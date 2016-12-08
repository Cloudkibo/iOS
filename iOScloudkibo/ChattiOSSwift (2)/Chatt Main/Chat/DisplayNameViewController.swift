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
    var Q5_fetchAllGroupsData=dispatch_queue_create("fetchAllGroupsData",DISPATCH_QUEUE_SERIAL)
    var Q6_updateIsKiboStatus=dispatch_queue_create("updateIsKiboStatus",DISPATCH_QUEUE_SERIAL)
    var newserialqueue=dispatch_queue_create("newserialqueue",DISPATCH_QUEUE_SERIAL)
    
    var syncPhonesList=[String]()
    var syncContactsList=[CNContact]()
    var syncAvailablePhonesList=[String]()
    var syncNotAvailablePhonesList=[String]()
    
    var accountKit: AKFAccountKit!
    
    var name=Expression<String>("name")
    var phone=Expression<String>("phone")
    var actualphone=Expression<String>("actualphone")
    var email=Expression<String>("email")
    //////////////var profileimage=Expression<NSData>("profileimage")
    let uniqueidentifier = Expression<String>("uniqueidentifier")
    
    
    
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
        strLabel = UILabel(frame: CGRect(x: 50, y: 0, width: 270, height: 50))
        strLabel.text = msg
        strLabel.textColor = UIColor.whiteColor()
        messageFrame = UIView(frame: CGRect(x: view.frame.midX - 110, y: view.frame.midY - 25 , width: 250, height: 50))
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
                        if(socketObj != nil)
                        {
                        socketObj.socket.emit("logClient", "display name \(displayName) sent to server successfully")
                        }
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
                       if(socketObj != nil)
                       {
                        socketObj.socket.emit("logClient","IPHONE-LOG: \(error)")
                        }
                    
                    
                    
                    
                    //when server sends response:
                    
            }
        
        
        
    }
       // }
    }
    func SyncfetchContacts(completion:(result:Bool)->())
    {
        let contactStore = CNContactStore()
        
        var keys = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactEmailAddressesKey, CNContactPhoneNumbersKey, CNContactImageDataAvailableKey,CNContactThumbnailImageDataKey, CNContactImageDataKey]
        dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0)){
            
        do {
            /////let contactStore = AppDelegate.getAppDelegate().contactStore
            
             try contactStore.enumerateContactsWithFetchRequest(CNContactFetchRequest(keysToFetch: keys)) { (contact, pointer) -> Void in
                
                print("appending to contacts")
                self.syncContactsList.append(contact)
                
                print("contactsListSync appended count is \(self.syncContactsList.count)")
                print("inside contacts filling for loop count is \(self.syncContactsList.count)")
                
                if (contact.isKeyAvailable(CNContactPhoneNumbersKey)) {
                    for phoneNumber:CNLabeledValue in contact.phoneNumbers {
                        let a = phoneNumber.value as! CNPhoneNumber
                        //////////////emails.append(a.valueForKey("digits") as! String)
                        var zeroIndex = -1
                        var phoneDigits=a.valueForKey("digits") as! String
                        var actualphonedigits=a.valueForKey("digits") as! String
                        //remove leading zeroes
                        /* for index in phoneDigits.characters.indices {
                         print(phoneDigits[index])
                         if(phoneDigits[index]=="0")
                         {
                         zeroIndex=index as! Int
                         //phoneDigits.characters.popFirst() as! String
                         print(".. droping zero \(phoneDigits) index \(zeroIndex)")
                         }
                         else
                         {
                         if(zeroIndex != -1)
                         {
                         let rangeOfTLD = Range(start: phoneDigits.startIndex.advancedBy(zeroIndex),
                         end: phoneDigits.endIndex)
                         phoneDigits = phoneDigits[rangeOfTLD] // "com"
                         print("range is \(phoneDigits)")
                         }
                         break
                         }
                         
                         }*/
                        for(var i=0;i<phoneDigits.characters.count;i++)
                        {
                            if(phoneDigits.characters.first=="0")
                            {
                                phoneDigits.removeAtIndex(phoneDigits.startIndex)
                                //phoneDigits.characters.popFirst() as! String
                                print(".. droping zero \(phoneDigits)")
                            }
                            else
                            {
                                break
                            }
                        }
                        do{
                            
                            
                            //get countrycode from db
                            
                            let country_prefix = Expression<String>("country_prefix")
                            
                            
                            if(countrycode == nil)
                            {
                                let tbl_accounts = sqliteDB.accounts
                                do{for account in try sqliteDB.db.prepare(tbl_accounts) {
                                    countrycode=account[country_prefix]
                                    //displayname=account[firstname]
                                    
                                    }
                                }
                            }
                            if(countrycode=="1" && phoneDigits.characters.first=="1" && phoneDigits.characters.first != "+")
                            {
                                phoneDigits = "+"+phoneDigits
                            }
                            else if(phoneDigits.characters.first != "+"){
                                phoneDigits = "+"+countrycode+phoneDigits
                                print("appended phone is \(phoneDigits)")
                            }
                            
                            self.syncPhonesList.append(phoneDigits)
                        }
                        catch{
                            print("error..")
                            //////   completion(result:false)
                        }
                        
                        /////// completion(result:true)
                    }
                }
    
            }
            
            dispatch_async(dispatch_get_main_queue())
            {
                completion(result: true)
            }
            
        }catch{
            dispatch_async(dispatch_get_main_queue())
            {
                print("error 1..")
                completion(result: false)
            }
        }
        }
    }
    
    func SyncFillContactsTableWithRecords(completion:(result:Bool)->())
    {
        
        
        let tbl_allcontacts=sqliteDB.allcontacts
        
        //deleting all records
        do
        {
            print("synccccc deleting records of contacts table")
            // --==== newww  try sqliteDB.db.run(tbl_allcontacts.delete())
            // =====---- newww print("now count is \(sqliteDB.db.scalar(tbl_allcontacts.count))")
            var contactsdata=[[String:String]]()
            dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0)){
                
            for(var i=0;i<self.syncContactsList.count;i++)
            {
                
                do{
                    /////// uniqueidentifierList.append(contact.identifier)
                    if(try self.syncContactsList[i].givenName != "")
                    {
                        /////////nameList.append(contact.givenName+" "+contact.familyName)
                        print(self.syncContactsList[i].givenName)
                        
                    }
                    
                    
                }
                catch(let error)
                {
                    print("error: \(error)")
                    socketObj.socket.emit("logClient", "error in fetching contact name: \(error)")
                }
                do{
                    
                    var uniqueidentifier1=self.syncContactsList[i].identifier
                    var image=NSData()
                    var fullname=self.syncContactsList[i].givenName+" "+self.syncContactsList[i].familyName
                    if (self.syncContactsList[i].isKeyAvailable(CNContactPhoneNumbersKey)) {
                        for phoneNumber:CNLabeledValue in self.syncContactsList[i].phoneNumbers {
                            let a = phoneNumber.value as! CNPhoneNumber
                            //////////////emails.append(a.valueForKey("digits") as! String)
                            var zeroIndex = -1
                            var phoneDigits=a.valueForKey("digits") as! String
                            var actualphonedigits=a.valueForKey("digits") as! String
                            //remove leading zeroes
                            /* for index in phoneDigits.characters.indices {
                             print(phoneDigits[index])
                             if(phoneDigits[index]=="0")
                             {
                             zeroIndex=index as! Int
                             //phoneDigits.characters.popFirst() as! String
                             print(".. droping zero \(phoneDigits) index \(zeroIndex)")
                             }
                             else
                             {
                             if(zeroIndex != -1)
                             {
                             let rangeOfTLD = Range(start: phoneDigits.startIndex.advancedBy(zeroIndex),
                             end: phoneDigits.endIndex)
                             phoneDigits = phoneDigits[rangeOfTLD] // "com"
                             print("range is \(phoneDigits)")
                             }
                             break
                             }
                             
                             }*/
                            for(var i=0;i<phoneDigits.characters.count;i++)
                            {
                                if(phoneDigits.characters.first=="0")
                                {
                                    phoneDigits.removeAtIndex(phoneDigits.startIndex)
                                    //phoneDigits.characters.popFirst() as! String
                                    print(".. droping zero \(phoneDigits)")
                                }
                                else
                                {
                                    break
                                }
                            }
                            do{
                                
                                
                                //get countrycode from db
                                
                                let country_prefix = Expression<String>("country_prefix")
                                
                                
                                if(countrycode == nil)
                                {
                                    let tbl_accounts = sqliteDB.accounts
                                    do{for account in try sqliteDB.db.prepare(tbl_accounts) {
                                        countrycode=account[country_prefix]
                                        //displayname=account[firstname]
                                        
                                        }
                                    }
                                }
                                if(countrycode=="1" && phoneDigits.characters.first=="1" && phoneDigits.characters.first != "+")
                                {
                                    phoneDigits = "+"+phoneDigits
                                }
                                else if(phoneDigits.characters.first != "+"){
                                    phoneDigits = "+"+countrycode+phoneDigits
                                    print("appended phone is \(phoneDigits)")
                                }
                                
                                //////===========
                                // =============emails.append(phoneDigits)
                                var emailAddress=""
                                let em = try self.syncContactsList[i].emailAddresses.first
                                if(em != nil && em != "")
                                {
                                    print(em?.label)
                                    print(em?.value)
                                    emailAddress=(em?.value)! as! String
                                    print("email adress value iss \(emailAddress)")
                                    /////emails.append(em!.value as! String)
                                }
                                if(self.syncContactsList[i].imageDataAvailable==true)
                                {
                                    image=self.syncContactsList[i].imageData!
                                }
                                print("trying to save \(fullname) and uniqueidentifier is \(uniqueidentifier1)")
                                
                                var data=[String:String]()
                                data["name"]=fullname
                                data["phone"]=phoneDigits
                                data["actualphone"]=actualphonedigits
                                data["email"]=emailAddress
                                data["uniqueidentifier"]=uniqueidentifier1
                                
                                
                                contactsdata.append(data)
                                //==== --- new commented moved down try sqliteDB.db.run(tbl_allcontacts.insert(name<-fullname,phone<-phoneDigits,actualphone<-actualphonedigits,email<-emailAddress,uniqueidentifier<-uniqueidentifier1))
                            }
                            catch(let error)
                            {
                                print("errorr in reading in name : \(error)")
                                
                                ///////socketObj.socket.emit("logClient","IPHONE-LOG: iphoneLog: error is getting name \(error)")
                            }
                        }
                    }
                    
                    
                    /*if let phone = try contacts[i].phoneNumbers.first?.value as! CNPhoneNumber!
                     {
                     if( phone != "")
                     {
                     emails.append(phone.stringValue)
                     print(phone.stringValue)
                     }
                     }*/
                    
                }
                
                
                /*if( phone != ""  && phone != nil)
                 {
                 phonesList.append(phone.stringValue)
                 print(phone.stringValue)
                 }*/
                
                
                //print(self.contacts[i].emailAddresses.first!.value)
                ////self.emails.append(phone.stringValue)
                // print(self.emails[i])
                
                ///////
                
                //  }
                
            }
            
            //delete table data====
            do{
                try sqliteDB.db.run(tbl_allcontacts.delete())
                // print("now count is \(sqliteDB.db.scalar(tbl_allcontacts.count))")
                
                for(var j=0;j<contactsdata.count;j++)
                {
                    do{
                        try sqliteDB.db.run(tbl_allcontacts.insert(self.name<-contactsdata[j]["name"]!,self.phone<-contactsdata[j]["phone"]!,self.actualphone<-contactsdata[j]["actualphone"]!,self.email<-contactsdata[j]["email"]!,self.uniqueidentifier<-contactsdata[j]["uniqueidentifier"]!))
                    }
                    catch(let error)
                    {
                        print("error in inserting contact : \(error)")
                        ///////socketObj.socket.emit("logClient","IPHONE-LOG: iphoneLog: error is getting name \(error)")
                    }
                }
                dispatch_async(dispatch_get_main_queue())
                {
                    completion(result:true)
                }
            }
            catch(let error)
            {
                print("error in deleting data of contacts table")
                ///////socketObj.socket.emit("logClient","IPHONE-LOG: iphoneLog: error is getting name \(error)")
            }
            }
            
        }
        catch
        {
            print("synccccc error in deleting allcontacts table")
            socketObj.socket.emit("logClient","IPHONE-LOG: iphoneLog: error in deleting allcontacts data \(error)")
        }
        dispatch_async(dispatch_get_main_queue())
        {
            completion(result:true)
        }
    }
    
    
    
    func fetchContactsFromDevice(completion: (result:Bool)->())
    {
       // self.strLabel.text="Setting Contacts Step 1/4"
                    contactsList.fetch(){ (result) -> () in
                        print("got contacts from device")
                        if(socketObj != nil)
                        {
                        socketObj.socket.emit("logClient", "done fetched contacts from iphone")
                        }
                        for r in result
                        {
                            //get phones and append phones in list
                            emailList.append(r)
                        }
                        completion(result: true)
            }
    }
    
    
    
    func SyncSendPhoneNumbersToServer(phones:[String],completion: (result:Bool)->())
    {
        // phones=phones.description.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        
        print("phones are are \(phones)")
        socketObj.socket.emit("logClient","IPHONE-LOG: sending phone numbers to server")
        // %%%%%%%%%%%%%%%%%% new phone model change
        let searchContactsByPhones=Constants.MainUrl+Constants.searchContactsByPhone
        //let searchContactsByEmail=Constants.MainUrl+Constants.searchContactsByEmail+"?access_token="+AuthToken!
        //var s:[String]!
        //var ss:String="["
        for e in phones{
            //ss.appendContentsOf(e)
            print("phones sending to server are \(e)")
            
        }
        
        //var ssss=phones.debugDescription.stringByReplacingOccurrencesOfString("\\", withString: " ")
        //var phonesCorrentFormat=phones.debugDescription.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        //var phonesCorrentFormat=phones.debugDescription.stringByReplacingOccurrencesOfString(" ", withString: "")
        var phonesCorrentFormat=phones.debugDescription.stringByReplacingOccurrencesOfString(" ", withString: "")
        
        print(phonesCorrentFormat)
        // print(ssss)
        //ss.appendContentsOf("]")
        //emails.description.propertyList()
        //var emailParas=JSON(emails).object
        //dispatch_async(dispatch_get_main_queue(), { () -> Void in
        
        //%%%%%%%%%%%%%%% new phone model change
        //Alamofire.request(.POST,searchContactsByEmail,parameters:["emails":emails],encoding: .JSON).responseJSON { response in
        Alamofire.request(.POST,searchContactsByPhones,headers:header,parameters:["phonenumbers":phones],encoding: .JSON).responseJSON { response in
            
            if(response.response?.statusCode==200)
            {socketObj.socket.emit("logClient","IPHONE-LOG: success in getting available and not available contacts")
                
                dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0))
                {
                debugPrint(response.data)
                //print(response.request)
                //print(response.response)
                print(response.data)
                //print(response.e
                
                //************* error here...........................
                print(response.result.value!)
                var res=JSON(response.result.value!)
                //print(res)
                ////////////////var availableContactsEmails=res["available"].object
                var availableContactsPhones=res["available"]
                print("available contacts are \(availableContactsPhones.debugDescription)")
                var notAvailablePhonesArrayReturned=res["notAvailable"].array
                for var i=0;i<notAvailablePhonesArrayReturned!.count;i++
                {
                    // self.notAvailableContacts[i]=NotavailableContactsEmails![i].rawString()!
                    self.syncNotAvailablePhonesList.append(notAvailablePhonesArrayReturned![i].debugDescription)
                    ////////// print("----------- \(self.notAvailableContacts[i].debugDescription)")
                }
                
                for var i=0;i<availableContactsPhones.count;i++
                {
                    // self.notAvailableContacts[i]=NotavailableContactsEmails![i].rawString()!
                    
                    
                    self.syncAvailablePhonesList.append(availableContactsPhones[i].debugDescription)
                    
                    
                    // print("----------- \(self.notAvailableContacts[i].debugDescription)")
                }
                
                
                //print(NotavailableContactsEmails!)
                //////   print("**************** \(self.notAvailableContacts)")
                
                dispatch_async(dispatch_get_main_queue())
                {
                    completion(result: true)
                }
                
                /* if(self.delegate != nil)
                 {
                 self.delegate?.receivedContactsUpdateUI()
                 }*/
                }
            }
            else
            {
                dispatch_async(dispatch_get_main_queue())
                {
                    socketObj.socket.emit("logClient","IPHONE-LOG: error: \(response.debugDescription)")
                    completion(result: false)
                }
            }
            
        }
        
        
        // })
    }
    
    
    func sendPhoneNumbersToServer(completion: (result:Bool)->())
    {
        contactsList.searchContactsByPhone(emailList)
            { (result2) -> () in
                if(socketObj != nil)
                {
                socketObj.socket.emit("logClient", "received contacts from cloudkibo server")
                }
                for r2 in result2
                {
                    notAvailableEmails.append(r2)
                    
                }
                
                completion(result: true)
            }
        
    }
    
    
    
    func fetchContactsFromServer(completion:(result:Bool)->()){
     //   self.strLabel.text="Setting Contacts Step 3/4"
        print("Server fetchingg contactss", terminator: "")
        if(socketObj != nil)
        {
        socketObj.socket.emit("logClient","IPHONE-LOG: fetch contacts from server")
        }
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
                    if(socketObj != nil)
                    {socketObj.socket.emit("logClient","IPHONE-LOG:  successfully received friends list from server")
                    }
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
                    if(socketObj != nil)
                    {
                    socketObj.socket.emit("logClient", "error: \(error1!.localizedDescription)")
                    }
                    print(error1)
                    print(response1?.statusCode)
                    print("FETCH CONTACTS FAILED")
                    print("eeeeeeeeeeeeeeeeeeeeee")
                    
                }
                if(response1?.statusCode==401)
                {
                    if(socketObj != nil)
                    {
                    socketObj.socket.emit("logClient", "error: \(error1!.localizedDescription)")
                    }
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
    { //self.strLabel.text="Setting Contacts Step 4/4"
        if(socketObj != nil)
        {
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
                    loggedUserObj=json
                    KeychainWrapper.setString(loggedUserObj.description, forKey:"loggedUserObjString")
                    var loggedobjstring=KeychainWrapper.stringForKey("loggedUserObjString")
                    
                    if(socketObj != nil)
                    {
                    socketObj.socket.emit("logClient","IPHONE-LOG: keychain of loggedUserObjString is \(loggedobjstring)")
                    }
                        
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
                    
                    
                    if(socketObj != nil)
                    {
                        socketObj.socket.emit("logClient","IPHONE-LOG: \(username!) is joining room room:globalchatroom, user: \(json.object)")
                        socketObj.socket.emit("join global chatroom",["room": "globalchatroom", "user": json.object])
                    }
                        print(json["_id"])
                        
                        
                        
                        let tbl_accounts = sqliteDB.accounts
                        
                        do{
                            
                            try sqliteDB.db.run(tbl_accounts.delete())
                        }catch{
                            if(socketObj != nil)
                            {
                            socketObj.socket.emit("logClient","accounts table not deleted")
                            print("accounts table not deleted \(error)")
                            }
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
                        
                        
                       //=== uncomment later tbl_accounts.delete()
                        
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
                           print("error \(error)")
                        }
                    }
            case .Failure:
                if(socketObj != nil)
                {
                socketObj.socket.emit("logClient", "\(username!) failed to get its data")
                }
            }
        }
    }
    
    
    func fetchChatsFromServer(completion: (result:Bool)->())
    {
        
        //%%%%%% fetch chat
        
        //dispatch_async(dispatch_get_global_queue(priority, 0)) {
            //self.progressBarDisplayer("Setting Conversations", true)
        if(socketObj != nil)
        {
            socketObj.socket.emit("logClient","\(username) is Fetching chat")
        }
        
        //var fetchChatURL=Constants.MainUrl+Constants.partialSync

        
        //===
        //changing sync logic
        //===
        
           var fetchChatURL=Constants.MainUrl+Constants.fetchMyAllchats
            //var getUserDataURL=userDataUrl
        
       // dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            Alamofire.request(.POST,"\(fetchChatURL)",headers:header,parameters:["user1":username!]).validate(statusCode: 200..<300).responseJSON{response in
                
                
                
                let to = Expression<String>("to")
                let from = Expression<Bool>("from")
                let name = Expression<String?>("name")

                
                switch response.result {
                case .Success:
                    
                    if(socketObj != nil)
                    {
                    socketObj.socket.emit("logClient", "All chat fetched success")
                    }
                    if let data1 = response.result.value {
                        let UserchatJson = JSON(data1)
                        print("chat fetched JSON: \(UserchatJson)")
                        
                        var tableUserChatSQLite=sqliteDB.userschats
                        
                        do{
                            try sqliteDB.db.run(tableUserChatSQLite.delete())
                        }catch{
                            if(socketObj != nil)
                            {
                            socketObj.socket.emit("logClient","sqlite chat table refreshed")
                            }
                            print("chat table not deleted")
                        }
                        
                        //Overwrite sqlite db
                        //sqliteDB.deleteChat(self.selectedContact)
                        if(socketObj != nil)
                        {
                        socketObj.socket.emit("logClient","IPHONE-LOG: all chat messages count is \(UserchatJson["msg"].count)")
                        }
                        for var i=0;i<UserchatJson["msg"].count
                            ;i++
                        {
                            //UserchatJson["msg"][i]["date"].string!
                            
                           // var labelll=self.messageFrame.subviews.first as! UILabel
                            //self.strLabel.text="Setting Chats \(UserchatJson["msg"].count/i*100)% ..."
                            let dateFormatter = NSDateFormatter()
                            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                            let datens2 = dateFormatter.dateFromString(UserchatJson["msg"][i]["date"].string!)
                           
                            print("fetch all date from server in installation got is \(UserchatJson["msg"][i]["date"].string!)... converted is \(datens2.debugDescription)")
                            
                            /*let formatter = NSDateFormatter()
                            formatter.dateFormat = "MM/dd hh:mm a"";
                            //formatter.dateStyle = NSDateFormatterStyle.ShortStyle
                            //formatter.timeStyle = .ShortStyle
                            
                            let dateString = formatter.stringFromDate(datens2!)
                            */
                            
                            
                            if(UserchatJson["msg"][i]["uniqueid"].isExists())
                            {
                                if(UserchatJson["msg"][i]["to"].string! == username! && UserchatJson["msg"][i]["status"].string!=="sent")
                                {
                                    var updatedStatus="delivered"
                                    
                                    ///sqliteDB.SaveChat(<#T##to1: String##String#>, from1: <#T##String#>, owneruser1: <#T##String#>, fromFullName1: <#T##String#>, msg1: <#T##String#>, date1: <#T##String!#>, uniqueid1: <#T##String!#>, status1: <#T##String#>, type1: <#T##String#>, file_type1: <#T##String#>, file_path1: <#T##String#>)
                                    
                                    
                                    //===
                                    
                                    //====
                                    
                                    
                                    let dateFormatter = NSDateFormatter()
                                    dateFormatter.timeZone=NSTimeZone.localTimeZone()
                                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                                    //  let datens2 = dateFormatter.dateFromString(date2.debugDescription)
                                    //2016-09-18T19:13:00.588Z
                                    let datens2 = dateFormatter.dateFromString(UserchatJson["msg"][i]["date"].string!)
                                    
                                    
                                    
                                    print("===fetch chat inside displayname full fetch chat got date as \(UserchatJson["msg"][i]["date"].string!) .. date .... converted NSDate is \(datens2!)")
                                    

                                    
                                    
                                    //UserchatJson["msg"][i]["uniqueid"].string!
                                    //chatJson[0]["from"].string!
                                    
                                    /*
                                    let formatter = NSDateFormatter()
                                    formatter.dateStyle = NSDateFormatterStyle.ShortStyle
                                    formatter.timeStyle = .ShortStyle
                                    
                                    let dateString = formatter.stringFromDate(datens2!)
                                    print("dateeeeeee \(dateString)")
                                    */
                                    
                                    sqliteDB.SaveChat(UserchatJson["msg"][i]["to"].string!, from1: UserchatJson["msg"][i]["from"].string!,owneruser1:UserchatJson["msg"][i]["owneruser"].string! , fromFullName1: UserchatJson["msg"][i]["fromFullName"].string!, msg1: UserchatJson["msg"][i]["msg"].string!,date1:datens2,uniqueid1:UserchatJson["msg"][i]["uniqueid"].string!,status1: updatedStatus, type1: "", file_type1: "",file_path1: "")
                                    
                                    //socketObj.socket.emit("messageStatusUpdate",["status":"","iniqueid":"","sender":""])
                                   // if(socketObj != nil)
                                    //{
                                    
                                    
                                    managerFile.sendChatStatusUpdateMessage(UserchatJson["msg"][i]["uniqueid"].string!, status: updatedStatus, sender: UserchatJson["msg"][i]["from"].string!)
                                    //OLD SOCKET LOGIC, NO UPDATE CHANGED COZ TABLE IS NEW
                                    /*
                                    socketObj.socket.emitWithAck("messageStatusUpdate", ["status":updatedStatus,"uniqueid":UserchatJson["msg"][i]["uniqueid"].string!,"sender": UserchatJson["msg"][i]["from"].string!])(timeoutAfter: 0){data in
                                        var chatmsg=JSON(data)
                                        print(data[0])
                                        print(chatmsg[0])
                                        print("chat status emitted")
                                        socketObj.socket.emit("logClient","\(username) chat status emitted")
 
 *?
                                    //}
                                    }*/
                                    
                                    
                                }
                                else
                                {
                                    
                                    sqliteDB.SaveChat(UserchatJson["msg"][i]["to"].string!, from1: UserchatJson["msg"][i]["from"].string!,owneruser1:UserchatJson["msg"][i]["owneruser"].string! , fromFullName1: UserchatJson["msg"][i]["fromFullName"].string!, msg1: UserchatJson["msg"][i]["msg"].string!,date1:datens2,uniqueid1:UserchatJson["msg"][i]["uniqueid"].string!,status1: UserchatJson["msg"][i]["status"].string!, type1: "", file_type1: "",file_path1: "" )
                                }
                            }
                            else
                            {
                                sqliteDB.SaveChat(UserchatJson["msg"][i]["to"].string!, from1: UserchatJson["msg"][i]["from"].string!,owneruser1:UserchatJson["msg"][i]["owneruser"].string! , fromFullName1: UserchatJson["msg"][i]["fromFullName"].string!, msg1: UserchatJson["msg"][i]["msg"].string!,date1:datens2,uniqueid1:"",status1: "", type1: "", file_type1: "",file_path1: "" )
                            }
                            
                            
                        }
                        //dispatch_async(dispatch_get_main_queue()) {
                        return completion(result: true)
                        //}
                        /* dispatch_async(dispatch_get_main_queue()) {
                        self.messageFrame2.removeFromSuperview()
                        }
                        */
                        
                        
                    }
                    /*dispatch_async(dispatch_get_main_queue()) {
                    
                    }*/
                    
                case .Failure:
                    if(socketObj != nil)
                    { socketObj.socket.emit("logClient", "All chat fetched failed")
                    }
                    print("all chat fetched failed")
                }
            }
      //  }
       // }
        
    }
   
    func goToContactsPage(completion: (result:Bool)->())
    {
        
    }
    
    @IBAction func btnDonePressed(sender: AnyObject) {
        print("button done pressed start time \(NSDate())")
        var displayName="unknown"
        displayName=txtDisplayName.text!
       // appJustInstalled=[true]
        if(accountKit!.currentAccessToken != nil)
        {
        header=["kibo-token":accountKit!.currentAccessToken!.tokenString]
        }
        displayname=displayName
        progressBarDisplayer("Contacting Server", true)
        dispatch_sync(Q0_sendDisplayName,
            {
                self.sendNameToServer(displayName){ (result) -> () in
                /*dispatch_async(dispatch_get_main_queue())
                    {
                    
                }*/
                    self.messageFrame.removeFromSuperview()
                    print("setting contacts start time \(NSDate())")
                    self.progressBarDisplayer("Setting Contacts Step 1/4", true)
                    dispatch_sync(self.Q1_fetchFromDevice,
                        {//self.strLabel.text="Setting Contacts Step 2/4"
                            //self.fetchContactsFromDevice({ (result) -> () in
                              //SyncfetchContacts
                            self.SyncfetchContacts({ (result) -> () in
                                
                                self.messageFrame.removeFromSuperview()
                                print("setting contacts start time \(NSDate())")
                                self.progressBarDisplayer("Setting Contacts Step 2/4", true)
                                dispatch_sync(self.Q2_sendPhonesToServer,
                                    {//self.strLabel.text="Setting Contacts Step 2/4"
                                       //====----- self.sendPhoneNumbersToServer({ (result) -> () in
                                            self.SyncSendPhoneNumbersToServer(self.syncPhonesList, completion: { (result) in
                                            self.messageFrame.removeFromSuperview()
                                            print("setting contacts start time \(NSDate())")
                                            self.progressBarDisplayer("Setting Contacts Step 3/4", true)
                                            dispatch_sync(self.Q3_getContactsFromServer,
                                                {
                                                    self.SyncFillContactsTableWithRecords({ (result) in
                                                        
                                                        dispatch_sync(self.Q6_updateIsKiboStatus,
                                                            {
                                                        self.updateKiboContactsStatus({ (result) in
                                                            
                                                            
                                                        /*var allcontactslist1=sqliteDB.allcontacts
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
                                                        }*/
                                                        
                                                        dispatch_sync(self.Q4_getUserData,
                                                            {
                                                                self.messageFrame.removeFromSuperview()
                                                                print("setting contacts start time \(NSDate())")
                                                                self.progressBarDisplayer("Setting Contacts Step 4/4", true)
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
                                                                    
                                                                    print("setting contacts finish time \(NSDate())")
                                                                self.messageFrame.removeFromSuperview()
                                                                self.progressBarDisplayer("Setting Chats", true)
                                                                dispatch_sync(self.Q5_fetchAllChats,
                                                                {
                                                                self.fetchChatsFromServer({ (result) -> () in
                                                                    
                                                                   // dispatch_async(dispatch_get_main_queue())
                                                                       // {
                                                                            self.messageFrame.removeFromSuperview()
                                                                            self.progressBarDisplayer("Setting Groups", true)
                                                                            dispatch_sync(self.newserialqueue,
                                                                                {
                                                                                    var syncGroupsObj=syncGroupService.init()
                                                                                    //==uncomment latersyncGroupsObj.startSyncGroupsService({ (result) -> () in
                                                                                    dispatch_sync(self.Q5_fetchAllGroupsData,
                                                                                        {
                                                                                    syncGroupsObj.startSyncGroupsServiceOnLaunch({ (result) -> () in
                                                                                    //result
                                                                                        print("sync on installation is completed. going to chat screen")
                                                                                    dispatch_async(dispatch_get_main_queue())
                                                                                    {
                                                                                        self.messageFrame.removeFromSuperview()
                                                                                        print("completed done time \(NSDate())")
                                                                            self.dismissViewControllerAnimated(false, completion: { () -> Void in
                                                                                
                                                                                print("logged in going to contactlist")
                                                                            })
                                                                                        
                                                                                        }
                                                                                        
                                                                    //}
                                                                                    })
                                                                                    })
                                                                            })
                                                                   // }
                                                                })
                                                        })
                                                    })
                                                        
                                                })
                                                 //
                                                    })
                                                        })})
                                            
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
        var joinquery=allcontacts.join(.LeftOuter, contactslists, on: contactslists[phone] == allcontacts[phone])
        
        do{for joinresult in try sqliteDB.db.prepare(joinquery) {
            if(joinresult[uniqueidentifier].isEmpty){}
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
    
    func updateKiboContactsStatus(completion: (result:Bool)->())
    {
        
        var allcontactslist1=sqliteDB.allcontacts
        var alladdressContactsArray:Array<Row>
        
        let phone = Expression<String>("phone")
        let kibocontact = Expression<Bool>("kiboContact")
        let name = Expression<String?>("name")
        
        //alladdressContactsArray = Array(try sqliteDB.db.prepare(allcontactslist1))
        
        dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0))
        {
            var joinrows=self.leftJoinContactsTables()
            
            do{
                for ccc in joinrows {
                    
                    for var i=0;i<availableEmailsList.count;i++
                    {print(":::email .......  : \(availableEmailsList[i])")
                        
                        if(ccc.get(allcontactslist1[phone])==availableEmailsList[i])
                        { print(":::::::: \(ccc.get(allcontactslist1[phone]))  and emaillist : \(availableEmailsList[i])")
                            //ccc[kibocontact]
                            
                            let query = allcontactslist1.select(kibocontact)           // SELECT "email" FROM "users"
                                .filter(phone == ccc.get(allcontactslist1[phone]))     // WHERE "name" IS NOT NULL
                            
                            do{try sqliteDB.db.run(query.update(kibocontact <- true))}
                            catch{
                                print("error in join query \(error)")
                            }
                            
                            // for kk in try sqliteDB.db.prepare(query) {
                            //  try sqliteDB.db.run(query.update(kk[kibocontact] <- true))
                            //}
                            //try sqliteDB.db.run(allcontactslist1.update(query[kibocontact] <- true))
                            
                            // try sqliteDB.db.run(allcontactslist1.update(ccc[kibocontact] <- true))
                        }
                        
                    }
                    
                }
                
                dispatch_async(dispatch_get_main_queue())
                {
                    return completion(result:true)
                }
                
                
            }
            catch{
                print("error updating kibo status")
            }
        }
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
