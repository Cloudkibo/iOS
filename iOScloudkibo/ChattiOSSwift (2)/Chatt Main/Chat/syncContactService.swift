//
//  syncContactService.swift
//  kiboApp
//
//  Created by Cloudkibo on 29/09/2016.
//  Copyright © 2016 MyAppTemplates. All rights reserved.
//

import Foundation
import SQLite
import Contacts
import AccountKit
import Alamofire
import SwiftyJSON

class syncContactService
{
    var Q0_sendDisplayName=dispatch_queue_create("Q0_sendDisplayName",DISPATCH_QUEUE_SERIAL)
    var Q1_fetchFromDevice=dispatch_queue_create("fetchFromDevice",DISPATCH_QUEUE_SERIAL)
    var Q2_sendPhonesToServer=dispatch_queue_create("sendPhonesToServer",DISPATCH_QUEUE_SERIAL)
    var Q3_getContactsFromServer=dispatch_queue_create("getContactsFromServer",DISPATCH_QUEUE_SERIAL)
    var Q4_getUserData=dispatch_queue_create("getUserData",DISPATCH_QUEUE_SERIAL)
    var Q5_fetchAllChats=dispatch_queue_create("fetchAllChats",DISPATCH_QUEUE_SERIAL)
    
    
    var contactsListSync=[CNContact]()
    //var PhoneList=[String]() make in activity
    var accountKit: AKFAccountKit!
   
     init()
    {
        if(accountKit == nil){
            accountKit = AKFAccountKit(responseType: AKFResponseType.AccessToken)
        }
        
        
        if (accountKit!.currentAccessToken != nil) {
            
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)) {
            print("synccccc fetching contacts in background")
            self.SyncfetchContacts{ (result) in
                print("synccccc fetch contacts donee")
                
            }
            
        }
        }
     
        
    }
    
    func SyncfetchContacts(completion:(result:Bool)->())
    {
        let contactStore = CNContactStore()
        
        var keys = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactEmailAddressesKey, CNContactPhoneNumbersKey, CNContactImageDataAvailableKey,CNContactThumbnailImageDataKey, CNContactImageDataKey]
        do {
            /////let contactStore = AppDelegate.getAppDelegate().contactStore
            try contactStore.enumerateContactsWithFetchRequest(CNContactFetchRequest(keysToFetch: keys)) { (contact, pointer) -> Void in
                
                print("appending to contacts")
                self.contactsListSync.append(contact)
                
                print("contactsListSync appended count is \(self.contactsListSync.count)")
                print("inside contacts filling for loop count is \(self.contactsListSync.count)")
                do{
                    uniqueidentifierList.append(contact.identifier)
                    if(try contact.givenName != "")
                    {
                        nameList.append(contact.givenName+" "+contact.familyName)
                        print(contact.givenName)
                        
                    }
                    
                    
                }
                catch(let error)
                {
                    print("error: \(error)")
                    socketObj.socket.emit("logClient", "error in fetching contact name: \(error)")
                }
                
                do{
                    
                    if(try contact.imageDataAvailable == true)
                    {
                        profileimageList.append(contact.imageData!)
                        //nameList.append(contacts[i].givenName+" "+contacts[i].familyName)
                        //print(contacts[i].givenName)
                    }
                    /*else
                     {
                     profileimageList.append(nil)
                     }*/
                    
                }
                catch(let error)
                {
                    print("error: \(error)")
                    socketObj.socket.emit("logClient", "error in fetching contact name: \(error)")
                }
                
                do{
                    
                    var uniqueidentifier1=contact.identifier
                    var image=NSData()
                    var fullname=contact.givenName+" "+contact.familyName
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
                                let em = try contact.emailAddresses.first
                                if(em != nil && em != "")
                                {
                                    print(em?.label)
                                    print(em?.value)
                                    emailAddress=(em?.value)! as! String
                                    print("email adress value iss \(emailAddress)")
                                    /////emails.append(em!.value as! String)
                                }
                                if(contact.imageDataAvailable==true)
                                {
                                    image=contact.imageData!
                                }
                                
                               ///////====== FILL DB AFTERWARDS
                                
                                //try sqliteDB.db.run(tbl_allcontacts.insert(name<-fullname,phone<-phoneDigits,actualphone<-actualphonedigits,email<-emailAddress,uniqueidentifier<-uniqueidentifier1))
                            }
                            catch(let error)
                            {
                                print("error in name : \(error)")
                                socketObj.socket.emit("logClient","IPHONE-LOG: iphoneLog: error is getting name \(error)")
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
                catch(let error)
                {
                    print("error: \(error)")
                    socketObj.socket.emit("logClient", "error in fetching phone: \(error)")
                }
                
                
                /*if( phone != ""  && phone != nil)
                 {
                 phonesList.append(phone.stringValue)
                 print(phone.stringValue)
                 }*/
                
                do{
                    let em = try contact.emailAddresses.first
                    if(em != nil && em != "")
                    {
                        print(em?.label)
                        print(em?.value)
                        /////emails.append(em!.value as! String)
                    }
                    
                    
                }
                catch(let error)
                {
                    print("error: \(error)")
                    socketObj.socket.emit("logClient", "error in fetching email address: \(error)")
                }
                
                
                //print(self.contacts[i].emailAddresses.first!.value)
                ////self.emails.append(phone.stringValue)
                // print(self.emails[i])
                
                ///////
                
            }
            
            
            completion(result: true)
            
        }catch{
            print("error 1..")
        }
        
    }
    
    func startContactsRefresh()
    {
        if (accountKit!.currentAccessToken != nil) {
            
        
        print("sync fetching from devie")
    dispatch_async(self.Q1_fetchFromDevice,
    {
    self.fetchContactsFromDevice({ (result) -> () in
    
    dispatch_async(self.Q2_sendPhonesToServer,
    {
        
        print("sync sending numbers to server")
    self.sendPhoneNumbersToServer({ (result) -> () in
    
    dispatch_async(self.Q3_getContactsFromServer,
    {
        
        print("sync fetching contacts from server")
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
    
    })})})})})
    
    })
            
            addressbookChangedNotifReceived=false
            
           // socketObj.delegateChat.socketReceivedMessageChat("updateUI", data: nil)
        }
        else
        {
            print("error: accountkit not initialised yet in sync contacts")
        }
        
        
        
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
    
    func fetchContactsFromDevice(completion: (result:Bool)->())
    {
        
       /// var newcontactsList=iOSContact(keys: [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactEmailAddressesKey, CNContactPhoneNumbersKey])
        
        contactsList.fetch(){ (result) -> () in
            
            emailList.removeAll()
            
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
    
    
    
    func sendPhoneNumbersToServer(completion: (result:Bool)->())
    {
        contactsList.searchContactsByPhone(emailList)
        { (result2) -> () in
            
            notAvailableEmails.removeAll()
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
                      //  self.performSegueWithIdentifier("loginSegue", sender: nil)
                    }
                    
                    /*else{
                     self.rt.refrToken()
                     }*/
                    
                }
                
        }
        
        
        
    }
}