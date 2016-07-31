//
//  Statuses.swift
//  PerfectBase
//
//  Created by Sergey Nikolaev on 15.06.16.
//  Copyright © 2016 Sergey Nikolaev. All rights reserved.
//

enum HTTPStatus: Int, ErrorType {
    case _200 = 200
    case _201 = 201
    
    case _400 = 400
    case _401 = 401
    case _403 = 403
    case _404 = 404
    
    case _500 = 500
    
    var description: String {
        switch self {
        case ._200: return "OK"
        case ._201: return "Created"
            
        case ._400: return "Bad Request"
        case ._401: return "Not Authorized"
        case ._403: return "Forbidden"
        case ._404: return "Not Found"
            
        case ._500: return "Internal Server Error"
        }
    }
    
    var _code: Int {
        return self.rawValue
    }
    
    var group: HTTPStatusGroup {return HTTPStatusGroup(status: self)}
}

enum HTTPStatusGroup: Int {
    case Info           = 1
    case Success        = 2
    case Redirection    = 3
    case ClientError    = 4
    case ServerError    = 5
    
    init (status: HTTPStatus) {
        let number = Int(status.rawValue/100)
        self = HTTPStatusGroup(rawValue: number)!
    }
    
    init? (statusCode: Int) {
        let number = Int(statusCode/100)
        guard let group = HTTPStatusGroup(rawValue: number) else {return nil}
        self = group
    }
}

protocol HTTPStatusProtocol: ErrorType {
    var status: HTTPStatus {get}
}
