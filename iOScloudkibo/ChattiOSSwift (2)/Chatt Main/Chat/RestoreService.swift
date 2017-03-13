//
//  RestoreService.swift
//  kiboApp
//
//  Created by Cloudkibo on 10/03/2017.
//  Copyright © 2017 MyAppTemplates. All rights reserved.
//

import Foundation
import SQLite
import UIKit
import SwiftyJSON

class RestoreService
{
    
    init()
    {
        
    }
    
    func startRestoreBackup(completion:@escaping (_ result:Bool)->())
    {
        let downloadQueue = OperationQueue();
        downloadQueue.maxConcurrentOperationCount = 1;
        
       // for i in 1...10 {
            
            let RestoreChatsTable : BlockOperation = BlockOperation(block: {
                self.RestoreChatsTable(filename: "userchats.json")
            })
        
        let restoreGroupsTable : BlockOperation = BlockOperation(block: {
            self.restoreGroupsTable(filename: "groups.json")
        })

        let restoreGroupMembersTable : BlockOperation = BlockOperation(block: {
            self.restoreGroupMembersTable(filename: "groupmembers.json")
        })

        let restoreGroupChatTable : BlockOperation = BlockOperation(block: {
            self.restoreGroupChatTable(filename: "groupchats.json")
        })

        let restoreBroadcastListTable : BlockOperation = BlockOperation(block: {
            self.restoreBroadcastListTable(filename: "broadcastlists.json")
        })

        let RestoreGroupChatsStatusTable : BlockOperation = BlockOperation(block: {
            self.RestoreGroupChatsStatusTable(filename: "groupchatstatus.json")
        })

        let restoreBroadcastListMembersTable : BlockOperation = BlockOperation(block: {
            self.restoreBroadcastListMembersTable(filename: "broadcastlistmembers.json")
        })

        let RestoreFilesTable : BlockOperation = BlockOperation(block: {
            self.RestoreFilesTable(filename: "files.json")
        })

        
            downloadQueue.addOperation(RestoreChatsTable)
              downloadQueue.addOperation(restoreGroupsTable)
              downloadQueue.addOperation(restoreGroupMembersTable)
              downloadQueue.addOperation(restoreGroupChatTable)
              downloadQueue.addOperation(restoreBroadcastListTable)
              downloadQueue.addOperation(RestoreGroupChatsStatusTable)
              downloadQueue.addOperation(restoreBroadcastListMembersTable)
            downloadQueue.addOperation(RestoreFilesTable)
        downloadQueue.waitUntilAllOperationsAreFinished()
        print("restore done")
        return completion(true)
       // }
    }
    
    func RestoreChatsTable(filename:String)
    {
        var ubiquityURL = UtilityFunctions.init().getBackupDirectoryICloud()
        
        if(ubiquityURL != nil)
        {
        ///////ubiquityURL=ubiquityURL!.appendingPathComponent("Backup", isDirectory: true)
        ubiquityURL=ubiquityURL!.appendingPathComponent("\(filename)")
        
        do{ var chatsData=try Data.init(contentsOf: ubiquityURL!)
            print("reading \(filename.removeCharsFromEnd(5)) table from icloud")
            print(JSON.init(data: chatsData))
            var ChatsDataJSONobject=JSON.init(data: chatsData)
            
            for chatsRows in ChatsDataJSONobject
            {
                var chats=chatsRows.1 //as! [String : Any]
             
                
                var formatterDateSendtoDateType = DateFormatter();
                formatterDateSendtoDateType.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ";
                var dateSentDateType = formatterDateSendtoDateType.date(from: chats["date"].string!)
                
                sqliteDB.SaveChat(chats["to"].string!, from1: chats["from"].string!, owneruser1: chats["owneruser"].string!, fromFullName1: chats["fromFullName"].string!, msg1: chats["msg"].string!, date1: dateSentDateType, uniqueid1: chats["uniqueid"].string!, status1: chats["status"].string!, type1: chats["type"].string!, file_type1: chats["file_type"].string!, file_path1: chats["file_path"].string!)
                
          
            }
        }
        catch{
            print("error reading \(filename.removeCharsFromEnd(5)) table from icloud")
        }
        }
    }
    
