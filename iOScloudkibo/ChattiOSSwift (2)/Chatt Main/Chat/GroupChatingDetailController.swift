//
//  GroupChatingDetailController.swift
//  kiboApp
//
//  Created by Cloudkibo on 31/08/2016.
//  Copyright © 2016 MyAppTemplates. All rights reserved.
//

import UIKit
import Alamofire
import SQLite
import SwiftyJSON
//import Haneke
class GroupChatingDetailController: UIViewController,UpdateGroupChatDetailsDelegate {
    
    
    
    
    var cellY:CGFloat=0
    var showKeyboard=false
    var keyFrame:CGRect!
    var keyheight:CGFloat!
    /////
    
    
    
    @IBOutlet weak var viewForContent: UIScrollView!
    
    var swipedRow:Int!
    ///@IBOutlet weak var viewForTableAndTextfield: UIView!
    var membersList=[[String:AnyObject]]()
    var delegateReload:UpdateGroupChatDetailsDelegate!
    var mytitle=""
    var groupid1=""
    var groupimage:Data!=nil
    var messages:NSMutableArray!
    @IBOutlet var tblForGroupChat: UITableView!
    
    @IBOutlet weak var txtFieldMessage: UITextField!
   
    @IBOutlet weak var chatComposeView: UIView!
    
