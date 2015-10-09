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

class ChatViewController: UIViewController {
    
    
    var refreshControl = UIRefreshControl()
    //var contactsJsonObj:JSON="[]"
    @IBOutlet var viewForTitle : UIView!
    @IBOutlet var ctrlForChat : UISegmentedControl!
    @IBOutlet var btnForLogo : UIButton!
    var loggedID=loggedUserObj["_id"]
    //@IBOutlet var itemForSearch : UIBarButtonItem!
    @IBOutlet var tblForChat : UITableView!
    //var AuthToken:String=""
    //var socketObj=LoginAPI(url: "\(Constants.MainUrl)")
    @IBOutlet weak var btnContactAdd: UIBarButtonItem!
    
    @IBAction func addContactTapped(sender: UIBarButtonItem) {
        /* let alert = UIAlertView()
        alert.title = "Alert"
        alert.message = "Here's a message"
        alert.addButtonWithTitle("Understod")
        alert.show()
        */
        
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
            
            println(loggedUserObj)
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
            var addContactUsernameURL=Constants.MainUrl+Constants.addContactByEmail+"?access_token=\(AuthToken)"
            Alamofire.request(.POST,"\(addContactUsernameURL)",parameters: ["searchemail":"\(tField.text!)"]).responseJSON{
                request1, response1, data1, error1 in
                //searchemail  f@lkjlklkm.com
                //====================
                dispatch_async(dispatch_get_main_queue(), {
                    
                    self.dismissViewControllerAnimated(true, completion: nil);
                    /// self.performSegueWithIdentifier("loginSegue", sender: nil)
                    
                    if response1?.statusCode==200 {
                        println("success")
                        
                        var json=JSON(data1!)
                        //println(json)
                        if(json["msg"].string=="null")
                        {println("Invalid email")}
                        else
                        {
                            if(json["status"].string=="danger"){
                                println("contact already in your list")}
                            else
                            {println("friend request sent")}
                        }
                    }
                    else
                    {
                        println("error in sending friend request")
                    }
                })
            }
            
        }
        actionSheetController.addAction(cancelAction)
        //Create and an option action
        let nextAction: UIAlertAction = UIAlertAction(title: "Add by Username", style: UIAlertActionStyle.Default) { action -> Void in
            
            //var ContactEmail=self.ContactsObjectss[]
            println(loggedUserObj)
            var userid=""
            socketObj.socket.emit("friendrequest",[
                "room":"globalchatroom",
                "userid":loggedUserObj.object,
                "contact":"\(tField.text!)"]
            )
            
            
            //Do some other stuff
            var addContactUsernameURL=Constants.MainUrl+Constants.addContactByUsername+"?access_token=\(AuthToken)"
            Alamofire.request(.POST,"\(addContactUsernameURL)",parameters: ["searchusername":"\(tField.text!)"]).responseJSON{
                request1, response1, data1, error1 in
                //searchemail  f@lkjlklkm.com
                //====================
                dispatch_async(dispatch_get_main_queue(), {
                    
                    self.dismissViewControllerAnimated(true, completion: nil);
                    /// self.performSegueWithIdentifier("loginSegue", sender: nil)
                    
                    if response1?.statusCode==200 {
                        println("success")
                        
                        var json=JSON(data1!)
                        //println(json)
                        if(json["msg"].string=="null")
                        {println("Invalid user")}
                        else
                        {
                            if(json["status"].string=="danger"){
                                println("contact already in your list")}
                            else
                            {println("friend request sent")}
                        }
                    }
                    else
                    {
                        println("error in sending friend request")
                    }
                })
            }
            
        }
        actionSheetController.addAction(nextAction)
        
        
        //Present the AlertController
        self.presentViewController(actionSheetController, animated: true, completion: nil)
    }
    
    var ContactNames:[String]=[]
    var ContactUsernames:[String]=[]
    var ContactIDs:[String]=[]
    var ContactFirstname:[String]=[]
    var ContactLastNAme:[String]=[]
    var ContactStatus:[String]=[]
    var ContactsObjectss:[JSON]=[]
    
    var ContactOnlineStatus:[Int]=[]
    
    //["Bus","Helicopter","Truck","Boat","Bicycle","Motorcycle","Plane","Train","Car","Scooter","Caravan"]
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        // Custom initialization
        
    }
    
    required init(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        println(AuthToken)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
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
        
        self.navigationItem.titleView = viewForTitle
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: btnForLogo)
        //self.navigationItem.rightBarButtonItem = itemForSearch
        self.navigationItem.rightBarButtonItem = btnContactAdd
        self.tabBarController?.tabBar.tintColor = UIColor.greenColor()
        println("////////////////////// new class tokn \(AuthToken)")
        // fetchContacts(AuthToken)
        println(self.ContactNames.count.description)
        // self.tblForChat.reloadData()
        
        
       
        //========
        socketObj.socket.on("online")
            {data,ack in
                    
                    println("online status...")
                    var onlineUsers=JSON(data!)
                    println(onlineUsers[0])
                    //println(onlineUsers[0]["username"])
                
                for(var i=0;i<onlineUsers.count;i++)
                {
                    for(var j=0;j<self.ContactUsernames.count;j++)
                    {
                        if self.ContactUsernames[j]==onlineUsers[i]["username"].string!
                        {
                            //found online contact,s username
                            println("user found onlineeeee \(self.ContactUsernames[j])")
                            self.ContactOnlineStatus[j]=1
                            self.tblForChat.reloadData()
                        }
                    }
                }
                
                }
        
       

     
        
        //======Offline users=========
        socketObj.socket.on("offline")
            {data,ack in
                
                println("offline status...")
                var offlineUsers=JSON(data!)
                println(offlineUsers[0])
                //println(offlineUsers[0]["username"])
                
                for(var i=0;i<offlineUsers.count;i++)
                {
                    for(var j=0;j<self.ContactUsernames.count;j++)
                    {
                        if self.ContactUsernames[j]==offlineUsers[i]["username"].string!
                        {
                            //found online contact,s username
                            println("user found offlinee \(self.ContactUsernames[j])")
                            self.ContactOnlineStatus[j]=0
                            self.tblForChat.reloadData()
                        }
                    }
                }
                
        }
        
        
       
        //refreshControl.addTarget(self, action: Selector("fetchContacts"), forControlEvents: UIControlEvents.ValueChanged)
        //self.refreshControl = refreshControl
        
        
        let username = Expression<String?>("username")
        //if sqliteDB.db["accounts"].count(username)<1
        //if AuthToken==""
        
        //everytime new login
        //^^^^^^^^^^^KeychainWrapper.removeObjectForKey("access_token")
        let retrievedToken=KeychainWrapper.stringForKey("access_token")
        if retrievedToken==nil
        {performSegueWithIdentifier("loginSegue", sender: nil)}
        else
        {println("rrrrrrrrr \(retrievedToken)")
            refreshControl.addTarget(self, action: Selector("fetchContacts"), forControlEvents: UIControlEvents.ValueChanged)
            
            //fetchContacts()
            self.tblForChat.reloadData()
            //performSegueWithIdentifier("loginSegue", sender: nil)
        }
        
        // Do any additional setup after loading the view.
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        fetchContacts()
        
        //var db=DatabaseHandler(dbName: "abc.sqlite")
        
        
    }
    
    //=====================================
    //to fetch contacts from SQLite db
    
    func fetchContacts(){
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
        /*self.ContactIDs.removeAll(keepCapacity: false)
        self.ContactLastNAme.removeAll(keepCapacity: false)
        self.ContactNames.removeAll(keepCapacity: false)
        self.ContactStatus.removeAll(keepCapacity: false)
        self.ContactUsernames.removeAll(keepCapacity: false)*/
        //self.ContactsObjectss.removeAll(keepCapacity: false)

        let tbl_contactslists=sqliteDB.db["contactslists"]
        for tblContacts in tbl_contactslists.select(contactid,firstname,lastname,username,userid,status) {
           println("queryy runned count is \(tbl_contactslists.count)")
            println(tblContacts[firstname]+" "+tblContacts[lastname])
            //ContactsObjectss.append(tblContacts[contactid])
            ContactNames.append(tblContacts[firstname]+" "+tblContacts[lastname])
            ContactUsernames.append(tblContacts[username])
            ContactIDs.append(tblContacts[userid])
            ContactFirstname.append(tblContacts[firstname])
            ContactLastNAme.append(tblContacts[lastname])
            ContactStatus.append(tblContacts[status])
            ContactOnlineStatus.append(0)

        }
        
         dispatch_async(dispatch_get_main_queue(), {
            if AuthToken==nil{}
            else{
                self.fetchContactsFromServer()}
        })
    
    }
    
    
    //======================================
    //to fetch contacts from server
    
    func fetchContactsFromServer(){
        println("Server fetchingg contactss")
        var fetchChatURL=Constants.MainUrl+Constants.getContactsList+"?access_token="+AuthToken!
        
        println(fetchChatURL)
        
        Alamofire.request(.GET,"\(fetchChatURL)").response{
            
            request1, response1, data1, error1 in
            
            
            
            //============GOT Contacts SECCESS=================
            
            
            ////////////////////////
            dispatch_async(dispatch_get_main_queue(), {
                //self.fetchContacts(self.AuthToken)
                /// activityOverlayView.dismissAnimated(true)
                
                
                if response1?.statusCode==200 {
                    //println("Contacts fetched success")
                    let contactsJsonObj = JSON(data: data1!)
                    println(contactsJsonObj)
                    //println(contactsJsonObj["userid"])
                    //let contact=JSON(contactsJsonObj["contactid"])
                    //   println(contact["firstname"])
                    println("Contactsss fetcheddddddd")
                    //var userr=contactsJsonObj["userid"]
                    // println(self.contactsJsonObj.count)
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
                    
                    
                    let tbl_contactslists=sqliteDB.db["contactslists"]
                    
                    //-========Remove old values=====================
                    self.ContactIDs.removeAll(keepCapacity: false)
                    self.ContactLastNAme.removeAll(keepCapacity: false)
                    self.ContactNames.removeAll(keepCapacity: false)
                    self.ContactStatus.removeAll(keepCapacity: false)
                    self.ContactUsernames.removeAll(keepCapacity: false)
                    self.ContactsObjectss.removeAll(keepCapacity: false)
                    
                    for var i=0;i<contactsJsonObj.count;i++
                    {
                        let insert=tbl_contactslists.insert(contactid<-contactsJsonObj[i]["contactid"]["_id"].string!,
                            detailsshared<-contactsJsonObj[i]["detailsshared"].string!,
                            
                            unreadMessage<-contactsJsonObj[i]["unreadMessage"].boolValue,
                            
                            userid<-contactsJsonObj[i]["userid"].string!,
                            firstname<-contactsJsonObj[i]["contactid"]["firstname"].string!,
                            lastname<-contactsJsonObj[i]["contactid"]["lastname"].string!,
                            email<-contactsJsonObj[i]["contactid"]["email"].string!,
                            phone<-contactsJsonObj[i]["contactid"]["_id"].string!,
                            username<-contactsJsonObj[i]["contactid"]["username"].string!,
                            status<-contactsJsonObj[i]["contactid"]["status"].string!)
                        
                        //self.transportItems.insert(contactsJsonObj[i]["contactid"]["firstname"].string!+" "+contactsJsonObj[i]["contactid"]["lastname"].string!, atIndex: i)
                        
                        self.ContactsObjectss.append(contactsJsonObj[i]["contactid"])
                        self.ContactNames.append(contactsJsonObj[i]["contactid"]["firstname"].string!+" "+contactsJsonObj[i]["contactid"]["lastname"].string!)
                        self.ContactUsernames.append(contactsJsonObj[i]["contactid"]["username"].string!)
                        self.ContactIDs.append(contactsJsonObj[i]["contactid"]["_id"].string!)
                        self.ContactFirstname.append(contactsJsonObj[i]["contactid"]["firstname"].string!)
                        self.ContactLastNAme.append(contactsJsonObj[i]["contactid"]["lastname"].string!)
                        self.ContactStatus.append(contactsJsonObj[i]["contactid"]["status"].string!)
                        self.ContactOnlineStatus.append(0)
                        if let rowid = insert.rowid {
                            println("inserted id: \(rowid)")
                            self.tblForChat.reloadData()
                        } else if insert.statement.failed {
                            println("insertion failed: \(insert.statement.reason)")
                        }
                    }
                    
                    //self.refreshControl.endRefreshing()
                    
                } else {
                    println("FETCH CONTACTS FAILED")
                }
            })
            
            
            
        }
        
        
        //====These are Online====
        
        socketObj.socket.on("theseareonline")
            {data,ack in
                
                println("theseareonline status...")
                var theseareonlineUsers=JSON(data!)
                println(theseareonlineUsers.object)
                //println(offlineUsers[0]["username"])
                
                for(var i=0;i<theseareonlineUsers[0].count;i++)
                {
                    for(var j=0;j<self.ContactUsernames.count && i<theseareonlineUsers.count;j++)
                    {println(theseareonlineUsers[i].description)
                        println(theseareonlineUsers.count)
                        println(theseareonlineUsers[0][0].description)
                        println(self.ContactUsernames[j])
                        if self.ContactUsernames[j]==theseareonlineUsers[0][i]["username"].description
                        {
                            //found online contact,s username
                            println("user found theseareonline \(self.ContactUsernames[j])")
                            self.ContactOnlineStatus[j]=1
                            self.tblForChat.reloadData()
                        }
                    }
                }
                
        }
        //==========Show Online============
        
        
        socketObj.socket.emit("whozonline",[
            "room":"globalchatroom",
            "user":loggedUserObj.object])


    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func unwindToChat (segueSelected : UIStoryboardSegue) {
        println("unwind chat")
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //refreshControl.addTarget(self, action: Selector("fetchContacts"), forControlEvents: UIControlEvents.ValueChanged)
        
        println(ContactNames.count)
        return ContactNames.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView!) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        
        /* if (indexPath.row%2 == 0){
        return tblForChat.dequeueReusableCellWithIdentifier("ChatPrivateCell") as! UITableViewCell
        } else {
        return tblForChat.dequeueReusableCellWithIdentifier("ChatPublicCell")as! UITableViewCell
        }
        */
        var cell=tblForChat.dequeueReusableCellWithIdentifier("ChatPrivateCell") as! ContactsListCell
        
        cell.contactName?.text=ContactNames[indexPath.row]
        if ContactOnlineStatus[indexPath.row]==0
        {
            cell.btnGreenDot.hidden=true
        }
        else
        {
            cell.btnGreenDot.hidden=false
        }
        
        
        return cell
        
    }
    
    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!){
        
        //let indexPath = tableView.indexPathForSelectedRow();
        //let currentCell = tableView.cellForRowAtIndexPath(indexPath!) as UITableViewCell!;
        
        println(ContactNames[indexPath.row])
        self.performSegueWithIdentifier("contactChat", sender: nil);
        //slideToChat
        
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            
             var selectedRow = indexPath.row
            println(selectedRow.description+" selected")
            
            var removeChatFromServer=NetworkingLibAlamofire()
            var loggedFirstName=loggedUserObj["firstname"]
            var loggedLastName=loggedUserObj["lastname"]
            var loggedStatus=loggedUserObj["status"]
            var loggedUsername=loggedUserObj["username"]
            
            println(self.ContactFirstname[selectedRow]+self.ContactLastNAme[selectedRow]+self.ContactStatus[selectedRow]+self.ContactUsernames[selectedRow])
            
            
            
            
            var url=Constants.MainUrl+Constants.removeFriend+"?access_token=\(AuthToken)"
            
            var params=self.ContactsObjectss[selectedRow].arrayValue
            //var pp=JSON(params)
            //var bb=jsonString(self.ContactsObjectss[selectedRow].stringValue)
            //var a=JSONStringify(self.ContactsObjectss[selectedRow].object, prettyPrinted: false)
            Alamofire.request(.POST,"\(url)",parameters:["username":"\(self.ContactUsernames[selectedRow])"]
                ).responseJSON{
                request1, response1, data1, error1 in
                
                //===========INITIALISE SOCKETIOCLIENT=========
                dispatch_async(dispatch_get_main_queue(), {
                    
                    //self.dismissViewControllerAnimated(true, completion: nil);
                    /// self.performSegueWithIdentifier("loginSegue", sender: nil)
                    
                    if response1?.statusCode==200 {
                        //println("got user success")
                        println("Request success")
                        var json=JSON(data1!)

                        
                        println(json)
                        //println(json)
                        //dataMy=JSON(data1!)
                        //println(dataMy.description)
                        
                    }
                    else
                    {
                        println("request failed")
                        //var json=JSON(error1!)
                        println(error1?.description)
                        println(response1?.statusCode)
                        //errorMy=JSON(error1!)
                        // println(errorMy.description)
                    }
                })
            }
            //return dataMy
        
        
        
        
        
           /* removeChatFromServer.sendRequestPOST("POST", url: Constants.MainUrl+Constants.removeFriend+"?access_token=\(AuthToken)", parameters1: ["firstname":"\(ContactFirstname[selectedRow])", "lastname":"\(ContactLastNAme[selectedRow])", "status":"\(ContactStatus[selectedRow])", "username" : "\(ContactUsernames[selectedRow])"])
            */
        
        
            sqliteDB.deleteChat(ContactNames[selectedRow])
            
            //println(ContactNames[selectedRow]+" deleted")
            sqliteDB.deleteFriend(ContactUsernames[selectedRow])
            ContactNames.removeAtIndex(selectedRow)
            ContactIDs.removeAtIndex(selectedRow)
            ContactFirstname.removeAtIndex(selectedRow)
            ContactLastNAme.removeAtIndex(selectedRow)
            ContactStatus.removeAtIndex(selectedRow)
            ContactUsernames.removeAtIndex(selectedRow)
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            //tblForChat.reloadData()
            
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    
    
    
    // #pragma mark - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue?, sender: AnyObject?) {
        //var newController=segue ?.destinationViewController
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        
        //if segue!.identifier == "chatSegue" {
        if segue!.identifier == "contactChat" {
            
            if let destinationVC = segue!.destinationViewController as? ChatDetailViewController{
                
                let selectedRow = tblForChat.indexPathForSelectedRow()!.row
                //destinationVC.selectedContact = ContactNames[selectedRow]
                destinationVC.selectedContact = ContactUsernames[selectedRow]
                destinationVC.selectedID=ContactIDs[selectedRow]
                //destinationVC.AuthToken = self.AuthToken
                
                //
                /* var getUserbByIdURL=Constants.MainUrl+Constants.getSingleUserByID+ContactIDs[selectedRow]+"?access_token="+AuthToken
                println(getUserbByIdURL.debugDescription+"..........")
                Alamofire.request(.GET,"\(getUserbByIdURL)").response{
                request, response, data, error in
                println(error)
                
                if response?.statusCode==200
                
                {
                println("got userrrrrrr")
                println(data?.debugDescription)
                println(":::::::::")
                destinationVC.selectedUserObj=JSON(data!)
                }
                else
                {
                println("didnt get userrrrr")
                println(error)
                println(data)
                println(response)
                }
                }*/
                
                //
            }
        }
        
    }
    
}


