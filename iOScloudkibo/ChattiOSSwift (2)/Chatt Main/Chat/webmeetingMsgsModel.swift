//
//  webmeetingMsgsModel.swift
//  Chat
//
//  Created by Cloudkibo on 16/02/2016.
//  Copyright © 2016 MyAppTemplates. All rights reserved.
//

import Foundation

class webmeetingMsgsModel{
    
    public var delegateWebmeetingChat:WebMeetingChatDelegate!
    var messages:NSMutableArray!
    init()
    {
        messages=NSMutableArray()
        
    }
    func addChatMsg(msg:String,usr:String)
    {//["message":message, "type":msgType]
        if(usr != username!)
        {//Message of other user not myself
        messages.addObject(["message":msg,"type":"1"])
            print("callingreceivedchat")
           self.delegateWebmeetingChat?.receivedChatMessageUpdateUI()
        }
    }
   
}
protocol WebMeetingChatDelegate:class
{
    //func receivedChatMessageUpdateUI(message:String,username:String);
    func receivedChatMessageUpdateUI();
}
