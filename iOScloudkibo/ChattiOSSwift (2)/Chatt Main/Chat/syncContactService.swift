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
    
    
    var delegateRefreshContactsList:RefreshContactsList!
    
    var Q0_sendDisplayName=dispatch_queue_create("Q0_sendDisplayName",DISPATCH_QUEUE_SERIAL)
    var Q1_fetchFromDevice=dispatch_queue_create("fetchFromDevice",DISPATCH_QUEUE_SERIAL)
    var Q2_sendPhonesToServer=dispatch_queue_create("sendPhonesToServer",DISPATCH_QUEUE_SERIAL)
    var Q3_getContactsFromServer=dispatch_queue_create("getContactsFromServer",DISPATCH_QUEUE_SERIAL)
    var Q4_getUserData=dispatch_queue_create("getUserData",DISPATCH_QUEUE_SERIAL)
    var Q5_fetchAllChats=dispatch_queue_create("fetchAllChats",DISPATCH_QUEUE_SERIAL)
    
    
    var syncPhonesList=[String]()
    var syncAvailablePhonesList=[String]()
    var syncNotAvailablePhonesList=[String]()
    var syncContactsList=[CNContact]()
    //var PhoneList=[String]() make in activity
    var accountKit: AKFAccountKit!
   
    
    var name=Expression<String>("name")
    var phone=Expression<String>("phone")
    var actualphone=Expression<String>("actualphone")
    var email=Expression<String>("email")
    //////////////var profileimage=Expression<NSData>("profileimage")
    let uniqueidentifier = Expression<String>("uniqueidentifier")
    
    
    
    init()
    {
        
        
        
    }
     func startSyncService()
    {
        
       /* let dispatch_queue_attr = dispatch_queue_attr_make_with_qos_class(DISPATCH_QUEUE_SERIAL, QOS_CLASS_BACKGROUND, 0)
        var queue = dispatch_queue_create("DataStoreControllerSerialQueue", dispatch_queue_attr)
        
        dispatch_async(queue) {
            
            
            
            
        }*/
    
        if(accountKit == nil){
            accountKit = AKFAccountKit(responseType: AKFResponseType.AccessToken)
        }
        
        
        if (accountKit!.currentAccessToken != nil) {
            
            
            
      //  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)) {
            let dispatch_queue_attr = dispatch_queue_attr_make_with_qos_class(DISPATCH_QUEUE_SERIAL, QOS_CLASS_BACKGROUND, 0)
            var queue1 = dispatch_queue_create("1", dispatch_queue_attr)
            var queue2 = dispatch_queue_create("2", dispatch_queue_attr)
            var queue3 = dispatch_queue_create("3", dispatch_queue_attr)
            var queue4 = dispatch_queue_create("4", dispatch_queue_attr)
            var queue5 = dispatch_queue_create("5", dispatch_queue_attr)
            
            dispatch_async(queue1) {
            print("synccccc fetching contacts in background...")
            self.SyncfetchContacts{ (result) in
                print("synccccc fetch contacts donee")
                 print("synccccc sending phone numbers to server...")
                
                //dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)) {
                dispatch_async(queue2) {
                self.SyncSendPhoneNumbersToServer(self.syncPhonesList, completion: { (result) in
                    print("synccccc sent phone numbers to server done ")
                    print("synccccc filling local database with contacts ")
                   // dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)) {
                    dispatch_async(queue3) {
                        self.SyncFillContactsTableWithRecords({ (result) in
                        print("synccccc filled local database with contacts done")
                        print("synccccc setting kibocontact boolean")
                        //dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)) {
                        dispatch_async(queue4) {
                            self.syncSetKiboContactsBoolean({ (result) in
                            print("synccccc setting kibocontact boolean done")
                            print("synccccc getting friends/contactslist from server")
                           // dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)) {
                            
                                
                                dispatch_async(queue5) {
                                    self.fetchContactsFromServer({ (result) in
                                
                                print("synccccc got friends/contactslist from server done")
                                dispatch_async(dispatch_get_main_queue())
                                {
                                if(self.delegateRefreshContactsList != nil)
                                {
                                self.delegateRefreshContactsList?.refreshContactsList("refreshContactsUI")
                                }
                                addressbookChangedNotifReceived=false
                                }
                            })
                            }
                            })
                        }
                        })

                        }
                
                    })
                }
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
                /*do{
                   /////// uniqueidentifierList.append(contact.identifier)
                    if(try contact.givenName != "")
                    {
                        /////////nameList.append(contact.givenName+" "+contact.familyName)
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
                       ///////// profileimageList.append(contact.imageData!)
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
                
                
                */
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
            for(var i=0;i<syncContactsList.count;i++)
            {
                
                do{
                    /////// uniqueidentifierList.append(contact.identifier)
                    if(try syncContactsList[i].givenName != "")
                    {
                        /////////nameList.append(contact.givenName+" "+contact.familyName)
                        print(syncContactsList[i].givenName)
                        
                    }
                    
                    
                }
                catch(let error)
                {
                    print("error: \(error)")
                    socketObj.socket.emit("logClient", "error in fetching contact name: \(error)")
                }
                do{
                    
                    var uniqueidentifier1=syncContactsList[i].identifier
                    var image=NSData()
                    var fullname=syncContactsList[i].givenName+" "+syncContactsList[i].familyName
                    if (syncContactsList[i].isKeyAvailable(CNContactPhoneNumbersKey)) {
                        for phoneNumber:CNLabeledValue in syncContactsList[i].phoneNumbers {
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
                                let em = try syncContactsList[i].emailAddresses.first
                                if(em != nil && em != "")
                                {
                                    print(em?.label)
                                    print(em?.value)
                                    emailAddress=(em?.value)! as! String
                                    print("email adress value iss \(emailAddress)")
                                    /////emails.append(em!.value as! String)
                                }
                                if(syncContactsList[i].imageDataAvailable==true)
                                {
                                    image=syncContactsList[i].imageData!
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
                try sqliteDB.db.run(tbl_allcontacts.insert(name<-contactsdata[j]["name"]!,phone<-contactsdata[j]["phone"]!,actualphone<-contactsdata[j]["actualphone"]!,email<-contactsdata[j]["email"]!,uniqueidentifier<-contactsdata[j]["uniqueidentifier"]!))
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
    
        
        
    
    
    
    func syncSetKiboContactsBoolean(completion:(result:Bool)->())
    {
        
         var allcontactslist1=sqliteDB.allcontacts
         var alladdressContactsArray:Array<Row>
         
         let phone = Expression<String>("phone")
         let kibocontact = Expression<Bool>("kiboContact")
         let name = Expression<String?>("name")
         
         //alladdressContactsArray = Array(try sqliteDB.db.prepare(allcontactslist1))
         
         do{for ccc in try sqliteDB.db.prepare(allcontactslist1) {
         
         for var i=0;i<syncAvailablePhonesList.count;i++
         {print(":::email .......  : \(syncAvailablePhonesList[i])")
         if(ccc[phone]==syncAvailablePhonesList[i])
         { print(":::::::: \(ccc[phone])  and emaillist : \(syncAvailablePhonesList[i])")
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
            dispatch_async(dispatch_get_main_queue())
            {
            completion(result:true)
            }
         }
         catch{
         print("error 123")
            dispatch_async(dispatch_get_main_queue())
            {
            completion(result:false)
            }
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
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND,0))
        {
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
            dispatch_async(dispatch_get_main_queue())
{
            completion(result: true)
            }
        }
    }
    }
    
    
    
    func sendPhoneNumbersToServer(completion: (result:Bool)->())
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND,0))
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
            dispatch_async(dispatch_get_main_queue())
            {
            completion(result: true)
            }
        }
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
                    
                    dispatch_async(dispatch_get_main_queue())
                    {
                    completion(result:true)
                    }
                    
                }else{
                    dispatch_async(dispatch_get_main_queue())
                    {
                    completion(result:false)
                    }
                    
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

protocol RefreshContactsList:class
{
    func refreshContactsList(message:String);
}
