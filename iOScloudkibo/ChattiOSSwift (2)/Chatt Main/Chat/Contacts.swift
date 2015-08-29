//
//  Contacts.swift
//  Chat
//
//  Created by Cloudkibo on 28/08/2015.
//  Copyright (c) 2015 MyAppTemplates. All rights reserved.
//

import Foundation

class Contacts{
    var userid:String=""
    var contactid:String=""
    var unreadMessage:Bool=false
    var detailsshared:String=""

    init(userid:String,contactid:String,detailsshared:String){
        self.userid=userid
        self.contactid=contactid
        self.detailsshared=detailsshared
       
    }
    
    
}