//
//  UpwardSyncService.swift
//  kiboApp
//
//  Created by Cloudkibo on 20/03/2017.
//  Copyright © 2017 MyAppTemplates. All rights reserved.
//

import Foundation
import SQLite
import UIKit
import SwiftyJSON
import AccountKit
import Alamofire

class syncService{
    
    
    
    init()
    {
        
    }
    
    func startDownwardSync(_ completion:@escaping (_ result:Bool,_ error:String?)->())
    {
        DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.background).async {
            
            //upwardSyncURL
            print("start downward sync service after install")
            if(accountKit == nil){
                accountKit = AKFAccountKit(responseType: AKFResponseType.accessToken)
            }
            
            
            if (accountKit!.currentAccessToken != nil) {
                
                var url=Constants.MainUrl+Constants.downwardSyncURL
                
            let request=Alamofire.request("\(url)", method: .get,encoding:JSONEncoding.default,headers:header).responseJSON { response in
            
                print("downward sync response is \(response)")
                if(response.response?.statusCode==200)
                {
                    
                    var resJSON=JSON.init(data:response.data!)
                    print("downward sync JSON response is \(resJSON)")
                    var partialChatObjectList=resJSON["partialChat"]//: the partial chat sync,
                    self.partialChatSync(UserchatJson: partialChatObjectList)
                    
                    var contactsUpdateObjectList=resJSON["contactsUpdate"]//: the update on your contacts,
                    self.contactUpdate(contactsJsonObj: contactsUpdateObjectList)
                    
                    var contactsWhoBlockedYouObjectList=resJSON["contactsWhoBlockedYou"]//: the contacts who have blocked you,
                    self.contactsWhoBlockedYou(contactsJsonObj: contactsWhoBlockedYouObjectList)
                    
                    var contactsBlockedByMeObjectList=resJSON["contactsBlockedByMe"]//: the contacts which are blocked by me,
                    self.contactsBlockedByMe(contactsJsonObj: contactsBlockedByMeObjectList)
                    
                    var myGroupsObjectList=resJSON["myGroups"]//: my groups,
                    self.getGroups(groupInfo: myGroupsObjectList)
                    
                    var myGroupsMembersObjectList=resJSON["myGroupsMembers"]//: member of groups I am in,
                    self.getGroupMembers(jsongroupinfo: myGroupsMembersObjectList)
                    
                    var partialGroupChatObjectList=resJSON["partialGroupChat"]//: the partial group chat
                    self.getPartialGroupChat(jsongroupinfo: partialGroupChatObjectList)
                    
                }
                //print("JSON: \(JSON(response.))")
            }
        }
        
    }
    }
