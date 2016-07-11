//
//  Settings.swift
//  MarketServer
//
//  Created by Sergey Nikolaev on 07.07.16.
//  Copyright © 2016 Sergey Nikolaev. All rights reserved.
//

import Foundation

enum Settings {
    
    static func SetupLogger() {
        
        Logger.setup(.Debug, showLogIdentifier: false, showFunctionName: false, showThreadName: true, showLogLevel: false, showFileNames: true, showLineNumbers: true, showDate: true, writeToFile: nil, fileLogLevel: .None)
        
        Logger.dateFormatter?.dateFormat = "HH:mm:ss.SSS"
        Logger.xcodeColorsEnabled = true
        
        print()
    }
}

func SetupPostgreSQLTables () {
    
    let userQuery = TBUser.generateCreatingQuery()
    let tokenQuery = TBToken.generateCreatingQuery()
    
    do {
        try PostgresOperation({ (connection) in
            try connection.execute(userQuery)
            try connection.execute(tokenQuery)
        })
    } catch let error as PGConnectionError {
        Logger.severe("\(error)")
    } catch let error {
        Logger.severe("\(error)")
    }
}

//    do {

//    } catch

//    let frame       = TableFrame().generateCreatingQuery()
//    let cluster     = TableCluster().generateCreatingQuery()
//    let point       = TablePoint().generateCreatingQuery()
//    let group       = TableGroup().generateCreatingQuery()
//    let image       = TableImage().generateCreatingQuery()

//    do {
//        try PostgresOperation { (connection) in
//            do {
//                try connection.execute(frame)
//                try connection.execute(cluster)
//                try connection.execute(point)
//                try connection.execute(group)
//                try connection.execute(image)
//            } catch let error {
//                print(error)
//            }
//        }
//    } catch let error {
//        print(error)
//    }
//}

//let JSONDatabaseSnapshot: String = {
//    let framesArray     = ENFrame.getAll().map({$0.toJSON()})       as Array<JSONValue>
//    let clustersArray   = ENCluster.getAll().map({$0.toJSON()})     as Array<JSONValue>
//    let pointsArray     = ENPoint.getAll().map({$0.toJSON()})       as Array<JSONValue>
//    let groupsArray     = ENGroup.getAll().map({$0.toJSON()})       as Array<JSONValue>
//    let imagesArray     = ENImage.getAll().map({$0.toJSON()})       as Array<JSONValue>
//
//    let responseString = try! JSONEncoder().encode([
//        "frames"    : framesArray,
//        "clusters"  : clustersArray,
//        "points"    : pointsArray,
//        "groups"    : groupsArray,
//        "images"    : imagesArray
//        ])
//
//    return responseString
//}()

//class JSONHandler: KRHandlerProtocol {
//    let requestType         : RequestType           = .GET
//    let responseContentType : ResponseContentType   = .JSON
//
//    func kr_handleRequest(query: [String : String], request: WebRequest, response: WebResponse) throws {
//
//        response.addContentTypeHeader(.JSON)
////        response.appendBodyString(JSONDatabaseSnapshot)
//        response.setHTTPStatus(._200)
//    }
//}
