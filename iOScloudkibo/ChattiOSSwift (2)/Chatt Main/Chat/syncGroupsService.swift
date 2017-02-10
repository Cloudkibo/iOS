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
    func startSyncGroupsService(_ completion:@escaping (_ result:Bool,_ error:String?)->())
    {print("start sync groups service after install")
        if(accountKit == nil){
            accountKit = AKFAccountKit(responseType: AKFResponseType.accessToken)
        }
        
        
        if (accountKit!.currentAccessToken != nil) {
            
            
            
            DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.background).async {
                print("synccccc fetching contacts in background...")
                self.SyncGroupsAPI{ (result,error,groupinfo) in
                   if(groupinfo != nil)
                   {
                    self.fullRefreshGroupsInfo(groupinfo){ (result,error) in
                       
                        
                        self.SyncGroupMembersAPI(){(result,error,groupinfo) in
                            print("...")
                            
                            return completion(true, nil)
                           // UtilityFunctions.init().downloadProfileImage("9Mm0S3b201611817744")
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
                    return completion(true, nil)
                    }
                }
            }
        }
        print("stop sync groups service after install")
    }
    
    func startSyncGroupsServiceOnLaunch(_ completion:@escaping (_ result:Bool,_ error:String?)->())
    {print("group sync on launch start")
        if(accountKit == nil){
            accountKit = AKFAccountKit(responseType: AKFResponseType.accessToken)
        }
        
        
        if (accountKit!.currentAccessToken != nil) {
           
                
  /*          Alamofire.request(.POST,"\(Constants.MainUrl+Constants.urllog)",headers:header,parameters: ["data":"IPHONE_LOG: group sync on install start \(username!)"]).response{
                request, response_, data, error in
                print(error)
            }
*/
            
          //  var Q5_fetchAllGroupsData=dispatch_queue_create("fetchAllGroupsData",DISPATCH_QUEUE_SERIAL)
           // dispatch_async(Q5_fetchAllGroupsData,{
                print("synccccc fetching contacts in background on launch...")
            DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.default).sync
            {
                self.SyncGroupsAPIonLaunch{ (result,error,groupinfo) in
                    if(groupinfo != nil)
                    {
                        self.fullRefreshGroupsInfoOnLaunch(groupinfo){ (result,error) in
                            
                            
                            self.SyncGroupMembersAPIonLaunch(){(result,error,groupinfo) in
                                print("...")
                                
                                DispatchQueue.main.async
                                {
                                return completion(true, nil)
                                }
                                
                                // UtilityFunctions.init().downloadProfileImage("9Mm0S3b201611817744")
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
                    { DispatchQueue.main.async
                    {
                        return completion(true, nil)
                        }
                    }
                }
            }
         //   })
        }
        print("group sync on launch stop")
    }
    
    func startPartialGroupsChatSyncService()
    {
        
        if(accountKit == nil){
            accountKit = AKFAccountKit(responseType: AKFResponseType.accessToken)
        }
        
        
        if (accountKit!.currentAccessToken != nil) {
            
            /*Alamofire.request(.POST,"\(Constants.MainUrl+Constants.urllog)",headers:header,parameters: ["data":"IPHONE_LOG: Starting partial groups chat sync \(username!)"]).response{
                request, response_, data, error in
                print(error)
            }*/
            
           //commented for testing
          DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.low).async {
                print("sync partial groups chat in background...")
            /*Alamofire.request(.POST,"\(Constants.MainUrl+Constants.urllog)",headers:header,parameters: ["data":"IPHONE_LOG: sync partial groups chat in background... \(username!)"]).response{
                request, response_, data, error in
                print(error)
            }*/
                self.partialSyncGroupsChat{ (result,error,groupinfo) in
                   /// if(groupinfo != nil)
                    //{
                        print("updating UI now...")
                    DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.low).async {
                        /*Alamofire.request(.POST,"\(Constants.MainUrl+Constants.urllog)",headers:header,parameters: ["data":"IPHONE_LOG: sync group chat statuses in background... \(username!)"]).response{
                            request, response_, data, error in
                            print(error)
                        }*/
                        self.syncGroupChatStatuses{(result,error) in
                            
                            
                            
                          /*  Alamofire.request(.POST,"\(Constants.MainUrl+Constants.urllog)",headers:header,parameters: ["data":"IPHONE_LOG: Done group chat statuses in background... \(username!)"]).response{
                                request, response_, data, error in
                                print(error)
                            }*/
                            
                        if(result==true)
                        {
                            
                        DispatchQueue.main.async
                        {
                           /* Alamofire.request(.POST,"\(Constants.MainUrl+Constants.urllog)",headers:header,parameters: ["data":"IPHONE_LOG: updating all UI screens \(username!)"]).response{
                                request, response_, data, error in
                                print(error)
                            }*/

                        UIDelegates.getInstance().UpdateMainPageChatsDelegateCall()
                        UIDelegates.getInstance().UpdateGroupInfoDetailsDelegateCall()
                        UIDelegates.getInstance().UpdateGroupChatDetailsDelegateCall()
                        }
                        }
                        }
                    }
                    ////}
                }
            }}
    }
    
    func SyncGroupsAPIonLaunch(_ completion:@escaping (_ result:Bool,_ error:String?,_ groupinfo:JSON?)->())
    {
        
        //  let isMute = Expression<Bool>("isMute")
        
        var jsongroupinfo:JSON!=nil
        print("inside group info function")
        var url=Constants.MainUrl+Constants.getMyGroups
        print(url.debugDescription)
        
        var hhh=["headers":"\(header)"]
        print(header.description)
        
       // var queue2=dispatch_queue_attr_make_with_qos_class(DISPATCH_QUEUE_SERIAL, QOS_CLASS_BACKGROUND, 0);
        
        //let queue2 = dispatch_queue_create("com.kibochat.manager-response-queue-file", DISPATCH_QUEUE_CONCURRENT)
       // let qqq=dispatch_queue_create("com.kibochat.queue.getmembers",queue2)
        
        DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.default).sync
        {
            var request=Alamofire.request("\(url)",headers:header).response{ response in
        /*
        request.response(
            queue: qqq,
            responseSerializer: Request.JSONResponseSerializer(),
            completionHandler: { response in
                */
                
                
                
                //.validate().responseJSON { response in
                print(response)
                if(response.response?.statusCode==200)
                {
                    print(response.request?.value)
                    jsongroupinfo=JSON(response.request!.value)
                    DispatchQueue.main.async
                    {
                    return completion(true,nil,jsongroupinfo)
                    }
                    
                }
                else{
                    DispatchQueue.main.async
                    {
                    return completion(true,"API synch groups failed",jsongroupinfo)
                    }
                    
                }
        }
        }
        
        //====----return completion(result:true,error: "Fetch group info API failed",groupinfo: jsongroupinfo)
    }

    func SyncGroupsAPI(_ completion:@escaping (_ result:Bool,_ error:String?,_ groupinfo:JSON?)->())
    {
        
        //  let isMute = Expression<Bool>("isMute")

        var jsongroupinfo:JSON!=nil
        print("inside group info function")
        var url=Constants.MainUrl+Constants.getMyGroups
        print(url.debugDescription)
     
        var hhh=["headers":"\(header)"]
        print(header.description)
        
        //var queue2=DispatchQoS(_FIXME_useThisWhenCreatingTheQueueAndRemoveFromThisCall: DispatchQueue.//Attributes.concurrent, qosClass: DispatchQoS.QoSClass.background, relativePriority: 0);
        
        //let queue2 = dispatch_queue_create("com.kibochat.manager-response-queue-file", DISPATCH_QUEUE_CONCURRENT)
        let qqq=DispatchQueue(label: "com.kibochat.queue.getmembers")//,attributes: queue2)
        
        let request = Alamofire.request("\(url)", method: .get, headers:header).responseData(queue: qqq) { (response) in
            
            /*
        var request=Alamofire.request(.GET,"\(url)",headers:header)
        request.response(
            queue: qqq,
            responseSerializer: Request.JSONResponseSerializer(),
            completionHandler: { response in
                */

        
        
        //.validate().responseJSON { response in
            print(response)
            if(response.result.isSuccess)
            {
            print(response.result.value)
            jsongroupinfo=JSON(response.result.value!)
            return completion(true,nil,jsongroupinfo)
                
            }
            else{
                return completion(true,"API synch groups failed",jsongroupinfo)
                
            }
        }
    
        return completion(true,"Fetch group info API failed",jsongroupinfo)
    }
    
    
    //dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0))
    
    func fullRefreshGroupsInfoOnLaunch(_ groupInfo:JSON!,completion:@escaping (_ result:Bool,_ error:String?)->())
    {
        /*Alamofire.request(.POST,"\(Constants.MainUrl+Constants.urllog)",headers:header,parameters: ["data":"IPHONE_LOG: update database on install with gruop info \(username!)"]).response{
            request, response_, data, error in
            print(error)
        }*/

        
        print("inside full refresh groups")
        //_id:String,groupname:String,date_creation:String,group_icon:NSData
        var tbl_Groups=sqliteDB.groups
        
        
        //==-- down do{
           //==---- down try sqliteDB.db.run(tbl_Groups.delete())
            var groupsList=[[String:AnyObject]]()
        DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.default).sync
        {
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
                    print("group icon existssss")
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
                        
                        var imgNSData=FileManager.default.contents(atPath: imgPath)
                        
                        // print("found path is \(imgNSData)")
                        if(imgNSData != nil)
                        {
                            //update UI
                            
                        }
                        else
                        {
                            print("didnot find group icon")
                         //=====UtilityFunctions.init().downloadProfileImageOnLaunch(unique_id)
                        }
                        
                    }
                    else
                    {
                       //=====UtilityFunctions.init().downloadProfileImageOnLaunch(unique_id)
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
                var data=[String:AnyObject]()
                data["group_name"]=group_name as AnyObject?
                data["groupicon1"]=group_icon as AnyObject?
                data["datecreation1"]=datens2 as AnyObject?
                data["uniqueid1"]=unique_id as AnyObject?
                data["status1"]="new" as AnyObject?
                groupsList.append(data)
                
               //==-- move down sqliteDB.storeGroups(group_name, groupicon1: group_icon, datecreation1: datens2!, uniqueid1: unique_id, status1: "new")
                
                //=====MUTE GROUP====
               //==---- down sqliteDB.storeMuteGroupSettingsTable(unique_id, isMute1: false, muteTime1: NSDate(), unMuteTime1: NSDate())
                
            }
            
            //delete and add
        do{
            try sqliteDB.db.run((tbl_Groups?.delete())!)
            
            for i in 0 ..< groupsList.count
            {
            sqliteDB.storeGroups(groupsList[i]["group_name"] as! String, groupicon1: groupsList[i]["groupicon1"] as! Data, datecreation1: groupsList[i]["datecreation1"] as! Date , uniqueid1: groupsList[i]["uniqueid1"] as! String, status1: groupsList[i]["status1"] as! String)
            sqliteDB.storeMuteGroupSettingsTable(groupsList[i]["uniqueid1"] as! String, isMute1: false, muteTime1: Date(), unMuteTime1: Date())
            }
            
            DispatchQueue.main.async
            {
                return completion(true, nil)
            }
        }
            
        catch{
            print("cannot delete groups data")
        }
            DispatchQueue.main.async
            {
                
                return completion(true, nil)
            }
        }
        
    }
    
    func fullRefreshGroupsInfo(_ groupInfo:JSON!,completion:(_ result:Bool,_ error:String?)->())
    {print("inside full refresh groups")
        //_id:String,groupname:String,date_creation:String,group_icon:NSData
        var tbl_Groups=sqliteDB.groups
        
        
        do{
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
        catch{
            print("cannot delete groups data")
        }
        
        return completion(true, nil)
    }
    
    
    func SyncGroupMembersAPIonLaunch(_ completion:@escaping (_ result:Bool,_ error:String?,_ groupinfo:JSON?)->())
    {
        print("sync members")
        
        //  let isMute = Expression<Bool>("isMute")
        
        var jsongroupinfo:JSON!=nil
        print("inside group info function")
        var url=Constants.MainUrl+Constants.fetchmygroupmembers
        print(url.debugDescription)
        //var queue2=dispatch_queue_attr_make_with_qos_class(DISPATCH_QUEUE_CONCURRENT, QOS_CLASS_BACKGROUND, 0);
        
        //let queue2 = dispatch_queue_create("com.kibochat.manager-response-queue-file", DISPATCH_QUEUE_CONCURRENT)
       // let qqq=dispatch_queue_create("com.kibochat.queue.getmembers",queue2)
        
        
        var hhh=["headers":"\(header)"]
        print(header.description)
       DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.default).sync
       {
        
          let request = Alamofire.request("\(url)",headers:header).responseJSON { response in
            
            /*
        var request=Alamofire.request(.GET,"\(url)",headers:header).validate().responseJSON{ response in
            */
        
            /*queue: qqq,
            responseSerializer: Request.JSONResponseSerializer(),
            completionHandler: { response in
              */
                
                //.validate().responseJSON { response in
                print(response)
                if(response.result.isSuccess)
                {
                    /*
                    Alamofire.request(.POST,"\(Constants.MainUrl+Constants.urllog)",headers:header,parameters: ["data":"IPHONE_LOG: got group members on install \(username!)"]).response{
                        request, response_, data, error in
                        print(error)
                    }*/

                    
                    print("group members got success")
                    print(response.result.value)
                    jsongroupinfo=JSON(response.result.value!)
                    print(jsongroupinfo)
                    do{
                        var tbl_Groups_Members=sqliteDB.group_member
                        try sqliteDB.db.run((tbl_Groups_Members?.delete())!)
                    }catch{
                        print("error delete members")
                    }
                    
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
                    
                    DispatchQueue.main.async
                    {
                    return completion(true,nil,jsongroupinfo)
                    }
                    
                }
                else{
                    return completion(true,"API synch groups failed",jsongroupinfo)
                    
                }
        }
        //)
        }
        //===---return completion(result:true,error: "Fetch group info API failed",groupinfo: jsongroupinfo)
    }
    
    func SyncGroupMembersAPI(_ completion:@escaping (_ result:Bool,_ error:String?,_ groupinfo:JSON?)->())
    {
        print("sync members")
        
        //  let isMute = Expression<Bool>("isMute")
        
        var jsongroupinfo:JSON!=nil
        print("inside group info function")
        var url=Constants.MainUrl+Constants.fetchmygroupmembers
        print(url.debugDescription)
        
        //var queue2=DispatchQoS(DispatchQueue.Attributes.concurrent, qosClass: DispatchQoS.QoSClass.background, relativePriority: 0);
        
        //let queue2 = dispatch_queue_create("com.kibochat.manager-response-queue-file", DISPATCH_QUEUE_CONCURRENT)
        let qqq=DispatchQueue(label: "com.kibochat.queue.getmembers")
        
        var hhh=["headers":"\(header)"]
       // print(header.description)
        
            
             let request = Alamofire.request("\(url)",headers:header).responseData(queue: qqq)
             { response in
                
      /*  var request=Alamofire.request(.GET,"\(url)",headers:header)
        request.response(
            queue: qqq,
            responseSerializer: Request.JSONResponseSerializer(),
            completionHandler: { response in
           */
            
            //.validate().responseJSON { response in
            print(response)
            if(response.result.isSuccess)
            {
                print("group members got success")
                print(response.result.value)
                jsongroupinfo=JSON(response.result.value!)
                print(jsongroupinfo)
                do{
                    var tbl_Groups_Members=sqliteDB.group_member
                try sqliteDB.db.run((tbl_Groups_Members?.delete())!)
                }catch{
                    print("error delete members")
                }
                
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
               
                return completion(true,nil,jsongroupinfo)
                
            }
            else{
                return completion(true,"API synch groups failed",jsongroupinfo)
                }
        }
        
        return completion(true,"Fetch group info API failed",jsongroupinfo)
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
                
              
                
                let dateFormatter = DateFormatter()
                dateFormatter.timeZone=NSTimeZone.local()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                //  let datens2 = dateFormatter.date(from:date2.debugDescription)
                //2016-09-18T19:13:00.588Z
                let datens2 = dateFormatter.date(from:date_join)
                
                
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
    
    func partialSyncGroupsChat(_ completion:@escaping (_ result:Bool,_ error:String?,_ groupinfo:JSON?)->())
    {
            print("sync partial chat")
            
            //  let isMute = Expression<Bool>("isMute")
            
            var jsongroupinfo:JSON!=nil
        
            var url=Constants.MainUrl+Constants.syncGetPartialGroupChats
            print(url.debugDescription)
        
            var hhh=["headers":"\(header)"]
            print(header.description)
        
        let request = Alamofire.request("\(url)",headers:header).responseJSON{response in
            
            
            //Alamofire.request(.GET,"\(url)",headers:header).validate().responseJSON { response in
            
                print(response)
                 print(response.response?.statusCode)
                if(response.result.isSuccess)
                {
                    
                    let request = Alamofire.request("\(Constants.MainUrl+Constants.urllog)",parameters: ["data":"IPHONE_LOG: group chat partial got success \(username!)"],headers:header).responseJSON(completionHandler: { (response) in
                   /* Alamofire.request(.POST,"\(Constants.MainUrl+Constants.urllog)",headers:header,parameters: ["data":"IPHONE_LOG: group chat partial got success \(username!)"]).response{
                        request, response_, data, error in
                        print(error)
                    }*/
                    print("group chat partial got success")
                    print(response.result.value)
                    jsongroupinfo=JSON(response.result.value)
                    print(jsongroupinfo)
                    
                    print("jsongroupinfo.count is \(jsongroupinfo.count)")
                    /*
                     "__v" = 0;
                     "_id" = 58214c1acf342a4837076bbb;
                     "chat_unique_id" = iCtXklp201611885258;
                     "delivered_date" = "2016-11-08T03:52:58.881Z";
                     "msg_unique_id" =     {
                     "__v" = 0;
                     "_id" = 58214c1acf342a4837076bba;
                     date = "2016-11-08T03:52:58.844Z";
                     from = "+923333864540";
                     "from_fullname" = "+923333864540";
                     "group_unique_id" = 5818607d35edf8ae2aa61070;
                     msg = 2;
                     type = chat;
                     "unique_id" = iCtXklp201611885258;
                     };
                     "read_date" = "2016-11-08T03:52:58.881Z";
                     status = sent;
                     "user_phone" = "+923201211991";
                     */
                    
                    
                    /*do{
                        var tbl_Groups_Members=sqliteDB.group_member
                        try sqliteDB.db.run(tbl_Groups_Members.delete())
                    }catch{
                        print("error delete members")
                    }*/
                    
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
                        
                        
                        sqliteDB.storeGroupsChat(from!, group_unique_id1: group_unique_id!, type1: type!, msg1: msg!, from_fullname1: from_fullname!, date1: datens2!, unique_id1: uniqueid!)
                        
                        
                       
                        
                        //== only for which i sent so no need sqliteDB.storeGRoupsChatStatus(uniqueid, status1: status, memberphone1: <#T##String#>)
                    }
 
                    DispatchQueue.main.async
                    {
                    return completion(true,nil,jsongroupinfo)
                    }
                })
                }
                    
                else{
                    print("error in partial group chat sync \(response.result)")
                    return completion(true,"API synch group chats partial failed",jsongroupinfo)
                    
                }
            }
            
            return completion(true,"API synch group chats partial failed",jsongroupinfo)
      

    }
    
    
    func syncGroupChatStatuses(_ completion:@escaping (_ result:Bool,_ error:String?)->())
    {print("sync statuses")
        var statusNotSentList=sqliteDB.getGroupsChatStatusUniqueIDsListNotSeen()
        var jsongroupinfo:JSON!=nil
        
        var url=Constants.MainUrl+Constants.checkGroupMsgStatus
        print(url.debugDescription)
        print("status list is \(statusNotSentList)")
        var hhh=["headers":"\(header)"]
        print(header.description)
        
        
        let request = Alamofire.request("\(url)", method: .post, parameters: ["unique_ids":statusNotSentList],headers:header).responseJSON{response in
            
            
            
            /*
        Alamofire.request(.POST,"\(url)",parameters:["unique_ids":statusNotSentList],headers:header, encoding: .JSON).validate().responseJSON { response in
            */
            print(response)
            print(response.response?.statusCode)
            if(response.result.isSuccess)
            {
               /* Alamofire.request(.POST,"\(Constants.MainUrl+Constants.urllog)",headers:header,parameters: ["data":"IPHONE_LOG: partial sync group chat statuses success \(username!)"]).response{
                    request, response_, data, error in
                    print(error)
                }*/
                
             print("yes success")
                print(JSON(response.result.value!).count)
                var jsongroupinfo=JSON(response.result.value!)
                for var i in 0 ..< jsongroupinfo.count
                {
                    var uniqueid1=jsongroupinfo[i]["chat_unique_id"].string!
                    var user_phone1=jsongroupinfo[i]["user_phone"].string!
                    var read_dateString=jsongroupinfo[i]["read_date"].string!

                    var delivered_dateString=jsongroupinfo[i]["delivered_date"].string!
                    var status1=jsongroupinfo[i]["status"].string!
                    
                     let dateFormatter = DateFormatter()
                     dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                
                    let delivered_date = dateFormatter.date(from: delivered_dateString)
                    let read_date = dateFormatter.date(from:read_dateString)
                    
                    print("updating status ......... \(i)")
                    sqliteDB.updateGroupChatStatus(uniqueid1, memberphone1: user_phone1, status1: status1, delivereddate1: delivered_date, readDate1: read_date)
                    
                }
                DispatchQueue.main.async
                {
                return completion(true, nil)
                }
                /*
                 {
                 "__v" = 0;
                 "_id" = 5821ea870138a8054212a2ba;
                 "chat_unique_id" = yU5bS8l201611820854;
                 "delivered_date" = "2016-11-08T15:08:56.437Z";
                 "msg_unique_id" = 5821ea870138a8054212a2b9;
                 "read_date" = "2016-11-08T15:08:55.242Z";
                 status = delivered;
                 "user_phone" = "+923333864540";
                 }
                 */
            }
            else
            {
                
              /*  Alamofire.request(.POST,"\(Constants.MainUrl+Constants.urllog)",headers:header,parameters: ["data":"IPHONE_LOG: partial sync group chat statuses failed \(username!)"]).response{
                    request, response_, data, error in
                    print(error)
                }
*/
                DispatchQueue.main.async
                {
                return completion(false,"Unable to fetch data")
                }
            }
            
        }
    }
    
    
    
    
}
