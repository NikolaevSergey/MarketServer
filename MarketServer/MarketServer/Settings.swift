//
//  Settings.swift
//  MarketServer
//
//  Created by Sergey Nikolaev on 07.07.16.
//  Copyright © 2016 Sergey Nikolaev. All rights reserved.
//

import Foundation

enum Settings {
    
    static func SetupLogger() {
        
        Logger.setup(.Debug, showLogIdentifier: false, showFunctionName: false, showThreadName: true, showLogLevel: false, showFileNames: true, showLineNumbers: true, showDate: true, writeToFile: nil, fileLogLevel: .None)
        
        Logger.dateFormatter?.dateFormat = "HH:mm:ss.SSS"
        Logger.xcodeColorsEnabled = true
        
        print()
    }
}
