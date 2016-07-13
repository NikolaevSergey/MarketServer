//
//  ENUnit.swift
//  MarketServer
//
//  Created by Sergey Nikolaev on 11.07.16.
//  Copyright © 2016 Sergey Nikolaev. All rights reserved.
//

import Foundation

//case Novel          : return "Роман"
//case Child          : return "Детская литература"
//case Fantasy        : return "Фэнтези"
//case Detective      : return "Детектив"
//case ScienceFiction : return "Научная фантастика"
//case PulpFiction    : return "Бульварное чтиво"



enum ENUnit: Int {
    // Fantasy
    case HarryPotter1 = 0
    case HarryPotter2
    // Novel
    case ClockworkingOrange
    case CrimeAndPunishment
    // Child
    case BadAdvices
    case LittlePrince
    // Detective
    case SherlockHolmes
    case TenLittleNiggers
    // Science Fiction
    case TheGodDelusion
    case Mutants
    // Pulp Fiction
    
    var id: Int {return self.rawValue}
    
    var name: String {
        switch self {
            
        case .HarryPotter1: return "Гарри Поттер и Философский камень"
        case .HarryPotter2: return "Гарри Поттер и Тайная комната"
            
        case .ClockworkingOrange: return "Заводной апельсин"
        case .CrimeAndPunishment: return "Преступление и наказание"
            
        case .BadAdvices    : return "Вредные советы"
        case .LittlePrince  : return "Маленький принц"
            
        case .SherlockHolmes    : return "Шерлок Холмс: Полное собрание"
        case .TenLittleNiggers  : return "10 негритят"
            
        case .TheGodDelusion    : return "Бог как иллюзия"
        case .Mutants           : return "Мутанты"
        }
    }
    
    var autor: String {
        switch self {
            
        case .HarryPotter1: return "Джоан Роулинг"
        case .HarryPotter2: return "Джоан Роулинг"
            
        case .ClockworkingOrange: return "Энтони Бёрджесс"
        case .CrimeAndPunishment: return "Федор Достоевский"
            
        case .BadAdvices    : return "Григория Остер"
        case .LittlePrince  : return "Антуан де Сент-Экзюпери"
            
        case .SherlockHolmes    : return "Артур Конан Дойл"
        case .TenLittleNiggers  : return "Агата Кристи"
            
        case .TheGodDelusion    : return "Ричард Докинз"
        case .Mutants           : return "Арман Мари Леруа"
        }
    }
    
    var price: Double {
        switch self {
        case .HarryPotter1: return 350
        case .HarryPotter2: return 250
            
        case .ClockworkingOrange: return 150
        case .CrimeAndPunishment: return 400
            
        case .BadAdvices    : return 300
        case .LittlePrince  : return 240
            
        case .SherlockHolmes    : return 800
        case .TenLittleNiggers  : return 450
            
        case .TheGodDelusion    : return 350
        case .Mutants           : return 320
        }
    }
    
    var category: ENCategory {
        switch self {
        case .HarryPotter1: return .Fantasy
        case .HarryPotter2: return .Fantasy
            
        case .ClockworkingOrange: return .Novel
        case .CrimeAndPunishment: return .Novel
            
        case .BadAdvices    : return .Child
        case .LittlePrince  : return .Child
            
        case .SherlockHolmes    : return .Detective
        case .TenLittleNiggers  : return .Detective
            
        case .TheGodDelusion    : return .ScienceFiction
        case .Mutants           : return .ScienceFiction
        }
    }
    
    var tags: [ENTag] {
        switch self {
        case .HarryPotter1: return [.Bestseller, .Hit, .ParentsChoice, .Foreign]
        case .HarryPotter2: return [.Bestseller, .Hit, .ParentsChoice, .Foreign]
            
        case .ClockworkingOrange: return [.Bestseller, .Adult, .Foreign]
        case .CrimeAndPunishment: return [.School, .Classic, .Domestic]
            
        case .BadAdvices    : return [.School, .ParentsChoice, .Domestic]
        case .LittlePrince  : return [.School, .Foreign, .Bestseller]
            
        case .SherlockHolmes    : return [.Bestseller, .Hit, .School, .ParentsChoice]
        case .TenLittleNiggers  : return [.Hit, .Sale]
            
        case .TheGodDelusion    : return [.Bestseller, .Hit]
        case .Mutants           : return [.Sale]
        }
    }
    
}

extension ENUnit {
    enum Key {
        static let ID           = "id"
        static let Name         = "name"
        static let Autor        = "autor"
        static let Price        = "price"
        
        static let CategoryID   = "category_id"
        static let Tags         = "tags"
    }
}

extension ENUnit: KRSerializable {
    func serialize() -> JSONType {
        return [
            Key.ID : self.id,
            Key.Name: self.name,
            Key.Autor: self.autor,
            Key.Price: self.price,
            Key.CategoryID: self.category.serialize(),
            Key.Tags: self.tags.map({$0.serialize()}) as [Any]
        ]
    }
}




//case Bestseller = 0
//case Hit
//case Sale
//case Adult
//case ParentsChoice
//case School
//case Exams






//class ENUnit {
//    let id: Int
//    var name: String
//    var price: Double
//    var categoryID: Int
//
//    init (name: String, price: Double, categoryID: Int) throws {
//        var id: Int!
//
//        try PostgresOperation { (connection) in
//            let request = SQLBuilder.INSERT(TBUnit.Name, data: [
//                Key.Name : name,
//                Key.Price : price,
//                Key.CategoryID : categoryID
//                ]).RETURNING([Key.ID])
//            let result = try connection.execute(request)
//
//            id = result.getFieldInt(0, fieldIndex: 0)
//        }
//
//        self.id = id
//        self.name = name
//        self.price = price
//        self.categoryID = categoryID
//    }
//
//    init (id: Int) throws {
//
//        var name: String!
//        var price: Double!
//        var categoryID: Int!
//
//        try PostgresOperation({ (connection) in
//            let request = SQLBuilder.SELECT([
//                Key.Name,
//                Key.Price,
//                Key.CategoryID
//                ]).FROM(TBUnit.Name).WHERE("\(ENUnit.Key.ID)=\(id)").LIMIT(1)
//            let result = try connection.execute(request)
//
//            name        = result.getFieldString(0, fieldIndex: 0)
//            price       = result.getFieldDouble(0, fieldIndex: 1)
//            categoryID  = result.getFieldInt(0, fieldIndex: 2)
//        })
//
//        self.id = id
//        self.name = name
//        self.price = price
//        self.categoryID = categoryID
//    }
//
//    func setTags (tags: [ENTag]) {
//        for tag in tags {
//            do {
//                let _ = try ENRUnitTag(unit: self, tag: tag)
//            } catch {}
//        }
//    }
//}

