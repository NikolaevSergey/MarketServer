//
//  ENTag.swift
//  MarketServer
//
//  Created by Sergey Nikolaev on 12.07.16.
//  Copyright © 2016 Sergey Nikolaev. All rights reserved.
//

import Foundation

enum ENTag: Int {
    case Bestseller = 0
    case Hit
    case Sale
    case Adult
    case ParentsChoice
    case School
    case Exams
    case Classic
    case Domestic
    case Foreign
    
    var id: Int {return self.rawValue}
    
    var name: String {
        switch self {
        case Bestseller     : return "Бестселлер"
        case Hit            : return "Хит"
        case Sale           : return "Скидки"
        case Adult          : return "18+"
        case ParentsChoice  : return "Выбор родителей"
        case School         : return "Школьная программа"
        case Exams          : return "ЕГЭ/ГИА/ОГЭ"
        case Classic        : return "Классика"
        case Domestic       : return "Отечественная литература"
        case Foreign        : return "Зарубежная литература"
        }
    }
}

extension ENTag {
    enum Key {
        static let ID       = "id"
        static let Name     = "name"
    }
}

extension ENTag: KRSerializable {
    func serialize() -> JSONType {
        return [
            Key.ID      : self.id,
            Key.Name    : self.name
        ]
    }
}
