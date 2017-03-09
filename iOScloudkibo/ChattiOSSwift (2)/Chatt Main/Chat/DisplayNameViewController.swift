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
    
    @IBOutlet weak var lbl_progress: UILabel!
    
    @IBOutlet weak var lbl_version: UILabel!
    var Q0_sendDisplayName=DispatchQueue(label: "Q0_sendDisplayName",attributes: [])
    var Q1_fetchFromDevice=DispatchQueue(label: "fetchFromDevice",attributes: [])
    var Q2_sendPhonesToServer=DispatchQueue(label: "sendPhonesToServer",attributes: [])
    var Q3_getContactsFromServer=DispatchQueue(label: "getContactsFromServer",attributes: [])
    var Q4_getUserData=DispatchQueue(label: "getUserData",attributes: [])
    var Q5_fetchAllChats=DispatchQueue(label: "fetchAllChats",attributes: [])
    var Q5_fetchAllGroupsData=DispatchQueue(label: "fetchAllGroupsData",attributes: [])
    var Q6_updateIsKiboStatus=DispatchQueue(label: "updateIsKiboStatus",attributes: [])
    var newserialqueue=DispatchQueue(label: "newserialqueue",attributes: [])
    var Q_fetchAllfriends=DispatchQueue(label: "fetchAllFriends",attributes: [])
    
    
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
        
        print("appearrrrrr", terminator: "")
        
      
        let nsObject: AnyObject? = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as AnyObject?
        if let text = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
            print("... \(text)") //build number
        }
        print(",,,,, \(nsObject!.description)") //version number
        
        self.lbl_version.text="\(nsObject!.description)"
        if(self.accountKit == nil){
            self.accountKit = AKFAccountKit(responseType: AKFResponseType.accessToken)
        }
        
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
                    //CountryCode=account?.phoneNumber?.countryCode
                    
                }
                
            }}
        
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func progressBarDisplayer(_ msg:String, _ indicator:Bool ) {
        print(msg)
        strLabel = UILabel(frame: CGRect(x: 50, y: 0, width: 270, height: 50))
        strLabel.text = msg
        strLabel.textColor = UIColor.white
        messageFrame = UIView(frame: CGRect(x: view.frame.midX - 110, y: view.frame.midY - 25 , width: 250, height: 50))
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
    
    
    
    func sendNameToServer(_ displayName:String,completion:@escaping (_ result:Bool)->())
    {
        var displayName = displayName
       // progressBarDisplayer("Contacting Server", true)
        //let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        
        //dispatch_async(dispatch_get_global_queue(priority, 0)) {
            // do some task start to show progress wheel
            
            var urlToSendDisplayName=Constants.MainUrl+Constants.firstTimeLogin
            var nn="{display_name:displayName}"
            //var getUserDataURL=userDataUrl
        
        
        Alamofire.request("\(urlToSendDisplayName)", method: .post, parameters: ["display_name":displayName],headers:header).responseJSON { response in
      
            
            //alamofire4
            /*
            Alamofire.request(.POST,"\(urlToSendDisplayName)",headers:header,parameters:["display_name":displayName]).responseJSON{
                response in
                */
                
                    print(response.data?.debugDescription)
                    
                    print("display name is \(displayName)")
                    /*Alamofire.request(.GET,"\(urlToSendDisplayName)",headers:header,parameters:["display_name":"\(displayName)"]).validate(statusCode: 200..<300).responseJSON{response in
                */
                
                    switch response.result {
                        
                        
                        
                    case .success(let value):
                        print("display name sent to server")
                        firstTimeLogin=false
                        if(socketObj != nil)
                        {
                        socketObj.socket.emit("logClient", "display name \(displayName) sent to server successfully")
                        }
                        return completion(true)
                        //////// %%%%%%%%%%%%%%***************self.performSegueWithIdentifier("fetchContactsSegue", sender: self)
                        //self.performSegueWithIdentifier("fetchaddressbooksegue", sender: self)
                        //*********************%%%%%%%%%%%%%%%%%%%%%%%%% commented new
                        
                        //%%%%%%%%%%%%%%%% new logic commented -------------
                        /*
                        DispatchQueue.main.async {
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
                        
                        /*self.dismiss(false, completion: { () -> Void in
                            
                            print("logged in going to contactlist")
                        })*/
                        
                        
                        //self.performSegueWithIdentifier(<#T##identifier: String##String#>, sender: <#T##AnyObject?#>)
                        
                    case .failure(let error):
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
    func SyncfetchContacts(_ completion:@escaping (_ result:Bool)->())
    {
        let contactStore = CNContactStore()
        
        var keys = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactEmailAddressesKey, CNContactPhoneNumbersKey, CNContactImageDataAvailableKey,CNContactThumbnailImageDataKey, CNContactImageDataKey]
        DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.default).sync{
            
        do {
            /////let contactStore = AppDelegate.getAppDelegate().contactStore
            var counter=1
             try contactStore.enumerateContacts(with: CNContactFetchRequest(keysToFetch: keys as [CNKeyDescriptor])) { (contact, pointer) -> Void in
                
                
                
                print("appending to contacts")
                self.syncContactsList.append(contact)
                
                print("contactsListSync appended count is \(self.syncContactsList.count)")
              //  DispatchQueue.main.async
//{
                self.lbl_progress.text="Setting Contact \(self.syncContactsList.count)"
//}
                print("inside contacts filling for loop count is \(self.syncContactsList.count)")
               // DispatchQueue.main.async
                //{
                    
                  //  self.messageFrame.removeFromSuperview()
                   // print("setting contacts start time \(NSDate())")
                   // self.progressBarDisplayer("Setting Contacts \(counter)", true)
                //}
                if (contact.isKeyAvailable(CNContactPhoneNumbersKey)) {
                    for phoneNumber:CNLabeledValue in contact.phoneNumbers {
                        let a = phoneNumber.value 
                        //////////////emails.append(a.valueForKey("digits") as! String)
                        var zeroIndex = -1
                        var phoneDigits=a.value(forKey: "digits") as! String
                        var actualphonedigits=a.value(forKey: "digits") as! String
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
                        for i in 0..<phoneDigits.characters.count
                        {
                            if(phoneDigits.characters.first=="0")
                            {
                                phoneDigits.remove(at: phoneDigits.startIndex)
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
                                do{for account in try sqliteDB.db.prepare(tbl_accounts!) {
                                    countrycode=account[country_prefix]
                                    //displayname=account[firstname]
                                    
                                    }
                                }
                            }
                            var logicalexpression=countrycode=="1" &&
                                phoneDigits.characters.first == Character.init("1") &&
                                phoneDigits.characters.first != Character.init("+")
                            
                            if logicalexpression
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
    counter=counter+1
                print("still working on contactsss...")
            }
            
            DispatchQueue.main.async
            {
                print("moving out...")
                completion(true)
            }
            
        }catch{
            DispatchQueue.main.async
            {
                print("error 1..")
                completion(false)
            }
        }
        }
    }
    
    func SyncFillContactsTableWithRecords(_ completion:@escaping (_ result:Bool)->())
    {
        
        
        let tbl_allcontacts=sqliteDB.allcontacts
        
        //deleting all records
        do
        {
            print("synccccc deleting records of contacts table")
            // --==== newww  try sqliteDB.db.run(tbl_allcontacts.delete())
            // =====---- newww print("now count is \(sqliteDB.db.scalar(tbl_allcontacts.count))")
            var contactsdata=[[String:String]]()
            DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.default).sync{
                
            for i in 0..<self.syncContactsList.count
            {
                self.lbl_progress.text="Updating Contact \(i)"
                
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
                    var image=Data()
                    var fullname=self.syncContactsList[i].givenName+" "+self.syncContactsList[i].familyName
                    if (self.syncContactsList[i].isKeyAvailable(CNContactPhoneNumbersKey)) {
                        for phoneNumber:CNLabeledValue in self.syncContactsList[i].phoneNumbers {
                            let a = phoneNumber.value 
                            //////////////emails.append(a.valueForKey("digits") as! String)
                            var zeroIndex = -1
                            var phoneDigits=a.value(forKey: "digits") as! String
                            var actualphonedigits=a.value(forKey: "digits") as! String
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
                            for i in 0 ..< phoneDigits.characters.count
                            {
                                if(phoneDigits.characters.first=="0")
                                {
                                    phoneDigits.remove(at: phoneDigits.startIndex)
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
                                    do{for account in try sqliteDB.db.prepare(tbl_accounts!) {
                                        countrycode=account[country_prefix]
                                        //displayname=account[firstname]
                                        
                                        }
                                    }
                                }
                                var logicalexpression=countrycode=="1" &&
                                    phoneDigits.characters.first == Character.init("1") &&
                                    phoneDigits.characters.first != Character.init("+")

                                
                                if logicalexpression
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
                                if let em = try self.syncContactsList[i].emailAddresses.first
                                {
                                
                                if((em.value as! String) != nil && (em.value as! String) != "")
                                {
                                    print(em.label)
                                    print(em.value)
                                    emailAddress=(em.value) as String
                                    print("email adress value iss \(emailAddress)")
                                    /////emails.append(em!.value as! String)
                                }
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
                try sqliteDB.db.run((tbl_allcontacts?.delete())!)
                // print("now count is \(sqliteDB.db.scalar(tbl_allcontacts.count))")
                
                for j in 0 ..< contactsdata.count
                {
                    do{
                        try sqliteDB.db.run((tbl_allcontacts?.insert(self.name<-contactsdata[j]["name"]!,self.phone<-contactsdata[j]["phone"]!,self.actualphone<-contactsdata[j]["actualphone"]!,self.email<-contactsdata[j]["email"]!,self.uniqueidentifier<-contactsdata[j]["uniqueidentifier"]!))!)
                    }
                    catch(let error)
                    {
                        print("error in inserting contact : \(error)")
                        ///////socketObj.socket.emit("logClient","IPHONE-LOG: iphoneLog: error is getting name \(error)")
                    }
                }
                DispatchQueue.main.async
                {
                    completion(true)
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
        DispatchQueue.main.async
        {
            completion(true)
        }
    }
    
    
    
    func fetchContactsFromDevice(_ completion: (_ result:Bool)->())
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
                        completion(true)
            }
    }
    
    
    
    func SyncSendPhoneNumbersToServer(_ phones:[String],completion: @escaping (_ result:Bool)->())
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
        var phonesCorrentFormat=phones.debugDescription.replacingOccurrences(of: " ", with: "")
        
        print(phonesCorrentFormat)
        // print(ssss)
        //ss.appendContentsOf("]")
        //emails.description.propertyList()
        //var emailParas=JSON(emails).object
        //dispatch_async(dispatch_get_main_queue(), { () -> Void in
        
        //%%%%%%%%%%%%%%% new phone model change
        //Alamofire.request(.POST,searchContactsByEmail,parameters:["emails":emails],encoding: .JSON).responseJSON { response in
        
       /* Alamofire.request(searchContactsByPhones,
                          method: .post,
                          parameters: ["phonenumbers":phones],
                          encoding: URLEncoding.default,
                          headers: header)
            .responseJSON(completionHandler: { (response) in
                // do something with the response
                print(response)
           // })
 
        */
        
     let request = Alamofire.request("\(searchContactsByPhones)", method: .post, parameters: ["phonenumbers":phones],encoding: JSONEncoding.init(), headers:header).responseJSON{ response in
            

         //alamofire4
       // Alamofire.request(.POST,searchContactsByPhones,headers:header,parameters:["phonenumbers":phones],encoding: .JSON).responseJSON { response in
            
            if(response.response?.statusCode==200)
            {socketObj.socket.emit("logClient","IPHONE-LOG: success in getting available and not available contacts")
                
                DispatchQueue.global().sync
                //global(DispatchQueue.GlobalQueuePriority.default,0).sync()
                {
                debugPrint("response.data \(response.data)")
                //print(response.request)
                //print(response.response)
                //print(response.data)
                //print(response.e
                
                //************* error here...........................
                //print("response.result.value! \(response.result.value!)")
              //  print(")response.result.value! \(response.result.value!)")
                    /////////var res=JSON(response.data!)
                    var res=JSON(response.result.value)
                print("res \(res)")
                ////////////////var availableContactsEmails=res["available"].object
                var availableContactsPhones=res["available"]
                print("available contacts are \(availableContactsPhones.debugDescription)")
                    
                var notAvailablePhonesArrayReturned=res["notAvailable"]
                    for i in 0..<notAvailablePhonesArrayReturned.count
                {
                    // self.notAvailableContacts[i]=NotavailableContactsEmails![i].rawString()!
            
                        self.syncNotAvailablePhonesList.append(notAvailablePhonesArrayReturned[i].string!)
                    ////////// print("----------- \(self.notAvailableContacts[i].debugDescription)")
                    }
                
                for var i in 0 ..< availableContactsPhones.count
                {
                    // self.notAvailableContacts[i]=NotavailableContactsEmails![i].rawString()!
                    
                    
                    self.syncAvailablePhonesList.append(availableContactsPhones[i].string!)
                    
                    
                    // print("----------- \(self.notAvailableContacts[i].debugDescription)")
                    }
                
                
                //print(NotavailableContactsEmails!)
                //////   print("**************** \(self.notAvailableContacts)")
                
                DispatchQueue.main.async
                {
                    completion(true)
                }
                
                /* if(self.delegate != nil)
                 {
                 self.delegate?.receivedContactsUpdateUI()
                 }*/
                }
            }
            else
            {
                DispatchQueue.main.async
                {
                    socketObj.socket.emit("logClient","IPHONE-LOG: error: \(response.error)")
                    completion(false)
                }
            }
            
        }
        
        
        // })
    }
    
    
    func sendPhoneNumbersToServer(_ completion: @escaping (_ result:Bool)->())
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
                
                completion(true)
            }
        
    }
    
    
    
    func fetchContactsFromServer(_ completion:@escaping (_ result:Bool)->()){
     //   self.strLabel.text="Setting Contacts Step 3/4"
        print("Server fetchingg contactss", terminator: "")
        if(socketObj != nil)
        {
        socketObj.socket.emit("logClient","IPHONE-LOG: fetch contacts from server")
        }
        
        /*if(loggedUserObj == JSON("[]"))
        {
        }
        */
        //%%%%% new phone model
        //var fetchChatURL=Constants.MainUrl+Constants.getContactsList+"?access_token="+AuthToken!
        
        var fetchChatURL=Constants.MainUrl+Constants.getContactsList
        
        print(fetchChatURL, terminator: "")
        
        //%%%%% new phone model
        //Alamofire.request(.GET,"\(fetchChatURL)").validate(statusCode: 200..<300)
        header=["kibo-token":self.accountKit!.currentAccessToken!.tokenString]
        print("header iss \(header)")
        
        let request = Alamofire.request("\(fetchChatURL)",headers:header).responseJSON { response1 in
          
            //alamofire4
       // Alamofire.request(.GET,"\(fetchChatURL)",headers:header).validate(statusCode: 200..<300).response { (request1, response1, data1, error1) in
                
                
                
                
                if response1.response?.statusCode==200 {
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
                    let contactsJsonObj = JSON(data: response1.data!)
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
                    do{try sqliteDB.db.run((tbl_contactslists?.delete())!)}catch{
                        print("contactslist table not deleted")
                    }
                    ////////////////
                    ///tbl_contactslists.delete() //complete refresh
                    ////////////////////////////////////////COUNTTTTTTT
                    print(sqliteDB.contactslists.count)
                    
                
                    
                    //////
                    for i in 0..<contactsJsonObj.count
                    {
                        print("inside for loop")
                        do {
                            if(contactsJsonObj[i]["contactid"]["username"].string != nil)
                            {
                                print("inside username hereeeeeee")
                                let rowid = try sqliteDB.db.run((tbl_contactslists?.insert(contactid<-contactsJsonObj[i]["contactid"]["_id"].string!,
                                                                                           detailsshared<-contactsJsonObj[i]["detailsshared"].string!,
                                                                                           
                                                                                           unreadMessage<-contactsJsonObj[i]["unreadMessage"].boolValue,
                                                                                           
                                                                                           userid<-contactsJsonObj[i]["userid"].string!,
                                                                                           firstname<-contactsJsonObj[i]["contactid"]["firstname"].string!,
                                                                                           lastname<-contactsJsonObj[i]["contactid"]["lastname"].string!,
                                                                                           email<-contactsJsonObj[i]["contactid"]["email"].string!,
                                                                                           phone<-contactsJsonObj[i]["contactid"]["phone"].string!,
                                                                                           username<-contactsJsonObj[i]["contactid"]["username"].string!,
                                                                                           status<-contactsJsonObj[i]["contactid"]["status"].string!))!
                                )
                                print("data inserttt")
                                
                                //=========this is done in fetching from sqlite not here====
                                
                                
                                // %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%new commented june
                              
                                
                                print("inserted id: \(rowid)")
                            }
                            else
                            {
                                print("inside displayname hereeeeeee")
                                
                                
                                let rowid = try sqliteDB.db.run((tbl_contactslists?.insert(contactid<-contactsJsonObj[i]["contactid"]["_id"].string!,
                                                                                           detailsshared<-contactsJsonObj[i]["detailsshared"].string!,
                                                                                           
                                                                                           unreadMessage<-contactsJsonObj[i]["unreadMessage"].boolValue,
                                                                                           
                                                                                           userid<-contactsJsonObj[i]["userid"].string!,
                                                                                           firstname<-contactsJsonObj[i]["contactid"]["display_name"].string!,
                                                                                           lastname<-"",
                                                                                           
                                                                                           //lastname<-contactsJsonObj[i]["contactid"]["lastname"].string!,
                                    email<-"@",
                                    phone<-contactsJsonObj[i]["contactid"]["phone"].string!,
                                    username<-contactsJsonObj[i]["contactid"]["phone"].string!,
                                    status<-contactsJsonObj[i]["contactid"]["status"].string!))!
                                )
                           
                                print("inserted id: \(rowid)")
                                
                            }
                            
                        } catch {
                            print("insertion failed: \(error)")
                        }
                        
                    }
                    
                    print("contacts fetchedddddddddddddd sucecess")
                    
                    
                    completion(true)
                    
                }else{
                    
                    completion(false)
                    
                    print("error: \(response1.error!.localizedDescription)")
                    /*if(socketObj != nil)
                    {
                    socketObj.socket.emit("logClient", "error: \(error1!.localizedDescription)")
                    }*/
                    //print(error1)
                    print(response1.response?.statusCode)
                    print("FETCH CONTACTS FAILED")
                    print("eeeeeeeeeeeeeeeeeeeeee")
                    
                }
                if(response1.response?.statusCode==401)
                {
                 
                    print("Refreshinggggggggggggggggggg token expired")
                    if(username==nil || password==nil)
                    {print("line # 1074")
                        self.performSegue(withIdentifier: "loginSegue", sender: nil)
                    }
                    
                    /*else{
                        self.rt.refrToken()
                    }*/
                    
                }
                
        }
        
        
        
    }

    func getCurrentUserDetails(_ completion: @escaping (_ result:Bool)->())
    { //self.strLabel.text="Setting Contacts Step 4/4"
        if(socketObj != nil)
        {
        socketObj.socket.emit("logClient","IPHONE-LOG: login success and AuthToken was not nil getting myself details from server")
        }
        
        print("login success 1")
        
        //======GETTING REST API TO GET CURRENT USER=======================
        
        var userDataUrl=Constants.MainUrl+Constants.getCurrentUser
        
        
        var getUserDataURL=userDataUrl
        
        Alamofire.request("\(getUserDataURL)",headers:header).validate(statusCode: 200..<300).responseJSON { (response) in
            
       // Alamofire.request(.GET,"\(getUserDataURL)",headers:header).validate(statusCode: 200..<300).responseJSON{response in
            
            
            //switch response.result {
            if(response.response?.statusCode==200)
            {
            //case .success:
                if let data1 = response.result.value {
                    let json = JSON(data1)
                    print("JSON: \(json)")
                    
                    print("got user success")
                   
                    username=json["phone"].string
                    //loggedUserObj=json
                    //KeychainWrapper.setString(loggedUserObj.description, forKey:"loggedUserObjString")
                    var loggedobjstring=KeychainWrapper.stringForKey("loggedUserObjString")
                    
                    if(socketObj != nil)
                    {
                    socketObj.socket.emit("logClient","IPHONE-LOG: keychain of loggedUserObjString is \(loggedobjstring)")
                    }
                        
                    //print(loggedUserObj.debugDescription)
                    //print(loggedUserObj.object)
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
                            
                            try sqliteDB.db.run((tbl_accounts?.delete())!)
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
                            let rowid = try sqliteDB.db.run((tbl_accounts?.insert(_id<-json["_id"].string!,
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
                                phone<-json["phone"].string!))!)
                            print("inserted id: \(rowid)")
                            
                            return completion(true)
                            
                        } catch {
                            print("insertion failed: \(error)")
                        }
                        
                        
                        do{for account in try sqliteDB.db.prepare(tbl_accounts!) {
                            print("id: \(account[_id]), phone: \(account[phone]), firstname: \(account[firstname])")
                            // id: 1, email: alice@mac.com, name: Optional("Alice")
                            }
                            
                        }
                        catch
                        {
                           print("error \(error)")
                        }
                    }
           // case .failure:
            }
            else{
                print("error \(response.error)")
                if(socketObj != nil)
                {
                socketObj.socket.emit("logClient", "\(username!) failed to get its data")
                }
            }
            }
        }
    
    
    
    func fetchChatsFromServer(_ completion: @escaping (_ result:Bool)->())
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
        
       // dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
        
        
        Alamofire.request("\(fetchChatURL)", method: .post, parameters: ["user1":username!],headers:header).responseJSON { response in
            

       /// Alamofire.request(.POST,"\(fetchChatURL)",headers:header,parameters:["user1":username!]).validate(statusCode: 200..<300).responseJSON{response in
                
                
                
                let to = Expression<String>("to")
                let from = Expression<Bool>("from")
                let name = Expression<String?>("name")

                
                switch response.result {
                case .success:
                    
                    if(socketObj != nil)
                    {
                    socketObj.socket.emit("logClient", "All chat fetched success")
                    }
                    if let data1 = response.result.value {
                        let serialQueue = DispatchQueue(label: "queuename")
                        serialQueue.sync{
                       // DispatchQueue.global(DispatchQoS.default).sync() {
                            
                        //let UserchatJson = JSON(data1)
                            let UserchatJson = JSON(response.data!)
                        print("all chat fetched JSON: \(UserchatJson)")
                        
                        var tableUserChatSQLite=sqliteDB.userschats
                        
                        do{
                            try sqliteDB.db.run((tableUserChatSQLite?.delete())!)
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
                        
                            for var i in 0 ..< UserchatJson["msg"].count
                            {
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                            let datens2 = dateFormatter.date(from: UserchatJson["msg"][i]["date"].string!)
                           
                            print("fetch all date from server in installation got is \(UserchatJson["msg"][i]["date"].string!)... converted is \(datens2.debugDescription)")
                            
                            /*let formatter = DateFormatter()
                            formatter.dateFormat = "MM/dd hh:mm a"";
                            //formatter.dateStyle = NSDateFormatterStyle.ShortStyle
                            //formatter.timeStyle = .ShortStyle
                            
                            let dateString = formatter.stringFromDate(datens2!)
                            */
                            
                            
                            if(UserchatJson["msg"][i]["uniqueid"].exists())
                            {
                                if(UserchatJson["msg"][i]["to"].string! == username! && UserchatJson["msg"][i]["status"].string!=="sent")
                                {
                                    var updatedStatus="delivered"
                                    
                                    ///sqliteDB.SaveChat(<#T##to1: String##String#>, from1: <#T##String#>, owneruser1: <#T##String#>, fromFullName1: <#T##String#>, msg1: <#T##String#>, date1: <#T##String!#>, uniqueid1: <#T##String!#>, status1: <#T##String#>, type1: <#T##String#>, file_type1: <#T##String#>, file_path1: <#T##String#>)
                                    
                                    
                                    //===
                                    
                                    //====
                                    
                                    
                                    let dateFormatter = DateFormatter()
                                    dateFormatter.timeZone=NSTimeZone.local
                                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                                    //  let datens2 = dateFormatter.date(from:date2.debugDescription)
                                    //2016-09-18T19:13:00.588Z
                                    let datens2 = dateFormatter.date(from: UserchatJson["msg"][i]["date"].string!)
                                    
                                    
                                    
                                    print("===fetch chat inside displayname full fetch chat got date as \(UserchatJson["msg"][i]["date"].string!) .. date .... converted NSDate is \(datens2!)")
                                    

                                    
                                    
                                    //UserchatJson["msg"][i]["uniqueid"].string!
                                    //chatJson[0]["from"].string!
                                    
                                    /*
                                    let formatter = DateFormatter()
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
                        DispatchQueue.main.async{
                        return completion(true)
                            }
                        /* DispatchQueue.main.async {
                        self.messageFrame2.removeFromSuperview()
                        }
                        */
                    }
                    
                    }
                    /*DispatchQueue.main.async {
                    
                    }*/
                    
                case .failure:
                    if(socketObj != nil)
                    { socketObj.socket.emit("logClient", "All chat fetched failed")
                    }
                    DispatchQueue.main.async {
                        return completion(true)
                    }
                    print("all chat fetched failed")
                }
            }
           
           // }
        
      //  }
       // }
        
    }
   
    func goToContactsPage(_ completion: (_ result:Bool)->())
    {
        
    }
    
    @IBAction func btnDonePressed(_ sender: AnyObject) {
        print("button done pressed start time \(Date())")
        (sender as! UIBarButtonItem).isEnabled=false
        if(socketObj != nil)
{
socketObj.socket.emit("logClient","button done pressed start time \(Date())")
}
        var displayName="unknown"
        displayName=txtDisplayName.text!
       // appJustInstalled=[true]
        if(accountKit!.currentAccessToken != nil)
        {
        header=["kibo-token":accountKit!.currentAccessToken!.tokenString]
        }
        displayname=displayName
        //=--progressBarDisplayer("Contacting Server", true)
        self.lbl_progress.text="Contacting Server..."
        Q0_sendDisplayName.sync(execute: {
                self.sendNameToServer(displayName){ (result) -> () in
                /*DispatchQueue.main.async
                    {
                    
                }*/
                    /*self.messageFrame.removeFromSuperview()
                    print("setting contacts start time \(NSDate())")
                    self.progressBarDisplayer("Setting Contacts Step 1/4", true)
                    */
                    
                    self.lbl_progress.text="Setting Contacts..."
                    if(socketObj != nil)
                    {
                        socketObj.socket.emit("logClient","IPHONE LOG: setting contacts start time \(Date())")
                    }

                    self.Q1_fetchFromDevice.sync(execute: {//self.strLabel.text="Setting Contacts Step 2/4"
                            //self.fetchContactsFromDevice({ (result) -> () in
                              //SyncfetchContacts
                            self.SyncfetchContacts({ (result) -> () in
                                
                                if(socketObj != nil)
                                {
                                    socketObj.socket.emit("logClient","IPHONE LOG:Done reading addressbook time \(Date())")
                                }
                                //self.messageFrame.removeFromSuperview()
                                //print("Sending network request..")
                               // self.progressBarDisplayer("Sending network request..", true)
                                self.lbl_progress.text="Waiting for Server response.."
                                self.Q2_sendPhonesToServer.sync(execute: {//self.strLabel.text="Setting Contacts Step 2/4"
                                       //====----- self.sendPhoneNumbersToServer({ (result) -> () in
                                            self.SyncSendPhoneNumbersToServer(self.syncPhonesList, completion: { (result) in
                                            //self.messageFrame.removeFromSuperview()
                                            //print("updating local database \(NSDate())")
                                           // self.progressBarDisplayer("Updating local database", true)
                                                if(socketObj != nil)
                                                {
                                                    socketObj.socket.emit("logClient","IPHONE LOG:got server response time \(Date())")
                                                }

                                                self.lbl_progress.text="Updating local database.."
                                            self.Q3_getContactsFromServer.sync(execute: {
                                                    
                                                    //.......
                                                    //....
                                                    self.SyncFillContactsTableWithRecords({ (result) in
                                                        
                                                        
                                                        self.Q6_updateIsKiboStatus.sync(execute: {
                                                                self.syncSetKiboContactsBoolean({ (result) in
                                                                    
                                                                    
                                                                    if(socketObj != nil)
                                                                    {
                                                                        socketObj.socket.emit("logClient","IPHONE LOG:Done updating database time \(Date())")
                                                                    }

                                                                //===self.updateKiboContactsStatus({ (result) in
                                                            
                                                            
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
                                                        
                                                                 //   self.messageFrame.//removeFromSuperview()
                                                                    print("setting contacts start time \(Date())")
                                                                    //self.progressBarDisplayer("Waiting for server response", true)
                                                                    
                                                        self.Q4_getUserData.sync(execute: {
                                                                //self.messageFrame.removeFromSuperview()
                                                                //print("setting contacts start time \(NSDate())")
                                                                //self.progressBarDisplayer("Setting Contacts Step 4/4", true)
                                                                self.getCurrentUserDetails({ (result) -> () in
                                                                
                                                                    
                                                                    
                                                                    
                                                                    let notificationTypes: UIUserNotificationType = [UIUserNotificationType.alert, UIUserNotificationType.badge, UIUserNotificationType.sound]
                                                                    
                                                                    //let notificationTypes: UIUserNotificationType = [UIUserNotificationType.None]
                                                                    
                                                                    
                                                                    let pushNotificationSettings = UIUserNotificationSettings(types: notificationTypes, categories: nil)
                                                                    
                                                                    
                                                                    
                                                                    /////-------will be commented----
                                                                    //application.registerUserNotificationSettings(pushNotificationSettings)
                                                                    //application.registerForRemoteNotifications()
                                                                    
                                                                    if(username != nil && username != "")
                                                                    {
                                                                        print("didRegisterForRemoteNotificationsWithDeviceToken in displaycontroller")
                                                                        
                                                                        UIApplication.shared.registerUserNotificationSettings(pushNotificationSettings)
                                                                    }
                                                                    
                                                                    print("setting contacts finish time \(Date())")
                                                                    
                                                                    self.lbl_progress.text="Getting details from server.."
                                                                    self.Q_fetchAllfriends.sync(execute: {
                                                                            
                                                                    self.fetchContactsFromServer({ (result) in

                                                                        if(socketObj != nil)
                                                                        {
                                                                            socketObj.socket.emit("logClient","IPHONE LOG:Done setting contacts time \(Date())")
                                                                        }

                                                                        self.lbl_progress.text="Setting Chats.."
                                                                //self.messageFrame.removeFromSuperview()
                                                                //self.progressBarDisplayer("Setting Chats", true)
                                                                self.Q5_fetchAllChats.sync(execute: {
                                                                    if(socketObj != nil)
                                                                    {
                                                                        socketObj.socket.emit("logClient","IPHONE LOG: fetch chat start time \(Date())")
                                                                    }

                                                                self.fetchChatsFromServer({ (result) -> () in
                                                                    
                                                                    if(socketObj != nil)
                                                                    {
                                                                        socketObj.socket.emit("logClient","IPHONE LOG:Done fetching chat time \(Date())")
                                                                    }

                                                                   // DispatchQueue.main.async
                                                                       // {
                                                                   //         self.messageFrame.removeFromSuperview()
                                                                            //self.progressBarDisplayer("Setting Groups", true)
                                                                  
                                                                    
                                                                    //==============COMMENTED===========
                                                                    self.lbl_progress.text="Setting Groups.."
                                                                    
                                                                    self.newserialqueue.sync(execute: {
                                                                                    var syncGroupsObj=syncGroupService.init()
                                                                                    //==uncomment latersyncGroupsObj.startSyncGroupsService({ (result) -> () in
                                                                                    
                                                                                    if(socketObj != nil)
                                                                                    {
                                                                                        socketObj.socket.emit("logClient","IPHONE LOG:setting groups \(username!) time \(Date())")
                                                                                    }
                                                                                    self.Q5_fetchAllGroupsData.sync(execute: {
                                                                                    syncGroupsObj.startSyncGroupsServiceOnLaunch({ (result) -> () in
                                                                                        
                                                                                        
                                                                                        Alamofire.request("\(Constants.MainUrl+Constants.urllog)", method: .post, parameters: ["data":"IPHONE_LOG: sync on installation is completed. going to chat screen \(username!)"], encoding: JSONEncoding.default)
                                                                                            .downloadProgress(queue: DispatchQueue.global(qos: .utility)) { progress in
                                                                                                print("Progress: \(progress.fractionCompleted)")
                                                                                            }
                                                                                            .validate { request, response, data in
                                                                                                // Custom evaluation closure now includes data (allows you to parse data to dig out error messages if necessary)
                                                                                                return .success
                                                                                            }
                                                                                            .responseJSON { response in
                                                                                                debugPrint(response)
                                                                                        }
                                                                                        
                                                                                        /*Alamofire.request(.POST,"\(Constants.MainUrl+Constants.urllog)",headers:header,parameters: ["data":"IPHONE_LOG: sync on installation is completed. going to chat screen \(username!)"]).response{
                                                                                            request, response_, data, error in
                                                                                            print(error)
                                                                                        }
*/
 
                                                                                    //result
                                                                                        print("sync on installation is completed. going to chat screen")
                                                                     
                                                                                        self.lbl_progress.text="Completed.."
                                                                                        DispatchQueue.main.async
                                                                                    {
                                                                                        if(socketObj != nil)
                                                                                        {
                                                                                            socketObj.socket.emit("logClient","IPHONE LOG: Completed\(username!) \(Date())")
                                                                                        }

                                                                                        //self.messageFrame.removeFromSuperview()
                                                                                        print("completed done time \(Date())")
                                                                                        
                                                                                        
                                                                                        
                                                                                        //self.performSegue(withIdentifier: "displayToChatSegue", sender: nil)
                                                                
                                                                                       /* var chatview=self.storyboard?.instantiateViewController(withIdentifier: "MainChatView")
                                                                                        
                                                                                    
                                                                                        
                                                                                       self.present(chatview!, animated: true, completion: {
                                                                                
                                                                                print("logged in going to contactlist")
                                                                                
                                                                            })*/
                                                                                        
                                                                                        self.dismiss(animated: false, completion: { () -> Void in
                                                                                
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
                                            
                                            DispatchQueue.main.async
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
    
    
    
    
    func syncSetKiboContactsBoolean(_ completion:@escaping (_ result:Bool)->())
    {
        
        let allcontactslist1=sqliteDB.allcontacts
        var alladdressContactsArray:Array<Row>
        
        let phone = Expression<String>("phone")
        let kibocontact = Expression<Bool>("kiboContact")
        let name = Expression<String?>("name")
        
        //alladdressContactsArray = Array(try sqliteDB.db.prepare(allcontactslist1))
        DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.default).sync
        {
        do{for ccc in try sqliteDB.db.prepare(allcontactslist1!) {
            
            for i in 0 ..< self.syncAvailablePhonesList.count
            {//print(":::email .......  : \(self.syncAvailablePhonesList[i])")
                if(ccc[phone]==self.syncAvailablePhonesList[i])
                { print(":::::::: \(ccc[phone])  and emaillist : \(self.syncAvailablePhonesList[i])")
                    //ccc[kibocontact]
                    
                    let query = allcontactslist1?.select(kibocontact)           // SELECT "email" FROM "users"
                        .filter(phone == ccc[phone])     // WHERE "name" IS NOT NULL
                    
                    try sqliteDB.db.run((query?.update(kibocontact <- true))!)
                    
                    
                    // for kk in try sqliteDB.db.prepare(query) {
                    //  try sqliteDB.db.run(query.update(kk[kibocontact] <- true))
                    //}
                    //try sqliteDB.db.run(allcontactslist1.update(query[kibocontact] <- true))
                    
                    // try sqliteDB.db.run(allcontactslist1.update(ccc[kibocontact] <- true))
                }
                
            }
            
            }
            DispatchQueue.main.async
            {
                completion(true)
            }
        }
        catch{
            print("error 123")
            DispatchQueue.main.async
            {
                completion(false)
            }
        }
        
        
    }
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
        var joinquery=allcontacts?.join(.leftOuter, contactslists!, on: (contactslists?[phone])! == (allcontacts?[phone])!)
        
        do{for joinresult in try sqliteDB.db.prepare(joinquery!) {
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
    
    func updateKiboContactsStatus(_ completion: @escaping (_ result:Bool)->())
    {
        
        let allcontactslist1=sqliteDB.allcontacts
        var alladdressContactsArray:Array<Row>
        
        let phone = Expression<String>("phone")
        let kibocontact = Expression<Bool>("kiboContact")
        let name = Expression<String?>("name")
        
        //alladdressContactsArray = Array(try sqliteDB.db.prepare(allcontactslist1))
        
        DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.default).sync
        {
            let joinrows=self.leftJoinContactsTables()
            
            do{
                for ccc in joinrows {
                    
                    for i in 0 ..< availableEmailsList.count
                    {print(":::email .......  : \(availableEmailsList[i])")
                        
                        if(ccc.get((allcontactslist1?[phone])!)==availableEmailsList[i])
                        { print(":::::::: \(ccc.get((allcontactslist1?[phone])!))  and emaillist : \(availableEmailsList[i])")
                            //ccc[kibocontact]
                            
                            let query = allcontactslist1?.select(kibocontact)           // SELECT "email" FROM "users"
                                .filter(phone == ccc.get((allcontactslist1?[phone])!))     // WHERE "name" IS NOT NULL
                            
                            do{try sqliteDB.db.run((query?.update(kibocontact <- true))!)}
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
                
                DispatchQueue.main.async
                {
                    return completion(true)
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
                    DispatchQueue.main.async {
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

                        self.dismiss(false, completion: { () -> Void in

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
