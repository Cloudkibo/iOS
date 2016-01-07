//
//  notifications.swift
//  Chat
//
//  Created by Cloudkibo on 30/12/2015.
//  Copyright (c) 2015 MyAppTemplates. All rights reserved.
//

import Foundation
struct NotificationItem {
    var type:String
    var message: String
    var otherUserName:String
    var deadline: NSDate
    var UUID: String
    
    init(otherUserName: String, message: String, type:String, UUID: String,deadline:NSDate) {
        self.otherUserName = otherUserName
        self.message = message
        self.UUID = UUID
        self.type=type
        self.deadline=deadline
    }
}