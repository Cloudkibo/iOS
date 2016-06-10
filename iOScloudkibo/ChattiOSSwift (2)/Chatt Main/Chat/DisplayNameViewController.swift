//
//  DisplayNameViewController.swift
//  kiboApp
//
//  Created by Cloudkibo on 02/06/2016.
//  Copyright © 2016 MyAppTemplates. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import ContactsUI
import AccountKit
import SQLite

class DisplayNameViewController: UIViewController {
    
    
    @IBOutlet weak var txtDisplayName: UITextField!
    var messageFrame = UIView()
    var activityIndicator = UIActivityIndicatorView()
    var strLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func progressBarDisplayer(msg:String, _ indicator:Bool ) {
        print(msg)
        strLabel = UILabel(frame: CGRect(x: 50, y: 0, width: 250, height: 50))
        strLabel.text = msg
        strLabel.textColor = UIColor.whiteColor()
        messageFrame = UIView(frame: CGRect(x: view.frame.midX - 110, y: view.frame.midY - 25 , width: 230, height: 50))
        messageFrame.layer.cornerRadius = 15
        messageFrame.backgroundColor = UIColor(white: 0, alpha: 0.7)
        if indicator {
            activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.White)
            activityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
            activityIndicator.startAnimating()
            messageFrame.addSubview(activityIndicator)
        }
        messageFrame.addSubview(strLabel)
        view.addSubview(messageFrame)
    }
    
    
    
    func sendNameToServer(var displayName:String)
    {
        progressBarDisplayer("Contacting Server", true)
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            // do some task start to show progress wheel
            
            var urlToSendDisplayName=Constants.MainUrl+Constants.firstTimeLogin
            var nn="{display_name:displayName}"
            //var getUserDataURL=userDataUrl
            
            socketObj.socket.emit("logClient", "")
            Alamofire.request(.POST,"\(urlToSendDisplayName)",headers:header,parameters:["display_name":displayName]).responseJSON{
                response in
                
                //===========INITIALISE SOCKETIOCLIENT=========
               // dispatch_async(dispatch_get_main_queue(), {
                    
                    //self.dismissViewControllerAnimated(true, completion: nil);
                    /// self.performSegueWithIdentifier("loginSegue", sender: nil)
                    
                
            
          /*  Alamofire.request(.GET,"\(urlToSendDisplayName)",headers:header,parameters:["display_name":displayName])
                .validate(statusCode: 200..<300)
                .response { (request, response, data, error) in
                    
                    */
                    
                    print(response.data?.debugDescription)
                    
                    print("display name is \(displayName)")
                    /*Alamofire.request(.GET,"\(urlToSendDisplayName)",headers:header,parameters:["display_name":"\(displayName)"]).validate(statusCode: 200..<300).responseJSON{response in
                */
                
                    switch response.result {
                        
                        
                        
                    case .Success:
                        print("display name sent to server")
                        firstTimeLogin=false
                        socketObj.socket.emit("logClient", "display name \(displayName) sent to server successfully")
                        //print(response.data)
                        //let json = JSON(data!)
                        //print("JSON: \(json)")
                        //%%%%%*******************
                        firstTimeLogin=false
                        
                        //////// %%%%%%%%%%%%%%***************self.performSegueWithIdentifier("fetchContactsSegue", sender: self)
                        //self.performSegueWithIdentifier("fetchaddressbooksegue", sender: self)
                        //*********************%%%%%%%%%%%%%%%%%%%%%%%%% commented new
                        
                        //%%%%%%%%%%%%%%%% new logic commented -------------
                        /*
                        dispatch_async(dispatch_get_main_queue()) {
                            // update some UI
                            //remove progress wheel
                            print("got server response")
                            self.messageFrame.removeFromSuperview()
                            self.fetchContactsFromDevice(){ (result) -> () in
                                socketObj.socket.emit("logClient","contacts fetched from device")
                                for cc in contacts{
                                    sqliteDB.saveAllContacts(cc, kiboContact1: false)
                                }
                             

                            //move to next screen
                            //self.saveButton.enabled = true
                        }

                        
                                               }*/
                        //%%%%%%%%%%%%%%%%_----
                        self.dismissViewControllerAnimated(false, completion: { () -> Void in
                            
                            print("logged in going to contactlist")
                        })
                        
                        
                        //self.performSegueWithIdentifier(<#T##identifier: String##String#>, sender: <#T##AnyObject?#>)
                        
                   case .Failure(let error):
                       print(error)
                        socketObj.socket.emit("logClient","\(error)")
                        
                    
                    
                    
                    
                    //when server sends response:
                    
            }
        
        
        
    }
        }
    }
    
    func fetchContactsFromDevice(completion: (result:Bool)->())
    {
       // self.messageFrame.removeFromSuperview()
        //progressBarDisplayer("Fetching Contacts", true)
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
                    contactsList.fetch(){ (result) -> () in
                        print("got contacts from device")
                       
                        socketObj.socket.emit("logClient", "done fetched contacts from iphone")
                        for r in result
                        {
                            //get phones and append phones in list
                            emailList.append(r)
                        }
                        
                        
                        dispatch_async(dispatch_get_main_queue()) {
                            // update some UI
                            //remove progress wheel
                            print("got server response")
                            socketObj.socket.emit("logClient", "Got contacts List from device")
                            self.messageFrame.removeFromSuperview()
                            completion(result: true)
                            //move to next screen
                            //self.saveButton.enabled = true
                        }
                        
                        
            }
        }
    }
    
                        //emailList = result
                        /*socketObj.socket.emit("logClient", "getting contacts from cloudkibo server")
                        ///// %%%%%%%%%%%%%%%%%% contactsList.searchContactsByEmail(emailList){ (result2) -> () in
                        
                        contactsList.searchContactsByPhone(emailList){ (result2) -> () in
                            
                            
                            
                            dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) {
                                // do some task start to show progress wheel
                                self.fetchContactsFromServer()
                                
                                
                                
                                socketObj.socket.emit("logClient","login success and AuthToken was not nil getting myself details from server")
                                
                                print("login success")
                                //self.labelLoginUnsuccessful.text=nil
                                //self.gotToken=true
                                
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
                                            
                                            //%%%%%%%% commenting it for a while phone model
                                            //self.dismissViewControllerAnimated(true, completion: nil);
                                            print("got user success")
                                            //self.gotToken=true
                                            //var json=JSON(data1)
                                            //KeychainWrapper.setData(data1!, forKey: "loggedUserObj")
                                            //loggedUserObj=json(loggedUserObj)
                                            
                                            // if let u = json["phone"].string
                                            // {
                                            username=json["phone"].string
                                            ////}
                                            
                                            /* if let u = json["username"].string
                                            {
                                            username=u
                                            }
                                            else
                                            {
                                            username=json["display_name"].string!
                                            }*/
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
                                            dispatch_async(dispatch_get_main_queue(), {
                                                if let uu = json["username"].string
                                                {
                                                    do{
                                                        try KeychainWrapper.setString(json["phone"].string!, forKey: "username")
                                                        try KeychainWrapper.setString(json["display_name"].string!, forKey: "loggedFullName")
                                                        try KeychainWrapper.setString(json["phone"].string!, forKey: "loggedPhone")
                                                        try KeychainWrapper.setString(json["email"].string!, forKey: "loggedEmail")
                                                        try KeychainWrapper.setString(json["_id"].string!, forKey: "_id")
                                                        
                                                        //%%%% new phone model
                                                        // try KeychainWrapper.setString(self.txtForPassword.text!, forKey: "password")
                                                        try KeychainWrapper.setString("", forKey: "password")
                                                        
                                                        
                                                    }
                                                    catch{
                                                        print("error is setting keychain value")
                                                        print(json.error?.localizedDescription)
                                                    }
                                                }
                                                else
                                                {
                                                    do{
                                                        try KeychainWrapper.setString(json["phone"].string!, forKey: "username")
                                                        /// try KeychainWrapper.setString(json["display_name"].string!, forKey: "username")
                                                        try KeychainWrapper.setString(json["display_name"].string!, forKey: "loggedFullName")
                                                        try KeychainWrapper.setString(json["phone"].string!, forKey: "loggedPhone")
                                                        try KeychainWrapper.setString("", forKey: "loggedEmail")
                                                        try KeychainWrapper.setString(json["_id"].string!, forKey: "_id")
                                                        
                                                        //%%%% new phone model
                                                        // try KeychainWrapper.setString(self.txtForPassword.text!, forKey: "password")
                                                        try KeychainWrapper.setString("", forKey: "password")
                                                        
                                                        
                                                    }
                                                    catch{
                                                        print("error is setting keychain value")
                                                        print(json.error?.localizedDescription)
                                                    }
                                                    
                                                    
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
                                                let username1 = Expression<String>("username")
                                                let status = Expression<String>("status")
                                                let date = Expression<String>("date")
                                                let accountVerified = Expression<String>("accountVerified")
                                                let role = Expression<String>("role")
                                                
                                                
                                                // let insert = users.insert(email <- "alice@mac.com")
                                                
                                                
                                                tbl_accounts.delete()
                                                do {
                                                    if(json["username"].string != nil)
                                                    {
                                                        let rowid = try sqliteDB.db.run(tbl_accounts.insert(_id<-json["_id"].string!,
                                                            firstname<-json["firstname"].string!,
                                                            lastname<-json["lastname"].string!,
                                                            email<-json["email"].string!,
                                                            username1<-json["phone"].string!,
                                                            status<-json["status"].string!,
                                                            phone<-json["phone"].string!))
                                                        print("inserted id: \(rowid)")
                                                    }
                                                    else
                                                    {
                                                        let rowid = try sqliteDB.db.run(tbl_accounts.insert(_id<-json["_id"].string!,
                                                            firstname<-json["display_name"].string!,
                                                            lastname<-"",
                                                            email<-"",
                                                            username1<-json["phone"].string!,
                                                            status<-json["status"].string!,
                                                            phone<-json["phone"].string!))
                                                        print("inserted id: \(rowid)")
                                                    }
                                                } catch {
                                                    print("insertion failed: \(error)")
                                                }
                                               
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
                                        
                                        socketObj.socket.emit("logClient","error in logging in  \(error)")
                                        print("GOT USER FAILED \(error)")
                                        
                                        
                                        print(error)
                                        print("error: \(error.localizedDescription)")
                                    }
                                  
                                }
                            }
                            
                            
                            
                            
                            socketObj.socket.emit("logClient", "received contacts from cloudkibo server")
                            for r2 in result2
                            {
                                notAvailableEmails.append(r2)
                                
                                //notAvailableEmails=result2
                                //dispatch_async(dispatch_get_main_queue()) { () -> Void in
                                //%%%%%%%%*********
                                
                                
                                ////self.tblForChat.reloadData()
                            }
                            dispatch_async(dispatch_get_main_queue(), {
                                
                                if(nameList.count>1||displayname=="")
                                {
                                    
                                    
                                    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) {
                                        // do some task start to show progress wheel
                                        self.fetchContacts()
                                        //self.fetchContactsFromServer()
                                        dispatch_async(dispatch_get_main_queue()) {
                                            self.tblForChat.reloadData()
                                        }
                                    }
                                    
                                }
                                
                                self.tblForChat.reloadData()
                            })
                        }
                        
                        ///
                        
                    }
        
            
            
            // dispatch_async(dispatch_get_main_queue(), {
            ///////////newwwwwwwwwwwww
            // %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            if(nameList.count>1||displayname=="")
            {
                
                
                dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) {
                    // do some task start to show progress wheel
                    self.fetchContacts()
                    //self.fetchContactsFromServer()
                    dispatch_async(dispatch_get_main_queue()) {
                        self.tblForChat.reloadData()
                    }
                }
                
            }
    
            
            
        }
        
    }*/
    func sendPhoneNumbersToServer(completion: (result:Bool)->())
    {
        self.messageFrame.removeFromSuperview()
        progressBarDisplayer("Fetching Contacts", true)
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            contactsList.searchContactsByPhone(emailList){ (result2) -> () in
                
                dispatch_async(dispatch_get_main_queue()) {
                    // update some UI
                    //remove progress wheel
                    print("got server response")
                    socketObj.socket.emit("logClient", "Got contacts List from device")
                    self.messageFrame.removeFromSuperview()
                    completion(result: true)
                }
                
            }
            
        }
        
    }
    func fetchContactsListFromServer(completion: (result:Bool)->())
    {
        
    }
    func SaveContactsListInSqliteDB(completion: (result:Bool)->())
    {
        
    }
    func fetchChatsFromServer(completion: (result:Bool)->())
    {
        
    }
    func SaveChatInSQliteDB(completion: (result:Bool)->())
    {
        
    }
    func goToContactsPage(completion: (result:Bool)->())
    {
        
    }
    
    @IBAction func btnDonePressed(sender: AnyObject) {
        var displayName=txtDisplayName.text!
       // appJustInstalled=[true]
        if(accountKit!.currentAccessToken != nil)
        {
        header=["kibo-token":accountKit!.currentAccessToken!.tokenString]
        }
        displayname=displayName
        self.sendNameToServer(displayName)
    }
}

