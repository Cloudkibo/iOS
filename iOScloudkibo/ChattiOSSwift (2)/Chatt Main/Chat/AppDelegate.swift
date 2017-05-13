

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
import ContactsUI
import Contacts
import GoogleMaps
import UserNotifications
import GooglePlacePicker
import GooglePlaces
//import UserNotifications
//import WindowsAzureMessaging
import PushKit



var desktopAppRoomJoined=false
var desktopRoomID=""
var mobileSocketID=""

var messageFrame = UIView()
var activityIndicator = UIActivityIndicatorView()
var strLabel = UILabel()

var applaunch=false
var retainOldDatabase:Bool! = true
var versionNumber:String! = "0.4"

//KeychainWrapper.stringForKey("retainOldDatabase") as! Bool
//var versionNumber:Double! = KeychainWrapper.stringForKey("versionNumber") as! Double

//var socket:SocketIOClient!
var syncServiceContacts:syncContactService!
var syncServiceContacts2:syncContactService!
var addressbookChangedNotifReceivedDateTime:Date?
var addressbookChangedNotifReceived=false
var aaaaa:SBNotificationHub!
var uploadInfo:NSMutableArray!
 var managerFile = NetworkingManager.sharedManager
var selectedText=""
var chatDetailView:ChatDetailViewController!
var goBack=false
var countrycode:String! = KeychainWrapper.stringForKey("countrycode")
let configuration1 = URLSessionConfiguration.background(withIdentifier: "com.example.app.background")
let manager = Alamofire.SessionManager(configuration: configuration1)

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
var profileimageList=[Data]()
var uniqueidentifierList=[String]()

var isFileReceived=false
var meetingStarted=false
var isSocketConnected=false
var delegateScreen:AppDelegateScreenDelegate!
var screenCaptureToggle:Bool=false
var webMeetingModel=webmeetingMsgsModel()
//let socketObj=LoginAPI(url:"\(Constants.MainUrl)")
var socketObj:LoginAPI!=nil
var sqliteDB=DatabaseHandler(dbName:"cloudkibo.sqlite3")
////let sqliteDB=DatabaseHandler(dbName: "")
//%%%%%%%%%%%%var AuthToken=KeychainWrapper.stringForKey("access_token")
var AuthToken:String!=nil
//var loggedUserObj=JSON("[]")
var globalChatRoomJoined:Bool=false
//let dbSQLite=DatabaseHandler(dbName: "/cloudKibo.sqlite3")

//%%%%%%%%%%%%%%%% new phone model
var username:String! = ""

//var username:String! = KeychainWrapper.stringForKey("username")
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
var atimer:Timer!
var areYouFreeForCall:Bool=true
var iamincallWith:String!
var isInitiator=false
var callerName=""
var rtcICEarray:[RTCICEServer]=[]
var rtcFact:RTCPeerConnectionFactory!
var contactsList=iOSContact(keys: [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactEmailAddressesKey, CNContactPhoneNumbersKey])

var filejustreceivednameToSave:String!
var filejustreceivedname:String!
var filejustreceivedPathURL:URL!
var urlLocalFile:URL!
var iOSstartedCall=false
var firstTimeLogin=false
var header:[String:String]=["kibo-token":""]
var delegateRefreshChat:UpdateChatViewsDelegate!
//var appJustInstalled=[Bool]()
var reachability:Reachability!;
var contactsarray=[CNContact]()

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,AppDelegateScreenDelegate,UNUserNotificationCenterDelegate,PKPushRegistryDelegate {
    /*!
     @method        pushRegistry:didUpdatePushCredentials:forType:
     @abstract      This method is invoked when new credentials (including push token) have been received for the specified
     PKPushType.
     @param         registry
     The PKPushRegistry instance responsible for the delegate callback.
     @param         credentials
     The push credentials that can be used to send pushes to the device for the specified PKPushType.
     @param         type
     This is a PKPushType constant which is present in [registry desiredPushTypes].
     */
    @available(iOS 8.0, *)
    public func pushRegistry(_ registry: PKPushRegistry, didUpdate credentials: PKPushCredentials, forType type: PKPushType) {
        
        
        let token = credentials.token.map { String(format: "%02.2hhx", $0) }.joined()
        print("voip2 token: \(token)")
        
        //NSLog("voip2 token: \(credentials.token.base64EncodedString())")

        
    }

    func pushRegistry(_ registry: PKPushRegistry, didInvalidatePushTokenForType type: PKPushType) {
        
        
    }

    func pushRegistry(_ registry: PKPushRegistry, didReceiveIncomingPushWith payload: PKPushPayload, forType type: PKPushType) {
        
        UtilityFunctions.init().log_papertrail("IPHONE- VOIP push received by \(username!)")
        print("Process the received push")
        
        /*socketObj=LoginAPI(url:"\(Constants.MainUrl)")
        ///socketObj.connect()
        socketObj.addHandlers()
        socketObj.addWebRTCHandlers()
 */
        
       // UtilityFunctions.init().backupFiles()
       /* for var i in 0..<99999
        {
            print("helloo \(i)")
        }*/
    }

    
    var window: UIWindow?
 


    
    /*if(self.retainOldDatabase==false )
    {
    accountKit.logOut()
    }*/
   // private var reachability:Reachability!;
    
    //  var window: UIWindow?
    
    
    /*func application(application: UIApplication, willFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
        
        print("launchingggggggggg")
        return true
    }*/
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        print("========launchhhhhhhhh=====")
        print(Date())
        
        print("app state application is \(UIApplication.shared.applicationState.rawValue)")
        print("app state is \(application.applicationState.rawValue)")
        print("app state value background is \(UIApplicationState.background.rawValue)")
        print("app state value inactive is \(UIApplicationState.inactive.rawValue)")
        print("app state value active is \(UIApplicationState.active.rawValue)")
        
        
        print("starting keyvalue")
        UtilityFunctions.init().writeLocaliseFile()
        
        let username1 = Expression<String>("username")
        let tbl_accounts = sqliteDB.accounts
        do{for account in try sqliteDB.db.prepare(tbl_accounts!) {
            username=account[username1]
            
            }
        }
        catch{
            
        }
 
        
        if (UserDefaults.standard.value(forKey: Constants.defaultsBackupTimeKey) == nil)
        {
            UserDefaults.standard.set("Off", forKey: Constants.defaultsBackupTimeKey)
            
        }
        else{
            
            switch(UserDefaults.standard.value(forKey: Constants.defaultsBackupTimeKey) as! String)
            {
                case "Daily":
                print("backup daily")
                UIApplication.shared.setMinimumBackgroundFetchInterval(86400/24)
                
            case "Weekly":
                print("backup daily")
                UIApplication.shared.setMinimumBackgroundFetchInterval(604800)

                
            case "Monthly":
                print("backup daily")
                UIApplication.shared.setMinimumBackgroundFetchInterval(604800*4)
                
            default: print("backup off")
            }
       }
        
    //!! UIApplication.shared.setMinimumBackgroundFetchInterval(60)
        
        GMSServices.provideAPIKey("AIzaSyA4ayZ7WiMRkulzF6OxZhBa8WXp7w4BkhI")
        GMSPlacesClient.provideAPIKey("AIzaSyA4ayZ7WiMRkulzF6OxZhBa8WXp7w4BkhI")
        GMSServices.provideAPIKey("AIzaSyA4ayZ7WiMRkulzF6OxZhBa8WXp7w4BkhI")
        
       //==--self.checkFirstRun()
        
        
        let nsObject: AnyObject? = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as AnyObject?
        if let text = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
            print("... \(text)") //build number
        }
        print(",,,,, \(nsObject!.description)") //version number
        
        var log=UtilityFunctions.init()
        //log.log_papertrail("IPHONE: \(username!) has version number \(nsObject!.description)")
        

        //  self.messageFrame.removeFromSuperview()
        // print("setting contacts start time \(NSDate())")
        //self.progressBarDisplayer("App version \( (nsObject!.description))", true)
        
        
       /* if(!(KeychainWrapper.stringForKey("retainOldDatabase")==nil))
        {
            KeychainWrapper.setString("false",forKey: "retainOldDatabase")
            KeychainWrapper.setString("\(versionNumber)",forKey: "versionNumber")
            if(accountKit == nil){
                accountKit = AKFAccountKit(responseType: AKFResponseType.AccessToken)
            }
            accountKit.logOut()
        }       
       
        else
        {
            if(KeychainWrapper.stringForKey("versionNumber") != versionNumber)
            {
                KeychainWrapper.setString("false",forKey: "retainOldDatabase")
                KeychainWrapper.setString(versionNumber,forKey: "versionNumber")
                if(accountKit == nil){
                    accountKit = AKFAccountKit(responseType: AKFResponseType.AccessToken)
                }
                accountKit.logOut()
            }
        }*/
        
       // print("notifications ... \(launchOptions?.debugDescription)")
        
        
        syncServiceContacts=syncContactService.init()
        syncServiceContacts2=syncContactService.init()
        
             
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
        
        UIApplication.shared.setStatusBarHidden(true, with: UIStatusBarAnimation.fade);
        
        UIApplication.shared.setStatusBarStyle(UIStatusBarStyle.lightContent, animated: false);
        
        
       /* do{reachability = try Reachability.reachabilityForInternetConnection()
        try reachability.startNotifier();
          //  NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("checkForReachability:"), name:ReachabilityChangedNotification, object: reachability)
        }
        catch{
            print("error in reachability")
        }*/
        
        
        //RESET TEMP
        
  /* if(username != nil)
{
 KeychainWrapper.removeObjectForKey("username")
        KeychainWrapper.removeObjectForKey("loggedFullName")
        KeychainWrapper.removeObjectForKey("countrycode")
 }*/
 
      /////  KeychainWrapper.removeObjectForKey("username")
        
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        //var socketObj=LoginAPI(url:"\(Constants.MainUrl)")
        webMeetingModel.delegateScreen=self
        UIApplication.shared.isNetworkActivityIndicatorVisible=true
        print("appdidFinishLaunching")
        
        
        
        
       /* socket = SocketIOClient(socketURL:URL(string: "\(Constants.MainUrl)")!, config:SocketIOClientConfiguration.init(arrayLiteral: .voipEnabled(true)))
        socket.connect()
        UtilityFunctions.init().log_papertrail("socket connectingg \(socket.sid)")
        // socket=SocketIOClient(socketURL:URL(string: "\(url)")! , config: [.voipenabled(true)])!/*, options: [.Log(true)]*/)
        areYouFreeForCall=true
        //isBusy=false
        socket.on("connect") {data, ack in
            isSocketConnected=true
            NSLog("connected to socket")
            
        }*/
        
       
        if(socketObj == nil)
        {
            print("socket is nillll", terminator: "")
           //DispatchQueue.main.async
            //{
            socketObj=LoginAPI(url:"\(Constants.MainUrl)")
            ///socketObj.connect()
//            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND,0))
//{
            socketObj.addHandlers()
            socketObj.addWebRTCHandlers()
            socketObj.addDesktopAppHandlers()

            }
