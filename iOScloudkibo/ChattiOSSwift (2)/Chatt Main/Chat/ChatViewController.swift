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

class ChatViewController: UIViewController {
    var rt=NetworkingLibAlamofire()
    
    var refreshControl = UIRefreshControl()
    //var contactsJsonObj:JSON="[]"
    @IBOutlet var viewForTitle : UIView!
    @IBOutlet var ctrlForChat : UISegmentedControl!
    @IBOutlet var btnForLogo : UIButton!
    var loggedID=loggedUserObj["_id"]
    //@IBOutlet var itemForSearch : UIBarButtonItem!
    @IBOutlet var tblForChat : UITableView!
    //var AuthToken:String=""
    //var socketObj=LoginAPI(url: "\(Constants.MainUrl)")
    @IBOutlet weak var btnContactAdd: UIBarButtonItem!
    
    var currrentUsernameRetrieved:String=""
    
    
    
    
    @IBAction func addContactTapped(sender: UIBarButtonItem) {
        /* let alert = UIAlertView()
        alert.title = "Alert"
        alert.message = "Here's a message"
        alert.addButtonWithTitle("Understod")
        alert.show()
        */
        
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
            
            println(loggedUserObj)
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
            
            var addContactUsernameURL=Constants.MainUrl+Constants.addContactByEmail+"?access_token=\(AuthToken!)"
           
            
            Alamofire.request(.POST,"\(addContactUsernameURL)",parameters: ["searchemail":"\(tField.text!)"])
                .validate(statusCode: 200..<300)
                .response { (request1, response1, data1, error1) in
                    println("success")
                    
                    var json=JSON(data1!)
                    //println(json)
                    if(json["msg"].string=="null")
                    {println("Invalid email")}
                    else
                    {
                        if(json["status"].string=="danger"){
                            println("contact already in your list")}
                        else
                        {println("friend request sent")}
                    println(error1)
                        
                    
                    }
                    if response1?.statusCode==401
                    {
                        println("REFRESH TOKEN Neededd Add Contact Username...")
                        
                        self.rt.refrToken()
                    }
            
            }
        println("outttt of sucess parasssss")
        }
            
            //////
          /* Alamofire.request(.POST,"\(addContactUsernameURL)",parameters: ["searchemail":"\(tField.text!)"])
                .responseJSON { request1, response1, data1, error1 in
                    
                //request1, response1, data1, error1 in
                //searchemail  f@lkjlklkm.com
                //====================
               dispatch_async(dispatch_get_main_queue(), {
                    
                    self.dismissViewControllerAnimated(true, completion: nil);
                    /// self.performSegueWithIdentifier("loginSegue", sender: nil)
                    
                    if response1?.statusCode==200 {
                        println("success")
                        
                        var json=JSON(data1!)
                        //println(json)
                        if(json["msg"].string=="null")
                        {println("Invalid email")}
                        else
                        {
                            if(json["status"].string=="danger"){
                                println("contact already in your list")}
                            else
                            {println("friend request sent")}
                        }
                    }
                    else
                    {
                        println("error in sending friend request")
                    }
                })
            }
            
        }*/

