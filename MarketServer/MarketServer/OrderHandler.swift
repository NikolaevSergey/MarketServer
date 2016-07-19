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
        
        static let requestType: RequestType = .GET
        
        func kr_handleRequest(queryObject: QueryType, request: WebRequest, response: WebResponse) throws {
            
            let token = try ENToken(token: queryObject.token)
            
            let user: ENUser!
            
            do {
                user = try ENUser(token: token)
            } catch let error as ENError {
                guard error == ENError.NotFound else {throw error}
                throw HTTPStatus._401
            }
            
            
            let orders = try ENOrder.OrdersForUser(user.id)
            let ordersSerialized = orders.map({$0.serialize()}) as [Any]
            
            try response.addJSONResponse(["orders" : ordersSerialized])
            response.setHTTPStatus(._200)
        }
    }

    struct UnitsQuery: KRQueryObject {
        let token: String
        
        init (query: [String : String], request: WebRequest) throws {
            guard let token = request.urlVariables["token"] else {throw HTTPStatus._401}
            self.token = token
        }
    }
    
}
