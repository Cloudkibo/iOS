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
    var delegateWebRTC:SocketClientDelegateWebRTC!
    var delegateWebRTCVideo:SocketClientDelegateWebRTCVideo!
    //var areYouFreeForCall:Bool
    
    
    init(url:String){
        socket=SocketIOClient(socketURL: "\(url)", options: ["log": false])
        areYouFreeForCall=true
        isBusy=false
        self.socket.connect()
        //self.delegate=SocketClientDelegate()
    }
    /*
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
            print(data?.debugDescription)
           // self.socket.emit("message", ["msg":"hangup"])
            
        }
       /* socket.on("youareonline") {data,ack in
            
            print("you onlineeee \(ack)")
            glocalChatRoomJoined = true
        }*/
        //self.socket.connect()
        //addHandlers()
        
            }
*/
    
    func addHandlers(){
        print("adding socket handlerssss", terminator: "")
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
            print(data.debugDescription)
            // self.socket.emit("message", ["msg":"hangup"])
            
        }
        
        socketObj.socket.on("theseareonline"){data,ack in
            print("theseareonline ........")
            print(":::::::::::::::::::::::::::::::::::")
            var msg=JSON(data)
            print(msg.debugDescription)
            self.delegate?.socketReceivedMessage("theseareonline",data: data)
        }
        socketObj.socket.on("yesiamfreeforcall"){data,ack in
            print("yesiamfreeforcall .......")
            print(":::::::::::::::::::::::::::::::::::")
            var msg=JSON(data)
            print(msg.debugDescription)
            self.delegate?.socketReceivedMessage("yesiamfreeforcall",data: data)
        }
        socketObj.socket.on("areyoufreeforcall"){data,ack in
            print("areyoufreeforcall ........")
            print(":::::::::::::::::::::::::::::::::::")
            var msg=JSON(data)
            print(msg.debugDescription)
            self.delegate?.socketReceivedMessage("areyoufreeforcall",data: data)
        }
        socketObj.socket.on("offline"){data,ack in
            print("offline ......")
            print(":::::::::::::::::::::::::::::::::::")
            var msg=JSON(data)
            print(msg.debugDescription)
            self.delegate?.socketReceivedMessage("offline",data: data)
        }
        
        
        
        ///////////////
        
        socketObj.socket.on("othersideringing"){data,ack in
            print("otherside ringing")
            print(":::::::::::::::::::::::::::::::::::")
            let msg=JSON(data)
            print(msg.debugDescription)
            self.delegate?.socketReceivedMessage("othersideringing",data: data)
            
        }
        
        socket.on("youareonline") {data,ack in
            
            print("you onlineeee \(ack)")
            glocalChatRoomJoined = true
        }
        socketObj.socket.on("message"){data,ack in
            print("received messageee")
            var msg=JSON(data)
            var missedMsg=""
            print(msg.debugDescription)
            let mmm=msg[0].debugDescription
            let start = mmm.startIndex
            let char:Character=":"
            let end=mmm.characters.indexOf(char)
            ////////^^^^^^newww let end = find(mmm, ":")
            
            if (end != nil) {
                missedMsg = mmm[start...end!]
                print(missedMsg)
            }
            if(missedMsg == "Missed Call:")
            {print("inside missed notification")
                let todoItem = NotificationItem(otherUserName: "\(iamincallWith!)", message: "you received a mised call", type: "missed call", UUID: "111", deadline: NSDate())
                notificationsMainClass.sharedInstance.addItem(todoItem) // schedule a local notification to persist this item
                
            }
        }
        
       /* socketObj.socket.on("message"){data,ack in
            print("received messageee")
            var msg=JSON(data)
            print(msg.debugDescription)
        if(msg[0]["type"]=="Missed")
        {
            let todoItem = NotificationItem(otherUserName: "\(iamincallWith!)", message: "You have received a missed call", type: "missed call", UUID: "111", deadline: NSDate())
            notificationsMainClass.sharedInstance.addItem(todoItem) // schedule a local notification to persist this item
            
        }
        
        }*/
    }
    
        
        func addWebRTCHandlers()
        {
            socketObj.socket.on("msgAudio"){data,ack in
                
                self.delegateWebRTC.socketReceivedMSGWebRTC("msgAudio", data: data)
                
                print("msgAudio reeived.. check if offer answer or ice")
 
                
                
            }
            
           /* socketObj.socket.on("msgVideo"){data,ack in
                
                self.delegateWebRTC.socketReceivedMSGWebRTC("msgVideo", data: data)
                
                print("msgVideo reeived.. check if offer answer or ice")
                
                
                
            }*/
            
            
            socketObj.socket.on("peer.connected.new"){data,ack in
                print("received peer.connected.new obj from server")
                self.delegateWebRTC.socketReceivedOtherWebRTC("peer.connected.new", data: data)
                
                //Both joined same room
            }
            
            socketObj.socket.on("conference.stream"){data,ack in
                
                print("received conference.stream obj from server")
                self.delegateWebRTC.socketReceivedOtherWebRTC("conference.stream", data: data)
                
            }
            /*socketObj.socket.on("conference.streamVideo"){data,ack in
                
                print("received conference.streamVideo obj from server")
                self.delegateWebRTC.socketReceivedOtherWebRTC("conference.streamVideo", data: data)
                
            }*/
            
            /*socketObj.socket.on("peer.stream"){data,ack in
                print("received peer.stream obj from server")
                var datajson=JSON(data)
                print(datajson.debugDescription)
                
            }
*/
            socketObj.socket.on("peer.disconnected.new"){data,ack in
                print("received peer.disconnected obj from server")
                var datajson=JSON(data)
                print(datajson.debugDescription)
                
                self.delegateWebRTC.socketReceivedOtherWebRTC("peer.disconnected.new", data: data)
                
            }
            
            
            socketObj.socket.on("message"){data,ack in
                print("received messageee11")
                self.delegateWebRTC.socketReceivedMessageWebRTC("message",data: data)
                
                
                
            }

            //conference.streamVideo
        }
    
    
    
    func addWebRTCHandlersVideo()
    {
        
        socketObj.socket.on("msgVideo"){data,ack in
            
           // self.delegateWebRTCVideo.socketReceivedMSGWebRTCVideo("msgVideo", data: data)
            
            print("msgVideo reeived.. check if offer answer or ice")
            
            
            
        }
        
        
        socketObj.socket.on("peer.connected.new"){data,ack in
            print("received peer.connected.new obj from server")
            //self.delegateWebRTCVideo.socketReceivedOtherWebRTCVideo("peer.connected.new", data: data)
            
            //Both joined same room
        }
        
       
        socketObj.socket.on("conference.streamVideo"){data,ack in
            
            print("received conference.streamVideo obj from server")
            //self.delegateWebRTCVideo.socketReceivedOtherWebRTCVideo("conference.streamVideo", data: data)
            
        }
        
        /*socketObj.socket.on("peer.stream"){data,ack in
        print("received peer.stream obj from server")
        var datajson=JSON(data)
        print(datajson.debugDescription)
        
        }
        */
        socketObj.socket.on("peer.disconnected.new"){data,ack in
            print("received peer.disconnected obj from server")
            var datajson=JSON(data)
            print(datajson.debugDescription)
            
           // self.delegateWebRTCVideo.socketReceivedOtherWebRTCVideo("peer.disconnected.new", data: data)
            
        }
        
        
        socketObj.socket.on("message"){data,ack in
            print("received messageee11")
           // self.delegateWebRTCVideo.socketReceivedMessageWebRTCVideo("message",data: data)
            
            
            
        }
        
        //conference.streamVideo
    }


    func getSocket()->SocketIOClient {
        return self.socket
    }
    
    func registerWithRoomId(roomId:NSString,clientId:NSString)
    {
        
    }
    func sendMessage(msg:String,para:[AnyObject]!)
    {
        socket.emit(msg, para)
        print("Socket emitted \(msg) \(para.debugDescription)", terminator: "")
        //ChatAppSocketDelegate.channel(socket,didReceiveMessage:msg)
}
    
    
    func sendMessagesOfMessageType(msg:String)
    {
        print("inside sendMessagesOfMessageType func \(msg)", terminator: "")
        //var str=msg
        //str = msg.stringByReplacingOccurrencesOfString("\\", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
        print(msg, terminator: "")
        //var message:JSON=["msg":msg,"room":globalroom,"to":iamincallWith!,"username":username!]
        
        //////////////////////////socket.emit("message",["msg":msg,"room":globalroom,"to":iamincallWith!,"username":username!])
        
        socket.emit("message",["msgAudio":msg,"room":globalroom,"to":iamincallWith!,"username":username!])
        
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
protocol SocketClientDelegateWebRTC:class
{
    func socketReceivedMSGWebRTC(message:String,data:AnyObject!);
    func socketReceivedOtherWebRTC(message:String,data:AnyObject!);
    func socketReceivedMessageWebRTC(message:String,data:AnyObject!);
    
    
}

protocol SocketClientDelegateWebRTCVideo:class
{
    func socketReceivedMSGWebRTCVideo(message:String,data:AnyObject!);
    func socketReceivedOtherWebRTCVideo(message:String,data:AnyObject!);
    func socketReceivedMessageWebRTCVideo(message:String,data:AnyObject!);
    
    
}

