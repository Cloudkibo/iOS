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
    //var peerNumber:Int
    var joinedRoom:Bool=false
    var isBusy:Bool=false
    var rtcMediaConst:RTCMediaConstraints!
    var rtcICEarray:[RTCICEServer]=[]
    var factory:RTCPeerConnectionFactory!
    init(id:String,username:String)
    {
        self.id=id as NSString
        self.username=username as NSString
       // self.peerNumber=peerNumber
        RTCPeerConnectionFactory.initializeSSL()
        factory=RTCPeerConnectionFactory.alloc()
        //super.init()
        
        
        //var rtcICEobj=RTCICEServer(URI: mainICEServerURL, username: username!, password: password!)
        //rtcICEarray.append(rtcICEobj)
        rtcICEarray.append(RTCICEServer(URI: NSURL(string:"turn:45.55.232.65:3478?transport=udp"), username: "cloudkibo", password: "cloudkibo"))
        rtcICEarray.append(RTCICEServer(URI: NSURL(string:"turn:45.55.232.65:3478?transport=tcp"), username: "cloudkibo", password: "cloudkibo"))
        rtcICEarray.append(RTCICEServer(URI: NSURL(string:"stun:stun.l.google.com:19302"), username: "", password: ""))
        rtcICEarray.append(RTCICEServer(URI: NSURL(string:"stun:23.21.150.121"), username: "", password: ""))
        rtcICEarray.append(RTCICEServer(URI: NSURL(string:"stun:stun.anyfirewall.com:3478"), username: "", password: ""))
        rtcICEarray.append(RTCICEServer(URI: NSURL(string:"turn:turn.bistri.com:80?transport=udp"), username: "homeo", password: "homeo"))
        rtcICEarray.append(RTCICEServer(URI: NSURL(string:"turn:turn.bistri.com:80?transport=tcp"), username: "homeo", password: "homeo"))
        rtcICEarray.append(RTCICEServer(URI: NSURL(string:"turn:turn.anyfirewall.com:443?transport=tcp"), username: "webrtc", password: "webrtc"))
        
        self.rtcMediaConst=RTCMediaConstraints(mandatoryConstraints: [RTCPair(key: "OfferToReceiveAudio", value: "true"),RTCPair(key: "OfferToReceiveVideo", value: "true")], optionalConstraints: nil)
        //self.pc=factory.peerConnectionWithICEServers(rtcICEarray, constraints: rtcMediaConst, delegate: self)
        
        //self.pc=factory.peerConnectionWithICEServers(rtcICEarray, constraints: nil, delegate: self)
         self.pc=factory.peerConnectionWithICEServers(rtcICEarray, constraints: nil, delegate: nil)
        
    }
    func getPC()->RTCPeerConnection!
    {
       
        return self.pc
        
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
    func createOffer()
    {
        self.pc.createOfferWithDelegate(self, constraints: rtcMediaConst)
    }

    func peerConnection(peerConnection: RTCPeerConnection!, addedStream stream: RTCMediaStream!) {
        print("added stream", terminator: "")
        
    }
    func peerConnection(peerConnection: RTCPeerConnection!, didOpenDataChannel dataChannel: RTCDataChannel!) {
        
    }
    func peerConnection(peerConnection: RTCPeerConnection!, gotICECandidate candidate: RTCICECandidate!) {
        print("got ice candidate", terminator: "")
    }
    func peerConnection(peerConnection: RTCPeerConnection!, iceConnectionChanged newState: RTCICEConnectionState) {
        
    }
    func peerConnection(peerConnection: RTCPeerConnection!, iceGatheringChanged newState: RTCICEGatheringState) {
        
    }
    func peerConnection(peerConnection: RTCPeerConnection!, removedStream stream: RTCMediaStream!) {
        
    }
    func peerConnection(peerConnection: RTCPeerConnection!, signalingStateChanged stateChanged: RTCSignalingState) {
        print("signaling state changed \(stateChanged)", terminator: "")
    }
    func peerConnectionOnRenegotiationNeeded(peerConnection: RTCPeerConnection!) {
        
    }
    
    func peerConnection(peerConnection: RTCPeerConnection!, didCreateSessionDescription sdp: RTCSessionDescription!, error: NSError!) {
        print("created sdp..", terminator: "")
        socketObj.socket.emit("msg", ["by": "\(_id!)" , "to": "553513f8fff0f13a73518adc", "sdp": sdp, "type": "offer", "username": "\(username)" ]);
        
        //set SDP
        pc.setLocalDescriptionWithDelegate(self, sessionDescription: sdp)
    }
    func peerConnection(peerConnection: RTCPeerConnection!, didSetSessionDescriptionWithError error: NSError!) {
        print("error setting sdp", terminator: "")
    }
    override func didChange(changeKind: NSKeyValueChange, valuesAtIndexes indexes: NSIndexSet, forKey key: String) {
        
    }
    override func didChangeValueForKey(key: String, withSetMutation mutationKind: NSKeyValueSetMutationKind, usingObjects objects: Set<NSObject>) {
        
    }
}

class abc{
    
    
}