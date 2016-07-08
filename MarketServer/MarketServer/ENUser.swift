//
//  DBUser.swift
//  PerfectBase
//
//  Created by Sergey Nikolaev on 16.06.16.
//  Copyright © 2016 Sergey Nikolaev. All rights reserved.
//

import PerfectLib

class ENUser {
//    let id: Int
//    
//    var password: String
//    
//    var firstName: String
//    var lastName: String
//    var email: String
//    var phone: String
//    
//    init (id: Int) throws {
//        
//        var firstName   : String = ""
//        var lastName    : String = ""
//        
//        try PostgresOperation({ (connection) in
//            
//            do {
//                let result = try connection.execute("SELECT first_name, last_name, email, phone FROM public.user WHERE id=\(id) LIMIT 1")
//                
//                firstName = result.getFieldString(0, fieldIndex: 0)
//                lastName = result.getFieldString(0, fieldIndex: 1)
//            } catch let error as PGConnectionError {
//                if case .ReturnedEmpty = error {
//                    throw DBUserError.NotFound
//                }
//            }
//            
//            
//        })
//    }
}

enum DBUserError: ErrorType {
    case NotFound
}


//
//class DBUser {
//    let id          : Int
//    let firstName   : String
//    let lastName    : String
//    
//    init (id: Int) throws {
//        
//        var firstName   : String = ""
//        var lastName    : String = ""
//        
//        try PostgresOperation({ (connection) in
//            
//            do {
//                let result = try connection.execute("SELECT first_name, last_name FROM public.user WHERE id=\(id) LIMIT 1")
//                
//                firstName = result.getFieldString(0, fieldIndex: 0)
//                lastName = result.getFieldString(0, fieldIndex: 1)
//            } catch let error as PGConnectionError {
//                if case .ReturnedEmpty = error {
//                    throw DBUserError.NotFound
//                }
//            }
//            
//            
//        })
//
//        self.firstName  = firstName
//        self.lastName   = lastName
//        self.id         = id
//    }
//    
//    init (firstName: String, lastName: String) throws {
//        
//        var id: Int = 0
//        
//        try PostgresOperation({ (connection) in
//            let result = try connection.execute("INSERT INTO public.user (first_name,last_name) VALUES ('\(firstName)', '\(lastName)') RETURNING id")
//            
//            id = result.getFieldInt(0, fieldIndex: 0)
//        })
//        
//        self.firstName  = firstName
//        self.lastName   = lastName
//        self.id         = id
//    }
//}
