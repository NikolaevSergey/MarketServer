//
//  ENUnit.swift
//  MarketServer
//
//  Created by Sergey Nikolaev on 11.07.16.
//  Copyright © 2016 Sergey Nikolaev. All rights reserved.
//

import Foundation

class ENUnit {
    let id: Int
    var name: String
    var price: Double
    var categoryID: Int
    
    init (name: String, price: Double, categoryID: Int) throws {
        var id: Int!
        
        try PostgresOperation { (connection) in
            let request = SQLBuilder.INSERT(TBUnit.Name, data: [
                Key.Name : name,
                Key.Price : price,
                Key.CategoryID : categoryID
                ]).RETURNING([Key.ID])
            let result = try connection.execute(request)
            
            id = result.getFieldInt(0, fieldIndex: 0)
        }
        
        self.id = id
        self.name = name
        self.price = price
        self.categoryID = categoryID
    }
    
    init (id: Int) throws {
        
        var name: String!
        var price: Double!
        var categoryID: Int!
        
        try PostgresOperation({ (connection) in
            let request = SQLBuilder.SELECT([
                Key.Name,
                Key.Price,
                Key.CategoryID
                ]).FROM(TBUnit.Name).WHERE("\(ENUnit.Key.ID)=\(id)").LIMIT(1)
            let result = try connection.execute(request)
            
            name        = result.getFieldString(0, fieldIndex: 0)
            price       = result.getFieldDouble(0, fieldIndex: 1)
            categoryID  = result.getFieldInt(0, fieldIndex: 2)
        })
        
        self.id = id
        self.name = name
        self.price = price
        self.categoryID = categoryID
    }
}

extension ENUnit {
    enum Key {
        static let ID           = "id"
        static let Name         = "name"
        static let Price        = "price"
        
        static let CategoryID   = "category_id"
    }
}
