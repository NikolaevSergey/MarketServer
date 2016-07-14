//
//  ENBusket.swift
//  MarketServer
//
//  Created by Sergey Nikolaev on 13.07.16.
//  Copyright © 2016 Sergey Nikolaev. All rights reserved.
//

import Foundation

class ENOrder {
    
    let id: Int
    let userID: Int
    let date: NSDate
    
    private(set) var comment: String?
    private(set) var units: [ENUnit]
    
    var total: Double {return self.units.map({return $0.price}).reduce(0 as Double, combine: {$0 + $1})}
    
    class func OrdersForUser (id: Int) throws -> [ENOrder] {
        var orders: [ENOrder] = []
        
        try PostgresOperation { (connection) in
            let request = SQLBuilder.SELECT([Key.ID, Key.UserID, Key.Date, Key.Comment, Key.Units]).FROM(TBOrder.Name).ORDERBY(Key.Date)
            
        }
        
        return orders
    }
    
    init (userID: Int, comment: String? = nil, units: [ENUnit] = []) throws {
        
        var id: Int!
        
        let date = NSDate()
        
        try PostgresOperation({ (connection) in
            
            var data: [String : Any] = [
                Key.UserID  : userID,
                Key.Date    : date.timestamp
            ]
            data.fs_updateIfExist(comment, forKey: Key.Comment)
            
            let request = SQLBuilder.INSERT(TBOrder.Name, data: data).RETURNING([Key.ID]).build()
            let result = try connection.execute(request)
            id = result.getFieldInt(0, fieldIndex: 0)
            
            try ENOrder.SetUnits(id, units: units)
        })
        
        self.id         = id
        self.date       = date
        self.comment    = comment
        self.userID     = userID
        self.units      = units
    }
    
    func addUnits (units: [ENUnit]) throws {
        try ENOrder.SetUnits(self.id, units: units)
    }
    
    func removeUnits (units: [ENUnit]) throws {
        try PostgresOperation({ (connection) in
            for unit in units {
                let request = SQLBuilder.DELETE(TBROrderUnit.Name).WHERE("busket_id=\(self.id) AND unit_id=\(unit.id)")
                try connection.execute(request)
            }
        })
    }
    
    func delete () throws {
        try PostgresOperation({ (connection) in
            let unitRelationrequest = SQLBuilder.DELETE(TBROrderUnit.Name).WHERE("busket_id=\(self.id)")
            try connection.execute(unitRelationrequest)
            
            let removeRequest = SQLBuilder.DELETE(TBOrder.Name).WHERE("id=\(self.id)")
            try connection.execute(removeRequest)
        })
    }
}

extension ENOrder {
    enum Key {
        static let ID       = "id"
        static let Date     = "timestamp"
        static let UserID   = "user_id"
        static let Comment  = "comment"
        static let Units    = "units"
        static let Total    = "total"
    }
}

extension ENOrder: KRSerializable {
    func serialize() -> JSONType {
        
        var data: JSONType = [
            Key.ID      : self.id,
            Key.Date    : self.date.timestamp,
            Key.UserID  : self.userID,
            Key.Total   : self.total,
            Key.Units   : self.units.map({$0.serialize()}) as [Any]
        ]
        
        data.fs_updateIfExist(self.comment, forKey: Key.Comment)
        
        return data
    }
}

extension ENOrder {
    
    private class func SetUnits (id: Int, units: [ENUnit]) throws {
        
        let table = TBROrderUnit.self
        
        do {
            try PostgresOperation({ (connection) in
                for unit in units {
                    let checkRequest = SQLBuilder.SELECT().COUNT().FROM(table.Name)
                        .WHERE("busket_id=\(id) AND unit_id=\(unit.id)")
                    let insertRequest = SQLBuilder.INSERT(table.Name, data: ["busket_id" : id, "unit_id" : unit.id])
                    
                    let checkResult = try connection.execute(checkRequest)
                    guard checkResult.numTuples() == 0 else {continue}
                    try connection.execute(insertRequest)
                }
            })
        } catch let error {
            Logger.error("TBRBusketUnit insert was failed: \(error)")
            throw error
        }
        
    }
}
