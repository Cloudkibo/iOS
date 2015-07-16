/  LoginViewController.swift

//  Chat

//  Created by My App Templates Team on 24/08/14.

//  Copyright (c) 2014 My App Templates. All rights reserved.



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
    
    
    
    func labelDelegateMethodWithString(string: String) { println(string) }
    
    
    
    
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        
        
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        
        
    }
    
    
    
    
    
    required init(coder aDecoder: NSCoder){
        
        
        
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
                
                //println(tok);
                
                
                
                let socket = SocketIOClient(socketURL: "https://www.cloudkibo.com")
                
                
                
                socket.on("connect") {data, ack in
                    
                    println("socket connected")
                    
                }
                
                
                
                ///////////socket.io////////////////////
                
                socket.on("calleeisoffline") {
                    
                    JSONObject payload = new JSONObject(args[0].toString());
                    
                    var amInCall = false;
                    
                    var amInCallWith = "";
                    
                    println("callee is offline");
                    
                    
                }
                
                socket.on("calleeisbusy") {
                    
                    JSONObject payload = new JSONObject(args[0].toString());
                    
                    var amInCall = false;
                    
                    var amInCallWith = "";
                    
                    println("calleeisbusy")
                    
                }
                
                socket.on("othersideringing") {
                    
                    println("SOCKET: "+ args.toString());
                    
                    JSONObject payload = new JSONObject(args[0].toString());
                    
                    var amInCall = true;
                    
                    var otherSideRinging = true;
                    
                    var amInCallWith = payload.getString("callee");
                    
                    println("othersideringing");
                    
                    
                }
                
                socket.on("areyoufreeforcall") {
                    
                    JSONObject payload = new JSONObject(args[0].toString());
                    
                    JSONObject message2 = new JSONObject();
                    
                    message2.put("me", user.get("username"));
                    message2.put("mycaller", payload.getString("caller"));
                    
                    if(!amInCall){
                        
                        isSomeOneCalling = true;
                        ringing = true;
                        amInCall = true;
                        
                        amInCallWith = payload.getString("caller");
                        
                        socket.emit("yesiamfreeforcall", message2);
                        
                        println("areyoufreeforcall");
                        
                    }
                    else{
                        
                        socket.emit("noiambusy", message2);
                    }
                    
                    
                }
                
                socket.on("currentAmount") {data, ack in
                    
                    if let cur = data?[0] as? Double {
                        
                        socket.emitWithAck("canUpdate", cur)(timeout: 0) {data in
                            
                            socket.emit("update", ["amount": cur + 2.50])
                            
                        }
                        
                        
                        
                        ack?("Got your currentAmount", "dude")
                        
                    }
                    
                }
                
                
                
                socket.connect()
                
                /////////////////////////////////////////
                
                
                
                Alamofire.request(.GET, "https://www.cloudkibo.com/api/users/me?access_token=" + globalToken)
                    
                    
                    
                    .responseJSON { (request, response, data, error) in
                        
                        
                        
                        let u_jsonData = JSON(data!);
                        
                        
                        
                        
                        
                        
                        
                        Alamofire.request(.GET, "https://www.cloudkibo.com/api/contactslist/?access_token=" + globalToken)
                            
                            
                            
                            .responseJSON { (request, response, data1, error) in
                                
                                
                                
                                
                                
                                //println(data1)
                                
                                let c_jsonData = JSON(data1!)
                                
                                let c_jsonArray = JSON(c_jsonData.arrayObject!)
                                
                                
                                
                                for contact in c_jsonArray {
                                    
                                    // println("INSERTED DATA: contact username: \(contact)")
                                    
                                    
                                    
                                }
                                
                                
                                
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
                                
                                
                                
                                // let j_username:String = c_jsonData["username"].string!
                                
                                
                                
                                /*for (index: String, subJson: JSON) in c_jsonData {
                                
                                //Do something you want
                                
                                //var alice: Query?
                                
                                //if let c_insertId =
                                
                                let  c_insertID = contacts.insert(
                                
                                c_username <- c_jsonArray["username"].string!,
                                
                                c_firstname <- c_jsonArray["firstname"].string!,
                                
                                c_lastname <- c_jsonArray["lastname"].string!,
                                
                                c_phone <- c_jsonArray["phone"].string!,
                                
                                c_id <- c_jsonArray["id"].string!,
                                
                                c_status <- c_jsonArray["status"].string!,
                                
                                detailshared <- c_jsonArray["detailshared"].string!)
                                
                                
                                
                                }*/
                                
                                
                                
                                
                                
                                
                                
                                
                                
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
                        
                        
                        
                        
                        
                        //var alice: Query?
                        
                        let insertId = users.insert(username <- u_jsonData["username"].string!,
                            
                            email <- u_jsonData["email"].string!,
                            
                            //date <- jsonData["date"].string!,
                            
                            firstname <- u_jsonData["firstname"].string!,
                            
                            lastname <- u_jsonData["lastname"].string!,
                            
                            phone <- u_jsonData["phone"].string!,
                            
                            role <- u_jsonData["role"].string!,
                            
                            id <- u_jsonData["_id"].string!
                            
                            
                            
                            
                            
                        )
                        
                        
                        
                        for user in users {
                            
                            // println("name: \(user[username]), email: \(user[email])")
                            
                            // id: 1, name: Optional("Alice"), email: alice@mac.com
                            
                        }
                        
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
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue?, sender: AnyObject?) {
        
        if (segue!.identifier == "loginSegue") {
            
            var svc = segue!.destinationViewController as! ChatViewController;
            
            
            
            svc.toPass = globalToken;
            
            println("test")
            
            
            
        }
        
    }
    
    
    
    
    
}