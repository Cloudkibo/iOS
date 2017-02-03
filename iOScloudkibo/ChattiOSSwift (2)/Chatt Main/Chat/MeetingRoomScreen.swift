//
//  MeetingRoomScreen.swift
//  Chat
//
//  Created by Cloudkibo on 07/02/2016.
//  Copyright © 2016 MyAppTemplates. All rights reserved.
//

import Foundation
import AVFoundation
import Foundation
import SwiftyJSON
class MeetingRoomScreen:NSObject,RTCPeerConnectionDelegate,RTCSessionDescriptionDelegate{
    
    var pc:RTCPeerConnection!
    var rtcMediaConst:RTCMediaConstraints!
    var rtcLocalVideoTrack:RTCVideoTrack!
    var rtcRemoteVideoTrack:RTCVideoTrack!
    var stream:RTCMediaStream!
    var delegateConference:ConferenceScreenReceiveDelegate!
    var delegateConferenceEnd:ConferenceEndDelegate!
    var screenshared=false
    
    override init()
    {/*var mainICEServerURL:NSURL=NSURL(fileURLWithPath: Constants.MainUrl)
        rtcICEarray.append(RTCICEServer(URI: NSURL(string:"turn:45.55.232.65:3478?transport=udp"), username: "cloudkibo", password: "cloudkibo"))
        rtcICEarray.append(RTCICEServer(URI: NSURL(string:"turn:45.55.232.65:3478?transport=tcp"), username: "cloudkibo", password: "cloudkibo"))
        rtcICEarray.append(RTCICEServer(URI: NSURL(string:"stun:stun.l.google.com:19302"), username: "", password: ""))
        rtcICEarray.append(RTCICEServer(URI: NSURL(string:"stun:23.21.150.121"), username: "", password: ""))
        rtcICEarray.append(RTCICEServer(URI: NSURL(string:"stun:stun.anyfirewall.com:3478"), username: "", password: ""))
        rtcICEarray.append(RTCICEServer(URI: NSURL(string:"turn:turn.bistri.com:80?transport=udp"), username: "homeo", password: "homeo"))
        rtcICEarray.append(RTCICEServer(URI: NSURL(string:"turn:turn.bistri.com:80?transport=tcp"), username: "homeo", password: "homeo"))
        rtcICEarray.append(RTCICEServer(URI: NSURL(string:"turn:turn.anyfirewall.com:443?transport=tcp"), username: "webrtc", password: "webrtc"))
        
        
        print("rtcICEServerObj is \(rtcICEarray[0])")
        
        //self.createPeerConnectionObject()
        RTCPeerConnectionFactory.initializeSSL()
        rtcFact=RTCPeerConnectionFactory()*/
        super.init()
    }
    /*func joinRoom(var roomname:String,id:Int)
    {
    if(joinedRoomInCall == "")
    {
    print("inside accept call")
    /// roomname="test"
    print("conference name is\(ConferenceRoomName)")
    roomname=ConferenceRoomName
    
    //iamincallWith=username!
    areYouFreeForCall=false
    joinedRoomInCall=roomname as String
    socketObj.socket.emitWithAck("init.new", ["room":joinedRoomInCall,"username":username!])(timeoutAfter: 150000000) {data in
    print("room joined by got ack")
    var a=JSON(data)
    print(a.debugDescription)
    currentID=a[1].int!
    print("current id is \(currentID)")
    var aa=JSON(["msgAudio":["type":"room_name","room":roomname as String],"room":globalroom,"to":iamincallWith!,"username":username!])
    print(aa.description)
    socketObj.socket.emit("message",aa.object)
    
    }//end data
    }
    else{print("you are already in room\(joinedRoomInCall))")
    }
    }*/
    
    
    func createPeerConnection()
    {
        //Initialise Peer Connection Object
        print("inside create peer conn object method")
        self.rtcMediaConst=RTCMediaConstraints(mandatoryConstraints: [RTCPair(key: "OfferToReceiveAudio", value: "false"),RTCPair(key: "OfferToReceiveVideo", value: "true")], optionalConstraints: nil)
        //rtcFact=nil
        if(self.pc != nil)
        {
            print("pc closeddddd")
            
            self.pc.close()
            self.pc = nil
        }
        ///////////////////////////
        if(rtcFact == nil)
            
        {RTCPeerConnectionFactory.initializeSSL()
            rtcFact=RTCPeerConnectionFactory()
        }
        ////////////////////////
        self.pc=rtcFact.peerConnection(withICEServers: rtcICEarray, constraints: self.rtcMediaConst, delegate:self)
        
    }
    
