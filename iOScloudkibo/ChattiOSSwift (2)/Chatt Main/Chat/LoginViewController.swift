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


class LoginViewController: UIViewController, UITextFieldDelegate{
    
    var rt=NetworkingLibAlamofire()
    
    var contactsJsonObj:JSON=""
    @IBOutlet var viewForContent : UIScrollView!
    @IBOutlet var viewForUser : UIView!
    @IBOutlet var txtForEmail : UITextField!
    @IBOutlet var txtForPassword : UITextField!
    
    @IBOutlet weak var labelLoginUnsuccessful: UILabel!
    //var AuthToken:String=""
    var authParams:String=""
    var currentUserData:JSON=""
    var gotToken:Bool=false
    var gotUser:Bool=false
    
    
    var joinedRoom:Bool=false
    var UserDictionary:[String:AnyObject] = ["":""]
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        // Custom initialization
        
        
    }
    
 required init?(coder aDecoder: NSCoder) {
        ////fatalError("init(coder:) has not been implemented")
    
        super.init(coder: aDecoder)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let size = UIScreen.mainScreen().bounds.size
        viewForContent.contentSize = CGSizeMake(size.width, 568)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if(socketObj == nil)
        {
            print("socket is nillll22", terminator: "")
            socketObj=LoginAPI(url:"\(Constants.MainUrl)")
            //socketObj.connect()
            socketObj.addHandlers()
        }
        
        //socketObj.socket.on("connect") {data, ack in
          //  NSLog("connected to socket")
        //}
        
        let size = UIScreen.mainScreen().bounds.size
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
        let keyboardF:NSValue = userInfo.objectForKey(UIKeyboardFrameEndUserInfoKey)as! NSValue
        let keyboardFrame = keyboardF.CGRectValue()
        
        UIView.animateWithDuration(duration, delay: 0, options:[], animations: {
            self.viewForContent.contentOffset = CGPointMake(0, keyboardFrame.size.height)
            
            }, completion: nil)
        
    }
    
    func willHideKeyBoard(notification : NSNotification){
        
        var userInfo: NSDictionary!
        userInfo = notification.userInfo
        
        var duration : NSTimeInterval = 0
        var curve = userInfo.objectForKey(UIKeyboardAnimationCurveUserInfoKey) as! UInt
        duration = userInfo[UIKeyboardAnimationDurationUserInfoKey]as! NSTimeInterval
        let keyboardF:NSValue = userInfo.objectForKey(UIKeyboardFrameEndUserInfoKey) as! NSValue
        var keyboardFrame = keyboardF.CGRectValue()
        
        UIView.animateWithDuration(duration, delay: 0, options:[], animations: {
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
    
   
    
    
    @IBAction func loginBtnTapped() {
        //============================ Authenticate User ================
        var url=Constants.MainUrl+Constants.authentictionUrl
        KeychainWrapper.setString(txtForPassword.text!, forKey: "password")
        password=KeychainWrapper.stringForKey("password")
        var param:[String:String]=["username": txtForEmail.text!,"password":txtForPassword.text!]
        Alamofire.request(.POST,"\(url)",parameters: param).response{
            request, response_, _data, error in
            print(error)
            
            if response_?.statusCode==200
                
            {
                //^^^^^username=txtForEmail.text!
                print("login success")
                self.labelLoginUnsuccessful.text=nil
                self.gotToken=true
                
                //======GETTING REST API TO GET CURRENT USER=======================
                
                var userDataUrl=Constants.MainUrl+Constants.getCurrentUser
                //let index: String.Index = advance(self.AuthToken.startIndex, 10)
                
                //======================STORING Token========================
                let jsonLogin = JSON(data: _data!)
                let token = jsonLogin["token"]
                KeychainWrapper.setString(token.string!, forKey: "access_token")
                AuthToken=token.string!
                
                //========GET USER DETAILS===============
                var getUserDataURL=userDataUrl+"?access_token="+AuthToken!
                Alamofire.request(.GET,"\(getUserDataURL)").validate(statusCode: 200..<300).responseJSON{response in
                   
                    
                    switch response.result {
                    case .Success:
                        if let data1 = response.result.value {
                            let json = JSON(data1)
                            print("JSON: \(json)")
                            dispatch_async(dispatch_get_main_queue(), {
                                
                                self.dismissViewControllerAnimated(true, completion: nil);
                                print("got user success")
                                self.gotToken=true
                                var json=JSON(data1)
                                //KeychainWrapper.setData(data1!, forKey: "loggedUserObj")
                                //loggedUserObj=json(loggedUserObj)
                                
                                loggedUserObj=json
                                //stringByResolvingSymlinksInPath
                                
                                KeychainWrapper.setString(loggedUserObj.description, forKey:"loggedUserObjString")
                                
                                print(loggedUserObj.debugDescription)
                                print(loggedUserObj.object)
                                print("$$$$$$$$$$$$$$$$$$$$$$$$$")
                                ////print(loggedUserObj.string)
                                //KeychainWrapper.setString(loggedUserObj.string!, forKey:"loggedUserObjString")
                                /////var lll = JSONStringify(data1!, prettyPrinted: false)
                                ///print(lll)
                                /////KeychainWrapper.setString(lll,forKey:"loggedIDKeyChain")
                                print("************************")
                                
                                //===========saving username======================
                                
                                do{
                                    try KeychainWrapper.setString(json["username"].string!, forKey: "username")
                                    try KeychainWrapper.setString(json["firstname"].string!+" "+json["lastname"].string!, forKey: "loggedFullName")
                                    try KeychainWrapper.setString(json["phone"].string!, forKey: "loggedPhone")
                                    try KeychainWrapper.setString(json["email"].string!, forKey: "loggedEmail")
                                    try KeychainWrapper.setString(json["_id"].string!, forKey: "_id")
                                    try KeychainWrapper.setString(self.txtForPassword.text!, forKey: "password")
                                    
                                }
                                catch{
                                    print("error is setting keychain value")
                                    print(json.error?.localizedDescription)
                                }
                                
                                /* username=KeychainWrapper.stringForKey("password")
                                firstname=KeychainWrapper.stringForKey("firstname")
                                password=KeychainWrapper.stringForKey("password")
                                password=KeychainWrapper.stringForKey("password")
                                password=KeychainWrapper.stringForKey("password")
                                */
                                /////////socketObj.addHandlers()
                                
                                var jsonNew=JSON("{\"room\": \"globalchatroom\",\"user\": {\"username\":\"sabachanna\"}}")
                                //socketObj.socket.emit("join global chatroom", ["room": "globalchatroom", "user": ["username":"sabachanna"]]) WORKINGGG
                                
                                socketObj.socket.emit("join global chatroom",["room": "globalchatroom", "user": json.object])
                                
                                print(json["_id"])
                                
                                let tbl_accounts = sqliteDB.accounts
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
                                } catch {
                                    print("insertion failed: \(error)")
                                }
                                
                                
                                /*let insert=tbl_accounts.insert(_id<-json["_id"].string!,
                                firstname<-json["firstname"].string!,
                                lastname<-json["lastname"].string!,
                                email<-json["email"].string!,
                                username<-json["username"].string!,
                                status<-json["status"].string!,
                                phone<-json["phone"].string!)
                                if let rowid = insert.rowid {
                                print("inserted id: \(rowid)")
                                } else if insert.statement.failed {
                                print("insertion failed: \(insert.statement.reason)")
                                }
                                */
                                //// self.fetchContacts(AuthToken)
                                do{for account in try sqliteDB.db.prepare(tbl_accounts) {
                                    print("id: \(account[_id]), email: \(account[email]), firstname: \(account[firstname])")
                                    // id: 1, email: alice@mac.com, name: Optional("Alice")
                                    }
                                }catch{
                                    print("failed accounts data print")
                                }
                                
                                
                                
                                
                                //...........
                                /*  let stmt = sqliteDB.db.prepare("SELECT * FROM accounts")
                                print(stmt.columnNames)
                                for row in stmt {
                                print("...................... firstname: \(row[1]), email: \(row[3])")
                                // id: Optional(1), email: Optional("alice@mac.com")
                                }*/
                                
                            
                            })
                        
                        }
                    case .Failure(let error):
                        self.labelLoginUnsuccessful.text="Sorry, you are not registered"
                        self.txtForEmail.text=nil
                        self.txtForPassword.text=nil
                        
                        print("GOT USER FAILED")
                    
                
                        print(error)
                    }}}}
                    
                    
                    
                    /*
                    let response1=response.response
                    let request1=response.request
                    let data1=response.data
                    let error1=response.result.error
                    //===========INITIALISE SOCKETIOCLIENT=========
                    dispatch_async(dispatch_get_main_queue(), {
                        
                        self.dismissViewControllerAnimated(true, completion: nil);
                        /// self.performSegueWithIdentifier("loginSegue", sender: nil)
                        
                        if response1?.statusCode==200 {
                            print("got user success")
                            self.gotToken=true
                            var json=JSON(data1!)
                            //KeychainWrapper.setData(data1!, forKey: "loggedUserObj")
                            //loggedUserObj=json(loggedUserObj)
                            
                            loggedUserObj=json
                            //stringByResolvingSymlinksInPath
                            
                            KeychainWrapper.setString(loggedUserObj.description, forKey:"loggedUserObjString")
                            
                            print(loggedUserObj.debugDescription)
                            print(loggedUserObj.object)
                            print("$$$$$$$$$$$$$$$$$$$$$$$$$")
                            ////print(loggedUserObj.string)
                            //KeychainWrapper.setString(loggedUserObj.string!, forKey:"loggedUserObjString")
                            /////var lll = JSONStringify(data1!, prettyPrinted: false)
                            ///print(lll)
                            /////KeychainWrapper.setString(lll,forKey:"loggedIDKeyChain")
                            print("************************")
                            
                            //===========saving username======================
                           
                            do{
                            try KeychainWrapper.setString(json["username"].string!, forKey: "username")
                            try KeychainWrapper.setString(json["firstname"].string!+" "+json["lastname"].string!, forKey: "loggedFullName")
                            try KeychainWrapper.setString(json["phone"].string!, forKey: "loggedPhone")
                            try KeychainWrapper.setString(json["email"].string!, forKey: "loggedEmail")
                            try KeychainWrapper.setString(json["_id"].string!, forKey: "_id")
                            try KeychainWrapper.setString(self.txtForPassword.text!, forKey: "password")
                            
                            }
                                catch{
                                    print("error is setting keychain value")
                                    print(json.error?.localizedDescription)
                                }
                            
                           /* username=KeychainWrapper.stringForKey("password")
                            firstname=KeychainWrapper.stringForKey("firstname")
                            password=KeychainWrapper.stringForKey("password")
                            password=KeychainWrapper.stringForKey("password")
                            password=KeychainWrapper.stringForKey("password")
                            */
                            /////////socketObj.addHandlers()
                            
                            var jsonNew=JSON("{\"room\": \"globalchatroom\",\"user\": {\"username\":\"sabachanna\"}}")
                            //socketObj.socket.emit("join global chatroom", ["room": "globalchatroom", "user": ["username":"sabachanna"]]) WORKINGGG
                            
                            socketObj.socket.emit("join global chatroom",["room": "globalchatroom", "user": json.object])
                            
                            print(json["_id"])
                            
                            let tbl_accounts = sqliteDB.accounts
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
                            } catch {
                                print("insertion failed: \(error)")
                            }
                            
                            
                            /*let insert=tbl_accounts.insert(_id<-json["_id"].string!,
                                firstname<-json["firstname"].string!,
                                lastname<-json["lastname"].string!,
                                email<-json["email"].string!,
                                username<-json["username"].string!,
                                status<-json["status"].string!,
                                phone<-json["phone"].string!)
                            if let rowid = insert.rowid {
                                print("inserted id: \(rowid)")
                            } else if insert.statement.failed {
                                print("insertion failed: \(insert.statement.reason)")
                            }
                            */
                            //// self.fetchContacts(AuthToken)
                            do{for account in try sqliteDB.db.prepare(tbl_accounts) {
                                print("id: \(account[_id]), email: \(account[email]), firstname: \(account[firstname])")
                                // id: 1, email: alice@mac.com, name: Optional("Alice")
                            }
                            }catch{
                                print("failed accounts data print")
                            }
                            
                            
                            
                            
                            //...........
                            /*  let stmt = sqliteDB.db.prepare("SELECT * FROM accounts")
                            print(stmt.columnNames)
                            for row in stmt {
                            print("...................... firstname: \(row[1]), email: \(row[3])")
                            // id: Optional(1), email: Optional("alice@mac.com")
                            }*/
                            
                        } else {
                            self.labelLoginUnsuccessful.text="Sorry, you are not registered"
                            self.txtForEmail.text=nil
                            self.txtForPassword.text=nil
                            
                            print("GOT USER FAILED")
                        }
                    })
                    
                    if(response_!.statusCode==401)
                    {
                        print("got user failed token expired")
                        self.rt.refrToken()
                    }
                }
               
            }
                
            else
            {
                KeychainWrapper.removeObjectForKey("password")
                print("login failed")
                self.labelLoginUnsuccessful.text="Sorry, you are not registered"
                self.txtForEmail.text=nil
                self.txtForPassword.text=nil
            }
        }*/
    }
    
    
    
    func AuthenticateUser(){}
    func getUserObject(){}
    func joinGlobalChatRoom(){}
    
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
    
    
    
    // #pragma mark - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    /* override func prepareForSegue(segue: UIStoryboardSegue?, sender: AnyObject?) {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if segue!.identifier == "loginSegue" {
    if let destinationVC = segue!.destinationViewController as? ChatViewController{
    destinationVC.AuthToken = AuthToken
    destinationVC.contactsJsonObj=self.contactsJsonObj
    }
    }
    }*/
}
