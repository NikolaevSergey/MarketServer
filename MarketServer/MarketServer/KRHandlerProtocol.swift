//
//  KRHandler.swift
//  PerfectBase
//
//  Created by Sergey Nikolaev on 16.06.16.
//  Copyright © 2016 Sergey Nikolaev. All rights reserved.
//

import PerfectLib

typealias QueryType = [String : String]

protocol KRHandlerProtocol: RequestHandler {
    
    var requestType:RequestType {get}
    var responseContentType: ResponseContentType {get}
    
    var requiredFields: [String] {get}
    
    func getRequestParameters(request: WebRequest) -> [String : String]
    
    func validate(query: [String : AnyObject]) throws
    
    func kr_handleRequest(query: [String : String], request: WebRequest, response: WebResponse) throws
}

extension KRHandlerProtocol {
    
    var requiredFields: [String] {return []}
    func validate(query: [String : AnyObject]) throws {}
    
    var responseContentType: ResponseContentType {return .JSON}
    
    func getRequestParameters(request: WebRequest) -> [String : String] {
        switch self.requestType {
        case .GET   : return DictFromStringTuple(request.queryParams)
        case .POST  : return DictFromStringTuple(request.postParams)
        default: return [:]
        }
    }
}

extension KRHandlerProtocol {
    func handleRequest(request: WebRequest, response: WebResponse) {
        
        defer {response.requestCompletedCallback()}
        
        let query = self.getRequestParameters(request)
        
        for key in self.requiredFields {
            guard query[key] != nil else {
                Logger.warning("Validation failed for key \(key)")
                response.setHTTPStatus(._400)
                return
            }
        }
        
        do {
            try self.validate(query)
            try self.kr_handleRequest(query, request: request, response: response)
            
        } catch let status as HTTPStatus {
            response.setHTTPStatus(status)
            
        } catch let error as HTTPStatusProtocol {
            response.setHTTPStatus(error.status)
            
        } catch let error as APIErrorProtocol {
            response.setAPIError(error)
            
        } catch let error {
            Logger.error("\(error)")
            response.setHTTPStatus(._500)
        }
    }
}
