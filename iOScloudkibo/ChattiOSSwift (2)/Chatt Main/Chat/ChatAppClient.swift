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
    var factory:RTCPeerConnectionFactory
    var messageQueue:NSMutableArray
    var isTurnComplete:Bool!
    var hasReceivedSdp:Bool!
    var isRegisteredWithRoomServer:Bool
    var roomId:NSString
    var clientId:NSString
    var isInitiator:Bool
    var iceServers:NSMutableArray
    var channel:AnyObject //ARDWebSocketChannel
    var serverHostURL:NSString
    var state:ChatAppClientState
    ///var id:ChatAppClientDelegate
/* ARDAppClientState state;
@property(nonatomic, weak) id<ARDAppClientDelegate> delegate;
@property(nonatomic, strong) NSString *serverHostUrl;*/
    
   
    static var kARDRoomServerHostUrl:NSString=""
    static var kARDRoomServerRegisterFormat:NSString=""
    static var kARDRoomServerMessageFormat:NSString=""
    static var kARDRoomServerByeFormat:NSString=""
    static var kARDDefaultSTUNServerUrl:NSString="fsfs"
    static var kARDTurnRequestUrl:NSString=""
    
    
   override init()
   {
    
    RTCPeerConnectionFactory.initializeSSL()
    self.factory=RTCPeerConnectionFactory()
    messageQueue=NSMutableArray(array: [])
    iceServers=NSMutableArray(array: [ChatAppClient.kARDDefaultSTUNServerUrl])
    serverHostURL=ChatAppClient.kARDRoomServerHostUrl
   
    
    
    }
    
    /*

@interface ARDAppClient () <ARDWebSocketChannelDelegate,
RTCPeerConnectionDelegate, RTCSessionDescriptionDelegate>
@property(nonatomic, strong) ARDWebSocketChannel *channel;

    (instancetype)initWithDelegate:(id<ARDAppClientDelegate>)delegate {
    if (self = [super init]) {
    _delegate = delegate;
    _factory = [[RTCPeerConnectionFactory alloc] init];
    _messageQueue = [NSMutableArray array];
    _iceServers = [NSMutableArray arrayWithObject:[self defaultSTUNServer]];
    _serverHostUrl = kARDRoomServerHostUrl;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
    selector:@selector(orientationChanged:)
    name:@"UIDeviceOrientationDidChangeNotification"
    object:nil];
    }
    return self;
 
   
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

/*
@protocol ARDAppClientDelegate <NSObject>

- (void)appClient:(ARDAppClient *)client
didChangeState:(ARDAppClientState)state;

- (void)appClient:(ARDAppClient *)client
didReceiveLocalVideoTrack:(RTCVideoTrack *)localVideoTrack;

- (void)appClient:(ARDAppClient *)client
didReceiveRemoteVideoTrack:(RTCVideoTrack *)remoteVideoTrack;

- (void)appClient:(ARDAppClient *)client
didError:(NSError *)error;

*/

