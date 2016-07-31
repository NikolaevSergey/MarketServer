//
//  ENCategory.swift
//  MarketServer
//
//  Created by Sergey Nikolaev on 11.07.16.
//  Copyright © 2016 Sergey Nikolaev. All rights reserved.
//

import Foundation

enum ENCategory: Int {
    case Novel = 0
    case Child
    case Fantasy
    case Detective
    case ScienceFiction
    case PulpFiction
    
    var id: Int {return self.rawValue}
    
    var name: String {
        switch self {
        case Novel          : return "Роман"
        case Child          : return "Детская литература"
        case Fantasy        : return "Фэнтези"
        case Detective      : return "Детектив"
        case ScienceFiction : return "Научная фантастика"
        case PulpFiction    : return "Бульварное чтиво"
        }
    }
}

extension ENCategory: KRSerializable {
    func serialize () -> JSONType {
        return [
            Key.ID      : self.id,
            Key.Name    : self.name
        ]
    }
}

extension ENCategory {
    enum Key {
        static let ID       = "id"
        static let Name     = "name"
    }
}
