//
//  DBUser.swift
//  PerfectBase
//
//  Created by Sergey Nikolaev on 16.06.16.
//  Copyright © 2016 Sergey Nikolaev. All rights reserved.
//

import PerfectLib

class ENUser {
    let id: Int
    
    var password: String
    
    var firstName   : String
    var lastName    : String
    var email       : String
    var phone       : String?
    
    init (id: Int) throws {
        
        var firstName   = ""
        var lastName    = ""
        var password    = ""
        var email       = ""
        
        var phone: String?
        
        try PostgresOperation({ (connection) in
            
            do {
                let request = SQLBuilder.SELECT([
                    ENUser.Key.firstName,
                    ENUser.Key.lastName,
                    ENUser.Key.password,
                    ENUser.Key.email, ENUser.Key.phone]).FROM(TBUser.Name).WHERE("id=\(id)").LIMIT(1)
                let result = try connection.execute(request)
                
                firstName   = result.getFieldString(0, fieldIndex: 0)
                lastName    = result.getFieldString(0, fieldIndex: 1)
                password    = result.getFieldString(0, fieldIndex: 2)
                email       = result.getFieldString(0, fieldIndex: 3)
                phone       = result.getFieldString(0, fieldIndex: 4)
            } catch let error as PGConnectionError {
                if case .ReturnedEmpty = error {
                    throw ENError.NotFound
                }
            }
            
            
        })
        
        self.id = id
        self.firstName  = firstName
        self.lastName   = lastName
        self.email      = email
        self.password   = password
        self.phone      = phone
    }
    
    init (email: String) throws {
        
        var id          : Int!
        var firstName   : String!
        var lastName    : String!
        var password    : String!
        
        var phone: String?
        
        try PostgresOperation({ (connection) in
            
            do {
                let request = SQLBuilder.SELECT([
                    Key.id,
                    Key.firstName,
                    Key.lastName,
                    Key.password,
                    Key.phone]).FROM(TBUser.Name).WHERE("email=\(email.escaped)").LIMIT(1)
                let result = try connection.execute(request)
                
                id          = result.getFieldInt(0, fieldIndex: 0)
                firstName   = result.getFieldString(0, fieldIndex: 1)
                lastName    = result.getFieldString(0, fieldIndex: 2)
                password    = result.getFieldString(0, fieldIndex: 3)
                phone       = result.getFieldString(0, fieldIndex: 4)
            } catch let error as PGConnectionError {
                if case .ReturnedEmpty = error {
                    throw ENError.NotFound
                }
            }
            
            
        })
        
        self.id = id
        self.firstName  = firstName
        self.lastName   = lastName
        self.email      = email
        self.password   = password
        self.phone      = phone
    }
    
    init (firstName: String, lastName: String, email: String, password: String, phone: String? = nil) throws {
        self.firstName  = firstName
        self.lastName   = lastName
        self.email      = email
        self.password   = password
        self.phone      = phone
        
        var id: Int?
        
        try PostgresOperation({ (connection) in
            
            var values: [String : Any] = [
                Key.firstName : firstName,
                Key.lastName : lastName,
                Key.email : email,
                Key.password : password
            ]
            
            if let lPhone = phone {
                values.updateValue(lPhone, forKey: Key.phone)
            }
            
            let request = SQLBuilder.INSERT(TBUser.Name, data: values).RETURNING(["id"])
            let result = try connection.execute(request)
            id = result.getFieldInt(0, fieldIndex: 0)
        })
        
        guard let lId = id else {throw ENError.Unknown}
        self.id = lId
    }
    
    // MARK: - KRSerializable
    
    convenience required init (dict: [String : Any]) throws {
        guard   let firstName   = dict[Key.firstName] as? String,
            lastName    = dict[Key.lastName] as? String,
            email       = dict[Key.email] as? String,
            password    = dict[Key.password] as? String  else {throw ENError.RequiredFieldsMissing}
        
        let phone = dict[Key.phone] as? String
        
        try self.init(firstName: firstName, lastName: lastName, email: email, password: password, phone: phone)
    }
}

extension ENUser: KRSerializable {
    func serialize () -> JSONType {
        var dict: JSONType = [
            Key.id : self.id,
            Key.firstName : self.firstName,
            Key.lastName : self.lastName,
            Key.email : self.email,
            ]
        
        if let lPhone = self.phone {
            dict.updateValue(lPhone, forKey: Key.phone)
        }
        
        return dict
    }
}

extension ENUser {
    enum Key {
        static let id         = "id"
        static let firstName  = "first_name"
        static let lastName   = "last_name"
        static let email      = "email"
        static let password   = "password"
        static let phone      = "phone"
    }
}
