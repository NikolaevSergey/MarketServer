//
//  SQLRequest.swift
//  MarketServer
//
//  Created by Sergey Nikolaev on 09.07.16.
//  Copyright © 2016 Sergey Nikolaev. All rights reserved.
//

import Foundation

//class SQLRequest {
//    
//}

func Play () {
    SQLBuilder().SELECT([]).FROM("").WHERE("").build()
}

protocol SQLParrent {
    func build () -> String
}

struct SQLBuilder {
    
    func SELECT (columns: [String]) -> SQLSelect {return SQLSelect(columns: columns)}
    func INSERT (columns: [String]) -> SQLInsert {return SQLInsert(columns: columns)}
    func UPDATE (columns: [String]) -> SQLUpdate {return SQLUpdate(columns: columns)}
    func DELETE () -> SQLDelete {return SQLDelete()}
}

//===

struct SQLInsert: SQLParrent {
    let columns: [String]
    
    func FROM (table: String) -> SQLFrom {
        return SQLFrom(parrent: self, table: table)
    }
    
    func build() -> String {
        return ""
    }
}

struct SQLSelect: SQLParrent {
    let columns: [String]
    
    func FROM (table: String) -> SQLFrom {
        return SQLFrom(parrent: self, table: table)
    }
    
    func build() -> String {
        return ""
    }
}

struct SQLUpdate: SQLParrent {
    let columns: [String]
    
    func FROM (table: String) -> SQLFrom {
        return SQLFrom(parrent: self, table: table)
    }
    
    func build() -> String {
        return ""
    }
}

struct SQLDelete: SQLParrent {
    
    func FROM (table: String) -> SQLFrom {
        return SQLFrom(parrent: self, table: table)
    }
    
    func build() -> String {
        return ""
    }
}

//===

struct SQLFrom: SQLParrent {
    let parrent: SQLParrent
    let table: String
    
    func WHERE (query: String) -> SQLWhere {
        return SQLWhere(parrent: self, query: query)
    }
    
    func build() -> String {
        return ""
    }
}

struct SQLWhere: SQLParrent {
    let parrent: SQLParrent
    let query: String
    
    func build() -> String {
        return ""
    }
}






enum SQLCreate {
    case SCHEMA
    case TABLE
}

enum SQLDrop {
    case SCHEMA
    case TABLE
}

enum SQLOperation {
    case INSERT
    case SELECT
    case UPDATE
    case DELETE
}

struct SQLColumns {
    var columns: [String]
}

struct SQLValues {
    var values: [String]
}



protocol SQLRequest {
//    var request
}

