//
//  ENBusket.swift
//  MarketServer
//
//  Created by Sergey Nikolaev on 13.07.16.
//  Copyright © 2016 Sergey Nikolaev. All rights reserved.
//

import Foundation

class ENBusket {
    
    let id: Int
    let userID: Int
    let date: NSDate
    
    private(set) var comment: String?
    private(set) var units: [ENUnit]
    
    init (userID: Int, comment: String? = nil, units: [ENUnit] = []) throws {
        
        var id: Int!
        
        let date = NSDate()
        
        try PostgresOperation({ (connection) in
            
            var data: [String : Any] = [
                Key.UserID  : userID,
                Key.Date    : date.timestamp
            ]
            data.fs_updateIfExist(comment, forKey: Key.Comment)
            
            let request = SQLBuilder.INSERT(TBBusket.Name, data: data).RETURNING([Key.ID]).build()
            let result = try connection.execute(request)
            id = result.getFieldInt(0, fieldIndex: 0)
            
            try ENBusket.SetUnits(id, units: units)
        })
        
        self.id         = id
        self.date       = date
        self.comment    = comment
        self.userID     = userID
        self.units      = units
    }
    
    func addUnits (units: [ENUnit]) throws {
        try ENBusket.SetUnits(self.id, units: units)
    }
    
    func removeUnits (units: [ENUnit]) throws {
        try PostgresOperation({ (connection) in
            for unit in units {
                let request = SQLBuilder.DELETE(TBRBusketUnit.Name).WHERE("busket_id=\(self.id) AND unit_id=\(unit.id)")
                try connection.execute(request)
            }
        })
    }
    
    func delete () throws {
        try PostgresOperation({ (connection) in
            let unitRelationrequest = SQLBuilder.DELETE(TBRBusketUnit.Name).WHERE("busket_id=\(self.id)")
            try connection.execute(unitRelationrequest)
            
            let removeRequest = SQLBuilder.DELETE(TBBusket.Name).WHERE("id=\(self.id)")
            try connection.execute(removeRequest)
        })
    }
}

extension ENBusket {
    enum Key {
        static let ID       = "id"
        static let Date     = "timestamp"
        static let UserID   = "user_id"
        static let Comment  = "comment"
        static let Units    = "units"
    }
}

extension ENBusket: KRSerializable {
    func serialize() -> JSONType {
        
        var data: JSONType = [
            Key.ID      : self.id,
            Key.Date    : self.date.timestamp,
            Key.UserID  : self.userID,
            Key.Units   : self.units.map({$0.serialize()}) as [Any]
        ]
        
        data.fs_updateIfExist(self.comment, forKey: Key.Comment)
        
        return data
    }
}

extension ENBusket {
    
    private class func SetUnits (id: Int, units: [ENUnit]) throws {
        
        let table = TBRBusketUnit.self
        
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
