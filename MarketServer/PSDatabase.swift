//
//  PostgreSQLDatabase.swift
//  PerfectBase
//
//  Created by Sergey Nikolaev on 19.06.16.
//  Copyright © 2016 Sergey Nikolaev. All rights reserved.
//

import PostgreSQL

func PostgresOperation (block: ((connection: PGConnection) throws -> Void)) throws {
    let database = try PSConnection()
    defer {database.connection.close()}
    try block(connection: database.connection)
}