    func restoreGroupsTable(filename:String)
    {
        let group_name = Expression<String>("group_name")
        let group_icon = Expression<Data>("group_icon")
        let date_creation = Expression<Date>("date_creation")
        let unique_id = Expression<String>("unique_id")
        let isMute = Expression<Bool>("isMute")
        let status = Expression<Bool>("status")

        var ubiquityURL = UtilityFunctions.init().getBackupDirectoryICloud()
        
        if(ubiquityURL != nil)
        {
            ///////ubiquityURL=ubiquityURL!.appendingPathComponent("Backup", isDirectory: true)
            ubiquityURL=ubiquityURL!.appendingPathComponent("\(filename)")
            
            do{ var groupsData=try Data.init(contentsOf: ubiquityURL!)
                print("reading \(filename.removeCharsFromEnd(5)) table from icloud")
                print(JSON.init(data: groupsData))
                var groupsDataJSONobject=JSON.init(data: groupsData)
                
                for groupsRows in groupsDataJSONobject
                {
                    var groups=groupsRows.1 //as! [String : Any]
                    
                    var formatterDateSendtoDateType = DateFormatter();
                     let dateFormatter = DateFormatter()
                    dateFormatter.timeZone=NSTimeZone.local
                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                    //  let datens2 = dateFormatter.date(from:date2.debugDescription)
                    //2016-09-18T19:13:00.588Z
                    
                    print(" groups unique_id .string! is \( groups["unique_id"].string!)")
                    var datestring=groups["date_creation"]
                    print("datestring \(datestring)")
                    
                    let dateCreationDateType = dateFormatter.date(from: groups["date_creation"].debugDescription)
                   /// var datens2 = formatterDateSendtoDateType.date(from: groups["date_creation"].debugDescription)
                    
                    var group_icon=NSData()
                    
                    if(groups["group_icon"] != nil)
                    {
                        // group_icon=(groupSingleInfo[0]["group_icon"] as! String).dataUsingEncoding(NSUTF8StringEncoding)!
                        group_icon="exists".data(using: String.Encoding.utf8)! as Data as NSData
                        
                    }
                    
                    sqliteDB.storeGroups(groups["group_name"].string!, groupicon1: group_icon as Data!, datecreation1: dateCreationDateType!, uniqueid1: groups["unique_id"].string!, status1: groups["status"].string!)
                   
                    // sqliteDB.SaveChat(chats["to"].string!, from1: chats["from"].string!, owneruser1: chats["owneruser"].string!, fromFullName1: chats["fromFullName"].string!, msg1: chats["msg"].string!, date1: dateSentDateType, uniqueid1: chats["uniqueid"].string!, status1: chats["status"].string!, type1: chats["type"].string!, file_type1: chats["file_type"].string!, file_path1: chats["file_path"].string!)
                    
                    
                }
            }
            catch{
                print("error reading \(filename.removeCharsFromEnd(5)) table from icloud")
            }
        }
    }
    
    func restoreGroupMembersTable(filename:String)
    {
        var ubiquityURL = UtilityFunctions.init().getBackupDirectoryICloud()
        
        if(ubiquityURL != nil)
        {
            ///////ubiquityURL=ubiquityURL!.appendingPathComponent("Backup", isDirectory: true)
            ubiquityURL=ubiquityURL!.appendingPathComponent("\(filename)")
            
            do{ var chatsData=try Data.init(contentsOf: ubiquityURL!)
                print("reading \(filename.removeCharsFromEnd(5)) table from icloud")
                print(JSON.init(data: chatsData))
                var ChatsDataJSONobject=JSON.init(data: chatsData)
                
                for chatsRows in ChatsDataJSONobject
                {
                    var chats=chatsRows.1 //as! [String : Any]
                    let group_unique_id = Expression<String>("group_unique_id")
                    let member_phone = Expression<String>("member_phone")
                    let isAdmin = Expression<String>("isAdmin")
                    let membership_status = Expression<String>("membership_status")
                    let date_joined = Expression<Date>("date_joined")
                    let date_left = Expression<Date>("date_left")
                    let group_member_displayname = Expression<String>("group_member_displayname")
                    
                    
                    
                    var formatterDateSendtoDateType = DateFormatter();
                    formatterDateSendtoDateType.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ";
                    var date_joinedDate = formatterDateSendtoDateType.date(from: chats["date_joined"].string!)
                    
                     var date_leftDate = formatterDateSendtoDateType.date(from: chats["date_left"].string!)
                    
                   
                    sqliteDB.storeMembers(chats["group_unique_id"].string!, member_displayname1: chats["group_member_displayname"].string!, member_phone1: chats["member_phone"].string!, isAdmin1: chats["isAdmin"].string!, membershipStatus1: chats["membership_status"].string!, date_joined1: date_joinedDate!)
                    
                    //date left
                 
                    
                }
            }
            catch{
                print("error reading \(filename.removeCharsFromEnd(5)) table from icloud")
            }
        }
    }
    
