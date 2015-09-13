//
//  Constants.swift
//  Chat
//
//  Created by Cloudkibo on 14/08/2015.
//  Copyright (c) 2015 MyAppTemplates. All rights reserved.
//

import Foundation
class Constants{
    
    static let MainUrl="https://www.cloudkibo.com"
    static let authentictionUrl="/auth/local/"
    static let bringUserChat="/api/userchat/"
    static let getCurrentUser="/api/users/me"
    static let getContactsList="/api/contactslist/"
    static let room="globalchatroom"
    
    static let addContactByUsername="/api/contactslist/addbyusername"
    static let addContactByEmail="/api/contactslist/addbyemail"
    static let markAsRead="/api/userchat/markasread"
    static let getSingleUserByID="/api/users/" //send if along
    
}