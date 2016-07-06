//
//  PSSettings.swift
//  MarketServer
//
//  Created by Sergey Nikolaev on 21.06.16.
//  Copyright © 2016 Sergey Nikolaev. All rights reserved.
//

import PostgreSQL

struct PSSettings {
    let host        : String
    let dbname      : String
    let user        : String
    let password    : String
    
    static var defaultSettings: PSSettings {
        return PSSettings(
            host        : "localhost",
            dbname      : "chasha",
            user        : "",
            password    : ""
        )
    }
    
    func getConnectString () -> String {
        return "host='\(self.host)' dbname='\(self.dbname)' user='\(self.user)' password='\(self.password)'"
    }
}
