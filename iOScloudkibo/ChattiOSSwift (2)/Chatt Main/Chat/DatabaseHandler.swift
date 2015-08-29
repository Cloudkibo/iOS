//
//  DatabaseHandler.swift
//  Chat
//
//  Created by Cloudkibo on 28/08/2015.
//  Copyright (c) 2015 MyAppTemplates. All rights reserved.
//

import Foundation
import SQLite
class DatabaseHandler:NSObject{
    
    var db:Database
    var dbPath:String
    var accounts:Query
    
    init(dbName:String)
    {let docsDir = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).last!
     dbPath = (docsDir as! NSString).stringByAppendingPathComponent("/(dbName)")
        
     self.db = Database(dbPath)
        println(db.description)
        db=Database(dbPath)
        
        accounts = db["accounts"]
        let _id = Expression<String>("id")
        let firstname = Expression<String?>("firstname")
        let lastname = Expression<String?>("lastname")
        let email = Expression<String>("email")
        let phone = Expression<String>("phone")
        let username = Expression<String>("username")
        let status = Expression<String>("status")
        let date = Expression<String>("date")
        let accountVerified = Expression<String>("accountVerified")
        let role = Expression<String>("role")
        
        db.create(table: accounts, ifNotExists: true) { t in
            //t.column(_id, primaryKey: true)
            t.column(email, unique: true,check: like("%@%", email))
            t.column(username, unique: true)
            t.column(phone, unique: true)
        }
       /* insertUser(_id:"abc",
            firstname: "sum",
            lastname: "saeed",
            email: "s@sdf.com",
            username: "sum",
            status: "testing table")*/

    }
    
    func insertUser(_id:Expression<String>,firstname:Expression<String>,lastname:Expression<String>,email:Expression<String>,username:Expression<String>,status:Expression<String>)
    {
        let a=accounts.insert(email<-"\(email)",firstname<-"\(firstname)",lastname<-"\(lastname)",_id<-"\(_id)",status<-"\(status)")
        if let rowid = a.rowid {
            println("inserted id: \(rowid)")
        } else if a.statement.failed {
            println("insertion failed: \(a.statement.reason)")
        }
        
    }
    
}