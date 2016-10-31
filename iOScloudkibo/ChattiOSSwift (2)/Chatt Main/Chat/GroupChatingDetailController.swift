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

class GroupChatingDetailController: UIViewController {
    
    var mytitle=""
    var groupid1=""
    var messages:NSMutableArray!
    @IBOutlet var tblForGroupChat: UITableView!
    
    @IBOutlet weak var txtFieldMessage: UITextField!
   
    @IBOutlet weak var chatComposeView: UIView!
    
    func setTitle(title:String, subtitle:String) -> UIView {
        //Create a label programmatically and give it its property's
        let titleLabel = UILabel(frame: CGRectMake(0, 0, 0, 0)) //x, y, width, height where y is to offset from the view center
        titleLabel.backgroundColor = UIColor.clearColor()
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.font = UIFont.boldSystemFontOfSize(17)
        titleLabel.text = title
        titleLabel.sizeToFit()
        
        //Create a label for the Subtitle
        let subtitleLabel = UILabel(frame: CGRectMake(0, 18, 0, 0))
        subtitleLabel.backgroundColor = UIColor.clearColor()
        //subtitleLabel.textColor = UIColor.lightGrayColor()
        subtitleLabel.textColor = UIColor.blackColor()
        
        subtitleLabel.font = UIFont.systemFontOfSize(12)
        subtitleLabel.text = subtitle
        subtitleLabel.sizeToFit()
        
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
        
        return titleView
    }

    @IBAction func btnSendTapped(sender: AnyObject){
        
        var uniqueid_chat=generateUniqueid()
        var date=getDateString(NSDate())
        messages.addObject(["msg":txtFieldMessage.text!, "type":"2", "fromFullName":"","date":date,"uniqueid":uniqueid_chat])
        
        
        //save chat
        sqliteDB.storeGroupsChat(username!, group_unique_id1: groupid1, type1: "chat", msg1: txtFieldMessage.text!, from_fullname1: username!, date1: NSDate(), unique_id1: uniqueid_chat)
        
        var chatmsg=txtFieldMessage.text!
        txtFieldMessage.text = "";
        tblForGroupChat.reloadData()
        if(messages.count>1)
        {
            var indexPath = NSIndexPath(forRow:messages.count-1, inSection: 0)
            tblForGroupChat.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Bottom, animated: true)
            
        }
        