    func restoreGroupChatTable(filename:String)
    {
        var ubiquityURL = UtilityFunctions.init().getBackupDirectoryICloud()
        
        if(ubiquityURL != nil)
        {
            ///////ubiquityURL=ubiquityURL!.appendingPathComponent("Backup", isDirectory: true)
            ubiquityURL=ubiquityURL!.appendingPathComponent("\(filename)")
            
            do{ var chatsData=try Data.init(contentsOf: ubiquityURL!)
                print("reading \(filename.removeCharsFromEnd(5)) table from icloud")
                print(JSON.init(data: chatsData))
                var ChatsDataJSONobject=JSON.init(data: chatsData)
                
                for chatsRows in ChatsDataJSONobject
                {
                    var chats=chatsRows.1 //as! [String : Any]
                    
                    let from = Expression<String>("from")
                    let group_unique_id = Expression<String>("group_unique_id")
                    let type = Expression<String>("type")
                    let msg = Expression<String>("msg")
                    let from_fullname = Expression<String>("from_fullname")
                    let date = Expression<Date>("date")
                    let unique_id = Expression<String>("unique_id")
                    

                    
                    var formatterDateSendtoDateType = DateFormatter();
                    formatterDateSendtoDateType.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ";
                    var dateSentDateType = formatterDateSendtoDateType.date(from: chats["date"].string!)
                    
                    
                    sqliteDB.storeGroupsChat(chats["from"].string!, group_unique_id1: chats["group_unique_id"].string!, type1: chats["type"].string!, msg1: chats["msg"].string!, from_fullname1: chats["from_fullname"].string!, date1: dateSentDateType!, unique_id1: chats["unique_id"].string!)
                    
                    
                }
            }
            catch{
                print("error reading \(filename.removeCharsFromEnd(5)) table from icloud")
            }
        }
    }
    
    func restoreBroadcastListTable(filename:String)
    {
        var ubiquityURL = UtilityFunctions.init().getBackupDirectoryICloud()
        
        if(ubiquityURL != nil)
        {
            ///////ubiquityURL=ubiquityURL!.appendingPathComponent("Backup", isDirectory: true)
            ubiquityURL=ubiquityURL!.appendingPathComponent("\(filename)")
            
            do{ var chatsData=try Data.init(contentsOf: ubiquityURL!)
                print("reading \(filename.removeCharsFromEnd(5)) table from icloud")
                print(JSON.init(data: chatsData))
                var ChatsDataJSONobject=JSON.init(data: chatsData)
                
                for chatsRows in ChatsDataJSONobject
                {
                    var chats=chatsRows.1 //as! [String : Any]
                    
                    let uniqueid = Expression<String>("uniqueid")
                    let listname = Expression<String>("listname")
      
                    
                   // var formatterDateSendtoDateType = DateFormatter();
                   // formatterDateSendtoDateType.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ";
                   // var dateSentDateType = formatterDateSendtoDateType.date(from: chats["date"].string!)
                    
                    sqliteDB.storeBroadcastList(chats["uniqueid"].string!, ListName1: chats["listname"].string!)
                    
                    
                }
            }
            catch{
                print("error reading \(filename.removeCharsFromEnd(5)) table from icloud")
            }
        }
    }
    
    func restoreBroadcastListMembersTable(filename:String)
    {
        
        var ubiquityURL = UtilityFunctions.init().getBackupDirectoryICloud()
        
        if(ubiquityURL != nil)
        {
            ///////ubiquityURL=ubiquityURL!.appendingPathComponent("Backup", isDirectory: true)
            ubiquityURL=ubiquityURL!.appendingPathComponent("\(filename)")
            
            do{ var chatsData=try Data.init(contentsOf: ubiquityURL!)
                print("reading \(filename.removeCharsFromEnd(5)) table from icloud")
                print(JSON.init(data: chatsData))
                var ChatsDataJSONobject=JSON.init(data: chatsData)
                
                for chatsRows in ChatsDataJSONobject
                {
                    var chats=chatsRows.1 //as! [String : Any]
                    
                    let uniqueid = Expression<String>("uniqueid")
                    let memberphone = Expression<String>("memberphone")
                    
                    sqliteDB.storeBroadcastListMembers(chats["uniqueid"].string!, memberphones: [chats["memberphone"].string!])
                    
                }
            }
            catch{
                print("error reading \(filename.removeCharsFromEnd(5)) table from icloud")
            }
        }

        
    }
    
