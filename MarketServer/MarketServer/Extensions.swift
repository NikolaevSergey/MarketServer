//
//  Extensions.swift
//  PerfectBase
//
//  Created by Sergey Nikolaev on 16.06.16.
//  Copyright © 2016 Sergey Nikolaev. All rights reserved.
//

import PerfectLib

extension WebResponse {
    
    func setHTTPStatus (status: HTTPStatus) {
        self.setStatus(status.rawValue, message: status.description)
    }
    
    func addContentTypeHeader (type: ResponseContentType) {
        self.addHeader(type.name, value: type.value)
    }
    
    func setAPIError (error: APIErrorProtocol) {
        self.setHTTPStatus(error.status)
        guard let parameters = try? JSONEncoder().encode(error.parameters) else {return}
        self.addContentTypeHeader(.JSON)
        self.appendBodyString(parameters)
    }
    
    func addJSONResponse (response: [String : JSONValue]) throws {
        
        let jsonEncoder = JSONEncoder()
        guard let responseString = try? jsonEncoder.encode(response) else {
            throw HTTPStatus._500
        }

        
        self.addContentTypeHeader(.JSON)
        self.appendBodyString(responseString)
    }
    
}

extension String {
    var escaped: String {
        return "'\(self)'"
    }
}

func DictFromStringTuple (tuples: [(String, String)]) -> [String : String] {
    var dict: [String : String] = [:]
    
    for (key, value) in tuples {
        dict.updateValue(value, forKey: key)
    }
    
    return dict
}

// MARK: Raw Representable
public extension RawRepresentable {
    public init?(_ rawValue: RawValue) {
        self.init(rawValue: rawValue)
    }
}

public extension RawRepresentable where Self.RawValue == Int {
    public static var allCases: [Self] {
        var i = -1
        return Array( AnyGenerator{i += 1;return self.init(rawValue: i)})
    }
}
