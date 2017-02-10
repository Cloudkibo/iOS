//
//  Contact.swift
//  Chat
//
//  Created by Cloudkibo on 24/01/2016.
//  Copyright © 2016 MyAppTemplates. All rights reserved.
//

import Foundation
import Contacts
import Alamofire
import SwiftyJSON
import SQLite

class iOSContact{
    
    var delegate:InviteContactsDelegate!
    //var contacts = [CNContact]()
    var keys:[String]
    var notAvailableContacts=[String]()
    
    //// var emails=[String]()
    init(keys:[String]){
        self.keys=keys
        //fetch()
    }
    
    
    
    
    func fetch(_ completion: (_ result:[String])->()){
        
        let tbl_allcontacts=sqliteDB.allcontacts
        
        //deleting all records
        do
        {
            print("deleting records")
            try sqliteDB.db.run((tbl_allcontacts?.delete())!)
print("now count is \(tbl_allcontacts?.count)")
        }
        catch
            {
                print("error in deleting allcontacts table")
                socketObj.socket.emit("logClient","IPHONE-LOG: iphoneLog: error in deleting allcontacts data \(error)")
        }
        
        
        var name=Expression<String>("name")
        var phone=Expression<String>("phone")
        var actualphone=Expression<String>("actualphone")
        let email=Expression<String>("email")
        //////////////var profileimage=Expression<NSData>("profileimage")
        let uniqueidentifier = Expression<String>("uniqueidentifier")
        
        socketObj.socket.emit("logClient","IPHONE-LOG: \(username) fetching contacts from iphone contactlist")
        var emails=[String]()
        contacts.removeAll()
        emailList.removeAll()
        nameList.removeAll()
        phonesList.removeAll()
        notAvailableEmails.removeAll()
        notAvailableContacts.removeAll()
        notAvailableContacts.removeAll()
        profileimageList.removeAll()
        uniqueidentifierList.removeAll()
        
        print("inside fetchhhhh")
        
        //////===new sync contacts
        
        
        //contacts.removeAll()
        ///contacts = [CNContact]()
        let contactStore = CNContactStore()
        
        keys = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactEmailAddressesKey, CNContactPhoneNumbersKey, CNContactImageDataAvailableKey,CNContactThumbnailImageDataKey, CNContactImageDataKey]
        do {
            /////let contactStore = AppDelegate.getAppDelegate().contactStore
            try contactStore.enumerateContacts(with: CNContactFetchRequest(keysToFetch: keys as [CNKeyDescriptor])) { (contact, pointer) -> Void in
                
                print("appending to contacts")
                contacts.append(contact)
               
                    print("contacts appended count is \(contacts.count)")
                    print("inside contacts filling for loop count is \(contacts.count)")
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
                        var image=Data()
                        var fullname=contact.givenName+" "+contact.familyName
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
                                    if(countrycode=="1" && phoneDigits.characters.first==Character.init("1") && phoneDigits.characters.first != Character.init("+"))
                                    {
                                        phoneDigits = "+"+phoneDigits
                                    }
                                    else if(phoneDigits.characters.first != "+"){
                                        phoneDigits = "+"+countrycode+phoneDigits
                                        print("appended phone is \(phoneDigits)")
                                    }
                                    emails.append(phoneDigits)
                                    var emailAddress=""
                                    if let em = try contact.emailAddresses.first
                                    {
                                        print(em.label)
                                        print(em.value)
                                        emailAddress=(em.value) as String
                                        print("email adress value iss \(emailAddress)")
                                        /////emails.append(em!.value as! String)
                                    }
                                    if(contact.imageDataAvailable==true)
                                    {
                                        image=contact.imageData!
                                    }
                                    
                                    try sqliteDB.db.run((tbl_allcontacts?.insert(name<-fullname,phone<-phoneDigits,actualphone<-actualphonedigits,email<-emailAddress,uniqueidentifier<-uniqueidentifier1))!)
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
                        if let em = try contact.emailAddresses.first
                        {
                            print(em.label)
                            print(em.value)
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
            
            
            completion(emails)
            
        }catch{
            print("error 1..")
        }
        
        
        
        
        
        
        /*
        
        print(contacts.first?.givenName)
            // dispatch_async(dispatch_get_main_queue(), { () -> Void in
            
            socketObj.socket.emit("logClient","IPHONE-LOG: \(username) received \(contacts.count) contacts from iphone contactlist")
            for(var i=0;i<contacts.count;i++){
                
                print("inside contacts filling for loop count is \(contacts.count)")
                do{
                    uniqueidentifierList.append(contacts[i].identifier)
                    if(try contacts[i].givenName != "")
                    {
                        nameList.append(contacts[i].givenName+" "+contacts[i].familyName)
                        print(contacts[i].givenName)
                        
                    }
                    
                    
                }
                catch(let error)
                {
                    print("error: \(error)")
                    socketObj.socket.emit("logClient", "error in fetching contact name: \(error)")
                }
                
                do{
                    
                    if(try contacts[i].imageDataAvailable == true)
                    {
                        profileimageList.append(contacts[i].imageData!)
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
                    
                    var uniqueidentifier1=contacts[i].identifier
                    var image=NSData()
                    var fullname=contacts[i].givenName+" "+contacts[i].familyName
                    if (contacts[i].isKeyAvailable(CNContactPhoneNumbersKey)) {
                        for phoneNumber:CNLabeledValue in contacts[i].phoneNumbers {
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
                                emails.append(phoneDigits)
                                var emailAddress=""
                                let em = try contacts[i].emailAddresses.first
                                if(em != nil && em != "")
                                {
                                    print(em?.label)
                                    print(em?.value)
                                    emailAddress=(em?.value)! as! String
                                    print("email adress value iss \(emailAddress)")
                                    /////emails.append(em!.value as! String)
                                }
                                if(contacts[i].imageDataAvailable==true)
                                {
                                   image=contacts[i].imageData!
                                }
                                
                                try sqliteDB.db.run(tbl_allcontacts.insert(name<-fullname,phone<-phoneDigits,actualphone<-actualphonedigits,email<-emailAddress,uniqueidentifier<-uniqueidentifier1))
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
                    let em = try contacts[i].emailAddresses.first
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
            }
            //emails.append("kibo@kibo.com")
            
            
            
            //self.delegate.didFetchContacts(contacts)
            //self.navigationController?.popViewControllerAnimated(true)
            ////  })
            ////searchContactsByEmail(emails)
            ////sendInvite()
            //return emails
        
        
        
        */
            
            completion(emails)
       
        
        
        
        /* }
        catch let error as NSError {
            print("errorrrrr ...")
            socketObj.socket.emit("logClient","IPHONE-LOG: error: fetching contacts from device \(error.description)")
            print(error.description, separator: "", terminator: "\n")
             print("... ... \(error.localizedFailureReason)")
        }*/
        
        //return emails
        
    }
    
    
    func fetchContactsByEmails(_ completion: @escaping (_ result:[String])->()){
        socketObj.socket.emit("logClient","IPHONE-LOG: \(username) fetching contacts from iphone contactlist")
        var emails=[String]()
        contacts.removeAll()
        emailList.removeAll()
        nameList.removeAll()
        phonesList.removeAll()
        notAvailableEmails.removeAll()
        notAvailableContacts.removeAll()
        
        print("inside fetchhhhh")
        let contactStore = CNContactStore()
        
        keys = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactEmailAddressesKey, CNContactPhoneNumbersKey]
        do {
            /////let contactStore = AppDelegate.getAppDelegate().contactStore
            try contactStore.enumerateContacts(with: CNContactFetchRequest(keysToFetch: keys as [CNKeyDescriptor])) { (contact, pointer) -> Void in
                contacts.append(contact)
                
                    
                    
                    do{
                        
                        if(try contact.givenName != "")
                        {
                            nameList.append(contact.givenName)
                            print(contact.givenName)
                        }
                        
                        
                    }
                    catch(let error)
                    {
                        print("error: \(error)")
                        socketObj.socket.emit("logClient", "error in fetching contact name: \(error)")
                    }
                    
                    
                    
                    do{
                        if let phone = try contact.phoneNumbers.first?.value as CNPhoneNumber!
                        {
                            
                        }
                        
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
                            emails.append(em!.value as String)
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
                
                completion(emails)
            }
        }
            catch(let error)
            {
                print("error: \(error)")
                socketObj.socket.emit("logClient", "error in fetching email address: \(error)")
            }
            
           /*
            print(contacts.first?.givenName)
            // dispatch_async(dispatch_get_main_queue(), { () -> Void in
            
            socketObj.socket.emit("logClient","IPHONE-LOG: \(username) received \(contacts.count) contacts from iphone contactlist")
            for(var i=0;i<contacts.count;i++){
                
                
                do{
                    
                    if(try contacts[i].givenName != "")
                    {
                        nameList.append(contacts[i].givenName)
                        print(contacts[i].givenName)
                    }
                    
                    
                }
                catch(let error)
                {
                    print("error: \(error)")
                    socketObj.socket.emit("logClient", "error in fetching contact name: \(error)")
                }

                
               
                do{
                    if let phone = try contacts[i].phoneNumbers.first?.value as! CNPhoneNumber!
                    {
                        
                    }
                        
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
                    let em = try contacts[i].emailAddresses.first
                    if(em != nil && em != "")
                    {
                        print(em?.label)
                        print(em?.value)
                        emails.append(em!.value as! String)
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
            }
            //emails.append("kibo@kibo.com")
            
            
            
            //self.delegate.didFetchContacts(contacts)
            //self.navigationController?.popViewControllerAnimated(true)
            ////  })
            ////searchContactsByEmail(emails)
            ////sendInvite()
            //return emails
            
            completion(result: emails)
        }
        catch {
            print("errorrrrr ...")
            socketObj.socket.emit("logClient","IPHONE-LOG: error: fetching contacts from device")
          //  print(error.description, separator: "", terminator: "\n")
          //  print("... ... \(error.localizedFailureReason)")
            
        }
        */
        //return emails
        
    }
    func searchContactsByEmail(_ emails:[String],completion: @escaping (_ result:[String])->())
    {
        print("emails are \(emails)")
        socketObj.socket.emit("logClient","IPHONE-LOG: sending emails to server")
        // %%%%%%%%%%%%%%%%%% new phone model change
        let searchContactsByEmail=Constants.MainUrl+Constants.searchContactsByEmail
        //let searchContactsByEmail=Constants.MainUrl+Constants.searchContactsByEmail+"?access_token="+AuthToken!
        //var s:[String]!
        //var ss:String="["
        for e in emails{
            //ss.appendContentsOf(e)
            print(e)
            
        }
        
        var ssss=emails.debugDescription.replacingOccurrences(of: "\\", with: " ")
        //ss.appendContentsOf("]")
        //emails.description.propertyList()
        //var emailParas=JSON(emails).object
        //dispatch_async(dispatch_get_main_queue(), { () -> Void in
        
        //%%%%%%%%%%%%%%% new phone model change
        //Alamofire.request(.POST,searchContactsByEmail,parameters:["emails":emails],encoding: .JSON).responseJSON { response in
        
        Alamofire.request(searchContactsByEmail, method: .post, parameters: ["emails":emails], headers: header).responseJSON { (response) in
            
        
       // Alamofire.request(.POST,searchContactsByEmail,headers:header,parameters:["emails":emails],encoding: .JSON).responseJSON { response in
            
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
            var availableContactsEmails=res["available"]
            print("available contacts are \(availableContactsEmails.debugDescription)")
            var NotavailableContactsEmails=res["notAvailable"].array
                for var i in 0 ..< NotavailableContactsEmails!.count
                {                // self.notAvailableContacts[i]=NotavailableContactsEmails![i].rawString()!
                self.notAvailableContacts.append(NotavailableContactsEmails![i].debugDescription)
                print("----------- \(self.notAvailableContacts[i].debugDescription)")
            }
                
                for var i in 0 ..< availableContactsEmails.count
                {
                    // self.notAvailableContacts[i]=NotavailableContactsEmails![i].rawString()!
                    availableEmailsList.append(availableContactsEmails[i].debugDescription)
                   // print("----------- \(self.notAvailableContacts[i].debugDescription)")
                }
                
            /*    var allcontactslist1=sqliteDB.allcontacts
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
*/
                //tbl_allcontacts
                
            print(NotavailableContactsEmails!)
            print("**************** \(self.notAvailableContacts)")
            completion(self.notAvailableContacts)
                
               //============ self.delegate?.receivedContactsUpdateUI()
        }
            else
            {
                socketObj.socket.emit("logClient","IPHONE-LOG: error: \(response.debugDescription)")
            }
        
        }
        
       
        // })
    }
    
