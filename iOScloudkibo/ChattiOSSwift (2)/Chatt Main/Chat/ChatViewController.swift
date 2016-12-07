//
//  ChatViewController.swift
//  Chat
//
//  Created by My App Templates Team on 24/08/14.
//  Copyright (c) 2014 My App Templates. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import SQLite
import AVFoundation
import Foundation
import AccountKit
import Contacts
import ContactsUI

class ChatViewController:UIViewController,SocketClientDelegate,SocketConnecting,CNContactPickerDelegate,
    EPPickerDelegate,SWTableViewCellDelegate,UpdateChatViewsDelegate,RefreshContactsList,UpdateMainPageChatsDelegate
{
    
    
    var messages:NSMutableArray!
    var pendinggroupchatsarray=[[String:AnyObject]]()
    var groupsObjectList=[[String:AnyObject]]()
    var delegateUpdateUI:UpdateMainPageChatsDelegate!
    var swipeindexRow:Int!
    var delegateContctsList:RefreshContactsList!
    var pendingchatsarray=[[String:String]]()
    var delegateRefrChat:UpdateChatViewsDelegate!
    var participantsSelected=[EPContact]()
   // var participantsSelected=[CNContact]()
    var picker:CNContactPickerViewController!
    var btnNewGroup:UIButton!
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
    let nationalNumber = Expression<String>("nationalNumber")
    

    var userObject:JSON!
    @IBOutlet weak var editButtonOutlet: UIBarButtonItem!
    var accountKit: AKFAccountKit!
    var rt=NetworkingLibAlamofire()
    var allkiboContactsArray=Array<Row>()
    
    
    
    var Q_serial1=dispatch_queue_create("Q_serial1",DISPATCH_QUEUE_SERIAL)
    var Q_serial2=dispatch_queue_create("Q_serial2",DISPATCH_QUEUE_SERIAL)
    var Q_serial3=dispatch_queue_create("Q_serial3",DISPATCH_QUEUE_SERIAL)
    
    var messageFrame = UIView()
    var activityIndicator = UIActivityIndicatorView()
    var messageFrame2 = UIView()
    var activityIndicator2 = UIActivityIndicatorView()
    var strLabel = UILabel()
    var strLabel2 = UILabel()
    
    var refreshControl = UIRefreshControl()
    @IBOutlet var viewForTitle : UIView!
    @IBOutlet var ctrlForChat : UISegmentedControl!
    @IBOutlet var btnForLogo : UIButton!
    var loggedID=loggedUserObj["_id"]
    @IBOutlet var tblForChat : UITableView!
    @IBOutlet weak var btnContactAdd: UIBarButtonItem!
    var delegateSocketConn:SocketConnecting!
    var currrentUsernameRetrieved:String=""
    var delegate:SocketClientDelegate!
    ////////let delegateController=LoginAPI(url: "sdfsfes")
    
    
    
    
    func getCurrentUserDetails(completion: (result:Bool)->())
    {
        if(socketObj != nil){
        socketObj.socket.emit("logClient","IPHONE-LOG: login success and AuthToken was not nil getting myself details from server")
        }
        
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
                    displayname=json["display_name"].string!
                    loggedUserObj=json
                    KeychainWrapper.setString(loggedUserObj.description, forKey:"loggedUserObjString")
                    var loggedobjstring=KeychainWrapper.stringForKey("loggedUserObjString")
                    if(socketObj != nil){
                    socketObj.socket.emit("logClient","IPHONE-LOG: keychain of loggedUserObjString is \(loggedobjstring)")
                    }
                    
                    print(loggedUserObj.debugDescription)
                    print(loggedUserObj.object)
                    print("$$$$$$$$$$$$$$$$$$$$$$$$$")
                    print("************************")
                    
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
                    
                    
                    var jsonNew=JSON("{\"room\": \"globalchatroom\",\"user\": {\"username\":\"sabachanna\"}}")
                    //socketObj.socket.emit("join global chatroom", ["room": "globalchatroom", "user": ["username":"sabachanna"]]) WORKINGGG
                    if(socketObj != nil){
                    socketObj.socket.emit("logClient","IPHONE-LOG: \(username!) is joining room room:globalchatroom, user: \(json.object)")
                    socketObj.socket.emit("join global chatroom",["room": "globalchatroom", "user": json.object])
                    }
                    print(json["_id"])
                    self.userObject=json
                    
                    
                    let tbl_accounts = sqliteDB.accounts
                    
                    do{
                        
                        try sqliteDB.db.run(tbl_accounts.delete())
                    }catch{
                        if(socketObj != nil){
                        socketObj.socket.emit("logClient","accounts table not deleted")
                        }
                        print("accounts table not deleted")
                    }
                  
                    // let insert = users.insert(email <- "alice@mac.com")
                    
                    
                    tbl_accounts.delete()
                    
                    do {
                        let rowid = try sqliteDB.db.run(tbl_accounts.insert(self._id<-json["_id"].string!,
                            //firstname<-json["firstname"].string!,
                            self.firstname<-json["display_name"].string!,
                            self.country_prefix<-json["country_prefix"].string!,
                            self.nationalNumber<-json["national_number"].string!,
                            //lastname<-"",
                            //lastname<-json["lastname"].string!,
                            //email<-json["email"].string!,
                            self.username1<-json["phone"].string!,
                            self.status<-json["status"].string!,
                            self.phone<-json["phone"].string!))
                        //country_prefix
                        //national_number"
                        print("inserted id: \(rowid)")
                        
                        return completion(result:true)
                        
                    } catch {
                        print("insertion failed: \(error)")
                    }
                    
                    
                    do{for account in try sqliteDB.db.prepare(tbl_accounts) {
                        print("id: \(account[self._id]), phone: \(account[self.phone]), firstname: \(account[self.firstname])")
                        // id: 1, email: alice@mac.com, name: Optional("Alice")
                        }
                        
                    }
                    catch
                    {
                        
                    }
                }
            case .Failure:
                if(socketObj != nil){
                socketObj.socket.emit("logClient", "\(username!) failed to get its data")
                }
            }
        }
    }
    
    //func fetchChatsFromServer()
    
    
    @IBAction func addContactTapped(sender: UIBarButtonItem) {
        
        self.performSegueWithIdentifier("inviteSegue",sender: nil)

    }
    
    /*
    var ContactCountMsgRead:[Int]=[]
    //////var ContactMsgRead:[String]=[]
    var ContactsLastMsgDate:[String]=[]
    var ContactLastMessage:[String]=[]
    var ContactNames:[String]=[]
    var ContactUsernames:[String]=[]
    //var ContactIDs:[String]=[]
    var ContactFirstname:[String]=[]
    var ContactLastNAme:[String]=[]
    var ContactStatus:[String]=[]
    var ContactsObjectss:[JSON]=[]
    
    var ContactOnlineStatus:[Int]=[]
    ///////////////////////
    /////////NEW//////////////
    //////////////////////////
   ///// var ContactsEmail:[String]=[]
    var ContactsPhone:[String]=[]
    var ContactsProfilePic:[NSData]=[]
    var ChatType:[String]=[] //group OR single
    */
    
    
    
    
    //["Bus","Helicopter","Truck","Boat","Bicycle","Motorcycle","Plane","Train","Car","Scooter","Caravan"]
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        //print(AuthToken!)
        
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        // Custom initialization
        
    }
    
    
    
    
    func showError(title:String,message:String,button1:String) {
        
        // create the alert
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        
        // add the actions (buttons)
        alert.addAction(UIAlertAction(title: button1, style: UIAlertActionStyle.Default, handler: nil))
        //alert.addAction(UIAlertAction(title: button2, style: UIAlertActionStyle.Cancel, handler: nil))
        
        // show the alert
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func synchroniseChatData()
    {
        print("synchronise called")
        if(accountKit == nil){
            accountKit = AKFAccountKit(responseType: AKFResponseType.AccessToken)
        }
        
        if (accountKit!.currentAccessToken != nil) {
            
            header=["kibo-token":self.accountKit!.currentAccessToken!.tokenString]
            
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
                print("error in getting data from accounts table \(error)")
                
            }
            
            //  dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) {
            
            
            //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            // if(socketObj != nil)
            // {
            
            
            //commenting it managerFile.checkPendingFiles(username!)
           
            self.sendPendingChatMessages({ (result) -> () in
                
                self.getData({ (result) -> () in
                    
                    self.sendPendingGroupChatMessages({ (result) -> () in
                        
                        self.getGroupsData({ (result) -> () in
                            
                            
                   /* Alamofire.request(.POST,"\(Constants.MainUrl+Constants.urllog)",headers:header,parameters: ["data":"IPHONE_LOG: checkin here pending messages sent"]).response{
                        request, response_, data, error in
                        print(error)
                    }
                    */
               // print("checkin here pending messages sent")
                    
               // if(socketObj != nil)
                //{
                     
                 
                            
                            //commenting new uncomment
               /* UIDelegates.getInstance().UpdateGroupChatDetailsDelegateCall()
                UIDelegates.getInstance().UpdateMainPageChatsDelegateCall()
                            
                if(delegateRefreshChat != nil)
                {
                    print("refresh UI after pending msgs are sent")
                    delegateRefreshChat?.refreshChatsUI(nil, uniqueid:nil, from:nil, date1:nil, type:"status")
                }*/
                            
                /////======CHANGE IT==================
                    self.fetchChatsFromServer()
                    
                    var syncGroupsObj=syncGroupService.init()
                    
                    syncGroupsObj.startSyncGroupsService({ (result) -> () in
                        
                        // partial sync groups
                        print("calling partial sync groups chat")
                        syncGroupsObj.startPartialGroupsChatSyncService()
                    })
                    
                })
                })
                //}
                })
            })
        }
    }
    
    
    
   func fetchChatsFromServer()
    {
        
        
        let uniqueid = Expression<String>("uniqueid")
        let file_name = Expression<String>("file_name")
        let type = Expression<String>("type")
        let from = Expression<String>("from")
        let to = Expression<String>("to")
        
        let phone = Expression<String>("phone")
        
        let contactPhone = Expression<String>("contactPhone")
        let date = Expression<NSDate>("date")
        //contactPhone
        
        //%%%%%% fetch chat
        
        //dispatch_async(dispatch_get_global_queue(priority, 0)) {
        //self.progressBarDisplayer("Setting Conversations", true)
        print("\(username) is Fetching chat")
      //  socketObj.socket.emit("logClient","\(username) is Fetching chat")
        Alamofire.request(.POST,"\(Constants.MainUrl+Constants.urllog)",headers:header,parameters: ["data":"IPHONE_LOG: \(username) is Fetching chat"]).response{
            request, response_, data, error in
            print(error)
        }

        //===
        
        //===
        
        //var fetchChatURL=Constants.MainUrl+Constants.fetchMyAllchats
        
        var fetchChatURL=Constants.MainUrl+Constants.partialSync
        
        
        
        //var getUserDataURL=userDataUrl
        
        //  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND,0))
        //    {
        
        //QOS_CLASS_USER_INTERACTIVE
        let queue2 = dispatch_queue_create("com.cnoon.manager-response-queue", DISPATCH_QUEUE_CONCURRENT)
        let qqq=dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0)
        let request = Alamofire.request(.POST, "\(fetchChatURL)", parameters: ["user1":username!], headers:header)
        request.response(
            queue: queue2,
            responseSerializer: Request.JSONResponseSerializer(),
            completionHandler: { response in
                // You are now running on the concurrent `queue` you created earlier.
                print("Parsing JSON on thread: \(NSThread.currentThread()) is main thread: \(NSThread.isMainThread())")
                
                // Validate your JSON response and convert into model objects if necessary
                //print(response)
                //print(response.result.value)
                
                
                switch response.result {
                case .Success:
                    
                    print("All chat fetched success")
                    socketObj.socket.emit("logClient", "All chat fetched success")
                    print("response data \(response.data)")
                    
                    if let data1 = response.result.value {
                        print("data \(data1)")
                        let UserchatJson = JSON(data1)
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
                        for var i=0;i<UserchatJson["msg"].count
                            ;i++
                        {
                            
                            // var isFile=false
                            var chattype="chat"
                            var file_type=""
                            //UserchatJson["msg"][i]["date"].string!
                            
                            
                            
                            let dateFormatter = NSDateFormatter()
                            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                            let datens2 = dateFormatter.dateFromString(UserchatJson["msg"][i]["date"].string!)
                            
                            print("fetch date from server got is \(UserchatJson["msg"][i]["date"].string!)... converted is \(datens2.debugDescription)")
                            
                            
                             print("===fetch chat date raw from server in chatview is \(UserchatJson["msg"][i]["date"].string!)")
                            
                            /*
                             let formatter = NSDateFormatter()
                             formatter.dateFormat = "MM/dd hh:mm a"";
                             // formatter.dateStyle = NSDateFormatterStyle.ShortStyle
                             //formatter.timeStyle = .ShortStyle
                             
                             let dateString = formatter.stringFromDate(datens2!)
                             */
                            
                            if(UserchatJson["msg"][i]["type"].isExists())
                            {
                                chattype=UserchatJson["msg"][i]["type"].string!
                            }
                            
                            if(UserchatJson["msg"][i]["file_type"].isExists())
                            {
                                file_type=UserchatJson["msg"][i]["file_type"].string!
                            }
                            
                            if(UserchatJson["msg"][i]["uniqueid"].isExists())
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
                                    
                                    
                                    if(UserchatJson["msg"][i]["type"].string! == "file")
                                    {
                                        managerFile.checkPendingFiles(UserchatJson["msg"][i]["uniqueid"].string!)
                                        
                                    }
                                    
                                    managerFile.sendChatStatusUpdateMessage(UserchatJson["msg"][i]["uniqueid"].string!, status: updatedStatus, sender: UserchatJson["msg"][i]["from"].string!)
                                    
                                    
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
                                    
                                    if(UserchatJson["msg"][i]["type"].string! == "file")
                                    {
                                        managerFile.checkPendingFiles(UserchatJson["msg"][i]["uniqueid"].string!)
                                        
                                    }
                                    
                                    sqliteDB.SaveChat(UserchatJson["msg"][i]["to"].string!, from1: UserchatJson["msg"][i]["from"].string!,owneruser1:UserchatJson["msg"][i]["owneruser"].string! , fromFullName1: UserchatJson["msg"][i]["fromFullName"].string!, msg1: UserchatJson["msg"][i]["msg"].string!,date1:datens2,uniqueid1:UserchatJson["msg"][i]["uniqueid"].string!,status1: UserchatJson["msg"][i]["status"].string!, type1: chattype, file_type1: file_type,file_path1: "" )
                                    
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
                        
                        //////// dispatch_async(dispatch_get_main_queue()) {
                        
                        
                        //IF NO CHAT WAS THERE TO FETCH
                        /*
                        //------CHECK IF ANY PENDING FILES--------
                        if(delegateRefreshChat != nil)
                        {
                            delegateRefreshChat?.refreshChatsUI("updateUI", data: nil)
                        }
                        
                        if(socketObj.delegateChat != nil)
                        {
                            socketObj.delegateChat?.socketReceivedMessageChat("updateUI", data: nil)
                        }
                        if(self.delegate != nil)
                        {
                            self.delegate?.socketReceivedMessage("updateUI", data: nil)
                        }
                        ///////// }
                        
                        
                        print("all fetched chats saved in sqlite success")*/
                        
                        if(UserchatJson["msg"].count > 0)
                        {
                            dispatch_async(dispatch_get_main_queue()) {
                                if(delegateRefreshChat != nil)
                                {print("updating UI now ...")
                                    delegateRefreshChat?.refreshChatsUI(nil, uniqueid:nil, from:nil, date1:nil, type:"status")
                                }
                                
                                if(socketObj.delegateChat != nil)
                                {
                                    socketObj.delegateChat?.socketReceivedMessageChat("updateUI", data: nil)
                                }
                                if(self.delegate != nil)
                                {
                                    self.delegate?.socketReceivedMessage("updateUI", data: nil)
                                }
                                ///////// }
                                
                            }
                            print("all fetched chats saved in sqlite success")
                        }
                        
                        
                    }
                 
                    
                /////return completion(result: true)
                case .Failure:
                    socketObj.socket.emit("logClient", "All chat fetched failed")
                    print("all chat fetched failed")
                }
                // }
                
                
                // To update anything on the main thread, just jump back on like so.
                ///  dispatch_async(dispatch_get_main_queue()) {
                ///      print("Am I back on the main thread: \(NSThread.isMainThread())")
                /// }
            }
        )
        
        
    }
    
    func leftJoinContactsTables(phone1:String)->Array<Row>
    {
        
        var resultrow=Array<Row>()
        let name = Expression<String>("name")
        let phone = Expression<String>("phone")
        let actualphone = Expression<String>("actualphone")
        let email = Expression<String>("email")
        let kiboContact = Expression<Bool>("kiboContact")
        /////////////////////let profileimage = Expression<NSData>("profileimage")
        let uniqueidentifier = Expression<NSData>("uniqueidentifier")
        //
        var allcontacts = sqliteDB.allcontacts
        //========================================================
        let contactid = Expression<String>("contactid")
        let detailsshared = Expression<String>("detailsshared")
        let unreadMessage = Expression<Bool>("unreadMessage")
        
        let userid = Expression<String>("userid")
        let firstname = Expression<String>("firstname")
        let lastname = Expression<String>("lastname")
        //---let email = Expression<String>("email")
       //--- let phone = Expression<String>("phone")
        let username = Expression<String>("username")
        let status = Expression<String>("status")
        
        var contactslists = sqliteDB.contactslists
        //=================================================
        var joinquery=allcontacts.join(.LeftOuter, contactslists, on: contactslists[phone] == allcontacts[phone]).filter(allcontacts[phone]==phone1)
    
        do{for joinresult in try sqliteDB.db.prepare(joinquery) {
        
            resultrow.append(joinresult)
            }
        }
        catch{
            print("error in join query \(error)")
}
        return resultrow
    
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        messages=NSMutableArray()
        syncServiceContacts.delegateRefreshContactsList=self
        delegateRefreshChat=self
        print("Chat ViewController is loadingggggg")
        
       /* if(retainOldDatabase != nil
            ==false)
        {
            accountKit.logOut()
        }*/
        
        if(self.accountKit == nil){
            self.accountKit = AKFAccountKit(responseType: AKFResponseType.AccessToken)
        }
    
        
      
    
    
        if(socketObj != nil)
        {
            socketObj.delegate=self
        }
        socketObj.socket.on("connect") {data, ack in
            print("connected caught in chat view")
           if(socketObj != nil)
            {
            socketObj.delegate=self
            }
           
            //==========
            //DO ON INTERNET CONNECTED
            //===========
            
           /* if(username != nil && username != "")
            {
            self.synchroniseChatData()
            }*/
            
        }
        
        
       
        
        
        
        //print()
        
        CNContactStore.authorizationStatusForEntityType(.Contacts)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("contactChanged:"), name: CNContactStoreDidChangeNotification, object: nil)
        

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
                    
                    
                }
                
            }}
        else
        {
            
            
        }
        
        
        
        
   
        
        var retrievedToken=KeychainWrapper.stringForKey("access_token")
        print("retrieved token === \(retrievedToken)")
        print("khul raha hai2", terminator: "")
        print(loggedUserObj.object)
        
        
        if(KeychainWrapper.stringForKey("username") != nil)
        {print("delegate added in chat")
            currrentUsernameRetrieved=KeychainWrapper.stringForKey("username")!
            print("currrentUsernameRetrieved is \(currrentUsernameRetrieved)")
            if(socketObj != nil){
                socketObj.delegate=self
            }
            if(loggedUserObj == JSON("[]"))
            {
                
                
            }
            
        }//end if username definned
        
        print("loadddddd", terminator: "")
        
        
        do{reachability = try Reachability.reachabilityForInternetConnection()
            try reachability.startNotifier();
            //  NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("checkForReachability:"), name:ReachabilityChangedNotification, object: reachability)
        }
        catch{
            print("error in reachability")
        }
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("checkForReachability:"), name:ReachabilityChangedNotification, object: reachability)
        
        self.navigationItem.titleView = viewForTitle
        /////self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: btnForLogo)
        //self.navigationItem.rightBarButtonItem = itemForSearch
        
        
        
        
        //&&&&&7
       /// self.tblForChat.setEditing(true, animated: true)
        
        
        
        
        
        
        
        
        
        /////self.navigationItem.leftBarButtonItem = editButtonItem()
        ///////self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Edit, target: self, action: "editItems:")
        self.navigationItem.rightBarButtonItem = btnContactAdd
        self.tabBarController?.tabBar.tintColor = UIColor.greenColor()
        print("////////////////////// new class tokn \(AuthToken)", terminator: "")
        
        //print(self.ContactNames.count.description, terminator: "")
        // self.tblForChat.reloadData()
        
        if(tblForChat.editing.boolValue==false)
        {
            editButtonOutlet.title="Edit"
            self.navigationItem.leftBarButtonItem!.title = "Edit"
        }
        else
        {
            editButtonOutlet.title="Done"
            self.navigationItem.leftBarButtonItem!.title = "Done"
        }
        

        
        
        //-----------------------NEW TRY FROM APPEAR TO HERE -------------
        if(socketObj.delegateSocketConnected == nil && isSocketConnected==true)
        {
            socketObj.delegateSocketConnected=self
        }
      
    }
    func checkForReachability(notification:NSNotification)
    {
        print("checking internet")
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
                print("commenting")
                //commentingg
                var syncGroupsObj=syncGroupService.init()
                syncGroupsObj.startPartialGroupsChatSyncService()
                self.synchroniseChatData()
            }
        }
        else
        {
            print("Reachable")
            if(username != nil && username != "")
            {//commentingg
                var syncGroupsObj=syncGroupService.init()
                syncGroupsObj.startPartialGroupsChatSyncService()
                self.synchroniseChatData()
            }
        }
    }

    
    func contactChanged(notification : NSNotification)
    {
        if(notification.name==CNContactStoreDidChangeNotification)
        {
        let now=NSDate()
        print("contact changed notification received")
         guard addressbookChangedNotifReceivedDateTime==nil || now.timeIntervalSinceDate(addressbookChangedNotifReceivedDateTime!)>1 else{
            print("returning")
            return}
        addressbookChangedNotifReceivedDateTime=now
        
       // if(addressbookChangedNotifReceived==false)
//{
    
    addressbookChangedNotifReceived=true
        var userInfo: NSDictionary!
        userInfo = notification.userInfo
    print(userInfo)
        print(userInfo.allKeys.debugDescription)
        print("contacts changed sync now starting")
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND,0))
    {
         syncServiceContacts.startSyncService()
    }
        }
        else
        {
            print("some other notification received")
        }
    
    /*var sync=syncContactService.init()
        sync.startContactsRefresh()
    tblForChat.reloadData()
 */

