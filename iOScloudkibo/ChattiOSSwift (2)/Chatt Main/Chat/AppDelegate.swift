//
//  AppDelegate.swift
//  Chat
//
//  Created by My App Templates Team on 24/08/14.
//  Copyright (c) 2014 My App Templates. All rights reserved.
//

import UIKit
import SQLite
import SwiftyJSON
import Alamofire
import Contacts
import CloudKit
import AccountKit
import Fabric
import Crashlytics
import Foundation
import SystemConfiguration
import AVFoundation

//import UserNotifications
//import WindowsAzureMessaging



var addressbookChangedNotifReceived=false
var aaaaa:SBNotificationHub!
var uploadInfo:NSMutableArray!
 var managerFile = NetworkingManager.sharedManager
var selectedText=""
var chatDetailView:ChatDetailViewController!
var goBack=false
var countrycode:String! = KeychainWrapper.stringForKey("countrycode")
let configuration1 = NSURLSessionConfiguration.backgroundSessionConfigurationWithIdentifier("com.example.app.background")
let manager = Alamofire.Manager(configuration: configuration1)

var endedCall=false
var accountKit:AKFAccountKit!
var displayname=""
////////var selectedEmails=[String]() // moved to contactsinviteviewcontroller
var emailList=[String]()
var nameList=[String]()
var phonesList=[String]()
var notAvailableEmails=[String]()
var contacts = [CNContact]()
var availableEmailsList=[String]()
var profileimageList=[NSData]()
var uniqueidentifierList=[String]()

var isFileReceived=false
var meetingStarted=false
var isSocketConnected=false
var delegateScreen:AppDelegateScreenDelegate!
var screenCaptureToggle:Bool=false
var webMeetingModel=webmeetingMsgsModel()
//let socketObj=LoginAPI(url:"\(Constants.MainUrl)")
var socketObj:LoginAPI!=nil
let sqliteDB=DatabaseHandler(dbName:"cloudkibo.sqlite3")
////let sqliteDB=DatabaseHandler(dbName: "")
//%%%%%%%%%%%%var AuthToken=KeychainWrapper.stringForKey("access_token")
var AuthToken:String!=nil
var loggedUserObj=JSON("[]")
var globalChatRoomJoined:Bool=false
//let dbSQLite=DatabaseHandler(dbName: "/cloudKibo.sqlite3")

//%%%%%%%%%%%%%%%% new phone model
var username:String! = KeychainWrapper.stringForKey("username")
//var username:String!="sadia1"
var password=KeychainWrapper.stringForKey("password")
let loggedFullName=KeychainWrapper.stringForKey("loggedFullName")
let loggedPhone=KeychainWrapper.stringForKey("loggedPhone")
let loggedEmail=KeychainWrapper.stringForKey("loggedEmail")
let _id=KeychainWrapper.stringForKey("_id")
var globalroom="globalchatroom"
var joinedRoomInCall=""
//%%%%%%%%
var currentID:Int! = -1
var otherID:Int!
//let loggedIDKeyChain=KeychainWrapper.stringForKey("loggedIDKeyChain")

//from id, to id remaining
//mark chat as read is remaining
var isConference = false
var ConferenceRoomName = ""
var atimer:NSTimer!
var areYouFreeForCall:Bool=true
var iamincallWith:String!
var isInitiator=false
var callerName=""
var rtcICEarray:[RTCICEServer]=[]
var rtcFact:RTCPeerConnectionFactory!
var contactsList=iOSContact(keys: [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactEmailAddressesKey, CNContactPhoneNumbersKey])

