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
    
    
    var Q0_sendDisplayName=dispatch_queue_create("Q0_sendDisplayName",DISPATCH_QUEUE_SERIAL)
    var Q1_fetchFromDevice=dispatch_queue_create("fetchFromDevice",DISPATCH_QUEUE_SERIAL)
    var Q2_sendPhonesToServer=dispatch_queue_create("sendPhonesToServer",DISPATCH_QUEUE_SERIAL)
    var Q3_getContactsFromServer=dispatch_queue_create("getContactsFromServer",DISPATCH_QUEUE_SERIAL)
    var Q4_getUserData=dispatch_queue_create("getUserData",DISPATCH_QUEUE_SERIAL)
    var Q5_fetchAllChats=dispatch_queue_create("fetchAllChats",DISPATCH_QUEUE_SERIAL)
    
    var accountKit: AKFAccountKit!
    @IBOutlet weak var txtDisplayName: UITextField!
    var messageFrame = UIView()
    var activityIndicator = UIActivityIndicatorView()
    var strLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(self.accountKit == nil){
            self.accountKit = AKFAccountKit(responseType: AKFResponseType.AccessToken)
        }
        
        if (self.accountKit!.currentAccessToken == nil) {
            
            //specify AKFResponseType.AccessToken
            self.accountKit = AKFAccountKit(responseType: AKFResponseType.AccessToken)
            accountKit.requestAccount{
                (account, error) -> Void in
                
                
                
                
                //**********
                
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
                    //CountryCode=account?.phoneNumber?.countryCode
                    
                }
                
            }}
        
        
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
    
    
    
    func sendNameToServer(var displayName:String,completion:(result:Bool)->())
    {
       // progressBarDisplayer("Contacting Server", true)
        //let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        
        //dispatch_async(dispatch_get_global_queue(priority, 0)) {
            // do some task start to show progress wheel
            
            var urlToSendDisplayName=Constants.MainUrl+Constants.firstTimeLogin
            var nn="{display_name:displayName}"
            //var getUserDataURL=userDataUrl
            
            socketObj.socket.emit("logClient", "")
            
            Alamofire.request(.POST,"\(urlToSendDisplayName)",headers:header,parameters:["display_name":displayName]).responseJSON{
                response in
                
                
                    print(response.data?.debugDescription)
                    
                    print("display name is \(displayName)")
                    /*Alamofire.request(.GET,"\(urlToSendDisplayName)",headers:header,parameters:["display_name":"\(displayName)"]).validate(statusCode: 200..<300).responseJSON{response in
                */
                
                    switch response.result {
                        
                        
                        
                    case .Success:
                        print("display name sent to server")
                        firstTimeLogin=false
                        socketObj.socket.emit("logClient", "display name \(displayName) sent to server successfully")
                    
                        return completion(result: true)
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
                                socketObj.socket.emit("logClient","IPHONE-LOG: contacts fetched from device")
                                for cc in contacts{
                                    sqliteDB.saveAllContacts(cc, kiboContact1: false)
                                }
                             

                            //move to next screen
                            //self.saveButton.enabled = true
                        }

                        
                                               }*/
                        //%%%%%%%%%%%%%%%%_----
                        
                        
                        /////%%%%%%% important new commented %%%%%%%%%
                        
                        /*self.dismissViewControllerAnimated(false, completion: { () -> Void in
                            
                            print("logged in going to contactlist")
                        })*/
                        
                        
                        //self.performSegueWithIdentifier(<#T##identifier: String##String#>, sender: <#T##AnyObject?#>)
                        
                   case .Failure(let error):
                       print(error)
                        socketObj.socket.emit("logClient","IPHONE-LOG: \(error)")
                        
                    
                    
                    
                    
                    //when server sends response:
                    
            }
        
        
        
    }
       // }
    }
    
    func fetchContactsFromDevice(completion: (result:Bool)->())
    {
                    contactsList.fetch(){ (result) -> () in
                        print("got contacts from device")
                       
                        socketObj.socket.emit("logClient", "done fetched contacts from iphone")
                        for r in result
                        {
                            //get phones and append phones in list
                            emailList.append(r)
                        }
                        completion(result: true)
            }
    }
    
    
    
    func sendPhoneNumbersToServer(completion: (result:Bool)->())
    {
        contactsList.searchContactsByPhone(emailList)
            { (result2) -> () in
                socketObj.socket.emit("logClient", "received contacts from cloudkibo server")
                for r2 in result2
                {
                    notAvailableEmails.append(r2)
                    
                }
                
                completion(result: true)
            }
        
    }
    
    
    
    func fetchContactsFromServer(completion:(result:Bool)->()){
        print("Server fetchingg contactss", terminator: "")
        socketObj.socket.emit("logClient","IPHONE-LOG: fetch contacts from server")
        if(loggedUserObj == JSON("[]"))
        {
        }
        
        //%%%%% new phone model
        //var fetchChatURL=Constants.MainUrl+Constants.getContactsList+"?access_token="+AuthToken!
        
        var fetchChatURL=Constants.MainUrl+Constants.getContactsList
        
        print(fetchChatURL, terminator: "")
        
        //%%%%% new phone model
        //Alamofire.request(.GET,"\(fetchChatURL)").validate(statusCode: 200..<300)
        header=["kibo-token":self.accountKit!.currentAccessToken!.tokenString]
        print("header iss \(header)")
        Alamofire.request(.GET,"\(fetchChatURL)",headers:header).validate(statusCode: 200..<300)
            .response { (request1, response1, data1, error1) in
                
                
                
                
                if response1?.statusCode==200 {
                    //============GOT Contacts SECCESS=================
                    
                    
                    print("success successfully received friends list from server")
                    socketObj.socket.emit("logClient","IPHONE-LOG:  successfully received friends list from server")
                    if(globalChatRoomJoined == false)
                    {
                        //socketObj.addHandlers()
                        print("joiningggggg")
                        
                        
                    }
                    //print("Contacts fetched success")
                    let contactsJsonObj = JSON(data: data1!)
                    print(contactsJsonObj)
                    //print(contactsJsonObj["userid"])
                    //let contact=JSON(contactsJsonObj["contactid"])
                    //   print(contact["firstname"])
                    print("Contactsss fetcheddddddd")
                    //var userr=contactsJsonObj["userid"]
                    // print(self.contactsJsonObj.count)
                    let contactid = Expression<String>("contactid")
                    let detailsshared = Expression<String>("detailsshared")
                    
                    let unreadMessage = Expression<Bool>("unreadMessage")
                    
                    let userid = Expression<String>("userid")
                    let firstname = Expression<String>("firstname")
                    let lastname = Expression<String>("lastname")
                    let email = Expression<String>("email")
                    let phone = Expression<String>("phone")
                    let username = Expression<String>("username")
                    let status = Expression<String>("status")
                    
                    
                    let tbl_contactslists=sqliteDB.contactslists
                    /////////newwwwwwwww///////
                    do{try sqliteDB.db.run(tbl_contactslists.delete())}catch{
                        print("contactslist table not deleted")
                    }
                    ////////////////
                    ///tbl_contactslists.delete() //complete refresh
                    ////////////////////////////////////////COUNTTTTTTT
                    print(sqliteDB.contactslists.count)
                    
                
                    
                    //////
                    for var i=0;i<contactsJsonObj.count;i++
                    {
                        print("inside for loop")
                        do {
                            if(contactsJsonObj[i]["contactid"]["username"].string != nil)
                            {
                                print("inside username hereeeeeee")
                                let rowid = try sqliteDB.db.run(tbl_contactslists.insert(contactid<-contactsJsonObj[i]["contactid"]["_id"].string!,
                                    detailsshared<-contactsJsonObj[i]["detailsshared"].string!,
                                    
                                    unreadMessage<-contactsJsonObj[i]["unreadMessage"].boolValue,
                                    
                                    userid<-contactsJsonObj[i]["userid"].string!,
                                    firstname<-contactsJsonObj[i]["contactid"]["firstname"].string!,
                                    lastname<-contactsJsonObj[i]["contactid"]["lastname"].string!,
                                    email<-contactsJsonObj[i]["contactid"]["email"].string!,
                                    phone<-contactsJsonObj[i]["contactid"]["phone"].string!,
                                    username<-contactsJsonObj[i]["contactid"]["username"].string!,
                                    status<-contactsJsonObj[i]["contactid"]["status"].string!)
                                )
                                print("data inserttt")
                                
                                //=========this is done in fetching from sqlite not here====
                                
                                
                                // %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%new commented june
                              
                                
                                print("inserted id: \(rowid)")
                            }
                            else
                            {
                                print("inside displayname hereeeeeee")
                                
                                
                                let rowid = try sqliteDB.db.run(tbl_contactslists.insert(contactid<-contactsJsonObj[i]["contactid"]["_id"].string!,
                                    detailsshared<-contactsJsonObj[i]["detailsshared"].string!,
                                    
                                    unreadMessage<-contactsJsonObj[i]["unreadMessage"].boolValue,
                                    
                                    userid<-contactsJsonObj[i]["userid"].string!,
                                    firstname<-contactsJsonObj[i]["contactid"]["display_name"].string!,
                                    lastname<-"",
                                    
                                    //lastname<-contactsJsonObj[i]["contactid"]["lastname"].string!,
                                    email<-"@",
                                    phone<-contactsJsonObj[i]["contactid"]["phone"].string!,
                                    username<-contactsJsonObj[i]["contactid"]["phone"].string!,
                                    status<-contactsJsonObj[i]["contactid"]["status"].string!)
                                )
                           
                                print("inserted id: \(rowid)")
                                
                            }
                            
                        } catch {
                            print("insertion failed: \(error)")
                        }
                        
                    }
                    
                    print("contacts fetchedddddddddddddd sucecess")
                    
                    
                    completion(result:true)
                    
                }else{
                    
                    completion(result:false)
                    
                    print("error: \(error1!.localizedDescription)")
                    socketObj.socket.emit("logClient", "error: \(error1!.localizedDescription)")
                    print(error1)
                    print(response1?.statusCode)
                    print("FETCH CONTACTS FAILED")
                    print("eeeeeeeeeeeeeeeeeeeeee")
                    
                }
                if(response1?.statusCode==401)
                {
                    socketObj.socket.emit("logClient", "error: \(error1!.localizedDescription)")
                    print("Refreshinggggggggggggggggggg token expired")
                    if(username==nil || password==nil)
                    {print("line # 1074")
                        self.performSegueWithIdentifier("loginSegue", sender: nil)
                    }
                    
                    /*else{
                        self.rt.refrToken()
                    }*/
                    
                }
                
        }
        
        
        
    }

    func getCurrentUserDetails(completion: (result:Bool)->())
    {
        
        socketObj.socket.emit("logClient","IPHONE-LOG: login success and AuthToken was not nil getting myself details from server")
        
        print("login success")
        
        //======GETTING REST API TO GET CURRENT USER=======================
        
        var userDataUrl=Constants.MainUrl+Constants.getCurrentUser
        
        
        var getUserDataURL=userDataUrl
        
        Alamofire.request(.GET,"\(getUserDataURL)",headers:header).validate(statusCode: 200..<300).responseJSON{response in
            
            
            switch response.result {
            case .Success:
                if let data1 = response.result.value {
                    let json = JSON(data1)
                    print("JSON: \(json)")
                    
                    print("got user success")
                   
                    username=json["phone"].string
                    loggedUserObj=json
                    KeychainWrapper.setString(loggedUserObj.description, forKey:"loggedUserObjString")
                    var loggedobjstring=KeychainWrapper.stringForKey("loggedUserObjString")
                    
                    socketObj.socket.emit("logClient","IPHONE-LOG: keychain of loggedUserObjString is \(loggedobjstring)")
                    
                    print(loggedUserObj.debugDescription)
                    print(loggedUserObj.object)
                    print("$$$$$$$$$$$$$$$$$$$$$$$$$")
                    print("************************")
                    
                            do{
                             //   try KeychainWrapper.setObject(json., forKey: "userobject")
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
                    
                        
                        var jsonNew=JSON("{\"room\": \"globalchatroom\",\"user\": {\"username\":\"sabachanna\"}}")
                        //socketObj.socket.emit("join global chatroom", ["room": "globalchatroom", "user": ["username":"sabachanna"]]) WORKINGGG
                        
                        socketObj.socket.emit("logClient","IPHONE-LOG: \(username!) is joining room room:globalchatroom, user: \(json.object)")
                        socketObj.socket.emit("join global chatroom",["room": "globalchatroom", "user": json.object])
                        
                        print(json["_id"])
                        
                        
                        
                        let tbl_accounts = sqliteDB.accounts
                        
                        do{
                            
                            try sqliteDB.db.run(tbl_accounts.delete())
                        }catch{
                            socketObj.socket.emit("logClient","accounts table not deleted")
                            print("accounts table not deleted")
                        }
                        
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
                    let country_prefix = Expression<String>("country_prefix")
                    let nationalNumber = Expression<String>("national_number")
                        
                        // let insert = users.insert(email <- "alice@mac.com")
                        
                        
                        tbl_accounts.delete()
                        
                        do {
                            let rowid = try sqliteDB.db.run(tbl_accounts.insert(_id<-json["_id"].string!,
                                //firstname<-json["firstname"].string!,
                                firstname<-json["display_name"].string!,
                                country_prefix<-json["country_prefix"].string!,
                                nationalNumber<-json["national_number"].string!,
                                //country_prefix
                                //lastname<-"",
                                //lastname<-json["lastname"].string!,
                                //email<-json["email"].string!,
                                username1<-json["phone"].string!,
                                status<-json["status"].string!,
                                phone<-json["phone"].string!))
                            print("inserted id: \(rowid)")
                            
                            return completion(result:true)
                            
                        } catch {
                            print("insertion failed: \(error)")
                        }
                        
                        
                        do{for account in try sqliteDB.db.prepare(tbl_accounts) {
                            print("id: \(account[_id]), phone: \(account[phone]), firstname: \(account[firstname])")
                            // id: 1, email: alice@mac.com, name: Optional("Alice")
                            }
                            
                        }
                        catch
                        {
                            
                        }
                    }
            case .Failure:
                socketObj.socket.emit("logClient", "\(username!) failed to get its data")
            }
        }
    }
    
    
    func fetchChatsFromServer(completion: (result:Bool)->())
    {
        
        //%%%%%% fetch chat
        
        //dispatch_async(dispatch_get_global_queue(priority, 0)) {
            //self.progressBarDisplayer("Setting Conversations", true)
            socketObj.socket.emit("logClient","\(username) is Fetching chat")
            var fetchChatURL=Constants.MainUrl+Constants.fetchMyAllchats
            //var getUserDataURL=userDataUrl
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            Alamofire.request(.POST,"\(fetchChatURL)",headers:header,parameters:["user1":username!]).validate(statusCode: 200..<300).responseJSON{response in
                
                
                switch response.result {
                case .Success:
                    
                    
                    socketObj.socket.emit("logClient", "All chat fetched success")
                    if let data1 = response.result.value {
                        let UserchatJson = JSON(data1)
                       // print("chat fetched JSON: \(json)")
                        
                        var tableUserChatSQLite=sqliteDB.userschats
                        
                        do{
                            try sqliteDB.db.run(tableUserChatSQLite.delete())
                        }catch{
                            socketObj.socket.emit("logClient","sqlite chat table refreshed")
                            print("chat table not deleted")
                        }
                        
                        //Overwrite sqlite db
                        //sqliteDB.deleteChat(self.selectedContact)
                        
                        socketObj.socket.emit("logClient","IPHONE-LOG: all chat messages count is \(UserchatJson["msg"].count)")
                        for var i=0;i<UserchatJson["msg"].count
                            ;i++
                        {
                            //UserchatJson["msg"][i]["date"].string!
                            
                            
                            
                            let dateFormatter = NSDateFormatter()
                            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                            let datens2 = dateFormatter.dateFromString(UserchatJson["msg"][i]["date"].string!)
                            
                            
                            
                            let formatter = NSDateFormatter()
                            formatter.dateFormat = "MM/dd, HH:mm";
                            //formatter.dateStyle = NSDateFormatterStyle.ShortStyle
                            //formatter.timeStyle = .ShortStyle
                            
                            let dateString = formatter.stringFromDate(datens2!)
                            
                            
                            if(UserchatJson["msg"][i]["uniqueid"].isExists())
                            {
                                if(UserchatJson["msg"][i]["to"].string! == username! && UserchatJson["msg"][i]["status"].string!=="sent")
                                {
                                    var updatedStatus="delivered"
                                    
                                    ///sqliteDB.SaveChat(<#T##to1: String##String#>, from1: <#T##String#>, owneruser1: <#T##String#>, fromFullName1: <#T##String#>, msg1: <#T##String#>, date1: <#T##String!#>, uniqueid1: <#T##String!#>, status1: <#T##String#>, type1: <#T##String#>, file_type1: <#T##String#>, file_path1: <#T##String#>)
                                    
                                    sqliteDB.SaveChat(UserchatJson["msg"][i]["to"].string!, from1: UserchatJson["msg"][i]["from"].string!,owneruser1:UserchatJson["msg"][i]["owneruser"].string! , fromFullName1: UserchatJson["msg"][i]["fromFullName"].string!, msg1: UserchatJson["msg"][i]["msg"].string!,date1:dateString,uniqueid1:UserchatJson["msg"][i]["uniqueid"].string!,status1: updatedStatus, type1: "", file_type1: "",file_path1: "")
                                    
                                    //socketObj.socket.emit("messageStatusUpdate",["status":"","iniqueid":"","sender":""])
                                    socketObj.socket.emitWithAck("messageStatusUpdate", ["status":updatedStatus,"uniqueid":UserchatJson["msg"][i]["uniqueid"].string!,"sender": UserchatJson["msg"][i]["from"].string!])(timeoutAfter: 0){data in
                                        var chatmsg=JSON(data)
                                        print(data[0])
                                        print(chatmsg[0])
                                        print("chat status emitted")
                                        socketObj.socket.emit("logClient","\(username) chat status emitted")
                                    }
                                    
                                    
                                    
                                }
                                else
                                {
                                    
                                    sqliteDB.SaveChat(UserchatJson["msg"][i]["to"].string!, from1: UserchatJson["msg"][i]["from"].string!,owneruser1:UserchatJson["msg"][i]["owneruser"].string! , fromFullName1: UserchatJson["msg"][i]["fromFullName"].string!, msg1: UserchatJson["msg"][i]["msg"].string!,date1:dateString,uniqueid1:UserchatJson["msg"][i]["uniqueid"].string!,status1: UserchatJson["msg"][i]["status"].string!, type1: "", file_type1: "",file_path1: "" )
                                }
                            }
                            else
                            {
                                sqliteDB.SaveChat(UserchatJson["msg"][i]["to"].string!, from1: UserchatJson["msg"][i]["from"].string!,owneruser1:UserchatJson["msg"][i]["owneruser"].string! , fromFullName1: UserchatJson["msg"][i]["fromFullName"].string!, msg1: UserchatJson["msg"][i]["msg"].string!,date1:dateString,uniqueid1:"",status1: "", type1: "", file_type1: "",file_path1: "" )
                            }
                            
                            
                        }
                        return completion(result: true)
                        
                        /* dispatch_async(dispatch_get_main_queue()) {
                        self.messageFrame2.removeFromSuperview()
                        }
                        */
                        
                        
                    }
                    /*dispatch_async(dispatch_get_main_queue()) {
                    
                    }*/
                    
                case .Failure:
                    socketObj.socket.emit("logClient", "All chat fetched failed")
                    print("all chat fetched failed")
                }
            }
        }
       // }
        
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
        progressBarDisplayer("Contacting Server", true)
        dispatch_async(Q0_sendDisplayName,
            {
                self.sendNameToServer(displayName){ (result) -> () in
                /*dispatch_async(dispatch_get_main_queue())
                    {
                    
                }*/
                    self.messageFrame.removeFromSuperview()
                    self.progressBarDisplayer("Setting Contacts", true)
                    dispatch_async(self.Q1_fetchFromDevice,
                        {
                            self.fetchContactsFromDevice({ (result) -> () in
                                
                                dispatch_async(self.Q2_sendPhonesToServer,
                                    {
                                        self.sendPhoneNumbersToServer({ (result) -> () in
                                            
                                            dispatch_async(self.Q3_getContactsFromServer,
                                                {
                                                    self.fetchContactsFromServer({ (result) -> () in
                                                        
                                                        
                                                        var allcontactslist1=sqliteDB.allcontacts
                                                        var alladdressContactsArray:Array<Row>
                                                        
                                                        let phone = Expression<String>("phone")
                                                        let kibocontact = Expression<Bool>("kiboContact")
                                                        let name = Expression<String?>("name")
                                                        
                                                        //alladdressContactsArray = Array(try sqliteDB.db.prepare(allcontactslist1))
                                                        
                                                        do{for ccc in try sqliteDB.db.prepare(allcontactslist1) {
                                                            
                                                            for var i=0;i<availableEmailsList.count;i++
                                                            {print(":::email .......  : \(availableEmailsList[i])")
                                                                if(ccc[phone]==availableEmailsList[i])
                                                                { print(":::::::: \(ccc[phone])  and emaillist : \(availableEmailsList[i])")
                                                                    //ccc[kibocontact]
                                                                    
                                                                    let query = allcontactslist1.select(kibocontact)           // SELECT "email" FROM "users"
                                                                        .filter(phone == ccc[phone])     // WHERE "name" IS NOT NULL
                                                                    
                                                                    try sqliteDB.db.run(query.update(kibocontact <- true))
                                                                    // for kk in try sqliteDB.db.prepare(query) {
                                                                    //  try sqliteDB.db.run(query.update(kk[kibocontact] <- true))
                                                                    //}
                                                                    //try sqliteDB.db.run(allcontactslist1.update(query[kibocontact] <- true))
                                                                    
                                                                    // try sqliteDB.db.run(allcontactslist1.update(ccc[kibocontact] <- true))
                                                                }
                                                                
                                                            }
                                                            
                                                            }
                                                        }
                                                        catch{
                                                            print("error 123")
                                                        }
                                                        
                                                        dispatch_async(self.Q4_getUserData,
                                                            {
                                                                self.getCurrentUserDetails({ (result) -> () in
                                                                
                                                                    
                                                                    
                                                                    
                                                                    let notificationTypes: UIUserNotificationType = [UIUserNotificationType.Alert, UIUserNotificationType.Badge, UIUserNotificationType.Sound]
                                                                    
                                                                    //let notificationTypes: UIUserNotificationType = [UIUserNotificationType.None]
                                                                    
                                                                    
                                                                    let pushNotificationSettings = UIUserNotificationSettings(forTypes: notificationTypes, categories: nil)
                                                                    
                                                                    
                                                                    
                                                                    /////-------will be commented----
                                                                    //application.registerUserNotificationSettings(pushNotificationSettings)
                                                                    //application.registerForRemoteNotifications()
                                                                    
                                                                    if(username != nil && username != "")
                                                                    {
                                                                        print("didRegisterForRemoteNotificationsWithDeviceToken in displaycontroller")
                                                                        UIApplication.sharedApplication().registerUserNotificationSettings(pushNotificationSettings)
                                                                    }
                                                                    
                                                                    
                                                                self.messageFrame.removeFromSuperview()
                                                                self.progressBarDisplayer("Setting Conversations", true)
                                                                dispatch_async(self.Q5_fetchAllChats,
                                                                {
                                                                self.fetchChatsFromServer({ (result) -> () in
                                                                    
                                                                    dispatch_async(dispatch_get_main_queue())
                                                                        {
                                                                            self.messageFrame.removeFromSuperview()
                                                                            self.dismissViewControllerAnimated(false, completion: { () -> Void in
                                                                                
                                                                                print("logged in going to contactlist")
                                                                            })

                                                                    }
                                                                    
                                                                })
                                                        })
                                                    })
                                                        
                                                })
                                                    
                                            })
                                            
                                        })
                                })
                                
                            })
                    })
                })
                }
            })
        
        /*self.progressBarDisplayer("Setting Contacts", true)
            dispatch_async(Q1_fetchFromDevice,
            {
                self.fetchContactsFromDevice({ (result) -> () in
        
                    dispatch_async(self.Q2_sendPhonesToServer,
                        {
                            self.sendPhoneNumbersToServer({ (result) -> () in
                                
                                dispatch_async(self.Q3_getContactsFromServer,
                                    {
                                        self.fetchContactsFromServer({ (result) -> () in
                                            
                                            dispatch_async(dispatch_get_main_queue())
                                                {
                                                    self.messageFrame.removeFromSuperview()
                                            }
                                            
                                        })
                                        
                                })
                                
                            })
                    })
                    
                })
            })*/
     
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


                    socketObj.socket.emit("logClient","IPHONE-LOG: got server response ..")
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
                        socketObj.socket.emit("logClient","IPHONE-LOG: error in display name routine \(error)")
                        
                        
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
