//
//  FileTransferWebRTCclient.swift
//  kiboApp
//
//  Created by Cloudkibo on 19/07/2016.
//  Copyright © 2016 MyAppTemplates. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import Foundation
import SwiftyJSON
import MobileCoreServices

class FileTransferWebRTCclient:NSObject,RTCPeerConnectionDelegate,RTCSessionDescriptionDelegate,SocketClientDelegateWebRTC{
    
    
    var iaminmeetingWith:String!=""
    var ConferenceRoomNameNew = ""
    var meetingRoomName=""
    var currentIDnew:Int! = -1
    
    var iOSstartedCall=false
    var pc:RTCPeerConnection! = nil
    var myfid=0
    var fid:Int!=0
    var bytesarraytowrite:Array<UInt8>!
    var jsonnnn:Dictionary<String, AnyObject>!
    var numberOfChunksReceived:Int=0
    var fu=FileUtility()
    var filePathImage:String!
    ////** new commented april 2016var fileSize:Int!
    var fileContents:NSData!
    var chunknumbertorequest:Int=0
    var numberOfChunksInFileToSave:Double=0
    var filePathReceived:String!
    var fileSizeReceived:Int!
    var fileContentsReceived:NSData!
    
    var newjson:JSON!
    var myJSONdata:JSON!
    var chunknumber:Int!
    var strData:String!
    
    var fileTransferCompleted=false
    override init()
    {
        var mainICEServerURL:NSURL=NSURL(fileURLWithPath: Constants.MainUrl)
        
        
        rtcICEarray.append(RTCICEServer(URI: NSURL(string:"turn:45.55.232.65:3478?transport=udp"), username: "cloudkibo", password: "cloudkibo"))
        rtcICEarray.append(RTCICEServer(URI: NSURL(string:"turn:45.55.232.65:3478?transport=tcp"), username: "cloudkibo", password: "cloudkibo"))
        rtcICEarray.append(RTCICEServer(URI: NSURL(string:"stun:stun.l.google.com:19302"), username: "", password: ""))
        rtcICEarray.append(RTCICEServer(URI: NSURL(string:"stun:23.21.150.121"), username: "", password: ""))
        rtcICEarray.append(RTCICEServer(URI: NSURL(string:"stun:stun.anyfirewall.com:3478"), username: "", password: ""))
        rtcICEarray.append(RTCICEServer(URI: NSURL(string:"turn:turn.bistri.com:80?transport=udp"), username: "homeo", password: "homeo"))
        rtcICEarray.append(RTCICEServer(URI: NSURL(string:"turn:turn.bistri.com:80?transport=tcp"), username: "homeo", password: "homeo"))
        rtcICEarray.append(RTCICEServer(URI: NSURL(string:"turn:turn.anyfirewall.com:443?transport=tcp"), username: "webrtc", password: "webrtc"))
    }
    
    func randomStringWithLength (len : Int) -> NSString {
        
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        
        let randomString : NSMutableString = NSMutableString(capacity: len)
        
        for (var i=0; i < len; i++){
            let length = UInt32 (letters.length)
            let rand = arc4random_uniform(length)
            randomString.appendFormat("%C", letters.characterAtIndex(Int(rand)))
        }
        
        return randomString
    }
    
    
    
