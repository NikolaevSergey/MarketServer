//
//  Database.swift
//  PerfectBase
//
//  Created by Sergey Nikolaev on 15.06.16.
//  Copyright © 2016 Sergey Nikolaev. All rights reserved.
//

import PerfectLib

func SetupDatabase() throws {
    
    try SQLiteOperation { (sqlite) in
        try sqlite.execute("CREATE TABLE IF NOT EXISTS user (id INTEGER AUTO_INCREMENT PRIMARY KEY, first_name TEXT, last_name TEXT)")
    }
    
}

func SQLiteOperation (block: ((sqlite: SQLite) throws -> Void)) throws {
    
    var sqlite: SQLite?
    
    do {
        sqlite = try SQLite(DB_PATH)
        try block(sqlite: sqlite!)
        sqlite?.close()
    } catch let error {
        
        guard let lSqlite = sqlite else {
            NSLog("SQLite error: Failure creating database at \(DB_PATH)")
            throw error
        }
        
        let code        = lSqlite.errCode()
        let message     = lSqlite.errMsg()
        
        sqlite?.close()
        
        NSLog("SQLite error\nCode: \(code)\nMessage: \(message)\n")
        
        throw SQLiteError(code: code, message: message)
    }
}

struct SQLiteError: ErrorType {
    
    static var Domain: String {return "com.perfect_base.sqlite"}
    
    let _domain: String = SQLiteError.Domain
    let _code: Int
    let message: String
    
    init(code: Int, message: String) {
        self._code = code
        self.message = message
    }
}
