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
    Routing.Routes[RequestType.POST.rawValue, ["/users"]] = {(_: WebResponse) in return Users.RegistrationHandler()}
    Routing.Routes[RequestType.GET.rawValue, ["/auth"]] = {(_: WebResponse) in return Users.AuthorizationHandler()}
//    Routing.Routes["GET", ["/snapshot"]]   = {(_:WebResponse) in return JSONHandler()}
    
    SetupPostgreSQLTables()
    
}
