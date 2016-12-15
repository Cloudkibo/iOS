//
//  contactsSingletonClass.swift
//  kiboApp
//
//  Created by Cloudkibo on 15/12/2016.
//  Copyright © 2016 MyAppTemplates. All rights reserved.
//

import Foundation
import Contacts

let sharedInstance = contactsSingletonClass()
internal class contactsSingletonClass{
    
    private init(){}
    var contactsArray:[CNContact]?
   
    
    class func getInstance() -> contactsSingletonClass
    {
        return sharedInstance
        
    }
    
    
    
     /*func getContactsArray()->[CNContact]?
    {print("inside getContactsArray")
        if(sharedInstance.contactsArray == nil)
        {
            sharedInstance.findContactsOnBackgroundThread{ (contacts) in
                
                sharedInstance.contactsArray=contacts
                
                return sharedInstance.contactsArray!
            }
            
            
        }
    }*/

    
    func findContactsOnBackgroundThread (completion:(contact:[CNContact]?)->())/*->([CNContact]))*/ {
        print("inside findContactsOnBackgroundThread")
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), { () -> Void in
            
            let keysToFetch = [CNContactFormatter.descriptorForRequiredKeysForStyle(.FullName),CNContactPhoneNumbersKey] //CNContactIdentifierKey
            let fetchRequest = CNContactFetchRequest( keysToFetch: keysToFetch)
            var contacts = [CNContact]()
            CNContact.localizedStringForKey(CNLabelPhoneNumberiPhone)
            
            fetchRequest.mutableObjects = false
            fetchRequest.unifyResults = true
            fetchRequest.sortOrder = .UserDefault
            
            let contactStoreID = CNContactStore().defaultContainerIdentifier()
            print("\(contactStoreID)")
            
            
            do {
                
                try CNContactStore().enumerateContactsWithFetchRequest(fetchRequest) { (contact, stop) -> Void in
                    //do something with contact
                    if contact.phoneNumbers.count > 0 {
                        print("inside contactsarray class \(contact.givenName)")
                        contacts.append(contact)
                    }
                    
                }
            } catch let e as NSError {
                print(e.localizedDescription)
            }
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                 return completion(contact: contacts)
                
            })
        })
    }
}