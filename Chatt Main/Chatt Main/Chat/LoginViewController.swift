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
        
        
        
        Alamofire.request(.POST, "https://www.cloudkibo.com/auth/local", parameters: ["username" : txtForEmail.text, "password" : txtForPassword.text])
            
            .responseJSON { (request, response, data, error) in
                
                
                let jsonObject = JSON(data!)
                
                
                let tok: String = jsonObject["token"].string!
                
                globalToken = tok;
                
                
                Alamofire.request(.GET, "https://www.cloudkibo.com/api/users/me?access_token=" + globalToken)
                    
                    .responseJSON { (request, response, data, error) in
        
                        //println(data);
                        
                        
                        Alamofire.request(.GET, "https://www.cloudkibo.com/api/contactslist/?access_token=" + globalToken)
                            
                            .responseJSON { (request, response, data, error) in
                                
                                
                                println(data)
                                
                                
                                let socket = SocketIOClient(socketURL: "https://www.cloudkibo.com")
                                
                                socket.on("connect") {data, ack in
                                    println("socket connected")
                                }
                                
                                // Connect
                                socket.connect()
                                
                                //////////////////////////////////////
                                // sqlite moved here
                                //////////////////////////////////////
                                
                                
                                import Squeal
                                
                                let cloudkibo= Database(path:"data.sqlite3")!
                                
                                cloudkibo= .createTable("users",
                                    definitions:[
                                        "username TEXT",
                                        "firstname TEXT",
                                        "lastname TEXT",
                                        "email(email)",
                                        "phone INTEGER",
                                        "country TEXT",
                                        "city TEXT",
                                        "state TEXT",
                                        "gender TEXT",
                                        "role TEXT = 'user' ",
                                        "fb_photo TEXT",
                                        "google_photo TEXT",
                                        "windows_photo TEXT",
                                        "isOwner TEXT",
                                        "picture TEXT",
                                        "accountVerified : {type: String, default: 'No' }",
                                        "date  :  { type: Date, default: Date.now }",
                                        "initialTesting TEXT,",
                                        "status : {type: String, default: 'I am on CloudKibo' }",
                                        "hashedPassword TEXT",
                                        "provider TEXT",
                                        "salt TEXT"
                                        
                                        
                                    ])
                                
                                cloudkibo= .createTable("contactlist",
                                    definitions:[
                                        "username TEXT",
                                        "userid TEXT",
                                        "contactid TEXT",
                                        "unreadMessage : {type: Boolean, default: false }",
                                        "detailsshared: {type : String, default :'No'}"
                                        
                                    ])
                                
                                
                                
                                cloudkibo= .createTable("contactlist",
                                    definitions:[
                                        "to TEXT",
                                        "from TEXT",
                                        "fromFullName TEXT",
                                        "msg TEXT",
                                        "date : {type: Date, default: Date.now },
                                        "owneruser TEXT
                                    ])
                                
                                
                                
                                ////////////////////////////////
                                
                                var error: NSError?
                                if let rowId = database.insertInto("user", values:[
                                    "username":,
                                    "firstname":,
                                    "lastname":,
                                    "email":,
                                    "phone":, 
                                    "country":,
                                    "city":,
                                    "state":,
                                    "gender":,
                                    "role" = 'user' ,
                                    "fb_photo":,
                                    "google_photo TEXT",
                                    "windows_photo TEXT",
                                    "isOwner":,
                                    "picture TEXT",
                                    "accountVerified":,
                                    "date":,
                                    "initialTesting TEXT,",
                                    "status":,
                                    "hashedPassword TEXT",
                                    "provider TEXT",
                                    "salt TEXT"
                                    
                                    ], error:&error]) {
                                        // rowId is the id in the database
                                } else {
                                    // handle error
                                }
                                
                                /////////////////////////////////////////
                                // sqlite moved here
                                ////////////////////////////////////////
                                
                                
                        }
                        
                        
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

