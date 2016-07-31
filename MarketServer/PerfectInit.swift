//
//  PerfectInit.swift
//  PerfectBase
//
//  Created by Sergey Nikolaev on 16.06.16.
//  Copyright © 2016 Sergey Nikolaev. All rights reserved.
//

import PerfectLib

public func PerfectServerModuleInit() {
    
    Settings.SetupLogger()
    
    Routing.Handler.registerGlobally()
    
    SetupRoutes()
    
    SetupPostgreSQLTables()
    
}
