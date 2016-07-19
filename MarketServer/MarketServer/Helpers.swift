//
//  Helpers.swift
//  MarketServer
//
//  Created by Sergey Nikolaev on 14.07.16.
//  Copyright © 2016 Sergey Nikolaev. All rights reserved.
//

import Foundation

class IndexGenerator {
    
    let startIndex: Int
    private(set) var currentIndex: Int
    
    init (startIndex: Int = 0) {
        self.startIndex = startIndex
        self.currentIndex = startIndex
    }
    
    func generate () -> Int {
        defer {self.currentIndex += 1}
        return self.currentIndex
    }
    
}
