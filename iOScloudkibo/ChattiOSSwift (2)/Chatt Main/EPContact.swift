//
//  EPContact.swift
//  EPContacts
//
//  Created by Prabaharan Elangovan on 13/10/15.
//  Copyright © 2015 Prabaharan Elangovan. All rights reserved.
//

import UIKit
import Contacts
import SQLite

open class EPContact {
    
    open var firstName: String
    open var lastName: String
    open var company: String
    open var thumbnailProfileImage: UIImage?
    open var profileImage: UIImage?
    open var birthday: Date?
    open var birthdayString: String?
    open var contactId: String?
    open var phoneNumbers = [(phoneNumber: String, phoneLabel: String)]()
    open var emails = [(email: String, emailLabel: String )]()
	
    public init (contact: CNContact) {
        firstName = contact.givenName
        lastName = contact.familyName
        company = contact.organizationName
        contactId = contact.identifier
        
        if let thumbnailImageData = contact.thumbnailImageData {
            thumbnailProfileImage = UIImage(data:thumbnailImageData)
        }
        
        if let imageData = contact.imageData {
            profileImage = UIImage(data:imageData)
        }
        
        if let birthdayDate = contact.birthday {
            
            birthday = Calendar(identifier: Calendar.Identifier.gregorian).date(from: birthdayDate)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = EPGlobalConstants.Strings.birdtdayDateFormat
            //Example Date Formats:  Oct 4, Sep 18, Mar 9
            birthdayString = dateFormatter.string(from: birthday!)
        }
        
        for phoneNumber:CNLabeledValue in contact.phoneNumbers {
            let a = phoneNumber.value as! CNPhoneNumber
            //////////////emails.append(a.valueForKey("digits") as! String)
            var zeroIndex = -1
            var phoneDigits=a.value(forKey: "digits") as! String
            var actualphonedigits=a.value(forKey: "digits") as! String
            
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
            
            if(countrycode != nil){
                if((countrycode=="1") && (phoneDigits.characters.first=="1") && (phoneDigits.characters.first != "+"))
                {
                    phoneDigits = "+"+phoneDigits
                }
                else if(phoneDigits.characters.first != "+"){
                    phoneDigits = "+"+countrycode+phoneDigits
                    print("appended phone is \(phoneDigits)")
                }
                
                
            }
            
            
            // phoneNumbers.append((phone.stringValue,phoneNumber.label))
            phoneNumbers.append((phoneDigits,phoneNumber.label!))
        }
        
        for emailAddress in contact.emailAddresses {
            let email = emailAddress.value as! String
            emails.append((email,emailAddress.label!))
        }
    }
    
    
    public func getPhoneNumber()->String
    {
        return (phoneNumbers.first?.phoneNumber)!
    }
    
    func isKiboContact()->Bool
    {
        var allcontactslist1=sqliteDB.allcontacts
        var alladdressContactsArray:Array<Row>
        
        let phone = Expression<String>("phone")
        let kibocontact = Expression<Bool>("kiboContact")
        let name =
            Expression<String?>("name")
        // if(self.getPhoneNumber() != nil)
        //{
        do{for found in try sqliteDB.db.prepare((allcontactslist1?.filter(phone==self.getPhoneNumber() && kibocontact==true))!)
        {
            print("found contact \(self.getPhoneNumber())")
            return true
            }
        }catch{}
        // }
        return false
        
    }
    
    public func displayName() -> String {
        return "\(firstName) \(lastName)"
    }
  
    
    open func contactInitials() -> String {
        var initials = String()
		
		if let firstNameFirstChar = firstName.characters.first {
			initials.append(firstNameFirstChar)
		}
		
		if let lastNameFirstChar = lastName.characters.first {
			initials.append(lastNameFirstChar)
		}
		
        return initials
    }
    
}
