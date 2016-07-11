//
//  PostgreSQLTable.swift
//  MarketServer
//
//  Created by Sergey Nikolaev on 21.06.16.
//  Copyright © 2016 Sergey Nikolaev. All rights reserved.
//

import PostgreSQL

protocol DBTable {
    static var name            : String {get}
    static var columns         : [DBColumn] {get}
    static var relationships   : [DBRelation] {get}
    
//    init (name: String, columns: [DBColumn] = [], relationships: [DBRelation] = []) {
//        self.name           = name
//        self.columns        = columns
//        self.relationships  = relationships
//    }
    
    
}

extension DBTable {
    
    func getColumn (name: String) -> DBColumn? {
        for column in self.dynamicType.columns {
            guard column.name == name else {continue}
            return column
        }
        return nil
    }
    
    func getRelation (name: String) -> DBRelation? {
        for relationship in self.dynamicType.relationships {
            guard relationship.columnName == name else {continue}
            return relationship
        }
        return nil
    }
    
    func generateCreatingQuery () -> String {
        
        var query = "CREATE TABLE IF NOT EXISTS"
        
        query += " \(self.dynamicType.name) "
        
        guard self.dynamicType.columns.count > 0 else {return query}
        
        query += "("
        
        self.dynamicType.columns.forEach({
            if query.characters.last != "(" {
                query += ", "
            }
            query += "\($0.generateCreatingQuery())"
            
        })
        
        self.dynamicType.relationships.forEach({
            if query.characters.last != "(" {
                query += ", "
            }
            query += "\($0.generateCreatingQuery())"
        })
        
        query += ")"
        
        return query
    }
    
    var allColumnsNames: [String] {
        let columnNames     = self.dynamicType.columns.map({$0.name})
        let relationNames   = self.dynamicType.relationships.map({$0.columnName})
        return columnNames + relationNames
    }
    
    func SelectAll (columns: [DBColumn] = [], relations: [DBRelation] = []) -> PostgreSQL.PGResult? {
        
        do {
            let database = try PSConnection()
            defer {database.connection.close()}
            
            let names = self.allColumnsNames
            
            let columnsQuery = names.count == 0 ? "*" : names.reduce("", combine: {
                return $0.0.characters.count == 0 ? $0.1 : "\($0.0), \($0.1)"
            })
            
            return try database.connection.execute("SELECT \(columnsQuery) FROM \(self.dynamicType.name)")
        } catch {}
        
        return nil
    }
    
}
