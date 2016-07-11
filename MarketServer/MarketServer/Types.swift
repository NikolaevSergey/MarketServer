//
//  Types.swift
//  PerfectBase
//
//  Created by Sergey Nikolaev on 18.06.16.
//  Copyright © 2016 Sergey Nikolaev. All rights reserved.
//


enum ResponseContentType {
    case JSON
    
    var value: String {
        switch self {
        case .JSON: return "application/json"
        }
    }
    
    static let Name: String = "Content-Type"
    var name: String {return ResponseContentType.Name}
}

enum RequestType: String {
    case GET = "GET"
    case POST = "POST"
    case PATCH = "PATCH"
    case PUT = "PUT"
    case DELETE = "DELETE"
}

