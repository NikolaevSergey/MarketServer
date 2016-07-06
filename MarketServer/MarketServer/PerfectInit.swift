//
//  PerfectInit.swift
//  PerfectBase
//
//  Created by Sergey Nikolaev on 16.06.16.
//  Copyright © 2016 Sergey Nikolaev. All rights reserved.
//

import PerfectLib

public func PerfectServerModuleInit() {
    
    Routing.Handler.registerGlobally()
    
    // MARK: Users
    Routing.Routes["GET", ["/snapshot"]]   = {(_:WebResponse) in return JSONHandler()}
    
    SetupPostgreSQLTables()
    
}

func SetupPostgreSQLTables () {
    let frame       = TableFrame().generateCreatingQuery()
    let cluster     = TableCluster().generateCreatingQuery()
    let point       = TablePoint().generateCreatingQuery()
    let group       = TableGroup().generateCreatingQuery()
    let image       = TableImage().generateCreatingQuery()
    
    do {
        try PostgresOperation { (connection) in
            do {
                try connection.execute(frame)
                try connection.execute(cluster)
                try connection.execute(point)
                try connection.execute(group)
                try connection.execute(image)
            } catch let error {
                print(error)
            }
        }
    } catch let error {
        print(error)
    }
}

let JSONDatabaseSnapshot: String = {
    let framesArray     = ENFrame.getAll().map({$0.toJSON()})       as Array<JSONValue>
    let clustersArray   = ENCluster.getAll().map({$0.toJSON()})     as Array<JSONValue>
    let pointsArray     = ENPoint.getAll().map({$0.toJSON()})       as Array<JSONValue>
    let groupsArray     = ENGroup.getAll().map({$0.toJSON()})       as Array<JSONValue>
    let imagesArray     = ENImage.getAll().map({$0.toJSON()})       as Array<JSONValue>
    
    let responseString = try! JSONEncoder().encode([
        "frames"    : framesArray,
        "clusters"  : clustersArray,
        "points"    : pointsArray,
        "groups"    : groupsArray,
        "images"    : imagesArray
        ])
    
    return responseString
}()

class JSONHandler: KRHandlerProtocol {
    let requestType         : RequestType           = .GET
    let responseContentType : ResponseContentType   = .JSON
    
    func kr_handleRequest(query: [String : String], request: WebRequest, response: WebResponse) throws {
        
        response.addContentTypeHeader(.JSON)
        response.appendBodyString(JSONDatabaseSnapshot)
        response.setHTTPStatus(._200)
    }
}
