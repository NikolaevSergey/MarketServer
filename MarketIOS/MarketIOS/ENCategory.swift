//
//  ENCategories.swift
//  MarketIOS
//
//  Created by Sergey Nikolaev on 21.07.16.
//  Copyright © 2016 Flatstack. All rights reserved.
//

import Foundation

class ENCategory: Object {
    dynamic var id: Int = 0
    dynamic var name: String = ""
    
    convenience init (id: Int, name: String) {
        self.init(value: ["id": id, "name" : name])
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

struct RRCategories {
    let categories: [String : AnyObject]
}

extension RRCategories: RTSerialazible {
    
    typealias ResponseType = [String : [String : AnyObject]]
    
    static func serialize (object: ResponseType) throws -> RRCategories {
        guard let categories = object["categories"] else {throw SerializationError.RequeriedFieldMissing}
        return RRCategories(categories: categories)
    }
}
