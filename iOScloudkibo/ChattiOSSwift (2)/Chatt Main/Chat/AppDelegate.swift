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

let socketObj=LoginAPI(url:"\(Constants.MainUrl)")
let sqliteDB=DatabaseHandler(dbName:"cloudkiboDB.sqlite3")

var AuthToken=KeychainWrapper.stringForKey("access_token")
var loggedUserObj=JSON("[]")

//let dbSQLite=DatabaseHandler(dbName: "/cloudKibo.sqlite3")
var username=KeychainWrapper.stringForKey("username")
var password=KeychainWrapper.stringForKey("password")
let loggedFullName=KeychainWrapper.stringForKey("loggedFullName")
let loggedPhone=KeychainWrapper.stringForKey("loggedPhone")
let loggedEmail=KeychainWrapper.stringForKey("loggedEmail")
let _id=KeychainWrapper.stringForKey("_id")
var globalroom=""
var joinedRoomInCall=""

//let loggedIDKeyChain=KeychainWrapper.stringForKey("loggedIDKeyChain")

//from id, to id remaining
//mark chat as read is remaining

var areYouFreeForCall:Bool=true
var iamincallWith:String!

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    //  var window: UIWindow?
    
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        UIApplication.sharedApplication().setStatusBarHidden(true, withAnimation: UIStatusBarAnimation.Fade);
        
        UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.LightContent, animated: false);
        
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
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
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        
        socketObj.socket.disconnect(fast: true)
        socketObj.socket.close(fast: true)
    }
    func fetchNewToken()
    {
        var url=Constants.MainUrl+Constants.authentictionUrl
        var param:[String:String]=["username": username!,"password":password!]
        Alamofire.request(.POST,"\(url)",parameters: param).response{
            request, response, data, error in
            println(error)
            
            if response?.statusCode==200
                
            {
                println("login success")
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
                    request1, response1, data1, error1 in
                    
                    //===========INITIALISE SOCKETIOCLIENT=========
                    dispatch_async(dispatch_get_main_queue(), {
                        
                        //self.dismissViewControllerAnimated(true, completion: nil);
                        /// self.performSegueWithIdentifier("loginSegue", sender: nil)
                        
                        if response1?.statusCode==200 {
                            println("got user success")
                            //self.gotToken=true
                            var json=JSON(data1!)
                            
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
                            
                            println(json["_id"])
                            
                            let tbl_accounts = sqliteDB.db["accounts"]
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
                            
                            let insert=tbl_accounts.insert(_id<-json["_id"].string!,
                                firstname<-json["firstname"].string!,
                                lastname<-json["lastname"].string!,
                                email<-json["email"].string!,
                                username<-json["username"].string!,
                                status<-json["status"].string!,
                                phone<-json["phone"].string!)
                            if let rowid = insert.rowid {
                                println("inserted id: \(rowid)")
                            } else if insert.statement.failed {
                                println("insertion failed: \(insert.statement.reason)")
                            }
                            
                            //// self.fetchContacts(AuthToken)
                            for account in tbl_accounts {
                                println("id: \(account[_id]), email: \(account[email]), firstname: \(account[firstname])")
                                // id: 1, email: alice@mac.com, name: Optional("Alice")
                            }
                            
                            
                            
                            
                            //...........
                            /*  let stmt = sqliteDB.db.prepare("SELECT * FROM accounts")
                            println(stmt.columnNames)
                            for row in stmt {
                            println("...................... firstname: \(row[1]), email: \(row[3])")
                            // id: Optional(1), email: Optional("alice@mac.com")
                            }*/
                            
                        } else {
                            /*self.labelLoginUnsuccessful.text="Sorry, you are not registered"
                            self.txtForEmail.text=nil
                            self.txtForPassword.text=nil
                            */
                            println("GOT USER FAILED")
                        }
                    })
                }
                
            }
                
            else
            {
                println("login failed")
                /*self.labelLoginUnsuccessful.text="Sorry, you are not registered"
                self.txtForEmail.text=nil
                self.txtForPassword.text=nil*/
            }
        }
    }
    
    
        
    
    
    
}

