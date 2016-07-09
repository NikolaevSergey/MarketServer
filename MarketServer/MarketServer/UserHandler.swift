//
//  UserHandler.swift
//  PerfectBase
//
//  Created by Sergey Nikolaev on 16.06.16.
//  Copyright © 2016 Sergey Nikolaev. All rights reserved.
//

import PerfectLib

enum Users {
    
    class RegistrationHandler: KRHandlerProtocol {
        let requestType         : RequestType           = .GET
        let responseContentType : ResponseContentType   = .JSON
        
        var requiredFields: [String] {return ["first_name", "last_name", "email", "password"]}
        
        func validate(query: [String : AnyObject]) throws {
            
            guard let email = query["email"] as? String else {throw HTTPStatus._400}
            
            try PostgresOperation({ (connection) in
                let result = try connection.execute("SELECT id FROM \(TBUser.name) WHERE email=\(email)")
                guard result.numTuples() == 0 else {
                    throw APIErrorType.UserEmailExist
                }
            })
        }
        
        func kr_handleRequest(query: [String : String], request: WebRequest, response: WebResponse) throws {
            
            let user = try ENUser(query: query)
            
            
        }
    }
    
}

//class PostUsersHandler: KRHandlerProtocol {
//    
//    let requestType         : RequestType           = .GET
//    let responseContentType : ResponseContentType   = .JSON
//    
//    func kr_handleRequest(query: [String : String], request: WebRequest, response: WebResponse) throws {
//        
//        let query: [String : String] = DictFromStringTuple(request.postParams)
//        
//        guard let firstName = query["first_name"] else {
//            throw HTTPStatus._400
//        }
//        guard let lastName = query["last_name"] else {
//            throw HTTPStatus._400
//        }
//        
//        guard let user = try? DBUser(firstName: firstName, lastName: lastName) else {
//            throw HTTPStatus._500
//        }
//        
//        let responseDict: [String : Any] = [
//            "id"            : user.id,
//            "first_name"    : user.firstName,
//            "last_name"     : user.lastName
//        ]
//        
//        let jsonEncoder = JSONEncoder()
//        guard let responseString = try? jsonEncoder.encode(["user" : responseDict]) else {
//            throw HTTPStatus._500
//        }
//        
//        response.addContentTypeHeader(.JSON)
//        response.appendBodyString(responseString)
//        response.setHTTPStatus(._201)
//    }
//}
//
//class GetUsersHandler: KRHandlerProtocol {
//    let requestType         : RequestType           = .GET
//    let responseContentType : ResponseContentType   = .JSON
//    
//    func kr_handleRequest(query: [String : String], request: WebRequest, response: WebResponse) throws {
//        
//        guard let idString = query["id"], id = Int(idString) else {
//            throw HTTPStatus._400
//        }
//        
//        var user: DBUser!
//        
//        do {
//            user = try DBUser(id: id)
//        } catch let error as DBUserError {
//            
//            if case .NotFound = error {
//                throw APIError(type: .UserNotFound, parameters: ["searched_by":"id"])
//            } else {
//                throw HTTPStatus._500
//            }
//            
//        } catch {
//            throw HTTPStatus._500
//        }
//        
//        let responseDict: [String : Any] = [
//            "id"            : user.id,
//            "first_name"    : user.firstName,
//            "last_name"     : user.lastName
//        ]
//        
//        guard let responseString = try? JSONEncoder().encode(["user" : responseDict]) else {
//            throw HTTPStatus._500
//        }
//        
//        response.addContentTypeHeader(.JSON)
//        response.appendBodyString(responseString)
//        response.setHTTPStatus(._200)
//        
//    }
//}
