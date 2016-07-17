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

class ChatDetailViewController: UIViewController,SocketClientDelegate,UpdateChatDelegate{
    
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
    
    var messages : NSMutableArray!
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
    required init?(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
        //print("hiiiiii22 \(self.AuthToken)")
        
    }
    
    
    override func viewWillAppear(animated: Bool) {
        print("chat will appear")
        socketObj.socket.emit("logClient","IPHONE-LOG: chat page will appear")
        
        
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
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("willShowKeyBoard:"), name:UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("willHideKeyBoard:"), name:UIKeyboardWillHideNotification, object: nil)
        messages = NSMutableArray()
        
        
        
        print("chat on load")
        socketObj.socket.emit("logClient","IPHONE-LOG: chat page loading")
        socketObj.delegate=self
        socketObj.delegateChat=self
        
        dispatch_async(dispatch_get_main_queue())
            {
               self.tblForChats.reloadData()
        }
        
        if(self.messages.count>1)
        {
            var indexPath = NSIndexPath(forRow:self.messages.count-1, inSection: 0)
            
            self.tblForChats.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Bottom, animated: true)
        }
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
            socketObj.socket.emit("logClient","IPHONE-LOG: callthisperson,room:globalchatroom,callee: \(selectedContact), caller:\(username!)")
            print("callthisperson,room : globalchatroom,callee: \(selectedContact), caller:\(username!)")
            socketObj.socket.emit("callthisperson",["room" : "globalchatroom","callee": selectedContact, "caller":username!])
            print("username is ... \(username!)")
            
            isInitiator=true
            callerName=username!
            iamincallWith=selectedContact
            
            iOSstartedCall=true
            socketObj.socket.emit("logClient","IPHONE-LOG: \(username!) is going to videoViewController")
            ////
            var next = self.storyboard!.instantiateViewControllerWithIdentifier("MainV2") as! VideoViewController
            
            self.presentViewController(next, animated: true, completion: {
            })
      //  }
        
    }
    
    
    
    func retrieveChatFromSqlite(selecteduser:String)
    {
        messages.removeAllObjects()
        let to = Expression<String>("to")
        let from = Expression<String>("from")
        let owneruser = Expression<String>("owneruser")
        let fromFullName = Expression<String>("fromFullName")
        let msg = Expression<String>("msg")
        let date = Expression<String>("date")
        let status = Expression<String>("status")
        let uniqueid = Expression<String>("uniqueid")

        
        
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
            print(tblContacts[to])
            print(tblContacts[from])
            print(tblContacts[msg])
            print(tblContacts[date])
            print(tblContacts[status])
            print("--------")
            
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
                print("statussss is \(tblContacts[status])")
                self.addMessage(tblContacts[msg]+" (\(tblContacts[status])) ", ofType: "2",date: tblContacts[date])
            }
            else
            {//type2
                print("statussss is \(tblContacts[status])")
                self.addMessage(tblContacts[msg], ofType: "1", date: tblContacts[date])
                
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
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addMessage(message: String, ofType msgType:String, date:String) {
        messages.addObject(["message":message, "type":msgType, "date":date])
    }
    
    func fetchChatSQlite(){
        
        
        
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
        let sizeOFStr = self.getSizeOfString(msg)
        
        return sizeOFStr.height + 70
        
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
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        var cell : UITableViewCell!
        
        var messageDic = messages.objectAtIndex(indexPath.row) as! [String : String];
        NSLog(messageDic["message"]!, 1)
        let msgType = messageDic["type"] as NSString!
        let msg = messageDic["message"] as NSString!
        let date2=messageDic["date"] as NSString!
        let sizeOFStr = self.getSizeOfString(msg)
         print("sizeOfstr is width \(sizeOFStr.width) and height is \(sizeOFStr.height)")
        
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
        } else {
            cell = tblForChats.dequeueReusableCellWithIdentifier("ChatReceivedCell")! as UITableViewCell
            let deliveredLabel = cell.viewWithTag(13) as! UILabel
            let textLable = cell.viewWithTag(12) as! UILabel
            let timeLabel = cell.viewWithTag(11) as! UILabel
            let chatImage = cell.viewWithTag(1) as! UIImageView
            let profileImage = cell.viewWithTag(2) as! UIImageView
            let distanceFactor = (170.0 - sizeOFStr.width) < 100 ? (170.0 - sizeOFStr.width) : 100
            chatImage.frame = CGRectMake(20 + distanceFactor, chatImage.frame.origin.y, ((sizeOFStr.width + 100)  > 200 ? (sizeOFStr.width + 100) : 200), sizeOFStr.height + 40)
            chatImage.image = UIImage(named: "chat_send")?.stretchableImageWithLeftCapWidth(40,topCapHeight: 20);
            //*********
            textLable.frame = CGRectMake(36 + distanceFactor, textLable.frame.origin.y, textLable.frame.size.width, sizeOFStr.height)
            ////profileImage.center = CGPointMake(profileImage.center.x, textLable.frame.origin.y + textLable.frame.size.height - profileImage.frame.size.height/2 + 10)
            
            profileImage.center = CGPointMake(profileImage.center.x, textLable.frame.origin.y + textLable.frame.size.height - profileImage.frame.size.height/2+10)
            
            timeLabel.frame = CGRectMake(36 + distanceFactor, timeLabel.frame.origin.y, timeLabel.frame.size.width, timeLabel.frame.size.height)
            deliveredLabel.frame = CGRectMake(deliveredLabel.frame.origin.x, textLable.frame.origin.y + textLable.frame.size.height + 15, deliveredLabel.frame.size.width, deliveredLabel.frame.size.height)
            textLable.text = "\(msg)"
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
    
    func willShowKeyBoard(notification : NSNotification){
        
        var userInfo: NSDictionary!
        userInfo = notification.userInfo
        
        var duration : NSTimeInterval = 0
        var curve = userInfo.objectForKey(UIKeyboardAnimationCurveUserInfoKey) as! UInt
        duration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSTimeInterval
        let keyboardF:NSValue = userInfo.objectForKey(UIKeyboardFrameEndUserInfoKey) as! NSValue
        let keyboardFrame = keyboardF.CGRectValue()
        
        UIView.animateWithDuration(duration, delay: 0, options:[], animations: {
            self.chatComposeView.frame = CGRectMake(self.chatComposeView.frame.origin.x, self.chatComposeView.frame.origin.y - keyboardFrame.size.height+self.chatComposeView.frame.size.height+3, self.chatComposeView.frame.size.width, self.chatComposeView.frame.size.height)
            
            self.tblForChats.frame = CGRectMake(self.tblForChats.frame.origin.x, self.tblForChats.frame.origin.y, self.tblForChats.frame.size.width, self.tblForChats.frame.size.height - keyboardFrame.size.height+49);
            }, completion: nil)
        if(messages.count>1)
        {
        let indexPath = NSIndexPath(forRow:messages.count-1, inSection: 0)
        tblForChats.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Bottom, animated: true)
        }
        
    }
    
    func willHideKeyBoard(notification : NSNotification){
        
        var userInfo: NSDictionary!
        userInfo = notification.userInfo
        
        var duration : NSTimeInterval = 0
        var curve = userInfo.objectForKey(UIKeyboardAnimationCurveUserInfoKey) as! UInt
        duration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSTimeInterval
        let keyboardF:NSValue = userInfo.objectForKey(UIKeyboardFrameEndUserInfoKey) as! NSValue
        let keyboardFrame = keyboardF.CGRectValue()
        
        
        UIView.animateWithDuration(duration, delay: 0, options:[], animations: {
            self.chatComposeView.frame = CGRectMake(self.chatComposeView.frame.origin.x, self.chatComposeView.frame.origin.y + keyboardFrame.size.height-self.chatComposeView.frame.size.height-3, self.chatComposeView.frame.size.width, self.chatComposeView.frame.size.height)
            self.tblForChats.frame = CGRectMake(self.tblForChats.frame.origin.x, self.tblForChats.frame.origin.y, self.tblForChats.frame.size.width, self.tblForChats.frame.size.height + keyboardFrame.size.height-49);
            }, completion: nil)
        
    }
    
    func textFieldShouldReturn (textField: UITextField!) -> Bool{
        textField.resignFirstResponder()
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
        
        sqliteDB.SaveChat("\(selectedContact)", from1: "\(username!)",owneruser1: "\(username!)", fromFullName1: "\(loggedFullName!)", msg1: "\(txtFldMessage.text!)",date1: nil,uniqueid1: uniqueID, status1: statusNow)

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
        
        self.addMessage(txtFldMessage.text!+" (\(statusNow))", ofType: "2",date:defaultTimeZoneStr)
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
            
            
            
            
            self.addMessage(receivedMsg.description, ofType: "1",date: defaultTimeZoneStr)
            
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
       
        /*
        if segue!.identifier == "backToChatPushSegue" {
             if let destinationVC = segue!.destinationViewController as? ChatViewController{
            //destinationVC.tabBarController?.selectedIndex=0
                //self.tabBarController?.selectedIndex=0
                self.dismissViewControllerAnimated(true, completion: { () -> Void in
                    
                    
                })
            }
    }
*/
    }
    override func viewWillDisappear(animated: Bool) {
        
        //socketObj.socket.off(socketEventID)
    }
    
}
