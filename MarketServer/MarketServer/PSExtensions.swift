//
//  PSExtensions.swift
//  MarketServer
//
//  Created by Sergey Nikolaev on 21.06.16.
//  Copyright © 2016 Sergey Nikolaev. All rights reserved.
//

import PostgreSQL

extension PGConnection {
    
    func execute(statement: String) throws -> PostgreSQL.PGResult {
        
        let queryResult = self.exec(statement)
        
        guard queryResult.status() == .CommandOK || queryResult.status() == .TuplesOK else {
            throw PGConnectionError.QueryError
        }
        
        return queryResult
    }
    
    func execute(statement: String, params: [String]) throws -> PostgreSQL.PGResult {
        let queryResult = self.exec(statement, params: params)
        
        guard queryResult.status() == .CommandOK || queryResult.status() == .TuplesOK else {
            throw PGConnectionError.QueryError
        }
        
        return queryResult
    }
    
}

enum PGConnectionError: ErrorType {
    case QueryError
    case ReturnedNothing
    case ReturnedEmpty
}