    @IBAction func backBtnPressed(_ sender: AnyObject) {
        self.dismiss(animated: true) { 
            
            
        }
    }
    func setTitle(_ title:String, subtitle:String) -> UIView {
        //Create a label programmatically and give it its property's
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0)) //x, y, width, height where y is to offset from the view center
        titleLabel.backgroundColor = UIColor.clear
        titleLabel.textColor = UIColor.white
        titleLabel.font = UIFont.boldSystemFont(ofSize: 17)
        titleLabel.text = title
        titleLabel.sizeToFit()
        
        //Create a label for the Subtitle
        let subtitleLabel = UILabel(frame: CGRect(x: 0, y: 18, width: 0, height: 0))
        subtitleLabel.backgroundColor = UIColor.clear
        //subtitleLabel.textColor = UIColor.lightGrayColor()
        subtitleLabel.textColor = UIColor.black
        
        subtitleLabel.font = UIFont.systemFont(ofSize: 12)
        subtitleLabel.text = subtitle
        subtitleLabel.sizeToFit()
        
        //===
        let titleView = UIView(frame: CGRect(x: 0, y: 0, width: max(titleLabel.frame.size.width, subtitleLabel.frame.size.width), height: 30))
        titleView.addSubview(titleLabel)
        titleView.addSubview(subtitleLabel)
        
        let widthDiff = subtitleLabel.frame.size.width - titleLabel.frame.size.width
        
        var frame = titleLabel.frame
        frame.origin.x = widthDiff / 2
        titleLabel.frame = frame.integral
        /*if widthDiff > 0 {
            var frame = titleLabel.frame
            frame.origin.x = widthDiff / 2
            titleLabel.frame = CGRectIntegral(frame)
        } else {
            var frame = subtitleLabel.frame
            frame.origin.x = abs(widthDiff) / 2
            titleLabel.frame = CGRectIntegral(frame)
        }*/

        ///===
        /*
        // Create a view and add titleLabel and subtitleLabel as subviews setting
        let titleView = UIView(frame: CGRectMake(0, 0, max(titleLabel.frame.size.width, subtitleLabel.frame.size.width), 30))
        
        // Center title or subtitle on screen (depending on which is larger)
        if titleLabel.frame.width >= subtitleLabel.frame.width {
            var adjustment = subtitleLabel.frame
            adjustment.origin.x = titleView.frame.origin.x + (titleView.frame.width/2) - (subtitleLabel.frame.width/2)
            subtitleLabel.frame = adjustment
        } else {
            var adjustment = titleLabel.frame
            adjustment.origin.x = titleView.frame.origin.x + (titleView.frame.width/2) - (titleLabel.frame.width/2)
            titleLabel.frame = adjustment
        }
        
        titleView.addSubview(titleLabel)
        titleView.addSubview(subtitleLabel)
        */
        return titleView
    }

    @IBAction func btnSendTapped(_ sender: AnyObject){
        
        var uniqueid_chat=generateUniqueid()
        var date=getDateString(Date())
        var status="pending"
        messages.add(["msg":txtFieldMessage.text!+" (pending)", "type":"2", "fromFullName":"","date":date,"uniqueid":uniqueid_chat])
        
        
  
        
        //save chat
        sqliteDB.storeGroupsChat(username!, group_unique_id1: groupid1, type1: "chat", msg1: txtFieldMessage.text!, from_fullname1: username!, date1: Date(), unique_id1: uniqueid_chat)
        
        
        //get members and store status as pending
        for i in 0 .. membersList.count
        {
            /*
             let member_phone = Expression<String>("member_phone")
             let isAdmin = Expression<String>("isAdmin")
             let membership_status
 */
            if((membersList[i]["member_phone"] as! String) != username! && (membersList[i]["membership_status"] as! String) != "left")
            {
                print("adding group chat status for \(membersList[i]["member_phone"])")
                sqliteDB.storeGRoupsChatStatus(uniqueid_chat, status1: "pending", memberphone1: membersList[i]["member_phone"]! as! String, delivereddate1: UtilityFunctions.init().minimumDate(), readDate1: UtilityFunctions.init().minimumDate())
            }
        }
        
        var chatmsg=txtFieldMessage.text!
        txtFieldMessage.text = "";
        tblForGroupChat.reloadData()
        if(messages.count>1)
        {
            var indexPath = IndexPath(row:messages.count-1, section: 0)
            tblForGroupChat.scrollToRow(at: indexPath, at: UITableViewScrollPosition.bottom, animated: true)
  
        
            
        }
        
        /////// dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED,0))
        ////// {
        
        DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.default).async
        {
            print("messages count before sending msg is \(self.messages.count)")
            self.sendChatMessage(self.groupid1, from: username!, type: "chat", msg: chatmsg, fromFullname: username!, uniqueidChat: uniqueid_chat, completion: { (result) in
                
                print("chat sent")
                if(result==true)
                {
                    for i in 0 ..< self.membersList.count
                    {
                    if((self.membersList[i]["member_phone"] as! String) != username! && (self.membersList[i]["membership_status"] as! String) != "left")
                    {
                        sqliteDB.updateGroupChatStatus(uniqueid_chat, memberphone1: self.membersList[i]["member_phone"]! as! String, status1: "sent", delivereddate1: Date(), readDate1: Date())
                        
                         // === wrong sqliteDB.storeGRoupsChatStatus(uniqueid_chat, status1: "sent", memberphone1: self.membersList[i]["member_phone"]! as! String, delivereddate1: UtilityFunctions.init().minimumDate(), readDate1: UtilityFunctions.init().minimumDate())
                    }
                    }

                   //==== sqliteDB.updateGroupChatStatus(uniqueid_chat, memberphone1: username!,status1: "sent", delivereddate1: UtilityFunctions.init().minimumDate(), readDate1: UtilityFunctions.init().minimumDate())
                    
                    UIDelegates.getInstance().UpdateGroupChatDetailsDelegateCall()
                }
            })
        }
        
    
    }
    
    func sendChatMessage(_ group_id:String,from:String,type:String,msg:String,fromFullname:String,uniqueidChat:String,completion:@escaping (_ result:Bool)->())
    {
        // let queue=dispatch_get_global_queue(QOS_CLASS_USER_INITIATED,0)
        // let queue = dispatch_queue_create("com.kibochat.manager-response-queue", DISPATCH_QUEUE_CONCURRENT)
        /*  let request = Alamofire.request(.POST, "\(url)", parameters: chatstanza,headers:header)
         request.response(
         queue: queue,
         responseSerializer: Request.JSONResponseSerializer(options: .AllowFragments),
         completionHandler: { response in
         */
        
        //group_unique_id = <group_unique_id>, from, type, msg, from_fullname, unique_id
        
        var url=Constants.MainUrl+Constants.sendGroupChat
        print(url)
        print("..")
        let request = Alamofire.request(.POST, "\(url)", parameters: ["group_unique_id":group_id,"from":from,"type":type,"msg":msg,"from_fullname":fromFullname,"unique_id":uniqueidChat],headers:header).responseJSON { response in
            // You are now running on the concurrent `queue` you created earlier.
            //print("Parsing JSON on thread: \(NSThread.currentThread()) is main thread: \(NSThread.isMainThread())")
            
            // Validate your JSON response and convert into model objects if necessary
            //print(response.result.value) //status, uniqueid
            
            // To update anything on the main thread, just jump back on like so.
            //print("\(chatstanza) ..  \(response)")
            print("status code is \(response.response?.statusCode)")
            print(response)
            print(response.result.error)
            if(response.response?.statusCode==200 || response.response?.statusCode==201)
            {
                
                //print("chat ack received")
                var statusNow="sent"
                ///var chatmsg=JSON(data)
                /// //print(data[0])
                /////print(chatmsg[0])
                //print("chat sent unikque id \(chatstanza["uniqueid"])")
                
              //  sqliteDB.UpdateChatStatus(chatstanza["uniqueid"]!, newstatus: "sent")
                
                
                
                
                
                
                
                /////    dispatch_async(dispatch_get_main_queue()) {
                //print("Am I back on the main thread: \(NSThread.isMainThread())")
                
                print("MAINNNNNNNNNNNN")
                completion(result: true)
                //self.retrieveChatFromSqlite(self.selectedContact)
                
                
                
                
                /////// }
            }
            else{
                completion(result: false)
                
                }
        }//)
        
    }
    

    
    override func viewWillAppear(_ animated: Bool) {
        
        
        //======== self.navigationController?.title=mytitle
        
        
     /*   let swipeRecognizer = UISwipeGestureRecognizer(target: self, action: Selector("chatSwipped:"))
        //Add the recognizer to your view.
        swipeRecognizer.direction = .Left
        tblForGroupChat.addGestureRecognizer(swipeRecognizer)
 */
        UIDelegates.getInstance().delegateGroupChatDetails1=self
        membersList=sqliteDB.getGroupMembersOfGroup(self.groupid1)
        
   
        
        var namesList=[String]()
        for i in 0 ..< membersList.count
        {
            //var fullname=""
            if((sqliteDB.getNameFromAddressbook(membersList[i]["member_phone"] as! String)) != nil)
            {
                namesList.append(sqliteDB.getNameFromAddressbook(membersList[i]["member_phone"]  as! String))
            }
            else
            {
                if((sqliteDB.getNameGroupMemberNameFromMembersTable(membersList[i]["member_phone"] as! String)) != nil)
                {
                    namesList.append(sqliteDB.getNameGroupMemberNameFromMembersTable(membersList[i]["member_phone"] as! String))
                }
                else
                {
                    namesList.append(membersList[i]["member_phone"] as! String)
                }
            }
        }
        var subtitleMembers=namesList.joined(separator: ",").trunc(20)
      self.navigationItem.titleView = setTitle(mytitle, subtitle: subtitleMembers)
       // self.navigationItem.title = mytitle
       // self.navigationItem.prompt=subtitleMembers
  
        self.retrieveChatFromSqlite { (result) in
            
            
                self.tblForGroupChat.reloadData()
            
            if(self.messages.count>1)
            {
                var indexPath = IndexPath(row:self.messages.count-1, section: 0)
                
                self.tblForGroupChat.scrollToRow(at: indexPath, at: UITableViewScrollPosition.bottom, animated: true)
            }
        }
        
    }
    
    override func viewDidLoad() {
        
        
        
       //   self.navigationItem.titleView = setTitle(mytitle, subtitle: "Sumaira,xyz,abc")
        messages=NSMutableArray()
        
        
        NotificationCenter.default.removeObserver(self, name:NSNotification.Name.UIApplicationWillResignActive, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(UIApplicationDelegate.applicationWillResignActive(_:)), name:NSNotification.Name.UIApplicationWillResignActive, object: nil)
        
        //
        
        NotificationCenter.default.removeObserver(self, name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(UIApplicationDelegate.applicationDidBecomeActive(_:)), name:NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
        
        
        
        
        NotificationCenter.default.removeObserver(self, name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(GroupChatingDetailController.keyboardWillShow(_:)), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        
       //uncomment later NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name: UIKeyboardWillHideNotification, object: nil)
        

       /* NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name: UIKeyboardWillHideNotification, object: nil)
        */
        
        
        if(groupimage != nil)
        {
            print("found group icon avatar \(self.navigationItem.rightBarButtonItems?.count)")
            
            /*
             //var w=imageavatar1!.size.width
             //  var h=imageavatar1!.size.height
             var wOld=(self.navigationController?.navigationBar.frame.height)!-5
             var hOld=(self.navigationController?.navigationBar.frame.width)!-5
             //var scale:CGFloat=w/wOld
             
             cell!.profilePic.layer.cornerRadius = cell!.profilePic.frame.size.width/2
             cell!.profilePic.clipsToBounds = true
             */
            //cell.profilePic.hnk_format=Format<UIImage>
            var scaledimage=ImageResizer(size: CGSize(width: (self.navigationController?.navigationBar.frame.height)!,height: (self.navigationController?.navigationBar.frame.height)!), scaleMode: .AspectFit, allowUpscaling: true, compressionQuality: 0.5)
            //var resizedimage=scaledimage.resizeImage(UIImage(data:ContactsProfilePic)!)
            //==---cell!.profilePic.hnk_setImage(scaledimage.resizeImage(UIImage(data:ContactsProfilePic)!), key: groupid1)
            
            
            ///var s=CGSizeMake((self.navigationController?.navigationBar.frame.height)!-5,(self.navigationController?.navigationBar.frame.height)!-5)
            var groupiconimage=scaledimage.resizeImage(UIImage(data:groupimage)!)
            var barAvatarImage=UIImageView.init(image: groupiconimage)
            
            barAvatarImage.layer.borderWidth = 1.0
            //==--barAvatarImage.layer.masksToBounds = false
            barAvatarImage.layer.borderColor = UIColor.whiteColor().CGColor
            //==---barAvatarImage.layer.cornerRadius = barAvatarImage.frame.size.width/2
            //==--- barAvatarImage.clipsToBounds = true
            
            //print("bav avatar size is \(barAvatarImage.frame.width) .. \(barAvatarImage.frame.width)")
            
            
            var avatarbutton=UIBarButtonItem.init(customView: barAvatarImage)
            self.navigationItem.rightBarButtonItems?.first?.customView = avatarbutton.customView
            
            //==---self.navigationItem.leftBarButtonItems?.insert(avatarbutton, atIndex: 1)
            
        }
        
        /*var filedata=sqliteDB.getFilesData(groupid1)
        if(filedata.count>0)
        {
            print("found group icon")
            print("actual path is \(filedata["file_path"])")
            //======
            
            //=======
            let dirPaths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
            let docsDir1 = dirPaths[0]
            var documentDir=docsDir1 as NSString
            var imgPath=documentDir.stringByAppendingPathComponent(filedata["file_name"] as! String)
            
            var imgNSData=NSFileManager.defaultManager().contentsAtPath(imgPath)

            //==
            var imageavatar1=UIImage.init(data:(imgNSData)!)
            //   imageavatar1=ResizeImage(imageavatar1!,targetSize: s)
            
            //var img=UIImage(data:ContactsProfilePic[indexPath.row])
            var w=imageavatar1!.size.width
            var h=imageavatar1!.size.height
            var wOld=(self.navigationController?.navigationBar.frame.height)!-5
            var hOld=(self.navigationController?.navigationBar.frame.width)!-5
            var scale:CGFloat=w/wOld
            
            
            ///var s=CGSizeMake((self.navigationController?.navigationBar.frame.height)!-5,(self.navigationController?.navigationBar.frame.height)!-5)
            
            var barAvatarImage=UIImageView.init(image: UIImage(data: (imgNSData)!,scale:scale))
            
            barAvatarImage.layer.borderWidth = 1.0
            barAvatarImage.layer.masksToBounds = false
            barAvatarImage.layer.borderColor = UIColor.whiteColor().CGColor
            barAvatarImage.layer.cornerRadius = barAvatarImage.frame.size.width/2
            barAvatarImage.clipsToBounds = true
            
            //print("bav avatar size is \(barAvatarImage.frame.width) .. \(barAvatarImage.frame.width)")
            
            var avatarbutton=UIBarButtonItem.init(customView: barAvatarImage)
            self.navigationItem.rightBarButtonItems?.insert(avatarbutton, atIndex: 0)
            
            //ContactsProfilePic.append(foundcontact.imageData!)
            //picfound=true
        }*/
  



    }
    
    func applicationDidBecomeActive(_ notification : Notification)
    {print("app active chat details view")
        //print("didbecomeactivenotification=========")
        //  NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("applicationWillResignActive:"), name:UIApplicationWillResignActiveNotification, object: nil)
        
        //
        //   NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("applicationDidBecomeActive:"), name:UIApplicationDidBecomeActiveNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(GroupChatingDetailController.keyboardWillShow(_:)), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        
        UIDelegates.getInstance().delegateGroupChatDetails1=self
        //// NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("willHideKeyBoard:"), name:UIKeyboardWillHideNotification, object: nil)
    }
    func applicationWillResignActive(_ notification : Notification){
        /////////self.view.endEditing(true)
        //print("applicationWillResignActive=========")
        NotificationCenter.default.removeObserver(self, name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        
    }
    

    func getDateString(_ datetime:Date)->String
    {
        let formatter2 = DateFormatter();
        formatter2.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        formatter2.timeZone = TimeZone.autoupdatingCurrent
        let defaultTimeeee = formatter2.string(from: datetime)
        return defaultTimeeee
    }
    
    
    func retrieveChatFromSqlite(_ completion:(_ result:Bool)->())
    {
        //print("retrieveChatFromSqlite called---------")
        ///^^messages.removeAllObjects()
        var messages2=NSMutableArray()
        
        let from = Expression<String>("from")
        let group_unique_id = Expression<String>("group_unique_id")
        let type = Expression<String>("type")
        let msg = Expression<String>("msg")
        let from_fullname = Expression<String>("from_fullname")
        let date = Expression<Date>("date")
        let unique_id = Expression<String>("unique_id")
        
        var tbl_userchats=sqliteDB.group_chat
        var res=tbl_userchats?.filter(group_unique_id==groupid1)
        //to==selecteduser || from==selecteduser
        //print("chat from sqlite is")
        //print(res)
        do
        {
            
            //for tblContacts in try sqliteDB.db.prepare(tbl_userchats.filter(owneruser==owneruser1)){
            ////print("queryy runned count is \(tbl_contactslists.count)")
            for tblUserChats in try sqliteDB.db.prepare((tbl_userchats?.filter(group_unique_id==groupid1).order(date.asc))!){
                
                print("data of group table chat got is \(tblUserChats)")
                //print("===fetch date from database is tblContacts[date] \(tblContacts[date])")
                /*
                 var formatter = NSDateFormatter();
                 formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS";
                 //formatter.dateFormat = "MM/dd hh:mm a"";
                 formatter.timeZone = NSTimeZone(name: "UTC")
                 */
                // formatter.timeZone = NSTimeZone.localTimeZone()
                // var defaultTimeZoneStr = formatter.dateFromString(tblContacts[date])
                // var defaultTimeZoneStr2 = formatter.stringFromDate(defaultTimeZoneStr!)
                
                
                var formatter2 = DateFormatter();
                formatter2.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
                formatter2.timeZone = NSTimeZone.local
                var defaultTimeeee = formatter2.string(from: tblUserChats[date])
                
                var fullname=""
                if((sqliteDB.getNameFromAddressbook(tblUserChats[from])) != nil)
                {
                    fullname=sqliteDB.getNameFromAddressbook(tblUserChats[from])
                }
                else
                {
                    if((sqliteDB.getNameGroupMemberNameFromMembersTable(tblUserChats[from])) != nil)
                    {
                        fullname=sqliteDB.getNameGroupMemberNameFromMembersTable(tblUserChats[from])
                    }
                    else
                    {
                        fullname=tblUserChats[from]
                    }
                }
                
                //print("===fetch date from database is tblContacts[date] ... date converted is \(defaultTimeZoneStr)... string is \(defaultTimeZoneStr2)... defaultTimeeee \(defaultTimeeee)")
                
                /*//print(tblContacts[to])
                 //print(tblContacts[from])
                 //print(tblContacts[msg])
                 //print(tblContacts[date])
                 //print(tblContacts[status])
                 //print("--------")
                 */
                
                
                
                
                //uncomment later
                if(tblUserChats[from] != username!)
                    
                    //&& (sqliteDB.getGroupsChatStatusSingle(tblUserChats[unique_id], user_phone1: username!)=="delivered"))
                {
                    var singleStatus=sqliteDB.getGroupsChatStatusSingle(tblUserChats[unique_id], user_phone1: username!)
                   
                    if(singleStatus == "delivered")
                    {print("yes it is delivered")
                     self.sendGroupChatStatus(tblUserChats[unique_id],status1: "seen")
                    }

                  /*  for(var i=0;i<membersList.count;i++)
                    {
                        /*
                         let member_phone = Expression<String>("member_phone")
                         let isAdmin = Expression<String>("isAdmin")
                         let membership_status
                         */
                        
                        if((membersList[i]["member_phone"] as! String) != username! && (membersList[i]["membership_status"] as! String) != "left")
                        {
                            //unique_id
                           var singleStatusObject=sqliteDB.getGroupsChatStatusSingle(tblUserChats[unique_id], user_phone1: membersList[i]["member_phone"] as! String)
                            if(singleStatusObject["Status"] == "delivered")
                            {
                                sqliteDB.updateGroupChatStatus(tblContacts[uniqueid],status: "seen",sender: tblContacts[from], delivereddate1: NSDate(), readDate1:NSDate())
                                self.sendGroupChatStatus(tblContacts[uniqueid],"seen")
                                
                            }
                        }
                        
                    }
                    
                    */
                    //sqliteDB.updateGroupChatStatus(tblUserChats[unique_id], memberphone1: username!, status1: "seen")
                    
                    //==done sqliteDB.UpdateChatStatus(tblContacts[uniqueid], newstatus: "seen")
                    
                    
                    //== do later saving temprarily === sqliteDB.saveMessageStatusSeen("seen", sender1: tblContacts[from], uniqueid1: tblContacts[uniqueid])
                    
                    //===sendChatStatusUpdateMessage(tblContacts[uniqueid],status: "seen",sender: tblContacts[from])
                    
                    //OLD SOCKET LOGIC OF SENDING CHAT STATUS
                    /*  socketObj.socket.emitWithAck("messageStatusUpdate", ["status":"seen","uniqueid":tblContacts[uniqueid],"sender": tblContacts[from]])(timeoutAfter: 15000){data in
                     var chatmsg=JSON(data)
                     
                     //print(data[0])
                     //print(data[0]["uniqueid"]!!)
                     //print(data[0]["uniqueid"]!!.debugDescription!)
                     //print(chatmsg[0]["uniqueid"].string!)
                     ////print(data[0]["status"]!!.string!+" ... "+data[0]["uniqueid"]!!.string!)
                     //print("chat status seen emitted")
                     sqliteDB.removeMessageStatusSeen(data[0]["uniqueid"]!!.debugDescription!)
                     socketObj.socket.emit("logClient","\(username) chat status emitted")
                     
                     }
                     */
                }
 
 
                if(tblUserChats[type].lowercased()=="log")//check left
                {
                    
                    
                    var memStatus=sqliteDB.getMemberShipStatus(self.groupid1, memberphone: username!)
                   if(memStatus == "left")
                   {
                    self.txtFieldMessage.text="You left the group"
                    self.chatComposeView.isUserInteractionEnabled=false
                    }
                }
                
                if (tblUserChats[from]==username!)
                {
                    var status="pending"
                    
                    var allseen=sqliteDB.checkGroupMessageisAllSeen(tblUserChats[unique_id], members_phones1: membersList)
                    if(allseen==true)
                    {
                        status="seen"
                    }
                    else
                    {
                        var alldelivered=sqliteDB.checkGroupMessageisAllDelevered(tblUserChats[unique_id], members_phones1: membersList)
                        if(alldelivered==true)
                        {
                            status="delivered"
                        }
                        else{
                            var allsent=sqliteDB.checkGroupMessageisAnySent(tblUserChats[unique_id], members_phones1: membersList)
                            if(allsent==true)
                            {
                                status="sent"
                            }
                        }
                    }
                            messages2.add(["msg":tblUserChats[msg]+" (\(status))", "type":"2", "fromFullName":fullname,"date":defaultTimeeee, "uniqueid":tblUserChats[unique_id]])
                }
                else
                {
                        
                    messages2.add(["msg":tblUserChats[msg], "type":"1", "fromFullName":fullname,"date":defaultTimeeee, "uniqueid":tblUserChats[unique_id]])
             
                }
                
                
            }
            ////////// self.messages.removeAllObjects()
            messages.setArray(messages2 as [AnyObject])
            ////////////self.messages.addObjectsFromArray(messages2 as [AnyObject])
            
            
            completion(true)
            /*
             self.tblForChats.reloadData()
             
             if(self.messages.count>1)
             {
             var indexPath = NSIndexPath(forRow:self.messages.count-1, inSection: 0)
             
             self.tblForChats.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Bottom, animated: true)
             }*/
            
        }
        catch(let error)
        {
            //print(error)
        }
        /////var tbl_userchats=sqliteDB.db["userschats"]
        
    }
    
    
    func addMessage(_ message: String, ofType msgType:String, date:String, uniqueid:String)
    {
        messages.add(["message":message, "type":msgType, "date":date, "uniqueid":uniqueid])
    }
    
    //uncomment later
    /*func textFieldShouldReturn (textField: UITextField!) -> Bool{
        txtFieldMessage.resignFirstResponder()
        return true
    
    }*/
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAtIndexPath indexPath: IndexPath) -> CGFloat {
        
        ////======return 60
        
        var messageDic = messages.object(at: indexPath.row) as! [String : String];
        
        let msg = messageDic["msg"] as NSString!
        let msgType = messageDic["type"]! as NSString
        if(msgType.isEqual(to: "3")||msgType.isEqual(to: "4"))
        {
            let cell = tblForGroupChat.dequeueReusableCell(withIdentifier: "FileImageReceivedCell")! as UITableViewCell
            let chatImage = cell.viewWithTag(1) as! UIImageView
            
            
            if(chatImage.frame.height <= 230)
            {
                return chatImage.frame.height+20
            }
            else
            {
                return 200
            }
            
            
        }
        else
        {
            let sizeOFStr = self.getSizeOfString(msg!)
            
            return sizeOFStr.height + 70
        }
    }
    
    func numberOfSectionsInTableView(_ tableView: UITableView) -> Int {
        
        return 1
    }
    
    
   /* func chatSwipped(sender:UISwipeGestureRecognizer)
    {
        let gesture:UISwipeGestureRecognizer = sender as! UISwipeGestureRecognizer
        if(gesture.direction == .Left)
        {
            
            var location = gesture.locationInView(tblForGroupChat)
            print("swipe location is \(location)")
            var swipedIndexPath = tblForGroupChat.indexPathForRowAtPoint(location)
            swipedRow=swipedIndexPath!.row
            print("swiped row is \(swipedRow)")
           var swipedCell  = tblForGroupChat.cellForRowAtIndexPath(swipedIndexPath!)

            
            
           // swipeGesture.i
            self.performSegueWithIdentifier("groupMessageInfoSegue", sender: nil)
            /*var frame:CGRect = self.mainView.frame;
            frame.origin.x = -self.leftButton.frame.width;
            self.mainView.frame = frame;*/
        }
       
        
    }*/
    
     func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        
      
        
        var messageDic = messages.object(at: indexPath.row) as! [String : String];
       // NSLog(messageDic["message"]!, 1)
        let msgType = messageDic["type"] as NSString!
        let msg = messageDic["msg"] as NSString!
        let date2=messageDic["date"] as NSString!
        let fullname=messageDic["fromFullName"] as NSString!
        let sizeOFStr = self.getSizeOfString(msg!)
        let uniqueidDictValue=messageDic["uniqueid"] as NSString!
        
        
        if(msgType?.isEqual("2"))!
        {
            print("my msg \(msg)")
            //i am sender
            let cell = tblForGroupChat.dequeueReusableCell(withIdentifier: "ChatReceivedCell")! as UITableViewCell
            let msgLabel = cell.viewWithTag(12) as! UILabel
            let chatImage = cell.viewWithTag(1) as! UIImageView
            let timeLabel = cell.viewWithTag(11) as! UILabel
            
            
            
            
            
            let distanceFactor = (197.0 - sizeOFStr.width) < 107 ? (197.0 - sizeOFStr.width) : 107
            //// //print("distanceFactor for \(msg) is \(distanceFactor)")
            
            chatImage.frame = CGRect(x: 20 + distanceFactor, y: chatImage.frame.origin.y, width: ((sizeOFStr.width + 107)  > 207 ? (sizeOFStr.width + 107) : 200), height: sizeOFStr.height + 40)
            ////    //print("chatImage.x for \(msg) is \(20 + distanceFactor) and chatimage.wdith is \(chatImage.frame.width)")
            
            
            msgLabel.isHidden=false
            //chatImage.frame = CGRectMake(20 + distanceFactor, chatImage.frame.origin.y, ((sizeOFStr.width + 100)  > 200 ? (sizeOFStr.width + 100) : 200), sizeOFStr.height + 40)
            chatImage.image = UIImage(named: "chat_send")?.stretchableImage(withLeftCapWidth: 40,topCapHeight: 20);
            //*********
            
            msgLabel.frame = CGRect(x: 36 + distanceFactor, y: msgLabel.frame.origin.y, width: msgLabel.frame.size.width, height: sizeOFStr.height)
            
            // //print("date received in chat is \(date2.debugDescription)")
            let formatter = DateFormatter();
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS";
            //formatter.dateFormat = "MM/dd hh:mm a"";
            formatter.timeZone = TimeZone.autoupdatingCurrent
            let defaultTimeZoneStr = formatter.date(from: date2.debugDescription)
            //print("defaultTimeZoneStr \(defaultTimeZoneStr)")
            timeLabel.frame = CGRect(x: 36 + distanceFactor, y: msgLabel.frame.origin.y+msgLabel.frame.height+10, width: chatImage.frame.size.width-46, height: timeLabel.frame.size.height)
            
            if(defaultTimeZoneStr == nil)
            {
                timeLabel.text=date2.debugDescription
                
            }
            else
            {
                let formatter2 = DateFormatter();
                formatter2.timeZone=TimeZone.autoupdatingCurrent
                formatter2.dateFormat = "MM/dd hh:mm a";
                let displaydate=formatter2.string(from: defaultTimeZoneStr!)
                //formatter.dateFormat = "MM/dd hh:mm a"";
                
                
                
               //== uncomment later timeLabel.frame = CGRectMake(36 + distanceFactor, timeLabel.frame.origin.y, timeLabel.frame.size.width, timeLabel.frame.size.height)
                
                timeLabel.text=displaydate

            }
            
            msgLabel.text=msg as! String
            return cell
        
        }
            
        //if(msgType.isEqual("1"))
        
        else{

            print("got sender msg \(msg)")
            let cell = tblForGroupChat.dequeueReusableCell(withIdentifier: "ChatSentCell")! as UITableViewCell
            
          
            
            let msgLabel = cell.viewWithTag(12) as! UILabel
            
            let chatImage = cell.viewWithTag(1) as! UIImageView
            let nameLabel = cell.viewWithTag(15) as! UILabel
           
            let timeLabel = cell.viewWithTag(11) as! UILabel
            
            chatImage.frame = CGRect(x: chatImage.frame.origin.x, y: chatImage.frame.origin.y, width: ((sizeOFStr.width + 100)  > 200 ? (sizeOFStr.width + 100) : 200), height: sizeOFStr.height + 60)
            chatImage.image = UIImage(named: "chat_receive")?.stretchableImage(withLeftCapWidth: 40,topCapHeight: 20);
            //******
            
            
            msgLabel.frame = CGRect(x: msgLabel.frame.origin.x, y: msgLabel.frame.origin.y, width: msgLabel.frame.size.width, height: sizeOFStr.height)
            
            
            
            let formatter = DateFormatter();
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS";
            //formatter.dateFormat = "MM/dd hh:mm a"";
            formatter.timeZone = TimeZone.autoupdatingCurrent
            let defaultTimeZoneStr = formatter.date(from: date2.debugDescription)
            //print("defaultTimeZoneStr \(defaultTimeZoneStr)")
            
            let formatter2 = DateFormatter();
            formatter2.timeZone=TimeZone.autoupdatingCurrent
            formatter2.dateFormat = "MM/dd hh:mm a";
            let displaydate=formatter2.string(from: defaultTimeZoneStr!)
            timeLabel.frame = CGRect(x: msgLabel.frame.origin.x, y: msgLabel.frame.origin.y+msgLabel.frame.height+5, width: chatImage.frame.size.width-46, height: timeLabel.frame.size.height)
            
            timeLabel.text = displaydate
            nameLabel.textColor=UIColor.blue
            nameLabel.text=fullname as! String
            msgLabel.text=msg as! String
            
            return cell


        }
  
        
    }
    
    func textFieldShouldReturn (_ textField: UITextField!) -> Bool{
        textField.resignFirstResponder()
        let duration : TimeInterval = 0
        let keyboardFrame = keyFrame
        
        
        if(cellY>((keyboardFrame?.origin.y)!-20))
        {
            UIView.animate(withDuration: duration, delay: 0, options:[], animations: {
                self.viewForContent.contentOffset = CGPoint(x: 0, y: 0)
                
                }, completion:{ (true)-> Void in
                    self.showKeyboard=false
            })
        }else{
            UIView.animate(withDuration: duration, delay: 0, options:[], animations: {
                let newY=self.chatComposeView.frame.origin.y+(keyboardFrame?.size.height)!
                self.chatComposeView.frame=CGRect(x: self.chatComposeView.frame.origin.x,y: newY,width: self.chatComposeView.frame.width,height: self.chatComposeView.frame.height)
                
                //== self.viewForContent.contentOffset = CGPointMake(0, keyboardFrame.size.height)
                
                },completion:{ (true)-> Void in
                    self.showKeyboard=false
            })
        }
        //  var userInfo: NSDictionary!
        // userInfo = notification.userInfo
        
        /*
         var duration : NSTimeInterval = 0
         
         
         
         
         /*var userInfo: NSDictionary!
         userInfo = notification.userInfo
         
         var duration : NSTimeInterval = 0
         var curve = userInfo.objectForKey(UIKeyboardAnimationCurveUserInfoKey) as! UInt
         duration = userInfo[UIKeyboardAnimationDurationUserInfoKey]as! NSTimeInterval
         let keyboardF:NSValue = userInfo.objectForKey(UIKeyboardFrameEndUserInfoKey) as! NSValue
         var keyboardFrame = keyboardF.CGRectValue()
         
         UIView.animateWithDuration(duration, delay: 0, options:[], animations: {
         self.viewForContent.contentOffset = CGPointMake(0, 0)
         
         }, completion: nil)
         
         */
         
         UIView.animateWithDuration(duration, delay: 0, options:[], animations: {
         self.chatComposeView.frame = CGRectMake(self.chatComposeView.frame.origin.x, self.chatComposeView.frame.origin.y + self.keyheight-self.chatComposeView.frame.size.height-3, self.chatComposeView.frame.size.width, self.chatComposeView.frame.size.height)
         self.tblForChats.frame = CGRectMake(self.tblForChats.frame.origin.x, self.tblForChats.frame.origin.y, self.tblForChats.frame.size.width, self.tblForChats.frame.size.height + self.keyFrame.size.height-49);
         }, completion: nil)
         showKeyboard=false
         */
        
        
        
        //uncomment later if needed
        /*
         var duration : NSTimeInterval = 0
         
         UIView.animateWithDuration(duration, delay: 0, options:[], animations: {
         self.viewForContent.contentOffset = CGPointMake(0, 0)
         
         }, completion:{ (true)-> Void in
         self.showKeyboard=false
         })
         */
        return true
        
        
    }
    
    func keyboardWillShow(_ notification: Notification) {
        
        
        //uncomment moved down
        
        /*
            var lastind=NSIndexPath.init(index: self.messages.count)
            let rectOfCellInTableView = tblForGroupChat.rectForRowAtIndexPath(lastind)
            let rectOfCellInSuperview = tblForGroupChat.convertRect(rectOfCellInTableView, toView: nil)
            print("last cell pos y is \(tblForGroupChat.visibleCells.last?.frame.origin.y)")
            
            print("Y of Cell is: \(rectOfCellInSuperview.origin.y%viewForContent.frame.height)")
            print("content offset is \(tblForGroupChat.contentOffset.y)")
            
            cellY=(tblForGroupChat.visibleCells.last?.frame.origin.y)!+(tblForGroupChat.visibleCells.last?.frame.height)!
            print("cellY is \(cellY)")*/
            
            /*let info = notification.userInfo as! [String: AnyObject],
             kbSize = (info[UIKeyboardFrameBeginUserInfoKey] as! NSValue).CGRectValue().size,
             contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: kbSize.height, right: 0)
             
             self.tblForChats.contentInset = contentInsets
             self.tblForChats.scrollIndicatorInsets = contentInsets
             
             // If active text field is hidden by keyboard, scroll it so it's visible
             // Your app might not need or want this behavior.
             var aRect = self.view.frame
             aRect.size.height -= kbSize.height
             
             if !CGRectContainsPoint(aRect, chatComposeView!.frame.origin) {
             self.tblForChats.scrollRectToVisible(chatComposeView!.frame, animated: true)
             }
             */
            //print("showkeyboardNotification============")
            
        if(showKeyboard==false)
        {
            
            var userInfo: NSDictionary!
            userInfo = notification.userInfo as NSDictionary!
            
            var duration : TimeInterval = 0
            var curve = userInfo.object(forKey: UIKeyboardAnimationCurveUserInfoKey) as! UInt
            duration = userInfo[UIKeyboardAnimationDurationUserInfoKey]as! TimeInterval
            let keyboardF:NSValue = userInfo.object(forKey: UIKeyboardFrameEndUserInfoKey)as! NSValue
            let keyboardFrame = keyboardF.cgRectValue
            print("keyboard y is \(keyboardFrame.origin.y)")
            
            if(keyheight==nil)
            {
                keyheight=keyboardFrame.size.height
            }
            if(keyFrame==nil)
            {
                keyFrame=keyboardFrame
            }
            
            print("keyboard height is \(keyheight)")
            
            
            
            if(messages.count>0)
            {
                let lastind=IndexPath.init(index: self.messages.count)
                let rectOfCellInTableView = tblForGroupChat.rectForRow(at: lastind)
                let rectOfCellInSuperview = tblForGroupChat.convert(rectOfCellInTableView, to: nil)
                print("last cell pos y is \(tblForGroupChat.visibleCells.last?.frame.origin.y)")
                
                print("Y of Cell is: \(rectOfCellInSuperview.origin.y.truncatingRemainder(dividingBy: viewForContent.frame.height))")
                print("content offset is \(tblForGroupChat.contentOffset.y)")
                
                cellY=(tblForGroupChat.visibleCells.last?.frame.origin.y)!+(tblForGroupChat.visibleCells.last?.frame.height)!
                print("cellY is \(cellY)")
            }
                if(cellY>(keyboardFrame.origin.y-20))
                {
                    
                    UIView.animate(withDuration: duration, delay: 0, options:[], animations: {
                        self.viewForContent.contentOffset = CGPoint(x: 0, y: keyboardFrame.size.height)
                        
                        }, completion: nil)
                }else{
                    UIView.animate(withDuration: duration, delay: 0, options:[], animations: {
                        let newY=self.chatComposeView.frame.origin.y-keyboardFrame.size.height
                        self.chatComposeView.frame=CGRect(x: self.chatComposeView.frame.origin.x,y: newY,width: self.chatComposeView.frame.width,height: self.chatComposeView.frame.height)
                        
                        //== self.viewForContent.contentOffset = CGPointMake(0, keyboardFrame.size.height)
                        
                        }, completion: nil)
                    
                }
           
            /*var userInfo: NSDictionary!
                 userInfo = notification.userInfo
                 
                 var duration : NSTimeInterval = 0
                 var curve = userInfo.objectForKey(UIKeyboardAnimationCurveUserInfoKey) as! UInt
                 duration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSTimeInterval
                 let keyboardF:NSValue = userInfo.objectForKey(UIKeyboardFrameEndUserInfoKey) as! NSValue
                 let keyboardFrame = keyboardF.CGRectValue()
                 
                 if(keyheight==nil)
                 {
                 keyheight=keyboardFrame.size.height
                 }
                 if(keyFrame==nil)
                 {
                 keyFrame=keyboardFrame
                 }
                 
                 
                 UIView.animateWithDuration(duration, delay: 0, options:[], animations: {
                 self.chatComposeView.frame = CGRectMake(self.chatComposeView.frame.origin.x, self.chatComposeView.frame.origin.y - self.keyheight+self.chatComposeView.frame.size.height+3, self.chatComposeView.frame.size.width, self.chatComposeView.frame.size.height)
                 
                 self.tblForChats.frame = CGRectMake(self.tblForChats.frame.origin.x, self.tblForChats.frame.origin.y, self.tblForChats.frame.size.width, self.tblForChats.frame.size.height-self.keyFrame.size.height+49);
                 }, completion: nil)
                 */
                showKeyboard=true
                
            }
            
            tblForGroupChat.reloadData()
            if(messages.count>1)
            {
                let indexPath = IndexPath(row:messages.count-1, section: 0)
                tblForGroupChat.scrollToRow(at: indexPath, at: UITableViewScrollPosition.bottom, animated: true)
            }
        
        /*if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            self.viewForTableAndTextfield.frame.origin.y -= keyboardSize.height
            // self.view.frame.origin.y -= keyboardSize.height
        }
        */
    }
    //uncomment
   /* func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            self.viewForContent.frame.origin.y += keyboardSize.height
            //self.view.frame.origin.y += keyboardSize.height
        }
    }*/
    
    func getSizeOfString(_ postTitle: NSString) -> CGSize {
        
        
        // Get the height of the font
        let constraintSize = CGSize(width: 170, height: CGFloat.greatestFiniteMagnitude)
        
        //let constraintSize = CGSizeMake(220, CGFloat.max)
        
        
        
        /*let attributes = [NSFontAttributeName:UIFont.systemFontOfSize(11.0)]
         let labelSize = postTitle.boundingRectWithSize(constraintSize,
         options: NSStringDrawingOptions.UsesLineFragmentOrigin,
         attributes: attributes,
         context: nil)*/
        
        let labelSize = postTitle.boundingRect(with: constraintSize,
                                                       options: NSStringDrawingOptions.usesLineFragmentOrigin,
                                                       attributes:[NSFontAttributeName : UIFont.systemFont(ofSize: 11.0)],
                                                       context: nil)
        ////print("size is width \(labelSize.width) and height is \(labelSize.height)")
        return labelSize.size
    }
    
    func randomStringWithLength (_ len : Int) -> NSString {
        
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        
        let randomString : NSMutableString = NSMutableString(capacity: len)
        
        for i in 0 .. len{
            let length = UInt32 (letters.length)
            let rand = arc4random_uniform(length)
            randomString.appendFormat("%C", letters.character(at: Int(rand)))
        }
        
        return randomString
    }

    
    func sendGroupChatStatus(_ chat_uniqueid:String,status1:String)
    {
    
    var url=Constants.MainUrl+Constants.updateGroupChatStatusAPI
    
    
   //--- dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0))
    //{
    let request = Alamofire.request(.POST, "\(url)", parameters: ["chat_unique_id":chat_uniqueid,"status":status1],headers:header).responseJSON { response in
    
    
    /*let request = Alamofire.request(.POST, "\(url)", parameters: ["uniqueid":uniqueid,"sender":sender,"status":status],headers:header)
     request.response(
     queue: queue,
     responseSerializer: Request.JSONResponseSerializer(options: .AllowFragments),
     completionHandler: { response in
     
     */
    // You are now running on the concurrent `queue` you created earlier.
    //print("Parsing JSON on thread: \(NSThread.currentThread()) is main thread: \(NSThread.isMainThread())")
    
    // Validate your JSON response and convert into model objects if necessary
    //   //print(response.result.value!) //status, uniqueid
    
    
    // To update anything on the main thread, just jump back on like so.
    
    if(response.response?.statusCode==200)
    {
    var resJSON=JSON(response.result.value!)
    print("status seen sent response \(resJSON)")
        //update locally
        //moving it out of function. if seen offline so remove chat bubble unread count
        sqliteDB.updateGroupChatStatus(chat_uniqueid, memberphone1: username!, status1: status1, delivereddate1: NSDate(), readDate1: NSDate())
    }
    }
  //===  }
}

    func generateUniqueid()->String
    {
    
        let uid=randomStringWithLength(7)
    
        let date=Date()
        let calendar = Calendar.current
        let year=(calendar as NSCalendar).components(NSCalendar.Unit.year,from: date).year
        let month=(calendar as NSCalendar).components(NSCalendar.Unit.month,from: date).month
        let day=(calendar as NSCalendar).components(.day,from: date).day
        let hr=(calendar as NSCalendar).components(NSCalendar.Unit.hour,from: date).hour
        let min=(calendar as NSCalendar).components(NSCalendar.Unit.minute,from: date).minute
        let sec=(calendar as NSCalendar).components(NSCalendar.Unit.second,from: date).second
        print("\(year) \(month) \(day) \(hr) \(min) \(sec)")
        let uniqueid="\(uid)\(year)\(month)\(day)\(hr)\(min)\(sec)"
        
        return uniqueid
        

    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        //groupMessageInfoSegue
        
        if segue.identifier == "groupMessageInfoSegue" {
            
            if let destinationVC = segue.destination as? GroupMessageStatusViewController{
                
                var messageDic = messages.object(at: swipedRow) as! [String : String];
                
                let uniqueid = messageDic["uniqueid"] as NSString!
                
                destinationVC.message_unique_id=uniqueid as! String
            }
        }
    }
    
    func refreshGroupChatDetailUI(_ message: String, data: AnyObject!) {
        
        self.retrieveChatFromSqlite { (result) in
            
            
            //dispatch_async(dispatch_get_main_queue())
           // {
            self.tblForGroupChat.reloadData()
            
            if(self.messages.count>1)
            {
                let indexPath = IndexPath(row:self.messages.count-1, section: 0)
                
                self.tblForGroupChat.scrollToRow(at: indexPath, at: UITableViewScrollPosition.bottom, animated: true)
            }
           // }
        }
    }
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        
        UIDelegates.getInstance().delegateGroupChatDetails1=nil
    }

}
