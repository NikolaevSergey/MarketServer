//
//  KRHandler.swift
//  PerfectBase
//
//  Created by Sergey Nikolaev on 16.06.16.
//  Copyright © 2016 Sergey Nikolaev. All rights reserved.
//

import PerfectLib

protocol KRHandlerProtocol: RequestHandler {
    
    var requestType:RequestType {get}
    var responseContentType: ResponseContentType {get}
    
    func getRequestParameters(request: WebRequest) -> [String : String]
    
    func kr_handleRequest(query: [String : String], request: WebRequest, response: WebResponse) throws
}

extension KRHandlerProtocol {
    
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
        
        do {
            try self.kr_handleRequest(self.getRequestParameters(request), request: request, response: response)
        } catch let status as HTTPStatus {
            response.setHTTPStatus(status)
        } catch let error as APIError {
            response.setAPIError(error)
        } catch {
            response.setHTTPStatus(._500)
        }
    }
}
