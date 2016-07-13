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
        }
    }
}

//struct ENTag {
//    let id: Int
//    let name: String
//    
//    init (id: Int, name: String) {
//        self.id = id
//        self.name = name
//    }
//    
//    private init (generator: IndexGenerator, name: String) {
//        self.id = generator.generate()
//        self.name = name
//    }
//}
//
//extension ENTag {
//    static var All: [ENTag] = {
//        let generator = IndexGenerator(inital: 0)
//        
//        return [
//            ENTag(generator: generator, name: "Бестселлер"),
//            ENTag(generator: generator, name: "Хит"),
//            ENTag(generator: generator, name: "Скидки"),
//            ENTag(generator: generator, name: "18+"),
//            ENTag(generator: generator, name: "Выбор родителей"),
//            ENTag(generator: generator, name: ""),
//            ENTag(generator: generator, name: ""),
//            ENTag(generator: generator, name: "")
//        ]
//    }()
//}
//
//private class IndexGenerator {
//    let inital: Int
//    private var current: Int
//    
//    init (inital: Int) {
//        self.inital = inital
//        self.current = inital
//    }
//    
//    func generate () -> Int {
//        let value = self.current
//        self.current += 1
//        return value
//    }
//}
