//
//  HelloHandler.swift
//  PerfectBase
//
//  Created by Sergey Nikolaev on 15.06.16.
//  Copyright © 2016 Sergey Nikolaev. All rights reserved.
//

import PerfectLib

func SetupRoutes () {
    // MARK: Users
    Routing.Routes[RequestType.POST.rawValue, ["/users"]] = {(_: WebResponse) in return Handler.Users.RegistrationHandler()}
    Routing.Routes[RequestType.GET.rawValue, ["/auth"]] = {(_: WebResponse) in return Handler.Users.AuthorizationHandler()}
    
    Routing.Routes[RequestType.GET.rawValue, ["/categories"]] = {(_: WebResponse) in return Handler.Categories.CategoriesHandler()}
    Routing.Routes[RequestType.GET.rawValue, ["/categories/{category_id}"]] = {(_: WebResponse) in return Handler.Unit.UnitsHandler()}
    
    Routing.Routes[RequestType.GET.rawValue, ["/orders"]] = {(_: WebResponse) in return Handler.Order.OrdersHandler()}
}

enum Handler {
    enum Users {}
    enum Categories {}
    enum Unit {}
    enum Order {}
}

//class IndexPageHandler: PageHandler {
//    
//    func valuesForResponse(context: MustacheEvaluationContext,
//                           collector: MustacheEvaluationOutputCollector) throws -> MustacheEvaluationContext.MapType {
//        
//        var values = MustacheEvaluationContext.MapType()
//        
//        values["title"]     = "Perfect Base"
//        values["name"]      = "Flatstack"
//        
//        return values
//    }
//}
//
//class IndexHandler: RequestHandler {
//    
//    func handleRequest(request: WebRequest, response: WebResponse) {
//        
//        response.appendBodyString("Perfect Base")
//        
//        if let word = request.urlVariables["word"] {
//            response.appendBodyString("\nYour word is \(word)")
//        }
//        response.requestCompletedCallback()
//    }
//    
//}


