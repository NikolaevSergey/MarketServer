//
//  HelloHandler.swift
//  PerfectBase
//
//  Created by Sergey Nikolaev on 15.06.16.
//  Copyright © 2016 Sergey Nikolaev. All rights reserved.
//

import PerfectLib

class IndexPageHandler: PageHandler {
    
    func valuesForResponse(context: MustacheEvaluationContext,
                           collector: MustacheEvaluationOutputCollector) throws -> MustacheEvaluationContext.MapType {
        
        var values = MustacheEvaluationContext.MapType()
        
        values["title"]     = "Perfect Base"
        values["name"]      = "Flatstack"
        
        return values
    }
}

class IndexHandler: RequestHandler {
    
    func handleRequest(request: WebRequest, response: WebResponse) {
        
        response.appendBodyString("Perfect Base")
        
        if let word = request.urlVariables["word"] {
            response.appendBodyString("\nYour word is \(word)")
        }
        response.requestCompletedCallback()
    }
    
}