/*
     try db.transaction {
     try db.run(alice.update(balance -= amount))
     try db.run(betty.update(balance += amount))
     }
 */
    
    func getPartialGroupChat(jsongroupinfo:JSON)
    {
        for i in 0 ..< jsongroupinfo.count
        {
            print("partial sync group chats storing info \(i)")
            
            // var _id=jsongroupinfo[i]["_id"].string!
            var uniqueid=jsongroupinfo[i]["msg_unique_id"]["unique_id"].string
            
            var date=jsongroupinfo[i]["msg_unique_id"]["date"].string
            
            var from=jsongroupinfo[i]["msg_unique_id"]["from"].string
            
            var from_fullname=jsongroupinfo[i]["msg_unique_id"]["from_fullname"].string
            
            var msg=jsongroupinfo[i]["msg_unique_id"]["msg"].string
            
            var group_unique_id=jsongroupinfo[i]["msg_unique_id"]["group_unique_id"]["unique_id"].string
            var type=jsongroupinfo[i]["msg_unique_id"]["type"].string
            var status=jsongroupinfo[i]["status"].string
            
            
            let dateFormatter = DateFormatter()
            dateFormatter.timeZone=NSTimeZone.local
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            
            let datens2 = dateFormatter.date(from:date!)
            
            
            if(type != "chat")
            {
                managerFile.checkPendingFilesInGroup(uniqueid!)
                
            }
            
            
            sqliteDB.storeGroupsChat(from!, group_unique_id1: group_unique_id!, type1: type!, msg1: msg!, from_fullname1: from_fullname!, date1: datens2!, unique_id1: uniqueid!)
            
            
            
            
            //== only for which i sent so no need sqliteDB.storeGRoupsChatStatus(uniqueid, status1: status, memberphone1: <#T##String#>)
        }
      
        // })
    
    }
    
    
    func getGroupMembers(jsongroupinfo:JSON)
    {
        
            do{
                try sqliteDB.db.transaction {
       
            var tbl_Groups_Members=sqliteDB.group_member
            
            try sqliteDB.db.run((tbl_Groups_Members?.delete())!)
        
        
        for var i in 0 ..< jsongroupinfo.count
        {
            
            var _id=jsongroupinfo[i]["_id"].string!
            var group_id=jsongroupinfo[i]["group_unique_id"]["unique_id"].string
            var membername=jsongroupinfo[i]["display_name"].string
            
            var date_join=jsongroupinfo[i]["date_join"].string!
            var isAdmin=jsongroupinfo[i]["isAdmin"].string
            var member_phone=jsongroupinfo[i]["member_phone"].string!
            var membership_status=jsongroupinfo[i]["membership_status"].string!
            
            
            
            let dateFormatter = DateFormatter()
            dateFormatter.timeZone=NSTimeZone.local
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            
            let datens2 = dateFormatter.date(from:date_join)
            
            
            sqliteDB.storeMembers(group_id!,member_displayname1: membername!, member_phone1: member_phone, isAdmin1: isAdmin!, membershipStatus1: membership_status, date_joined1: datens2!)
        }
        }
    }catch{
    print("error delete and adding group members")
    }
}

    
    func getGroups(groupInfo:JSON)
    {
        var tbl_Groups=sqliteDB.groups
        
        
        do{
             try sqliteDB.db.transaction {
            try sqliteDB.db.run((tbl_Groups?.delete())!)
            
            for i in 0 ..< groupInfo.count
            {
                //groupInfo[i]["group_unique_id"]
                var unique_id=groupInfo[i]["group_unique_id"]["unique_id"].string!
                var group_name=groupInfo[i]["group_unique_id"]["group_name"].string!
                var date_creation=groupInfo[i]["group_unique_id"]["date_creation"].string!
                var group_icon=Data()
                if(groupInfo[i]["group_unique_id"]["group_icon"] != nil)
                {
                    
                    //group_icon=(groupInfo[i]["group_unique_id"]["group_icon"] as! String).dataUsingEncoding(NSUTF8StringEncoding)!
                    group_icon="exists".data(using: String.Encoding.utf8)!
                    var filedata=sqliteDB.getFilesData(unique_id)
                    if(filedata.count>0)
                    {
                        print("found group icon")
                        print("actual path is \(filedata["file_path"])")
                        //======
                        
                        //=======
                        let dirPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
                        let docsDir1 = dirPaths[0]
                        var documentDir=docsDir1 as NSString
                        var imgPath=documentDir.appendingPathComponent(filedata["file_name"] as! String)
                        
                        var imgNSData=FileManager.default.contents(atPath:imgPath)
                        
                        // print("found path is \(imgNSData)")
                        if(imgNSData != nil)
                        {
                            //update UI
                        }
                        else
                        {
                            print("didnot find group icon")
                            UtilityFunctions.init().downloadProfileImage(unique_id)
                        }
                        
                    }
                    else
                    {
                        UtilityFunctions.init().downloadProfileImage(unique_id)
                    }
                    
                    
                    //=== UtilityFunctions.init().downloadProfileImage(<#T##uniqueid1: String##String#>)
                    //==uncomment later group_icon=groupInfo[i]["group_unique_id"]["group_icon"] as NSData
                }
                
                let dateFormatter = DateFormatter()
                dateFormatter.timeZone=TimeZone.autoupdatingCurrent
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                //  let datens2 = dateFormatter.date(from:date2.debugDescription)
                //2016-09-18T19:13:00.588Z
                let datens2 = dateFormatter.date(from:date_creation)
                
                sqliteDB.storeGroups(group_name, groupicon1: group_icon, datecreation1: datens2!, uniqueid1: unique_id, status1: "new")
                
                //=====MUTE GROUP====
                sqliteDB.storeMuteGroupSettingsTable(unique_id, isMute1: false, muteTime1: Date(), unMuteTime1: Date())
                
            }
        }
        }
        catch{
            print("cannot delete groups data")
        }
        

    }
    
    
    func contactsBlockedByMe(contactsJsonObj:JSON)
    {
        let blockedByMe = Expression<Bool>("blockedByMe")
        var contactslists = Table("contactslists")

        if(contactsJsonObj.count>0)
        {
            do{
                try sqliteDB.db.run(contactslists.select(blockedByMe).update(blockedByMe<-false))
            }
            catch{
                print("error: unable to update value iAMblocked contact")
            }
        }
        
        for i in 0 ..< contactsJsonObj.count
        {
            
            print("inside for loop")
            
                var phone=contactsJsonObj[i]["contactid"]["phone"].string
                
         sqliteDB.BlockContactUpdateStatus(phone1: phone!,status1: true)
        }
    }
    
    func contactsWhoBlockedYou(contactsJsonObj:JSON)
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
        
        var contactslists = Table("contactslists")
      if(contactsJsonObj.count>0)
      {
        do{
            try sqliteDB.db.run(contactslists.select(IamBlocked,phone).update(IamBlocked<-false))
        }
        catch{
            print("error: unable to update value iAMblocked contact")
        }
        }
         for i in 0 ..< contactsJsonObj.count
         {
            
         print("inside for loop")
         do {
         var phone=contactsJsonObj[i]["contactid"]["phone"].string
       
            sqliteDB.IamBlockedUpdateStatus(phone1: phone!, status1: true)
            //contactid[phone]
         
         }
         catch{
            
            }
        }
 
    }
    
    func contactUpdate(contactsJsonObj:JSON)
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
        
        
        let tbl_contactslists=sqliteDB.contactslists
        /////////newwwwwwwww///////
        do{try sqliteDB.db.run((tbl_contactslists?.delete())!)}catch{
            print("contactslist table not deleted")
        }
        ////////////////
     
            for i in 0 ..< contactsJsonObj.count
            {
                print("inside for loop")
                do {
                    if(contactsJsonObj[i]["contactid"]["username"].string != nil)
                    {
                        print("inside username hereeeeeee old")
                        let rowid = try sqliteDB.db.run((tbl_contactslists?.insert(contactid<-contactsJsonObj[i]["contactid"]["_id"].string!,
                                                                                   detailsshared<-contactsJsonObj[i]["detailsshared"].string!,
                                                                                   
                                                                                   unreadMessage<-contactsJsonObj[i]["unreadMessage"].boolValue,
                                                                                   
                                                                                   userid<-contactsJsonObj[i]["userid"].string!,
                                                                                   firstname<-contactsJsonObj[i]["contactid"]["firstname"].string!,
                                                                                   lastname<-contactsJsonObj[i]["contactid"]["lastname"].string!,
                                                                                   email<-contactsJsonObj[i]["contactid"]["email"].string!,
                                                                                   phone<-contactsJsonObj[i]["contactid"]["phone"].string!,
                                                                                   username<-contactsJsonObj[i]["contactid"]["username"].string!,
                                                                                   status<-contactsJsonObj[i]["contactid"]["status"].string!))!
                        )
                        print("data inserttt")
                        
                        print("inserted id: \(rowid)")
                    }
                    else
                    {
                        print("inside displayname hereeeeeee")
                        
                        
                        let rowid = try sqliteDB.db.run((tbl_contactslists?.insert(contactid<-contactsJsonObj[i]["contactid"]["_id"].string!,
                                                                                   detailsshared<-contactsJsonObj[i]["detailsshared"].string!,
                                                                                   
                                                                                   unreadMessage<-contactsJsonObj[i]["unreadMessage"].boolValue,
                                                                                   
                                                                                   userid<-contactsJsonObj[i]["userid"].string!,
                                                                                   firstname<-contactsJsonObj[i]["contactid"]["display_name"].string!,
                                                                                   lastname<-"",
                                                                                   
                                                                                   //lastname<-contactsJsonObj[i]["contactid"]["lastname"].string!,
                            email<-"@",
                            phone<-contactsJsonObj[i]["contactid"]["phone"].string!,
                            username<-contactsJsonObj[i]["contactid"]["phone"].string!,
                            status<-contactsJsonObj[i]["contactid"]["status"].string!))!
                        )
                        
                        print("inserted id: \(rowid)")
                        
                    }
                    
                } catch {
                    print("insertion failed: \(error)")
                }
                
            }
            
            print("contacts fetchedddddddddddddd sucecess")
        

    }
    
    func partialChatSync(UserchatJson:JSON)
    {
        socketObj.socket.emit("logClient","IPHONE-LOG: all chat messages count is \(UserchatJson["msg"].count)")
        for i in 0 ..< UserchatJson["msg"].count
            
        {
            
            // var isFile=false
            var chattype="chat"
            var file_type=""
            //UserchatJson["msg"][i]["date"].string!
            
            
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            //let datens2 = dateFormatter.date(from: UserchatJson["msg"][i]["date"].string!)
            let datens2 = dateFormatter.date(from: UserchatJson["msg"][i]["date_server_received"].string!)
            //date_server_receive
           
            
            
            /*
             let formatter = DateFormatter()
             formatter.dateFormat = "MM/dd hh:mm a"";
             // formatter.dateStyle = NSDateFormatterStyle.ShortStyle
             //formatter.timeStyle = .ShortStyle
             
             let dateString = formatter.stringFromDate(datens2!)
             */
            
            if(UserchatJson["msg"][i]["type"].exists())
            {
                chattype=UserchatJson["msg"][i]["type"].string!
            }
            
            if(UserchatJson["msg"][i]["file_type"].exists())
            {
                file_type=UserchatJson["msg"][i]["file_type"].string!
            }
            
            if(UserchatJson["msg"][i]["uniqueid"].exists())
            {
                
                
                if(UserchatJson["msg"][i]["to"].string! == username! && UserchatJson["msg"][i]["status"].string!=="sent")
                {
                    var updatedStatus="delivered"
                    
                    
                    sqliteDB.SaveChat(UserchatJson["msg"][i]["to"].string!, from1: UserchatJson["msg"][i]["from"].string!,owneruser1:UserchatJson["msg"][i]["owneruser"].string! , fromFullName1: UserchatJson["msg"][i]["fromFullName"].string!, msg1: UserchatJson["msg"][i]["msg"].string!,date1:datens2,uniqueid1:UserchatJson["msg"][i]["uniqueid"].string!,status1: updatedStatus, type1: chattype, file_type1: file_type,file_path1: "" )
                    
                    //socketObj.socket.emit("messageStatusUpdate",["status":"","iniqueid":"","sender":""])
                    
                    
                    if(UserchatJson["msg"][i]["type"].string! == "file")
                    {
                        managerFile.checkPendingFiles(UserchatJson["msg"][i]["uniqueid"].string!)
                        
                    }
                    
                    //==-- new change  managerFile.sendChatStatusUpdateMessage(UserchatJson["msg"][i]["uniqueid"].string!, status: updatedStatus, sender: UserchatJson["msg"][i]["from"].string!)
                    
                    
                    
                    
                }
                else
                {
                    
                    if(UserchatJson["msg"][i]["type"].string! == "file")
                    {
                        managerFile.checkPendingFiles(UserchatJson["msg"][i]["uniqueid"].string!)
                        
                    }
                    
                    sqliteDB.SaveChat(UserchatJson["msg"][i]["to"].string!, from1: UserchatJson["msg"][i]["from"].string!,owneruser1:UserchatJson["msg"][i]["owneruser"].string! , fromFullName1: UserchatJson["msg"][i]["fromFullName"].string!, msg1: UserchatJson["msg"][i]["msg"].string!,date1:datens2,uniqueid1:UserchatJson["msg"][i]["uniqueid"].string!,status1: UserchatJson["msg"][i]["status"].string!, type1: chattype, file_type1: file_type,file_path1: "" )
                    
                }
            }
            else
            {
                sqliteDB.SaveChat(UserchatJson["msg"][i]["to"].string!, from1: UserchatJson["msg"][i]["from"].string!,owneruser1:UserchatJson["msg"][i]["owneruser"].string! , fromFullName1: UserchatJson["msg"][i]["fromFullName"].string!, msg1: UserchatJson["msg"][i]["msg"].string!,date1:datens2,uniqueid1:"",status1: "",type1: chattype, file_type1: file_type,file_path1: "" )
                
            }
            
        }
        
        
        
        
        // if(UserchatJson["msg"].count > 0)
        //{
       /* DispatchQueue.main.async() {
            
            UIDelegates.getInstance().UpdateMainPageChatsDelegateCall()
            UIDelegates.getInstance().UpdateSingleChatDetailDelegateCall()
            
            /*if(delegateRefreshChat != nil)
            {print("updating UI now ...")
                delegateRefreshChat?.refreshChatsUI(nil, uniqueid:nil, from:nil, date1:nil, type:"status")
            }
            
            if(socketObj.delegateChat != nil)
            {
                socketObj.delegateChat?.socketReceivedMessageChat("updateUI", data: nil)
            }
            if(self.delegate != nil)
            {
                self.delegate?.socketReceivedMessage("updateUI", data: nil)
            }
            ///////// }
            */
            
        }*/
        print("all fetched chats saved in sqlite success")
        //}
        
        
    
    }
    
    func startUpwardSyncService(_ completion:@escaping (_ result:Bool,_ error:String?)->())
    {print("start upward sync service after install")
        if(accountKit == nil){
            accountKit = AKFAccountKit(responseType: AKFResponseType.accessToken)
        }
        
        
        if (accountKit!.currentAccessToken != nil) {
            
            var url=Constants.MainUrl+Constants.upwardSyncURL
            var params=["unsentMessages":self.createArrayUnsentChatMessages(),
                        "unsentGroupMessages": self.getPendingGroupChatMessages(),
                        "unsentChatMessageStatus":self.sendPendingChatStatuses(),
                        "unsentGroupChatMessageStatus":self.sendPendingGroupChatStatuses(),
                        "unsentGroups":[],
                        "unsentAddedGroupMembers":[],
                        "unsentRemovedGroupMembers":[],
                        "statusOfSentMessages":self.getStatusOfSentChats(),
                        "statusOfSentGroupMessages":self.getStatusOfSentGroupChats()] as [String : Any]
            
            DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.background).async {
                
                //upwardSyncURL
                let request=Alamofire.request("\(url)", method: .post, parameters: params,encoding:JSONEncoding.default,headers:header).responseJSON { response in
                    
                    print("upward sync \(response)")
                    return completion(true,nil)
                }
            
                
            }
        }
    }

    func createArrayUnsentChatMessages()->[[String:String]]
    {
    
        var pendingchatsarray=[[String:String]]()
    
        //self.pendingchatsarray.removeAll()
        
        print("checkin here inside pending chat messages.....")
        var userchats=sqliteDB.userschats
        var userchatsArray:Array<Row>
        
        
        
        let to = Expression<String>("to")
        let from = Expression<String>("from")
        let owneruser = Expression<String>("owneruser")
        let fromFullName = Expression<String>("fromFullName")
        let msg = Expression<String>("msg")
        let date = Expression<Date>("date")
        let status = Expression<String>("status")
        let uniqueid = Expression<String>("uniqueid")
        let type = Expression<String>("type")
        let file_type = Expression<String>("file_type")
        
        
        var tbl_userchats=sqliteDB.userschats
       
        do
        {print("pending chats in background")
            var count=0
               print("initially pending chats count is \(pendingchatsarray.count)")
            
            do
            {for pendingchats in try sqliteDB.db.prepare((tbl_userchats?.filter(status=="pending").order(date.asc))!)
            {
                
                // print("pending chats count date desc is \(count)")
                count += 1
                
                var imParas=["from":pendingchats[from],"to":pendingchats[to],"fromFullName":pendingchats[fromFullName],"msg":pendingchats[msg],"uniqueid":pendingchats[uniqueid],"type":pendingchats[type],"file_type":pendingchats[file_type]]
                
                
                
                pendingchatsarray.append(imParas)
    
                print("imparas are \(imParas)")
                
                
            }
            }
            catch{
                print("cant get pending chat messages")
            }
        }
        
        return pendingchatsarray
    }
    
    func sendPendingChatStatuses()->[[String:String]]
    {
        var tbl_messageStatus=sqliteDB.statusUpdate
        let status = Expression<String>("status")
        let sender = Expression<String>("sender")
        let uniqueid = Expression<String>("uniqueid")
        
         var pendingchatsStatusArray=[[String:String]]()
        do
        {
            for statusMessages in try sqliteDB.db.prepare(tbl_messageStatus!)
            {
            var imParas=["uniqueid":statusMessages[uniqueid],"sender":statusMessages[sender],"status":statusMessages[status]] as [String : Any]
            pendingchatsStatusArray.append(imParas as! [String : String])
            
            
            }
        }
        catch{
            print("error: cant get pending statuses")
        }
        
        return pendingchatsStatusArray
    }
    
    func getPendingGroupChatMessages()->[[String:String]]
    {
        
        var pendingGroupchatsMsgsArray=[[String:String]]()
        
        let from = Expression<String>("from")
        let group_unique_id = Expression<String>("group_unique_id")
        let type = Expression<String>("type")
        let msg = Expression<String>("msg")
        let from_fullname = Expression<String>("from_fullname")
        let date = Expression<Date>("date")
        let unique_id = Expression<String>("unique_id")
        
        
        
        var pendingMSGs=sqliteDB.findGroupChatPendingMsgDetails()
        //var res=tbl_userchats.filter(to==selecteduser || from==selecteduser)
        //to==selecteduser || from==selecteduser
        //print("chat from sqlite is")
        //print(res)
        
        var count=0
        for i in 0 ..< pendingMSGs.count
        {
           // pendingMSGs[i]["group_unique_id"] as! String, from: pendingMSGs[i]["from"] as! String, type: pendingMSGs[i]["type"] as! String, msg: pendingMSGs[i]["msg"] as! String, fromFullname: pendingMSGs[i]["from_fullname"] as! String, uniqueidChat: pendingMSGs[i]["unique_id"] as! String
            
            
            var params=["group_unique_id":pendingMSGs[i]["group_unique_id"] as! String,"from":pendingMSGs[i]["from"] as! String,"type":pendingMSGs[i]["type"] as! String,"msg":pendingMSGs[i]["msg"] as! String,"from_fullname":pendingMSGs[i]["from_fullname"] as! String,"unique_id":pendingMSGs[i]["unique_id"] as! String]
            
            pendingGroupchatsMsgsArray.append(params)
        }
        
      return pendingGroupchatsMsgsArray
    }
    
    func sendPendingGroupChatStatuses()->[[String:String]]
    {
        
        var pendingGroupchatsStatusArray=[[String:String]]()
        
        var tbl_groupStatusUpdatesTemp=sqliteDB.groupStatusUpdatesTemp
        let status = Expression<String>("status")
        let sender = Expression<String>("sender")
        let messageuniqueid = Expression<String>("messageuniqueid")
        
        do{
            for statusMessages in try sqliteDB.db.prepare(tbl_groupStatusUpdatesTemp!)
            {
                //statusMessages[messageuniqueid], status1: statusMessages[status]
                var params=["chat_unique_id":statusMessages[messageuniqueid],"status":statusMessages[status]]
                pendingGroupchatsStatusArray.append(params)
            }
            
        
        
        }
        catch{
            print("error: cant get unsent statuses for group chat statuses")
        }
        
        return pendingGroupchatsStatusArray
    }
    
    
    func getStatusOfSentGroupChats()->[String:[String]]
    {
        var statusNotSentList=sqliteDB.getGroupsChatStatusUniqueIDsListNotSeen()
        var params=["unique_ids":statusNotSentList]
       //  var statusNotSentList=sqliteDB.getGroupsChatStatusUniqueIDsListNotSeen()
       // var params=["chat_unique_id":statusNotSentList]
        return params
    }
    
    func getStatusOfSentChats()->[String:[String]]
    {
        
        var statusNotSentList=sqliteDB.getChatStatusListNotSeenObject()
        var listStatuses=[String:[String]]()
        var listUniqueIDS=[String]()
        for obj in statusNotSentList
        {
           listUniqueIDS.append(obj["uniqueid"]!)
            
       // var params=["uniqueid":obj["uniqueid"],"status":obj["status"]]
           // listStatuses.append(params as! [String : String])
        }
        listStatuses["unique_ids"]=listUniqueIDS
        print("getStatusOfSentChats \(listStatuses)")
        return listStatuses
    }
    
    
    
}