    func joinRoom(roonName:String)
    {
        if(self.iOSstartedCall==true){
            var roomname=self.randomStringWithLength(9) as String
            //joinedRoomInCall=roomname as String
            self.ConferenceRoomNameNew=roomname
            socketObj.socket.emit("logClient","IPHONE-LOG: \(username) is trying to join room \(self.ConferenceRoomNameNew)")
            areYouFreeForCall=false
            //}
            //iamincallWith=username!
            
            //joinedRoomInCall=roomname as String
            //socketObj.socket.emitWithAck("init", ["room":ConferenceRoomName,"username":username!])(timeoutAfter: 1500000) {data in
            
            socketObj.socket.emitWithAck("init", ["room":self.meetingRoomName,"username":username!])(timeoutAfter: 1500000) {data in
                
                meetingStarted=true
                print("1-1 call room joined by got ack")
                var a=JSON(data)
                socketObj.socket.emit("logClient","IPHONE-LOG: \(username!) joined room\(self.meetingRoomName) and got id \(a[1].int!) , also \(a.debugDescription)")
                print(a.debugDescription)
                self.currentIDnew=a[1].int!
                print("current id is \(self.currentIDnew)")
                //var aa=JSON(["msg":["type":"room_name","room":ConferenceRoomName as String],"room":globalroom,"to":iamincallWith!,"username":username!])
                
                var aa=JSON(["msg":["type":"room_name","room":self.ConferenceRoomNameNew as String],"room":globalroom,"to":self.iaminmeetingWith!,"username":username!])
                
                print(aa.description)
                socketObj.socket.emit("logClient","IPHONE-LOG: \(aa.object)")
                socketObj.socket.emit("message",aa.object)
                
            }
        }
    }
    func peerConnectionOnRenegotiationNeeded(peerConnection: RTCPeerConnection!) {
        
        
    }
    
    func peerConnection(peerConnection: RTCPeerConnection!, addedStream stream: RTCMediaStream!) {
        
        
    }
    
    func peerConnection(peerConnection: RTCPeerConnection!, removedStream stream: RTCMediaStream!) {
        
        
    }
    
    func peerConnection(peerConnection: RTCPeerConnection!, gotICECandidate candidate: RTCICECandidate!) {
        
        
    }
    
    func peerConnection(peerConnection: RTCPeerConnection!, didOpenDataChannel dataChannel: RTCDataChannel!) {
        
        
    }
   
    func peerConnection(peerConnection: RTCPeerConnection!, didSetSessionDescriptionWithError error: NSError!) {
        
        
    }
   
    func peerConnection(peerConnection: RTCPeerConnection!, iceGatheringChanged newState: RTCICEGatheringState) {
        
        
    }
 
    func peerConnection(peerConnection: RTCPeerConnection!, iceConnectionChanged newState: RTCICEConnectionState) {
        
        
    }
    
    func peerConnection(peerConnection: RTCPeerConnection!, signalingStateChanged stateChanged: RTCSignalingState) {
        
        
    }
    
    func peerConnection(peerConnection: RTCPeerConnection!, didCreateSessionDescription sdp: RTCSessionDescription!, error: NSError!) {
        
        
    }
    func socketReceivedMSGWebRTC(message: String, data: AnyObject!) {
        
        
    }
    func socketReceivedOtherWebRTC(message: String, data: AnyObject!) {
        
        
        /*var msg=JSON(data)
        socketObj.socket.emit("logClient","IPHONE-LOG: \(username!) received message \(msg)")
        
        print("socketReceivedOtherWebRTC inside \(msg)")
        switch(message){
            
        case "peer.connected":
            print("peer.connected received")
            
          /////  handlePeerConnected(data)
            
            /*case "peer.connected.new":
             print("peer.connected.new received")
             handlePeerConnected(data)
             */
        case "conference.stream":
         /////   handleConferenceStream(data)
            
        case "peer.disconnected":
          /////  handlePeerDisconnected(data)
            
        case "peer.disconnected.new":
           ///// handlePeerDisconnected(data)
            
        default:print("wrong socket other mesage received")
        var msg=JSON(data)
        print(msg.description)
        socketObj.socket.emit("logClient","IPHONE-LOG: \(username!)received wrong socket message  \(msg.description)")
        }
        
*/
        
    }
    func socketReceivedMessageWebRTC(message: String, data: AnyObject!) {
        print("socketReceivedMSGWebRTC inside webrtcclient")
        switch(message){
        case "msg":
            print()
         /////   handlemsg(data)
            
            
        default:print("wrong socket msg received")
        print(data)
        }
        
    }
    
}