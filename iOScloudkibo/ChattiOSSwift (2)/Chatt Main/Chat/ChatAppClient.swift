//
//  ChatAppClient.swift
//  Chat
//
//  Created by Cloudkibo on 12/11/2015.
//  Copyright (c) 2015 MyAppTemplates. All rights reserved.
//

import Foundation
import SwiftyJSON
import UIKit
import AVFoundation

enum ChatAppClientState:NSInteger{
    // Disconnected from servers.
    case kARDAppClientStateDisconnected
    // Connecting to servers.
    case kARDAppClientStateConnecting
    // Connected to servers.
    case kARDAppClientStateConnected
    
}
class ChatAppClient:NSObject,RTCPeerConnectionDelegate, RTCSessionDescriptionDelegate
{
    var mainICEServerURL:NSURL=NSURL(fileURLWithPath: Constants.MainUrl)!
    
    var rtcICEarray:[RTCICEServer]=[]

    static var kARDAppClientErrorDomain:NSString="ChatAppclient"
    static var kARDAppClientErrorUnknown:NSInteger = -1
    static var kARDAppClientErrorRoomFull:NSInteger = -2
    static var kARDAppClientErrorCreateSDP:NSInteger = -3
    static var kARDAppClientErrorSetSDP:NSInteger = -4
    static var kARDAppClientErrorNetwork:NSInteger = -5
    static var kARDAppClientErrorInvalidClient:NSInteger = -6
    static var kARDAppClientErrorInvalidRoom:NSInteger = -7
    var peerConnection:RTCPeerConnection!
    var factory:RTCPeerConnectionFactory!
    var messageQueue:NSMutableArray!
    var isTurnComplete:Bool!
    var hasReceivedSdp:Bool!
    var isRegisteredWithRoomServer:Bool!
    var roomId:NSString!
    var clientId:NSString!
    var isInitiator:Bool!
    var iceServers:NSMutableArray!
    var channel:AnyObject! //ARDWebSocketChannel
    var serverHostURL:NSString!
    var state:ChatAppClientState!
    var delegate:ChatAppClientDelegate!
    
    static var kARDRoomServerHostUrl:NSString=Constants.MainUrl
    static var kARDRoomServerRegisterFormat:NSString="%@/join/%@"
    static var kARDRoomServerMessageFormat:NSString="%@/message/%@/%@"
    static var kARDRoomServerByeFormat:NSString="%@/leave/%@/%@"
    static var kARDDefaultSTUNServerUrl:NSString="stun:stun.l.google.com:19302"
    //static var kARDTurnRequestUrl:NSString="https://computeengineondemand.appspot.com@/turn?username=iapprtc&key=4080218913";
    static var kARDTurnRequestUrl:NSString="turn:45.55.232.65:3478?transport=udp"

    
    
    init(delegate:ChatAppClientDelegate)
   {
    super.init()
    self.delegate=delegate
    RTCPeerConnectionFactory.initializeSSL()
    self.factory=RTCPeerConnectionFactory.alloc()
    messageQueue=NSMutableArray(array: [])
    iceServers=NSMutableArray(array: [ChatAppClient.kARDDefaultSTUNServerUrl])
    serverHostURL=ChatAppClient.kARDRoomServerHostUrl
    
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "orientationChanged", name: UIDeviceOrientationDidChangeNotification, object: nil)
   
    //===========================================================================================
    
