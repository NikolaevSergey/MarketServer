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
    Routing.Routes[RequestType.POST.rawValue, ["/users"]] = {(_: WebResponse) in return Handler.Users.RegistrationHandler()}
    Routing.Routes[RequestType.GET.rawValue, ["/auth"]] = {(_: WebResponse) in return Handler.Users.AuthorizationHandler()}
    
    Routing.Routes[RequestType.GET.rawValue, ["/categories"]] = {(_: WebResponse) in return Handler.Categories.AuthorizationHandler()}
    
    SetupPostgreSQLTables()
    
}

enum Handler {
    enum Users {}
    enum Categories {}
}
