//
//  RTSerializing.swift
//  MarketIOS
//
//  Created by Sergey Nikolaev on 06.07.16.
//  Copyright © 2016 Flatstack. All rights reserved.
//

import Foundation

enum SerializeError: ErrorType {
    case WrongType
    case RequiredFieldMissing
    case Network(NetworkError)
}

enum NetworkError {
    case Unknown(NSError?)
}

protocol Serialazible {
    associatedtype ResponseType
    static func serialize (object: ResponseType) throws -> Self
}

extension Request {
    
    func responseObject<T: Serialazible>(completionHandler: Response<T, SerializeError> -> Void) -> Self {
        
        let responseSerializer = ResponseSerializer<T, SerializeError> { request, response, data, error in
            
            guard error == nil else { return .Failure(SerializeError.Network(.Unknown(error!)))}
            
            let JSONResponseSerializer = Request.JSONResponseSerializer(options: .AllowFragments)
            let result = JSONResponseSerializer.serializeResponse(request, response, data, error)
            
            switch result {
            case .Success(let value):
                
                guard let object = value as? T.ResponseType else {
                    return .Failure(SerializeError.WrongType)
                }
                
                do {
                    let serializedObject = try T.serialize(object)
                    return .Success(serializedObject)
                } catch {
                    return .Failure(SerializeError.RequiredFieldMissing)
                }
                
            case .Failure(_):
                return .Failure(SerializeError.WrongType)
            }
        }
        
        return response(responseSerializer: responseSerializer, completionHandler: completionHandler)
    }
}
