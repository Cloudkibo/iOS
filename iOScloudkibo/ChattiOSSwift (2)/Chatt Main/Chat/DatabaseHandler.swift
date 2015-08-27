//
//  DatabaseHandler.swift
//  Chat
//
//  Created by Cloudkibo on 27/08/2015.
//  Copyright (c) 2015 MyAppTemplates. All rights reserved.
//

import Foundation
import SQLite

let path = NSSearchPathForDirectoriesInDomains(
    .DocumentDirectory, .UserDomainMask, true
    ).first as! String

let db = Database("\(path)/db.sqlite3")