//
//  ChatDetailViewController.swift
//  Chat
//
//  Created by My App Templates Team on 26/08/14.
//  Copyright (c) 2014 My App Templates. All rights reserved.
//

import UIKit
import SwiftyJSON
import SQLite
import Alamofire
import AVFoundation
import MobileCoreServices
import Foundation
import AssetsLibrary
import Photos

class ChatDetailViewController: UIViewController,SocketClientDelegate,UpdateChatDelegate,UIDocumentPickerDelegate,UIDocumentMenuDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,NSFileManagerDelegate,showUploadProgressDelegate{
    
   /// var manager = NetworkingManager.sharedManager
    
    var delegateProgressUpload:showUploadProgressDelegate!
    var shareMenu = UIAlertController()
    var selectedImage:UIImage!
    var filename=""
    var showKeyboard=false
    var keyFrame:CGRect!
    var keyheight:CGFloat!
    var myfid=0
    var fid:Int!=0
    var fileSize1:UInt64=0
    var filePathImage:String!
    ////** new commented april 2016var fileSize:Int!
    var fileContents:NSData!
    var chunknumbertorequest:Int=0
    var numberOfChunksInFileToSave:Double=0
    var filePathReceived:String!
    var fileSizeReceived:Int!
    var fileContentsReceived:NSData!
    
    
    var ContactNames=""
    var ContactOnlineStatus:Int!=0
    var delegateChat:UpdateChatDelegate!
    var delegate:SocketClientDelegate!
    //var socketEventID:NSUUID
    var rt=NetworkingLibAlamofire()
    @IBOutlet weak var NewChatNavigationTitle: UINavigationItem!
    @IBOutlet weak var labelToName: UILabel!
    @IBOutlet var tblForChats : UITableView!
    @IBOutlet var chatComposeView : UIView!
    @IBOutlet var txtFldMessage : UITextField!
    
    @IBOutlet weak var btn_chatDeleteHistory: UIBarButtonItem!
    
    var selectedIndex:Int!
    var selectedContact="" //username
    var selectedID=""
    var selectedFirstName=""
    var selectedLastName=""
    var selectedUserObj=JSON("[]")
    let to = Expression<String>("to")
    let from = Expression<String>("from")
    let fromFullName = Expression<String>("fromFullName")
    let msg = Expression<String>("msg")
    let date = Expression<NSDate>("date")
    
    var tbl_userchats:Table!
    
