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
    var broadcastlisttable:Table!
    var broadcastlistmembers:Table!
    var groupStatusUpdatesTemp:Table!
    var urlData:Table!
    var dayStatusInfoTable:Table!
    var dayStatusUpdatesTable:Table!
    
    
    init(dbName:String)
    {print("inside database handler class")
        
        let fileManager = FileManager.default
        let dirPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let docsDir1 = dirPaths[0] 
        self.dbPath = (docsDir1 as NSString).appendingPathComponent("cloudKiboDatabase2.sqlite3")
        
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
        createBroadcastListTable()
        createBroadcastListMembersTable()
        createGroupStatusTempTable()
        createURLTable()
        createdayStatusInfoTable()
        //createAllContactsTable()
        
    }
    
    func alterTable(_ version:Double)
    {print("alter table")
        if(version < 0.1274)
        {
print("alter table needed")
            let broadcastlistID = Expression<String>("broadcastlistID")
            let isBroadcastMessage = Expression<Bool>("isBroadcastMessage")
            
            do{
            try db.run(self.userschats.addColumn(broadcastlistID, defaultValue: ""))
            try db.run(self.userschats.addColumn(isBroadcastMessage, defaultValue: false))
            }
            catch{
    print("unable to alter \(error)")
            }
        }
        if(version < 0.1312)
        {
            print("alter table needed")
            let isArchived = Expression<Bool>("isArchived")
            
            do{
                try db.run(self.userschats.addColumn(isArchived, defaultValue: false))
            }
            catch{
                print("unable to alter \(error)")
            }
        }
        if(version<0.1316)
        {
            
            print("alter table needed")
            let file_caption = Expression<String>("file_caption")
            
            do{
                try db.run(self.files.addColumn(file_caption, defaultValue:""))
            }
            catch{
                print("unable to alter \(error)")
            }
        }
    }
    
    func resetTables()
    {
        print("resetting tables")
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
        self.broadcastlisttable = Table("broadcastlisttable")
        do{try db.run(self.broadcastlisttable.drop(ifExists: true))
        }
        catch
        {
            print("error in dropping broadcastlisttable table \(error)")
        }
        
        self.broadcastlistmembers = Table("broadcastlistmembers")
        do{try db.run(self.broadcastlistmembers.drop(ifExists: true))
        }
        catch
        {
            print("error in dropping broadcastlistmembers table \(error)")
        }
        
        self.groupStatusUpdatesTemp = Table("groupStatusUpdatesTemp")
        do{try db.run(self.groupStatusUpdatesTemp.drop(ifExists: true))
        }
        catch
        {
            print("error in dropping groupStatusUpdatesTemp table \(error)")
        }
       
        //var broadcastlistmembers:Table!
    }
    
    func createAccountsTable()
    {
        print("creating accounts table")
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
            print("creating accounts table ifnotexist is \(retainOldDatabase)")
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
        let blockedByMe = Expression<Bool>("blockedByMe")
        let IamBlocked = Expression<Bool>("IamBlocked")
        //blockedByMe
        //IamBlocked
        
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
            t.column(blockedByMe, defaultValue: false)
            t.column(IamBlocked, defaultValue: false)
            
            //     "name" TEXT
            })
            
        }
        catch
        {
            if(socketObj != nil){
            socketObj.socket.emit("logClient","IPHONE-LOG: error in creating contacts table \(error)")
            print("error in creating contactslists table \(error)")
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
        let uniqueidentifier = Expression<String>("uniqueidentifier")
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
    
    
    func createURLTable(){
        
        
        let urlMessageID = Expression<String>("urlMessageID")
        let title = Expression<String>("title")
        let desc = Expression<String>("desc")
        let url = Expression<String>("url")
        let msg = Expression<String>("msg")
        let image = Expression<Data>("image")
        
        self.urlData = Table("urlData")
        /*
         var date22=NSDate()
         var formatter = DateFormatter();
         formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ";
         //formatter.dateFormat = "MM/dd hh:mm a"";
         formatter.timeZone = NSTimeZone.local()
         //formatter.dateStyle = .ShortStyle
         //formatter.timeStyle = .ShortStyle
         let defaultTimeZoneStr2 = formatter.stringFromDate(date22);
         var defaultTimeZoneStr = formatter..date(from:defaultTimeZoneStr2)
         */
        // print("default db date is \(defaultTimeZoneStr)")
        do{
            try db.run(urlData.create(ifNotExists: retainOldDatabase) { t in     // CREATE TABLE "accounts" (
                t.column(urlMessageID)//loggedin user id
                t.column(title)
                t.column(desc)
                t.column(url)
                t.column(msg)
                t.column(image, defaultValue:Data.init())
                
                //t.column(file_path, defaultValue:"")
                
                //     "name" TEXT
            })
            
        }
        catch(let error)
        {

            
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
        let date = Expression<Date>("date")
        let uniqueid = Expression<String>("uniqueid")
        let status = Expression<String>("status")
        let contactPhone = Expression<String>("contactPhone")
        let type = Expression<String>("type")
        let file_type = Expression<String>("file_type")
        let file_path = Expression<String>("file_path")
        let broadcastlistID = Expression<String>("broadcastlistID")
        let isBroadcastMessage = Expression<Bool>("isBroadcastMessage")
        let isArchived = Expression<Bool>("isArchived")
        
        //let file_path = Expression<String>("file_path")

        
       // let dateFormatter = DateFormatter()
       // dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
       // dateFormatter.
        //let datens2 = dateFormatter.date(from:NSDate().debugDescription)
       //print("defaultDate is \(datens2)")
        self.userschats = Table("userschats")
        /*
        var date22=NSDate()
        var formatter = DateFormatter();
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ";
        //formatter.dateFormat = "MM/dd hh:mm a"";
        formatter.timeZone = NSTimeZone.local()
        //formatter.dateStyle = .ShortStyle
        //formatter.timeStyle = .ShortStyle
        let defaultTimeZoneStr2 = formatter.stringFromDate(date22);
        var defaultTimeZoneStr = formatter..date(from:defaultTimeZoneStr2)
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
                t.column(broadcastlistID, defaultValue:"")
                t.column(isBroadcastMessage, defaultValue:false)
                t.column(isArchived, defaultValue:false)
                //t.column(file_path, defaultValue:"")
                
                //     "name" TEXT
                })
            
        }
        catch(let error)
        {
            if(socketObj != nil)
            {
            socketObj.socket.emit("logClient","IPHONE-LOG: error in creating chat table \(error)")
            print("error in creating userschats table \(error)")
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
        let muteTime = Expression<Date>("muteTime")
        let unMuteTime = Expression<Date>("unMuteTime")

        
        
        self.group_muteSettings = Table("group_muteSettings")
        do{
            try db.run(group_muteSettings.create(ifNotExists: retainOldDatabase) { t in
                t.column(groupid, unique:true)
                t.column(isMute, defaultValue:false)
                t.column(muteTime)
                 t.column(unMuteTime)
                })
            
        }
        catch
        {
             print("error in creating group_muteSettings table")
       
        
    }
    }
    
    func createBroadcastListTable(){
        
        self.broadcastlisttable = Table("broadcastlistmembers")
        //self.broadcastlisttable.drop()
        //let contactObject=Expression<CNContact>("contactObj")
        //let kiboContact = Expression<Bool>("kiboContact")
        let uniqueid = Expression<String>("uniqueid")
        let listname = Expression<String>("listname")
        let listIsArchived = Expression<Bool>("listIsArchived")
        //
        self.broadcastlisttable = Table("broadcastlisttable")
        do{
            try db.run(broadcastlisttable.create(ifNotExists: retainOldDatabase) { t in     // CREATE TABLE "accounts" (
                t.column(uniqueid, unique:true)
                t.column(listname)
                t.column(listIsArchived, defaultValue:false)
                //////////////t.column(profileimage, defaultValue:NSData.init())
                })
            
        }
        catch(let error)
        {
            if(socketObj != nil)
            {
                socketObj.socket.emit("logClient","IPHONE-LOG: error in creating broadcastlist table \(error)")
            }
                print("error in creating broadcastlist table")
          
        }
    }
    
    
        func createBroadcastListMembersTable(){
            print("creatinggg")
            
            self.broadcastlistmembers = Table("broadcastlistmembers")
            if(socketObj != nil)
            {socketObj.socket.emit("logClient","IPHONE-LOG: creating broadcastlistmembers table")}
            //let contactObject=Expression<CNContact>("contactObj")
            //let kiboContact = Expression<Bool>("kiboContact")
            let uniqueid = Expression<String>("uniqueid")
            let memberphone = Expression<String>("memberphone")
            //
            self.broadcastlistmembers = Table("broadcastlistmembers")
            do{
                try db.run(broadcastlistmembers.create(ifNotExists: retainOldDatabase) { t in     // CREATE TABLE "accounts" (
                    t.column(uniqueid)
                    t.column(memberphone)
                    //////////////t.column(profileimage, defaultValue:NSData.init())
                    })
                
            }
            catch(let error)
            {
                if(socketObj != nil)
                {
                    socketObj.socket.emit("logClient","IPHONE-LOG: error in creating broadcastlist members table \(error)")
                    print("error in creating broadcastlist members table")
                    
                }
            }
            
    }
    
    func createdayStatusInfoTable(){
        
        //self.broadcastlisttable.drop()
        //let contactObject=Expression<CNContact>("contactObj")
        //let kiboContact = Expression<Bool>("kiboContact")
        let daystatus_id = Expression<String>("daystatus_id")
        let daystatus_type = Expression<String>("daystatus_type")
        let daystatus_caption = Expression<String>("daystatus_caption")
        let daystatus_uploadDate = Expression<Date>("daystatus_uploadDate")
        let daystatus_filename = Expression<String>("daystatus_filename")
        let daystatus_filesize = Expression<String>("daystatus_filesize")
        let daystatus_filepath = Expression<String>("Daystatus_filepath")
        let daystatus_uploadedBy = Expression<String>("daystatus_uploadedBy")
        //
        self.dayStatusInfoTable = Table("dayStatusInfoTable")
        do{
            try db.run(dayStatusInfoTable.create(ifNotExists: retainOldDatabase) { t in     // CREATE TABLE "accounts" (
                t.column(daystatus_id, unique:true)
                t.column(daystatus_type)
                t.column(daystatus_caption)
                t.column(daystatus_uploadDate)
                t.column(daystatus_filename)
                t.column(daystatus_filesize)
                t.column(daystatus_filepath)
                t.column(daystatus_uploadedBy)
                //////////////t.column(profileimage, defaultValue:NSData.init())
            })
            
        }
        catch(let error)
        {
            if(socketObj != nil)
            {
                socketObj.socket.emit("logClient","IPHONE-LOG: error in creating day status table \(error)")
            }
            print("error in creating day status table")
            
        }
    }
    
    func createDayStatusUpdatesTable()
    {
        let daystatus_id = Expression<String>("daystatus_id")
        let daystatus_status = Expression<String>("daystatus_status")
        let daystatus_contactphone = Expression<String>("daystatus_contactphone")
        
        
        
        self.dayStatusUpdatesTable = Table("dayStatusUpdatesTable")
        do{
            try db.run(dayStatusUpdatesTable.create(ifNotExists: retainOldDatabase) { t in
                t.column(daystatus_id)
                t.column(daystatus_status)
                t.column(daystatus_contactphone)
            })
            
        }
        catch
        {
            print("error in creating group_muteSettings table")
            
            
        }
    }

    func storeDayStatusInfoTable(_ daystatus_id1:String,daystatus_type1:String,daystatus_caption1:String,daystatus_uploadDate1:Date,daystatus_filename1:String,daystatus_filesize1:String,daystatus_filepath1:String,daystatus_uploadedBy1:String)
    {
        let daystatus_id = Expression<String>("daystatus_id")
        let daystatus_type = Expression<String>("daystatus_type")
        let daystatus_caption = Expression<String>("daystatus_caption")
        let daystatus_uploadDate = Expression<Date>("daystatus_uploadDate")
        let daystatus_filename = Expression<String>("daystatus_filename")
        let daystatus_filesize = Expression<String>("daystatus_filesize")
        let daystatus_filepath = Expression<String>("Daystatus_filepath")
        let daystatus_uploadedBy = Expression<String>("daystatus_uploadedBy")
        
        
        let dayStatusInfoTable=sqliteDB.dayStatusInfoTable
        
        do {
            let rowid = try db.run((dayStatusInfoTable?.insert(
                daystatus_id<-daystatus_id1,
                daystatus_type<-daystatus_type1,
                daystatus_caption<-daystatus_caption1,
                daystatus_uploadDate<-daystatus_uploadDate1,
                daystatus_filename<-daystatus_filename1,
                daystatus_filesize<-daystatus_filesize1,
                daystatus_filepath<-daystatus_filepath1,
                daystatus_uploadedBy<-daystatus_uploadedBy1
                ))!)
            
            
            print("inserted id dayStatusInfoTable : \(rowid)")
        } catch {
            print("insertion failed: dayStatusInfoTable \(error)")
        }
        
    }
    
    func storeDayStatusInfoTable(_ daystatus_id1:String,daystatus_status1:String,daystatus_contactphone1:String)
    {
        let daystatus_id = Expression<String>("daystatus_id")
        let daystatus_status = Expression<String>("daystatus_status")
        let daystatus_contactphone = Expression<String>("daystatus_contactphone")
        
        
        
        self.dayStatusUpdatesTable = Table("dayStatusUpdatesTable")
        
        do {
            let rowid = try db.run((dayStatusUpdatesTable?.insert(
                daystatus_id<-daystatus_id1,
                daystatus_status<-daystatus_status1,
                daystatus_contactphone<-daystatus_contactphone1
                ))!)
            
            
            print("inserted id dayStatusUpdatesTable : \(rowid)")
        } catch {
            print("insertion failed: dayStatusUpdatesTable \(error)")
        }
        
    }
    
    
        func storeMuteGroupSettingsTable(_ groupid1:String,isMute1:Bool,muteTime1:Date,unMuteTime1:Date)
        {
            let groupid = Expression<String>("groupid")
            let isMute = Expression<Bool>("isMute")
            let muteTime = Expression<Date>("muteTime")
            let unMuteTime = Expression<Date>("unMuteTime")
            
            
            let group_muteSettings=sqliteDB.group_muteSettings
            
            do {
                let rowid = try db.run((group_muteSettings?.insert(
                    groupid<-groupid1,
                    isMute<-isMute1,
                    muteTime<-muteTime1,
                    unMuteTime<-unMuteTime1
                    ))!)
                
               
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
        let date = Expression<Date>("date")
        let uniqueid = Expression<String>("uniqueid") //chat uniqueid OR group image id
        let contactPhone = Expression<String>("contactPhone")
        let type = Expression<String>("type")  //image or document
        let file_name = Expression<String>("file_name")
        let file_size = Expression<String>("file_size")
        let file_type = Expression<String>("file_type")
        let file_path = Expression<String>("file_path")
        let file_caption = Expression<String>("file_caption")
        
        
        // let dateFormatter = DateFormatter()
        // dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        // dateFormatter.
        //let datens2 = dateFormatter.date(from:NSDate().debugDescription)
        //print("defaultDate is \(datens2)")
        self.files = Table("files")
        
        /*var date22=NSDate()
        var formatter = DateFormatter();
        //formatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZ";
        formatter.dateFormat = "MM/dd hh:mm a"";
        formatter.timeZone = NSTimeZone.local()
        //formatter.dateStyle = .ShortStyle
        //formatter.timeStyle = .ShortStyle
        let defaultTimeZoneStr = formatter.stringFromDate(date22);*/
        let date22=Date()
        let formatter = DateFormatter();
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ";
        //formatter.dateFormat = "MM/dd hh:mm a"";
        formatter.timeZone = TimeZone.autoupdatingCurrent
        //formatter.dateStyle = .ShortStyle
        //formatter.timeStyle = .ShortStyle
        let defaultTimeZoneStr2 = formatter.string(from: date22);
        let defaultTimeZoneStr = formatter.date(from: defaultTimeZoneStr2)
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
                t.column(file_caption, defaultValue:"")
                
                //     "name" TEXT
                })
            
        }
        catch(let error)
        {if(socketObj != nil){
            socketObj.socket.emit("logClient","IPHONE-LOG: error in creating chat table \(error)")
            }
            print("error in creating file table")
        }
    }
    
    
    
    
    
    func createGroupStatusTempTable()
    {
        if(socketObj != nil)
        {
            
            socketObj.socket.emit("logClient","IPHONE-LOG: creating groupStatusUpdatesTemp table")
        }
        let status = Expression<String>("status")
        let sender = Expression<String>("sender")
        let messageuniqueid = Expression<String>("messageuniqueid")

        
        self.groupStatusUpdatesTemp = Table("groupStatusUpdatesTemp")
        do{
            try db.run(groupStatusUpdatesTemp.create(ifNotExists: retainOldDatabase) { t in
                t.column(status)
                t.column(sender)
                t.column(messageuniqueid)
            })
            
        }
        catch
        {
            if(socketObj != nil)
            {socketObj.socket.emit("logClient","IPHONE-LOG: error in creating messageStatus table \(error)")}
            print("error in creating messageStatus table")
        }
        
    }
    
    func saveMessageStatusSeen(_ status1:String,sender1:String,uniqueid1:String)
    {
        
        let status = Expression<String>("status")
        let sender = Expression<String>("sender")
        let uniqueid = Expression<String>("uniqueid")
        
        let statusUpdate=sqliteDB.statusUpdate
        
        do {
            let rowid = try db.run((statusUpdate?.insert(
                status<-status1,
                sender<-sender1,
                uniqueid<-uniqueid1
                ))!)
            
            if(socketObj != nil)
            {
           // socketObj.socket.emit("logClient","IPHONE-LOG: all messageStatus saved in sqliteDB")
            }
            print("inserted id messageStatus : \(rowid)")
        } catch {
            print("insertion failed: messageStatus \(error)")
        }
        
        
        
    }
    func saveGroupStatusTemp(_ status1:String,sender1:String,messageuniqueid1:String)
    {
    let status = Expression<String>("status")
    let sender = Expression<String>("sender")
    let messageuniqueid = Expression<String>("messageuniqueid")
    
    
    self.groupStatusUpdatesTemp = Table("groupStatusUpdatesTemp")
        
        do {
            let rowid = try db.run((groupStatusUpdatesTemp?.insert(
                status<-status1,
                sender<-sender1,
                messageuniqueid<-messageuniqueid1
                ))!)
            
            if(socketObj != nil)
            {
                // socketObj.socket.emit("logClient","IPHONE-LOG: all messageStatus saved in sqliteDB")
            }
            print("inserted id groupStatusUpdatesTemp : \(rowid)")
        } catch {
            print("insertion failed: error - groupStatusUpdatesTemp \(error)")
        }
    }
    
    
    func removeGroupStatusTemp(_ status1:String,memberphone1:String,messageuniqueid1:String)
    {
        let status = Expression<String>("status")
        let sender = Expression<String>("sender")
        let messageuniqueid = Expression<String>("messageuniqueid")
        
        
        self.groupStatusUpdatesTemp = Table("groupStatusUpdatesTemp")
        do
        {
            try sqliteDB.db.run((groupStatusUpdatesTemp?.filter(messageuniqueid==messageuniqueid1).delete())!)
            
        }
        catch(let error)
        {
            print("error in deleting groupStatusUpdatesTemp \(error)")
            if(socketObj != nil)
            {
                socketObj.socket.emit("logClient","IPHONE-LOG: error in deleting groupStatusUpdatesTemp from sqliteDB \(error)")
            }
            
        }

    }
    func removeMessageStatusSeen(_ uniqueid1:String)
    {
        
        let status = Expression<String>("status")
        let sender = Expression<String>("sender")
        let uniqueid = Expression<String>("uniqueid")
        
        let statusUpdate=sqliteDB.statusUpdate
        
        do
        {
            try sqliteDB.db.run((statusUpdate?.filter(uniqueid==uniqueid1).delete())!)
            
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
    
    
    
    func saveCallHist(_ name1:String,dateTime1:String,type1:String)
    {
        print("saving call history, call received from \(name1) type is \(type1) datetime is \(dateTime1)")
        if(socketObj != nil)
        {socketObj.socket.emit("\(username!) is saving call history, call received from \(name1) type is \(type1) datetime is \(dateTime1)")
        }
        // let contactObject=Expression<CNContact>("contactObj")
        
        let name = Expression<String>("name")
        let dateTime = Expression<String>("dateTime")
        let type = Expression<String>("type")
        
        let date22=Date()
        let formatter = DateFormatter();
        //formatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZ";
         formatter.dateFormat = "MM/dd hh:mm a";
        formatter.timeZone = TimeZone.autoupdatingCurrent
        //formatter.dateStyle = .ShortStyle
        //formatter.timeStyle = .ShortStyle
        let defaultTimeZoneStr = formatter.string(from: date22);
        
        
        
        
        let tbl_callHist=sqliteDB.callHistory
        
        do {
            let rowid = try db.run((tbl_callHist?.insert(
                name<-name1,
                dateTime<-defaultTimeZoneStr,
                type<-type1
                ))!)
           if(socketObj != nil)
           {socketObj.socket.emit("logClient","IPHONE-LOG: Call History saved in sqliteDB")}
            print("inserted id callHist : \(rowid)")
        } catch {
            print("insertion failed: callHist \(error)")
        }
        
        
        
    }
    
    
    func saveAllContacts(_ uniqueidentifier1:String,name1:String,phone1:String,actualphone1:String,kiboContact1:Bool,email1:String)
    {
        // let contactObject=Expression<CNContact>("contactObj")
        let uniqueidentifier = Expression<String>("uniqueidentifier")
        let name = Expression<String>("name")
        let phone = Expression<String>("phone")
        let actualphone = Expression<String>("actualphone")
        let email = Expression<String>("email")

        let kiboContact = Expression<Bool>("kiboContact")
        
        let tbl_allcontacts=sqliteDB.allcontacts
        
        do {
            let rowid = try db.run((tbl_allcontacts?.insert(
                uniqueidentifier<-uniqueidentifier1,
                name<-name1,
                phone<-phone1,
                email<-email1,
                actualphone<-actualphone1,
                kiboContact<-kiboContact1
                ))!)
            if(socketObj != nil){
            socketObj.socket.emit("logClient","IPHONE-LOG: all contacts saved in sqliteDB")
            }
            print("inserted id allcontacts : \(rowid)")
        } catch {
            print("insertion failed: allcontacts \(error)")
        }
        


    }
    func UpdateChatStatus(_ uniqueid1:String,newstatus:String)
    {
       //  UtilityFunctions.init().log_papertrail("IPHONE: \(username!) inside database function to update chat status")
        
        let uniqueid = Expression<String>("uniqueid")
        let status = Expression<String>("status")

        
        let tbl_userchats=sqliteDB.userschats
        
        let query = tbl_userchats?.select(status)           // SELECT "email" FROM "users"
            .filter(uniqueid == uniqueid1)     // WHERE "name" IS NOT NULL
        
             do{for tblContacts in try sqliteDB.db.prepare((tbl_userchats?.filter(uniqueid == uniqueid1))!){
                if(tblContacts[status] != "seen")
                {
                    var res=try sqliteDB.db.run((query?.update(status <- newstatus))!)
                    
                    print("update status query runned \(res.description)")
                }
                else{
                    print("already seen so no update")
                }
                }
           
        }
        catch
        {
            print("error in updating chat")
            if(socketObj != nil){
            socketObj.socket.emit("logClient","\(username!) error in updating chat satatus")
            }
        }
}
    
    func UpdateChat(_ uniqueid1:String,type1:String)
    {
        //  UtilityFunctions.init().log_papertrail("IPHONE: \(username!) inside database function to update chat status")
        print("uniqueid is \(uniqueid1) and type1 is \(type1)")
        let uniqueid = Expression<String>("uniqueid")
        let status = Expression<String>("status")
        let to = Expression<String>("to")
        let from = Expression<String>("from")
        let owneruser = Expression<String>("owneruser")
        let fromFullName = Expression<String>("fromFullName")
        let msg = Expression<String>("msg")
        let date = Expression<Date>("date")
        let contactPhone = Expression<String>("contactPhone")
        let type = Expression<String>("type")
        let file_type = Expression<String>("file_type")
        let file_path = Expression<String>("file_path")
        
        
        
        let tbl_userchats=sqliteDB.userschats
        
        let query = tbl_userchats?.select(status)           // SELECT "email" FROM "users"
            .filter(uniqueid == uniqueid1)     // WHERE "name" IS NOT NULL
        
        do{for tblContacts in try sqliteDB.db.prepare((tbl_userchats?.filter(uniqueid == uniqueid1))!)
        {
               var res=try sqliteDB.db.run((query?.update(type <- type1))!)
            print("chat type updated result is \(res) msg is \(tblContacts[msg])")
            break
                
                          }
            
        }
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
                var formatter = DateFormatter();
                //formatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZ";
                formatter.dateFormat = "MM/dd hh:mm a"";
                formatter.timeZone = NSTimeZone.local()
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
    func SaveURLData(_ urlMessageID1:String,title1:String,desc1:String,url1:String,msg1:String,image1:Data?)
    {
        
        let urlMessageID = Expression<String>("urlMessageID")
    let title = Expression<String>("title")
    let desc = Expression<String>("desc")
    let url = Expression<String>("url")
    let msg = Expression<String>("msg")
    let image = Expression<Data>("image")
    
    self.urlData = Table("urlData")
        do{
            let rowid = try db.run((urlData?.insert(urlMessageID<-urlMessageID1,
                                                    title<-title1,
                                                    desc<-desc1,
                                                    url<-url1,
                                                    msg<-msg1,
                                                    image<-Data.init()
                
                
                ))!)
        }
        catch{
            
        }
    
}
    func SaveChat(_ to1:String,from1:String,owneruser1:String,fromFullName1:String,msg1:String,date1:Date!,uniqueid1:String!,status1:String,type1:String,file_type1:String,file_path1:String)
    {
        //createUserChatTable()
        // UtilityFunctions.init().log_papertrail("IPHONE:\(username!) inside database function to SAVE chat")
        
        let to = Expression<String>("to")
        let from = Expression<String>("from")
        let owneruser = Expression<String>("owneruser")
        let fromFullName = Expression<String>("fromFullName")
        let msg = Expression<String>("msg")
        let date = Expression<Date>("date")
        let uniqueID = Expression<String>("uniqueid")
        let status = Expression<String>("status")
        let contactPhone = Expression<String>("contactPhone")
        let type = Expression<String>("type")
        let file_type = Expression<String>("file_type")
        let file_path = Expression<String>("file_path")
        
        let broadcastlistID = Expression<String>("broadcastlistID")
        let isBroadcastMessage = Expression<Bool>("isBroadcastMessage")
        let isArchived = Expression<Bool>("isArchived")
        
        
        let tbl_userchats=sqliteDB.userschats
        
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
        var mydate:Date!
        if(date1 == nil)
        {
            print("date got is null to put current date/time")
            
            
            let date22=Date()
            let formatter = DateFormatter();
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ";
            ///newwwwwwww
            formatter.timeZone = TimeZone.autoupdatingCurrent
            
            
            
            //formatter.dateFormat = "MM/dd hh:mm a"";
            ////////////////==formatter.timeZone = NSTimeZone.defaultTimeZone()
            //formatter.dateStyle = .ShortStyle
            //formatter.timeStyle = .ShortStyle
            let defaultTimeZoneStr2 = formatter.string(from: date22);
            
            
            let formatter2 = DateFormatter();
            formatter2.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ";
            
            //////formatter.timeZone = NSTimeZone.local()
            let defaultTimeZoneStr = formatter2.date(from: defaultTimeZoneStr2)
            print("default db date is \(defaultTimeZoneStr!)")
            
            print("===fetch chat inside database handler string \(defaultTimeZoneStr2) .. converted NSDate is \(defaultTimeZoneStr!)... now date 22 is \(date22)")
            
            mydate=date22
            ////mydate=defaultTimeZoneStr!
            
        }
        else
        {
            
            
            print("date got is not null. converting")
            //var date22=NSDate()
            let formatter = DateFormatter();
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ";
            //formatter.dateFormat = "MM/dd hh:mm a"";
            formatter.timeZone = TimeZone.autoupdatingCurrent
            
            let defaultTimeZoneStr2 = formatter.string(from: date1);
            let defaultTimeZoneStr = formatter.date(from: defaultTimeZoneStr2)
            
            ////var defaultTimeZoneStr = formatter..date(from:date1)
            print("default db date from server is \(defaultTimeZoneStr!)")
            
            print("===fetch chat inside database handler got date as \(date1) .. date string is \(defaultTimeZoneStr2) ...converted NSDate is \(defaultTimeZoneStr!)  ... date1 got is \(date1)")
            
            
            
            mydate=defaultTimeZoneStr!
        }
        
        do {
            
            var alreadyexists=false
            for res in try sqliteDB.db.prepare((tbl_userchats?.filter(uniqueID == uniqueid1))!)
            {
                // print("chat already exists")
                alreadyexists=true
            }
            
            var isArchived1=false
            for res in try sqliteDB.db.prepare((tbl_userchats?.filter(contactPhone == contactPhone1))!)
            {
                isArchived1=res.get(isArchived)
            }
            if(alreadyexists==false)
            {
                print("adding chat \(file_type1) .. \(msg1) .. type \(type1)")
                let rowid = try db.run((tbl_userchats?.insert(fromFullName<-fromFullName1,
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
                    file_path<-file_path1,
                    isArchived<-isArchived1
                    ))!)
                
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
    

    
    func SaveBroadcastChat(_ to1:String,from1:String,owneruser1:String,fromFullName1:String,msg1:String,date1:Date!,uniqueid1:String!,status1:String,type1:String,file_type1:String,file_path1:String,broadcastlistID1:String)
    {
        //createUserChatTable()
    // UtilityFunctions.init().log_papertrail("IPHONE:\(username!) inside database function to SAVE chat")
        
        let to = Expression<String>("to")
        let from = Expression<String>("from")
        let owneruser = Expression<String>("owneruser")
        let fromFullName = Expression<String>("fromFullName")
        let msg = Expression<String>("msg")
        let date = Expression<Date>("date")
         let uniqueID = Expression<String>("uniqueid")
        let status = Expression<String>("status")
        let contactPhone = Expression<String>("contactPhone")
        let type = Expression<String>("type")
        let file_type = Expression<String>("file_type")
        let file_path = Expression<String>("file_path")
        let broadcastlistID = Expression<String>("broadcastlistID")
        let isBroadcastMessage = Expression<Bool>("isBroadcastMessage")
        
        let tbl_userchats=sqliteDB.userschats
        
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
        var mydate:Date!
        if(date1 == nil)
        {
            print("date got is null to put current date/time")
          
            
            let date22=Date()
            let formatter = DateFormatter();
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ";
            ///newwwwwwww
             formatter.timeZone = TimeZone.autoupdatingCurrent
           
            
            
            //formatter.dateFormat = "MM/dd hh:mm a"";
            ////////////////==formatter.timeZone = NSTimeZone.defaultTimeZone()
            //formatter.dateStyle = .ShortStyle
            //formatter.timeStyle = .ShortStyle
            let defaultTimeZoneStr2 = formatter.string(from: date22);
            
            
            let formatter2 = DateFormatter();
            formatter2.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ";
            
            //////formatter.timeZone = NSTimeZone.local()
            let defaultTimeZoneStr = formatter2.date(from: defaultTimeZoneStr2)
            print("default db date is \(defaultTimeZoneStr!)")
            
            print("===fetch chat inside database handler string \(defaultTimeZoneStr2) .. converted NSDate is \(defaultTimeZoneStr!)... now date 22 is \(date22)")
            
            mydate=date22
            ////mydate=defaultTimeZoneStr!
            
            }
        else
        {
            
            
              print("date got is not null. converting")
            //var date22=NSDate()
            let formatter = DateFormatter();
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ";
            //formatter.dateFormat = "MM/dd hh:mm a"";
            formatter.timeZone = TimeZone.autoupdatingCurrent
            
            let defaultTimeZoneStr2 = formatter.string(from: date1);
            let defaultTimeZoneStr = formatter.date(from: defaultTimeZoneStr2)
            
           ////var defaultTimeZoneStr = formatter..date(from:date1)
            print("default db date from server is \(defaultTimeZoneStr!)")
            
              print("===fetch chat inside database handler got date as \(date1) .. date string is \(defaultTimeZoneStr2) ...converted NSDate is \(defaultTimeZoneStr!)  ... date1 got is \(date1)")

            
            
            mydate=defaultTimeZoneStr!
        }
        
     /*   do {
            
            var alreadyexists=false
            for res in try sqliteDB.db.prepare(tbl_userchats.filter(uniqueID == uniqueid1))
            {
               // print("chat already exists")
                alreadyexists=true
            }
            
            if(alreadyexists==false)
{*/
        do{print("adding chat \(file_type1) .. \(msg1) .. type \(type1)")
            let rowid = try db.run((tbl_userchats?.insert(fromFullName<-fromFullName1,
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
                file_path<-file_path1,
                broadcastlistID<-broadcastlistID1,
                isBroadcastMessage<-true
                ))!)}
        catch{
            
        }
    }
    
   // UtilityFunctions.init().log_papertrail("IPHONE_LOG: \(username!) saving chat in db \(rowid)")
          /*  }
            else
            {
                print("chat data already available, avoid duplicates")
            }*/
            //////print("inserted id: \(rowid)")
        //}
    //catch {
          //  UtilityFunctions.init().log_papertrail("IPHONE_LOG: \(username!) error: failed to save chat")
            
           // print("insertion failed: \(error)")
      //  }
        
        
        /*if let rowid = insert.rowid {
            print("inserted id: \(rowid)")
        } else if insert.statement.failed {
            print("insertion failed: \(insert.statement.reason)")
        }*/
        
        
    
    func updateFileInfo(_ to1:String,from1:String,owneruser1:String,file_name1:String,date1:String!,uniqueid1:String!,file_size1:String,file_type1:String,file_path1:String, type1:String, caption1:String)
    {
    //var chatType="image"
    
    //createUserChatTable()
    let to = Expression<String>("to")
    let from = Expression<String>("from")
    let date = Expression<Date>("date")
    let uniqueid = Expression<String>("uniqueid")
    let contactPhone = Expression<String>("contactPhone")
    let type = Expression<String>("type")
    let file_name = Expression<String>("file_name")
    let file_size = Expression<String>("file_size")
    let file_type = Expression<String>("file_type")
    let file_path = Expression<String>("file_path")
    let file_caption = Expression<String>("file_caption")
        
    
    let tbl_userfiles=sqliteDB.files
    
    var contactPhone1=""
    if(to1 != owneruser1)
    {
    contactPhone1=to1
    }
    else
    {
    contactPhone1=from1
    }
        var mydate:Date!
    if(date1 == nil)
    {
    let date22=Date()
    let formatter = DateFormatter();
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ";
    //formatter.dateFormat = "MM/dd hh:mm a"";
    formatter.timeZone = TimeZone.autoupdatingCurrent
    //formatter.dateStyle = .ShortStyle
    //formatter.timeStyle = .ShortStyle
    let defaultTimeZoneStr2 = formatter.string(from: date22);
    let defaultTimeZoneStr = formatter.date(from: defaultTimeZoneStr2)
    print("default db date is \(defaultTimeZoneStr)")
    
    mydate=defaultTimeZoneStr
    
    
    }
    else
    {
    
    //var date22=NSDate()
    let formatter = DateFormatter();
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ";
    //formatter.dateFormat = "MM/dd hh:mm a"";
    formatter.timeZone = TimeZone.autoupdatingCurrent
    let defaultTimeZoneStr = formatter.date(from: date1)
    print("default db date from server is \(defaultTimeZoneStr)")
    
    
    mydate=defaultTimeZoneStr
    }
    /*
     t.column(type, defaultValue:"chat")
     t.column(file_type, defaultValue:"")
     t.column(file_path, defaultValue:"")
     */
    
        
        let query = tbl_userfiles?.select(to,from,date,uniqueid,contactPhone,type,file_name,file_size,file_type,file_path)           // SELECT "email" FROM "users"
            .filter(uniqueid == uniqueid1)     // WHERE "name" IS NOT NULL
        
        
        do
        {try sqliteDB.db.run((query?.update(to<-to1,
                                            from<-from1,
                                            date<-mydate,
                                            uniqueid<-uniqueid1,
                                            contactPhone<-contactPhone1,
                                            type<-type1,  //image or document
            file_name<-file_name1,
            file_size<-file_size1,
            file_type<-file_type1,
            file_path<-file_path1,
            file_caption<-caption1))!)}
        catch
        {
            print("error: cannot update file info")
        }
   
    
    
    /*if let rowid = insert.rowid {
     print("inserted id: \(rowid)")
     } else if insert.statement.failed {
     print("insertion failed: \(insert.statement.reason)")
     }*/
    
    
    }
    
    func saveFile(_ to1:String,from1:String,owneruser1:String,file_name1:String,date1:String!,uniqueid1:String!,file_size1:String,file_type1:String,file_path1:String, type1:String, caption1:String)
        
    {
        //var chatType="image"
        
        //createUserChatTable()
        let to = Expression<String>("to")
        let from = Expression<String>("from")
        let date = Expression<Date>("date")
        let uniqueid = Expression<String>("uniqueid")
        let contactPhone = Expression<String>("contactPhone")
        let type = Expression<String>("type")
        let file_name = Expression<String>("file_name")
        let file_size = Expression<String>("file_size")
        let file_type = Expression<String>("file_type")
        let file_path = Expression<String>("file_path")
        let file_caption = Expression<String>("file_caption")
        
        
        let tbl_userfiles=sqliteDB.files
        
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
        var mydate:Date!
        if(date1 == nil)
        {
            let date22=Date()
            let formatter = DateFormatter();
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ";
            //formatter.dateFormat = "MM/dd hh:mm a"";
            formatter.timeZone = TimeZone.autoupdatingCurrent
            //formatter.dateStyle = .ShortStyle
            //formatter.timeStyle = .ShortStyle
            let defaultTimeZoneStr2 = formatter.string(from: date22);
            let defaultTimeZoneStr = formatter.date(from: defaultTimeZoneStr2)
            print("default db date is \(defaultTimeZoneStr)")
            
            mydate=defaultTimeZoneStr

            
        }
        else
        {
            
            //var date22=NSDate()
            let formatter = DateFormatter();
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ";
            //formatter.dateFormat = "MM/dd hh:mm a"";
            formatter.timeZone = TimeZone.autoupdatingCurrent
            let defaultTimeZoneStr = formatter.date(from: date1)
            print("default db date from server is \(defaultTimeZoneStr)")
            

            mydate=defaultTimeZoneStr
        }
        /*
         t.column(type, defaultValue:"chat")
         t.column(file_type, defaultValue:"")
         t.column(file_path, defaultValue:"")
         */
        
        do {
            let rowid = try db.run((tbl_userfiles?.insert(
                to<-to1,
                from<-from1,
                date<-mydate,
                uniqueid<-uniqueid1,
                contactPhone<-contactPhone1,
                type<-type1,  //image or document
                file_name<-file_name1,
                file_size<-file_size1,
                file_type<-file_type1,
                file_path<-file_path1,
                file_caption<-caption1
                ))!)
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
    

    
    
    func retrieveChat(_ owneruser1:String)
    {
        
        let to = Expression<String>("to")
        let from = Expression<String>("from")
        let owneruser = Expression<String>("owneruser")
        let fromFullName = Expression<String>("fromFullName")
        let msg = Expression<String>("msg")
        let date = Expression<Date>("date")
        
        let tbl_userchats=sqliteDB.userschats
        let res=tbl_userchats?.filter(owneruser==owneruser1)
        
            print("chat from sqlite is")
            print(res)
        do
        {for tblContacts in try sqliteDB.db.prepare((tbl_userchats?.filter(owneruser==owneruser1))!){
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
    func deleteChat(_ userTo:String)
    {
        let to = Expression<String>("to")
        let from = Expression<String>("from")
        
        let tbl_userchats=sqliteDB.userschats
        
        //%%%%%%%%%%%%%%%% new running delete chat from sqlite database june 2016 %%%%%%%%%%%%%%%%
        //-----------------____________
        /////var tbl_userchats=sqliteDB.db["userschats"]
        //tbl_userchats.filter(to==userTo).delete()
        //tbl_userchats.filter(from==userTo).delete()
        do
        {
        try sqliteDB.db.run((tbl_userchats?.filter(to==userTo).delete())!)
        try sqliteDB.db.run((tbl_userchats?.filter(from==userTo).delete())!)
            
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

    func deleteFriend(_ user:String)
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
        let group_icon = Expression<Data>("group_icon")
        let date_creation = Expression<Date>("date_creation")
        let unique_id = Expression<String>("unique_id")
        let isMute = Expression<Bool>("isMute")
        let status = Expression<Bool>("status")
        
        
         self.groups = Table("groups")
        do{
            try db.run(groups.create(ifNotExists: retainOldDatabase) { t in
                t.column(group_name)
                t.column(group_icon, defaultValue:NSData.init() as Data)
                t.column(date_creation, defaultValue:NSDate() as Date)
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
        let date_joined = Expression<Date>("date_joined")
        let date_left = Expression<Date>("date_left")
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
                t.column(date_left, defaultValue:NSDate.init() as Date)
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
        let date = Expression<Date>("date")
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
        let read_date = Expression<Date>("read_date")
        let delivered_date = Expression<Date>("delivered_date")
        
        self.group_chat_status = Table("group_chat_status")
        do{
            try db.run(group_chat_status.create(ifNotExists: retainOldDatabase) { t in
                t.column(msg_unique_id)
                t.column(Status)
                t.column(user_phone)
                
                t.column(read_date,defaultValue:UtilityFunctions.init().minimumDate() as Date)
                
                t.column(delivered_date,defaultValue:UtilityFunctions.init().minimumDate() as Date)
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
    
    func storeGroupsChat(_ from1:String,group_unique_id1:String,type1:String,msg1:String,from_fullname1:String,date1:Date,unique_id1:String)
    {
        let from = Expression<String>("from")
        let group_unique_id = Expression<String>("group_unique_id")
        let type = Expression<String>("type")
        let msg = Expression<String>("msg")
        let from_fullname = Expression<String>("from_fullname")
        let date = Expression<Date>("date")
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
    
    
    
    func updateGroupsCreateNewStatus(uniqueid1:String,status1:String)
    {
        
        let group_name = Expression<String>("group_name")
        let group_icon = Expression<Data>("group_icon")
        let date_creation = Expression<Date>("date_creation")
        let unique_id = Expression<String>("unique_id")
        let isMute = Expression<Bool>("isMute")
        let status = Expression<String>("status") //temp or new
        
        self.groups = Table("groups")
        let query = groups.select(unique_id)           // SELECT "email" FROM "users"
            .filter(unique_id == uniqueid1)     // WHERE "name" IS NOT NULL
        
        do
        {try sqliteDB.db.run(query.update(status <- status1))}
        catch
        {
            print("error: cannot update group new status")
        }
        
        
    }
    func storeGroups(_ groupname1:String,groupicon1:Data!,datecreation1:Date,uniqueid1:String,status1:String)
    {
        
        let group_name = Expression<String>("group_name")
        let group_icon = Expression<Data>("group_icon")
        let date_creation = Expression<Date>("date_creation")
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
    func getGroupMuteStatus(uniqueID1:String)->[String: AnyObject]
    {
        /*
        let unique_id = Expression<String>("unique_id")
        let isMute = Expression<Bool>("isMute")
        var groupsList=[[String:Any]]()
        */
        
        let groupid = Expression<String>("groupid")
        let isMute = Expression<Bool>("isMute")
        let muteTime = Expression<Date>("muteTime")
        let unMuteTime = Expression<Date>("unMuteTime")
        
        
        var newEntry: [String: AnyObject] = [:]
        self.group_muteSettings = Table("group_muteSettings")
        
        
        /* let _id = Expression<String>("_id")
         let deptname = Expression<String>("deptname")
         let deptdescription = Expression<String>("deptdescription")
         let companyid = Expression<String>("companyid")
         let createdby = Expression<String>("createdby")
         let creationdate = Expression<String>("creationdate")
         let deleteStatus = Expression<String>("deleteStatus")
         */
        //self.groups = Table("groups")
        
        do
        {for mutedetails in try self.db.prepare(self.group_muteSettings.filter(groupid==uniqueID1)){
            // print("channel name for deptid \(deptid) is \(channelNames.get(msg_channel_name))")
           newEntry["groupid"]=mutedetails.get(groupid) as AnyObject?
            newEntry["isMute"]=mutedetails.get(isMute) as AnyObject?
            newEntry["muteTime"]=mutedetails.get(muteTime) as AnyObject?
            newEntry["unMuteTime"]=mutedetails.get(unMuteTime) as AnyObject?
            }
        }
        catch{
            
        }
        return newEntry
        
    }
    
    func getOldDayStatuses()->[[String:AnyObject]]
    {
        let to = Expression<String>("to")
        let from = Expression<String>("from")
        let date = Expression<Date>("date")
        let uniqueid = Expression<String>("uniqueid")
        let contactPhone = Expression<String>("contactPhone")
        let type = Expression<String>("type")
        let file_name = Expression<String>("file_name")
        let file_size = Expression<String>("file_size")
        let file_type = Expression<String>("file_type")
        let file_path = Expression<String>("file_path")
        let file_caption = Expression<String>("file_caption")
        
        var StatusObjList=[[String:AnyObject]]()
        var nowdate=Date.init()
                //  var filesObjectList=[[String:AnyObject]]()
        do
        {
            
            for filesData in try self.db.prepare(files.filter(date<=Date.init()))
             {
            print("old status info \(filesData)")
            // print("found status object matchedddd")
            var fileObj=[String:AnyObject]()
            fileObj["to"]=filesData[to] as AnyObject?
            fileObj["from"]=filesData[from] as AnyObject?
            fileObj["date"]=filesData[date] as AnyObject?
            fileObj["uniqueid"]=filesData[uniqueid] as AnyObject?
            fileObj["contactPhone"]=filesData[contactPhone] as AnyObject?
            fileObj["type"]=filesData[type] as AnyObject?
            fileObj["file_name"]=filesData[file_name] as AnyObject?
            fileObj["file_size"]=filesData[file_size] as AnyObject?
            fileObj["file_type"]=filesData[file_type] as AnyObject?
            fileObj["file_path"]=filesData[file_path] as AnyObject?
            fileObj["file_caption"]=filesData[file_caption] as AnyObject?
            StatusObjList.append(fileObj)
            
            }
        }catch{
            
        }
        return StatusObjList
        

    }
    
    
    func muteGroup(starttime:Date,endTime:Date,groupid1:String)
    {
        let groupid = Expression<String>("groupid")
        let isMute = Expression<Bool>("isMute")
        let muteTime = Expression<Date>("muteTime")
        let unMuteTime = Expression<Date>("unMuteTime")
        
        
        self.group_muteSettings = Table("group_muteSettings")
        let query = group_muteSettings.select(groupid)           // SELECT "email" FROM "users"
            .filter(groupid == groupid1)     // WHERE "name" IS NOT NULL
        
        do
        {try sqliteDB.db.run(query.update(isMute <- true, muteTime<-starttime,unMuteTime<-endTime))}
        catch
        {
            print("error: cannot mute Group")
        }
        

    }
    
    func UnMuteGroup(groupid1:String)
    {
        
        let groupid = Expression<String>("groupid")
        let isMute = Expression<Bool>("isMute")
        let muteTime = Expression<Date>("muteTime")
        let unMuteTime = Expression<Date>("unMuteTime")
        
        
        self.group_muteSettings = Table("group_muteSettings")
        let query = group_muteSettings.select(groupid)           // SELECT "email" FROM "users"
            .filter(groupid == groupid1)     // WHERE "name" IS NOT NULL
        
        do
        {try sqliteDB.db.run(query.update(isMute <- false))}
        catch
        {
            print("error: cannot unmute Group")
        }
        
    }
    
    func UpdateMuteGroupStatus(_ unique_id1:String,isMute1:Bool)
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
    
    func storeMembers(_ group_uniqueid1:String,member_displayname1:String,member_phone1:String,isAdmin1:String,membershipStatus1:String,date_joined1:Date)
    {
        let group_unique_id = Expression<String>("group_unique_id")
        let group_member_displayname = Expression<String>("group_member_displayname")
        let member_phone = Expression<String>("member_phone")
        let isAdmin = Expression<String>("isAdmin")
        let membership_status = Expression<String>("membership_status")//joined or left
        let date_joined = Expression<Date>("date_joined")
        let date_left = Expression<Date>("date_left")
        
        self.group_member = Table("group_member")
        
        do {
            let rowid = try db.run(group_member.insert(
                group_unique_id<-group_uniqueid1,
                group_member_displayname<-member_displayname1,
                member_phone<-member_phone1,
                isAdmin<-isAdmin1,
                membership_status<-membershipStatus1,
                date_joined<-date_joined1,
                date_left<-Date.init()
                
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
    func getGroupDetails()->[[String:Any]]
    {
        let group_name = Expression<String>("group_name")
        let group_icon = Expression<Data>("group_icon")
        let date_creation = Expression<Date>("date_creation")
        let unique_id = Expression<String>("unique_id")
        let isMute = Expression<Bool>("isMute")
        let status = Expression<String>("status")
        
        
        var groupsList=[[String:Any]]()
        
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
            var newEntry: [String: Any] = [:]
            newEntry["group_name"]=groupDetails.get(group_name) as String
            newEntry["group_icon"]=groupDetails.get(group_icon) as Data
            newEntry["date_creation"]=groupDetails.get(date_creation) as Date
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
    
    func getSingleURLInfo(_ uniqueid1:String)->[String: AnyObject]
    {
        
    let urlMessageID = Expression<String>("urlMessageID")
    let title = Expression<String>("title")
    let desc = Expression<String>("desc")
    let url = Expression<String>("url")
    let msg = Expression<String>("msg")
    let image = Expression<Data>("image")
    
    self.urlData = Table("urlData")
         var newEntry: [String: AnyObject] = [:]
        do
        {for URLinfo in try self.db.prepare(self.urlData.filter(urlMessageID == uniqueid1)){
            
          //  print("inside finding group found in db")
            newEntry["urlMessageID"]=URLinfo.get(urlMessageID) as AnyObject
            newEntry["title"]=URLinfo.get(title) as AnyObject
            newEntry["desc"]=URLinfo.get(desc) as AnyObject
            newEntry["url"]=URLinfo.get(url) as AnyObject
            newEntry["msg"]=URLinfo.get(msg) as AnyObject
            //groupsList.append(newEntry)
            break
            
            }
        }
        catch{
            print("failed to get URL info object data")
        }
        print("search get URL info is \(newEntry)")
        return newEntry
    
    }
    func updateGroupname(groupid:String,newname:String)
    {
        let group_name = Expression<String>("group_name")
        let unique_id = Expression<String>("unique_id")
        
        
        var tblGroups = Table("groups")
        do
        {
            let query = tblGroups.select(unique_id).filter(unique_id == groupid)
       
            try sqliteDB.db.run(query.update(group_name <- newname))
                    }
        catch{
            
        }
        
    }
    
    func getSingleGroupInfo(_ groupid:String)->[String: AnyObject]
    {
        // var groupsList=[String:AnyObject]()
        var newEntry: [String: AnyObject] = [:]
        
        let group_name = Expression<String>("group_name")
        let group_icon = Expression<Data>("group_icon")
        let date_creation = Expression<Date>("date_creation")
        let unique_id = Expression<String>("unique_id")
        let isMute = Expression<Bool>("isMute")
        
        
        
        var tblGroups = Table("groups")
        do
        {for groupsinfo in try self.db.prepare(tblGroups.filter(unique_id == groupid)){
            
            print("inside finding group found in db")
            newEntry["group_name"]=groupsinfo.get(group_name) as AnyObject
            newEntry["group_icon"]=groupsinfo.get(group_icon) as AnyObject
            newEntry["date_creation"]=groupsinfo.get(date_creation) as AnyObject
            newEntry["unique_id"]=groupsinfo.get(unique_id) as AnyObject
            newEntry["isMute"]=groupsinfo.get(isMute) as AnyObject
            //groupsList.append(newEntry)
            
            
            }
        }
        catch{
            print("failed to get teams single object data")
        }
        print("search get single group array is \(newEntry)")
        return newEntry
        
    }
    
    func getGroupMembersOfGroup(_ groupid1:String)->[[String:AnyObject]]
    {
        let group_unique_id = Expression<String>("group_unique_id")
        let member_phone = Expression<String>("member_phone")
        let isAdmin = Expression<String>("isAdmin")
        let membership_status = Expression<String>("membership_status")
        let date_joined = Expression<Date>("date_joined")
        let date_left = Expression<Date>("date_left")
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
            newEntry["group_unique_id"]=groupDetails.get(group_unique_id) as AnyObject
            newEntry["member_phone"]=groupDetails.get(member_phone) as AnyObject
            newEntry["isAdmin"]=groupDetails.get(isAdmin) as AnyObject
            newEntry["membership_status"]=groupDetails.get(membership_status) as AnyObject
            
            newEntry["date_joined"]=groupDetails.get(date_joined) as AnyObject
            
            newEntry["date_left"]=groupDetails.get(date_left) as AnyObject
            
            newEntry["group_member_displayname"]=groupDetails.get(group_member_displayname) as AnyObject
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
    func getGroupMembersCount(groupid1:String)->Int
    {
    let group_unique_id = Expression<String>("group_unique_id")
    
   // var groupsList=[[String:AnyObject]]()
    
    /* let _id = Expression<String>("_id")
     let deptname = Expression<String>("deptname")
     let deptdescription = Expression<String>("deptdescription")
     let companyid = Expression<String>("companyid")
     let createdby = Expression<String>("createdby")
     let creationdate = Expression<String>("creationdate")
     let deleteStatus = Expression<String>("deleteStatus")
     */
    var tblGroupmember = Table("group_member")
    var memberscount=0
    do
    {var membersArray = Array(try self.db.prepare(tblGroupmember.filter(group_unique_id==groupid1)))
     memberscount=membersArray.count
    }
    catch{
    print("failed to get groupsList")
    }
    return memberscount
    
    
    
    }
    
    func removeMember(_ groupid1:String,member_phone1:String)
        {
            let group_unique_id = Expression<String>("group_unique_id")
            let member_phone = Expression<String>("member_phone")
            let isAdmin = Expression<String>("isAdmin")
            let membership_status = Expression<String>("membership_status")
            let date_joined = Expression<Date>("date_joined")
            let date_left = Expression<Date>("date_left")
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
    
    func updateMembershipStatus(_ groupid1:String,memberphone1:String,membership_status1:String)
    {
        let group_unique_id = Expression<String>("group_unique_id")
        let member_phone = Expression<String>("member_phone")
        let isAdmin = Expression<String>("isAdmin")
        let membership_status = Expression<String>("membership_status")
        let date_joined = Expression<Date>("date_joined")
        let date_left = Expression<Date>("date_left")
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
    
    func getGroupAdmin(_ id:String)->[String]{
    
    let group_unique_id = Expression<String>("group_unique_id")
    let member_phone = Expression<String>("member_phone")
    let isAdmin = Expression<String>("isAdmin")
    let membership_status = Expression<String>("membership_status")
    let date_joined = Expression<Date>("date_joined")
    let date_left = Expression<Date>("date_left")
    let group_member_displayname = Expression<String>("group_member_displayname")
    
    var groupsList=[String]()
    
    /* let _id = Expression<String>("_id")
     let deptname = Expression<String>("deptname")
     let deptdescription = Expression<String>("deptdescription")
     let companyid = Expression<String>("companyid")
     let createdby = Expression<String>("createdby")
     let creationdate = Expression<String>("creationdate")
     let deleteStatus = Expression<String>("deleteStatus")
     */
    let tblGroupmember = Table("group_member")
    
    do
    {for groupDetails in try self.db.prepare(tblGroupmember.filter(group_unique_id==id && isAdmin.lowercaseString=="yes")){
         groupsList.append(groupDetails[member_phone])
        }}catch{
            
        }
     return groupsList}
    
    func changeRole(_ groupid1:String,member1:String,isAdmin1:String)
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
    
    func getMemberShipStatus(_ groupid1:String,memberphone:String)->String
    {
            let group_unique_id = Expression<String>("group_unique_id")
            let member_phone = Expression<String>("member_phone")
            let isAdmin = Expression<String>("isAdmin")
            let membership_status = Expression<String>("membership_status")
            let date_joined = Expression<Date>("date_joined")
            let date_left = Expression<Date>("date_left")
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
            let tblGroupmember = Table("group_member")
            
            do
            {for groupDetails in try self.db.prepare(tblGroupmember.filter(group_unique_id==groupid1 && member_phone==memberphone)){
                
                return groupDetails[membership_status]
                
                }}catch{
                    
            }
            return "error"

    }
    
    func updateGroupChatStatus(_ uniqueid1:String,memberphone1:String,status1:String,delivereddate1:Date!,readDate1:Date!)
    {
        let msg_unique_id = Expression<String>("msg_unique_id")
        let Status = Expression<String>("Status")
        let user_phone = Expression<String>("user_phone")
        
        let read_date = Expression<Date>("read_date")
        let delivered_date = Expression<Date>("delivered_date")
        
        
        
        self.group_chat_status = Table("group_chat_status")

        let query = self.group_chat_status.select(Status).filter(msg_unique_id == uniqueid1 && user_phone == memberphone1)
        do
        {let row=try sqliteDB.db.run(query.update(Status <- status1))
        print("status updated of group chat \(row)")
            if(status1.lowercased() == "delivered")
            {
            var row=try sqliteDB.db.run(query.update(delivered_date <- delivereddate1))
            }
            else
            {
                if(status1.lowercased() == "seen")
                {
                var row=try sqliteDB.db.run(query.update(read_date <- readDate1))
                }
                }
        }
        catch
        {
            print("error in updating group chat status \(error)")
            
        }


    }
    
    func storeGRoupsChatStatus(_ uniqueid1:String,status1:String,memberphone1:String,delivereddate1:Date!,readDate1:Date!)
    {
        let msg_unique_id = Expression<String>("msg_unique_id")
        let Status = Expression<String>("Status")
        let user_phone = Expression<String>("user_phone")
        let read_date = Expression<Date>("read_date")
        let delivered_date = Expression<Date>("delivered_date")
        
       // var group_muteSettings=sqliteDB.group_muteSettings
        if(status1.lowercased() == "seen")
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
        if(status1.lowercased() == "delivered")
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
    
    
    func getGroupsChatStatusSingle(_ uniqueid1:String,user_phone1:String)->String
    {
        let msg_unique_id = Expression<String>("msg_unique_id")
        let Status = Expression<String>("Status")
        let user_phone = Expression<String>("user_phone")
        let read_date = Expression<Date>("read_date")
        let delivered_date = Expression<Date>("delivered_date")
        
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
        let read_date = Expression<Date>("read_date")
        let delivered_date = Expression<Date>("delivered_date")
        
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
    
    func getChatStatusUniqueIDsListNotSeen()->[String]
    {
        
        let uniqueid = Expression<String>("uniqueid")
        let status = Expression<String>("status")
       
        
        let tbl_userchats=sqliteDB.userschats
        // var tblGroupmember = Table("group_member")
        var uniqueidlist=[String]()
        do
        {for ChatStatus in try self.db.prepare((tbl_userchats?.filter(status.lowercaseString != "seen"))!){
            print("found status NOT SEEN")
            
            uniqueidlist.append(ChatStatus[uniqueid])
            
            }
        }catch{
            print("error in NOT SEEN status query")
        }
        return uniqueidlist
    }

    func getChatStatusListNotSeenObject()->[[String:String]]
    {
        
        let uniqueid = Expression<String>("uniqueid")
        let status = Expression<String>("status")
        let from = Expression<String>("from")
        
        
        let tbl_userchats=sqliteDB.userschats
        // var tblGroupmember = Table("group_member")
        var uniqueidlist=[[String:String]]()
        do
        {for ChatStatus in try self.db.prepare((tbl_userchats?.filter(status.lowercaseString != "seen" && from==username!))!){
            print("found status NOT SEEN")
            var newlist=[String:String]()
            newlist["uniqueid"]=ChatStatus[uniqueid]
            newlist["status"]=ChatStatus[status]
            uniqueidlist.append(newlist)
            }
        }catch{
            print("error in NOT SEEN status query")
        }
        return uniqueidlist
    }
    
    func updateGroupCreationDate(_ uniqueid1:String,date1:Date)
    {
        let date_creation = Expression<Date>("date_creation")
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
    
    func updateGroupChatMessage(_ group_unique_id1:String,msg1:String)
    {
        
        let from = Expression<String>("from")
        let group_unique_id = Expression<String>("group_unique_id")
        let type = Expression<String>("type")
        let msg = Expression<String>("msg")
        let from_fullname = Expression<String>("from_fullname")
        let date = Expression<Date>("date")
        let unique_id = Expression<String>("unique_id")
        
        
        let query = self.group_chat.select(unique_id,msg,date)           // SELECT "email" FROM "users"
            .filter(group_unique_id == group_unique_id1)     // WHERE "name" IS NOT NULL
        
        do
        {try sqliteDB.db.run(query.update(date <- Date(),msg <- msg1))}
        catch
        {
            print("error in updating date of group creation")
            if(socketObj != nil){
                socketObj.socket.emit("logClient","\(username!) error in updatingdate of group creation")
            }
        }
        

        
        
    }
    
    func updateKiboStatusInAddressbook(_ phone1:String!)
    {
        let name = Expression<String>("name")
        let phone = Expression<String>("phone")
        let kiboContact = Expression<Bool>("kiboContact")
       
        
            do{
                try self.db.run(self.allcontacts.filter(phone==phone1).update(kiboContact<-true))
            }
            catch{
                
            }
    
        
    }
    
    func getNameFromAddressbook(_ phone1:String!)->String!
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
    
    func getNameGroupMemberNameFromMembersTable(_ phone1:String)->String!
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
    
    func getGroupsChatReadStatusList(_ msguniqueid1:String)->[[String:AnyObject]]
    {
        let msg_unique_id = Expression<String>("msg_unique_id")
        let Status = Expression<String>("Status")
        let user_phone = Expression<String>("user_phone")
        let read_date = Expression<Date>("read_date")
        let delivered_date = Expression<Date>("delivered_date")
        
        var statusObjectList=[[String:AnyObject]]()
        // var tblGroupmember = Table("group_member")
       // var uniqueid=[String]()
        do
        {for groupChatStatus in try self.db.prepare(group_chat_status.filter(msg_unique_id == msguniqueid1 && Status.lowercaseString=="seen")){
            print("found status..")
            
            var statusObj=[String:AnyObject]()
            statusObj["msg_unique_id"]=groupChatStatus[msg_unique_id] as AnyObject?
            statusObj["Status"]=groupChatStatus[Status] as AnyObject?
            statusObj["user_phone"]=groupChatStatus[user_phone] as AnyObject?
            statusObj["read_date"]=groupChatStatus[read_date] as AnyObject?
            statusObj["delivered_date"]=groupChatStatus[delivered_date] as AnyObject?
            
           statusObjectList.append(statusObj)
            //return groupChatStatus[read_date]
            //uniqueid.append(groupChatStatus[msg_unique_id])
            
            }
        }catch{
            print("error in readdate status query")
        }
        return statusObjectList
    }
    
    
    func getGroupsChatDeliveredStatusList(_ msguniqueid1:String)->[[String:AnyObject]]
    {
        let msg_unique_id = Expression<String>("msg_unique_id")
        let Status = Expression<String>("Status")
        let user_phone = Expression<String>("user_phone")
        let read_date = Expression<Date>("read_date")
        let delivered_date = Expression<Date>("delivered_date")
        
        var statusObjectList=[[String:AnyObject]]()
        // var tblGroupmember = Table("group_member")
        // var uniqueid=[String]()
        do
        {for groupChatStatus in try self.db.prepare(group_chat_status.filter(msg_unique_id == msguniqueid1 && Status.lowercaseString=="delivered")){
            print("found status..")
            
            var statusObj=[String:AnyObject]()
            statusObj["msg_unique_id"]=groupChatStatus[msg_unique_id] as AnyObject?
            statusObj["Status"]=groupChatStatus[Status] as AnyObject?
            statusObj["user_phone"]=groupChatStatus[user_phone] as AnyObject?
            statusObj["read_date"]=groupChatStatus[read_date] as AnyObject?
            statusObj["delivered_date"]=groupChatStatus[delivered_date] as AnyObject?
            statusObjectList.append(statusObj)
            
            //return groupChatStatus[delivered_date]
            //uniqueid.append(groupChatStatus[msg_unique_id])
            
            }
        }catch{
            print("error in delivered_date status query")
        }
        return statusObjectList
    }
    
    func getGroupsUnreadMessagesCount(_ groupid1:String)->Int    {
        
        
        let msg_unique_id = Expression<String>("msg_unique_id")
        let Status = Expression<String>("Status")
        let user_phone = Expression<String>("user_phone")
        let read_date = Expression<Date>("read_date")
        let delivered_date = Expression<Date>("delivered_date")
        
        let from = Expression<String>("from")
        let group_unique_id = Expression<String>("group_unique_id")
        let type = Expression<String>("type")
        let msg = Expression<String>("msg")
        let from_fullname = Expression<String>("from_fullname")
        let date = Expression<Date>("date")
        let unique_id = Expression<String>("unique_id")
        
        let tblgroupchat=sqliteDB.group_chat
        var res=tblgroupchat?.filter(group_unique_id==groupid1)
        //to==selecteduser || from==selecteduser
        //print("chat from sqlite is")
        //print(res)
       
        var countunread=0
        do
        {//for tblContacts in try sqliteDB.db.prepare(tbl_userchats.filter(owneruser==owneruser1)){
            ////print("queryy runned count is \(tbl_contactslists.count)")
            for groupsChat in try sqliteDB.db.prepare((tblgroupchat?.filter(group_unique_id==groupid1))!){
                
                var statusObjectList=[[String:AnyObject]]()
                // var tblGroupmember = Table("group_member")
                // var uniqueid=[String]()
                for groupChatStatus in try self.db.prepare(group_chat_status.filter(msg_unique_id == groupsChat[unique_id] && (Status.lowercaseString=="delivered" || Status.lowercaseString=="sent") && user_phone==username!)){
                    print("found unread message..")
                    countunread += 1
                    
                    }
              
                
            }
        }catch{
                print("error in delivered_date status query")
            }
              return countunread
    }

    
    func getGroupsChatStatusObjectList(_ msguniqueid1:String)->[[String:AnyObject]]
    {
        let msg_unique_id = Expression<String>("msg_unique_id")
        let Status = Expression<String>("Status")
        let user_phone = Expression<String>("user_phone")
        let read_date = Expression<Date>("read_date")
        let delivered_date = Expression<Date>("delivered_date")
        
        // var tblGroupmember = Table("group_member")
        var statusObjectList=[[String:AnyObject]]()
        do
        {for groupChatStatus in try self.db.prepare(group_chat_status.filter(msg_unique_id==msguniqueid1)){
            var statusObj=[String:AnyObject]()
            print("found status object matchedddd")
            
            statusObj["msg_unique_id"]=groupChatStatus[msg_unique_id] as AnyObject?
            statusObj["Status"]=groupChatStatus[Status] as AnyObject?
            statusObj["user_phone"]=groupChatStatus[user_phone] as AnyObject?
            statusObj["read_date"]=groupChatStatus[read_date] as AnyObject?
            statusObj["delivered_date"]=groupChatStatus[delivered_date] as AnyObject?
            
            statusObjectList.append(statusObj)
            }
        }catch{
            
        }
        return statusObjectList
    }

    func getDayStatusesData()->[[String:AnyObject]]
    {
        let to = Expression<String>("to")
        let from = Expression<String>("from")
        let date = Expression<Date>("date")
        let uniqueid = Expression<String>("uniqueid")
        let contactPhone = Expression<String>("contactPhone")
        let type = Expression<String>("type")
        let file_name = Expression<String>("file_name")
        let file_size = Expression<String>("file_size")
        let file_type = Expression<String>("file_type")
        let file_path = Expression<String>("file_path")
        let file_caption = Expression<String>("file_caption")
        
        var StatusObjList=[[String:AnyObject]]()
        
        //  var filesObjectList=[[String:AnyObject]]()
        do
        {for filesData in try self.db.prepare(files.filter(type=="day_status")){
            // print("found status object matchedddd")
            var fileObj=[String:AnyObject]()
            fileObj["to"]=filesData[to] as AnyObject?
            fileObj["from"]=filesData[from] as AnyObject?
            fileObj["date"]=filesData[date] as AnyObject?
            fileObj["uniqueid"]=filesData[uniqueid] as AnyObject?
            fileObj["contactPhone"]=filesData[contactPhone] as AnyObject?
            fileObj["type"]=filesData[type] as AnyObject?
            fileObj["file_name"]=filesData[file_name] as AnyObject?
            fileObj["file_size"]=filesData[file_size] as AnyObject?
            fileObj["file_type"]=filesData[file_type] as AnyObject?
            fileObj["file_path"]=filesData[file_path] as AnyObject?
            fileObj["file_caption"]=filesData[file_caption] as AnyObject?
            StatusObjList.append(fileObj)
           
            }
        }catch{
            
        }
        return StatusObjList
        
    }
    
    
    func getFilesData(_ uniqueid1:String)->[String:AnyObject]
    {
        let to = Expression<String>("to")
        let from = Expression<String>("from")
        let date = Expression<Date>("date")
        let uniqueid = Expression<String>("uniqueid")
        let contactPhone = Expression<String>("contactPhone")
        let type = Expression<String>("type")
        let file_name = Expression<String>("file_name")
        let file_size = Expression<String>("file_size")
        let file_type = Expression<String>("file_type")
        let file_path = Expression<String>("file_path")
        let file_caption = Expression<String>("file_caption")
        
        var fileObj=[String:AnyObject]()
        
      //  var filesObjectList=[[String:AnyObject]]()
        do
        {for filesData in try self.db.prepare(files.filter(uniqueid==uniqueid1)){
            // print("found status object matchedddd")
            
            fileObj["to"]=filesData[to] as AnyObject?
            fileObj["from"]=filesData[from] as AnyObject?
            fileObj["date"]=filesData[date] as AnyObject?
            fileObj["uniqueid"]=filesData[uniqueid] as AnyObject?
            fileObj["contactPhone"]=filesData[contactPhone] as AnyObject?
            fileObj["type"]=filesData[type] as AnyObject?
            fileObj["file_name"]=filesData[file_name] as AnyObject?
            fileObj["file_size"]=filesData[file_size] as AnyObject?
            fileObj["file_type"]=filesData[file_type] as AnyObject?
            fileObj["file_path"]=filesData[file_path] as AnyObject?
            fileObj["file_caption"]=filesData[file_caption] as AnyObject?
            
            break
            }
        }catch{
            
        }
        return fileObj

    }
    
    func checkGroupMessageisAllDelevered(_ msg_unique_id1:String,members_phones1:[[String:AnyObject]])->Bool
    {
        let msg_unique_id = Expression<String>("msg_unique_id")
        let Status = Expression<String>("Status")
        let user_phone = Expression<String>("user_phone")
        let read_date = Expression<Date>("read_date")
        let delivered_date = Expression<Date>("delivered_date")
        var result=true
        for i in 0 ..< members_phones1.count
        {
        do
        {for groupChatStatus in try self.db.prepare(group_chat_status.filter(msg_unique_id==msg_unique_id1 && user_phone==members_phones1[i]["member_phone"] as! String)){
            if(groupChatStatus[Status].lowercased() != "delivered")
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
    
    func checkGroupMessageisAnySent(_ msg_unique_id1:String,members_phones1:[[String:AnyObject]])->Bool
    {
        let msg_unique_id = Expression<String>("msg_unique_id")
        let Status = Expression<String>("Status")
        let user_phone = Expression<String>("user_phone")
        let read_date = Expression<Date>("read_date")
        let delivered_date = Expression<Date>("delivered_date")
        var result=true
        for i in 0 ..< members_phones1.count
        {do
            {for groupChatStatus in try self.db.prepare(group_chat_status.filter(msg_unique_id==msg_unique_id1 && user_phone==members_phones1[i]["member_phone"] as! String)){
                if(groupChatStatus[Status].lowercased() == "sent")
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
    
    func checkGroupMessageisAllSeen(_ msg_unique_id1:String,members_phones1:[[String:AnyObject]])->Bool
    {
        let msg_unique_id = Expression<String>("msg_unique_id")
        let Status = Expression<String>("Status")
        let user_phone = Expression<String>("user_phone")
        let read_date = Expression<Date>("read_date")
        let delivered_date = Expression<Date>("delivered_date")
        var result=true
        for i in 0 ..< members_phones1.count
        {
            do
            {for groupChatStatus in try self.db.prepare(group_chat_status.filter(msg_unique_id==msg_unique_id1 && user_phone==members_phones1[i]["member_phone"] as! String)){
                if(groupChatStatus[Status].lowercased() != "seen")
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
    
    func checkIfFileExists(_ uniqueid1:String)->Bool
    {
        print("ckecking file exists \(uniqueid1)")
        let uniqueid = Expression<String>("uniqueid")
        
        
        let tbl_userfiles=sqliteDB.files
        var fileexists=false
        
        do
        {for groupsinfo in try self.db.prepare((tbl_userfiles?.filter(uniqueid == uniqueid1))!){
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
    
    
    func getIdentifierFRomPhone(_ phone1:String)->String
    {
        let phone = Expression<String>("phone")
        let uniqueidentifier = Expression<String>("uniqueidentifier")
        //
        self.allcontacts = Table("allcontacts")
        var identifier=""
        do
        {for identifierinfo in try self.db.prepare(allcontacts.filter(phone == phone1)){
            print("found identifier")
            identifier=identifierinfo[uniqueidentifier]
            break
            }
        }
        catch
        {
            print("error in filee")
        }
        
        return identifier
    }
    
    func findGroupChatPendingMsgDetails()->[[String:AnyObject]]
    {
        let msg_unique_id = Expression<String>("msg_unique_id")
        let Status = Expression<String>("Status")
        let user_phone = Expression<String>("user_phone")
        
        self.group_chat_status = Table("group_chat_status")
        
        var groupsList=[[String:AnyObject]]()
        
        let from = Expression<String>("from")
        let group_unique_id = Expression<String>("group_unique_id")
        let type = Expression<String>("type")
        let msg = Expression<String>("msg")
        let from_fullname = Expression<String>("from_fullname")
        let date = Expression<Date>("date")
        let unique_id = Expression<String>("unique_id")
        
        
        
        let query = self.group_chat_status.select(Status,msg_unique_id).filter(Status.lowercaseString == "pending")
        do
        {for pendingchats in try self.db.prepare(query)
        {
            print()
            var idPendingMsg=pendingchats[msg_unique_id]
            var tblgroupchat=sqliteDB.group_chat
            
            do
            {for pendingchatsGroupDetail in try self.db.prepare((tblgroupchat?.filter(unique_id == idPendingMsg))!)
            {
                var newEntry=[String:AnyObject]()
                newEntry["from"]=pendingchatsGroupDetail.get(from) as AnyObject
                newEntry["group_unique_id"]=pendingchatsGroupDetail.get(group_unique_id) as AnyObject
                newEntry["type"]=pendingchatsGroupDetail.get(type) as AnyObject
                newEntry["msg"]=pendingchatsGroupDetail.get(msg) as AnyObject
                newEntry["from_fullname"]=pendingchatsGroupDetail.get(from_fullname) as AnyObject
                newEntry["date"]=pendingchatsGroupDetail.get(date) as AnyObject
                newEntry["unique_id"]=pendingchatsGroupDetail.get(unique_id) as AnyObject
                groupsList.append(newEntry)
            }
                
            }
            catch
            {

}
            
        }
        }
        catch
        {
            
        }
        
        return groupsList
    }
    
  /*  func getBroadcastListChatMessages(broadcastID1:String)
    {
        
        
    }*/
    func storeBroadcastList(_ broadcastlistID1:String,ListName1:String)
    {
        let uniqueid = Expression<String>("uniqueid")
        let listname = Expression<String>("listname")
        //
        //listIsArchived
        self.broadcastlisttable = Table("broadcastlisttable")
        do {
            let rowid = try db.run(broadcastlisttable.insert(
                uniqueid<-broadcastlistID1,
                listname<-ListName1
                ))
            
            
            print("inserted id broadcastlist : \(rowid)")
        } catch {
            print("insertion failed: broadcastlist \(error)")
        }
        
    }
    
    func storeBroadcastListMembers(_ broadcastlistID1:String,memberphones:[String])
    {
        let uniqueid = Expression<String>("uniqueid")
        let memberphone = Expression<String>("memberphone")
        //
        self.broadcastlistmembers = Table("broadcastlistmembers")
        do {
            for i in 0 ..< memberphones.count
            {
            let rowid = try db.run(broadcastlistmembers.insert(
                uniqueid<-broadcastlistID1,
                memberphone<-memberphones[i]
                ))
            
            
            print("inserted id broadcastlistmember : \(rowid)")
            }
        }
        catch {
            print("insertion failed: broadcastlistmember \(error)")
        }
        
    }
    
       
    func UpdateBroadcastlistMembers(_ uniqueid1:String,members:[String])
    {
        //  UtilityFunctions.init().log_papertrail("IPHONE: \(username!) inside database function to update chat status")
        
        let uniqueid = Expression<String>("uniqueid")
        let memberphone = Expression<String>("memberphone")
        
        
        var broadcastlistmembers=sqliteDB.broadcastlistmembers
        
        let query = broadcastlistmembers?.select(uniqueid)           // SELECT "email" FROM "users"
            .filter(uniqueid == uniqueid1)     // WHERE "name" IS NOT NULL
        
        do
        {
            try sqliteDB.db.run((query?.delete())!)
            for i in 0 ..< members.count
            {
                let rowid = try db.run((broadcastlistmembers?.insert(
                    uniqueid<-uniqueid1,
                    memberphone<-members[i]
                    ))!)
                
        }
        }
        catch
        {
           print("error here updatinggg")
        }
    }
    
    func updateBroadcastlistName(_ uniqueid1:String,listname1:String)
    {
        let uniqueid = Expression<String>("uniqueid")
        let listname = Expression<String>("listname")
        
        self.broadcastlisttable = Table("broadcastlisttable")
        
        do{
            try self.db.run(broadcastlisttable.filter(uniqueid==uniqueid1).update(listname<-listname1))
        }
        catch{

}
        
    }
    
    func getBroadcastListMembers(_ uniqueid1:String)->[String]
    {
        var newEntry=[String]()
        
                let uniqueid = Expression<String>("uniqueid")
                let memberphone = Expression<String>("memberphone")
                //
                self.broadcastlistmembers = Table("broadcastlistmembers")
        let query = self.broadcastlistmembers.select(uniqueid,memberphone).filter(uniqueid == uniqueid1)
        
        do
        {for list in try self.db.prepare(query)
        {
           // newEntry["uniqueid"]=list.get(uniqueid)
            print("broadcast list member is \(list.get(memberphone))")
            newEntry.append(list.get(memberphone))
            
            }
        }
        catch
        {
            
        }
        return newEntry
    }
    
    
    func getSinglebroadcastlist(_ uniqueid1:String)->[String:AnyObject]
    {
        var newEntry=[String:Any]()
        
        let uniqueid = Expression<String>("uniqueid")
        let listname = Expression<String>("listname")
        let listIsArchived = Expression<Bool>("listIsArchived")
        //listIsArchived
        self.broadcastlisttable = Table("broadcastlisttable")
        let query = self.broadcastlisttable.select(uniqueid,listname).filter(uniqueid == uniqueid1)
        do
        {for list in try self.db.prepare(query)
        {   newEntry["uniqueid"]=list.get(uniqueid)
            newEntry["listname"]=list.get(listname)
            newEntry["listIsArchived"]=list.get(listIsArchived)
            
        
            }
        }
        catch
        {
            
        }
       return newEntry as [String : AnyObject]
    }
    
    func getSinglebroadcastlist()->[[String:AnyObject]]
    {
        var broadcastlist=[[String:AnyObject]]()
        
        let uniqueid = Expression<String>("uniqueid")
        let listname = Expression<String>("listname")
        let listIsArchived = Expression<Bool>("listIsArchived")
        //
        self.broadcastlisttable = Table("broadcastlisttable")
       
        do
        {for list in try self.db.prepare(self.broadcastlisttable)
        { var newEntry=[String:AnyObject]()
            
            var aaa=list.get(listname)
            newEntry["uniqueid"]=list.get(uniqueid) as AnyObject
            newEntry["listname"]=list.get(listname) as AnyObject
            newEntry["listIsArchived"]=list.get(listIsArchived) as AnyObject
            broadcastlist.append(newEntry)
            
            }
        }
        catch
        {
            
        }
        return broadcastlist
    }
    
    func getBroadcastListDataForController()->[[String:AnyObject]]
    {
        var listDataController=[[String:AnyObject]]()
        
        let uniqueid = Expression<String>("uniqueid")
        let listname = Expression<String>("listname")
        //let listIsArchived = Expression<Bool>("listIsArchived")
        var listdata = getSinglebroadcastlist()
        for i in 0 ..< listdata.count
        {
            var listDetailSingle=[String:String]()
            
            var membersarray=getBroadcastListMembers(listdata[i]["uniqueid"] as! String)
            var memberslistnames=[String]()
            for j in 0 ..< membersarray.count
            {
                print(membersarray[j] )
                if(getNameFromAddressbook(membersarray[j]) != nil)
                {
            memberslistnames.append(getNameFromAddressbook(membersarray[j] ))
                }
                else{
                    memberslistnames.append(membersarray[j])
                }
            }
            listDetailSingle["listname"]=listdata[i]["listname"] as! String
            listDetailSingle["uniqueid"]=listdata[i]["uniqueid"] as! String
            listDetailSingle["listIsArchived"]="\(listdata[i]["listIsArchived"]!)" as! String
            listDetailSingle["membersnames"]=memberslistnames.joined(separator: ",")
            listDataController.append(listDetailSingle as [String : AnyObject])
        }
        print("listDataController is \(listDataController)")
        return listDataController
    }
    
    func deleteBroadcastList(_ id:String)
    {
        let uniqueid = Expression<String>("uniqueid")
        let listname = Expression<String>("listname")
        //
        self.broadcastlisttable = Table("broadcastlisttable")
        self.broadcastlistmembers = Table("broadcastlistmembers")
        do{
            try self.db.run(self.broadcastlisttable.filter(uniqueid==id).delete())
            try self.db.run(self.broadcastlistmembers.filter(uniqueid==id).delete())
            


        }
        catch{
            
        }
        
    }
    
    
    func getGroupStatusTemp(messageUniqueid1:String)->[String : AnyObject]
    {
        let status = Expression<String>("status")
        let sender = Expression<String>("sender")
        let messageuniqueid = Expression<String>("messageuniqueid")
        
        var newEntry = [String : Any]()

        self.groupStatusUpdatesTemp = Table("groupStatusUpdatesTemp")
        
                let query = self.groupStatusUpdatesTemp.select(messageuniqueid).filter(messageuniqueid == messageUniqueid1)
        do
        {for list in try self.db.prepare(query)
        {   newEntry["status"]=list.get(status)
            newEntry["sender"]=list.get(sender)
            newEntry["messageuniqueid"]=list.get(messageuniqueid)
            
            }
        }
        catch
        {
            
        }
        return newEntry as [String : AnyObject]
        
    }
    
    
    func IamBlockedUpdateStatus(phone1:String,status1:Bool)
    {
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
        let blockedByMe = Expression<Bool>("blockedByMe")
        let IamBlocked = Expression<Bool>("IamBlocked")
        //blockedByMe
        //IamBlocked
        
        self.contactslists = Table("contactslists")
        do{
            try self.db.run(self.contactslists.select(IamBlocked,phone).filter(phone==phone1).update(IamBlocked<-status1))
        }
        catch{
            print("error: unable to update value iAMblocked contact")
        }
        
        
    }
    
    func BlockContactUpdateStatus(phone1:String,status1:Bool)
    {
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
        let blockedByMe = Expression<Bool>("blockedByMe")
        let IamBlocked = Expression<Bool>("IamBlocked")
        //blockedByMe
        //IamBlocked
        
        self.contactslists = Table("contactslists")
        do{
            print("phone \(phone1) statusblocked \(status1)")
            var rowupdated=try self.db.run(self.contactslists.select(blockedByMe,phone).filter(phone==phone1).update(blockedByMe<-status1))
            print("blockedByMe value \(self.contactslists.select(blockedByMe).filter(phone==phone1)) rowupdated \(rowupdated)")
        }
        catch{
            print("error: unable to update value blockedByME contact")
        }
        
        
    }
    
    func getBlockedContatList()->[[String : Any]]
    {
        
        
        var BlockedContatList=[[String:Any]]()
        
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
        let blockedByMe = Expression<Bool>("blockedByMe")
        let IamBlocked = Expression<Bool>("IamBlocked")
        //blockedByMe
        //IamBlocked
        
        self.contactslists = Table("contactslists")
        
        
      //  let query = self.contactslists.select(messageuniqueid).filter(messageuniqueid == messageUniqueid1)
        do
        {for list in try self.db.prepare(self.contactslists.filter(blockedByMe==true))
        {
            var newEntry = [String : Any]()
            
            newEntry["contactid"]=list.get(contactid)
             newEntry["detailsshared"]=list.get(detailsshared)
             newEntry["unreadMessage"]=list.get(unreadMessage)
             newEntry["userid"]=list.get(userid)
             newEntry["firstname"]=list.get(firstname)
             newEntry["lastname"]=list.get(lastname)
             newEntry["email"]=list.get(email)
             newEntry["phone"]=list.get(phone)
             newEntry["username"]=list.get(username)
             newEntry["status"]=list.get(status)
             newEntry["blockedByMe"]=list.get(blockedByMe)
             newEntry["IamBlocked"]=list.get(IamBlocked)
            BlockedContatList.append(newEntry)
        }
        }
        catch{
            print("error in getting blocked contacts")
        }
        return BlockedContatList
    }
    
    func getIAMblockedByList()->[[String:Any]]
    {
        
        var IAMblockedByList=[[String:Any]]()
        
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
        let blockedByMe = Expression<Bool>("blockedByMe")
        let IamBlocked = Expression<Bool>("IamBlocked")
        //blockedByMe
        //IamBlocked
        
        self.contactslists = Table("contactslists")
        
        
        //  let query = self.contactslists.select(messageuniqueid).filter(messageuniqueid == messageUniqueid1)
        do
        {for list in try self.db.prepare(self.contactslists.filter(IamBlocked==true))
        {
            var newEntry = [String : Any]()
            
            newEntry["contactid"]=list.get(contactid)
            newEntry["detailsshared"]=list.get(detailsshared)
            newEntry["unreadMessage"]=list.get(unreadMessage)
            newEntry["userid"]=list.get(userid)
            newEntry["firstname"]=list.get(firstname)
            newEntry["lastname"]=list.get(lastname)
            newEntry["email"]=list.get(email)
            newEntry["phone"]=list.get(phone)
            newEntry["username"]=list.get(username)
            newEntry["status"]=list.get(status)
            newEntry["blockedByMe"]=list.get(blockedByMe)
            newEntry["IamBlocked"]=list.get(IamBlocked)
            IAMblockedByList.append(newEntry)
            }
        }
        catch{
            print("error in getting blocked contacts")
        }
        return IAMblockedByList
    }
    
    //updateArchiveStatusBroadcast
    func checkIfArchived()
    {
        
    }
    
    func updateArchiveStatusBroadcast(bid:String,status:Bool)
    {
        print("bid is \(bid) status is \(status)")
        /*let isArchived = Expression<Bool>("isArchived")
        let broadcastlistID = Expression<String>("broadcastlistID")
        let tbl_userchats=sqliteDB.userschats
        */
        let tbl_broadcastlisttable=sqliteDB.broadcastlisttable

        
        let uniqueid = Expression<String>("uniqueid")
       // let listname = Expression<String>("listname")
        let listIsArchived = Expression<Bool>("listIsArchived")
        
        let query = tbl_broadcastlisttable?.select(uniqueid)           // SELECT "email" FROM "users"
            .filter(uniqueid == bid)     // WHERE "name" IS NOT NULL
        
        do{
            var res=try sqliteDB.db.run((query?.update(listIsArchived <- status))!)
           print("archive broadcast list rows updated \(res)")
            
            
            
        }
        catch{
            print("eror: in updating archive status of broadcast")
        }
       /*
        let query = tbl_userchats?.select(broadcastlistID)           // SELECT "email" FROM "users"
            .filter(broadcastlistID == bid)     // WHERE "name" IS NOT NULL
        
        do{for tblContacts in try sqliteDB.db.prepare((tbl_userchats?.filter(broadcastlistID == bid))!)
        {
            var res=try sqliteDB.db.run((query?.update(isArchived <- status))!)
            }
            for tblContacts in try sqliteDB.db.prepare((tbl_broadcastlisttable?.filter(broadcastlistID == bid))!)
            {
                var res=try sqliteDB.db.run((query?.update(listIsArchived <- status))!)
            }

            
            
        }
        catch{
            print("eror: in updating archive status of broadcast")
        }*/
        
    }
    
    func updateArchiveStatus(contactPhone1:String,status:Bool)
    {
        let isArchived = Expression<Bool>("isArchived")
        let contactPhone = Expression<String>("contactPhone")
        
        
        let tbl_userchats=sqliteDB.userschats
        
        let query = tbl_userchats?.select(contactPhone)           // SELECT "email" FROM "users"
            .filter(contactPhone == contactPhone1)     // WHERE "name" IS NOT NULL
        
        do{for tblContacts in try sqliteDB.db.prepare((tbl_userchats?.filter(contactPhone == contactPhone1))!)
        {
            var res=try sqliteDB.db.run((query?.update(isArchived <- status))!)
            }
        }
            catch{
                print("eror: in updating archive status")
            }
        
    }
  
    
    func getArchivedChatDetails()->[[String:Any]]
    {
        let to = Expression<String>("to")
        let from = Expression<String>("from")
        let fromFullName = Expression<String>("fromFullName")
        let msg = Expression<String>("msg")
        let owneruser = Expression<String>("owneruser")
        let date = Expression<Date>("date")
        let uniqueid = Expression<String>("uniqueid")
        let status = Expression<String>("status")
        let contactPhone = Expression<String>("contactPhone")
        let type = Expression<String>("type")
        let file_type = Expression<String>("file_type")
        let file_path = Expression<String>("file_path")
        let broadcastlistID = Expression<String>("broadcastlistID")
        let isBroadcastMessage = Expression<Bool>("isBroadcastMessage")
        let isArchived = Expression<Bool>("isArchived")
        
        
        
        self.userschats = Table("userschats")
        var allChatsList=[[String:Any]]()
        
        
        //  let query = self.contactslists.select(messageuniqueid).filter(messageuniqueid == messageUniqueid1)
        do
        {
            
            let myquery=userschats?.filter(isArchived==true).group((userschats?[contactPhone])!).order(date.desc)
            
            var queryruncount=0
            for list in try sqliteDB.db.prepare(myquery!) {
                //for list in try self.db.prepare(self.userschats)
                // {
                var newEntry = [String : Any]()
                
                newEntry["date"]=list.get(date).debugDescription as AnyObject
                newEntry["contact_phone"]=list.get(contactPhone) as! String
                newEntry["msg"]=list.get(msg) as! String
                newEntry["pendingMsgs"]="0"
                if(self.getNameFromAddressbook(list.get(contactPhone)) != nil)
                {
                    newEntry["display_name"]=self.getNameFromAddressbook(list.get(contactPhone)) as! String
                }
                else{
                    newEntry["display_name"]=list.get(contactPhone)
                }
                newEntry["isArchived"]=list.get(isArchived)
                allChatsList.append(newEntry)
            }
        }
        catch{
            
        }
        
        return allChatsList
        
        
    }
    
    func getChatListForDesktopApp(user1:String)->[[String:Any]]
    {
       
        var allChatsList=[[String:Any]]()
       
    
        let to = Expression<String>("to")
        let from = Expression<String>("from")
        let fromFullName = Expression<String>("fromFullName")
        let msg = Expression<String>("msg")
        let owneruser = Expression<String>("owneruser")
        let date = Expression<Date>("date")
        let uniqueid = Expression<String>("uniqueid")
        let status = Expression<String>("status")
        let contactPhone = Expression<String>("contactPhone")
        let type = Expression<String>("type")
        let file_type = Expression<String>("file_type")
        let file_path = Expression<String>("file_path")
        let broadcastlistID = Expression<String>("broadcastlistID")
        let isBroadcastMessage = Expression<Bool>("isBroadcastMessage")
        let isArchived = Expression<Bool>("isArchived")
        
        /* toperson
         fromperson
         fromFullName
         msg
         date
         status
         type
         file_type
         uniqueid
         contact_phone*/
        
        self.userschats = Table("userschats")
        
        var query=(self.userschats.filter(to==user1 || from==user1).order(date.asc))
        do
        {
            for list in try self.db.prepare(query)
            {
            var newEntry = [String : Any]()
                
                newEntry["toperson"]=list.get(to)
                newEntry["fromperson"]=list.get(from)
                newEntry["fromFullName"]=list.get(fromFullName)
                newEntry["msg"]=list.get(msg)
                newEntry["date"]=list.get(date).debugDescription as AnyObject
                newEntry["status"]=list.get(status)
                newEntry["type"]=list.get(type)
                newEntry["file_type"]=list.get(file_type)
                newEntry["uniqueid"]=list.get(uniqueid)
                newEntry["contact_phone"]=list.get(date).debugDescription as AnyObject
                newEntry["isArchived"]=list.get(isArchived) as AnyObject
                allChatsList.append(newEntry)
               // break
            
            }
        }
        catch{
            
        }
        return allChatsList
    }
    
    func getChatDetails()->[[String:Any]]
    {
        let to = Expression<String>("to")
        let from = Expression<String>("from")
        let fromFullName = Expression<String>("fromFullName")
        let msg = Expression<String>("msg")
        let owneruser = Expression<String>("owneruser")
        let date = Expression<Date>("date")
        let uniqueid = Expression<String>("uniqueid")
        let status = Expression<String>("status")
        let contactPhone = Expression<String>("contactPhone")
        let type = Expression<String>("type")
        let file_type = Expression<String>("file_type")
        let file_path = Expression<String>("file_path")
        let broadcastlistID = Expression<String>("broadcastlistID")
        let isBroadcastMessage = Expression<Bool>("isBroadcastMessage")
        let isArchived = Expression<Bool>("isArchived")
       
        
        
        self.userschats = Table("userschats")
        var allChatsList=[[String:Any]]()
        
        
        //  let query = self.contactslists.select(messageuniqueid).filter(messageuniqueid == messageUniqueid1)
        do
        {
            
            let myquery=userschats?.group((userschats?[contactPhone])!).order(date.desc)
            
            var queryruncount=0
           for list in try sqliteDB.db.prepare(myquery!) {
                //for list in try self.db.prepare(self.userschats)
       // {
            var newEntry = [String : Any]()
      
            newEntry["date"]=list.get(date).debugDescription as AnyObject
            newEntry["contact_phone"]=list.get(contactPhone) as! String
            newEntry["msg"]=list.get(msg) as! String
            newEntry["pendingMsgs"]="0"
            if(self.getNameFromAddressbook(list.get(contactPhone)) != nil)
            {
            newEntry["display_name"]=self.getNameFromAddressbook(list.get(contactPhone)) as! String
            }
            else{
                newEntry["display_name"]=list.get(contactPhone)
            }
            newEntry["isArchived"]=list.get(isArchived)
            allChatsList.append(newEntry)
            }
        }
        catch{
            
        }
        
        return allChatsList
/*
         info platform data sharing message -> {"phone":"+923323800399","to_connection_id":"4731","from_connection_id":"74177","type":"loading_chatlist","data":[{"date":"2017-05-01T13:09:09.468Z","contact_phone":"+923000359691","msg":"hello","pendingMsgs":0,"display_name":"Ansa Laghari"},{"date":"2017-05-01T13:08:57.650Z","contact_phone":"+923333864540","msg":"test","pendingMsgs":0,"display_name":"Sumaira 2"}]}
 */
    }
    
    func getContactDetails()->[[String:Any]]
    {
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
        let blockedByMe = Expression<Bool>("blockedByMe")
        let IamBlocked = Expression<Bool>("IamBlocked")
        //blockedByMe
        //IamBlocked
        var allContactsList=[[String:Any]]()
        
        self.contactslists = Table("contactslists")
        do
        {for list in try self.db.prepare(self.contactslists)
        {
            var newEntry = [String : Any]()
            
            newEntry["phone"]=list.get(phone)
            newEntry["display_name"] = list.get(firstname)
                //self.getNameFromAddressbook(list.get(phone) as! String)
            newEntry["_id"]=list.get(userid) as! String
            newEntry["detailsshared"]=list.get(detailsshared) as! String
            newEntry["status"]=list.get(status) as! String
            newEntry["on_cloudkibo"]="true"
            newEntry["display_name"]=list.get(firstname)
                //UtilityFunctions.init().isKiboContact(phone1: list.get(phone)) as! String
            //on_cloudkibo
            allContactsList.append(newEntry)
            }
        }
        catch{
            
        }
        
        return allContactsList

        
        /*
         {"phone":"+923313548911","display_name":"DAYEM SIDDIQUI","_id":"587756acf661e36e14c4d9b9","detailsshared":"Yes","status":"I am on CloudKibo","on_cloudkibo":"true"},{"phone":"+923057007457","display_name":"Asad Steve Jobs","_id":"587757c9a1357780141f48e6","detailsshared":"Yes","status":"I am on CloudKibo","on_cloudkibo":"true"},{"phone":"+923410212162","display_name":"Imran Shaukat","_id":"587756e5f661e36e14c4d9ba","detailsshared":"Yes","status":"I am on CloudKibo","on_cloudkibo":"true"},{"phone":"+923341366328","display_name":"Asad Steve Jobs","_id":"5879cd41de29d3ff5659e448","detailsshared":"Yes","status":"I am on CloudKibo","on_cloudkibo":"true"
         */
    }
}
