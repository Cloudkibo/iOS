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
    /*
    var delegateChatDetailMesage:ChatDetailMessageDelegate!
var messages:NSMutableArray!
init()
{
    messages=NSMutableArray()
    
}
func addMessage(message: String, ofType msgType:String, date:String)
{
        messages.addObject(["message":message, "type":msgType, "date":date])
    self.delegateChatDetailMesage?.receivedChatMessageUpdateUI()
        /*if(self.delegateWebmeetingChat != nil)
        {
            self.delegateWebmeetingChat.receivedChatMessageUpdateUI(msg, username: usr)
        }*/
    
}
   */
}

protocol ChatDetailMessageDelegate:class
{
    func receivedChatMessageUpdateUI();
}
