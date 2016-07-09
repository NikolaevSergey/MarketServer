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
    
    static let name: String = "User"
    
    static let columns: [DBColumn] = [
        DBColumn(name: "id"         , type: .SERIAL , settings: [.PrimaryKey]   , notNull: true),
        DBColumn(name: "first_name" , type: .TEXT   , settings: []              , notNull: true),
        DBColumn(name: "last_name"  , type: .TEXT   , settings: []              , notNull: true),
        DBColumn(name: "email"      , type: .TEXT   , settings: []              , notNull: true),
        DBColumn(name: "phone"      , type: .TEXT   , settings: []              , notNull: false)
    ]
    
    static let relationships: [DBRelation] = []
}

class TBToken: DBTable {
    
    static let name: String = "Token"
    
    static let columns: [DBColumn] = [
        DBColumn(name: "token"      , type: .TEXT , settings: [.PrimaryKey]   , notNull: true),
        DBColumn(name: "timestamp"  , type: .INT  , settings: []              , notNull: true)
    ]
    
    static let relationships: [DBRelation] = [
        DBRelation(columnName: "user", type: .INT, rTableName: "User", rColumnName: "id")
    ]
}

/*

class TableFrame: DBTable {
    
    init () {
        super.init(name: "frame",
                   columns: [
                    DBColumn(name: "id"             , type: .SERIAL , settings: [.PrimaryKey]),
                    DBColumn(name: "termFrequency"  , type: .REAL   , settings: []),
            ])
    }
    
}

class TableCluster: DBTable {
    init () {
        super.init(name: "cluster",
                   columns: [
                    DBColumn(name: "id"                       , type: .SERIAL , settings: [.PrimaryKey]),
                    DBColumn(name: "inverseDocumentFrequency" , type: .REAL   , settings: [])
            ])
    }
}

class TablePoint: DBTable {
    init () {
        super.init(name: "point",
                   columns: [
                    DBColumn(name: "id"         , type: .SERIAL , settings: [.PrimaryKey]),
                    DBColumn(name: "x"          , type: .REAL   , settings: []),
                    DBColumn(name: "y"          , type: .REAL   , settings: [])
            ]   , relationships: [
                DBRelation(columnName: "frame_id"   , type: .INT, rTableName: "frame"   , rColumnName: "id"),
                DBRelation(columnName: "cluster_id" , type: .INT, rTableName: "cluster" , rColumnName: "id")
            ])
    }
}

class TableGroup: DBTable {
    init () {
        super.init(name: "group",
                   columns: [
                    DBColumn(name: "folder"     , type: .TEXT , settings: [.PrimaryKey]),
                    DBColumn(name: "title"      , type: .TEXT   , settings: []),
                    DBColumn(name: "text"       , type: .TEXT   , settings: [])
            ])
    }
}

class TableImage: DBTable {
    init () {
        super.init(name: "image",
                   columns: [
                    DBColumn(name: "name"       , type: .TEXT , settings: [.PrimaryKey]),
            ]   , relationships: [
                DBRelation(columnName: "folder"   , type: .TEXT, rTableName: "group"   , rColumnName: "folder"),
            ])
    }
}

//----
protocol EntityProtocol {
    static var table: DBTable {get}
    static func getAll () -> [Self]
    
    func toJSON () -> [String : JSONValue]
}

final class ENFrame: EntityProtocol {
    static let table: DBTable = TableFrame()
    
    private(set) var id: Int
    private(set) var termFrequency: Double
    
    private init (id: Int, termFrequency: Double) {
        self.id = id
        self.termFrequency = termFrequency
    }
    
    static func getAll () -> [ENFrame] {
        
        guard let idColumn      = self.table.getColumn("id")                else {return []}
        guard let termColumn    = self.table.getColumn("termFrequency")     else {return []}
        
        guard let result = self.table.SelectAll([idColumn, termColumn]) else {return []}
        
        var frames: [ENFrame] = []
        
        for i in 0 ..< result.numTuples() {
            guard let id    : Int       = idColumn.type.getValue(result, row: i, number: 0) else {continue}
            guard let term  : Double    = termColumn.type.getValue(result, row: i, number: 1) else {continue}
            
            frames.append(ENFrame(id: id, termFrequency: term))
        }
        
        return frames
    }
    
    func toJSON() -> [String : JSONValue] {
        return [
            "id"                : self.id,
            "termFrequency"     : self.termFrequency
        ] as [String : JSONValue]
    }
    
}

final class ENCluster: EntityProtocol {
    static let table: DBTable = TableCluster()
    
    private(set) var id: Int
    private(set) var inverseDocumentFrequency: Double
    
    private init (id: Int, termFrequency: Double) {
        self.id = id
        self.inverseDocumentFrequency = termFrequency
    }
    
    static func getAll () -> [ENCluster] {
        
        guard let idColumn      = self.table.getColumn("id")                else {return []}
        guard let termColumn    = self.table.getColumn("inverseDocumentFrequency")     else {return []}
        
        guard let result = self.table.SelectAll([idColumn, termColumn]) else {return []}
        
        var clusters: [ENCluster] = []
        
        for i in 0 ..< result.numTuples() {
            guard let id    : Int       = idColumn.type.getValue(result, row: i, number: 0) else {continue}
            guard let term  : Double    = termColumn.type.getValue(result, row: i, number: 1) else {continue}
            
            clusters.append(ENCluster(id: id, termFrequency: term))
        }
        
        return clusters
    }
    
    func toJSON() -> [String : JSONValue] {
        return [
            "id"                        : self.id,
            "inverseDocumentFrequency"  : self.inverseDocumentFrequency
            ] as [String : JSONValue]
    }
    
}

typealias Point = (x: Double, y: Double)
final class ENPoint: EntityProtocol {
    static let table: DBTable = TablePoint()
    
    private(set) var id: Int
    private(set) var point: Point
    
    private(set) var frameID: Int
    private(set) var clusterID: Int
    
    private init (id: Int, point: Point, frameID: Int, clusterID: Int) {
        self.id = id
        self.point = point
        
        self.frameID = frameID
        self.clusterID = clusterID
    }
    
    static func getAll () -> [ENPoint] {
        
        guard let idColumn      = self.table.getColumn("id")    else {return []}
        guard let xColumn       = self.table.getColumn("x")     else {return []}
        guard let yColumn       = self.table.getColumn("y")     else {return []}
        
        guard let frameColumn       = self.table.getRelation("frame_id")    else {return []}
        guard let clusterColumn     = self.table.getRelation("cluster_id")  else {return []}
        
        guard let result = self.table.SelectAll([idColumn, xColumn, yColumn], relations: [frameColumn, clusterColumn]) else {return []}
        
        var frames: [ENPoint] = []
        
        for i in 0 ..< result.numTuples() {
            guard let id            : Int       = idColumn.type.getValue        (result, row: i, number: 0) else {continue}
            guard let x             : Double    = xColumn.type.getValue         (result, row: i, number: 1) else {continue}
            guard let y             : Double    = yColumn.type.getValue         (result, row: i, number: 2) else {continue}
            guard let frameID       : Int       = frameColumn.type.getValue     (result, row: i, number: 3) else {continue}
            guard let clusterID     : Int       = clusterColumn.type.getValue   (result, row: i, number: 4) else {continue}
            
            frames.append(ENPoint(id: id, point: (x, y), frameID: frameID, clusterID: clusterID))
        }
        
        return frames
    }
    
    func toJSON() -> [String : JSONValue] {
        return [
            "id"            : self.id,
            "x"             : self.point.x,
            "y"             : self.point.y,
            "frame_id"      : self.frameID,
            "cluster_id"    : self.clusterID
            ] as [String : JSONValue]
    }
    
}

final class ENGroup: EntityProtocol {
    static let table: DBTable = TableGroup()
    
    private(set) var folder : String
    private(set) var title  : String
    private(set) var text   : String
    
    private init (folder: String, title: String, text: String) {
        self.folder     = folder
        self.title      = title
        self.text       = text
    }
    
    static func getAll () -> [ENGroup] {
        
        guard let folderColumn   = self.table.getColumn("folder")    else {return []}
        guard let titleColumn    = self.table.getColumn("title")     else {return []}
        guard let textColumn     = self.table.getColumn("text")      else {return []}
        
        guard let result = self.table.SelectAll([folderColumn, titleColumn, textColumn]) else {return []}
        
        var groups: [ENGroup] = []
        
        for i in 0 ..< result.numTuples() {
            guard let folder    : String    = folderColumn.type.getValue(result, row: i, number: 0) else {continue}
            guard let title     : String    = titleColumn.type.getValue(result, row: i, number: 1) else {continue}
            guard let text      : String    = textColumn.type.getValue(result, row: i, number: 2) else {continue}
            
            groups.append(ENGroup(folder: folder, title: title, text: text))
        }
        
        return groups
    }
    
    func toJSON() -> [String : JSONValue] {
        return [
            "folder"    : self.folder,
            "title"     : self.title,
            "text"      : self.text
            ] as [String : JSONValue]
    }
    
}

final class ENImage: EntityProtocol {
    static let table: DBTable = TableImage()
    
    private(set) var name   : String
    private(set) var folder : String
    
    private init (name: String, folder: String) {
        self.name       = name
        self.folder     = folder
    }
    
    static func getAll () -> [ENImage] {
        
        guard let nameColumn     = self.table.getColumn("name")     else {return []}
        guard let folderColumn   = self.table.getColumn("folder")    else {return []}
        
        
        guard let result = self.table.SelectAll([nameColumn, folderColumn]) else {return []}
        
        var images: [ENImage] = []
        
        for i in 0 ..< result.numTuples() {
            guard let name      : String    = nameColumn.type.getValue(result, row: i, number: 0) else {continue}
            guard let folder    : String    = folderColumn.type.getValue(result, row: i, number: 1) else {continue}
            
            images.append(ENImage(name: name, folder: folder))
        }
        
        return images
    }
    
    func toJSON() -> [String : JSONValue] {
        return [
            "name"    : self.name,
            "folder"  : self.folder,
            ] as [String : JSONValue]
    }
    
}
 */
