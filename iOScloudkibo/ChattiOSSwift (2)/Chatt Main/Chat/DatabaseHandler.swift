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
import AccountKit
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
    var groups:Table!
    var group_member:Table!
    var group_chat:Table!
    var group_chat_status:Table!
    var group_muteSettings:Table!
    
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
                    
                    /*let preferences = NSUserDefaults.standardUserDefaults()
                    
                    let currentLevelKey = "currentLevel"
                    
                    if preferences.objectForKey(currentLevelKey) == nil {
                        //  Doesn't exist
                    } else {
                        let currentLevel = preferences.integerForKey(currentLevelKey)
                    }
                    */
                    
                   /* if(KeychainWrapper.stringForKey("retainOldDatabase")==nil)
                        {
                            KeychainWrapper.setString("false", forKey: "retainOldDatabase")
                        }
                    else
                    {
                        if((KeychainWrapper.stringForKey("versionNumber")!  as! Double) < 0.3)
                        {
                             KeychainWrapper.setString("false", forKey: "retainOldDatabase")
                        }
                        else
                        {
                            KeychainWrapper.setString("true", forKey: "retainOldDatabase")
                            
                        }
                    }
*/
                    
                    //////
                   /* if((KeychainWrapper.stringForKey("retainOldDatabase")==nil))
                    {print("retainolddatabase is empty")
                        KeychainWrapper.setString("false",forKey: "retainOldDatabase")
                        KeychainWrapper.setString(versionNumber,forKey: "versionNumber")
                        retainOldDatabase=false
                        if(accountKit == nil){
                            accountKit = AKFAccountKit(responseType: AKFResponseType.AccessToken)
                        }
                        accountKit.logOut()
                    }
                        
                    else
                    {
                        if((KeychainWrapper.stringForKey("versionNumber")==nil))
                        {print("versionnumber is empty")
                            KeychainWrapper.setString("false",forKey: "retainOldDatabase")
                            KeychainWrapper.setString(versionNumber,forKey: "versionNumber")
                            retainOldDatabase=false;
                            if(accountKit == nil){
                                accountKit = AKFAccountKit(responseType: AKFResponseType.AccessToken)
                            }
                            accountKit.logOut()
   
                        }
                        else{
                        if(KeychainWrapper.stringForKey("versionNumber") != versionNumber)
                        {print("retainolddatabase is lesser")
                            KeychainWrapper.setString("false",forKey: "retainOldDatabase")
                            KeychainWrapper.setString(versionNumber,forKey: "versionNumber")
                            retainOldDatabase=false;
                            if(accountKit == nil){
                                accountKit = AKFAccountKit(responseType: AKFResponseType.AccessToken)
                            }
                            accountKit.logOut()
                        }
                        else
                        {
                           retainOldDatabase=true
}
                    }
                    }*/
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
        createGroupsTable()
        createGroupsMembersTable()
        createGroupsChatTable()
        createGroupsChatStatusTable()
        createMuteGroupSettingsTable()
        //createAllContactsTable()
        
    }
    func resetTables()
    {
        self.accounts = Table("accounts")
        do{try db.run(self.accounts.drop(ifExists: true))
        }
        catch
        {
            print("error in dropping accounts table \(error)")
        }
        
        self.allcontacts = Table("allcontacts")
        do{try db.run(self.allcontacts.drop(ifExists: true))
        }
        catch
        {
            print("error in dropping allcontacts table \(error)")
        }
        
        self.contactslists = Table("contactslists")
        do{try db.run(self.contactslists.drop(ifExists: true))
        }
        catch
        {
            print("error in dropping contactslists table \(error)")
        }
        
        self.userschats = Table("userschats")
        do{try db.run(self.userschats.drop(ifExists: true))
        }
        catch
        {
            print("error in dropping userschats table \(error)")
        }
        
        
        
        self.statusUpdate = Table("statusUpdate")
        do{try db.run(self.statusUpdate.drop(ifExists: true))
        }
        catch
        {
            print("error in dropping statusUpdate table \(error)")
        }
        
        
        self.callHistory = Table("callHistory")
        do{try db.run(self.callHistory.drop(ifExists: true))
        }
        catch
        {
            print("error in dropping callHistory table \(error)")
        }
        
        self.files = Table("files")
        do{try db.run(self.files.drop(ifExists: true))
        }
        catch
        {
            print("error in dropping files table \(error)")
        }
        //
        self.groups = Table("groups")
        do{try db.run(self.groups.drop(ifExists: true))
        }
        catch
        {
            print("error in dropping groups table \(error)")
        }
        /////
        self.group_member = Table("group_member")
        do{try db.run(self.group_member.drop(ifExists: true))
        }
        catch
        {
            print("error in dropping group_member table \(error)")
        }
        ///////////////
        self.group_chat = Table("group_chat")
        do{try db.run(self.group_chat.drop(ifExists: true))
        }
        catch
        {
            print("error in dropping files table \(error)")
        }
        self.group_chat_status = Table("group_chat_status")
        do{try db.run(self.group_chat_status.drop(ifExists: true))
        }
        catch
        {
            print("error in dropping group_chat_status table \(error)")
        }
        self.group_muteSettings = Table("group_muteSettings")
        do{try db.run(self.group_muteSettings.drop(ifExists: true))
        }
        catch
        {
            print("error in dropping group_muteSettings table \(error)")
        }
    }
    
    func createAccountsTable()
    {
        if(socketObj != nil)
        {socketObj.socket.emit("logClient","IPHONE-LOG: creating accounts table")}
        
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
            try db.run(accounts.create(ifNotExists: retainOldDatabase) { t in     // CREATE TABLE "accounts" (
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
            if(socketObj != nil){
            socketObj.socket.emit("logClient","IPHONE-LOG: error in creating accounts table \(error)")
            }
            print("error in creating accounts table \(error)")
                
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
        if(socketObj != nil){
            
        socketObj.socket.emit("logClient","IPHONE-LOG: creating contacts table")
        }
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
        try db.run(contactslists.create(ifNotExists: retainOldDatabase){ t in     // CREATE TABLE "users" (
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
            if(socketObj != nil){
            socketObj.socket.emit("logClient","IPHONE-LOG: error in creating contacts table \(error)")
            print("error in creating contactslists table")
            }
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
        
        if(socketObj != nil)
        {socketObj.socket.emit("logClient","IPHONE-LOG: creating allcontacts table")}
        //let contactObject=Expression<CNContact>("contactObj")
        //let kiboContact = Expression<Bool>("kiboContact")
        let name = Expression<String>("name")
        let phone = Expression<String>("phone")
        let actualphone = Expression<String>("actualphone")
        let email = Expression<String>("email")
        let kiboContact = Expression<Bool>("kiboContact")
        /////////////////////let profileimage = Expression<NSData>("profileimage")
        let uniqueidentifier = Expression<NSData>("uniqueidentifier")
        //
        self.allcontacts = Table("allcontacts")
        do{
            try db.run(allcontacts.create(ifNotExists: retainOldDatabase) { t in     // CREATE TABLE "accounts" (
                t.column(uniqueidentifier, unique:true)
                t.column(name)
                t.column(phone)
                t.column(actualphone)
                t.column(email)
                t.column(kiboContact, defaultValue:false)
                //////////////t.column(profileimage, defaultValue:NSData.init())
                })
            
        }
        catch(let error)
        {
            if(socketObj != nil)
            {
            socketObj.socket.emit("logClient","IPHONE-LOG: error in creating allcontacts table \(error)")
            print("error in creating allcontacts table")
            }
        }
    }
    
    
    
    func createUserChatTable(){
        
        if(socketObj != nil)
        {
           socketObj.socket.emit("logClient","IPHONE-LOG: creating chat table")
        }
        
        let to = Expression<String>("to")
        let from = Expression<String>("from")
        let fromFullName = Expression<String>("fromFullName")
        let msg = Expression<String>("msg")
        let owneruser = Expression<String>("owneruser")
        let date = Expression<NSDate>("date")
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
        /*
        var date22=NSDate()
        var formatter = NSDateFormatter();
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ";
        //formatter.dateFormat = "MM/dd HH:mm";
        formatter.timeZone = NSTimeZone.localTimeZone()
        //formatter.dateStyle = .ShortStyle
        //formatter.timeStyle = .ShortStyle
        let defaultTimeZoneStr2 = formatter.stringFromDate(date22);
        var defaultTimeZoneStr = formatter.dateFromString(defaultTimeZoneStr2)
        */
       // print("default db date is \(defaultTimeZoneStr)")
        do{
            try db.run(userschats.create(ifNotExists: retainOldDatabase) { t in     // CREATE TABLE "accounts" (
                t.column(to)//loggedin user id
                t.column(from)
                t.column(owneruser)
                t.column(fromFullName)
                t.column(contactPhone)
                t.column(msg)
                t.column(date)
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
            if(socketObj != nil)
            {
            socketObj.socket.emit("logClient","IPHONE-LOG: error in creating chat table \(error)")
            print("error in creating userschats table")
            }
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
    if(socketObj != nil)
    {
            socketObj.socket.emit("logClient","IPHONE-LOG: creating accounts table")
        
        }
            let name = Expression<String>("name")
            let dateTime = Expression<String>("dateTime")
            let type = Expression<String>("type")
            
            
            self.callHistory = Table("callHistory")
            do{
                try db.run(callHistory.create(ifNotExists: retainOldDatabase) { t in     // CREATE TABLE "callHistory"
                    t.column(name)
                    t.column(dateTime)
                    t.column(type)
                    })
                
            }
            catch
            {
                if(socketObj != nil)
                {
                socketObj.socket.emit("logClient","IPHONE-LOG: error in creating callHistory table \(error)")
                }
                print("error in creating callHistory table")
                
            }
        
}
    
    func createMessageSeenStatusTable()
    {
        if(socketObj != nil)
        {
        
        socketObj.socket.emit("logClient","IPHONE-LOG: creating messageSeen table")
        }
        let status = Expression<String>("status")
        let sender = Expression<String>("sender")
        let uniqueid = Expression<String>("uniqueid")
        
        
        self.statusUpdate = Table("statusUpdate")
        do{
            try db.run(statusUpdate.create(ifNotExists: retainOldDatabase) { t in
                t.column(status)
                t.column(sender)
                t.column(uniqueid)
                })
            
        }
        catch
        {
           if(socketObj != nil)
           {socketObj.socket.emit("logClient","IPHONE-LOG: error in creating messageStatus table \(error)")}
            print("error in creating messageStatus table")
        }
        
    }
    
    func createMuteGroupSettingsTable()
    {
        let groupid = Expression<String>("groupid")
        let isMute = Expression<Bool>("isMute")
        let muteTime = Expression<NSDate>("muteTime")
        let unMuteTime = Expression<NSDate>("unMuteTime")

        
        
        self.group_muteSettings = Table("group_muteSettings")
        do{
            try db.run(group_muteSettings.create(ifNotExists: retainOldDatabase) { t in
                t.column(groupid)
                t.column(isMute)
                t.column(muteTime)
                 t.column(unMuteTime)
                })
            
        }
        catch
        {
             print("error in creating group_muteSettings table")
       
        
    }
    }
    
    
    
        func storeMuteGroupSettingsTable(groupid1:String,isMute1:Bool,muteTime1:NSDate,unMuteTime1:NSDate)
        {
            let groupid = Expression<String>("groupid")
            let isMute = Expression<Bool>("isMute")
            let muteTime = Expression<NSDate>("muteTime")
            let unMuteTime = Expression<NSDate>("unMuteTime")
            
            
            var group_muteSettings=sqliteDB.group_muteSettings
            
            do {
                let rowid = try db.run(group_muteSettings.insert(
                    groupid<-groupid1,
                    isMute<-isMute1,
                    muteTime<-muteTime1,
                    unMuteTime<-unMuteTime1
                    ))
                
               
                print("inserted id group_muteSettings : \(rowid)")
            } catch {
                print("insertion failed: group_muteSettings \(error)")
            }
            
        }
    
    
    func createFileTable(){
        if(socketObj != nil){
        socketObj.socket.emit("logClient","IPHONE-LOG: creating chat table")
        }
        let to = Expression<String>("to") //user phone or group id
        let from = Expression<String>("from")
        let date = Expression<NSDate>("date")
        let uniqueid = Expression<String>("uniqueid") //chat uniqueid OR group image id
        let contactPhone = Expression<String>("contactPhone")
        let type = Expression<String>("type")  //image or document
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
        
        /*var date22=NSDate()
        var formatter = NSDateFormatter();
        //formatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZ";
        formatter.dateFormat = "MM/dd HH:mm";
        formatter.timeZone = NSTimeZone.localTimeZone()
        //formatter.dateStyle = .ShortStyle
        //formatter.timeStyle = .ShortStyle
        let defaultTimeZoneStr = formatter.stringFromDate(date22);*/
        var date22=NSDate()
        var formatter = NSDateFormatter();
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ";
        //formatter.dateFormat = "MM/dd HH:mm";
        formatter.timeZone = NSTimeZone.localTimeZone()
        //formatter.dateStyle = .ShortStyle
        //formatter.timeStyle = .ShortStyle
        let defaultTimeZoneStr2 = formatter.stringFromDate(date22);
        var defaultTimeZoneStr = formatter.dateFromString(defaultTimeZoneStr2)
        print("default db date is \(defaultTimeZoneStr)")
        
        do{
            try db.run(files.create(ifNotExists: retainOldDatabase) { t in     // CREATE TABLE "accounts" (
                t.column(to)//loggedin user id
                t.column(from)
                t.column(contactPhone)
                t.column(date)
                t.column(uniqueid)
                t.column(type, defaultValue:"")
                t.column(file_name, defaultValue:"")
                t.column(file_size, defaultValue:"")
                t.column(file_type, defaultValue:"")
                t.column(file_path, defaultValue:"")
                
                //     "name" TEXT
                })
            
        }
        catch(let error)
        {if(socketObj != nil){
            socketObj.socket.emit("logClient","IPHONE-LOG: error in creating chat table \(error)")
            }
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
            
            if(socketObj != nil)
            {
           // socketObj.socket.emit("logClient","IPHONE-LOG: all messageStatus saved in sqliteDB")
            }
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
            if(socketObj != nil)
            {
            socketObj.socket.emit("logClient","IPHONE-LOG: error in deleting messageStatus from sqliteDB \(error)")
            }
            
        }
        

        
        
    }
    
    
    
    func saveCallHist(name1:String,dateTime1:String,type1:String)
    {
        print("saving call history, call received from \(name1) type is \(type1) datetime is \(dateTime1)")
        if(socketObj != nil)
        {socketObj.socket.emit("\(username!) is saving call history, call received from \(name1) type is \(type1) datetime is \(dateTime1)")
        }
        // let contactObject=Expression<CNContact>("contactObj")
        
        let name = Expression<String>("name")
        let dateTime = Expression<String>("dateTime")
        let type = Expression<String>("type")
        
        var date22=NSDate()
        var formatter = NSDateFormatter();
        //formatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZ";
         formatter.dateFormat = "MM/dd HH:mm";
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
           if(socketObj != nil)
           {socketObj.socket.emit("logClient","IPHONE-LOG: Call History saved in sqliteDB")}
            print("inserted id callHist : \(rowid)")
        } catch {
            print("insertion failed: callHist \(error)")
        }
        
        
        
    }
    
    
    func saveAllContacts(uniqueidentifier1:String,name1:String,phone1:String,actualphone1:String,kiboContact1:Bool,email1:String)
    {
        // let contactObject=Expression<CNContact>("contactObj")
        let uniqueidentifier = Expression<String>("uniqueidentifier")
        let name = Expression<String>("name")
        let phone = Expression<String>("phone")
        let actualphone = Expression<String>("actualphone")
        let email = Expression<String>("email")

        let kiboContact = Expression<Bool>("kiboContact")
        
        var tbl_allcontacts=sqliteDB.allcontacts
        
        do {
            let rowid = try db.run(tbl_allcontacts.insert(
                uniqueidentifier<-uniqueidentifier1,
                name<-name1,
                phone<-phone1,
                email<-email1,
                actualphone<-actualphone1,
                kiboContact<-kiboContact1
                ))
            if(socketObj != nil){
            socketObj.socket.emit("logClient","IPHONE-LOG: all contacts saved in sqliteDB")
            }
            print("inserted id allcontacts : \(rowid)")
        } catch {
            print("insertion failed: allcontacts \(error)")
        }
        


    }
    func UpdateChatStatus(uniqueid1:String,newstatus:String)
    {
       //  UtilityFunctions.init().log_papertrail("IPHONE: \(username!) inside database function to update chat status")
        
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
            if(socketObj != nil){
            socketObj.socket.emit("logClient","\(username!) error in updating chat satatus")
            }
        }
}
    
   /* func saveChatImage(to1:String,from1:String,owneruser1:String,fromFullName1:String,msg1:String,date1:String!,uniqueid1:String!,status1:String,type1:String,file_type1:String,file_path1:String)

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
                formatter.dateFormat = "MM/dd HH:mm";
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
            
            
        }*/
    
    func SaveChat(to1:String,from1:String,owneruser1:String,fromFullName1:String,msg1:String,date1:NSDate!,uniqueid1:String!,status1:String,type1:String,file_type1:String,file_path1:String)
    {
        //createUserChatTable()
    // UtilityFunctions.init().log_papertrail("IPHONE:\(username!) inside database function to SAVE chat")
        
        let to = Expression<String>("to")
        let from = Expression<String>("from")
        let owneruser = Expression<String>("owneruser")
        let fromFullName = Expression<String>("fromFullName")
        let msg = Expression<String>("msg")
        let date = Expression<NSDate>("date")
         let uniqueID = Expression<String>("uniqueid")
        let status = Expression<String>("status")
        let contactPhone = Expression<String>("contactPhone")
        let type = Expression<String>("type")
        let file_type = Expression<String>("file_type")
        let file_path = Expression<String>("file_path")
        
        var tbl_userchats=sqliteDB.userschats
        
        var contactPhone1=""
        
        print("date received is \(date1)")
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
        var mydate:NSDate!
        if(date1 == nil)
        {
            print("date got is null to put current date/time")
           /* var date22=NSDate()
            var formatter = NSDateFormatter();
            //formatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZ";
            formatter.dateFormat = "MM/dd HH:mm";
            formatter.timeZone = NSTimeZone.localTimeZone()
            //formatter.dateStyle = .ShortStyle
            //formatter.timeStyle = .ShortStyle
            let defaultTimeZoneStr = formatter.stringFromDate(date22);
            */
            
            var date22=NSDate()
            var formatter = NSDateFormatter();
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ";
            ///newwwwwwww
             formatter.timeZone = NSTimeZone.localTimeZone()
           
            
            
            //formatter.dateFormat = "MM/dd HH:mm";
            ////////////////==formatter.timeZone = NSTimeZone.defaultTimeZone()
            //formatter.dateStyle = .ShortStyle
            //formatter.timeStyle = .ShortStyle
            let defaultTimeZoneStr2 = formatter.stringFromDate(date22);
            
            
            var formatter2 = NSDateFormatter();
            formatter2.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ";
            
            //////formatter.timeZone = NSTimeZone.localTimeZone()
            var defaultTimeZoneStr = formatter2.dateFromString(defaultTimeZoneStr2)
            print("default db date is \(defaultTimeZoneStr!)")
            
            print("===fetch chat inside database handler string \(defaultTimeZoneStr2) .. converted NSDate is \(defaultTimeZoneStr!)... now date 22 is \(date22)")
            
            mydate=date22
            ////mydate=defaultTimeZoneStr!
            
            }
        else
        {
            
            
              print("date got is not null. converting")
            //var date22=NSDate()
            var formatter = NSDateFormatter();
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ";
            //formatter.dateFormat = "MM/dd HH:mm";
            formatter.timeZone = NSTimeZone.localTimeZone()
            
            let defaultTimeZoneStr2 = formatter.stringFromDate(date1);
            var defaultTimeZoneStr = formatter.dateFromString(defaultTimeZoneStr2)
            
           ////var defaultTimeZoneStr = formatter.dateFromString(date1)
            print("default db date from server is \(defaultTimeZoneStr!)")
            
              print("===fetch chat inside database handler got date as \(date1) .. date string is \(defaultTimeZoneStr2) ...converted NSDate is \(defaultTimeZoneStr!)  ... date1 got is \(date1)")

            
            
            mydate=defaultTimeZoneStr!
        }
        
        do {
            
            var alreadyexists=false
            for res in try sqliteDB.db.prepare(tbl_userchats.filter(uniqueID == uniqueid1))
            {
               // print("chat already exists")
                alreadyexists=true
            }
            
            if(alreadyexists==false)
{
    print("adding chat \(file_type1) .. \(msg1) .. type \(type1)")
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
    
   // UtilityFunctions.init().log_papertrail("IPHONE_LOG: \(username!) saving chat in db \(rowid)")
            }
            else
            {
                print("chat data already available, avoid duplicates")
            }
            //////print("inserted id: \(rowid)")
        } catch {
          //  UtilityFunctions.init().log_papertrail("IPHONE_LOG: \(username!) error: failed to save chat")
            
            print("insertion failed: \(error)")
        }
        
        
        /*if let rowid = insert.rowid {
            print("inserted id: \(rowid)")
        } else if insert.statement.failed {
            print("insertion failed: \(insert.statement.reason)")
        }*/
        
        
    }
    
    func saveFile(to1:String,from1:String,owneruser1:String,file_name1:String,date1:String!,uniqueid1:String!,file_size1:String,file_type1:String,file_path1:String, type1:String)
        
    {
        //var chatType="image"
        
        //createUserChatTable()
        let to = Expression<String>("to")
        let from = Expression<String>("from")
        let date = Expression<NSDate>("date")
        let uniqueid = Expression<String>("uniqueid")
        let contactPhone = Expression<String>("contactPhone")
        let type = Expression<String>("type")
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
        var mydate:NSDate!
        if(date1 == nil)
        {
            var date22=NSDate()
            var formatter = NSDateFormatter();
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ";
            //formatter.dateFormat = "MM/dd HH:mm";
            formatter.timeZone = NSTimeZone.localTimeZone()
            //formatter.dateStyle = .ShortStyle
            //formatter.timeStyle = .ShortStyle
            let defaultTimeZoneStr2 = formatter.stringFromDate(date22);
            var defaultTimeZoneStr = formatter.dateFromString(defaultTimeZoneStr2)
            print("default db date is \(defaultTimeZoneStr)")
            
            mydate=defaultTimeZoneStr

            
        }
        else
        {
            
            //var date22=NSDate()
            var formatter = NSDateFormatter();
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ";
            //formatter.dateFormat = "MM/dd HH:mm";
            formatter.timeZone = NSTimeZone.localTimeZone()
            var defaultTimeZoneStr = formatter.dateFromString(date1)
            print("default db date from server is \(defaultTimeZoneStr)")
            

            mydate=defaultTimeZoneStr
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
                type<-type1,  //image or document
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
        let date = Expression<NSDate>("date")
        
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
                if(socketObj != nil){
                socketObj.socket.emit("logClient","IPHONE-LOG: error in deleting previous chat from sqliteDB \(error)")
                }
                
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
    
    
    func createGroupsTable()
    {
        if(socketObj != nil)
        {socketObj.socket.emit("logClient","IPHONE-LOG: creating groups table")}
        
        let group_name = Expression<String>("group_name")
        let group_icon = Expression<NSData>("group_icon")
        let date_creation = Expression<NSDate>("date_creation")
        let unique_id = Expression<String>("unique_id")
        let isMute = Expression<Bool>("isMute")
        let status = Expression<Bool>("status")
        
         self.groups = Table("groups")
        do{
            try db.run(groups.create(ifNotExists: retainOldDatabase) { t in
                t.column(group_name)
                t.column(group_icon, defaultValue:NSData.init())
                t.column(date_creation, defaultValue:NSDate())
                t.column(unique_id, unique:true)
                t.column(isMute, defaultValue:false)
                t.column(status)
                
                //     "name" TEXT
                })
            
        }
        catch
        {
            if(socketObj != nil){
                socketObj.socket.emit("logClient","IPHONE-LOG: error in creating groups table \(error)")
            }
            print("error in creating groups table \(error)")
            
        }
      
    }
    
    func createGroupsMembersTable()
    {
        /*
         group_unique_id
         member_phone
         isAdmin
         membership_status (left or joined)
         date_joined
         date_left
         */
        if(socketObj != nil)
        {socketObj.socket.emit("logClient","IPHONE-LOG: creating group_member table")}
        
        let group_unique_id = Expression<String>("group_unique_id")
        let member_phone = Expression<String>("member_phone")
        let isAdmin = Expression<String>("isAdmin")
        let membership_status = Expression<String>("membership_status")
        let date_joined = Expression<NSDate>("date_joined")
        let date_left = Expression<NSDate>("date_left")
        let group_member_displayname = Expression<String>("group_member_displayname")
        
        
        self.group_member = Table("group_member")
        do{
            try db.run(group_member.create(ifNotExists: retainOldDatabase) { t in
                t.column(group_unique_id)
                t.column(group_member_displayname)
                t.column(member_phone)
                t.column(isAdmin)
                t.column(membership_status)
                t.column(date_joined)
                t.column(date_left, defaultValue:NSDate.init())
                //     "name" TEXT
                })
            
        }
        catch
        {
            if(socketObj != nil){
                socketObj.socket.emit("logClient","IPHONE-LOG: error in creating group_member table \(error)")
            }
            print("error in creating group_member table \(error)")
            
        }
        
    }
    
    func createGroupsChatTable()
    {
        /*
         from
         group_unique_id
         type (log or chat)
         msg
         from_fullname
         date
         unique_id

         */
        if(socketObj != nil)
        {socketObj.socket.emit("logClient","IPHONE-LOG: creating group chats table")}
        
        let from = Expression<String>("from")
        let group_unique_id = Expression<String>("group_unique_id")
        let type = Expression<String>("type")
        let msg = Expression<String>("msg")
        let from_fullname = Expression<String>("from_fullname")
        let date = Expression<NSDate>("date")
        let unique_id = Expression<String>("unique_id")
        
        self.group_chat = Table("group_chat")
        do{
            try db.run(group_chat.create(ifNotExists: retainOldDatabase) { t in
                t.column(from)
                t.column(group_unique_id)
                t.column(type)
                t.column(msg)
                t.column(from_fullname)
                t.column(date)
                t.column(unique_id)
                //     "name" TEXT
                })
            
        }
        catch
        {
            if(socketObj != nil){
                socketObj.socket.emit("logClient","IPHONE-LOG: error in creating group chats table \(error)")
            }
            print("error in creating group chats table \(error)")
            
        }
        
    }
    
    func createGroupsChatStatusTable()
    {
        /*
         msg_unique_id
         Status (‘pending’, ‘sent’, ‘delivered’, ‘seen’, ‘deleted’)
         user_phone
         
         */
        if(socketObj != nil)
        {socketObj.socket.emit("logClient","IPHONE-LOG: creating group chats status table")}
        
        let msg_unique_id = Expression<String>("msg_unique_id")
        let Status = Expression<String>("Status")
        let user_phone = Expression<String>("user_phone")
        let read_date = Expression<NSDate>("read_date")
        let delivered_date = Expression<NSDate>("delivered_date")
        
        self.group_chat_status = Table("group_chat_status")
        do{
            try db.run(group_chat_status.create(ifNotExists: retainOldDatabase) { t in
                t.column(msg_unique_id)
                t.column(Status)
                t.column(user_phone)
                
                t.column(read_date,defaultValue:UtilityFunctions.init().minimumDate())
                
                t.column(delivered_date,defaultValue:UtilityFunctions.init().minimumDate())
                })
            
        }
        catch
        {
            if(socketObj != nil){
                socketObj.socket.emit("logClient","IPHONE-LOG: error in creating group chats status table \(error)")
            }
            print("error in creating group chats status table \(error)")
            
        }
        
    }
    
    func storeGroupsChat(from1:String,group_unique_id1:String,type1:String,msg1:String,from_fullname1:String,date1:NSDate,unique_id1:String)
    {
        let from = Expression<String>("from")
        let group_unique_id = Expression<String>("group_unique_id")
        let type = Expression<String>("type")
        let msg = Expression<String>("msg")
        let from_fullname = Expression<String>("from_fullname")
        let date = Expression<NSDate>("date")
        let unique_id = Expression<String>("unique_id")
        
        self.group_chat = Table("group_chat")
        
        
        do {
            
            var alreadyexists=false
            for res in try sqliteDB.db.prepare(group_chat.filter(unique_id == unique_id1))
            {
                // print("chat already exists")
                alreadyexists=true
            }
            
            if(alreadyexists==false)
            {
       // do {
            let rowid = try db.run(group_chat.insert(
                from<-from1,
                group_unique_id<-group_unique_id1,
                type<-type1,
                msg<-msg1,
                from_fullname<-from_fullname1,
                date<-date1,
                unique_id<-unique_id1
                
                ))
            
            if(socketObj != nil)
            {
                socketObj.socket.emit("logClient","IPHONE-LOG: group chat saved in sqliteDB")
            }
            print("inserted id groupchat : \(rowid)")
        }
            else
            {
                print("avoid adding duplicate group chats")
            }
        }
            catch {
            print("insertion failed: groupchat \(error)")
        }
    }
    
    func storeGroups(groupname1:String,groupicon1:NSData!,datecreation1:NSDate,uniqueid1:String,status1:String)
    {
        
        let group_name = Expression<String>("group_name")
        let group_icon = Expression<NSData>("group_icon")
        let date_creation = Expression<NSDate>("date_creation")
        let unique_id = Expression<String>("unique_id")
        let isMute = Expression<Bool>("isMute")
        let status = Expression<String>("status") //temp or new
        
        self.groups = Table("groups")
        
        do {
       let rowid = try db.run(groups.insert(
                    group_name<-groupname1,
                    group_icon<-groupicon1,
                    date_creation<-datecreation1,
                    unique_id<-uniqueid1,
                    status<-status1
                    ))
        }
     //   }
    catch {
            print("insertion failed: saving group \(error)")
        }
        
        

    }
    
    func UpdateMuteGroupStatus(unique_id1:String,isMute1:Bool)
    {
       let unique_id = Expression<String>("unique_id")
        let isMute = Expression<Bool>("isMute")
        
        self.groups = Table("groups")
        let query = groups.select(unique_id)           // SELECT "email" FROM "users"
            .filter(unique_id == unique_id1)     // WHERE "name" IS NOT NULL
        
        do
        {try sqliteDB.db.run(query.update(isMute <- isMute1))}
        catch
        {
            print("error: cannot update isMute status")
        }
        
    }
    
    func storeMembers(group_uniqueid1:String,member_displayname1:String,member_phone1:String,isAdmin1:String,membershipStatus1:String,date_joined1:NSDate)
    {
        let group_unique_id = Expression<String>("group_unique_id")
        let group_member_displayname = Expression<String>("group_member_displayname")
        let member_phone = Expression<String>("member_phone")
        let isAdmin = Expression<String>("isAdmin")
        let membership_status = Expression<String>("membership_status")//joined or left
        let date_joined = Expression<NSDate>("date_joined")
        let date_left = Expression<NSDate>("date_left")
        
        self.group_member = Table("group_member")
        
        do {
            let rowid = try db.run(group_member.insert(
                group_unique_id<-group_uniqueid1,
                group_member_displayname<-member_displayname1,
                member_phone<-member_phone1,
                isAdmin<-isAdmin1,
                membership_status<-membershipStatus1,
                date_joined<-date_joined1,
                date_left<-NSDate.init()
                
                ))
            
            if(socketObj != nil)
            {
             //   socketObj.socket.emit("logClient","IPHONE-LOG: all messageStatus saved in sqliteDB")
            }
            print("inserted id messageStatus : \(rowid)")
        } catch {
            print("insertion failed: messageStatus \(error)")
        }
        

        
    }
    func getGroupDetails()->[[String:AnyObject]]
    {
        let group_name = Expression<String>("group_name")
        let group_icon = Expression<NSData>("group_icon")
        let date_creation = Expression<NSDate>("date_creation")
        let unique_id = Expression<String>("unique_id")
        let isMute = Expression<Bool>("isMute")
        let status = Expression<String>("status")
        
        
        var groupsList=[[String:AnyObject]]()
        
        /* let _id = Expression<String>("_id")
         let deptname = Expression<String>("deptname")
         let deptdescription = Expression<String>("deptdescription")
         let companyid = Expression<String>("companyid")
         let createdby = Expression<String>("createdby")
         let creationdate = Expression<String>("creationdate")
         let deleteStatus = Expression<String>("deleteStatus")
         */
        self.groups = Table("groups")
        
        do
        {for groupDetails in try self.db.prepare(self.groups){
           // print("channel name for deptid \(deptid) is \(channelNames.get(msg_channel_name))")
            var newEntry: [String: AnyObject] = [:]
            newEntry["group_name"]=groupDetails.get(group_name)
            newEntry["group_icon"]=groupDetails.get(group_icon)
            newEntry["date_creation"]=groupDetails.get(date_creation)
            newEntry["unique_id"]=groupDetails.get(unique_id)
            newEntry["isMute"]=groupDetails.get(isMute)
            newEntry["status"]=groupDetails.get(status)
            
            
            /*newEntry["msg_channel_description"]=channelNames.get(msg_channel_description)
            newEntry["companyid"]=channelNames.get(companyid)
            newEntry["groupid"]=channelNames.get(groupid)
            newEntry["createdby"]=channelNames.get(createdby)
            newEntry["creationdate"]=channelNames.get(creationdate)
            newEntry["deleteStatus"]=channelNames.get(deleteStatus)
                */
            groupsList.append(newEntry)
            
            
            }
        }
        catch{
            print("failed to get groupsList")
        }
        print("groupsList count is \(groupsList.count)")
        return groupsList

        
        
    }
    func getSingleGroupInfo(groupid:String)->[String: AnyObject]
    {
        // var groupsList=[String:AnyObject]()
        var newEntry: [String: AnyObject] = [:]
        
        let group_name = Expression<String>("group_name")
        let group_icon = Expression<NSData>("group_icon")
        let date_creation = Expression<NSDate>("date_creation")
        let unique_id = Expression<String>("unique_id")
        let isMute = Expression<Bool>("isMute")
        
        
        
        var tblGroups = Table("groups")
        do
        {for groupsinfo in try self.db.prepare(tblGroups.filter(unique_id == groupid)){
            
            print("inside finding group found in db")
            newEntry["group_name"]=groupsinfo.get(group_name)
            newEntry["group_icon"]=groupsinfo.get(group_icon)
            newEntry["date_creation"]=groupsinfo.get(date_creation)
            newEntry["unique_id"]=groupsinfo.get(unique_id)
            newEntry["isMute"]=groupsinfo.get(isMute)
            //groupsList.append(newEntry)
            
            
            }
        }
        catch{
            print("failed to get teams single object data")
        }
        return newEntry
        
    }
    
    func getGroupMembersOfGroup(groupid1:String)->[[String:AnyObject]]
    {
        let group_unique_id = Expression<String>("group_unique_id")
        let member_phone = Expression<String>("member_phone")
        let isAdmin = Expression<String>("isAdmin")
        let membership_status = Expression<String>("membership_status")
        let date_joined = Expression<NSDate>("date_joined")
        let date_left = Expression<NSDate>("date_left")
        let group_member_displayname = Expression<String>("group_member_displayname")
        
        var groupsList=[[String:AnyObject]]()
        
        /* let _id = Expression<String>("_id")
         let deptname = Expression<String>("deptname")
         let deptdescription = Expression<String>("deptdescription")
         let companyid = Expression<String>("companyid")
         let createdby = Expression<String>("createdby")
         let creationdate = Expression<String>("creationdate")
         let deleteStatus = Expression<String>("deleteStatus")
         */
        var tblGroupmember = Table("group_member")
        
        do
        {for groupDetails in try self.db.prepare(tblGroupmember.filter(group_unique_id==groupid1)){
            // print("channel name for deptid \(deptid) is \(channelNames.get(msg_channel_name))")
            var newEntry: [String: AnyObject] = [:]
            newEntry["group_unique_id"]=groupDetails.get(group_unique_id)
            newEntry["member_phone"]=groupDetails.get(member_phone)
            newEntry["isAdmin"]=groupDetails.get(isAdmin)
            newEntry["membership_status"]=groupDetails.get(membership_status)
            
            newEntry["date_joined"]=groupDetails.get(date_joined)
            
            newEntry["date_left"]=groupDetails.get(date_left)
            
            newEntry["group_member_displayname"]=groupDetails.get(group_member_displayname)
            /*newEntry["msg_channel_description"]=channelNames.get(msg_channel_description)
             newEntry["companyid"]=channelNames.get(companyid)
             newEntry["groupid"]=channelNames.get(groupid)
             newEntry["createdby"]=channelNames.get(createdby)
             newEntry["creationdate"]=channelNames.get(creationdate)
             newEntry["deleteStatus"]=channelNames.get(deleteStatus)
             */
            groupsList.append(newEntry)
            
            
            }
        }
        catch{
            print("failed to get groupsList")
        }
        print("groupsList count is \(groupsList.count)")
        return groupsList
        
        
        
    }
    
    func removeMember(groupid1:String,member_phone1:String)
        {
            let group_unique_id = Expression<String>("group_unique_id")
            let member_phone = Expression<String>("member_phone")
            let isAdmin = Expression<String>("isAdmin")
            let membership_status = Expression<String>("membership_status")
            let date_joined = Expression<NSDate>("date_joined")
            let date_left = Expression<NSDate>("date_left")
            let group_member_displayname = Expression<String>("group_member_displayname")
            
        do
        {
        try sqliteDB.db.run(group_member.filter(member_phone==member_phone1 && group_unique_id==groupid1).delete())
        
        }
        catch(let error)
        {
        print("error in deleting group member \(error)")
        if(socketObj != nil)
        {
        socketObj.socket.emit("logClient","IPHONE-LOG: error in deleting group member \(member_phone1) from sqliteDB \(error)")
        }
        
        }
        }
    
    func updateMembershipStatus(groupid1:String,memberphone1:String,membership_status1:String)
    {
        let group_unique_id = Expression<String>("group_unique_id")
        let member_phone = Expression<String>("member_phone")
        let isAdmin = Expression<String>("isAdmin")
        let membership_status = Expression<String>("membership_status")
        let date_joined = Expression<NSDate>("date_joined")
        let date_left = Expression<NSDate>("date_left")
        let group_member_displayname = Expression<String>("group_member_displayname")
        
        
        self.group_member = Table("group_member")
        
        let query = self.group_member.select(membership_status).filter(member_phone == memberphone1 && group_unique_id==groupid1)
        do
        {try sqliteDB.db.run(query.update(membership_status <- membership_status1))}
        catch
        {
            print("error in updating membership status")
            if(socketObj != nil){
                socketObj.socket.emit("logClient","\(username!) error in updating membership satatus of \(memberphone1)")
            }
        }


    }
    
    func getGroupAdmin(id:String)->String{
    
    let group_unique_id = Expression<String>("group_unique_id")
    let member_phone = Expression<String>("member_phone")
    let isAdmin = Expression<String>("isAdmin")
    let membership_status = Expression<String>("membership_status")
    let date_joined = Expression<NSDate>("date_joined")
    let date_left = Expression<NSDate>("date_left")
    let group_member_displayname = Expression<String>("group_member_displayname")
    
    var groupsList=[[String:AnyObject]]()
    
    /* let _id = Expression<String>("_id")
     let deptname = Expression<String>("deptname")
     let deptdescription = Expression<String>("deptdescription")
     let companyid = Expression<String>("companyid")
     let createdby = Expression<String>("createdby")
     let creationdate = Expression<String>("creationdate")
     let deleteStatus = Expression<String>("deleteStatus")
     */
    var tblGroupmember = Table("group_member")
    
    do
    {for groupDetails in try self.db.prepare(tblGroupmember.filter(group_unique_id==id && isAdmin.lowercaseString=="yes")){
        return groupDetails[member_phone]
        }}catch{
            
        }
     return "error"}
    
    func changeRole(groupid1:String,member1:String,isAdmin1:String)
    {
        let group_unique_id = Expression<String>("group_unique_id")
        let member_phone = Expression<String>("member_phone")
        let isAdmin = Expression<String>("isAdmin")
        
        self.group_member = Table("group_member")
        
        let query = self.group_member.select(member_phone).filter(member_phone == member1 && group_unique_id==groupid1)
        do
        {try sqliteDB.db.run(query.update(isAdmin <- isAdmin1))}
        catch
        {
            print("error in updating member role")
           
        }

    }
    
    func getMemberShipStatus(groupid1:String,memberphone:String)->String
    {
            let group_unique_id = Expression<String>("group_unique_id")
            let member_phone = Expression<String>("member_phone")
            let isAdmin = Expression<String>("isAdmin")
            let membership_status = Expression<String>("membership_status")
            let date_joined = Expression<NSDate>("date_joined")
            let date_left = Expression<NSDate>("date_left")
            let group_member_displayname = Expression<String>("group_member_displayname")
            
            var groupsList=[[String:AnyObject]]()
            
            /* let _id = Expression<String>("_id")
             let deptname = Expression<String>("deptname")
             let deptdescription = Expression<String>("deptdescription")
             let companyid = Expression<String>("companyid")
             let createdby = Expression<String>("createdby")
             let creationdate = Expression<String>("creationdate")
             let deleteStatus = Expression<String>("deleteStatus")
             */
            var tblGroupmember = Table("group_member")
            
            do
            {for groupDetails in try self.db.prepare(tblGroupmember.filter(group_unique_id==groupid1 && member_phone==memberphone)){
                
                return groupDetails[membership_status]
                
                }}catch{
                    
            }
            return "error"

    }
    
    func updateGroupChatStatus(uniqueid1:String,memberphone1:String,status1:String,delivereddate1:NSDate!,readDate1:NSDate!)
    {
        let msg_unique_id = Expression<String>("msg_unique_id")
        let Status = Expression<String>("Status")
        let user_phone = Expression<String>("user_phone")
        
        let read_date = Expression<NSDate>("read_date")
        let delivered_date = Expression<NSDate>("delivered_date")
        
        
        
        self.group_chat_status = Table("group_chat_status")

        let query = self.group_chat_status.select(Status).filter(msg_unique_id == uniqueid1 && user_phone == memberphone1)
        do
        {var row=try sqliteDB.db.run(query.update(Status <- status1))
        print("status updated of group chat \(row)")
            if(status1.lowercaseString == "delivered")
            {
            var row=try sqliteDB.db.run(query.update(delivered_date <- delivereddate1))
            }
            else
            {
                var row=try sqliteDB.db.run(query.update(read_date <- readDate1))
            }
        }
        catch
        {
            print("error in updating group chat status \(error)")
            
        }


    }
    
    func storeGRoupsChatStatus(uniqueid1:String,status1:String,memberphone1:String,delivereddate1:NSDate!,readDate1:NSDate!)
    {
        let msg_unique_id = Expression<String>("msg_unique_id")
        let Status = Expression<String>("Status")
        let user_phone = Expression<String>("user_phone")
        let read_date = Expression<NSDate>("read_date")
        let delivered_date = Expression<NSDate>("delivered_date")
        
       // var group_muteSettings=sqliteDB.group_muteSettings
        if(status1.lowercaseString == "seen")
        {
            do {
                let rowid = try db.run(group_chat_status.insert(
                    msg_unique_id<-uniqueid1,
                    Status<-status1,
                    user_phone<-memberphone1,
                    read_date<-readDate1,
                    delivered_date<-delivereddate1
                    ))
                
                
                print("inserted group_chat_status : \(rowid)")
            } catch {
                print("insertion failed: group_chat_status \(error)")
            }
            
        }
        if(status1.lowercaseString == "delivered")
        {
            do {
                let rowid = try db.run(group_chat_status.insert(
                    msg_unique_id<-uniqueid1,
                    Status<-status1,
                    user_phone<-memberphone1,
                    delivered_date<-delivereddate1
                    ))
                
                
                print("inserted group_chat_status : \(rowid)")
            } catch {
                print("insertion failed: group_chat_status \(error)")
            }
        }
        else{
        
        do {
            let rowid = try db.run(group_chat_status.insert(
                msg_unique_id<-uniqueid1,
                Status<-status1,
                user_phone<-memberphone1
                ))
            
            
            print("inserted group_chat_status : \(rowid)")
        } catch {
            print("insertion failed: group_chat_status \(error)")
        }
    }
    
    }
    
    
    func getGroupsChatStatusSingle(uniqueid1:String,user_phone1:String)->String
    {
        let msg_unique_id = Expression<String>("msg_unique_id")
        let Status = Expression<String>("Status")
        let user_phone = Expression<String>("user_phone")
        let read_date = Expression<NSDate>("read_date")
        let delivered_date = Expression<NSDate>("delivered_date")
        
       // var tblGroupmember = Table("group_member")
        var status=""
        do
        {for groupChatStatus in try self.db.prepare(group_chat_status.filter(msg_unique_id==uniqueid1 && user_phone==user_phone1)){
            print("found status matchedddd")
            
            status=groupChatStatus[Status]
            
            }
        }catch{
                
        }
        return status
    }
    
    func getGroupsChatStatusUniqueIDsListNotSeen()->[String]
    {
        let msg_unique_id = Expression<String>("msg_unique_id")
        let Status = Expression<String>("Status")
        let user_phone = Expression<String>("user_phone")
        let read_date = Expression<NSDate>("read_date")
        let delivered_date = Expression<NSDate>("delivered_date")
        
        // var tblGroupmember = Table("group_member")
        var uniqueid=[String]()
        do
        {for groupChatStatus in try self.db.prepare(group_chat_status.filter(Status.lowercaseString != "seen")){
            print("found status NOT SEEN")
            
            uniqueid.append(groupChatStatus[msg_unique_id])
            
            }
        }catch{
          print("error in NOT SEEN status query")
        }
        return uniqueid
    }

    func updateGroupCreationDate(uniqueid1:String,date1:NSDate)
    {
        let date_creation = Expression<NSDate>("date_creation")
        let unique_id = Expression<String>("unique_id")
        
        let query = self.groups.select(unique_id,date_creation)           // SELECT "email" FROM "users"
            .filter(unique_id == uniqueid1)     // WHERE "name" IS NOT NULL
        
        do
        {try sqliteDB.db.run(query.update(date_creation <- date1))}
        catch
        {
            print("error in updating date of group creation")
            if(socketObj != nil){
                socketObj.socket.emit("logClient","\(username!) error in updatingdate of group creation")
            }
        }

       // self.statusUpdate = Table("statusUpdate")
       
    }
    
    func updateGroupChatMessage(group_unique_id1:String,msg1:String)
    {
        
        let from = Expression<String>("from")
        let group_unique_id = Expression<String>("group_unique_id")
        let type = Expression<String>("type")
        let msg = Expression<String>("msg")
        let from_fullname = Expression<String>("from_fullname")
        let date = Expression<NSDate>("date")
        let unique_id = Expression<String>("unique_id")
        
        
        let query = self.group_chat.select(unique_id,msg,date)           // SELECT "email" FROM "users"
            .filter(group_unique_id == group_unique_id1)     // WHERE "name" IS NOT NULL
        
        do
        {try sqliteDB.db.run(query.update(date <- NSDate(),msg <- msg1))}
        catch
        {
            print("error in updating date of group creation")
            if(socketObj != nil){
                socketObj.socket.emit("logClient","\(username!) error in updatingdate of group creation")
            }
        }
        

        
        
    }
    
    func getNameFromAddressbook(phone1:String!)->String!
    {
        let name = Expression<String>("name")
        let phone = Expression<String>("phone")
        
       
        do
        { for res in try sqliteDB.db.prepare(self.allcontacts.filter(phone == phone1))
        {
            return res[name]
        }
        }
        catch
        {
            print("error in getting name from allcontacts")
        }
        return nil
        
    }
    
    func getNameGroupMemberNameFromMembersTable(phone1:String)->String!
    {
        let member_phone = Expression<String>("member_phone")
        let group_member_displayname = Expression<String>("group_member_displayname")
        
        
        do
        { for res in try sqliteDB.db.prepare(self.group_member.filter(member_phone == phone1))
        {
            return res[group_member_displayname]
            }
        }
        catch
        {
            print("error in getting name from allcontacts")
        }
        return nil

    }
    
    func getGroupsChatReadStatusList(msguniqueid1:String)->[[String:AnyObject]]
    {
        let msg_unique_id = Expression<String>("msg_unique_id")
        let Status = Expression<String>("Status")
        let user_phone = Expression<String>("user_phone")
        let read_date = Expression<NSDate>("read_date")
        let delivered_date = Expression<NSDate>("delivered_date")
        
        var statusObjectList=[[String:AnyObject]]()
        // var tblGroupmember = Table("group_member")
       // var uniqueid=[String]()
        do
        {for groupChatStatus in try self.db.prepare(group_chat_status.filter(msg_unique_id == msguniqueid1 && Status.lowercaseString=="seen")){
            print("found status..")
            
            var statusObj=[String:AnyObject]()
            statusObj["msg_unique_id"]=groupChatStatus[msg_unique_id]
            statusObj["Status"]=groupChatStatus[Status]
            statusObj["user_phone"]=groupChatStatus[user_phone]
            statusObj["read_date"]=groupChatStatus[read_date]
            statusObj["delivered_date"]=groupChatStatus[delivered_date]
            
           statusObjectList.append(statusObj)
            //return groupChatStatus[read_date]
            //uniqueid.append(groupChatStatus[msg_unique_id])
            
            }
        }catch{
            print("error in readdate status query")
        }
        return statusObjectList
    }
    
    
    func getGroupsChatDeliveredStatusList(msguniqueid1:String)->[[String:AnyObject]]
    {
        let msg_unique_id = Expression<String>("msg_unique_id")
        let Status = Expression<String>("Status")
        let user_phone = Expression<String>("user_phone")
        let read_date = Expression<NSDate>("read_date")
        let delivered_date = Expression<NSDate>("delivered_date")
        
        var statusObjectList=[[String:AnyObject]]()
        // var tblGroupmember = Table("group_member")
        // var uniqueid=[String]()
        do
        {for groupChatStatus in try self.db.prepare(group_chat_status.filter(msg_unique_id == msguniqueid1 && Status.lowercaseString=="delivered")){
            print("found status..")
            
            var statusObj=[String:AnyObject]()
            statusObj["msg_unique_id"]=groupChatStatus[msg_unique_id]
            statusObj["Status"]=groupChatStatus[Status]
            statusObj["user_phone"]=groupChatStatus[user_phone]
            statusObj["read_date"]=groupChatStatus[read_date]
            statusObj["delivered_date"]=groupChatStatus[delivered_date]
            statusObjectList.append(statusObj)
            
            //return groupChatStatus[delivered_date]
            //uniqueid.append(groupChatStatus[msg_unique_id])
            
            }
        }catch{
            print("error in delivered_date status query")
        }
        return statusObjectList
    }
    
    func getGroupsUnreadMessagesCount(groupid1:String)->Int    {
        
        
        let msg_unique_id = Expression<String>("msg_unique_id")
        let Status = Expression<String>("Status")
        let user_phone = Expression<String>("user_phone")
        let read_date = Expression<NSDate>("read_date")
        let delivered_date = Expression<NSDate>("delivered_date")
        
        let from = Expression<String>("from")
        let group_unique_id = Expression<String>("group_unique_id")
        let type = Expression<String>("type")
        let msg = Expression<String>("msg")
        let from_fullname = Expression<String>("from_fullname")
        let date = Expression<NSDate>("date")
        let unique_id = Expression<String>("unique_id")
        
        var tblgroupchat=sqliteDB.group_chat
        var res=tblgroupchat.filter(group_unique_id==groupid1)
        //to==selecteduser || from==selecteduser
        //print("chat from sqlite is")
        //print(res)
       
        var countunread=0
        do
        {//for tblContacts in try sqliteDB.db.prepare(tbl_userchats.filter(owneruser==owneruser1)){
            ////print("queryy runned count is \(tbl_contactslists.count)")
            for groupsChat in try sqliteDB.db.prepare(tblgroupchat.filter(group_unique_id==groupid1)){
                
                var statusObjectList=[[String:AnyObject]]()
                // var tblGroupmember = Table("group_member")
                // var uniqueid=[String]()
                for groupChatStatus in try self.db.prepare(group_chat_status.filter(msg_unique_id == groupsChat[unique_id] && (Status.lowercaseString=="delivered" || Status.lowercaseString=="sent") && user_phone==username!)){
                    print("found unread message..")
                    countunread++
                    
                    }
              
                
            }
        }catch{
                print("error in delivered_date status query")
            }
              return countunread
    }

    
    func getGroupsChatStatusObjectList(msguniqueid1:String)->[[String:AnyObject]]
    {
        let msg_unique_id = Expression<String>("msg_unique_id")
        let Status = Expression<String>("Status")
        let user_phone = Expression<String>("user_phone")
        let read_date = Expression<NSDate>("read_date")
        let delivered_date = Expression<NSDate>("delivered_date")
        
        // var tblGroupmember = Table("group_member")
        var statusObjectList=[[String:AnyObject]]()
        do
        {for groupChatStatus in try self.db.prepare(group_chat_status.filter(msg_unique_id==msguniqueid1)){
            var statusObj=[String:AnyObject]()
            print("found status object matchedddd")
            
            statusObj["msg_unique_id"]=groupChatStatus[msg_unique_id]
            statusObj["Status"]=groupChatStatus[Status]
            statusObj["user_phone"]=groupChatStatus[user_phone]
            statusObj["read_date"]=groupChatStatus[read_date]
            statusObj["delivered_date"]=groupChatStatus[delivered_date]
            
            statusObjectList.append(statusObj)
            }
        }catch{
            
        }
        return statusObjectList
    }

    
    func getFilesData(uniqueid1:String)->[String:AnyObject]
    {
        let to = Expression<String>("to")
        let from = Expression<String>("from")
        let date = Expression<NSDate>("date")
        let uniqueid = Expression<String>("uniqueid")
        let contactPhone = Expression<String>("contactPhone")
        let type = Expression<String>("type")
        let file_name = Expression<String>("file_name")
        let file_size = Expression<String>("file_size")
        let file_type = Expression<String>("file_type")
        let file_path = Expression<String>("file_path")
        
        var fileObj=[String:AnyObject]()
        
      //  var filesObjectList=[[String:AnyObject]]()
        do
        {for filesData in try self.db.prepare(files.filter(uniqueid==uniqueid1)){
            // print("found status object matchedddd")
            
            fileObj["to"]=filesData[to]
            fileObj["from"]=filesData[from]
            fileObj["date"]=filesData[date]
            fileObj["uniqueid"]=filesData[uniqueid]
            fileObj["contactPhone"]=filesData[contactPhone]
            fileObj["type"]=filesData[type]
            fileObj["file_name"]=filesData[file_name]
            fileObj["file_size"]=filesData[file_size]
            fileObj["file_type"]=filesData[file_type]
            fileObj["file_path"]=filesData[file_path]
            
            break
            }
        }catch{
            
        }
        return fileObj

    }
    
    func checkGroupMessageisAllDelevered(msg_unique_id1:String,members_phones1:[[String:AnyObject]])->Bool
    {
        let msg_unique_id = Expression<String>("msg_unique_id")
        let Status = Expression<String>("Status")
        let user_phone = Expression<String>("user_phone")
        let read_date = Expression<NSDate>("read_date")
        let delivered_date = Expression<NSDate>("delivered_date")
        var result=true
        for(var i=0;i<members_phones1.count;i++)
        {
        do
        {for groupChatStatus in try self.db.prepare(group_chat_status.filter(msg_unique_id==msg_unique_id1 && user_phone==members_phones1[i]["member_phone"] as! String)){
            if(groupChatStatus[Status].lowercaseString != "delivered")
            {
                result=false
            }
        }
        }
        
            catch
            {
                result=false
            }
        }
      return result
        
    }
    
    func checkGroupMessageisAnySent(msg_unique_id1:String,members_phones1:[[String:AnyObject]])->Bool
    {
        let msg_unique_id = Expression<String>("msg_unique_id")
        let Status = Expression<String>("Status")
        let user_phone = Expression<String>("user_phone")
        let read_date = Expression<NSDate>("read_date")
        let delivered_date = Expression<NSDate>("delivered_date")
        var result=true
        for(var i=0;i<members_phones1.count;i++)
        {
            do
            {for groupChatStatus in try self.db.prepare(group_chat_status.filter(msg_unique_id==msg_unique_id1 && user_phone==members_phones1[i]["member_phone"] as! String)){
                if(groupChatStatus[Status].lowercaseString == "sent")
                {
                    result=true
                    break
                }
            else{
            result=false
                }
                }
            }
                
            catch
            {
                result=false
            }
        }
        return result
    }
    
    func checkGroupMessageisAllSeen(msg_unique_id1:String,members_phones1:[[String:AnyObject]])->Bool
    {
        let msg_unique_id = Expression<String>("msg_unique_id")
        let Status = Expression<String>("Status")
        let user_phone = Expression<String>("user_phone")
        let read_date = Expression<NSDate>("read_date")
        let delivered_date = Expression<NSDate>("delivered_date")
        var result=true
        for(var i=0;i<members_phones1.count;i++)
        {
            do
            {for groupChatStatus in try self.db.prepare(group_chat_status.filter(msg_unique_id==msg_unique_id1 && user_phone==members_phones1[i]["member_phone"] as! String)){
                if(groupChatStatus[Status].lowercaseString != "seen")
                {
                    result=false
                }
                }
            }
                
            catch
            {
                result=false
            }
        }
        return result
        
        
    }
    
    func checkIfFileExists(uniqueid1:String)->Bool
    {
        print("ckecking file exists \(uniqueid1)")
        let uniqueid = Expression<String>("uniqueid")
        
        
        var tbl_userfiles=sqliteDB.files
        var fileexists=false
        
        do
        {for groupsinfo in try self.db.prepare(tbl_userfiles.filter(uniqueid == uniqueid1)){
            print("found pending file")
            fileexists=true
            
            }
        }
        catch
        {
            print("error in filee")
        }
        return fileexists
            
    }
    
    
    
}