        /////// dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED,0))
        ////// {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0))
        {
            print("messages count before sending msg is \(self.messages.count)")
            self.sendChatMessage(self.groupid1, from: username!, type: "chat", msg: chatmsg, fromFullname: username!, uniqueidChat: uniqueid_chat, completion: { (result) in
                
                print("chat sent")
            })
        }
        
    
    }
    
    func sendChatMessage(group_id:String,from:String,type:String,msg:String,fromFullname:String,uniqueidChat:String,completion:(result:Bool)->())
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
    

    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.title=mytitle
        self.retrieveChatFromSqlite { (result) in
            
            
                self.tblForGroupChat.reloadData()
            
            if(self.messages.count>1)
            {
                var indexPath = NSIndexPath(forRow:self.messages.count-1, inSection: 0)
                
                self.tblForGroupChat.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Bottom, animated: true)
            }
        }
        
    }
    
    override func viewDidLoad() {
          self.navigationItem.titleView = setTitle(mytitle, subtitle: "Sumaira,xyz,abc")
        messages=NSMutableArray()
        
    }
    
    func getDateString(datetime:NSDate)->String
    {
        var formatter2 = NSDateFormatter();
        formatter2.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        formatter2.timeZone = NSTimeZone.localTimeZone()
        var defaultTimeeee = formatter2.stringFromDate(datetime)
        return defaultTimeeee
    }
    
    
    func retrieveChatFromSqlite(completion:(result:Bool)->())
    {
        //print("retrieveChatFromSqlite called---------")
        ///^^messages.removeAllObjects()
        var messages2=NSMutableArray()
        
        let from = Expression<String>("from")
        let group_unique_id = Expression<String>("group_unique_id")
        let type = Expression<String>("type")
        let msg = Expression<String>("msg")
        let from_fullname = Expression<String>("from_fullname")
        let date = Expression<NSDate>("date")
        let unique_id = Expression<String>("unique_id")
        
        var tbl_userchats=sqliteDB.group_chat
        var res=tbl_userchats.filter(group_unique_id==groupid1)
        //to==selecteduser || from==selecteduser
        //print("chat from sqlite is")
        //print(res)
        do
        {
            
            //for tblContacts in try sqliteDB.db.prepare(tbl_userchats.filter(owneruser==owneruser1)){
            ////print("queryy runned count is \(tbl_contactslists.count)")
            for tblContacts in try sqliteDB.db.prepare(tbl_userchats.filter(group_unique_id==groupid1).order(date.asc)){
                
                print("data of group table chat got is \(tblContacts)")
                //print("===fetch date from database is tblContacts[date] \(tblContacts[date])")
                /*
                 var formatter = NSDateFormatter();
                 formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS";
                 //formatter.dateFormat = "MM/dd, HH:mm";
                 formatter.timeZone = NSTimeZone(name: "UTC")
                 */
                // formatter.timeZone = NSTimeZone.localTimeZone()
                // var defaultTimeZoneStr = formatter.dateFromString(tblContacts[date])
                // var defaultTimeZoneStr2 = formatter.stringFromDate(defaultTimeZoneStr!)
                
                
                var formatter2 = NSDateFormatter();
                formatter2.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
                formatter2.timeZone = NSTimeZone.localTimeZone()
                var defaultTimeeee = formatter2.stringFromDate(tblContacts[date])
                
                //print("===fetch date from database is tblContacts[date] ... date converted is \(defaultTimeZoneStr)... string is \(defaultTimeZoneStr2)... defaultTimeeee \(defaultTimeeee)")
                
                /*//print(tblContacts[to])
                 //print(tblContacts[from])
                 //print(tblContacts[msg])
                 //print(tblContacts[date])
                 //print(tblContacts[status])
                 //print("--------")
                 */
                
                
                
                
                //uncomment later
               /* if(tblContacts[from]==selecteduser && (tblContacts[status]=="delivered"))
                {
                    sqliteDB.UpdateChatStatus(tblContacts[uniqueid], newstatus: "seen")
                    
                    sqliteDB.saveMessageStatusSeen("seen", sender1: tblContacts[from], uniqueid1: tblContacts[uniqueid])
                    
                    sendChatStatusUpdateMessage(tblContacts[uniqueid],status: "seen",sender: tblContacts[from])
                    
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
                */
                
                if(tblContacts[type]=="log_leftGroup")
                {
                    self.txtFieldMessage.text="You left the group"
                    self.chatComposeView.userInteractionEnabled=false
                }
                
                if (tblContacts[from]==username!)
                    
                {//type1
                    /////print("statussss is \(tblContacts[status])")
                   /* if(tblContacts[file_type]=="image")
                    {
                        
                        //  self.addUploadInfo(selectedContact, uniqueid1: tblContacts[uniqueid], rowindex: messages.count, uploadProgress: 1, isCompleted: true)
                        
                        messages2.addObject(["message":tblContacts[msg], "type":"4", "date":defaultTimeeee, "uniqueid":tblContacts[uniqueid]])
                        
                        
                        //messages2.addObject(["message":tblContacts[msg], "type":"4", "date":tblContacts[date], "uniqueid":tblContacts[uniqueid]])
                        
                        //^^^ self.addMessage(tblContacts[msg], ofType: "4",date: tblContacts[date],uniqueid: tblContacts[uniqueid])
                        
                    }
                    else{
                        if(tblContacts[file_type]=="document")
                        {
                            
                            ////  self.addUploadInfo(selectedContact, uniqueid1: tblContacts[uniqueid], rowindex: messages.count, uploadProgress: 1, isCompleted: true)
                            
                            messages2.addObject(["message":tblContacts[msg], "type":"6", "date":defaultTimeeee, "uniqueid":tblContacts[uniqueid]])
                            
                            //^^^^ self.addMessage(tblContacts[msg], ofType: "6",date: tblContacts[date],uniqueid: tblContacts[uniqueid])
                            
                        }
                        else
                        {*/
                            messages2.addObject(["msg":tblContacts[msg], "type":"2", "fromFullName":tblContacts[from_fullname],"date":defaultTimeeee, "uniqueid":tblContacts[unique_id]])
                            
                            
                            //^^^^self.addMessage(tblContacts[msg]+" (\(tblContacts[status])) ", ofType: "2",date: tblContacts[date],uniqueid: tblContacts[uniqueid])
                       // }
                    //}
                }
                else
                {//type2
                    //// //print("statussss is \(tblContacts[status])")
                    /*if(tblContacts[file_type]=="image")
                    {
                        //  self.addUploadInfo(selectedContact, uniqueid1: tblContacts[uniqueid], rowindex: messages.count, uploadProgress: 1, isCompleted: true)
                        messages2.addObject(["message":tblContacts[msg], "type":"3", "date":defaultTimeeee, "uniqueid":tblContacts[uniqueid]])
                        
                        
                        //^^^^  self.addMessage(tblContacts[msg] , ofType: "3",date: tblContacts[date],uniqueid: tblContacts[uniqueid])
                        
                    }
                    else
                    {if(tblContacts[file_type]=="document")
                    {
                        // self.addUploadInfo(selectedContact, uniqueid1: tblContacts[uniqueid], rowindex: messages.count, uploadProgress: 1, isCompleted: true)
                        messages2.addObject(["message":tblContacts[msg], "type":"5", "date":defaultTimeeee, "uniqueid":tblContacts[uniqueid]])
                        
                        
                        //^^^^ self.addMessage(tblContacts[msg], ofType: "5",date: tblContacts[date],uniqueid: tblContacts[uniqueid])
                        
                    }
                    else
                    {*/
                        
                    messages2.addObject(["msg":tblContacts[msg], "type":"1", "fromFullName":tblContacts[from_fullname],"date":defaultTimeeee, "uniqueid":tblContacts[unique_id]])
                    
                    
                    
                        
                        ///^^^ self.addMessage(tblContacts[msg], ofType: "1", date: tblContacts[date],uniqueid: tblContacts[uniqueid])
                      //  }
                    //}
                    
                }
                /* if(self.messages.count>1)
                 {
                 var indexPath = NSIndexPath(forRow:self.messages.count-1, inSection: 0)
                 
                 self.tblForChats.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Bottom, animated: false)
                 }*/
                
                //self.tblForChats.reloadData()
                
            }
            ////////// self.messages.removeAllObjects()
            messages.setArray(messages2 as [AnyObject])
            ////////////self.messages.addObjectsFromArray(messages2 as [AnyObject])
            
            
            completion(result:true)
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
    
    
    func addMessage(message: String, ofType msgType:String, date:String, uniqueid:String) {
        messages.addObject(["message":message, "type":msgType, "date":date, "uniqueid":uniqueid])
    }
    
    
    func textFieldShouldReturn (textField: UITextField!) -> Bool{
        txtFieldMessage.resignFirstResponder()
        return true
    
    }
     func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
     func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 60
    }
     func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    
     func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var messageDic = messages.objectAtIndex(indexPath.row) as! [String : String];
       // NSLog(messageDic["message"]!, 1)
        let msgType = messageDic["type"] as NSString!
        let msg = messageDic["msg"] as NSString!
        let date2=messageDic["date"] as NSString!
        let fullname=messageDic["fromFullName"] as NSString!
        //let sizeOFStr = self.getSizeOfString(msg)
        let uniqueidDictValue=messageDic["uniqueid"] as NSString!
        
        
        if(msgType.isEqual("2"))
        {
            print("my msg \(msg)")
            //i am sender
            var cell = tblForGroupChat.dequeueReusableCellWithIdentifier("ChatReceivedCell")! as UITableViewCell
            let msgLabel = cell.viewWithTag(12) as! UILabel
            msgLabel.text=msg as! String
            return cell
        
        }
        //if(msgType.isEqual("1"))
        
        else{

            print("got sender msg \(msg)")
            var cell = tblForGroupChat.dequeueReusableCellWithIdentifier("ChatSentCell")! as UITableViewCell
            let nameLabel = cell.viewWithTag(15) as! UILabel
            nameLabel.textColor=UIColor.blueColor()
            nameLabel.text=fullname as! String
            let msgLabel = cell.viewWithTag(12) as! UILabel
            msgLabel.text=msg as! String
            
            return cell


        }
       /* if(indexPath.row==2)
        {
            var cell = tblForGroupChat.dequeueReusableCellWithIdentifier("ChatSentCell")! as UITableViewCell
            let nameLabel = cell.viewWithTag(15) as! UILabel
            nameLabel.textColor=UIColor.blueColor()
            nameLabel.text="Sumaira"
            let msgLabel = cell.viewWithTag(12) as! UILabel
            msgLabel.text="Wsalaam. I am fine"
            
            return cell
        }
       /* if(indexPath.row==3)
        {
            var cell = tblForGroupChat.dequeueReusableCellWithIdentifier("ChatReceivedCell")! as UITableViewCell
            
            return cell
        }*/
        if(indexPath.row==3)
        {
            var cell = tblForGroupChat.dequeueReusableCellWithIdentifier("ChatSentCell")! as UITableViewCell
            let nameLabel = cell.viewWithTag(15) as! UILabel
            nameLabel.text="Sojharo"
            let msgLabel = cell.viewWithTag(12) as! UILabel
            msgLabel.text="Done with tasks?"
            return cell
        }
        else{
            var cell = tblForGroupChat.dequeueReusableCellWithIdentifier("ChatReceivedCell")! as UITableViewCell
            let msgLabel = cell.viewWithTag(12) as! UILabel
            msgLabel.text="Yes. I am done"
            return cell
        }*/
        
    }
    
    func randomStringWithLength (len : Int) -> NSString {
        
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        
        let randomString : NSMutableString = NSMutableString(capacity: len)
        
        for (var i=0; i < len; i++){
            let length = UInt32 (letters.length)
            let rand = arc4random_uniform(length)
            randomString.appendFormat("%C", letters.characterAtIndex(Int(rand)))
        }
        
        return randomString
    }

    
    func generateUniqueid()->String
    {
        
        var uid=randomStringWithLength(7)
        
        var date=NSDate()
        var calendar = NSCalendar.currentCalendar()
        var year=calendar.components(NSCalendarUnit.Year,fromDate: date).year
        var month=calendar.components(NSCalendarUnit.Month,fromDate: date).month
        var day=calendar.components(.Day,fromDate: date).day
        var hr=calendar.components(NSCalendarUnit.Hour,fromDate: date).hour
        var min=calendar.components(NSCalendarUnit.Minute,fromDate: date).minute
        var sec=calendar.components(NSCalendarUnit.Second,fromDate: date).second
        print("\(year) \(month) \(day) \(hr) \(min) \(sec)")
        var uniqueid="\(uid)\(year)\(month)\(day)\(hr)\(min)\(sec)"
        
        return uniqueid
        

    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        
    }

}
