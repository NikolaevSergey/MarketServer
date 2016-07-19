//
//  HelloHandler.swift
//  PerfectBase
//
//  Created by Sergey Nikolaev on 15.06.16.
//  Copyright © 2016 Sergey Nikolaev. All rights reserved.
//

import PerfectLib

func SetupRoutes () {
    RegisterRoute(.POST,    routes: ["/users"],                     handler: Handler.Users.RegistrationHandler())
    RegisterRoute(.GET,     routes: ["/auth"],                      handler: Handler.Users.AuthorizationHandler())
    
    RegisterRoute(.GET,     routes: ["/categories"],                handler: Handler.Categories.CategoriesHandler())
    
    RegisterRoute(.GET,     routes: ["/categories/{category_id}"],  handler: Handler.Unit.UnitsHandler())
    
    RegisterRoute(.GET,     routes: ["/orders"],                    handler: Handler.Order.OrdersHandler())
}

enum Handler {
    enum Users {}
    enum Categories {}
    enum Unit {}
    enum Order {}
}

private func RegisterRoute (type: RequestType, routes: [String], handler: RequestHandler) {
    Routing.Routes[type.rawValue, routes] = {(_: WebResponse) in return handler}
}