    func createLocalVideoStream()->RTCMediaStream
    {
        print("inside createlocalvideostream")
        
        let localStream:RTCMediaStream!
        /*
        localStream=rtcFact.mediaStreamWithLabel("ARDAMS")
        
        self.rtcLocalVideoTrack = createLocalVideoTrack()
        if let lvt=self.rtcLocalVideoTrack
        {
            let addedVideo=localStream.addVideoTrack(self.rtcLocalVideoTrack)
            self.stream=localStream
            print("video stream \(addedVideo)")
            ////++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
            dispatch_async(dispatch_get_main_queue(), {
                //////self.didReceiveLocalVideoTrack(localVideoTrack)
                
                
                self.delegateConference.didReceiveLocalScreen(self.rtcLocalVideoTrack)
                //////self.didReceiveLocalVideoTrack()
            })
            
        }
        print("localStreammm ")
        print(localStream.description, terminator: "")
        //^^^localVideoTrack.addRenderer(localView)
*/
        return localStream

    }
    
    
    
    func createLocalVideoTrack()->RTCVideoTrack{
        //var localVideoTrack:RTCVideoTrack
        var cameraID:NSString!
        for aaa in AVCaptureDevice.devices(withMediaType: AVMediaTypeVideo)
        {
            //self.rtcCaptureSession=aaa.captureSession
            if (aaa as AnyObject).position==AVCaptureDevicePosition.front
            {
                print((aaa as AnyObject).localizedName!)
                cameraID=(aaa as AnyObject).localizedName! as NSString!
                print("got front cameraaa as id \(cameraID)")
                break
            }
            
        }
        if cameraID==nil
            
        {print("failed to get front camera")}
        
        //AVCaptureDevice
        let capturer=RTCVideoCapturer(deviceName: cameraID! as String)
        
        print(capturer?.description)
        
        var VideoSource:RTCVideoSource
        
        VideoSource=rtcFact.videoSource(with: capturer, constraints: nil)
        self.rtcLocalVideoTrack=nil
        self.rtcLocalVideoTrack=rtcFact.videoTrack(withID: "ARDAMSv0", source: VideoSource)
        print("sending localVideoTrack")
        return self.rtcLocalVideoTrack
        
    }
    /* func removeLocalMediaStreamFromPeerConnection()
    {
    
    //self.pc.removeStream(stream)
    
    if((self.rtcLocalVideoTrack) != nil)
    {print("remove localtrack renderer")
    self.rtcLocalVideoTrack.removeRenderer(self.localView)
    }
    /*if((self.rtcVideoTrackReceived) != nil)
    {print("remove remotetrack renderer")
    self.rtcVideoTrackReceived.removeRenderer(self.remoteView)
    }
    */
    print("out of removing remoterenderer")
    self.rtcLocalVideoTrack=nil
    self.rtcLocalVideoStream=nil
    
    
    }*/
    
    func sendOffer()
    {
        self.pc.createOffer(with: self, constraints: self.rtcMediaConst!)
    }
    
    
    func sendAnswer()
    {
        self.pc.createAnswer(with: self, constraints: self.rtcMediaConst)
        
    }
    
    func toggleScreen(_ videoAction:Bool,tempstream:RTCMediaStream!)
    {
        if(self.pc == nil)
        {
            createPeerConnection()
        }
        
        socketObj.socket.emit("conference.streamScreen", ["username":username!,"id":currentID!,"type":"screen","action":videoAction])
        
    }
    
    
    
    func peerConnection(_ peerConnection: RTCPeerConnection!, addedStream stream1: RTCMediaStream!) {
        print("added remote stream")
        if(stream1.videoTracks.count>0)
        {self.rtcRemoteVideoTrack=stream1.videoTracks[0] as! RTCVideoTrack
            DispatchQueue.main.async(execute: {
                
                self.delegateConference.didReceiveRemoteScreen(self.rtcRemoteVideoTrack)
            })
            
        }
        
    }
    func peerConnection(_ peerConnection: RTCPeerConnection!, didCreateSessionDescription sdp: RTCSessionDescription!, error: NSError!) {
        
        print("did create offer/answer session description success")
        //^^^^^^^^^^^^^^^^^^^newwwww
        ////dispatch_async(dispatch_get_main_queue(), {
        
        ///if (error==nil && self.pc.localDescription == nil){
        if (error==nil){
            if(self.screenshared == true)
            {
                print("\(sdp.type) creatddddd")
                print(sdp.debugDescription)
                let sessionDescription=RTCSessionDescription(type: sdp.type!, sdp: sdp.description)
                
                self.pc.setLocalDescriptionWith(self, sessionDescription: sessionDescription)
                
                print(["by":currentID!,"to":otherID,"sdp":["type":sdp.type!,"sdp":sdp.description],"type":sdp.type!,"username":username!])
                
                socketObj.socket.emit("msgScreen",["by":currentID!,"to":otherID,"sdp":["type":sdp.type!,"sdp":sdp.description],"type":sdp.type!,"username":username!])
                print("\(sdp.type) emitteddd")
            }
            if(self.pc.localDescription == nil){
                print("\(sdp.type) creatddddd")
                print(sdp.debugDescription)
                let sessionDescription=RTCSessionDescription(type: sdp.type!, sdp: sdp.description)
                
                self.pc.setLocalDescriptionWith(self, sessionDescription: sessionDescription)
                
                ////print(["by":currentID!,"to":otherID,"sdp":["type":sdp.type!,"sdp":sdp.description],"type":sdp.type!,"username":username!])
                
                socketObj.socket.emit("msgScreen",["by":currentID!,"to":otherID,"sdp":["type":sdp.type!,"sdp":sdp.description],"type":sdp.type!,"username":username!])
                print("\(sdp.type) emitteddd")
            }
            
        }
        else
        {
            print("sdp created with error \(error.localizedDescription)")
        }
        
    }
    func peerConnection(_ peerConnection: RTCPeerConnection!, didOpen dataChannel: RTCDataChannel!) {
        
        
    }
    func peerConnection(_ peerConnection: RTCPeerConnection!, didSetSessionDescriptionWithError error: NSError!) {
        
        print("inside didSetSessionDescriptionWithError")
        
        // If we are acting as the callee then generate an answer to the offer.
        //^^^^^^^^^^^^^^newwwwwwww
        /////dispatch_async(dispatch_get_main_queue(), {
        
        if error == nil {
            print("did set remote sdp no error")
            
            print("isinitiator is \(isInitiator)")
            if isInitiator == false &&
                self.pc.localDescription == nil {
                    print("creating answer")
                    //^^^^^^^^^ new self.pc.addStream(self.rtcMediaStream)
                    self.pc.createAnswer(with: self, constraints: self.rtcMediaConst)
            }
            else
            {
                print("local not nil or initiator is true")
                //print(self.pc.localDescription.description)
                
            }
            
        } else {
            print(".......sdp set ERROR: \(error.localizedDescription)", terminator: "")
        }
        ///// })
        
        
        
    }
    func peerConnection(_ peerConnection: RTCPeerConnection!, gotICECandidate candidate: RTCICECandidate!) {
        
        var cnd=JSON(["sdpMLineIndex":candidate.sdpMLineIndex,"sdpMid":candidate.sdpMid!,"candidate":candidate.sdp!])
        
        var aa=JSON(["msgScreen":["by":currentID!,"to":otherID,"ice":cnd.object,"type":"ice"]])
        //print(aa.description)
        socketObj.socket.emit("msgScreen",["by":currentID!,"to":otherID,"ice":cnd.object,"type":"ice"])
        
        
    }
    func peerConnection(_ peerConnection: RTCPeerConnection!, iceConnectionChanged newState: RTCICEConnectionState) {
        
        
    }
    func peerConnection(_ peerConnection: RTCPeerConnection!, iceGatheringChanged newState: RTCICEGatheringState) {
        
        
    }
    func peerConnection(_ peerConnection: RTCPeerConnection!, removedStream stream: RTCMediaStream!) {
        print("removed screen stream")
        print("stream screen tracks are \(stream.videoTracks.count)")
       // self.delegateConference.didRemoveRemoteScreen()
        //self.rtcRemoteVideoTrack=nil
        //self.pc.close()
    }
    func peerConnection(_ peerConnection: RTCPeerConnection!, signalingStateChanged stateChanged: RTCSignalingState) {
        
        
    }
    func peerConnection(onRenegotiationNeeded peerConnection: RTCPeerConnection!) {
        
        
    }
    
    func randomStringWithLength (_ len : Int) -> NSString {
        
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        
        let randomString : NSMutableString = NSMutableString(capacity: len)
        
        for (i in 0 ..< len){
            let length = UInt32 (letters.length)
            let rand = arc4random_uniform(length)
            randomString.appendFormat("%C", letters.character(at: Int(rand)))
        }
        
        return randomString
    }
    
    
    
    
    
    func handlemsg(_ data:AnyObject!)
    {
        print("msg reeived.. check if offer answer or ice")
        print(data.description)
        var msg=JSON(data)
        print(msg.description)
        print(msg[0].description)
        
        if(msg[0]["type"].string! == "offer")
        {
            //^^^^^^^^^^^^^^^^newwwww if(joinedRoomInCall == "" && isInitiator.description == "false")
            if(joinedRoomInCall == "")
            {
                print("room joined is null")
            }
            
            print("offer received")
            //var sdpNew=msg[0]["sdp"].object
            if(self.pc == nil) //^^^^^^^^^^^^^^^^^^newwwww tryyy
            {
                self.createPeerConnection()
            }
            //^^^^^^^^^^^^^^^^^^ check this for second call already have localstream
            ////self.CreateAndAttachDataChannel()
            
            //.........................
            ////////////////////////////////////self.stream=self.createLocalVideoStream()
            pc.add(self.stream)
            
            
            //^^^^^^^^^^^^^^^^^^^^^^^newwwwww self.pc.addStream(self.getLocalMediaStream())
            otherID=msg[0]["by"].int!
            currentID=msg[0]["to"].int!
            
            print("...sending remotedesciption")
            if(msg[0]["username"].description != username! && self.pc.remoteDescription == nil){
                var sessionDescription=RTCSessionDescription(type: msg[0]["type"].description, sdp: msg[0]["sdp"]["sdp"].description)
                self.pc.setRemoteDescriptionWithDelegate(self, sessionDescription: sessionDescription)
            }
            
        }
        
        if(msg[0]["type"].string! == "answer" && msg[0]["by"].int != currentID)
        {//if(self.screenshared==true)
            if(self.screenshared==true && self.pc.remoteDescription == nil){
                print("answer received video")
                var sessionDescription=RTCSessionDescription(type: msg[0]["type"].description, sdp: msg[0]["sdp"]["sdp"].description)
                self.pc.setRemoteDescriptionWithDelegate(self, sessionDescription: sessionDescription)
            }
            
            ///// if(isInitiator.description == "true")
            if(isInitiator.description == "true" && self.pc.remoteDescription == nil)
            {print("answer received")
                var sessionDescription=RTCSessionDescription(type: msg[0]["type"].description, sdp: msg[0]["sdp"]["sdp"].description)
                self.pc.setRemoteDescriptionWithDelegate(self, sessionDescription: sessionDescription)
            }
            
        }
        if(msg[0]["type"].string! == "ice")
        {print("ice received of other peer")
            if(msg[0]["ice"].description=="null")
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
            }
            
        }
        
    }
    
    
    
    func handleConferenceStream(_ data:AnyObject!)
    {
        var datajson=JSON(data!)
        //print(datajson.debugDescription)
        /////////////////////////////////VIDEO AND SCREEN
        if(self.pc == nil)
        {print("screen peer connection was nil")
            createPeerConnection()
            
        }
        
        if(datajson[0]["username"].debugDescription != username! && datajson[0]["type"].debugDescription == "screen" && datajson[0]["action"].boolValue==true )
        {self.screenshared=true
            //Handle Screen sharing
            print("handle screen sharing")
            self.pc.createOffer(with: self, constraints: self.rtcMediaConst)
        }
        
        
        
    }
    func addHandlers()
    {
        
        socketObj.socket.on("msgScreen"){data,ack in
            
            //self.delegateWebRTCVideo.socketReceivedMSGWebRTCVideo("msgScreen", data: data)
            
            //print("msgScreen reeived.. check if offer answer or ice")
            print("msgScreen received from socket")
            self.handlemsg(data as AnyObject!)
            /*switch(message){
            
            // case "peer.connected.new":
            //   handlePeerConnected(data)
            
            
            case "peer.connected":
            print("error old peer.connected received from socket")
            /// handlePeerConnected(data)
            
            case "conference.streamVideo":
            handleConferenceStream(data)
            
            case "peer.disconnected":
            print("error old peer.disconnected received from socket")
            
            case "peer.disconnected.new":
            handlePeerDisconnected(data)
            
            default:print("wrong video socket other mesage received \(message)")
            }
            */
            
        }
        
        
        socketObj.socket.on("peer.connected.new"){data,ack in
            print("received peer.connected.new obj from server")
            // self.delegateWebRTCVideo.socketReceivedOtherWebRTCVideo("peer.connected.new", data: data)
            //handlePeerConnected(data)
            //Both joined same room
            var datajson=JSON(data)
            print(datajson.debugDescription)
            
            if(datajson[0]["username"].description != username!){
                otherID=datajson[0]["id"].int
                iamincallWith=datajson[0]["username"].description
                isInitiator=true
            }
            
        }
        
        
        socketObj.socket.on("conference.streamScreen"){data,ack in
            
            print("received conference.streamScreen obj from server")
            var datajson=JSON(data)
            print(datajson.debugDescription)
            if(datajson[0]["id"].int != currentID!)
            {
                if(datajson[0]["action"]==true)
                {
                    self.handleConferenceStream(data as AnyObject!)

                }
                else
                {
                    //HIDE SCREEN DESTROY PeerConnection object
                    self.rtcRemoteVideoTrack=nil
                    //self.pc.close()
                    self.pc=nil
                    self.screenshared=false
                    DispatchQueue.main.asynchronously(DispatchQueue.mainexecute: { () -> Void in
                        self.delegateConference.didRemoveRemoteScreen()
                        
                    })
                    
                    
                }
                
            }
            else
            {print("conference.streamScreen received of myself so no need to handle")}
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
            self.delegateConferenceEnd.disconnectAll()
            //handlePeerDisconnected(data)
            
            //self.delegateWebRTCVideo.socketReceivedOtherWebRTCVideo("peer.disconnected.new", data: data)
            
        }
        
        
        socketObj.socket.on("message"){data,ack in
            print("received messageee111")
            // self.delegateWebRTCVideo.socketReceivedMessageWebRTCVideo("message",data: data)
            
            
            
        }
        
        
        
        
    }
    
    
    func removeLocalMediaStreamFromPeerConnection()
    {
        
        //self.pc.removeStream(stream)
        
        if((self.rtcLocalVideoTrack) != nil)
        {print("remove localtrack renderer")
            ////////// ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^self.rtcLocalVideoTrack.removeRenderer(self.localView)
        }
        /*if((self.rtcVideoTrackReceived) != nil)
        {print("remove remotetrack renderer")
        self.rtcVideoTrackReceived.removeRenderer(self.remoteView)
        }
        */
        print("out of removing remoterenderer")
        self.rtcLocalVideoTrack=nil
        ///self.rtcLocalVideoStream=nil
        
        
    }
    
    
       

    
}

protocol ConferenceScreenReceiveDelegate:class
{
    func didReceiveRemoteScreen(_ remoteAudioTrack:RTCVideoTrack);
    func didRemoveRemoteScreen();
    //func didReceiveLocalVideoTrack(localVideoTrack:RTCVideoTrack);
    //func didReceiveLocalScreen(remoteVideoTrack:RTCVideoTrack);
    
}
