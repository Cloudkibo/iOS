//
//  LoginAPI.swift
//  Chat
//
//  Created by Cloudkibo on 13/08/2015.
//  Copyright (c) 2015 MyAppTemplates. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import UIKit
import SQLite

enum ChatAppSocketChannelState:NSInteger{
    
    case kARDWebSocketChannelStateClosed
    // State when connection is established but not ready for use.
    case kARDWebSocketChannelStateOpen
    // State when connection is established and registered.
    case kARDWebSocketChannelStateRegistered
    // State when connection encounters a fatal error.
    case kARDWebSocketChannelStateError
    
}

/*
kARDWebSocketChannelStateClosed,
// State when connection is established but not ready for use.
kARDWebSocketChannelStateOpen,
// State when connection is established and registered.
kARDWebSocketChannelStateRegistered,
// State when connection encounters a fatal error.
kARDWebSocketChannelStateError*/

class LoginAPI{
    
    var socket:SocketIOClient
    var areYouFreeForCall:Bool
    var isBusy:Bool
    //var areYouFreeForCall:Bool
    init(url:String){
        socket=SocketIOClient(socketURL: "\(url)", opts: ["log": false])
        areYouFreeForCall=true
        isBusy=false
    }
    func connect()
    {
        
        self.socket.on("connect") {data, ack in
            NSLog("connected to socket")
            
            
        }
        
        self.socket.connect()
        
            }
    
    func addHandlers(){
        socket.on("youareonline") {data,ack in
            
            println("you onlineeee \(ack)")
        }
        
      /*  socket.on("msg") {data,ack in
           
            //println("you onlineeee \(ack)")
            
        }
*/
      
        
        /*
        socket.on("areyoufreeforcall") {data,ack in
            var jdata=JSON(data!)
            println("somebody callinggg  \(data) \(ack)")
            
            if(self.areYouFreeForCall==true)
            {
                println(jdata[0]["caller"].string!)
                println(username!)
                self.socket.emit("yesiamfreeforcall",["mycaller" : jdata[0]["caller"].string!, "me":username!])
                //self.areYouFreeForCall=false
                //self.isBusy=true
                /*var storyBoard = UIStoryboard(name: "Main", bundle: nil)
                storyBoard.instantiateViewControllerWithIdentifier("CallRingingViewController") as! CallRingingViewController
                
*/
                //transition
                self.socket.emit("message","Accept Call")
                
                //show screen
            }
        }
        
        
        self.socket.on("othersideringing") {data,ack in
            var jdata=JSON(data!)
            println("received call as u were free")
        }
        */
    
    }
    
    /*func transition() {
        let secondViewController:CallRingingViewController = CallRingingViewController()
        
      presentViewController(secondViewController, animated: true, completion: nil)
        
    }*/

    func isConnected()->Bool{
        return socket.connected
    }
    
    func getSocket()->SocketIOClient{
        return self.socket
    }
    
    func registerWithRoomId(var roomId:NSString,var clientId:NSString)
    {
        
    }
    func sendMessage(var msg:String,para:[AnyObject]!)
    {
        socket.emit(msg, para)
        println("Socket emitted \(msg) \(para.debugDescription)")
        //ChatAppSocketDelegate.channel(socket,didReceiveMessage:msg)
}
    
    
    func sendMessagesOfMessageType(msg:String)
    {
        println("inside sendMessagesOfMessageType func \(msg)")
        //var str=msg
        //str = msg.stringByReplacingOccurrencesOfString("\\", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
        println(msg)
        //var message:JSON=["msg":msg,"room":globalroom,"to":iamincallWith!,"username":username!]
        
        socket.emit("message",["msg":msg,"room":globalroom,"to":iamincallWith!,"username":username!])
        
        
    }
   
}


protocol ChatAppSocketDelegate
{
    func channel(channel:SocketIOClient ,didChangeState state:ChatAppSocketChannelState);
     func channel(channel:SocketIOClient,didReceiveMessage message:String);
    //socket.on(message
   
}