    var messages:NSMutableArray!
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?)
    {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        print(NSBundle.debugDescription())
        
        // Custom initialization
    }
    
    
    /* @IBAction func btnBackToChatsPressed(sender: AnyObject) {
     //backToChatPushSegue
     
     self.dismissViewControllerAnimated(true) { () -> Void in
     
     
     }
     //self.tabBarController?.selectedIndex=1
     //if self.rootViewController as? UITabBarController != nil {
     // var tababarController = self.window!.rootViewController as UITabBarController
     //    tababarController.selectedIndex = 1
     //}
     
     /*
     var next=self.storyboard?.instantiateViewControllerWithIdentifier("MainChatView") as! ChatViewController
     self.navigationController?.presentViewController(next, animated: true, completion: { () -> Void in
     
     
     })
     */
     /*
     var myviewChat=ChatViewController.init(nibName: nil, bundle: nil)
     var mynav=UINavigationController.init(rootViewController: myviewChat)
     self.presentViewController(mynav, animated: true) { () -> Void in
     
     
     }*/
     
     /* MyViewController *myViewController = [[MyViewController alloc] initWithNibName:nil bundle:nil];
     UINavigationController *navigationController =
     [[UINavigationController alloc] initWithRootViewController:myViewController];
     
     //now present this navigation controller modally
     [self presentViewController:navigationController
     animated:YES
     completion:^{
     
     }];*/
     /*
     RootViewController *vController=[[RootViewController alloc] initWithNibName:@"RootViewController" bundle:nil];
     [self.navigationController pushViewController:vController animated:YES];
     */
     
     
     }
     */
    
    /*
     required init?(coder aDecoder: NSCoder) {
     fatalError("init(coder:) has not been implemented")
     }*/
    
    
   
    func fileManager(fileManager: NSFileManager, shouldProceedAfterError error: NSError, copyingItemAtPath srcPath: String, toPath dstPath: String) -> Bool {
        if error.code == NSFileWriteFileExistsError {
            do {
                //var new path=dstPath.re
                try fileManager.removeItemAtPath(dstPath)
                print("Existing file deleted.")
            } catch {
                print("Failed to delete existing file:\n\((error as NSError).description)")
            }
            do {
                try fileManager.copyItemAtPath(srcPath, toPath: dstPath)
                print("File saved.")
            } catch {
                print("File not saved:\n\((error as NSError).description)")
            }
            return true
        } else {
            return false
        }
    }
    
    required init?(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
        //print("hiiiiii22 \(self.AuthToken)")
        
    }
    
    
    override func viewWillAppear(animated: Bool) {
        print("chat will appear")
        socketObj.socket.emit("logClient","IPHONE-LOG: chat page will appear")
        
       /* NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("applicationWillResignActive:"), name:UIApplicationWillResignActiveNotification, object: nil)
        
        //
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("applicationDidBecomeActive:"), name:UIApplicationDidBecomeActiveNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("willShowKeyBoard:"), name:UIKeyboardWillShowNotification, object: nil)
        */
        
        //%%%%%%%%%%%%%% commented new socket connected again and again
        /*if(socketObj == nil)
         {
         print("socket is nillll", terminator: "")
         
         
         socketObj=LoginAPI(url:"\(Constants.MainUrl)")
         /////////// print("connected issssss \(socketObj.socket.connected)")
         ///socketObj.connect()
         socketObj.addHandlers()
         socketObj.addWebRTCHandlers()
         }*/
        
        
        self.retrieveChatFromSqlite(selectedContact)
        
        
        //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%------------ commented june 16 FetchChatServer()
        print("calling retrieveChat")
        
        // if(appJustInstalled[self.selectedIndex] == true)
        //{
        
        //%%%%% new imp commented for testing ***** ******** ***** $$$$ $$$
        //--------------------------------
        //____+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        /*
         FetchChatServer(){ (result) -> () in
         if(result==true)
         {
         //          appJustInstalled[self.selectedIndex] = false
         self.retrieveChatFromSqlite(self.selectedContact)
         
         }
         }
         // ****************__________________________
         */
        
        //}
        //else
        //{
        //self.retrieveChatFromSqlite(selectedContact)
        //}
        ///////%%%%% self.retrieveChatFromSqlite(selectedContact)
        //sqliteDB.retrieveChat(username!)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        //restorationIdentifier = "ChatDetailViewController"
        //restorationClass = ChatDetailViewController.self
        
        //UIApplicationWillEnterForegroundNotification
        
       
        NSNotificationCenter.defaultCenter().removeObserver(self, name:UIApplicationWillResignActiveNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("applicationWillResignActive:"), name:UIApplicationWillResignActiveNotification, object: nil)
        
        //
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name:UIKeyboardWillShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("applicationDidBecomeActive:"), name:UIApplicationDidBecomeActiveNotification, object: nil)
        
        
        
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name:UIKeyboardWillShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("willShowKeyBoard:"), name:UIKeyboardWillShowNotification, object: nil)
        
        
        ///NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("willHideKeyBoard:"), name:UIKeyboardWillHideNotification, object: nil)
        
 
        messages = NSMutableArray()
        //uploadInfo=NSMutableArray()
        managerFile.delegateProgressUpload=self
        
        print("chat on load")
        socketObj.socket.emit("logClient","IPHONE-LOG: chat page loading")
        socketObj.delegate=self
        socketObj.delegateChat=self
        
        dispatch_async(dispatch_get_main_queue())
        {
            self.tblForChats.reloadData()
        }
        
       /* if(self.messages.count>1)
        {
            var indexPath = NSIndexPath(forRow:self.messages.count-1, inSection: 0)
            
            self.tblForChats.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Bottom, animated: true)
        }*/
        //%%%%%%%%%%%%%%%%%&&&&&&&&&&&&&&&&&&^^^^^^^^^
        //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%FetchChatServer()
        self.NewChatNavigationTitle.title=selectedFirstName
        self.navigationItem.leftBarButtonItem = self.navigationItem.backBarButtonItem
        var receivedMsg=JSON("")
        
        //%%%%%%% workinggg commented
        /*socketEventID=socketObj.socket.on("im") {data,ack in
         
         print("chat sent to server.ack received 222 ")
         var chatJson=JSON(data)
         print("chat received \(chatJson.debugDescription)")
         print(chatJson[0]["msg"])
         receivedMsg=chatJson[0]["msg"]
         self.addMessage(receivedMsg.description, ofType: "1",date: NSDate().debugDescription)
         self.tblForChats.reloadData()
         if(self.messages.count>1)
         {
         var indexPath = NSIndexPath(forRow:self.messages.count-1, inSection: 0)
         
         self.tblForChats.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Bottom, animated: true)
         }
         
         // declared system sound here
         //let systemSoundID: SystemSoundID = 1104
         // create a sound ID, in this case its the tweet sound.
         
         /*let systemSoundID: SystemSoundID = 1016
         
         // to play sound
         AudioServicesPlaySystemSound (systemSoundID)
         //AudioServicesCre
         // to play sound
         //AudioServicesPlaySystemSound (systemSoundID)
         
         var chatJson=JSON(data)
         print("chat received \(chatJson.debugDescription)")
         print(chatJson[0]["msg"])
         receivedMsg=chatJson[0]["msg"]
         //var dateString=chatJson[0]["date"]
         
         
         self.addMessage(receivedMsg.description, ofType: "1",date: NSDate().debugDescription)
         
         
         /*
         if(self.messages.count>1)
         {
         var indexPath = NSIndexPath(forRow:self.messages.count-1, inSection: 0)
         
         self.tblForChats.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Bottom, animated: true)
         }
         */
         
         
         sqliteDB.SaveChat(chatJson[0]["to"].string!, from1: chatJson[0]["from"].string!,owneruser1:chatJson[0]["to"].string!, fromFullName1: chatJson[0]["fromFullName"].string!, msg1: chatJson[0]["msg"].string!,date1:nil)
         
         
         //sqliteDB.SaveChat(chatJson["msg"][0]["to"].string!, from1: chatJson["msg"][0]["from"].string!,owneruser1:chatJson["msg"][0]["owneruser"].string! , fromFullName1: chatJson["msg"][0]["fromFullName"].string!, msg1: UserchatJson["msg"][0]["msg"].string!)
         
         
         self.tblForChats.reloadData()
         if(self.messages.count>1)
         {
         var indexPath = NSIndexPath(forRow:self.messages.count-1, inSection: 0)
         
         self.tblForChats.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Bottom, animated: true)
         }*/
         }
         */
        //________%%%%% workingggg
        
        
        ////////////messages.addObject(["message":"helloo","hiiii":"tstingggg","type":"1"])
        /*  self.addMessage("Its actually pretty good!", ofType: "1")
         self.addMessage("What do you think of this tool!", ofType: "2")*/
    }
    
    /*func getUserObjectById()
     {
     var tbl_contactList=sqliteDB.contactslists
     ////var tbl_contactList=sqliteDB.db["contactslists"]
     let username = Expression<String>("username")
     let email = Expression<String>("email")
     let _id = Expression<String>("_id")
     //let detailsshared = Expression<String>("detailsshared")
     //let unreadMessage = Expression<Bool>("unreadMessage")
     let userid = Expression<String>("userid")
     let firstname = Expression<String>("firstname")
     let lastname = Expression<String>("lastname")
     let phone = Expression<String>("phone")
     let status = Expression<String>("status")
     let contactid = Expression<String>("contactid")
     
     do{
     for user in try sqliteDB.db.prepare(tbl_contactList) {
     print("id: \(user[username]), email: \(user[email])")
     // id: 1, name: Optional("Alice"), email: alice@mac.com
     var userObj=JSON(["_id":"\(user[_id])","userid":"\(user[contactid])","firstname":"\(user[firstname])","lastname":"\(user[lastname])","email":"\(user[email])","phone":"\(user[phone])","status":"\(user[status])"])
     
     self.selectedUserObj=userObj
     }}catch{
     
     }
     
     
     /* for user in tbl_contactList.select(username, email,_id,contactid,firstname,lastname,phone,status).filter(username==selectedContact) {
     print("id: \(user[username]), email: \(user[email])")
     //^^^^var userObj=JSON(["_id":"\(user[_id])","userid":"\(user[userid])","firstname":"\(user[firstname])","lastname":"\(user[lastname])","email":"\(user[email])","phone":"\(user[phone])","status":"\(user[status])"])
     var userObj=JSON(["_id":"\(user[_id])","userid":"\(user[contactid])","firstname":"\(user[firstname])","lastname":"\(user[lastname])","email":"\(user[email])","phone":"\(user[phone])","status":"\(user[status])"])
     
     self.selectedUserObj=userObj
     // id: 1, email: alice@mac.com
     }*/
     
     //removeChatHistory()
     
     self.markChatAsRead()
     }*/
    
    
    func showError(title:String,message:String,button1:String) {
        
        // create the alert
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        
        // add the actions (buttons)
        alert.addAction(UIAlertAction(title: button1, style: UIAlertActionStyle.Default, handler: nil))
        //alert.addAction(UIAlertAction(title: button2, style: UIAlertActionStyle.Cancel, handler: nil))
        
        // show the alert
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    @IBAction func btnCallPressed(sender: AnyObject) {
        socketObj.socket.emit("logClient","IPHONE-LOG: \(username!) is trying to call \(selectedContact)")
        /*if(self.ContactOnlineStatus==0)
         {
         self.showError("Info:", message: "Contact is offline. Please try again later.", button1: "Ok")
         print("contact is offline")
         socketObj.socket.emit("logClient","IPHONE-LOG: contact \(selectedContact) is offline")
         }*/
        // else{
        
        sqliteDB.saveCallHist(ContactNames, dateTime1: NSDate().debugDescription, type1: "Outgoing")
        
        //socketObj.socket.emit("callthisperson",["room" : "globalchatroom","callee": self.ContactUsernames[selectedRow], "caller":username!])
        // &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&**************************
        username=KeychainWrapper.stringForKey("username")
        socketObj.socket.emit("logClient","IPHONE-LOG: callthisperson,room:globalchatroom,calleephone: \(selectedContact),callerphone:\(username!)")
        print("callthisperson,room : globalchatroom,callee: \(selectedContact), caller:\(username!)")
        
        
        socketObj.socket.emitWithAck("callthisperson",["room" : "globalchatroom","calleephone": selectedContact, "callerphone":username!])(timeoutAfter: 15000){data in
            var chatmsg=JSON(data)
            
            print(data[0])
            print(data[0]["calleephone"]!!)
            print(data[0]["status"]!!.debugDescription!)
            
            print("username is ... \(username!)")
            
            isInitiator=true
            callerName=username!
            iamincallWith=self.selectedContact
            
            iOSstartedCall=true
            socketObj.socket.emit("logClient","IPHONE-LOG: \(username!) is going to videoViewController")
            ////
            var next = self.storyboard!.instantiateViewControllerWithIdentifier("MainV2") as! VideoViewController
            
            self.presentViewController(next, animated: true, completion: {
            })
            
        }
        
        //  }
        
    }
    
    
    
    func retrieveChatFromSqlite(selecteduser:String)
    {
        print("retrieveChatFromSqlite called---------")
        messages.removeAllObjects()
        
        
        let to = Expression<String>("to")
        let from = Expression<String>("from")
        let owneruser = Expression<String>("owneruser")
        let fromFullName = Expression<String>("fromFullName")
        let msg = Expression<String>("msg")
        let date = Expression<String>("date")
        let status = Expression<String>("status")
        let uniqueid = Expression<String>("uniqueid")
        let type = Expression<String>("type")
        
        
        var tbl_userchats=sqliteDB.userschats
        var res=tbl_userchats.filter(to==selecteduser || from==selecteduser)
        //to==selecteduser || from==selecteduser
        print("chat from sqlite is")
        print(res)
        do
        {
            
            //for tblContacts in try sqliteDB.db.prepare(tbl_userchats.filter(owneruser==owneruser1)){
            //print("queryy runned count is \(tbl_contactslists.count)")
            for tblContacts in try sqliteDB.db.prepare(tbl_userchats.filter(to==selecteduser || from==selecteduser)){
                /*print(tblContacts[to])
                print(tblContacts[from])
                print(tblContacts[msg])
                print(tblContacts[date])
                print(tblContacts[status])
                print("--------")
                */
                if(tblContacts[from]==selecteduser && (tblContacts[status]=="delivered"))
                {
                    sqliteDB.UpdateChatStatus(tblContacts[uniqueid], newstatus: "seen")
                    
                    sqliteDB.saveMessageStatusSeen("seen", sender1: tblContacts[from], uniqueid1: tblContacts[uniqueid])
                    
                    socketObj.socket.emitWithAck("messageStatusUpdate", ["status":"seen","uniqueid":tblContacts[uniqueid],"sender": tblContacts[from]])(timeoutAfter: 15000){data in
                        var chatmsg=JSON(data)
                        
                        print(data[0])
                        print(data[0]["uniqueid"]!!)
                        print(data[0]["uniqueid"]!!.debugDescription!)
                        print(chatmsg[0]["uniqueid"].string!)
                        //print(data[0]["status"]!!.string!+" ... "+data[0]["uniqueid"]!!.string!)
                        print("chat status seen emitted")
                        sqliteDB.removeMessageStatusSeen(data[0]["uniqueid"]!!.debugDescription!)
                        socketObj.socket.emit("logClient","\(username) chat status emitted")
                        
                    }
                }
                
                if (tblContacts[from]==username!)
                    
                {//type1
                    ///print("statussss is \(tblContacts[status])")
                    if(tblContacts[type]=="image")
                    {
                      
                      //  self.addUploadInfo(selectedContact, uniqueid1: tblContacts[uniqueid], rowindex: messages.count, uploadProgress: 1, isCompleted: true)
                      
                        self.addMessage(tblContacts[msg], ofType: "4",date: tblContacts[date],uniqueid: tblContacts[uniqueid])
                        
                    }
                    else{
                    if(tblContacts[type]=="document")
                    {

                      ////  self.addUploadInfo(selectedContact, uniqueid1: tblContacts[uniqueid], rowindex: messages.count, uploadProgress: 1, isCompleted: true)
                        self.addMessage(tblContacts[msg], ofType: "6",date: tblContacts[date],uniqueid: tblContacts[uniqueid])
                        
                    }
                    else
                    {
                    self.addMessage(tblContacts[msg]+" (\(tblContacts[status])) ", ofType: "2",date: tblContacts[date],uniqueid: tblContacts[uniqueid])
                    }
                    }
                }
                else
                {//type2
                   //// print("statussss is \(tblContacts[status])")
                    if(tblContacts[type]=="image")
                    {
                      //  self.addUploadInfo(selectedContact, uniqueid1: tblContacts[uniqueid], rowindex: messages.count, uploadProgress: 1, isCompleted: true)
                        self.addMessage(tblContacts[msg] , ofType: "3",date: tblContacts[date],uniqueid: tblContacts[uniqueid])
                        
                    }
                    else
                    {if(tblContacts[type]=="document")
                    {
                       // self.addUploadInfo(selectedContact, uniqueid1: tblContacts[uniqueid], rowindex: messages.count, uploadProgress: 1, isCompleted: true)
                        self.addMessage(tblContacts[msg], ofType: "5",date: tblContacts[date],uniqueid: tblContacts[uniqueid])
                        
                    }
                    else
                    {
                    self.addMessage(tblContacts[msg], ofType: "1", date: tblContacts[date],uniqueid: tblContacts[uniqueid])
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
            self.tblForChats.reloadData()
            
            if(self.messages.count>1)
            {
                var indexPath = NSIndexPath(forRow:self.messages.count-1, inSection: 0)
                
                self.tblForChats.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Bottom, animated: true)
            }
            
        }
        catch(let error)
        {
            print(error)
        }
        /////var tbl_userchats=sqliteDB.db["userschats"]
        
    }
    
    func removeChatHistory(){
        print("header is \(header) selectedContact is \(selectedContact)")
        
        //var loggedUsername=loggedUserObj["username"]
        print("inside mark funcc", terminator: "")
        var removeChatHistoryURL=Constants.MainUrl+Constants.removeChatHistory
        
        //Alamofire.request(.POST,"\(removeChatHistoryURL)",headers:header,parameters: ["username":"\(selectedContact)"]).validate(statusCode: 200..<300).response{
        Alamofire.request(.POST,"\(removeChatHistoryURL)",headers:header,parameters: ["phone":selectedContact]).validate(statusCode: 200..<300).response{
            
            request1, response1, data1, error1 in
            
            //===========INITIALISE SOCKETIOCLIENT=========
            // dispatch_async(dispatch_get_main_queue(), {
            
            //self.dismissViewControllerAnimated(true, completion: nil);
            /// self.performSegueWithIdentifier("loginSegue", sender: nil)
            
            if response1?.statusCode==200 {
                print("chat history deleted")
                //print(request1)
                print(data1?.debugDescription)
                
                sqliteDB.deleteChat(self.selectedContact.debugDescription)
                
                self.messages.removeAllObjects()
                dispatch_async(dispatch_get_main_queue())
                {
                    self.tblForChats.reloadData()
                }
            }
            else
            {print("chat history not deleted")
                print(error1)
                print(data1)
            }
            if(response1?.statusCode==401)
            {
                print("chat history not deleted token refresh needed")
                if(username==nil || password==nil)
                {
                    self.performSegueWithIdentifier("loginSegue", sender: nil)
                }
                else{
                    self.rt.refrToken()
                }
            }
        }
        
        
    }
    
    func markChatAsRead()
    {
        print("inside mark as read", terminator: "")
        var markChatReadURL=Constants.MainUrl+Constants.markAsRead
        //print(["user1":"\(loggedUserObj)","user2":"\(selectedUserObj)"])
        print("**", terminator: "")
        //^^^^^ var loggedID=loggedUserObj["_id"]
        var loggedID=_id
        //^^^^print(loggedID.description+" logged id")
        print(loggedID!+" logged id", terminator: "")
        print(self.selectedID+" selected id", terminator: "")
        Alamofire.request(.POST,"\(markChatReadURL)",headers:header,parameters: ["user1":"\(loggedID!)","user2":"\(self.selectedID)"]
            ).responseJSON{response in
                var response1=response.response
                var request1=response.request
                var data1=response.data
                var error1=response.result.error
                
                if(error1==nil)
                {print("chat marked as read")}
                else
                {
                    self.rt.refrToken()
                }
                //===========INITIALISE SOCKETIOCLIENT=========
                // dispatch_async(dispatch_get_main_queue(), {
                
                //self.dismissViewControllerAnimated(true, completion: nil);
                /// self.performSegueWithIdentifier("loginSegue", sender: nil)
                
                //^^ if response1?.statusCode==200 {
                print("chat marked as read")
                print(response1)
                //print(data1?.debugDescription)
                //var UserchatJson=JSON(data1!)
                //^^}
                /*else
                 {print("chat marked as read but status code is not 200")
                 print(error1)
                 //print(response1?.statusCode)
                 //print(data1)
                 }
                 */
                /*if(response1?.statusCode==401)
                 {
                 print("chat not marked as read refresh token needed")
                 self.rt.refrToken()
                 }
                 */
        }
        
        
    }
    
    override func awakeFromNib() {
      //  NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("applicationWillBecomeActive:"), name:UIApplicationDidBecomeActiveNotification, object: nil)
       print("awakeeeeeeeee")
        /*NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("applicationWillResignActive:"), name:UIApplicationWillResignActiveNotification, object: nil)
        
        //
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("applicationDidBecomeActive:"), name:UIApplicationWillEnterForegroundNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("willShowKeyBoard:"), name:UIKeyboardWillShowNotification, object: nil)
        */
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addMessage(message: String, ofType msgType:String, date:String, uniqueid:String) {
        messages.addObject(["message":message, "type":msgType, "date":date, "uniqueid":uniqueid])
    }
    
    func updateProgressUpload(progress: Float, uniqueid: String) {
        
        print("progress delegate called \(progress) .. uniqueid is \(uniqueid)")
        //uploadInfo.indexOfObject(<#T##anObject: AnyObject##AnyObject#>)
       /* uploadInfo.filterUsingPredicate(NSPredicate(block: { ("uniqueid", uniqueid) -> Bool in
            
            
        })*/
        var predicate=NSPredicate(format: "uniqueid = %@", uniqueid)
        var resultArray=uploadInfo.filteredArrayUsingPredicate(predicate)
        //cfpresultArray.first
        
        var foundInd=uploadInfo.indexOfObject(resultArray.first!)
        var resultArrayMsgs=messages.filteredArrayUsingPredicate(predicate)

        
         var foundMsgInd=messages.indexOfObject(resultArrayMsgs.first!)
        //if(foundInd != NSNotFound)
            if(resultArray.count>0){
               // print("found uniqueID index as \(foundInd)")
                var newuser=resultArray.first!.valueForKey("selectedUser")
                var newuniqueid=resultArray.first!.valueForKey("uniqueid")
                var newrowindex=foundMsgInd
                var newuploadProgress=progress
                ///var newIsCompleted=resultArray.first!.valueForKey("isCompleted")
                
                var newIsCompleted=false
                if(progress==1.0)
                    {
                        newIsCompleted=true
                    }
                
                var aaa:[String:AnyObject]=["selectedUser":newuser!,"uniqueid":newuniqueid!,"rowIndex":newrowindex,"uploadProgress":newuploadProgress,"isCompleted":newIsCompleted]
                
               /////// uploadInfo.insertObject(aaa, atIndex: foundInd)
                
                
                //let newObject=["selectedUser":newuser,"uniqueid":newuniqueid,"rowIndex":newrowindex,"uploadProgress":newuploadProgress,"isCompleted":newIsCompleted]
                uploadInfo.replaceObjectAtIndex(foundInd, withObject: aaa)
                /*
 ["selectedUser":selectedUser1,"uniqueid":uniqueid1,"rowIndex":rowindex,"uploadProgress":uploadProgress,"isCompleted":isCompleted]
 */
                //=progress
               // var foundMsgInd=messages.indexOfObject(messages.valueForKey("uniqueid") as! String==uniqueid)
                var indexPath = NSIndexPath(forRow: foundMsgInd, inSection: 0)
                
                dispatch_async(dispatch_get_main_queue())
                {
                    
                    var newcell=self.tblForChats.cellForRowAtIndexPath(indexPath)
                    do{
                    var newprogressview = try newcell!.viewWithTag(14) as! KDCircularProgress!
                    var intangle=(progress*360) as NSNumber
                    
                    print("from \(newprogressview.angle) to \(intangle.integerValue)")
                    newprogressview.hidden=false
                    newprogressview.animateToAngle(intangle.integerValue, duration: 0.7, completion: { (Bool) in
                        
                        if(intangle.integerValue==360)
                        {
                            newprogressview.hidden=true
                        }
                        else
                        {
                            newprogressview.hidden=false
                        }
                        //newprogressview.angle=intangle.integerValue
                        
                    })
                    //self.tblForChats.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.None)
                    
                    //var cell=self.tblForChats.dequeueReusableCellWithIdentifier("")! as UITableViewCell
                    }
                    catch
                    {
                        print("errorrrrr 788")
                    }
                }
                
            }
    }
    
    
    
    
    func addUploadInfo(selectedUser1:String,uniqueid1:String,rowindex:Int,uploadProgress:Float,isCompleted:Bool)
    {
        uploadInfo.addObject(["selectedUser":selectedUser1,"uniqueid":uniqueid1,"rowIndex":rowindex,"uploadProgress":uploadProgress,"isCompleted":isCompleted])
    }
    
   
    
    
    //***** was working but not needed
    /*func FetchChatServer(completion:(result:Bool)->())
     {
     
     print("[user1:\(username!),user2:\(selectedContact)]", terminator: "")
     ///POST GET april 2016
     var bringUserChatURL=Constants.MainUrl+Constants.bringUserChat
     let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
     let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
     dispatch_async(dispatch_get_global_queue(priority, 0)) {
     Alamofire.request(.POST,"\(bringUserChatURL)",headers:header,parameters: ["user1":"\(username!)","user2":"\(self.selectedContact)"]
     ).validate(statusCode: 200..<300).responseJSON{response in
     var response1=response.response
     var request1=response.request
     var data1=response.result.value
     var error1=response.result.error
     
     
     
     /*.validate(statusCode: 200..<300)
     .response { (request1, response1, data1, error1) in*/
     
     
     //===========INITIALISE SOCKETIOCLIENT=========
     // dispatch_async(dispatch_get_main_queue(), {
     
     //self.dismissViewControllerAnimated(true, completion: nil);
     /// self.performSegueWithIdentifier("loginSegue", sender: nil)
     
     if response1?.statusCode==200 {
     print("chatttttttt:::::")
     print(response1)
     print(data1)
     var UserchatJson=JSON(data1!)
     print(UserchatJson)
     socketObj.socket.emit("logClient","user chat fetched \(UserchatJson)")
     print(":::::^^^&&&&&")
     //print(UserchatJson["msg"][0]["to"])
     
     //Overwrite sqlite db
     sqliteDB.deleteChat(self.selectedContact)
     
     socketObj.socket.emit("logClient","IPHONE-LOG: chat messages count is \(UserchatJson["msg"].count)")
     for var i=0;i<UserchatJson["msg"].count
     ;i++
     {
     
     
     sqliteDB.SaveChat(UserchatJson["msg"][i]["to"].string!, from1: UserchatJson["msg"][i]["from"].string!,owneruser1:UserchatJson["msg"][i]["owneruser"].string! , fromFullName1: UserchatJson["msg"][i]["fromFullName"].string!, msg1: UserchatJson["msg"][i]["msg"].string!,date1:UserchatJson["msg"][i]["date"].string!)
     
     //%%%%%%%%%%%%%%%%%%%%%%%%%
     //%%%%%%%%%%%%%%%%%%%%%%%%%%
     //_______________________________commenting june 2016 for testing--------
     
     
     /*if (UserchatJson["msg"][i]["from"].string==username!)
     
     {//type1
     self.addMessage(UserchatJson["msg"][i]["msg"].string!, ofType: "2")
     }
     else
     {//type2
     self.addMessage(UserchatJson["msg"][i]["msg"].string!, ofType: "1")
     
     }
     
     self.tblForChats.reloadData()
     if(self.messages.count>1)
     {
     var indexPath = NSIndexPath(forRow:self.messages.count-1, inSection: 0)
     self.tblForChats.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Bottom, animated: true)
     }
     */
     
     }
     dispatch_async(dispatch_get_main_queue()) {
     completion(result:true)
     }
     }
     else
     {
     
     print("chatttttt faileddddddd")
     print(response1)
     print(error1)
     print(data1)
     completion(result:false)
     }
     
     
     // })
     if(response1?.statusCode==401)
     {
     socketObj.socket.emit("logClient","IPHONE-LOG: error in fetching chat status 401")
     print("chatttttt fetch faileddddddd token expired")
     self.rt.refrToken()
     }
     }
     }
     
     
     }*/
    
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView!) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        
        var messageDic = messages.objectAtIndex(indexPath.row) as! [String : String];
        
        let msg = messageDic["message"] as NSString!
        let msgType = messageDic["type"]! as NSString
        if(msgType.isEqualToString("3")||msgType.isEqualToString("4"))
        {
            var cell=tblForChats.dequeueReusableCellWithIdentifier("FileImageReceivedCell")! as UITableViewCell
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
        let sizeOFStr = self.getSizeOfString(msg)
        
        return sizeOFStr.height + 70
        }
        /* var cell : UITableViewCell!
         cell = tblForChats.dequeueReusableCellWithIdentifier("ChatSentCell")! as UITableViewCell
         
         /*
         [self configureCell:self.prototypeCell forRowAtIndexPath:indexPath];
         [self.prototypeCell layoutIfNeeded];
         
         CGSize size = [self.prototypeCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
         return size.height+1;
         */
         
         // height = [NSLayoutConstraint constraintWithItem:chatUserImage attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.f constant:25.0f];
         
         //var hhh = NSLayoutConstraint(item: txtFldMessage, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 25.0)
         
         var size:CGSize=cell.contentView.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize);
         
         var messageDic = messages.objectAtIndex(indexPath.row) as! [String : String];
         let msg = messageDic["message"] as NSString!
         
         let sizeOFStr = self.getSizeOfString(msg)
         //var hh1 = msg.boundingRectWithSize(CGSizeMake(220.0,CGFloat.max), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: nil, context: nil).size
         
         return sizeOFStr.height + 70
         //print("size old is \(sizeOFStr.height) and my height is \(size.height)")
         //return size.height+1;
         
         */
    }
    
     func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
   
        var messageDic = messages.objectAtIndex(indexPath.row) as! [String : String];
        NSLog(messageDic["message"]!, 1)
        let msgType = messageDic["type"] as NSString!
        let msg = messageDic["message"] as NSString!
        
        if(msgType.isEqualToString("5")||msgType.isEqualToString("6")){
        self.performSegueWithIdentifier("showFullDocSegue", sender: nil);
        }
    }
    
    

    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        var cell : UITableViewCell!
        
        print("cellForRowAtIndexPath called \(indexPath)")
        var messageDic = messages.objectAtIndex(indexPath.row) as! [String : String];
        NSLog(messageDic["message"]!, 1)
        let msgType = messageDic["type"] as NSString!
        let msg = messageDic["message"] as NSString!
        let date2=messageDic["date"] as NSString!
        let sizeOFStr = self.getSizeOfString(msg)
        let uniqueidDictValue=messageDic["uniqueid"] as NSString!
       //// print("sizeOfstr is width \(sizeOFStr.width) and height is \(sizeOFStr.height)")
        
        //var sizeOFStr=msg.boundingRectWithSize(CGSizeMake(220.0,CGFloat.max), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: nil, context: nil).size
        /*
         
         Messagesize = [message.userMessage boundingRectWithSize:CGSizeMake(220.0f, CGFLOAT_MAX)
         options:NSStringDrawingUsesLineFragmentOrigin
         attributes:@{NSFontAttributeName:fontArray[1]}
         context:nil].size;
         
         
         Timesize = [@"Time" boundingRectWithSize:CGSizeMake(220.0f, CGFLOAT_MAX)
         options:NSStringDrawingUsesLineFragmentOrigin
         attributes:@{NSFontAttributeName:fontArray[2]}
         context:nil].size;
         
         
         size.height = Messagesize.height + Namesize.height + Timesize.height + 48.0f;
         */
        
        if (msgType.isEqualToString("1")){
            cell = tblForChats.dequeueReusableCellWithIdentifier("ChatSentCell")! as UITableViewCell
            let textLable = cell.viewWithTag(12) as! UILabel
            let chatImage = cell.viewWithTag(1) as! UIImageView
            let profileImage = cell.viewWithTag(2) as! UIImageView
            let timeLabel = cell.viewWithTag(11) as! UILabel
           
            
            chatImage.frame = CGRectMake(chatImage.frame.origin.x, chatImage.frame.origin.y, ((sizeOFStr.width + 100)  > 200 ? (sizeOFStr.width + 100) : 200), sizeOFStr.height + 40)
            chatImage.image = UIImage(named: "chat_receive")?.stretchableImageWithLeftCapWidth(40,topCapHeight: 20);
            //******
            
            
            textLable.frame = CGRectMake(textLable.frame.origin.x, textLable.frame.origin.y, textLable.frame.size.width, sizeOFStr.height)
            ////// profileImage.center = CGPointMake(profileImage.center.x, textLable.frame.origin.y + textLable.frame.size.height - profileImage.frame.size.height/2 + 10)
            profileImage.center = CGPointMake(profileImage.center.x, textLable.frame.origin.y + textLable.frame.size.height - profileImage.frame.size.height/2+20)
            textLable.text = "\(msg)"
            /*
             
             let dateFormatter = NSDateFormatter()
             dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
             let datens2 = dateFormatter.dateFromString(date2.debugDescription)
             
             
             
             let formatter = NSDateFormatter()
             formatter.dateStyle = NSDateFormatterStyle.ShortStyle
             formatter.timeStyle = .ShortStyle
             
             let dateString = formatter.stringFromDate(datens2!)
             */
            timeLabel.text=date2.debugDescription
        }
        if (msgType.isEqualToString("2")){
            cell = ///tblForChats.dequeueReusableCellWithIdentifier("ChatReceivedCell")! as UITableViewCell
                
                //FileImageReceivedCell
                tblForChats.dequeueReusableCellWithIdentifier("ChatReceivedCell")! as UITableViewCell
            let deliveredLabel = cell.viewWithTag(13) as! UILabel
            let textLable = cell.viewWithTag(12) as! UILabel
            let timeLabel = cell.viewWithTag(11) as! UILabel
            let chatImage = cell.viewWithTag(1) as! UIImageView
            let profileImage = cell.viewWithTag(2) as! UIImageView
            /*  let documentDirectory = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first as String!
             let photoURL          = NSURL(fileURLWithPath: documentDirectory)
             let imgPath         = photoURL.URLByAppendingPathComponent(self.filename)
             var imgNSData=NSFileManager.defaultManager().contentsAtPath(imgPath.path!)
             if(imgNSData != nil)
             {
             chatImage.image = UIImage(data: imgNSData!)
             chatImage.contentMode = .ScaleAspectFit
             }
             */
            print("here 905 msgtype is \(msgType)")
            let distanceFactor = (170.0 - sizeOFStr.width) < 100 ? (170.0 - sizeOFStr.width) : 100
            chatImage.frame = CGRectMake(20 + distanceFactor, chatImage.frame.origin.y, ((sizeOFStr.width + 100)  > 200 ? (sizeOFStr.width + 100) : 200), sizeOFStr.height + 40)
            
            
            
            textLable.hidden=false
            //chatImage.frame = CGRectMake(20 + distanceFactor, chatImage.frame.origin.y, ((sizeOFStr.width + 100)  > 200 ? (sizeOFStr.width + 100) : 200), sizeOFStr.height + 40)
            chatImage.image = UIImage(named: "chat_send")?.stretchableImageWithLeftCapWidth(40,topCapHeight: 20);
            //*********
            textLable.text = "\(msg)"
            textLable.frame = CGRectMake(36 + distanceFactor, textLable.frame.origin.y, textLable.frame.size.width, sizeOFStr.height)
            ////profileImage.center = CGPointMake(profileImage.center.x, textLable.frame.origin.y + textLable.frame.size.height - profileImage.frame.size.height/2 + 10)
            
            profileImage.center = CGPointMake(profileImage.center.x, textLable.frame.origin.y + textLable.frame.size.height - profileImage.frame.size.height/2+10)
            
            timeLabel.frame = CGRectMake(36 + distanceFactor, timeLabel.frame.origin.y, timeLabel.frame.size.width, timeLabel.frame.size.height)
            deliveredLabel.frame = CGRectMake(deliveredLabel.frame.origin.x, textLable.frame.origin.y + textLable.frame.size.height + 15, deliveredLabel.frame.size.width, deliveredLabel.frame.size.height)
            timeLabel.text=date2.debugDescription
        }
        if (msgType.isEqualToString("3")){
            cell = ///tblForChats.dequeueReusableCellWithIdentifier("ChatReceivedCell")! as UITableViewCell
                
                //FileImageReceivedCell
                tblForChats.dequeueReusableCellWithIdentifier("FileImageSentCell")! as UITableViewCell
            let deliveredLabel = cell.viewWithTag(13) as! UILabel
            let textLable = cell.viewWithTag(12) as! UILabel
            let timeLabel = cell.viewWithTag(11) as! UILabel
            let chatImage = cell.viewWithTag(1) as! UIImageView
            let profileImage = cell.viewWithTag(2) as! UIImageView
            
            let progressView = cell.viewWithTag(14) as! KDCircularProgress!
            
            //////chatImage.contentMode = .Center
            
            //chatImage.frame = CGRectMake(80, chatImage.frame.origin.y, 220, 220)
            /*let documentDirectory = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first as String!
             let photoURL          = NSURL(fileURLWithPath: documentDirectory)
             let imgPath         = photoURL.URLByAppendingPathComponent(msg as! String)
             
             */
            
            
            let dirPaths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
            let docsDir1 = dirPaths[0]
            var documentDir=docsDir1 as NSString
            var imgPath=documentDir.stringByAppendingPathComponent(msg as! String)
            
            var imgNSData=NSFileManager.defaultManager().contentsAtPath(imgPath)
            //var imgNSData=NSFileManager.defaultManager().contentsAtPath(imgPath.path!)
            print("hereee imgPath.path! is \(imgPath)")
            
            
            
            if(imgNSData != nil)
            {
                chatImage.userInteractionEnabled = true
              
                
                /*var predicate=NSPredicate(format: "uniqueid = %@", uniqueidDictValue)
                var resultArray=uploadInfo.filteredArrayUsingPredicate(predicate)
                if(resultArray.count>0)
                {
                    
                    
                    var uploadDone = resultArray.first!.valueForKey("isCompleted") as! Bool
                    if(uploadDone==false)
                    {
                        progressView.hidden=false
                    }
                    else
                    {
                        progressView.hidden=true

                    }
                    
                    // progressView.hidden=false
                    // print("yes uploading predicate satisfiedd")
                  //  var bbb = resultArray.first!.valueForKey("uploadProgress") as! Float
                    
                    
                    /*print("yes uploading predicate satisfiedd \(bbb)")
                    var newAngleValue=(bbb*360) as NSNumber
                    print("\(progressView.angle) to newangle is \(newAngleValue.integerValue)")
                    if(progressView.angle<newAngleValue.integerValue)
                    {
                        progressView.animateFromAngle(progressView.angle, toAngle: newAngleValue.integerValue, duration: 0.5, completion: nil)
                    }*/
 
                    
                    
                    // progressView.animateToAngle(newAngleValue.integerValue, duration: 0.5, completion: nil)
                    //return true
                }
 
 */
                
                //now you need a tap gesture recognizer
                //note that target and action point to what happens when the action is recognized.
                let tapRecognizer = UITapGestureRecognizer(target: self, action: Selector("imageTapped:"))
                //Add the recognizer to your view.
                chatImage.addGestureRecognizer(tapRecognizer)
                
                
                chatImage.frame = CGRectMake(chatImage.frame.origin.x, chatImage.frame.origin.y, 200, 200)
                
                chatImage.image = UIImage(data: imgNSData!)!
                ///.stretchableImageWithLeftCapWidth(40,topCapHeight: 20);
                chatImage.contentMode = .ScaleAspectFill
                chatImage.setNeedsDisplay()
                print("file shownnnnnnnnn")
                textLable.hidden=true
                
                //timeLabel.text=date2.debugDescription
            }
            
            
            /* var imgNSURL = NSURL(fileURLWithPath: msg as String)
             var imgNSData=NSFileManager.defaultManager().contentsAtPath(imgNSURL.path!)
             if(imgNSData != nil)
             {
             chatImage.image = UIImage(contentsOfFile: msg as String)
             print("file shownnnnnnnnn")
             }
             */
        }
        if (msgType.isEqualToString("4")){
            cell = ///tblForChats.dequeueReusableCellWithIdentifier("ChatReceivedCell")! as UITableViewCell
                
                //FileImageReceivedCell
                tblForChats.dequeueReusableCellWithIdentifier("FileImageReceivedCell")! as UITableViewCell
            let deliveredLabel = cell.viewWithTag(13) as! UILabel
            let textLable = cell.viewWithTag(12) as! UILabel
            let timeLabel = cell.viewWithTag(11) as! UILabel
            let chatImage = cell.viewWithTag(1) as! UIImageView
            let profileImage = cell.viewWithTag(2) as! UIImageView
            let progressView = cell.viewWithTag(14) as! KDCircularProgress!
            
            //////chatImage.contentMode = .Center
            
            //chatImage.frame = CGRectMake(80, chatImage.frame.origin.y, 220, 220)
            /*let documentDirectory = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first as String!
             let photoURL          = NSURL(fileURLWithPath: documentDirectory)
             let imgPath         = photoURL.URLByAppendingPathComponent(msg as! String)
             
             */
            
            
            let dirPaths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
            let docsDir1 = dirPaths[0]
            var documentDir=docsDir1 as NSString
            var imgPath=documentDir.stringByAppendingPathComponent(msg as! String)
            
            var imgNSData=NSFileManager.defaultManager().contentsAtPath(imgPath)
            //var imgNSData=NSFileManager.defaultManager().contentsAtPath(imgPath.path!)
            print("hereee imgPath.path! is \(imgPath)")
            
            
            
            if(imgNSData != nil)
            {
                chatImage.userInteractionEnabled = true
                //now you need a tap gesture recognizer
                //note that target and action point to what happens when the action is recognized.
                let tapRecognizer = UITapGestureRecognizer(target: self, action: Selector("imageTapped:"))
                //Add the recognizer to your view.
    
    
                var predicate=NSPredicate(format: "uniqueid = %@", uniqueidDictValue)
                var resultArray=uploadInfo.filteredArrayUsingPredicate(predicate)
                if(resultArray.count>0)
                {
                    
                    
                    var uploadDone = resultArray.first!.valueForKey("isCompleted") as! Bool
                    if(uploadDone==false)
                    {
                        progressView.hidden=false
                    }
                    else
                    {
                        progressView.hidden=true
                        
                    }
                    
                }
    /*var predicate=NSPredicate(format: "uniqueid = %@", uniqueidDictValue)
                var resultArray=uploadInfo.filteredArrayUsingPredicate(predicate)
                if(resultArray.count>0)
                {
                    // progressView.hidden=false
                    // print("yes uploading predicate satisfiedd")
                    var bbb = resultArray.first!.valueForKey("uploadProgress") as! Float
                    print("yes uploading predicate satisfiedd \(bbb)")
                    var newAngleValue=(bbb*360) as NSNumber
                    print("\(progressView.angle) to newangle is \(newAngleValue.integerValue)")
                    if(progressView.angle<newAngleValue.integerValue)
                    {
                        progressView.animateFromAngle(progressView.angle, toAngle: newAngleValue.integerValue, duration: 0.5, completion: nil)
                    }
 
                    
                    // progressView.animateToAngle(newAngleValue.integerValue, duration: 0.5, completion: nil)
                    //return true
                }
 */
                chatImage.addGestureRecognizer(tapRecognizer)
                
                
                chatImage.frame = CGRectMake(chatImage.frame.origin.x, chatImage.frame.origin.y, 200, 200)
                
                chatImage.image = UIImage(data: imgNSData!)!
                ///.stretchableImageWithLeftCapWidth(40,topCapHeight: 20);
                chatImage.contentMode = .ScaleAspectFill
                chatImage.setNeedsDisplay()
                print("file shownnnnnnnnn")
                textLable.hidden=true
                timeLabel.text=date2.debugDescription
            }
            
            
            /* var imgNSURL = NSURL(fileURLWithPath: msg as String)
             var imgNSData=NSFileManager.defaultManager().contentsAtPath(imgNSURL.path!)
             if(imgNSData != nil)
             {
             chatImage.image = UIImage(contentsOfFile: msg as String)
             print("file shownnnnnnnnn")
             }
             */
        }
        if(msgType.isEqualToString("5"))
        {
            print("type is 5 hereeeeeeeeeeee")
            cell = ///tblForChats.dequeueReusableCellWithIdentifier("ChatReceivedCell")! as UITableViewCell
                
                //FileImageReceivedCell
                tblForChats.dequeueReusableCellWithIdentifier("DocSentCell")! as UITableViewCell
            let deliveredLabel = cell.viewWithTag(13) as! UILabel
            let textLable = cell.viewWithTag(12) as! UILabel
            let timeLabel = cell.viewWithTag(11) as! UILabel
            let chatImage = cell.viewWithTag(1) as! UIImageView
            let profileImage = cell.viewWithTag(2) as! UIImageView
             let progressView=cell.viewWithTag(14) as! KDCircularProgress
            
            let distanceFactor = (170.0 - sizeOFStr.width) < 100 ? (170.0 - sizeOFStr.width) : 100
            
            
            /*
            var predicate=NSPredicate(format: "uniqueid = %@", uniqueidDictValue)
            var resultArray=uploadInfo.filteredArrayUsingPredicate(predicate)
            if(resultArray.count>0)
            {
                
                
                var uploadDone = resultArray.first!.valueForKey("isCompleted") as! Bool
                if(uploadDone==false)
                {
                    progressView.hidden=false
                }
                else
                {
                    progressView.hidden=true
                    
                }
                
                
            }
            */
            /*var predicate=NSPredicate(format: "uniqueid = %@", uniqueidDictValue)
            var resultArray=uploadInfo.filteredArrayUsingPredicate(predicate)
            if(resultArray.count>0)
{
   // progressView.hidden=false
   // print("yes uploading predicate satisfiedd")
   var bbb = resultArray.first!.valueForKey("uploadProgress") as! Float
    print("yes uploading predicate satisfiedd \(bbb)")
    var newAngleValue=(bbb*360) as NSNumber
    print("\(progressView.angle) to newangle is \(newAngleValue.integerValue)")
    if(progressView.angle<newAngleValue.integerValue)
    {
        progressView.animateFromAngle(progressView.angle, toAngle: newAngleValue.integerValue, duration: 0.5, completion: nil)
    }

    //progressView.animateToAngle(newAngleValue.integerValue, duration: 0.5, completion: nil)
    //return true
}
 
 */
          /*  var uploading=uploadInfo.contains({ (predicate) -> Bool in
             //   return ((predicate as? Int) == intValue)
                print("yes uploading predicate satisfiedd")
                var newAngleValue=270
                progressView.animateToAngle(newAngleValue, duration: 0.5, completion: nil)
                return true
            })
 */
            
            
           //  chatImage.frame = CGRectMake(chatImage.frame.origin.x, chatImage.frame.origin.y, 200, 200)
            
            ///chatImage.frame = CGRectMake(20 + distanceFactor, chatImage.frame.origin.y, ((sizeOFStr.width + 100)  > 200 ? (sizeOFStr.width + 100) : 200), sizeOFStr.height + 40)
            
            
            textLable.hidden=false
            //chatImage.frame = CGRectMake(20 + distanceFactor, chatImage.frame.origin.y, ((sizeOFStr.width + 100)  > 200 ? (sizeOFStr.width + 100) : 200), sizeOFStr.height + 40)
            chatImage.image = UIImage(named: "chat_receive")?.stretchableImageWithLeftCapWidth(40,topCapHeight: 20);
            
             chatImage.frame = CGRectMake(chatImage.frame.origin.x, chatImage.frame.origin.y, ((sizeOFStr.width + 100)  > 200 ? (sizeOFStr.width + 100) : 200), sizeOFStr.height + 40)
            
            // chatImage.layer.borderColor=UIColor.greenColor().CGColor
            //  chatImage.layer.borderWidth = 3.0;
            // chatImage.highlighted=true
            // *********
            textLable.text = "\(msg)"
            //old was 36 in place of 60
            ///textLable.frame = CGRectMake(60 + textLable.frame.origin.x, textLable.frame.origin.y, textLable.frame.size.width, sizeOFStr.height)
            
            
           //// profileImage.center = CGPointMake(45+textLable.frame.origin.x, textLable.frame.origin.y + textLable.frame.size.height - profileImage.frame.size.height/2+10)
            
            ////////profileImage.setNeedsDisplay()
            
            ////timeLabel.frame = CGRectMake(35 + distanceFactor, chatImage.frame.origin.y+sizeOFStr.height + 20, chatImage.frame.size.width-40, timeLabel.frame.size.height)
            
            
            //////chatImage.contentMode = .Center
            
            //chatImage.frame = CGRectMake(80, chatImage.frame.origin.y, 220, 220)
 
            
            
            let dirPaths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
            let docsDir1 = dirPaths[0]
            var documentDir=docsDir1 as NSString
            ////var imgPath=documentDir.stringByAppendingPathComponent(msg as! String)
            
            selectedText = msg as! String
            /// var imgNSData=NSFileManager.defaultManager().contentsAtPath(imgPath)
            chatImage.userInteractionEnabled=true
            //var filelabel=UILabel(frame: CGRect(x: 20 + chatImage.frame.origin.x, y: chatImage.frame.origin.y + sizeOFStr.height + 40,width: ((sizeOFStr.width + 100)  > 200 ? (sizeOFStr.width + 100) : 200), height: sizeOFStr.height + 40))
            //filelabel.text="rtf   95kb 3:23am"
            //chatImage.addSubview(filelabel)
            // UILabel(frame: 0,0,((sizeOFStr.width + 100)  > 200 ? (sizeOFStr.width + 100) : 200), sizeOFStr.height + 40)
           
            //let tapRecognizer = UITapGestureRecognizer(target: self, action: Selector("docTapped:"))
            //Add the recognizer to your view.
            
            
           //chatImage.addGestureRecognizer(tapRecognizer)
            timeLabel.text=date2.debugDescription
        }
        if(msgType.isEqualToString("6"))
        {
            print("type is 6 hereeeeeeeeeeee")
            cell = ///tblForChats.dequeueReusableCellWithIdentifier("ChatReceivedCell")! as UITableViewCell
                
                //FileImageReceivedCell
                tblForChats.dequeueReusableCellWithIdentifier("DocReceivedCell")! as UITableViewCell
            let deliveredLabel = cell.viewWithTag(13) as! UILabel
            let textLable = cell.viewWithTag(12) as! UILabel
            let timeLabel = cell.viewWithTag(11) as! UILabel
            let chatImage = cell.viewWithTag(1) as! UIImageView
            let profileImage = cell.viewWithTag(2) as! UIImageView
            let progressView=cell.viewWithTag(14) as! KDCircularProgress
            
            let distanceFactor = (170.0 - sizeOFStr.width) < 100 ? (170.0 - sizeOFStr.width) : 100
    
            var predicate=NSPredicate(format: "uniqueid = %@", uniqueidDictValue)
            var resultArray=uploadInfo.filteredArrayUsingPredicate(predicate)
            if(resultArray.count>0)
            {
                
                
                var uploadDone = resultArray.first!.valueForKey("isCompleted") as! Bool
                if(uploadDone==false)
                {
                    progressView.hidden=false
                }
                else
                {
                    progressView.hidden=true
                    
                }
                
                
            }
    
    /*
            var predicate=NSPredicate(format: "uniqueid = %@", uniqueidDictValue)
            var resultArray=uploadInfo.filteredArrayUsingPredicate(predicate)
            if(resultArray.count>0)
            {
                // progressView.hidden=false
                // print("yes uploading predicate satisfiedd")
                var bbb = resultArray.first!.valueForKey("uploadProgress") as! Float
                print("yes uploading predicate satisfiedd \(bbb)")
                var newAngleValue=(bbb*360) as NSNumber
                print("\(progressView.angle) to newangle is \(newAngleValue.integerValue)")
                if(progressView.angle<newAngleValue.integerValue)
                {
                progressView.animateFromAngle(progressView.angle, toAngle: newAngleValue.integerValue, duration: 0.5, completion: nil)
                }
                               // progressView.animateToAngle(newAngleValue.integerValue, duration: 0.5, completion: nil)
               //return true
            }
    
    
    */
            /*var uploading=uploadInfo.contains({ (predicate) -> Bool in
                //   return ((predicate as? Int) == intValue)
                print(predicate.uploadProgress)
                print("yes uploading predicate satisfiedd")
                var newAngleValue=predicate.
               // progressView.animateToAngle(Int32(newAngleValue), duration: 0.5, completion: nil)
                return true
            })*/
           
            chatImage.frame = CGRectMake(20 + distanceFactor, chatImage.frame.origin.y, ((sizeOFStr.width + 100)  > 200 ? (sizeOFStr.width + 100) : 200), sizeOFStr.height + 40)
            
            
            textLable.hidden=false
            //chatImage.frame = CGRectMake(20 + distanceFactor, chatImage.frame.origin.y, ((sizeOFStr.width + 100)  > 200 ? (sizeOFStr.width + 100) : 200), sizeOFStr.height + 40)
            chatImage.image = UIImage(named: "chat_send")?.stretchableImageWithLeftCapWidth(40,topCapHeight: 20);
            
            // chatImage.layer.borderColor=UIColor.greenColor().CGColor
            //  chatImage.layer.borderWidth = 3.0;
            // chatImage.highlighted=true
            // *********
            textLable.text = "\(msg)"
            //old was 36 in place of 60
            textLable.frame = CGRectMake(60 + distanceFactor, textLable.frame.origin.y, textLable.frame.size.width, sizeOFStr.height)
            
            
            profileImage.center = CGPointMake(45+distanceFactor, textLable.frame.origin.y + textLable.frame.size.height - profileImage.frame.size.height/2+10)
            
            profileImage.setNeedsDisplay()
            
            timeLabel.frame = CGRectMake(35 + distanceFactor, chatImage.frame.origin.y+sizeOFStr.height + 20, chatImage.frame.size.width-40, timeLabel.frame.size.height)
            
            
            //////chatImage.contentMode = .Center
            
            //chatImage.frame = CGRectMake(80, chatImage.frame.origin.y, 220, 220)
            /*let documentDirectory = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first as String!
             let photoURL          = NSURL(fileURLWithPath: documentDirectory)
             let imgPath         = photoURL.URLByAppendingPathComponent(msg as! String)
             
             */
            
            
            let dirPaths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
            let docsDir1 = dirPaths[0]
            var documentDir=docsDir1 as NSString
            ////var imgPath=documentDir.stringByAppendingPathComponent(msg as! String)
            
            selectedText = msg as! String
            /// var imgNSData=NSFileManager.defaultManager().contentsAtPath(imgPath)
            chatImage.userInteractionEnabled=true
            //var filelabel=UILabel(frame: CGRect(x: 20 + distanceFactor, y: chatImage.frame.origin.y + sizeOFStr.height + 40,width: ((sizeOFStr.width + 100)  > 200 ? (sizeOFStr.width + 100) : 200), height: sizeOFStr.height + 40))
            //filelabel.text="rtf   95kb 3:23am"
            //chatImage.addSubview(filelabel)
            // UILabel(frame: 0,0,((sizeOFStr.width + 100)  > 200 ? (sizeOFStr.width + 100) : 200), sizeOFStr.height + 40)
           // let tapRecognizer = UITapGestureRecognizer(target: self, action: Selector("docTapped:"))
            //Add the recognizer to your view.
            //chatImage.addGestureRecognizer(tapRecognizer)
            timeLabel.text=date2.debugDescription
        }

            

        
        
        
            
            
            
            
            //_____________________------------________
        
        
            /*
        else {
       
            if(msgType.isEqualToString("3"))
            {
                cell = ///tblForChats.dequeueReusableCellWithIdentifier("ChatReceivedCell")! as UITableViewCell
                    
                    //FileImageReceivedCell
                    tblForChats.dequeueReusableCellWithIdentifier("FileImageReceivedCell")! as UITableViewCell
                let deliveredLabel = cell.viewWithTag(13) as! UILabel
                let textLable = cell.viewWithTag(12) as! UILabel
                let timeLabel = cell.viewWithTag(11) as! UILabel
                let chatImage = cell.viewWithTag(1) as! UIImageView
                let profileImage = cell.viewWithTag(2) as! UIImageView

                
                //////chatImage.contentMode = .Center
                
                //chatImage.frame = CGRectMake(80, chatImage.frame.origin.y, 220, 220)
                /*let documentDirectory = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first as String!
                let photoURL          = NSURL(fileURLWithPath: documentDirectory)
                let imgPath         = photoURL.URLByAppendingPathComponent(msg as! String)
                
                */
                
                
                let dirPaths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
                let docsDir1 = dirPaths[0]
                var documentDir=docsDir1 as NSString
                var imgPath=documentDir.stringByAppendingPathComponent(msg as! String)
                
                var imgNSData=NSFileManager.defaultManager().contentsAtPath(imgPath)
                //var imgNSData=NSFileManager.defaultManager().contentsAtPath(imgPath.path!)
                print("hereee imgPath.path! is \(imgPath)")
           
                
                
                if(imgNSData != nil)
                {
                    chatImage.userInteractionEnabled = true
                    //now you need a tap gesture recognizer
                    //note that target and action point to what happens when the action is recognized.
                    let tapRecognizer = UITapGestureRecognizer(target: self, action: Selector("imageTapped:"))
                    //Add the recognizer to your view.
                    chatImage.addGestureRecognizer(tapRecognizer)
                    
                    
                    chatImage.frame = CGRectMake(chatImage.frame.origin.x, chatImage.frame.origin.y, 200, 200)
                    
                   chatImage.image = UIImage(data: imgNSData!)!
                    ///.stretchableImageWithLeftCapWidth(40,topCapHeight: 20);
                    chatImage.contentMode = .ScaleAspectFill
                    chatImage.setNeedsDisplay()
                     print("file shownnnnnnnnn")
                    textLable.hidden=true
                }

                
               /* var imgNSURL = NSURL(fileURLWithPath: msg as String)
                var imgNSData=NSFileManager.defaultManager().contentsAtPath(imgNSURL.path!)
                if(imgNSData != nil)
                {
                chatImage.image = UIImage(contentsOfFile: msg as String)
                print("file shownnnnnnnnn")
                }
                */
            }
            else{
                print("not 3 ...")
                
                let distanceFactor = (170.0 - sizeOFStr.width) < 100 ? (170.0 - sizeOFStr.width) : 100
                chatImage.frame = CGRectMake(20 + distanceFactor, chatImage.frame.origin.y, ((sizeOFStr.width + 100)  > 200 ? (sizeOFStr.width + 100) : 200), sizeOFStr.height + 40)
                
                

                textLable.hidden=false
            //chatImage.frame = CGRectMake(20 + distanceFactor, chatImage.frame.origin.y, ((sizeOFStr.width + 100)  > 200 ? (sizeOFStr.width + 100) : 200), sizeOFStr.height + 40)
             chatImage.image = UIImage(named: "chat_send")?.stretchableImageWithLeftCapWidth(40,topCapHeight: 20);
            // *********
                textLable.text = "\(msg)"
                textLable.frame = CGRectMake(36 + distanceFactor, textLable.frame.origin.y, textLable.frame.size.width, sizeOFStr.height)
                ////profileImage.center = CGPointMake(profileImage.center.x, textLable.frame.origin.y + textLable.frame.size.height - profileImage.frame.size.height/2 + 10)
                
                profileImage.center = CGPointMake(profileImage.center.x, textLable.frame.origin.y + textLable.frame.size.height - profileImage.frame.size.height/2+10)
                
                timeLabel.frame = CGRectMake(36 + distanceFactor, timeLabel.frame.origin.y, timeLabel.frame.size.width, timeLabel.frame.size.height)
                deliveredLabel.frame = CGRectMake(deliveredLabel.frame.origin.x, textLable.frame.origin.y + textLable.frame.size.height + 15, deliveredLabel.frame.size.width, deliveredLabel.frame.size.height)
                
                if(msgType.isEqualToString("4"))
                {
                    print("type is 4 hereeeeeeeeeeee")
                    cell = ///tblForChats.dequeueReusableCellWithIdentifier("ChatReceivedCell")! as UITableViewCell
                        
                        //FileImageReceivedCell
                        tblForChats.dequeueReusableCellWithIdentifier("DocReceivedCell")! as UITableViewCell
                    let deliveredLabel = cell.viewWithTag(13) as! UILabel
                    let textLable = cell.viewWithTag(12) as! UILabel
                    let timeLabel = cell.viewWithTag(11) as! UILabel
                    let chatImage = cell.viewWithTag(1) as! UIImageView
                    let profileImage = cell.viewWithTag(2) as! UIImageView
                    
                    
                    let distanceFactor = (170.0 - sizeOFStr.width) < 100 ? (170.0 - sizeOFStr.width) : 100
                    
                    
                    
                    chatImage.frame = CGRectMake(20 + distanceFactor, chatImage.frame.origin.y, ((sizeOFStr.width + 100)  > 200 ? (sizeOFStr.width + 100) : 200), sizeOFStr.height + 40)
                    
                   
                    textLable.hidden=false
                    //chatImage.frame = CGRectMake(20 + distanceFactor, chatImage.frame.origin.y, ((sizeOFStr.width + 100)  > 200 ? (sizeOFStr.width + 100) : 200), sizeOFStr.height + 40)
                    chatImage.image = UIImage(named: "chat_send")?.stretchableImageWithLeftCapWidth(40,topCapHeight: 20);
                    
                   // chatImage.layer.borderColor=UIColor.greenColor().CGColor
                  //  chatImage.layer.borderWidth = 3.0;
                   // chatImage.highlighted=true
                    // *********
                    textLable.text = "\(msg)"
                    //old was 36 in place of 60
                    textLable.frame = CGRectMake(60 + distanceFactor, textLable.frame.origin.y, textLable.frame.size.width, sizeOFStr.height)
 
                    
                    profileImage.center = CGPointMake(45+distanceFactor, textLable.frame.origin.y + textLable.frame.size.height - profileImage.frame.size.height/2+10)
                    
                    profileImage.setNeedsDisplay()
                    
                    timeLabel.frame = CGRectMake(35 + distanceFactor, chatImage.frame.origin.y+sizeOFStr.height + 20, chatImage.frame.size.width-40, timeLabel.frame.size.height)
                  
                    
                    //////chatImage.contentMode = .Center
                    
                    //chatImage.frame = CGRectMake(80, chatImage.frame.origin.y, 220, 220)
                    /*let documentDirectory = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first as String!
                     let photoURL          = NSURL(fileURLWithPath: documentDirectory)
                     let imgPath         = photoURL.URLByAppendingPathComponent(msg as! String)
                     
                     */
                    
                    
                    let dirPaths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
                    let docsDir1 = dirPaths[0]
                    var documentDir=docsDir1 as NSString
                    ////var imgPath=documentDir.stringByAppendingPathComponent(msg as! String)
                    
                    selectedText = msg as! String
                   /// var imgNSData=NSFileManager.defaultManager().contentsAtPath(imgPath)
                    chatImage.userInteractionEnabled=true
                    var filelabel=UILabel(frame: CGRect(x: 20 + distanceFactor, y: chatImage.frame.origin.y + sizeOFStr.height + 40,width: ((sizeOFStr.width + 100)  > 200 ? (sizeOFStr.width + 100) : 200), height: sizeOFStr.height + 40))
                    filelabel.text="rtf   95kb 3:23am"
                    chatImage.addSubview(filelabel)
                   // UILabel(frame: 0,0,((sizeOFStr.width + 100)  > 200 ? (sizeOFStr.width + 100) : 200), sizeOFStr.height + 40)
                    let tapRecognizer = UITapGestureRecognizer(target: self, action: Selector("docTapped:"))
                    //Add the recognizer to your view.
                    chatImage.addGestureRecognizer(tapRecognizer)
                    
                }
                
                
            }
           
            //////////////////////deliveredLabel.text="Delivered"
            /*
             let dateFormatter = NSDateFormatter()
             dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
             let datens2 = dateFormatter.dateFromString(date2.debugDescription)
             
             
             
             let formatter = NSDateFormatter()
             formatter.dateStyle = NSDateFormatterStyle.ShortStyle
             formatter.timeStyle = .ShortStyle
             
             let dateString = formatter.stringFromDate(datens2!)
             */
            timeLabel.text=date2.debugDescription
            //timeLabel.text=date2.debugDescription
        }
        
        
        
        */
        return cell
        /*if (msgType.isEqualToString("1")){
         cell = tblForChats.dequeueReusableCellWithIdentifier("ChatSentCell")! as UITableViewCell
         
         let textLable = cell.viewWithTag(12) as! UILabel
         let chatImage = cell.viewWithTag(1) as! UIImageView
         let profileImage = cell.viewWithTag(2) as! UIImageView
         //textLable.lineBreakMode = .ByWordWrapping // or NSLineBreakMode.ByWordWrapping
         //textLable.numberOfLines = 0
         
         chatImage.frame = CGRectMake(chatImage.frame.origin.x, chatImage.frame.origin.y, ((sizeOFStr.width + 60)  > 100 ? (sizeOFStr.width + 60) : 100), sizeOFStr.height + 40)
         //chatImage.image = UIImage(named: "chat_receive")?.stretchableImageWithLeftCapWidth(40,topCapHeight: 20);
         //chatImage.frame = CGRectMake(chatImage.frame.origin.x, chatImage.frame.origin.y, ((sizeOFStr.width + 60)  > 100 ? (sizeOFStr.width + 60) : 100), cell.frame.height + 40)
         //chatImage.image = UIImage(named: "chat_new_receive")?.stretchableImageWithLeftCapWidth(40,topCapHeight: 20);
         chatImage.image=UIImage(named: "chat_receive")?.resizableImageWithCapInsets(UIEdgeInsetsMake(chatImage.frame.origin.x, chatImage.frame.origin.y, ((sizeOFStr.width + 60)  > 100 ? (sizeOFStr.width + 60) : 100), sizeOFStr.height + 40), resizingMode:.Stretch)
         
         textLable.frame = CGRectMake(textLable.frame.origin.x, textLable.frame.origin.y, textLable.frame.size.width, sizeOFStr.height)
         /*var currentFrame = textLable.frame;
         var max = CGSizeMake(textLable.frame.size.width, 500);
         var expected=sizeOFStr
         //var expected =  [myString sizeWithFont:textLable.font constrainedToSize:max lineBreakMode:myLabel.lineBreakMode];
         currentFrame.size.height = expected.height;
         textLable.frame = currentFrame;*/
         
         profileImage.center = CGPointMake(profileImage.center.x, textLable.frame.origin.y + textLable.frame.size.height - profileImage.frame.size.height/2 + 10)
         textLable.text = "\(msg)"
         } else {
         cell = tblForChats.dequeueReusableCellWithIdentifier("ChatReceivedCell")! as UITableViewCell
         let deliveredLabel = cell.viewWithTag(13) as! UILabel
         let textLable = cell.viewWithTag(12) as! UILabel
         let timeLabel = cell.viewWithTag(11) as! UILabel
         let chatImage = cell.viewWithTag(1) as! UIImageView
         let profileImage = cell.viewWithTag(2) as! UIImageView
         let contentView = cell.viewWithTag(0) as!  UIView!
         
         /*
         var newContentViewFrame = CGRectMake(contentView.frame.origin.x, contentView.frame.origin.y, contentView.frame.size.width, 60);
         
         contentView.frame = newContentViewFrame;
         */
         textLable.lineBreakMode = .ByWordWrapping // or NSLineBreakMode.ByWordWrapping
         textLable.numberOfLines = 0
         
         let distanceFactor = (170.0 - sizeOFStr.width) < 130 ? (170.0 - sizeOFStr.width) : 130
         chatImage.frame = CGRectMake(20 + distanceFactor, chatImage.frame.origin.y, ((sizeOFStr.width + 60)  > 100 ? (sizeOFStr.width + 60) : 100), sizeOFStr.height + 40)
         chatImage.image = UIImage(named: "chat_send")?.stretchableImageWithLeftCapWidth(20,topCapHeight: 20);
         
         
         //chatImage.frame = CGRectMake(20 + distanceFactor, chatImage.frame.origin.y, ((sizeOFStr.width + 60)  > 100 ? (sizeOFStr.width + 60) : 100), cell.frame.height + 40)
         
         //chatImage.image = UIImage(named: "chat_new_send")?.stretchableImageWithLeftCapWidth(20,topCapHeight: 20);
         
         //chatImage.image=UIImage(named: "chat_new_send")?.resizableImageWithCapInsets(UIEdgeInsetsMake(20 + distanceFactor, chatImage.frame.origin.y, ((sizeOFStr.width + 60)  > 100 ? (sizeOFStr.width + 60) : 100), sizeOFStr.height + 40), resizingMode:.Stretch)
         // bubbleReadLeftImage = [[UIImage imageNamed:@"bubble_read_left"] resizableImageWithCapInsets:UIEdgeInsetsMake(20.0f, 9.0f, 27.0f, 4.0f) resizingMode:UIImageResizingModeStretch];
         
         textLable.frame = CGRectMake(36 + distanceFactor, textLable.frame.origin.y, textLable.frame.size.width, sizeOFStr.height)
         profileImage.center = CGPointMake(profileImage.center.x, textLable.frame.origin.y + textLable.frame.size.height - profileImage.frame.size.height/2 + 10)
         timeLabel.frame = CGRectMake(36 + distanceFactor, timeLabel.frame.origin.y, timeLabel.frame.size.width, timeLabel.frame.size.height)
         deliveredLabel.frame = CGRectMake(deliveredLabel.frame.origin.x, textLable.frame.origin.y + textLable.frame.size.height + 20, deliveredLabel.frame.size.width, deliveredLabel.frame.size.height)
         textLable.text = "\(msg)"
         deliveredLabel.text="Delivered"
         }
         return cell*/
    }
    
   /* override func encodeRestorableStateWithCoder(coder: NSCoder) {
        //1
        
        //coder.encode
        if let messages = messages {
            coder.encodeObject(messages, forKey: "messages")
        }
        
        //2
        super.encodeRestorableStateWithCoder(coder)
    }
    
    override func decodeRestorableStateWithCoder(coder: NSCoder) {
        messages = coder.decodeObjectForKey("messages") as! NSMutableArray
        
        super.decodeRestorableStateWithCoder(coder)
    }
    
    override func applicationFinishedRestoringState() {
        guard let messages = messages else { return }
        //tblForChats.reloadData()
        //messages = MatchedPetsManager.sharedManager.petForId(petId)
    }
    */
    
    
    func imageTapped(gestureRecognizer: UITapGestureRecognizer) {
        //tappedImageView will be the image view that was tapped.
        //dismiss it, animate it off screen, whatever.
        let tappedImageView = gestureRecognizer.view! as! UIImageView
        selectedImage=tappedImageView.image
         self.performSegueWithIdentifier("showFullImageSegue", sender: nil);
        
    }
    
    func docTapped(gestureRecognizer: UITapGestureRecognizer) {
        //tappedImageView will be the image view that was tapped.
        //dismiss it, animate it off screen, whatever.
        print("docTapped hereee")
        
        let tappedImageView = gestureRecognizer.view! as! UIImageView
        //selectedImage=tappedImageView.image
        self.performSegueWithIdentifier("showFullDocSegue", sender: nil);
        
    }
    
    
    func applicationDidBecomeActive(notification : NSNotification)
    {
       print("didbecomeactivenotification=========")
      //  NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("applicationWillResignActive:"), name:UIApplicationWillResignActiveNotification, object: nil)
        
        //
     //   NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("applicationDidBecomeActive:"), name:UIApplicationDidBecomeActiveNotification, object: nil)
          NSNotificationCenter.defaultCenter().removeObserver(self, name:UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("willShowKeyBoard:"), name:UIKeyboardWillShowNotification, object: nil)
        
 
       //// NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("willHideKeyBoard:"), name:UIKeyboardWillHideNotification, object: nil)
    }
    func applicationWillResignActive(notification : NSNotification){
        /////////self.view.endEditing(true)
        print("applicationWillResignActive=========")
         NSNotificationCenter.defaultCenter().removeObserver(self, name:UIKeyboardWillShowNotification, object: nil)
    
    }
    func willShowKeyBoard(notification : NSNotification){
       
        print("showkeyboardNotification============")
        
        if(showKeyboard==false)
        {var userInfo: NSDictionary!
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
        
        showKeyboard=true
        
    }
    
     tblForChats.reloadData()
        if(messages.count>1)
        {
            let indexPath = NSIndexPath(forRow:messages.count-1, inSection: 0)
            tblForChats.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Bottom, animated: true)
        }
 
        
    }
    /*
    func willHideKeyBoard(notification : NSNotification){
        
        var userInfo: NSDictionary!
        userInfo = notification.userInfo
        
        var duration : NSTimeInterval = 0
        var curve = userInfo.objectForKey(UIKeyboardAnimationCurveUserInfoKey) as! UInt
        duration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSTimeInterval
        let keyboardF:NSValue = userInfo.objectForKey(UIKeyboardFrameEndUserInfoKey) as! NSValue
        let keyboardFrame = keyboardF.CGRectValue()
        /////// keyheight=keyboardFrame.size.height
        
        UIView.animateWithDuration(duration, delay: 0, options:[], animations: {
            self.chatComposeView.frame = CGRectMake(self.chatComposeView.frame.origin.x, self.chatComposeView.frame.origin.y + self.keyheight-self.chatComposeView.frame.size.height-3, self.chatComposeView.frame.size.width, self.chatComposeView.frame.size.height)
            self.tblForChats.frame = CGRectMake(self.tblForChats.frame.origin.x, self.tblForChats.frame.origin.y, self.tblForChats.frame.size.width, self.tblForChats.frame.size.height + keyboardFrame.size.height-49);
            }, completion: nil)
        
    }*/
    
    func textFieldShouldReturn (textField: UITextField!) -> Bool{
        textField.resignFirstResponder()
      //  var userInfo: NSDictionary!
       // userInfo = notification.userInfo
        
        var duration : NSTimeInterval = 0

        
        UIView.animateWithDuration(duration, delay: 0, options:[], animations: {
            self.chatComposeView.frame = CGRectMake(self.chatComposeView.frame.origin.x, self.chatComposeView.frame.origin.y + self.keyheight-self.chatComposeView.frame.size.height-3, self.chatComposeView.frame.size.width, self.chatComposeView.frame.size.height)
            self.tblForChats.frame = CGRectMake(self.tblForChats.frame.origin.x, self.tblForChats.frame.origin.y, self.tblForChats.frame.size.width, self.tblForChats.frame.size.height + self.keyFrame.size.height-49);
            }, completion: nil)
        showKeyboard=false

        return true
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
    
    @IBAction func btnShareFileInChatPressed(sender: AnyObject)
    {
        
        
        let shareMenu = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        shareMenu.modalPresentationStyle=UIModalPresentationStyle.OverCurrentContext
        let photoAction = UIAlertAction(title: "Photo/Video Library", style: UIAlertActionStyle.Default,handler: { (action) -> Void in
            
            var picker=UIImagePickerController.init()
            picker.delegate=self
            
            picker.allowsEditing = true;
            //picker.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
            // if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary))
            //  {
           
            //savedPhotosAlbum
            // picker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            //}
            picker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            ////picker.mediaTypes=[kUTTypeMovie as NSString as String,kUTTypeMovie as NSString as String]
            //[self presentViewController:picker animated:YES completion:NULL];
            dispatch_async(dispatch_get_main_queue())
            { () -> Void in
                
                self.presentViewController(picker, animated: true, completion: nil)
                
            }
            
        
        })
        let documentAction = UIAlertAction(title: "Share Document", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
            
            print(NSOpenStepRootDirectory())
            ///var UTIs=UTTypeCopyPreferredTagWithClass("public.image", kUTTypeImage)?.takeRetainedValue() as! [String]
            
            //let importMenu = UIDocumentMenuViewController(documentTypes: [kUTTypeText as NSString as String, kUTTypeImage as String,"com.adobe.pdf","public.jpeg","public.html","public.content","public.data","public.item",kUTTypeBundle as String],
             //   inMode: .Import)
            
            let importMenu = UIDocumentMenuViewController(documentTypes: [kUTTypeText as NSString as String,"com.adobe.pdf","public.html",/*"public.content",*/"public.text",/*kUTTypeBundle as String,"com.apple.rtfd"*/"com.adobe.pdf","com.microsoft.word.doc","org.openxmlformats.wordprocessingml.document"],
                inMode: .Import)
            ///////let importMenu = UIDocumentMenuViewController(documentTypes: UTIs, inMode: .Import)
            importMenu.delegate = self
            
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                self.presentViewController(importMenu, animated: true, completion: nil)
                
                
            }

            
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler:nil)
        shareMenu.addAction(photoAction)
        shareMenu.addAction(documentAction)
        shareMenu.addAction(cancelAction)
        
        
        
        self.presentViewController(shareMenu, animated: true, completion: {
            
        })

        
        
        
        
        
        
        
        //................................
        
        /*
        //socketObj.socket.emit("logClient","\(username!) is sharing file with \(iamincallWith)")
        print(NSOpenStepRootDirectory())
        ///var UTIs=UTTypeCopyPreferredTagWithClass("public.image", kUTTypeImage)?.takeRetainedValue() as! [String]
        
        let importMenu = UIDocumentMenuViewController(documentTypes: [kUTTypeText as NSString as String, kUTTypeImage as String,"com.adobe.pdf","public.jpeg","public.html","public.content","public.data","public.item",kUTTypeBundle as String],
                                                      inMode: .Import)
        ///////let importMenu = UIDocumentMenuViewController(documentTypes: UTIs, inMode: .Import)
        importMenu.delegate = self
        if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary))
        {
        importMenu.addOptionWithTitle("Photots and Movies", image: nil, order: UIDocumentMenuOrder.First) {
            var picker=UIImagePickerController.init()
            picker.delegate=self
            
            picker.allowsEditing = true;
           // if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary))
          //  {
                picker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            //}
            
            //[self presentViewController:picker animated:YES completion:NULL];
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                self.presentViewController(picker, animated: true, completion: nil)
                
                
            }

            
        }
    }
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            self.presentViewController(importMenu, animated: true, completion: nil)
            
            
        }
        */
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
        

          //  var filesizenew=""
 
        
        let imageUrl          = editingInfo![UIImagePickerControllerReferenceURL] as! NSURL
        let imageName         = imageUrl.lastPathComponent
        let documentDirectory = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first as String!
        let photoURL          = NSURL(fileURLWithPath: documentDirectory)
        let localPath         = photoURL.URLByAppendingPathComponent(imageName!)
        let image             = editingInfo![UIImagePickerControllerOriginalImage]as! UIImage
        let data              = UIImagePNGRepresentation(image)
       
        if let imageURL = editingInfo![UIImagePickerControllerReferenceURL] as? NSURL {
            let result = PHAsset.fetchAssetsWithALAssetURLs([imageURL], options: nil)
            
            
           self.filename = result.firstObject?.filename ?? ""
           
           // var myasset=result.firstObject as! PHAsset
            //print(myasset.mediaType)
            
            
            
        }
        
        
        let shareMenu = UIAlertController(title: nil, message: " Send \" \(filename) \" to \(selectedFirstName) ? ", preferredStyle: .ActionSheet)
        shareMenu.modalPresentationStyle=UIModalPresentationStyle.OverCurrentContext
        let confirm = UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default,handler: { (action) -> Void in
            
        socketObj.socket.emit("logClient","IPHONE-LOG: \(username!) selected image ")
        print("file gotttttt")
        var furl=NSURL(string: localPath.URLString)
        
        print(furl!.pathExtension!)
        print(furl!.URLByDeletingPathExtension?.lastPathComponent!)
        var ftype=furl!.pathExtension!
        var fname=furl!.URLByDeletingPathExtension?.lastPathComponent!
        
        
        let dirPaths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let docsDir1 = dirPaths[0]
        var documentDir=docsDir1 as NSString
        var filePathImage2=documentDir.stringByAppendingPathComponent(self.filename)
        var fm=NSFileManager.defaultManager()
       
        var fileAttributes:[String:AnyObject]=["":""]
        do {
           /// let fileAttributes : NSDictionary? = try NSFileManager.defaultManager().attributesOfItemAtPath(furl!.path!)
        ///    let fileAttributes : NSDictionary? = try NSFileManager.defaultManager().attributesOfItemAtPath(imageUrl.path!)
            let fileAttributes : NSDictionary? = try NSFileManager.defaultManager().attributesOfItemAtPath(filePathImage2)
            if let _attr = fileAttributes {
                self.fileSize1 = _attr.fileSize();
                print("file size is \(self.fileSize1)")
                //// ***april 2016 neww self.fileSize=(fileSize1 as! NSNumber).integerValue
            }
        } catch {
            socketObj.socket.emit("logClient","IPHONE-LOG: error: \(error)")
            print("Error:+++ \(error)")
        }
        

        print("filename is \(self.filename) destination path is \(filePathImage2) image name \(imageName) imageurl \(imageUrl) photourl \(photoURL) localPath \(localPath).. \(localPath.absoluteString)")
        
            var s=fm.createFileAtPath(filePathImage2, contents: nil, attributes: nil)
        
      //  var written=fileData!.writeToFile(filePathImage2, atomically: false)
        
        //filePathImage2
        
         data!.writeToFile(filePathImage2, atomically: true)
      // data!.writeToFile(localPath.absoluteString, atomically: true)
        
            
            let calendar = NSCalendar.currentCalendar()
            let comp = calendar.components([.Hour, .Minute], fromDate: NSDate())
            let year = String(comp.year)
            let month = String(comp.month)
            let day = String(comp.day)
            let hour = String(comp.hour)
            let minute = String(comp.minute)
            let second = String(comp.second)
            
            
            var randNum5=self.randomStringWithLength(5) as! String
            var uniqueID=randNum5+year+month+day+hour+minute+second
            //var uniqueID=randNum5+year
            print("unique ID is \(uniqueID)")
            
            //var loggedid=_id!
            //^^var firstNameSelected=selectedUserObj["firstname"]
            //^^^var lastNameSelected=selectedUserObj["lastname"]
            //^^^var fullNameSelected=firstNameSelected.string!+" "+lastNameSelected.string!
            //var imParas=["from":"\(username!)","to":"\(self.selectedContact)","fromFullName":"\(displayname)","msg":"\(self.txtFldMessage.text!)","uniqueid":"\(uniqueID)"]
            
            
            
            
            
            
            
            
            var imParas=["from":"\(username!)","to":"\(self.selectedContact)","fromFullName":"\(displayname)","msg":self.filename,"uniqueid":uniqueID]
            print("imparas are \(imParas)")
            
            
            var statusNow="pending"
            //}
            
            ////sqliteDB.SaveChat("\(selectedContact)", from1: username!, owneruser1: username!, fromFullName1: displayname!, msg1: fname!+"."+ftype, date1: nil, uniqueid1: uniqueID, status1: statusNow, type1: "chat", file_type1: "", file_path1: "")
            // sqliteDB.SaveChat("\(selectedContact)", from1: "\(username!)",owneruser1: "\(username!)", fromFullName1: "\(loggedFullName!)", msg1: "\(txtFldMessage.text!)",date1: nil,uniqueid1: uniqueID, status1: statusNow)
            
            
            
            //------
            sqliteDB.SaveChat(self.selectedContact, from1: username!, owneruser1: username!, fromFullName1: displayname, msg1: self.filename, date1: nil, uniqueid1: uniqueID, status1: statusNow, type1: "image", file_type1: ftype, file_path1: filePathImage2)
            
            socketObj.socket.emitWithAck("im",["room":"globalchatroom","stanza":imParas])(timeoutAfter: 150000)
            {data in
                
                print("chat ack received  \(data)")
                statusNow="sent"
                var chatmsg=JSON(data)
                print(data[0])
                print(chatmsg[0])
                sqliteDB.UpdateChatStatus(chatmsg[0]["uniqueid"].string!, newstatus: chatmsg[0]["status"].string!)
                
                self.retrieveChatFromSqlite(self.selectedContact)
                //self.tblForChats.reloadData()
                
                
                
            }
            
            
            //sqliteDB.SaveChat(self.selectedContact, from1: username!, owneruser1: username!, fromFullName1: displayname, msg1: self.filename, date1: nil, uniqueid1: uniqueID, status1: "pending", type1: "image", file_type1: ftype, file_path1: filePathImage2)
            
            sqliteDB.saveFile(self.selectedContact, from1: username!, owneruser1: username!, file_name1: self.filename, date1: nil, uniqueid1: uniqueID, file_size1: "\(self.fileSize1)", file_type1: ftype, file_path1: filePathImage2, type1: "image")
            
            self.addUploadInfo(self.selectedContact,uniqueid1: uniqueID, rowindex: self.messages.count, uploadProgress: 0.0, isCompleted: false)
            
            managerFile.uploadFile(filePathImage2, to1: self.selectedContact, from1: username!, uniqueid1: uniqueID, file_name1: self.filename, file_size1: "\(self.fileSize1)", file_type1: ftype)
            print("alamofire upload calledddd")
            
            ///sqliteDB.saveChatImage(self.selectedContact, from1: username!, owneruser1: username!, fromFullName1: displayname, msg1: self.filename, date1: nil, uniqueid1: uniqueID, status1: "pending", type1: "document",file_type1: ftype, file_path1: filePathImage2)
        
            self.retrieveChatFromSqlite(self.selectedContact)
       /////// self.addMessage(filePathImage2, ofType: "3", date: nil)
            //print(result.firstObject?.keys)
            //filename = result.firstObject?.fileSize.debugDescription
            /* PHImageManager.defaultManager().requestImageDataForAsset(result.firstObject as! PHAsset, options: PHImageRequestOptions.init(), resultHandler: { (imageData, dataUTI, orientation, infoDict) in
             infoDict?.keys.elements.forEach({ (infoKeys) in
             print("---+++---")
             print(dataUTI)
             //print(infoKeys.debugDescription)
             })
             
             
             })*/
            // filename = result.firstObject?.
        
        
        

        
        
        self.dismissViewControllerAnimated(true, completion:{ ()-> Void in
        
            if(self.showKeyboard==true)
            {var duration : NSTimeInterval = 0
                
                
                UIView.animateWithDuration(duration, delay: 0, options:[], animations: {
                    self.chatComposeView.frame = CGRectMake(self.chatComposeView.frame.origin.x, self.chatComposeView.frame.origin.y + self.keyheight-self.chatComposeView.frame.size.height-3, self.chatComposeView.frame.size.width, self.chatComposeView.frame.size.height)
                    self.tblForChats.frame = CGRectMake(self.tblForChats.frame.origin.x, self.tblForChats.frame.origin.y, self.tblForChats.frame.size.width, self.tblForChats.frame.size.height + self.keyFrame.size.height-49);
                    }, completion: nil)
                self.showKeyboard=false
        
            }
            
            if(self.messages.count>1)
            {
                var indexPath = NSIndexPath(forRow:self.messages.count-1, inSection: 0)
                
                self.tblForChats.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Bottom, animated: true)
            }

        });
        
     
        
        
        /*if (controller.documentPickerMode == UIDocumentPickerMode.Import) {
            NSLog("Opened ", url.path!);
            print("picker url is \(url)")
            
            
            */
        
        
                
        
                
            //    urlLocalFile=localPath
                /////let text2 = fm.contentsAtPath(filePath)
                ////////print(text2)
                /////////print(JSON(text2!))
                ///mdata.fileContents=fm.contentsAtPath(filePathImage)!
            //    self.fileContents=NSData(contentsOfURL: localPath)
             //   self.filePathImage=localPath.URLString
                //var filecontentsJSON=JSON(NSData(contentsOfURL: url)!)
                //print(filecontentsJSON)
               // print("file url is \(self.filePathImage) file type is \(ftype)")
            //    var filename=fname!+"."+ftype
               // socketObj.socket.emit("logClient","\(username!) is sending file \(fname)")
                
               // var mjson="{\"file_meta\":{\"name\":\"\(filename)\",\"size\":\"\(self.fileSize1.description)\",\"filetype\":\"\(ftype)\",\"browser\":\"firefox\",\"uname\":\"\(username!)\",\"fid\":\(self.myfid),\"senderid\":\(currentID!)}}"
               /// var fmetadata="{\"eventName\":\"data_msg\",\"data\":\(mjson)}"
                
                
                //----------sendDataBuffer(fmetadata,isb: false)
                
                
              //  socketObj.socket.emit("conference.chat", ["message":"You have received a file. Download and Save it.","username":username!])
                
              /*  let alert = UIAlertController(title: "Success", message: "Your file has been successfully sent", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)*/
                
        
            //mdata.sharefile(url)
       // }
        
        })
        
        let notConfirm = UIAlertAction(title: "No", style: UIAlertActionStyle.Cancel, handler: { (action) -> Void in
            
                    })
        
        shareMenu.addAction(confirm)
        shareMenu.addAction(notConfirm)
        
        self.dismissViewControllerAnimated(true, completion:{ ()-> Void in
            
            if(self.showKeyboard==true)
            {var duration : NSTimeInterval = 0
                
                
                UIView.animateWithDuration(duration, delay: 0, options:[], animations: {
                    self.chatComposeView.frame = CGRectMake(self.chatComposeView.frame.origin.x, self.chatComposeView.frame.origin.y + self.keyheight-self.chatComposeView.frame.size.height-3, self.chatComposeView.frame.size.width, self.chatComposeView.frame.size.height)
                    self.tblForChats.frame = CGRectMake(self.tblForChats.frame.origin.x, self.tblForChats.frame.origin.y, self.tblForChats.frame.size.width, self.tblForChats.frame.size.height + self.keyFrame.size.height-49);
                    }, completion: nil)
                self.showKeyboard=false
                
            }
            self.tblForChats.reloadData()
            if(self.messages.count>1)
            {
                var indexPath = NSIndexPath(forRow:self.messages.count-1, inSection: 0)
                self.tblForChats.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Bottom, animated: true)
                
            }
            
            self.presentViewController(shareMenu, animated: true) {
                
                
            }
            
        });
        

        
       /* self.presentViewController(shareMenu, animated: true) {
            
            
        }*/
        
    }
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            self.dismissViewControllerAnimated(true, completion: { ()-> Void in
                
                if(self.showKeyboard==true)
                {var duration : NSTimeInterval = 0
                    
                    
                    UIView.animateWithDuration(duration, delay: 0, options:[], animations: {
                        self.chatComposeView.frame = CGRectMake(self.chatComposeView.frame.origin.x, self.chatComposeView.frame.origin.y + self.keyheight-self.chatComposeView.frame.size.height-3, self.chatComposeView.frame.size.width, self.chatComposeView.frame.size.height)
                        self.tblForChats.frame = CGRectMake(self.tblForChats.frame.origin.x, self.tblForChats.frame.origin.y, self.tblForChats.frame.size.width, self.tblForChats.frame.size.height + self.keyFrame.size.height-49);
                        }, completion: nil)
                    self.showKeyboard=false
                    
                }});
        }
    }
    @IBAction func postBtnTapped() {
        
        
        ///=== code for sending chat here
        ///=================
        
        //^^^^var loggedid=loggedUserObj["_id"]
        /* var uniqueid=self.randomStringWithLength(5)
         let formatter = NSDateFormatter()
         formatter.dateStyle = NSDateFormatterStyle.LongStyle
         formatter.timeStyle = .ShortStyle
         */
        //let dateString = formatter.stringFromDate(NSDate())
        let calendar = NSCalendar.currentCalendar()
        let comp = calendar.components([.Hour, .Minute], fromDate: NSDate())
        let year = String(comp.year)
        let month = String(comp.month)
        let day = String(comp.day)
        let hour = String(comp.hour)
        let minute = String(comp.minute)
        let second = String(comp.second)
        
        var randNum5=self.randomStringWithLength(5) as! String
        var uniqueID=randNum5+year+month+day+hour+minute+second
        //var uniqueID=randNum5+year
        print("unique ID is \(uniqueID)")
        
        var loggedid=_id!
        //^^var firstNameSelected=selectedUserObj["firstname"]
        //^^^var lastNameSelected=selectedUserObj["lastname"]
        //^^^var fullNameSelected=firstNameSelected.string!+" "+lastNameSelected.string!
        var imParas=["from":"\(username!)","to":"\(selectedContact)","fromFullName":"\(displayname)","msg":"\(txtFldMessage.text!)","uniqueid":"\(uniqueID)"]
        print("imparas are \(imParas)")
        print(imParas, terminator: "")
        print("", terminator: "")
        ///=== code for sending chat here
        ///=================
        
        //socketObj.socket.emit("logClient","IPHONE-LOG: \(username!) is sending chat message")
        //////socketObj.socket.emit("im",["room":"globalchatroom","stanza":imParas])
        var statusNow=""
        /*if(isSocketConnected==true)
         {
         statusNow="sent"
         
         }
         else
         {
         */
        statusNow="pending"
        //}
        
        sqliteDB.SaveChat("\(selectedContact)", from1: username!, owneruser1: username!, fromFullName1: loggedFullName!, msg1: txtFldMessage.text!, date1: nil, uniqueid1: uniqueID, status1: statusNow, type1: "chat", file_type1: "", file_path1: "")
       // sqliteDB.SaveChat("\(selectedContact)", from1: "\(username!)",owneruser1: "\(username!)", fromFullName1: "\(loggedFullName!)", msg1: "\(txtFldMessage.text!)",date1: nil,uniqueid1: uniqueID, status1: statusNow)
        
        socketObj.socket.emitWithAck("im",["room":"globalchatroom","stanza":imParas])(timeoutAfter: 150000)
        {data in
            
            print("chat ack received  \(data)")
            statusNow="sent"
            var chatmsg=JSON(data)
            print(data[0])
            print(chatmsg[0])
            sqliteDB.UpdateChatStatus(chatmsg[0]["uniqueid"].string!, newstatus: chatmsg[0]["status"].string!)
            
            self.retrieveChatFromSqlite(self.selectedContact)
            //self.tblForChats.reloadData()
            
            
            
        }
        
        
        //////
        
        
        /*insert(self.fromFullName<-"Sabach Channa",
         self.msg<-"\(txtFldMessage.text)",
         //self.owneruser<-"sabachanna",
         self.to<-"sumi",
         self.from<-"sabachanna"
         )
         if let rowid = insert.rowid {
         print("inserted id: \(rowid)")
         } else if insert.statement.failed {
         print("insertion failed: \(insert.statement.reason)")
         }*/
        
        var date=NSDate()
        var formatter = NSDateFormatter();
        formatter.dateFormat = "MM/dd, HH:mm";
        formatter.timeZone = NSTimeZone.localTimeZone()
        //formatter.dateStyle = .ShortStyle
        //formatter.timeStyle = .ShortStyle
        let defaultTimeZoneStr = formatter.stringFromDate(date);
        
        self.addMessage(txtFldMessage.text!+" (\(statusNow))", ofType: "2",date:defaultTimeZoneStr, uniqueid: uniqueID)
        txtFldMessage.text = "";
        tblForChats.reloadData()
        if(messages.count>1)
        {
            var indexPath = NSIndexPath(forRow:messages.count-1, inSection: 0)
            tblForChats.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Bottom, animated: true)
            
        }
    }
    
    func getSizeOfString(postTitle: NSString) -> CGSize {
        
        
        // Get the height of the font
        let constraintSize = CGSizeMake(170, CGFloat.max)
        
        //let constraintSize = CGSizeMake(220, CGFloat.max)
        
        
        
        /*let attributes = [NSFontAttributeName:UIFont.systemFontOfSize(11.0)]
         let labelSize = postTitle.boundingRectWithSize(constraintSize,
         options: NSStringDrawingOptions.UsesLineFragmentOrigin,
         attributes: attributes,
         context: nil)*/
        
        let labelSize = postTitle.boundingRectWithSize(constraintSize,
                                                       options: NSStringDrawingOptions.UsesLineFragmentOrigin,
                                                       attributes:[NSFontAttributeName : UIFont.systemFontOfSize(11.0)],
                                                       context: nil)
        //print("size is width \(labelSize.width) and height is \(labelSize.height)")
        return labelSize.size
    }
    
    
    @IBAction func btn_deleteChatHistoryPressed(sender: AnyObject) {
        
        removeChatHistory()
        /*sqliteDB.deleteChat(selectedContact.debugDescription)
         
         messages.removeAllObjects()
         tblForChats.reloadData()*/
    }
    
    func socketReceivedMessage(message: String, data: AnyObject!) {
        /*
         print("socketReceivedMessage inside im got", terminator: "")
         var msg=JSON(data)
         print("$$ \(message) is this \(msg)")
         print(message)
         switch(message)
         {
         case "im":
         print("chat sent to server.ack received 222 ")
         var chatJson=JSON(data)
         print("chat received \(chatJson.debugDescription)")
         print(chatJson[0]["msg"])
         var receivedMsg=chatJson[0]["msg"]
         
         self.addMessage(receivedMsg.description, ofType: "1",date: NSDate().debugDescription)
         self.tblForChats.reloadData()
         if(self.messages.count>1)
         {
         var indexPath = NSIndexPath(forRow:self.messages.count-1, inSection: 0)
         
         self.tblForChats.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Bottom, animated: true)
         }
         
         
         default:
         print("error: wrong messgae received2 \(message)")
         
         }
         */
        
    }
    func socketReceivedSpecialMessage(message: String, params: JSON!) {
        
        
    }
    func socketReceivedMessageChat(message: String, data: AnyObject!) {
        
        //print("socketReceivedMessage inside im got", terminator: "")
        switch(message)
        {
        case "im":
            var msg=JSON(data)
            print("$$ \(message) is this \(msg)")
            print(message)
            
            print("chat sent to server.ack received 222 ")
            
            var chatJson=JSON(data)
            print("chat received \(chatJson.debugDescription)")
            print(chatJson[0]["msg"])
            var receivedMsg=chatJson[0]["msg"]
            
            
            var date22=NSDate()
            var formatter = NSDateFormatter();
            //formatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZ";
            formatter.dateFormat = "MM/dd, HH:mm";
            formatter.timeZone = NSTimeZone.localTimeZone()
            // formatter.dateStyle = .ShortStyle
            //formatter.timeStyle = .ShortStyle
            let defaultTimeZoneStr = formatter.stringFromDate(date22);
            
             var uniqueid=chatJson[0]["uniqueid"].string!
            
            
            self.addMessage(receivedMsg.description, ofType: "1",date: defaultTimeZoneStr,uniqueid: uniqueid)
            
            self.retrieveChatFromSqlite(self.selectedContact)
            if(self.messages.count>1)
            {
                var indexPath = NSIndexPath(forRow:self.messages.count-1, inSection: 0)
                
                self.tblForChats.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Bottom, animated: true)
            }
            
            //%%%%% OLD working logic.. changed coz of bubble unread
            
            /*
             self.tblForChats.reloadData()
             if(self.messages.count>1)
             {
             var indexPath = NSIndexPath(forRow:self.messages.count-1, inSection: 0)
             
             self.tblForChats.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Bottom, animated: true)
             }
             
             */
        case "updateUI":
            
            print("$$ \(message)")
            print(message)
            
            self.retrieveChatFromSqlite(self.selectedContact)
            if(self.messages.count>1)
            {
                var indexPath = NSIndexPath(forRow:self.messages.count-1, inSection: 0)
                
                self.tblForChats.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Bottom, animated: true)
            }
            
            // dispatch_async(dispatch_get_main_queue())
            //  {
            //     self.tblForChats.reloadData()
            // }
            
            
        default:
            print("error: wrong messgae received2 \(message)")
            
            
        }
    }
    
    /*
     // delete slider to delete individual row
     // Override to support editing the table view.
     func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
     if editingStyle == .Delete {
     messages.removeObjectAtIndex(indexPath.row)
     // Delete the row from the data source
     tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
     } else if editingStyle == .Insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    
    
    // #pragma mark - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue?, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        
        
         if segue!.identifier == "showFullImageSegue" {
         if let destinationVC = segue!.destinationViewController as? ShowImageViewController{
         //destinationVC.tabBarController?.selectedIndex=0
         //self.tabBarController?.selectedIndex=0
             destinationVC.newimage=self.selectedImage
                    self.dismissViewControllerAnimated(true, completion: { () -> Void in
         
                       

         })
         }
         }
        if segue!.identifier == "showFullDocSegue" {
            if let destinationVC = segue!.destinationViewController as? textDocumentViewController{
                let selectedRow = tblForChats.indexPathForSelectedRow!.row
                var messageDic = messages.objectAtIndex(selectedRow) as! [String : String];
                
                let msg = messageDic["message"] as NSString!
                selectedText=msg as String
                //destinationVC.tabBarController?.selectedIndex=0
                //self.tabBarController?.selectedIndex=0
                destinationVC.newtext=selectedText
                self.dismissViewControllerAnimated(true, completion: { () -> Void in
                    
                    
                    
                })
            }
        }
 
    }
    
    func documentPicker(controller: UIDocumentPickerViewController, didPickDocumentAtURL url: NSURL) {
        
        
        
        
        
        print("yess pickeddd document")
        var furl=NSURL(string: url.URLString)
        
        
        //METADATA FILE NAME,TYPE
        print(furl!.pathExtension!)
        print(furl!.URLByDeletingPathExtension?.lastPathComponent!)
        var ftype=furl!.pathExtension!
        var fname=furl!.URLByDeletingPathExtension?.lastPathComponent!
        ////var fname=furl!.URLByDeletingPathExtension?.URLString
        //var attributesError=nil
        var fileAttributes:[String:AnyObject]=["":""]
        
         shareMenu = UIAlertController(title: nil, message: " Send \" \(fname!) .\(ftype)\" to \(selectedFirstName) ? ", preferredStyle: .ActionSheet)
       // shareMenu.modalPresentationStyle=UIModalPresentationStyle.OverCurrentContext
        let confirm = UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default,handler: { (action) -> Void in
            

            
        
        
        if (controller.documentPickerMode == UIDocumentPickerMode.Import) {
          //  NSLog("Opened ", url.path!);
            print("picker url is \(url)")
            print("opened \(url.path!)")
            
            
            url.startAccessingSecurityScopedResource()
            let coordinator = NSFileCoordinator()
            var error:NSError? = nil
            coordinator.coordinateReadingItemAtURL(url, options: [], error: &error) { (url) -> Void in
                // do something with it
                let fileData = NSData(contentsOfURL: url)
                ///////////////////////print(fileData?.description)
                socketObj.socket.emit("logClient","IPHONE-LOG: \(username!) selected file ")
                print("file gotttttt")
               
                do {
                    let fileAttributes : NSDictionary? = try NSFileManager.defaultManager().attributesOfItemAtPath(furl!.path!)
                    
                    if let _attr = fileAttributes {
                        self.fileSize1 = _attr.fileSize();
                        print("file size is \(self.fileSize1)")
                        //// ***april 2016 neww self.fileSize=(fileSize1 as! NSNumber).integerValue
                    }
                } catch {
                    socketObj.socket.emit("logClient","IPHONE-LOG: error: \(error)")
                    print("Error:.... \(error)")
                }
                
                urlLocalFile=url
                /////let text2 = fm.contentsAtPath(filePath)
                ////////print(text2)
                /////////print(JSON(text2!))
                ///mdata.fileContents=fm.contentsAtPath(filePathImage)!
                self.fileContents=NSData(contentsOfURL: url)
                self.filePathImage=url.URLString
                //var filecontentsJSON=JSON(NSData(contentsOfURL: url)!)
                //print(filecontentsJSON)
                print("file url is \(self.filePathImage) file type is \(ftype)")
                
                
                
                
                
                let dirPaths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
                let docsDir1 = dirPaths[0]
                var documentDir=docsDir1 as NSString
                var filePathImage2=documentDir.stringByAppendingPathComponent(fname!+"."+ftype)
                var fm=NSFileManager.defaultManager()
                
                /*var fileAttributes:[String:AnyObject]=["":""]
                do {
                    /// let fileAttributes : NSDictionary? = try NSFileManager.defaultManager().attributesOfItemAtPath(furl!.path!)
                    let fileAttributes : NSDictionary? = try NSFileManager.defaultManager().attributesOfItemAtPath(imageUrl.path!)
                    
                    if let _attr = fileAttributes {
                        self.fileSize1 = _attr.fileSize();
                        print("file size is \(self.fileSize1)")
                        //// ***april 2016 neww self.fileSize=(fileSize1 as! NSNumber).integerValue
                    }
                } catch {
                    socketObj.socket.emit("logClient","IPHONE-LOG: error: \(error)")
                    print("Error:+++ \(error)")
                }*/
                
                
              //  print("filename is \(self.filename) destination path is \(filePathImage2) image name \(imageName) imageurl \(imageUrl) photourl \(photoURL) localPath \(localPath).. \(localPath.absoluteString)")
                
                var s=fm.createFileAtPath(filePathImage2, contents: nil, attributes: nil)
                
                //  var written=fileData!.writeToFile(filePathImage2, atomically: false)
                
                //filePathImage2
                //var data=NSData(contentsOfFile: self.filePathImage)
                fileData!.writeToFile(filePathImage2, atomically: true)
                
                
                
                
                
              /*
                var filename=fname!+"."+ftype
                socketObj.socket.emit("logClient","\(username!) is sending file \(fname)")
                
                var mjson="{\"file_meta\":{\"name\":\"\(filename)\",\"size\":\"\(self.fileSize1.description)\",\"filetype\":\"\(ftype)\",\"browser\":\"firefox\",\"uname\":\"\(username!)\",\"fid\":\(self.myfid),\"senderid\":\(currentID!)}}"
                var fmetadata="{\"eventName\":\"data_msg\",\"data\":\(mjson)}"
                */
                
                //----------sendDataBuffer(fmetadata,isb: false)
                
                
                let calendar = NSCalendar.currentCalendar()
                let comp = calendar.components([.Hour, .Minute], fromDate: NSDate())
                let year = String(comp.year)
                let month = String(comp.month)
                let day = String(comp.day)
                let hour = String(comp.hour)
                let minute = String(comp.minute)
                let second = String(comp.second)
                
                
                var randNum5=self.randomStringWithLength(5) as! String
                var uniqueID=randNum5+year+month+day+hour+minute+second
                
                
                
                //var uniqueID=randNum5+year
                print("unique ID is \(uniqueID)")
                
                //^^var firstNameSelected=selectedUserObj["firstname"]
                //^^^var lastNameSelected=selectedUserObj["lastname"]
                //^^^var fullNameSelected=firstNameSelected.string!+" "+lastNameSelected.string!
                var imParas=["from":"\(username!)","to":"\(self.selectedContact)","fromFullName":"\(displayname)","msg":fname!+"."+ftype,"uniqueid":uniqueID]
                print("imparas are \(imParas)")
                print(imParas, terminator: "")
                print("", terminator: "")
                ///=== code for sending chat here
                ///=================
                
                //socketObj.socket.emit("logClient","IPHONE-LOG: \(username!) is sending chat message")
                //////socketObj.socket.emit("im",["room":"globalchatroom","stanza":imParas])
                var statusNow=""
                /*if(isSocketConnected==true)
                 {
                 statusNow="sent"
                 
                 }
                 else
                 {
                 */
                statusNow="pending"
                //}
                
                ////sqliteDB.SaveChat("\(selectedContact)", from1: username!, owneruser1: username!, fromFullName1: displayname!, msg1: fname!+"."+ftype, date1: nil, uniqueid1: uniqueID, status1: statusNow, type1: "chat", file_type1: "", file_path1: "")
                // sqliteDB.SaveChat("\(selectedContact)", from1: "\(username!)",owneruser1: "\(username!)", fromFullName1: "\(loggedFullName!)", msg1: "\(txtFldMessage.text!)",date1: nil,uniqueid1: uniqueID, status1: statusNow)
                
            
                
                //------
                sqliteDB.SaveChat(self.selectedContact, from1: username!, owneruser1: username!, fromFullName1: displayname, msg1: fname!+"."+ftype, date1: nil, uniqueid1: uniqueID, status1: statusNow, type1: "document", file_type1: ftype, file_path1: filePathImage2)
                
                socketObj.socket.emitWithAck("im",["room":"globalchatroom","stanza":imParas])(timeoutAfter: 150000)
                {data in
                    
                    print("chat ack received  \(data)")
                    statusNow="sent"
                    var chatmsg=JSON(data)
                    print(data[0])
                    print(chatmsg[0])
                    sqliteDB.UpdateChatStatus(chatmsg[0]["uniqueid"].string!, newstatus: chatmsg[0]["status"].string!)
                    
                    self.retrieveChatFromSqlite(self.selectedContact)
                    //self.tblForChats.reloadData()
                    
                    
                    
                }
                

                 sqliteDB.saveFile(self.selectedContact, from1: username!, owneruser1: username!, file_name1: fname!+"."+ftype, date1: nil, uniqueid1: uniqueID, file_size1: "\(self.fileSize1)", file_type1: ftype, file_path1: filePathImage2, type1: "document")
                
               
                self.addUploadInfo(self.selectedContact,uniqueid1: uniqueID, rowindex: self.messages.count, uploadProgress: 0.0, isCompleted: false)
                
                managerFile.uploadFile(filePathImage2, to1: self.selectedContact, from1: username!, uniqueid1: uniqueID, file_name1: fname!+"."+ftype, file_size1: "\(self.fileSize1)", file_type1: ftype)
                
              ////  sqliteDB.saveChatImage(self.selectedContact, from1: username!, owneruser1: username!, fromFullName1: "fafa", msg1: fname!+"."+ftype, date1: nil, uniqueid1: uniqueID, status1: "pending", type1: "document", file_type1: ftype, file_path1: filePathImage2)
                
               //// sqliteDB.saveChatImage(self.selectedContact, from1: username!,fromFullName1: displayname, owneruser1:username!, msg1: fname!+"."+ftype, date1: nil, uniqueid1: uniqueID, status1: "pending", type1: "doc",file_type1: ftype, file_path1: filePathImage2)
                selectedText = filePathImage2
                
                 self.retrieveChatFromSqlite(self.selectedContact)
               ////  sqliteDB.SaveChat(self.selectedContact, from1: username!, owneruser1: username!, fromFullName1: displayname, msg1: filename, date1: nil, uniqueid1: uniqueID, status1: "pending")
                
                /////socketObj.socket.emit("conference.chat", ["message":"You have received a file. Download and Save it.","username":username!])
                
               /* let alert = UIAlertController(title: "Success", message: "Your file has been successfully sent", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
                
                */
            }
            
            url.stopAccessingSecurityScopedResource()
            //mdata.sharefile(url)
        }
        })
        
        
        let notConfirm = UIAlertAction(title: "No", style: UIAlertActionStyle.Cancel, handler: { (action) -> Void in
            
        })
        
        shareMenu.addAction(confirm)
        shareMenu.addAction(notConfirm)
        
        self.presentViewController(shareMenu, animated: true, completion: {
            
        })

        
        
    }
    
    
    
    func documentMenu(documentMenu: UIDocumentMenuViewController, didPickDocumentPicker documentPicker: UIDocumentPickerViewController) {
        
        documentPicker.delegate = self
        presentViewController(documentPicker, animated: true, completion: nil)
        
        
    }
    
    
    
    func documentMenuWasCancelled(documentMenu: UIDocumentMenuViewController) {
        
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        print("disappearrrrrrrrr")
        super.viewWillDisappear(animated)
        socketObj.delegateChat=nil
       /////  NSNotificationCenter.defaultCenter().removeObserver(self, name:UIKeyboardWillShowNotification, object: nil)    
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    /* override func viewDidLayoutSubviews() {
     
     super.viewDidLayoutSubviews()
     }*/
}
/*
 extension ChatDetailViewController: UIViewControllerRestoration {
 static func viewControllerWithRestorationIdentifierPath(identifierComponents: [AnyObject],
 coder: NSCoder) -> UIViewController? {
 let vc = ChatDetailViewController()
 return vc
 }
 }*/