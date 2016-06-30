//
//  ChatViewController.swift
//  Chat
//
//  Created by My App Templates Team on 24/08/14.
//  Copyright (c) 2014 My App Templates. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import SQLite
import AVFoundation
import Foundation
import AccountKit
import Contacts

class ChatViewController:UIViewController,SocketClientDelegate,SocketConnecting
{
    
    
    
    var accountKit: AKFAccountKit!
    var rt=NetworkingLibAlamofire()
    var allkiboContactsArray=Array<Row>()
    
    var Q_serial1=dispatch_queue_create("Q_serial1",DISPATCH_QUEUE_SERIAL)
    var Q_serial2=dispatch_queue_create("Q_serial2",DISPATCH_QUEUE_SERIAL)
    var Q_serial3=dispatch_queue_create("Q_serial3",DISPATCH_QUEUE_SERIAL)
    
    var messageFrame = UIView()
    var activityIndicator = UIActivityIndicatorView()
    var messageFrame2 = UIView()
    var activityIndicator2 = UIActivityIndicatorView()
    var strLabel = UILabel()
    var strLabel2 = UILabel()
    
    var refreshControl = UIRefreshControl()
    @IBOutlet var viewForTitle : UIView!
    @IBOutlet var ctrlForChat : UISegmentedControl!
    @IBOutlet var btnForLogo : UIButton!
    var loggedID=loggedUserObj["_id"]
    @IBOutlet var tblForChat : UITableView!
    @IBOutlet weak var btnContactAdd: UIBarButtonItem!
    var delegateSocketConn:SocketConnecting!
    var currrentUsernameRetrieved:String=""
    var delegate:SocketClientDelegate!
    ////////let delegateController=LoginAPI(url: "sdfsfes")
    
    
    
    
    func getCurrentUserDetails(completion: (result:Bool)->())
    {
        
        socketObj.socket.emit("logClient","IPHONE-LOG: login success and AuthToken was not nil getting myself details from server")
        
        print("login success")
        
        //======GETTING REST API TO GET CURRENT USER=======================
        
        var userDataUrl=Constants.MainUrl+Constants.getCurrentUser
        
        
        var getUserDataURL=userDataUrl
        
        Alamofire.request(.GET,"\(getUserDataURL)",headers:header).validate(statusCode: 200..<300).responseJSON{response in
            
            
            switch response.result {
            case .Success:
                if let data1 = response.result.value {
                    let json = JSON(data1)
                    print("JSON: \(json)")
                    
                    print("got user success")
                    
                    
                    username=json["phone"].string
                    displayname=json["display_name"].string!
                    loggedUserObj=json
                    KeychainWrapper.setString(loggedUserObj.description, forKey:"loggedUserObjString")
                    var loggedobjstring=KeychainWrapper.stringForKey("loggedUserObjString")
                    
                    socketObj.socket.emit("logClient","IPHONE-LOG: keychain of loggedUserObjString is \(loggedobjstring)")
                    
                    print(loggedUserObj.debugDescription)
                    print(loggedUserObj.object)
                    print("$$$$$$$$$$$$$$$$$$$$$$$$$")
                    print("************************")
                    
                    do{
                        try KeychainWrapper.setString(json["phone"].string!, forKey: "username")
                        /// try KeychainWrapper.setString(json["display_name"].string!, forKey: "username")
                        try KeychainWrapper.setString(json["display_name"].string!, forKey: "loggedFullName")
                        try KeychainWrapper.setString(json["phone"].string!, forKey: "loggedPhone")
                        try KeychainWrapper.setString("", forKey: "loggedEmail")
                        try KeychainWrapper.setString(json["_id"].string!, forKey: "_id")
                        
                        //%%%% new phone model
                        // try KeychainWrapper.setString(self.txtForPassword.text!, forKey: "password")
                        try KeychainWrapper.setString("", forKey: "password")
                    }
                    catch{
                        print("error is setting keychain value")
                        print(json.error?.localizedDescription)
                    }
                    
                    
                    var jsonNew=JSON("{\"room\": \"globalchatroom\",\"user\": {\"username\":\"sabachanna\"}}")
                    //socketObj.socket.emit("join global chatroom", ["room": "globalchatroom", "user": ["username":"sabachanna"]]) WORKINGGG
                    
                    socketObj.socket.emit("logClient","IPHONE-LOG: \(username!) is joining room room:globalchatroom, user: \(json.object)")
                    socketObj.socket.emit("join global chatroom",["room": "globalchatroom", "user": json.object])
                    
                    print(json["_id"])
                    
                    
                    
                    let tbl_accounts = sqliteDB.accounts
                    
                    do{
                        
                        try sqliteDB.db.run(tbl_accounts.delete())
                    }catch{
                        socketObj.socket.emit("logClient","accounts table not deleted")
                        print("accounts table not deleted")
                    }
                    
                    let _id = Expression<String>("_id")
                    let firstname = Expression<String?>("firstname")
                    let lastname = Expression<String?>("lastname")
                    let email = Expression<String>("email")
                    let phone = Expression<String>("phone")
                    let username1 = Expression<String>("username")
                    let status = Expression<String>("status")
                    let date = Expression<String>("date")
                    let accountVerified = Expression<String>("accountVerified")
                    let role = Expression<String>("role")
                    
                    
                    // let insert = users.insert(email <- "alice@mac.com")
                    
                    
                    tbl_accounts.delete()
                    
                    do {
                        let rowid = try sqliteDB.db.run(tbl_accounts.insert(_id<-json["_id"].string!,
                            //firstname<-json["firstname"].string!,
                            firstname<-json["display_name"].string!,
                            //lastname<-"",
                            //lastname<-json["lastname"].string!,
                            //email<-json["email"].string!,
                            username1<-json["phone"].string!,
                            status<-json["status"].string!,
                            phone<-json["phone"].string!))
                        print("inserted id: \(rowid)")
                        
                        return completion(result:true)
                        
                    } catch {
                        print("insertion failed: \(error)")
                    }
                    
                    
                    do{for account in try sqliteDB.db.prepare(tbl_accounts) {
                        print("id: \(account[_id]), phone: \(account[phone]), firstname: \(account[firstname])")
                        // id: 1, email: alice@mac.com, name: Optional("Alice")
                        }
                        
                    }
                    catch
                    {
                        
                    }
                }
            case .Failure:
                socketObj.socket.emit("logClient", "\(username!) failed to get its data")
            }
        }
    }
    
