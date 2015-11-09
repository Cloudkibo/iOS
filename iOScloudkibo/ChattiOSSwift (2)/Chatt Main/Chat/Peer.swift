//
//  Peer.swift
//  Chat
//
//  Created by Cloudkibo on 08/11/2015.
//  Copyright (c) 2015 MyAppTemplates. All rights reserved.
//

import Foundation

class Peer: NSObject,RTCPeerConnectionDelegate,RTCSessionDescriptionDelegate {
    
    var id:NSString
    var pc:RTCPeerConnection!
    var username:NSString
    var peerNumber:Int
    var joinedRoom:Bool=false
    var isBusy:Bool=false
    
    
    init(id:String,username:String,var peerNumber:Int)
    {
        self.id=id as NSString
        self.username=username as NSString
        self.peerNumber=peerNumber
        RTCPeerConnectionFactory.initializeSSL()
        var factory=RTCPeerConnectionFactory.alloc()
        super.init()
        self.pc=factory.peerConnectionWithConfiguration(nil, constraints: nil, delegate: self)
        
    }
    
    func getID()->String
    {
        return self.id as String
    }
    func getName()->String
    {
        return self.username as String
    }
    func getPeer()->RTCPeerConnection
    {
        return self.pc
        
    }
    
    func sendMessage()
    {
    
    }

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
    override func didChange(changeKind: NSKeyValueChange, valuesAtIndexes indexes: NSIndexSet, forKey key: String) {
        
    }
    override func didChangeValueForKey(key: String, withSetMutation mutationKind: NSKeyValueSetMutationKind, usingObjects objects: Set<NSObject>) {
        
    }
}

class abc{
    
    
}