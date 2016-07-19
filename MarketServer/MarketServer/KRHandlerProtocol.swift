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
    
    associatedtype QueryType: KRQueryObject
    
    static var requestType:RequestType {get}
    static var responseContentType: ResponseContentType {get}
    
    func kr_handleRequest(query: QueryType, request: WebRequest, response: WebResponse) throws
}

extension KRHandlerProtocol {
    
    static var responseContentType: ResponseContentType {return .JSON}
    
    func getRequestParameters(request: WebRequest) -> [String : String] {
        switch self.dynamicType.requestType {
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
        
        do {
            let queryObject = try QueryType(query: query, request: request)
            try self.kr_handleRequest(queryObject, request: request, response: response)
            
        } catch let status as HTTPStatus {
            Logger.warning(status.description)
            response.setHTTPStatus(status)
            
        } catch let error as HTTPStatusProtocol {
            Logger.warning(error.status.description)
            response.setHTTPStatus(error.status)
            
        } catch let error as APIErrorProtocol {
            Logger.warning(error.message)
            response.setAPIError(error)
            
        } catch let error {
            Logger.error("\(error)")
            response.setHTTPStatus(._500)
        }
    }
}

protocol KRQueryObject {
    init (query: [String : String], request: WebRequest) throws
}