protocol initialSettingsProtocol:class
{
    func didLoginFirstTime();

}

    /*
    func sendNameToServer(var displayName:String)
    {
        progressBarDisplayer("Contacting Server", true)
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            // do some task start to show progress wheel
            
            var urlToSendDisplayName=Constants.MainUrl+Constants.firstTimeLogin
            //var nn="{display_name:displayName}"
            //var getUserDataURL=userDataUrl
            
            
            
            socketObj.socket.emit("logClient", "contacting server to register user(if new)")
            Alamofire.request(.GET,"\(urlToSendDisplayName)",headers:header,parameters:["display_name":displayName])
                .validate(statusCode: 200..<300)
                .response { (request, response, data, error) in
                    
                    
                    socketObj.socket.emit("logClient","got server response ..")
                    username=displayName
                    displayname=displayName
                    print("display name is \(displayName)")
                    /*Alamofire.request(.GET,"\(urlToSendDisplayName)",headers:header,parameters:["display_name":"\(displayName)"]).validate(statusCode: 200..<300).responseJSON{response in
                    */
                    dispatch_async(dispatch_get_main_queue()) {
                        // update some UI
                        //remove progress wheel
                        print("got server response")
                        self.messageFrame.removeFromSuperview()
                        //move to next screen
                        //self.saveButton.enabled = true
                    }
                    
                    print(data?.debugDescription)
                    switch response!.statusCode {
                        
                    case 200:
                        print("display name sent to server")
                        firstTimeLogin=false
                        socketObj.socket.emit("logClient", "display name \(displayName) sent to server successfully")
                        print(data)
                        
                        let json = JSON(data!)
                        
                        print("JSON: \(json[0].debugDescription)")
                        print("data: \(json.debugDescription)")
                        
                        
                        //%%%%%*******************
                        firstTimeLogin=false
                        
                        //////// %%%%%%%%%%%%%%***************self.performSegueWithIdentifier("fetchContactsSegue", sender: self)
                        //self.performSegueWithIdentifier("fetchaddressbooksegue", sender: self)
                        //*********************%%%%%%%%%%%%%%%%%%%%%%%%% commented new
                        
                        self.dismissViewControllerAnimated(false, completion: { () -> Void in
                            
                            print("logged in going to contactlist")
                        })
                        
                        
                        //self.performSegueWithIdentifier(<#T##identifier: String##String#>, sender: <#T##AnyObject?#>)
                        
                    default:
                        print(error)
                        socketObj.socket.emit("logClient","error in display name routine \(error)")
                        
                        
                    }
                    
                    
                    
                    //when server sends response:
                    
            }
        }
        
        
    }
    
    */
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */




/*
// MARK: - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
// Get the new view controller using segue.destinationViewController.
// Pass the selected object to the new view controller.
}
*/

*/
