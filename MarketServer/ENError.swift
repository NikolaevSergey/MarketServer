//
//  ENError.swift
//  MarketServer
//
//  Created by Sergey Nikolaev on 12.07.16.
//  Copyright © 2016 Sergey Nikolaev. All rights reserved.
//

import Foundation

enum ENError: ErrorType, HTTPStatusProtocol {
    case NotFound
    case RequiredFieldsMissing
    case AlreadyExist
    case Unknown
    
    var status: HTTPStatus {
        switch self {
        case .NotFound              : return ._404
        case .RequiredFieldsMissing : return ._400
        case .AlreadyExist          : return ._403
        case .Unknown               : return ._500
        }
    }
}
