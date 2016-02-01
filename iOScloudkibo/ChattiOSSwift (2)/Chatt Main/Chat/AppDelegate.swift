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

//let socketObj=LoginAPI(url:"\(Constants.MainUrl)")
var socketObj:LoginAPI!
let sqliteDB=DatabaseHandler(dbName:"cloudkibo.sqlite3")
////let sqliteDB=DatabaseHandler(dbName: "")
var AuthToken=KeychainWrapper.stringForKey("access_token")
var loggedUserObj=JSON("[]")
var glocalChatRoomJoined:Bool=false
//let dbSQLite=DatabaseHandler(dbName: "/cloudKibo.sqlite3")
var username=KeychainWrapper.stringForKey("username")
var password=KeychainWrapper.stringForKey("password")
let loggedFullName=KeychainWrapper.stringForKey("loggedFullName")
let loggedPhone=KeychainWrapper.stringForKey("loggedPhone")
let loggedEmail=KeychainWrapper.stringForKey("loggedEmail")
let _id=KeychainWrapper.stringForKey("_id")
var globalroom="globalchatroom"
var joinedRoomInCall=""
var currentID:Int!
var otherID:Int!
//let loggedIDKeyChain=KeychainWrapper.stringForKey("loggedIDKeyChain")

//from id, to id remaining
//mark chat as read is remaining
var isConference = false
var ConferenceRoomName = "test"
var atimer:NSTimer!
var areYouFreeForCall:Bool=true
var iamincallWith:String!
var isInitiator=false
var callerName=""
var rtcICEarray:[RTCICEServer]=[]
var rtcFact:RTCPeerConnectionFactory!
var contactsList=iOSContact(keys: [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactEmailAddressesKey, CNContactPhoneNumbersKey])
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    //  var window: UIWindow?
    
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        UIApplication.sharedApplication().setStatusBarHidden(true, withAnimation: UIStatusBarAnimation.Fade);
        
        UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.LightContent, animated: false);
        
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        application.registerUserNotificationSettings(UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: nil))  // types are UIUserNotificationType members
        
        application.registerForRemoteNotifications()
        
          if(socketObj == nil)
            {
                print("socket is nillll1", terminator: "")
                socketObj=LoginAPI(url:"\(Constants.MainUrl)")
                //socketObj.connect()
                socketObj.addHandlers()
                socketObj.addWebRTCHandlers()
            }
        
    
        
        
        
        return true
        
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
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
        if(socketObj == nil)
        {
            print("socket is nillll", terminator: "")
            socketObj=LoginAPI(url:"\(Constants.MainUrl)")
            ///socketObj.connect()
            socketObj.addHandlers()
            socketObj.addWebRTCHandlers()
        }
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        
        //socketObj.socket.disconnect(fast: true)
        //socketObj.socket.close(fast: true)
    }
    func fetchNewToken()
    {let tbl_accounts = sqliteDB.accounts
        var url=Constants.MainUrl+Constants.authentictionUrl
        var param:[String:String]=["username": username!,"password":password!]
        Alamofire.request(.POST,"\(url)",parameters: param).response{
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
                var getUserDataURL=userDataUrl+"?access_token="+AuthToken!
                Alamofire.request(.GET,"\(getUserDataURL)").responseJSON{
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
                            KeychainWrapper.setString(json["firstname"].string!+" "+json["lastname"].string!, forKey: "loggedFullName")
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
                                    firstname<-json["firstname"].string!,
                                    lastname<-json["lastname"].string!,
                                    email<-json["email"].string!,
                                    username<-json["username"].string!,
                                    status<-json["status"].string!,
                                    phone<-json["phone"].string!))
                                print("inserted id: \(rowid)")
                                for account in try sqliteDB.db.prepare(tbl_accounts) {
                                    print("id: \(account[_id]), email: \(account[email]), firstname: \(account[firstname])")
                                }
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
    
    
        
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        let token=JSON(deviceToken)
        print("device tokennnnnnn...", terminator: "")
        print(token.debugDescription)
        
        print("registered for notification", terminator: "")
    }
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        
        print("registered for notification error", terminator: "")
        NSLog("Error in registration. Error: \(error)")
    }
    

    
}

