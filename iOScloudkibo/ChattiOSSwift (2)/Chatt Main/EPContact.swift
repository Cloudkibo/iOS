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
public class EPContact: NSObject {
    
    public var firstName: NSString!
    public var lastName: NSString!
    public var company: NSString!
    public var thumbnailProfileImage: UIImage?
    public var profileImage: UIImage?
    public var birthday: NSDate?
    public var birthdayString: String?
    public var contactId: String?
    public var phoneNumbers = [(phoneNumber: String, phoneLabel: String)]()
    public var emails = [(email: String, emailLabel: String )]()
    
    override init() {
        super.init()
    }
    
    public init (contact: CNContact)
    {
        super.init()
        
        //VERY IMPORTANT: Make sure you have all the keys accessed below in the fetch request
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
            
            birthday = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)?.dateFromComponents(birthdayDate)
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = EPGlobalConstants.Strings.birdtdayDateFormat
            //Example Date Formats:  Oct 4, Sep 18, Mar 9
            birthdayString = dateFormatter.stringFromDate(birthday!)
        }
        
      //  for phoneNumber in contact.phoneNumbers {
        //    let phone = phoneNumber.value as! CNPhoneNumber
            
            for phoneNumber:CNLabeledValue in contact.phoneNumbers {
                let a = phoneNumber.value as! CNPhoneNumber
                //////////////emails.append(a.valueForKey("digits") as! String)
                var zeroIndex = -1
                var phoneDigits=a.valueForKey("digits") as! String
                var actualphonedigits=a.valueForKey("digits") as! String
           
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
                
             
                    if(countrycode=="1" && phoneDigits.characters.first=="1" && phoneDigits.characters.first != "+")
                    {
                        phoneDigits = "+"+phoneDigits
                    }
                    else if(phoneDigits.characters.first != "+"){
                        phoneDigits = "+"+countrycode+phoneDigits
                        print("appended phone is \(phoneDigits)")
                    }

               
             
                
                
           // phoneNumbers.append((phone.stringValue,phoneNumber.label))
                phoneNumbers.append((phoneDigits,phoneNumber.label))
        }

        for emailAddress in contact.emailAddresses {
            let email = emailAddress.value as! String
            emails.append((email,emailAddress.label))
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
        do{for found in try sqliteDB.db.prepare(allcontactslist1.filter(phone==self.getPhoneNumber() && kibocontact==true))
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
    
    public func contactInitials() -> String {
        var initials = String()
        if firstName.length > 0 {
            initials.appendContentsOf(firstName.substringToIndex(1))
        }
        if lastName.length > 0 {
            initials.appendContentsOf(lastName.substringToIndex(1))
        }
        return initials
    }
    
}
