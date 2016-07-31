//
//  ENToken.swift
//  MarketServer
//
//  Created by Sergey Nikolaev on 09.07.16.
//  Copyright © 2016 Sergey Nikolaev. All rights reserved.
//

import Foundation

class ENToken {
    let id: Int
    let token: String
    let date: NSDate
    let userID: Int
    
    init (userID: Int) throws {
        
        let token = NSUUID().UUIDString
        let date = NSDate()
        
        let timestamp = Int(date.timeIntervalSince1970)
        
        var id: Int!
        
        try PostgresOperation({ (connection) in
            let request = SQLBuilder.INSERT(TBToken.Name, data: [
                Key.Token   : token,
                Key.Date    : timestamp,
                Key.UserID  : userID
                ]).RETURNING([Key.ID]).build()
            
            let result = try connection.execute(request)
            id = result.getFieldInt(0, fieldIndex: 0)
        })
        
        self.token = token
        self.date = date
        self.userID = userID
        self.id = id
    }
    
    convenience init (user: ENUser) throws {
        try self.init(userID: user.id)
    }
    
    init (token: String) throws {
        
        var id      : Int!
        var date    : NSDate!
        var userID  : Int!
        
        try PostgresOperation({ (connection) in
            let request = SQLBuilder.SELECT([Key.ID, Key.Date, Key.UserID]).FROM(TBToken.Name).WHERE("\(Key.Token)=\(token.escaped)").LIMIT(1)
            let result = try connection.execute(request)
            
            guard result.numTuples() > 0 else {throw ENError.NotFound}
            
            id      = result.getFieldInt(0, fieldIndex: 0)
            date    = NSDate(timeIntervalSince1970: NSTimeInterval(result.getFieldInt(0, fieldIndex: 1)))
            userID  = result.getFieldInt(0, fieldIndex: 2)
        })
        
        self.id         = id
        self.token      = token
        self.date       = date
        self.userID     = userID
    }
}

extension ENToken {
    enum Key {
        static let ID = "id"
        static let Token = "token"
        static let Date = "timestamp"
        static let UserID = "user_id"
    }
}
