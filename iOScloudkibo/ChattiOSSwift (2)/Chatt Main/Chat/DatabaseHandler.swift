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
    var callHistory:Table!
    var statusUpdate:Table!
    var files:Table!
    
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
        createMessageSeenStatusTable()
        createCallHistoryTable()
        createFileTable()
        //createAllContactsTable()
        
    }
    
    func createAccountsTable()
    {
        socketObj.socket.emit("logClient","IPHONE-LOG: creating accounts table")
        
        let _id = Expression<String>("_id")
        let firstname = Expression<String>("firstname")
        let lastname = Expression<String>("lastname")
        //let email = Expression<String>("email")
        let phone = Expression<String>("phone")
        let username = Expression<String>("username")
        let status = Expression<String>("status")
        let date = Expression<String>("date")
        let accountVerified = Expression<String>("accountVerified")
        let role = Expression<String>("role")
        let country_prefix = Expression<String>("country_prefix")
        let nationalNumber = Expression<String>("national_number")
        
        self.accounts = Table("accounts")
        do{
            try db.run(accounts.create(ifNotExists: true) { t in     // CREATE TABLE "accounts" (
                //t.column(email,check: email.like("%@%"))
                t.column(firstname)
                //t.column(lastname)
                t.column(_id)
                t.column(status)
                t.column(username)
                t.column(country_prefix)
                t.column(nationalNumber)
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
        let actualphone = Expression<String>("actualphone")
        let email = Expression<String>("email")
        let kiboContact = Expression<Bool>("kiboContact")
        let profileimage = Expression<NSData>("profileimage")
        
        self.allcontacts = Table("allcontacts")
        do{
            try db.run(allcontacts.create(ifNotExists: true) { t in     // CREATE TABLE "accounts" (
                t.column(name)
                t.column(phone)
                t.column(actualphone)
                t.column(email)
                t.column(kiboContact, defaultValue:false)
                t.column(profileimage, defaultValue:NSData.init())
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
        let uniqueid = Expression<String>("uniqueid")
        let status = Expression<String>("status")
        let contactPhone = Expression<String>("contactPhone")
        let type = Expression<String>("type")
        let file_type = Expression<String>("file_type")
        let file_path = Expression<String>("file_path")

        
       // let dateFormatter = NSDateFormatter()
       // dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
       // dateFormatter.
        //let datens2 = dateFormatter.dateFromString(NSDate().debugDescription)
       //print("defaultDate is \(datens2)")
        self.userschats = Table("userschats")
        
        var date22=NSDate()
        var formatter = NSDateFormatter();
        //formatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZ";
        formatter.dateFormat = "MM/dd, HH:mm";
        formatter.timeZone = NSTimeZone.localTimeZone()
        //formatter.dateStyle = .ShortStyle
        //formatter.timeStyle = .ShortStyle
        let defaultTimeZoneStr = formatter.stringFromDate(date22);
        
        do{
            try db.run(userschats.create(ifNotExists: true) { t in     // CREATE TABLE "accounts" (
                t.column(to)//loggedin user id
                t.column(from)
                t.column(owneruser)
                t.column(fromFullName)
                t.column(contactPhone)
                t.column(msg)
                t.column(date, defaultValue:defaultTimeZoneStr)
                t.column(status)
                t.column(uniqueid)
                t.column(type, defaultValue:"chat")
                t.column(file_type, defaultValue:"")
                t.column(file_path, defaultValue:"")
                
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
    
    func createCallHistoryTable()
    {
    
            socketObj.socket.emit("logClient","IPHONE-LOG: creating accounts table")
            
            let name = Expression<String>("name")
            let dateTime = Expression<String>("dateTime")
            let type = Expression<String>("type")
            
            
            self.callHistory = Table("callHistory")
            do{
                try db.run(callHistory.create(ifNotExists: true) { t in     // CREATE TABLE "callHistory"
                    t.column(name)
                    t.column(dateTime)
                    t.column(type)
                    })
                
            }
            catch
            {
                socketObj.socket.emit("logClient","IPHONE-LOG: error in creating callHistory table \(error)")
                print("error in creating callHistory table")
            }
        
}
    
    func createMessageSeenStatusTable()
    {
        
        socketObj.socket.emit("logClient","IPHONE-LOG: creating messageSeen table")
        
        let status = Expression<String>("status")
        let sender = Expression<String>("sender")
        let uniqueid = Expression<String>("uniqueid")
        
        
        self.statusUpdate = Table("statusUpdate")
        do{
            try db.run(statusUpdate.create(ifNotExists: true) { t in
                t.column(status)
                t.column(sender)
                t.column(uniqueid)
                })
            
        }
        catch
        {
            socketObj.socket.emit("logClient","IPHONE-LOG: error in creating messageStatus table \(error)")
            print("error in creating messageStatus table")
        }
        
    }
    
    
    
    func createFileTable(){
        
        socketObj.socket.emit("logClient","IPHONE-LOG: creating chat table")
        
        let to = Expression<String>("to")
        let from = Expression<String>("from")
        let date = Expression<String>("date")
        let uniqueid = Expression<String>("uniqueid")
        let contactPhone = Expression<String>("contactPhone")
        let file_name = Expression<String>("file_name")
        let file_size = Expression<String>("file_size")
        let file_type = Expression<String>("file_type")
        let file_path = Expression<String>("file_path")
        
        
        // let dateFormatter = NSDateFormatter()
        // dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        // dateFormatter.
        //let datens2 = dateFormatter.dateFromString(NSDate().debugDescription)
        //print("defaultDate is \(datens2)")
        self.files = Table("files")
        
        var date22=NSDate()
        var formatter = NSDateFormatter();
        //formatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZ";
        formatter.dateFormat = "MM/dd, HH:mm";
        formatter.timeZone = NSTimeZone.localTimeZone()
        //formatter.dateStyle = .ShortStyle
        //formatter.timeStyle = .ShortStyle
        let defaultTimeZoneStr = formatter.stringFromDate(date22);
        
        do{
            try db.run(files.create(ifNotExists: true) { t in     // CREATE TABLE "accounts" (
                t.column(to)//loggedin user id
                t.column(from)
                t.column(contactPhone)
                t.column(date, defaultValue:defaultTimeZoneStr)
                t.column(uniqueid)
                t.column(file_name, defaultValue:"")
                t.column(file_size, defaultValue:"")
                t.column(file_type, defaultValue:"")
                t.column(file_path, defaultValue:"")
                
                //     "name" TEXT
                })
            
        }
        catch(let error)
        {
            socketObj.socket.emit("logClient","IPHONE-LOG: error in creating chat table \(error)")
            print("error in creating userschats table")
        }
    }
    
    
    func saveMessageStatusSeen(status1:String,sender1:String,uniqueid1:String)
    {
        
        let status = Expression<String>("status")
        let sender = Expression<String>("sender")
        let uniqueid = Expression<String>("uniqueid")
        
        var statusUpdate=sqliteDB.statusUpdate
        
        do {
            let rowid = try db.run(statusUpdate.insert(
                status<-status1,
                sender<-sender1,
                uniqueid<-uniqueid1
                ))
            socketObj.socket.emit("logClient","IPHONE-LOG: all messageStatus saved in sqliteDB")
            print("inserted id messageStatus : \(rowid)")
        } catch {
            print("insertion failed: messageStatus \(error)")
        }
        
        
        
    }
    func removeMessageStatusSeen(uniqueid1:String)
    {
        
        let status = Expression<String>("status")
        let sender = Expression<String>("sender")
        let uniqueid = Expression<String>("uniqueid")
        
        var statusUpdate=sqliteDB.statusUpdate
        
        do
        {
            try sqliteDB.db.run(statusUpdate.filter(uniqueid==uniqueid1).delete())
            
        }
        catch(let error)
        {
            print("error in deleting messageStatus \(error)")
            socketObj.socket.emit("logClient","IPHONE-LOG: error in deleting messageStatus from sqliteDB \(error)")
            
        }
        

        
        
    }
    
    
    
    func saveCallHist(name1:String,dateTime1:String,type1:String)
    {
        print("saving call history, call received from \(name1) type is \(type1) datetime is \(dateTime1)")
        socketObj.socket.emit("\(username!) is saving call history, call received from \(name1) type is \(type1) datetime is \(dateTime1)")
        // let contactObject=Expression<CNContact>("contactObj")
        
        let name = Expression<String>("name")
        let dateTime = Expression<String>("dateTime")
        let type = Expression<String>("type")
        
        var date22=NSDate()
        var formatter = NSDateFormatter();
        //formatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZ";
         formatter.dateFormat = "MM/dd, HH:mm";
        formatter.timeZone = NSTimeZone.localTimeZone()
        //formatter.dateStyle = .ShortStyle
        //formatter.timeStyle = .ShortStyle
        let defaultTimeZoneStr = formatter.stringFromDate(date22);
        
        
        
        
        var tbl_callHist=sqliteDB.callHistory
        
        do {
            let rowid = try db.run(tbl_callHist.insert(
                name<-name1,
                dateTime<-defaultTimeZoneStr,
                type<-type1
                ))
            socketObj.socket.emit("logClient","IPHONE-LOG: Call History saved in sqliteDB")
            print("inserted id callHist : \(rowid)")
        } catch {
            print("insertion failed: callHist \(error)")
        }
        
        
        
    }
    
    
    func saveAllContacts(name1:String,phone1:String,actualphone1:String,kiboContact1:Bool,email1:String)
    {
        // let contactObject=Expression<CNContact>("contactObj")
        let name = Expression<String>("name")
        let phone = Expression<String>("phone")
        let actualphone = Expression<String>("actualphone")
        let email = Expression<String>("email")

        let kiboContact = Expression<Bool>("kiboContact")
        
        var tbl_allcontacts=sqliteDB.allcontacts
        
        do {
            let rowid = try db.run(tbl_allcontacts.insert(
                name<-name1,
                phone<-phone1,
                email<-email1,
                actualphone<-actualphone1,
                kiboContact<-kiboContact1
                ))
            socketObj.socket.emit("logClient","IPHONE-LOG: all contacts saved in sqliteDB")
            print("inserted id allcontacts : \(rowid)")
        } catch {
            print("insertion failed: allcontacts \(error)")
        }
        


    }
    func UpdateChatStatus(uniqueid1:String,newstatus:String)
    {
        
        let uniqueid = Expression<String>("uniqueid")
        let status = Expression<String>("status")

        
        var tbl_userchats=sqliteDB.userschats
        
        let query = tbl_userchats.select(status)           // SELECT "email" FROM "users"
            .filter(uniqueid == uniqueid1)     // WHERE "name" IS NOT NULL
        
        do
        {try sqliteDB.db.run(query.update(status <- newstatus))}
        catch
        {
            print("error in updating chat")
            socketObj.socket.emit("logClient","\(username!) error in updating chat satatus")
        }
}
    
    func saveChatImage(to1:String,from1:String,owneruser1:String,fromFullName1:String,msg1:String,date1:String!,uniqueid1:String!,status1:String,type1:String,file_type1:String,file_path1:String)

    {
        //var chatType="image"
    
            //createUserChatTable()
            
            let to = Expression<String>("to")
            let from = Expression<String>("from")
            let owneruser = Expression<String>("owneruser")
            let fromFullName = Expression<String>("fromFullName")
            let msg = Expression<String>("msg")
            let date = Expression<String>("date")
            let uniqueID = Expression<String>("uniqueid")
            let status = Expression<String>("status")
            let contactPhone = Expression<String>("contactPhone")
        let type = Expression<String>("type")
        let file_type = Expression<String>("file_type")
        let file_path = Expression<String>("file_path")
        
            var tbl_userchats=sqliteDB.userschats
            
            var contactPhone1=""
            if(to1 != owneruser1)
            {
                contactPhone1=to1
            }
            else
            {
                contactPhone1=from1
            }
            
            //////var tbl_userchats=sqliteDB.db["userschats"]
            
            /*let insert=tbl_userchats.insert(fromFullName<-fromFullName1,
             msg<-msg1,
             to<-to1,
             from<-from1
             )*/
            var mydate:String!
            if(date1 == nil)
            {
                var date22=NSDate()
                var formatter = NSDateFormatter();
                //formatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZ";
                formatter.dateFormat = "MM/dd, HH:mm";
                formatter.timeZone = NSTimeZone.localTimeZone()
                //formatter.dateStyle = .ShortStyle
                //formatter.timeStyle = .ShortStyle
                let defaultTimeZoneStr = formatter.stringFromDate(date22);
                
                mydate=defaultTimeZoneStr
                
            }
            else
            {
                mydate=date1
            }
      /*
        t.column(type, defaultValue:"chat")
        t.column(file_type, defaultValue:"")
        t.column(file_path, defaultValue:"")
      */
        
            do {
                let rowid = try db.run(tbl_userchats.insert(fromFullName<-fromFullName1,
                    msg<-msg1,
                    owneruser<-owneruser1,
                    to<-to1,
                    from<-from1,
                    date<-mydate,
                    uniqueID<-uniqueid1,
                    status<-status1,
                    contactPhone<-contactPhone1,
                    type<-type1,
                    file_type<-file_type1,
                    file_path<-file_path1
                    ))
                //////print("inserted id: \(rowid)")
            } catch {
                print("insertion failed: \(error)")
            }
            
            
            /*if let rowid = insert.rowid {
             print("inserted id: \(rowid)")
             } else if insert.statement.failed {
             print("insertion failed: \(insert.statement.reason)")
             }*/
            
            
        }
    
    func SaveChat(to1:String,from1:String,owneruser1:String,fromFullName1:String,msg1:String,date1:String!,uniqueid1:String!,status1:String)
    {
        //createUserChatTable()
        
        let to = Expression<String>("to")
        let from = Expression<String>("from")
        let owneruser = Expression<String>("owneruser")
        let fromFullName = Expression<String>("fromFullName")
        let msg = Expression<String>("msg")
        let date = Expression<String>("date")
         let uniqueID = Expression<String>("uniqueid")
        let status = Expression<String>("status")
        let contactPhone = Expression<String>("contactPhone")
        
        var tbl_userchats=sqliteDB.userschats
        
        var contactPhone1=""
        if(to1 != owneruser1)
        {
            contactPhone1=to1
        }
        else
        {
            contactPhone1=from1
        }
        
        //////var tbl_userchats=sqliteDB.db["userschats"]
        
        /*let insert=tbl_userchats.insert(fromFullName<-fromFullName1,
            msg<-msg1,
            to<-to1,
            from<-from1
        )*/
        var mydate:String!
        if(date1 == nil)
        {
            var date22=NSDate()
            var formatter = NSDateFormatter();
            //formatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZ";
            formatter.dateFormat = "MM/dd, HH:mm";
            formatter.timeZone = NSTimeZone.localTimeZone()
            //formatter.dateStyle = .ShortStyle
            //formatter.timeStyle = .ShortStyle
            let defaultTimeZoneStr = formatter.stringFromDate(date22);
            
            mydate=defaultTimeZoneStr
            
            }
        else
        {
            mydate=date1
        }
        
        do {
            let rowid = try db.run(tbl_userchats.insert(fromFullName<-fromFullName1,
                msg<-msg1,
                owneruser<-owneruser1,
                to<-to1,
                from<-from1,
                date<-mydate,
                uniqueID<-uniqueid1,
                status<-status1,
                contactPhone<-contactPhone1
))
            //////print("inserted id: \(rowid)")
        } catch {
            print("insertion failed: \(error)")
        }
        
        
        /*if let rowid = insert.rowid {
            print("inserted id: \(rowid)")
        } else if insert.statement.failed {
            print("insertion failed: \(insert.statement.reason)")
        }*/
        
        
    }
    
    func saveFile(to1:String,from1:String,owneruser1:String,file_name1:String,date1:String!,uniqueid1:String!,file_size1:String,file_type1:String,file_path1:String)
        
    {
        //var chatType="image"
        
        //createUserChatTable()
        let to = Expression<String>("to")
        let from = Expression<String>("from")
        let date = Expression<String>("date")
        let uniqueid = Expression<String>("uniqueid")
        let contactPhone = Expression<String>("contactPhone")
        let file_name = Expression<String>("file_name")
        let file_size = Expression<String>("file_size")
        let file_type = Expression<String>("file_type")
        let file_path = Expression<String>("file_path")
        
        
        var tbl_userfiles=sqliteDB.files
        
        var contactPhone1=""
        if(to1 != owneruser1)
        {
            contactPhone1=to1
        }
        else
        {
            contactPhone1=from1
        }
        
        //////var tbl_userchats=sqliteDB.db["userschats"]
        
        /*let insert=tbl_userchats.insert(fromFullName<-fromFullName1,
         msg<-msg1,
         to<-to1,
         from<-from1
         )*/
        var mydate:String!
        if(date1 == nil)
        {
            var date22=NSDate()
            var formatter = NSDateFormatter();
            //formatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZ";
            formatter.dateFormat = "MM/dd, HH:mm";
            formatter.timeZone = NSTimeZone.localTimeZone()
            //formatter.dateStyle = .ShortStyle
            //formatter.timeStyle = .ShortStyle
            let defaultTimeZoneStr = formatter.stringFromDate(date22);
            
            mydate=defaultTimeZoneStr
            
        }
        else
        {
            mydate=date1
        }
        /*
         t.column(type, defaultValue:"chat")
         t.column(file_type, defaultValue:"")
         t.column(file_path, defaultValue:"")
         */
        
        do {
            let rowid = try db.run(tbl_userfiles.insert(
                to<-to1,
                from<-from1,
                date<-mydate,
                uniqueid<-uniqueid1,
                contactPhone<-contactPhone1,
                file_name<-file_name1,
                file_size<-file_size1,
                file_type<-file_type1,
                file_path<-file_path1
                ))
            //////print("inserted id: \(rowid)")
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