    func RestoreGroupChatsStatusTable(filename:String)
    {
        var ubiquityURL = UtilityFunctions.init().getBackupDirectoryICloud()
        
        if(ubiquityURL != nil)
        {
            ///////ubiquityURL=ubiquityURL!.appendingPathComponent("Backup", isDirectory: true)
            ubiquityURL=ubiquityURL!.appendingPathComponent("\(filename)")
            
            do{ var chatsData=try Data.init(contentsOf: ubiquityURL!)
                print("reading \(filename.removeCharsFromEnd(5)) table from icloud")
                print(JSON.init(data: chatsData))
                var ChatsDataJSONobject=JSON.init(data: chatsData)
                
                for chatsRows in ChatsDataJSONobject
                {
                    var chats=chatsRows.1 //as! [String : Any]
                    
                    let msg_unique_id = Expression<String>("msg_unique_id")
                    let Status = Expression<String>("Status")
                    let user_phone = Expression<String>("user_phone")
                    
                    let read_date = Expression<Date>("read_date")
                    let delivered_date = Expression<Date>("delivered_date")
                    
                    var formatterDateSendtoDateType = DateFormatter();
                    formatterDateSendtoDateType.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ";
                    var read_dateDateType = formatterDateSendtoDateType.date(from: chats["read_date"].string!)
                   
                    var delivered_dateDateType = formatterDateSendtoDateType.date(from: chats["delivered_date"].string!)
                    
                    
                    sqliteDB.storeGRoupsChatStatus(chats["msg_unique_id"].string!, status1: chats["Status"].string!, memberphone1: chats["user_phone"].string!, delivereddate1: delivered_dateDateType!, readDate1: read_dateDateType!)
                   // sqliteDB.storeBroadcastListMembers(chats["uniqueid"].string!, memberphones: [chats["memberphone"].string!])
                    
                }
            }
            catch{
                print("error reading \(filename.removeCharsFromEnd(5)) table from icloud")
            }
        }
    }
    
    func RestoreFilesTable(filename:String)
    {
        var ubiquityURL = UtilityFunctions.init().getBackupDirectoryICloud()
        
        if(ubiquityURL != nil)
        {
            ///////ubiquityURL=ubiquityURL!.appendingPathComponent("Backup", isDirectory: true)
            ubiquityURL=ubiquityURL!.appendingPathComponent("\(filename)")
            
            do{ var chatsData=try Data.init(contentsOf: ubiquityURL!)
                print("reading \(filename.removeCharsFromEnd(5)) table from icloud")
                print(JSON.init(data: chatsData))
                var FilesDataJSONobject=JSON.init(data: chatsData)
                
                for fileRows in FilesDataJSONobject
                {
                    var files=fileRows.1 //as! [String : Any]
                    
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
                    
                    
                    //set file format "2017-03-06 14:06:43 +0000"
                    if(files["file_name"].string! != "" && files["file_name"].string! != nil)
                    {
                   copyToAppContainer(filename: files["file_name"].string!)
                    }
                    sqliteDB.saveFile(files["to"].string!, from1: files["from"].string!, owneruser1: username!, file_name1: files["file_name"].string!, date1: nil, uniqueid1: files["uniqueid"].string!, file_size1: files["file_size"].string!, file_type1: files["file_type"].string!, file_path1: files["file_path"].string!, type1: files["type"].string!)
                }
            }
            catch{
                print("error reading \(filename.removeCharsFromEnd(5)) table from icloud")
            }
        }
    }
    
    func copyToAppContainer(filename:String)
        
    {
        var ubiquityURL=UtilityFunctions.init().getBackupDirectoryICloud()
        
        
        if(ubiquityURL != nil)
        {
            ubiquityURL=ubiquityURL!.appendingPathComponent("\(filename)")
            print("ubiquityURL is \(ubiquityURL)")
            
            var filemgr=FileManager.init()
            
            let dirPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
            let docsDir1 = dirPaths[0]
            var documentDir=docsDir1 as NSString
            var filePathImage2=documentDir.appendingPathComponent(filename)
            
            
           /* var filedata=NSData.init(contentsOfFile: filePathImage2)
            var filepath2=URL(fileURLWithPath: filePathImage2)
            let documentURL=filepath2
            */
            ///////   if let ubiquityURL = ubiquityURL {
            var error:NSError? = nil
            var isDir:ObjCBool = false
            
            let coordinator = NSFileCoordinator()
            //var error:NSError? = nil
            coordinator.coordinate(readingItemAt: ubiquityURL!, options: [], error: &error) { (url) -> Void in
                
            }
            if (filemgr.fileExists(atPath: ubiquityURL!.path, isDirectory: &isDir)) {
                
                do{ var ans=try filemgr.copyItem(at: URL.init(fileURLWithPath: ubiquityURL!.path), to: URL.init(fileURLWithPath:filePathImage2))
                    ///var ans=try filemgr.setUbiquitous(true, itemAt: URL.init(fileURLWithPath: filePathImage2), destinationURL: ubiquityURL!)
                    
                    // var ans=try filemgr.createFile(atPath: (ubiquityURL?.absoluteString)!, contents: filedata as Data?, attributes: nil)
                    //.copyItem(at: documentURL, to: ubiquityURL!)
                    print("Your file \(filename) has been \(ans) saved to app Container")
                    ///--- backupChatsTable()
                }
                catch{
                    print("NOT saveddd to app container \(error)")
                }
            }
            else{
                
                print("file not found in icloud")
                
            }
        }
        
    }
    
}
