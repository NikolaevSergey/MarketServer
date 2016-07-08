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
    
    init (host: String = "localhost", dbname: String, user: String = "", password: String = "") {
        self.host = host
        self.dbname = dbname
        self.user = user
        self.password = password
    }
    
    func getConnectString () -> String {
        return "host='\(self.host)' dbname='\(self.dbname)' user='\(self.user)' password='\(self.password)'"
    }
}
