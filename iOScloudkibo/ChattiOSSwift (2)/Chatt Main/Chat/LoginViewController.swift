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
import AccountKit
import Foundation
class LoginViewController: UIViewController,SocketConnecting,AKFViewControllerDelegate{
    
    ///////var accountKit:AKFAccountKit!
    var rt=NetworkingLibAlamofire()
    var delegateSocket:SocketConnecting!
    @IBOutlet weak var progressWheel: UIActivityIndicatorView!
    var contactsJsonObj:JSON=""
    @IBOutlet var viewForContent : UIScrollView!
    @IBOutlet var viewForUser : UIView!
    @IBOutlet var txtForEmail : UITextField!
    @IBOutlet var txtForPassword : UITextField!
    @IBOutlet weak var txtForRoomName: UITextField!
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        if (accountKit.currentAccessToken != nil && firstTimeLogin==false) {
            header=["kibo-token":accountKit!.currentAccessToken!.tokenString]
            
          print("login view will appear")
            self.dismiss(animated: true, completion:{
                if(socketObj != nil){
                socketObj.socket.emit("logClient", "login done fetch contacts and show contacts list now")
}
                print("show contacts list now")
                }
            )
            
        }
        
        /*if (accountKit.currentAccessToken != nil) {
            header=["kibo-token":accountKit!.currentAccessToken!.tokenString]
            //%%%%%%%%%%%%%%%%%%%%% phone model added firtsttimelogin
             //%%%%%%%%%%%%%%newwwww phone model firstTimeLogin=false
            AuthToken=accountKit.currentAccessToken!.tokenString
            // if the user is already logged in, go to the main screen
            print("User already logged in go to ViewController")
            if(firstTimeLogin==true)
            {
                print("displayname ................")
            dispatch_async(dispatch_get_main_queue(), {
                
               self.performSegueWithIdentifier("displaynamesegue", sender: self)
                
                //no seque from login to chat. it is from chat to login
                //self.performSegueWithIdentifier("loginSegue", sender: self)
                //%%%%%%%%%%%%%%%%%% was working but showing contact list directly
            /*self.dismiss(true, completion: { () -> Void in
                
                
                print("login success now going to contact list")
                socketObj.socket.emit("logClient","IPHONE-LOG: login success now going to contact list")
            })*/
                
            })
            }
            else{
                print("firsttimelogin true no displayname....")
                if(firstTimeLogin==false)
                {
                
                self.dismiss(true, completion: { () -> Void in
                    
                    
                    print("login success now going to contact list")
                    socketObj.socket.emit("logClient","IPHONE-LOG: login success now going to contact list")
                })
                }
            }
            
        }
        else
        {
           
            /*self.dismiss(true, completion:{
                socketObj.socket.emit("logClient", "login done fetch contacts and show contacts list now")
                print("show contacts list now")
                }
            )*/
            
        }*/
        
        
        /*if(socketConnected == false)
        {
        socketObj.socket.connect(timeoutAfter: 5000) { () -> Void in
        
        socketObj.socket.reconnect()
        
        }
        }*/
        
        /*if(socketObj == nil)
        {
        print("socket is nillll22", terminator: "")
        socketObj=LoginAPI(url:"\(Constants.MainUrl)")
        //socketObj.connect()
        socketObj.addHandlers()
        socketObj.addWebRTCHandlers()
        }*/
    }
    
    //********************************************************************************************
    
    func viewController(_ viewController: UIViewController!, didCompleteLoginWith accessToken: AKFAccessToken!, state: String!) {
        print("Login succcess with AccessToken \(accessToken.debugDescription)")
        DispatchQueue.main.async(execute: {
            header=["kibo-token":accountKit!.currentAccessToken!.tokenString]
            accountKit = AKFAccountKit(responseType: AKFResponseType.accessToken)
            accountKit.requestAccount{
                (account, error) -> Void in
                
                //**********
                
                if(account != nil){
                    KeychainWrapper.setString((account?.phoneNumber?.countryCode)!, forKey: "countrycode")
                    countrycode=account?.phoneNumber?.countryCode
                    
                    
                 /*   let defaults = UserDefaults.standard
                    if let baseURL = defaults.string(forKey: "baseURL") {
                        print(baseURL)
                        Constants.MainUrl=baseURL
                    }
                    else{
                        //ask from user
                        //self.showError("Get Base URL", message: "Base URL set is \(Constants.MainUrl)", button1: "Ok")
                        let alertController = UIAlertController(title: "Enter Server URL", message: "Please input your URL:", preferredStyle: .alert)
                        
                        let confirmAction = UIAlertAction(title: "Ok", style: .default) { (_) in
                            if let field = alertController.textFields![0] as? UITextField {
                                // store your data
                                Constants.MainUrl=field.text!
                                defaults.set(field.text! as! String, forKey: "baseURL")
                                // UserDefaults.standardUserDefaults.set(field.text, forKey: "userEmail")
                                // UserDefaults.standard.synchronize()
                                 self.performSegue(withIdentifier: "displaynamesegue", sender: self)
                            } else {
                                 self.performSegue(withIdentifier: "displaynamesegue", sender: self)
                                // user did not fill field
                            }
                        }
                        
                        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in
                            
                             self.performSegue(withIdentifier: "displaynamesegue", sender: self)
                        }
                        
                        alertController.addTextField { (textField) in
                            //textField.placeholder = "Email"
                            textField.text=Constants.MainUrl
                        }
                        
                        alertController.addAction(confirmAction)
                        alertController.addAction(cancelAction)
                        
                        self.navigationController?.pushViewController(alertController, animated: true) //present(alertController, animated: true, completion: nil)
                        print("not in defaults")
                    }
                    */
                    
                    
                    //restoreChatSegue
                    
                    //if backup available
                    //self.performSegue(withIdentifier: "restoreChatSegue", sender: self)
                    //else no backup
                    self.performSegue(withIdentifier: "displaynamesegue", sender: self)
                }
       
            
            }})
        
    }
    func viewController(_ viewController: UIViewController!, didCompleteLoginWithAuthorizationCode code: String!, state: String!) {
        print("Login succcess with AuthorizationCode")
        
        
    }
    
    func viewController(_ viewController: UIViewController!, didFailWithError error: NSError!) {
        print("We have an error \(error)")
        self.showError("An error has occured:", message: error.debugDescription, button1: "Ok")
        
    }
    func viewControllerDidCancel(_ viewController: UIViewController!) {
        print("The user cancel the login")
    }
    
    
    
    
    //**********
    
    @IBAction func btnConferenceStart(_ sender: AnyObject) {
        
        
        
        print("call pressed")
        //1. Create the alert controller.
        
        DispatchQueue.main.async(execute: {
            let alert = UIAlertController(title: "Welcome to Cloudkibo Meeting", message: "Please enter your username", preferredStyle: .alert)
            
            //2. Add the text field. You can configure it however you need.
            alert.addTextField(configurationHandler: { (textField) -> Void in
                textField.text = ""
            })
            
            
            //3. Grab the value from the text field, and print it when the user clicks OK.
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                let textField = alert.textFields![0] as UITextField
                username = textField.text!
                print("Text field: \(textField.text)")
                
                
                ///username = "iphoneUser"
                //iamincallWith = "webConference"
                isInitiator = false
                isConference = true
                ConferenceRoomName = self.txtForRoomName.text!
                
                
                /////////socketObj.sendMessagesOfMessageType("Conference Call")
                /*if(socketConnected == false)
                {
                socketObj.socket.connect(timeoutAfter: 5000) { () -> Void in
                
                socketObj.socket.reconnect()
                
                }
                }*/
                
                /*
                if(socketObj == nil)
                {
                print("socket is nillll22", terminator: "")
                socketObj=LoginAPI(url:"\(Constants.MainUrl)")
                //socketObj.connect()
                socketObj.addHandlers()
                socketObj.addWebRTCHandlers()
                }*/
                
                
                // ******** COMMENTING ROOM JOINING CODE MOVED TO VIDEOVIEWCONTROLLER AFTER CAMERA CAPTURE
                /* meetingStarted=true
                if(isSocketConnected==true){
                socketObj.socket.emitWithAck("init", ["room":ConferenceRoomName,"username":username!])(timeoutAfter: 1500000) {data in
                
                print("room joined by got ack")
                var a=JSON(data)
                print(a.debugDescription)
                currentID=a[1].int!
                print("current id is \(currentID)")
                print("room joined is\(ConferenceRoomName)")
                }
                }*/
                
                // ***************************************
                
                
                /*
                let next = self.storyboard!.instantiateViewControllerWithIdentifier("MainV2") as! VideoViewController
                
                self.navigationController!.presentViewController(next, animated: true, completion:nil)*/
                ////self.performSegueWithIdentifier("conferenceStartSegue", sender: nil)
                
                //***neww tryy may 2016
                let next = self.storyboard!.instantiateViewController(withIdentifier: "MainV2") as! VideoViewController
                
                self.present(next, animated: true, completion:nil)
                
                
            }))
            
            // 4. Present the alert.
            self.present(alert, animated: true, completion:
                {
                    
                    
                }
            )
            
        })
        
        
        /*
        username = "iphoneUser"
        iamincallWith = "webConference"
        isInitiator = true
        isConference = true
        ConferenceRoomName = txtForRoomName.text!
        /////////socketObj.sendMessagesOfMessageType("Conference Call")
        
        socketObj.socket.emitWithAck("init", ["room":ConferenceRoomName,"username":username!])(timeoutAfter: 150000000) {data in
        print("room joined by got ack")
        var a=JSON(data)
        print(a.debugDescription)
        currentID=a[1].int!
        print("current id is \(currentID)")
        print("room joined is\(ConferenceRoomName)")
        }
        let next = self.storyboard!.instantiateViewControllerWithIdentifier("MainV2") as! VideoViewController
        
        self.presentViewController(next, animated: true, completion:nil)
        
        */
        ////////CONFERENCE OLD CODE COMMENTED
        
        /* username = "iphoneUser"
        iamincallWith = "webConference"
        isInitiator = true
        isConference = true
        ConferenceRoomName = txtForRoomName.text!
        /////////socketObj.sendMessagesOfMessageType("Conference Call")
        
        socketObj.socket.emitWithAck("init", ["room":ConferenceRoomName,"username":username!])(timeoutAfter: 150000000) {data in
        print("room joined by got ack")
        var a=JSON(data)
        print(a.debugDescription)
        currentID=a[1].int!
        print("current id is \(currentID)")
        print("room joined is\(ConferenceRoomName)")
        }
        let next = self.storyboard!.instantiateViewControllerWithIdentifier("Main2") as! VideoViewController
        
        self.presentViewController(next, animated: true, completion:nil)
        */
    }
    
    @IBAction func btnWebmeetingStart(_ sender: AnyObject) {
        
        
        print("call pressed")
        /*if(socketConnected == false)
        {
        socketObj.socket.connect(timeoutAfter: 5000) { () -> Void in
        
        socketObj.socket.reconnect()
        
        }
        }*/
        /*if(socketObj == nil)
        {
        print("socket is nillll1", terminator: "")
        socketObj=LoginAPI(url:"\(Constants.MainUrl)")
        //socketObj.connect()
        socketObj.addHandlers()
        socketObj.addWebRTCHandlers()
        //socketObj.addWebRTCHandlersVideo()
        }*/
        meetingStarted=true
        username = "iphoneUser"
        //iamincallWith = "webConference"
        isInitiator = false
        isConference = true
        ConferenceRoomName = txtForRoomName.text!
        /////////socketObj.sendMessagesOfMessageType("Conference Call")
        if(socketObj != nil){
        var init1=socketObj.socket.emitWithAck("init.new", ["room":ConferenceRoomName,"username":username!])
            init1.timingOut(after: 1500000, callback: { (data) in
                print("room joined by got ack")
                var a=JSON(data)
                print(a.debugDescription)
                currentID=a[1].int!
                print("current id is \(currentID)")
                print("room joined is\(ConferenceRoomName)")
                joinedRoomInCall=ConferenceRoomName
                
            })
           // (timeoutAfter: 150000000) {data in
           
        //}
        }
        /// var mAudio=MeetingRoomAudio()
        ////mAudio.initAudio()
        
        
        
        // feb 2017 later
        /*
        var next = self.storyboard?.instantiateViewController(withIdentifier: "Main2") as! ConferenceCallViewController
        
        self.present(next, animated: false, completion: {
        })
 */
        
    }
    
    
    @IBOutlet weak var labelLoginUnsuccessful: UILabel!
    //var AuthToken:String=""
    var authParams:String=""
    var currentUserData:JSON=""
    var gotToken:Bool=false
    var gotUser:Bool=false
    
    
    var joinedRoom:Bool=false
    var UserDictionary:[String:AnyObject] = ["":"" as AnyObject]
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        // Custom initialization
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        ////fatalError("init(coder:) has not been implemented")
        
        super.init(coder: aDecoder)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let size = UIScreen.main.bounds.size
        viewForContent.contentSize = CGSize(width: size.width, height: 568)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Login ViewController loadeddddd")
        
        if accountKit == nil {
            // may also specify AKFResponseTypeAccessToken
            print("initialising AccountKit .......")
            accountKit = AKFAccountKit(responseType: AKFResponseType.accessToken)
        }
        
        //socketObj.delegateSocketConnected=self
        
        //*********commented coz using account kit now **************
        /*if(isSocketConnected==true)
        {socketObj.delegateSocketConnected=self
        progressWheel.stopAnimating()
        progressWheel.hidden=true
        }
        /*while(isSocketConnected==false)
        {
        if(isSocketConnected==false)
        {progressWheel.startAnimating()
        progressWheel.hidden=false
        }
        else{
        progressWheel.stopAnimating()
        progressWheel.hidden=true
        break
        }
        }*/
        /*if(isSocketConnected==false)
        {
        progressWheel.startAnimating()
        progressWheel.hidden=false
        }
        if(isSocketConnected==true)
        {
        progressWheel.stopAnimating()
        progressWheel.hidden=true
        }*/
        /* if(isSocketConnected == false)
        {
        progressWheel.startAnimating()
        }
        else{
        progressWheel.stopAnimating()
        progressWheel.hidden=true
        }*/
        /*if(socketConnected == false)
        {
        socketObj.socket.connect(timeoutAfter: 5000) { () -> Void in
        
        socketObj.socket.reconnect()
        
        }
        }*/
        if(socketObj == nil)
        {
        print("socket is nillll22", terminator: "")
        socketObj=LoginAPI(url:"\(Constants.MainUrl)")
        //socketObj.connect()
        socketObj.addHandlers()
        socketObj.addWebRTCHandlers()
        }
        
        socketObj.socket.on("connect") {data, ack in
        //  NSLog("connected to socket")
        self.progressWheel.stopAnimating()
        self.progressWheel.hidden=true
        }*/
        
        let size = UIScreen.main.bounds.size
        viewForContent.contentSize = CGSize(width: size.width, height: 568)
    
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.willShowKeyBoard(_:)), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.willHideKeyBoard(_:)), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        
        // Do any additional setup after loading the view.
    }
    
    func willShowKeyBoard(_ notification : Notification){
        
        var userInfo: NSDictionary!
        userInfo = notification.userInfo as NSDictionary!
        
        var duration : TimeInterval = 0
        var curve = userInfo.object(forKey: UIKeyboardAnimationCurveUserInfoKey) as! UInt
        duration = userInfo[UIKeyboardAnimationDurationUserInfoKey]as! TimeInterval
        let keyboardF:NSValue = userInfo.object(forKey: UIKeyboardFrameEndUserInfoKey)as! NSValue
        let keyboardFrame = keyboardF.cgRectValue
        
        UIView.animate(withDuration: duration, delay: 0, options:[], animations: {
            self.viewForContent.contentOffset = CGPoint(x: 0, y: keyboardFrame.size.height)
            
            }, completion: nil)
        
    }
    
    func willHideKeyBoard(_ notification : Notification){
        
        var userInfo: NSDictionary!
        userInfo = notification.userInfo as NSDictionary!
        
        var duration : TimeInterval = 0
        var curve = userInfo.object(forKey: UIKeyboardAnimationCurveUserInfoKey) as! UInt
        duration = userInfo[UIKeyboardAnimationDurationUserInfoKey]as! TimeInterval
        let keyboardF:NSValue = userInfo.object(forKey: UIKeyboardFrameEndUserInfoKey) as! NSValue
        var keyboardFrame = keyboardF.cgRectValue
        
        UIView.animate(withDuration: duration, delay: 0, options:[], animations: {
            self.viewForContent.contentOffset = CGPoint(x: 0, y: 0)
            
            }, completion: nil)
        
    }
    
    func textFieldShouldReturn (_ textField: UITextField) -> Bool{
        if ((textField == txtForEmail)){
            txtForPassword.becomeFirstResponder();
        } else if (textField == txtForPassword){
            textField.resignFirstResponder()
        }
        textField.resignFirstResponder()
        return true
    }
    
    
    
    func prepareLoginViewController(_ loginViewController: AKFViewController) {
        
        loginViewController.delegate = self
        loginViewController.advancedUIManager = nil
        
        //Costumize the theme
        let theme:AKFTheme = AKFTheme.default()
        theme.headerBackgroundColor = UIColor(red: 0.325, green: 0.557, blue: 1, alpha: 1)
        theme.headerTextColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        theme.iconColor = UIColor(red: 0.325, green: 0.557, blue: 1, alpha: 1)
        theme.inputTextColor = UIColor(white: 0.4, alpha: 1.0)
        theme.statusBarStyle = .default
        theme.textColor = UIColor(white: 0.3, alpha: 1.0)
        theme.titleColor = UIColor(red: 0.247, green: 0.247, blue: 0.247, alpha: 1)
        loginViewController.theme = theme
        
        
    }
    /*func showError(title:String,message:String,button1:String) {
        
        // create the alert
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        
        // add the actions (buttons)
        alert.addAction(UIAlertAction(title: button1, style: UIAlertActionStyle.Default, handler: nil))
        //alert.addAction(UIAlertAction(title: button2, style: UIAlertActionStyle.Cancel, handler: nil))
        
        //==--let tabBarController = window?.rootViewController as? UITabBarController
        
        //  let navigationController = UIApplication.sharedApplication().windows[0].rootViewController as! UINavigationController
        
        // show the alert
        //=-- let activeViewCont = navigationController.visibleViewController
        
        self.presentViewController(alert, animated: true, completion: nil)
        
        
        //=--tabBarController!.presentViewController(alert, animated: true, completion: nil)
    }*/
    @IBAction func loginBtnTapped() {
        
        
        
        
        //login with Phone
        //%%%%%%%%%%%%%%%%%%%% new firsttimelogin ...
       
        /*print("...sfsfsf\(UIApplication.sharedApplication().isRegisteredForRemoteNotifications())")
    
        let notificationTypes: UIUserNotificationType = [/*UIUserNotificationType.Alert, */UIUserNotificationType.Badge, UIUserNotificationType.Sound]
        
        
        let pushNotificationSettings = UIUserNotificationSettings(forTypes: notificationTypes, categories: nil)
        
        UIApplication.sharedApplication().registerUserNotificationSettings(pushNotificationSettings)
        */
    //   if(UIApplication.sharedApplication().isRegisteredForRemoteNotifications())
    // {
           firstTimeLogin=true
            print("okkk")
        let inputState: String = UUID().uuidString
        let viewController:AKFViewController = accountKit.viewControllerForPhoneLogin(with: nil, state: inputState)  as! AKFViewController
        viewController.enableSendToFacebook = true
        self.prepareLoginViewController(viewController)
        self.present(viewController as! UIViewController, animated: true, completion: nil)
       /* }
        else{
            
            
            let notificationTypes: UIUserNotificationType = [/*UIUserNotificationType.Alert, */UIUserNotificationType.Badge, UIUserNotificationType.Sound]
        
            
            let pushNotificationSettings = UIUserNotificationSettings(forTypes: notificationTypes, categories: nil)
            
            UIApplication.sharedApplication().registerUserNotificationSettings(pushNotificationSettings)
            
           //==--- self.showError("Error",message: "You must allow Remote notifications to continue",button1: "Ok")
            
            
}*/
        
        
        //============================ Authenticate User ================
        
        //%%%%%%%%% new phone model already login done
        /*var url=Constants.MainUrl+Constants.authentictionUrl
        KeychainWrapper.setString(txtForPassword.text!, forKey: "password")
        password=KeychainWrapper.stringForKey("password")
        var param:[String:String]=["username": txtForEmail.text!,"password":txtForPassword.text!]
        Alamofire.request(.POST,"\(url)",parameters: param).response{
        request, response_, _data, error in
        print(error)
        
        if response_?.statusCode==200
        
        {
        */
        //^^^^^username=txtForEmail.text!
        
        
        
        //%%%%%%%%% new phone model already login done
        /*
        print("login success")
        self.labelLoginUnsuccessful.text=nil
        self.gotToken=true
        
        //======GETTING REST API TO GET CURRENT USER=======================
        
        var userDataUrl=Constants.MainUrl+Constants.getCurrentUser
        //let index: String.Index = advance(self.AuthToken.startIndex, 10)
        
        //======================STORING Token========================
        
        //%%%%% already set token
        /*let jsonLogin = JSON(data: _data!)
        let token = jsonLogin["token"]
        KeychainWrapper.setString(token.string!, forKey: "access_token")
        AuthToken=token.string!
        */
        //========GET USER DETAILS===============
        //%%%% new phone model
        //var getUserDataURL=userDataUrl+"?access_token="+AuthToken!
        
        var getUserDataURL=userDataUrl

        Alamofire.request(.GET,"\(getUserDataURL)",headers:header).validate(statusCode: 200..<300).responseJSON{response in
        
        
        switch response.result {
        case .Success:
        if let data1 = response.result.value {
        let json = JSON(data1)
        print("JSON: \(json)")
        dispatch_async(dispatch_get_main_queue(), {
        
        self.dismiss(true, completion: nil);
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
        }
        

            
            //%%%%%% new phone model login done

            /*}
    }
        else
        {self.labelLoginUnsuccessful.text="Please enter valid username/password"
        self.txtForEmail.text=nil
        self.txtForPassword.text=nil
        
        print("GOT USER FAILED")
        
        }*/
        }
        
        */
        
        
        
        /*
        let response1=response.response
        let request1=response.request
        let data1=response.data
        let error1=response.result.error
        //===========INITIALISE SOCKETIOCLIENT=========
        dispatch_async(dispatch_get_main_queue(), {
        
        self.dismiss(true, completion: nil);
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
        self.dismiss(animated: true, completion: nil);
    }
    
    @IBAction func twitterBtnTapped() {
        self.dismiss(animated: true, completion: nil);
    }
    
    @IBAction func forgotPasswordBtnTapped() {
        self.dismiss(animated: true, completion: nil);
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
        
        
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return true
        
        
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
        
        
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        return true
        
        
    }
    func socketConnected() {
        print("connected delegate in login ")
        if(self.isViewLoaded || (self.view.window != nil))
        {
            print("progress wheel stopping")
            if(socketObj != nil){
            socketObj.delegateSocketConnected=self
            }
            //if(progressWheel != nil){
            self.progressWheel.stopAnimating()
            self.progressWheel.isHidden=true
            //}
            
        }
    }
    /*override func viewWillDisappear(animated: Bool) {
    super.viewWillDisappear(false)
    print("disappearing loginview")
    if (self.isMovingFromParentViewController())
    {
    if ((self.navigationController!.delegate?.isEqual(self)) != nil)
    {print("removing delegate")
    self.navigationController!.delegate = nil;
    }
    }
    }*/
    // #pragma mark - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    /* override func prepareForSegue(segue: UIStoryboardSegue?, sender: AnyObject?) {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if segue!.identifier == "loginSegue" {
    if let destinationVC = segue!.destinationViewController as? ChatViewController{
    destinationVC.firstTimeLogin=true
    print("firsttimeloginn yesss")
    //destinationVC.AuthToken = AuthToken
    //destinationVC.contactsJsonObj=self.contactsJsonObj
    }
    }
    }*/
    
    func showError(_ title:String,message:String,button1:String) {
        
        // create the alert
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        // add the actions (buttons)
        alert.addAction(UIAlertAction(title: button1, style: UIAlertActionStyle.default, handler: nil))
        //alert.addAction(UIAlertAction(title: button2, style: UIAlertActionStyle.Cancel, handler: nil))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        print("dismissed loginnnnn")
        if(socketObj != nil)
{
        socketObj.delegateSocketConnected=nil
}
        //%%%%%%%% commented firsttimelogin
        //firstTimeLogin=true
        print("firsttimeloginn yesss")
    }
    
}

