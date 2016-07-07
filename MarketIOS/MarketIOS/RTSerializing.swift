//
//  RTSerializing.swift
//  MarketIOS
//
//  Created by Sergey Nikolaev on 06.07.16.
//  Copyright © 2016 Flatstack. All rights reserved.
//

import Foundation

protocol RTSerialazible {
    associatedtype ResponseType
    static func serialize (object: ResponseType) throws -> Self
}

extension Request {
    
    func responseObject<T: RTSerialazible>(completionHandler: Response<T, RTError> -> Void) -> Self {
        
        let responseSerializer = ResponseSerializer<T, RTError> { request, response, data, error in
            guard error == nil else { return .Failure(RTError(request: .Unknown(error: error)))}
            
            let JSONResponseSerializer = Request.JSONResponseSerializer(options: .AllowFragments)
            let result = JSONResponseSerializer.serializeResponse(request, response, data, error)
            
            switch result {
            case .Success(let value):
                
                guard let object = value as? T.ResponseType else {
                    return .Failure(RTError(serialize: .WrongType))
                }
                
                do {
                    let serializedObject = try T.serialize(object)
                    return .Success(serializedObject)
                } catch let error as SerializationError {
                    return .Failure(RTError(serialize: error))
                } catch {
                    return .Failure(RTError(serialize: .Unknown))
                }
                
            case .Failure(_):
                return .Failure(RTError(serialize: .JSONSerializingFailed))
            }
        }
        
        return response(responseSerializer: responseSerializer, completionHandler: completionHandler)
    }
}