//}
 
        
     
        
        
        
        /*
         UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeSound |
         UIUserNotificationTypeAlert | UIUserNotificationTypeBadge categories:nil];
         
         [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
         [[UIApplication sharedApplication] registerForRemoteNotifications];
 */
        
        
        
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) {(accepted, error) in
                if !accepted {
                    print("Notification access denied.")
                }
            }
        }
        
      
        
        
        /////-------will be commented----
        //application.registerUserNotificationSettings(pushNotificationSettings)
        //application.registerForRemoteNotifications()
  
        
        //^^^^^^^^^^^^^^^^^^^
        
        
        
        
        
        
        
        
        
      //  print("username is \(username!)")
    if(username != nil && username != "")
        {
        
       /* let username1 = Expression<String>("username")
        let tbl_accounts = sqliteDB.accounts
        do{for account in try sqliteDB.db.prepare(tbl_accounts) {
            username=account[username1]

          */  print(" check permission for remote notifications \(UIApplication.shared.isRegisteredForRemoteNotifications)")
            
            if #available(iOS 10.0, *) {
                let center  = UNUserNotificationCenter.current()
                center.delegate = self
                center.requestAuthorization(options: [.sound, .alert, .badge]) { (granted, error) in
                    if error == nil{
                        UIApplication.shared.registerForRemoteNotifications()
                    }
                }
            }
                
            else {
                let notificationTypes: UIUserNotificationType = [UIUserNotificationType.alert, UIUserNotificationType.badge, UIUserNotificationType.sound]
                
                //let notificationTypes: UIUserNotificationType = [UIUserNotificationType.None]
                
                
                let pushNotificationSettings = UIUserNotificationSettings(types: notificationTypes, categories: nil)
                
                UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.sound, .alert, .badge], categories: nil))
                UIApplication.shared.registerForRemoteNotifications()
            }
            
            self.PushKitRegistration()

        //UIApplication.shared.registerUserNotificationSettings(pushNotificationSettings)
       
            /*}
        }
        catch{
            
}*/
       }
        
        
        
        //background
     // UIApplication.shared.setMinimumBackgroundFetchInterval(UIApplicationBackgroundFetchIntervalMinimum)
        //!!UIApplication.shared.setMinimumBackgroundFetchInterval(86400/24)
        //UIApplication.shared.setMinimumBackgroundFetchInterval(60)
        
      NotificationCenter.default.addObserver(self, selector: #selector(AppDelegate.contactChanged(_:)), name: NSNotification.Name.CNContactStoreDidChange, object: nil)

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

     
        
        print("on launch app state is \(UIApplication.shared.applicationState.rawValue)")
        return true
        
    }
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        print("Failed to register:", error)
    }
    
    func PushKitRegistration()
    {
        
        let mainQueue = DispatchQueue.main
        // Create a push registry object
        if #available(iOS 8.0, *) {
            
            let voipRegistry: PKPushRegistry = PKPushRegistry(queue: mainQueue)
            
            // Set the registry's delegate to self
            
            voipRegistry.delegate = self
            
            // Set the push type to VoIP
            
            voipRegistry.desiredPushTypes = [PKPushType.voIP]
            
        } else {
            // Fallback on earlier versions
        }
        
        
    }
    /*
    func pushRegistry(registry: PKPushRegistry!, didInvalidatePushTokenForType type: String!) {
        
        NSLog("token invalidated")
    }
    */
    /*@available(iOS 8.*0, *)
    func pushRegistry(registry: PKPushRegistry!, didUpdatePushCredentials credentials: PKPushCredentials!, forType type: String!) {
        // Register VoIP push token (a property of PKPushCredentials) with server
        
      /*  let hexString : String = UnsafeBufferPointer<UInt8>(start: UnsafePointer(credentials.token.bytes),
                                                            count: credentials.token.length).map { String(format: "%02x", $0) }.joinWithSeparator("")
        */
        /*let tokenChars = UnsafePointer<CChar>(UnsafePointer(credentials.token.bytes))
        var tokenString = ""
        
        for i in 0..<credentials.token.count {
            tokenString += String(format: "%02.2hhx", arguments: [tokenChars[i]])
        }
        
        print("Device Token:", tokenString)
        */
        //print(hexString)
        NSLog("voip token: \(credentials.token)")
        
    }*/
    
    
   /* @available(iOS 8.0, *)
    func pushRegistry(registry: PKPushRegistry!, didReceiveIncomingPushWithPayload payload: PKPushPayload!, forType type: String!) {
        print("Process the received push")
        socketObj=LoginAPI(url:"\(Constants.MainUrl)")
        ///socketObj.connect()
        socketObj.addHandlers()
        socketObj.addWebRTCHandlers()
        // Process the received push
        // From here you have to schedule your local notification
        
    }*/
    
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
    
    
    //Called when a notification is delivered to a foreground app.
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)
        {
            
            var myview=ChatDetailViewController()
            var userInfo=notification.request.content.userInfo
            let appDelegate = UIApplication.shared.delegate
            if let window = appDelegate!.window {
                if(window?.rootViewController?.isKind(of: UITabBarController.self))!
                {
                    if((window?.rootViewController as! UITabBarController).selectedIndex==0)
                        {
                           
                            if((window?.rootViewController as! UITabBarController).childViewControllers.first?.isKind(of: ChatDetailViewController.self))!
                            {
                                print("chatssss")
                            }
                            else{
                                print("another view of chats")
                            }
                    }
                    else{
                        print("another \((window?.rootViewController as! UITabBarController).selectedIndex)")
                    }
                  /* if(window?.rootViewController?.tabBarController?.presentedViewController?.isKind(of:ChatDetailViewController.self))!
                   {
                    print("Chatdetailvisiblee")
                    print(myview.selectedContact)
                    
                    }
                   else{
                    print("another tabbar \(window?.rootViewController?.presentedViewController)")
                     }*/
                }
                else{
                    print("no .. \(window?.rootViewController)")
                }
            }
             //if  let singleuniqueid = userInfo["sound"] as? String
             //{
            completionHandler([.alert, .badge, .sound])
            //}
            
           // UtilityFunctions.init().log_papertrail("iOS 10 mode \(UIApplication.shared.applicationState) User Info = \(notification.request.content.userInfo)")
       // print("User Info = \(notification.request.content.userInfo)")
            
            UtilityFunctions.init().getAppState(currentState: UIApplication.shared.applicationState.rawValue)
            UtilityFunctions.init().log_papertrail("IPHONE: \(username!) willpresent iOS10 \(userInfo)")
            
           /* if(UIApplication.shared.applicationState.rawValue != UIApplicationState.inactive.rawValue)
            {
                
                Alamofire.request("https://api.cloudkibo.com/api/users/log", method: .post, parameters: ["data":"IPHONE_LOG: \(username!) iOS 10+ received push notification as \(userInfo.description)"],headers:header).response{
                    response in
                    print(response.error)
                }

        if  let singleuniqueid = userInfo["uniqueId"] as? String {
            // Printout of (userInfo["aps"])["type"]
            print("\nFrom APS-dictionary with key \"singleuniqueid\":  \( singleuniqueid)")
            if  let notifType = userInfo["type"] as? String {
                print("payload of satus or iOS chat")
                if(notifType=="status")
                {
                    updateMessageStatus(singleuniqueid, status: (userInfo["status"] as? String)!)
                    print("calling completion handler for status update now")
                    completionHandler([.alert, .badge, .sound])
                  //  completionHandler(UIBackgroundFetchResult.newData)
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "ReceivedNotification"), object:userInfo)
                    
                }
                else
                {/*
                     group:you_are_added
                     */
                    
                    if(notifType=="chat" || notifType=="file" || notifType=="contact" || notifType=="location")
                        
                    {print("payload of iOS chat")
                        fetchSingleChatMessage(singleuniqueid)
                        print("calling completion handler for fetch chat now")
                       
                        completionHandler([.alert, .badge, .sound])
                        //completionHandler(UIBackgroundFetchResult.newData)
                        NotificationCenter.default.post(name: Notification.Name(rawValue: "ReceivedNotification"), object:userInfo)
                    }
                        
                    else
                    {
                        if(notifType=="group:msg_status_changed")
                            
                        {print("inside here updating status")
                            //change message status
                            //status : 'delivered',
                            //uniqueId : req.body.unique_id
                            var uniqueId=userInfo["uniqueId"] as! String
                            var status=userInfo["status"] as! String
                            var user_phone=userInfo["user_phone"] as? String
                            
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                            var delivered_date=Date()
                            var read_date=Date()
                            
                            
                            
                            /* if(status == "delivered")
                             {
                             var delivered_dateString=userInfo["delivered_date"] as! String
                             delivered_date = dateFormatter.date(from:delivered_dateString)!
                             
                             
                             }
                             else
                             {
                             var read_dateString=userInfo["read_date"] as! String
                             read_date = dateFormatter.date(from:read_dateString)!
                             
                             
                             }
                             
                             */
                            
                            if(user_phone == nil)
                            {
                                user_phone=""
                            }
                            sqliteDB.updateGroupChatStatus(uniqueId,memberphone1: user_phone!,status1: status, delivereddate1: delivered_date, readDate1: read_date)
                            UIDelegates.getInstance().UpdateMainPageChatsDelegateCall()
                            UIDelegates.getInstance().UpdateGroupChatDetailsDelegateCall()
                            UIDelegates.getInstance().UpdateGroupInfoDetailsDelegateCall()
                            
                        }
                        else{
                            
                            if(notifType=="block:blockedyou")
                                
                            {print("inside i am blocked")
                                //change message status
                                //status : 'delivered',
                                //uniqueId : req.body.unique_id
                                var phone=userInfo["phone"] as! String
                                sqliteDB.IamBlockedUpdateStatus(phone1: phone, status1: true)
                            }
                            else{
                                
                                if(notifType=="block:unblockedyou")
                                    
                                {print("inside i am unblocked")
                                    //change message status
                                    //status : 'delivered',
                                    //uniqueId : req.body.unique_id
                                    var phone=userInfo["phone"] as! String
                                    sqliteDB.IamBlockedUpdateStatus(phone1: phone, status1: false)
                                }
                            }
                        }
                    }
                    
                    /* else
                     {
                     if(notifType=="group:you_are_added")
                     {
                     
                     //you are added to group
                     /*   Body: group_unique_id = <group_unique_id>, members = [‘+9233232900920’, ‘+9432233919233’, ....]
                     Push notification will be sent to other members of group:
                     var payload = {
                     type : 'group:you_are_added',
                     senderId : ‘<admin phone number>’,
                     groupId : ‘<unique id of group>’,
                     isAdmin: 'No',
                     membership_status : 'joined',
                     group_name: ‘<name of the group>’,
                     badge : <ignore this field>
                     };
                     */
                     }
                     }
                     
                     }*/
                    
                }
            }
            else
            {
                print("rwong payload without type field")
                
                /*
                 //==
                 // this is from android
                 //==
                 fetchSingleChatMessage(singleuniqueid)
                 
                 */
               // completionHandler(UIBackgroundFetchResult.newData)
                completionHandler([.alert, .badge, .sound])
                NotificationCenter.default.post(name: Notification.Name(rawValue: "ReceivedNotification"), object:userInfo)
                
                
            }
            
            // Do your stuff?
            
            
        }
            
        else
        {
            //handle Group Push here
            //you are added to group
            /* Body: group_unique_id = <group_unique_id>, members = [‘+9233232900920’, ‘+9432233919233’, ....]
             Push notification will be sent to other members of group:
             var payload = {
             type : 'group:you_are_added',
             senderId : ‘<admin phone number>’,
             groupId : ‘<unique id of group>’,
             isAdmin: 'No',
             membership_status : 'joined',
             group_name: ‘<name of the group>’,
             badge : <ignore this field>
             };
             *?
             }
             }
             
             }*/
            if  let type = userInfo["type"] as? String {
                print(userInfo)
                // Printout of (userInfo["aps"])["type"]
                print("group push unique_id is \( type)")
                // if  let notifType = userInfo["type"] as? String {
                
                if(type=="group:you_are_added")
                {
                    var senderid = userInfo["senderId"] as! String
                    var groupId = userInfo["groupId"] as? String
                    var isAdmin = userInfo["isAdmin"] as! String
                    var membership_status = userInfo["membership_status"] as! String
                    var group_name = userInfo["group_name"] as! String
                    DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.background).async {
                        self.fetchSingleGroup(groupId!, completion: { (result, error) in
                            
                            self.fetchGroupMembersSpecificGroup(groupId!,completion: { (result, error) in
                                
                                sqliteDB.storeGroupsChat("Log:", group_unique_id1: groupId!, type1: "log", msg1: "You are added by \(senderid)", from_fullname1: "", date1: Date(), unique_id1:UtilityFunctions.init().generateUniqueid())
                                UIDelegates.getInstance().UpdateMainPageChatsDelegateCall()
                                UIDelegates.getInstance().UpdateGroupInfoDetailsDelegateCall()
                                
                                completionHandler([.alert, .badge, .sound])
                             //   completionHandler(UIBackgroundFetchResult.newData)
                            })
                            
                        })
                    }
                    /* dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)) {
                     print("synccccc fetching contacts in background...")
                     {
                     self.fetchSingleGroup(groupId, completion: { (result, error) in
                     
                     print("group fetched now fetch members")
                     
                     })}}*/
                    
                }
                if(type=="group:chat_received")
                {
                    
                    
                    var senderId=userInfo["senderId"] as? String  //from
                    var groupId=userInfo["groupId"] as? String
                    var msg_type=userInfo["msg_type"] as? String
                    var unique_id=userInfo["unique_id"] as? String
                    
                    self.fetchSingleGroupChatMessage(unique_id!,completion: {(result,error) in
                        
                        UIDelegates.getInstance().UpdateGroupChatDetailsDelegateCall()
                        UIDelegates.getInstance().UpdateMainPageChatsDelegateCall()
                        UIDelegates.getInstance().UpdateGroupInfoDetailsDelegateCall()
                       
                        completionHandler([.alert, .badge, .sound])
                        // completionHandler(UIBackgroundFetchResult.newData)
                    })
                    
                    
                    
                    
                }
                
                
                
                
                if(type=="group:member_left_group")
                {
                    var senderId=userInfo["senderId"] as! String  //from
                    var groupId=userInfo["groupId"] as! String
                    var isAdmin=userInfo["isAdmin"] as! String
                    var membership_status=userInfo["membership_status"] as! String
                    
                    var uniqueid1=UtilityFunctions.init().generateUniqueid()
                    
                    sqliteDB.updateMembershipStatus(groupId,memberphone1: senderId, membership_status1: "left")
                    sqliteDB.storeGroupsChat("Log:", group_unique_id1: groupId, type1: "log", msg1: "\(senderId) has left this group", from_fullname1: "", date1: Date(), unique_id1: uniqueid1)
                    ///////  sqliteDB.removeMember(groupId!,member_phone1: senderId!)
                    if(delegateRefreshChat != nil)
                    {
                        print("refresh UI after member leaves")
                        delegateRefreshChat?.refreshChatsUI(nil, uniqueid:nil, from:nil, date1:nil, type:"status")
                    }
                
                    UIDelegates.getInstance().UpdateMainPageChatsDelegateCall()
                    UIDelegates.getInstance().UpdateGroupInfoDetailsDelegateCall()
                    UIDelegates.getInstance().UpdateGroupChatDetailsDelegateCall()
                    
                    completionHandler([.alert, .badge, .sound])
                   // completionHandler(UIBackgroundFetchResult.newData)
                    
                    //updateUI
                    
                }
                //removed_from_group
                if(type=="group:removed_from_group")
                {
                    var senderId=userInfo["senderId"] as! String
                    var isAdmin=userInfo["isAdmin"] as! String
                    var membership_status=userInfo["membership_status"] as! String
                    var personRemoved=userInfo["personRemoved"] as! String
                    var groupId=userInfo["groupId"] as! String
                    
                    var uniqueid1=UtilityFunctions.init().generateUniqueid()
                    
                    sqliteDB.updateMembershipStatus(groupId,memberphone1: personRemoved, membership_status1: "left")
                    
                    if(personRemoved == username!)
                    {
                        sqliteDB.storeGroupsChat("Log:", group_unique_id1: groupId, type1: "log", msg1: "\(senderId) removed you", from_fullname1: "", date1: Date(), unique_id1: uniqueid1)
                    }
                    else{
                        sqliteDB.storeGroupsChat("Log:", group_unique_id1: groupId, type1: "log", msg1: "\(personRemoved) is removed from this group", from_fullname1: "", date1: Date(), unique_id1: uniqueid1)
                    }
                    ///////  sqliteDB.removeMember(groupId!,member_phone1: senderId!)
                    /*if(delegateRefreshChat != nil)
                    {
                        print("refresh UI after member leaves")
                        delegateRefreshChat?.refreshChatsUI(nil, uniqueid:nil, from:nil, date1:nil, type:"status")
                    }*/
                    UIDelegates.getInstance().UpdateMainPageChatsDelegateCall()
                    UIDelegates.getInstance().UpdateGroupInfoDetailsDelegateCall()
                    UIDelegates.getInstance().UpdateGroupChatDetailsDelegateCall()
                    
                    completionHandler([.alert, .badge, .sound])
                   // completionHandler(UIBackgroundFetchResult.newData)
                    
                    /*
                     [senderId: +923201211991, badge: 0, aps: {
                     }, isAdmin: No, membership_status: left, type: group:removed_from_group, personRemoved: +923323800399, groupId: cFBhfRu201611116656]
                     [senderId: +923201211991, badge: 0, aps: {
                     }, isAdmin: No, membership_status: left, type: group:removed_from_group, personRemoved: +923323800399, groupId: cFBhfRu201611116656]
                     
                     */
                }
                
                if(type=="group:icon_update")
                {
                    print("group icon is changed")
                    var groupId=userInfo["groupId"] as! String
                    //"exists".dataUsingEncoding(NSUTF8StringEncoding)!
                    UtilityFunctions.init().downloadProfileImage(groupId)
                }
                
                if(type=="syncUpward")
                {
                    
                    UtilityFunctions.init().log_papertrail("IPHONE: UPWARD SYNC PUSH \(userInfo) ... PAYLOAD: \(userInfo["payload"])")
                    var sub_type = userInfo["sub_type"] as! String
                    
                    if(sub_type=="unsentMessages")
                    {
                        if let payload=userInfo["payload"] as? [AnyHashable : Any]
                        {
                        var uniqueid=payload["uniqueid"] as! String
                        var status=payload["status"] as! String
                        
                        sqliteDB.UpdateChatStatus(uniqueid, newstatus: status)
                        
                        UIDelegates.getInstance().UpdateMainPageChatsDelegateCall()
                        UIDelegates.getInstance().UpdateGroupInfoDetailsDelegateCall()
                        UIDelegates.getInstance().UpdateGroupChatDetailsDelegateCall()
                        
                        completionHandler([.alert, .badge, .sound])
                        }
                        
                    }
                    if(sub_type=="unsentGroupMessages")
                    {
                        UtilityFunctions.init().log_papertrail("IPHONE: UPWARD SYNC PUSH \(userInfo) ... PAYLOAD: \(userInfo["payload"])")
                        print("push got group chat \(userInfo)")
                        
                        if let payload=userInfo["payload"] as? [AnyHashable : Any]
                        {var uniqueid=payload["unique_id"] as! String
                        
                        
                        let msg_unique_id = Expression<String>("msg_unique_id")
                        let Status = Expression<String>("Status")
                        let user_phone = Expression<String>("user_phone")
                        
                        let read_date = Expression<Date>("read_date")
                        let delivered_date = Expression<Date>("delivered_date")
                        
                        
                        
                        sqliteDB.group_chat_status = Table("group_chat_status")
                        
                        let query = sqliteDB.group_chat_status.select(Status).filter(msg_unique_id == uniqueid)
                        do
                        {let row=try sqliteDB.db.run(query.update(Status <- "sent"))
                            
                            UIDelegates.getInstance().UpdateMainPageChatsDelegateCall()
                            UIDelegates.getInstance().UpdateGroupInfoDetailsDelegateCall()
                            UIDelegates.getInstance().UpdateGroupChatDetailsDelegateCall()
                            
                            completionHandler([.alert, .badge, .sound])
                        }
                        catch{
                            
                        }
                        
                    }
                    
                    }
                    //unsentChatMessageStatus
                    //unsentGroupChatMessageStatus
                    //unsentGroups
                    //unsentAddedGroupMembers
                    //unsentRemovedGroupMembers
                    //statusOfSentMessages
                    //statusOfSentGroupMessages
                    if(sub_type=="unsentChatMessageStatus")
                    {
                        if let payload=userInfo["payload"] as? [AnyHashable : Any] {
                            
                        if(payload.count>0)
                        {
                            var uniqueid=payload["uniqueid"] as! String
                            sqliteDB.removeMessageStatusSeen(uniqueid)
                        }
                    }
                    }
                    
                    if(sub_type=="unsentGroupChatMessageStatus")
                    {
                      if let payload=userInfo["payload"] as? [AnyHashable : Any]
                      {if(payload.count>0)
                        {
                            
                            var chat_uniqueid=payload["chat_uniqueid"] as! String
                            var status=payload["status"] as! String
                            
                            sqliteDB.removeGroupStatusTemp(status, memberphone1: username!, messageuniqueid1: chat_uniqueid)
                            sqliteDB.updateGroupChatStatus(chat_uniqueid, memberphone1: username!, status1: status, delivereddate1: NSDate() as Date!, readDate1: NSDate() as Date!)
                            
                            UIDelegates.getInstance().UpdateMainPageChatsDelegateCall()
                            UIDelegates.getInstance().UpdateGroupInfoDetailsDelegateCall()
                            UIDelegates.getInstance().UpdateGroupChatDetailsDelegateCall()
                            
                            completionHandler(.alert)
                        }
                    }
                    }
                    if(sub_type=="unsentGroups")
                    {
                        
                    }
                    
                    if(sub_type=="unsentAddedGroupMembers")
                    {
                        
                    }
                    
                    if(sub_type=="unsentRemovedGroupMembers")
                    {
                        
                    }
                    
                    if(sub_type=="statusOfSentMessages")
                    {
                        //"uniqueid":"3fc8d6548c22c3341172114344","status":"delivered
                        
                        if let payload=userInfo["payload"] as? JSON
                        {
                            for var i in 0 ..< payload.count
                            {
                            var uniqueid=payload[i]["uniqueid"] as! String
                            var status=payload[i]["status"] as! String
                            
                            sqliteDB.UpdateChatStatus(uniqueid, newstatus: status)
                            UIDelegates.getInstance().UpdateMainPageChatsDelegateCall()
                            UIDelegates.getInstance().UpdateGroupInfoDetailsDelegateCall()
                            UIDelegates.getInstance().UpdateGroupChatDetailsDelegateCall()
                            
                            completionHandler(.alert)
                        }
                    }
                    
                    }
                    
                    if(sub_type=="statusOfSentGroupMessages")
                    {
                        UtilityFunctions.init().log_papertrail("IPHONE: UPWARD SYNC PUSH \(userInfo) ... PAYLOAD: \(userInfo["payload"])")
                        print("statusOfSentGroupMessages")
                        
                        
                        if let payload=userInfo["payload"] as? [AnyHashable : Any]
                        {if(payload.count>0)
                        {
                            
                            var chat_unique_id=payload["chat_unique_id"] as! String
                            var user_phone=payload["user_phone"] as! String
                            var read_date=payload["read_date"] as! String
                            var delivered_date=payload["delivered_date"] as! String
                            var status=payload["status"] as! String
                            
                            for var i in 0 ..< payload.count
                            {
                                var uniqueid1=chat_unique_id
                                var user_phone1=user_phone
                                var read_dateString=read_date
                                
                                var delivered_dateString=delivered_date
                                var status1=status
                                
                                let dateFormatter = DateFormatter()
                                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                                
                                let delivered_date = dateFormatter.date(from: delivered_dateString)
                                let read_date = dateFormatter.date(from:read_dateString)
                                
                                print("updating status ......... \(i)")
                                sqliteDB.updateGroupChatStatus(uniqueid1, memberphone1: user_phone1, status1: status1, delivereddate1: delivered_date, readDate1: read_date)
                            }
                            
                            UIDelegates.getInstance().UpdateMainPageChatsDelegateCall()
                            UIDelegates.getInstance().UpdateGroupInfoDetailsDelegateCall()
                            UIDelegates.getInstance().UpdateGroupChatDetailsDelegateCall()
                            
                            completionHandler(.alert)
                        }
                    }
                    }
                }
                
                
                
                //}
            }
            
                }
            }
            else
            {
                UtilityFunctions.init().log_papertrail("Push received when insactive, not processed \(userInfo)")
            }
        completionHandler([.alert, .badge, .sound])
            */
    }
    

       // completionHandler([.alert, .badge, .sound])
  //  }
    
    //Called to let your app know which action was selected by the user for a given notification.
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        UtilityFunctions.init().getAppState(currentState: UIApplication.shared.applicationState.rawValue)
        UtilityFunctions.init().log_papertrail("IPHONE: didReceive notification iOS10 \(response.notification.request.content.userInfo)")
      
        
        //UtilityFunctions.init().log_papertrail("IPHONE: iOS 10+ \(username!) didreceive \(response.notification.request.content.userInfo)")
            
       ///// UtilityFunctions.init().log_papertrail("iOS 10 mode \(UIApplication.shared.applicationState) User Info = \(response.notification.request.content.userInfo)")
          //  print("User Info = ",response.notification.request.content.userInfo)
        
        /*var userInfo=response.notification.request.content.userInfo
        
        if(UIApplication.shared.applicationState.rawValue != UIApplicationState.inactive.rawValue)
        {
            
            Alamofire.request("https://api.cloudkibo.com/api/users/log", method: .post, parameters: ["data":"IPHONE_LOG: \(username!) iOS 10+ received push notification as \(userInfo.description)"],headers:header).response{
                response in
                print(response.error)
            }
            
            if  let singleuniqueid = userInfo["uniqueId"] as? String {
                // Printout of (userInfo["aps"])["type"]
                print("\nFrom APS-dictionary with key \"singleuniqueid\":  \( singleuniqueid)")
                if  let notifType = userInfo["type"] as? String {
                    print("payload of satus or iOS chat")
                    if(notifType=="status")
                    {
                        updateMessageStatus(singleuniqueid, status: (userInfo["status"] as? String)!)
                        print("calling completion handler for status update now")
                        completionHandler()
                        //  completionHandler(UIBackgroundFetchResult.newData)
                        NotificationCenter.default.post(name: Notification.Name(rawValue: "ReceivedNotification"), object:userInfo)
                        
                    }
                    else
                    {/*
                         group:you_are_added
                         */
                        
                        if(notifType=="chat" || notifType=="file" || notifType=="contact" || notifType=="location")
                            
                        {print("payload of iOS chat")
                            fetchSingleChatMessage(singleuniqueid)
                            print("calling completion handler for fetch chat now")
                            
                            completionHandler()
                            //completionHandler(UIBackgroundFetchResult.newData)
                            NotificationCenter.default.post(name: Notification.Name(rawValue: "ReceivedNotification"), object:userInfo)
                        }
                            
                        else
                        {
                            if(notifType=="group:msg_status_changed")
                                
                            {print("inside here updating status")
                                //change message status
                                //status : 'delivered',
                                //uniqueId : req.body.unique_id
                                var uniqueId=userInfo["uniqueId"] as! String
                                var status=userInfo["status"] as! String
                                var user_phone=userInfo["user_phone"] as? String
                                
                                let dateFormatter = DateFormatter()
                                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                                var delivered_date=Date()
                                var read_date=Date()
                                
                                
                                
                                /* if(status == "delivered")
                                 {
                                 var delivered_dateString=userInfo["delivered_date"] as! String
                                 delivered_date = dateFormatter.date(from:delivered_dateString)!
                                 
                                 
                                 }
                                 else
                                 {
                                 var read_dateString=userInfo["read_date"] as! String
                                 read_date = dateFormatter.date(from:read_dateString)!
                                 
                                 
                                 }
                                 
                                 */
                                
                                if(user_phone == nil)
                                {
                                    user_phone=""
                                }
                                sqliteDB.updateGroupChatStatus(uniqueId,memberphone1: user_phone!,status1: status, delivereddate1: delivered_date, readDate1: read_date)
                                UIDelegates.getInstance().UpdateMainPageChatsDelegateCall()
                                UIDelegates.getInstance().UpdateGroupChatDetailsDelegateCall()
                                UIDelegates.getInstance().UpdateGroupInfoDetailsDelegateCall()
                                
                            }
                            else{
                                
                                if(notifType=="block:blockedyou")
                                    
                                {print("inside i am blocked")
                                    //change message status
                                    //status : 'delivered',
                                    //uniqueId : req.body.unique_id
                                    var phone=userInfo["phone"] as! String
                                    sqliteDB.IamBlockedUpdateStatus(phone1: phone, status1: true)
                                }
                                else{
                                    
                                    if(notifType=="block:unblockedyou")
                                        
                                    {print("inside i am unblocked")
                                        //change message status
                                        //status : 'delivered',
                                        //uniqueId : req.body.unique_id
                                        var phone=userInfo["phone"] as! String
                                        sqliteDB.IamBlockedUpdateStatus(phone1: phone, status1: false)
                                    }
                                }
                            }
                        }
                        
                        /* else
                         {
                         if(notifType=="group:you_are_added")
                         {
                         
                         //you are added to group
                         /*   Body: group_unique_id = <group_unique_id>, members = [‘+9233232900920’, ‘+9432233919233’, ....]
                         Push notification will be sent to other members of group:
                         var payload = {
                         type : 'group:you_are_added',
                         senderId : ‘<admin phone number>’,
                         groupId : ‘<unique id of group>’,
                         isAdmin: 'No',
                         membership_status : 'joined',
                         group_name: ‘<name of the group>’,
                         badge : <ignore this field>
                         };
                         */
                         }
                         }
                         
                         }*/
                        
                    }
                }
                else
                {
                    print("rwong payload without type field")
                    
                    /*
                     //==
                     // this is from android
                     //==
                     fetchSingleChatMessage(singleuniqueid)
                     
                     */
                    // completionHandler(UIBackgroundFetchResult.newData)
                    completionHandler()
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "ReceivedNotification"), object:userInfo)
                    
                    
                }
                
                // Do your stuff?
                
                
            }
                
            else
            {
                //handle Group Push here
                //you are added to group
                /* Body: group_unique_id = <group_unique_id>, members = [‘+9233232900920’, ‘+9432233919233’, ....]
                 Push notification will be sent to other members of group:
                 var payload = {
                 type : 'group:you_are_added',
                 senderId : ‘<admin phone number>’,
                 groupId : ‘<unique id of group>’,
                 isAdmin: 'No',
                 membership_status : 'joined',
                 group_name: ‘<name of the group>’,
                 badge : <ignore this field>
                 };
                 *?
                 }
                 }
                 
                 }*/
                if  let type = userInfo["type"] as? String {
                    print(userInfo)
                    // Printout of (userInfo["aps"])["type"]
                    print("group push unique_id is \( type)")
                    // if  let notifType = userInfo["type"] as? String {
                    
                    if(type=="group:you_are_added")
                    {
                        var senderid = userInfo["senderId"] as! String
                        var groupId = userInfo["groupId"] as? String
                        var isAdmin = userInfo["isAdmin"] as! String
                        var membership_status = userInfo["membership_status"] as! String
                        var group_name = userInfo["group_name"] as! String
                        DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.background).async {
                            self.fetchSingleGroup(groupId!, completion: { (result, error) in
                                
                                self.fetchGroupMembersSpecificGroup(groupId!,completion: { (result, error) in
                                    
                                    sqliteDB.storeGroupsChat("Log:", group_unique_id1: groupId!, type1: "log", msg1: "You are added by \(senderid)", from_fullname1: "", date1: Date(), unique_id1:UtilityFunctions.init().generateUniqueid())
                                    UIDelegates.getInstance().UpdateMainPageChatsDelegateCall()
                                    UIDelegates.getInstance().UpdateGroupInfoDetailsDelegateCall()
                                    
                                    completionHandler()
                                    //   completionHandler(UIBackgroundFetchResult.newData)
                                })
                                
                            })
                        }
                        /* dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)) {
                         print("synccccc fetching contacts in background...")
                         {
                         self.fetchSingleGroup(groupId, completion: { (result, error) in
                         
                         print("group fetched now fetch members")
                         
                         })}}*/
                        
                    }
                    if(type=="group:chat_received")
                    {
                        
                        
                        var senderId=userInfo["senderId"] as? String  //from
                        var groupId=userInfo["groupId"] as? String
                        var msg_type=userInfo["msg_type"] as? String
                        var unique_id=userInfo["unique_id"] as? String
                        
                        self.fetchSingleGroupChatMessage(unique_id!,completion: {(result,error) in
                            
                            UIDelegates.getInstance().UpdateGroupChatDetailsDelegateCall()
                            UIDelegates.getInstance().UpdateMainPageChatsDelegateCall()
                            UIDelegates.getInstance().UpdateGroupInfoDetailsDelegateCall()
                            
                            completionHandler()
                            // completionHandler(UIBackgroundFetchResult.newData)
                        })
                        
                        
                        
                        
                    }
                    
                    
                    
                    
                    if(type=="group:member_left_group")
                    {
                        var senderId=userInfo["senderId"] as! String  //from
                        var groupId=userInfo["groupId"] as! String
                        var isAdmin=userInfo["isAdmin"] as! String
                        var membership_status=userInfo["membership_status"] as! String
                        
                        var uniqueid1=UtilityFunctions.init().generateUniqueid()
                        
                        sqliteDB.updateMembershipStatus(groupId,memberphone1: senderId, membership_status1: "left")
                        sqliteDB.storeGroupsChat("Log:", group_unique_id1: groupId, type1: "log", msg1: "\(senderId) has left this group", from_fullname1: "", date1: Date(), unique_id1: uniqueid1)
                        ///////  sqliteDB.removeMember(groupId!,member_phone1: senderId!)
                        if(delegateRefreshChat != nil)
                        {
                            print("refresh UI after member leaves")
                            delegateRefreshChat?.refreshChatsUI(nil, uniqueid:nil, from:nil, date1:nil, type:"status")
                        }
                        
                        UIDelegates.getInstance().UpdateMainPageChatsDelegateCall()
                        UIDelegates.getInstance().UpdateGroupInfoDetailsDelegateCall()
                        UIDelegates.getInstance().UpdateGroupChatDetailsDelegateCall()
                        
                        completionHandler()
                        // completionHandler(UIBackgroundFetchResult.newData)
                        
                        //updateUI
                        
                    }
                    //removed_from_group
                    if(type=="group:removed_from_group")
                    {
                        var senderId=userInfo["senderId"] as! String
                        var isAdmin=userInfo["isAdmin"] as! String
                        var membership_status=userInfo["membership_status"] as! String
                        var personRemoved=userInfo["personRemoved"] as! String
                        var groupId=userInfo["groupId"] as! String
                        
                        var uniqueid1=UtilityFunctions.init().generateUniqueid()
                        
                        sqliteDB.updateMembershipStatus(groupId,memberphone1: personRemoved, membership_status1: "left")
                        
                        if(personRemoved == username!)
                        {
                            sqliteDB.storeGroupsChat("Log:", group_unique_id1: groupId, type1: "log", msg1: "\(senderId) removed you", from_fullname1: "", date1: Date(), unique_id1: uniqueid1)
                        }
                        else{
                            sqliteDB.storeGroupsChat("Log:", group_unique_id1: groupId, type1: "log", msg1: "\(personRemoved) is removed from this group", from_fullname1: "", date1: Date(), unique_id1: uniqueid1)
                        }
                        ///////  sqliteDB.removeMember(groupId!,member_phone1: senderId!)
                        /*if(delegateRefreshChat != nil)
                         {
                         print("refresh UI after member leaves")
                         delegateRefreshChat?.refreshChatsUI(nil, uniqueid:nil, from:nil, date1:nil, type:"status")
                         }*/
                        UIDelegates.getInstance().UpdateMainPageChatsDelegateCall()
                        UIDelegates.getInstance().UpdateGroupInfoDetailsDelegateCall()
                        UIDelegates.getInstance().UpdateGroupChatDetailsDelegateCall()
                        
                        completionHandler()
                        // completionHandler(UIBackgroundFetchResult.newData)
                        
                        /*
                         [senderId: +923201211991, badge: 0, aps: {
                         }, isAdmin: No, membership_status: left, type: group:removed_from_group, personRemoved: +923323800399, groupId: cFBhfRu201611116656]
                         [senderId: +923201211991, badge: 0, aps: {
                         }, isAdmin: No, membership_status: left, type: group:removed_from_group, personRemoved: +923323800399, groupId: cFBhfRu201611116656]
                         
                         */
                    }
                    
                    if(type=="group:icon_update")
                    {
                        print("group icon is changed")
                        var groupId=userInfo["groupId"] as! String
                        //"exists".dataUsingEncoding(NSUTF8StringEncoding)!
                        UtilityFunctions.init().downloadProfileImage(groupId)
                    }
                    
                    if(type=="syncUpward")
                    {
                        
                        UtilityFunctions.init().log_papertrail("IPHONE: UPWARD SYNC PUSH \(userInfo) ... PAYLOAD: \(userInfo["payload"] as! [AnyHashable : Any])")
                        var sub_type = userInfo["sub_type"] as! String
                        
                        if(sub_type=="unsentMessages")
                        {
                            var payload=userInfo["payload"] as! [AnyHashable : Any]
                            var uniqueid=payload["uniqueid"] as! String
                            var status=payload["status"] as! String
                            
                            sqliteDB.UpdateChatStatus(uniqueid, newstatus: status)
                            
                            UIDelegates.getInstance().UpdateMainPageChatsDelegateCall()
                            UIDelegates.getInstance().UpdateGroupInfoDetailsDelegateCall()
                            UIDelegates.getInstance().UpdateGroupChatDetailsDelegateCall()
                            
                            completionHandler()
                            
                            
                        }
                        if(sub_type=="unsentGroupMessages")
                        {
                            UtilityFunctions.init().log_papertrail("IPHONE: UPWARD SYNC PUSH \(userInfo) ... PAYLOAD: \(userInfo["payload"] as! [AnyHashable : Any])")
                            print("push got group chat \(userInfo)")
                            
                            var payload=userInfo["payload"] as! [AnyHashable : Any]
                            var uniqueid=payload["unique_id"] as! String
                            
                            
                            let msg_unique_id = Expression<String>("msg_unique_id")
                            let Status = Expression<String>("Status")
                            let user_phone = Expression<String>("user_phone")
                            
                            let read_date = Expression<Date>("read_date")
                            let delivered_date = Expression<Date>("delivered_date")
                            
                            
                            
                            sqliteDB.group_chat_status = Table("group_chat_status")
                            
                            let query = sqliteDB.group_chat_status.select(Status).filter(msg_unique_id == uniqueid)
                            do
                            {let row=try sqliteDB.db.run(query.update(Status <- "sent"))
                                
                                UIDelegates.getInstance().UpdateMainPageChatsDelegateCall()
                                UIDelegates.getInstance().UpdateGroupInfoDetailsDelegateCall()
                                UIDelegates.getInstance().UpdateGroupChatDetailsDelegateCall()
                                
                                completionHandler()
                            }
                            catch{
                                
                            }
                            
                            
                            
                        }
                        //unsentChatMessageStatus
                        //unsentGroupChatMessageStatus
                        //unsentGroups
                        //unsentAddedGroupMembers
                        //unsentRemovedGroupMembers
                        //statusOfSentMessages
                        //statusOfSentGroupMessages
                        if(sub_type=="unsentChatMessageStatus")
                        {
                            var payload=userInfo["payload"] as! [AnyHashable : Any]
                            if(payload.count>0)
                            {
                                var uniqueid=payload["uniqueid"] as! String
                                sqliteDB.removeMessageStatusSeen(uniqueid)
                            }
                        }
                        
                        if(sub_type=="unsentGroupChatMessageStatus")
                        {
                            var payload=userInfo["payload"] as! [AnyHashable : Any]
                            if(payload.count>0)
                            {
                                
                                var chat_uniqueid=payload["chat_uniqueid"] as! String
                                var status=payload["status"] as! String
                                
                                sqliteDB.removeGroupStatusTemp(status, memberphone1: username!, messageuniqueid1: chat_uniqueid)
                                sqliteDB.updateGroupChatStatus(chat_uniqueid, memberphone1: username!, status1: status, delivereddate1: NSDate() as Date!, readDate1: NSDate() as Date!)
                                
                                UIDelegates.getInstance().UpdateMainPageChatsDelegateCall()
                                UIDelegates.getInstance().UpdateGroupInfoDetailsDelegateCall()
                                UIDelegates.getInstance().UpdateGroupChatDetailsDelegateCall()
                                
                                completionHandler()
                            }
                            
                        }
                        if(sub_type=="unsentGroups")
                        {
                            
                        }
                        
                        if(sub_type=="unsentAddedGroupMembers")
                        {
                            
                        }
                        
                        if(sub_type=="unsentRemovedGroupMembers")
                        {
                            
                        }
                        
                        if(sub_type=="statusOfSentMessages")
                        {
                            //"uniqueid":"3fc8d6548c22c3341172114344","status":"delivered
                            
                            var payload=userInfo["payload"] as! [AnyHashable : Any]
                            if(payload.count>0)
                            {
                                var uniqueid=payload["uniqueid"] as! String
                                var status=payload["status"] as! String
                                
                                sqliteDB.UpdateChatStatus(uniqueid, newstatus: status)
                                UIDelegates.getInstance().UpdateMainPageChatsDelegateCall()
                                UIDelegates.getInstance().UpdateGroupInfoDetailsDelegateCall()
                                UIDelegates.getInstance().UpdateGroupChatDetailsDelegateCall()
                                
                                completionHandler()
                            }
                            
                            
                        }
                        
                        if(sub_type=="statusOfSentGroupMessages")
                        {
                            UtilityFunctions.init().log_papertrail("IPHONE: UPWARD SYNC PUSH \(userInfo) ... PAYLOAD: \(userInfo["payload"] as! [AnyHashable : Any])")
                            print("statusOfSentGroupMessages")
                            
                            
                            var payload=userInfo["payload"] as! [AnyHashable : Any]
                            if(payload.count>0)
                            {
                                
                                var chat_unique_id=payload["chat_unique_id"] as! String
                                var user_phone=payload["user_phone"] as! String
                                var read_date=payload["read_date"] as! String
                                var delivered_date=payload["delivered_date"] as! String
                                var status=payload["status"] as! String
                                
                                for var i in 0 ..< payload.count
                                {
                                    var uniqueid1=chat_unique_id
                                    var user_phone1=user_phone
                                    var read_dateString=read_date
                                    
                                    var delivered_dateString=delivered_date
                                    var status1=status
                                    
                                    let dateFormatter = DateFormatter()
                                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                                    
                                    let delivered_date = dateFormatter.date(from: delivered_dateString)
                                    let read_date = dateFormatter.date(from:read_dateString)
                                    
                                    print("updating status ......... \(i)")
                                    sqliteDB.updateGroupChatStatus(uniqueid1, memberphone1: user_phone1, status1: status1, delivereddate1: delivered_date, readDate1: read_date)
                                }
                                
                                UIDelegates.getInstance().UpdateMainPageChatsDelegateCall()
                                UIDelegates.getInstance().UpdateGroupInfoDetailsDelegateCall()
                                UIDelegates.getInstance().UpdateGroupChatDetailsDelegateCall()
                                
                                completionHandler()
                            }
                            
                        }
                    }
                    
                    
                    
                    //}
                }
                
            }
        }
        else
        {
            UtilityFunctions.init().log_papertrail("Push received when insactive, not processed \(userInfo)")
        }
        */
        completionHandler()
    }
    
    
    
    func contactChanged(_ notification : Notification)
    {
        print("phonebood opened notification name \(notification.name)")
        /*Alamofire.request(.POST,"\(Constants.MainUrl+Constants.urllog)",headers:header,parameters: ["data":"IPHONE_LOG: Device phonebook opened notification \(username!)"]).response{
         request, response_, data, error in
         print(error)
         //   }
         
         */
        if(notification.name==NSNotification.Name.CNContactStoreDidChange)
        {
            let now=Date()
            print("contact changed notification received")
            guard addressbookChangedNotifReceivedDateTime==nil || now.timeIntervalSince(addressbookChangedNotifReceivedDateTime!)>2 else{
                print("returning")
                return}
            addressbookChangedNotifReceivedDateTime=now
            
            if(addressbookChangedNotifReceived==false)
            {
                
                addressbookChangedNotifReceived=true
                var userInfo: NSDictionary!
                userInfo = notification.userInfo as NSDictionary!
                print(userInfo)
                print(userInfo.allKeys.debugDescription)
                print("contacts changed sync now starting")
                
                //====-------
                DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.background).async
                {
                    syncServiceContacts.startSyncService()
                }
            }
            else
            {
                print("some other notification received")
            }
            
            //===-----
            /*var sync=syncContactService.init()
             sync.startContactsRefresh()
             tblForChat.reloadData()
             
             
             }
             */
        }
    }
    
   /* func contactChanged(notification : NSNotification)
    {
        print("contact changed notification received")
        var userInfo: NSDictionary!
        userInfo = notification.userInfo
        print(userInfo.allKeys.debugDescription)
        var sync=syncContactService.init()
        sync.startContactsRefresh()
    
        
    }*/
    var pendingchatsarray=[[String:String]]()
    var pendinggroupchatsarray=[[String:AnyObject]]()
    
    /*func synchroniseChatData()
    {
                print("synchronise called")
        if(accountKit == nil){
            accountKit = AKFAccountKit(responseType: AKFResponseType.accessToken)
        }
        
        if (accountKit!.currentAccessToken != nil) {
            
            header=["kibo-token":accountKit!.currentAccessToken!.tokenString]
            
            let _id = Expression<String>("_id")
            let phone = Expression<String>("phone")
            let username1 = Expression<String>("username")
            let status = Expression<String>("status")
            let firstname = Expression<String>("firstname")
            
            
            
            let tbl_accounts = sqliteDB.accounts
            do{for account in try sqliteDB.db.prepare(tbl_accounts!) {
                username=account[username1]
                //displayname=account[firstname]
                
                }
            }
            catch
            {
                if(socketObj != nil){
                    socketObj.socket.emit("error getting data from accounts table")
                }
                print("error in getting data from accounts table \(error)")
                
            }
            
            Alamofire.request("\(Constants.MainUrl+Constants.urllog)", method: .post, parameters: ["data":"IPHONE_LOG: partial sync chat \(username!)"], encoding: JSONEncoding.default)
                .downloadProgress(queue: DispatchQueue.global(qos: .utility)) { progress in
                    print("Progress: \(progress.fractionCompleted)")
                }
                .validate { request, response, data in
                    // Custom evaluation closure now includes data (allows you to parse data to dig out error messages if necessary)
                    return .success
                }
                .responseJSON { response in
                    debugPrint(response)
            }
            
            
            ///updated alamofire4
            /*
            Alamofire.request("\(Constants.MainUrl+Constants.urllog)", method: .post, parameters: ["data":"IPHONE_LOG: partial sync chat \(username!)"], encoding: NSUTF8StringEncoding, headers: header)  /*(.POST,"\(Constants.MainUrl+Constants.urllog)",headers:header,parameters: ["data":"IPHONE_LOG: partial sync chat \(username!)"])*/.response{
                request, response_, data, error in
                print(error)
            }
