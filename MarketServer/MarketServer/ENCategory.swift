//
//  ENCategory.swift
//  MarketServer
//
//  Created by Sergey Nikolaev on 11.07.16.
//  Copyright © 2016 Sergey Nikolaev. All rights reserved.
//

import Foundation

class ENCategory {
    let id: Int
    let name: String
    
    init (name: String) throws {
        var id: Int!
        
        try PostgresOperation { (connection) in
            let request = SQLBuilder.INSERT(TBCategory.Name, data: [Key.Name : name]).RETURNING([Key.ID])
            let result = try connection.execute(request)
            
            id = result.getFieldInt(0, fieldIndex: 0)
        }
        
        self.id = id
        self.name = name
    }
    
    init (id: Int) throws {
        var name: String!
        
        try PostgresOperation({ (connection) in
            let request = SQLBuilder.SELECT([Key.Name]).FROM(TBCategory.Name).WHERE("\(Key.ID)=\(id)").LIMIT(1)
            let result = try connection.execute(request)
            
            name = result.getFieldString(0, fieldIndex: 0)
        })
        
        self.id = id
        self.name = name
    }
}

extension ENCategory {
    enum Key {
        static let ID       = "id"
        static let Name     = "name"
    }
}
