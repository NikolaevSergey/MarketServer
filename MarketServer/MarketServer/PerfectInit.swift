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
    
    // MARK: Users
    Routing.Routes["POST", ["/users"]] = {(_: WebResponse) in return Users.RegistrationHandler()}
//    Routing.Routes["GET", ["/snapshot"]]   = {(_:WebResponse) in return JSONHandler()}
    
    SetupPostgreSQLTables()
    
}
