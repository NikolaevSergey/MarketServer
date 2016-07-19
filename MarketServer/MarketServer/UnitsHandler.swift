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
        
        typealias QueryType = UnitsQuery
        
        static let requestType: RequestType = .GET
        
        func kr_handleRequest(queryObject: QueryType, request: WebRequest, response: WebResponse) throws {
            
            guard let category = ENCategory(rawValue: queryObject.categoryID) else {throw HTTPStatus._404}
            
            let units = ENUnit.allCases.filter({$0.category == category}).sort({$0.0.name < $0.1.name}).map({$0.serialize()}) as [JSONValue]
            
            try response.addJSONResponse(["units" : units])
            response.setHTTPStatus(._200)
        }
    }
    
    struct UnitsQuery: KRQueryObject {
        let categoryID: Int
        
        init (query: [String : String], request: WebRequest) throws {
            guard let category = request.urlVariables["category_id"], categoryID = Int(category) else {throw HTTPStatus._400}
            self.categoryID = categoryID
        }
    }
    
}
