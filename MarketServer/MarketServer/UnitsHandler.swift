//
//  UnitsHandler.swift
//  MarketServer
//
//  Created by Sergey Nikolaev on 13.07.16.
//  Copyright © 2016 Sergey Nikolaev. All rights reserved.
//

import Foundation
import PerfectLib

extension Handler.Unit {
    
    class UnitsHandler: KRHandlerProtocol {
        let requestType: RequestType = .GET
        
        func kr_handleRequest(query: [String : String], request: WebRequest, response: WebResponse) throws {
            
            guard let categoryName = request.urlVariables["category_id"], categoryID = Int(categoryName) else {throw HTTPStatus._400}
            guard let category = ENCategory(rawValue: categoryID) else {throw HTTPStatus._404}
            
            let units = ENUnit.allCases.filter({$0.category == category}).sort({$0.0.name < $0.1.name}).map({$0.serialize()}) as [JSONValue]
            
            try response.addJSONResponse(["units" : units])
            response.setHTTPStatus(._200)
        }
    }
    
}
