//
//  PSConnection.swift
//  MarketServer
//
//  Created by Sergey Nikolaev on 21.06.16.
//  Copyright © 2016 Sergey Nikolaev. All rights reserved.
//

import PostgreSQL

class PSConnection {
    
    let connection: PGConnection
    
    deinit {
        self.connection.close()
    }
    
    init (settings: PSSettings = PSSettings.defaultSettings) throws {
        self.connection = PostgreSQL.PGConnection()
        self.connection.connectdb(settings.getConnectString())
        
        guard self.connection.status() != .Bad else {
            throw PostgresDBError.ConnectionFailed
        }
    }
}

enum PostgresDBError: ErrorType {
    case ConnectionFailed
}


