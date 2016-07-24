//
//  ENCategories.swift
//  MarketIOS
//
//  Created by Sergey Nikolaev on 21.07.16.
//  Copyright © 2016 Flatstack. All rights reserved.
//

import Foundation
import ObjectMapper

class ENCategory: Object {
    dynamic var id: Int = 0
    dynamic var name: String = ""
    
    convenience init (id: Int, name: String) {
        self.init(value: ["id": id, "name" : name])
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    required convenience init?(_ map: ObjectMapper.Map) {
        guard let _ = map.JSONDictionary["id"] as? Int else {return nil}
        self.init()
    }
    
    
}

extension ENCategory: Mappable {
    func mapping(map: ObjectMapper.Map) {
        id <- map["id"]
        name <- map["name"]
    }
}

//class example: Mappable {
//    var id: Int = 0
//    var name: String = ""
//    
//    required convenience init?(_ map: ObjectMapper.Map) {
//        self.init()
//    }
//    
//    func mapping(map: ObjectMapper.Map) {
//        id <- map["id"]
//        name <- map["name"]
//    }
//}



//extension ENCategory {
//    typealias ResponseType = [String : AnyObject]
//    
//    static func serialize (object: ResponseType) throws -> ENCategory {
//        return ENCategory(value: object)
//    }
//}



//protocol MappableEntity {
//    associatedtype MappableKeys: MappableEnum
//    subscript (key: String) -> AnyObject? { get set }
//}

//extension MappableEntity where Self: Object {
//    subscript (key: String) -> AnyObject? {
//        get {
//            guard let keyObject = MappableKeys(mappingKey: key) else {return nil}
//            return Self[keyObject.masterKey]
//        }
//        set (value) {
//            
//        }
//    }
//}

//extension ENCategory {
//    enum Key: Int, MappableEnum{
//        case id = 0
//        case name
//        
//        var masterKey: String {
//            Key.allCases
//            switch self {
//            case .id    : return "id"
//            case .name  : return "name"
//            }
//        }
//        
//        var mappingKeys: [String] {
//            var keys: [String] = [self.masterKey]
//            switch self {
//            case .id    : keys += []
//            case .name  : keys += []
//            }
//            return keys
//        }
//    }
//}

//protocol MappableEnum: RawRepresentable {
//    var masterKey: String {get}
//    var mappingKeys: [String] {get}
//    init? (mappingKey: String)
//}
//
//extension MappableEnum where Self.RawValue == Int {
//    init? (mappingKey: String) {
//        for key in Self.allCases {
//            guard key.mappingKeys.contains(mappingKey) else {continue}
//            self = key; return
//        }
//        return nil
//    }
//}



//struct RRCategories {
//    let categories: [String : AnyObject]
//}