var filejustreceivednameToSave:String!
var filejustreceivedname:String!
var filejustreceivedPathURL:NSURL!
var urlLocalFile:NSURL!
var iOSstartedCall=false
var firstTimeLogin=false
var header:[String:String]=["kibo-token":""]
var delegateRefreshChat:UpdateChatViewsDelegate!
//var appJustInstalled=[Bool]()
var reachability:Reachability!;


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,AppDelegateScreenDelegate {
    
    var window: UIWindow?
   // private var reachability:Reachability!;
    
    //  var window: UIWindow?
    
    
    /*func application(application: UIApplication, willFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
        
        print("launchingggggggggg")
        return true
    }*/
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        print("========launchhhhhhhhh=====")
        print(NSDate())
        
        print("notifications ... \(launchOptions?.debugDescription)")
        
        /*
         // Handle launching from a notification
         UILocalNotification *locationNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
         if (locationNotification) {
         // Set icon badge number to zero
         application.applicationIconBadgeNumber = 0;
         }
 
         */
        
        
     /*   UserNotificationCenter.current().requestAuthorization([.alert, .sound, .badge]
            { (granted, error) in
               // ...
            }
     */
        uploadInfo=NSMutableArray()
        Fabric.with([Crashlytics.self])
        
        UIApplication.sharedApplication().setStatusBarHidden(true, withAnimation: UIStatusBarAnimation.Fade);
        
        UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.LightContent, animated: false);
        
        
       /* do{reachability = try Reachability.reachabilityForInternetConnection()
        try reachability.startNotifier();
          //  NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("checkForReachability:"), name:ReachabilityChangedNotification, object: reachability)
        }
        catch{
            print("error in reachability")
        }*/
        
        
        //RESET TEMP
        
 /*  if(username != nil)
{
 KeychainWrapper.removeObjectForKey("username")
        KeychainWrapper.removeObjectForKey("loggedFullName")
        KeychainWrapper.removeObjectForKey("countrycode")
 }*/
 
      /////  KeychainWrapper.removeObjectForKey("username")
        
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        //var socketObj=LoginAPI(url:"\(Constants.MainUrl)")
        webMeetingModel.delegateScreen=self
        UIApplication.sharedApplication().networkActivityIndicatorVisible=true
        print("appdidFinishLaunching")
        
        
        
        
        
        
        
        if(socketObj == nil)
        {
            print("socket is nillll", terminator: "")
           //dispatch_async(dispatch_get_main_queue())
            //{
            socketObj=LoginAPI(url:"\(Constants.MainUrl)")
            ///socketObj.connect()
//            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND,0))
//{
            socketObj.addHandlers()
            socketObj.addWebRTCHandlers()
            //}
//}
        }
        
     
        
        
        
        /*
         UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeSound |
         UIUserNotificationTypeAlert | UIUserNotificationTypeBadge categories:nil];
         
         [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
         [[UIApplication sharedApplication] registerForRemoteNotifications];
 */
        
        
        
        
        let notificationTypes: UIUserNotificationType = [UIUserNotificationType.Alert, UIUserNotificationType.Badge, UIUserNotificationType.Sound]
        
        //let notificationTypes: UIUserNotificationType = [UIUserNotificationType.None]
       
        
        let pushNotificationSettings = UIUserNotificationSettings(forTypes: notificationTypes, categories: nil)
        
        
        
        /////-------will be commented----
        //application.registerUserNotificationSettings(pushNotificationSettings)
        //application.registerForRemoteNotifications()
  
        
        //^^^^^^^^^^^^^^^^^^^
        
      //  print("username is \(username!)")
     if(username != nil && username != "")
        {
        UIApplication.sharedApplication().registerUserNotificationSettings(pushNotificationSettings)
       }
        
        /////NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("contactChanged:"), name: CNContactStoreDidChangeNotification, object: nil)

        /*[[NSNotificationCenter defaultCenter] addObserver:self
            selector:@selector(aWindowBecameMain:)
        name:NSWindowDidBecomeMainNotification object:nil];*/
 
        
        //Moving to on-connect
        
        /*
        if(username != nil && username != "")
        {
            print("calling synchronise chat from App Delegate")
            self.synchroniseChatData()
        }
        */
        
        
        ///UIApplication.sharedApplication().registerForRemoteNotificationTypes(notificationTypes)
        
        /*if let remoteNotification = launchOptions?[UIApplicationLaunchOptionsRemoteNotificationKey] as? NSDictionary {
            // ...do stuff...
            print("received notification in background .... \(remoteNotification.description)")
        }
        */
        ///old code
        /*
        if(UIApplication.instancesRespondToSelector(Selector("registerUserNotificationSettings:"))) {
            
            UIApplication.sharedApplication().registerUserNotificationSettings(pushNotificationSettings)
            ///UIApplication.sharedApplication().registerUserNotificationSettings(UIUserNotificationSettings(forTypes: .Alert | .Badge, categories: nil))
        }*/
        
       // return true
        
        
        
       // application.registerUserNotificationSettings(UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: nil))  // types are UIUserNotificationType members
        
        //application.registerForRemoteNotifications()

        /*var fileManager=NSFileManager.defaultManager()
        var currentiCloudToken=fileManager.ubiquityIdentityToken
        if(currentiCloudToken != nil)
            {
                print("currentiCloudToken is \(currentiCloudToken)")
                var newTokenData:NSData=NSKeyedArchiver.archivedDataWithRootObject(currentiCloudToken!)
                NSUserDefaults.standardUserDefaults().setObject(newTokenData, forKey: "com.apple.Chat.UbiquityIdentityToken")
                
            }
        else{
                NSUserDefaults.standardUserDefaults().removeObjectForKey("com.apple.Chat.UbiquityIdentityToken")
            }
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "iCloudAccountAvailabilityChanged:",name: nil, object: nil)*/
        
        /*
NSFileManager* fileManager = [NSFileManager defaultManager];
id currentiCloudToken = fileManager.ubiquityIdentityToken;
        if (currentiCloudToken) {
        NSData *newTokenData =
        [NSKeyedArchiver archivedDataWithRootObject: currentiCloudToken];
        [[NSUserDefaults standardUserDefaults]
        setObject: newTokenData
        forKey: @"com.apple.MyAppName.UbiquityIdentityToken"];
        } else {
        [[NSUserDefaults standardUserDefaults]
        removeObjectForKey: @"com.apple.MyAppName.UbiquityIdentityToken"];
        }
        
        [[NSNotificationCenter defaultCenter]
        addObserver: self
        selector: @selector (iCloudAccountAvailabilityChanged:)
        name: NSUbiquityIdentityDidChangeNotification
        object: nil];

        */
        
       
       
        /*
            socketObj.socket.connect()
            socketObj.addHandlers()
            socketObj.addWebRTCHandlers()
            //socketConnected=true
            
        */

     
        
        
        
        return true
        
    }
    
   /* func checkForReachability(notification:NSNotification)
    {
        print("checking internet...")
        // Remove the next two lines of code. You cannot instantiate the object
        // you want to receive notifications from inside of the notification
        // handler that is meant for the notifications it emits.
        
        //var networkReachability = Reachability.reachabilityForInternetConnection()
        //networkReachability.startNotifier()
        
        let networkReachability = notification.object as! Reachability;
        var remoteHostStatus = networkReachability.currentReachabilityStatus
        
        if (remoteHostStatus == Reachability.NetworkStatus.NotReachable)
        {
            print("Not Reachable")
        }
        else if (remoteHostStatus == Reachability.NetworkStatus.ReachableViaWiFi)
        {
            print("Reachable via Wifi")
            if(username != nil && username != "")
            {
                self.synchroniseChatData()
            }
        }
        else
        {
            print("Reachable")
            if(username != nil && username != "")
            {
                self.synchroniseChatData()
            }
        }
    }*/
    
   /* func contactChanged(notification : NSNotification)
    {
        print("contact changed notification received")
        var userInfo: NSDictionary!
        userInfo = notification.userInfo
        print(userInfo.allKeys.debugDescription)
        var sync=syncContactService.init()
        sync.startContactsRefresh()
        
        
    }*/

 /*   func synchroniseChatData()
    {
        print("synchronise called")
        if(accountKit == nil){
            accountKit = AKFAccountKit(responseType: AKFResponseType.AccessToken)
        }
        if (accountKit!.currentAccessToken != nil) {
            
            header=["kibo-token":accountKit!.currentAccessToken!.tokenString]
            
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
                if(socketObj != nil){
                    socketObj.socket.emit("error getting data from accounts table")
                }
                print("error in getting data from accounts table")
                
            }
            
            //  dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) {
            
            
            //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            // if(socketObj != nil)
            // {
            managerFile.checkPendingFiles(username!)
            self.sendPendingChatMessages({ (result) -> () in
                print("checkin here pending messages sent")
                print("checkin fetching chats")
                // if(socketObj != nil)
                //{
                socketObj.fetchChatsFromServer()
                //}
                
            })
        }
    }*/
    

    
    
    
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
        let type = Expression<String>("type")
        let file_type = Expression<String>("file_type")
        
        
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
                var imParas=["from":pendingchats[from],"to":pendingchats[to],"fromFullName":pendingchats[fromFullName],"msg":pendingchats[msg],"uniqueid":pendingchats[uniqueid],"type":pendingchats[type],"file_type":pendingchats[file_type]]
                
                print("imparas are \(imParas)")
                print(imParas, terminator: "")
                print("", terminator: "")
                
                //////// if(socketObj != nil){
                
                managerFile.sendChatMessage(imParas)
               //OLD SOCKET  LOGIC OF SENDING PENDING MESSAGES
                
                
                
                /*socketObj.socket.emitWithAck("im",["room":"globalchatroom","stanza":imParas])(timeoutAfter: 1500000)
                {data in
                    print("chat ack received \(data)")
                    // statusNow="sent"
                    var chatmsg=JSON(data)
                    print(data[0])
                    print(chatmsg[0])
                    sqliteDB.UpdateChatStatus(chatmsg[0]["uniqueid"].string!, newstatus: chatmsg[0]["status"].string!)
                    
                }
 
 */
                /////  }
                
                
                
                
            }
            //var count=0
            var tbl_messageStatus=sqliteDB.statusUpdate
            let status = Expression<String>("status")
            let sender = Expression<String>("sender")
            let uniqueid = Expression<String>("uniqueid")
            
            for statusMessages in try sqliteDB.db.prepare(tbl_messageStatus)
            {
            // if(socketObj != nil){
                
                
                managerFile.sendChatStatusUpdateMessage(statusMessages[uniqueid],status: statusMessages[status],sender: statusMessages[sender])
                
                //OLD LOGIC OF SOCKET MESSAGE STATUS UPDATES
                /*socketObj.socket.emitWithAck("messageStatusUpdate", ["status":statusMessages[status],"uniqueid":statusMessages[uniqueid],"sender": statusMessages[sender]])(timeoutAfter: 15000){data in
                    var chatmsg=JSON(data)
                    
                    print(data[0])
                 //   print(data[0]["uniqueid"]!!)
                  //  print(data[0]["uniqueid"]!!.debugDescription!)
                    print(chatmsg[0]["uniqueid"].string!)
                    //print(data[0]["status"]!!.string!+" ... "+data[0]["uniqueid"]!!.string!)
                    print("chat status seen emitted which were pending")
                    sqliteDB.removeMessageStatusSeen(data[0]["uniqueid"]!!.debugDescription!)
                    socketObj.socket.emit("logClient","\(username) pending seen statuses emitted")
                    
                }
                */
              //}
                
            }
            if(socketObj != nil){
                socketObj.socket.emit("logClient","IPHONE-LOG: \(username!) done sending pending chat messages")
            }
            
            return completion(result: true)
            //// return completion(result: true)
        }
        catch
        {
            print("error in pending chat fetching")
            if(socketObj != nil){
                socketObj.socket.emit("logClient","IPHONE-LOG: \(username!) error in sending pending chat messages")
            }
            
            return completion(result: false)
        }
        
        
    }
    

    
    
    func application(application: UIApplication, didRegisterUserNotificationSettings notificationSettings: UIUserNotificationSettings) {
        print("didRegisterUserNotificationSettings")
       //if(!UIApplication.sharedApplication().isRegisteredForRemoteNotifications())
       // {
        if(username != nil && username != "")
{
        print("didRegisterUserNotificationSettings... inside...")
        
            UIApplication.sharedApplication().registerForRemoteNotifications()
        }
    
    // }
        
    }
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
       
        
       /* --------- if(socketObj != nil)
        {   //// socketObj.socket.close()
            socketObj.socket.disconnect()
            socketObj.socket.close()
          /////  socketObj=nil
        }
 
 */
 /* if(socketObj == nil)
        {
            print("socket is nillll", terminator: "")
            socketObj=LoginAPI(url:"\(Constants.MainUrl)")
            ///socketObj.connect()
            socketObj.addHandlers()
            socketObj.addWebRTCHandlers()
        }
        */
        
        print("appwillresignactive")
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        print("didenterbackground")
        /*print("close socket")
        if(socketObj != nil)
        {    socketObj.socket.close()
        socketObj.socket.disconnect()
        socketObj=nil
        }
        */
       // application
        /*if(socketObj == nil)
        {
            print("socket is nillll", terminator: "")
            socketObj=LoginAPI(url:"\(Constants.MainUrl)")
            ///socketObj.connect()
            socketObj.addHandlers()
            socketObj.addWebRTCHandlers()
        }*/
        
        
        if(socketObj != nil)
        {   //// socketObj.socket.close()
            socketObj.socket.disconnect()
            socketObj.socket.close()
            /////  socketObj=nil
        }
        
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
   /*     if(chatDetailView != nil)
{
        chatDetailView.tblForChats.reloadData()
}*/
        /////NSNotificationCenter.defaultCenter().postNotificationName(UIApplicationWillEnterForegroundNotification, object: self)
        //////NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("willShowKeyBoard:"), name:UIKeyboardWillShowNotification, object: nil)

        
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
       
        /*
        if(socketObj == nil)
        {
            print("socket is nillll", terminator: "")
            socketObj=LoginAPI(url:"\(Constants.MainUrl)")
            ///socketObj.connect()
            socketObj.addHandlers()
            socketObj.addWebRTCHandlers()
        }
        */
        /*if(socketConnected == false)
        {
            
            socketObj.socket.connect(timeoutAfter: 5000) { () -> Void in
                
                socketObj.socket.reconnect()
                
            }
        }*/
        print("app will enter foreground")
             /*if(socketObj == nil)
        {
            print("socket is nillll", terminator: "")
            //dispatch_async(dispatch_get_main_queue())
            //{
            socketObj=LoginAPI(url:"\(Constants.MainUrl)")
            ///socketObj.connect()
            //            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND,0))
            //{
            socketObj.addHandlers()
            socketObj.addWebRTCHandlers()
            //}
            //}
        }*/

        /*if(socketObj == nil || isSocketConnected==false)
        {
            print("socket is nillll", terminator: "")
            socketObj=LoginAPI(url:"\(Constants.MainUrl)")
            ///socketObj.connect()
            socketObj.addHandlers()
            socketObj.addWebRTCHandlers()
        }
        else{
            socketObj.socket.reconnects=true
        }
        */
        
         if(socketObj == nil)
        {
            print("socket is nillll", terminator: "")
            socketObj=LoginAPI(url:"\(Constants.MainUrl)")
            ///socketObj.connect()
            socketObj.addHandlers()
            socketObj.addWebRTCHandlers()
        }
        
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
       
       /* if(socketObj == nil)
        {
            print("socket is nillll", terminator: "")
            socketObj=LoginAPI(url:"\(Constants.MainUrl)")
            ///socketObj.connect()
            socketObj.addHandlers()
            socketObj.addWebRTCHandlers()
        }*/
        
        /*if(socketConnected == false)
        {
            socketObj.socket.connect(timeoutAfter: 5000) { () -> Void in
                
                socketObj.socket.reconnect()
                
            }
        }*/
        print("app becomeActive")
        UIApplication.sharedApplication().applicationIconBadgeNumber=1;
        UIApplication.sharedApplication().applicationIconBadgeNumber=0;

       // socketObj=LoginAPI(url:"\(Constants.MainUrl)")
        //socketObj.addHandlers()
        //socketObj.addWebRTCHandlers()
        
        
       /* if(socketObj == nil || isSocketConnected==false)
        {
            print("socket is nillll", terminator: "")
            socketObj=LoginAPI(url:"\(Constants.MainUrl)")
            ///socketObj.connect()
            socketObj.addHandlers()
            socketObj.addWebRTCHandlers()
        }
        else{
           // socketObj.socket.reconnects=true
        }*/
        
        print("socket status iss \(socketObj.socket.status)")
        if(socketObj.socket.status == SocketIOClientStatus.Closed)
        {
            print("opening socket")
            socketObj=nil
            socketObj=LoginAPI(url:"\(Constants.MainUrl)")
            ///socketObj.connect()
            socketObj.addHandlers()
            socketObj.addWebRTCHandlers()
            
          //  socketObj.socket.connect()
           // socketObj.socket.open()
        }
        
        if(socketObj == nil)
        {
          print("rsign active when socket for nil")
        }
        
       
       /*  if(socketObj == nil)
        {print("connecting socket in")
            print("socket is nillll", terminator: "")
            socketObj=LoginAPI(url:"\(Constants.MainUrl)")
            ///socketObj.connect()
            socketObj.addHandlers()
            socketObj.addWebRTCHandlers()
        }*/
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
       
        print("app will terminate")
        //socketObj.socket.disconnect(fast: true)
        //socketObj.socket.close(fast: true)
    }
    
    
    
    /*func fetchNewToken()
    {let tbl_accounts = sqliteDB.accounts
        var url=Constants.MainUrl+Constants.authentictionUrl
        var param:[String:String]=["username": username,"password":password!]
        Alamofire.request(.POST,"\(url)",headers:header,parameters: param).response{
            request, response_, data, error in
            print(error)
            
            if response_?.statusCode==200
                
            {
                print("login success")
                //self.labelLoginUnsuccessful.text=nil
                //self.gotToken=true
                
                //======GETTING REST API TO GET CURRENT USER=======================
                
                var userDataUrl=Constants.MainUrl+Constants.getCurrentUser
                //let index: String.Index = advance(self.AuthToken.startIndex, 10)
                
                //======================STORING Token========================
                let jsonLogin = JSON(data: data!)
                let token = jsonLogin["token"]
                KeychainWrapper.setString(token.string!, forKey: "access_token")
                AuthToken=token.string!
                
                
                //========GET USER DETAILS===============
                var getUserDataURL=userDataUrl
                Alamofire.request(.GET,"\(getUserDataURL)",headers:header).responseJSON{
                    response in
                    
                    //===========INITIALISE SOCKETIOCLIENT=========
                    dispatch_async(dispatch_get_main_queue(), {
                        
                        //self.dismissViewControllerAnimated(true, completion: nil);
                        /// self.performSegueWithIdentifier("loginSegue", sender: nil)
                        
                        if response.response!.statusCode==200 {
                            print("got user success")
                            //self.gotToken=true
                            var json=JSON(response.data!)
                            
                            loggedUserObj=json
                            //===========saving username======================
                            KeychainWrapper.setString(json["username"].string!, forKey: "username")
                            KeychainWrapper.setString(json["display_name"].string!, forKey: "loggedFullName")
                            KeychainWrapper.setString(json["phone"].string!, forKey: "loggedPhone")
                            KeychainWrapper.setString(json["email"].string!, forKey: "loggedEmail")
                            KeychainWrapper.setString(json["_id"].string!, forKey: "_id")
                            
                            
                            socketObj.addHandlers()
                            
                            var jsonNew=JSON("{\"room\": \"globalchatroom\",\"user\": {\"username\":\"sabachanna\"}}")
                            //socketObj.socket.emit("join global chatroom", ["room": "globalchatroom", "user": ["username":"sabachanna"]]) WORKINGGG
                            
                            socketObj.socket.emit("join global chatroom",["room": "globalchatroom", "user": json.object])
                            
                            print(json["_id"])
                            
                            
                            let _id = Expression<String>("_id")
                            let firstname = Expression<String?>("firstname")
                            let lastname = Expression<String?>("lastname")
                            let email = Expression<String>("email")
                            let phone = Expression<String>("phone")
                            let username = Expression<String>("username")
                            let status = Expression<String>("status")
                            let date = Expression<String>("date")
                            let accountVerified = Expression<String>("accountVerified")
                            let role = Expression<String>("role")
                            
                            
                            // let insert = users.insert(email <- "alice@mac.com")
                            
                            
                            tbl_accounts.delete()
                            do {
                                let rowid = try sqliteDB.db.run(tbl_accounts.insert(_id<-json["_id"].string!,
                                    firstname<-json["display_name"].string!,
                                    //lastname<-"",
                                    //email<-json["email"].string!,
                                    username<-json["phone"].string!,
                                    status<-json["status"].string!,
                                    phone<-json["phone"].string!))
                                print("inserted id: \(rowid)")
                                /*for account in try sqliteDB.db.prepare(tbl_accounts) {
                                    print("id: \(account[_id]), email: \(account[email]), firstname: \(account[firstname])")
                                }*/
                            } catch {
                                print("insertion failed: \(error)")
                            }
                           

                            
                            
                            
                            
                            
                            
                                                       //// self.fetchContacts(AuthToken)
                            
                            
                            
                            
                            //...........
                            /*  let stmt = sqliteDB.db.prepare("SELECT * FROM accounts")
                            print(stmt.columnNames)
                            for row in stmt {
                            print("...................... firstname: \(row[1]), email: \(row[3])")
                            // id: Optional(1), email: Optional("alice@mac.com")
                            }*/
                            
                           
                        } else {
                            /*self.labelLoginUnsuccessful.text="Sorry, you are not registered"
                            self.txtForEmail.text=nil
                            self.txtForPassword.text=nil
                            */
                            print("GOT USER FAILED")
                        }//end else
                        
                    })
                    
                        // id: 1, email: alice@mac.com, name: Optional("Alice")
                    }
                }
            
            
        
            else
            {
                print("login failed")
                /*self.labelLoginUnsuccessful.text="Sorry, you are not registered"
                self.txtForEmail.text=nil
                self.txtForPassword.text=nil*/
            }
        }
        
        
    }
    
    */
    /*
     
     SBNotificationHub* hub = [[SBNotificationHub alloc] initWithConnectionString:HUBLISTENACCESS
     notificationHubPath:HUBNAME];
     
     [hub registerNativeWithDeviceToken:deviceToken tags:nil completion:^(NSError* error) {
     if (error != nil) {
     NSLog(@"Error registering for notifications: %@", error);
     }
     else {
     [self MessageBox:@"Registration Status" message:@"Registered"];
     }
     }];
 */
    
    // ----commenting
    
     func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        print("trying to register device token")
        if(username != nil && username != ""){
        print("inside didRegisterForRemoteNotificationsWithDeviceToken username is \(username!) ")
        var hub=SBNotificationHub(connectionString: Constants.connectionstring, notificationHubPath: Constants.hubname) //from constants file
        var tagarray=[String]()
        tagarray.append(username!.substringFromIndex(username!.startIndex.successor()))
        print(username!.substringFromIndex(username!.startIndex.successor()))
       // var tagname=NSSet(object: username!.substringFromIndex(username!.startIndex))
        var tagname=NSSet(array: tagarray)
       // hub.registerNativeWithDeviceToken(deviceToken, tags: tagname as Set<NSObject>) { (error) in
        hub.registerNativeWithDeviceToken(deviceToken, tags: tagname as! Set<NSObject>) { (error) in
        //hub.registerNativeWithDeviceToken(deviceToken, tags: nil) { (error) in
            
        if(error != nil)
            {
                print("Registering for notifications \(error)")
            }
            else
            {
                print("Successfully registered for notifications")

            }
            
        }
       }
    }
    
    
    /*
     received while the app is active:
     
     Copy
     - (void)application:(UIApplication *)application didReceiveRemoteNotification: (NSDictionary *)userInfo {
     NSLog(@"%@", userInfo);
     [self MessageBox:@"Notification" message:[[userInfo objectForKey:@"aps"] valueForKey:@"alert"]];
     }
 */
    

    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        
        print("receivednotification method called")
        print("app state application is \(UIApplication.sharedApplication().applicationState.rawValue)")
        print("app state is \(application.applicationState.rawValue)")
        print("app state value background is \(UIApplicationState.Background.rawValue)")
        print("app state value inactive is \(UIApplicationState.Inactive.rawValue)")
        print("app state value active is \(UIApplicationState.Active.rawValue)")
       print("......")
        print(userInfo.description)
      ////////  if (application.applicationState != UIApplicationState.Background) {
       // NSLog("received remote notification \(userInfo)")
        if(socketObj != nil)
        {
             socketObj.socket.emit("logClient","\(username) didReceiveRemoteNotification: ..... \(userInfo["userInfo"]).....\(userInfo.description)")
            print(userInfo["userInfo"])
            
        }
     
        
        if  let singleuniqueid = userInfo["uniqueId"] as? String {
            // Printout of (userInfo["aps"])["type"]
            print("\nFrom APS-dictionary with key \"singleuniqueid\":  \( singleuniqueid)")
             if  let notifType = userInfo["type"] as? String {
                print("payload of satus or iOS chat")
                if(notifType=="status")
                {
                    updateMessageStatus(singleuniqueid, status: (userInfo["status"] as? String)!)
                }
                else
                {
                    print("payload of iOS chat")
                    fetchSingleChatMessage(singleuniqueid)

                }
            }
            else
             {
                print("payload of Android message")
                //==
                // this is from android
                //==
                fetchSingleChatMessage(singleuniqueid)
                
            }
            
            // Do your stuff?
        }

        
        print("remote notification received is \(userInfo)")
        /*var notificationJSON=JSON(userInfo)
        print("json converted is \(notificationJSON)")
        print("json received is is \(notificationJSON["aps"])")
        */
        completionHandler(UIBackgroundFetchResult.NewData)
        NSNotificationCenter.defaultCenter().postNotificationName("ReceivedNotification", object:userInfo)
        /*
         json converted is {
         "aps" : {
         "data" : {
         "msg" : "Hello +923201211991! You joined the room."
         }
         }
         }
         */
        
        
        /*
         var payload = {
         +          type : im.stanza.type,
         +          senderId : im.stanza.from,
         +          uniqueId : im.stanza.uniqueid
         +        };
         +
         +        sendPushNotification(im.stanza.to, payload);
         +      }
         */
       // print("json received is is \(notificationJSON["aps"])")
 ///////   }
    }
 
    /*
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        let token=JSON(deviceToken)
        print("device tokennnnnnn...", terminator: "")
        socketObj.socket.emit("logClient","deviceToken: \(token)")
        print(token.debugDescription)
        
        print("registered for notification", terminator: "")
    }
    */
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        
        print("registered for notification error", terminator: "")
        NSLog("Error in registration. Error: \(error)")
    }
    
    func iCloudAccountAvailabilityChanged(sender:NSNotification)
    {

}
    
   
    func screenCapture() {
        atimer=NSTimer(timeInterval: 0.1, target: self, selector: "timerFiredScreenCapture", userInfo: nil, repeats: true)
        
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)) { () -> Void in
    while(screenCaptureToggle)
    //for(var i=0;i<30000;i++)
    {
    atimer.fire()
    sleep(1)
    }
    
    }
        

    
    }
    func application(application: UIApplication, willFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
        
        return true
    }
    func timerFiredScreenCapture()
    {print("inside timerFiredScreenCapture")
        
        //if(countTimer%2 == 0){
        
        //while(atimer.timeInterval < 3000)
        var chunkLength=64000
        var screenshot:UIImage!
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            var myscreen=self.window!.snapshotViewAfterScreenUpdates(true)
            
            UIGraphicsBeginImageContext((self.window!.bounds.size))
            
            self.window!.drawViewHierarchyInRect(myscreen.bounds, afterScreenUpdates: true)
            print("width is \(myscreen.layer.bounds.width), height is \(myscreen.layer.bounds.height)")
            screenshot=UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            webMeetingModel.delegateSendScreenshotDataChannel.sendImageFromDataChannel(screenshot)
            
        })
        
        print("outside")
        
    }
    public func showFileRecievedNotification()
    {
        let alert = UIAlertController(title: "Success", message: "You have received a new file. Click on \"View\" button at top to View and Save it.", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        let navigationController = UIApplication.sharedApplication().windows[0].rootViewController as! UINavigationController
        
        let activeViewCont = navigationController.visibleViewController
        
        activeViewCont!.presentViewController(alert, animated: true, completion: nil)
        
        
    
    //self.window?.rootViewController!.presentViewController(alert, animated: true, completion: nil)
    }
    
    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
        ///application.applicationIconBadgeNumber = 0
      //  UIApplication.sharedApplication().presentLocalNotificationNow(notification)
        print("got local notification")
        socketObj.socket.emit("logClient","IPHONE-LOG: call notification received in background")
    }
    
    
  
    func application(application: UIApplication, shouldSaveApplicationState coder: NSCoder) -> Bool {
        return true
    }
    
    func application(application: UIApplication, shouldRestoreApplicationState coder: NSCoder) -> Bool {
        return true
    }
   /* func application(application: UIApplication, viewControllerWithRestorationIdentifierPath identifierComponents: [AnyObject], coder: NSCoder) -> UIViewController? {
        return UIViewController
    }*/
    
    func application(application: UIApplication, performFetchWithCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        print("background fetch resultttt...")
        completionHandler(UIBackgroundFetchResult.NewData)
        
    }
    func application(application: UIApplication, handleEventsForBackgroundURLSession identifier: String, completionHandler: () -> Void) {
        
         NetworkingManager.sharedManager.backgroundCompletionHandler = completionHandler
    }
    func fetchSingleChatMessage(uniqueid:String)
    {
        print("uniqueid of single chat is \(uniqueid)")
        
        //======GETTING REST API TO GET CURRENT USER=======================
        
        print("inside fetch single chat")
        if(accountKit == nil){
            accountKit = AKFAccountKit(responseType: AKFResponseType.AccessToken)
        }
        
        if (accountKit!.currentAccessToken == nil) {
            
            print("inside etch single 1462")
            //specify AKFResponseType.AccessToken
            accountKit = AKFAccountKit(responseType: AKFResponseType.AccessToken)
            accountKit.requestAccount{
                (account, error) -> Void in
                
                
                
                
                //**********
                
                if(account != nil){
                  //  var url=Constants.MainUrl+Constants.getContactsList
                    
                    let header:[String:String]=["kibo-token":(accountKit!.currentAccessToken!.tokenString)]
                    
                    
                }
                
            }
        }
        var fetchSingleMsgURL=Constants.MainUrl+Constants.fetchSingleChat
        
        
        //var getUserDataURL=userDataUrl
        
        Alamofire.request(.POST,"\(fetchSingleMsgURL)",parameters: ["uniqueid":uniqueid],headers:header).validate(statusCode: 200..<300).responseJSON{response in
            
            
            switch response.result {
            case .Success:
                if let data1 = response.result.value {
                    var chatJson = JSON(data1)
                    chatJson=chatJson["msg"]
                    print("JSON single chat: \(chatJson)")
                    print("JSON single chat to is: \(chatJson[0]["to"].string!)")
                    var status="delivered"
                    if(!chatJson[0]["type"].isExists())
                    {//old chat message
                        
                        
                        //====
                        
                        //====
                        
                        let dateFormatter = NSDateFormatter()
                        dateFormatter.timeZone=NSTimeZone.localTimeZone()
                        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                        //  let datens2 = dateFormatter.dateFromString(date2.debugDescription)
                        //2016-09-18T19:13:00.588Z
                        let datens2 = dateFormatter.dateFromString(chatJson[0]["date"].string!)
                        
                        print("===single fetch chat date in app delegate \(datens2)")
                        
                      /*  let formatter = NSDateFormatter()
                        formatter.dateFormat = "MM/dd, HH:mm"
                       /////// formatter.dateStyle = NSDateFormatterStyle.ShortStyle
                        //////formatter.timeStyle = .ShortStyle
                        
                        let dateString = formatter.stringFromDate(datens2!)
                        print("dateeeeeee \(dateString)")
                        */
                        
                        sqliteDB.SaveChat(chatJson[0]["to"].string!, from1: chatJson[0]["from"].string!,owneruser1:chatJson[0]["to"].string!, fromFullName1: chatJson[0]["fromFullName"].string!, msg1: chatJson[0]["msg"].string!,date1:datens2,uniqueid1:chatJson[0]["uniqueid"].string!,status1: status,type1: "", file_type1: "chat",file_path1: "")
                        
                        managerFile.sendChatStatusUpdateMessage(chatJson[0]["uniqueid"].string!, status: status, sender: chatJson[0]["from"].string!)
                        
                        
                    }
                    else
                    {
                        
                        if(chatJson[0]["type"].string! == "file")
                        {
                            managerFile.checkPendingFiles(username!)
                        }
                        
                        //===
                        //===
                        
                        let dateFormatter = NSDateFormatter()
                        dateFormatter.timeZone=NSTimeZone.localTimeZone()
                        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                        //  let datens2 = dateFormatter.dateFromString(date2.debugDescription)
                        //2016-09-18T19:13:00.588Z
                        let datens2 = dateFormatter.dateFromString(chatJson[0]["date"].string!)
                        
                       /* let formatter = NSDateFormatter()
                        formatter.dateFormat = "MM/dd, HH:mm"
                        /////// formatter.dateStyle = NSDateFormatterStyle.ShortStyle
                        //////formatter.timeStyle = .ShortStyle
                        
                        let dateString = formatter.stringFromDate(datens2!)
                        print("dateeeeeee \(dateString)")
                        */
                        
                        
                        sqliteDB.SaveChat(chatJson[0]["to"].string!, from1: chatJson[0]["from"].string!,owneruser1:chatJson[0]["to"].string!, fromFullName1: chatJson[0]["fromFullName"].string!, msg1: chatJson[0]["msg"].string!,date1:datens2,uniqueid1:chatJson[0]["uniqueid"].string!,status1: status,type1: chatJson[0]["type"].string!, file_type1: chatJson[0]["file_type"].string!,file_path1: "")
                        
                        managerFile.sendChatStatusUpdateMessage(chatJson[0]["uniqueid"].string!, status: status, sender: chatJson[0]["from"].string!)
                     // === change date   sqliteDB.SaveChat(chatJson[0]["to"].string!, from1: chatJson[0]["from"].string!,owneruser1:chatJson[0]["to"].string!, fromFullName1: chatJson[0]["fromFullName"].string!, msg1: chatJson[0]["msg"].string!,date1:nil,uniqueid1:chatJson[0]["uniqueid"].string!,status1: status,type1: chatJson[0]["type"].string!, file_type1: chatJson[0]["file_type"].string!,file_path1: "")
                        
                        
                    }
                    if(socketObj == nil)
                    {
                    }
                    
                    var state=UIApplication.sharedApplication().applicationState

//UIApplicationState state = [[UIApplication sharedApplication] applicationState];

                    if (state == UIApplicationState.Active || state == UIApplicationState.Inactive)
                    {
                        
                         let systemSoundID: SystemSoundID = 1016
                         
                         // to play sound
                         AudioServicesPlaySystemSound (systemSoundID)
                        if(delegateRefreshChat != nil)
                        {
                            delegateRefreshChat?.refreshChatsUI("updateUI", data: nil)
                        }
 
                        
                        //AudioServicesCre
                        // to play sound
                        //AudioServicesPlaySystemSound (systemSoundID)

                        
                        //let navigationController = UIApplication.sharedApplication().windows[0].rootViewController
                        //let activeViewCont = navigationController.visibleViewController
                        
                      //  activeViewCont?.loadView()
    
                    }
                    
                    //UIApplicationState state = [[UIApplication sharedApplication] applicationState];
                    
                    if (state == UIApplicationState.Background )
                    {
                        if(delegateRefreshChat != nil)
                        {
                            delegateRefreshChat?.refreshChatsUI("updateUI", data: nil)
                        }
   
                    }
 

                    //print(response.description)
                    // print(JSON(response.data!).description)
                    
                }
            case .Failure:
                print("failed to get seingle chat message")
            }
        }
        
    }
    
    func updateMessageStatus(uniqueID:String,status:String)
    {
        print("messageStatusUpdate ......")
        print(":::::::::::::::::::::::::::::::::::")
        //var chatmsg=JSON(data)
        //print(data[0])
        //print(chatmsg[0])
       
        
        
        sqliteDB.UpdateChatStatus(uniqueID, newstatus: status)
        
        
        //get status and unique id from server delivered or seen
        
        var state=UIApplication.sharedApplication().applicationState
        
        //UIApplicationState state = [[UIApplication sharedApplication] applicationState];
        
        if (state == UIApplicationState.Active )
        {
            print("updating message status when app is avtive")
            
           /* let systemSoundID: SystemSoundID = 1016
            
            // to play sound
            AudioServicesPlaySystemSound (systemSoundID)
            */
            if(delegateRefreshChat != nil)
            {
                print("informing UI to repfresh status")
                delegateRefreshChat?.refreshChatsUI("updateUI", data: nil)
            }
            
            
            //AudioServicesCre
            // to play sound
            //AudioServicesPlaySystemSound (systemSoundID)
            
            
            //let navigationController = UIApplication.sharedApplication().windows[0].rootViewController
            //let activeViewCont = navigationController.visibleViewController
            
            //  activeViewCont?.loadView()
            
        }
        

        
        /*
        self.delegate?.socketReceivedMessage("messageStatusUpdate",data: data)
        if(self.delegateChat != nil)
        {
            self.delegateChat?.socketReceivedMessageChat("updateUI", data: nil)
        }*/
    }
    

    
}
protocol UpdateChatViewsDelegate:class
{
    func refreshChatsUI(message:String,data:AnyObject!);
}




