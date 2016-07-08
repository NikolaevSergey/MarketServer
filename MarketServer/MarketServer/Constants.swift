//
//  Constants.swift
//  PerfectBase
//
//  Created by Sergey Nikolaev on 15.06.16.
//  Copyright © 2016 Sergey Nikolaev. All rights reserved.
//

import PerfectLib

let DB_PATH = PerfectServer.staticPerfectServer.homeDir() + serverSQLiteDBs + "PWSDB"
//let TokenExperationTime: NSTimeInterval = 0

var Logger: XCGLogger {return XCGLogger.defaultInstance()}
