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
                    var contactsWhoBlockedYouObjectList=resJSON["contactsWhoBlockedYou"]//: the contacts who have blocked you,
                    var contactsBlockedByMeObjectList=resJSON["contactsBlockedByMe"]//: the contacts which are blocked by me,
                    var myGroupsObjectList=resJSON["myGroups"]//: my groups,
                    var myGroupsMembersObjectList=resJSON["myGroupsMembers"]//: member of groups I am in,
                    var partialGroupChatObjectList=resJSON["partialGroupChat"]//: the partial group chat

                    
                }
                //print("JSON: \(JSON(response.))")
            }
        }
        
    }
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
            let datens2 = dateFormatter.date(from: UserchatJson["msg"][i]["date"].string!)
            
            print("fetch date from server got is \(UserchatJson["msg"][i]["date"].string!)... converted is \(datens2.debugDescription)")
            
            
            print("===fetch chat date raw from server in chatview is \(UserchatJson["msg"][i]["date"].string!)")
            
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
        DispatchQueue.main.async() {
            
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
            
        }
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
        return listStatuses
    }
    
    
    
}
