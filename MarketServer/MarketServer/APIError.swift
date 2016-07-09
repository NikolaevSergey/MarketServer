//
//  APIError.swift
//  PerfectBase
//
//  Created by Sergey Nikolaev on 18.06.16.
//  Copyright © 2016 Sergey Nikolaev. All rights reserved.
//

protocol APIErrorProtocol: ErrorType {
    
    var status: HTTPStatus {get}
    var message: String {get}
}

extension APIErrorProtocol {
    var parameters: [String : Any] {
        return [
            "domain": self._domain,
            "code" : self._code,
            "message": self.message
        ]
    }
}

class APIError: APIErrorProtocol {
    let type: APIErrorType
    let additionalInfo: [String : Any]?
    
    init (type: APIErrorType, additionalInfo: [String : Any]? = nil) {
        self.type = type
        self.additionalInfo = additionalInfo
    }
    
    var _domain : String        {return type._domain}
    var _code   : Int           {return type._code}
    var message : String        {return self.type.message}
    var status  : HTTPStatus    {return self.type.status}
    
    var parameters: [String : Any] {
        var parameters = self.type.parameters
        if let info = self.additionalInfo {
            parameters.updateValue(info, forKey: "info")
        }
        return parameters
    }
}

enum APIErrorType: APIErrorProtocol {
    case UserNotFound
    case UserEmailExist
    
    var message: String {
        switch self {
        case .UserNotFound      : return "User not founded"
        case .UserEmailExist    : return "User with this email address already exist"
        }
    }
    
    var status: HTTPStatus {
        switch self {
        case .UserNotFound      : return ._404
        case .UserEmailExist    : return ._403
        }
    }
    
    var parameters: [String : Any] {
        return [
            "domain"    : self._domain,
            "code"      : self._code,
        ]
    }
}
