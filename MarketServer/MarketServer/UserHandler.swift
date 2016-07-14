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
        typealias QueryType             = UserRegistrationQuery
        let requestType: RequestType    = .POST
        
        func kr_handleRequest(queryObject: QueryType, request: WebRequest, response: WebResponse) throws {
            
            let user = try ENUser(userQuery: queryObject)
            let token = try ENToken(user: user)
            
            try response.addJSONResponse(["token" : token.token])
            response.setHTTPStatus(._201)
        }
    }
    
    class AuthorizationHandler: KRHandlerProtocol {
        typealias QueryType             = UserAuthQuery
        let requestType: RequestType    = .GET
        
        func kr_handleRequest(queryObject: QueryType, request: WebRequest, response: WebResponse) throws {
            
            let user = try ENUser(email: queryObject.email)
            
            guard user.password == queryObject.password else {throw APIErrorType.UserWrongPassword}
            
            let token = try ENToken(user: user)
            
            var responseDict = user.serialize()
            responseDict.updateValue(token.token, forKey: "token")
            
            try response.addJSONResponse(["token" : responseDict])
            response.setHTTPStatus(._201)
        }
    }
    
}

extension Handler.Users {
    struct UserRegistrationQuery: KRQueryObject {
        let firstName   : String
        let lastName    : String
        let email       : String
        let password    : String
        
        init (query: [String : String], request: WebRequest) throws {
            guard let firstName     = query["first_name"]   else {throw HTTPStatus._400}
            guard let lastName      = query["last_name"]    else {throw HTTPStatus._400}
            guard let email         = query["email"]        else {throw HTTPStatus._400}
            guard let password      = query["password"]     else {throw HTTPStatus._400}
            
            try PostgresOperation({ (connection) in
                let request = SQLBuilder.SELECT([ENUser.Key.id]).FROM(TBUser.Name).WHERE("\(ENUser.Key.email)=\(email.escaped)").LIMIT(1)
                let result = try connection.execute(request)
                guard result.numTuples() == 0 else {
                    throw APIErrorType.UserEmailExist
                }
            })
            
            self.firstName  = firstName
            self.lastName   = lastName
            self.email      = email
            self.password   = password
        }
    }
    
    struct UserAuthQuery: KRQueryObject {
        let email       : String
        let password    : String
        
        init (query: [String : String], request: WebRequest) throws {
            guard let email         = query["email"]        else {throw HTTPStatus._400}
            guard let password      = query["password"]     else {throw HTTPStatus._400}
            
            self.email      = email
            self.password   = password
        }
    }
}

private extension ENUser {
    convenience init (userQuery: Handler.Users.UserRegistrationQuery) throws {
        try self.init(firstName: userQuery.firstName, lastName: userQuery.lastName, email: userQuery.email, password: userQuery.password)
    }
}
