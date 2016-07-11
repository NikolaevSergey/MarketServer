//
//  ENToken.swift
//  MarketServer
//
//  Created by Sergey Nikolaev on 09.07.16.
//  Copyright © 2016 Sergey Nikolaev. All rights reserved.
//

import Foundation

class ENToken {
    let token: String
    let date: NSDate
    let userID: Int
    
    init (userID: Int) throws {
        
        let token = NSUUID().UUIDString
        let date = NSDate()
        
//        try PostgresOperation({ (connection) in
//            
//            let result = try connection.execute("INSERT INTO \(TBToken.name) \(Key.Token), \(Key.Date), \(Key.UserID)")
//            
//            firstName   = result.getFieldString(0, fieldIndex: 0)
//            lastName    = result.getFieldString(0, fieldIndex: 1)
//            password    = result.getFieldString(0, fieldIndex: 2)
//            email       = result.getFieldString(0, fieldIndex: 3)
//            phone       = result.getFieldString(0, fieldIndex: 4)
//            
//            
//        })
        
        self.token = token
        self.date = date
        self.userID = userID
    }
    
    convenience init (user: ENUser) throws {
        try self.init(userID: user.id)
    }
}

extension ENToken {
    enum Key {
        static let Token = "token"
        static let Date = "timestamp"
        static let UserID = "user_id"
    }
}

extension ENToken {
    enum Error {
        case Unknown
    }
}
