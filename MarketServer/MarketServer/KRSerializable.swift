//
//  KRSerializable.swift
//  MarketServer
//
//  Created by Sergey Nikolaev on 09.07.16.
//  Copyright © 2016 Sergey Nikolaev. All rights reserved.
//

import Foundation
import PerfectLib

typealias JSONType = [String : JSONValue]

protocol KRSerializable {
    func serialize () -> JSONType
}