    func searchContactsByPhone(_ phones:[String],completion: @escaping (_ result:[String])->())
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
            print(e)
            
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
        
        
        
        let request = Alamofire.request(searchContactsByPhones, method: .post, parameters: ["phonenumbers":phones],headers:header).responseJSON{ response in
            
            
        /*
        Alamofire.request(.POST,searchContactsByPhones,headers:header,parameters:["phonenumbers":phones],encoding: .JSON).responseJSON { response in
            */
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
                var NotavailableContactsEmails=res["notAvailable"].array
                for var i in 0 ..< NotavailableContactsEmails!.count
                {
                    // self.notAvailableContacts[i]=NotavailableContactsEmails![i].rawString()!
                    self.notAvailableContacts.append(NotavailableContactsEmails![i].debugDescription)
                    print("----------- \(self.notAvailableContacts[i].debugDescription)")
                }
                
                for var i in 0 ..< availableContactsPhones.count
                {
                    // self.notAvailableContacts[i]=NotavailableContactsEmails![i].rawString()!
                    
                    
                    availableEmailsList.append(availableContactsPhones[i].debugDescription)
                    
                    
                    // print("----------- \(self.notAvailableContacts[i].debugDescription)")
                }
                
                
                //print(NotavailableContactsEmails!)
                print("**************** \(self.notAvailableContacts)")
                completion(self.notAvailableContacts)
                
               /* if(self.delegate != nil)
{
                self.delegate?.receivedContactsUpdateUI()
}*/
            }
            else
            {
                socketObj.socket.emit("logClient","IPHONE-LOG: error: \(response.debugDescription)")
            }
            
        }
        
        
        // })
    }

    func saveToAddressBook(_ newcontact:[String:String],completion: (_ result:Bool)->()){
        let contactTemp = CNMutableContact()
        
        contactTemp.imageData = Data() // The profile picture as a NSData object
        
        contactTemp.givenName = newcontact["fname"]!
        contactTemp.familyName = newcontact["lname"]!
        
        //let homeEmail = CNLabeledValue(label:CNLabelHome, value:"john@example.com")
        //%%%%%%%%%%%%let workEmail = CNLabeledValue(label:CNLabelWork, value:newcontact["email"]!)
        //contactTemp.emailAddresses = [homeEmail, workEmail]
        //%%%%%%%%%%%%%%%%%%%%%%%contactTemp.emailAddresses = [workEmail]
        /* contactTemp.phoneNumbers = [CNLabeledValue(
        label:CNLabelPhoneNumberiPhone,
        value:CNPhoneNumber(stringValue:"(408) 555-0126"))]
        */
        contactTemp.phoneNumbers = [CNLabeledValue(
            label:CNLabelPhoneNumberiPhone,
            value:CNPhoneNumber(stringValue:newcontact["phone"]!))]
        
        /*let homeAddress = CNMutablePostalAddress()
        homeAddress.street = "1 Infinite Loop"
        homeAddress.city = "Cupertino"
        homeAddress.state = "CA"
        homeAddress.postalCode = "95014"
        contactTemp.postalAddresses = [CNLabeledValue(label:CNLabelHome, value:homeAddress)]
        
        let birthday = NSDateComponents()
        birthday.day = 1
        birthday.month = 4
        birthday.year = 1988  // You can omit the year value for a yearless birthday
        contactTemp.birthday = birthday
        */
        // Saving the newly created contact
        let store = CNContactStore()
        let saveRequest = CNSaveRequest()
        saveRequest.add(contactTemp, toContainerWithIdentifier:nil)
        do{
            
             try store.execute(saveRequest)
            
                completion(true)
            
        
        }
        catch{
            completion(false)
            print("cannot save contact to address book. Try again with correct values")
        }
        
    }
    func sendInvite(_ emails:[String],completion: @escaping (_ result:String)->())
    {
        var emails = emails
        //emails.append("sumaira.syedsaeed@gmail.com")
        //emails.append("kibo@kibo.com")
        let inviteMultipleURL=Constants.MainUrl+Constants.invitebymultipleemail
        
        let request = Alamofire.request(inviteMultipleURL, method: .post, parameters: ["emails":emails],headers:header).responseJSON{ response in
            
           /*
        Alamofire.request(.POST,inviteMultipleURL,headers:header,parameters:["emails":emails],encoding: .JSON).validate(statusCode: 200..<300).responseJSON { response in
            */
            debugPrint(response.data)
            //print(response.request)
            //print(response.response)
            print(response.data)
            //print(response.e
            var res=JSON(response.result.value!)
            print(res)

            //print(response.result.value!)
            switch response.result {
            case .success:
            print("invite sent")
                return completion(res["msg"].string!)
            case .failure:
                print("invite failed")
                return completion(res["msg"].string!)
            }
            
        }
        
    }
    
}

protocol InviteContactsDelegate:class
{
    func receivedContactsUpdateUI();
}

/*
if let phone=self.contacts[i].phoneNumbers.first?.value as! CNPhoneNumber!
{

do
{

}
catch
{

}

}
*/
