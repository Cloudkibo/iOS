//
//  ChatAppClient.swift
//  Chat
//
//  Created by Cloudkibo on 12/11/2015.
//  Copyright (c) 2015 MyAppTemplates. All rights reserved.
//

import Foundation

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
        if self.state==ChatAppClientState.kARDAppClientStateDisconnected
        return
        
        if((self.isRegisteredWithRoomServer) != nil)
        {
            self.unregisterWithRoomServer()
        }
        if(self.channel!=nil)
        //if(self.channel.state == ChatAppClient.kar
    }
    func unregisterWithRoomServer()
    {}
    
    /*

  
    - (void)disconnect {
    if (_state == kARDAppClientStateDisconnected) {
    return;
    }
    if (self.isRegisteredWithRoomServer) {
    [self unregisterWithRoomServer];
    }
    if (_channel) {
    if (_channel.state == kARDWebSocketChannelStateRegistered) {
    // Tell the other client we're hanging up.
    ARDByeMessage *byeMessage = [[ARDByeMessage alloc] init];
    NSData *byeData = [byeMessage JSONData];
    [_channel sendData:byeData];
    }
    // Disconnect from collider.
    _channel = nil;
    }
    _clientId = nil;
    _roomId = nil;
    _isInitiator = NO;
    _hasReceivedSdp = NO;
    _messageQueue = [NSMutableArray array];
    _peerConnection = nil;
    self.state = kARDAppClientStateDisconnected;
    }
*/


    func peerConnection(peerConnection: RTCPeerConnection!, addedStream stream: RTCMediaStream!) {
        println("added stream")
        
    }
    func peerConnection(peerConnection: RTCPeerConnection!, didOpenDataChannel dataChannel: RTCDataChannel!) {
        
    }
    func peerConnection(peerConnection: RTCPeerConnection!, gotICECandidate candidate: RTCICECandidate!) {
        println("got ice candidate")
    }
    func peerConnection(peerConnection: RTCPeerConnection!, iceConnectionChanged newState: RTCICEConnectionState) {
        
    }
    func peerConnection(peerConnection: RTCPeerConnection!, iceGatheringChanged newState: RTCICEGatheringState) {
        
    }
    func peerConnection(peerConnection: RTCPeerConnection!, removedStream stream: RTCMediaStream!) {
        
    }
    func peerConnection(peerConnection: RTCPeerConnection!, signalingStateChanged stateChanged: RTCSignalingState) {
        
    }
    func peerConnectionOnRenegotiationNeeded(peerConnection: RTCPeerConnection!) {
        
    }
    
    func peerConnection(peerConnection: RTCPeerConnection!, didCreateSessionDescription sdp: RTCSessionDescription!, error: NSError!) {
        
    }
    func peerConnection(peerConnection: RTCPeerConnection!, didSetSessionDescriptionWithError error: NSError!) {
        
    }
    
   
    
}


protocol ChatAppClientDelegate
{
    
    func appClient(client:ChatAppClient,didChangeState state:ChatAppClientState);
    func appClient(client:ChatAppClient,didReceiveLocalVideoTrack localVideoTrack:RTCVideoTrack);
    func appClient(client:ChatAppClient,didReceiveRemoteVideoTrack remoteVideoTrack:ChatAppClientState);
    func appClient(client:ChatAppClient,didError error:NSError);
    
    //func game(game: DiceGame, didStartNewTurnWithDiceRoll diceRoll: Int)
}



