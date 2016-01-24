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
    var contacts = [CNContact]()
    var keys:[String]
    //var emails=[String]()
    init(keys:[String]){
        self.keys=keys
    }
    
    func fetch(){
    
    let contactStore = CNContactStore()
     
    keys = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactEmailAddressesKey, CNContactPhoneNumbersKey]
    do {
    /////let contactStore = AppDelegate.getAppDelegate().contactStore
    try contactStore.enumerateContactsWithFetchRequest(CNContactFetchRequest(keysToFetch: keys)) { (contact, pointer) -> Void in
    self.contacts.append(contact)
    
    }
    
    
     print(contacts.first?.givenName)
    dispatch_async(dispatch_get_main_queue(), { () -> Void in
        
        var emails=[String]()
        for(var i=0;i<self.contacts.count;i++){
            
            print(self.contacts[i].givenName)
            let phone=self.contacts[i].phoneNumbers.first?.value as! CNPhoneNumber
            print(phone.stringValue)
            let em=self.contacts[i].emailAddresses.first
            print(em?.label)
            print(em?.value)
            emails.append(em!.value as! String)
            //print(self.contacts[i].emailAddresses.first!.value)
            ////self.emails.append(phone.stringValue)
           // print(self.emails[i])
        }
        self.searchContactsByEmail(emails)
        
    //self.delegate.didFetchContacts(contacts)
    //self.navigationController?.popViewControllerAnimated(true)
    })
        
    }
    catch let error as NSError {
    print(error.description, separator: "", terminator: "\n")
    }
    
    
    
    }
    func searchContactsByEmail(emails:[String])
    { let searchContactsByEmail=Constants.MainUrl+Constants.searchContactsByEmail+"?access_token="+AuthToken!
        //var s:[String]!
        for e in emails{
          print(e)
        }
        
        //dispatch_async(dispatch_get_main_queue(), { () -> Void in
        Alamofire.request(.POST,searchContactsByEmail,parameters: ["emails":"kibo@kibo.com"]).responseJSON { response in
           debugPrint(response)
            /* print(response.request)
            print(response.response)
            print(response.data?.description)
            //print(response.e
            var res=JSON(response.data!.debugDescription)
            print(res)*/
        }
        // })
    }
    
}