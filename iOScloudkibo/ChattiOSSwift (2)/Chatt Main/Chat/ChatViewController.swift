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

class ChatViewController: UIViewController,SocketClientDelegate {
    var rt=NetworkingLibAlamofire()
    
    var refreshControl = UIRefreshControl()
    @IBOutlet var viewForTitle : UIView!
    @IBOutlet var ctrlForChat : UISegmentedControl!
    @IBOutlet var btnForLogo : UIButton!
    var loggedID=loggedUserObj["_id"]
    @IBOutlet var tblForChat : UITableView!
    @IBOutlet weak var btnContactAdd: UIBarButtonItem!
    
    var currrentUsernameRetrieved:String=""
    var delegate:SocketClientDelegate!
    ////////let delegateController=LoginAPI(url: "sdfsfes")
    
    
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
            
            var addContactUsernameURL=Constants.MainUrl+Constants.addContactByEmail+"?access_token=\(AuthToken!)"
           
            
            Alamofire.request(.POST,"\(addContactUsernameURL)",parameters: ["searchemail":"\(tField.text!)"])
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
            var addContactUsernameURL=Constants.MainUrl+Constants.addContactByUsername+"?access_token=\(AuthToken!)"
            Alamofire.request(.POST,"\(addContactUsernameURL)",parameters: ["searchusername":"\(tField.text!)"]).validate(statusCode: 200..<300).responseJSON{response in
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
                        {print("Invalid user")}
                        else
                        {
                            if(json["status"].string=="danger"){
                                print("contact already in your list")}
                            else
                            {print("friend request sent")}
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
    }
    
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

    
   
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Chat ViewController is loadingggggg")
        socketObj.delegate=self
        if(isConference == true)
        {
            self.dismissViewControllerAnimated(true,completion: nil)
        }
        
        if(KeychainWrapper.stringForKey("username") != nil)
        {currrentUsernameRetrieved=KeychainWrapper.stringForKey("username")!
        
        if(loggedUserObj == JSON("[]"))
        {
            var lusername=KeychainWrapper.stringForKey("username")
            
            var lid=KeychainWrapper.stringForKey("_id")
            
            var lobj=["_id" : lid!, "username" : lusername!]
            ///////////////////not supported ^^^^^^^^^^^newwwif let dataFromString = jsonString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false) {
                let json11 = JSON(lobj.debugDescription)
                
                var lllooo = json11
                loggedUserObj=json11
                loggedUserObj.object=json11.object
                print(lllooo.object)
                
                
                
                
                
                //var jsonNew=JSON("{\"room\": \"globalchatroom\",\"user\": {\"username\":\"sabachanna\"}}")
                //socketObj.socket.emit("join global chatroom", ["room": "globalchatroom", "user": ["username":"sabachanna"]]) WORKINGGG
                
                
                /*
                
                var logonjuser=KeychainWrapper.stringForKey("loggedUserObjString")
                var newloggedUserObj=logonjuser!.stringByResolvingSymlinksInPath
                print("newloggeduserobj string")
                print(newloggedUserObj)
                if let dataFromString = jsonString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false) {
                let json11 = JSON(newloggedUserObj)
                
                print("json11 object")
                print(json11.object)
                
                loggedUserObj=json11
                
                
                print("joining rooon \(json11.object)")
                socketObj.socket.emit("join global chatroom",["room": "globalchatroom", "user": json11.object])
                
                }*/
            ///////////////////////not supported}
            
        }
        
        }//end if username definned
        
        print("loadddddd", terminator: "")
        if(socketObj == nil)
        {
            print("socket is nillll", terminator: "")
            
            
            socketObj=LoginAPI(url:"\(Constants.MainUrl)")
           /////////// print("connected issssss \(socketObj.socket.connected)")
           ///socketObj.connect()
            socketObj.addHandlers()
        }

    
        
        
   
        //:::::::::::::::::::::::::::::::::::::::::::::::::::::::::
       //////////////////////////////
        /*
        socketObj.socket.on("othersideringing"){data,ack in
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
            
        }

        */
        
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
     //   print("logged id key chain is \(loggedIDKeyChain)")
        
        
        self.navigationItem.titleView = viewForTitle
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: btnForLogo)
        //self.navigationItem.rightBarButtonItem = itemForSearch
        self.navigationItem.rightBarButtonItem = btnContactAdd
        self.tabBarController?.tabBar.tintColor = UIColor.greenColor()
        print("////////////////////// new class tokn \(AuthToken)", terminator: "")
        // fetchContacts(AuthToken)
        print(self.ContactNames.count.description, terminator: "")
        // self.tblForChat.reloadData()
        
        
        /////////////----------------------================================++++++++++
       
        

