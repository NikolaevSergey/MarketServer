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
    
}

func DictFromStringTuple (tuples: [(String, String)]) -> [String : String] {
    var dict: [String : String] = [:]
    
    for (key, value) in tuples {
        dict.updateValue(value, forKey: key)
    }
    
    return dict
}
