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
    
    fileprivate init(){}
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

    
    func findContactsOnBackgroundThread (_ completion:@escaping (_ contact:[CNContact]?)->())/*->([CNContact]))*/ {
        print("inside findContactsOnBackgroundThread")
        DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async(execute: { () -> Void in
            
            let keysToFetch = [CNContactFormatter.descriptorForRequiredKeys(for: .fullName),CNContactPhoneNumbersKey] as [Any] //CNContactIdentifierKey
            let fetchRequest = CNContactFetchRequest( keysToFetch: keysToFetch as! [CNKeyDescriptor])
            var contacts = [CNContact]()
            CNContact.localizedString(forKey: CNLabelPhoneNumberiPhone)
            
            if #available(iOS 10.0, *) {
                fetchRequest.mutableObjects = false
            } else {
                // Fallback on earlier versions
            }
            fetchRequest.unifyResults = true
            fetchRequest.sortOrder = .userDefault
            
            let contactStoreID = CNContactStore().defaultContainerIdentifier()
            print("\(contactStoreID)")
            
            
            do {
                
                try CNContactStore().enumerateContacts(with: fetchRequest) { (contact, stop) -> Void in
                    //do something with contact
                    if contact.phoneNumbers.count > 0 {
                        print("inside contactsarray class \(contact.givenName)")
                        contacts.append(contact)
                    }
                    
                }
            } catch let e as NSError {
                print(e.localizedDescription)
            }
            
            DispatchQueue.main.async(execute: { () -> Void in
                 return completion(contacts)
                
            })
        })
    }
}
