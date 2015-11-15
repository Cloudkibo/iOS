//
//  ChatAppClient.swift
//  Chat
//
//  Created by Cloudkibo on 12/11/2015.
//  Copyright (c) 2015 MyAppTemplates. All rights reserved.
//

import Foundation
import SwiftyJSON

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
   
    /*
    static NSString *kARDRoomServerHostUrl =
    @"https://apprtc.appspot.com";
    static NSString *kARDRoomServerRegisterFormat =
    @"%@/join/%@";
    static NSString *kARDRoomServerMessageFormat =
    @"%@/message/%@/%@";
    static NSString *kARDRoomServerByeFormat =
    @"%@/leave/%@/%@";
    
    static NSString *kARDDefaultSTUNServerUrl =
    @"stun:stun.l.google.com:19302";
    // TODO(tkchin): figure out a better username for CEOD statistics.
    static NSString *kARDTurnRequestUrl =
    @"https://computeengineondemand.appspot.com"
    @"/turn?username=iapprtc&key=4080218913";
*/

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
    
/* ARDAppClientState state;
@property(nonatomic, weak) id<ARDAppClientDelegate> delegate;
@property(nonatomic, strong) NSString *serverHostUrl;*/
    
   
    static var kARDRoomServerHostUrl:NSString="https://apprtc.appspot.com";
    static var kARDRoomServerRegisterFormat:NSString="%@/join/%@"
    static var kARDRoomServerMessageFormat:NSString="%@/message/%@/%@"
    static var kARDRoomServerByeFormat:NSString="%@/leave/%@/%@"
    static var kARDDefaultSTUNServerUrl:NSString="stun:stun.l.google.com:19302"
    static var kARDTurnRequestUrl:NSString="https://computeengineondemand.appspot.com@/turn?username=iapprtc&key=4080218913";

    
    
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
    addHandlers(socketObj.socket)
    
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
    
    func createLocalVideoTrack()->RTCVideoTrack!
    {
    
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
        self.state=ChatAppClientState.kARDAppClientStateConnecting
        // Request TURN.
        weak var weakSelf:ChatAppClient!=self
        var turnRequestURL:NSURL=NSURL(string: ChatAppClient.kARDTurnRequestUrl as String)!
        /*
[self requestTURNServersWithURL:turnRequestURL
completionHandler:^(NSArray *turnServers) {
ARDAppClient *strongSelf = weakSelf;
[strongSelf.iceServers addObjectsFromArray:turnServers];
strongSelf.isTurnComplete = YES;
[strongSelf startSignalingIfReady];
}];*/
        
        // Register with room server.
        
        
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
        if((self.channel) != nil)
        {
            //if(self.channel.state ==
            //if socket is connected
            //// Tell the other client we're hanging up. send bye message through socket
        
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
        if(self.isInitiator==true)
        {//send to room server
        }
        else
            {//send to collider
            }
    }
    
    /*
//WEBSOCKETDELEGATE
    
    - (void)channel:(ARDWebSocketChannel *)channel
    didChangeState:(ARDWebSocketChannelState)state {
    switch (state) {
    case kARDWebSocketChannelStateOpen:
    break;
    case kARDWebSocketChannelStateRegistered:
    break;
    case kARDWebSocketChannelStateClosed:
    case kARDWebSocketChannelStateError:
    // TODO(tkchin): reconnection scenarios. Right now we just disconnect
    // completely if the websocket connection fails.
    [self disconnect];
    break;
    }
    }
    - (void)sendSignalingMessage:(ARDSignalingMessage *)message {
    if (_isInitiator) {
    [self sendSignalingMessageToRoomServer:message completionHandler:nil];
    } else {
    [self sendSignalingMessageToCollider:message];
    }
    }

   

   
    
*/


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
    /*
    
    - (void)peerConnection:(RTCPeerConnection *)peerConnection
    didCreateSessionDescription:(RTCSessionDescription *)sdp
    error:(NSError *)error {
    dispatch_async(dispatch_get_main_queue(), ^{
    if (error) {
    NSLog(@"Failed to create session description. Error: %@", error);
    [self disconnect];
    NSDictionary *userInfo = @{
    NSLocalizedDescriptionKey: @"Failed to create session description.",
    };
    NSError *sdpError =
    [[NSError alloc] initWithDomain:kARDAppClientErrorDomain
    code:kARDAppClientErrorCreateSDP
    userInfo:userInfo];
    [_delegate appClient:self didError:sdpError];
    return;
    }
    [_peerConnection setLocalDescriptionWithDelegate:self
    sessionDescription:sdp];
    ARDSessionDescriptionMessage *message =
    [[ARDSessionDescriptionMessage alloc] initWithDescription:sdp];
    [self sendSignalingMessage:message];
    });
    }
    

*/
    func peerConnection(peerConnection: RTCPeerConnection!, didSetSessionDescriptionWithError error: NSError!) {
        
    }
    
   
    
}


protocol ChatAppClientDelegate
{
    
    func appClient(client:ChatAppClient,didChangeState state:ChatAppClientState);
    func appClient(client:ChatAppClient,didReceiveLocalVideoTrack localVideoTrack:RTCVideoTrack);
    func appClient(client:ChatAppClient,didReceiveRemoteVideoTrack remoteVideoTrack:RTCVideoTrack);
    func appClient(client:ChatAppClient,didError error:NSError);
    
    //func game(game: DiceGame, didStartNewTurnWithDiceRoll diceRoll: Int)
}




