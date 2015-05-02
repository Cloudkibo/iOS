//

//  LoginViewController.swift

//  Chat

//

//  Created by My App Templates Team on 24/08/14.

//  Copyright (c) 2014 My App Templates. All rights reserved.

//



import UIKit

import Alamofire

import SwiftyJSON

import SQLite



var globalToken: String = "";



class LoginViewController: UIViewController, UITextFieldDelegate{
    
    
    
    @IBOutlet var viewForContent : UIScrollView!
    
    @IBOutlet var viewForUser : UIView!
    
    @IBOutlet var txtForEmail : UITextField!
    
    @IBOutlet var txtForPassword : UITextField!
    
    
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        // Custom initialization
        
        
        
    }
    
    
    
    required init(coder aDecoder: NSCoder)
        
    {
        
        super.init(coder: aDecoder)
        
    }
    
    
    
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        
        var size = UIScreen.mainScreen().bounds.size
        
        viewForContent.contentSize = CGSizeMake(size.width, 568)
        
    }
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        var size = UIScreen.mainScreen().bounds.size
        
        viewForContent.contentSize = CGSizeMake(size.width, 568)
        
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("willShowKeyBoard:"), name:UIKeyboardWillShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("willHideKeyBoard:"), name:UIKeyboardWillHideNotification, object: nil)
        
        
        
        // Do any additional setup after loading the view.
        
    }
    
    
    
    func willShowKeyBoard(notification : NSNotification){
        
        
        
        var userInfo: NSDictionary!
        
        userInfo = notification.userInfo
        
        
        
        var duration : NSTimeInterval = 0
        
        var curve = userInfo.objectForKey(UIKeyboardAnimationCurveUserInfoKey) as! UInt
        
        duration = userInfo[UIKeyboardAnimationDurationUserInfoKey]as! NSTimeInterval
        
        var keyboardF:NSValue = userInfo.objectForKey(UIKeyboardFrameEndUserInfoKey) as! NSValue
        
        var keyboardFrame = keyboardF.CGRectValue()
        
        
        
        UIView.animateWithDuration(duration, delay: 0, options:nil, animations: {
            
            self.viewForContent.contentOffset = CGPointMake(0, keyboardFrame.size.height)
            
            
            
            }, completion: nil)
        
        
        
    }
    
    
    
    func willHideKeyBoard(notification : NSNotification){
        
        
        
        var userInfo: NSDictionary!
        
        userInfo = notification.userInfo
        
        
        
        var duration : NSTimeInterval = 0
        
        var curve = userInfo.objectForKey(UIKeyboardAnimationCurveUserInfoKey)as! UInt
        
        duration = userInfo[UIKeyboardAnimationDurationUserInfoKey]as! NSTimeInterval
        
        var keyboardF:NSValue = userInfo.objectForKey(UIKeyboardFrameEndUserInfoKey) as! NSValue
        
        var keyboardFrame = keyboardF.CGRectValue()
        
        
        
        UIView.animateWithDuration(duration, delay: 0, options:nil, animations: {
            
            self.viewForContent.contentOffset = CGPointMake(0, 0)
            
            
            
            }, completion: nil)
        
        
        
    }
    
    
    
    func textFieldShouldReturn (textField: UITextField) -> Bool{
        
        if ((textField == txtForEmail)){
            
            txtForPassword.becomeFirstResponder();
            
        } else if (textField == txtForPassword){
            
            textField.resignFirstResponder()
            
        }
        
        return true
        
    }
    
    
    
    @IBAction func registerBtnTapped() {
        
        self.dismissViewControllerAnimated(true, completion: nil);
        
    }
    
    
    
    @IBAction func loginBtnTapped() {
        
        let db = Database("/Users/cloudkibo/Desktop/iOS/db.sqlite3")
        
        Alamofire.request(.POST, "https://www.cloudkibo.com/auth/local", parameters: ["username" : txtForEmail.text, "password" : txtForPassword.text])
            
            .responseJSON { (request, response, data, error) in
                
                
                let jsonObject = JSON(data!)
                
                
                let tok: String = jsonObject["token"].string!
                
                globalToken = tok;
                
                
                Alamofire.request(.GET, "https://www.cloudkibo.com/api/users/me?access_token=" + globalToken)
                    
                    .responseJSON { (request, response, data, error) in
        
                        let u_jsonData = JSON(data!)
                        //println(jsonData["username"].string!);
                        ///////////////////////////////////
                        
                        Alamofire.request(.GET, "https://www.cloudkibo.com/api/contactslist/?access_token=" + globalToken)
                            
                            .responseJSON { (request, response, data1, error) in
                                
                                
                                //println(data1)
                                let c_jsonData = JSON(data1!)
                                
                                
                                
                                let contacts = db["contacts"]
                                let c_id = Expression<String>("id")
                                let c_username = Expression<String>("username")
                                let c_firstname = Expression<String>("firstname")
                                let c_lastname = Expression<String>("lastname")
                                let c_phone = Expression<String>("phone")
                                let detailshared = Expression<String>("detailshared")
                                let c_status = Expression<String>("status")
                                
                                db.drop(table: contacts, ifExists: true);
                                
                                db.create(table: contacts, ifNotExists: true) { t in
                                    t.column(c_id, defaultValue: "Anonymous")
                                    t.column(c_username, defaultValue: "Anonymous")
                                    t.column(c_firstname, defaultValue: "Anonymous")
                                    t.column(c_lastname, defaultValue: "Anonymous")
                                    t.column(c_phone, defaultValue: "0987")
                                    t.column(c_status, defaultValue: "Anonymous")
                                    t.column(detailshared, defaultValue: "Anonymous")
                                    
                                }// db created
                                
                                for (index: String, subJson: JSON) in c_jsonData {
                                    //Do something you want
                                    //var alice: Query?
                                    if let c_insertId = contacts.insert(
                                        c_username <- c_jsonData["username"].string!,
                                        c_firstname <- c_jsonData["firstname"].string!,
                                        c_lastname <- c_jsonData["lastname"].string!,
                                        c_phone <- c_jsonData["phone"].string!,
                                        c_id <- c_jsonData["id"].string!,
                                        c_status <- c_jsonData["status"].string!,
                                        detailshared <- c_jsonData["detailshared"].string!
                                        
                                        
                                        ) {
                                           println(c_jsonData[1]["username"].string)
                                            
                                            println("inserted id: \(c_insertId)")
                                            //println(c_jsonData["username"].string!)
                                            // inserted id: 1
                                            //alice = users.filter(id == insertId)
                                    }
                                    
                                    
                                }
                                
                                
                                
                                
                                
                                
                                
                                
                                let socket = SocketIOClient(socketURL: "http://45.55.233.191:8080")
                                
                                socket.on("connect") {data, ack in
                                    println("socket connected")
                                }
                                
                                // Connect
                                socket.connect()
                                
                                
                                
                        }//////////////////////////////////
                        
                        
                        //////////////////////////////////////
                        // sqlite moved here
                        //////////////////////////////////////
                        
                        
                        
                        
                        let users = db["users"]
                        let id = Expression<String>("id")
                        let username = Expression<String>("username")
                        let firstname = Expression<String>("firstname")
                        let lastname = Expression<String>("lastname")
                        let email = Expression<String>("email")
                        let phone = Expression<String>("phone")
                        let country = Expression<String>("country")
                        let city = Expression<String>("city")
                        let state = Expression<String>("state")
                        let gender = Expression<String>("gender")
                        let role = Expression<String>("role")
                        let date = Expression<String>("date")
                        let isOwner = Expression<String>("isOwner")
                        let status = Expression<String>("status")
                        
                        db.drop(table: users, ifExists: true);
                        
                        db.create(table: users, ifNotExists: true) { t in
                            t.column(id, defaultValue: "Anonymous")
                            t.column(username, defaultValue: "Anonymous")
                            t.column(email, defaultValue: "Anonymous")
                            t.column(firstname, defaultValue: "Anonymous")
                            t.column(lastname, defaultValue: "Anonymous")
                            t.column(phone, defaultValue: "0987")
                            t.column(country, defaultValue: "Anonymous")
                            t.column(city, defaultValue: "Anonymous")
                            t.column(state, defaultValue: "Anonymous")
                            t.column(gender, defaultValue: "Anonymous")
                            t.column(role, defaultValue: "Anonymous")
                            t.column(date, defaultValue: "Anonymous")
                            t.column(isOwner, defaultValue: "Anonymous")
                            t.column(status, defaultValue: "Anonymous")
                            
                        }
                        
                        /*println(jsonData["email"].string!)
                        println(jsonData["date"].string!)
                        println(jsonData["firstname"].string!)
                        println(jsonData["lastname"].string!)
                        println(jsonData["phone"].string!)
                        println(jsonData["role"].string!)
                        println(jsonData["_id"].string!)*/
                    
                        var alice: Query?
                        if let insertId = users.insert(username <- u_jsonData["username"].string!,
                                                        email <- u_jsonData["email"].string!,
                                                        //date <- jsonData["date"].string!,
                                                        firstname <- u_jsonData["firstname"].string!,
                                                        lastname <- u_jsonData["lastname"].string!,
                                                        phone <- u_jsonData["phone"].string!,
                                                        role <- u_jsonData["role"].string!,
                                                        id <- u_jsonData["_id"].string!
                           
                            
                            ) {
                            //println("inserted id: \(insertId)")
                            // inserted id: 1
                            //alice = users.filter(id == insertId)
                        }
                        
                        
                        
                        /*for user in users {
                            println("name: \(user[username]), email: \(user[email])")
                            // id: 1, name: Optional("Alice"), email: alice@mac.com
                        }*/
              //////////////////////////////////////////////
                       
                        
                }
                
        }

        
        self.dismissViewControllerAnimated(true, completion: nil);
        
    }
    
    
    @IBAction func facebookBtnTapped() {
        
        self.dismissViewControllerAnimated(true, completion: nil);
        
    }
    
    
    
    @IBAction func twitterBtnTapped() {
        
        self.dismissViewControllerAnimated(true, completion: nil);
        
    }
    
    
    
    @IBAction func forgotPasswordBtnTapped() {
        
        self.dismissViewControllerAnimated(true, completion: nil);
        
    }
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
        
    }
    
    
    
    
    
    /*
    
    // #pragma mark - Navigation
    
    
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue?, sender: AnyObject?) {
    
    // Get the new view controller using [segue destinationViewController].
    
    // Pass the selected object to the new view controller.
    
    }
    
    */
    
    
    
}

