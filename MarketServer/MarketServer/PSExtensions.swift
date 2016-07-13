//
//  PSExtensions.swift
//  MarketServer
//
//  Created by Sergey Nikolaev on 21.06.16.
//  Copyright © 2016 Sergey Nikolaev. All rights reserved.
//

import PostgreSQL

extension PGConnection {
    
    func executeUniqRequest (request: SQLRequestProtocol) throws -> Bool {
        let result = try self.execute(request)
        let count = result.getFieldInt(0, fieldIndex: 0)
        return count == 0
    }
    
    func execute(statement: String) throws -> PostgreSQL.PGResult {
        
        Logger.info(statement)
        
        let queryResult = self.exec(statement)
        
        if queryResult.errorMessage().characters.count > 0 {
            Logger.error("Error: \(queryResult.errorMessage())")
        }
        
        guard queryResult.status() == .CommandOK || queryResult.status() == .TuplesOK else {
            throw PGConnectionError.QueryError
        }
        
        return queryResult
    }
    
    func execute(request: SQLRequestProtocol) throws -> PostgreSQL.PGResult {
        return try self.execute(request.build())
    }
    
}

enum PGConnectionError: ErrorType {
    case QueryError
    case ReturnedNothing
    case ReturnedEmpty
}