//}
        
        
    }
    
    
    func loginSegueMethod()
    {print("line # 564")
        self.performSegueWithIdentifier("loginSegue", sender: nil)
    }
    func socketConnected() {
        if((self.view.window != nil) && self.isViewLoaded()){
            /* var lll=self.storyboard?.instantiateViewControllerWithIdentifier("mainpage") as! LoginViewController
            
            lll.progressWheel.stopAnimating()
            lll.progressWheel.hidden=true*/
            print("progressWheel hidden")
            //**** neww may 2016 added
            socketObj.delegate=self
        }
        
    }
    
    
    
    @IBAction func editButtonPressed(sender: AnyObject) {
        
     
         tblForChat.setEditing(!tblForChat.editing, animated: true)
        //////////self.setEditing(tblForChat.editing, animated: true)
        print("editinggg1..\(tblForChat.editing.boolValue) .. \(tblForChat.editing)")
        if(tblForChat.editing.boolValue==false)
        {
            editButtonOutlet.title="Edit"
            self.navigationController?.navigationItem.leftBarButtonItem?.title="Edit"
            self.navigationItem.leftBarButtonItem!.title = "Edit"
        }
        else
        {
            editButtonOutlet.title="Done"
            self.navigationController?.navigationItem.leftBarButtonItem?.title="Done"
            ///self.navigationItem.leftBarButtonItem!.title = "Done"
        }
        //self.navigationItem.leftBarButtonItem!.title = "Done"
        //self.setEditing(!tblForChat.editing, animated: true)
        
        
        
    }
    
    /*func editItems(sender: UIBarButtonItem) {
        self.navigationItem.leftBarButtonItem?.title="Done"
        //self.navigationItem.leftBarButtonItem!.title = tblForChat.editing ? "Done" : "Edit";
        tblForChat.setEditing(!tblForChat.editing, animated: true)
    }*/
    

    
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
    
    func progressBarDisplayer2(msg:String, _ indicator:Bool ) {
        print(msg)
        strLabel2 = UILabel(frame: CGRect(x: 50, y: 0, width: 250, height: 50))
        strLabel2.text = msg
        strLabel2.textColor = UIColor.whiteColor()
        messageFrame2 = UIView(frame: CGRect(x: view.frame.midX - 110, y: view.frame.midY - 25 , width: 230, height: 50))
        messageFrame2.layer.cornerRadius = 15
        messageFrame2.backgroundColor = UIColor(white: 0, alpha: 0.7)
        if indicator {
            activityIndicator2 = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.White)
            activityIndicator2.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
            activityIndicator2.startAnimating()
            messageFrame2.addSubview(activityIndicator2)
        }
        messageFrame2.addSubview(strLabel2)
        view.addSubview(messageFrame2)
    }
    
    override func viewWillAppear(animated: Bool) {
        let _id = Expression<String>("_id")
        let firstname = Expression<String?>("firstname")
        let lastname = Expression<String?>("lastname")
        let email = Expression<String>("email")
        let phone = Expression<String>("phone")
        
        print("appearrrrrr", terminator: "")
        
        UIDelegates.getInstance().delegateMainPageChats1=self
        delegateRefreshChat=self
        if(socketObj != nil)
        {
            socketObj.delegate=self
        
        if(socketObj.delegateSocketConnected == nil && isSocketConnected==true)
        {
            socketObj.delegateSocketConnected=self
        }
        }
        //%%%%%% new phone model add
        
        
        //////////// *******  if(AuthToken != nil)
        
        //already logged in
        /*
        if(retainOldDatabase==false)
        {
            accountKit.logOut()
        }
        else
        {*/
        if(accountKit == nil){
            accountKit = AKFAccountKit(responseType: AKFResponseType.AccessToken)
        }
        if(accountKit.currentAccessToken != nil)
        {
            header=["kibo-token":self.accountKit!.currentAccessToken!.tokenString]
            
           // socketObj.socket.emit("logClient", "fetching contacts from iphone")
            
            
            //dont do on every appear. just do once
            print("emaillist is \(emailList.first)")
            print("emailList count is \(emailList.count)")
            
            print("here refreshing UI in chats view line # 1123")
            self.retrieveSingleChatsAndGroupsChatData({(result)-> () in
                
                
                //    dispatch_async(dispatch_get_main_queue())
                //  {
                // self.tblForChats.reloadData()
                
                //commenting newwwwwwww -===-===-=
                dispatch_async(dispatch_get_main_queue())
                {
                    self.tblForChat.reloadData()
                    if(self.messages.count>1)
                    {
                        var indexPath = NSIndexPath(forRow:self.messages.count-1, inSection: 0)
                        
                        self.tblForChat.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Bottom, animated: false)
                    }
                }
                //}
                // })
            })
            
            
            //==--new commenting
           /* dispatch_sync(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) {
                // do some task start to show progress wheel
                self.fetchContacts({ (result) -> () in
                    //self.fetchContactsFromServer()
                    print("checkinnn")
                    
                    let tbl_accounts=sqliteDB.accounts
                    /*do{for account in try sqliteDB.db.prepare(tbl_accounts) {
                        ///print("id: \(account[_id]), phone: \(account[phone]), firstname: \(account[firstname])")
                        
                        var userr:JSON=["_id":account[_id],"display_name":account[firstname]!,"phone":account[phone]]
                        if(socketObj != nil){
                        socketObj.socket.emit("whozonline",
                            ["room":"globalchatroom",
                                "user":userr.object])
                        }}
                    }
                    catch{
                        
                    }
                    */
                    dispatch_async(dispatch_get_main_queue()) {
                        print("here reloading tableeee")
                        self.tblForChat.reloadData()
                    }
                })
            }
            */
        
            
            
            if(displayname=="")
            {
                
                
                
                let _id = Expression<String>("_id")
                let phone = Expression<String>("phone")
                let username1 = Expression<String>("username")
                let status = Expression<String>("status")
                let firstname = Expression<String>("firstname")
                
                
                
                let tbl_accounts = sqliteDB.accounts
                do{for account in try sqliteDB.db.prepare(tbl_accounts) {
                    username=account[username1]
                    displayname=account[firstname]
                    
                    }
                }
                catch
                {
                    if(socketObj != nil){
                    socketObj.socket.emit("error getting data from accounts table")
                    }
                    print("error in getting data from accounts table \(error)")
                    
                }
                
                
                
                
                var dispatch_group_t = dispatch_group_create();
                           }
            if(tblForChat.editing.boolValue==false)
            {
                editButtonOutlet.title="Edit"
                self.navigationController?.navigationItem.leftBarButtonItem?.title="Edit"
                self.navigationItem.leftBarButtonItem!.title = "Edit"
            }
            else
            {
                editButtonOutlet.title="Done"
                self.navigationController?.navigationItem.leftBarButtonItem?.title="Done"
                ///self.navigationItem.leftBarButtonItem!.title = "Done"
            }
            
            //}
        }
            
            // ******************%%%%%%%%% addition new
        else
        {
            // *********%%%%%%%%%%%%% Not logged in
            if(socketObj != nil){
            socketObj.socket.emit("logClient","IPHONE-LOG: access token is nil so go to login page")
            }
            print("access token is nil so go to login page")
            self.performSegueWithIdentifier("loginSegue", sender: self)
        }
        
  //  }
    
    }
    
    
 /*   func reloadThisPage()
    {
        print("inside reload func")
        
        let _id = Expression<String>("_id")
        let firstname = Expression<String?>("firstname")
        let lastname = Expression<String?>("lastname")
        let email = Expression<String>("email")
        let phone = Expression<String>("phone")
        
        if(accountKit == nil){
            accountKit = AKFAccountKit(responseType: AKFResponseType.AccessToken)
        }
        if(accountKit.currentAccessToken != nil)
        {
            header=["kibo-token":self.accountKit!.currentAccessToken!.tokenString]
            
            // socketObj.socket.emit("logClient", "fetching contacts from iphone")
            
            
            //dont do on every appear. just do once
            print("emaillist is \(emailList.first)")
            print("emailList count is \(emailList.count)")
            
            dispatch_sync(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) {
                // do some task start to show progress wheel
                self.fetchContacts({ (result) -> () in
                    //self.fetchContactsFromServer()
                    print("checkinnn")
                    
                    let tbl_accounts=sqliteDB.accounts
                    do{for account in try sqliteDB.db.prepare(tbl_accounts) {
                        ///print("id: \(account[_id]), phone: \(account[phone]), firstname: \(account[firstname])")
                        
                        var userr:JSON=["_id":account[_id],"display_name":account[firstname]!,"phone":account[phone]]
                        if(socketObj != nil){
                            socketObj.socket.emit("whozonline",
                                ["room":"globalchatroom",
                                    "user":userr.object])
                        }}
                    }
                    catch{
                        
                    }
                    dispatch_async(dispatch_get_main_queue()) {
                        print("here reloading tableeee")
                        self.tblForChat.reloadData()
                    }
                })
            }
            
            
            
            
            if(displayname=="")
            {
                
                
                
                let _id = Expression<String>("_id")
                let phone = Expression<String>("phone")
                let username1 = Expression<String>("username")
                let status = Expression<String>("status")
                let firstname = Expression<String>("firstname")
                
                
                
                let tbl_accounts = sqliteDB.accounts
                do{for account in try sqliteDB.db.prepare(tbl_accounts) {
                    username=account[username1]
                    displayname=account[firstname]
                    
                    }
                }
                catch
                {
                    if(socketObj != nil){
                        socketObj.socket.emit("error getting data from accounts table")
                    }
                    print("error in getting data from accounts table \(error)")
                    
                }
                
                
                
                
                var dispatch_group_t = dispatch_group_create();
            }
            if(tblForChat.editing.boolValue==false)
            {
                editButtonOutlet.title="Edit"
                self.navigationController?.navigationItem.leftBarButtonItem?.title="Edit"
                self.navigationItem.leftBarButtonItem!.title = "Edit"
            }
            else
            {
                editButtonOutlet.title="Done"
                self.navigationController?.navigationItem.leftBarButtonItem?.title="Done"
                ///self.navigationItem.leftBarButtonItem!.title = "Done"
            }
            
            //}
        }
            
            // ******************%%%%%%%%% addition new
        else
        {
            // *********%%%%%%%%%%%%% Not logged in
            if(socketObj != nil){
                socketObj.socket.emit("logClient","IPHONE-LOG: access token is nil so go to login page")
            }
            print("access token is nil so go to login page")
            self.performSegueWithIdentifier("loginSegue", sender: self)
        }
    }*/
    var index=0
   // var pendingcount=0
    
    func getData(completion:(result:Bool)->()) {
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
        let request = Alamofire.request(.POST, "\(url)", parameters: pendingchatsarray[index],headers:header).responseJSON { response in
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
        }
        }
        else{
            completion(result: false)

        }
    }
    
    var index2=0
    // var pendingcount=0
    
    func getGroupsData(completion:(result:Bool)->()) {
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
                    completion(result:true)
                    self.index2 = self.index2 + 1
                    if self.index2 < self.pendinggroupchatsarray.count {
                        self.getGroupsData({ (result) -> () in})
                    }else {
                        completion(result: true)
                        /////////self.collectionView.reloadData()
                    }
                }
                    //case .Failure(let error):
                else{
                    print("the error for \(self.pendinggroupchatsarray[self.index2]) ")
                    if self.index2 < self.pendinggroupchatsarray.count {
                        self.getGroupsData({ (result) -> () in})
                    }else {
                        completion(result: true)                /////////// self.collectionView.reloadData()
                    }
                }
            })
        }
        else{
            completion(result: false)
            
        }
    }
    

    
    func sendPendingChatMessages(completion:(result:Bool)->())
    {
        print("checkin here inside pending chat messages.....")
        var userchats=sqliteDB.userschats
        var userchatsArray:Array<Row>
        
        
        
        let to = Expression<String>("to")
        let from = Expression<String>("from")
        let owneruser = Expression<String>("owneruser")
        let fromFullName = Expression<String>("fromFullName")
        let msg = Expression<String>("msg")
        let date = Expression<NSDate>("date")
        let status = Expression<String>("status")
        let uniqueid = Expression<String>("uniqueid")
         let type = Expression<String>("type")
         let file_type = Expression<String>("file_type")
        
        
        var tbl_userchats=sqliteDB.userschats
        //var res=tbl_userchats.filter(to==selecteduser || from==selecteduser)
        //to==selecteduser || from==selecteduser
        //print("chat from sqlite is")
        //print(res)
        
     //  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND,0))
       // {
        do
        {print("pending chats in background")
            var count=0
           // var pendingMessagesArray=Array(try sqliteDB.db.prepare(tbl_userchats.filter(status=="pending").order(date.asc)))
          //  pendingchatsarray.append(pendingMessagesArray as [String:String])
            print("initially pending chats count is \(pendingchatsarray.count)")
            
            for pendingchats in try sqliteDB.db.prepare(tbl_userchats.filter(status=="pending").order(date.asc))
            {
                
                print("pending chats count date desc is \(count)")
                count++
                var imParas=["from":pendingchats[from],"to":pendingchats[to],"fromFullName":pendingchats[fromFullName],"msg":pendingchats[msg],"uniqueid":pendingchats[uniqueid],"type":pendingchats[type],"file_type":pendingchats[file_type]]
                
               
                
                self.pendingchatsarray.append(imParas)
                
                
                /*
 
                 func getData() {
                 var x = [[String: AnyObject]]()
                 Alamofire.request(.GET, bookmarks[index]).responseJSON { response in
                 switch response.result {
                 case .Success(let JSON):
                 x[self.index] = JSON as! [String : AnyObject] // saving data
                 self.index = self.index + 1
                 if self.index < self.bookmarks.count {
                 self.getData()
                 }else {
                 self.collectionView.reloadData()
                 }
                 case .Failure(let error):
                 print("the error for \(self.bookmarks[self.index]) is \(error) ")
                 if self.index < self.bookmarks.count {
                 self.getData()
                 }else {
                 self.collectionView.reloadData()
                 }
                 }
                 }
                 
                 }
 */
                print("imparas are \(imParas)")
               // print(imParas, terminator: "")
                //print("", terminator: "")
                
               //////// if(socketObj != nil){
               // dispatch_sync(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED,0))
               // {
               /////////// managerFile.sendChatMessage(imParas){ (result) -> () in
                    
                    
               // }
              /////  }
                //SOCKET OLD LOGIC
                /*socketObj.socket.emitWithAck("im",["room":"globalchatroom","stanza":imParas])(timeoutAfter: 1500000)
                    {data in
                        print("chat ack received \(data)")
                        // statusNow="sent"
                        var chatmsg=JSON(data)
                        print(data[0])
                        print(chatmsg[0])
                        sqliteDB.UpdateChatStatus(chatmsg[0]["uniqueid"].string!, newstatus: chatmsg[0]["status"].string!)
                        
                }*/
              /////  }
                
                
                
                
            }
            
           
            //refreshUI now
            
            
            
            //var count=0
            var tbl_messageStatus=sqliteDB.statusUpdate
            let status = Expression<String>("status")
            let sender = Expression<String>("sender")
            let uniqueid = Expression<String>("uniqueid")
            
            for statusMessages in try sqliteDB.db.prepare(tbl_messageStatus)
            {
                ////////if(socketObj != nil){
                
            managerFile.sendChatStatusUpdateMessage(statusMessages[uniqueid], status: statusMessages[status], sender: statusMessages[sender])
                
                // OLD SOCKET LOGIC
                /*socketObj.socket.emitWithAck("messageStatusUpdate", ["status":statusMessages[status],"uniqueid":statusMessages[uniqueid],"sender": statusMessages[sender]])(timeoutAfter: 15000){data in
                    var chatmsg=JSON(data)
                    
                    print(data[0])
                    print(data[0]["uniqueid"]!!)
                    print(data[0]["uniqueid"]!!.debugDescription!)
                    print(chatmsg[0]["uniqueid"].string!)
                    //print(data[0]["status"]!!.string!+" ... "+data[0]["uniqueid"]!!.string!)
                    print("chat status seen emitted which were pending")
                    sqliteDB.removeMessageStatusSeen(data[0]["uniqueid"]!!.debugDescription!)
                    socketObj.socket.emit("logClient","\(username) pending seen statuses emitted")
                    
                }*/
               /////// }
                
            }
            if(socketObj != nil){
            socketObj.socket.emit("logClient","IPHONE-LOG: \(username!) done sending pending chat messages")
            }
            
           dispatch_async(dispatch_get_main_queue())
           {
            return completion(result: true)
            }
       
    
            //// return completion(result: true)
        }
        catch
        {
            print("error in pending chat fetching")
            if(socketObj != nil){
            socketObj.socket.emit("logClient","IPHONE-LOG: \(username!) error in sending pending chat messages")
            }
            
            dispatch_async(dispatch_get_main_queue())
            {
            return completion(result: false)
            }
           
        }
      // }
        
    }
    
    
    func sendPendingGroupChatMessages(completion:(result:Bool)->())
    {
        print("inside sending pending group chat messages.....")
        var userchats=sqliteDB.userschats
        //  var userchatsArray:Array<Row>
        
        
        
        let from = Expression<String>("from")
        let group_unique_id = Expression<String>("group_unique_id")
        let type = Expression<String>("type")
        let msg = Expression<String>("msg")
        let from_fullname = Expression<String>("from_fullname")
        let date = Expression<NSDate>("date")
        let unique_id = Expression<String>("unique_id")
        
        
        
        var pendingMSGs=sqliteDB.findGroupChatPendingMsgDetails()
        //var res=tbl_userchats.filter(to==selecteduser || from==selecteduser)
        //to==selecteduser || from==selecteduser
        //print("chat from sqlite is")
        //print(res)
        
        var count=0
        for(var i=0;i<pendingMSGs.count;i++)
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
        
        completion(result: true)
        
    }

    
    //=====================================
    //to fetch contacts from SQLite db
    
    /*func saveAllChat(UserchatJson:JSON,completion: (result:Bool)->())
    {
        for var i=0;i<UserchatJson["msg"].count;i++
        {
            sqliteDB.SaveChat(UserchatJson["msg"][i]["to"].string!, from1: UserchatJson["msg"][i]["from"].string!,owneruser1:UserchatJson["msg"][i]["owneruser"].string! , fromFullName1: UserchatJson["msg"][i]["fromFullName"].string!, msg1: UserchatJson["msg"][i]["msg"].string!,date1:UserchatJson["msg"][i]["date"].string!,uniqueid1: UserchatJson["msg"][i]["uniqueid"].string!,status1: UserchatJson["msg"][i]["status"].string!)
            
            
            
        }
        completion(result: true)
    }
    */
    
    
    func sendGroupChatMessage(group_id:String,from:String,type:String,msg:String,fromFullname:String,uniqueidChat:String,completion:(result:Bool)->())
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
        
        
        print("sending groups chat \(group_id) , \(from) , \(type) \(msg), \(fromFullname) , \(uniqueidChat)")
        
        var url=Constants.MainUrl+Constants.sendGroupChat
        print(url)
        print("..")
        let request = Alamofire.request(.POST, "\(url)", parameters: ["group_unique_id":group_id,"from":from,"type":type,"msg":msg,"from_fullname":fromFullname,"unique_id":uniqueidChat],headers:header).responseJSON { response in
            // You are now running on the concurrent `queue` you created earlier.
            //print("Parsing JSON on thread: \(NSThread.currentThread()) is main thread: \(NSThread.isMainThread())")
            
            // Validate your JSON response and convert into model objects if necessary
            //print(response.result.value) //status, uniqueid
            
            // To update anything on the main thread, just jump back on like so.
            //print("\(chatstanza) ..  \(response)")
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
                
                
                
                
                
                
                
                /////    dispatch_async(dispatch_get_main_queue()) {
                //print("Am I back on the main thread: \(NSThread.isMainThread())")
                
                print("MAINNNNNNNNNNNN")
                completion(result: true)
                //self.retrieveChatFromSqlite(self.selectedContact)
                
                
                
                
                /////// }
            }
            else{
                completion(result: false)
                
            }
        }//)
        
    }
    
    
    func retrieveSingleChatsAndGroupsChatData(completion:(result:Bool)->())
    {
        
        var messages2=NSMutableArray()
        var ContactsLastMsgDate=""
        var ContactLastMessage=""
        //self.ContactIDs.removeAll(keepCapacity: false)
        var ContactLastNAme=""
        var ContactNames=""
        var ContactStatus=""
        var ContactUsernames=""
        var ContactOnlineStatus=0
        ////////////////////////
        var ContactFirstname=""
        ////////
        
        var ContactsPhone=""
        ////self.ContactsEmail.removeAll(keepCapacity: false)
        //////self.ContactMsgRead.removeAll(keepCapacity: false)
        var ContactCountMsgRead=0
        var ContactsProfilePic=NSData.init()
        var ChatType=""
        
        
        groupsObjectList=sqliteDB.getGroupDetails()
        
        for(var i=0;i<groupsObjectList.count;i++)
        {print("date is \(groupsObjectList[i]["date_creation"] as! NSDate)")
            
            if((groupsObjectList[i]["status"] as! String) == "temp")
            {
                print("group_failed called")
                ChatType="group_failed"
                
                //ChatType.append("group_failed")
            }
            else
            {
                ChatType="group"
                //ChatType.append("group")
            }
            print("group name is \(groupsObjectList[i]["group_name"] as! String)")
             ContactNames=groupsObjectList[i]["group_name"] as! String
            ContactFirstname=groupsObjectList[i]["group_name"] as! String
            ContactLastNAme=""
           
            // ContactNames.append(groupsObjectList[i]["group_name"] as! String)
            //ContactFirstname.append(groupsObjectList[i]["group_name"] as! String)
            //ContactLastNAme.append("")
            
            var formatter2 = NSDateFormatter();
            formatter2.dateFormat = "MM/dd hh:mm a"
            formatter2.timeZone = NSTimeZone.localTimeZone()
            ///////////////==========var defaultTimeeee = formatter2.stringFromDate(defaultTimeZoneStr!)
            var defaultTimeeee = formatter2.stringFromDate(groupsObjectList[i]["date_creation"] as! NSDate)
            
            
            
            ContactStatus=""
            ContactUsernames=groupsObjectList[i]["unique_id"] as! String
            ContactOnlineStatus=0
            
            ContactsPhone=groupsObjectList[i]["unique_id"] as! String
           
            
            /*
            self.ContactStatus.append("")
            self.ContactUsernames.append(groupsObjectList[i]["unique_id"] as! String)
            ContactOnlineStatus.append(0)
            
            self.ContactsPhone.append(groupsObjectList[i]["unique_id"] as! String)
            */
            
            
            //check unread for group
            var unreadcount=sqliteDB.getGroupsUnreadMessagesCount(groupsObjectList[i]["unique_id"] as! String)
            //===================================
            ContactCountMsgRead=unreadcount
            
            
            //check file table and get path
            //NSData at contents at path
            
            var filedata=sqliteDB.getFilesData(groupsObjectList[i]["unique_id"] as! String)
            if(filedata.count>0)
            {
                print("found group icon")
                print("actual path is \(filedata["file_path"])")
                //======
                
                //=======
                let dirPaths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
                let docsDir1 = dirPaths[0]
                var documentDir=docsDir1 as NSString
                var imgPath=documentDir.stringByAppendingPathComponent(filedata["file_name"] as! String)
                
                var imgNSData=NSFileManager.defaultManager().contentsAtPath(imgPath)
                
                // print("found path is \(imgNSData)")
                if(imgNSData != nil)
                {
                    ContactsProfilePic=imgNSData!
                }
                else
                {
                    print("didnot find group icon")
                    ContactsProfilePic=NSData.init()
                }
            }
            else
            {
                print("didnot find group icon")
                ContactsProfilePic=NSData.init()
            }
          
            
            let from = Expression<String>("from")
            let group_unique_id = Expression<String>("group_unique_id")
            let type = Expression<String>("type")
            let msg = Expression<String>("msg")
            let from_fullname = Expression<String>("from_fullname")
            let date = Expression<NSDate>("date")
            let unique_id = Expression<String>("unique_id")
            
            
            var tbl_groupchats=sqliteDB.group_chat
            
            let myquerylastmsg=tbl_groupchats.filter(group_unique_id==(groupsObjectList[i]["unique_id"] as! String)).order(date.desc)
            
            var queryruncount=0
            
            var chatexists=false
            
            
            do{for ccclastmsg in try sqliteDB.db.prepare(myquerylastmsg) {
                print("date received in chat view is \(ccclastmsg[date])")
            
                var formatter2 = NSDateFormatter();
                formatter2.dateFormat = "MM/dd hh:mm a"
                formatter2.timeZone = NSTimeZone.localTimeZone()
                ///////////////==========var defaultTimeeee = formatter2.stringFromDate(defaultTimeZoneStr!)
                var defaultTimeeee = formatter2.stringFromDate(ccclastmsg[date])
                print("===fetch date from database is ccclastmsg[date] \(ccclastmsg[date])... defaultTimeeee \(defaultTimeeee)")
             
                
                print("last msg is \(ccclastmsg[msg])")
                ContactsLastMsgDate=defaultTimeeee
                ContactLastMessage=ccclastmsg[msg]
                
                chatexists=true
                break
                }}catch{
                    print("error in fetching last msg")
            }
            if(chatexists==false)
            {
                ContactsLastMsgDate=defaultTimeeee
                ContactLastMessage="Welcome to the group"
            }
            /*
             var ContactsLastMsgDate=""
             var ContactLastMessage=""
             //self.ContactIDs.removeAll(keepCapacity: false)
             var ContactLastNAme=""
             var ContactNames=""
             var ContactStatus=""
             var ContactUsernames=""
             var ContactOnlineStatus=0
             ////////////////////////
             var ContactFirstname=""
             ////////
             
             var ContactsPhone=""
             ////self.ContactsEmail.removeAll(keepCapacity: false)
             //////self.ContactMsgRead.removeAll(keepCapacity: false)
             var ContactCountMsgRead=0
             var ContactsProfilePic=NSData.init()
             var ChatType=""
 */
            messages2.addObject(["ContactsLastMsgDate":ContactsLastMsgDate,"ContactLastMessage":ContactLastMessage,"ContactLastNAme":ContactLastNAme,"ContactNames":ContactNames,"ContactStatus":ContactStatus,"ContactUsernames":ContactUsernames,"ContactOnlineStatus":ContactOnlineStatus,"ContactFirstname":ContactFirstname,"ContactsPhone":ContactsPhone,"ContactCountMsgRead":ContactCountMsgRead,"ContactsProfilePic":ContactsProfilePic,"ChatType":ChatType])
            
        }
        //=============================-----------------------------
        let tbl_userchats=sqliteDB.userschats
        let tbl_contactslists=sqliteDB.contactslists
        let tbl_allcontacts=sqliteDB.allcontacts
        let to = Expression<String>("to")
        let from = Expression<String>("from")
        let date = Expression<NSDate>("date")
        let msg = Expression<String>("msg")
        let fromFullName = Expression<String>("fromFullName")
        
        
        let uniqueid = Expression<String>("uniqueid")
        
        
        
        let contactPhone = Expression<String>("contactPhone")
        /////////// let contactProfileImage = Expression<NSData>("profileimage")
        let uniqueidentifier = Expression<String>("uniqueidentifier")
        
        // let myquery=tbl_userchats.join(tbl_contactslists, on: tbl_contactslists[phone] == tbl_userchats[contactPhone]).group(tbl_userchats[contactPhone]).order(date.desc)
        
        let myquery=tbl_userchats.group(tbl_userchats[contactPhone]).order(date.desc)
        
        var queryruncount=0
        do{for ccc in try sqliteDB.db.prepare(myquery) {
            queryruncount=queryruncount+1
            print("queryruncount is \(queryruncount)")
            var picfound=false
            // print(ccc[phone])
            print(ccc[contactPhone])
            print(ccc[msg])
            print(ccc[date])
            
            /*Alamofire.request(.POST,"\(Constants.MainUrl+Constants.urllog)",headers:header,parameters: ["data":"IPHONE_LOG: database date is \(ccc[date])"]).response{
             request, response_, data, error in
             print(error)
             }*/
            print(ccc[uniqueid])
            //////print(ccc[tbl_userchats[status]])
            print(ccc[status])
            print(ccc[from])
            print(ccc[fromFullName])
           
            print("*************")
            ////////////ContactNames.append(ccc[firstname]+" "+ccc[lastname])
            //ContactUsernames.append(ccc[username])
            //print("ContactUsernames is \(ccc[username])")
            // %%%%%%%%%%%%%%%%************ CHAT BUG ID %%%%%%%%%%%
            // ContactIDs.append(ccc[contactid])
            // ContactIDs.append(tblContacts[userid])
            
            
            var nameFoundInAddressBook=false
            let myquery1=tbl_userchats.join(tbl_contactslists, on: tbl_contactslists[phone] == ccc[contactPhone])//.group(tbl_userchats[contactPhone]).order(date.desc)
            
            //  var queryruncount=0
            //do{
            for ccc1 in try sqliteDB.db.prepare(myquery1) {
                nameFoundInAddressBook=true
               //print("name found \(ccc1[firstname]+" "+ccc1[lastname])")
                ContactNames=ccc1[firstname]!+" "+ccc1[lastname]!
                ContactFirstname=ccc1[firstname]!
                ContactLastNAme=ccc1[lastname]!
                break
                
            }
            if(nameFoundInAddressBook==false)
            {
                let myquery3=tbl_userchats.filter(tbl_userchats[from] != username && tbl_userchats[contactPhone]==ccc[contactPhone])
                
                
                for ccc3 in try sqliteDB.db.prepare(myquery3) {
                    print("name not found \(ccc[fromFullName])")
                    ContactNames=ccc3[fromFullName]
                    ContactFirstname=ccc3[fromFullName]
                    ContactLastNAme=""
                    break
                    
                }
                //ccc[fromFullName]
                
                
            }
            
            ContactStatus="Hey there! I am using Kibo App"
            
            ////////////// ContactUsernames.append(ccc[phone])
            
            
            ContactUsernames=ccc[contactPhone]
            ///// ContactsEmail.append(ccc[email])
            /////ContactsPhone.append(ccc[phone])
            ContactsPhone=ccc[contactPhone]
            ContactOnlineStatus=0
            
            ChatType="single"
            
            
            let myquerylastmsg=tbl_userchats.filter(to==ccc[contactPhone] || from==ccc[contactPhone]).order(date.desc)
            
            var queryruncount=0
            
            
            
            
            do{for ccclastmsg in try sqliteDB.db.prepare(myquerylastmsg) {
                print("date received in chat view is \(ccclastmsg[date])")
             
                
                var formatter2 = NSDateFormatter();
                formatter2.dateFormat = "MM/dd hh:mm a"
                formatter2.timeZone = NSTimeZone.localTimeZone()
                ///////////////==========var defaultTimeeee = formatter2.stringFromDate(defaultTimeZoneStr!)
                var defaultTimeeee = formatter2.stringFromDate(ccclastmsg[date])
                print("===fetch date from database is ccclastmsg[date] \(ccclastmsg[date])... defaultTimeeee \(defaultTimeeee)")
                
           
                
                print("last msg is \(ccclastmsg[msg])")
                ContactsLastMsgDate=defaultTimeeee
                ContactLastMessage=ccclastmsg[msg]
                break
                }}catch{
                    print("error in fetching last msg")
            }
            //////ContactLastMessage.append(ccc[msg])
            
            // print("date of chat view page is to be converted \(ccc[date])")
            
            
            /// ContactsLastMsgDate.append(defaultTimeeee)
            ///////==========ContactsLastMsgDate.append(ccc[date])
            
            //do join query of allcontacts and contactslist table to get avatar
            
            
            
          
            var joinrows=self.leftJoinContactsTables(ccc[contactPhone])
            if(joinrows.count>0)
            {print(joinrows.debugDescription)
                print("found uniqueidentifier from join is \(joinrows[0].get(uniqueidentifier))")
                //==========----------let queryPic = tbl_allcontacts.filter(tbl_allcontacts[phone] == ccc[contactPhone])
                
                //do{
                //=======------- for picquery in try sqliteDB.db.prepare(queryPic) {
                
                let contactStore = CNContactStore()
                
                var keys = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactEmailAddressesKey, CNContactPhoneNumbersKey, CNContactImageDataAvailableKey,CNContactThumbnailImageDataKey, CNContactImageDataKey]
                //--- var foundcontact=try contactStore.unifiedContactWithIdentifier(picquery[uniqueidentifier], keysToFetch: keys)
                var foundcontact=try contactStore.unifiedContactWithIdentifier(joinrows[0].get(uniqueidentifier), keysToFetch: keys)
                
                if(foundcontact.imageDataAvailable==true)
                {
                    foundcontact.imageData
                    ContactsProfilePic=foundcontact.imageData!
                    picfound=true
                }
                
                
            }
            if(picfound==false)
            {
                ContactsProfilePic=NSData.init()
                // print("picquery NOT found for \(ccc[phone]) and is \(NSData.init())")
            }
            /*
             String countQuery = "SELECT  * FROM " + UserChat.TABLE_USERCHAT + " WHERE status = 'delivered' AND contact_phone = '"+ contact_phone +"'";
             SQLiteDatabase db = this.getReadableDatabase();
             Cursor cursor = db.rawQuery(countQuery, null);
             int rowCount = cursor.getCount();
             db.close();
             cursor.close();
             
             // return row count
             return rowCount;
             
             let query = tbl_userchats.filter(contactPhone == ccc[phone] && status == "delivered")          // SELECT "email" FROM "users"
             
             
             allkiboContactsArray = Array(try sqliteDB.db.prepare(query))
             */
            let query = tbl_userchats.filter(from == ccc[contactPhone] && status == "delivered")          // SELECT "email" FROM "users"
            
            
            allkiboContactsArray = Array(try sqliteDB.db.prepare(query))
            if(allkiboContactsArray.first==nil)
            {
                ContactCountMsgRead=0
            }
            else{
                ContactCountMsgRead=allkiboContactsArray.count
            }
            
            messages2.addObject(["ContactsLastMsgDate":ContactsLastMsgDate,"ContactLastMessage":ContactLastMessage,"ContactLastNAme":ContactLastNAme,"ContactNames":ContactNames,"ContactStatus":ContactStatus,"ContactUsernames":ContactUsernames,"ContactOnlineStatus":ContactOnlineStatus,"ContactFirstname":ContactFirstname,"ContactsPhone":ContactsPhone,"ContactCountMsgRead":ContactCountMsgRead,"ContactsProfilePic":ContactsProfilePic,"ChatType":ChatType])
            }
            
            }
        catch{
            
        }
        messages.setArray(messages2 as [AnyObject])
        return completion(result:true)
    }
    
   /* func fetchContacts(completion:(result:Bool)->()){
        
        
         var picfound=false
        if(socketObj != nil){
        socketObj.socket.emit("logClient","IPHONE-LOG: fetch contacts from sqlite database")
        }
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
          let _id = Expression<String>("_id")
        
        let to = Expression<String>("to")
        let from = Expression<String>("from")
        let date = Expression<NSDate>("date")
        let msg = Expression<String>("msg")
        let fromFullName = Expression<String>("fromFullName")
       
        
        let uniqueid = Expression<String>("uniqueid")
        
        
        
        let contactPhone = Expression<String>("contactPhone")
       /////////// let contactProfileImage = Expression<NSData>("profileimage")
        let uniqueidentifier = Expression<String>("uniqueidentifier")
        
        //contactPhone
        //-========Remove old values=====================
        self.ContactsLastMsgDate.removeAll(keepCapacity: false)
        self.ContactLastMessage.removeAll(keepCapacity: false)
        //self.ContactIDs.removeAll(keepCapacity: false)
        self.ContactLastNAme.removeAll(keepCapacity: false)
        self.ContactNames.removeAll(keepCapacity: false)
        self.ContactStatus.removeAll(keepCapacity: false)
        self.ContactUsernames.removeAll(keepCapacity: false)
        self.ContactsObjectss.removeAll(keepCapacity: false)
        ContactOnlineStatus.removeAll(keepCapacity: false)
        ////////////////////////
        self.ContactFirstname.removeAll(keepCapacity: false)
        ////////
        
        self.ContactsPhone.removeAll(keepCapacity: false)
        ////self.ContactsEmail.removeAll(keepCapacity: false)
        //////self.ContactMsgRead.removeAll(keepCapacity: false)
        self.ContactCountMsgRead.removeAll(keepCapacity: false)
        self.ContactsProfilePic.removeAll(keepCapacity: false)
        self.ChatType.removeAll(keepCapacity: false)
        
        
        groupsObjectList=sqliteDB.getGroupDetails()
        for(var i=0;i<groupsObjectList.count;i++)
        {print("date is \(groupsObjectList[i]["date_creation"] as! NSDate)")
            
        if((groupsObjectList[i]["status"] as! String) == "temp")
            {
                print("group_failed called")
                
                ChatType.append("group_failed")
            }
            else
            {
            ChatType.append("group")
            }
            print("group name is \(groupsObjectList[i]["group_name"] as! String)")
        ContactNames.append(groupsObjectList[i]["group_name"] as! String)
            ContactFirstname.append(groupsObjectList[i]["group_name"] as! String)
            ContactLastNAme.append("")
            
            var formatter2 = NSDateFormatter();
            formatter2.dateFormat = "MM/dd hh:mm a"
            formatter2.timeZone = NSTimeZone.localTimeZone()
            ///////////////==========var defaultTimeeee = formatter2.stringFromDate(defaultTimeZoneStr!)
            var defaultTimeeee = formatter2.stringFromDate(groupsObjectList[i]["date_creation"] as! NSDate)
            
            
            //self.ContactsLastMsgDate.append(defaultTimeeee)
            //self.ContactLastMessage.append("You created this group") 
           
            self.ContactStatus.append("")
            self.ContactUsernames.append(groupsObjectList[i]["unique_id"] as! String)
            //self.ContactsObjectss.removeAll(keepCapacity: false)
            ContactOnlineStatus.append(0)
            ////////////////////////
           // self.ContactFirstname.removeAll(keepCapacity: false)
            ////////
            
            self.ContactsPhone.append(groupsObjectList[i]["unique_id"] as! String)
            ////self.ContactsEmail.removeAll(keepCapacity: false)
            //////self.ContactMsgRead.removeAll(keepCapacity: false)
            
            
            
            //check unread for group
         var unreadcount=sqliteDB.getGroupsUnreadMessagesCount(groupsObjectList[i]["unique_id"] as! String)
          //===================================
            self.ContactCountMsgRead.append(unreadcount)
            
            
            //check file table and get path
            //NSData at contents at path
            
            var filedata=sqliteDB.getFilesData(groupsObjectList[i]["unique_id"] as! String)
            if(filedata.count>0)
            {
                print("found group icon")
                print("actual path is \(filedata["file_path"])")
                //======
             
                //=======
                let dirPaths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
                let docsDir1 = dirPaths[0]
                var documentDir=docsDir1 as NSString
                var imgPath=documentDir.stringByAppendingPathComponent(filedata["file_name"] as! String)
                
                var imgNSData=NSFileManager.defaultManager().contentsAtPath(imgPath)
                
               // print("found path is \(imgNSData)")
                if(imgNSData != nil)
                {
               self.ContactsProfilePic.append(imgNSData!)
                }
                else
                {
                    print("didnot find group icon")
                    self.ContactsProfilePic.append(NSData.init())
                }
            }
            else
            {
                 print("didnot find group icon")
                self.ContactsProfilePic.append(NSData.init())
            }
            //self.ContactsProfilePic.append(groupsObjectList[i]["group_icon"] as! NSData)
            
            
            let from = Expression<String>("from")
            let group_unique_id = Expression<String>("group_unique_id")
            let type = Expression<String>("type")
            let msg = Expression<String>("msg")
            let from_fullname = Expression<String>("from_fullname")
            let date = Expression<NSDate>("date")
            let unique_id = Expression<String>("unique_id")
            
            
            var tbl_groupchats=sqliteDB.group_chat
            
            let myquerylastmsg=tbl_groupchats.filter(group_unique_id==(groupsObjectList[i]["unique_id"] as! String)).order(date.desc)
            
            var queryruncount=0
            
            var chatexists=false
            
            
            do{for ccclastmsg in try sqliteDB.db.prepare(myquerylastmsg) {
                print("date received in chat view is \(ccclastmsg[date])")
                /* Alamofire.request(.POST,"\(Constants.MainUrl+Constants.urllog)",headers:header,parameters: ["data":"IPHONE-LOG: date received in chat view is \(ccclastmsg[date])"]).response{
                 request, response_, data, error in
                 print(error)
                 }*/
                
                // var formatter = NSDateFormatter();
                //formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS";
                //formatter.dateFormat = "MM/dd hh:mm a"";
                //formatter.timeZone = NSTimeZone(name: "UTC")
                // formatter.timeZone = NSTimeZone.localTimeZone()
                ////////////==========var defaultTimeZoneStr = formatter.dateFromString(ccc[date])
                /////////////====== var defaultTimeZoneStr2 = formatter.stringFromDate(defaultTimeZoneStr!)
                
                
                var formatter2 = NSDateFormatter();
                formatter2.dateFormat = "MM/dd hh:mm a"
                formatter2.timeZone = NSTimeZone.localTimeZone()
                ///////////////==========var defaultTimeeee = formatter2.stringFromDate(defaultTimeZoneStr!)
                var defaultTimeeee = formatter2.stringFromDate(ccclastmsg[date])
                print("===fetch date from database is ccclastmsg[date] \(ccclastmsg[date])... defaultTimeeee \(defaultTimeeee)")
                
                // socketObj.socket.emit("logClient","IPHONE_LOG: ===fetch date from database is ccclastmsg[date] \(ccclastmsg[date])... defaultTimeeee \(defaultTimeeee)")
                
                /* Alamofire.request(.POST,"\(Constants.MainUrl+Constants.urllog)",headers:header,parameters: ["data":"IPHONE_LOG: ===fetch date from database is ccclastmsg[date] \(ccclastmsg[date])... defaultTimeeee \(defaultTimeeee)"]).response{
                 request, response_, data, error in
                 print(error)
                 }*/
                
                
                print("last msg is \(ccclastmsg[msg])")
                ContactsLastMsgDate.append(defaultTimeeee)
                ContactLastMessage.append(ccclastmsg[msg])
                
                chatexists=true
                break
                }}catch{
                    print("error in fetching last msg")
            }
            if(chatexists==false)
{
    self.ContactsLastMsgDate.append(defaultTimeeee)
    self.ContactLastMessage.append("Welcome to the group")
}
        
        }
        
       // ContactNames.append(ccc1[firstname]+" "+ccc1[lastname])
        
        
        /*
        let stmt = try db.prepare("SELECT id, email FROM users")
        for row in stmt {
        for (index, name) in stmt.columnNames.enumerate() {
        print ("\(name)=\(row[index]!)")
        // id: Optional(1), email: Optional("alice@mac.com")
        }
        }
        
         SELECT date, contact_phone, display_name, msg, contacts._id FROM userchat, contacts WHERE contacts.phone = userchat.contact_phone GROUP BY contact_phone ORDER BY date DESC
        
        SELECT firstname,to,lastname,username,contactid,status,email,phone from tbl_contactslists,tbl_userchats WHERE tbl_contactslists.phone==tbl_userchats.to GROUP BY to
        
        for row in stmt {
        for (index, name) in stmt.columnNames.enumerate() {
        print ("\(name)=\(row[index]!)")
        // id: Optional(1), email: Optional("alice@mac.com")
        }
        }
        
        
        
        let query = prices.select(defindex, average(price))
        .filter(quality == 5 && price_index != 0)
        .group(defindex)
        .order(average(price).desc)
        let rows = Array(query)
        
        SELECT firstname,to,lastname,username,contactid,status,email,phone from tbl_contactslists,tbl_userchats WHERE tbl_contactslists.phone==tbl_userchats.to GROUP BY to
        */
        
       
        
         let tbl_userchats=sqliteDB.userschats
        let tbl_contactslists=sqliteDB.contactslists
        let tbl_allcontacts=sqliteDB.allcontacts
        
        
       // let myquery=tbl_userchats.join(tbl_contactslists, on: tbl_contactslists[phone] == tbl_userchats[contactPhone]).group(tbl_userchats[contactPhone]).order(date.desc)
        
        let myquery=tbl_userchats.group(tbl_userchats[contactPhone]).order(date.desc)
        
        var queryruncount=0
        do{for ccc in try sqliteDB.db.prepare(myquery) {
            queryruncount=queryruncount+1
            print("queryruncount is \(queryruncount)")
             var picfound=false
           // print(ccc[phone])
            print(ccc[contactPhone])
            print(ccc[msg])
            print(ccc[date])
            
            /*Alamofire.request(.POST,"\(Constants.MainUrl+Constants.urllog)",headers:header,parameters: ["data":"IPHONE_LOG: database date is \(ccc[date])"]).response{
                request, response_, data, error in
                print(error)
            }*/
            print(ccc[uniqueid])
            //////print(ccc[tbl_userchats[status]])
            print(ccc[status])
            print(ccc[from])
            print(ccc[fromFullName])
       //   print("===fetch date from database is tblContacts[date] ... date converted is \(defaultTimeZoneStr)... string is \(defaultTimeZoneStr2)... defaultTimeeee \(defaultTimeeee)")
            /*
            var formatter = NSDateFormatter();
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS";
            //formatter.dateFormat = "MM/dd hh:mm a"";
            formatter.timeZone = NSTimeZone.localTimeZone()
            var defaultTimeZoneStr = formatter.dateFromString(ccc[date])
            print("defaultTimeZoneStr \(defaultTimeZoneStr)")
            
            var formatter2 = NSDateFormatter();
            formatter2.timeZone=NSTimeZone.localTimeZone()
            formatter2.dateFormat = "MM/dd hh:mm a"";
            var displaydate=formatter2.stringFromDate(defaultTimeZoneStr!)
 */
           // timeLabel.text=displaydate

            
            
         /*
            var formatter = NSDateFormatter();
          //  formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ";
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZ"
            //formatter.dateFormat = "MM/dd hh:mm a"";
            formatter.timeZone = NSTimeZone.localTimeZone()
            //formatter.dateStyle = .ShortStyle
            //formatter.timeStyle = .ShortStyle
            //let defaultTimeZoneStr2 = formatter.stringFromDate(date22);
            //var d=ccc[date] as! NSDate
           var datezulo = formatter.dateFromString(ccc[date].debugDescription)
            print("default db date is \(datezulo)")
            
           
            
           // var date22=NSDate()
            let formatter2 = NSDateFormatter()
            formatter2.dateFormat = "MM/dd hh:mm a""
            /////// formatter.dateStyle = NSDateFormatterStyle.ShortStyle
            //////formatter.timeStyle = .ShortStyle
            
            let dateString = formatter2.stringFromDate(datezulo!)
            print("dateeeeeee \(dateString)")
            
            */
            print("*************")
            ////////////ContactNames.append(ccc[firstname]+" "+ccc[lastname])
            //ContactUsernames.append(ccc[username])
            //print("ContactUsernames is \(ccc[username])")
            // %%%%%%%%%%%%%%%%************ CHAT BUG ID %%%%%%%%%%%
           // ContactIDs.append(ccc[contactid])
            // ContactIDs.append(tblContacts[userid])
            
            
            var nameFoundInAddressBook=false
             let myquery1=tbl_userchats.join(tbl_contactslists, on: tbl_contactslists[phone] == ccc[contactPhone])//.group(tbl_userchats[contactPhone]).order(date.desc)
        
              //  var queryruncount=0
        //do{
            for ccc1 in try sqliteDB.db.prepare(myquery1) {
            nameFoundInAddressBook=true
                print("name found \(ccc1[firstname]+" "+ccc1[lastname])")
               ContactNames.append(ccc1[firstname]+" "+ccc1[lastname])
                ContactFirstname.append(ccc1[firstname])
                ContactLastNAme.append(ccc1[lastname])
                break

            }
            if(nameFoundInAddressBook==false)
            {
                let myquery3=tbl_userchats.filter(tbl_userchats[from] != username && tbl_userchats[contactPhone]==ccc[contactPhone])
                
                
                for ccc3 in try sqliteDB.db.prepare(myquery3) {
                    print("name not found \(ccc[fromFullName])")
                    ContactNames.append(ccc3[fromFullName])
                    ContactFirstname.append(ccc3[fromFullName])
                    ContactLastNAme.append("")
                    break
                    
                }
                    //ccc[fromFullName]
               

            }
            
            ContactStatus.append("Hey there! I am using Kibo App")
            
            ////////////// ContactUsernames.append(ccc[phone])
            
            
            ContactUsernames.append(ccc[contactPhone])
           ///// ContactsEmail.append(ccc[email])
            /////ContactsPhone.append(ccc[phone])
            ContactsPhone.append(ccc[contactPhone])
            ContactOnlineStatus.append(0)
            
            ChatType.append("single")
            
            
            let myquerylastmsg=tbl_userchats.filter(to==ccc[contactPhone] || from==ccc[contactPhone]).order(date.desc)
            
            var queryruncount=0
            
           
            
            
            do{for ccclastmsg in try sqliteDB.db.prepare(myquerylastmsg) {
                print("date received in chat view is \(ccclastmsg[date])")
               /* Alamofire.request(.POST,"\(Constants.MainUrl+Constants.urllog)",headers:header,parameters: ["data":"IPHONE-LOG: date received in chat view is \(ccclastmsg[date])"]).response{
                    request, response_, data, error in
                    print(error)
                }*/
                
                // var formatter = NSDateFormatter();
                //formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS";
                //formatter.dateFormat = "MM/dd hh:mm a"";
                //formatter.timeZone = NSTimeZone(name: "UTC")
                // formatter.timeZone = NSTimeZone.localTimeZone()
                ////////////==========var defaultTimeZoneStr = formatter.dateFromString(ccc[date])
                /////////////====== var defaultTimeZoneStr2 = formatter.stringFromDate(defaultTimeZoneStr!)
                
                
                var formatter2 = NSDateFormatter();
                formatter2.dateFormat = "MM/dd hh:mm a"
                formatter2.timeZone = NSTimeZone.localTimeZone()
                ///////////////==========var defaultTimeeee = formatter2.stringFromDate(defaultTimeZoneStr!)
                var defaultTimeeee = formatter2.stringFromDate(ccclastmsg[date])
                print("===fetch date from database is ccclastmsg[date] \(ccclastmsg[date])... defaultTimeeee \(defaultTimeeee)")
        
               // socketObj.socket.emit("logClient","IPHONE_LOG: ===fetch date from database is ccclastmsg[date] \(ccclastmsg[date])... defaultTimeeee \(defaultTimeeee)")
                
               /* Alamofire.request(.POST,"\(Constants.MainUrl+Constants.urllog)",headers:header,parameters: ["data":"IPHONE_LOG: ===fetch date from database is ccclastmsg[date] \(ccclastmsg[date])... defaultTimeeee \(defaultTimeeee)"]).response{
                    request, response_, data, error in
                    print(error)
                }*/
                
                
                print("last msg is \(ccclastmsg[msg])")
                ContactsLastMsgDate.append(defaultTimeeee)
                ContactLastMessage.append(ccclastmsg[msg])
                break
                }}catch{
                    print("error in fetching last msg")
                }
            //////ContactLastMessage.append(ccc[msg])
            
           // print("date of chat view page is to be converted \(ccc[date])")
            
            
           /// ContactsLastMsgDate.append(defaultTimeeee)
            ///////==========ContactsLastMsgDate.append(ccc[date])
            
            //do join query of allcontacts and contactslist table to get avatar
            
            
            
            
            /*
             let keys = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactEmailAddressesKey, CNContactBirthdayKey, CNContactImageDataKey]
             
             do {
             let contactRefetched = try AppDelegate.getAppDelegate().contactStore.unifiedContactWithIdentifier(contact.identifier, keysToFetch: keys)
             self.contacts[indexPath.row] = contactRefetched
             
             dispatch_async(dispatch_get_main_queue(), { () -> Void in
             self.tblContacts.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
             })
             }
             catch {
             print("Unable to refetch the contact: \(contact)", separator: "", terminator: "\n")
             }
 */
            
          
            
          ////  let queryPic = tbl_allcontacts.filter(tbl_allcontacts[phone] == ccc[phone])          // SELECT "email" FROM "users"
            
            var joinrows=self.leftJoinContactsTables(ccc[contactPhone])
            if(joinrows.count>0)
            {print(joinrows.debugDescription)
            print("found uniqueidentifier from join is \(joinrows[0].get(uniqueidentifier))")
            //==========----------let queryPic = tbl_allcontacts.filter(tbl_allcontacts[phone] == ccc[contactPhone])
           
            //do{
               //=======------- for picquery in try sqliteDB.db.prepare(queryPic) {
                    
                    let contactStore = CNContactStore()
                    
                    var keys = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactEmailAddressesKey, CNContactPhoneNumbersKey, CNContactImageDataAvailableKey,CNContactThumbnailImageDataKey, CNContactImageDataKey]
                   //--- var foundcontact=try contactStore.unifiedContactWithIdentifier(picquery[uniqueidentifier], keysToFetch: keys)
            var foundcontact=try contactStore.unifiedContactWithIdentifier(joinrows[0].get(uniqueidentifier), keysToFetch: keys)
            
            if(foundcontact.imageDataAvailable==true)
                    {
                    foundcontact.imageData
                        ContactsProfilePic.append(foundcontact.imageData!)
                        picfound=true
                    }
                    
                   // if(contactProfileImage != NSData.init())
                    //{
                  //  print("picquery found for \(ccc[phone]) and is \(picquery[contactProfileImage]) count is \(ContactsProfilePic.count) ... \(picquery[phone]) .... \(ccc[phone])")
                //////////^^^^^ContactsProfilePic.append(picquery[contactProfileImage])
                //////////^^^^^^^^^picfound=true
                 // print("profilepicarray count is \(ContactsProfilePic.count)")
                    //}
                    /*else
                    {
                        
                    }*/
               //--------======= }
            /*}
            catch
                {
                    Alamofire.request(.POST,"\(Constants.MainUrl+Constants.urllog)",headers:header,parameters: ["data":"IPHONE_LOG: error in fetching profile image"]).response{
                        request, response_, data, error in
                        print(error)
                    }
                    
                    
                   // print("error in fetching profile image")
                }
            */
            
            }
            if(picfound==false)
            {
                ContactsProfilePic.append(NSData.init())
               // print("picquery NOT found for \(ccc[phone]) and is \(NSData.init())")
            }
             /*
             String countQuery = "SELECT  * FROM " + UserChat.TABLE_USERCHAT + " WHERE status = 'delivered' AND contact_phone = '"+ contact_phone +"'";
             SQLiteDatabase db = this.getReadableDatabase();
             Cursor cursor = db.rawQuery(countQuery, null);
             int rowCount = cursor.getCount();
             db.close();
             cursor.close();
             
             // return row count
             return rowCount;
             
             let query = tbl_userchats.filter(contactPhone == ccc[phone] && status == "delivered")          // SELECT "email" FROM "users"
             
             
             allkiboContactsArray = Array(try sqliteDB.db.prepare(query))
             */
            let query = tbl_userchats.filter(from == ccc[contactPhone] && status == "delivered")          // SELECT "email" FROM "users"
            
            
            allkiboContactsArray = Array(try sqliteDB.db.prepare(query))
            if(allkiboContactsArray.first==nil)
            {
                ContactCountMsgRead.append(0)
            }
            else{
            ContactCountMsgRead.append(allkiboContactsArray.count)
}
            /*
             if(ccc[tbl_userchats[status]] == "delivered")
            {
                if(ccc[from] == ccc[phone])
                {
                    ContactMsgRead.append("show")
                }
                else
                {
                    ContactMsgRead.append("not show")
                }
            }
            else{
                ContactMsgRead.append("not show")
            }
            */
            }
            print("picccc count is \(ContactsProfilePic.count)")
            
              return completion(result:true)
        }
            catch
            {
                print("error here")
            }
        

        
    }*/
    
    
    //======================================
    //to fetch contacts from server
    
   
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func unwindToChat (segueSelected : UIStoryboardSegue) {
        print("unwind chat", terminator: "")
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        
        return self.messages.count
        //==--return ContactUsernames.count
    }
    

    //uncomment later
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
      print("tableheader")
        
        var cellview=UIView.init()
        
        let cell = tblForChat.dequeueReusableCellWithIdentifier("NewGroupCell") as! ContactsListCell
        btnNewGroup=cell.btnNewGroupOutlet
        
        cell.btnNewGroupOutlet.tag=section
        cell.btnNewGroupOutlet.addTarget(self, action: Selector("BtnnewGroupClicked:"), forControlEvents:.TouchUpInside)
       // cell.setEditing(true, animated: true)
        /*
         [cell.yourbutton addTarget:self action:@selector(yourButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
         3) Code actions based on index as below in ViewControler:
         
         -(void)yourButtonClicked:(UIButton*)sender
         {
         if (sender.tag == 0)
         {
         // Your code here
         }
         }
 */
        
        cellview.addSubview(cell)
        return cellview
