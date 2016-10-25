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
    
    
    
    var messages:NSMutableArray!
    @IBOutlet var tblForGroupChat: UITableView!
    
    @IBOutlet weak var txtFieldMessage: UITextField!
   

    @IBAction func btnSendTapped(sender: AnyObject){
        
    
    }
    
    override func viewDidLoad() {
        messages=NSMutableArray()
        
    }
    
    
    func retrieveChatFromSqlite(selecteduser:String,completion:(result:Bool)->())
    {
        //print("retrieveChatFromSqlite called---------")
        ///^^messages.removeAllObjects()
        var messages2=NSMutableArray()
        
        let to = Expression<String>("to")
        let from = Expression<String>("from")
        let owneruser = Expression<String>("owneruser")
        let fromFullName = Expression<String>("fromFullName")
        let msg = Expression<String>("msg")
        let date = Expression<NSDate>("date")
        let status = Expression<String>("status")
        let uniqueid = Expression<String>("uniqueid")
        let type = Expression<String>("type")
        let file_type = Expression<String>("file_type")
        
        var tbl_userchats=sqliteDB.userschats
        var res=tbl_userchats.filter(to==selecteduser || from==selecteduser)
        //to==selecteduser || from==selecteduser
        //print("chat from sqlite is")
        //print(res)
        do
        {
            
            //for tblContacts in try sqliteDB.db.prepare(tbl_userchats.filter(owneruser==owneruser1)){
            ////print("queryy runned count is \(tbl_contactslists.count)")
            for tblContacts in try sqliteDB.db.prepare(tbl_userchats.filter(to==selecteduser || from==selecteduser).order(date.asc)){
                
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
                
                
                if (tblContacts[from]==username!)
                    
                {//type1
                    /////print("statussss is \(tblContacts[status])")
                    if(tblContacts[file_type]=="image")
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
                        {
                            messages2.addObject(["message":tblContacts[msg]+" (\(tblContacts[status])) ", "type":"2", "date":defaultTimeeee, "uniqueid":tblContacts[uniqueid]])
                            
                            
                            //^^^^self.addMessage(tblContacts[msg]+" (\(tblContacts[status])) ", ofType: "2",date: tblContacts[date],uniqueid: tblContacts[uniqueid])
                        }
                    }
                }
                else
                {//type2
                    //// //print("statussss is \(tblContacts[status])")
                    if(tblContacts[file_type]=="image")
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
                    {
                        
                        messages2.addObject(["message":tblContacts[msg], "type":"1", "date":defaultTimeeee, "uniqueid":tblContacts[uniqueid]])
                        
                        
                        ///^^^ self.addMessage(tblContacts[msg], ofType: "1", date: tblContacts[date],uniqueid: tblContacts[uniqueid])
                        }
                    }
                    
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
        return 4
    }
     func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 60
    }
     func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    
     func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if(indexPath.row==0)
        {
        var cell = tblForGroupChat.dequeueReusableCellWithIdentifier("ChatSentCell")! as UITableViewCell
            let nameLabel = cell.viewWithTag(15) as! UILabel
            nameLabel.text="Sojharo"
        return cell
        }
        if(indexPath.row==1)
        {
            var cell = tblForGroupChat.dequeueReusableCellWithIdentifier("ChatReceivedCell")! as UITableViewCell
            let msgLabel = cell.viewWithTag(12) as! UILabel
            msgLabel.text="Hello people!"
            return cell

        }
        if(indexPath.row==2)
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
        }
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        
    }

}
