//
//  RTSerializing.swift
//  MarketIOS
//
//  Created by Sergey Nikolaev on 06.07.16.
//  Copyright © 2016 Flatstack. All rights reserved.
//

import Foundation
import ObjectMapper

class RTCategoriesResponse: Mappable {
    var categories: [ENCategory]?
    
    required convenience init?(_ map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        self.categories <- map["categories"]
    }
}
