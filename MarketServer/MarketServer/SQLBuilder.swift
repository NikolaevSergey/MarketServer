//
//  SQLBuilder.swift
//  MarketServer
//
//  Created by Sergey Nikolaev on 11.07.16.
//  Copyright © 2016 Sergey Nikolaev. All rights reserved.
//

import Foundation

private extension _ArrayType where Generator.Element == String {
    func SQLStringUnion () -> String {
        return self.reduce("", combine: {return $0.characters.count == 0 ? $1 : "\($0), \($1)"})
    }
}

protocol SQLParent {
    func build () -> String
}

struct SQLBuilder {
    static func SELECT (columns: [String] = [])                 -> SQLSelect {return SQLSelect(columns: columns)}
    static func INSERT (table: String, data: [String : Any])    -> SQLInsert {return SQLInsert(table: table, data: data)}
    static func UPDATE (table: String, data: [String : Any])    -> SQLUpdate {return SQLUpdate(table: table, data: data)}
    static func DELETE (table: String)                          -> SQLDelete {return SQLDelete(table: table)}
}

//===

struct SQLInsert: SQLParent {
    let table   : String
    let data : [String : Any]
    
    func RETURNING (columns: [String]) -> SQLReturning {return SQLReturning(parent: self, columns: columns)}
    
    func build() -> String {
        let enumaratedData = self.data.enumerate()
        
        let columns = enumaratedData.map({return $0.element.0})
        let values = enumaratedData.map({return "\($0.element.1)"})
        
        return "INSERT INTO \(self.table) (\(columns.SQLStringUnion())) VALUES (\(values.SQLStringUnion()))"
    }
}

struct SQLSelect: SQLParent {
    private let columns: [String]
    
    func FROM (table: String) -> SQLFrom {
        return SQLFrom(parent: self, table: table)
    }
    
    func build() -> String {
        guard self.columns.count != 0 else {
            return "SELECT *"
        }
        return "SELECT (\(self.columns.SQLStringUnion()))"
    }
}

struct SQLUpdate: SQLParent {
    private let table   : String
    private let data : [String : Any]
    
    func WHERE (query: String) -> SQLWhere {
        return SQLWhere(parent: self, query: query)
    }
    
    func build() -> String {
        
        let setQuery = self.data.enumerate().map({return $1}).reduce("", combine: {
            let current = "\($1.0) = \($1.1)"
            return $0.characters.count == 0 ? current : "\($0), \(current)"
        })
        
        return "UPDATE \(self.table) SET (\(setQuery))"
    }
}

struct SQLDelete: SQLParent {
    let table: String
    
    func WHERE (query: String) -> SQLWhere {
        return SQLWhere(parent: self, query: query)
    }
    
    func build() -> String {
        return "DELETE FROM \(self.table)"
    }
}

struct SQLReturning {
    private let parent: SQLParent
    private let columns: [String]
    
    func build() -> String {
        return "\(self.parent.build()) RETURNING (\(self.columns.SQLStringUnion()))"
    }
}

//===

struct SQLFrom: SQLParent {
    private let parent: SQLParent
    private let table: String
    
    func WHERE (query: String) -> SQLWhere {
        return SQLWhere(parent: self, query: query)
    }
    
    func build() -> String {
        return "\(self.parent.build()) FROM \(self.table)"
    }
}

struct SQLWhere: SQLParent {
    private let parent: SQLParent
    private let query: String
    
    func build() -> String {
        return "\(self.parent.build()) WHERE \(self.query)"
    }
}
