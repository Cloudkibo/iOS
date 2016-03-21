//
//  webmeetingMsgsModel.swift
//  Chat
//
//  Created by Cloudkibo on 16/02/2016.
//  Copyright © 2016 MyAppTemplates. All rights reserved.
//

import Foundation

class webmeetingMsgsModel{
    
    var messages:NSMutableArray!
    init()
    {
        messages=NSMutableArray()
        
    }
    func addChatMsg(msg:String,usr:String)
    {
        messages.addObject(["message":msg,"username":usr])
    }
}