        //((((((((()))))))___________++++++++++++__________++++++++++++((((((((((()))))))))
    
        

        
        
        
        
        
        //========
        socketObj.socket.on("online")
            {data,ack in
                    
                    print("online status...")
                    var onlineUsers=JSON(data)
                    print(onlineUsers[0])
                    //print(onlineUsers[0]["username"])
                
                for(var i=0;i<onlineUsers.count;i++)
                {
                    for(var j=0;j<self.ContactUsernames.count;j++)
                    {
                        if self.ContactUsernames[j]==onlineUsers[i]["username"].string!
                        {
                            //found online contact,s username
                            print("user found onlineeeee \(self.ContactUsernames[j])")
                            self.ContactOnlineStatus[j]=1
                            self.tblForChat.reloadData()
                        }
                    }
                }
                
                }
        
       

     
        
        //======Offline users=========
        socketObj.socket.on("offline")
            {data,ack in
                
                print("offline status...")
                var offlineUsers=JSON(data)
                print(offlineUsers[0])
                //print(offlineUsers[0]["username"])
                
                for(var i=0;i<offlineUsers.count;i++)
                {
                    for(var j=0;j<self.ContactUsernames.count;j++)
                    {
                        if self.ContactUsernames[j]==offlineUsers[i]["username"].string!
                        {
                            //found online contact,s username
                            print("user found offlinee \(self.ContactUsernames[j])")
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
        AuthToken=""
        ///////////////if(sqliteDB.db != nil)
        if(sqliteDB.accounts != nil && sqliteDB.contactslists != nil && sqliteDB.userschats != nil)
        {
        var tbl_contactslists=sqliteDB.contactslists
        var tbl_accounts=sqliteDB.accounts
        let tbl_userchats=sqliteDB.userschats
        
        
        ///try db.run(users.delete())
            do{
        try sqliteDB.db.run(tbl_contactslists.delete())
        try sqliteDB.db.run(tbl_accounts.delete())
        try sqliteDB.db.run(tbl_userchats.delete())
            }catch{
                print("cannot delete tables")
            }
        
            print("deletinggggg tablessss")
        /*tbl_contactslists.delete()
        tbl_accounts.delete()
        tbl_userchats.delete()*/
        }
        
        
        KeychainWrapper.removeObjectForKey("access_token")
        KeychainWrapper.removeObjectForKey("username")
        KeychainWrapper.removeObjectForKey("password")
        KeychainWrapper.removeObjectForKey("loggedFullName")
        KeychainWrapper.removeObjectForKey("loggedPhone")
        KeychainWrapper.removeObjectForKey("loggedEmail")
        KeychainWrapper.removeObjectForKey("_id")
        loggedUserObj=JSON("[]")
        
        //let dbSQLite=DatabaseHandler(dbName: "/cloudKibo.sqlite3")
        print("loggedout", terminator: "")

        
        
        let retrievedToken=KeychainWrapper.stringForKey("access_token")
        if (retrievedToken==nil && isConference == false)
        {performSegueWithIdentifier("loginSegue", sender: nil)}
        else
        {print("rrrrrrrrr \(retrievedToken)", terminator: "")
            refreshControl.addTarget(self, action: Selector("fetchContacts"), forControlEvents: UIControlEvents.ValueChanged)
            
            /*^^^^^^newwww socketObj.socket.on("othersideringing"){data,ack in
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
                
            }
            */
            //fetchContacts()
            self.tblForChat.reloadData()
            //performSegueWithIdentifier("loginSegue", sender: nil)
        }
        
        
        
        
        // Do any additional setup after loading the view.
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        print("appearrrrrr", terminator: "")
        //socketObj.addHandlers()
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
                print(lllooo.object)
                //var jsonNew=JSON("{\"room\": \"globalchatroom\",\"user\": {\"username\":\"sabachanna\"}}")
                //socketObj.socket.emit("join global chatroom", ["room": "globalchatroom", "user": ["username":"sabachanna"]]) WORKINGGG
                
                socketObj.socket.emit("join global chatroom",["room": "globalchatroom", "user": lllooo.object])
                
               // print(lllooo["_id"])

            }
            /*var lll=KeychainWrapper.stringForKey("loggedIDKeyChain")
            print("------------------")
            print(lll!.stringByDeletingPathExtension)
            print("------------------")
            print(lll!.stringByRemovingPercentEncoding)
            print("------------------")
            print(lll!.stringByResolvingSymlinksInPath)
            loggedUserObj = JSON(lll!.stringByResolvingSymlinksInPath)
            */
            */
        
        print("khul raha hai1", terminator: "")
        ///^^^^^^^neww let retrievedToken=KeychainWrapper.stringForKey("access_token")
        //var retrievedToken:String!
        let retrievedToken=KeychainWrapper.stringForKey("access_token")
        print("khul raha hai2", terminator: "")
        print(loggedUserObj.object)
        //let retrievedUsername=KeychainWrapper.stringForKey("username")
        //if retrievedToken==nil || retrievedUsername==nil
        if (retrievedToken == nil && isConference == false)
            {performSegueWithIdentifier("loginSegue", sender: nil)}
        else
        {
        //^^^^^^^^^^^newwwww ************* 
            
            fetchContacts()
           //^^^^^^^^^^^^newwwww 
            self.fetchContactsFromServer()
             ////////self.fetchContactsFromServer()
            ///////////////////dispatch_async(dispatch_get_main_queue(), {
               
                self.tblForChat.reloadData()
                
            //^^^^^^^^^^^newwwww ******* 
           /////// })
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
        ////////////////////////
        self.ContactFirstname.removeAll(keepCapacity: false)
        ////////
        
        self.ContactsPhone.removeAll(keepCapacity: false)
        self.ContactsEmail.removeAll(keepCapacity: false)
        
        let tbl_contactslists=sqliteDB.contactslists
        do{
        for tblContacts in try sqliteDB.db.prepare(tbl_contactslists){
           print("queryy runned count is \(tbl_contactslists.count)")
            print(tblContacts[firstname]+" "+tblContacts[lastname])
            //ContactsObjectss.append(tblContacts[contactid])
            ContactNames.append(tblContacts[firstname]+" "+tblContacts[lastname])
            ContactUsernames.append(tblContacts[username])
            ContactIDs.append(tblContacts[userid])
            ContactFirstname.append(tblContacts[firstname])
            ContactLastNAme.append(tblContacts[lastname])
            ContactStatus.append(tblContacts[status])
            ContactsEmail.append(tblContacts[email])
            ContactsPhone.append(tblContacts[phone])
            ContactOnlineStatus.append(0)

        }
        }catch
        {
            print("query not runned contactlist")
        }
        //====These are Online====
        
       /* socketObj.socket.on("theseareonline")
            {data,ack in
                
                print("theseareonline status...")
                var theseareonlineUsers=JSON(data!)
                //print(theseareonlineUsers.object)
                //print(offlineUsers[0]["username"])
                
                for(var i=0;i<theseareonlineUsers[0].count;i++)
                {
                    for(var j=0;j<self.ContactUsernames.count && i<theseareonlineUsers.count;j++)
                    {
                        //print(theseareonlineUsers[i].description)
                        //print(theseareonlineUsers.count)
                        //print(theseareonlineUsers[0][0].description)
                        //print(self.ContactUsernames[j])
                        if self.ContactUsernames[j]==theseareonlineUsers[0][i]["username"].description
                        {
                            //found online contact,s username
                            print("user found theseareonline \(self.ContactUsernames[j])")
                            self.ContactOnlineStatus[j]=1
                            self.tblForChat.reloadData()
                        }
                    }
                }
                
        }*/
        
        /*
        socketObj.socket.on("yesiamfreeforcall"){data,ack in
            var message=JSON(data!)
            print("other user is free")
            print(data?.debugDescription)
            
        //socketObj.socket.emit("othersideringing", ["callee": message["me"].string!])
            
        }*/
        
        currrentUsernameRetrieved=KeychainWrapper.stringForKey("username")!
        
        
        
        /*
        socketObj.socket.on("areyoufreeforcall") {data,ack in
            var jdata=JSON(data!)
            print("somebody callinggg  \(data) \(ack)")
            
            if(areYouFreeForCall==true)
            {
                print(jdata[0]["caller"].string!)
                print(self.currrentUsernameRetrieved)
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
                
                print("i am busyyy")
                    
                }
                
            
                //self.presentViewController(CallRingingViewController(), animated: true, completion: {print("call screen shown")}
                
                //)

                
                //socketObj.socket.emit("message","Accept Call")
                //socketObj.socket.emit("message","Accept")
                
                //show screen
            
        }
        
        */
        
        //room callee callthisperson
        
        //==========Show Online============
        
       
    
    }
    
    
    //======================================
    //to fetch contacts from server
    
    func fetchContactsFromServer(){
        print("Server fetchingg contactss", terminator: "")
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
            /*if let dataFromString = jsonString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false) {
                let json11 = JSON(lobj.debugDescription)
                
                var lllooo = json11
                loggedUserObj=json11
                loggedUserObj.object=json11.object
                print(lllooo.object)
                //var jsonNew=JSON("{\"room\": \"globalchatroom\",\"user\": {\"username\":\"sabachanna\"}}")
                //socketObj.socket.emit("join global chatroom", ["room": "globalchatroom", "user": ["username":"sabachanna"]]) WORKINGGG
                
                
                /*
                
                var logonjuser=KeychainWrapper.stringForKey("loggedUserObjString")
                var newloggedUserObj=logonjuser!.stringByResolvingSymlinksInPath
                print("newloggeduserobj string")
                print(newloggedUserObj)
                if let dataFromString = jsonString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false) {
                let json11 = JSON(newloggedUserObj)
                
                print("json11 object")
                print(json11.object)
                
                loggedUserObj=json11
                
                
                print("joining rooon \(json11.object)")
                socketObj.socket.emit("join global chatroom",["room": "globalchatroom", "user": json11.object])
                
                }*/
            }*/
            
        }
        

        var fetchChatURL=Constants.MainUrl+Constants.getContactsList+"?access_token="+AuthToken!
        
        print(fetchChatURL, terminator: "")
        
        
        Alamofire.request(.GET,"\(fetchChatURL)").validate(statusCode: 200..<300)
            .response { (request1, response1, data1, error1) in
                print("success")

            
            
            
            //============GOT Contacts SECCESS=================
            
            
            ////////////////////////
           //^^^^^ dispatch_async(dispatch_get_main_queue(), {
                //self.fetchContacts(self.AuthToken)
                /// activityOverlayView.dismissAnimated(true)
                
                
                if response1?.statusCode==200 {
                    
                    if(glocalChatRoomJoined == false)
                    {
                        //socketObj.addHandlers()
                    print("joiningggggg")
                        //var lll=KeychainWrapper.stringForKey("loggedIDKeyChain")
                        var lll=KeychainWrapper.stringForKey("loggedUserObjString")
                        
                        //loggedUserObjString
                        
                        
                        
                        
                        
                        /*
                        /////////////////////////////////////////////////
                        
                        COMENTED TEMPERORARILY AS A FUNCTION stringByR IOS9
                        LOGIN LOGOUT NEEDED ISSUE
                        
                        //////////////////////////////////////////////////
                        
                        print("------------------")
                        print(lll!.stringByDeletingPathExtension)
                        print("------------------")
                        print(lll!.stringByRemovingPercentEncoding)
                        print("------------------")
                        print(lll!.stringByResolvingSymlinksInPath)
                        var ssss=lll!.stringByResolvingSymlinksInPath
                        
                        if let dataFromString = jsonString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false) {
                            let json22 = JSON(ssss)
                            
                            print(";;;;;;;;;")
                            print(json22.object)
                            
                        loggedUserObj = json22
                            
                            
                            

                        //var lllloooobbbb = json22
                          //  var dd:[AnyObject]=json22.rawValue as! [AnyObject]
                   /// socketObj.socket.emit("join global chatroom",["room":"globalchatroom","user":loggedUserObj.object])
                        ///socketObj.socket.emit("join global chatroom", ["room": "globalchatroom", "user": json22.object])
                            socketObj.socket.emit("join global chatroom", ["room": "globalchatroom", "user": ["username":KeychainWrapper.stringForKey("username")!]])
                        }
*/
                     
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
                        self.ContactsObjectss.append(contactsJsonObj[i]["contactid"])
                        self.ContactNames.append(contactsJsonObj[i]["contactid"]["firstname"].string!+" "+contactsJsonObj[i]["contactid"]["lastname"].string!)
                        self.ContactUsernames.append(contactsJsonObj[i]["contactid"]["username"].string!)
                        self.ContactIDs.append(contactsJsonObj[i]["contactid"]["_id"].string!)
                        self.ContactFirstname.append(contactsJsonObj[i]["contactid"]["firstname"].string!)
                        self.ContactLastNAme.append(contactsJsonObj[i]["contactid"]["lastname"].string!)
                        self.ContactStatus.append(contactsJsonObj[i]["contactid"]["status"].string!)
                        self.ContactsPhone.append(contactsJsonObj[i]["contactid"]["phone"].string!)
                        self.ContactsEmail.append(contactsJsonObj[i]["contactid"]["email"].string!)
                        self.ContactOnlineStatus.append(0)
                        
                        print("inserted id: \(rowid)")
                        self.tblForChat.reloadData()
                    } catch {
                        print("insertion failed: \(error)")
                        }
                        
                    }
                        /*let insert=tbl_contactslists.insert(contactid<-contactsJsonObj[i]["contactid"]["_id"].string!,
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
                            print("inserted id: \(rowid)")
                            self.tblForChat.reloadData()
                        } else if insert.statement.failed {
                            print("insertion failed: \(insert.statement.reason)")
                        }
                    }
                    */
                    //print(error1)
                    //
                    //self.refreshControl.endRefreshing()
                    
                } //else {
                
                //}
            //^^^^^^^})
                print(error1)
                print(response1?.statusCode)
                print("FETCH CONTACTS FAILED")
                print("eeeeeeeeeeeeeeeeeeeeee")
                if(response1?.statusCode==401)
                {
                    print("Refreshinggggggggggggggggggg token expired")
                    if(username==nil || password==nil)
                    {
                        self.performSegueWithIdentifier("loginSegue", sender: nil)
                    }
                    else{
                    self.rt.refrToken()
                    }
                    
                }
                
                
                
            
            
            
        }
        
        print("before whozonline print", terminator: "")
        print(loggedUserObj.object)
        socketObj.socket.emit("whozonline",[
            "room":"globalchatroom",
            "user":loggedUserObj.object])
        

        
   
       
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
        
        print(ContactNames.count, terminator: "")
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
        let cell=tblForChat.dequeueReusableCellWithIdentifier("ChatPrivateCell") as! ContactsListCell
        
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
        
        print(ContactNames[indexPath.row], terminator: "")
        self.performSegueWithIdentifier("contactChat", sender: nil);
        //slideToChat
        
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            
             var selectedRow = indexPath.row
            print(selectedRow.description+" selected", terminator: "")
            
            var removeChatFromServer=NetworkingLibAlamofire()
            var loggedFirstName=loggedUserObj["firstname"]
            var loggedLastName=loggedUserObj["lastname"]
            var loggedStatus=loggedUserObj["status"]
            var loggedUsername=loggedUserObj["username"]
            
            print(self.ContactFirstname[selectedRow]+self.ContactLastNAme[selectedRow]+self.ContactStatus[selectedRow]+self.ContactUsernames[selectedRow], terminator: "")
            
            
            
            
            var url=Constants.MainUrl+Constants.removeFriend+"?access_token=\(AuthToken!)"
            
            //var params=self.ContactsObjectss[selectedRow].arrayValue
            //var pp=JSON(params)
            //var bb=jsonString(self.ContactsObjectss[selectedRow].stringValue)
            //var a=JSONStringify(self.ContactsObjectss[selectedRow].object, prettyPrinted: false)
            Alamofire.request(.POST,"\(url)",parameters:["username":"\(self.ContactUsernames[selectedRow])"]
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
        }
        
            }
    
    
    
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject]?  {
        // 1
        var shareAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Delete" , handler: { (action:UITableViewRowAction, indexPath:NSIndexPath) -> Void in
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
            
            
            
            
            var url=Constants.MainUrl+Constants.removeFriend+"?access_token=\(AuthToken!)"
            
            //var params=self.ContactsObjectss[selectedRow].arrayValue
            //var pp=JSON(params)
            //var bb=jsonString(self.ContactsObjectss[selectedRow].stringValue)
            //var a=JSONStringify(self.ContactsObjectss[selectedRow].object, prettyPrinted: false)
            Alamofire.request(.POST,"\(url)",parameters:["username":"\(self.ContactUsernames[selectedRow])"]
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

        })
        // 3
        var rateAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Call" , handler: { (action:UITableViewRowAction, indexPath:NSIndexPath) -> Void in
            
            //ON CALL BUTTON PRESSED
            
            var selectedRow = indexPath.row
            print("call pressed")
            
            username = "iphoneUser"
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
            var mAudio=MeetingRoomAudio()
            mAudio.initAudio()
            
            var next = self.storyboard?.instantiateViewControllerWithIdentifier("Main2") as! ConferenceCallViewController
            
            self.presentViewController(next, animated: false, completion: {
            })
            /////mVideo.initVideo()
            
            
            /*let next = self.storyboard!.instantiateViewControllerWithIdentifier("Main2") as! VideoViewController
            
            self.presentViewController(next, animated: true, completion:nil)
            */
            
            
            //////////////////////////////
            //CORRECT CODE ONE TO ONE CALL COMMENTED
            //////////////////////////////
            /*
            socketObj.socket.emit("callthisperson",["room" : "globalchatroom","callee": self.ContactUsernames[selectedRow], "caller":username!])
            isInitiator=true
            callerName=username!
            iamincallWith=self.ContactUsernames[selectedRow]
*/
            
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
                destinationVC.selectedFirstName=ContactFirstname[selectedRow]
                destinationVC.selectedLastName=ContactLastNAme[selectedRow]
                destinationVC.selectedID=ContactIDs[selectedRow]
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
        
    }
    
    
    ///////////////////////////////
    //SOCKET CLIENT DELEGATE MESSAGES
    ///////////////////////////////
    
    func socketReceivedMessage(message:String,data:AnyObject!)
    {print("socketReceivedMessage inside", terminator: "")
        //var msg=JSON(params)
        switch(message)
        {
        case "othersideringing":
       // print(msg.debugDescription)
        callerName=KeychainWrapper.stringForKey("username")!
        //iamincallWith=msg[0]["callee"].string!
        
        print("callee is \(callerName)", terminator: "")
        
        var next = self.storyboard!.instantiateViewControllerWithIdentifier("Main2") as! VideoViewController
        
        self.presentViewController(next, animated: true, completion: {
        })
            
        case "offline":
            
            
                    print("offline status...", terminator: "")
                    var offlineUsers=JSON(data!)
                    print(offlineUsers[0])
                    //print(offlineUsers[0]["username"])
                    
                    for(var i=0;i<offlineUsers.count;i++)
                    {
                        for(var j=0;j<self.ContactUsernames.count;j++)
                        {
                            if self.ContactUsernames[j]==offlineUsers[i]["username"].string!
                            {
                                //found online contact,s username
                                print("user found offlinee \(self.ContactUsernames[j])")
                                self.ContactOnlineStatus[j]=0
                                self.tblForChat.reloadData()
                            }
                        }
                    }
            
            case "theseareonline":
               
                        print("theseareonline status...", terminator: "")
                        var theseareonlineUsers=JSON(data!)
                        //print(theseareonlineUsers.object)
                        //print(offlineUsers[0]["username"])
                        
                        for(var i=0;i<theseareonlineUsers[0].count;i++)
                        {
                            for(var j=0;j<self.ContactUsernames.count && i<theseareonlineUsers.count;j++)
                            {
                                if self.ContactUsernames[j]==theseareonlineUsers[0][i]["username"].description
                                {
                                    //found online contact,s username
                                    print("user found theseareonline \(self.ContactUsernames[j])")
                                    self.ContactOnlineStatus[j]=1
                                    self.tblForChat.reloadData()
                                }
                            }
                        }
            
            
        case "yesiamfreeforcall":
                var message=JSON(data!)
                print("other user is free", terminator: "")
                print(data?.debugDescription, terminator: "")
            
            
        case "areyoufreeforcall":
        
            var jdata=JSON(data!)
        print("areyoufreeforcall ......", terminator: "")
            print(jdata.debugDescription)
            
            if(areYouFreeForCall==true)
            {
                print(jdata[0]["caller"].string!)
                print(self.currrentUsernameRetrieved, terminator: "")
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
                
                print("i am busyyy", terminator: "")
                
            }
         
            
        
            

        default: print("", terminator: "")
        
        }//end switch

    }
    func socketReceivedSpecialMessage(message:String,params:JSON!)
    {
        
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


