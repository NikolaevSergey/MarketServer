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
        return self.reduce("", combine: {return $0.characters.count == 0 ? "\($1)" : "\($0), \($1)"})
    }
    
    func SQLStringUnionEscaped () -> String {
        return self.reduce("", combine: {return $0.characters.count == 0 ? "\($1.escaped)" : "\($0), \($1.escaped)"})
    }
}

protocol SQLRequestProtocol {
    func build () -> String
}

struct SQLBuilder {
    static func SELECT (columns: [String] = [])                 -> SQLSelect {return SQLSelect(columns: columns)}
    static func INSERT (table: String, data: [String : Any])    -> SQLInsert {return SQLInsert(table: table, data: data)}
    static func UPDATE (table: String, data: [String : Any])    -> SQLUpdate {return SQLUpdate(table: table, data: data)}
    static func DELETE (table: String)                          -> SQLDelete {return SQLDelete(table: table)}
}

//===

struct SQLInsert: SQLRequestProtocol {
    private let table   : String
    private let data : [String : Any]
    
    func RETURNING (columns: [String]) -> SQLReturning {return SQLReturning(parent: self, columns: columns)}
    
    func build() -> String {
        let enumaratedData = self.data.enumerate()
        
        let columns = enumaratedData.map({return $0.element.0})
        let values = enumaratedData.map({return "\($0.element.1)"})
        
        return "INSERT INTO \(self.table) (\(columns.SQLStringUnion())) VALUES (\(values.SQLStringUnionEscaped()))"
    }
}

struct SQLSelect: SQLRequestProtocol, SQLFromProtocol {
    private let columns: [String]
    
    func COUNT () -> SQLCount {
        return SQLCount(parent: self)
    }
    
    func build() -> String {
        guard self.columns.count != 0 else {
            return "SELECT *"
        }
        return "SELECT \(self.columns.SQLStringUnion())"
    }
    
    private func getColumns () -> String {
        guard self.columns.count != 0 else {
            return "*"
        }
        return self.columns.SQLStringUnion()
    }
}

struct SQLUpdate: SQLRequestProtocol {
    private let table   : String
    private let data : [String : Any]
    
    func WHERE (query: String) -> SQLWhere {
        return SQLWhere(parent: self, query: query)
    }
    
    func build() -> String {
        
        let setQuery = self.data.enumerate().map({return $1}).reduce("", combine: {
            let valueString = "\($1.1)".escaped
            let current = "\($1.0) = \(valueString)"
            return $0.characters.count == 0 ? current : "\($0), \(current)"
        })
        
        return "UPDATE \(self.table) SET (\(setQuery))"
    }
}

struct SQLDelete: SQLRequestProtocol {
    let table: String
    
    func WHERE (query: String) -> SQLWhere {
        return SQLWhere(parent: self, query: query)
    }
    
    func build() -> String {
        return "DELETE FROM \(self.table)"
    }
}

struct SQLReturning: SQLRequestProtocol {
    private let parent: SQLRequestProtocol
    private let columns: [String]
    
    func build() -> String {
        return "\(self.parent.build()) RETURNING (\(self.columns.SQLStringUnion()))"
    }
}

//===

struct SQLFrom: SQLRequestProtocol, SQLLimitProtocol, SQLOrderProtocol {
    private let parent: SQLRequestProtocol
    private let table: String
    
    func WHERE (query: String) -> SQLWhere {
        return SQLWhere(parent: self, query: query)
    }
    
    func build() -> String {
        return "\(self.parent.build()) FROM \(self.table)"
    }
}

struct SQLWhere: SQLRequestProtocol, SQLLimitProtocol, SQLOrderProtocol {
    private let parent: SQLRequestProtocol
    private let query: String
    
    func build() -> String {
        return "\(self.parent.build()) WHERE \(self.query)"
    }
}

struct SQLCount: SQLRequestProtocol, SQLFromProtocol {
    private let parent: SQLSelect
    
    func build() -> String {
        return "SELECT COUNT (\(self.parent.getColumns()))"
    }
}

struct SQLLimit: SQLRequestProtocol {
    private let parent: SQLRequestProtocol
    private let limit: Int
    
    func build() -> String {
        return "\(self.parent.build()) LIMIT \(self.limit)"
    }
}

struct SQLOrder: SQLRequestProtocol, SQLLimitProtocol {
    private let parent: SQLRequestProtocol
    private let column: String
    
    func build() -> String {
        return "\(self.parent.build()) ORDER BY \(column)"
    }
}

//=====

protocol SQLOrderProtocol: SQLRequestProtocol {}
extension SQLOrderProtocol {
    func ORDERBY (column: String) -> SQLOrder {return SQLOrder(parent: self, column: column)}
}

protocol SQLFromProtocol: SQLRequestProtocol {}
extension SQLFromProtocol {
    func FROM (table: String) -> SQLFrom {return SQLFrom(parent: self, table: table)}
}

protocol SQLLimitProtocol: SQLRequestProtocol {}
extension SQLLimitProtocol {
    func LIMIT (limit: Int) -> SQLLimit {return SQLLimit(parent: self, limit: limit)}
}
