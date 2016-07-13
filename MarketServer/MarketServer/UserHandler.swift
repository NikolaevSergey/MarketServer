//
//  UserHandler.swift
//  PerfectBase
//
//  Created by Sergey Nikolaev on 16.06.16.
//  Copyright © 2016 Sergey Nikolaev. All rights reserved.
//

import PerfectLib

extension Handler.Users {
    
    class RegistrationHandler: KRHandlerProtocol {
        let requestType: RequestType = .POST
        
        var requiredFields: [String] {return ["first_name", "last_name", "email", "password"]}
        
        func validate(query: [String : AnyObject]) throws {
            
            guard let email = query["email"] as? String else {throw HTTPStatus._400}
            
            try PostgresOperation({ (connection) in
                let request = SQLBuilder.SELECT(["id"]).FROM(TBUser.Name).WHERE("email='\(email)'").build()
                let result = try connection.execute(request)
                guard result.numTuples() == 0 else {
                    throw APIErrorType.UserEmailExist
                }
            })
        }
        
        func kr_handleRequest(query: [String : String], request: WebRequest, response: WebResponse) throws {
            
            let jsonQuery: JSONType = {
                var dict: JSONType = [:]
                query.forEach({dict.updateValue($1, forKey: $0)})
                return dict
            }()
            
            
            let user = try ENUser(dict: jsonQuery)
            let token = try ENToken(user: user)
            
            try response.addJSONResponse(["token" : token.token])
            response.setHTTPStatus(._201)
        }
    }
    
    class AuthorizationHandler: KRHandlerProtocol {
        let requestType: RequestType = .GET
        
        var requiredFields: [String] {return ["email", "password"]}
        
        func kr_handleRequest(query: [String : String], request: WebRequest, response: WebResponse) throws {
            
            let user = try ENUser(email: query[ENUser.Key.email]!)
            
            guard user.password == query[ENUser.Key.password]! else {throw APIErrorType.UserWrongPassword}
            
            let token = try ENToken(user: user)
            
            try response.addJSONResponse(["token" : token.token])
            response.setHTTPStatus(._201)
        }
    }
    
}
