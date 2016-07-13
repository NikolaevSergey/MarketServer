//
//  CategoriesHandler.swift
//  MarketServer
//
//  Created by Sergey Nikolaev on 11.07.16.
//  Copyright © 2016 Sergey Nikolaev. All rights reserved.
//

import Foundation
import PerfectLib

extension Handler.Categories {
    
    class AuthorizationHandler: KRHandlerProtocol {
        let requestType: RequestType = .GET
        
        func kr_handleRequest(query: [String : String], request: WebRequest, response: WebResponse) throws {
            
            let categories = ENCategory.allCases.map({$0.serialize()}) as [JSONValue]
            
            try response.addJSONResponse(["categories" : categories])
            response.setHTTPStatus(._200)
        }
    }
    
}
