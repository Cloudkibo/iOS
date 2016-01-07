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
    var delegate:SocketClientDelegate!
    //var areYouFreeForCall:Bool
    
    
    init(url:String){
        socket=SocketIOClient(socketURL: "\(url)", opts: ["log": false])
        areYouFreeForCall=true
        isBusy=false
        //self.delegate=SocketClientDelegate()
    }
    
    func connect()
    {
        
        self.socket.on("connect") {data, ack in
            NSLog("connected to socket")
            
            
        }
        self.socket.on("disconnect") {data, ack in
            NSLog("disconnected from socket")
            //self.socket.emit("message", ["msg":"hangup"])
            
        }
        //connection.status
        self.socket.on("connection.status") {data, ack in
            NSLog("disconnected from socket")
            println(data?.debugDescription)
           // self.socket.emit("message", ["msg":"hangup"])
            
        }
       /* socket.on("youareonline") {data,ack in
            
            println("you onlineeee \(ack)")
            glocalChatRoomJoined = true
        }*/
        self.socket.connect()
        addHandlers()
        
            }
    
    func addHandlers(){
        
        socketObj.socket.on("theseareonline"){data,ack in
            println("theseareonline ........")
            println(":::::::::::::::::::::::::::::::::::")
            var msg=JSON(data!)
            println(msg.debugDescription)
            self.delegate?.socketReceivedMessage("theseareonline",data: data!)
        }
        socketObj.socket.on("yesiamfreeforcall"){data,ack in
            println("yesiamfreeforcall .......")
            println(":::::::::::::::::::::::::::::::::::")
            var msg=JSON(data!)
            println(msg.debugDescription)
            self.delegate?.socketReceivedMessage("yesiamfreeforcall",data: data!)
        }
        socketObj.socket.on("areyoufreeforcall"){data,ack in
            println("areyoufreeforcall ........")
            println(":::::::::::::::::::::::::::::::::::")
            var msg=JSON(data!)
            println(msg.debugDescription)
            self.delegate?.socketReceivedMessage("areyoufreeforcall",data: data!)
        }
        socketObj.socket.on("offline"){data,ack in
            println("offline ......")
            println(":::::::::::::::::::::::::::::::::::")
            var msg=JSON(data!)
            println(msg.debugDescription)
            self.delegate?.socketReceivedMessage("offline",data: data!)
        }
        
        
        
        ///////////////
        
        socketObj.socket.on("othersideringing"){data,ack in
            println("otherside ringing")
            println(":::::::::::::::::::::::::::::::::::")
            var msg=JSON(data!)
            println(msg.debugDescription)
            self.delegate?.socketReceivedMessage("othersideringing",data: data!)
            
        }
        
        socket.on("youareonline") {data,ack in
            
            println("you onlineeee \(ack)")
            glocalChatRoomJoined = true
        }
        socketObj.socket.on("message"){data,ack in
            println("received messageee")
            var msg=JSON(data!)
            var missedMsg=""
            println(msg.debugDescription)
            var mmm=msg[0].debugDescription
            let start = mmm.startIndex
            let end = find(mmm, ":")
            
            if (end != nil) {
                missedMsg = mmm[start...end!]
                println(missedMsg)
            }
            if(missedMsg == "Missed Call:")
            {println("inside missed notification")
                let todoItem = NotificationItem(otherUserName: "\(iamincallWith!)", message: "you received a mised call", type: "missed call", UUID: "111", deadline: NSDate())
                notificationsMainClass.sharedInstance.addItem(todoItem) // schedule a local notification to persist this item
                
            }
        }
        
        socketObj.socket.on("message"){data,ack in
            println("received messageee")
            var msg=JSON(data!)
            println(msg.debugDescription)
        if(msg[0]["type"]=="Missed")
        {
            let todoItem = NotificationItem(otherUserName: "\(iamincallWith!)", message: "You have received a missed call", type: "missed call", UUID: "111", deadline: NSDate())
            notificationsMainClass.sharedInstance.addItem(todoItem) // schedule a local notification to persist this item
            
        }
        
        }
        

        /*
let todoItem = TodoItem(deadline: deadlinePicker.date, title: titleField.text, UUID: NSUUID().UUIDString)
TodoList.sharedInstance.addItem(todoItem) // schedule a local notification to persist this item
self.navigationController?.popToRootViewControllerAnimated(true) // return to list view*/

       
        
        
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
protocol SocketClientDelegate:class
{
    func socketReceivedMessage(message:String,data:AnyObject!);
    func socketReceivedSpecialMessage(message:String,params:JSON!)
    
    /*
    
    func appClient(client:ChatAppClient,didChangeState state:ChatAppClientState);
    func appClient(client:ChatAppClient,didReceiveLocalVideoTrack localVideoTrack:RTCVideoTrack);
    func appClient(client:ChatAppClient,didReceiveRemoteVideoTrack remoteVideoTrack:RTCVideoTrack);
    func appClient(client:ChatAppClient,didError error:NSError);
    
    //func game(game: DiceGame, didStartNewTurnWithDiceRoll diceRoll: Int)
    */
}

