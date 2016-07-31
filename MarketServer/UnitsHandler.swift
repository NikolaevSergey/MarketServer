//
//  UnitsHandler.swift
//  MarketServer
//
//  Created by Sergey Nikolaev on 13.07.16.
//  Copyright © 2016 Sergey Nikolaev. All rights reserved.
//

import Foundation
import PerfectLib

extension Handler.Unit {
    
    class UnitsHandler: KRHandlerProtocol {
        
        typealias QueryType = UnitsQuery
        
        static let requestType: RequestType = .GET
        
        func kr_handleRequest(queryObject: QueryType, request: WebRequest, response: WebResponse) throws {
            
            guard let category = ENCategory(rawValue: queryObject.categoryID) else {throw HTTPStatus._404}
            
            let units = ENUnit.allCases.filter({$0.category == category}).sort({$0.0.name < $0.1.name}).map({$0.serialize()}) as [JSONValue]
            
            try response.addJSONResponse(["units" : units])
            response.setHTTPStatus(._200)
        }
    }
    
    struct UnitsQuery: KRQueryObject {
        let categoryID: Int
        
        init (query: [String : String], request: WebRequest) throws {
            guard let category = request.urlVariables["category_id"], categoryID = Int(category) else {throw HTTPStatus._400}
            self.categoryID = categoryID
        }
    }
    
    //===
    
    class UnitsSearchHandler: KRHandlerProtocol {
        typealias QueryType = UnitsSearchQuery
        
        static let requestType: RequestType = .GET
        
        func kr_handleRequest(queryObject: QueryType, request: WebRequest, response: WebResponse) throws {
            
            let units = queryObject.getUnits().map({$0.serialize()}) as [JSONValue]
            
            try response.addJSONResponse(["units" : units])
            response.setHTTPStatus(._200)
        }
    }
    
    struct UnitsSearchQuery: KRQueryObject {
        let category        : ENCategory?
        let tags            : [ENTag]?
        let priceMin        : Double?
        let priceMax        : Double?
        let searchString    : String?
        
        init (query: [String : String], request: WebRequest) throws {
            
            
            if let categoryIDString = query["category_id"] {
                guard let categoryID = Int(categoryIDString), category = ENCategory(rawValue: categoryID) else {throw HTTPStatus._400}
                self.category = category
            } else {self.category = nil}
            
            if let tagsString = query["tag_ids"] {
                
                var tags: [ENTag] = []
                
                try tagsString.componentsSeparatedByString(",").forEach({
                    guard let id = Int($0) else {throw HTTPStatus._400}
                    guard let tag = ENTag(rawValue: id) else {throw HTTPStatus._400}
                    tags.append(tag)
                })
                
                self.tags = tags
                
            } else {self.tags = nil}
            
            if let priceMinString = query["price_min"] {
                guard let priceMin = Double(priceMinString) else {throw HTTPStatus._400}
                self.priceMin = priceMin
            } else {self.priceMin = nil}
            
            if let priceMaxString = query["price_max"] {
                guard let priceMax = Double(priceMaxString) else {throw HTTPStatus._400}
                self.priceMax = priceMax
            } else {self.priceMax = nil}
            
            self.searchString = query["s"]
        }
        
        func getUnits () -> [ENUnit] {
            
            var units = ENUnit.allCases
            
            if let category = self.category {
                units = ENUnit.allCases.filter({$0.category.id == category.id})
            }
            
            if let tags = self.tags {
                units = units.filter({
                    for tag in $0.tags {
                        guard tags.contains(tag) else {continue}
                        return true
                    }
                    return false
                })
            }
            
            if let priceMin = self.priceMin {
                units = units.filter({$0.price > priceMin})
            }
            
            if let priceMax = self.priceMax {
                units = units.filter({$0.price < priceMax})
            }
            
            if let searchString = self.searchString {
                let words = searchString.componentsSeparatedByString(" ")
                units = units.filter({
                    let unitWords = $0.autor.componentsSeparatedByString(" ") + $0.name.componentsSeparatedByString(" ")
                    for word in unitWords {
                        guard words.contains(word) else {continue}
                        return true
                    }
                    return false
                })
            }
            
            return units.sort({$0.0.name < $0.1.name})
        }
    }
    
}
