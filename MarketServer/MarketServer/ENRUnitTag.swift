//
//  ENRUnitTag.swift
//  MarketServer
//
//  Created by Sergey Nikolaev on 12.07.16.
//  Copyright © 2016 Sergey Nikolaev. All rights reserved.
//

import Foundation

//class ENRUnitTag {
//    let tagID: Int
//    let unitID: Int
//    
//    init (unitID: Int, tagID: Int) throws {
//        
//        try PostgresOperation { (connection) in
//            
//            let checkRequest = SQLBuilder.SELECT().COUNT().FROM(TBRUnitTag.Name)
//            
//            let insertRequest = SQLBuilder.INSERT(TBRUnitTag.Name, data: [
//                Key.TagID : tagID,
//                Key.UnitID : unitID,
//                ])
//            
//            let checkResult = try connection.execute(checkRequest)
//            guard checkResult.getFieldInt(0, fieldIndex: 0) == 0 else {
//                Logger.warning("Relation already exist")
//                return
//            }
//            
//            try connection.execute(insertRequest)
//        }
//        
//        self.tagID = tagID
//        self.unitID = unitID
//    }
//    
//    convenience init (unit: ENUnit, tag: ENTag) throws {
//        try self.init(unitID: unit.id, tagID: tag.id)
//    }
//}
//
//extension ENRUnitTag: KRSerializable {
//    func serialize() -> JSONType {
//        return [
//            Key.TagID   : self.tagID,
//            Key.UnitID  : self.unitID
//        ]
//    }
//}
//
//extension ENRUnitTag {
//    enum Key {
//        static let TagID    = "tag_id"
//        static let UnitID   = "unit_id"
//    }
//}
