//
//  chatMessagesModel.swift
//  kiboApp
//
//  Created by Cloudkibo on 20/07/2016.
//  Copyright © 2016 MyAppTemplates. All rights reserved.
//

import Foundation

class chatMessagesModel
{
    var delegateChatDetailMesage:WebMeetingChatDetailMessageDelegate!
var messages:NSMutableArray!
init()
{
    messages=NSMutableArray()
    
}
func addChatMsg(msg:String,usr:String)
{//["message":message, "type":msgType]
    if(usr != username!)
    {//Message of other user not myself
        messages.addObject(["message":msg,"type":"1","username":usr])
        /*if(self.delegateWebmeetingChat != nil)
        {
            self.delegateWebmeetingChat.receivedChatMessageUpdateUI(msg, username: usr)
        }*/
    }
}
   
}

protocol WebMeetingChatDetailMessageDelegate:class
{
    func receivedChatMessageUpdateUI(message:String,username:String);
}
