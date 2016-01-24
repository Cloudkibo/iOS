//
//  Contact.swift
//  Chat
//
//  Created by Cloudkibo on 24/01/2016.
//  Copyright © 2016 MyAppTemplates. All rights reserved.
//

import Foundation
import Contacts

class iOSContact{
    
    init(){
        
    }
    func fetch(){
    var contacts = [CNContact]()
    let contactStore = CNContactStore()
    //contact.phoneNumbers.first?.la
    //^^^^^^^^^^newwwwww let keys = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactEmailAddressesKey, CNContactBirthdayKey, CNContactImageDataKey]
    
    let keys = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactEmailAddressesKey, CNContactPhoneNumbersKey]
    
    /////let keys = [CNContactFormatter.descriptorForRequiredKeysForStyle(CNContactFormatterStyle.FullName), CNContactEmailAddressesKey, CNContactBirthdayKey, CNContactImageDataKey]
    do {
    /////let contactStore = AppDelegate.getAppDelegate().contactStore
    try contactStore.enumerateContactsWithFetchRequest(CNContactFetchRequest(keysToFetch: keys)) { (contact, pointer) -> Void in
    contacts.append(contact)
    print(contact.givenName)
    let phone=contact.phoneNumbers.first?.value as! CNPhoneNumber
    print(phone.stringValue)
    print(contact.emailAddresses.first!.value)
    //contacts.append(contact)
    
    //  print(contact.
    //if contact.birthday != nil && contact.birthday!.month == self.currentlySelectedMonthIndex {
    //  contacts.append(contact)
    //}
    }
    
    for(var i=0;i<contacts.count;i++){
    
    print(contacts[i].givenName)
    let phone=contacts[i].phoneNumbers.first?.value as! CNPhoneNumber
    print(phone.stringValue)
    print(contacts[i].emailAddresses.first!.value)
    }
    // print(contacts.first?.givenName)
    /*dispatch_async(dispatch_get_main_queue(), { () -> Void in
    //self.delegate.didFetchContacts(contacts)
    self.navigationController?.popViewControllerAnimated(true)
    })*/
    }
    catch let error as NSError {
    print(error.description, separator: "", terminator: "\n")
    }
    
    
    
    }
    
}