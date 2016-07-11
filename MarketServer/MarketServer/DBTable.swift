//
//  PostgreSQLTable.swift
//  MarketServer
//
//  Created by Sergey Nikolaev on 21.06.16.
//  Copyright © 2016 Sergey Nikolaev. All rights reserved.
//

import PostgreSQL

protocol DBTable {
    static var Name            : String {get}
    static var Columns         : [DBColumn] {get}
    static var Relationships   : [DBRelation] {get}
}

extension DBTable {
    
    static func getColumn (name: String) -> DBColumn? {
        for column in Columns {
            guard column.name == name else {continue}
            return column
        }
        return nil
    }
    
    static  func getRelation (name: String) -> DBRelation? {
        for relationship in Relationships {
            guard relationship.columnName == name else {continue}
            return relationship
        }
        return nil
    }
    
    static func generateCreatingQuery () -> String {
        
        var query = "CREATE TABLE IF NOT EXISTS"
        
        query += " \(Name) "
        
        guard Columns.count > 0 else {return query}
        
        query += "("
        
        Columns.forEach({
            if query.characters.last != "(" {
                query += ", "
            }
            query += "\($0.generateCreatingQuery())"
            
        })
        
        Relationships.forEach({
            if query.characters.last != "(" {
                query += ", "
            }
            query += "\($0.generateCreatingQuery())"
        })
        
        query += ")"
        
        return query
    }
    
    static var allColumnsNames: [String] {
        let columnNames     = Columns.map({$0.name})
        let relationNames   = Relationships.map({$0.columnName})
        return columnNames + relationNames
    }
    
    static func SelectAll (columns: [DBColumn] = [], relations: [DBRelation] = []) -> PostgreSQL.PGResult? {
        
        do {
            let database = try PSConnection()
            defer {database.connection.close()}
            
            let names = allColumnsNames
            
            let columnsQuery = names.count == 0 ? "*" : names.reduce("", combine: {
                return $0.0.characters.count == 0 ? $0.1 : "\($0.0), \($0.1)"
            })
            
            return try database.connection.execute("SELECT \(columnsQuery) FROM \(Name)")
        } catch {}
        
        return nil
    }
    
}
