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

class syncService{
    
    
    
    init()
    {
        
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
            var imParas=["uniqueid":statusMessages[uniqueid],"sender":sender,"status":statusMessages[status]] as [String : Any]
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
        var userchats=sqliteDB.userschats
        //  var userchatsArray:Array<Row>
        
        
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
    
    
    
    
}
