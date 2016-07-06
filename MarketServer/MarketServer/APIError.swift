//
//  APIError.swift
//  PerfectBase
//
//  Created by Sergey Nikolaev on 18.06.16.
//  Copyright © 2016 Sergey Nikolaev. All rights reserved.
//

class APIError {
    let type: APIErrorType
    let parameters: [String : Any]
    
    init (type: APIErrorType, parameters: [String : Any]? = nil) {
        self.type = type
        
        self.parameters = [
            "domain": self.type._domain,
            "code" : self.type._code,
            "info" : parameters
        ]
    }
}

extension APIError: ErrorType {
    var _domain : String    {return type._domain}
    var _code   : Int       {return type._code}
}

enum APIErrorType: ErrorType {
    case UserNotFound
    
    var message: String {
        switch self {
        case .UserNotFound: return "User not founded"
        }
    }
    
    var status: HTTPStatus {
        switch self {
        case .UserNotFound: return ._404
        }
    }
}
