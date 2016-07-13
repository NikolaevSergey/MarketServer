//
//  Extensions.swift
//  PerfectBase
//
//  Created by Sergey Nikolaev on 16.06.16.
//  Copyright © 2016 Sergey Nikolaev. All rights reserved.
//

import PerfectLib

extension WebResponse {
    
    func setHTTPStatus (status: HTTPStatus) {
        self.setStatus(status.rawValue, message: status.description)
    }
    
    func addContentTypeHeader (type: ResponseContentType) {
        self.addHeader(type.name, value: type.value)
    }
    
    func setAPIError (error: APIErrorProtocol) {
        self.setHTTPStatus(error.status)
        guard let parameters = try? JSONEncoder().encode(error.parameters) else {return}
        self.addContentTypeHeader(.JSON)
        self.appendBodyString(parameters)
    }
    
    func addJSONResponse (response: [String : JSONValue]) throws {
        
        let jsonEncoder = JSONEncoder()
        
        do {
            let responseString = try jsonEncoder.encode(response)
            self.addContentTypeHeader(.JSON)
            self.appendBodyString(responseString)
        } catch let error {
            Logger.error("Encoding error: \(error)")
            throw HTTPStatus._500
        }
    }
    
}

extension String {
    var escaped: String {
        return "'\(self)'"
    }
}

func DictFromStringTuple (tuples: [(String, String)]) -> [String : String] {
    var dict: [String : String] = [:]
    
    for (key, value) in tuples {
        dict.updateValue(value, forKey: key)
    }
    
    return dict
}

// MARK: Raw Representable
public extension RawRepresentable {
    public init?(_ rawValue: RawValue) {
        self.init(rawValue: rawValue)
    }
}

public extension RawRepresentable where Self.RawValue == Int {
    public static var allCases: [Self] {
        var i = -1
        return Array( AnyGenerator{i += 1;return self.init(rawValue: i)})
    }
}

extension NSDate {
    var timestamp: Int {return Int(self.timeIntervalSince1970)}
}

// MARK: - Array
public extension Array {
    
    public mutating func fs_appendIfExist (object: Element?) {
        guard let lObject = object else {return}
        self.append(lObject)
    }
    
    public func fs_objectAtIndexOrNil (index:Int) -> Element? {
        guard index < self.count && index >= 0 else {return nil}
        return self[index]
    }
    
    public func fs_shuffle () -> Array {
        var array:Array = self
        
        for i in 0 ..< array.count {
            let remainingCount = array.count - i
            let exchangeIndex = i + Int(arc4random_uniform(UInt32(remainingCount)))
            
            guard i != exchangeIndex else {continue}
            swap(&array[i], &array[exchangeIndex])
        }
        
        return array
    }
}

public func + <ValueType> (left: Array<ValueType>, right: Array<ValueType>) -> Array<ValueType> {
    var result: Array<ValueType> = left
    for value in right {
        result.append(value)
    }
    return result
}

public func += <ValueType> (inout left: Array<ValueType>, right: Array<ValueType>) {
    for value in right {
        left.append(value)
    }
}

// MARK: - Dictionary
public extension Dictionary {
    
    public mutating func fs_updateIfExist (object: Value?, forKey key: Key) {
        guard let lObject = object else {return}
        self.updateValue(lObject, forKey: key)
    }
    
    public func fs_objectForKey(key:Key, orDefault def:Value) -> Value {
        guard let value = self[key] else {return def}
        return value
    }
    
}

public func + <KeyType, ValueType> (left: Dictionary<KeyType, ValueType>, right: Dictionary<KeyType, ValueType>) -> Dictionary<KeyType, ValueType> {
    var result: Dictionary<KeyType, ValueType> = left
    for (k, v) in right {
        result.updateValue(v, forKey: k)
    }
    return result
}

public func += <KeyType, ValueType> (inout left: Dictionary<KeyType, ValueType>, right: Dictionary<KeyType, ValueType>) {
    for (k, v) in right {
        left.updateValue(v, forKey: k)
    }
}
