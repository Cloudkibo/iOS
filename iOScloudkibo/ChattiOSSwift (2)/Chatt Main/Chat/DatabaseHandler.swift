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
    var db:Connection!
    //var db:Database
    var dbPath:String
    var accounts:Table!
    var contactslists:Table!
    var userschats:Table!
    
    init(dbName:String)
    {print("inside database handler class")
        
        let fileManager = NSFileManager.defaultManager()
        let dirPaths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let docsDir1 = dirPaths[0] 
        self.dbPath = (docsDir1 as NSString).stringByAppendingPathComponent("cloudKiboDatabase2.sqlite3")
        
        ////////self.db = Database(dbPath)
                do {
            self.db = try Connection(dbPath)
                    print(db.description)

        }
        catch{
            print("Database Connection failed")
        }
        /////////db=Database(dbPath)
       
         super.init()
        /* insertUser(_id:"abc",
        firstname: "sum",
        lastname: "saeed",
        email: "s@sdf.com",
        username: "sum",
        status: "testing table")*/
        
        createAccountsTable()
        ///////contactslists.drop()
        createContactListsTable()
        createUserChatTable()
        
    }
    
    func createAccountsTable()
    {
        socketObj.socket.emit("logClient","creating accounts table")
        
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
        
        
        self.accounts = Table("accounts")
        do{
            try db.run(accounts.create(ifNotExists: true) { t in     // CREATE TABLE "accounts" (
                t.column(email, unique: true,check: email.like("%@%"))
                t.column(firstname)
                t.column(lastname)
                t.column(_id)
                t.column(status)
                t.column(username, unique: true)
                t.column(phone, unique: true)

                
                //     "name" TEXT
                })
            
        }
        catch
        {
            socketObj.socket.emit("logClient","error in creating accounts table \(error)")
            print("error in creating accounts table")
        }
        
       /* self.accounts = db["accounts"]
        
        //^^^^^self.accounts.delete()
        db.create(table: self.accounts, ifNotExists: true)
            {t in
            //t.column(_id, primaryKey: true)
            t.column(email, unique: true,check: like("%@%", email))
            t.column(firstname)
            t.column(lastname)
            t.column(_id)
            t.column(status)
            t.column(username, unique: true)
            t.column(phone, unique: true)
        }*/
    }
    
    func createContactListsTable()
    {
           socketObj.socket.emit("logClient","creating contacts table")
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
        
        self.contactslists = Table("contactslists")
        do{
        try db.run(contactslists.create(ifNotExists: true){ t in     // CREATE TABLE "users" (
            t.column(contactid)//loggedin user id
            t.column(detailsshared)
            
            t.column(unreadMessage)
            t.column(userid) //id of friend
            t.column(firstname)
            t.column(lastname)
            t.column(email, unique: true, check: email.like("%@%"))
            t.column(phone)
            t.column(username)
            t.column(status)
            
            //     "name" TEXT
            })
            
        }
        catch
        {
            socketObj.socket.emit("logClient","error in creating contacts table \(error)")
            print("error in creating contactslists table")
        }
        // )
        
        /*self.contactslists = db["contactslists"]
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
            
            
            
        }*/
        
        
        
    }
    
    func createUserChatTable(){
        
           socketObj.socket.emit("logClient","creating chat table")
        
        let to = Expression<String>("to")
        let from = Expression<String>("from")
        let fromFullName = Expression<String>("fromFullName")
        let msg = Expression<String>("msg")
        //let owneruser = Expression<String>("owneruser")
        let date = Expression<NSDate>("date")
        
        self.userschats = Table("userschats")
        do{
            try db.run(userschats.create(ifNotExists: true) { t in     // CREATE TABLE "accounts" (
                t.column(to)//loggedin user id
                t.column(from)
                t.column(fromFullName)
                t.column(msg)
                
                
                //     "name" TEXT
                })
            
        }
        catch(let error)
        {
            socketObj.socket.emit("logClient","error in creating chat table \(error)")
            print("error in creating userschats table")
        }
        
        /*self.userschats = db["userschats"]
        
        //db.drop(table: self.userschats)
        
        db.create(table: self.userschats, ifNotExists: true) { t in
            
            t.column(to)//loggedin user id
            t.column(from)
            t.column(fromFullName)
            t.column(msg)
            //t.column(owneruser)
            //t.column(date as )
            //t.column(unreadMessage)
        }*/
    }
    /*func insertUser(_id:String,firstname:String,lastname:Expression<String>,email:Expression<String>,username:Expression<String>,status:Expression<String>)
    {
    let a=accounts.insert(email<-email,
    firstname<-firstname,
    lastname<-lastname,
    _id<-_id,
    status<-status)
    if let rowid = a.rowid {
    print("inserted id: \(rowid)")
    } else if a.statement.failed {
    print("insertion failed: \(a.statement.reason)")
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
        var tbl_userchats=sqliteDB.userschats
        
        
        //////var tbl_userchats=sqliteDB.db["userschats"]
        
        /*let insert=tbl_userchats.insert(fromFullName<-fromFullName1,
            msg<-msg1,
            to<-to1,
            from<-from1
        )*/
        
        
        do {
            let rowid = try db.run(tbl_userchats.insert(fromFullName<-fromFullName1,
                msg<-msg1,
                to<-to1,
                from<-from1
))
            print("inserted id: \(rowid)")
        } catch {
            print("insertion failed: \(error)")
        }
        
        
        /*if let rowid = insert.rowid {
            print("inserted id: \(rowid)")
        } else if insert.statement.failed {
            print("insertion failed: \(insert.statement.reason)")
        }*/
        
        
    }
    func retrieveChat()
    {
        
        let to = Expression<String>("to")
        let from = Expression<String>("from")
        let fromFullName = Expression<String>("fromFullName")
        let msg = Expression<String>("msg")
        let date = Expression<NSDate>("date")
        
        var tbl_userchats=sqliteDB.userschats
        /////var tbl_userchats=sqliteDB.db["userschats"]

    }
    func deleteChat(userTo:String)
    {
        let to = Expression<String>("to")
        let from = Expression<String>("from")
        
        var tbl_userchats=sqliteDB.userschats
        /////var tbl_userchats=sqliteDB.db["userschats"]
        var n=tbl_userchats.filter(to==userTo).delete()
        tbl_userchats.filter(from==userTo).delete()
     
        
        /*let alice = users.filter(id == 1)
        try db.run(alice.delete())
        // DELETE FROM "users" WHERE ("id" = 1)
*/
        
    }

    func deleteFriend(user:String)
    {
    let username = Expression<String>("username")
       // print("sqlitedb queryyy"+self.contactslists.filter(username==user).description)
    ////self.contactslists.filter(username==user).delete().changes!
        self.contactslists.filter(username==user).delete()
        deleteChat(user)
        
    
    }

}