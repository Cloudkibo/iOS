//
//  DatabaseHandler.swift
//  Chat
//
//  Created by Cloudkibo on 28/08/2015.
//  Copyright (c) 2015 MyAppTemplates. All rights reserved.
//

import Foundation
import SQLite
import Contacts
class DatabaseHandler:NSObject{
    var db:Connection!
    //var db:Database
    var dbPath:String
    var accounts:Table!
    var contactslists:Table!
    var userschats:Table!
    var allcontacts:Table!
    
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
        createAllContactsTable()
        ///////contactslists.drop()
        createContactListsTable()
        createUserChatTable()
        createAllContactsTable()
        
    }
    
    func createAccountsTable()
    {
        socketObj.socket.emit("logClient","IPHONE-LOG: creating accounts table")
        
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
                t.column(email,check: email.like("%@%"))
                t.column(firstname)
                t.column(lastname)
                t.column(_id)
                t.column(status)
                t.column(username)
                ///t.column(username, unique: true)
                t.column(phone, unique: true)

                
                //     "name" TEXT
                })
            
        }
        catch
        {
            socketObj.socket.emit("logClient","IPHONE-LOG: error in creating accounts table \(error)")
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
           socketObj.socket.emit("logClient","IPHONE-LOG: creating contacts table")
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
            t.column(email,check: email.like("%@%"))
            t.column(phone,unique: true)
            t.column(username)
            t.column(status)
            
            //     "name" TEXT
            })
            
        }
        catch
        {
            socketObj.socket.emit("logClient","IPHONE-LOG: error in creating contacts table \(error)")
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
    
    func createAllContactsTable(){
        
        socketObj.socket.emit("logClient","IPHONE-LOG: creating allcontacts table")
        //let contactObject=Expression<CNContact>("contactObj")
        //let kiboContact = Expression<Bool>("kiboContact")
        let name = Expression<String>("name")
        let phone = Expression<String>("phone")
        //let email = Expression<String>("email")
        let kiboContact = Expression<Bool>("kiboContact")
        
        self.allcontacts = Table("allcontacts")
        do{
            try db.run(allcontacts.create(ifNotExists: true) { t in     // CREATE TABLE "accounts" (
                t.column(name)
                t.column(phone)
                t.column(kiboContact, defaultValue:false)
                })
            
        }
        catch(let error)
        {
            socketObj.socket.emit("logClient","IPHONE-LOG: error in creating allcontacts table \(error)")
            print("error in creating allcontacts table")
        }
    }
    
    func createUserChatTable(){
        
           socketObj.socket.emit("logClient","IPHONE-LOG: creating chat table")
        
        let to = Expression<String>("to")
        let from = Expression<String>("from")
        let fromFullName = Expression<String>("fromFullName")
        let msg = Expression<String>("msg")
        let owneruser = Expression<String>("owneruser")
        let date = Expression<String>("date")
        
        self.userschats = Table("userschats")
        do{
            try db.run(userschats.create(ifNotExists: true) { t in     // CREATE TABLE "accounts" (
                t.column(to)//loggedin user id
                t.column(from)
                t.column(owneruser)
                t.column(fromFullName)
                t.column(msg)
                t.column(date, defaultValue:NSDate().debugDescription)
                
                
                //     "name" TEXT
                })
            
        }
        catch(let error)
        {
            socketObj.socket.emit("logClient","IPHONE-LOG: error in creating chat table \(error)")
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
    func saveAllContacts(name1:String,phone1:String,kiboContact1:Bool)
    {
        // let contactObject=Expression<CNContact>("contactObj")
        let name = Expression<String>("name")
        let phone = Expression<String>("phone")
       // let email = Expression<String>("email")

        let kiboContact = Expression<Bool>("kiboContact")

        var tbl_allcontacts=sqliteDB.allcontacts
        
        do {
            let rowid = try db.run(tbl_allcontacts.insert(
                name<-name1,
                phone<-phone1,
                kiboContact<-kiboContact1
                ))
            socketObj.socket.emit("logClient","IPHONE-LOG: all contacts saved in sqliteDB")
            print("inserted id allcontacts : \(rowid)")
        } catch {
            print("insertion failed: allcontacts \(error)")
        }
        


    }
    
    func SaveChat(to1:String,from1:String,owneruser1:String,fromFullName1:String,msg1:String,date1:String)
    {
        //createUserChatTable()
        
        let to = Expression<String>("to")
        let from = Expression<String>("from")
        let owneruser = Expression<String>("owneruser")
        let fromFullName = Expression<String>("fromFullName")
        let msg = Expression<String>("msg")
        let date = Expression<String>("date")
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
                owneruser<-owneruser1,
                to<-to1,
                from<-from1,
                date<-date1
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
    func retrieveChat(owneruser1:String)
    {
        
        let to = Expression<String>("to")
        let from = Expression<String>("from")
        let owneruser = Expression<String>("owneruser")
        let fromFullName = Expression<String>("fromFullName")
        let msg = Expression<String>("msg")
        let date = Expression<String>("date")
        
        var tbl_userchats=sqliteDB.userschats
        var res=tbl_userchats.filter(owneruser==owneruser1)
        
            print("chat from sqlite is")
            print(res)
        do
        {for tblContacts in try sqliteDB.db.prepare(tbl_userchats.filter(owneruser==owneruser1)){
            //print("queryy runned count is \(tbl_contactslists.count)")
            print(tblContacts[to])
            print(tblContacts[from])
            print(tblContacts[msg])
            print(tblContacts[date])
print("--------")
            }
        }
        catch(let error)
            {
                print(error)
            }
        /////var tbl_userchats=sqliteDB.db["userschats"]

    }
    func deleteChat(userTo:String)
    {
        let to = Expression<String>("to")
        let from = Expression<String>("from")
        
        var tbl_userchats=sqliteDB.userschats
        
        //%%%%%%%%%%%%%%%% new running delete chat from sqlite database june 2016 %%%%%%%%%%%%%%%%
        //-----------------____________
        /////var tbl_userchats=sqliteDB.db["userschats"]
        //tbl_userchats.filter(to==userTo).delete()
        //tbl_userchats.filter(from==userTo).delete()
        do
        {
        try sqliteDB.db.run(tbl_userchats.filter(to==userTo).delete())
        try sqliteDB.db.run(tbl_userchats.filter(from==userTo).delete())
            
        }
        catch(let error)
            {
                print("error in deleting previous chat \(error)")
                socketObj.socket.emit("logClient","IPHONE-LOG: error in deleting previous chat from sqliteDB \(error)")
                
            }
     
        
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