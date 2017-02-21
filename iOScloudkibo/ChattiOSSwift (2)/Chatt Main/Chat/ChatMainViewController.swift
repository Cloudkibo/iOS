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
import AlamofireImage


var delegateRefreshContacts:RefreshContactsList!
class ChatMainViewController:UIViewController,SocketConnecting,RefreshContactsList
{
    
    let imageCache = AutoPurgingImageCache()
    var messages:NSMutableArray!
    var sendType=""
    var accountKit: AKFAccountKit!
    var rt=NetworkingLibAlamofire()
    var mytitle="Favourites"
    
    var messageFrame = UIView()
    var activityIndicator = UIActivityIndicatorView()
    var strLabel = UILabel()
    
    
    var refreshControl = UIRefreshControl()
    @IBOutlet var viewForTitle : UIView!
    @IBOutlet var ctrlForChat : UISegmentedControl!
    @IBOutlet var btnForLogo : UIButton!
    //var loggedID=loggedUserObj["_id"]
    @IBOutlet var tblForChat : UITableView!
    @IBOutlet weak var btnContactAdd: UIBarButtonItem!
    var delegateSocketConn:SocketConnecting!
    var currrentUsernameRetrieved:String=""
    var delegate:SocketClientDelegate!
    ////////let delegateController=LoginAPI(url: "sdfsfes")
    
    
    @IBAction func addContactTapped(_ sender: UIBarButtonItem) {
        
        self.performSegue(withIdentifier: "inviteSegue",sender: nil)
      
        
        
        /* let alert = UIAlertView()
        alert.title = "Alert"
        alert.message = "Here's a message"
        alert.addButtonWithTitle("Understod")
        alert.show()
        */
        
        
        
        /*
        var tField: UITextField!
        
        //Create the AlertController
        let actionSheetController: UIAlertController = UIAlertController(title: "Add Contact", message: "Please Enter Email/Username", preferredStyle: .Alert)
        
        //Add a text field
        actionSheetController.addTextFieldWithConfigurationHandler { textField -> Void in
            //TextField configuration
            textField.textColor = UIColor.greenColor()
            tField=textField
        }
        
        //Create and add the Cancel action
        let cancelAction: UIAlertAction = UIAlertAction(title: "Add by Email", style: UIAlertActionStyle.Cancel) { action -> Void in
            
            print(loggedUserObj)
            var fname=["firstname":loggedUserObj["firstname"]]
            var lname=["lastname":loggedUserObj["lastname"]]
            var usern=["username":loggedUserObj["username"]]
            var idd=["_id":loggedUserObj["_id"]]
            var date=["date":loggedUserObj["date"]]
            var email=["email":loggedUserObj["email"]]
            var status=["status":loggedUserObj["stauts"]]
            //var merge=fname.description+lname.description+String(usern)
            
           // var userID=["userid":"\(merge)"]
            //loggedUserObj["accountVerified"]
            //loggedUserObj["city"]
            //sloggedUserObj["country"]
            
            socketObj.socket.emit("friendrequest",[
                "room":"globalchatroom",
                "userid":loggedUserObj.object,
                "contact":"\(tField.text!)"]
            )
            
            
            //Do some stuff
            
            var addContactUsernameURL=Constants.MainUrl+Constants.addContactByEmail
           
            
            Alamofire.request(.POST,"\(addContactUsernameURL)",headers:header,parameters: ["searchemail":"\(tField.text!)"])
                .validate(statusCode: 200..<300)
                .response { (request1, response1, data1, error1) in
                    
                    
                    print("success")
                    
                    var json=JSON(data1!)
                    //print(json)
                    if(json["msg"].string=="null")
                    {print("Invalid email")}
                    else
                    {
                        if(json["status"].string=="danger"){
                            print("contact already in your list")}
                        else
                        {print("friend request sent")}
                    print(error1)
                        
                    
                    }
                    if response1?.statusCode==401
                    {
                        print("REFRESH TOKEN Neededd Add Contact Username...")
                        
                        self.rt.refrToken()
                    }
            
            }
        print("outttt of sucess parasssss", terminator: "")
        }
       

        actionSheetController.addAction(cancelAction)
        //Create and an option action
        let nextAction: UIAlertAction = UIAlertAction(title: "Add by Username", style: UIAlertActionStyle.Default) { action -> Void in
            
            //var ContactEmail=self.ContactsObjectss[]
            print(loggedUserObj)
            var userid=""
            socketObj.socket.emit("friendrequest",[
                "room":"globalchatroom",
                "userid":loggedUserObj.object,
                "contact":"\(tField.text!)"]
            )
            
            
            //Do some other stuff
            var addContactUsernameURL=Constants.MainUrl+Constants.addContactByUsername
            Alamofire.request(.POST,"\(addContactUsernameURL)",headers:header,parameters: ["searchusername":"\(tField.text!)"]).validate(statusCode: 200..<300).responseJSON{response in
                var response1=response.response
                var request1=response.request
                var data1=response.data
                var error1=response.result.error                //searchemail  f@lkjlklkm.com
                //====================
                dispatch_async(dispatch_get_main_queue(), {
                    
                    self.dismiss(true, completion: nil);
                    /// self.performSegueWithIdentifier("loginSegue", sender: nil)
                    
                    if response1?.statusCode==200 {
                        print("success")
                        
                        var json=JSON(data1!)
                        //print(json)
                        if(json["msg"].string=="null")
                        {print("Invalid user")
                            let alert = UIAlertController(title: "Failed", message: "Invalid user", preferredStyle: UIAlertControllerStyle.Alert)
                            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                            self.presentViewController(alert, animated: true, completion: nil)}
                        else
                        {
                            if(json["status"].string=="danger"){
                                print("contact already in your list")
                                let alert = UIAlertController(title: "Failed", message: "Contact already in your list", preferredStyle: UIAlertControllerStyle.Alert)
                                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                                self.presentViewController(alert, animated: true, completion: nil)
                            }
                            else
                            {print("friend request sent")
                                let alert = UIAlertController(title: "Success", message: "Friend request sent", preferredStyle: UIAlertControllerStyle.Alert)
                                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                                self.presentViewController(alert, animated: true, completion: nil)}
                        }
                    }
                    else
                    {
                        print("error in sending friend request")
                    }
                })
                if response1?.statusCode==401
                {
                    print(error1)
                    print("REFRESH TOKEN Neededd Add Contact Username...")
                    
                    self.rt.refrToken()
                }
 
                
                
                
            }
            
        }
        actionSheetController.addAction(nextAction)
        
        ///////////////
        //CONTACTS from Address Book
        //////////////
        var nextAction2: UIAlertAction = UIAlertAction(title: "Invite Contacts", style: UIAlertActionStyle.Default) { action -> Void in
            ///////contactsList.fetch()
            self.performSegueWithIdentifier("inviteSegue",sender: nil)
            //var newContact=["fname":self.ContactFirstname[0],"lname":self.ContactLastNAme[0],"email":self.ContactsEmail[0],"phone":self.ContactsPhone[0]]
            
            //contactsList.saveToAddressBook(newContact)
            /*
            //var ContactEmail=self.ContactsObjectss[]
            print(loggedUserObj)
            var userid=""
            
            //Do some other stuff
            var inviteContactEmailURL=Constants.MainUrl+Constants.inviteContactsByEmail+"?access_token=\(AuthToken!)"
            Alamofire.request(.POST,"\(inviteContactEmailURL)",parameters: ["emails":""]).validate(statusCode: 200..<300).responseJSON{response in
                var response1=response.response
            }
        */}
        actionSheetController.addAction(nextAction2)
        
        
        //Present the AlertController
        self.presentViewController(actionSheetController, animated: true, completion: nil)
        */
    }
    
    /*var ContactNames:[String]=[]
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
    var ContactsEmail:[String]=[]
    var ContactsPhone:[String]=[]
    var ContactsProfilePic:[NSData]=[]
    */
    //["Bus","Helicopter","Truck","Boat","Bicycle","Motorcycle","Plane","Train","Car","Scooter","Caravan"]
    required init?(coder aDecoder: NSCoder)
    {
        
        super.init(coder: aDecoder)
        //print(AuthToken!)
        
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        // Custom initialization
        
    }

    
   
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        print("Chat ViewController is loadingggggg")
        syncServiceContacts.delegateRefreshContactsList=self
        if(self.accountKit == nil){
        self.accountKit = AKFAccountKit(responseType: AKFResponseType.accessToken)
}

        messages=NSMutableArray()
        /*if(socketObj != nil)
        {
            socketObj.delegate=self
        }*/
       /* socketObj.socket.on("connect") {data, ack in
            print("connected caught in chat view")
            //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%socketObj.delegate=self
            
        }
        */
        
        
      //  NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("applicationDidBecomeActive:"), name:UIApplicationDidBecomeActiveNotification, object: nil)
        
        
        
        if (self.accountKit!.currentAccessToken == nil) {
            
            //specify AKFResponseType.AccessToken
            self.accountKit = AKFAccountKit(responseType: AKFResponseType.accessToken)
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
                    
                }}}
        //var lll=self.storyboard?.instantiateViewControllerWithIdentifier("mainpage") as! LoginViewController
        
        
        /*if(isSocketConnected==false)
        {   
            lll.progressWheel.startAnimating()
            lll.progressWheel.hidden=false
        }
        if(isSocketConnected==true)
        {
            lll.progressWheel.stopAnimating()
            lll.progressWheel.hidden=true
        }*/

        /*if(socketConnected == false)
        {            socketObj.socket.connect(timeoutAfter: 5000) { () -> Void in
                
                socketObj.socket.reconnect()
                
            }
        }*/
        
        if(isConference == true)
        {print("dont know why dismiss was there")
            /////self.dismiss(true,completion: nil)
        }
       /* var retrievedToken=KeychainWrapper.stringForKey("access_token")
        print("retrieved token === \(retrievedToken)")
        print("khul raha hai2", terminator: "")
        print(loggedUserObj.object)
        //let retrievedUsername=KeychainWrapper.stringForKey("username")
        //if retrievedToken==nil || retrievedUsername==nil
     

        
        if(KeychainWrapper.stringForKey("username") != nil)
        {print("delegate added in chat")
            currrentUsernameRetrieved=KeychainWrapper.stringForKey("username")!
          
        }//end if username definned
        
        print("loadddddd", terminator: "")
        
        */
        //%%%%%%%%%%%% commented socket connect again and again
        /*
        if(socketObj == nil)
        {
            print("socket is nillll", terminator: "")
            
            
            socketObj=LoginAPI(url:"\(Constants.MainUrl)")
           /////////// print("connected issssss \(socketObj.socket.connected)")
           ///socketObj.connect()
            socketObj.addHandlers()
            socketObj.addWebRTCHandlers()
        }*/

    
        
        
   
        //:::::::::::::::::::::::::::::::::::::::::::::::::::::::::
       //////////////////////////////
        /*
        socketObj.socket.on("othersideringing"){data,ack in
            print("otherside ringing")
            var msg=JSON(data)
            //self.othersideringing=true;
            print(msg.debugDescription)
            callerName=KeychainWrapper.stringForKey("username")!
            //iamincallWith=msg[0]["callee"].string!
            
            print("callee is \(callerName)")
            
            var next = self.storyboard?.instantiateViewControllerWithIdentifier("Main2") as! VideoViewController
            
            self.presentViewController(next, animated: true, completion: {
            })
            
        }

        */
        
       /*if loggedUserObj==nil
       {
        if let loggd=KeychainWrapper.objectForKey("loggedUserObj")
        {
            loggedUserObj=JSON(loggd)
        }
        }*/
        //==========Show Online============

        
       /* socketObj.socket.emit("whozonline",[
            "room":"globalchatroom",
            "user":loggedUserObj.object])
        */
     //   print("logged id key chain is \(loggedIDKeyChain)")
        
        
        self.navigationItem.titleView = viewForTitle
        self.navigationItem.title = mytitle
        ////////////////////self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: btnForLogo)
        //self.navigationItem.rightBarButtonItem = itemForSearch
        //////////////////self.navigationItem.rightBarButtonItem = btnContactAdd
        self.tabBarController?.tabBar.tintColor = UIColor.green
        print("////////////////////// new class tokn \(AuthToken)", terminator: "")
        // fetchContacts(AuthToken)
       // print(self.ContactNames.count.description, terminator: "")
       
        
        
        
        DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.default).async
        {
            self.fetchcontactsnew({(result)-> () in
                
                
                //    DispatchQueue.main.async
                //  {
                // self.tblForChats.reloadData()
                
                //commenting newwwwwwww -===-===-=
                if(result==true)
{
                DispatchQueue.main.async
                {
                    self.tblForChat.reloadData()
                    
                    
                }
}
                }
            )}
        /*self.fetchContacts({ (result) -> () in
            //self.fetchContactsFromServer()
            DispatchQueue.main.async {
                self.tblForChat.reloadData()
            }
        })
        */
        
        

        
       
        //refreshControl.addTarget(self, action: Selector("fetchContacts"), forControlEvents: UIControlEvents.ValueChanged)
        //self.refreshControl = refreshControl
        
        
        let username = Expression<String?>("username")
       
    }
    
    func loginSegueMethod()
    {print("line # 564")
        self.performSegue(withIdentifier: "loginSegue", sender: nil)
    }
    func socketConnected() {
        if((self.view.window != nil) && self.isViewLoaded){
       /* var lll=self.storyboard?.instantiateViewControllerWithIdentifier("mainpage") as! LoginViewController
        
        lll.progressWheel.stopAnimating()
        lll.progressWheel.hidden=true*/
        print("progressWheel hidden")
        //**** neww may 2016 added
        ///////%%%%%%%%%%%%%%%%%% socketObj.delegate=self
        }
        
    }

    
    func progressBarDisplayer(_ msg:String, _ indicator:Bool ) {
        print(msg)
        strLabel = UILabel(frame: CGRect(x: 50, y: 0, width: 250, height: 50))
        strLabel.text = msg
        strLabel.textColor = UIColor.white
        messageFrame = UIView(frame: CGRect(x: view.frame.midX - 110, y: view.frame.midY - 25 , width: 230, height: 50))
        messageFrame.layer.cornerRadius = 15
        messageFrame.backgroundColor = UIColor(white: 0, alpha: 0.7)
        if indicator {
            activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.white)
            activityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
            activityIndicator.startAnimating()
            messageFrame.addSubview(activityIndicator)
        }
        messageFrame.addSubview(strLabel)
        view.addSubview(messageFrame)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        print("appearrrrrr", terminator: "")
        if(socketObj.delegateSocketConnected == nil && isSocketConnected==true)
        {
               socketObj.delegateSocketConnected=self
        }
        //%%%%%% new phone model add
        
     //   dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) {
            // do some task start to show progress wheel
            /*self.fetchContacts({ (result) -> () in
                //self.fetchContactsFromServer()
                DispatchQueue.main.async {
                self.tblForChat.reloadData()
                }
            })*/
        //}

        DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.default).async
        {
            self.fetchcontactsnew({(result)-> () in
                
                
                //    DispatchQueue.main.async
                //  {
                // self.tblForChats.reloadData()
                
                //commenting newwwwwwww -===-===-=
                if(result==true)
                {
                    DispatchQueue.main.async
                    {
                        self.tblForChat.reloadData()
                        
                        
                    }
                }
                }
            )}
        
      
        
    }
    
    //=====================================
    //to fetch contacts from SQLite db
    
    
    func fetchcontactsnew(_ completion:(_ result:Bool)->())
    {
        
        let messages2=NSMutableArray()
        
        let name = Expression<String>("name")
        let phone = Expression<String>("phone")
        let actualphone = Expression<String>("actualphone")
        let email = Expression<String>("email")
        let lastname = Expression<String>("lastname")
        
        let allcontacts = sqliteDB.allcontacts
        var ContactNames=""
        var ContactUsernames=""
        var ContactsPhone=""
        
        var ContactFirstname=""
        var ContactLastNAme=""
        //var ContactsObjectss:[JSON]=[]
        
        var ContactOnlineStatus=0
        var ContactsEmail=""
           let ContactStatus=""
        var ContactsProfilePic=Data.init()
        
        let uniqueidentifier = Expression<String>("uniqueidentifier")
        
        
        let joinrows=self.leftJoinContactsTables()
        
        do{
            for ccc in joinrows {
              
                var picfound=false
                ContactNames=ccc.get(name)
                ContactUsernames=ccc.get((allcontacts?[phone])!)
                ContactsPhone=ccc.get((allcontacts?[phone])!)
                ContactsEmail=ccc.get((allcontacts?[email])!)
                //ContactLastNAme=ccc.get(allcontacts[lastname])
                let contactStore = CNContactStore()
                
                let keys = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactEmailAddressesKey, CNContactPhoneNumbersKey, CNContactImageDataAvailableKey,CNContactThumbnailImageDataKey, CNContactImageDataKey]
                //--- var foundcontact=try contactStore.unifiedContactWithIdentifier(picquery[uniqueidentifier], keysToFetch: keys)
                let foundcontact=try contactStore.unifiedContact(withIdentifier: ccc.get(uniqueidentifier), keysToFetch: keys as [CNKeyDescriptor])
                
                
                
                if(foundcontact.imageDataAvailable==true)
                {
                    foundcontact.imageData
                    ContactsProfilePic=foundcontact.imageData!
                    picfound=true
                    //===---break
                }
                if(picfound==false)
                {
                    //print("no pic found for \(ContactUsernames)")
                    ContactsProfilePic=NSData.init() as Data
                    // print("picquery NOT found for \(ccc[phone]) and is \(NSData.init())")
                }
                
                print("favourites tab \(ContactNames) .. \(ContactsPhone)")
                messages2.add(["ContactNames":ContactNames,"ContactUsernames":ContactUsernames,"ContactsPhone":ContactsPhone,"ContactsEmail":ContactsEmail,"ContactStatus":ContactStatus,"ContactsProfilePic":ContactsProfilePic])

            
            }
            
            
            
        }
        catch{
            
        }
        
        self.messages.setArray(messages2 as [AnyObject])
        
        return completion(true)
        
    }
    
   /* func fetchContacts(completion:(result:Bool)->()){
        socketObj.socket.emit("logClient","IPHONE-LOG: fetch contacts from sqlite database")
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) {
            
            
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
        
        //-========Remove old values=====================
        //self.ContactIDs.removeAll(keepCapacity: false)
        self.ContactLastNAme.removeAll(keepCapacity: false)
        self.ContactNames.removeAll(keepCapacity: false)
        self.ContactStatus.removeAll(keepCapacity: false)
        self.ContactUsernames.removeAll(keepCapacity: false)
        self.ContactsObjectss.removeAll(keepCapacity: false)
        ////////////////////////
        self.ContactFirstname.removeAll(keepCapacity: false)
        ////////
        
        self.ContactsPhone.removeAll(keepCapacity: false)
        self.ContactsEmail.removeAll(keepCapacity: false)
        self.ContactsProfilePic.removeAll(keepCapacity: false)
        
        
        
        let tbl_contactslists=sqliteDB.contactslists
        
        
        
            
            var allcontactslist1=sqliteDB.allcontacts
            var alladdressContactsArray:Array<Row>
            
            //let phone = Expression<String>("phone")
            let kibocontact = Expression<Bool>("kiboContact")
            let name = Expression<String?>("name")
            /////////////let contactProfileImage = Expression<NSData>("profileimage")
            let uniqueidentifier = Expression<String>("uniqueidentifier")
        
        
          //  alladdressContactsArray = Array(try sqliteDB.db.prepare(allcontactslist1))
            //alladdressContactsArray[indexPath.row].get(name)
            do{for ccc in try sqliteDB.db.prepare(allcontactslist1) {
                print("in main found ccc")
                for tblContacts in try sqliteDB.db.prepare(tbl_contactslists){
                    print("in main found tblContacts")
                    if(ccc[phone]==tblContacts[phone])
                    {
                        print("in main found phone")
                        
                        
                    //}
               // }
              //  }
        //for tblContacts in try sqliteDB.db.prepare(tbl_contactslists){
           print("queryy runned count is \(tbl_contactslists.count)")
            print(tblContacts[firstname]+" "+tblContacts[lastname])
            //ContactsObjectss.append(tblContacts[contactid])
            self.ContactNames.append(ccc[name]!)
            self.ContactUsernames.append(tblContacts[username])
            // %%%%%%%%%%%%%%%%************ CHAT BUG ID %%%%%%%%%%%
           // ContactIDs.append(tblContacts[contactid])
           // ContactIDs.append(tblContacts[userid])
            self.ContactFirstname.append(tblContacts[firstname])
            self.ContactLastNAme.append(tblContacts[lastname])
            self.ContactStatus.append(tblContacts[status])
            self.ContactsEmail.append(tblContacts[email])
            self.ContactsPhone.append(tblContacts[phone])
            self.ContactOnlineStatus.append(0)
                        
                        //let queryPic = allcontactslist1.filter(allcontactslist1[phone] == ccc[phone])          // SELECT "email" FROM "users"
                        
                        var picfound=false
                        //--------
                        
                        let queryPic = allcontactslist1.filter(allcontactslist1[phone] == ccc[phone])          // SELECT "email" FROM "users"
                        
                        
                        do{
                            for picquery in try sqliteDB.db.prepare(queryPic) {
                                
                                let contactStore = CNContactStore()
                                
                                var keys = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactEmailAddressesKey, CNContactPhoneNumbersKey, CNContactImageDataAvailableKey,CNContactThumbnailImageDataKey, CNContactImageDataKey]
                                var foundcontact=try contactStore.unifiedContactWithIdentifier(picquery[uniqueidentifier], keysToFetch: keys)
                                if(foundcontact.imageDataAvailable==true)
                                {
                                    foundcontact.imageData
                                    self.ContactsProfilePic.append(foundcontact.imageData!)
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
                            }
                        }
                        catch
                        {
                            print("error in fetching profile image")
                        }
                        

                        
                        
                        //-----
                       /* do{
                            for picquery in try sqliteDB.db.prepare(queryPic) {
                                // if(contactProfileImage != NSData.init())
                                //{
                                print("picquery found for \(ccc[phone])")
                                ContactsProfilePic.append(picquery[contactProfileImage])
                                picfound=true
                                //}
                                /*else
                                 {
                                 
                                 }*/
                            }
                        }
                        catch
                        {
                            print("error in fetching profile image")
                        }
                        */
                        
                        
                        
                        if(picfound==false)
                        {
                            self.ContactsProfilePic.append(NSData.init())
                        }
                        
                    }
                    else
                    {
                        print("phone not found")
                    }
                }

        }
                DispatchQueue.main.async
                {
            return completion(result:true)
        }
            }catch
        {
            print("query not runned contactlist")
            DispatchQueue.main.async
            {
                return completion(result:true)
            }
        }
        }
    
    }
    */
    
    //======================================
    //to fetch contacts from server
    

    
    func leftJoinContactsTables()->Array<Row>
    {
        
        var resultrow=Array<Row>()
        let name = Expression<String>("name")
        let phone = Expression<String>("phone")
        let actualphone = Expression<String>("actualphone")
        let email = Expression<String>("email")
        let kiboContact = Expression<Bool>("kiboContact")
        /////////////////////let profileimage = Expression<NSData>("profileimage")
        let uniqueidentifier = Expression<String>("uniqueidentifier")
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
        var joinquery=contactslists?.join(.cross, allcontacts!, on: (allcontacts?[phone])! == (contactslists?[phone])!)
        
        do{for joinresult in try sqliteDB.db.prepare(joinquery!) {
            
            if(joinresult[uniqueidentifier] == ""){}
            else{
                resultrow.append(joinresult)
            }
            }
        }
        catch{
            print("error in join query \(error)")
        }
        return resultrow
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func unwindToChat (_ segueSelected : UIStoryboardSegue) {
        print("unwind chat", terminator: "")
      
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //refreshControl.addTarget(self, action: Selector("fetchContacts"), forControlEvents: UIControlEvents.ValueChanged)
        
        //==--print(ContactNames.count, terminator: "")
       // return ContactNames.count+2
        return messages.count+2
    }
    
    func numberOfSectionsInTableView(_ tableView: UITableView!) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath!) -> UITableViewCell! {
        
        
        
        
        
        /* if (indexPath.row%2 == 0){
        return tblForChat.dequeueReusableCellWithIdentifier("ChatPrivateCell") as! UITableViewCell
        } else {
        return tblForChat.dequeueReusableCellWithIdentifier("ChatPublicCell")as! UITableViewCell
        }
        */
         print("indexpath row number is \(indexPath.row)")
        if(indexPath.row < (messages.count))
        {
            var messageDic = messages.object(at: indexPath.row) as! [String : AnyObject];
            
            //let ContactLastNAme=messageDic["ContactLastNAme"] as! String
            let ContactNames=messageDic["ContactNames"] as! String
            let ContactStatus=messageDic["ContactStatus"] as! String
            let ContactUsernames=messageDic["ContactUsernames"] as! String
            //let ContactFirstname=messageDic["ContactFirstname"] as! String
            let ContactsPhone=messageDic["ContactsPhone"] as! String
            let ContactsProfilePic=messageDic["ContactsProfilePic"] as! Data
            
      //==---  let cellPublic=tblForChat.dequeueReusableCellWithIdentifier("ChatPublicCell") as! ContactsListCell
        
        let cell=tblForChat.dequeueReusableCell(withIdentifier: "ChatPrivateCell") as! ContactsListCell
        
        //%%%%%%%%%%%%%%%%cell.contactName?.text=ContactNames[indexPath.row]
        
        var contactFound=false
        var allcontacts=sqliteDB.allcontacts
        var contactsKibo=sqliteDB.contactslists
        //var allkiboContactsArray:Array<Row>
        
        let phone = Expression<String>("phone")
        let usernameFromDb = Expression<String?>("username")
        let name = Expression<String?>("name")
        cell.contactName?.text=ContactNames
            cell.profilePic.image=UIImage(named: "profile-pic1")

            //if(!ContactsProfilePic.isEmpty && ContactsProfilePic[indexPath.row] != NSData.init())
            if(ContactsProfilePic != Data.init())
            {
                
                   print("ound avatar in favourites")
                
                let img=UIImage(data:ContactsProfilePic)
                let w=img!.size.width
                var h=img!.size.height
                let wOld=cell.profilePic.bounds.width
                var hOld=cell.profilePic.bounds.height
                let scale:CGFloat=w/wOld
                
                ////self.ResizeImage(img!, targetSize: CGSizeMake(cell.profilePic.bounds.width,cell.profilePic.bounds.height))
                
                cell.profilePic.layer.borderWidth = 1.0
                cell.profilePic.layer.masksToBounds = false
                cell.profilePic.layer.borderColor = UIColor.white.cgColor
                cell.profilePic.layer.cornerRadius = cell.profilePic.frame.size.width/2
                cell.profilePic.clipsToBounds = true
                
                imageCache.add(img!, withIdentifier: ContactUsernames)
                
                // Fetch
                var cachedAvatar = imageCache.image(withIdentifier: ContactUsernames)
                cachedAvatar=UtilityFunctions.init().resizedAvatar(img: cachedAvatar, size: CGSize(width: cell.profilePic.bounds.width,height: cell.profilePic.bounds.height), sizeStyle: "Fill")
                    
                cell.profilePic.image=cachedAvatar
                    
                    /*cell.profilePic.image=UIImage(data: ContactsProfilePic, scale: scale)
                ///cell.profilePic.image=UIImage(data:ContactsProfilePic[indexPath.row])
                UIImage(data: ContactsProfilePic, scale: scale)
                print("image size is s \(UIImage(data:ContactsProfilePic)?.size.width) and h \(UIImage(data:ContactsProfilePic)?.size.height)")*/
            }
            else
            {
                print("not found avatar in favourites")
                cell.profilePic.image=UIImage(named: "profile-pic1")
                
            }
            
            
        /*if ContactOnlineStatus==0
        {
            cell.btnGreenDot.hidden=true
        }
        else
        {
            cell.btnGreenDot.hidden=false
        }*/
        
        
        return cell
        }
        else {if(indexPath.row == (messages.count))
        {print("here count is \(messages.count)")
            let cell = tblForChat.dequeueReusableCell(withIdentifier: "InviteToKiboAppCell")! as UITableViewCell
           
            return cell
        }
        else
        {
         // print("here2 count is \(ContactNames.count)")
            let cell = tblForChat.dequeueReusableCell(withIdentifier: "numberOfFavouritesCell") as! numberOfFavouritesCell
           cell.lbl_numberOfFavourites.text = "\(messages.count) Favourites"
            return cell
        }
        }
    
    }
    
    func tableView(_ tableView: UITableView!, didSelectRowAtIndexPath indexPath: IndexPath!){
        
        //let indexPath = tableView.indexPathForSelectedRow();
        //let currentCell = tableView.cellForRowAtIndexPath(indexPath!) as UITableViewCell!;
        //if(indexPath.row < (ContactNames.count))
        //{
        //print(ContactNames[indexPath.row], terminator: "")
        self.performSegue(withIdentifier: "favouritesChat", sender: nil);
        //}
        //slideToChat
        
    }
    
    func tableView(_ tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: IndexPath) {
       /*
        if(indexPath.row < (ContactNames.count))
        {
        if editingStyle == .Delete {
            
             var selectedRow = indexPath.row
            print(selectedRow.description+" selected", terminator: "")
            
            var removeChatFromServer=NetworkingLibAlamofire()
            var loggedFirstName=loggedUserObj["firstname"]
            var loggedLastName=loggedUserObj["lastname"]
            var loggedStatus=loggedUserObj["status"]
            //%%%%%%%%var loggedUsername=loggedUserObj["username"]
            
            print(self.ContactFirstname[selectedRow]+self.ContactLastNAme[selectedRow]+self.ContactStatus[selectedRow]+self.ContactUsernames[selectedRow], terminator: "")
            
            
            
            
            var url=Constants.MainUrl+Constants.removeFriend
            
            //var params=self.ContactsObjectss[selectedRow].arrayValue
            //var pp=JSON(params)
            //var bb=jsonString(self.ContactsObjectss[selectedRow].stringValue)
            //var a=JSONStringify(self.ContactsObjectss[selectedRow].object, prettyPrinted: false)
            Alamofire.request(.POST,"\(url)",headers:header,parameters:["phone":"\(self.ContactUsernames[selectedRow])"]
                ).validate(statusCode: 200..<300).responseJSON{response in
                    var response1=response.response
                    var request1=response.request
                    var data1=response.data
                    var error1=response.result.error
                
                //===========INITIALISE SOCKETIOCLIENT=========
                dispatch_async(dispatch_get_main_queue(), {
                    
                    //self.dismiss(true, completion: nil);
                    /// self.performSegueWithIdentifier("loginSegue", sender: nil)
                    
                    if response1?.statusCode==200 {
                        //print("got user success")
                        print("Request success")
                        var json=JSON(data1!)

                        
                        print(json)
                        //print(json)
                        //dataMy=JSON(data1!)
                        //print(dataMy.description)
                        
                        sqliteDB.deleteChat(self.ContactNames[selectedRow])
                        
                        //print(ContactNames[selectedRow]+" deleted")
                        sqliteDB.deleteFriend(self.ContactUsernames[selectedRow])
                        self.ContactNames.removeAtIndex(selectedRow)
                        self.ContactIDs.removeAtIndex(selectedRow)
                        self.ContactFirstname.removeAtIndex(selectedRow)
                        self.ContactLastNAme.removeAtIndex(selectedRow)
                        self.ContactStatus.removeAtIndex(selectedRow)
                        self.ContactUsernames.removeAtIndex(selectedRow)
                        self.ContactsEmail.removeAtIndex(selectedRow)
                        self.ContactsPhone.removeAtIndex(selectedRow)
                        // Delete the row from the data source
                        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                        //tblForChat.reloadData()
                        
                    }
                    else
                    {
                        print("delete friend failed")
                        //var json=JSON(error1!)
                        print(error1?.description)
                        print(response1?.statusCode)
                        //errorMy=JSON(error1!)
                        // print(errorMy.description)
                    }
                })
                    if(response1!.statusCode==401)
                    {
                        print(error1)
                        print("delete friend failed token expired")
                        self.rt.refrToken()
                        
                    }
                    
            }
            //return dataMy
        
        
        
        
        
           /* removeChatFromServer.sendRequestPOST("POST", url: Constants.MainUrl+Constants.removeFriend+"?access_token=\(AuthToken)", parameters1: ["firstname":"\(ContactFirstname[selectedRow])", "lastname":"\(ContactLastNAme[selectedRow])", "status":"\(ContactStatus[selectedRow])", "username" : "\(ContactUsernames[selectedRow])"])
            */
        
        
            
            
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
        
            }
        */
    }
    
    
    
    
   // func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject]?  {
        // 1
        
        /*
        var shareAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Delete" , handler: { (action:UITableViewRowAction, indexPath:NSIndexPath) -> Void in
            // 2
            
            
            /*let shareMenu = UIAlertController(title: nil, message: "Share using", preferredStyle: .ActionSheet)
            
            let twitterAction = UIAlertAction(title: "Twitter", style: UIAlertActionStyle.Default, handler: nil)
            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil)
            
            shareMenu.addAction(twitterAction)
            shareMenu.addAction(cancelAction)
            
            
            self.presentViewController(shareMenu, animated: true, completion: nil)

*/
            
            
            var selectedRow = indexPath.row
            print(selectedRow.description+" selected")
            
            var removeChatFromServer=NetworkingLibAlamofire()
            var loggedFirstName=loggedUserObj["firstname"]
            var loggedLastName=loggedUserObj["lastname"]
            var loggedStatus=loggedUserObj["status"]
            var loggedUsername=loggedUserObj["username"]
            
            print(self.ContactFirstname[selectedRow]+self.ContactLastNAme[selectedRow]+self.ContactStatus[selectedRow]+self.ContactUsernames[selectedRow])
            
            
            
            
            var url=Constants.MainUrl+Constants.removeFriend
            
            //var params=self.ContactsObjectss[selectedRow].arrayValue
            //var pp=JSON(params)
            //var bb=jsonString(self.ContactsObjectss[selectedRow].stringValue)
            //var a=JSONStringify(self.ContactsObjectss[selectedRow].object, prettyPrinted: false)
            Alamofire.request(.POST,"\(url)",headers:header,parameters:["phone":"\(self.ContactUsernames[selectedRow])"]
                ).validate(statusCode: 200..<300).responseJSON{response in
                    var response1=response.response
                    var request1=response.request
                    var data1=response.data
                    var error1=response.result.error
                    //===========INITIALISE SOCKETIOCLIENT=========
                    dispatch_async(dispatch_get_main_queue(), {
                        
                        //self.dismiss(true, completion: nil);
                        /// self.performSegueWithIdentifier("loginSegue", sender: nil)
                        
                        if response1?.statusCode==200 {
                            //print("got user success")
                            print("Request success")
                            var json=JSON(data1!)
                            
                            
                            print(json)
                            //print(json)
                            //dataMy=JSON(data1!)
                            //print(dataMy.description)
                            
                            sqliteDB.deleteChat(self.ContactNames[selectedRow])
                            
                            //print(ContactNames[selectedRow]+" deleted")
                            sqliteDB.deleteFriend(self.ContactUsernames[selectedRow])
                            self.ContactNames.removeAtIndex(selectedRow)
                            self.ContactIDs.removeAtIndex(selectedRow)
                            self.ContactFirstname.removeAtIndex(selectedRow)
                            self.ContactLastNAme.removeAtIndex(selectedRow)
                            self.ContactStatus.removeAtIndex(selectedRow)
                            self.ContactUsernames.removeAtIndex(selectedRow)
                            self.ContactsPhone.removeAtIndex(selectedRow)
                            self.ContactsEmail.removeAtIndex(selectedRow)
                            // Delete the row from the data source
                            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                            //tblForChat.reloadData()
                            
                        }
                        else
                        {
                            print("delete friend failed")
                            //var json=JSON(error1!)
                            print(error1?.description)
                            print(response1?.statusCode)
                            //errorMy=JSON(error1!)
                            // print(errorMy.description)
                        }
                    })
                    if(response1!.statusCode==401)
                    {
                        print(error1)
                        print("delete friend failed token expired")
                        self.rt.refrToken()
                        
                    }
                    
            }

        })
        // 3
        var rateAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Call" , handler: { (action:UITableViewRowAction, indexPath:NSIndexPath) -> Void in
            
            //ON CALL BUTTON PRESSED
            
            var selectedRow = indexPath.row
            print("call pressed")
            isConference=false
            //-----------------------------------
            ///NEWW WEBMEETING WORKING CODE
            //------------------------------------
            /*username = "iphoneUser"
            iamincallWith = "webConference"
            isInitiator = false
            isConference = true
            ////ConferenceRoomName = txtForRoomName.text!
            /////////socketObj.sendMessagesOfMessageType("Conference Call")
            
            socketObj.socket.emitWithAck("init.new", ["room":ConferenceRoomName,"username":username!])(timeoutAfter: 150000000) {data in
                print("room joined by got ack")
                var a=JSON(data)
                print(a.debugDescription)
                currentID=a[1].int!
                print("current id is \(currentID)")
                print("room joined is\(ConferenceRoomName)")
                joinedRoomInCall=ConferenceRoomName
            }
           /// var mAudio=MeetingRoomAudio()
            ////mAudio.initAudio()
            
            var next = self.storyboard?.instantiateViewControllerWithIdentifier("Main2") as! ConferenceCallViewController
            
            self.presentViewController(next, animated: false, completion: {
            })
            
            */
            
            
            /////mVideo.initVideo()
            
            //------------------------
            //CONFERENCE CODE COMMENTED
            
            //var selectedRow = indexPath.row
            
            print("call pressed")
            /*
            username = "iphoneUser"
            iamincallWith = "webConference"
            isInitiator = true
            isConference = true
            ////ConferenceRoomName = txtForRoomName.text!
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

            
            
            
            //-----------------------
            /*let next = self.storyboard!.instantiateViewControllerWithIdentifier("MainV2") as! VideoViewController
            
            self.presentViewController(next, animated: true, completion:nil)
            */
            
            
            //////////////////////////////
            //CORRECT CODE ONE TO ONE CALL COMMENTED
            //////////////////////////////
            if(self.ContactOnlineStatus[selectedRow]==0)
            {
                
                print("contact is offline")
                
                socketObj.socket.emit("logClient","IPHONE-LOG: contact is offline")
            }
            socketObj.socket.emit("logClient","IPHONE-LOG: callthisperson,room:globalchatroom,callee: \(self.ContactUsernames[selectedRow]), caller:\(username!)")
            socketObj.socket.emit("callthisperson",["room" : "globalchatroom","callee": self.ContactUsernames[selectedRow], "caller":username!])
            isInitiator=true
            callerName=username!
            iamincallWith=self.ContactUsernames[selectedRow]

            
            
            /*
            var next = self.storyboard?.instantiateViewControllerWithIdentifier("Main2") as! VideoViewController
            
            self.presentViewController(next, animated: false, completion: {
            })
*/
            
            /*var next = self.storyboard?.instantiateViewControllerWithIdentifier("Main") as! CallRingingViewController
            
             self.presentViewController(next, animated: false, completion: {next.txtCallerName.text=self.currrentUsernameRetrieved
             next.txtCallingDialing.text="Dialing.."
                next.callerName=self.currrentUsernameRetrieved
             })
*/

            // 4
           /* let rateMenu = UIAlertController(title: nil, message: "Rate this App", preferredStyle: .ActionSheet)
            
            let appRateAction = UIAlertAction(title: "Rate", style: UIAlertActionStyle.Default, handler: nil)
            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil)
            
            rateMenu.addAction(appRateAction)
            rateMenu.addAction(cancelAction)
            
            
            self.presentViewController(rateMenu, animated: true, completion: nil)
*/
        }

)


        // 5
        return [shareAction,rateAction]
