//
//  RTCategories.swift
//  MarketIOS
//
//  Created by Sergey Nikolaev on 06.07.16.
//  Copyright © 2016 Flatstack. All rights reserved.
//

import Foundation

extension Router {
    enum Category {
        case GetAll
    }
}

extension Router.Category: RouterProtocol {
    
    var settings: RTRequestSettings {
        switch self {
        case .GetAll: return RTRequestSettings(method: .GET)
        }
    }
    
    var path: String {
        switch self {
        case .GetAll: return "/categories"
        }
    }
    
    var parameters: [String : AnyObject]? {
        switch self {
        case .GetAll: return nil
        }
    }
}