        actionSheetController.addAction(cancelAction)
        //Create and an option action
        let nextAction: UIAlertAction = UIAlertAction(title: "Add by Username", style: UIAlertActionStyle.Default) { action -> Void in
            
            //var ContactEmail=self.ContactsObjectss[]
            println(loggedUserObj)
            var userid=""
            socketObj.socket.emit("friendrequest",[
                "room":"globalchatroom",
                "userid":loggedUserObj.object,
                "contact":"\(tField.text!)"]
            )
            
            
            //Do some other stuff
            var addContactUsernameURL=Constants.MainUrl+Constants.addContactByUsername+"?access_token=\(AuthToken!)"
            Alamofire.request(.POST,"\(addContactUsernameURL)",parameters: ["searchusername":"\(tField.text!)"]).validate(statusCode: 200..<300).responseJSON{
                request1, response1, data1, error1 in
                //searchemail  f@lkjlklkm.com
                //====================
                dispatch_async(dispatch_get_main_queue(), {
                    
                    self.dismissViewControllerAnimated(true, completion: nil);
                    /// self.performSegueWithIdentifier("loginSegue", sender: nil)
                    
                    if response1?.statusCode==200 {
                        println("success")
                        
                        var json=JSON(data1!)
                        //println(json)
                        if(json["msg"].string=="null")
                        {println("Invalid user")}
                        else
                        {
                            if(json["status"].string=="danger"){
                                println("contact already in your list")}
                            else
                            {println("friend request sent")}
                        }
                    }
                    else
                    {
                        println("error in sending friend request")
                    }
                })
                if response1?.statusCode==401
                {
                    println(error1)
                    println("REFRESH TOKEN Neededd Add Contact Username...")
                    
                    self.rt.refrToken()
                }
 
                
                
                
            }
            
        }
        actionSheetController.addAction(nextAction)
        
        
        //Present the AlertController
        self.presentViewController(actionSheetController, animated: true, completion: nil)
    }
    
    var ContactNames:[String]=[]
    var ContactUsernames:[String]=[]
    var ContactIDs:[String]=[]
    var ContactFirstname:[String]=[]
    var ContactLastNAme:[String]=[]
    var ContactStatus:[String]=[]
    var ContactsObjectss:[JSON]=[]
    
    var ContactOnlineStatus:[Int]=[]
    
    //["Bus","Helicopter","Truck","Boat","Bicycle","Motorcycle","Plane","Train","Car","Scooter","Caravan"]
    required init(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        //println(AuthToken!)
        
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        // Custom initialization
        
    }

   
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
      currrentUsernameRetrieved=KeychainWrapper.stringForKey("username")!
        
        if(loggedUserObj == JSON("[]"))
        {
            var lusername=KeychainWrapper.stringForKey("username")
            //KeychainWrapper.stringForKey("password")
            //KeychainWrapper.stringForKey("loggedFullName")
            //KeychainWrapper.stringForKey("loggedPhone")
            //KeychainWrapper.stringForKey("loggedEmail")
            var lid=KeychainWrapper.stringForKey("_id")
            
            var lobj=["_id" : lid!, "username" : lusername!]
            if let dataFromString = jsonString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false) {
                let json11 = JSON(lobj.debugDescription)
                
                var lllooo = json11
                loggedUserObj=json11
                loggedUserObj.object=json11.object
                println(lllooo.object)
                //var jsonNew=JSON("{\"room\": \"globalchatroom\",\"user\": {\"username\":\"sabachanna\"}}")
                //socketObj.socket.emit("join global chatroom", ["room": "globalchatroom", "user": ["username":"sabachanna"]]) WORKINGGG
                
                
                /*
                
                var logonjuser=KeychainWrapper.stringForKey("loggedUserObjString")
                var newloggedUserObj=logonjuser!.stringByResolvingSymlinksInPath
                println("newloggeduserobj string")
                println(newloggedUserObj)
                if let dataFromString = jsonString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false) {
                let json11 = JSON(newloggedUserObj)
                
                println("json11 object")
                println(json11.object)
                
                loggedUserObj=json11
                
                
                println("joining rooon \(json11.object)")
                socketObj.socket.emit("join global chatroom",["room": "globalchatroom", "user": json11.object])
                
                }*/
            }
            
        }
        
        
        println("loadddddd")
        if(socketObj == nil)
        {
            println("socket is nillll")
            
            
            socketObj=LoginAPI(url:"\(Constants.MainUrl)")
            println("connected issssss \(socketObj.socket.connected)")
           socketObj.connect()
        }

    
        
        
   
        
            
        socketObj.socket.on("othersideringing"){data,ack in
            println("otherside ringing")
            var msg=JSON(data!)
            //self.othersideringing=true;
            println(msg.debugDescription)
            callerName=KeychainWrapper.stringForKey("username")!
            //iamincallWith=msg[0]["callee"].string!
            
            println("callee is \(callerName)")
            
            var next = self.storyboard?.instantiateViewControllerWithIdentifier("Main2") as! VideoViewController
            
            self.presentViewController(next, animated: true, completion: {
            })
            
        }

        
        
       /*if loggedUserObj==nil
       {
        if let loggd=KeychainWrapper.objectForKey("loggedUserObj")
        {
            loggedUserObj=JSON(loggd)
        }
        }*/
        //==========Show Online============

        
       /* socketObj.socket.emit("whozonline",[
            "room":"globalchatroom",
            "user":loggedUserObj.object])
        */
     //   println("logged id key chain is \(loggedIDKeyChain)")
        
        
        self.navigationItem.titleView = viewForTitle
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: btnForLogo)
        //self.navigationItem.rightBarButtonItem = itemForSearch
        self.navigationItem.rightBarButtonItem = btnContactAdd
        self.tabBarController?.tabBar.tintColor = UIColor.greenColor()
        println("////////////////////// new class tokn \(AuthToken)")
        // fetchContacts(AuthToken)
        println(self.ContactNames.count.description)
        // self.tblForChat.reloadData()
        
        
        /////////////----------------------================================++++++++++
       
        

        //((((((((()))))))___________++++++++++++__________++++++++++++((((((((((()))))))))
    
        

        
        
        
        
        
        //========
        socketObj.socket.on("online")
            {data,ack in
                    
                    println("online status...")
                    var onlineUsers=JSON(data!)
                    println(onlineUsers[0])
                    //println(onlineUsers[0]["username"])
                
                for(var i=0;i<onlineUsers.count;i++)
                {
                    for(var j=0;j<self.ContactUsernames.count;j++)
                    {
                        if self.ContactUsernames[j]==onlineUsers[i]["username"].string!
                        {
                            //found online contact,s username
                            println("user found onlineeeee \(self.ContactUsernames[j])")
                            self.ContactOnlineStatus[j]=1
                            self.tblForChat.reloadData()
                        }
                    }
                }
                
                }
        
       

     
        
        //======Offline users=========
        socketObj.socket.on("offline")
            {data,ack in
                
                println("offline status...")
                var offlineUsers=JSON(data!)
                println(offlineUsers[0])
                //println(offlineUsers[0]["username"])
                
                for(var i=0;i<offlineUsers.count;i++)
                {
                    for(var j=0;j<self.ContactUsernames.count;j++)
                    {
                        if self.ContactUsernames[j]==offlineUsers[i]["username"].string!
                        {
                            //found online contact,s username
                            println("user found offlinee \(self.ContactUsernames[j])")
                            self.ContactOnlineStatus[j]=0
                            self.tblForChat.reloadData()
                        }
                    }
                }
                
        }
        
        
       
        //refreshControl.addTarget(self, action: Selector("fetchContacts"), forControlEvents: UIControlEvents.ValueChanged)
        //self.refreshControl = refreshControl
        
        
        let username = Expression<String?>("username")
        //if sqliteDB.db["accounts"].count(username)<1
        //if AuthToken==""
        
        //everytime new login
        KeychainWrapper.removeObjectForKey("access_token")
        
        
        let retrievedToken=KeychainWrapper.stringForKey("access_token")
        if retrievedToken==nil
        {performSegueWithIdentifier("loginSegue", sender: nil)}
        else
        {println("rrrrrrrrr \(retrievedToken)")
            refreshControl.addTarget(self, action: Selector("fetchContacts"), forControlEvents: UIControlEvents.ValueChanged)
            
            /*^^^^^^newwww socketObj.socket.on("othersideringing"){data,ack in
                println("otherside ringing")
                var msg=JSON(data!)
                //self.othersideringing=true;
                println(msg.debugDescription)
                callerName=KeychainWrapper.stringForKey("username")!
                //iamincallWith=msg[0]["callee"].string!
                
                println("callee is \(callerName)")
                
                var next = self.storyboard?.instantiateViewControllerWithIdentifier("Main2") as! VideoViewController
                
                self.presentViewController(next, animated: true, completion: {
                })
                
            }
            */
            //fetchContacts()
            self.tblForChat.reloadData()
            //performSegueWithIdentifier("loginSegue", sender: nil)
        }
        
        
        
        
        // Do any additional setup after loading the view.
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        println("appearrrrrr")
        socketObj.addHandlers()
                   /*var lusername=KeychainWrapper.stringForKey("username")
            //KeychainWrapper.stringForKey("password")
            //KeychainWrapper.stringForKey("loggedFullName")
            //KeychainWrapper.stringForKey("loggedPhone")
            //KeychainWrapper.stringForKey("loggedEmail")
            var lid=KeychainWrapper.stringForKey("_id")
            
            
            var lobj=["_id": lid!, "username":lusername!]
            if let dataFromString = jsonString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false) {
                let json11 = JSON(lobj.debugDescription)
                
            var lllooo = json11
                loggedUserObj.object=lllooo.object
                socketObj.addHandlers()
                println(lllooo.object)
                //var jsonNew=JSON("{\"room\": \"globalchatroom\",\"user\": {\"username\":\"sabachanna\"}}")
                //socketObj.socket.emit("join global chatroom", ["room": "globalchatroom", "user": ["username":"sabachanna"]]) WORKINGGG
                
                socketObj.socket.emit("join global chatroom",["room": "globalchatroom", "user": lllooo.object])
                
               // println(lllooo["_id"])

            }
            /*var lll=KeychainWrapper.stringForKey("loggedIDKeyChain")
            println("------------------")
            println(lll!.stringByDeletingPathExtension)
            println("------------------")
            println(lll!.stringByRemovingPercentEncoding)
            println("------------------")
            println(lll!.stringByResolvingSymlinksInPath)
            loggedUserObj = JSON(lll!.stringByResolvingSymlinksInPath)
            */
            */
        
        println("khul raha hai1")
        ///^^^^^^^neww let retrievedToken=KeychainWrapper.stringForKey("access_token")
        //var retrievedToken:String!
        let retrievedToken=KeychainWrapper.stringForKey("access_token")
        println("khul raha hai2")
        println(loggedUserObj.object)
        //let retrievedUsername=KeychainWrapper.stringForKey("username")
        //if retrievedToken==nil || retrievedUsername==nil
        if retrievedToken == nil
            {performSegueWithIdentifier("loginSegue", sender: nil)}
        else
        {
        //^^^^^^^^^^^newwwww ************* 
            
            fetchContacts()
           //^^^^^^^^^^^^newwwww 
            self.fetchContactsFromServer()
             ////////self.fetchContactsFromServer()
            dispatch_async(dispatch_get_main_queue(), {
               
                self.tblForChat.reloadData()
                
            //^^^^^^^^^^^newwwww ******* 
            })
    }
    
        //var db=DatabaseHandler(dbName: "abc.sqlite")
        
        
    }
    
    //=====================================
    //to fetch contacts from SQLite db
    
    func fetchContacts(){
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
        
        //-========Remove old values=====================
        self.ContactIDs.removeAll(keepCapacity: false)
        self.ContactLastNAme.removeAll(keepCapacity: false)
        self.ContactNames.removeAll(keepCapacity: false)
        self.ContactStatus.removeAll(keepCapacity: false)
        self.ContactUsernames.removeAll(keepCapacity: false)
        self.ContactsObjectss.removeAll(keepCapacity: false)

        let tbl_contactslists=sqliteDB.db["contactslists"]
        for tblContacts in tbl_contactslists.select(contactid,firstname,lastname,username,userid,status) {
           println("queryy runned count is \(tbl_contactslists.count)")
            println(tblContacts[firstname]+" "+tblContacts[lastname])
            //ContactsObjectss.append(tblContacts[contactid])
            ContactNames.append(tblContacts[firstname]+" "+tblContacts[lastname])
            ContactUsernames.append(tblContacts[username])
            ContactIDs.append(tblContacts[userid])
            ContactFirstname.append(tblContacts[firstname])
            ContactLastNAme.append(tblContacts[lastname])
            ContactStatus.append(tblContacts[status])
            ContactOnlineStatus.append(0)

        }
        
        //====These are Online====
        
        socketObj.socket.on("theseareonline")
            {data,ack in
                
                println("theseareonline status...")
                var theseareonlineUsers=JSON(data!)
                //println(theseareonlineUsers.object)
                //println(offlineUsers[0]["username"])
                
                for(var i=0;i<theseareonlineUsers[0].count;i++)
                {
                    for(var j=0;j<self.ContactUsernames.count && i<theseareonlineUsers.count;j++)
                    {
                        //println(theseareonlineUsers[i].description)
                        //println(theseareonlineUsers.count)
                        //println(theseareonlineUsers[0][0].description)
                        //println(self.ContactUsernames[j])
                        if self.ContactUsernames[j]==theseareonlineUsers[0][i]["username"].description
                        {
                            //found online contact,s username
                            println("user found theseareonline \(self.ContactUsernames[j])")
                            self.ContactOnlineStatus[j]=1
                            self.tblForChat.reloadData()
                        }
                    }
                }
                
        }
        
        
        socketObj.socket.on("yesiamfreeforcall"){data,ack in
            var message=JSON(data!)
            println("other user is free")
            println(data?.debugDescription)
            
        //socketObj.socket.emit("othersideringing", ["callee": message["me"].string!])
            
        }
        currrentUsernameRetrieved=KeychainWrapper.stringForKey("username")!
        socketObj.socket.on("areyoufreeforcall") {data,ack in
            var jdata=JSON(data!)
            println("somebody callinggg  \(data) \(ack)")
            
            if(areYouFreeForCall==true)
            {
                println(jdata[0]["caller"].string!)
                println(self.currrentUsernameRetrieved)
                iamincallWith=jdata[0]["caller"].string!
                isInitiator=false
                //callerID=jdata[0]["sendersocket"].string!
                //transition
                
                //let secondViewController:CallRingingViewController = CallRingingViewController()
                
                socketObj.socket.emit("yesiamfreeforcall",["mycaller" : jdata[0]["caller"].string!, "me":self.currrentUsernameRetrieved])
                
              
                
                
            
            
                var next = self.storyboard?.instantiateViewControllerWithIdentifier("Main") as! CallRingingViewController
                
                self.presentViewController(next, animated: false, completion: {next.txtCallerName.text=jdata[0]["caller"].string!; next.currentusernameretrieved=self.currrentUsernameRetrieved; next.callerName=jdata[0]["caller"].string!
                    isInitiator=false
                })
                
                
                }
                else{
                socketObj.socket.emit("noiambusy",["mycaller" : jdata[0]["caller"].string!, "me":self.currrentUsernameRetrieved])
                
                println("i am busyyy")
                    
                }
                
            
                //self.presentViewController(CallRingingViewController(), animated: true, completion: {println("call screen shown")}
                
                //)

                
                //socketObj.socket.emit("message","Accept Call")
                //socketObj.socket.emit("message","Accept")
                
                //show screen
            
        }
        
        
        
        //room callee callthisperson
        
        //==========Show Online============
        
       
    
    }
    
    
    //======================================
    //to fetch contacts from server
    
    func fetchContactsFromServer(){
        println("Server fetchingg contactss")
        if(loggedUserObj == JSON("[]"))
        {
            var lusername=KeychainWrapper.stringForKey("username")
            if(lusername == nil)
            {lusername=username!}
            //KeychainWrapper.stringForKey("password")
            //KeychainWrapper.stringForKey("loggedFullName")
            //KeychainWrapper.stringForKey("loggedPhone")
            //KeychainWrapper.stringForKey("loggedEmail")
            var lid=KeychainWrapper.stringForKey("_id")
            
            var lobj=["_id": lid!, "username" : lusername!]
            if let dataFromString = jsonString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false) {
                let json11 = JSON(lobj.debugDescription)
                
                var lllooo = json11
                loggedUserObj=json11
                loggedUserObj.object=json11.object
                println(lllooo.object)
                //var jsonNew=JSON("{\"room\": \"globalchatroom\",\"user\": {\"username\":\"sabachanna\"}}")
                //socketObj.socket.emit("join global chatroom", ["room": "globalchatroom", "user": ["username":"sabachanna"]]) WORKINGGG
                
                
                /*
                
                var logonjuser=KeychainWrapper.stringForKey("loggedUserObjString")
                var newloggedUserObj=logonjuser!.stringByResolvingSymlinksInPath
                println("newloggeduserobj string")
                println(newloggedUserObj)
                if let dataFromString = jsonString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false) {
                let json11 = JSON(newloggedUserObj)
                
                println("json11 object")
                println(json11.object)
                
                loggedUserObj=json11
                
                
                println("joining rooon \(json11.object)")
                socketObj.socket.emit("join global chatroom",["room": "globalchatroom", "user": json11.object])
                
                }*/
            }
            
        }
        

        var fetchChatURL=Constants.MainUrl+Constants.getContactsList+"?access_token="+AuthToken!
        
        println(fetchChatURL)
        
        
        Alamofire.request(.GET,"\(fetchChatURL)").validate(statusCode: 200..<300)
            .response { (request1, response1, data1, error1) in
                println("success")

            
            
            
            //============GOT Contacts SECCESS=================
            
            
            ////////////////////////
           //^^^^^ dispatch_async(dispatch_get_main_queue(), {
                //self.fetchContacts(self.AuthToken)
                /// activityOverlayView.dismissAnimated(true)
                
                
                if response1?.statusCode==200 {
                    
                    if(glocalChatRoomJoined == false)
                    {
                        socketObj.addHandlers()
                    println("joiningggggg")
                        //var lll=KeychainWrapper.stringForKey("loggedIDKeyChain")
                        var lll=KeychainWrapper.stringForKey("loggedUserObjString")
                        //loggedUserObjString
                        println("------------------")
                        println(lll!.stringByDeletingPathExtension)
                        println("------------------")
                        println(lll!.stringByRemovingPercentEncoding)
                        println("------------------")
                        println(lll!.stringByResolvingSymlinksInPath)
                        var ssss=lll!.stringByResolvingSymlinksInPath
                        
                        if let dataFromString = jsonString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false) {
                            let json22 = JSON(ssss)
                            
                            println(";;;;;;;;;")
                            println(json22.object)
                            
                        loggedUserObj = json22
                        var lllloooobbbb = json22
                          //  var dd:[AnyObject]=json22.rawValue as! [AnyObject]
                   /// socketObj.socket.emit("join global chatroom",["room":"globalchatroom","user":loggedUserObj.object])
                        ///socketObj.socket.emit("join global chatroom", ["room": "globalchatroom", "user": json22.object])
                            socketObj.socket.emit("join global chatroom", ["room": "globalchatroom", "user": ["username":KeychainWrapper.stringForKey("username")!]])
                        }
                     
                    }
                    //println("Contacts fetched success")
                    let contactsJsonObj = JSON(data: data1!)
                    println(contactsJsonObj)
                    //println(contactsJsonObj["userid"])
                    //let contact=JSON(contactsJsonObj["contactid"])
                    //   println(contact["firstname"])
                    println("Contactsss fetcheddddddd")
                    //var userr=contactsJsonObj["userid"]
                    // println(self.contactsJsonObj.count)
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
                    
                    
                    let tbl_contactslists=sqliteDB.db["contactslists"]
                    tbl_contactslists.delete() //complete refresh
                    
                    
                    //-========Remove old values=====================
                    self.ContactIDs.removeAll(keepCapacity: false)
                    self.ContactLastNAme.removeAll(keepCapacity: false)
                    self.ContactNames.removeAll(keepCapacity: false)
                    self.ContactStatus.removeAll(keepCapacity: false)
                    self.ContactUsernames.removeAll(keepCapacity: false)
                    self.ContactsObjectss.removeAll(keepCapacity: false)
                    
                    
                    
                    for var i=0;i<contactsJsonObj.count;i++
                    {
                        let insert=tbl_contactslists.insert(contactid<-contactsJsonObj[i]["contactid"]["_id"].string!,
                            detailsshared<-contactsJsonObj[i]["detailsshared"].string!,
                            
                            unreadMessage<-contactsJsonObj[i]["unreadMessage"].boolValue,
                            
                            userid<-contactsJsonObj[i]["userid"].string!,
                            firstname<-contactsJsonObj[i]["contactid"]["firstname"].string!,
                            lastname<-contactsJsonObj[i]["contactid"]["lastname"].string!,
                            email<-contactsJsonObj[i]["contactid"]["email"].string!,
                            phone<-contactsJsonObj[i]["contactid"]["_id"].string!,
                            username<-contactsJsonObj[i]["contactid"]["username"].string!,
                            status<-contactsJsonObj[i]["contactid"]["status"].string!)
                        
                        //self.transportItems.insert(contactsJsonObj[i]["contactid"]["firstname"].string!+" "+contactsJsonObj[i]["contactid"]["lastname"].string!, atIndex: i)
                        
                        
                        //=========this is done in fetching from sqlite not here====
                        self.ContactsObjectss.append(contactsJsonObj[i]["contactid"])
                        self.ContactNames.append(contactsJsonObj[i]["contactid"]["firstname"].string!+" "+contactsJsonObj[i]["contactid"]["lastname"].string!)
                        self.ContactUsernames.append(contactsJsonObj[i]["contactid"]["username"].string!)
                        self.ContactIDs.append(contactsJsonObj[i]["contactid"]["_id"].string!)
                        self.ContactFirstname.append(contactsJsonObj[i]["contactid"]["firstname"].string!)
                        self.ContactLastNAme.append(contactsJsonObj[i]["contactid"]["lastname"].string!)
                        self.ContactStatus.append(contactsJsonObj[i]["contactid"]["status"].string!)
                        self.ContactOnlineStatus.append(0)
                    
                        
                        if let rowid = insert.rowid {
                            println("inserted id: \(rowid)")
                            self.tblForChat.reloadData()
                        } else if insert.statement.failed {
                            println("insertion failed: \(insert.statement.reason)")
                        }
                    }
                    
                    //println(error1)
                    //
                    //self.refreshControl.endRefreshing()
                    
                } //else {
                
                //}
            //^^^^^^^})
                println(error1)
                println(response1?.statusCode)
                println("FETCH CONTACTS FAILED")
                println("eeeeeeeeeeeeeeeeeeeeee")
                if(response1?.statusCode==401)
                {
                    println("Refreshinggggggggggggggggggg token expired")
                    if(username==nil || password==nil)
                    {
                        self.performSegueWithIdentifier("loginSegue", sender: nil)
                    }
                    else{
                    self.rt.refrToken()
                    }
                    
                }
                
                
                
            
            
            
        }
        
        println("before whozonline print")
        println(loggedUserObj.object)
        socketObj.socket.emit("whozonline",[
            "room":"globalchatroom",
            "user":loggedUserObj.object])
        

        
   
       
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func unwindToChat (segueSelected : UIStoryboardSegue) {
        println("unwind chat")
      
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //refreshControl.addTarget(self, action: Selector("fetchContacts"), forControlEvents: UIControlEvents.ValueChanged)
        
        println(ContactNames.count)
        return ContactNames.count
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
        var cell=tblForChat.dequeueReusableCellWithIdentifier("ChatPrivateCell") as! ContactsListCell
        
        cell.contactName?.text=ContactNames[indexPath.row]
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
        
        println(ContactNames[indexPath.row])
        self.performSegueWithIdentifier("contactChat", sender: nil);
        //slideToChat
        
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            
             var selectedRow = indexPath.row
            println(selectedRow.description+" selected")
            
            var removeChatFromServer=NetworkingLibAlamofire()
            var loggedFirstName=loggedUserObj["firstname"]
            var loggedLastName=loggedUserObj["lastname"]
            var loggedStatus=loggedUserObj["status"]
            var loggedUsername=loggedUserObj["username"]
            
            println(self.ContactFirstname[selectedRow]+self.ContactLastNAme[selectedRow]+self.ContactStatus[selectedRow]+self.ContactUsernames[selectedRow])
            
            
            
            
            var url=Constants.MainUrl+Constants.removeFriend+"?access_token=\(AuthToken!)"
            
            //var params=self.ContactsObjectss[selectedRow].arrayValue
            //var pp=JSON(params)
            //var bb=jsonString(self.ContactsObjectss[selectedRow].stringValue)
            //var a=JSONStringify(self.ContactsObjectss[selectedRow].object, prettyPrinted: false)
            Alamofire.request(.POST,"\(url)",parameters:["username":"\(self.ContactUsernames[selectedRow])"]
                ).validate(statusCode: 200..<300).responseJSON{
                request1, response1, data1, error1 in
                
                //===========INITIALISE SOCKETIOCLIENT=========
                dispatch_async(dispatch_get_main_queue(), {
                    
                    //self.dismissViewControllerAnimated(true, completion: nil);
                    /// self.performSegueWithIdentifier("loginSegue", sender: nil)
                    
                    if response1?.statusCode==200 {
                        //println("got user success")
                        println("Request success")
                        var json=JSON(data1!)

                        
                        println(json)
                        //println(json)
                        //dataMy=JSON(data1!)
                        //println(dataMy.description)
                        
                        sqliteDB.deleteChat(self.ContactNames[selectedRow])
                        
                        //println(ContactNames[selectedRow]+" deleted")
                        sqliteDB.deleteFriend(self.ContactUsernames[selectedRow])
                        self.ContactNames.removeAtIndex(selectedRow)
                        self.ContactIDs.removeAtIndex(selectedRow)
                        self.ContactFirstname.removeAtIndex(selectedRow)
                        self.ContactLastNAme.removeAtIndex(selectedRow)
                        self.ContactStatus.removeAtIndex(selectedRow)
                        self.ContactUsernames.removeAtIndex(selectedRow)
                        // Delete the row from the data source
                        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                        //tblForChat.reloadData()
                        
                    }
                    else
                    {
                        println("delete friend failed")
                        //var json=JSON(error1!)
                        println(error1?.description)
                        println(response1?.statusCode)
                        //errorMy=JSON(error1!)
                        // println(errorMy.description)
                    }
                })
                    if(response1!.statusCode==401)
                    {
                        println(error1)
                        println("delete friend failed token expired")
                        self.rt.refrToken()
                        
                    }
                    
            }
            //return dataMy
        
        
        
        
        
           /* removeChatFromServer.sendRequestPOST("POST", url: Constants.MainUrl+Constants.removeFriend+"?access_token=\(AuthToken)", parameters1: ["firstname":"\(ContactFirstname[selectedRow])", "lastname":"\(ContactLastNAme[selectedRow])", "status":"\(ContactStatus[selectedRow])", "username" : "\(ContactUsernames[selectedRow])"])
            */
        
        
            
            
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
        
            }
    
    
    
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject]?  {
        // 1
        var shareAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Delete" , handler: { (action:UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in
            // 2
            
            
            /*let shareMenu = UIAlertController(title: nil, message: "Share using", preferredStyle: .ActionSheet)
            
            let twitterAction = UIAlertAction(title: "Twitter", style: UIAlertActionStyle.Default, handler: nil)
            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil)
            
            shareMenu.addAction(twitterAction)
            shareMenu.addAction(cancelAction)
            
            
            self.presentViewController(shareMenu, animated: true, completion: nil)

*/
            
            
            var selectedRow = indexPath.row
            println(selectedRow.description+" selected")
            
            var removeChatFromServer=NetworkingLibAlamofire()
            var loggedFirstName=loggedUserObj["firstname"]
            var loggedLastName=loggedUserObj["lastname"]
            var loggedStatus=loggedUserObj["status"]
            var loggedUsername=loggedUserObj["username"]
            
            println(self.ContactFirstname[selectedRow]+self.ContactLastNAme[selectedRow]+self.ContactStatus[selectedRow]+self.ContactUsernames[selectedRow])
            
            
            
            
            var url=Constants.MainUrl+Constants.removeFriend+"?access_token=\(AuthToken!)"
            
            //var params=self.ContactsObjectss[selectedRow].arrayValue
            //var pp=JSON(params)
            //var bb=jsonString(self.ContactsObjectss[selectedRow].stringValue)
            //var a=JSONStringify(self.ContactsObjectss[selectedRow].object, prettyPrinted: false)
            Alamofire.request(.POST,"\(url)",parameters:["username":"\(self.ContactUsernames[selectedRow])"]
                ).validate(statusCode: 200..<300).responseJSON{
                    request1, response1, data1, error1 in
                    
                    //===========INITIALISE SOCKETIOCLIENT=========
                    dispatch_async(dispatch_get_main_queue(), {
                        
                        //self.dismissViewControllerAnimated(true, completion: nil);
                        /// self.performSegueWithIdentifier("loginSegue", sender: nil)
                        
                        if response1?.statusCode==200 {
                            //println("got user success")
                            println("Request success")
                            var json=JSON(data1!)
                            
                            
                            println(json)
                            //println(json)
                            //dataMy=JSON(data1!)
                            //println(dataMy.description)
                            
                            sqliteDB.deleteChat(self.ContactNames[selectedRow])
                            
                            //println(ContactNames[selectedRow]+" deleted")
                            sqliteDB.deleteFriend(self.ContactUsernames[selectedRow])
                            self.ContactNames.removeAtIndex(selectedRow)
                            self.ContactIDs.removeAtIndex(selectedRow)
                            self.ContactFirstname.removeAtIndex(selectedRow)
                            self.ContactLastNAme.removeAtIndex(selectedRow)
                            self.ContactStatus.removeAtIndex(selectedRow)
                            self.ContactUsernames.removeAtIndex(selectedRow)
                            // Delete the row from the data source
                            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                            //tblForChat.reloadData()
                            
                        }
                        else
                        {
                            println("delete friend failed")
                            //var json=JSON(error1!)
                            println(error1?.description)
                            println(response1?.statusCode)
                            //errorMy=JSON(error1!)
                            // println(errorMy.description)
                        }
                    })
                    if(response1!.statusCode==401)
                    {
                        println(error1)
                        println("delete friend failed token expired")
                        self.rt.refrToken()
                        
                    }
                    
            }

        })
        // 3
        var rateAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Call" , handler: { (action:UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in
            
            //ON CALL BUTTON PRESSED
            
            var selectedRow = indexPath.row
            println("call pressed")
            socketObj.socket.emit("callthisperson",["room" : "globalchatroom","callee": self.ContactUsernames[selectedRow], "caller":username!])
            isInitiator=true
            callerName=username!
            iamincallWith=self.ContactUsernames[selectedRow]
            
            /*var next = self.storyboard?.instantiateViewControllerWithIdentifier("Main2") as! VideoViewController
            
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
        return [shareAction,rateAction]

    }

    
    // #pragma mark - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue?, sender: AnyObject?) {
        //var newController=segue ?.destinationViewController
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        
        //if segue!.identifier == "chatSegue" {
        if segue!.identifier == "contactChat" {
            
            if let destinationVC = segue!.destinationViewController as? ChatDetailViewController{
                
                let selectedRow = tblForChat.indexPathForSelectedRow()!.row
                //destinationVC.selectedContact = ContactNames[selectedRow]
                destinationVC.selectedContact = ContactUsernames[selectedRow]
                destinationVC.selectedFirstName=ContactFirstname[selectedRow]
                destinationVC.selectedLastName=ContactLastNAme[selectedRow]
                destinationVC.selectedID=ContactIDs[selectedRow]
                //destinationVC.AuthToken = self.AuthToken
                
                //
                /* var getUserbByIdURL=Constants.MainUrl+Constants.getSingleUserByID+ContactIDs[selectedRow]+"?access_token="+AuthToken
                println(getUserbByIdURL.debugDescription+"..........")
                Alamofire.request(.GET,"\(getUserbByIdURL)").response{
                request, response, data, error in
                println(error)
                
                if response?.statusCode==200
                
                {
                println("got userrrrrrr")
                println(data?.debugDescription)
                println(":::::::::")
                destinationVC.selectedUserObj=JSON(data!)
                }
                else
                {
                println("didnt get userrrrr")
                println(error)
                println(data)
                println(response)
                }
                }*/
                
                //
            }
        }
        
    }
    
}


