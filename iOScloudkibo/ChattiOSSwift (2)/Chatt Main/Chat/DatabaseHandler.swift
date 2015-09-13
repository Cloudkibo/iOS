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
    var accounts:Query!
    var contactslists:Query!
    var userschats:Query!
    
    init(dbName:String)
    {
        
        /* let fileManager = NSFileManager.defaultManager()
        let dirPaths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        
        let docsDir1 = dirPaths[0] as! String
        
        let pathForDB = NSBundle.mainBundle().resourcePath!.stringByAppendingPathComponent("myNewDatabase.sqlite3")
        
        var databasePath = docsDir1.stringByAppendingPathComponent("myNewDatabase.sqlite3")
        
        self.db = Database(databasePath)*/
        
        // super.init()
        let docsDir = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).last!
        dbPath = (docsDir as! NSString).stringByAppendingPathComponent("/cloudkibo")
        
        self.db = Database(dbPath)
        println(db.description)
        db=Database(dbPath)
        super.init()
        
        /* insertUser(_id:"abc",
        firstname: "sum",
        lastname: "saeed",
        email: "s@sdf.com",
        username: "sum",
        status: "testing table")*/
        
        createAccountsTable()
        db.drop(table: self.db["contactslists"])
        createContactListsTable()
        createUserChatTable()
    }
    
    func createAccountsTable()
    {
        
        
        let _id = Expression<String>("_id")
        let firstname = Expression<String>("firstname")
        let lastname = Expression<String>("lastname")
        let email = Expression<String>("email")
        let phone = Expression<String>("phone")
        let username = Expression<String>("username")
        let status = Expression<String>("status")
        let date = Expression<String>("date")
        let accountVerified = Expression<String>("accountVerified")
        let role = Expression<String>("role")
        
        self.accounts = db["accounts"]
        
        self.accounts.delete()
        db.create(table: self.accounts, ifNotExists: true) { t in
            //t.column(_id, primaryKey: true)
            t.column(email, unique: true,check: like("%@%", email))
            t.column(firstname)
            t.column(lastname)
            t.column(_id)
            t.column(status)
            t.column(username, unique: true)
            t.column(phone, unique: true)
        }
    }
    
    func createContactListsTable()
    {
        //let _id = Expression<String>("_id")
        let contactid = Expression<String>("contactid")
        let detailsshared = Expression<String>("detailsshared")
        let unreadMessage = Expression<Bool>("unreadMessage")
        
        let userid = Expression<String>("userid")
        let firstname = Expression<String>("firstname")
        let lastname = Expression<String>("lastname")
        let email = Expression<String>("email")
        let phone = Expression<String>("phone")
        let username = Expression<String>("username")
        let status = Expression<String>("status")
        
        
        self.contactslists = db["contactslists"]
        //self.contactslists.delete()
        db.create(table: self.contactslists, ifNotExists: true) { t in
            //t.column(_id, primaryKey: true)
            
            //t.column(_id)
            t.column(contactid)//loggedin user id
            t.column(detailsshared)
            
            t.column(unreadMessage)
            t.column(userid) //id of friend
            t.column(firstname)
            t.column(lastname)
            t.column(email, unique: true,check: like("%@%", email))
            t.column(phone)
            t.column(username)
            t.column(status)
            
            
            
        }
        
        
        
    }
    
    func createUserChatTable(){
        
        
        let to = Expression<String>("to")
        let from = Expression<String>("from")
        let fromFullName = Expression<String>("fromFullName")
        let msg = Expression<String>("msg")
        //let owneruser = Expression<String>("owneruser")
        let date = Expression<NSDate>("date")
        
        self.userschats = db["userschats"]
        
        //db.drop(table: self.userschats)
        
        db.create(table: self.userschats, ifNotExists: true) { t in
            
            t.column(to)//loggedin user id
            t.column(from)
            t.column(fromFullName)
            t.column(msg)
            //t.column(owneruser)
            //t.column(date as )
            //t.column(unreadMessage)
        }
    }
    /*func insertUser(_id:String,firstname:String,lastname:Expression<String>,email:Expression<String>,username:Expression<String>,status:Expression<String>)
    {
    let a=accounts.insert(email<-email,
    firstname<-firstname,
    lastname<-lastname,
    _id<-_id,
    status<-status)
    if let rowid = a.rowid {
    println("inserted id: \(rowid)")
    } else if a.statement.failed {
    println("insertion failed: \(a.statement.reason)")
    }
    
    }*/
    
    func SaveChat(to1:String,from1:String,fromFullName1:String,msg1:String)
    {
        //createUserChatTable()
        
        let to = Expression<String>("to")
        let from = Expression<String>("from")
        let fromFullName = Expression<String>("fromFullName")
        let msg = Expression<String>("msg")
        let date = Expression<NSDate>("date")
        
        var tbl_userchats=sqliteDB.db["userschats"]
        
        let insert=tbl_userchats.insert(fromFullName<-fromFullName1,
            msg<-msg1,
            to<-to1,
            from<-from1
        )
        if let rowid = insert.rowid {
            //println("inserted id: \(rowid)")
        } else if insert.statement.failed {
            println("insertion failed: \(insert.statement.reason)")
        }
        
        
    }
    func retrieveChat()
    {
        
    }
    func deleteChat(userTo:String)
    {
        let to = Expression<String>("to")
        self.userschats.filter(to==userTo).delete()
        
    }
    
}