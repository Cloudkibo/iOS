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
    //var areYouFreeForCall:Bool
    
    
    init(url:String){
        socket=SocketIOClient(socketURL: "\(url)", opts: ["log": false])
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
            println(data?.debugDescription)
           // self.socket.emit("message", ["msg":"hangup"])
            
        }
       /* socket.on("youareonline") {data,ack in
            
            println("you onlineeee \(ack)")
            glocalChatRoomJoined = true
        }*/
        //self.socket.connect()
        //addHandlers()
        
            }
*/
    
    func addHandlers(){
        println("adding socket handlerssss")
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
        
       /* socketObj.socket.on("message"){data,ack in
            println("received messageee")
            var msg=JSON(data!)
            println(msg.debugDescription)
        if(msg[0]["type"]=="Missed")
        {
            let todoItem = NotificationItem(otherUserName: "\(iamincallWith!)", message: "You have received a missed call", type: "missed call", UUID: "111", deadline: NSDate())
            notificationsMainClass.sharedInstance.addItem(todoItem) // schedule a local notification to persist this item
            
        }
        
        }*/
    }
    
        
        func addWebRTCHandlers()
        {
            socketObj.socket.on("msg"){data,ack in
                
                self.delegateWebRTC.socketReceivedMSGWebRTC("msg", data: data!)
                
                println("msg reeived.. check if offer answer or ice")
                
                /*
                
                var msg=JSON(data!)
                println(msg[0].description)
                
                if(msg[0]["type"].string! == "offer")
                {
                    
                    
                    /*
                    //^^^^^^^^^^^^^^^^newwwww if(joinedRoomInCall == "" && isInitiator.description == "false")
                    if(joinedRoomInCall == "")
                    {
                        println("room joined is null")
                    }
                    
                    println("offer received")
                    //var sdpNew=msg[0]["sdp"].object
                    if(self.pc == nil) //^^^^^^^^^^^^^^^^^^newwwww tryyy
                    {
                        self.createPeerConnectionObject()
                    }
                    //^^^^^^^^^^^^^^^^^^ check this for second call already have localstream
                    
                    self.addLocalMediaStreamToPeerConnection()
                    
                    
                    //^^^^^^^^^^^^^^^^^^^^^^^newwwwww self.pc.addStream(self.getLocalMediaStream())
                    otherID=msg[0]["by"].int!
                    currentID=msg[0]["to"].int!
                    
                    if(msg[0]["username"].description != username! && self.pc.remoteDescription == nil){
                        var sessionDescription=RTCSessionDescription(type: msg[0]["type"].description, sdp: msg[0]["sdp"]["sdp"].description)
                        self.pc.setRemoteDescriptionWithDelegate(self, sessionDescription: sessionDescription)
                    }
                    */
                }
                
                if(msg[0]["type"].string! == "answer" && msg[0]["by"].int != currentID)
                {
                    /*
                    if(isInitiator.description == "true" && self.pc.remoteDescription == nil)
                    {println("answer received")
                        var sessionDescription=RTCSessionDescription(type: msg[0]["type"].description, sdp: msg[0]["sdp"]["sdp"].description)
                        self.pc.setRemoteDescriptionWithDelegate(self, sessionDescription: sessionDescription)
                    }
*/
                    
                }
                if(msg[0]["type"].string! == "ice")
                {println("ice received of other peer")
                   /* if(msg[0]["ice"].description=="null")
                    {println("last ice as null so ignore")}
                    else{
                        if(msg[0]["by"].intValue != currentID)
                        {var iceCandidate=RTCICECandidate(mid: msg[0]["ice"]["sdpMid"].description, index: msg[0]["ice"]["sdpMLineIndex"].int!, sdp: msg[0]["ice"]["candidate"].description)
                            println(iceCandidate.description)
                            
                            if(self.pc.localDescription != nil && self.pc.remoteDescription != nil)
                                
                            {var addedcandidate=self.pc.addICECandidate(iceCandidate)
                                println("ice candidate added \(addedcandidate)")
                            }

                        }
                    }*/
                    
                }
                
                */
                
                
            }
            
            
            
            
            ///////////////////////
            /////////////////////////////////////
            socketObj.socket.on("peer.connected"){data,ack in
                println("received peer.connected obj from server")
                self.delegateWebRTC.socketReceivedOtherWebRTC("peer.connected", data: data!)
                
                //Both joined same room
                /*
                var datajson=JSON(data!)
                println(datajson.debugDescription)
                
                if(datajson[0]["username"].description != username!){
                    otherID=datajson[0]["id"].int
                    iamincallWith=datajson[0]["username"].description
                    isInitiator=true
                    iamincallWith = datajson[0]["username"].description
                    
                    
                    //////optional
                    if(self.pc == nil) //^^^^^^^^^^^^^^^^^^newwww tryyy
                    {                         self.createPeerConnectionObject()
                    }
                    
                    self.addLocalMediaStreamToPeerConnection()
                    //^^^^^^^^^^^^^^^^^^newwwww self.pc.addStream(self.rtcLocalMediaStream)
                    println("peer attached stream")
                   
                    
                    self.pc.createOfferWithDelegate(self, constraints: self.rtcMediaConst!)
                }
                
                */
            }
            
            socketObj.socket.on("conference.stream"){data,ack in
                
                println("received conference.stream obj from server")
                self.delegateWebRTC.socketReceivedOtherWebRTC("conference.stream", data: data!)
                var datajson=JSON(data!)
                println(datajson.debugDescription)
                /*if(datajson[0]["username"].debugDescription != username! && datajson[0]["type"].debugDescription == "video" && self.rtcVideoTrackReceived != nil)
                {
                    println("toggle remote video stream")
                    ////////////self.rtcVideoTrackReceived.setEnabled((datajson[0]["action"].bool!))
                    if(datajson[0]["action"].bool! == false)
                    {
                        self.localView.hidden=true
                        self.remoteView.hidden=true
                    }
                    if(datajson[0]["action"].bool! == true)
                    {
                        self.localView.hidden=true
                        self.remoteView.hidden=false
                    }
                }
                
                */
                
            }
            
            socketObj.socket.on("peer.stream"){data,ack in
                println("received peer.stream obj from server")
                var datajson=JSON(data!)
                println(datajson.debugDescription)
                
            }
            socketObj.socket.on("peer.disconnected"){data,ack in
                println("received peer.disconnected obj from server")
                var datajson=JSON(data!)
                println(datajson.debugDescription)
                
            }
            
            
            
            
            socketObj.socket.on("message"){data,ack in
                println("received messageee11")
                self.delegateWebRTC.socketReceivedMessageWebRTC("message",data: data!)
                var msg=JSON(data!)
                println(msg.debugDescription)
                
                if(msg[0]["type"]=="room_name")
                {
                    /*
                    ////////////////////////////////////////////////////////////////
                    //////////////^^^^^^^^^^^^^^^^^^^^^^newww isInitiator=false
                    //What to do if already in a room??
                    
                    if(joinedRoomInCall=="")
                    {
                        var CurrentRoomName=msg[0]["room"].string!
                        println("got room name as \(joinedRoomInCall)")
                        println("trying to join room")
                        
                        socketObj.socket.emitWithAck("init", ["room":CurrentRoomName,"username":username!])(timeout: 1500000000) {data in
                            println("room joined got ack")
                            var a=JSON(data!)
                            println(a.debugDescription)
                            currentID=a[1].int!
                            joinedRoomInCall=msg[0]["room"].string!
                            println("current id is \(currentID)")
                            //}
                        }}
                        ////////////////////////newwwwwww
                    else
                    {
                        isInitiator = false
                    }
                    */
                }
                if(msg[0]=="Accept Call")
                {/*
                    if(joinedRoomInCall == "")
                    {
                        println("inside accept call")
                        var roomname=self.randomStringWithLength(9)
                        //iamincallWith=username!
                        self.areYouFreeForCall=false
                        joinedRoomInCall=roomname as String
                        socketObj.socket.emitWithAck("init", ["room":joinedRoomInCall,"username":username!])(timeout: 150000000) {data in
                            println("room joined by got ack")
                            var a=JSON(data!)
                            println(a.debugDescription)
                            currentID=a[1].int!
                            println("current id is \(currentID)")
                            var aa=JSON(["msg":["type":"room_name","room":roomname as String],"room":globalroom,"to":iamincallWith!,"username":username!])
                            println(aa.description)
                            socketObj.socket.emit("message",aa.object)
                            
                        }//end data
                    }*/
                    
                    
                  }
                if(msg[0]=="Reject Call")
                {
                    /*
                    println("inside reject call")
                    var roomname=""
                    iamincallWith=""
                    self.areYouFreeForCall=true
                    callerName=""
                    joinedRoomInCall=""
                    if(self.pc != nil)
                    {self.pc.close()}
                    self.dismissViewControllerAnimated(true, completion: nil)
*/
                    
                }
                
                
                if(msg[0]=="hangup")
                {
                    /*if(self.pc != nil)
                    {
                        println("hangupppppp received \(msg[0])")
                        
                        println("hangupppppp received \(msg.debugDescription)")
                        self.remoteDisconnected()
                        
                        
                        socketObj.socket.emit("leave",["room":joinedRoomInCall])
                        self.disconnect()
                    }*/
                    
                }
                
                /*if(msg[0]["type"]=="Missed")
                {
                    let todoItem = NotificationItem(otherUserName: "\(iamincallWith!)", message: "You have received a missed call", type: "missed call", UUID: "111", deadline: NSDate())
                    notificationsMainClass.sharedInstance.addItem(todoItem) // schedule a local notification to persist this item
                    
                }
                */
                
                
                
                
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
protocol SocketClientDelegateWebRTC:class
{
    func socketReceivedMSGWebRTC(message:String,data:AnyObject!);
    func socketReceivedOtherWebRTC(message:String,data:AnyObject!);
    func socketReceivedMessageWebRTC(message:String,data:AnyObject!);
    
    
}

