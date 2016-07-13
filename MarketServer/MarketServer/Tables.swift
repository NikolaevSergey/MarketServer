//
//  PostgreSQLTablesCreating.swift
//  MarketServer
//
//  Created by Sergey Nikolaev on 21.06.16.
//  Copyright © 2016 Sergey Nikolaev. All rights reserved.
//

import PerfectLib
import PostgreSQL

class TBUser: DBTable {
    
    static let Name: String = "users"
    
    static let Columns: [DBColumn] = [
        DBColumn(name: ENUser.Key.id         , type: .SERIAL , settings: [.PrimaryKey]   , notNull: true),
        DBColumn(name: ENUser.Key.firstName  , type: .TEXT   , settings: []              , notNull: true),
        DBColumn(name: ENUser.Key.lastName   , type: .TEXT   , settings: []              , notNull: true),
        DBColumn(name: ENUser.Key.email      , type: .TEXT   , settings: []              , notNull: true),
        DBColumn(name: ENUser.Key.password   , type: .TEXT   , settings: []              , notNull: true),
        DBColumn(name: ENUser.Key.phone      , type: .TEXT   , settings: []              , notNull: false)
    ]
    
    static let Relationships: [DBRelation] = []
}

class TBToken: DBTable {
    
    static let Name: String = "tokens"
    
    static let Columns: [DBColumn] = [
        DBColumn(name: ENToken.Key.ID         , type: .SERIAL     , settings: [.PrimaryKey]   , notNull: true),
        DBColumn(name: ENToken.Key.Token      , type: .TEXT       , settings: []              , notNull: true),
        DBColumn(name: ENToken.Key.Date       , type: .INT        , settings: []              , notNull: true)
    ]
    
    static let Relationships: [DBRelation] = [
        DBRelation(columnName: ENToken.Key.UserID, type: .INT, rTableName: TBUser.Name, rColumnName: ENUser.Key.id)
    ]
}

//class TBCategory: DBTable {
//    static let Name: String = "categories"
//    
//    static let Columns: [DBColumn] = [
//        DBColumn(name: ENCategory.Key.ID         , type: .SERIAL     , settings: [.PrimaryKey]   , notNull: true),
//        DBColumn(name: ENCategory.Key.Name       , type: .TEXT       , settings: []              , notNull: true)
//    ]
//    
//    static let Relationships: [DBRelation] = []
//}

//class TBUnit: DBTable {
//    static let Name: String = "units"
//    
//    static let Columns: [DBColumn] = [
//        DBColumn(name: ENUnit.Key.ID            , type: .SERIAL     , settings: [.PrimaryKey]   , notNull: true),
//        DBColumn(name: ENUnit.Key.Name          , type: .TEXT       , settings: []              , notNull: true),
//        DBColumn(name: ENUnit.Key.Price         , type: .REAL       , settings: []              , notNull: true)
//    ]
//    
//    static let Relationships: [DBRelation] = [
//        DBRelation(columnName: ENUnit.Key.CategoryID, type: .INT, rTableName: TBCategory.Name, rColumnName: ENCategory.Key.ID)
//    ]
//}
//
//class TBRUnitTag: DBTable {
//    static let Name: String = "r_unit_tag"
//    
//    static let Columns: [DBColumn] = [
//        DBColumn(name: ENRUnitTag.Key.TagID     , type: .INT, settings: [], notNull: true),
//        DBColumn(name: ENRUnitTag.Key.UnitID    , type: .INT, settings: [], notNull: true)
//    ]
//    
//    static let Relationships: [DBRelation] = []
//}
