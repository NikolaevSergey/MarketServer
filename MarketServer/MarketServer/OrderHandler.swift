//
//  OrderHandler.swift
//  MarketServer
//
//  Created by Sergey Nikolaev on 14.07.16.
//  Copyright © 2016 Sergey Nikolaev. All rights reserved.
//

import Foundation
import PerfectLib

extension Handler.Order {
    
    class OrdersHandler: KRHandlerProtocol {
        typealias QueryType = UnitsQuery
        let requestType: RequestType = .GET
        
        func kr_handleRequest(queryObject: QueryType, request: WebRequest, response: WebResponse) throws {
            
            let token = try ENToken(token: queryObject.token)
            
            
            guard let categoryName = request.urlVariables["category_id"], categoryID = Int(categoryName) else {throw HTTPStatus._400}
            guard let category = ENCategory(rawValue: categoryID) else {throw HTTPStatus._404}
            
            let units = ENUnit.allCases.filter({$0.category == category}).sort({$0.0.name < $0.1.name}).map({$0.serialize()}) as [JSONValue]
            
            try response.addJSONResponse(["units" : units])
            response.setHTTPStatus(._200)
        }
    }

    struct UnitsQuery: KRQueryObject {
        let token: String
        
        init (query: [String : String], request: WebRequest) throws {
            guard let token = request.urlVariables["token"] else {throw HTTPStatus._400}
            self.token = token
        }
    }
    
}
