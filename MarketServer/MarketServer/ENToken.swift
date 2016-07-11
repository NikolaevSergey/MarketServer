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
            let request = SQLBuilder.INSERT(TBToken.name, data: [
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
}

extension ENToken {
    enum Key {
        static let ID = "id"
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