    //func fetchChatsFromServer()
    
    
    @IBAction func addContactTapped(sender: UIBarButtonItem) {
        
        self.performSegueWithIdentifier("inviteSegue",sender: nil)
        
        
        
        /* let alert = UIAlertView()
        alert.title = "Alert"
        alert.message = "Here's a message"
        alert.addButtonWithTitle("Understod")
        alert.show()
        */
        
        
        
        /*
        var tField: UITextField!
        
        //Create the AlertController
        let actionSheetController: UIAlertController = UIAlertController(title: "Add Contact", message: "Please Enter Email/Username", preferredStyle: .Alert)
        
        //Add a text field
        actionSheetController.addTextFieldWithConfigurationHandler { textField -> Void in
        //TextField configuration
        textField.textColor = UIColor.greenColor()
        tField=textField
        }
        
        //Create and add the Cancel action
        let cancelAction: UIAlertAction = UIAlertAction(title: "Add by Email", style: UIAlertActionStyle.Cancel) { action -> Void in
        
        print(loggedUserObj)
        var fname=["firstname":loggedUserObj["firstname"]]
        var lname=["lastname":loggedUserObj["lastname"]]
        var usern=["username":loggedUserObj["username"]]
        var idd=["_id":loggedUserObj["_id"]]
        var date=["date":loggedUserObj["date"]]
        var email=["email":loggedUserObj["email"]]
        var status=["status":loggedUserObj["stauts"]]
        //var merge=fname.description+lname.description+String(usern)
        
        // var userID=["userid":"\(merge)"]
        //loggedUserObj["accountVerified"]
        //loggedUserObj["city"]
        //sloggedUserObj["country"]
        
        socketObj.socket.emit("friendrequest",[
        "room":"globalchatroom",
        "userid":loggedUserObj.object,
        "contact":"\(tField.text!)"]
        )
        
        
        //Do some stuff
        
        var addContactUsernameURL=Constants.MainUrl+Constants.addContactByEmail
        
        
        Alamofire.request(.POST,"\(addContactUsernameURL)",headers:header,parameters: ["searchemail":"\(tField.text!)"])
        .validate(statusCode: 200..<300)
        .response { (request1, response1, data1, error1) in
        
        
        print("success")
        
        var json=JSON(data1!)
        //print(json)
        if(json["msg"].string=="null")
        {print("Invalid email")}
        else
        {
        if(json["status"].string=="danger"){
        print("contact already in your list")}
        else
        {print("friend request sent")}
        print(error1)
        
        
        }
        if response1?.statusCode==401
        {
        print("REFRESH TOKEN Neededd Add Contact Username...")
        
        self.rt.refrToken()
        }
        
        }
        print("outttt of sucess parasssss", terminator: "")
        }
        
        actionSheetController.addAction(cancelAction)
        //Create and an option action
        let nextAction: UIAlertAction = UIAlertAction(title: "Add by Username", style: UIAlertActionStyle.Default) { action -> Void in
        
        //var ContactEmail=self.ContactsObjectss[]
        print(loggedUserObj)
        var userid=""
        socketObj.socket.emit("friendrequest",[
        "room":"globalchatroom",
        "userid":loggedUserObj.object,
        "contact":"\(tField.text!)"]
        )
        
        
        //Do some other stuff
        var addContactUsernameURL=Constants.MainUrl+Constants.addContactByUsername
        Alamofire.request(.POST,"\(addContactUsernameURL)",headers:header,parameters: ["searchusername":"\(tField.text!)"]).validate(statusCode: 200..<300).responseJSON{response in
        var response1=response.response
        var request1=response.request
        var data1=response.data
        var error1=response.result.error                //searchemail  f@lkjlklkm.com
        //====================
        dispatch_async(dispatch_get_main_queue(), {
        
        self.dismissViewControllerAnimated(true, completion: nil);
        /// self.performSegueWithIdentifier("loginSegue", sender: nil)
        
        if response1?.statusCode==200 {
        print("success")
        
        var json=JSON(data1!)
        //print(json)
        if(json["msg"].string=="null")
        {print("Invalid user")
        let alert = UIAlertController(title: "Failed", message: "Invalid user", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)}
        else
        {
        if(json["status"].string=="danger"){
        print("contact already in your list")
        let alert = UIAlertController(title: "Failed", message: "Contact already in your list", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
        }
        else
        {print("friend request sent")
        let alert = UIAlertController(title: "Success", message: "Friend request sent", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)}
        }
        }
        else
        {
        print("error in sending friend request")
        }
        })
        if response1?.statusCode==401
        {
        print(error1)
        print("REFRESH TOKEN Neededd Add Contact Username...")
        
        self.rt.refrToken()
        }
        
        
        
        
        }
        
        }
        actionSheetController.addAction(nextAction)
        
        ///////////////
        //CONTACTS from Address Book
        //////////////
        var nextAction2: UIAlertAction = UIAlertAction(title: "Invite Contacts", style: UIAlertActionStyle.Default) { action -> Void in
        ///////contactsList.fetch()
        self.performSegueWithIdentifier("inviteSegue",sender: nil)
        //var newContact=["fname":self.ContactFirstname[0],"lname":self.ContactLastNAme[0],"email":self.ContactsEmail[0],"phone":self.ContactsPhone[0]]
        
        //contactsList.saveToAddressBook(newContact)
        /*
        //var ContactEmail=self.ContactsObjectss[]
        print(loggedUserObj)
        var userid=""
        
        //Do some other stuff
        var inviteContactEmailURL=Constants.MainUrl+Constants.inviteContactsByEmail+"?access_token=\(AuthToken!)"
        Alamofire.request(.POST,"\(inviteContactEmailURL)",parameters: ["emails":""]).validate(statusCode: 200..<300).responseJSON{response in
        var response1=response.response
        }
        */}
        actionSheetController.addAction(nextAction2)
        
        
        //Present the AlertController
        self.presentViewController(actionSheetController, animated: true, completion: nil)
        */
    }
    var ContactsLastMsgDate:[String]=[]
    var ContactLastMessage:[String]=[]
    var ContactNames:[String]=[]
    var ContactUsernames:[String]=[]
    var ContactIDs:[String]=[]
    var ContactFirstname:[String]=[]
    var ContactLastNAme:[String]=[]
    var ContactStatus:[String]=[]
    var ContactsObjectss:[JSON]=[]
    
    var ContactOnlineStatus:[Int]=[]
    ///////////////////////
    /////////NEW//////////////
    //////////////////////////
    var ContactsEmail:[String]=[]
    var ContactsPhone:[String]=[]
    
    //["Bus","Helicopter","Truck","Boat","Bicycle","Motorcycle","Plane","Train","Car","Scooter","Caravan"]
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        //print(AuthToken!)
        
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        // Custom initialization
        
    }
    
    
    
    
    func showError(title:String,message:String,button1:String) {
        
        // create the alert
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        
        // add the actions (buttons)
        alert.addAction(UIAlertAction(title: button1, style: UIAlertActionStyle.Default, handler: nil))
        //alert.addAction(UIAlertAction(title: button2, style: UIAlertActionStyle.Cancel, handler: nil))
        
        // show the alert
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func synchroniseChatData()
    {
        if (self.accountKit!.currentAccessToken != nil) {
            
            header=["kibo-token":self.accountKit!.currentAccessToken!.tokenString]
            
            let _id = Expression<String>("_id")
            let phone = Expression<String>("phone")
            let username1 = Expression<String>("username")
            let status = Expression<String>("status")
            let firstname = Expression<String>("firstname")
            
            
            
            let tbl_accounts = sqliteDB.accounts
            do{for account in try sqliteDB.db.prepare(tbl_accounts) {
                username=account[username1]
                //displayname=account[firstname]
                
                }
            }
            catch
            {
                socketObj.socket.emit("error getting data from accounts table")
                print("error in getting data from accounts table")
                
            }
            
            //  dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) {
            
            
            //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            // if(socketObj != nil)
            // {
            
            self.sendPendingChatMessages({ (result) -> () in
                print("checkin here pending messages sent")
                print("checkin fetching chats")
                if(socketObj != nil)
                {
                    socketObj.fetchChatsFromServer()
                }
                
            })
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Chat ViewController is loadingggggg")
        if(self.accountKit == nil){
            self.accountKit = AKFAccountKit(responseType: AKFResponseType.AccessToken)
        }
        
       
        
        
        
        
        if(socketObj != nil)
        {
            socketObj.delegate=self
        }
        socketObj.socket.on("connect") {data, ack in
            print("connected caught in chat view")
            socketObj.delegate=self
            self.synchroniseChatData()
        }
        
        
        
        if (self.accountKit!.currentAccessToken == nil) {
            
            //specify AKFResponseType.AccessToken
            self.accountKit = AKFAccountKit(responseType: AKFResponseType.AccessToken)
            accountKit.requestAccount{
                (account, error) -> Void in
                
                
                
                
                //**********
                
                if(account != nil){
                    var url=Constants.MainUrl+Constants.getContactsList
                    
                    let header:[String:String]=["kibo-token":(self.accountKit!.currentAccessToken!.tokenString)]
                    
                    print(header)
                    print("in chat got token as \(self.accountKit!.currentAccessToken!.tokenString)")
                    AuthToken=self.accountKit!.currentAccessToken!.tokenString
                    KeychainWrapper.setString(self.accountKit!.currentAccessToken!.tokenString, forKey: "access_token")
                    print("access token key chain sett as \(self.accountKit!.currentAccessToken!.tokenString)")
                    
                    
                }
                
            }}
        else
        {
            
            /*
            dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) {
            // do some task start to show progress wheel
            self.fetchContacts({ (result) -> () in
            //self.fetchContactsFromServer()
            print("checkinnn")
            dispatch_async(dispatch_get_main_queue()) {
            self.tblForChat.reloadData()
            }
            })
            }
            */
            
            /*  header=["kibo-token":self.accountKit!.currentAccessToken!.tokenString]
            
            let _id = Expression<String>("_id")
            let phone = Expression<String>("phone")
            let username1 = Expression<String>("username")
            let status = Expression<String>("status")
            let firstname = Expression<String>("firstname")
            
            
            
            let tbl_accounts = sqliteDB.accounts
            do{for account in try sqliteDB.db.prepare(tbl_accounts) {
            username=account[username1]
            //displayname=account[firstname]
            
            }
            }
            catch
            {
            socketObj.socket.emit("error getting data from accounts table")
            print("error in getting data from accounts table")
            
            }
            
            //  dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) {
            
            
            //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            // if(socketObj != nil)
            // {
            
            self.sendPendingChatMessages({ (result) -> () in
            print("checkin here pending messages sent")
            print("checkin fetching chats")
            if(socketObj != nil)
            {
            socketObj.fetchChatsFromServer()
            }
            
            })
            */
            
            // }
            
            
            // }
        }
        
        
        
        
        /*
        if(displayname=="")
        {
        
        
        let _id = Expression<String>("_id")
        let phone = Expression<String>("phone")
        let username1 = Expression<String>("username")
        let status = Expression<String>("status")
        let firstname = Expression<String>("firstname")
        
        
        
        let tbl_accounts = sqliteDB.accounts
        do{for account in try sqliteDB.db.prepare(tbl_accounts) {
        username=account[username1]
        displayname=account[firstname]
        
        }
        }
        catch
        {
        socketObj.socket.emit("error getting data from accounts table")
        print("error in getting data from accounts table")
        
        }
        
        
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) {
        print("checkin here .....")
        //////////self.getCurrentUserDetails({ (result) -> () in
        //dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) {
        print("checkin here1 .....")
        self.sendPendingChatMessages({ (result) -> () in
        print("checkin here2 .....")
        /////dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) {
        print("checkin here3 .....")
        self.fetchChatsFromServer({ (result) -> () in
        print("checkin here4 .....")
        
        })
        
        ///// }
        
        })
        }
        
        //}
        //})
        }
        
        
        */
        /*dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) {
        // do some task start to show progress wheel
        self.fetchContacts({ (result) -> () in
        //self.fetchContactsFromServer()
        //dispatch_async(dispatch_get_main_queue()) {
        self.tblForChat.reloadData()
        //}
        })
        }
        */
        
        
        
        //}
        
        
        
        
        
        //var lll=self.storyboard?.instantiateViewControllerWithIdentifier("mainpage") as! LoginViewController
        
        
        /*if(isSocketConnected==false)
        {
        lll.progressWheel.startAnimating()
        lll.progressWheel.hidden=false
        }
        if(isSocketConnected==true)
        {
        lll.progressWheel.stopAnimating()
        lll.progressWheel.hidden=true
        }*/
        
        /*if(socketConnected == false)
        {            socketObj.socket.connect(timeoutAfter: 5000) { () -> Void in
        
        socketObj.socket.reconnect()
        
        }
        }*/
        
        
        var retrievedToken=KeychainWrapper.stringForKey("access_token")
        print("retrieved token === \(retrievedToken)")
        print("khul raha hai2", terminator: "")
        print(loggedUserObj.object)
        
        
        if(KeychainWrapper.stringForKey("username") != nil)
        {print("delegate added in chat")
            currrentUsernameRetrieved=KeychainWrapper.stringForKey("username")!
            print("currrentUsernameRetrieved is \(currrentUsernameRetrieved)")
            if(socketObj != nil){
                socketObj.delegate=self
            }
            if(loggedUserObj == JSON("[]"))
            {
                
                
            }
            
        }//end if username definned
        
        print("loadddddd", terminator: "")
        
        
        
        self.navigationItem.titleView = viewForTitle
        /////self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: btnForLogo)
        //self.navigationItem.rightBarButtonItem = itemForSearch
        
        ///////self.navigationItem.leftBarButtonItem = editButtonItem()
        self.navigationItem.rightBarButtonItem = btnContactAdd
        self.tabBarController?.tabBar.tintColor = UIColor.greenColor()
        print("////////////////////// new class tokn \(AuthToken)", terminator: "")
        // fetchContacts(AuthToken)
        print(self.ContactNames.count.description, terminator: "")
        // self.tblForChat.reloadData()
        
        
        
        //========
        /*socketObj.socket.on("online")
        {data,ack in
        
        print("online status...")
        var onlineUsers=JSON(data)
        print(onlineUsers[0])
        //print(onlineUsers[0]["username"])
        
        for(var i=0;i<onlineUsers.count;i++)
        {
        for(var j=0;j<self.ContactUsernames.count;j++)
        {
        if self.ContactIDs[j]==onlineUsers[i]["_id"].string!
        {
        //found online contact,s username
        print("user found onlineeeee \(self.ContactUsernames[j])")
        self.ContactOnlineStatus[j]=1
        self.tblForChat.reloadData()
        }
        }
        }
        
        }
        */
        
        
        
        
        //======Offline users=========
        /*socketObj.socket.on("offline")
        {data,ack in
        
        print("offline status...")
        var offlineUsers=JSON(data)
        print(offlineUsers[0])
        //print(offlineUsers[0]["username"])
        
        for(var i=0;i<offlineUsers.count;i++)
        {
        for(var j=0;j<self.ContactUsernames.count;j++)
        {
        if self.ContactUsernames[j]==offlineUsers[i]["phone"].string!
        {
        //found online contact,s username
        print("user found offlinee \(self.ContactUsernames[j])")
        self.ContactOnlineStatus[j]=0
        self.tblForChat.reloadData()
        }
        }
        }
        
        }*/
        
        
        //-----------------------NEW TRY FROM APPEAR TO HERE -------------
        if(socketObj.delegateSocketConnected == nil && isSocketConnected==true)
        {
            socketObj.delegateSocketConnected=self
        }
        //%%%%%% new phone model add
        
        
        ////////////*******  if(AuthToken != nil)
        
        //already logged in
        
        
        /////workingg next time
        /* dispatch_sync(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) {
        // do some task start to show progress wheel
        self.fetchContacts({ (result) -> () in
        //self.fetchContactsFromServer()
        // dispatch_async(dispatch_get_main_queue()) {
        //dispatch_async(dispatch_get_main_queue)
        self.tblForChat.reloadData()
        //}
        // })
        
        })
        }*/
    }
    
    func loginSegueMethod()
    {print("line # 564")
        self.performSegueWithIdentifier("loginSegue", sender: nil)
    }
    func socketConnected() {
        if((self.view.window != nil) && self.isViewLoaded()){
            /* var lll=self.storyboard?.instantiateViewControllerWithIdentifier("mainpage") as! LoginViewController
            
            lll.progressWheel.stopAnimating()
            lll.progressWheel.hidden=true*/
            print("progressWheel hidden")
            //**** neww may 2016 added
            socketObj.delegate=self
        }
        
    }
    
    
    func progressBarDisplayer(msg:String, _ indicator:Bool ) {
        print(msg)
        strLabel = UILabel(frame: CGRect(x: 50, y: 0, width: 250, height: 50))
        strLabel.text = msg
        strLabel.textColor = UIColor.whiteColor()
        messageFrame = UIView(frame: CGRect(x: view.frame.midX - 110, y: view.frame.midY - 25 , width: 230, height: 50))
        messageFrame.layer.cornerRadius = 15
        messageFrame.backgroundColor = UIColor(white: 0, alpha: 0.7)
        if indicator {
            activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.White)
            activityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
            activityIndicator.startAnimating()
            messageFrame.addSubview(activityIndicator)
        }
        messageFrame.addSubview(strLabel)
        view.addSubview(messageFrame)
    }
    
    func progressBarDisplayer2(msg:String, _ indicator:Bool ) {
        print(msg)
        strLabel2 = UILabel(frame: CGRect(x: 50, y: 0, width: 250, height: 50))
        strLabel2.text = msg
        strLabel2.textColor = UIColor.whiteColor()
        messageFrame2 = UIView(frame: CGRect(x: view.frame.midX - 110, y: view.frame.midY - 25 , width: 230, height: 50))
        messageFrame2.layer.cornerRadius = 15
        messageFrame2.backgroundColor = UIColor(white: 0, alpha: 0.7)
        if indicator {
            activityIndicator2 = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.White)
            activityIndicator2.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
            activityIndicator2.startAnimating()
            messageFrame2.addSubview(activityIndicator2)
        }
        messageFrame2.addSubview(strLabel2)
        view.addSubview(messageFrame2)
    }
    
    override func viewWillAppear(animated: Bool) {
        print("appearrrrrr", terminator: "")
        
        if(socketObj != nil)
        {
            socketObj.delegate=self
        }
        if(socketObj.delegateSocketConnected == nil && isSocketConnected==true)
        {
            socketObj.delegateSocketConnected=self
        }
        //%%%%%% new phone model add
        
        
        //////////// *******  if(AuthToken != nil)
        
        //already logged in
        if(accountKit.currentAccessToken != nil)
        {
            header=["kibo-token":self.accountKit!.currentAccessToken!.tokenString]
            
            socketObj.socket.emit("logClient", "fetching contacts from iphone")
            
            
            //dont do on every appear. just do once
            print("emaillist is \(emailList.first)")
            print("emailList count is \(emailList.count)")
            
            dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) {
                // do some task start to show progress wheel
                self.fetchContacts({ (result) -> () in
                    //self.fetchContactsFromServer()
                    print("checkinnn")
                    dispatch_async(dispatch_get_main_queue()) {
                        self.tblForChat.reloadData()
                    }
                })
            }
            
            
            /* dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) {
            // do some task start to show progress wheel
            self.fetchContacts({ (result) -> () in
            //self.fetchContactsFromServer()
            print("checkinnn")
            dispatch_async(dispatch_get_main_queue()) {
            self.tblForChat.reloadData()
            }
            })
            }*/
            
            /*dispatch_sync(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) {
            // do some task start to show progress wheel
            self.fetchContacts({ (result) -> () in
            //self.fetchContactsFromServer()
            dispatch_async(dispatch_get_main_queue()) {
            self.tblForChat.reloadData()
            }
            })
            }*/
            
            //if(emailList.count<1)
            //{
            
            
            
            /*
            dispatch_sync(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) {
            // do some task start to show progress wheel
            self.fetchContacts({ (result) -> () in
            //self.fetchContactsFromServer()
            dispatch_async(dispatch_get_main_queue()) {
            //dispatch_async(dispatch_get_main_queue)
            self.tblForChat.reloadData()
            }
            })
            }*/
            
            
            // dispatch_async(dispatch_get_main_queue(), {
            ///////////newwwwwwwwwwwww
            //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            /*if(displayname=="")
            {
            dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) {
            
            self.getCurrentUserDetails({ (result) -> () in
            //dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) {
            self.sendPendingChatMessages({ (result) -> () in
            
            dispatch_async(dispatch_get_global_queue(QOS_CLASS_UTILITY, 0)) {
            
            self.fetchChatsFromServer({ (result) -> () in
            
            
            })
            
            }
            
            })
            
            //}
            })}
            
            /*dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) {
            // do some task start to show progress wheel
            self.fetchContacts({ (result) -> () in
            //self.fetchContactsFromServer()
            //dispatch_async(dispatch_get_main_queue()) {
            self.tblForChat.reloadData()
            //}
            })
            }
            */
            
            
            
            }*/
            
            
            
            if(displayname=="")
            {
                
                
                
                let _id = Expression<String>("_id")
                let phone = Expression<String>("phone")
                let username1 = Expression<String>("username")
                let status = Expression<String>("status")
                let firstname = Expression<String>("firstname")
                
                
                
                let tbl_accounts = sqliteDB.accounts
                do{for account in try sqliteDB.db.prepare(tbl_accounts) {
                    username=account[username1]
                    displayname=account[firstname]
                    
                    }
                }
                catch
                {
                    socketObj.socket.emit("error getting data from accounts table")
                    print("error in getting data from accounts table")
                    
                }
                
                
                
                /*
                dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) {
                // do some task start to show progress wheel
                self.fetchContacts({ (result) -> () in
                //self.fetchContactsFromServer()
                print("checkinnn")
                // dispatch_async(dispatch_get_main_queue()) {
                self.tblForChat.reloadData()
                // }
                })
                }*/
                
                //
                
                
                
                var dispatch_group_t = dispatch_group_create();
                // let queue = dispatch_queue_create("com.cnoon.manager-response-queue", DISPA)
                
                //dispatch_async(queue)
                //  dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0))
                // {
                
                
                /*
                dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) {
                
                self.sendPendingChatMessages({ (result) -> () in
                print("checkin here pending messages sent")
                print("checkin fetching chats")
                if(socketObj != nil)
                {
                socketObj.fetchChatsFromServer()
                }
                
                })
                }
                
                */
                //  }
                // dispatch_group_async(group,
                
                // dispatch_group_async(dispatch_group_t,dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0)) {
                //
                /* dispatch_group_async(dispatch_group_t,queue) {
                // block1
                // NSLog(@"Block1");
                //[NSThread sleepForTimeInterval:5.0];
                // NSLog(@"Block1 End");
                self.sendPendingChatMessages({ (result) -> () in
                print("checkin here pending messages sent")
                print("checkin fetching chats")
                self.fetchChatsFromServer()
                //self.fetchChatsFromServer({ (result) -> () in
                //   print("checkin here fertched chat")
                
                })
                //})
                }
                */
                
                /*  let queue = dispatch_queue_create("com.cnoon.manager-response-queue", DISPATCH_QUEUE_CONCURRENT)
                
                dispatch_group_notify(dispatch_group_t,queue) {
                print("checkin fetching chats")
                self.fetchChatsFromServer()
                // self.fetchChatsFromServer({ (result) -> () in
                //    print("checkin here fertched chat")
                
                //})
                
                }
                */
                
                
                /*dispatch_group_async(dispatch_group_t,dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)){
                // block2
                //NSLog(@"Block2");
                // [NSThread sleepForTimeInterval:8.0];
                //NSLog(@"Block2 End");
                
                }*/
                
                //dispatch_group_notify(dispatch_group_t,dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0)){
                /*  dispatch_group_async(dispatch_group_t,dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0)) {
                
                print("checkin here fetching chat from server")
                // block3
                // NSLog(@"Block3");
                
                self.fetchChatsFromServer({ (result) -> () in
                print("checkin here fertched chat")
                
                })
                }*/
                
                // only for non-ARC projects, handled automatically in ARC-enabled projects.
                //    dispatch_release(dispatch_group_t);
                
                
                
                /*  dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) {
                
                self.getCurrentUserDetails({ (result) -> () in
                //dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) {
                self.sendPendingChatMessages({ (result) -> () in
                
                // dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) {
                
                self.fetchChatsFromServer({ (result) -> () in
                
                
                })
                //}
                })
                
                //}
                })}
                
                */
                /*
                ////dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) {
                dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0)) {
                print("checkin here .....")
                //////////self.getCurrentUserDetails({ (result) -> () in
                //dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) {
                print("checkin here1 .....")
                self.sendPendingChatMessages({ (result) -> () in
                print("checkin here2 .....")
                //QOS_CLASS_BACKGROUND
                //dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0)) {
                //print("checkin here3 .....")
                self.fetchChatsFromServer({ (result) -> () in
                print("checkin here3 .....")
                
                })
                
                //}
                
                })
                }
                */
                
                //}
                //})
            }
            
            
            //}
        }
            
            // ******************%%%%%%%%% addition new
        else
        {
            // *********%%%%%%%%%%%%% Not logged in
            socketObj.socket.emit("logClient","IPHONE-LOG: access token is nil so go to login page")
            print("access token is nil so go to login page")
            self.performSegueWithIdentifier("loginSegue", sender: self)
        }
        
        
        
    }
    
    func sendPendingChatMessages(completion:(result:Bool)->())
    {
        print("checkin here inside pending chat messages.....")
        var userchats=sqliteDB.userschats
        var userchatsArray:Array<Row>
        
        
        
        let to = Expression<String>("to")
        let from = Expression<String>("from")
        let owneruser = Expression<String>("owneruser")
        let fromFullName = Expression<String>("fromFullName")
        let msg = Expression<String>("msg")
        let date = Expression<String>("date")
        let status = Expression<String>("status")
        let uniqueid = Expression<String>("uniqueid")
        
        
        
        var tbl_userchats=sqliteDB.userschats
        //var res=tbl_userchats.filter(to==selecteduser || from==selecteduser)
        //to==selecteduser || from==selecteduser
        //print("chat from sqlite is")
        //print(res)
        do
        {
            var count=0
            for pendingchats in try sqliteDB.db.prepare(tbl_userchats.filter(status=="pending"))
            {
                print("pending chats count is \(count)")
                count++
                var imParas=["from":pendingchats[from],"to":pendingchats[to],"fromFullName":pendingchats[fromFullName],"msg":pendingchats[msg],"uniqueid":pendingchats[uniqueid]]
                
                print("imparas are \(imParas)")
                print(imParas, terminator: "")
                print("", terminator: "")
                
                
                socketObj.socket.emitWithAck("im",["room":"globalchatroom","stanza":imParas])(timeoutAfter: 1500000)
                    {data in
                        print("chat ack received \(data)")
                        // statusNow="sent"
                        var chatmsg=JSON(data)
                        print(data[0])
                        print(chatmsg[0])
                        sqliteDB.UpdateChatStatus(chatmsg[0]["uniqueid"].string!, newstatus: chatmsg[0]["status"].string!)
                        
                }
                
                
                
                
                
            }
            //var count=0
            var tbl_messageStatus=sqliteDB.statusUpdate
            let status = Expression<String>("status")
            let sender = Expression<String>("sender")
            let uniqueid = Expression<String>("uniqueid")
            
            for statusMessages in try sqliteDB.db.prepare(tbl_messageStatus)
            {
                
                socketObj.socket.emitWithAck("messageStatusUpdate", ["status":statusMessages[status],"uniqueid":statusMessages[uniqueid],"sender": statusMessages[sender]])(timeoutAfter: 15000){data in
                    var chatmsg=JSON(data)
                    
                    print(data[0])
                    print(data[0]["uniqueid"]!!)
                    print(data[0]["uniqueid"]!!.debugDescription!)
                    print(chatmsg[0]["uniqueid"].string!)
                    //print(data[0]["status"]!!.string!+" ... "+data[0]["uniqueid"]!!.string!)
                    print("chat status seen emitted which were pending")
                    sqliteDB.removeMessageStatusSeen(data[0]["uniqueid"]!!.debugDescription!)
                    socketObj.socket.emit("logClient","\(username) pending seen statuses emitted")
                    
                }

                
            }
            socketObj.socket.emit("logClient","IPHONE-LOG: \(username!) done sending pending chat messages")
            return completion(result: true)
            //// return completion(result: true)
        }
        catch
        {
            print("error in pending chat fetching")
            socketObj.socket.emit("logClient","IPHONE-LOG: \(username!) error in sending pending chat messages")
            return completion(result: false)
        }
        
        
    }
    
    //=====================================
    //to fetch contacts from SQLite db
    
    func saveAllChat(UserchatJson:JSON,completion: (result:Bool)->())
    {
        for var i=0;i<UserchatJson["msg"].count;i++
        {
            sqliteDB.SaveChat(UserchatJson["msg"][i]["to"].string!, from1: UserchatJson["msg"][i]["from"].string!,owneruser1:UserchatJson["msg"][i]["owneruser"].string! , fromFullName1: UserchatJson["msg"][i]["fromFullName"].string!, msg1: UserchatJson["msg"][i]["msg"].string!,date1:UserchatJson["msg"][i]["date"].string!,uniqueid1: UserchatJson["msg"][i]["uniqueid"].string!,status1: UserchatJson["msg"][i]["status"].string!)
            
            
            
        }
        completion(result: true)
    }
    
    func fetchContacts(completion:(result:Bool)->()){
        socketObj.socket.emit("logClient","IPHONE-LOG: fetch contacts from sqlite database")
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
        
        
        let to = Expression<String>("to")
        let from = Expression<String>("from")
        let date = Expression<String>("date")
        let msg = Expression<String>("msg")
        let contactPhone = Expression<String>("contactPhone")
        contactPhone
        //-========Remove old values=====================
        ContactsLastMsgDate.removeAll(keepCapacity: false)
        self.ContactLastMessage.removeAll(keepCapacity: false)
        self.ContactIDs.removeAll(keepCapacity: false)
        self.ContactLastNAme.removeAll(keepCapacity: false)
        self.ContactNames.removeAll(keepCapacity: false)
        self.ContactStatus.removeAll(keepCapacity: false)
        self.ContactUsernames.removeAll(keepCapacity: false)
        self.ContactsObjectss.removeAll(keepCapacity: false)
        ////////////////////////
        self.ContactFirstname.removeAll(keepCapacity: false)
        ////////
        
        self.ContactsPhone.removeAll(keepCapacity: false)
        self.ContactsEmail.removeAll(keepCapacity: false)
        
        /*
        let stmt = try db.prepare("SELECT id, email FROM users")
        for row in stmt {
        for (index, name) in stmt.columnNames.enumerate() {
        print ("\(name)=\(row[index]!)")
        // id: Optional(1), email: Optional("alice@mac.com")
        }
        }
        
         SELECT date, contact_phone, display_name, msg, contacts._id FROM userchat, contacts WHERE contacts.phone = userchat.contact_phone GROUP BY contact_phone ORDER BY date DESC
        
        SELECT firstname,to,lastname,username,contactid,status,email,phone from tbl_contactslists,tbl_userchats WHERE tbl_contactslists.phone==tbl_userchats.to GROUP BY to
        
        for row in stmt {
        for (index, name) in stmt.columnNames.enumerate() {
        print ("\(name)=\(row[index]!)")
        // id: Optional(1), email: Optional("alice@mac.com")
        }
        }
        
        
        
        let query = prices.select(defindex, average(price))
        .filter(quality == 5 && price_index != 0)
        .group(defindex)
        .order(average(price).desc)
        let rows = Array(query)
        
        SELECT firstname,to,lastname,username,contactid,status,email,phone from tbl_contactslists,tbl_userchats WHERE tbl_contactslists.phone==tbl_userchats.to GROUP BY to
        */
         let tbl_userchats=sqliteDB.userschats
        let tbl_contactslists=sqliteDB.contactslists
        
        let myquery=tbl_contactslists.join(tbl_userchats, on: tbl_contactslists[phone] == tbl_userchats[contactPhone]).group(tbl_userchats[contactPhone]).order(date.desc)
        
        
        do{for ccc in try sqliteDB.db.prepare(myquery) {
            print(ccc[phone])
            print(ccc[msg])
            print(ccc[date])
            print("*************")
            ContactNames.append(ccc[firstname]+" "+ccc[lastname])
            //ContactUsernames.append(ccc[username])
            print("ContactUsernames is \(ccc[username])")
            // %%%%%%%%%%%%%%%%************ CHAT BUG ID %%%%%%%%%%%
            ContactIDs.append(ccc[contactid])
            // ContactIDs.append(tblContacts[userid])
            ContactFirstname.append(ccc[firstname])
            ContactLastNAme.append(ccc[lastname])
            ContactStatus.append("Hey there! I am using Kibo App")
            ContactUsernames.append(ccc[phone])
            ContactsEmail.append(ccc[email])
            ContactsPhone.append(ccc[phone])
            ContactOnlineStatus.append(0)
            ContactLastMessage.append(ccc[msg])
            ContactsLastMsgDate.append(ccc[date])
            
            }
              return completion(result:true)
        }
            catch
            {
                print("error here")
            }
        
        
        // %%% workingg "SELECT msg,phone from userschats,contactslists WHERE contactslists.phone!=userschats.owneruser GROUP BY contactslists.phone"
        
        
       /*
        print("user chat join query here:")
        do{let stmt = try sqliteDB.db.prepare("SELECT msg,phone,fromFullName,userschats.owneruser from userschats,contactslists WHERE contactslists.phone!=userschats.owneruser GROUP BY userschats.fromFullName ORDER BY date DESC")
        for row in stmt {
            for (index, name) in stmt.columnNames.enumerate() {
                print ("\(name)=\(row[index]!)")
                                // id: Optional(1), email: Optional("alice@mac.com")
            }
            print(".......")

        }
        }
        catch(let e)
        {
print("query join error 1337 \(e)")
}
*/
        
        //%%% PREVIOUS WORKING
        /*
        
        do{
            for tblContacts in try sqliteDB.db.prepare(tbl_contactslists){
                print("queryy runned count is \(tbl_contactslists.count)")
                print(tblContacts[firstname]+" "+tblContacts[lastname])
                //ContactsObjectss.append(tblContacts[contactid])
                ContactNames.append(tblContacts[firstname]+" "+tblContacts[lastname])
                ContactUsernames.append(tblContacts[username])
                print("ContactUsernames is \(tblContacts[username])")
                // %%%%%%%%%%%%%%%%************ CHAT BUG ID %%%%%%%%%%%
                ContactIDs.append(tblContacts[contactid])
                // ContactIDs.append(tblContacts[userid])
                ContactFirstname.append(tblContacts[firstname])
                ContactLastNAme.append(tblContacts[lastname])
                ContactStatus.append(tblContacts[status])
                ContactsEmail.append(tblContacts[email])
                ContactsPhone.append(tblContacts[phone])
                ContactOnlineStatus.append(0)
                
            }
            
            return completion(result:true)
        }catch
        {
            print("query not runned contactlist")
            return completion(result:false)
        }
        */
        
    }
    
    
    //======================================
    //to fetch contacts from server
    
    func fetchContactsFromServer(completion:(result:Bool)->()){
        print("Server fetchingg contactss", terminator: "")
        socketObj.socket.emit("logClient","IPHONE-LOG: fetch contacts from server")
        if(loggedUserObj == JSON("[]"))
        {
        }
        
        //%%%%% new phone model
        //var fetchChatURL=Constants.MainUrl+Constants.getContactsList+"?access_token="+AuthToken!
        
        var fetchChatURL=Constants.MainUrl+Constants.getContactsList
        
        print(fetchChatURL, terminator: "")
        
        //%%%%% new phone model
        //Alamofire.request(.GET,"\(fetchChatURL)").validate(statusCode: 200..<300)
        header=["kibo-token":self.accountKit!.currentAccessToken!.tokenString]
        print("header iss \(header)")
        Alamofire.request(.GET,"\(fetchChatURL)",headers:header).validate(statusCode: 200..<300)
            .response { (request1, response1, data1, error1) in
                
                
                
                
                if response1?.statusCode==200 {
                    //============GOT Contacts SECCESS=================
                    
                    
                    print("success successfully received friends list from server")
                    socketObj.socket.emit("logClient","IPHONE-LOG:  successfully received friends list from server")
                    if(globalChatRoomJoined == false)
                    {
                        //socketObj.addHandlers()
                        print("joiningggggg")
                        
                        
                    }
                    //print("Contacts fetched success")
                    let contactsJsonObj = JSON(data: data1!)
                    print(contactsJsonObj)
                    //print(contactsJsonObj["userid"])
                    //let contact=JSON(contactsJsonObj["contactid"])
                    //   print(contact["firstname"])
                    print("Contactsss fetcheddddddd")
                    //var userr=contactsJsonObj["userid"]
                    // print(self.contactsJsonObj.count)
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
                    do{try sqliteDB.db.run(tbl_contactslists.delete())}catch{
                        print("contactslist table not deleted")
                    }
                    ////////////////
                    ///tbl_contactslists.delete() //complete refresh
                    ////////////////////////////////////////COUNTTTTTTT
                    print(sqliteDB.contactslists.count)
                    
                    //-========Remove old values=====================
                    // ***************%%%%%%%%%%%%%%%%%%% newww june
                    
                    self.ContactIDs.removeAll(keepCapacity: false)
                    self.ContactLastNAme.removeAll(keepCapacity: false)
                    self.ContactNames.removeAll(keepCapacity: false)
                    self.ContactStatus.removeAll(keepCapacity: false)
                    self.ContactUsernames.removeAll(keepCapacity: false)
                    self.ContactsObjectss.removeAll(keepCapacity: false)
                    self.ContactsEmail.removeAll(keepCapacity: false)
                    self.ContactsPhone.removeAll(keepCapacity: false)
                    //////////
                    self.ContactFirstname.removeAll(keepCapacity: false)
                    
                    //////
                    for var i=0;i<contactsJsonObj.count;i++
                    {
                        print("inside for loop")
                        do {
                            if(contactsJsonObj[i]["contactid"]["username"].string != nil)
                            {
                                print("inside username hereeeeeee")
                                let rowid = try sqliteDB.db.run(tbl_contactslists.insert(contactid<-contactsJsonObj[i]["contactid"]["_id"].string!,
                                    detailsshared<-contactsJsonObj[i]["detailsshared"].string!,
                                    
                                    unreadMessage<-contactsJsonObj[i]["unreadMessage"].boolValue,
                                    
                                    userid<-contactsJsonObj[i]["userid"].string!,
                                    firstname<-contactsJsonObj[i]["contactid"]["firstname"].string!,
                                    lastname<-contactsJsonObj[i]["contactid"]["lastname"].string!,
                                    email<-contactsJsonObj[i]["contactid"]["email"].string!,
                                    phone<-contactsJsonObj[i]["contactid"]["phone"].string!,
                                    username<-contactsJsonObj[i]["contactid"]["username"].string!,
                                    status<-contactsJsonObj[i]["contactid"]["status"].string!)
                                )
                                print("data inserttt")
                                
                                //=========this is done in fetching from sqlite not here====
                                
                                
                                // %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%new commented june
                                self.ContactsObjectss.append(contactsJsonObj[i]["contactid"])
                                // ****%%%%% database changes new june
                                self.ContactNames.append(contactsJsonObj[i]["contactid"]["phone"].string!)
                                
                                //self.ContactNames.append(contactsJsonObj[i]["contactid"]["firstname"].string!+" "+contactsJsonObj[i]["contactid"]["lastname"].string!)
                                self.ContactUsernames.append(contactsJsonObj[i]["contactid"]["phone"].string!)
                                self.ContactIDs.append(contactsJsonObj[i]["contactid"]["_id"].string!)
                                self.ContactFirstname.append(contactsJsonObj[i]["contactid"]["firstname"].string!)
                                self.ContactLastNAme.append(contactsJsonObj[i]["contactid"]["lastname"].string!)
                                self.ContactStatus.append(contactsJsonObj[i]["contactid"]["status"].string!)
                                self.ContactsPhone.append(contactsJsonObj[i]["contactid"]["phone"].string!)
                                self.ContactsEmail.append(contactsJsonObj[i]["contactid"]["email"].string!)
                                self.ContactOnlineStatus.append(0)
                                
                                print("inserted id: \(rowid)")
                            }
                            else
                            {
                                print("inside displayname hereeeeeee")
                                
                                
                                let rowid = try sqliteDB.db.run(tbl_contactslists.insert(contactid<-contactsJsonObj[i]["contactid"]["_id"].string!,
                                    detailsshared<-contactsJsonObj[i]["detailsshared"].string!,
                                    
                                    unreadMessage<-contactsJsonObj[i]["unreadMessage"].boolValue,
                                    
                                    userid<-contactsJsonObj[i]["userid"].string!,
                                    firstname<-contactsJsonObj[i]["contactid"]["display_name"].string!,
                                    lastname<-"",
                                    
                                    //lastname<-contactsJsonObj[i]["contactid"]["lastname"].string!,
                                    email<-"@",
                                    phone<-contactsJsonObj[i]["contactid"]["phone"].string!,
                                    username<-contactsJsonObj[i]["contactid"]["phone"].string!,
                                    status<-contactsJsonObj[i]["contactid"]["status"].string!)
                                )
                                print("data inserttt")
                                
                                //=========this is done in fetching from sqlite not here====
                                
                                
                                // %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%new commented june
                                self.ContactsObjectss.append(contactsJsonObj[i]["contactid"])
                                // ****%%%%% database changes new june
                                self.ContactNames.append(contactsJsonObj[i]["contactid"]["phone"].string!)
                                
                                //self.ContactNames.append(contactsJsonObj[i]["contactid"]["firstname"].string!+" "+contactsJsonObj[i]["contactid"]["lastname"].string!)
                                //self.ContactUsernames.append(contactsJsonObj[i]["contactid"]["display_name"].string!)
                                self.ContactUsernames.append(contactsJsonObj[i]["contactid"]["phone"].string!)
                                
                                self.ContactIDs.append(contactsJsonObj[i]["contactid"]["_id"].string!)
                                self.ContactFirstname.append(contactsJsonObj[i]["contactid"]["display_name"].string!)
                                self.ContactLastNAme.append("")
                                self.ContactStatus.append(contactsJsonObj[i]["contactid"]["status"].string!)
                                self.ContactsPhone.append(contactsJsonObj[i]["contactid"]["phone"].string!)
                                self.ContactsEmail.append("@")
                                self.ContactOnlineStatus.append(0)
                                
                                print("inserted id: \(rowid)")
                                
                            }
                            dispatch_async(dispatch_get_main_queue())
                                {
                                    self.tblForChat.reloadData()
                            }
                            
                        } catch {
                            print("insertion failed: \(error)")
                        }
                        
                    }
                    
                    print("contacts fetchedddddddddddddd sucecess")
                    
                    
                    completion(result:true)
                    
                }else{
                    
                    completion(result:false)
                    
                    print("error: \(error1!.localizedDescription)")
                    socketObj.socket.emit("logClient", "error: \(error1!.localizedDescription)")
                    print(error1)
                    print(response1?.statusCode)
                    print("FETCH CONTACTS FAILED")
                    print("eeeeeeeeeeeeeeeeeeeeee")
                    
                }
                if(response1?.statusCode==401)
                {
                    socketObj.socket.emit("logClient", "error: \(error1!.localizedDescription)")
                    print("Refreshinggggggggggggggggggg token expired")
                    if(username==nil || password==nil)
                    {print("line # 1074")
                        self.performSegueWithIdentifier("loginSegue", sender: nil)
                    }
                    else{
                        self.rt.refrToken()
                    }
                    
                }
                
        }
        
        
        
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func unwindToChat (segueSelected : UIStoryboardSegue) {
        print("unwind chat", terminator: "")
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //refreshControl.addTarget(self, action: Selector("fetchContacts"), forControlEvents: UIControlEvents.ValueChanged)
        
        // print(ContactNames.count, terminator: "")
        return ContactUsernames.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView!) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        
        /* if (indexPath.row%2 == 0){
        return tblForChat.dequeueReusableCellWithIdentifier("ChatPrivateCell") as! UITableViewCell
        } else {
        return tblForChat.dequeueReusableCellWithIdentifier("ChatPublicCell")as! UITableViewCell
        }
        */
        //let cellPublic=tblForChat.dequeueReusableCellWithIdentifier("ChatPublicCell") as! ContactsListCell
        
        let cell=tblForChat.dequeueReusableCellWithIdentifier("ChatPrivateCell") as! ContactsListCell
        
        var contactFound=false
        ////%%%%%%%%%%%%%cell.contactName?.text=ContactNames[indexPath.row]
        
        /*
        let query = users.join(posts, on: user_id == users[id])
        // SELECT * FROM "users" INNER JOIN "posts" ON ("user_id" = "users"."id")
        
        select * from contacts
        
        */
        var allcontacts=sqliteDB.allcontacts
        var contactsKibo=sqliteDB.contactslists
        
        
        let phone = Expression<String>("phone")
        let usernameFromDb = Expression<String?>("username")
        let name = Expression<String?>("name")
        cell.statusPrivate.text=ContactLastMessage[indexPath.row]
        cell.lbltimePrivate.text=ContactsLastMsgDate[indexPath.row]
      //  do
       //// {allkiboContactsArray = Array(try sqliteDB.db.prepare(contactsKibo))
            do{for all in try sqliteDB.db.prepare(allcontacts) {
                //print("id: \(account[_id]), phone: \(account[phone]), firstname: \(account[firstname])")
                // id: 1, email: alice@mac.com, name: Optional("Alice")
                
                //if(all[phone]==allkiboContactsArray[indexPath.row][username])
                if(all[phone]==ContactUsernames[indexPath.row])
                    
                {
                    //Matched phone number. Got contact
                    if(all[name] != "" || all[name] != nil)
                    {
                        cell.contactName?.text=all[name]
                        print("name is \(all[name])")
                        ContactNames[indexPath.row]=all[name]!
                    }
                    else
                    {
                        print("name is no name")
                        cell.contactName?.text=all[phone]
                    }
                    contactFound=true
                    
                    
                }
                
                }
                
            }
            catch
            {
                socketObj.socket.emit("logClient","error in fetching contacts from database..")
                print("error in fetching contacts from database..")
            }
            if(contactFound==false)
            {
                cell.contactName?.text=ContactUsernames[indexPath.row]
            }
            
            
       // }
      //  catch
        //{
        //    socketObj.socket.emit("logClient","error in getching contactss and making one array")
        //    print("error in getching contactss and making one array")
        //}
        
        
        /*
        for(var i=0;i<contacts.count;i++)
        {
        if(contacts[i].isKeyAvailable(CNContactPhoneNumbersKey)) {
        for phoneNumber:CNLabeledValue in contacts[i].phoneNumbers {
        let a = phoneNumber.value as! CNPhoneNumber
        //print("\()
        var phone=a.valueForKey("digits") as! String
        if(phone==ContactUsernames[indexPath.row])
        {
        //Matched phone number. Got contact
        if(contacts[i].givenName != "" || contacts[i].familyName != "")
        {
        cell.contactName?.text=contacts[i].givenName+" "+contacts[i].familyName
        print("name is \(contacts[i].givenName+" "+contacts[i].familyName)")
        ContactNames[indexPath.row]=contacts[i].givenName+" "+contacts[i].familyName
        }
        else
        {
        print("name is no name")
        cell.contactName?.text=phone
        }
        contactFound=true
        
        }
        }
        }
        if(contactFound==false)
        {
        cell.contactName?.text=ContactUsernames[indexPath.row]
        }
        }*/
        
        
        // %%%%%%%%%%%%%%%%%%%%%%%%%_------------------------- need to show names also ------
        
        
        
        
        
        if ContactOnlineStatus[indexPath.row]==0
        {
            cell.btnGreenDot.hidden=true
        }
        else
        {
            cell.btnGreenDot.hidden=false
        }
        
        
        return cell
        
    }
    
    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!){
        
        //let indexPath = tableView.indexPathForSelectedRow();
        //let currentCell = tableView.cellForRowAtIndexPath(indexPath!) as UITableViewCell!;
        
        print(ContactNames[indexPath.row], terminator: "")
        self.performSegueWithIdentifier("contactChat", sender: nil);
        //slideToChat
        
    }
    
    override func setEditing(editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tblForChat.reloadData()
    }
    
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.Delete
    }
     func tableView(tableView: UITableView, shouldIndentWhileEditingRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        
        if editingStyle == .Delete {
            self.removeChatHistory(ContactUsernames[indexPath.row],indexPath: indexPath)
            // Delete the row from the data source
            
          //  tblForChat.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            print("iii")
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
        
        
        
        /*if editingStyle == .Delete {
        
        var selectedRow = indexPath.row
        print(selectedRow.description+" selected", terminator: "")
        
        var removeChatFromServer=NetworkingLibAlamofire()
        var loggedFirstName=loggedUserObj["firstname"]
        var loggedLastName=loggedUserObj["lastname"]
        var loggedStatus=loggedUserObj["status"]
        var loggedUsername=loggedUserObj["phone"]
        // var loggedUsername=loggedUserObj["username"]
        
        print(self.ContactFirstname[selectedRow]+self.ContactLastNAme[selectedRow]+self.ContactStatus[selectedRow]+self.ContactUsernames[selectedRow], terminator: "")
        
        
        
        
        var url=Constants.MainUrl+Constants.removeFriend
        
        Alamofire.request(.POST,"\(url)",headers:header,parameters:["username":"\(self.ContactUsernames[selectedRow])"]
        ).validate(statusCode: 200..<300).responseJSON{response in
        var response1=response.response
        var request1=response.request
        var data1=response.data
        var error1=response.result.error
        
        //===========INITIALISE SOCKETIOCLIENT=========
        dispatch_async(dispatch_get_main_queue(), {
        
        
        if response1?.statusCode==200 {
        //print("got user success")
        print("Request success")
        var json=JSON(data1!)
        
        
        print(json)
        
        sqliteDB.deleteChat(self.ContactNames[selectedRow])
        
        //print(ContactNames[selectedRow]+" deleted")
        sqliteDB.deleteFriend(self.ContactUsernames[selectedRow])
        self.ContactNames.removeAtIndex(selectedRow)
        self.ContactIDs.removeAtIndex(selectedRow)
        self.ContactFirstname.removeAtIndex(selectedRow)
        self.ContactLastNAme.removeAtIndex(selectedRow)
        self.ContactStatus.removeAtIndex(selectedRow)
        self.ContactUsernames.removeAtIndex(selectedRow)
        self.ContactsEmail.removeAtIndex(selectedRow)
        self.ContactsPhone.removeAtIndex(selectedRow)
        // Delete the row from the data source
        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        //tblForChat.reloadData()
        
        }
        else
        {
        print("delete friend failed")
        //var json=JSON(error1!)
        print(error1?.description)
        print(response1?.statusCode)
        //errorMy=JSON(error1!)
        // print(errorMy.description)
        }
        })
        if(response1!.statusCode==401)
        {
        print(error1)
        print("delete friend failed token expired")
        self.rt.refrToken()
        
        }
        
        }
        //return dataMy
        
        
        
        
        
        /* removeChatFromServer.sendRequestPOST("POST", url: Constants.MainUrl+Constants.removeFriend+"?access_token=\(AuthToken)", parameters1: ["firstname":"\(ContactFirstname[selectedRow])", "lastname":"\(ContactLastNAme[selectedRow])", "status":"\(ContactStatus[selectedRow])", "username" : "\(ContactUsernames[selectedRow])"])
        */
        
        
        
        
        } else if editingStyle == .Insert {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }*/
        
    }
     func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    
    ///CALL WORKING BUTTON
   /*
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject]?  {
        // 1
        /*var shareAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Delete" , handler: { (action:UITableViewRowAction, indexPath:NSIndexPath) -> Void in
        // 2
        
        
        /*let shareMenu = UIAlertController(title: nil, message: "Share using", preferredStyle: .ActionSheet)
        
        let twitterAction = UIAlertAction(title: "Twitter", style: UIAlertActionStyle.Default, handler: nil)
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil)
        
        shareMenu.addAction(twitterAction)
        shareMenu.addAction(cancelAction)
        
        
        self.presentViewController(shareMenu, animated: true, completion: nil)
        */
        
        
        var selectedRow = indexPath.row
        print(selectedRow.description+" selected")
        
        var removeChatFromServer=NetworkingLibAlamofire()
        var loggedFirstName=loggedUserObj["firstname"]
        var loggedLastName=loggedUserObj["lastname"]
        var loggedStatus=loggedUserObj["status"]
        var loggedUsername=loggedUserObj["username"]
        
        print(self.ContactFirstname[selectedRow]+self.ContactLastNAme[selectedRow]+self.ContactStatus[selectedRow]+self.ContactUsernames[selectedRow])
        
        
        
        
        var url=Constants.MainUrl+Constants.removeFriend
        
        //var params=self.ContactsObjectss[selectedRow].arrayValue
        //var pp=JSON(params)
        //var bb=jsonString(self.ContactsObjectss[selectedRow].stringValue)
        //var a=JSONStringify(self.ContactsObjectss[selectedRow].object, prettyPrinted: false)
        Alamofire.request(.POST,"\(url)",headers:header,parameters:["username":"\(self.ContactUsernames[selectedRow])"]
        ).validate(statusCode: 200..<300).responseJSON{response in
        var response1=response.response
        var request1=response.request
        var data1=response.data
        var error1=response.result.error
        //===========INITIALISE SOCKETIOCLIENT=========
        dispatch_async(dispatch_get_main_queue(), {
        
        //self.dismissViewControllerAnimated(true, completion: nil);
        /// self.performSegueWithIdentifier("loginSegue", sender: nil)
        
        if response1?.statusCode==200 {
        //print("got user success")
        print("Request success")
        var json=JSON(data1!)
        
        
        print(json)
        //print(json)
        //dataMy=JSON(data1!)
        //print(dataMy.description)
        
        sqliteDB.deleteChat(self.ContactNames[selectedRow])
        
        //print(ContactNames[selectedRow]+" deleted")
        sqliteDB.deleteFriend(self.ContactUsernames[selectedRow])
        self.ContactNames.removeAtIndex(selectedRow)
        self.ContactIDs.removeAtIndex(selectedRow)
        self.ContactFirstname.removeAtIndex(selectedRow)
        self.ContactLastNAme.removeAtIndex(selectedRow)
        self.ContactStatus.removeAtIndex(selectedRow)
        self.ContactUsernames.removeAtIndex(selectedRow)
        self.ContactsPhone.removeAtIndex(selectedRow)
        self.ContactsEmail.removeAtIndex(selectedRow)
        // Delete the row from the data source
        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        //tblForChat.reloadData()
        
        }
        else
        {
        print("delete friend failed")
        //var json=JSON(error1!)
        print(error1?.description)
        print(response1?.statusCode)
        //errorMy=JSON(error1!)
        // print(errorMy.description)
        }
        })
        if(response1!.statusCode==401)
        {
        print(error1)
        print("delete friend failed token expired")
        self.rt.refrToken()
        
        }
        
        }
        
        })*/
        // 3
        var rateAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Call" , handler: { (action:UITableViewRowAction, indexPath:NSIndexPath) -> Void in
            
            //ON CALL BUTTON PRESSED
            
            var selectedRow = indexPath.row
            print("call pressed")
            isConference=false
            //-----------------------------------
            ///NEWW WEBMEETING WORKING CODE
            //------------------------------------
            /*username = "iphoneUser"
            iamincallWith = "webConference"
            isInitiator = false
            isConference = true
            ////ConferenceRoomName = txtForRoomName.text!
            /////////socketObj.sendMessagesOfMessageType("Conference Call")
            
            socketObj.socket.emitWithAck("init.new", ["room":ConferenceRoomName,"username":username!])(timeoutAfter: 150000000) {data in
            print("room joined by got ack")
            var a=JSON(data)
            print(a.debugDescription)
            currentID=a[1].int!
            print("current id is \(currentID)")
            print("room joined is\(ConferenceRoomName)")
            joinedRoomInCall=ConferenceRoomName
            }
            /// var mAudio=MeetingRoomAudio()
            ////mAudio.initAudio()
            
            var next = self.storyboard?.instantiateViewControllerWithIdentifier("Main2") as! ConferenceCallViewController
            
            self.presentViewController(next, animated: false, completion: {
            })
            
            */
            
            
            /////mVideo.initVideo()
            
            //------------------------
            //CONFERENCE CODE COMMENTED
            
            //var selectedRow = indexPath.row
            
            print("call pressed")
            /*
            username = "iphoneUser"
            iamincallWith = "webConference"
            isInitiator = true
            isConference = true
            ////ConferenceRoomName = txtForRoomName.text!
            /////////socketObj.sendMessagesOfMessageType("Conference Call")
            
            socketObj.socket.emitWithAck("init", ["room":ConferenceRoomName,"username":username!])(timeoutAfter: 150000000) {data in
            print("room joined by got ack")
            var a=JSON(data)
            print(a.debugDescription)
            currentID=a[1].int!
            print("current id is \(currentID)")
            print("room joined is\(ConferenceRoomName)")
            }
            let next = self.storyboard!.instantiateViewControllerWithIdentifier("MainV2") as! VideoViewController
            
            self.presentViewController(next, animated: true, completion:nil)
            */
            
            
            
            
            //-----------------------
            /*let next = self.storyboard!.instantiateViewControllerWithIdentifier("MainV2") as! VideoViewController
            
            self.presentViewController(next, animated: true, completion:nil)
            */
            
            
            
            
            
            
            /*
            dispatch_async(dispatch_get_main_queue(),{
            var alert = UIAlertController(title: "Welcome to Cloudkibo Meeting", message: "Please enter your username", preferredStyle: .Alert)
            
            //2. Add the text field. You can configure it however you need.
            alert.addTextFieldWithConfigurationHandler({ (textField) -> Void in
            textField.text = ""
            })
            
            
            //3. Grab the value from the text field, and print it when the user clicks OK.
            alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
            let textField = alert.textFields![0] as UITextField
            username = textField.text!
            print("Text field: \(textField.text)")
            
            
            
            
            }))})
            */
            //////////////////////////////
            //CORRECT CODE ONE TO ONE CALL COMMENTED
            //////////////////////////////
            socketObj.socket.emit("logClient","IPHONE-LOG: \(username!) is trying to call \(self.ContactUsernames[selectedRow])")
            if(self.ContactOnlineStatus[selectedRow]==0)
            {
                self.showError("Info:", message: "Contact is offline. Please try again later.", button1: "Ok")
                print("contact is offline")
                socketObj.socket.emit("logClient","IPHONE-LOG: contact \(self.ContactUsernames[selectedRow]) is offline")
            }
            else{
                
                sqliteDB.saveCallHist(self.ContactNames[selectedRow], dateTime1: NSDate().debugDescription, type1: "Outgoing")
                
                //socketObj.socket.emit("callthisperson",["room" : "globalchatroom","callee": self.ContactUsernames[selectedRow], "caller":username!])
                // &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&**************************
                username=KeychainWrapper.stringForKey("username")
                socketObj.socket.emit("logClient","IPHONE-LOG: callthisperson,room:globalchatroom,callee: \(self.ContactUsernames[selectedRow]), caller:\(username!)")
                print("callthisperson,room : globalchatroom,callee: \(self.ContactUsernames[selectedRow]), caller:\(username!)")
                socketObj.socket.emit("callthisperson",["room" : "globalchatroom","callee": self.ContactUsernames[selectedRow], "caller":username!])
                print("username is ... \(username!)")
                
                isInitiator=true
                callerName=username!
                iamincallWith=self.ContactUsernames[selectedRow]
                
                iOSstartedCall=true
                socketObj.socket.emit("logClient","IPHONE-LOG: \(username!) is going to videoViewController")
                ////
                var next = self.storyboard!.instantiateViewControllerWithIdentifier("MainV2") as! VideoViewController
                
                self.presentViewController(next, animated: true, completion: {
                })
            }
            
            /*
            var next = self.storyboard?.instantiateViewControllerWithIdentifier("Main2") as! VideoViewController
            
            self.presentViewController(next, animated: false, completion: {
            })
            */
            
            /*var next = self.storyboard?.instantiateViewControllerWithIdentifier("Main") as! CallRingingViewController
            
            self.presentViewController(next, animated: false, completion: {next.txtCallerName.text=self.currrentUsernameRetrieved
            next.txtCallingDialing.text="Dialing.."
            next.callerName=self.currrentUsernameRetrieved
            })
            */
            
            // 4
            /* let rateMenu = UIAlertController(title: nil, message: "Rate this App", preferredStyle: .ActionSheet)
            
            let appRateAction = UIAlertAction(title: "Rate", style: UIAlertActionStyle.Default, handler: nil)
            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil)
            
            rateMenu.addAction(appRateAction)
            rateMenu.addAction(cancelAction)
            
            
            self.presentViewController(rateMenu, animated: true, completion: nil)
            */
            }
            
        )
        
        
        // 5
        return [rateAction]
        
    }
    
   */
    
    // #pragma mark - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    
    func removeChatHistory(selectedContact:String,indexPath:NSIndexPath)
        {
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
                    self.ContactsLastMsgDate.removeAtIndex(indexPath.row)
                    self.ContactLastMessage.removeAtIndex(indexPath.row)
                    self.ContactIDs.removeAtIndex(indexPath.row)
                    self.ContactLastNAme.removeAtIndex(indexPath.row)
                    self.ContactNames.removeAtIndex(indexPath.row)
                    self.ContactStatus.removeAtIndex(indexPath.row)
                    self.ContactUsernames.removeAtIndex(indexPath.row)
                    //self.ContactsObjectss.removeAtIndex(indexPath.row)
                    ////////////////////////
                    self.ContactFirstname.removeAtIndex(indexPath.row)
                    ////////
                    
                    self.ContactsPhone.removeAtIndex(indexPath.row)
                    self.ContactsEmail.removeAtIndex(indexPath.row)
                    //print(request1)
                    print(data1?.debugDescription)
                    
                    sqliteDB.deleteChat(selectedContact)
                    
                    //self.messages.removeAllObjects()
                    self.tblForChat.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                    dispatch_async(dispatch_get_main_queue())
                        {
                            
                            self.tblForChat.reloadData()
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
    
    override func prepareForSegue(segue: UIStoryboardSegue?, sender: AnyObject?) {
        //var newController=segue ?.destinationViewController
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        
        //if segue!.identifier == "chatSegue" {
        /*if segue!.identifier == "inviteSegue"{
        if let destinationVC = segue!.destinationViewController as? ContactsInviteViewController{
        
        //contactsList.searchContactsByEmail(contactsList.emails)
        }
        }*/
        if segue!.identifier == "contactChat" {
            
            if let destinationVC = segue!.destinationViewController as? ChatDetailViewController{
                
                let selectedRow = tblForChat.indexPathForSelectedRow!.row
                //destinationVC.selectedContact = ContactNames[selectedRow]
                destinationVC.selectedContact = ContactUsernames[selectedRow]
                destinationVC.selectedFirstName=ContactNames[selectedRow]
                destinationVC.selectedLastName=ContactLastNAme[selectedRow]
                destinationVC.selectedID=ContactIDs[selectedRow]
                destinationVC.ContactNames=ContactNames[selectedRow]
                destinationVC.ContactOnlineStatus=ContactOnlineStatus[selectedRow]
                //destinationVC.AuthToken = self.AuthToken
                
                //
                /* var getUserbByIdURL=Constants.MainUrl+Constants.getSingleUserByID+ContactIDs[selectedRow]+"?access_token="+AuthToken
                print(getUserbByIdURL.debugDescription+"..........")
                Alamofire.request(.GET,"\(getUserbByIdURL)").response{
                request, response, data, error in
                print(error)
                
                if response?.statusCode==200
                
                {
                print("got userrrrrrr")
                print(data?.debugDescription)
                print(":::::::::")
                destinationVC.selectedUserObj=JSON(data!)
                }
                else
                {
                print("didnt get userrrrr")
                print(error)
                print(data)
                print(response)
                }
                }*/
                
                //
            }
        }
        if segue!.identifier == "newChat" {
            
            if let destinationVC = segue!.destinationViewController as? ChatMainViewController{
                destinationVC.mytitle="New Chat"
                destinationVC.navigationItem.leftBarButtonItem?.enabled=false
                destinationVC.navigationItem.rightBarButtonItem?.image=nil
                destinationVC.navigationItem.rightBarButtonItem?.enabled=false
            }}
        
    }
    
    
    ///////////////////////////////
    //SOCKET CLIENT DELEGATE MESSAGES
    ///////////////////////////////
    
    func socketReceivedMessage(message:String,data:AnyObject!)
    {print("socketReceivedMessage inside", terminator: "")
        //var msg=JSON(params)
        socketObj.socket.emit("logClient","IPHONE-LOG: \(username!) received message \(message)")
        switch(message)
        {
            
            
            // %%%%%%%%%%%%%%%%%% new commented
            /*case "Accept Call":
            socketObj.socket.emit("logClient","IPHONE-LOG: \(username!) is inside accept call")
            print("Accept call in chat view")
            callerName=KeychainWrapper.stringForKey("username")!
            //iamincallWith=msg[0]["callee"].string!
            
            print("callee is \(callerName)", terminator: "")
            
            var roomname=""
            //if(ConferenceRoomName == "")
            //{
            socketObj.socket.emit("logClient","IPHONE-LOG: \(username!) is inside accept call")
            print("inside accept call")
            /// roomname="test"
            
            /*** neww may 2016 MOVED ROOM JOIN
            
            if(isConference == true)
            {print("conference name is\(ConferenceRoomName)")
            roomname=ConferenceRoomName
            }
            else{
            //roomname=self.randomStringWithLength(9) as String
            roomname="sumaira"
            }
            //iamincallWith=username!
            areYouFreeForCall=false
            joinedRoomInCall=roomname as String
            socketObj.socket.emitWithAck("init", ["room":joinedRoomInCall,"username":username!])(timeoutAfter: 1500000) {data in
            meetingStarted=true
            print("room joined by got ack")
            var a=JSON(data)
            print(a.debugDescription)
            currentID=a[1].int!
            print("current id is \(currentID)")
            var aa=JSON(["msg":["type":"room_name","room":roomname as String],"room":globalroom,"to":iamincallWith!,"username":username!])
            print(aa.description)
            socketObj.socket.emit("message",aa.object)
            
            }//end data
            */
            
            
            ///NEW ADDED
            
            socketObj.socket.emit("logClient","IPHONE-LOG: \(username!) is going to videoViewController")
            ////
            var next = self.storyboard!.instantiateViewControllerWithIdentifier("MainV2") as! VideoViewController
            
            self.presentViewController(next, animated: true, completion: {
            })
            
            //}
            
            */
        case "othersideringing":
            print(message)
            iOSstartedCall=true
            //////*** newww may 2016
            
            callerName=KeychainWrapper.stringForKey("username")!
            //iamincallWith=msg[0]["callee"].string!
            socketObj.socket.emit("logClient","IPHONE-LOG: \(username!) othersideringing , callee is \(callerName)")
            print("callee is \(callerName)", terminator: "")
            
            /*
            ///NEW ADDED
            
            
            ////
            var next = self.storyboard!.instantiateViewControllerWithIdentifier("MainV2") as! VideoViewController
            
            self.presentViewController(next, animated: true, completion: {
            })
            */
        case "offline":
            
            
            print("offline status...", terminator: "")
            var offlineUsers=JSON(data!)
            print(offlineUsers[0])
            //print(offlineUsers[0]["username"])
            
            for(var i=0;i<offlineUsers.count;i++)
            {
                for(var j=0;j<self.ContactUsernames.count;j++)
                {
                    if self.ContactUsernames[j]==offlineUsers[i]["phone"].string!
                    {
                        //found online contact,s username
                        socketObj.socket.emit("logClient","IPHONE-LOG: user found offline \(self.ContactUsernames[j])")
                        print("user found offlinee \(self.ContactUsernames[j])")
                        self.ContactOnlineStatus[j]=0
                        dispatch_async(dispatch_get_main_queue())
                            {
                                self.tblForChat.reloadData()
                        }
                    }
                }
            }
            
        case "theseareonline":
            
            print("theseareonline status...", terminator: "")
            var theseareonlineUsers=JSON(data!)
            //print(theseareonlineUsers.object)
            //print(offlineUsers[0]["username"])
            print("contact user names count is \(self.ContactUsernames.count) and theseareonline users count is \(theseareonlineUsers[0].count) and self array of online users count is \(self.ContactOnlineStatus.count)")
            for(var i=0;i<theseareonlineUsers[0].count;i++)
            {
                for(var j=0;j<self.ContactUsernames.count && i<theseareonlineUsers.count;j++)
                {
                    if self.ContactUsernames[j]==theseareonlineUsers[0][i]["phone"].description
                    {
                        //found online contact,s username
                        socketObj.socket.emit("logClient","IPHONE-LOG: user found theseareonline \(self.ContactUsernames[j])")
                        print("user found theseareonline \(self.ContactUsernames[j])")
                        self.ContactOnlineStatus[j]=1
                        print("line # 1699")
                        // *** newwww self.tblForChat.reloadData()
                    }
                }
            }
            
            
        case "yesiamfreeforcall":
            var message=JSON(data!)
            print("other user is free", terminator: "")
            print(data?.debugDescription, terminator: "")
            socketObj.socket.emit("logClient","IPHONE-LOG: \(username!) received message from other peer yesiamfreeforcall")
            
        case "areyoufreeforcall":
            
            var jdata=JSON(data!)
            socketObj.socket.emit("logClient","IPHONE-LOG: checking if \(username!) is free for call")
            print("areyoufreeforcall ......", terminator: "")
            print(jdata.debugDescription)
            
            if(areYouFreeForCall==true)
            {   iOSstartedCall=false
                print(jdata[0]["caller"].string!)
                //print(self.currrentUsernameRetrieved, terminator: "")
                iamincallWith=jdata[0]["caller"].string!
                isInitiator=false
                //callerID=jdata[0]["sendersocket"].string!
                //transition
                
                //let secondViewController:CallRingingViewController = CallRingingViewController()
                
                socketObj.socket.emit("yesiamfreeforcall",["mycaller" : jdata[0]["caller"].string!, "me":username!])
                
                /*
                var allcontacts=sqliteDB.allcontacts
                //var contactsKibo=sqliteDB.contactslists
                
                
                let phone = Expression<String>("phone")
                let usernameFromDb = Expression<String?>("username")
                let name = Expression<String?>("name")
                
                var nameOfCaller=iamincallWith
                //do
                //{allkiboContactsArray = Array(try sqliteDB.db.prepare(contactsKibo))
                do{
                    for all in try sqliteDB.db.prepare(allcontacts) {
                        if(all[phone]==iamincallWith) //if we found contact in our AddressBook
                            
                        {
                            //Matched phone number. Got contact
                            if(all[name] != "" || all[name] != nil)
                            {
                                nameOfCaller=all[name]!
                                //cell.contactName?.text=all[name]
                            }}}}
                catch
                {
                    print("error here 111")
                }
                
                sqliteDB.saveCallHist(nameOfCaller, dateTime1: NSDate().debugDescription, type1: "Incoming")
                
                */
                
                var next = self.storyboard?.instantiateViewControllerWithIdentifier("Main") as! CallRingingViewController
                
                self.presentViewController(next, animated: false, completion: {next.txtCallerName.text=jdata[0]["caller"].string!; next.currentusernameretrieved=self.currrentUsernameRetrieved; next.callerName=jdata[0]["caller"].string!
                    isInitiator=false
                })
                
                
            }
            else{
                socketObj.socket.emit("logClient","IPHONE-LOG: \(username!) is busy on another call")
                
                socketObj.socket.emit("noiambusy",["mycaller" : jdata[0]["caller"].string!, "me":self.currrentUsernameRetrieved])
                /*
                print("i am busyyy", terminator: "")
                let alert = UIAlertView()
                alert.title = "Sorry"
                alert.message = "Your friend is busy on another call"
                alert.addButtonWithTitle("Ok")
                alert.show()*/
                
            }
            
        case "youareonline":
            globalChatRoomJoined=true
            var contactsOnlineList=JSON(data)
            print(contactsOnlineList.debugDescription)
            for(var i=0;i<contactsOnlineList[0].count;i++)
            {
                for(var j=0;j<self.ContactUsernames.count;j++)
                {
                    if self.ContactIDs[j]==contactsOnlineList[0][i]["_id"].string!
                    {
                        //found online contact,s username
                        print("user found onlineeeee \(self.ContactUsernames[j])")
                        self.ContactOnlineStatus[j]=1
                        dispatch_async(dispatch_get_main_queue())
                            {
                                self.tblForChat.reloadData()
                        }
                    }
                }
            }
            
            //  dispatch_async(dispatch_get_main_queue())
            // {
            
            //}
        case "calleeisbusy":
            
            self.showError("Information", message: "User is busy. Please try again later", button1: "Ok")
            
        case "online":
            //{data,ack in
            var onlinefound=false
            print("online status...")
            var onlineUsers=JSON(data)
            print(onlineUsers[0])
            //print(onlineUsers[0]["username"])
            
            for(var i=0;i<onlineUsers.count;i++)
            {
                for(var j=0;j<self.ContactUsernames.count;j++)
                {
                    if self.ContactsPhone[j]==onlineUsers[i]["phone"].string!
                    {
                        //found online contact,s username
                        print("user found online2 \(self.ContactUsernames[j])")
                        self.ContactOnlineStatus[j]=1
                        onlinefound=true
                        dispatch_async(dispatch_get_main_queue())
                            {
                                self.tblForChat.reloadData()
                        }
                    }
                }
            }
            
            // }
        case "offline":
            var offlinefound=false
            //{data,ack in
            
            print("offline status...")
            var offlineUsers=JSON(data)
            print(offlineUsers[0])
            //print(offlineUsers[0]["username"])
            
            for(var i=0;i<offlineUsers.count;i++)
            {
                for(var j=0;j<self.ContactUsernames.count;j++)
                {
                    if self.ContactUsernames[j]==offlineUsers[i]["phone"].string!
                    {
                        //found online contact,s username
                        print("user found offlinee \(self.ContactUsernames[j])")
                        self.ContactOnlineStatus[j]=0
                        offlinefound=true
                        dispatch_async(dispatch_get_main_queue())
                            {
                                self.tblForChat.reloadData()
                        }
                    }
                }
            }
            
            //}
            
        default: print("", terminator: "")
            
        }//end switch
        
    }
    func socketReceivedSpecialMessage(message:String,params:JSON!)
    {
        
    }
    override func viewWillDisappear(animated: Bool) {
        print("dismissed chatttttttt")
        //socketObj.delegate=nil
    }
    
    
    
}


/*
print("otherside ringing")
var msg=JSON(data)
//self.othersideringing=true;
print(msg.debugDescription)
callerName=KeychainWrapper.stringForKey("username")!
//iamincallWith=msg[0]["callee"].string!
print("callee is \(callerName)")
var next = self.storyboard?.instantiateViewControllerWithIdentifier("Main2") as! VideoViewController
self.presentViewController(next, animated: true, completion: {
})
*/