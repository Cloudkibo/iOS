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
                /*notificationsMainClass.sharedInstance.addItem(todoItem)
                */
                // schedule a local notification to persist this item
                
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
            //-----------------------
            //-----old conference handlers
            //-----------------------
            socketObj.socket.on("msg"){data,ack in
                
                self.delegateWebRTC.socketReceivedMSGWebRTC("msg", data: data)
                
                print("msg reeived.. check if offer answer or ice")
                
                /*
                
                var msg=JSON(data)
                print(msg[0].description)
                
                if(msg[0]["type"].string! == "offer")
                {
                
                
                /*
                //^^^^^^^^^^^^^^^^newwwww if(joinedRoomInCall == "" && isInitiator.description == "false")
                if(joinedRoomInCall == "")
                {
                print("room joined is null")
                }
                
                print("offer received")
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
                {print("answer received")
                var sessionDescription=RTCSessionDescription(type: msg[0]["type"].description, sdp: msg[0]["sdp"]["sdp"].description)
                self.pc.setRemoteDescriptionWithDelegate(self, sessionDescription: sessionDescription)
                }
                */
                
                }
                if(msg[0]["type"].string! == "ice")
                {print("ice received of other peer")
                /* if(msg[0]["ice"].description=="null")
                {print("last ice as null so ignore")}
                else{
                if(msg[0]["by"].intValue != currentID)
                {var iceCandidate=RTCICECandidate(mid: msg[0]["ice"]["sdpMid"].description, index: msg[0]["ice"]["sdpMLineIndex"].int!, sdp: msg[0]["ice"]["candidate"].description)
                print(iceCandidate.description)
                
                if(self.pc.localDescription != nil && self.pc.remoteDescription != nil)
                
                {var addedcandidate=self.pc.addICECandidate(iceCandidate)
                print("ice candidate added \(addedcandidate)")
                }
                
                }
                }*/
                
                }
                
                */
                
                
            }
            
            
            
            
            ///////////////////////
            /////////////////////////////////////
            socketObj.socket.on("peer.connected"){data,ack in
                print("received peer.connected obj from server")
                self.delegateWebRTC.socketReceivedOtherWebRTC("peer.connected", data: data)
                
                //Both joined same room
                /*
                var datajson=JSON(data!)
                print(datajson.debugDescription)
                
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
                print("peer attached stream")
                
                
                self.pc.createOfferWithDelegate(self, constraints: self.rtcMediaConst!)
                }
                
                */
            }
            
            socketObj.socket.on("conference.stream"){data,ack in
                
                print("received conference.stream obj from server")
                self.delegateWebRTC.socketReceivedOtherWebRTC("conference.stream", data: data)
                var datajson=JSON(data)
                print(datajson.debugDescription)
                /*if(datajson[0]["username"].debugDescription != username! && datajson[0]["type"].debugDescription == "video" && self.rtcVideoTrackReceived != nil)
                {
                print("toggle remote video stream")
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
                print("received peer.stream obj from server")
                var datajson=JSON(data)
                print(datajson.debugDescription)
                
            }
            socketObj.socket.on("peer.disconnected"){data,ack in
                print("received peer.disconnected obj from server")
                var datajson=JSON(data)
                print(datajson.debugDescription)
                
                self.delegateWebRTC.socketReceivedOtherWebRTC("peer.disconnected", data: data)
                
            }
            
            
            
            
            socketObj.socket.on("message"){data,ack in
                print("received messageee11")
                self.delegateWebRTC.socketReceivedMessageWebRTC("message",data: data)
                var msg=JSON(data)
                print(msg.debugDescription)
                
                if(msg[0]["type"]=="room_name")
                {
                    /*
                    ////////////////////////////////////////////////////////////////
                    //////////////^^^^^^^^^^^^^^^^^^^^^^newww isInitiator=false
                    //What to do if already in a room??
                    
                    if(joinedRoomInCall=="")
                    {
                    var CurrentRoomName=msg[0]["room"].string!
                    print("got room name as \(joinedRoomInCall)")
                    print("trying to join room")
                    
                    socketObj.socket.emitWithAck("init", ["room":CurrentRoomName,"username":username!])(timeout: 1500000000) {data in
                    print("room joined got ack")
                    var a=JSON(data!)
                    print(a.debugDescription)
                    currentID=a[1].int!
                    joinedRoomInCall=msg[0]["room"].string!
                    print("current id is \(currentID)")
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
                    print("inside accept call")
                    var roomname=self.randomStringWithLength(9)
                    //iamincallWith=username!
                    self.areYouFreeForCall=false
                    joinedRoomInCall=roomname as String
                    socketObj.socket.emitWithAck("init", ["room":joinedRoomInCall,"username":username!])(timeout: 150000000) {data in
                    print("room joined by got ack")
                    var a=JSON(data!)
                    print(a.debugDescription)
                    currentID=a[1].int!
                    print("current id is \(currentID)")
                    var aa=JSON(["msg":["type":"room_name","room":roomname as String],"room":globalroom,"to":iamincallWith!,"username":username!])
                    print(aa.description)
                    socketObj.socket.emit("message",aa.object)
                    
                    }//end data
                    }*/
                    
                    
                }
                if(msg[0]=="Reject Call")
                {
                    /*
                    print("inside reject call")
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
                    print("hangupppppp received \(msg[0])")
                    
                    print("hangupppppp received \(msg.debugDescription)")
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
            
            
            
            
            //----------------
            //-Webmeeting handlers start here
            //-----------------
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
                print("received peer.disconnected.new obj from server")
                var datajson=JSON(data)
                print(datajson.debugDescription)
                
                self.delegateWebRTC.socketReceivedOtherWebRTC("peer.disconnected.new", data: data)
                
            }
            
            
            socketObj.socket.on("message"){data,ack in
                print("received messageee11")
                self.delegateWebRTC.socketReceivedMessageWebRTC("message",data: data)
                
                
                
            }
            
            socketObj.socket.on("conference.chat"){data,ack in
                print("chat received")
                ///self.delegateWebRTC.socketReceivedOtherWebRTC("conference.chat",data: data)
                var chat=JSON(data)
                webMeetingModel.addChatMsg(chat[0]["message"].description, usr: chat[0]["username"].description)
                
                
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