*/
            
            //  dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) {
            
            
            //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            // if(socketObj != nil)
            // {
           
            
            
            //======== uncommenting. will be handled in chat part below managerFile.checkPendingFiles(username!)
         
            self.sendPendingChatMessages({ (result) -> () in
                
                self.getData({ (result) -> () in
                    self.index=0
                    
                    /*Alamofire.request(.POST,"\(Constants.MainUrl+Constants.urllog)",headers:header,parameters: ["data":"IPHONE_LOG: checkin here pending chat messages sent"]).response{
                        request, response_, data, error in
                        print(error)
                    }*/
                    
                    
                   /* self.sendPendingGroupChatMessages({ (result) -> () in
                        
                        self.getData({ (result) -> () in
                            self.index2=0
                            self.pendinggroupchatsarray.removeAll()
                            Alamofire.request(.POST,"\(Constants.MainUrl+Constants.urllog)",headers:header,parameters: ["data":"IPHONE_LOG: sending pending group chat messages"]).response{
                                request, response_, data, error in
                                print(error)
                            }
                        })})*/
                    
                    // print("checkin here pending messages sent")
                    
                    // if(socketObj != nil)
                    //{
                    if(self.pendingchatsarray.count>0)
                    {
                    if(delegateRefreshChat != nil)
                    {
                        print("refresh UI after pending msgs are sent")
                        delegateRefreshChat?.refreshChatsUI(nil, uniqueid:nil, from:nil, date1:nil, type:"status")
                    }
                    self.pendingchatsarray.removeAll()
                    }
                    /////======CHANGE IT==================
                    
                    
                    self.fetchChatsFromServer()
                    
                    
                    
                    //}
                })
            })
        }
    }*/
    /*{
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
                
                Alamofire.request(.POST,"\(Constants.MainUrl+Constants.urllog)",headers:header,parameters: ["data":"IPHONE_LOG: \(username!) received push notification as \(userInfo.description)"]).response{
                    request, response_, data, error in
                    print(error)
                }
                
                print("checkin here pending messages sent")
                print("checkin fetching chats")
                // if(socketObj != nil)
                //{
                self.fetchChatsFromServer()
                //}
                
            })
        }
    }
    */

    
    var index=0
    // var pendingcount=0
    
    func getData(_ completion:@escaping (_ result:Bool)->()) {
        var x = [[String: AnyObject]]()
        var url=Constants.MainUrl+Constants.sendChatURL
        /*
         let request = Alamofire.request(.POST, "\(url)", parameters: chatstanza,headers:header)
         request.response(
         queue: queue,
         responseSerializer: Request.JSONResponseSerializer(options: .AllowFragments),
         completionHandler: { response in
         
         */
        
        if(pendingchatsarray.count>index)
        {
            
            var req=Alamofire.request("\(url)", method: .post, parameters: pendingchatsarray[index],headers:header)
               /*( .downloadProgress(queue: DispatchQueue.global(qos: .utility)) { progress in
                    print("Progress: \(progress.fractionCompleted)")
                }
                .validate { request, response, data in
                    // Custom evaluation closure now includes data (allows you to parse data to dig out error messages if necessary)
                    return .success
                }
                */
                req.response { response in
                    debugPrint(response)
                    if (response.response?.statusCode==200) {
                      print("success sent pending chat")
                   // case .success(let JSON):
                        //x[self.index] = JSON as! [String : AnyObject] // saving data
                        var statusNow="sent"
                        ///var chatmsg=JSON(data)
                        /// print(data[0])
                        ///print(chatmsg[0])
                        //  print("chat sent msg \(chatstanza)")
                        
                        sqliteDB.UpdateChatStatus(self.pendingchatsarray[self.index]["uniqueid"]!, newstatus: "sent")
                        completion(true)
                        
                        
                        self.index = self.index + 1
                        if self.index < self.pendingchatsarray.count {
                            self.getData({ (result) -> () in})
                        }else {
                            completion(true)
                            /////////self.collectionView.reloadData()
                        }
                    }
                    //case .failure(let error):
                    else{
                        print("the error for \(self.pendingchatsarray[self.index]) is \(response.error) ")
                        if self.index < self.pendingchatsarray.count {
                            self.getData({ (result) -> () in})
                        }else {
                            completion(true)                /////////// self.collectionView.reloadData()
                        }
            }
                    }
            }
            
            
            //alamofire4
            /*let request = Alamofire.request(.POST, "\(url)", parameters: pendingchatsarray[index],headers:header).responseJSON { response in
                switch response.result {
                case .Success(let JSON):
                    //x[self.index] = JSON as! [String : AnyObject] // saving data
                    var statusNow="sent"
                    ///var chatmsg=JSON(data)
                    /// print(data[0])
                    ///print(chatmsg[0])
                    //  print("chat sent msg \(chatstanza)")
                    
                    sqliteDB.UpdateChatStatus(self.pendingchatsarray[self.index]["uniqueid"]!, newstatus: "sent")
                    completion(result:true)
                    
                    
                    self.index = self.index + 1
                    if self.index < self.pendingchatsarray.count {
                        self.getData({ (result) -> () in})
                    }else {
                        completion(result: true)
                        /////////self.collectionView.reloadData()
                    }
                case .Failure(let error):
                    print("the error for \(self.pendingchatsarray[self.index]) is \(error) ")
                    if self.index < self.pendingchatsarray.count {
                        self.getData({ (result) -> () in})
                    }else {
                        completion(result: true)                /////////// self.collectionView.reloadData()
                    }
                }
            }*/
    
    }
    
    
    
    
    var index2=0
    // var pendingcount=0
    
    func getGroupsData(_ completion:@escaping (_ result:Bool)->()) {
        var x = [[String: AnyObject]]()
       // var url=Constants.MainUrl+Constants.sendChatURL
        /*
         let request = Alamofire.request(.POST, "\(url)", parameters: chatstanza,headers:header)
         request.response(
         queue: queue,
         responseSerializer: Request.JSONResponseSerializer(options: .AllowFragments),
         completionHandler: { response in
         
         */
        
        if(pendinggroupchatsarray.count>index2)
        {
            sendGroupChatMessage(pendinggroupchatsarray[self.index2]["group_unique_id"] as! String, from: pendinggroupchatsarray[self.index2]["from"] as! String, type: pendinggroupchatsarray[self.index2]["type"] as! String, msg: pendinggroupchatsarray[self.index2]["msg"] as! String, fromFullname: pendinggroupchatsarray[self.index2]["from_fullname"] as! String, uniqueidChat: pendinggroupchatsarray[self.index2]["unique_id"] as! String, completion: { (result) in
                
                print("chat sent")
                if(result==true)
                {
                
                /*case .Success(let JSON):
                    //x[self.index] = JSON as! [String : AnyObject] // saving data
                    var statusNow="sent"
                    ///var chatmsg=JSON(data)
                    /// print(data[0])
                    ///print(chatmsg[0])
                    //  print("chat sent msg \(chatstanza)")
                    
                    sqliteDB.UpdateChatStatus(self.pendingchatsarray[self.index2]["uniqueid"]!, newstatus: "sent")
                 
                    
                    */
                completion(true)
                    self.index2 = self.index2 + 1
                    if self.index2 < self.pendinggroupchatsarray.count {
                        self.getGroupsData({ (result) -> () in})
                    }else {
                        completion(true)
                        /////////self.collectionView.reloadData()
                    }
                }
                //case .Failure(let error):
                else{
                    print("the error for \(self.pendinggroupchatsarray[self.index2]) ")
                    if self.index2 < self.pendinggroupchatsarray.count {
                        self.getGroupsData({ (result) -> () in})
                    }else {
                        completion(true)                /////////// self.collectionView.reloadData()
                    }
                }
            })
        }
        else{
            completion(false)
            
        }
    }
    
    /*func fetchChatsFromServer()
    {
        
        if(socketObj != nil)
        {
          //==--  socketObj.socket.emit("logClient","IPHONE LOG: \(username!) Fetching partial sync Chat")
        }

        let uniqueid = Expression<String>("uniqueid")
        let file_name = Expression<String>("file_name")
        let type = Expression<String>("type")
        let from = Expression<String>("from")
        let to = Expression<String>("to")
        
        let phone = Expression<String>("phone")
        
        let contactPhone = Expression<String>("contactPhone")
        let date = Expression<Date>("date")
        //contactPhone
        
        //%%%%%% fetch chat
        
        //dispatch_async(dispatch_get_global_queue(priority, 0)) {
        //self.progressBarDisplayer("Setting Conversations", true)
        print("\(username) is Fetching chat")
        socketObj.socket.emit("logClient","\(username) is Fetching chat")
        
        //===
        
        //===
        
        //var fetchChatURL=Constants.MainUrl+Constants.fetchMyAllchats
        
        var fetchChatURL=Constants.MainUrl+Constants.partialSync
        
        
        
        //var getUserDataURL=userDataUrl
        
        //  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND,0))
        //    {
        
        //QOS_CLASS_USER_INTERACTIVE
        let queue2 = DispatchQueue(label: "com.cnoon.manager-response-queue", attributes: DispatchQueue.Attributes.concurrent)
        let qqq=DispatchQueue.global(qos: DispatchQoS.QoSClass.background)
        
        let request = Alamofire.request("\(fetchChatURL)", method: .post, parameters: ["user1":username!],encoding:JSONEncoding.default,headers:header).responseData(queue: queue2) { response in
            
            
            /*.downloadProgress(queue: DispatchQueue.global(qos: .utility)) { progress in
                print("Progress: \(progress.fractionCompleted)")
            }
            .validate { request, response, data in
                // Custom evaluation closure now includes data (allows you to parse data to dig out error messages if necessary)
                return .success
            }
            .responseJSON { response in
                debugPrint(response)
                switch response.result {
                  */
        
        //alamofire4
        /////let request = Alamofire.request(.POST, "\(fetchChatURL)", parameters: ["user1":username!], headers:header)
        
        
        //alamofire4
        /*request.response(
            queue: queue2,
            responseSerializer: Request.JSONResponseSerializer(),
            completionHandler: { response in
                
                */
                // You are now running on the concurrent `queue` you created earlier.
                print("Parsing JSON on thread: \(Thread.current) is main thread: \(Thread.isMainThread)")
                
                // Validate your JSON response and convert into model objects if necessary
                //print(response)
                //print(response.result.value)
                
                
                switch response.result {
                case .success:
                    
                    print("All chat fetched success")
                    socketObj.socket.emit("logClient", "All chat fetched success")
                    print("response data \(response.data)")
                    
                    if let data1 = response.result.value {
                        print("data \(data1)")
                        let UserchatJson = JSON.init(data:data1)
                        print("chat fetched JSON: \(UserchatJson)")
                        
                        
                        //===========
                        //DONT DELETE ANYTHING
                        //============
                        
                        
                        /* var tableUserChatSQLite=sqliteDB.userschats
                         
                         do{
                         try sqliteDB.db.run(tableUserChatSQLite.filter(from != username!).delete())
                         }catch{
                         socketObj.socket.emit("logClient","sqlite chat table refreshed")
                         print("chat table not deleted")
                         }*/
                        
                        /*var tableUserChatSQLite=sqliteDB.userschats
                         
                         do{
                         try sqliteDB.db.run(tableUserChatSQLite.delete())
                         }catch{
                         socketObj.socket.emit("logClient","sqlite chat table refreshed")
                         print("chat table not deleted")
                         }*/
                        
                        //Overwrite sqlite db
                        //sqliteDB.deleteChat(self.selectedContact)
                        
                        socketObj.socket.emit("logClient","IPHONE-LOG: all chat messages count is \(UserchatJson["msg"].count)")
                        for var i in 0 ..< UserchatJson["msg"].count
                        {
                            
                            // var isFile=false
                            var chattype="chat"
                            var file_type=""
                            //UserchatJson["msg"][i]["date"].string!
                            
                            
                            
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                            
                            let datens2 = dateFormatter.date(from: UserchatJson["msg"][i]["date"].string!)
                            
                            print("fetch date from server got is \(UserchatJson["msg"][i]["date"].string!)... converted is \(datens2.debugDescription)")
                            
                            
                            print("===fetch chat date raw from server in chatview is \(UserchatJson["msg"][i]["date"].string!)")
                            
                            /*
                             let formatter = DateFormatter()
                             formatter.dateFormat = "MM/dd hh:mm a"";
                             // formatter.dateStyle = NSDateFormatterStyle.ShortStyle
                             //formatter.timeStyle = .ShortStyle
                             
                             let dateString = formatter.stringFromDate(datens2!)
                             */
                            
                            if(UserchatJson["msg"][i]["type"].exists())
                            {
                                chattype=UserchatJson["msg"][i]["type"].string!
                            }
                            
                            if(UserchatJson["msg"][i]["file_type"].exists())
                            {
                                file_type=UserchatJson["msg"][i]["file_type"].string!
                            }
                            
                            if(UserchatJson["msg"][i]["uniqueid"].exists())
                            {
                                
                            
                                
                                /* let tbl_files=sqliteDB.files;
                                 do{
                                 
                                 
                                 for tblFiles in try sqliteDB.db.prepare(tbl_files.filter(uniqueid==UserchatJson["msg"][i]["uniqueid"].string!/*,from==username!*/)){
                                 isFile=true
                                 chattype=tblFiles[type]
                                 
                                 print("File exists in file table \(file_name)")
                                 /////   socketObj.socket.emit("logClient","IPHONE LOG: \(username!) File exists in file table \(tblFiles[file_name])")
                                 
                                 
                                 /*print(tblContacts[to])
                                 print(tblContacts[from])
                                 print(tblContacts[msg])
                                 print(tblContacts[date])
                                 print(tblContacts[status])
                                 print("--------")
                                 */
                                 /*if(tblContacts[from]==selecteduser
                                 
                                 ){}*/
                                 }
                                 }
                                 catch
                                 {
                                 print("error in checking files table")
                                 }
                                 */
                                
                                if(UserchatJson["msg"][i]["to"].string! == username! && UserchatJson["msg"][i]["status"].string!=="sent")
                                {
                                    var updatedStatus="delivered"
                                    
                                    
                                   
                                    
                                    sqliteDB.SaveChat(UserchatJson["msg"][i]["to"].string!, from1: UserchatJson["msg"][i]["from"].string!,owneruser1:UserchatJson["msg"][i]["owneruser"].string! , fromFullName1: UserchatJson["msg"][i]["fromFullName"].string!, msg1: UserchatJson["msg"][i]["msg"].string!,date1:datens2,uniqueid1:UserchatJson["msg"][i]["uniqueid"].string!,status1: updatedStatus, type1: chattype, file_type1: file_type,file_path1: "" )
                                    
                                    //socketObj.socket.emit("messageStatusUpdate",["status":"","iniqueid":"","sender":""])
                                    
                                    
                                    
                                    //new added for file transfer
                                    if(UserchatJson["msg"][i]["type"].string! == "file")
                                    {
                                        managerFile.checkPendingFiles(UserchatJson["msg"][i]["uniqueid"].string!)

                                    }
                                    
                                   
                                    //==-- neww change managerFile.sendChatStatusUpdateMessage(UserchatJson["msg"][i]["uniqueid"].string!, status: updatedStatus, sender: UserchatJson["msg"][i]["from"].string!)
                                    
                                    
                                    //OLD SOCKET LOGIC
                                    /* socketObj.socket.emitWithAck("messageStatusUpdate", ["status":updatedStatus,"uniqueid":UserchatJson["msg"][i]["uniqueid"].string!,"sender": UserchatJson["msg"][i]["from"].string!])(timeoutAfter: 0){data in
                                     var chatmsg=JSON(data)
                                     print(data[0])
                                     print(chatmsg[0])
                                     print("chat status emitted")
                                     socketObj.socket.emit("logClient","\(username) chat status emitted")
                                     
                                     }*/
                                    
                                    
                                    
                                }
                                else
                                {
                                    
                                    sqliteDB.SaveChat(UserchatJson["msg"][i]["to"].string!, from1: UserchatJson["msg"][i]["from"].string!,owneruser1:UserchatJson["msg"][i]["owneruser"].string! , fromFullName1: UserchatJson["msg"][i]["fromFullName"].string!, msg1: UserchatJson["msg"][i]["msg"].string!,date1:datens2,uniqueid1:UserchatJson["msg"][i]["uniqueid"].string!,status1: UserchatJson["msg"][i]["status"].string!, type1: chattype, file_type1: file_type,file_path1: "" )
                                    
                                    if(UserchatJson["msg"][i]["type"].string! == "file")
                                    {
                                        managerFile.checkPendingFiles(UserchatJson["msg"][i]["uniqueid"].string!)
                                        
                                    }
                                    
                                }
                            }
                            else
                            {
                                sqliteDB.SaveChat(UserchatJson["msg"][i]["to"].string!, from1: UserchatJson["msg"][i]["from"].string!,owneruser1:UserchatJson["msg"][i]["owneruser"].string! , fromFullName1: UserchatJson["msg"][i]["fromFullName"].string!, msg1: UserchatJson["msg"][i]["msg"].string!,date1:datens2,uniqueid1:"",status1: "",type1: chattype, file_type1: file_type,file_path1: "" )
                                
                            }
                            
                        }
                        
                        
                        
                        /*  let tbl_userchats=sqliteDB.userschats
                         let tbl_contactslists=sqliteDB.contactslists
                         let tbl_allcontacts=sqliteDB.allcontacts
                         
                         let myquery=tbl_contactslists.join(tbl_userchats, on: tbl_contactslists[phone] == tbl_userchats[contactPhone]).group(tbl_userchats[contactPhone]).order(date.desc)
                         
                         var queryruncount=0
                         do{for ccc in try sqliteDB.db.prepare(myquery) {
                         
                         print("checking pending files from \(ccc[contactPhone])")
                         managerFile.checkPendingFiles(ccc[contactPhone])
                         
                         
                         }
                         }
                         catch{
                         print("error 1232")
                         }*/
                        /////// managerFile.checkPendingFiles(username!)
                        
                        //////// DispatchQueue.main.async {
                        
                        
                        
                        
                        //------CHECK IF ANY PENDING FILES--------
                        if(UserchatJson["msg"].count > 0)
                        {
                        DispatchQueue.main.async
                        {
                            if(UIDelegates.getInstance().delegateSingleChatDetails1 != nil)
                            {
                            UIDelegates.getInstance().UpdateSingleChatDetailDelegateCall()
                            }
                        if(delegateRefreshChat != nil)
                        {
                            print("informing UI to repfresh status")
                            delegateRefreshChat?.refreshChatsUI(nil, uniqueid:nil, from:nil, date1:nil, type:"status")
                        }
                        if(socketObj.delegateChat != nil)
                        {
                            socketObj.delegateChat?.socketReceivedMessageChat("updateUI", data: nil)
                        }
                        if(socketObj.delegate != nil)
                        {
                            socketObj.delegate?.socketReceivedMessage("updateUI", data: nil)
                        }
                        ///////// }
                        
                        }
}
                        print("all fetched chats saved in sqlite success")
                        
                        
                        
                    }
                    
                    
                /////return completion(result: true)
                case .failure:
                    socketObj.socket.emit("logClient", "All chat fetched failed")
                    print("all chat fetched failed")
                }
                // }
                
                
                // To update anything on the main thread, just jump back on like so.
                ///  DispatchQueue.main.async {
                ///      print("Am I back on the main thread: \(NSThread.isMainThread())")
                /// }
            }
        
    }
    */

  
    
    func sendPendingChatMessages(_ completion:(_ result:Bool)->())
    {
        print("checkin here inside pending chat messages.....")
        var userchats=sqliteDB.userschats
      //  var userchatsArray:Array<Row>
        
        
        
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
            for pendingchats in try sqliteDB.db.prepare((tbl_userchats?.filter(status=="pending"))!)
            {
                print("inside for loop")
                print("pending chats count in app delegate is \(count)")
                
                var date=NSDate()
                var formatterDateSend = DateFormatter();
                formatterDateSend.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ";
                ///newwwwwwww
                ////formatterDateSend.timeZone = NSTimeZone.local()
                let dateSentString = formatterDateSend.string(from: date as Date);
                
                
                var formatterDateSendtoDateType = DateFormatter();
                formatterDateSendtoDateType.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ";
                var dateSentDateType = formatterDateSendtoDateType.date(from: dateSentString)
                

                
                count += 1
                var imParas=["from":pendingchats[from],"to":pendingchats[to],"fromFullName":pendingchats[fromFullName],"msg":pendingchats[msg],"uniqueid":pendingchats[uniqueid],"type":pendingchats[type],"file_type":pendingchats[file_type],"date":"\(dateSentDateType!)"]
                
                print("imparas are \(imParas)")
                print(imParas, terminator: "")
                print("", terminator: "")
                
                //////// if(socketObj != nil){
                
                managerFile.sendChatMessage(imParas){ (result) -> () in
                    
                }
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
            
            for statusMessages in try sqliteDB.db.prepare(tbl_messageStatus!)
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
                //==--socketObj.socket.emit("logClient","IPHONE-LOG: \(username!) done sending pending chat messages")
            }
            
            return completion(true)
            //// return completion(result: true)
        }
        catch
        {
            print("error in pending chat fetching")
            if(socketObj != nil){
                socketObj.socket.emit("logClient","IPHONE-LOG: \(username!) error in sending pending chat messages")
            }
            
            return completion(false)
        }
        
        
    }
    
    
    func sendGroupChatMessage(_ group_id:String,from:String,type:String,msg:String,fromFullname:String,uniqueidChat:String,completion:@escaping (_ result:Bool)->())
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
        
        
     ////   print("sending groups chat \(group_id) , \(from) , \(type) \(msg), \(fromFullname) , \(uniqueidChat)")
        var url=Constants.MainUrl+Constants.sendGroupChat
        print(url)
        print("..")
        
        
         let request = Alamofire.request("\(url)", method: .post, parameters: ["group_unique_id":group_id,"from":from,"type":type,"msg":msg,"from_fullname":fromFullname,"unique_id":uniqueidChat],headers:header).responseJSON { response in
        /*
        let request = Alamofire.request(.POST, "\(url)", parameters: ["group_unique_id":group_id,"from":from,"type":type,"msg":msg,"from_fullname":fromFullname,"unique_id":uniqueidChat],headers:header).responseJSON { response in
            // You are now running on the concurrent `queue` you created earlier.
            //print("Parsing JSON on thread: \(NSThread.currentThread()) is main thread: \(NSThread.isMainThread())")
            
            // Validate your JSON response and convert into model objects if necessary
            //print(response.result.value) //status, uniqueid
            
            // To update anything on the main thread, just jump back on like so.
            //print("\(chatstanza) ..  \(response)")
            
            */
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
                
                
                
                
                
                
                
                /////    DispatchQueue.main.async {
                //print("Am I back on the main thread: \(NSThread.isMainThread())")
                
                print("MAINNNNNNNNNNNN")
                completion(true)
                //self.retrieveChatFromSqlite(self.selectedContact)
                
                
                
                
                /////// }
            }
            else{
                completion(false)
                
            }
        }//)
        
    }
    
    
    func sendPendingGroupChatMessages(_ completion:(_ result:Bool)->())
    {
        print("inside sending pending group chat messages.....")
        var userchats=sqliteDB.userschats
        //  var userchatsArray:Array<Row>
        
        
        
        let from = Expression<String>("from")
        let group_unique_id = Expression<String>("group_unique_id")
        let type = Expression<String>("type")
        let msg = Expression<String>("msg")
        let from_fullname = Expression<String>("from_fullname")
        let date = Expression<Date>("date")
        let unique_id = Expression<String>("unique_id")
        

        
        var pendingMSGs=sqliteDB.findGroupChatPendingMsgDetails()
        //var res=tbl_userchats.filter(to==selecteduser || from==selecteduser)
        //to==selecteduser || from==selecteduser
        //print("chat from sqlite is")
        //print(res)
        
            var count=0
        for i in 0 ..< pendingMSGs.count
            {
               var membersList=sqliteDB.getGroupMembersOfGroup(pendingMSGs[i]["group_unique_id"] as! String)
                
                pendinggroupchatsarray.append(pendingMSGs[i])
                
              /*  self.sendGroupChatMessage(pendingMSGs[i]["group_unique_id"] as! String, from: pendingMSGs[i]["from"] as! String, type: pendingMSGs[i]["type"] as! String, msg: pendingMSGs[i]["msg"] as! String, fromFullname: pendingMSGs[i]["from_fullname"] as! String, uniqueidChat: pendingMSGs[i]["unique_id"] as! String, completion: { (result) in
                    
                    print("chat sent")
                    if(result==true)
                    {
                        for(var i=0;i<membersList.count;i++)
                        {
                            if((membersList[i]["member_phone"] as! String) != username! && (membersList[i]["membership_status"] as! String) != "left")
                            {
                                sqliteDB.updateGroupChatStatus(pendingMSGs[i]["unique_id"] as! String, memberphone1: membersList[i]["member_phone"]! as! String, status1: "sent", delivereddate1: NSDate(), readDate1: NSDate())
                                
                                // === wrong sqliteDB.storeGRoupsChatStatus(uniqueid_chat, status1: "sent", memberphone1: self.membersList[i]["member_phone"]! as! String, delivereddate1: UtilityFunctions.init().minimumDate(), readDate1: UtilityFunctions.init().minimumDate())
                            }
                        }
                        
                        //==== sqliteDB.updateGroupChatStatus(uniqueid_chat, memberphone1: username!,status1: "sent", delivereddate1: UtilityFunctions.init().minimumDate(), readDate1: UtilityFunctions.init().minimumDate())
                        
                        UIDelegates.getInstance().UpdateGroupChatDetailsDelegateCall()
                        
                    }
                })*/
                
                
                
            }
        
        var tbl_groupStatusUpdatesTemp=sqliteDB.groupStatusUpdatesTemp
        let status = Expression<String>("status")
        let sender = Expression<String>("sender")
        let messageuniqueid = Expression<String>("messageuniqueid")
        
        do{
        for statusMessages in try sqliteDB.db.prepare(tbl_groupStatusUpdatesTemp!)
        {
            // if(socketObj != nil){
            
            self.sendGroupChatStatus(statusMessages[messageuniqueid], status1: statusMessages[status])
            
           
            }}
        catch{
            print("error in sending status updates to server")
        }
        
        completion(true)
        
    }
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
                
                
/*}

            }
            
            
        }*/
    

    
    func sendGroupChatStatus(_ chat_uniqueid:String,status1:String)
    {
        
        var url=Constants.MainUrl+Constants.updateGroupChatStatusAPI
        
        
        //--- dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0))
        //{
        
        let request=Alamofire.request("\(url)", method: .post, parameters: ["chat_unique_id":chat_uniqueid,"status":status1],headers:header).responseJSON { response in
            
            
                 if(response.response?.statusCode==200)
            {
                var resJSON=JSON(response.result.value!)
                print("status seen sent response \(resJSON)")
                //update locally
                //moving it out of function. if seen offline so remove chat bubble unread count
                
                sqliteDB.removeGroupStatusTemp(status1, memberphone1: username!, messageuniqueid1: chat_uniqueid)
                sqliteDB.updateGroupChatStatus(chat_uniqueid, memberphone1: username!, status1: status1, delivereddate1: NSDate() as Date!, readDate1: NSDate() as Date!)
            }
        }
    }
    
    func showError(_ title:String,message:String,button1:String) {
        
        // create the alert
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        // add the actions (buttons)
        alert.addAction(UIAlertAction(title: button1, style: UIAlertActionStyle.default, handler: nil))
        //alert.addAction(UIAlertAction(title: button2, style: UIAlertActionStyle.Cancel, handler: nil))
        
     let tabBarController = window?.rootViewController as? UITabBarController
        
      //  let navigationController = UIApplication.sharedApplication().windows[0].rootViewController as! UINavigationController
        
        // show the alert
        //=-- let activeViewCont = navigationController.visibleViewController
        
        self.window?.rootViewController?.present(alert, animated: true, completion: nil)
        
        
        //=--tabBarController!.presentViewController(alert, animated: true, completion: nil)
    }
    
    func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings) {
        print("didRegisterUserNotificationSettings")
        print("....234234  \(notificationSettings)")
        
     /*   let notificationTypes: UIUserNotificationType = [/*UIUserNotificationType.Alert, */UIUserNotificationType.Badge, UIUserNotificationType.Sound]
        
        //let notificationTypes: UIUserNotificationType = [UIUserNotificationType.None]
        
        
        let pushNotificationSettings = UIUserNotificationSettings(forTypes: notificationTypes, categories: nil)
        
         UIApplication.sharedApplication().registerUserNotificationSettings(pushNotificationSettings)
        */
     /*  if(UIApplication.sharedApplication().isRegisteredForRemoteNotifications())
        {
         let username1 = Expression<String>("username")
        let tbl_accounts = sqliteDB.accounts
        do{for account in try sqliteDB.db.prepare(tbl_accounts) {
            username=account[username1]
            //displayname=account[firstname]
            print("didRegisterUserNotificationSettings... inside...")
            
            UIApplication.sharedApplication().registerForRemoteNotifications()
            }
        }
        catch
        {
            if(socketObj != nil){
                socketObj.socket.emit("error getting data from accounts table in appdelegate")
            }
            print("error in getting data from accounts table.... \(error)")
            
        }

        }
        else
        {
           //==--self.showError("Error",message: "You must allow Remote notifications to continue",button1: "Ok")
}*/
       //if(!UIApplication.sharedApplication().isRegisteredForRemoteNotifications())
       // {
        if(username != nil && username != "")
{
        print("didRegisterUserNotificationSettings... inside...")
        
           ////==-- UIApplication.shared.registerForRemoteNotifications()
        }
 
        
    
    // }
        
    }
    func applicationWillResignActive(_ application: UIApplication) {
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
        
         UtilityFunctions.init().log_papertrail("IPHONE: \(username!) appwillresignactive")
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        print("didenterbackground")
        
        UtilityFunctions.init().log_papertrail("IPHONE: \(username!) app didenterbackground")
       
        
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
        
        ///!!
        if(socketObj != nil)
        {   //// socketObj.socket.close()
            socketObj.socket.disconnect()
            socketObj.socket.removeAllHandlers()
            ////// swiftt3 socketObj.socket.close()
            /////  socketObj=nil
        }
        
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        
        
        print("on willenterforeground app state is \(UIApplication.shared.applicationState.rawValue)")
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
            //DispatchQueue.main.async
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
        
       /*  if(socketObj == nil)
        {
            print("socket is nillll", terminator: "")
            socketObj=LoginAPI(url:"\(Constants.MainUrl)")
            ///socketObj.connect()
            socketObj.addHandlers()
            socketObj.addWebRTCHandlers()
        }*/
        
    }
    func handleIdentityChanged(notification: NSNotification){
        
        let fileManager = FileManager()
        
        if let token = fileManager.ubiquityIdentityToken{
            print("The new token is \(token)")
        } else {
            print("User has logged out of iCloud")
        }
        
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
       
        UtilityFunctions.init().log_papertrail("IPHONE: \(username!) app is active now")
        
        NotificationCenter.default.addObserver(self,
                                                         selector: "handleIdentityChanged:",
                                                         name: NSNotification.Name.NSUbiquityIdentityDidChange,
                                                         object: nil)
      //  self.messageFrame.removeFromSuperview()
        print("did become active app state is \(UIApplication.shared.applicationState.rawValue)")
        
        print("app launch variable is \(applaunch)")
        applaunch=true
        
        
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
        UIApplication.shared.applicationIconBadgeNumber=1;
        UIApplication.shared.applicationIconBadgeNumber=0;

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
        
       // print("socket status iss \(socketObj.socket.status)")
       /// if(socketObj.socket.status == SocketIOClientStatus.disconnected) //.closed
      ///  {
         //   print("opening socket")
        
        //!!
            if(username != nil && username != "")
            {
                //commenting for testing
                
                var syncservice=syncService.init()
                syncservice.startUpwardSyncService({ (result, error) in
                    
                    print("upward sync donee")
                    
                    syncservice.startDownwardSync({ (result2, error2) in
                        
                       
                            
                            DispatchQueue.main.async
                                {print("pendingGroupIcons refreshing page")
                                    UIDelegates.getInstance().UpdateMainPageChatsDelegateCall()
                                    UIDelegates.getInstance().UpdateSingleChatDetailDelegateCall()
                                    UIDelegates.getInstance().UpdateGroupChatDetailsDelegateCall()                            }
                        
                        
                    })
                    
                })
                
 
                
                
                
                
               /* var syncservice=syncService.init()
                syncservice.startUpwardSyncService({ (result, error) in
                    
                    print("upward sync donee")
                        
                        DispatchQueue.main.async
                            {print("pendingGroupIcons refreshing page")
                                
                                UIDelegates.getInstance().UpdateMainPageChatsDelegateCall()
                                UIDelegates.getInstance().UpdateSingleChatDetailDelegateCall()
                                UIDelegates.getInstance().UpdateGroupChatDetailsDelegateCall()
                                //self.tblForChat.reloadData()
                        }
                   
                })*/
                /*var syncGroupsObj=syncGroupService.init()
                syncGroupsObj.startPartialGroupsChatSyncService()
                self.synchroniseChatData()
                print("getting group messages which are not on device")
 
                */
            }
        
        
        //!!!
            /*socketObj=nil
            socketObj=LoginAPI(url:"\(Constants.MainUrl)")
            ///socketObj.connect()
            socketObj.addHandlers()
            socketObj.addWebRTCHandlers()
 */
            
          //  socketObj.socket.connect()
           // socketObj.socket.open()
      ////  }
        
        if(socketObj == nil)
        {
          print("resign active when socket for nil")
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
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
       
         UtilityFunctions.init().log_papertrail("IPHONE: \(username!) app will terminate")
        
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
                        
                        //self.dismiss(true, completion: nil);
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
    
    
     var retrycount=0
     func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("trying to register device token")
        
       /* let username1 = Expression<String>("username")
        let tbl_accounts = sqliteDB.accounts
        do{for account in try sqliteDB.db.prepare(tbl_accounts) {
           */
            
     if(username != nil && username != ""){
        print("inside didRegisterForRemoteNotificationsWithDeviceToken username is \(username!) ")
        let hub=SBNotificationHub(connectionString: Constants.connectionstring, notificationHubPath: Constants.hubname) //from constants file
        var tagarray=[String]()
        tagarray.append(username!.substring(from: username!.characters.index(after: username!.startIndex)))
        tagarray.append("newuser")
        
        print(username!.substring(from: username!.characters.index(after: username!.startIndex)))
       // var tagname=NSSet(object: username!.substringFromIndex(username!.startIndex))
        let tagname=NSSet(array: tagarray)
       // hub.registerNativeWithDeviceToken(deviceToken, tags: tagname as Set<NSObject>) { (error) in
        hub?.registerNative(withDeviceToken: deviceToken, tags: tagname as Set<NSObject>) { (error) in
        //hub.registerNativeWithDeviceToken(deviceToken, tags: nil) { (error) in
            
        if(error != nil)
            {
                print("Registering for notifications \(error)")
                ///UtilityFunctions.init().log_papertrail("Registering for notifications \(error)")
                //retry
                /////===-------UIApplication.shared.registerForRemoteNotifications()
                //==--UIApplication.sharedApplication().registerUserNotificationSettings(pushNotificationSettings)

            }
            else
            {///UtilityFunctions.init().log_papertrail("Successfully registered for notifications")
                print("Successfully registered for notifications")

            }
            
        }
       }
        /*}
        catch{
            
        }*/
    }
    
    
    /*
     received while the app is active:
     
     Copy
     - (void)application:(UIApplication *)application didReceiveRemoteNotification: (NSDictionary *)userInfo {
     NSLog(@"%@", userInfo);
     [self MessageBox:@"Notification" message:[[userInfo objectForKey:@"aps"] valueForKey:@"alert"]];
     }
 */
    

    /*func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        
        let systemSoundID: SystemSoundID = 1016
        
        // to play sound
        AudioServicesPlaySystemSound (systemSoundID)
        print("hereeeeeeeeeeee")
    }*/
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        
     
       // else{
    
        /*if(socketObj == nil)
        {
                  UtilityFunctions.init().log_papertrail("IPHONE:  \(username!) socketObj is nil is connecting socket")
            
            print("socket is nillll", terminator: "")
            socketObj=LoginAPI(url:"\(Constants.MainUrl)")
            ///socketObj.connect()
            socketObj.addHandlers()
            socketObj.addWebRTCHandlers()
            socketObj.addDesktopAppHandlers()
            
        }
        else{
            if(socketObj.socket==nil)
            {
                
                UtilityFunctions.init().log_papertrail("IPHONE:  \(username!) socket is  nill ")
            }
            else{
                
           
              UtilityFunctions.init().log_papertrail("IPHONE:  \(username!) socket is not nill status is \(socketObj.socket.status)")
                if(socketObj.socket.status == SocketIOClientStatus.disconnected)
                {
                    //socketObj.socket.close
                socketObj=LoginAPI(url:"\(Constants.MainUrl)")
                ///socketObj.connect()
                socketObj.addHandlers()
                socketObj.addWebRTCHandlers()
                    socketObj.addDesktopAppHandlers()
                }
            }
        }*/
        
            UtilityFunctions.init().getAppState(currentState: UIApplication.shared.applicationState.rawValue)
            UtilityFunctions.init().log_papertrail("IPHONE: receivednotification(old) iOS9 \(userInfo)")
            
        if(UIApplication.shared.applicationState.rawValue != UIApplicationState.inactive.rawValue )
        {
           UtilityFunctions.init().log_papertrail("IPHONE: \(username!) iOS 9+ receivednotification method called mode not inactive \(UIApplication.shared.applicationState.rawValue) \(userInfo) ")
            /*Alamofire.request("https://api.cloudkibo.com/api/users/log", method: .post, parameters: ["data":"IPHONE_LOG: \(username!) received push notification in mode value \(UIApplication.shared.applicationState.rawValue) as \(userInfo.description)"],headers:header).response{
                response in
                print(response.error)
            }*/
        
/*
         
        Alamofire.request(.POST,"https://api.cloudkibo.com/api/users/log",headers:header,parameters: ["data":"IPHONE_LOG: \(username!) received push notification as \(userInfo.description)"]).response{
            request, response_, data, error in
            print(error)
        }
 */
        

      ////////  if (application.applicationState != UIApplicationState.Background) {
       // NSLog("received remote notification \(userInfo)")
       /* if(socketObj != nil)
        {
             socketObj.socket.emit("logClient","\(username) didReceiveRemoteNotification: ..... \(userInfo["userInfo"]).....\(userInfo.description)")
         //   print(userInfo["userInfo"])
         
        }*/
        
  
 
        if  let singleuniqueid = userInfo["uniqueId"] as? String {
            // Printout of (userInfo["aps"])["type"]
            print("\nFrom APS-dictionary with key \"singleuniqueid\":  \( singleuniqueid)")
             if  let notifType = userInfo["type"] as? String {
                print("payload of satus or iOS chat")
                if(notifType=="status")
                {
                    updateMessageStatus(singleuniqueid, status: (userInfo["status"] as? String)!)
                    print("calling completion handler for status update now")
                   
                    /*
                     else if (payload.getString("type").equals("message_status")) {
                     
                     JSONObject row = payload.getJSONObject("data");
                     
                     sendMessageStatusUsingAPI(row.getString("status"),
                     row.getString("uniqueid"), row.getString("sender")); //this is when desktop sends to us
 */
                    
                    var dataForDesktopApp=["uniqueid":singleuniqueid,"status":userInfo["status"] as? String]
                    UtilityFunctions.init().sendDataToDesktopApp(data1: dataForDesktopApp as AnyObject, type1: "message_status")
                    
                    UIDelegates.getInstance().UpdateSingleChatDetailDelegateCall()
                    UIDelegates.getInstance().UpdateMainPageChatsDelegateCall()
                    completionHandler(UIBackgroundFetchResult.newData)

                    //completionHandler(UIBackgroundFetchResult.newData)
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "ReceivedNotification"), object:userInfo)
                    
                }
                else
                {/*
 group:you_are_added
 */
                    
                    if(notifType=="chat" || notifType=="file" || notifType=="broadcast_file" || notifType=="contact" || notifType=="location" || notifType=="link" || notifType=="log")
                   
                    {print("payload of iOS chat")
                    fetchSingleChatMessage(singleuniqueid)
                     print("calling completion handler for fetch chat now")
                        UIDelegates.getInstance().UpdateSingleChatDetailDelegateCall()
                        UIDelegates.getInstance().UpdateMainPageChatsDelegateCall()
                        completionHandler(UIBackgroundFetchResult.newData)

                   // completionHandler(UIBackgroundFetchResult.newData)
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "ReceivedNotification"), object:userInfo)
                    }
                    
                    else
                    {
                        if(notifType=="group:msg_status_changed")
                            
                        {print("inside here updating status")
                            //change message status
                            //status : 'delivered',
                            //uniqueId : req.body.unique_id
                            var uniqueId=userInfo["uniqueId"] as! String
                            var status=userInfo["status"] as! String
                            var user_phone=userInfo["user_phone"] as? String
                            
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                            var delivered_date=Date()
                            var read_date=Date()
                           
                            
                            
                            /* if(status == "delivered")
                            {
                                var delivered_dateString=userInfo["delivered_date"] as! String
                               delivered_date = dateFormatter.date(from:delivered_dateString)!
                                
                                
                            }
                            else
                            {
                            var read_dateString=userInfo["read_date"] as! String
                                read_date = dateFormatter.date(from:read_dateString)!
                                

                            }
                            
                            */
                            
                            if(user_phone == nil)
                            {
                            user_phone=""
                            }
                            sqliteDB.updateGroupChatStatus(uniqueId,memberphone1: user_phone!,status1: status, delivereddate1: delivered_date, readDate1: read_date)
                            UIDelegates.getInstance().UpdateMainPageChatsDelegateCall()
                            UIDelegates.getInstance().UpdateGroupChatDetailsDelegateCall()
                            UIDelegates.getInstance().UpdateGroupInfoDetailsDelegateCall()
                            
                        }
                        else{
                            
                            if(notifType=="block:blockedyou")
                                
                            {print("inside i am blocked")
                                //change message status
                                //status : 'delivered',
                                //uniqueId : req.body.unique_id
                                var phone=userInfo["phone"] as! String
                                sqliteDB.IamBlockedUpdateStatus(phone1: phone, status1: true)
                                UIDelegates.getInstance().UpdateSingleChatDetailDelegateCall()
                                                               UIDelegates.getInstance().UpdateMainPageChatsDelegateCall()
                                completionHandler(UIBackgroundFetchResult.newData)

                            }
                            else{
                                
                                if(notifType=="block:unblockedyou")
                                    
                                {print("inside i am unblocked")
                                    //change message status
                                    //status : 'delivered',
                                    //uniqueId : req.body.unique_id
                                    var phone=userInfo["phone"] as! String
                                    sqliteDB.IamBlockedUpdateStatus(phone1: phone, status1: false)
                                }
                        }
                                           }
                }
                
                   /* else
                    {
                        if(notifType=="group:you_are_added")
                        {
                            
                            //you are added to group
                         /*   Body: group_unique_id = <group_unique_id>, members = [‘+9233232900920’, ‘+9432233919233’, ....]
                            Push notification will be sent to other members of group:
                            var payload = {
                                type : 'group:you_are_added',
                                senderId : ‘<admin phone number>’,
                                groupId : ‘<unique id of group>’,
                                isAdmin: 'No',
                                membership_status : 'joined',
                                group_name: ‘<name of the group>’,
                                badge : <ignore this field>
                            };
*/
                        }
                    }

                }*/
            
             }
             }
            else
             {
                print("rwong payload without type field")
                
                /*
                //==
                // this is from android
                //==
                
                 fetchSingleChatMessage(singleuniqueid)
                
                */
                completionHandler(UIBackgroundFetchResult.newData)
                NotificationCenter.default.post(name: Notification.Name(rawValue: "ReceivedNotification"), object:userInfo)
                
                
            }
            
            // Do your stuff?
        

        }
        
        else
        {
            //handle Group Push here
            //you are added to group
            /* Body: group_unique_id = <group_unique_id>, members = [‘+9233232900920’, ‘+9432233919233’, ....]
             Push notification will be sent to other members of group:
             var payload = {
             type : 'group:you_are_added',
             senderId : ‘<admin phone number>’,
             groupId : ‘<unique id of group>’,
             isAdmin: 'No',
             membership_status : 'joined',
             group_name: ‘<name of the group>’,
             badge : <ignore this field>
             };
             *?
             }
             }
             
             }*/
            if  let type = userInfo["type"] as? String {
                print(userInfo)
                // Printout of (userInfo["aps"])["type"]
                print("group push unique_id is \( type)")
               // if  let notifType = userInfo["type"] as? String {
                    
                    if(type=="group:you_are_added")
                    {
                        var senderid = userInfo["senderId"] as! String
                        var groupId = userInfo["groupId"] as? String
                        var isAdmin = userInfo["isAdmin"] as! String
                        var membership_status = userInfo["membership_status"] as! String
                        var group_name = userInfo["group_name"] as! String
                       DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.background).async {
                        self.fetchSingleGroup(groupId!, completion: { (result, error) in
                            
                            self.fetchGroupMembersSpecificGroup(groupId!,completion: { (result, error) in
                                
                                sqliteDB.storeGroupsChat("Log:", group_unique_id1: groupId!, type1: "log", msg1: "You are added by \(senderid)", from_fullname1: "", date1: Date(), unique_id1:UtilityFunctions.init().generateUniqueid())
                                UIDelegates.getInstance().UpdateMainPageChatsDelegateCall()
                                UIDelegates.getInstance().UpdateGroupInfoDetailsDelegateCall()
                                
                              completionHandler(UIBackgroundFetchResult.newData)
                            })
                            
                        })
                        }
                        /* dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)) {
                            print("synccccc fetching contacts in background...")
                            {
                        self.fetchSingleGroup(groupId, completion: { (result, error) in
                            
                            print("group fetched now fetch members")
                        
                        })}}*/
                           
                }
                //group:name_update
                //group:role_updated
                if(type=="group:name_update")
                {
                    var senderId=userInfo["senderId"] as! String  //from
                    var groupId=userInfo["groupId"] as! String
                    var new_name=userInfo["new_name"] as! String
                    sqliteDB.updateGroupname(groupid:groupId,newname:new_name)
                    
                    var uniqueid1=UtilityFunctions.init().generateUniqueid()
                     sqliteDB.storeGroupsChat("Log:", group_unique_id1: groupId, type1: "log", msg1: "\(senderId) changed the subject to \(new_name)", from_fullname1: "", date1: Date(), unique_id1: uniqueid1)
                    
                    
                    

                    
                }
                if(type=="group:role_updated")
                {
                    /*type : 'group:role_updated',
                    senderId : req.user.phone,
                    personUpdated : req.body.member_phone,
                    groupId : req.body.group_unique_id,
                    isAdmin: req.body.makeAdmin,
                    badge : dataUser.iOS_badge
                    
                    */
                    var senderId=userInfo["senderId"] as! String  //from
                    var groupId=userInfo["groupId"] as! String
                    var isAdmin=userInfo["isAdmin"] as! String
                    var personUpdated=userInfo["personUpdated"] as! String
                    
                    var uniqueid1=UtilityFunctions.init().generateUniqueid()
                    sqliteDB.changeRole(groupId, member1: personUpdated, isAdmin1: isAdmin)
                    //sqliteDB.updateMembershipStatus(groupId,memberphone1: senderId, membership_status1: "left")
                    sqliteDB.storeGroupsChat("Log:", group_unique_id1: groupId, type1: "log", msg1: "\(senderId) has made \(personUpdated) as group admin", from_fullname1: "", date1: Date(), unique_id1: uniqueid1)
                    ///////  sqliteDB.removeMember(groupId!,member_phone1: senderId!)
                    /*if(delegateRefreshChat != nil)
                     {
                     print("refresh UI after member leaves")
                     delegateRefreshChat?.refreshChatsUI(nil, uniqueid:nil, from:nil, date1:nil, type:"status")
                     }*/
                    UIDelegates.getInstance().UpdateSingleChatDetailDelegateCall()
                    UIDelegates.getInstance().UpdateMainPageChatsDelegateCall()
                    UIDelegates.getInstance().UpdateGroupInfoDetailsDelegateCall()
                    UIDelegates.getInstance().UpdateGroupChatDetailsDelegateCall()
                    
                    completionHandler(UIBackgroundFetchResult.newData)

                    
                }
                if(type=="group:chat_received")
                {
                    
                  
                     var senderId=userInfo["senderId"] as? String  //from
                     var groupId=userInfo["groupId"] as? String
                     var msg_type=userInfo["msg_type"] as? String
                     var unique_id=userInfo["unique_id"] as? String
                    
                    self.fetchSingleGroupChatMessage(unique_id!,completion: {(result,error) in
                        
                        UIDelegates.getInstance().UpdateGroupChatDetailsDelegateCall()
                        UIDelegates.getInstance().UpdateMainPageChatsDelegateCall()
                        UIDelegates.getInstance().UpdateGroupInfoDetailsDelegateCall()
               
                    })
                   
                             completionHandler(UIBackgroundFetchResult.newData)
                    

                }
                
                
              
                
                if(type=="group:member_left_group")
                {
                    var senderId=userInfo["senderId"] as! String  //from
                    var groupId=userInfo["groupId"] as! String
                    var isAdmin=userInfo["isAdmin"] as! String
                    var membership_status=userInfo["membership_status"] as! String
           
                    var uniqueid1=UtilityFunctions.init().generateUniqueid()
                    
                    sqliteDB.updateMembershipStatus(groupId,memberphone1: senderId, membership_status1: "left")
                    sqliteDB.storeGroupsChat("Log:", group_unique_id1: groupId, type1: "log", msg1: "\(senderId) has left this group", from_fullname1: "", date1: Date(), unique_id1: uniqueid1)
                    ///////  sqliteDB.removeMember(groupId!,member_phone1: senderId!)
                    /*if(delegateRefreshChat != nil)
                    {
                        print("refresh UI after member leaves")
                        delegateRefreshChat?.refreshChatsUI(nil, uniqueid:nil, from:nil, date1:nil, type:"status")
                    }*/
                    UIDelegates.getInstance().UpdateSingleChatDetailDelegateCall()
                    UIDelegates.getInstance().UpdateMainPageChatsDelegateCall()
                    UIDelegates.getInstance().UpdateGroupInfoDetailsDelegateCall()
                    UIDelegates.getInstance().UpdateGroupChatDetailsDelegateCall()
                    
                    completionHandler(UIBackgroundFetchResult.newData)

                    //updateUI
                    
                }
                //removed_from_group
                if(type=="group:removed_from_group")
                {
                    var senderId=userInfo["senderId"] as! String
                    var isAdmin=userInfo["isAdmin"] as! String
                    var membership_status=userInfo["membership_status"] as! String
                    var personRemoved=userInfo["personRemoved"] as! String
                    var groupId=userInfo["groupId"] as! String
                    
                    var uniqueid1=UtilityFunctions.init().generateUniqueid()
                    
                    sqliteDB.updateMembershipStatus(groupId,memberphone1: personRemoved, membership_status1: "left")
                    
                    if(personRemoved == username!)
{
   sqliteDB.storeGroupsChat("Log:", group_unique_id1: groupId, type1: "log", msg1: "\(senderId) removed you", from_fullname1: "", date1: Date(), unique_id1: uniqueid1)
}
else{
                    sqliteDB.storeGroupsChat("Log:", group_unique_id1: groupId, type1: "log", msg1: "\(personRemoved) is removed from this group", from_fullname1: "", date1: Date(), unique_id1: uniqueid1)
                    }
                    ///////  sqliteDB.removeMember(groupId!,member_phone1: senderId!)
                   /* if(delegateRefreshChat != nil)
                    {
                        print("refresh UI after member leaves")
                        delegateRefreshChat?.refreshChatsUI(nil, uniqueid:nil, from:nil, date1:nil, type:"status")
                    }*/
                    UIDelegates.getInstance().UpdateSingleChatDetailDelegateCall()
                    UIDelegates.getInstance().UpdateMainPageChatsDelegateCall()
                    UIDelegates.getInstance().UpdateGroupInfoDetailsDelegateCall()
                    UIDelegates.getInstance().UpdateGroupChatDetailsDelegateCall()
                    
                    completionHandler(UIBackgroundFetchResult.newData)
                    
                    /*
                     [senderId: +923201211991, badge: 0, aps: {
                     }, isAdmin: No, membership_status: left, type: group:removed_from_group, personRemoved: +923323800399, groupId: cFBhfRu201611116656]
                     [senderId: +923201211991, badge: 0, aps: {
                     }, isAdmin: No, membership_status: left, type: group:removed_from_group, personRemoved: +923323800399, groupId: cFBhfRu201611116656]

 */
                }
                
                if(type=="group:icon_update")
                {
                    print("group icon is changed \(userInfo["groupId"] as! String)")
                    var groupId=userInfo["groupId"] as! String
                    var senderId=userInfo["senderId"] as! String
                    
                    print("group icon changed of: \(sqliteDB.getSingleGroupInfo(userInfo["groupId"] as! String))")
                    //"exists".dataUsingEncoding(NSUTF8StringEncoding)!
                    sqliteDB.storeGroupsChat("Log:", group_unique_id1: groupId, type1: "log", msg1: "\(senderId) has changed the group icon".localized, from_fullname1: "", date1:NSDate() as Date , unique_id1: groupId)
                  
                    
                    UtilityFunctions.init().downloadProfileImage(groupId)
                }
                
                if(type=="syncUpward")
                {
                    
                    UtilityFunctions.init().log_papertrail("IPHONE: UPWARD SYNC PUSH \(userInfo) ... PAYLOAD: \(userInfo["payload"])")
                    var sub_type = userInfo["sub_type"] as! String
                    
                    if(sub_type=="unsentMessages")
                    {
                       if let payload=userInfo["payload"] as? [AnyHashable : Any]
                       {
                       var uniqueid=payload["uniqueid"] as! String
                       var status=payload["status"] as! String
                    
                        sqliteDB.UpdateChatStatus(uniqueid, newstatus: status)
                        
                        UIDelegates.getInstance().UpdateMainPageChatsDelegateCall()
                        UIDelegates.getInstance().UpdateGroupInfoDetailsDelegateCall()
                        UIDelegates.getInstance().UpdateGroupChatDetailsDelegateCall()
                        
                        completionHandler(UIBackgroundFetchResult.newData)
                    }

                    }
                    if(sub_type=="unsentGroupMessages")
                    {
                         UtilityFunctions.init().log_papertrail("IPHONE: UPWARD SYNC PUSH \(userInfo) ... PAYLOAD: \(userInfo["payload"])")
                        print("push got group chat \(userInfo)")
                        
                        if let payload=userInfo["payload"] as? [AnyHashable : Any]
                        {
                        var uniqueid=payload["unique_id"] as! String
                       
                        
                        let msg_unique_id = Expression<String>("msg_unique_id")
                        let Status = Expression<String>("Status")
                        let user_phone = Expression<String>("user_phone")
                        
                        let read_date = Expression<Date>("read_date")
                        let delivered_date = Expression<Date>("delivered_date")
                        
                        
                        
                        sqliteDB.group_chat_status = Table("group_chat_status")
                        
                        let query = sqliteDB.group_chat_status.select(Status).filter(msg_unique_id == uniqueid)
                        do
                        {let row=try sqliteDB.db.run(query.update(Status <- "sent"))
                            UIDelegates.getInstance().UpdateMainPageChatsDelegateCall()
                            UIDelegates.getInstance().UpdateGroupChatDetailsDelegateCall()
                            
                           UIDelegates.getInstance().UpdateGroupInfoDetailsDelegateCall()
                            completionHandler(UIBackgroundFetchResult.newData)

                        }
                        catch{
                            
                        }
                        
                    }

                    }
                    //unsentChatMessageStatus
                    //unsentGroupChatMessageStatus
                    //unsentGroups
                    //unsentAddedGroupMembers
                    //unsentRemovedGroupMembers
                    //statusOfSentMessages
                    //statusOfSentGroupMessages
                    if(sub_type=="unsentChatMessageStatus")
                    {
                        if let payload=userInfo["payload"] as? [AnyHashable : Any]
                        {if(payload.count>0)
                        {
var uniqueid=payload["uniqueid"] as! String
                        sqliteDB.removeMessageStatusSeen(uniqueid)
                            UIDelegates.getInstance().UpdateGroupChatDetailsDelegateCall()
                            UIDelegates.getInstance().UpdateMainPageChatsDelegateCall()
                            UIDelegates.getInstance().UpdateGroupInfoDetailsDelegateCall()
                            completionHandler(UIBackgroundFetchResult.newData)

                        }
                    }
                    }
                    
                    if(sub_type=="unsentGroupChatMessageStatus")
                    {
                        if let payload=userInfo["payload"] as? [AnyHashable : Any]
                        {if(payload.count>0)
                        {

                            var chat_uniqueid=payload["chat_uniqueid"] as! String
                        var status=payload["status"] as! String
                        
 sqliteDB.removeGroupStatusTemp(status, memberphone1: username!, messageuniqueid1: chat_uniqueid)
 sqliteDB.updateGroupChatStatus(chat_uniqueid, memberphone1: username!, status1: status, delivereddate1: NSDate() as Date!, readDate1: NSDate() as Date!)
                            UIDelegates.getInstance().UpdateGroupChatDetailsDelegateCall()
                            UIDelegates.getInstance().UpdateMainPageChatsDelegateCall()
                            UIDelegates.getInstance().UpdateGroupInfoDetailsDelegateCall()
                            completionHandler(UIBackgroundFetchResult.newData)

                        }
                    }
                    }
                    if(sub_type=="unsentGroups")
                    {
                        
                    }
                    
                    if(sub_type=="unsentAddedGroupMembers")
                    {
                        
                    }
                    
                    if(sub_type=="unsentRemovedGroupMembers")
                    {
                        
                    }
                    
                    if(sub_type=="statusOfSentMessages")
                    {
                        //"uniqueid":"3fc8d6548c22c3341172114344","status":"delivered
                        
                        if let payload=userInfo["payload"] as? [AnyHashable : Any]
                        {
                        if(payload.count>0)
                        {
                        var uniqueid=payload["uniqueid"] as! String
                            var status=payload["status"] as! String
                            
                            sqliteDB.UpdateChatStatus(uniqueid, newstatus: status)
                            UIDelegates.getInstance().UpdateGroupChatDetailsDelegateCall()
                            UIDelegates.getInstance().UpdateMainPageChatsDelegateCall()
                            UIDelegates.getInstance().UpdateGroupInfoDetailsDelegateCall()
                            completionHandler(UIBackgroundFetchResult.newData)

                        }
                    }
                    }
                    
                    if(sub_type=="statusOfSentGroupMessages")
                    {
                       UtilityFunctions.init().log_papertrail("IPHONE: UPWARD SYNC PUSH \(userInfo) ... PAYLOAD: \(userInfo["payload"])")
                        print("statusOfSentGroupMessages")
                        
                        
                        if let payload=userInfo["payload"] as? [AnyHashable : Any]
                        {
                            if(payload.count>0)
                            {
                                
                                var chat_unique_id=payload["chat_unique_id"] as! String
                                var user_phone=payload["user_phone"] as! String
                                var read_date=payload["read_date"] as! String
                                var delivered_date=payload["delivered_date"] as! String
                                var status=payload["status"] as! String
                                
                                for var i in 0 ..< payload.count
                                {
                                    var uniqueid1=chat_unique_id
                                    var user_phone1=user_phone
                                    var read_dateString=read_date
                                    
                                    var delivered_dateString=delivered_date
                                    var status1=status
                                    
                                    let dateFormatter = DateFormatter()
                                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                                    
                                    let delivered_date = dateFormatter.date(from: delivered_dateString)
                                    let read_date = dateFormatter.date(from:read_dateString)
                                    
                                    print("updating status ......... \(i)")
                                    sqliteDB.updateGroupChatStatus(uniqueid1, memberphone1: user_phone1, status1: status1, delivereddate1: delivered_date, readDate1: read_date)
                                }
                            }
                            UIDelegates.getInstance().UpdateGroupChatDetailsDelegateCall()
                            UIDelegates.getInstance().UpdateMainPageChatsDelegateCall()
                            UIDelegates.getInstance().UpdateGroupInfoDetailsDelegateCall()
                            completionHandler(UIBackgroundFetchResult.newData)

                        }
                       

                    }
                }
                if(type=="new_user")
                {
                    UtilityFunctions.init().log_papertrail("IPHONE: new user found PAYLOAD: \(userInfo["payload"])")
                    var userobj = userInfo["user"] as! JSON
                    var newuserphone=userobj["phone"].string!
                    var addressbookname=sqliteDB.getNameFromAddressbook(newuserphone)
                    if(addressbookname != nil)
                    {
                        // in addressbook
                        sqliteDB.updateKiboStatusInAddressbook(newuserphone)
                    }
                    /*
                    self.country_prefix<-json["country_prefix"].string!,
                    self.nationalNumber<-json["national_number"].string!,
                    //lastname<-"",
                    //lastname<-json["lastname"].string!,
                    //email<-json["email"].string!,
                    self.username1<-json["phone"].string!,
                    self.status<-json["status"].string!,
                    self.phone<-json["phone"].string!))!)
 
                     */
                    
                }

                
                //}
            }
            
            
            
            
            
            
            
            
        }
    }
        else
        {
            
            var stateApp=UtilityFunctions.init().getAppState(currentState: UIApplication.shared.applicationState.rawValue)
            UtilityFunctions.init().log_papertrail("IPHONE: \(username!) app in \(stateApp) state received push iOS9 but will not preocess ----- \(userInfo)")
            
          /*  Alamofire.request(.POST,"https://api.cloudkibo.com/api/users/log",headers:header,parameters: ["data":"IPHONE_LOG: \(username!) received push notification when in inactive mode so nothing will be processed \(userInfo.description)"]).response{
                request, response_, data, error in
                print(error)
            }*/
        }
      //  }
       /////// print("remote notification received is \(userInfo)")
        /*var notificationJSON=JSON(userInfo)
        print("json converted is \(notificationJSON)")
        print("json received is is \(notificationJSON["aps"])")
        */
      /////////////--------  completionHandler(UIBackgroundFetchResult.NewData)
      ////////////////----------------  NSNotificationCenter.defaultCenter().postNotificationName("ReceivedNotification", object:userInfo)
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
    
  
    func updateAllUIScreensForGroupChat()
    {
       UIDelegates.getInstance().UpdateMainPageChatsDelegateCall()
        UIDelegates.getInstance().UpdateGroupChatDetailsDelegateCall()
        UIDelegates.getInstance().UpdateGroupInfoDetailsDelegateCall()
        
    }
    
    func fetchGroupMembersSpecificGroup(_ unique_id:String,completion:@escaping (_ result:Bool,_ error:String?)->())
    {
        print("uniqueid of grup fetching member is \(unique_id)")
        
        //======GETTING REST API TO GET SPECIFIC GROUP==================
        
        // print("inside fetch single chat")
        if(accountKit == nil){
            accountKit = AKFAccountKit(responseType: AKFResponseType.accessToken)
        }
        
        if (accountKit!.currentAccessToken == nil) {
            
            
            accountKit = AKFAccountKit(responseType: AKFResponseType.accessToken)
            accountKit.requestAccount{
                (account, error) -> Void in
                
                
                if(account != nil){
                    //  var url=Constants.MainUrl+Constants.getContactsList
                    
                    let header:[String:String]=["kibo-token":(accountKit!.currentAccessToken!.tokenString)]
                    
                }
                
            }
        }
        var fetchSingleMsgURL=Constants.MainUrl+Constants.fetchGroupMembersSpecificGroup
        
        
        //var getUserDataURL=userDataUrl
        
        let request = Alamofire.request("\(fetchSingleMsgURL)", method: .post,parameters: ["unique_id":unique_id],headers:header).validate().responseJSON { (responseData) -> Void in
            //if((responseData.result.value) != nil) {
                           
           /* if let statusesArray = try? JSONSerialization.jsonObject(with: responseData.data!, options: .allowFragments) as? [[String: Any]],
                    let user = statusesArray?[0]["user"] as? [String: Any],
                    let username = user["name"] as? String {
            
                    // Finally we got the username
                }
                */
                
                //swiftyJsonVar.
                //print(swiftyJsonVar.)
                
                
            //.responseJSON { response in
            
            //alamofire4
        ////Alamofire.request(.POST,"\(fetchSingleMsgURL)",parameters: ["unique_id":unique_id],headers:header).validate(statusCode: 200..<300).responseJSON{response in
            
            //print("members fetched response \(response.description)")
            //var membersDataNew=JSON(response.response!.description)
           // print("membersDataNew count is \(membersDataNew.count) and JSON data is : \(membersDataNew)")
           // print("response code is \(response.response?.statusCode)")

            
            switch responseData.result{
            case .success(let value):
                
                
            
                    
                let json = JSON(responseData.result.value)
           // print("members fetched response.. \(response.result)")
           //  print("members fetched response result.. \(response.result.value!)")
            print("members fetched response data.. \(responseData.data!)")
            
            /*print("members fetched response JSON.. \(JSON(response.result.debugDescription))")
            print("members fetched response result JSON.. \(JSON(response.result.value!))")
            print("members fetched response data JSON.. \(JSON(response.data!))")
            
            print("members fetched response COUNT.. \(JSON(response.result.debugDescription).count)")
            print("members fetched response result COUNT.. \(JSON(response.result.value!).count)")
            print("members fetched response data COUNT.. \(JSON(response.data!).count)")
            */
                var membersDataNew=JSON(responseData.result.value!)
                
            for var i in 0 ..< membersDataNew.count
            {
                var groupid=membersDataNew[i]["group_unique_id"]["unique_id"].string
                var displaynameMember=membersDataNew[i]["display_name"].string
                var member_phone1=membersDataNew[i]["member_phone"].string
                var isAdmin=membersDataNew[i]["isAdmin"].string
                var membership_status=membersDataNew[i]["membership_status"].string
                var date_join=membersDataNew[i]["date_join"].string
                
                let dateFormatter = DateFormatter()
                dateFormatter.timeZone=NSTimeZone.local
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                //  let datens2 = dateFormatter.date(from:date2.debugDescription)
                //2016-09-18T19:13:00.588Z
                let datens2 = dateFormatter.date(from: date_join!)
                
                //if already exist in members table , then update membership status
                
                var membershipstatus=sqliteDB.getMemberShipStatus(groupid!, memberphone: member_phone1!)
                if(membershipstatus=="error")
                {
                      sqliteDB.storeMembers(groupid!, member_displayname1: displaynameMember!, member_phone1: member_phone1!, isAdmin1: isAdmin!, membershipStatus1: membership_status!, date_joined1: datens2!)
                }
                //else
                else{
                    sqliteDB.updateMembershipStatus(groupid!, memberphone1: member_phone1!, membership_status1: "joined")
                }
                
              
            /*
     "__v" = 0;
     "_id" = 58137f5f44c231c85fb37e14;
     "date_join" = "2016-10-28T16:39:59.791Z";
     "display_name" = sumaira2;
     "group_unique_id" =         {
     "__v" = 0;
     "_id" = 58137f2144c231c85fb37e11;
     "date_creation" = "2016-10-28T16:38:57.272Z";
     "group_name" = testt222;
     "unique_id" = feWCKzC20161028213854;
     };
     isAdmin = No;
     "member_phone" = "+923201211991";
     "membership_status" = joined;
     */
            }
            
            return completion(true, nil)
            case .failure(let error):
                  return completion(false, nil)
            }
          
        }
    }
    
   
    func fetchSingleGroup(_ unique_id:String,completion:@escaping (_ result:Bool,_ error:String?)->())
    {
        Alamofire.request("https://api.cloudkibo.com/api/users/log", method: .post, parameters: ["data":"IPHONE_LOG: \(username!) fetching group chat message. uniqueid of single new group is \(unique_id)"],headers:header).response{
            response in
            print(response.error)
        }

        //alamofire4
        /*
        
        Alamofire.request(.POST,"https://api.cloudkibo.com/api/users/log",headers:header,parameters: ["data":"IPHONE_LOG: \(username!) fetching group chat message. uniqueid of single new group is \(unique_id)"]).response{
            request, response_, data, error in
            print(error)
        }
        */
        print("uniqueid of single new group is \(unique_id)")
        
        //======GETTING REST API TO GET SPECIFIC GROUP==================
        
       // print("inside fetch single chat")
        if(accountKit == nil){
            accountKit = AKFAccountKit(responseType: AKFResponseType.accessToken)
        }
        
        if (accountKit!.currentAccessToken == nil) {
            
         
            accountKit = AKFAccountKit(responseType: AKFResponseType.accessToken)
            accountKit.requestAccount{
                (account, error) -> Void in
                
                
                if(account != nil){
                    //  var url=Constants.MainUrl+Constants.getContactsList
                    
                    let header:[String:String]=["kibo-token":(accountKit!.currentAccessToken!.tokenString)]
       
                }
                
            }
        }
        var fetchSingleMsgURL=Constants.MainUrl+Constants.fetchSingleGroup
        
        
        //var getUserDataURL=userDataUrl
        
        Alamofire.request("\(fetchSingleMsgURL)", method: .post, parameters: ["unique_id":unique_id],headers:header).responseJSON{response in
            
            //alamofire4
            /*

        Alamofire.request(.POST,"\(fetchSingleMsgURL)",parameters: ["unique_id":unique_id],headers:header).validate(statusCode: 200..<300).responseJSON{response in
            */
            
            switch response.result {
            case .success:
              /*  Alamofire.request(.POST,"https://api.cloudkibo.com/api/users/log",headers:header,parameters: ["data":"IPHONE_LOG: \(username!) fetching group chat message. uniqueid of single new group is \(unique_id)"]).response{
                    request, response_, data, error in
                    print(error)
                }*/
                if let data1 = response.result.value {
                    print("fetch single group \(response.result.value)")
                    print(data1)
                    print(JSON(data1))
                    var groupSingleInfo=JSON(data1)
                    
                    Alamofire.request("https://api.cloudkibo.com/api/users/log", method: .post, parameters: ["data":"IPHONE_LOG: \(username!) fetching group chat message success \(unique_id)"],headers:header).response{
                        response in
                        
                        print("fetching group chat message success")
                    }
                    
                    //alamofire4
                    /*
                    Alamofire.request(.POST,"https://api.cloudkibo.com/api/users/log",headers:header,parameters: ["data":"IPHONE_LOG: \(username!) fetching group chat message success \(unique_id)"]).response{
                        request, response_, data, error in
                        print(error)
                    }*/
                    /*
                     {
                     "date_creation" : "2016-10-27T13:28:35.824Z",
                     "__v" : 0,
                     "_id" : "5812010383bb76fd433ef983",
                     "group_name" : "group B",
                     "unique_id" : "nIjWWER20161027182834"
                     }
                     */
                    var unique_id=groupSingleInfo[0]["unique_id"].string!
                    var group_name=groupSingleInfo[0]["group_name"].string!
                    var date_creation=groupSingleInfo[0]["date_creation"].string!
                    var group_icon=NSData()
                    if(groupSingleInfo[0]["group_icon"] != nil)
                    {
                       // group_icon=(groupSingleInfo[0]["group_icon"] as! String).dataUsingEncoding(NSUTF8StringEncoding)!
                        group_icon="exists".data(using: String.Encoding.utf8)! as Data as NSData
                            //.data(using: String.Encoding.utf8)
                        
                        UtilityFunctions.init().downloadProfileImage(unique_id)
                       
                        
                        // group_icon=groupSingleInfo[0]["group_icon"] as! NSData
                    }
                    
                    let dateFormatter = DateFormatter()
                    dateFormatter.timeZone=NSTimeZone.local
                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                    //  let datens2 = dateFormatter.date(from:date2.debugDescription)
                    //2016-09-18T19:13:00.588Z
                    let datens2 = dateFormatter.date(from: date_creation)
                    
                    print("saving group single \(unique_id)")
                    
                    //Alamofire.request(.POST,"https://api.cloudkibo.com/api/users/log",headers:header,parameters: ["data":"IPHONE_LOG: \(username!) storing groups chat \(unique_id)"])
                    
                    sqliteDB.storeGroups(group_name, groupicon1: group_icon as Data!, datecreation1: datens2!, uniqueid1: unique_id, status1: "new")

                    //=====MUTE GROUP====
                    sqliteDB.storeMuteGroupSettingsTable(unique_id, isMute1: false, muteTime1: NSDate() as Date, unMuteTime1: NSDate() as Date)
                    
                    return completion(true,nil)
                    
                }
            case .failure:
                return completion(false,"fetch single group failed")
            default: print("fetch single group failed")
            return completion(false,"fetch single group failed")

            }
        }
    }
    func fetchSingleGroupChatMessage(_ uniqueidMsg:String,completion:@escaping (_ result:Bool,_ error:String?)->())
    {
           print("uniqueid of group single chat is \(uniqueidMsg)")
        
            //======GETTING REST API TO GET CURRENT USER=======================
            
            print("inside fetch single group chat")
            if(accountKit == nil){
                accountKit = AKFAccountKit(responseType: AKFResponseType.accessToken)
            }
            
            if (accountKit!.currentAccessToken == nil) {
                
                print("inside etch single 1462")
                //specify AKFResponseType.AccessToken
                accountKit = AKFAccountKit(responseType: AKFResponseType.accessToken)
                accountKit.requestAccount{
                    (account, error) -> Void in
                    
                    
                    
                    
                    //**********
                    
                    if(account != nil){
                        //  var url=Constants.MainUrl+Constants.getContactsList
                        
                        let header:[String:String]=["kibo-token":(accountKit!.currentAccessToken!.tokenString)]
                        
                        
                    }
                    
                }
            }
            var fetchSingleMsgURL=Constants.MainUrl+Constants.fetchSingleGroupChat
            
            
            //var getUserDataURL=userDataUrl
        
        Alamofire.request("\(fetchSingleMsgURL)", method: .post, parameters: ["unique_id":uniqueidMsg],headers:header).responseJSON{response in
            
//alamofire4
        /*
            Alamofire.request(.POST,"\(fetchSingleMsgURL)",parameters: ["unique_id":uniqueidMsg],headers:header).validate(statusCode: 200..<300).responseJSON{response in
                */
                
                switch response.result {
                case .success:
                    if let data1 = response.result.value {
                        /*
                         from
                         group_unique_id
                         type (log or chat)
                         msg
                         from_fullname
                         date
                         unique_id
 */
                        //play sound
                        let systemSoundID: SystemSoundID = 1016
                        
                        // to play sound
                        AudioServicesPlaySystemSound (systemSoundID)
                        
                        print(data1)
                        var chatJson = JSON(data1)
                        //chatJson=chatJson["msg"]
                        print("JSON single chat: \(chatJson)")
                       // print("JSON single chat to is: \(chatJson[0]["to"].string!)")
                       // var status="delivered"
                        
                        let dateFormatter = DateFormatter()
                        dateFormatter.timeZone=NSTimeZone.local
                        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                        //  let datens2 = dateFormatter.date(from:date2.debugDescription)
                        //2016-09-18T19:13:00.588Z
                        
                        
                        
                        
                        ///let datens2 = dateFormatter.date(from: chatJson["date"].string!)
                        let datens2 = dateFormatter.date(from: chatJson["date"].string!)
                        
                        var from=chatJson["from"].string!
                        var group_unique_id=chatJson["group_unique_id"]["unique_id"].string!
                        var type=chatJson["type"].string!
                        var msg=chatJson["msg"].string!
                        var from_fullname=chatJson["from_fullname"].string!
                       // var date=chatJson["date"] as! NSDate
                        var unique_id=chatJson["unique_id"].string!
                        
                        sqliteDB.storeGroupsChat(from, group_unique_id1: group_unique_id, type1: type, msg1: msg, from_fullname1: from_fullname, date1: datens2!, unique_id1: unique_id)
                        
                        //store status update delivered
                        sqliteDB.storeGRoupsChatStatus(unique_id, status1: "delivered", memberphone1: from, delivereddate1: NSDate() as Date!, readDate1: NSDate() as Date!)
                      
                        if(chatJson["type"].string! != "chat")
                        {
                            managerFile.checkPendingFilesInGroup(chatJson["unique_id"].string!)
                            
                        }
                        
                        completion(true, nil)
                    }
                    
                default: print("failed errorr")
                    completion(false, "cannot fetch group chat message")
                    
                }
                
                
        
      //default: print("doneeee...")
    }
    }
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        
        ////UIApplication.shared.registerForRemoteNotifications()
        print("registered for notification error", terminator: "")
        ////UtilityFunctions.init().log_papertrail("Error in registration. Error: \(error)")
        NSLog("Error in registration. Error: \(error)")
        //retry
        ////UIApplication.shared.registerForRemoteNotifications()
        //==--UIApplication.sharedApplication().registerUserNotificationSettings(pushNotificationSettings)

    }

    
   
    func screenCapture() {
        atimer=Timer(timeInterval: 0.1, target: self, selector: #selector(AppDelegate.timerFiredScreenCapture), userInfo: nil, repeats: true)
        
    
    DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.background).async { () -> Void in
    while(screenCaptureToggle)
    //for(var i=0;i<30000;i++)
    {
    atimer.fire()
    sleep(1)
    }
    
    }
        

    
    }
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        //==-- UtilityFunctions.init().log_papertrail("IPHONE: \(username!) app willFinishLaunchingWithOptions")
        //==--UtilityFunctions.init().log_papertrail("IPHONE: \(launchOptions)")
        print("willFinishLaunchingWithOptions")
        //!!
        /*socketObj=LoginAPI(url:"\(Constants.MainUrl)")
        ///socketObj.connect()
        socketObj.addHandlers()
        socketObj.addWebRTCHandlers()*/
        return true
    }
    func timerFiredScreenCapture()
    {print("inside timerFiredScreenCapture")
        
        //if(countTimer%2 == 0){
        
        //while(atimer.timeInterval < 3000)
        var chunkLength=64000
        var screenshot:UIImage!
        DispatchQueue.main.async(execute: { () -> Void in
            var myscreen=self.window!.snapshotView(afterScreenUpdates: true)
            
            UIGraphicsBeginImageContext((self.window!.bounds.size))
            
            self.window!.drawHierarchy(in: (myscreen?.bounds)!, afterScreenUpdates: true)
            print("width is \(myscreen?.layer.bounds.width), height is \(myscreen?.layer.bounds.height)")
            screenshot=UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            webMeetingModel.delegateSendScreenshotDataChannel.sendImageFromDataChannel(screenshot)
            
        })
        
        print("outside")
        
    }
    open func showFileRecievedNotification()
    {
        let alert = UIAlertController(title: "Success", message: "You have received a new file. Click on \"View\" button at top to View and Save it.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        let navigationController = UIApplication.shared.windows[0].rootViewController as! UINavigationController
        
        let activeViewCont = navigationController.visibleViewController
        
        activeViewCont!.present(alert, animated: true, completion: nil)
        
        
    
    //self.window?.rootViewController!.presentViewController(alert, animated: true, completion: nil)
    }
    
    func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
        ///application.applicationIconBadgeNumber = 0
      //  UIApplication.sharedApplication().presentLocalNotificationNow(notification)
        print("got local notification")
        socketObj.socket.emit("logClient","IPHONE-LOG: call notification received in background")
    }
    
    
  
    func application(_ application: UIApplication, shouldSaveApplicationState coder: NSCoder) -> Bool {
        return true
    }
    
    func application(_ application: UIApplication, shouldRestoreApplicationState coder: NSCoder) -> Bool {
        return true
    }
   /* func application(application: UIApplication, viewControllerWithRestorationIdentifierPath identifierComponents: [AnyObject], coder: NSCoder) -> UIViewController? {
        return UIViewController
    }*/
    
    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        //UIApplication.shared.setMinimumBackgroundFetchInterval(UIApplicationBackgroundFetchIntervalMinimum) commented
      
        
        print("taking backup offline")
        /*UtilityFunctions.init().log_papertrail("waking up app and connecting socket")
        socketObj=LoginAPI(url:"\(Constants.MainUrl)")
        ///socketObj.connect()
        //            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND,0))
        //{
        socketObj.addHandlers()
        socketObj.addWebRTCHandlers()
        socketObj.addDesktopAppHandlers()
        socketObj.joinDesktopApp()
        */
       UtilityFunctions.init().backupFiles()
       //// completionHandler(.newData)
        
        /*if let tabBarController = window?.rootViewController as? UITabBarController,
            let viewControllers = tabBarController.viewControllers
        {
            for viewController in viewControllers {
                if let fetchViewController = viewController as? FetchViewController {
                    fetchViewController.fetch {
                        fetchViewController.updateUI()
                        completionHandler(.newData)
                    }
                }
            }
        }*/
    }
    
 
    func application(_ application: UIApplication, handleEventsForBackgroundURLSession identifier: String, completionHandler: @escaping () -> Void) {
        
         NetworkingManager.sharedManager.backgroundCompletionHandler = completionHandler
        
        UtilityFunctions.init().log_papertrail("IPHONE-LOG: \(username) completion background manager handler \(identifier)")
    }
    func fetchSingleChatMessage(_ uniqueid:String)
    {
        
      /*  Alamofire.request(.POST,"\(Constants.MainUrl+Constants.urllog)",headers:header,parameters: ["data":"IPHONE_LOG: inside function fetch single chat \(uniqueid)"]).response{
            request, response_, data, error in
            print(error)
        }*/
        
        if(socketObj != nil)
        {
            socketObj.socket.emit("logClient","fetch single chat \(uniqueid)")
        }
        print("uniqueid of single chat is \(uniqueid)")
        
        //======GETTING REST API TO GET CURRENT USER=======================
        
        print("inside fetch single chat")
        if(accountKit == nil){
            accountKit = AKFAccountKit(responseType: AKFResponseType.accessToken)
        }
        
        if (accountKit!.currentAccessToken == nil) {
            
            print("inside etch single 1462")
            //specify AKFResponseType.AccessToken
            accountKit = AKFAccountKit(responseType: AKFResponseType.accessToken)
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
        
        Alamofire.request("\(fetchSingleMsgURL)", method: .post, parameters:  ["uniqueid":uniqueid], encoding:JSONEncoding.default, headers:header).responseJSON{response in
         
            //alamofire4
       /* Alamofire.request(.POST,"\(fetchSingleMsgURL)",parameters: ["uniqueid":uniqueid],headers:header).validate(statusCode: 200..<300).responseJSON{response in
            
            */
            switch response.result {
            case .success:
                if let data1 = response.result.value {
                    
                   /* Alamofire.request(.POST,"\(Constants.MainUrl+Constants.urllog)",headers:header,parameters: ["data":"IPHONE_LOG: fetch single chat success \(uniqueid)"]).response{
                        request, response_, data, error in
                        print(error)
                    }
                    */
                    if(socketObj != nil)
                    {
                        socketObj.socket.emit("logClient","fetched success single chat \(uniqueid)")
                    }
                    
                    var chatJson = JSON(data1)
                    chatJson=chatJson["msg"]
                    print("JSON single chat: \(chatJson)")
                    print("JSON single chat to is: \(chatJson[0]["to"].string!)")
                    var status="delivered"
                    
                    let dateFormatter = DateFormatter()
                    dateFormatter.timeZone=NSTimeZone.local
                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                    //  let datens2 = dateFormatter.date(from:date2.debugDescription)
                    //2016-09-18T19:13:00.588Z
                    
                    
                    
                   let datens2 = dateFormatter.date(from: chatJson[0]["date"].string!)
                  
                    
                    if(!chatJson[0]["type"].exists())
                    {//old chat message
                        
                      
                        print("===single fetch chat date in app delegate \(datens2)")
                        
                     
                       //// UtilityFunctions.init().log_papertrail("IPHONE-LOG: \(username!) got chat saving in databse now sqliteDB is \(sqliteDB.debugDescription)")
                        
                        print()
                        sqliteDB.SaveChat(chatJson[0]["to"].string!, from1: chatJson[0]["from"].string!,owneruser1:chatJson[0]["to"].string!, fromFullName1: chatJson[0]["fromFullName"].string!, msg1: chatJson[0]["msg"].string!,date1:datens2,uniqueid1:chatJson[0]["uniqueid"].string!,status1: status,type1: "", file_type1: "chat",file_path1: "")
                        
                    managerFile.sendChatStatusUpdateMessage(chatJson[0]["uniqueid"].string!, status: status, sender: chatJson[0]["from"].string!)
                        
                        
                    }
                    else
                    {
                        
                        if(chatJson[0]["type"].string! == "file")
                        {
                          //change logic uncomment  managerFile.checkPendingFiles(username!)
                            managerFile.checkPendingFiles(chatJson[0]["uniqueid"].string!)
                        }
                        if(chatJson[0]["type"].string! == "broadcast_file")
                        {
                            //change logic uncomment  managerFile.checkPendingFiles(username!)
                            managerFile.checkPendingFilesBroadcasr(chatJson[0]["uniqueid"].string!)
                        }
                        //
                        //===
                        //===
                        
                     
                      ////   UtilityFunctions.init().log_papertrail("IPHONE-log: \(username!) got chat saving in databse now sqliteDB is \(sqliteDB.debugDescription)")
                        
                        sqliteDB.SaveChat(chatJson[0]["to"].string!, from1: chatJson[0]["from"].string!,owneruser1:chatJson[0]["to"].string!, fromFullName1: chatJson[0]["fromFullName"].string!, msg1: chatJson[0]["msg"].string!,date1:datens2,uniqueid1:chatJson[0]["uniqueid"].string!,status1: status,type1: chatJson[0]["type"].string!, file_type1: chatJson[0]["file_type"].string!,file_path1: "")
                        
                        managerFile.sendChatStatusUpdateMessage(chatJson[0]["uniqueid"].string!, status: status, sender: chatJson[0]["from"].string!)
                       
                        
                    }
                    
                    
                    ///=============***********====SEND DATA TO DESKTOP APP========********========///
                    
                    
                    UtilityFunctions.init().sendDataToDesktopApp(data1: chatJson.object as AnyObject, type1: "new_message_received")
                    
                    
                    
                    
                    var state=UIApplication.shared.applicationState

//UIApplicationState state = [[UIApplication sharedApplication] applicationState];

                    if (state == UIApplicationState.active || state == UIApplicationState.inactive)
                    {
                        
                       //  let systemSoundID: SystemSoundID = 1016
                         
                         // to play sound
                       //  AudioServicesPlaySystemSound (systemSoundID)
                     
                        
                        //AudioServicesCre
                        // to play sound
                        //AudioServicesPlaySystemSound (systemSoundID)

                        
                        //let navigationController = UIApplication.sharedApplication().windows[0].rootViewController
                        //let activeViewCont = navigationController.visibleViewController
                        
                      //  activeViewCont?.loadView()
    
                    }
                    //if(delegateRefreshChat != nil)
                    //{
                        let systemSoundID: SystemSoundID = 1016
                        
                        // to play sound
                        AudioServicesPlaySystemSound (systemSoundID)
                    var type=0
                    var filename=""
                    print("chatJson[type].string! is \(chatJson[0]["type"].string!)")
                    switch(chatJson[0]["from"].string!)
                    {
                        
                    case username! :
                        switch(chatJson[0]["file_type"].string!)
                        {
                        case "image" :
                             type=4
                            filename=chatJson[0]["msg"].string!
                            
                        case "contact" :
                            type=6
                            
                        case "document" :
                            type=8
                        
                        case "video" :
                            type=10
                        
                        case "audio" :
                            type=12
                            
                        case "location" :
                            type=14
                            
                        default: type=2
                        }
                        
                    default:
                        switch(chatJson[0]["file_type"].string!)
                        {
                        case "image" :
                             type=3
                            filename=chatJson[0]["msg"].string!
                            
                        case "document" :
                            type=5
                            
                        case "contact" :
                            type=7
                            
                        case "video" :
                            type=9
                            
                        case "audio" :
                            type=11
                            
                        case "location" :
                            type=13
                            
                        default: type=1
                        }
                    }
                    
                    var formatter2 = DateFormatter();
                    formatter2.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
                    formatter2.timeZone = TimeZone.autoupdatingCurrent
                    var defaultTimeeee = formatter2.string(from: datens2!)
                    
                    if(UIDelegates.getInstance().delegateInsertChatAtLast1 != nil)
                    {
                        UIDelegates.getInstance().delegateInsertChatAtLast1.insertChatRowAtLast(chatJson[0]["msg"].string!, uniqueid: chatJson[0]["uniqueid"].string!, status: status, filename: filename, type: "\(type)", date: defaultTimeeee,from:chatJson[0]["from"].string!)
                    }
                UIDelegates.getInstance().UpdateMainPageChatsDelegateCall()
                    
                    
                }
                else
                {
                   /*  Alamofire.request(.POST,"\(Constants.MainUrl+Constants.urllog)",headers:header,parameters: ["data":"IPHONE_LOG: fetch single chat success BUT response returned is invalid \(uniqueid)"]).response{
                        request, response_, data, error in
                        print(error)
                    }*/
                }
            case .failure:
                
                Alamofire.request("\(Constants.MainUrl+Constants.urllog)", method: .post, parameters:  ["data":"IPHONE_LOG: fetch single chat FAILED \(uniqueid) .. \(response.result.error) .. \(response.error)"],headers:header).response{
                    response in
                    //print(error)
                }

                  //alamofire4
                /*Alamofire.request(.POST,"\(Constants.MainUrl+Constants.urllog)",headers:header,parameters: ["data":"IPHONE_LOG: fetch single chat FAILED \(uniqueid)"]).response{
                    request, response_, data, error in
                    print(error)
                }*/
                print("failed to get seingle chat message")
            }
        }
        
    }
    
    func updateMessageStatus(_ uniqueID:String,status:String)
    {
        print("messageStatusUpdate ...... :\(uniqueID) and : \(status)")
        print(":::::::::::::::::::::::::::::::::::")
        //var chatmsg=JSON(data)
        //print(data[0])
        //print(chatmsg[0])
       
        var log=UtilityFunctions.init()
        log.log_papertrail("IPHONE: \(username!) updating chat status id \(uniqueID) and status \(status)")
        
        
        sqliteDB.UpdateChatStatus(uniqueID, newstatus: status)
        
        
        //get status and unique id from server delivered or seen
        
        var state=UIApplication.shared.applicationState
        
        //UIApplicationState state = [[UIApplication sharedApplication] applicationState];
        
       ///// if (state == UIApplicationState.Active )
       /////// {
            print("updating message status...")
            
           /* let systemSoundID: SystemSoundID = 1016
            
            // to play sound
            AudioServicesPlaySystemSound (systemSoundID)
            */
        let msg = Expression<String>("msg")
         let uniqueid = Expression<String>("uniqueid")
        let type = Expression<String>("type")
        var msgtype=""
        var message=""
        do{for tblContacts in try sqliteDB.db.prepare((sqliteDB.userschats!.filter(uniqueid == uniqueID))){
            message=tblContacts[msg]
            msgtype=tblContacts[type]
            }
        }
            catch{
                
            }
        if(UIDelegates.getInstance().delegateUpdateChatStatusRow1 != nil)
        {
        UIDelegates.getInstance().delegateUpdateChatStatusRow1.updateChatStatusRow(message, uniqueid: uniqueID, status: status, filename: "", type: msgtype as! String, date: "")
        }
        //==--UIDelegates.getInstance().UpdateSingleChatDetailDelegateCall()
        UIDelegates.getInstance().UpdateMainPageChatsDelegateCall()
        
        
        
        
        
        /*if(delegateRefreshChat != nil)
            {
                print("informing UI to repfresh status")
                var log=UtilityFunctions.init()
                log.log_papertrail("informing UI to repfresh status \(uniqueID) and status \(status)")
                
                //===---DispatchQueue.main.async
                //--{
                delegateRefreshChat?.refreshChatsUI(nil, uniqueid:nil, from:nil, date1:nil, type:"status")
                //==---}
            }
        else
            {
                var log=UtilityFunctions.init()
                log.log_papertrail("app is in background. cannot update UI")
                
        }*/
            
            
            //AudioServicesCre
            // to play sound
            //AudioServicesPlaySystemSound (systemSoundID)
            
            
            //let navigationController = UIApplication.sharedApplication().windows[0].rootViewController
            //let activeViewCont = navigationController.visibleViewController
            
            //  activeViewCont?.loadView()
            
      //////  }
        

        
        /*
        self.delegate?.socketReceivedMessage("messageStatusUpdate",data: data)
        if(self.delegateChat != nil)
        {
            self.delegateChat?.socketReceivedMessageChat("updateUI", data: nil)
        }*/
    }
    
    func checkFirstRun() {
    
    var PREFS_NAME = "MyPrefsFile";
    var PREF_VERSION_CODE_KEY = "version_code";
    var DOESNT_EXIST = 0.0;
    
    
    // Get current version code
    var currentVersionCode = 0.0;
        
            let nsObject: AnyObject? = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as AnyObject?
        currentVersionCode = (nsObject as! NSString).doubleValue
        print("current version code is \(currentVersionCode)")
           // Get saved version code
        let preferences = UserDefaults.standard
        print("preferences.doubleForKey PREF_VERSION_CODE_KEY \(preferences.double(forKey: PREF_VERSION_CODE_KEY))")
            

        
        if (preferences.double(forKey: PREF_VERSION_CODE_KEY) == 0.0) {
            //  Doesn't exist
            print("PREF_VERSION_CODE_KEY object not found")
            setupForNewInstall();
        } else {
            let savedVersionCode = preferences.double(forKey: PREF_VERSION_CODE_KEY)
            if (currentVersionCode == savedVersionCode) {
                
                print("This is normal run : version \(currentVersionCode)")
                if(savedVersionCode < 0.1274)
                {
                    //alter user chat table, add fields for broadcast list
                    sqliteDB.alterTable(savedVersionCode)
                }
              //  logMessage("This is normal run : version "+ currentVersionCode);
                
                doFinish();
                
                return;
                
            }
            else if (savedVersionCode == DOESNT_EXIST) {
                print("savedVersionCode doesnot exist")
                setupForNewInstall();
                
            }
            else if (currentVersionCode > savedVersionCode) {
                
                // TODO This is an upgrade
                
                print("This is an upgrade to next version : old version \(savedVersionCode)")
                
                //try db.run(users.addColumn(suffix, defaultValue: "SR"))
                //
                //if db change so uncomment this
                
                doFinish();
                //uncomment later setupForNewInstall()
                
                
                
                //and comment this
               // doFinish();
                
            }
        }
          //  let preferences = NSUserDefaults.standardUserDefaults()
            
           
            let currentLevel = preferences.set(currentVersionCode, forKey: PREF_VERSION_CODE_KEY)
            
            //  Save to disk
            let didSave = preferences.synchronize()
            
            if !didSave {
                //  Couldn't save (I've never seen this happen in real world testing)
            }
        
        
   // SharedPreferences prefs = getSharedPreferences(PREFS_NAME, MODE_PRIVATE);
   // int savedVersionCode = prefs.getInt(PREF_VERSION_CODE_KEY, DOESNT_EXIST);
    
    // Check for first run or upgrade
   
    
    // Update the shared preferences with the current version code
   //// prefs.edit().putInt(PREF_VERSION_CODE_KEY, currentVersionCode).commit();
    
    }

    
    func setupForNewInstall()
    {
               print("This is a new install");
        
       // UserFunctions fn = new UserFunctions();
        //retainOldDatabase=false
        //============================= commentingggggg     ----  sqliteDB.resetTables()
        
        sqliteDB=DatabaseHandler(dbName:"cloudkibo.sqlite3")
        
        /*sqliteDB.createAccountsTable()
        sqliteDB.createAllContactsTable()
        ///////contactslists.drop()
        sqliteDB.createContactListsTable()
        sqliteDB.createUserChatTable()
        sqliteDB.createMessageSeenStatusTable()
        sqliteDB.createCallHistoryTable()
        sqliteDB.createFileTable()
        sqliteDB.createGroupsTable()
        sqliteDB.createGroupsMembersTable()
        sqliteDB.createGroupsChatTable()
        sqliteDB.createGroupsChatStatusTable()
        sqliteDB.createMuteGroupSettingsTable()
        sqliteDB.createBroadcastListTable()
        sqliteDB.createBroadcastListMembersTable()
        */
        /*if(fn.isUserLoggedIn(getApplicationContext())){
            Toast.makeText(
                this,
                "Old data is found from previous install. Removing it.",
                Toast.LENGTH_LONG)
                .show();
            
            logMessage("Old data is found from previous install. Removing it.");
            
            DatabaseHandler db = new DatabaseHandler(getApplicationContext());
            db.resetChatsTable();
            db = new DatabaseHandler(getApplicationContext());
            db.resetTables();
            db = new DatabaseHandler(getApplicationContext());
            db.resetContactsTable();
            db = new DatabaseHandler(getApplicationContext());
            db.resetChatHistorySync();
            db = new DatabaseHandler(getApplicationContext());
            db.resetCallHistoryTable();*/
            
            print("Old data removed from tables. Checking old facebook auth token.");
        if(accountKit == nil){
            accountKit = AKFAccountKit(responseType: AKFResponseType.accessToken)
        }
        
         if (accountKit!.currentAccessToken != nil)
         {
            print("Facebook old auth token was there. Removing it now.");
            accountKit.logOut();
        }

       /* if (accountKit!.currentAccessToken == nil) {
            
            //specify AKFResponseType.AccessToken
            accountKit = AKFAccountKit(responseType: AKFResponseType.AccessToken)
            accountKit.requestAccount{
                (account, error) -> Void in
                
                
                
                
                 if(account != nil){
                    var url=Constants.MainUrl+Constants.getContactsList
                    
                    let header:[String:String]=["kibo-token":(self.accountKit!.currentAccessToken!.tokenString)]
                    
                    print(header)
                    print("in chat got token as \(self.accountKit!.currentAccessToken!.tokenString)")
                    AuthToken=self.accountKit!.currentAccessToken!.tokenString
                    KeychainWrapper.setString(self.accountKit!.currentAccessToken!.tokenString, forKey: "access_token")
                    print("access token key chain sett as \(self.accountKit!.currentAccessToken!.tokenString)")
                    KeychainWrapper.setString((account?.phoneNumber?.countryCode)!, forKey: "countrycode")
                    countrycode=account?.phoneNumber?.countryCode
                    
                    
                }
                
            }}*/
        else
        {
             print("Facebook old auth token was not there.");
            
        }
        doFinish()
    
        
        
    }

    func doFinish()
    {
    
   // if (isRunning)
   // {
    //isRunning = false;
    print("going to main activity now")
      /*  if(accountKit == nil){
            accountKit = AKFAccountKit(responseType: AKFResponseType.AccessToken)
        }
        
        if (accountKit!.currentAccessToken != nil)
        {
            print("Facebook old auth token was there. Removing it now.");
            accountKit.logOut();
        }
        else{
            //do login segue
            print("do login")
        }*/
    
    /*
    if (accessToken != null) {
				//Handle Returning User
				if(isDevelopment) {
    socket.disconnect();
    socket.close();
    Intent i = new Intent(this, DisplayNameReg.class);
    i.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);
    i.putExtra("authtoken", accessToken.getToken());
    startActivity(i);
    finish();
				} else {
    UserFunctions fn = new UserFunctions();
    if(fn.isUserLoggedIn(getApplicationContext())){
    socket.disconnect();
    socket.close();
    Intent i = new Intent(this, MainActivity.class);
    i.putExtra("authtoken", accessToken.getToken());
    i.putExtra("sync", true);
    i.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);
    startActivity(i);
    finish();
    } else {
    socket.disconnect();
    socket.close();
    Intent i = new Intent(this, DisplayNameReg.class);
    i.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);
    i.putExtra("authtoken", accessToken.getToken());
    startActivity(i);
    finish();
    }
    
				}
    } else {
				onLoginPhone();
    }

    
    //}
    }
    */
    }

}
protocol UpdateChatViewsDelegate:class
{
    func refreshChatsUI(_ message: String!, uniqueid:String!, from:String!, date1:Date!, type:String!);
}




