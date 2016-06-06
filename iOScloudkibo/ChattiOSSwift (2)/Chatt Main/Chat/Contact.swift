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
    
    
    func fetch(completion: (result:[String])->()){
        socketObj.socket.emit("logClient","\(username) fetching contacts from iphone contactlist")
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
            try contactStore.enumerateContactsWithFetchRequest(CNContactFetchRequest(keysToFetch: keys)) { (contact, pointer) -> Void in
                contacts.append(contact)
                
            }
            
            
            print(contacts.first?.givenName)
            // dispatch_async(dispatch_get_main_queue(), { () -> Void in
            
            socketObj.socket.emit("logClient","\(username) received \(contacts.count) contacts from iphone contactlist")
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
        catch let error as NSError {
            print("errorrrrr ...")
            socketObj.socket.emit("logClient","error: fetching contacts from device \(error.description)")
            print(error.description, separator: "", terminator: "\n")
        }
        
        //return emails
        
    }
    func searchContactsByEmail(emails:[String],completion: (result:[String])->())
    {
        print("emails are \(emails)")
        socketObj.socket.emit("logClient","sending emails to server")
        // %%%%%%%%%%%%%%%%%% new phone model change
        let searchContactsByEmail=Constants.MainUrl+Constants.searchContactsByEmail
        //let searchContactsByEmail=Constants.MainUrl+Constants.searchContactsByEmail+"?access_token="+AuthToken!
        //var s:[String]!
        //var ss:String="["
        for e in emails{
            //ss.appendContentsOf(e)
            print(e)
            
        }
        
        var ssss=emails.debugDescription.stringByReplacingOccurrencesOfString("\\", withString: " ")
        //ss.appendContentsOf("]")
        //emails.description.propertyList()
        //var emailParas=JSON(emails).object
        //dispatch_async(dispatch_get_main_queue(), { () -> Void in
        
        //%%%%%%%%%%%%%%% new phone model change
        //Alamofire.request(.POST,searchContactsByEmail,parameters:["emails":emails],encoding: .JSON).responseJSON { response in
        Alamofire.request(.POST,searchContactsByEmail,headers:header,parameters:["emails":emails],encoding: .JSON).responseJSON { response in
            
            if(response.response?.statusCode==200)
            {socketObj.socket.emit("logClient","success in getting available and not available contacts")
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
            for var i=0;i<NotavailableContactsEmails!.count;i++
            {
                // self.notAvailableContacts[i]=NotavailableContactsEmails![i].rawString()!
                self.notAvailableContacts.append(NotavailableContactsEmails![i].debugDescription)
                print("----------- \(self.notAvailableContacts[i].debugDescription)")
            }
                
                for var i=0;i<availableContactsEmails.count;i++
                {
                    // self.notAvailableContacts[i]=NotavailableContactsEmails![i].rawString()!
                    availableEmailsList.append(availableContactsEmails[i].debugDescription)
                   // print("----------- \(self.notAvailableContacts[i].debugDescription)")
                }
                
                
            print(NotavailableContactsEmails!)
            print("**************** \(self.notAvailableContacts)")
            completion(result: self.notAvailableContacts)
                
                self.delegate?.receivedContactsUpdateUI()
        }
            else
            {
                socketObj.socket.emit("logClient","error: \(response.debugDescription)")
            }
        
        }
        
       
        // })
    }
    func saveToAddressBook(newcontact:[String:String]){
        let contactTemp = CNMutableContact()
        
        contactTemp.imageData = NSData() // The profile picture as a NSData object
        
        contactTemp.givenName = newcontact["fname"]!
        contactTemp.familyName = newcontact["lname"]!
        
        //let homeEmail = CNLabeledValue(label:CNLabelHome, value:"john@example.com")
        let workEmail = CNLabeledValue(label:CNLabelWork, value:newcontact["email"]!)
        //contactTemp.emailAddresses = [homeEmail, workEmail]
        contactTemp.emailAddresses = [workEmail]
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
        saveRequest.addContact(contactTemp, toContainerWithIdentifier:nil)
        do{try store.executeSaveRequest(saveRequest)}
        catch{
            print("cannot save contact to address book. Try again with correct values")
        }
        
    }
    func sendInvite(var emails:[String])
    {
        //emails.append("sumaira.syedsaeed@gmail.com")
        //emails.append("kibo@kibo.com")
        let inviteMultipleURL=Constants.MainUrl+Constants.invitebymultipleemail
        Alamofire.request(.POST,inviteMultipleURL,headers:header,parameters:["emails":emails],encoding: .JSON).responseJSON { response in
            debugPrint(response.data)
            //print(response.request)
            //print(response.response)
            print(response.data)
            //print(response.e
            
            //print(response.result.value!)
            var res=JSON(response.result.value!)
            print("invite sent")
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