//        return nil
    }

 
    
    
    func BtnnewGroupClicked(sender:UIButton)
    {
        
        
        let contactPickerScene = EPContactsPicker(delegate: self, multiSelection:true, subtitleCellType: SubtitleCellValue.PhoneNumber)
        let navigationController = UINavigationController(rootViewController: contactPickerScene)
        self.presentViewController(navigationController, animated: true, completion: nil)
        

      
        participantsSelected.removeAll()
        print("BtnnewGroupClicked")
        picker = CNContactPickerViewController();
        picker.title="Add Participants"
        picker.navigationItem.leftBarButtonItem=picker.navigationController?.navigationItem.backBarButtonItem
    
        picker.predicateForEnablingContact = NSPredicate.init(value: true) //.fromValue(true); // make everything selectable
        
        // Respond to selection
        picker.delegate = self;
        self.presentViewController(picker, animated: true, completion: nil)
 
 
        
        // Display picker
        
       // UIApplication.sharedApplication().keyWindow!.rootViewController!.presentViewController(picker, animated: true, completion: nil);
        
        
    }
    
    
    func epContactPicker(_: EPContactsPicker, didContactFetchFailed error : NSError)
    {
        print("Failed with error \(error.description)")
    }
    
    func epContactPicker(_: EPContactsPicker, didSelectContact contact : EPContact)
    {
        print("Contact \(contact.displayName()) has been selected")
    }
    
    func epContactPicker(_: EPContactsPicker, didCancel error : NSError)
    {
        print("User canceled the selection");
    }
    
    
    
    func epContactPicker(_: EPContactsPicker, didSelectMultipleContacts contacts: [EPContact]) {
        print("The following contacts are selected")
        
        
        
        print("didSelectContacts \(contacts)")
        
        //get seleced participants
        participantsSelected.appendContentsOf(contacts)
        self.performSegueWithIdentifier("newGroupDetailsSegue", sender: nil);
        
        
        for contact in contacts {
            print("\(contact.displayName())")
        }
    }
    
    
    
    
    /*func contactPicker(picker: CNContactPickerViewController, didSelectContacts contacts: [CNContact]) {
        
        print("didSelectContacts \(contacts)")
        
        //get seleced participants
        participantsSelected.appendContentsOf(contacts)
        self.performSegueWithIdentifier("newGroupDetailsSegue", sender: nil);
        
    }
    
    */
    /*
    func contactPicker(picker: CNContactPickerViewController, didSelectContactProperties contactProperties: [CNContactProperty]) {
        
        print("didSelectContactProperties \(contactProperties)")
    }*/

    
    //uncomment later
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        print("header height table")
        return 70
    }
    
    func numberOfSectionsInTableView(tableView: UITableView!) -> Int {
        return 1
    }
    
    
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet() as NSCharacterSet).uppercaseString
        
        if (cString.hasPrefix("#")) {
            cString = cString.substringFromIndex(cString.startIndex.advancedBy(1))
        }
        
        if ((cString.characters.count) != 6) {
            return UIColor.grayColor()
        }
        
        var rgbValue:UInt32 = 0
        NSScanner(string: cString).scanHexInt(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    
    func getRightUtilityButtonsToCell()-> NSMutableArray{
        var utilityButtons: NSMutableArray = NSMutableArray()
        
        
        utilityButtons.sw_addUtilityButtonWithColor(hexStringToUIColor("#DCDEE0"), icon: UIImage(named:"more.png"))
        
        //utilityButtons.sw_addUtilityButtonWithColor(UIColor.redColor(), title: NSLocalizedString("ABC", comment: ""))
        //DCDEE0
        utilityButtons.sw_addUtilityButtonWithColor(hexStringToUIColor("#24669A"), icon: UIImage(named:"archive.png"))
        return utilityButtons
        //24669A
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        
        /*
         var ContactsLastMsgDate=""
         var ContactLastMessage=""
         //self.ContactIDs.removeAll(keepCapacity: false)
         var ContactLastNAme=""
         var ContactNames=""
         var ContactStatus=""
         var ContactUsernames=""
         var ContactOnlineStatus=0
         ////////////////////////
         var ContactFirstname=""
         ////////
         
         var ContactsPhone=""
         ////self.ContactsEmail.removeAll(keepCapacity: false)
         //////self.ContactMsgRead.removeAll(keepCapacity: false)
         var ContactCountMsgRead=0
         var ContactsProfilePic=NSData.init()
         var ChatType=""
 */
        var messageDic = messages.objectAtIndex(indexPath.row) as! [String : AnyObject];
      
        let ContactsLastMsgDate = messageDic["ContactsLastMsgDate"] as! String
        let ContactLastMessage = messageDic["ContactLastMessage"] as! String
        let ContactLastNAme=messageDic["ContactLastNAme"] as! String
        var ContactNames=messageDic["ContactNames"] as! String
        let ContactStatus=messageDic["ContactStatus"] as! String
        let ContactUsernames=messageDic["ContactUsernames"] as! String
        let ContactOnlineStatus=messageDic["ContactOnlineStatus"] as! Int
        let ContactFirstname=messageDic["ContactFirstname"] as! String
        let ContactsPhone=messageDic["ContactsPhone"] as! String
        let ContactCountMsgRead=messageDic["ContactCountMsgRead"] as! Int
        let ContactsProfilePic=messageDic["ContactsProfilePic"] as! NSData
        let ChatType=messageDic["ChatType"] as! NSString
        
        /* if (indexPath.row%2 == 0){
        return tblForChat.dequeueReusableCellWithIdentifier("ChatPrivateCell") as! UITableViewCell
        } else {
        return tblForChat.dequeueReusableCellWithIdentifier("ChatPublicCell")as! UITableViewCell
        }
        */
        //let cellPublic=tblForChat.dequeueReusableCellWithIdentifier("ChatPublicCell") as! ContactsListCell
        let cell=tblForChat.dequeueReusableCellWithIdentifier("ChatPrivateCell") as! ContactsListCell
        //if(ContactUsernames.count > 0)
        //{
        cell.rightUtilityButtons=self.getRightUtilityButtonsToCell() as [AnyObject]
        cell.delegate=self
        var contactFound=false
        cell.newMsg.hidden=true
        cell.countNewmsg.hidden=true
        cell.profilePic.image=UIImage(named: "profile-pic1.png")
        
        ////%%%%%%%%%%%%%cell.contactName?.text=ContactNames[indexPath.row]
        
        /*
        let query = users.join(posts, on: user_id == users[id])
        // SELECT * FROM "users" INNER JOIN "posts" ON ("user_id" = "users"."id")
        
        select * from contacts
        
        */
      //  var allcontacts=sqliteDB.allcontacts
        //var contactsKibo=sqliteDB.contactslists
        
        
        let phone = Expression<String>("phone")
        let usernameFromDb = Expression<String?>("username")
        let name = Expression<String?>("name")
        
        
        cell.statusPrivate.text=ContactLastMessage as! String
        cell.lbltimePrivate.text=ContactsLastMsgDate as! String
    
        
        //cell.statusPrivate.text=ContactLastMessage[indexPath.row]
        //cell.lbltimePrivate.text=ContactsLastMsgDate[indexPath.row]
    
    
    //==----commenting for testing
        /*if(!ContactLastMessage.isEmpty)
        {
        cell.statusPrivate.text=ContactLastMessage[indexPath.row]
        }
            if(!ContactsLastMsgDate.isEmpty)
        {
        cell.lbltimePrivate.text=ContactsLastMsgDate[indexPath.row]
        }*/
        
        
        
        
      //  do
       //// {allkiboContactsArray = Array(try sqliteDB.db.prepare(contactsKibo))
        
        
        
        
        if(ChatType == "single")
        {
            do{
               // if(!ContactUsernames.isEmpty && indexPath.row<=ContactUsernames.count)
               // {
                print("username count is \(messages.count) and indexpath.row is \(indexPath.row)")
              //=====  for all in try sqliteDB.db.prepare(allcontacts) {
                //print("id: \(account[_id]), phone: \(account[phone]), firstname: \(account[firstname])")
                // id: 1, email: alice@mac.com, name: Optional("Alice")
                
                //if(all[phone]==allkiboContactsArray[indexPath.row][username])
                    var matched=self.leftJoinContactsTables(ContactUsernames)
                //==----if(all[phone]==ContactUsernames[indexPath.row])
                 if(matched.count>0)
                {
                    //Matched phone number. Got contact
                    /*if(all[name] != "" || all[name] != nil)
                    {
                        cell.contactName?.text=all[name]
                        print("name is \(all[name])")
                        ContactNames[indexPath.row]=all[name]!
                    }*/
                    if(matched[0][name] != "" || matched[0].get(name) != nil)
                    {
                        cell.contactName?.text=matched[0].get(name)
                        print("name is \(matched[0].get(name))")
                        ContactNames=matched[0].get(name)!
                    }
                    else
                    {
                        print("name is no name")
                        //===---cell.contactName?.text=all[phone]
                        cell.contactName?.text=ContactUsernames as! String
                    }
                    
                   if(ContactsProfilePic != NSData.init())
                    {
                        print("seeting picc22 for \(ContactUsernames)")
                        
                        var img=UIImage(data:ContactsProfilePic)
                        var w=img!.size.width
                        var h=img!.size.height
                        var wOld=cell.profilePic.bounds.width
                        var hOld=cell.profilePic.bounds.height
                        var scale:CGFloat=w/wOld
                        
                        ////self.ResizeImage(img!, targetSize: CGSizeMake(cell.profilePic.bounds.width,cell.profilePic.bounds.height))
                        
                        cell.profilePic.layer.borderWidth = 1.0
                        cell.profilePic.layer.masksToBounds = false
                        cell.profilePic.layer.borderColor = UIColor.whiteColor().CGColor
                        cell.profilePic.layer.cornerRadius = cell.profilePic.frame.size.width/2
                        cell.profilePic.clipsToBounds = true
                        cell.profilePic.image=UIImage(data:ContactsProfilePic, scale: scale)
                        ///cell.profilePic.image=UIImage(data:ContactsProfilePic[indexPath.row])
                        UIImage(data: NSData(data: ContactsProfilePic) , scale: scale)
                        print("image size is s \(UIImage(data:ContactsProfilePic)?.size.width) and h \(UIImage(data:ContactsProfilePic)?.size.height)")
                   }
                    
                    contactFound=true
                    
                }
                
              //====  }
                
       // }//end isempty usernames
             
                
                
                //if(!ContactCountMsgRead.isEmpty)
                //{
                if(Int(ContactCountMsgRead)>0)
                {
                cell.newMsg.hidden=false
                    cell.countNewmsg.text="\(ContactCountMsgRead)"
                    cell.countNewmsg.hidden=false
                }
               // }
            }
            catch
            {
                if(socketObj != nil){
                socketObj.socket.emit("logClient","error in fetching contacts from database..")
                }
                print("error in fetching contacts from database..")
            }
            if(contactFound==false)
            {
            //if(!ContactUsernames.isEmpty && indexPath.row <= ContactUsernames.count)
               // {
                cell.contactName?.text=ContactUsernames
              //  }
              //  if(!ContactCountMsgRead.isEmpty)
                //{
                if(ContactCountMsgRead>0)
                {
                //{
                    cell.newMsg.hidden=false
                    cell.countNewmsg.text="\(ContactCountMsgRead)"
                    cell.countNewmsg.hidden=false
                }
                }
                
                if(/*!ContactsProfilePic.isEmpty  &&*/ ContactsProfilePic != NSData.init())
                {
                    print("seeting picc for \(ContactUsernames)")
                    cell.profilePic.image=UIImage(data:ContactsProfilePic)
                }
            }
        
        else
        {
            cell.contactName?.text=ContactNames
            if(ContactsProfilePic != NSData.init())
            {
                print("seeting picc22 for \(ContactUsernames)")
                
                var img=UIImage(data:ContactsProfilePic)
                var w=img!.size.width
                var h=img!.size.height
                var wOld=cell.profilePic.bounds.width
                var hOld=cell.profilePic.bounds.height
                var scale:CGFloat=w/wOld
                
                ////self.ResizeImage(img!, targetSize: CGSizeMake(cell.profilePic.bounds.width,cell.profilePic.bounds.height))
                
                cell.profilePic.layer.borderWidth = 1.0
                cell.profilePic.layer.masksToBounds = false
                cell.profilePic.layer.borderColor = UIColor.whiteColor().CGColor
                cell.profilePic.layer.cornerRadius = cell.profilePic.frame.size.width/2
                cell.profilePic.clipsToBounds = true
                
                cell.profilePic.image=UIImage(data: ContactsProfilePic, scale: scale)
                ///cell.profilePic.image=UIImage(data:ContactsProfilePic[indexPath.row])
                UIImage(data: ContactsProfilePic, scale: scale)
                print("image size is s \(UIImage(data:ContactsProfilePic)?.size.width) and h \(UIImage(data:ContactsProfilePic)?.size.height)")
            }
            if(ContactCountMsgRead > 0)
            {
            cell.newMsg.hidden=false
            cell.countNewmsg.text="\(ContactCountMsgRead)"
            cell.countNewmsg.hidden=false
            }

        }
    
    
       // }
      //  catch
        //{
        //    socketObj.socket.emit("logClient","error in getching contactss and making one array")
        //    print("error in getching contactss and making one array")
        //}
        
        
        /*
        for(var i=0;i<contacts.count;i++)
        {
        if(contacts[i].isKeyAvailable(CNContactPhoneNumbersKey)) {
        for phoneNumber:CNLabeledValue in contacts[i].phoneNumbers {
        let a = phoneNumber.value as! CNPhoneNumber
        //print("\()
        var phone=a.valueForKey("digits") as! String
        if(phone==ContactUsernames[indexPath.row])
        {
        //Matched phone number. Got contact
        if(contacts[i].givenName != "" || contacts[i].familyName != "")
        {
        cell.contactName?.text=contacts[i].givenName+" "+contacts[i].familyName
        print("name is \(contacts[i].givenName+" "+contacts[i].familyName)")
        ContactNames[indexPath.row]=contacts[i].givenName+" "+contacts[i].familyName
        }
        else
        {
        print("name is no name")
        cell.contactName?.text=phone
        }
        contactFound=true
        
        }
        }
        }
        if(contactFound==false)
        {
        cell.contactName?.text=ContactUsernames[indexPath.row]
        }
        }*/
        
        
        // %%%%%%%%%%%%%%%%%%%%%%%%%_------------------------- need to show names also ------
 
        if (ContactOnlineStatus==0)
        {
            cell.btnGreenDot.hidden=true
        }
        else
        {
            cell.btnGreenDot.hidden=false
        }
        
        //}
        return cell
        
    }
    
    func ResizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / image.size.width
        let heightRatio = targetSize.height / image.size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSizeMake(size.width * heightRatio, size.height * heightRatio)
        } else {
            newSize = CGSizeMake(size.width * widthRatio,  size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRectMake(0, 0, newSize.width, newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.drawInRect(rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!){
        var messageDic = messages.objectAtIndex(indexPath.row) as! [String : AnyObject];
        
        
        let ContactsLastMsgDate = messageDic["ContactsLastMsgDate"] as! String
        let ContactLastMessage = messageDic["ContactLastMessage"] as! String
        let ContactLastNAme=messageDic["ContactLastNAme"] as! String
        var ContactNames=messageDic["ContactNames"] as! String
        let ContactStatus=messageDic["ContactStatus"] as! String
        let ContactUsernames=messageDic["ContactUsernames"] as! String
        let ContactOnlineStatus=messageDic["ContactOnlineStatus"] as! Int
        let ContactFirstname=messageDic["ContactFirstname"] as! String
        let ContactsPhone=messageDic["ContactsPhone"] as! String
        let ContactCountMsgRead=messageDic["ContactCountMsgRead"] as! Int
        let ContactsProfilePic=messageDic["ContactsProfilePic"] as! NSData
        let ChatType=messageDic["ChatType"] as! NSString
        
        //let indexPath = tableView.indexPathForSelectedRow();
        //let currentCell = tableView.cellForRowAtIndexPath(indexPath!) as UITableViewCell!;
        
        ///print(ContactNames[indexPath.row], terminator: "")
        if(tblForChat.editing.boolValue==false)
        {
            if((ChatType as! String) == "group_failed")
            {
                print("clicked group_failed")
                var membersCompleteList=sqliteDB.getGroupMembersOfGroup(groupsObjectList[indexPath.row]["unique_id"] as! String)
                
                var membersList=[String]()
                for(var i=0;i<membersCompleteList.count;i++)
                {
                    membersList.append(membersCompleteList[i]["member_phone"] as! String)
                 }
                
                print("re-try create group id \(ContactUsernames as! String) name is \(groupsObjectList[indexPath.row]["group_name"] as! String) and members are \(membersList)")
                
              UtilityFunctions.init().createGroupAPI(groupsObjectList[indexPath.row]["group_name"] as! String, members: membersList, uniqueid: ContactUsernames as! String)
            }
            else
            {
            if(ChatType == "single")
            {
        self.performSegueWithIdentifier("contactChat", sender: nil);
            }
            else{

                self.performSegueWithIdentifier("startGroupChatSegue", sender: nil);
                
            }
        }
        }
        //slideToChat
        
    }
    

    
    func tableView(
        tableView: UITableView,
        estimatedHeightForRowAtIndexPath indexPath: NSIndexPath
        ) -> CGFloat {
        return 50
    }
    
    override func setEditing(editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tblForChat.setEditing(editing, animated: animated)
        print("editingggg....2")
        tblForChat.reloadData()
    }
    
    /*func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        
        if(indexPath.section == 0)
        {
            print("sectionnnnnnn")
            
        }
        if (tableView.editing && editButtonOutlet.title=="Edit") {
            
            
            return UITableViewCellEditingStyle.Delete
        }
        
        /*
         let more = UITableViewRowAction(style: .Normal, title: "More") { action, index in
         print("more button tapped")
         }
         more.backgroundColor = UIColor.lightGrayColor()

 */
        
        return UITableViewCellEditingStyle.init(rawValue: 1)!
       ////// &&& return UITableViewCellEditingStyle.None
    }
    */
    
     func tableView(tableView: UITableView, shouldIndentWhileEditingRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        
        return false
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
       
        var messageDic = messages.objectAtIndex(indexPath.row) as! [String : AnyObject];
        let ContactsLastMsgDate = messageDic["ContactsLastMsgDate"] as! String
        let ContactLastMessage = messageDic["ContactLastMessage"] as! String
        let ContactLastNAme=messageDic["ContactLastNAme"] as! String
        var ContactNames=messageDic["ContactNames"] as! String
        let ContactStatus=messageDic["ContactStatus"] as! String
        let ContactUsernames=messageDic["ContactUsernames"] as! String
        let ContactOnlineStatus=messageDic["ContactOnlineStatus"] as! Int
        let ContactFirstname=messageDic["ContactFirstname"] as! String
        let ContactsPhone=messageDic["ContactsPhone"] as! String
        let ContactCountMsgRead=messageDic["ContactCountMsgRead"] as! Int
        let ContactsProfilePic=messageDic["ContactsProfilePic"] as! NSData
        let ChatType=messageDic["ChatType"] as! NSString
        
        
       //// if editingStyle == .Delete {
        if(editingStyle == UITableViewCellEditingStyle.Delete){
            let shareMenu = UIAlertController(title: nil, message: "Delete Chat with \(ContactNames)", preferredStyle: .ActionSheet)
            
            let DeleteAction = UIAlertAction(title: "Delete", style: UIAlertActionStyle.Default,handler: { (action) -> Void in
                self.removeChatHistory(ContactUsernames,indexPath: indexPath)
                
            })
            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: { (action) -> Void in
                
                //self.sendType="Message"
                //self.performSegueWithIdentifier("inviteSegue",sender: nil)
                /*var messageVC = MFMessageComposeViewController()
                 
                 messageVC.body = "Enter a message";
                 messageVC.recipients = ["03201211991"]
                 messageVC.messageComposeDelegate = self;
                 
                 self.presentViewController(messageVC, animated: false, completion: nil)
                 */
            })
            
            shareMenu.addAction(DeleteAction)
            shareMenu.addAction(cancelAction)
            
            
            self.presentViewController(shareMenu, animated: true, completion: {
                
            })

            
            // Delete the row from the data source
           /// self.removeChatHistory(ContactUsernames[indexPath.row],indexPath: indexPath)
            // arr.removeAtIndex(indexPath.row)
           //////////////// tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)

            ///tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } /*else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
        else
        {
            
        }*/
        
    }
     func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    

    
    // #pragma mark - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    
    func removeChatHistory(selectedContact:String,indexPath:NSIndexPath)
        {
            var messageDic = messages.objectAtIndex(indexPath.row) as! [String : AnyObject];
            
            let ContactsLastMsgDate = messageDic["ContactsLastMsgDate"] as! String
            let ContactLastMessage = messageDic["ContactLastMessage"] as! String
            let ContactLastNAme=messageDic["ContactLastNAme"] as! String
            var ContactNames=messageDic["ContactNames"] as! String
            let ContactStatus=messageDic["ContactStatus"] as! String
            let ContactUsernames=messageDic["ContactUsernames"] as! String
            let ContactOnlineStatus=messageDic["ContactOnlineStatus"] as! Int
            let ContactFirstname=messageDic["ContactFirstname"] as! String
            let ContactsPhone=messageDic["ContactsPhone"] as! String
            let ContactCountMsgRead=messageDic["ContactCountMsgRead"] as! Int
            let ContactsProfilePic=messageDic["ContactsProfilePic"] as! NSData
            let ChatType=messageDic["ChatType"] as! NSString
            
            
            
            print("header is \(header) selectedContact is \(selectedContact)")
            
            //var loggedUsername=loggedUserObj["username"]
            print("inside mark funcc", terminator: "")
            var removeChatHistoryURL=Constants.MainUrl+Constants.removeChatHistory
            
            //Alamofire.request(.POST,"\(removeChatHistoryURL)",headers:header,parameters: ["username":"\(selectedContact)"]).validate(statusCode: 200..<300).response{
            Alamofire.request(.POST,"\(removeChatHistoryURL)",headers:header,parameters: ["phone":selectedContact]).validate(statusCode: 200..<300).response{
                
                request1, response1, data1, error1 in
                
                //===========INITIALISE SOCKETIOCLIENT=========
                // dispatch_async(dispatch_get_main_queue(), {
                
                //self.dismissViewControllerAnimated(true, completion: nil);
                /// self.performSegueWithIdentifier("loginSegue", sender: nil)
                
                if response1?.statusCode==200 {
                    print("chat history deleted")
                   // if(ContactCountMsgRead.endIndex<=indexPath.row)
                    //{
                    self.messages.removeObjectAtIndex(indexPath.row)
                    /*self.ContactCountMsgRead.removeAtIndex(indexPath.row)
                    //}
                    
                    self.ContactsProfilePic.removeAtIndex(indexPath.row)
                    
                    /*if(!self.ContactMsgRead.isEmpty && self.ContactMsgRead.endIndex<=indexPath.row)
                    {

                    self.ContactMsgRead.removeAtIndex(indexPath.row)
                    }*/
                    self.ContactsLastMsgDate.removeAtIndex(indexPath.row)
                    self.ContactLastMessage.removeAtIndex(indexPath.row)
                   ////// self.ContactIDs.removeAtIndex(indexPath.row)
                    self.ContactLastNAme.removeAtIndex(indexPath.row)
                    self.ContactNames.removeAtIndex(indexPath.row)
                    self.ContactStatus.removeAtIndex(indexPath.row)
                    self.ContactUsernames.removeAtIndex(indexPath.row)
                    self.ContactOnlineStatus.removeAtIndex(indexPath.row)
                    //self.ContactsObjectss.removeAtIndex(indexPath.row)
                    ////////////////////////
                    self.ContactFirstname.removeAtIndex(indexPath.row)
                    ////////
                    
                    self.ContactsPhone.removeAtIndex(indexPath.row)
                    self.ChatType.removeAtIndex(indexPath.row)
                    */
                    ////self.ContactsEmail.removeAtIndex(indexPath.row)
                    //print(request1)
                    print(data1?.debugDescription)
                    
                    sqliteDB.deleteChat(selectedContact)
                    
                    //self.messages.removeAllObjects()
                    self.tblForChat.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                    dispatch_async(dispatch_get_main_queue())
                        {
                            
                            self.tblForChat.reloadData()
                    }
                }
                else
                {print("chat history not deleted")
                    print(error1)
                    print(data1)
                }
                if(response1?.statusCode==401)
                {
                    print("chat history not deleted token refresh needed")
                    if(username==nil || password==nil)
                    {
                        self.performSegueWithIdentifier("loginSegue", sender: nil)
                    }
                    else{
                        self.rt.refrToken()
                    }
                }
            }
            
            
        }
    
    
    
   /* func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        
        
////   if(tblForChat.cellForRowAtIndexPath(indexPath)?.editingStyle == UITableViewCellEditingStyle.init(rawValue: 1))
        //if(tblForChat.editing == false)
       // if(tblForChat.cellForRowAtIndexPath(indexPath)?.editingStyle == UITableViewCellEditingStyle.init(rawValue: 1) && tblForChat.editing.boolValue==true)
//if(tblForChat.cellForRowAtIndexPath(indexPath)?.editingStyle != .Delete && tblForChat.editing.boolValue==true)
        if(editButtonOutlet.title=="Edit")

//UITableViewCellEditingStyle
{
        let more = UITableViewRowAction(style: .Normal, title: "More") { action, index in
            print("more button tapped")
            let shareMenu = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
            
            let Mute = UIAlertAction(title: "Mute", style: UIAlertActionStyle.Default,handler: { (action) -> Void in
               //// self.removeChatHistory(self.ContactUsernames[indexPath.row],indexPath: indexPath)
                
                //call Mute delegate or method
            })
            
            let GroupInfo = UIAlertAction(title: "Group Info", style: UIAlertActionStyle.Default,handler: { (action) -> Void in
                //// self.removeChatHistory(self.ContactUsernames[indexPath.row],indexPath: indexPath)
                
                //call Mute delegate or method
            })
            
            let ExportChat = UIAlertAction(title: "Export Chat", style: UIAlertActionStyle.Default,handler: { (action) -> Void in
                //// self.removeChatHistory(self.ContactUsernames[indexPath.row],indexPath: indexPath)
                
                //call Mute delegate or method
            })
            
            let ClearChat = UIAlertAction(title: "Clear Chat", style: UIAlertActionStyle.Default,handler: { (action) -> Void in
                //// self.removeChatHistory(self.ContactUsernames[indexPath.row],indexPath: indexPath)
                
                //call Mute delegate or method
            })
            let DeleteChat = UIAlertAction(title: "Delete Chat", style: UIAlertActionStyle.Default,handler: { (action) -> Void in
                
                //// self.removeChatHistory(self.ContactUsernames[indexPath.row],indexPath: indexPath)
                
                //call Mute delegate or method
            })
            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: { (action) -> Void in
                
                //self.sendType="Message"
                //self.performSegueWithIdentifier("inviteSegue",sender: nil)
                /*var messageVC = MFMessageComposeViewController()
                 
                 messageVC.body = "Enter a message";
                 messageVC.recipients = ["03201211991"]
                 messageVC.messageComposeDelegate = self;
                 
                 self.presentViewController(messageVC, animated: false, completion: nil)
                 */
            })
            
            shareMenu.addAction(Mute)
            shareMenu.addAction(GroupInfo)
            shareMenu.addAction(ExportChat)
            shareMenu.addAction(ClearChat)
            
            shareMenu.addAction(DeleteChat)
            shareMenu.addAction(cancelAction)
            
            
            self.presentViewController(shareMenu, animated: true, completion: {
                
            })

            
        }
        more.backgroundColor = UIColor.lightGrayColor()
        
        let Archive = UITableViewRowAction(style: .Normal, title: "Archive") { action, index in
            print("Archive button tapped")
            
            
            
        }
    //////   Archive.backgroundColor = UIColor.blueColor()
  //  Archive.set
    
    var imageavatar1=UIImage(named: "archive.png")!    //   imageavatar1=ResizeImage(imageavatar1!,targetSize: s)
    
    //var img=UIImage(data:ContactsProfilePic[indexPath.row])
    var wImg=imageavatar1.size.width
    var hImg=imageavatar1.size.height
    ////var wOld=(self.navigationController?.navigationBar.frame.height)!-5
    
    var hRow=CGFloat.init(70.0)
    var scale:CGFloat=wImg/tableView.cellForRowAtIndexPath(indexPath)!.bounds.width/5
   print("height icon is \(hImg) widh is \(wImg) ... row  width\(tableView.cellForRowAtIndexPath(indexPath)!.bounds.width) and h is \(tableView.cellForRowAtIndexPath(indexPath)!.bounds.height)")
   
    
    
    
    let rect: CGRect = CGRectMake(0, 0, tableView.cellForRowAtIndexPath(indexPath)!.bounds.width/5, hImg)
    
    // Create bitmap image from context using the rect
   let imageRef: CGImageRef = CGImageCreateWithImageInRect(imageavatar1.CGImage, rect)!
    let imggg=UIImage(CGImage: imageRef)
    
   // var resizeDimen=CGSizeMake(tableView.cellForRowAtIndexPath(indexPath)!.bounds.width/5,hImg)
   // var newiconsized=ResizeImage(imageavatar1,targetSize: resizeDimen)
    
        Archive.backgroundColor = UIColor(patternImage: imggg)
      /*  let share = UITableViewRowAction(style: .Normal, title: "Share") { action, index in
            print("share button tapped")
        }
        share.backgroundColor = UIColor.blueColor()
        */
        return [Archive,more]
        }
        else
        {
            return nil
        }
    }

    */
    
    override func prepareForSegue(segue: UIStoryboardSegue?, sender: AnyObject?) {
        
        //newGroupDetailsSegue
        
        if segue!.identifier == "newGroupDetailsSegue" {
            
            if let destinationVC = segue!.destinationViewController as? NewGroupSetDetails{
                destinationVC.participants.removeAll()
                    destinationVC.participants=self.participantsSelected
              //  let selectedRow = tblForChat.indexPathForSelectedRow!.row
                
            }}
        if segue!.identifier == "contactChat" {
            
            if let destinationVC = segue!.destinationViewController as? ChatDetailViewController{
                
                let selectedRow = tblForChat.indexPathForSelectedRow!.row
                var messageDic = messages.objectAtIndex(selectedRow) as! [String : AnyObject];
                
                //destinationVC.selectedContact = ContactNames[selectedRow]
                destinationVC.selectedContact = messageDic["ContactUsernames"] as! String
                destinationVC.selectedFirstName=messageDic["ContactNames"] as! String
                destinationVC.selectedLastName=messageDic["ContactLastNAme"] as! String
                ///////////////////////////////////destinationVC.selectedID=ContactIDs[selectedRow]
                destinationVC.ContactNames=messageDic["ContactNames"] as! String
                destinationVC.ContactOnlineStatus=messageDic["ContactOnlineStatus"] as! Int
                print("destinationnnnnn....")
                //////print("Selectedrow is \(selectedRow)... username is \(ContactUsernames[selectedRow]) firstname is \(ContactFirstname[selectedRow]) lastname is \(ContactLastNAme[selectedRow]) fullname is \(ContactNames)")
            
            }
        }
        if segue!.identifier == "newChat" {
            
            if let destinationVC = segue!.destinationViewController as? ChatMainViewController{
                destinationVC.mytitle="New Chat"
                destinationVC.navigationItem.leftBarButtonItem?.enabled=false
                destinationVC.navigationItem.rightBarButtonItem?.image=nil
                destinationVC.navigationItem.rightBarButtonItem?.enabled=false
            }}
        //startGroupChatSegue
        if segue!.identifier == "startGroupChatSegue" {
            
            if let destinationVC = segue!.destinationViewController as? GroupChatingDetailController{
                let selectedRow = tblForChat.indexPathForSelectedRow!.row
                
                var messageDic = messages.objectAtIndex(selectedRow) as! [String : AnyObject];
                
                let ContactsLastMsgDate = messageDic["ContactsLastMsgDate"] as! String
                let ContactLastMessage = messageDic["ContactLastMessage"] as! String
                let ContactLastNAme=messageDic["ContactLastNAme"] as! String
                var ContactNames=messageDic["ContactNames"] as! String
                let ContactStatus=messageDic["ContactStatus"] as! String
                let ContactUsernames=messageDic["ContactUsernames"] as! String
                let ContactOnlineStatus=messageDic["ContactOnlineStatus"] as! Int
                let ContactFirstname=messageDic["ContactFirstname"] as! String
                let ContactsPhone=messageDic["ContactsPhone"] as! String
                let ContactCountMsgRead=messageDic["ContactCountMsgRead"] as! Int
                let ContactsProfilePic=messageDic["ContactsProfilePic"] as! NSData
                let ChatType=messageDic["ChatType"] as! NSString
        
                
                print("going to groups chat, title is \(ContactNames) and groupid is \(ContactUsernames)")
                destinationVC.mytitle=ContactNames
               destinationVC.groupid1=ContactUsernames
            }}
        //groupInfoSegue
        if segue!.identifier == "groupInfoSegue" {
            
            if let destinationVC = segue!.destinationViewController as? GroupInfo3ViewController{
                let selectedRow = swipeindexRow
                var messageDic = messages.objectAtIndex(selectedRow) as! [String : AnyObject];
                
                let ContactsLastMsgDate = messageDic["ContactsLastMsgDate"] as! String
                let ContactLastMessage = messageDic["ContactLastMessage"] as! String
                let ContactLastNAme=messageDic["ContactLastNAme"] as! String
                var ContactNames=messageDic["ContactNames"] as! String
                let ContactStatus=messageDic["ContactStatus"] as! String
                let ContactUsernames=messageDic["ContactUsernames"] as! String
                let ContactOnlineStatus=messageDic["ContactOnlineStatus"] as! Int
                let ContactFirstname=messageDic["ContactFirstname"] as! String
                let ContactsPhone=messageDic["ContactsPhone"] as! String
                let ContactCountMsgRead=messageDic["ContactCountMsgRead"] as! Int
                let ContactsProfilePic=messageDic["ContactsProfilePic"] as! NSData
                let ChatType=messageDic["ChatType"] as! NSString
                
                print("going to groupsinfo  groupid is \(ContactUsernames)")
              //  destinationVC.mytitle=ContactNames[selectedRow]
                destinationVC.groupid=ContactUsernames
            }}
        
        if segue!.identifier == "contactDetailsFromChatSegue" {
            print("contactDetailsFromChatSegue")
            
            let contactsDetailController = segue!.destinationViewController as? contactsDetailsTableViewController
            
            if let viewController = contactsDetailController {
                let selectedRow = swipeindexRow
                var messageDic = messages.objectAtIndex(selectedRow) as! [String : AnyObject];
                
                let ContactsLastMsgDate = messageDic["ContactsLastMsgDate"] as! String
                let ContactLastMessage = messageDic["ContactLastMessage"] as! String
                let ContactLastNAme=messageDic["ContactLastNAme"] as! String
                var ContactNames=messageDic["ContactNames"] as! String
                let ContactStatus=messageDic["ContactStatus"] as! String
                let ContactUsernames=messageDic["ContactUsernames"] as! String
                let ContactOnlineStatus=messageDic["ContactOnlineStatus"] as! Int
                let ContactFirstname=messageDic["ContactFirstname"] as! String
                let ContactsPhone=messageDic["ContactsPhone"] as! String
                let ContactCountMsgRead=messageDic["ContactCountMsgRead"] as! Int
                let ContactsProfilePic=messageDic["ContactsProfilePic"] as! NSData
                let ChatType=messageDic["ChatType"] as! NSString
                
                var indexnew=getAddressBookIndex(ContactUsernames)
                contactsDetailController?.contactIndex=indexnew
                //contactsDetailController?.contactIndex=tblForNotes.indexPathForSelectedRow!.row
                //var cell=tblForNotes.cellForRowAtIndexPath(tblForNotes.indexPathForSelectedRow!) as! AllContactsCell
                

                if(ContactStatus != "")
                {
                    contactsDetailController?.isKiboContact = true
                    //print("hidden falseeeeeee")
                }
                
    
            }}
    }
    
    func getAddressBookIndex(phone1:String)->Int
    {
        var allcontactslist1=sqliteDB.allcontacts
        
        
        let phone = Expression<String>("phone")
        let kibocontact = Expression<Bool>("kiboContact")
        let name = Expression<String?>("name")
        let email = Expression<String?>("email")
        
        //alladdressContactsArray = Array(try sqliteDB.db.prepare(allcontactslist1))
        
        var alladdressContactsArray=Array<Row>()
        //////configureSearchController()
        var newindexphone = -1
        do
        { alladdressContactsArray = Array(try sqliteDB.db.prepare(allcontactslist1))
            for (var i=0;i<alladdressContactsArray.count;i++)
            {
                if(alladdressContactsArray[i].get(phone)==phone1)
                {
                    newindexphone=i
                }
                
            }
        }
        catch
        {
            print("error in finding index in addressbook")
        }
        
        return newindexphone
    }
    
    
    ///////////////////////////////
    //SOCKET CLIENT DELEGATE MESSAGES
    ///////////////////////////////
    
    func socketReceivedMessage(message:String,data:AnyObject!)
    {print("socketReceivedMessage inside \(message)", terminator: "")
        //var msg=JSON(params)
        if(socketObj != nil){
        socketObj.socket.emit("logClient","IPHONE-LOG: \(username!) received message \(message)")
        }
        switch(message)
        {
            
            
            // %%%%%%%%%%%%%%%%%% new commented
            /*case "Accept Call":
            socketObj.socket.emit("logClient","IPHONE-LOG: \(username!) is inside accept call")
            print("Accept call in chat view")
            callerName=KeychainWrapper.stringForKey("username")!
            //iamincallWith=msg[0]["callee"].string!
            
            print("callee is \(callerName)", terminator: "")
            
            var roomname=""
            //if(ConferenceRoomName == "")
            //{
            socketObj.socket.emit("logClient","IPHONE-LOG: \(username!) is inside accept call")
            print("inside accept call")
            /// roomname="test"
            
            /*** neww may 2016 MOVED ROOM JOIN
            
            if(isConference == true)
            {print("conference name is\(ConferenceRoomName)")
            roomname=ConferenceRoomName
            }
            else{
            //roomname=self.randomStringWithLength(9) as String
            roomname="sumaira"
            }
            //iamincallWith=username!
            areYouFreeForCall=false
            joinedRoomInCall=roomname as String
            socketObj.socket.emitWithAck("init", ["room":joinedRoomInCall,"username":username!])(timeoutAfter: 1500000) {data in
            meetingStarted=true
            print("room joined by got ack")
            var a=JSON(data)
            print(a.debugDescription)
            currentID=a[1].int!
            print("current id is \(currentID)")
            var aa=JSON(["msg":["type":"room_name","room":roomname as String],"room":globalroom,"to":iamincallWith!,"username":username!])
            print(aa.description)
            socketObj.socket.emit("message",aa.object)
            
            }//end data
            */
            
            
            ///NEW ADDED
            
            socketObj.socket.emit("logClient","IPHONE-LOG: \(username!) is going to videoViewController")
            ////
            var next = self.storyboard!.instantiateViewControllerWithIdentifier("MainV2") as! VideoViewController
            
            self.presentViewController(next, animated: true, completion: {
            })
            
            //}
            
            */
            case "updateUI":
                print("here refreshing UI in chats view line # 3898")
                self.retrieveSingleChatsAndGroupsChatData({(result)-> () in
                    
                    
                    //    dispatch_async(dispatch_get_main_queue())
                    //  {
                    // self.tblForChats.reloadData()
                    
                    //commenting newwwwwwww -===-===-=
                    dispatch_async(dispatch_get_main_queue())
                    {
                        self.tblForChat.reloadData()
                        if(self.messages.count>1)
                        {
                            var indexPath = NSIndexPath(forRow:self.messages.count-1, inSection: 0)
                            
                            self.tblForChat.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Bottom, animated: false)
                        }
                    }
                    //}
                    // })
                })
                /*dispatch_sync(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) {
                    // do some task start to show progress wheel
                    self.fetchContacts({ (result) -> () in
                        //self.fetchContactsFromServer()
                        print("checkinnn ... 3042")
                        let tbl_accounts=sqliteDB.accounts
                        do{for account in try sqliteDB.db.prepare(tbl_accounts) {
                            ///print("id: \(account[_id]), phone: \(account[phone]), firstname: \(account[firstname])")
                            
                            var userr:JSON=["_id":account[self._id],"display_name":account[self.firstname]!,"phone":account[self.phone]]
                            if(socketObj != nil){
                            socketObj.socket.emit("whozonline",
                                ["room":"globalchatroom",
                                    "user":userr.object])
                            }}}
                        catch{
                            
                        }
                        
                        dispatch_async(dispatch_get_main_queue()) {
                            self.tblForChat.reloadData()
                        }
                    })
            }*/
            
            case "im": print("im received")
                /*dispatch_sync(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) {
                    // do some task start to show progress wheel
                    self.fetchContacts({ (result) -> () in
                        //self.fetchContactsFromServer()
                        print("checkinnn im 3067")
                        let tbl_accounts=sqliteDB.accounts
                        do{for account in try sqliteDB.db.prepare(tbl_accounts) {
                            ///print("id: \(account[_id]), phone: \(account[phone]), firstname: \(account[firstname])")
                            
                            var userr:JSON=["_id":account[self._id],"display_name":account[self.firstname]!,"phone":account[self.phone]]
                            if(socketObj != nil){
                            socketObj.socket.emit("whozonline",
                                ["room":"globalchatroom",
                                    "user":userr.object])
                            }}}
                        catch{
                            
                        }
                        
                        dispatch_async(dispatch_get_main_queue()) {
                            self.tblForChat.reloadData()
                        }
                    })
            }*/
        case "othersideringing":
            print(message)
            iOSstartedCall=true
            //////*** newww may 2016
            
            callerName=KeychainWrapper.stringForKey("username")!
            //iamincallWith=msg[0]["callee"].string!
            if(socketObj != nil){
            socketObj.socket.emit("logClient","IPHONE-LOG: \(username!) othersideringing , callee is \(callerName)")
            }
            print("callee is \(callerName)", terminator: "")
            
            /*
            ///NEW ADDED
            
            
            ////
            var next = self.storyboard!.instantiateViewControllerWithIdentifier("MainV2") as! VideoViewController
            
            self.presentViewController(next, animated: true, completion: {
            })
            */
        case "offline":
            
            
            print("offline status... 3112", terminator: "")
           /* var offlineUsers=JSON(data!)
            print(offlineUsers[0])
            //print(offlineUsers[0]["username"])
            dispatch_sync(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) {
            for(var i=0;i<offlineUsers.count;i++)
            {
                for(var j=0;j<self.ContactOnlineStatus.count;j++)
                {
                   // if self.ContactIDs[j]==offlineUsers[i]["_id"].string!
                    if self.ContactUsernames[j]==offlineUsers[i]["phone"].string!
                        
                    {
                        
                        //found online contact,s username
                        if(socketObj != nil){
                        socketObj.socket.emit("logClient","IPHONE-LOG: user found offline \(self.ContactUsernames[j])")
                        }
                       // print("user found offlinee \(self.ContactUsernames[j])")
                        self.ContactOnlineStatus[j]=0
                        
                    }
                }
            }
            dispatch_async(dispatch_get_main_queue())
            {
                self.tblForChat.reloadData()
            }
            }*/
            
        case "theseareonline":
            
            print("theseareonline status...", terminator: "")
            /*var theseareonlineUsers=JSON(data!)
            //print(theseareonlineUsers.object)
            //print(offlineUsers[0]["username"])
            print("contact user names count is \(self.ContactUsernames.count) and theseareonline users count is \(theseareonlineUsers[0].count) and self array of online users count is \(self.ContactOnlineStatus.count)")
            for(var i=0;i<theseareonlineUsers[0].count;i++)
            {
                for(var j=0;j<self.ContactUsernames.count && i<theseareonlineUsers.count;j++)
                {
                    if self.ContactUsernames[j]==theseareonlineUsers[0][i]["phone"].description
                    {
                        //found online contact,s username
                        socketObj.socket.emit("logClient","IPHONE-LOG: user found theseareonline \(self.ContactUsernames[j])")
                        print("user found theseareonline \(self.ContactUsernames[j])")
                        self.ContactOnlineStatus[j]=1
                        print("line # 1699")
                        // *** newwww self.tblForChat.reloadData()
                    }
                }
            }*/
            var onlinefound=false
            print("online status...")
            print(data)
           /* var onlineUsers=JSON(data)
            print(onlineUsers.debugDescription)
            print(onlineUsers[0]["phone"])
            //print(onlineUsers[0]["username"])
            dispatch_sync(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) {
            for(var i=0;i<onlineUsers[0].count;i++)
            {
                for(var j=0;j<self.ContactOnlineStatus.count;j++)
                {
                    ////if self.ContactIDs[j]==onlineUsers[0][i]["_id"].string!
                    if self.ContactUsernames[j]==onlineUsers[0][i]["phone"].string!
                    {
                        //found online contact,s username
                        ///print("user found online2 \(self.ContactIDs[j])")
                        print("user found online2 \(self.ContactUsernames[j])")
                        self.ContactOnlineStatus[j]=1
                        onlinefound=true
                        /*dispatch_async(dispatch_get_main_queue())
                        {
                            self.tblForChat.reloadData()
                        }*/
                    }
                }
            }
            dispatch_async(dispatch_get_main_queue())
            {
                self.tblForChat.reloadData()
            }
            }*/
        case "yesiamfreeforcall":
            var message=JSON(data!)
            print("other user is free", terminator: "")
            print(data?.debugDescription, terminator: "")
            if(socketObj != nil){
            socketObj.socket.emit("logClient","IPHONE-LOG: \(username!) received message from other peer yesiamfreeforcall")
            }
            
     
        case "youareonline":
            globalChatRoomJoined=true
            var contactsOnlineList=JSON(data)
            
     
        case "calleeisbusy":
            
            self.showError("Information", message: "User is busy. Please try again later", button1: "Ok")
            
        case "online":
            //{data,ack in
            var onlinefound=false
            print("online status...")
            print(data)
            /*var onlineUsers=JSON(data)
            print(onlineUsers.debugDescription)
            print(onlineUsers["phone"])
            //print(onlineUsers[0]["username"])
            dispatch_sync(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) {
            for(var i=0;i<onlineUsers.count;i++)
            {
                for(var j=0;j<self.ContactOnlineStatus.count;j++)
                {
                    ///if self.ContactIDs[j]==onlineUsers[i]["_id"].string!
                    if self.ContactUsernames[j]==onlineUsers[i]["phone"].string!
                        
                    {
                        //found online contact,s username
                        ///print("user found online2 \(self.ContactIDs[j])")
                        
                        print("user found online2 \(self.ContactUsernames[j])")
                        
                        self.ContactOnlineStatus[j]=1
                        onlinefound=true
                      /*  dispatch_async(dispatch_get_main_queue())
                            {
                                self.tblForChat.reloadData()
                        }*/
                    }
                }
            }
                dispatch_async(dispatch_get_main_queue())
                {
                    self.tblForChat.reloadData()
                }
            }
            */
      
        default: print("", terminator: "")
            
        }//end switch
        
    }
    
    
    //UNCOMMENT WHEN DEALINAG WITH GROUPS
    
   func swipeableTableViewCell(cell: SWTableViewCell!, didTriggerRightUtilityButtonWithIndex index: Int) {
    
    swipeindexRow=tblForChat.indexPathForCell(cell)!.row
       // if(index==0)
       // {
    var messageDic = messages.objectAtIndex(swipeindexRow) as! [String : AnyObject];
    
    let ContactsLastMsgDate = messageDic["ContactsLastMsgDate"] as! String
    let ContactLastMessage = messageDic["ContactLastMessage"] as! String
    let ContactLastNAme=messageDic["ContactLastNAme"] as! String
    var ContactNames=messageDic["ContactNames"] as! String
    let ContactStatus=messageDic["ContactStatus"] as! String
    let ContactUsernames=messageDic["ContactUsernames"] as! String
    let ContactOnlineStatus=messageDic["ContactOnlineStatus"] as! Int
    let ContactFirstname=messageDic["ContactFirstname"] as! String
    let ContactsPhone=messageDic["ContactsPhone"] as! String
    let ContactCountMsgRead=messageDic["ContactCountMsgRead"] as! Int
    let ContactsProfilePic=messageDic["ContactsProfilePic"] as! NSData
    let ChatType=messageDic["ChatType"] as! NSString
    
        print("RightUtilityButton index of more is \(index)")
            if(editButtonOutlet.title=="Edit")
            {//UITableViewCellEditingStyle
             if(ChatType != "single")
                {
                //let more = UITableViewRowAction(style: .Normal, title: "More") { action, index in
                    print("more button tapped")
                    let shareMenu = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
                    
                    /*let Mute = UIAlertAction(title: "Mute", style: UIAlertActionStyle.Default,handler: { (action) -> Void in
                        
                        var groupid=self.ContactUsernames[self.swipeindexRow]
                        sqliteDB.UpdateMuteGroupStatus(groupid, isMute1: true)
                        
                        //// self.removeChatHistory(self.ContactUsernames[indexPath.row],indexPath: indexPath)
                        
                        //call Mute delegate or method
                    })*/
                    
                    let GroupInfo = UIAlertAction(title: "Group Info", style: UIAlertActionStyle.Default,handler: { (action) -> Void in
                        
                       // swipeindex=index
                        self.performSegueWithIdentifier("groupInfoSegue", sender: nil)
                        //// self.removeChatHistory(self.ContactUsernames[indexPath.row],indexPath: indexPath)
                        
                        //call Mute delegate or method
                    })
                    
                   /* let ExportChat = UIAlertAction(title: "Export Chat", style: UIAlertActionStyle.Default,handler: { (action) -> Void in
                        //// self.removeChatHistory(self.ContactUsernames[indexPath.row],indexPath: indexPath)
                        
                        //call Mute delegate or method
                        
                    })
                    
                    let ClearChat = UIAlertAction(title: "Clear Chat", style: UIAlertActionStyle.Default,handler: { (action) -> Void in
                        //// self.removeChatHistory(self.ContactUsernames[indexPath.row],indexPath: indexPath)
                        
                        //call Mute delegate or method
                    })
                    let DeleteChat = UIAlertAction(title: "Delete Chat", style: UIAlertActionStyle.Default,handler: { (action) -> Void in
                        
                        //// self.removeChatHistory(self.ContactUsernames[indexPath.row],indexPath: indexPath)
                        
                        //call Mute delegate or method
                    })
 */
                    let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: { (action) -> Void in
                        
                        //self.sendType="Message"
                        //self.performSegueWithIdentifier("inviteSegue",sender: nil)
                        /*var messageVC = MFMessageComposeViewController()
                         
                         messageVC.body = "Enter a message";
                         messageVC.recipients = ["03201211991"]
                         messageVC.messageComposeDelegate = self;
                         
                         self.presentViewController(messageVC, animated: false, completion: nil)
                         */
                    })
                    
                    // commented shareMenu.addAction(Mute)
                    shareMenu.addAction(GroupInfo)
                    /*shareMenu.addAction(ExportChat)
                    shareMenu.addAction(ClearChat)
                    
                    shareMenu.addAction(DeleteChat)*/
                    shareMenu.addAction(cancelAction)
                    
                   // shareMenu.show
                    self.presentViewController(shareMenu, animated: true, completion: {
                        
                    })
                //}
            }
            else
            {
                //if single chat
                //if exists in addressbook
                var newindex=getAddressBookIndex(ContactUsernames)
                if(newindex != -1)
                {
                    
                    let shareMenu = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
                
                    let contactinfo = UIAlertAction(title: "Contact Info", style: UIAlertActionStyle.Default,handler: { (action) -> Void in
                    //segue to contact info page
                    //contactDetailsSegue
                    
                    self.performSegueWithIdentifier("contactDetailsFromChatSegue", sender: nil)
                   })
                    
                    let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: { (action) -> Void in
                        
                    
                    })
    
                    shareMenu.addAction(contactinfo)
                    shareMenu.addAction(cancelAction)

                    self.presentViewController(shareMenu, animated: true, completion: {
                        
                    })
                }
                
                }
    } // if edit
    
    }
    
    
    
    func swipeableTableViewCellShouldHideUtilityButtonsOnSwipe(cell: SWTableViewCell!) -> Bool {
        
        return true
    }
    
    
    
    func socketReceivedSpecialMessage(message:String,params:JSON!)
    {
        
    }
    override func viewWillDisappear(animated: Bool) {
        print("dismissed chatttttttt")
        //socketObj.delegate=nil
    }
    
    func refreshChatsUI(message:String!, uniqueid:String!, from:String!, date1:NSDate!, type:String!) {
        print("here refreshing UI in chats view line # 4291")
        self.retrieveSingleChatsAndGroupsChatData({(result)-> () in
           
            
            //    dispatch_async(dispatch_get_main_queue())
            //  {
            // self.tblForChats.reloadData()
            
            //commenting newwwwwwww -===-===-=
            dispatch_async(dispatch_get_main_queue())
            {
                self.tblForChat.reloadData()
                if(self.messages.count>1)
                {
                    var indexPath = NSIndexPath(forRow:self.messages.count-1, inSection: 0)
                    
                    self.tblForChat.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Bottom, animated: false)
                }
            }
            //}
            // })
        })
        
        /*dispatch_sync(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) {
            // do some task start to show progress wheel
            self.fetchContacts({ (result) -> () in
                //self.fetchContactsFromServer()
                print("checkinnn")
                let tbl_accounts=sqliteDB.accounts
                do{for account in try sqliteDB.db.prepare(tbl_accounts) {
                    ///print("id: \(account[_id]), phone: \(account[phone]), firstname: \(account[firstname])")
                    
                    var userr:JSON=["_id":account[self._id],"display_name":account[self.firstname]!,"phone":account[self.phone]]
                    if(socketObj != nil){
                        socketObj.socket.emit("whozonline",
                            ["room":"globalchatroom",
                                "user":userr.object])
                    }}}
                catch{
                    
                }
                
                dispatch_async(dispatch_get_main_queue()) {
                    self.tblForChat.reloadData()
                }
            })
        }*/
        
    }
    
    func refreshContactsList(message: String) {
        print("here refreshing UI in chats view line # 4341")
        self.retrieveSingleChatsAndGroupsChatData({(result)-> () in
           
            //    dispatch_async(dispatch_get_main_queue())
            //  {
            // self.tblForChats.reloadData()
            
            //commenting newwwwwwww -===-===-=
            dispatch_async(dispatch_get_main_queue())
            {
                self.tblForChat.reloadData()
                if(self.messages.count>1)
                {
                    var indexPath = NSIndexPath(forRow:self.messages.count-1, inSection: 0)
                    
                    self.tblForChat.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Bottom, animated: false)
                }
            }
            //}
            // })
        })
        /*dispatch_sync(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) {
            // do some task start to show progress wheel
            self.fetchContacts({ (result) -> () in
                //self.fetchContactsFromServer()
                print("checkinnn")
                let tbl_accounts=sqliteDB.accounts
                /*do{for account in try sqliteDB.db.prepare(tbl_accounts) {
                    ///print("id: \(account[_id]), phone: \(account[phone]), firstname: \(account[firstname])")
                    
                    var userr:JSON=["_id":account[self._id],"display_name":account[self.firstname]!,"phone":account[self.phone]]
                    if(socketObj != nil){
                        socketObj.socket.emit("whozonline",
                            ["room":"globalchatroom",
                                "user":userr.object])
                    }}}
                catch{
                    
                }*/
                
                dispatch_async(dispatch_get_main_queue()) {
                    self.tblForChat.reloadData()
                }
            })
        }*/
        
    }
    
    func refreshUI(message: String, data: AnyObject!) {
        print("here refreshing UI in chats view line # 4390")
        /*self.retrieveSingleChatsAndGroupsChatData({(result)-> () in
            
            //    dispatch_async(dispatch_get_main_queue())
            //  {
            // self.tblForChats.reloadData()
            
            //commenting newwwwwwww -===-===-=
            dispatch_async(dispatch_get_main_queue())
            {
                self.tblForChat.reloadData()
                if(self.messages.count>1)
                {
                    var indexPath = NSIndexPath(forRow:self.messages.count-1, inSection: 0)
                    
                    self.tblForChat.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Bottom, animated: false)
                }
            }
            //}
            // })
        })*/
       //==-- self.reloadThisPage()
    }
    
}