    self.rtcICEarray.append(RTCICEServer(URI: NSURL(string:"turn:45.55.232.65:3478?transport=udp"), username: "cloudkibo", password: "cloudkibo"))
    rtcICEarray.append(RTCICEServer(URI: NSURL(string:"turn:45.55.232.65:3478?transport=tcp"), username: "cloudkibo", password: "cloudkibo"))
    rtcICEarray.append(RTCICEServer(URI: NSURL(string:"stun:stun.l.google.com:19302"), username: "", password: ""))
    rtcICEarray.append(RTCICEServer(URI: NSURL(string:"stun:23.21.150.121"), username: "", password: ""))
    rtcICEarray.append(RTCICEServer(URI: NSURL(string:"stun:stun.anyfirewall.com:3478"), username: "", password: ""))
    rtcICEarray.append(RTCICEServer(URI: NSURL(string:"turn:turn.bistri.com:80?transport=udp"), username: "homeo", password: "homeo"))
    rtcICEarray.append(RTCICEServer(URI: NSURL(string:"turn:turn.bistri.com:80?transport=tcp"), username: "homeo", password: "homeo"))
    rtcICEarray.append(RTCICEServer(URI: NSURL(string:"turn:turn.anyfirewall.com:443?transport=tcp"), username: "webrtc", password: "webrtc"))
    addHandlers(socketObj.socket)
    startSignallingIfReady()
    
    }
    
    deinit
    {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIDeviceOrientationDidChangeNotification, object: nil)
        self.disconnect()
        
    }
    
   
    func orientationChanged(notification:NSNotification)
    {
        var orientation:UIDeviceOrientation=UIDevice.currentDevice().orientation
        if(UIDeviceOrientationIsLandscape(orientation) || UIDeviceOrientationIsPortrait(orientation))
        {//Remove current video track
            var localStream:RTCMediaStream=self.peerConnection.localStreams[0] as! RTCMediaStream
            localStream.removeVideoTrack(localStream.videoTracks[0] as! RTCVideoTrack)
            var localVideoTrack:RTCVideoTrack!=self.createLocalVideoTrack()
            if let lvt=localVideoTrack
            {
                localStream.addVideoTrack(localVideoTrack)
                self.delegate.appClient(self, didReceiveLocalVideoTrack: localVideoTrack)
                
            }
            self.peerConnection.removeStream(localStream)
            self.peerConnection.addStream(localStream)
            
        }
    }
    
  
    func createLocalVideoTrack()->RTCVideoTrack
    {
        var cameraID:NSString!
        for aaa in AVCaptureDevice.devicesWithMediaType(AVMediaTypeVideo)
        {
            if aaa.position==AVCaptureDevicePosition.Front
            {                cameraID=aaa.localizedName!!
               
                println(cameraID!)
                println("got front camera")
                break
            }
            
        }
        if cameraID==nil
            
        {println("failed to get camera")}
        
        //AVCaptureDevice
        var rtcVideoCapturer=RTCVideoCapturer(deviceName: cameraID! as String)
        
        println(rtcVideoCapturer.debugDescription)
        var rtcMediaConst=RTCMediaConstraints(mandatoryConstraints: nil, optionalConstraints: nil)
        //RTCMediaConstraints(mandatoryConstraints: nil, optionalConstraints: nil)
        println(rtcMediaConst.debugDescription)
        //var rtcVideoSource:RTCVideoSource
        //rtcVideoSource.
        //rtcVideoCapturer=rtcVideoCapturer()
        var rtcVideoSource=self.factory.videoSourceWithCapturer(rtcVideoCapturer, constraints: nil)
        println("outttt")
        println(rtcVideoSource.debugDescription)
        
        var rtcVideoTrack1=RTCVideoTrack(factory: self.factory!, source: rtcVideoSource, trackId: "sss")
        //rtcVideoTrack=rtcFact.videoTrackWithID("sss", source: rtcVideoSource)
        println("out of error")
        return rtcVideoTrack1
    }

    func createLocalMediaStream()->RTCMediaStream
    {
        println("inside createLocalMediaStream func  ")
        
        var mediaStreamLabel:String!
        var mediaAudioLabel:String!
        mediaStreamLabel="kibo"
        mediaAudioLabel="kiboa1"
        var localStream:RTCMediaStream!
        
        localStream=self.factory.mediaStreamWithLabel("kibo")
        
        var localVideoTrack:RTCVideoTrack!=createLocalVideoTrack()
        
        if let lvt=localVideoTrack
        {
            localStream.addVideoTrack(localVideoTrack)
            self.delegate.appClient(self, didReceiveLocalVideoTrack: localVideoTrack)
            
            
        }
        localStream.addAudioTrack(self.factory.audioTrackWithID("kiboa0"))
        print(localStream.description)
        return localStream
        
    }
    func setState(state:ChatAppClientState)
    {
        if(self.state==state)
        {return}
        self.state=state
        self.delegate.appClient(self, didChangeState: self.state)
        
    }
    
    func connectToRoomWithId(roomId:NSString,options:NSDictionary)
    {
        println("inside connectToRoomWithId function")
        self.state=ChatAppClientState.kARDAppClientStateConnecting
        // Request TURN.
        weak var weakSelf:ChatAppClient!=self
        var turnRequestURL:NSURL=NSURL(string: ChatAppClient.kARDTurnRequestUrl as String)!
     
        // Register with room server.
        //incomplete
        
        
    }
    func disconnect()
    {
        println("inside disconnect function")
        if self.state==ChatAppClientState.kARDAppClientStateDisconnected
        {println("chat app client disconnected")
            return}
        
        if((self.isRegisteredWithRoomServer) != nil)
        {
            self.unregisterWithRoomServer()
        }
        //if socket is connected
        if((self.channel) != nil || socketObj.socket.connected)
        {
            //if(self.channel.state ==
            //if socket is connected
            //// Tell the other client we're hanging up. send bye message through socket
            socketObj.socket.emit("bye")
            println("message sent BYE")
        
        }
        //if(self.channel.state == ChatAppClient.kar
        self.clientId=nil
        self.roomId=nil
        self.isInitiator=false
        self.hasReceivedSdp=false
        self.messageQueue=NSMutableArray(array: [])
        self.peerConnection=nil
        self.state = ChatAppClientState.kARDAppClientStateDisconnected
    }
    func unregisterWithRoomServer()
    {
    
    }
    func addHandlers(socket:SocketIOClient)
    {
        socketObj.socket.on("msg")
            {data,ack in
                
                println("received msg from socket")
                var message=JSON(data!)
                
                //var pc=RTCPeerConnection.alloc()
                switch (message["type"])
                {
                    case "offer":println("msg is offer")
                    case "answer":println("msg is answer")
                                self.hasReceivedSdp=true
                    self.messageQueue.insertObject(data!, atIndex: 0)
                    break
                    case "ice":println("msg is ices")
                        self.messageQueue.addObject(data!)
                default: println("msg type is invalid")
                }
            }
        self.drainMessageQueueIfReady()
        
        
    }
    
    func drainMessageQueueIfReady()
    {
        if((self.peerConnection) == nil || self.hasReceivedSdp==false)
        {
         return
        }
        for message in self.messageQueue
        {
            self.processSignallingMessage(message as! NSArray)
        }
        self.messageQueue.removeAllObjects()
        
    }
    func processSignallingMessage(data:NSArray!)
    {
        var message=JSON(data!)
        if((self.peerConnection) != nil)//NSParameterAssert(_peerConnection || message.type == kARDSignalingMessageTypeBye);
        {
            
          switch(message["type"])
          {
            
            case "offer":println("processing msg offer")
            case "answer":
                println("processing msg answer");
                var description=RTCSessionDescription(type:"answer",sdp: message["sdp"].string!)
                self.peerConnection.setRemoteDescriptionWithDelegate(self, sessionDescription: description)
                break
            
            case "ice":println("processing msg ice candidate")
            var candidate=RTCICECandidate(mid: message["ice"]["sdpMid"].string!,index: message["ice"]["sdpMLineIndex"].intValue,sdp: message["ice"]["candidate"].string!)
            var success=self.peerConnection.addICECandidate(candidate)
            println(success)
          default: println("processing invalid msg")
        }
        }
        
    }
    
    func sendSignallingMessage(message:NSObject)
    {
        
        //incomplete
        
        if(self.isInitiator==true)
        {//send to room server
        }
        else
            {//send to collider
            }
    }
    


    func peerConnection(peerConnection: RTCPeerConnection!, addedStream stream: RTCMediaStream!) {
        println("added stream")
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            println("received \(stream.videoTracks.count) video tracks and \(stream.audioTracks.count) audio tracks")
            if (stream.videoTracks.count>0) {
                var videoTrack:RTCVideoTrack=stream.videoTracks[0] as! RTCVideoTrack
                self.delegate.appClient(self, didReceiveRemoteVideoTrack: videoTrack)
            }
        })
        
        }
    func peerConnection(peerConnection: RTCPeerConnection!, didOpenDataChannel dataChannel: RTCDataChannel!) {
        
    }
    func peerConnection(peerConnection: RTCPeerConnection!, gotICECandidate candidate: RTCICECandidate!) {
        println("got ice candidate")
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.sendSignallingMessage(["mid":candidate.sdpMid,"sdp":candidate.sdp,"index":candidate.sdpMLineIndex])
            
            
        })
    }
    func peerConnection(peerConnection: RTCPeerConnection!, iceConnectionChanged newState: RTCICEConnectionState) {
        
    }
    func peerConnection(peerConnection: RTCPeerConnection!, iceGatheringChanged newState: RTCICEGatheringState) {
        
    }
    func peerConnection(peerConnection: RTCPeerConnection!, removedStream stream: RTCMediaStream!) {
        
    }
    func peerConnection(peerConnection: RTCPeerConnection!, signalingStateChanged stateChanged: RTCSignalingState) {
        println("signalling state changed \(stateChanged)")
        
    }
    func peerConnectionOnRenegotiationNeeded(peerConnection: RTCPeerConnection!) {
        
    }
    
    func peerConnection(peerConnection: RTCPeerConnection!, didCreateSessionDescription sdp: RTCSessionDescription!, error: NSError!) {
        if((error) != nil)
        {
            println("failed to create session desc \(error.debugDescription)")
            self.disconnect()
            return
        }
        self.peerConnection.setLocalDescriptionWithDelegate(self, sessionDescription: sdp)
    }

    func peerConnection(peerConnection: RTCPeerConnection!, didSetSessionDescriptionWithError error: NSError!) {
        println("didsetpeerconnecxn with error")
    }
    
    func isRegisteredWithRoomServerFunc()
    {
        if(self.clientId.length>0)
        {self.isRegisteredWithRoomServer=true}
        else
            {self.isRegisteredWithRoomServer=false}
    }
    func startSignallingIfReady()
    {println("inside signalling")
        /*^^^^^^if(self.isTurnComplete==false || self.isRegisteredWithRoomServer==false)
        {
        return;
        }*/
        self.state=ChatAppClientState.kARDAppClientStateConnected
        socketObj.socket.connect()
        
        //Create Peer connection
        var constraints:RTCMediaConstraints=self.defaultPeerConnectionConstraints()
        self.factory=RTCPeerConnectionFactory.alloc()
        self.peerConnection=RTCPeerConnection.alloc()
        self.peerConnection=self.factory.peerConnectionWithICEServers(nil, constraints: nil, delegate: self)
        var localStream:RTCMediaStream=createLocalMediaStream()
        self.peerConnection.addStream(localStream)
        if(isInitiator==true)
        {
            self.sendOffer()
        }
        else
        {
            self.waitForAnswer()
        }
    }
    
    func sendOffer(){
        self.peerConnection.createOfferWithDelegate(self, constraints: defaultOfferConstraints())
    }
    func waitForAnswer()
    {
        self.drainMessageQueueIfReady()
    }
    
    
    func defaultMediaStreamConstraints()->RTCMediaConstraints
    {
        var constraints:RTCMediaConstraints=RTCMediaConstraints(mandatoryConstraints: nil, optionalConstraints: nil)
        return constraints
    }
    func defaultOfferConstraints()->RTCMediaConstraints
    {
        var mandatoryConstraints:NSArray=[RTCPair(key: "OfferToReceiveAudio", value: "true"),RTCPair(key: "OfferToReceiveVideo", value: "true")]
        var constraints:RTCMediaConstraints=RTCMediaConstraints(mandatoryConstraints: mandatoryConstraints as [AnyObject], optionalConstraints: nil)
        return constraints

        
    }
    
    func defaultAnswerConstraints()->RTCMediaConstraints
    {
        return self.defaultOfferConstraints()
    }
    
    func defaultPeerConnectionConstraints()->RTCMediaConstraints
    {
        var optionalConstraints:NSArray=[RTCPair(key: "DtlsSrtpKeyAgreement", value: "true")]
        var constraints:RTCMediaConstraints=RTCMediaConstraints(mandatoryConstraints: nil, optionalConstraints: optionalConstraints as [AnyObject])
        return constraints

        
    }
    func defaultSTUNServer()->RTCICEServer
    {
        var defaultSTUNServerURL=rtcICEarray[3].URI
        println(defaultSTUNServerURL.debugDescription)
        return rtcICEarray[3]
    }
    
    /*
    
   

*/
    
}


protocol ChatAppClientDelegate
{
    
    func appClient(client:ChatAppClient,didChangeState state:ChatAppClientState);
    func appClient(client:ChatAppClient,didReceiveLocalVideoTrack localVideoTrack:RTCVideoTrack);
    func appClient(client:ChatAppClient,didReceiveRemoteVideoTrack remoteVideoTrack:RTCVideoTrack);
    func appClient(client:ChatAppClient,didError error:NSError);
    
    //func game(game: DiceGame, didStartNewTurnWithDiceRoll diceRoll: Int)
}




