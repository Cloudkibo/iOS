//
//  webmeetingMsgsModel.swift
//  Chat
//
//  Created by Cloudkibo on 16/02/2016.
//  Copyright © 2016 MyAppTemplates. All rights reserved.
//

import Foundation

class webmeetingMsgsModel{
    
    var delegateSendScreenshotDataChannel:DelegateSendScreenshotDelegate!
    var delegateWebmeetingChat:WebMeetingChatDelegate!
    var delegateScreen:AppDelegateScreenDelegate!
    
    var messages:NSMutableArray!
    init()
    {
        messages=NSMutableArray()
        
    }
    func addChatMsg(_ msg:String,usr:String)
    {//["message":message, "type":msgType]
        if(usr != username!)
        {//Message of other user not myself
        messages.add(["message":msg,"type":"1","username":usr])
            if(self.delegateWebmeetingChat != nil)
            {
            self.delegateWebmeetingChat.receivedChatMessageUpdateUI(msg, username: usr)
            }
        }
    }
   
}
protocol WebMeetingChatDelegate:class
{
    func receivedChatMessageUpdateUI(_ message:String,username:String);
}
protocol DelegateSendScreenshotDelegate:class
{
    func sendImageFromDataChannel(_ screenshot:UIImage!);
}
protocol AppDelegateScreenDelegate:class
{
    func screenCapture();
}
