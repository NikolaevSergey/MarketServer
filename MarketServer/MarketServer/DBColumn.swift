//
//  DBColumnType.swift
//  MarketServer
//
//  Created by Sergey Nikolaev on 21.06.16.
//  Copyright © 2016 Sergey Nikolaev. All rights reserved.
//

import PostgreSQL

// MARK: - Column

struct DBColumn {
    let name        : String
    let type        : DBColumnType
    let settings    : [DBColumnSettings]
    let notNull     : Bool
    
    init (name: String, type: DBColumnType, settings: [DBColumnSettings], notNull: Bool = false) {
        self.name       = name
        self.type       = type
        self.settings   = settings
        self.notNull    = notNull
    }
    
    func generateCreatingQuery () -> String {
        var query = ""
        
        query += "\(self.name)"
        
        query += " \(self.type.rawValue)"
        
        self.settings.forEach({query += " \($0.rawValue)"})
        
        if self.notNull {
            query += " NOT NULL"
        }
        
        return query
    }
}

// MARK: - Types

enum DBColumnType: String {
    case SERIAL     = "SERIAL"
    case INT        = "INT"
    case REAL       = "REAL"
    case TEXT       = "TEXT"
    
    func getValue<T>(result: PostgreSQL.PGResult, row: Int, number: Int) -> T? {
        switch self {
        case .SERIAL    : return result.getFieldInt     (row, fieldIndex: number) as? T
        case .INT       : return result.getFieldInt     (row, fieldIndex: number) as? T
        case .REAL      : return result.getFieldDouble  (row, fieldIndex: number) as? T
        case .TEXT      : return result.getFieldString  (row, fieldIndex: number) as? T
        }
    }
}

// MARK: - Settings

enum DBColumnSettings: String {
    case PrimaryKey = "PRIMARY KEY"
}

//MARK: - Relation

struct DBRelation {
    let columnName  : String
    let type        : DBColumnType
    let rTableName  : String
    let rColumnName : String
    
    func generateCreatingQuery () -> String {
        return "\(self.columnName) \(self.type.rawValue) REFERENCES \(self.rTableName)(\(self.rColumnName))"
    }
}

// Generic DBColumn?
//protocol SQLType {
//    static var columnType: DBColumnType {get}
//}
//
//extension Int64: SQLType {
//    static var columnType: DBColumnType {return .SERIAL}
//}
//
//extension Int: SQLType {
//    static var columnType: DBColumnType {return .INT}
//}
//
//extension Double: SQLType {
//    static var columnType: DBColumnType {return .REAL}
//}
//
//extension String: SQLType {
//    static var columnType: DBColumnType {return .TEXT}
//}