*/
   // }

    @IBAction func inviteFriendsButtonPressed(_ sender: AnyObject) {
        let shareMenu = UIAlertController(title: nil, message: "Invite using", preferredStyle: .actionSheet)
        
        let mailAction = UIAlertAction(title: "Mail", style: UIAlertActionStyle.default,handler: { (action) -> Void in
            
            self.sendType="Mail"
            self.performSegue(withIdentifier: "inviteSegue",sender: nil)
            /*let mailComposeViewController = self.configuredMailComposeViewController()
             if MFMailComposeViewController.canSendMail() {
             self.presentViewController(mailComposeViewController, animated: true, completion: nil)
             } else {
             self.showSendMailErrorAlert()
             }*/
        })
        let msgAction = UIAlertAction(title: "Message", style: UIAlertActionStyle.default, handler: { (action) -> Void in
            
            self.sendType="Message"
            self.performSegue(withIdentifier: "inviteSegue",sender: nil)
            /*var messageVC = MFMessageComposeViewController()
             
             messageVC.body = "Enter a message";
             messageVC.recipients = ["03201211991"]
             messageVC.messageComposeDelegate = self;
             
             self.presentViewController(messageVC, animated: false, completion: nil)
             */
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler:nil)
        shareMenu.addAction(mailAction)
        shareMenu.addAction(msgAction)
        shareMenu.addAction(cancelAction)
        
        
        
        self.present(shareMenu, animated: true, completion: {
            
        })
        
    }
    
    
    
    // #pragma mark - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    
    override func prepare(for segue: UIStoryboardSegue?, sender: Any?) {
        //var newController=segue ?.destinationViewController
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        
        //if segue!.identifier == "chatSegue" {
        /*if segue!.identifier == "inviteSegue"{
            if let destinationVC = segue!.destinationViewController as? ContactsInviteViewController{
                
                //contactsList.searchContactsByEmail(contactsList.emails)
            }
        }*/
        if segue!.identifier == "favouritesChat" {
            
            if let destinationVC = segue!.destination as? ChatDetailViewController{
                
                let selectedRow = tblForChat.indexPathForSelectedRow!.row
                
                var messageDic = messages.object(at: selectedRow) as! [String : AnyObject];
        
                
                //destinationVC.selectedContact = ContactNames[selectedRow]
                destinationVC.selectedContact = messageDic["ContactUsernames"] as! String
                destinationVC.selectedFirstName=messageDic["ContactNames"] as! String
                destinationVC.selectedLastName=""
               // destinationVC.selectedID=ContactIDs[selectedRow]
                //destinationVC.AuthToken = self.AuthToken
                
                //
                /* var getUserbByIdURL=Constants.MainUrl+Constants.getSingleUserByID+ContactIDs[selectedRow]+"?access_token="+AuthToken
                print(getUserbByIdURL.debugDescription+"..........")
                Alamofire.request(.GET,"\(getUserbByIdURL)").response{
                request, response, data, error in
                print(error)
                
                if response?.statusCode==200
                
                {
                print("got userrrrrrr")
                print(data?.debugDescription)
                print(":::::::::")
                destinationVC.selectedUserObj=JSON(data!)
                }
                else
                {
                print("didnt get userrrrr")
                print(error)
                print(data)
                print(response)
                }
                }*/
                
                //
            }
        }
        if segue!.identifier == "inviteSegue" {
            let destinationNavigationController = segue!.destination as! UINavigationController
            let destinationVC = destinationNavigationController.topViewController as? ContactsInviteViewController
            
            destinationVC?.sendType=self.sendType
            

        }
        
        
    }
    
    
    
    ///////////////////////////////
    //SOCKET CLIENT DELEGATE MESSAGES
    ///////////////////////////////
    /*
    func socketReceivedMessage(message:String,data:AnyObject!)
    {print("socketReceivedMessage inside", terminator: "")
        //var msg=JSON(params)
        switch(message)
        {
            case "Accept Call":
                print("Accept call in chat view")
              
                callerName=KeychainWrapper.stringForKey("username")!
                  print("callerName is ........... \(callerName)")
                socketObj.socket.emit("logClient","IPHONE-LOG: callerName is ........... \(callerName)")
                //iamincallWith=msg[0]["callee"].string!
                
                print("callee is \(callerName)", terminator: "")
                
                var roomname=""
                if(ConferenceRoomName == "")
                {
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
                
                
                ////
                var next = self.storyboard!.instantiateViewControllerWithIdentifier("MainV2") as! VideoViewController
                
                self.presentViewController(next, animated: true, completion: {
                })
            }
        case "othersideringing":
        print(message)
            iOSstartedCall=true
            //////*** newww may 2016
        
        callerName=KeychainWrapper.stringForKey("username")!
        //iamincallWith=msg[0]["callee"].string!
        
        print("callee is \(callerName)", terminator: "")
        
        /*
        ///NEW ADDED
        
        
        ////
        var next = self.storyboard!.instantiateViewControllerWithIdentifier("MainV2") as! VideoViewController
        
        self.presentViewController(next, animated: true, completion: {
        })
           */ 
        case "offline":
            
            
                    print("offline status...", terminator: "")
                    var offlineUsers=JSON(data!)
                    print(offlineUsers[0])
                    //print(offlineUsers[0]["username"])
                    
                    for(var i=0;i<offlineUsers.count;i++)
                    {
                        for(var j=0;j<self.ContactUsernames.count;j++)
                        {
                            if self.ContactUsernames[j]==offlineUsers[i]["username"].string!
                            {
                                //found online contact,s username
                                print("user found offlinee \(self.ContactUsernames[j])")
                                self.ContactOnlineStatus[j]=0
                                self.tblForChat.reloadData()
                            }
                        }
                    }
            
            case "theseareonline":
               
                        print("theseareonline status...", terminator: "")
                        var theseareonlineUsers=JSON(data!)
                        print(theseareonlineUsers.object)
                        print(theseareonlineUsers[0])
                        //print(offlineUsers[0]["username"])
                        print("contact user names count is \(self.ContactUsernames.count) and theseareonline users count is \(theseareonlineUsers[0].count) and self array of online users count is \(self.ContactOnlineStatus.count)")
                        for(var i=0;i<theseareonlineUsers[0].count;i++)
                        {
                            for(var j=0;j<self.ContactUsernames.count && i<theseareonlineUsers.count;j++)
                            {
                                if self.ContactUsernames[j]==theseareonlineUsers[0][i]["username"].description
                                {
                                    //found online contact,s username
                                    print("user found theseareonline \(self.ContactUsernames[j])")
                                    self.ContactOnlineStatus[j]=1
                                    print("line # 1699")
                                    // *** newwww self.tblForChat.reloadData()
                                }
                            }
                        }
            
            
        case "yesiamfreeforcall":
                var message=JSON(data!)
                print("other user is free", terminator: "")
                print(data?.debugDescription, terminator: "")
            
            
        case "areyoufreeforcall":
        
            var jdata=JSON(data!)
        print("areyoufreeforcall ......", terminator: "")
            print(jdata.debugDescription)
            
            if(areYouFreeForCall==true)
            {   iOSstartedCall=false
                print(jdata[0]["caller"].string!)
                print(self.currrentUsernameRetrieved, terminator: "")
                iamincallWith=jdata[0]["caller"].string!
                isInitiator=false
                //callerID=jdata[0]["sendersocket"].string!
                //transition
                
                //let secondViewController:CallRingingViewController = CallRingingViewController()
                
                print("currrentUsernameRetrieved is \(currrentUsernameRetrieved)")
                socketObj.socket.emit("yesiamfreeforcall",["mycaller" : jdata[0]["caller"].string!, "me":self.currrentUsernameRetrieved])
                
                var next = self.storyboard?.instantiateViewControllerWithIdentifier("Main") as! CallRingingViewController
                
                self.presentViewController(next, animated: false, completion: {next.txtCallerName.text=jdata[0]["caller"].string!; next.currentusernameretrieved=self.currrentUsernameRetrieved; next.callerName=jdata[0]["caller"].string!
                    isInitiator=false
                })
                
                
            }
            else{
                socketObj.socket.emit("noiambusy",["mycaller" : jdata[0]["caller"].string!, "me":self.currrentUsernameRetrieved])
                /*
                print("i am busyyy", terminator: "")
                let alert = UIAlertView()
                alert.title = "Sorry"
                alert.message = "Your friend is busy on another call"
                alert.addButtonWithTitle("Ok")
                alert.show()*/
                
            }
         
            
        
            

        default: print("", terminator: "")
        
        }//end switch

    }
    func socketReceivedSpecialMessage(message:String,params:JSON!)
    {
        
    }
    
    */*/
    override func viewWillDisappear(_ animated: Bool) {
        print("dismissed chatttttttt")
        //socketObj.delegate=nil
        syncServiceContacts.delegateRefreshContactsList=nil
    }

    func refreshContactsList(_ message: String) {
        
        DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async {
            // do some task start to show progress wheel
            self.fetchcontactsnew({ (result) -> () in
                //self.fetchContactsFromServer()
                //DispatchQueue.main.async {
                self.tblForChat.reloadData()
                //}
            })
        }
    }

}


/*
print("otherside ringing")
var msg=JSON(data)
//self.othersideringing=true;
print(msg.debugDescription)
callerName=KeychainWrapper.stringForKey("username")!
//iamincallWith=msg[0]["callee"].string!

print("callee is \(callerName)")

var next = self.storyboard?.instantiateViewControllerWithIdentifier("Main2") as! VideoViewController

self.presentViewController(next, animated: true, completion: {
})


*/


