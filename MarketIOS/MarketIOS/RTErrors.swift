//
//  RTErrors.swift
//  MarketIOS
//
//  Created by Sergey Nikolaev on 06.07.16.
//  Copyright © 2016 Flatstack. All rights reserved.
//

import Foundation

protocol FSError: ErrorType {
    var description: String {get}
}

extension FSError {
    func log () {
        NSLog("\(self._domain)(\(self._code)): \(self.description)")
    }
}

struct ErrorHumanDescription {
    let title: String
    let text: String
    
    init (title: String? = nil, text: String) {
        self.title = title ?? "Error"
        self.text = text
    }
}

protocol HumanErrorType: FSError {
    var humanDescription: ErrorHumanDescription {get}
}

enum RTError {
    case Request(RequestError)
    case Backend(BackendError)
    case Serialize(SerializationError)
    case Unknown(NSError?)
}

enum SerializationError {
    case WrongType
    case RequeriedFieldMissing
}

enum BackendError {
    case NotAuthorized
}

enum RequestError {
    //???
}

//====

enum SerializeError: ErrorType {
    case WrongType
    case RequiredFieldMissing
    case Network(NetworkError)
}

enum NetworkError {
    case Unknown(NSError?)
}


