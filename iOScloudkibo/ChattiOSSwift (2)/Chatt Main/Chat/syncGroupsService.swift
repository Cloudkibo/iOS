//
//  syncGroupsService.swift
//  kiboApp
//
//  Created by Cloudkibo on 24/10/2016.
//  Copyright © 2016 MyAppTemplates. All rights reserved.
//

import Foundation
import AccountKit
import SwiftyJSON
import Alamofire
import SQLite
class syncGroupService
{
    
    init()
    {
        
        
        
    }
    func startSyncGroupsService(completion:(result:Bool,error:String!)->())
    {
        if(accountKit == nil){
            accountKit = AKFAccountKit(responseType: AKFResponseType.AccessToken)
        }
        
        
        if (accountKit!.currentAccessToken != nil) {
            
            
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)) {
                print("synccccc fetching contacts in background...")
                self.SyncGroupsAPI{ (result,error,groupinfo) in
                   if(groupinfo != nil)
                   {
                    self.fullRefreshGroupsInfo(groupinfo){ (result,error) in
                       
                        
                        self.SyncGroupMembersAPI(){(result,error,groupinfo) in
                            print("...")
                        }
                       /* self.fullRefreshMembersInfo(groupinfo){ (result,error) in
                            print("sync groups data done")
                            if(result == true)
                            {
                                return completion(result: true, error: nil)
                            }
                            else{
                                return completion(result: false, error: error)
                            }
                        }*/
                    
                    }}
                    else
                   {
                    return completion(result: true, error: nil)
                    }
                }
            }
        }
    }

    func SyncGroupsAPI(completion:(result:Bool,error:String!,groupinfo:JSON!)->())
    {
        
        //  let isMute = Expression<Bool>("isMute")

        var jsongroupinfo:JSON!=nil
        print("inside group info function")
        var url=Constants.MainUrl+Constants.getMyGroups
        print(url.debugDescription)
        /*
         'kibo-app-id' : '5wdqvvi8jyvfhxrxmu73dxun9za8x5u6n59',
         'kibo-app-secret': 'jcmhec567tllydwhhy2z692l79j8bkxmaa98do1bjer16cdu5h79xvx',
         'kibo-client-id': 'cd89f71715f2014725163952',
         */
        //var header:[String:String]=["kibo-app-id":DatabaseObjectInitialiser.getInstance().appid,"kibo-app-secret":DatabaseObjectInitialiser.getInstance().secretid,"kibo-client-id":DatabaseObjectInitialiser.getInstance().clientid]
        var hhh=["headers":"\(header)"]
        print(header.description)
        Alamofire.request(.GET,"\(url)",headers:header).validate().responseJSON { response in
            print(response)
            if(response.result.isSuccess)
            {
            print(response.result.value)
            jsongroupinfo=JSON(response.result.value!)
            return completion(result:true,error: nil,groupinfo: jsongroupinfo)
                
            }
            else{
                return completion(result:true,error: "API synch groups failed",groupinfo: jsongroupinfo)
                
            }
        }
        
        return completion(result:true,error: "Fetch group info API failed",groupinfo: jsongroupinfo)
    }
    
    func fullRefreshGroupsInfo(groupInfo:JSON,completion:(result:Bool,error:String!)->())
    {
        //_id:String,groupname:String,date_creation:String,group_icon:NSData
        var tbl_Groups=sqliteDB.groups
        
        
        do{
        try sqliteDB.db.run(tbl_Groups.delete())
            
            for(var i=0;i<groupInfo.count;i++)
            {
                //groupInfo[i]["group_unique_id"]
                var unique_id=groupInfo[i]["group_unique_id"]["unique_id"].string!
                var group_name=groupInfo[i]["group_unique_id"]["group_name"].string!
                var date_creation=groupInfo[i]["group_unique_id"]["date_creation"].string!
                var group_icon=NSData()
                if(groupInfo[i]["group_unique_id"]["group_icon"] != nil)
                {
                    group_icon=groupInfo[i]["group_unique_id"]["group_icon"] as! NSData
                }
                
                let dateFormatter = NSDateFormatter()
                dateFormatter.timeZone=NSTimeZone.localTimeZone()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                //  let datens2 = dateFormatter.dateFromString(date2.debugDescription)
                //2016-09-18T19:13:00.588Z
                let datens2 = dateFormatter.dateFromString(date_creation)
                
                
                sqliteDB.storeGroups(group_name, groupicon1: group_icon, datecreation1: datens2!, uniqueid1: unique_id)
            }
        }
        catch{
            print("cannot delete groups data")
        }
        
        return completion(result: true, error: nil)
    }
    
    func SyncGroupMembersAPI(completion:(result:Bool,error:String!,groupinfo:JSON!)->())
    {
        
        //  let isMute = Expression<Bool>("isMute")
        
        var jsongroupinfo:JSON!=nil
        print("inside group info function")
        var url=Constants.MainUrl+Constants.fetchmygroupmembers
        print(url.debugDescription)
        /*
         'kibo-app-id' : '5wdqvvi8jyvfhxrxmu73dxun9za8x5u6n59',
         'kibo-app-secret': 'jcmhec567tllydwhhy2z692l79j8bkxmaa98do1bjer16cdu5h79xvx',
         'kibo-client-id': 'cd89f71715f2014725163952',
         */
        //var header:[String:String]=["kibo-app-id":DatabaseObjectInitialiser.getInstance().appid,"kibo-app-secret":DatabaseObjectInitialiser.getInstance().secretid,"kibo-client-id":DatabaseObjectInitialiser.getInstance().clientid]
        var hhh=["headers":"\(header)"]
        print(header.description)
        Alamofire.request(.GET,"\(url)",headers:header).validate().responseJSON { response in
            print(response)
            if(response.result.isSuccess)
            {
                print("group members got success")
                print(response.result.value)
                jsongroupinfo=JSON(response.result.value!)
                print(jsongroupinfo)
                
                for(var i=0;i<jsongroupinfo.count;i++)
                {
                    /*
                     "__v" = 0;
                     "_id" = 58109ac9bd172a020ab9180b;
                     "date_join" = "2016-10-26T12:00:09.309Z";
                     "display_name" = sumaira;
                     "group_unique_id" = 58109ac9bd172a020ab9180a;
                     isAdmin = Yes;
                     "member_phone" = "+923333864540";
                     "membership_status" = joined;
                     */
                    
                    //groupInfo[i]["group_unique_id"]
                    var _id=jsongroupinfo[i]["_id"].string!
                    var group_id=jsongroupinfo[i]["group_unique_id"].string
                    var membername=jsongroupinfo[i]["display_name"].string
                   
                    var date_join=jsongroupinfo[i]["date_join"].string!
                    var isAdmin=jsongroupinfo[i]["isAdmin"].string
                    var member_phone=jsongroupinfo[i]["member_phone"].string!
                    var membership_status=jsongroupinfo[i]["membership_status"].string!
                    
                    
                    
                    let dateFormatter = NSDateFormatter()
                    dateFormatter.timeZone=NSTimeZone.localTimeZone()
                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                    //  let datens2 = dateFormatter.dateFromString(date2.debugDescription)
                    //2016-09-18T19:13:00.588Z
                    let datens2 = dateFormatter.dateFromString(date_join)
                    /*let firstname = Expression<String>("firstname")
                    
                    var myname=""
                    let tbl_accounts = sqliteDB.accounts
                    do{for account in try sqliteDB.db.prepare(tbl_accounts) {
                        myname=account[firstname]
                        //displayname=account[firstname]
                        
                        }
                    }
                    catch
                    {
                        if(socketObj != nil){
                            socketObj.socket.emit("error getting data from accounts table")
                        }
                        print("error in getting data from accounts table")
                        
                    }
                    */

                    
                    sqliteDB.storeMembers(group_id!,member_displayname1: membername!, member_phone1: member_phone, isAdmin1: isAdmin!, membershipStatus1: membership_status, date_joined1: datens2!)
                }
               
                return completion(result:true,error: nil,groupinfo: jsongroupinfo)
                
            }
            else{
                return completion(result:true,error: "API synch groups failed",groupinfo: jsongroupinfo)
                
            }
        }
        
        return completion(result:true,error: "Fetch group info API failed",groupinfo: jsongroupinfo)
    }
    
   /* func fullRefreshMembersInfo(groupInfo:JSON,completion:(result:Bool,error:String!)->())
    {
        
        
        var tbl_Groups_Members=sqliteDB.group_member
        
        
        do{
            try sqliteDB.db.run(tbl_Groups_Members.delete())
            
            for(var i=0;i<groupInfo.count;i++)
            {
                /*
                 "_id" = 580df4d266ec7ffb2e8464c9;
                 "date_join" = "2016-10-24T11:47:30.951Z";
                 "group_unique_id" =         {
                 "__v" = 0;
                 "_id" = 580df4d266ec7ffb2e8464c7;
                 "date_creation" = "2016-10-24T11:47:30.940Z";
                 "group_name" = "sample group";
                 "unique_id" = Iux1bdB20161024164730;
                 };
                 isAdmin = No;
                 "member_phone" = "+923333864540";
                 "membership_status" = joined;
                 */
                
                
                //groupInfo[i]["group_unique_id"]
                var _id=groupInfo[i]["_id"].string!
                var group_id=groupInfo[i]["group_unique_id"]["unique_id"].string
                var date_join=groupInfo[i]["date_join"].string!
                var isAdmin=groupInfo[i]["isAdmin"].string
                var member_phone=groupInfo[i]["member_phone"].string!
                var membership_status=groupInfo[i]["membership_status"].string!
                
              
                
                let dateFormatter = NSDateFormatter()
                dateFormatter.timeZone=NSTimeZone.localTimeZone()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                //  let datens2 = dateFormatter.dateFromString(date2.debugDescription)
                //2016-09-18T19:13:00.588Z
                let datens2 = dateFormatter.dateFromString(date_join)
                
                
                sqliteDB.storeMembers(group_id!, member_phone1: member_phone, isAdmin1: isAdmin!, membershipStatus1: membership_status, date_joined1: datens2!)
            }
        }
        catch{
            print("cannot refresh groups members data")
             return completion(result: false, error: "cannot refresh group members data")
        }
        
        return completion(result: true, error: nil)

        
    }
    */
    
    
    
    
    
    
    
    
    
}