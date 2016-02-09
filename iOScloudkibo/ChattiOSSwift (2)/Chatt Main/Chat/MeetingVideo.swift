//
//  MeetingVideo.swift
//  Chat
//
//  Created by Cloudkibo on 04/02/2016.
//  Copyright © 2016 MyAppTemplates. All rights reserved.
//

import Foundation
import SwiftyJSON
import AVFoundation
import UIKit

class MeetingVideo:NSObject,SocketClientDelegateWebRTCVideo,RTCPeerConnectionDelegate,RTCSessionDescriptionDelegate{
    
    var pc:RTCPeerConnection!
    /////var username =username!
    //////var stream:RTCMediaStream!
    var nullStream:RTCMediaStream!
    //var videoAction=true
    var rtcMediaConst:RTCMediaConstraints! = nil
    var rtcLocalVideoTrack:RTCVideoTrack!
    var delegate:ConferenceVideoViewDelegate!
    var rtcRemoteVideoStream:RTCMediaStream!
    var videoshared=false
    //var delegate:ConferenceVideoViewDelegate
    override init()
    {
        
        super.init()
    }
    
    func initVideo()
    {
        print("inside video init")
        
        /*var mainICEServerURL:NSURL=NSURL(fileURLWithPath: Constants.MainUrl)
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
        rtcFact=RTCPeerConnectionFactory()
        */
        if(socketObj.delegateWebRTCVideo == nil)
        {
            socketObj.delegateWebRTCVideo=self
        }
        
        //////////////////********************
        //DONT ATTACH ANY STREAM AT FIRST
        //self.stream=self.getLocalMediaStream()
        print("waiting now video")
        
        
        
    }
    func getPeerConnection()->RTCPeerConnection!
    {
        return pc
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
    
    func addLocalMediaStreamToPeerConnection(stream:RTCMediaStream)
    {
        
        //if(stream.audioTracks.count > 0)
        //{
         //   self.pc.addStream(stream)
        //}
        //else
        //{
            // $**************************************
            //////////self.stream=self.getLocalMediaStream()
        
            var aaa=self.pc.addStream(stream)
            print("video stream attached \(aaa)")
            
            ///////////////self.pc.addStream(self.getLocalMediaStream())
       // }
    }
        
    
    func toggleVideo(videoAction:Bool,var stream:RTCMediaStream) {
        print("inside toggle video pressed")
        //videoAction = !videoAction.boolValue
       // if(videoAction == true)
        //{
          //  self.addLocalMediaStreamToPeerConnection(stream)
        //}
        //else
            if(videoAction == false)
        {
            self.pc.removeStream(stream)
            stream.removeVideoTrack(rtcLocalVideoTrack)
            rtcLocalVideoTrack=nil
            
        }
        socketObj.socket.emit("conference.streamVideo", ["username":username!,"id":currentID!,"type":"video","action":videoAction.boolValue])
        
        
    }
    
    func disconnect()
    {
        print("inside disconnect")
        /*if((self.pc) != nil)
        {
        dispatch_async(dispatch_get_global_queue(Int(QOS_CLASS_USER_INITIATED.rawValue),0)){
        
        if((self.rtcLocalVideoTrack) != nil)
        {print("remove localtrack renderer")
        self.rtcLocalVideoTrack.removeRenderer(self.localView)
        }
        if((self.rtcVideoTrackReceived) != nil)
        {print("remove remotetrack renderer")
        self.rtcVideoTrackReceived.removeRenderer(self.remoteView)
        }
        print("out of removing remoterenderer")
        self.rtcLocalVideoTrack=nil
        
        //////////////self.localView.renderFrame(nil)
        /////////////self.remoteView.renderFrame(nil)
        self.pc=nil
        joinedRoomInCall=""
        //iamincallWith=nil
        isInitiator=false
        // rtcFact=nil
        areYouFreeForCall=true
        currentID=nil
        otherID=nil
        //self.remoteDisconnected()
        
        //////////////socketObj.socket.emit("message",["msg":"hangup","room":globalroom,"to":iamincallWith!,"username":username!])
        
        iamincallWith=nil
        //self.localView.removeFromSuperview()
        //self.remoteView.removeFromSuperview()
        self.localView=nil
        self.remoteView=nil
        
        //^^^^^^^^^^^^newwwwww
        self.rtcLocalMediaStream = nil
        self.rtcStreamReceived = nil//^^^^^^^^^^^^^^^^newwwww
        
        
        if(self.rtcDataChannel != nil){
        self.rtcDataChannel.close()
        }
        
        
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
        
        
        
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
        
        })
        
        
        })
        }
        
        
        }*/
    }
    
    func remoteDisconnected()
    {
        print("inside remote disconnected")
        /*  if((self.rtcVideoTrackReceived) != nil)
        {
        self.rtcVideoTrackReceived.removeRenderer(self.remoteView)
        }
        self.rtcVideoTrackReceived=nil
        if((remoteView) != nil)
        {self.remoteView.renderFrame(nil)}
        print("remote disconnected")*/
    }
   /*
    func getLocalMediaStream()->RTCMediaStream!
    {
        print("getlocalmediastream")
        
        self.stream=createLocalVideoStream()
        
        
        //print(rtcLocalMediaStream.audioTracks.count)
        
        // print(rtcLocalMediaStream.videoTracks.count)
        return stream
        
    }
    */
    
    func createPeerConnectionObject()
    {//Initialise Peer Connection Object
        print("inside create peer conn object method")
        self.rtcMediaConst=RTCMediaConstraints(mandatoryConstraints: [RTCPair(key: "OfferToReceiveAudio", value: "false"),RTCPair(key: "OfferToReceiveVideo", value: "false")], optionalConstraints: nil)
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
        self.pc=rtcFact.peerConnectionWithICEServers(rtcICEarray, constraints: self.rtcMediaConst, delegate:self)
        ////CreateAndAttachDataChannel()
    }
    
    
    
    /*
    func createLocalVideoStream()->RTCMediaStream
    {print("inside createlocalvideotrack")
        
        var localStream:RTCMediaStream!
        
        localStream=rtcFact.mediaStreamWithLabel("ARDAMS")
        /////////////$$$************^^^
        var localVideoTrack=createLocalVideoTrack()
        
        self.rtcLocalVideoTrack = createLocalVideoTrack()
        if let lvt=self.rtcLocalVideoTrack
        {
        let addedVideo=localStream.addVideoTrack(self.rtcLocalVideoTrack)
        
        print("video stream \(addedVideo)")
        ////++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        dispatch_async(dispatch_get_main_queue(), {
            // ..$$$$******************************
            //TELL CONTROLLER TO SHOW LOCAL VIDEO
        self.delegate.didReceiveLocalVideoTrack(self.rtcLocalVideoTrack)
        })
        
        }

       // let audioTrack=rtcFact.audioTrackWithID("ARDAMSa0")
        ///audioTrack.setEnabled(true)
        //let addedAudioStream=localStream.addAudioTrack(audioTrack)
        
        ///print("audio stream \(addedAudioStream)")
        //localStream.addAudioTrack(mediaAudioLabel!)
        print("localStreammm ")
        print(localStream.description, terminator: "")
        //^^^localVideoTrack.addRenderer(localView)
        return localStream
    }
*/
    
    /*func didReceiveRemoteAudioTrack(remoteAudioTrack:RTCAudioTrack)
    {
        print("didreceiveremoteaudiotrack")
        
        /////self.rtcVideoTrackReceived=remoteAudioTrack
        
        ///////HANDLE AUDIO RENDER UI
        
        /*self.rtcVideoTrackReceived.addRenderer(self.remoteView)
        self.remoteView.hidden=true // ^^^^newww
        if(self.screenshared==true){
        self.remoteView.hidden=false
        }
        
        self.localViewOutlet.addSubview(self.remoteView)
        
        self.localViewOutlet.updateConstraintsIfNeeded()
        self.remoteView.setNeedsDisplay()
        self.localViewOutlet.setNeedsDisplay()
        */
        
    }*/
    
    
    func createLocalVideoTrack()->RTCVideoTrack{
        //var localVideoTrack:RTCVideoTrack
        var cameraID:NSString!
        for aaa in AVCaptureDevice.devicesWithMediaType(AVMediaTypeVideo)
        {
            //self.rtcCaptureSession=aaa.captureSession
            if aaa.position==AVCaptureDevicePosition.Front
            {
                print(aaa.localizedName!)
                cameraID=aaa.localizedName!!
                print("got front cameraaa as id \(cameraID)")
                break
            }
            
        }
        if cameraID==nil
            
        {print("failed to get front camera")}
        
        //AVCaptureDevice
        let capturer=RTCVideoCapturer(deviceName: cameraID! as String)
        
        print(capturer.description)
        
        var VideoSource:RTCVideoSource
        
        VideoSource=rtcFact.videoSourceWithCapturer(capturer, constraints: nil)
        self.rtcLocalVideoTrack=nil
        self.rtcLocalVideoTrack=rtcFact.videoTrackWithID("ARDAMSv0", source: VideoSource)
        print("sending localVideoTrack")
        return self.rtcLocalVideoTrack
        
    }
    
    
    
    
   /*
    func didReceiveRemoteVideoTrack(remoteVideoTrack:RTCVideoTrack)
    {//..******************
        print("didreceiveremotevideotrack")
        ////dispatch_async(dispatch_get_main_queue(), {
        
        
        //////CODE TO RENDER REMOTE VIDEO
        
        /*
        self.rtcVideoTrackReceived=remoteVideoTrack
        /////////self.remoteView=RTCEAGLVideoView(frame: CGRect(x: 0, y: 0, width: 500, height: 500))
        //////////self.remoteView.drawRect(CGRect(x: 0, y: 0, width: 500, height: 500))
        
        self.rtcVideoTrackReceived.addRenderer(self.remoteView)
        //////////////remoteVideoTrack.addRenderer(self.remoteView)
        self.remoteView.hidden=true // ^^^^newww
        if(self.screenshared==true){
            self.remoteView.hidden=false
        }
        
        self.localViewOutlet.addSubview(self.remoteView)
        
        ///self.localViewOutlet.addSubview(self.remoteView)
        self.localViewOutlet.updateConstraintsIfNeeded()
        //////////self.remoteView.updateConstraintsIfNeeded()
        self.remoteView.setNeedsDisplay()
        self.localViewOutlet.setNeedsDisplay()
        
        */
        
        /// })
        // }
        
    }
    */
    
    
    func peerConnection(peerConnection: RTCPeerConnection!, addedStream stream: RTCMediaStream!) {
        print("added stream video \(stream.debugDescription)")
        print(stream.videoTracks.count)
        print(stream.audioTracks.count)
        
        // dispatch_async(dispatch_get_main_queue(), {
        
        self.rtcRemoteVideoStream=stream
        if(stream.videoTracks.count>0)
        {print("remote video track count is greater than one")
            let remoteVideoTrack=stream.videoTracks[0] as! RTCVideoTrack
            dispatch_async(dispatch_get_main_queue(), {
                
                self.delegate.didReceiveRemoteVideoTrack(remoteVideoTrack)
            })
            
        }
        
        // })
        
        
    }
    func peerConnection(peerConnection: RTCPeerConnection!, didOpenDataChannel dataChannel: RTCDataChannel!) {
        print(".................. did open data channel")
        print(dataChannel.description)
        
    }
    func peerConnection(peerConnection: RTCPeerConnection!, gotICECandidate candidate: RTCICECandidate!) {
        print("got ice candidate")
        
        //// dispatch_async(dispatch_get_main_queue(), {
        
        ////////print(candidate.description)
        
        var cnd=JSON(["sdpMLineIndex":candidate.sdpMLineIndex,"sdpMid":candidate.sdpMid!,"candidate":candidate.sdp!])
        
        var aa=JSON(["msgVideo":["by":currentID!,"to":otherID,"ice":cnd.object,"type":"ice"]])
        //print(aa.description)
        socketObj.socket.emit("msgVideo",["by":currentID!,"to":otherID,"ice":cnd.object,"type":"ice"])
        
        
        //// })
    }
    func peerConnection(peerConnection: RTCPeerConnection!, iceConnectionChanged newState: RTCICEConnectionState) {
        ////////print("............... ice connection changed new state is \(newState.value.description)")
        
    }
    func peerConnection(peerConnection: RTCPeerConnection!, iceGatheringChanged newState: RTCICEGatheringState) {
        ///////// print("............... ice gathering changed \(newState.value.description)")
    }
    func peerConnection(peerConnection: RTCPeerConnection!, removedStream stream: RTCMediaStream!) {
        print("...............removed stream")
        
    }
    func peerConnection(peerConnection: RTCPeerConnection!, signalingStateChanged stateChanged: RTCSignalingState) {
        //////// print("................signalling state changed")
        ////////print(stateChanged.value)
        
    }
    func peerConnectionOnRenegotiationNeeded(peerConnection: RTCPeerConnection!) {
        ///////////print("............... on negotiation needed")
        
    }
    
    func peerConnection(peerConnection: RTCPeerConnection!, didCreateSessionDescription sdp: RTCSessionDescription!, error: NSError!) {
        print("did create offer/answer session description success")
        //^^^^^^^^^^^^^^^^^^^newwwww
        ////dispatch_async(dispatch_get_main_queue(), {
        
        ///if (error==nil && self.pc.localDescription == nil){
        if (error==nil){
            //SCREEN CLASS WILL HANDLE
            
             if(self.videoshared == true)
            {
            print("\(sdp.type) creatddddd")
            print(sdp.debugDescription)
            let sessionDescription=RTCSessionDescription(type: sdp.type!, sdp: sdp.description)
            
            self.pc.setLocalDescriptionWithDelegate(self, sessionDescription: sessionDescription)
            
            print(["by":currentID!,"to":otherID,"sdp":["type":sdp.type!,"sdp":sdp.description],"type":sdp.type!,"username":username!])
            
            socketObj.socket.emit("msg",["by":currentID!,"to":otherID,"sdp":["type":sdp.type!,"sdp":sdp.description],"type":sdp.type!,"username":username!])
            print("\(sdp.type) emitteddd")
            }
            
            if(self.pc.localDescription == nil){
                print("\(sdp.type) creatddddd")
                print(sdp.debugDescription)
                let sessionDescription=RTCSessionDescription(type: sdp.type!, sdp: sdp.description)
                
                self.pc.setLocalDescriptionWithDelegate(self, sessionDescription: sessionDescription)
                
                ////print(["by":currentID!,"to":otherID,"sdp":["type":sdp.type!,"sdp":sdp.description],"type":sdp.type!,"username":username!])
                
                socketObj.socket.emit("msgVideo",["by":currentID!,"to":otherID,"sdp":["type":sdp.type!,"sdp":sdp.description],"type":sdp.type!,"username":username!])
                print("\(sdp.type) emitteddd")
            }
            
        }
        else
        {
            print("sdp created with error \(error.localizedDescription)")
        }
        
        
        //// })
        
    }
    func peerConnection(peerConnection: RTCPeerConnection!, didSetSessionDescriptionWithError error: NSError!) {
        //print(error.localizedDescription)
        
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
                    self.pc.createAnswerWithDelegate(self, constraints: self.rtcMediaConst)
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
    
    func socketReceivedMSGWebRTCVideo(message:String,data:AnyObject!)
    {print("socketReceivedMSGWebRTC inside")
        switch(message){
        case "msgVideo":
            print("msgVideo received from socket")
            handlemsg(data)
            
        case "msg":
            print("error old msg received from socket")
            
        default:print("wrong video socket msg received \(message)")
        }
    }
    
    func socketReceivedOtherWebRTCVideo(message:String,data:AnyObject!)
    {
        print("socketReceivedOtherWebRTC inside")
        switch(message){
            
        case "peer.connected.new":
            handlePeerConnected(data)
            
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
        
    }
    
    func socketReceivedMessageWebRTCVideo(message:String,data:AnyObject!)
    {print("socketReceivedMessageWebRTC inside")
        switch(message){
            
        case "message":
            handleMessage(data)
            
            
        default:print("wrong socket video message received\(message)")
            
        }
    }
    
    
    
    func handlemsg(data:AnyObject!)
    {
        print("msg reeived.. check if offer answer or ice")
        var msg=JSON(data)
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
                self.createPeerConnectionObject()
            }
            //^^^^^^^^^^^^^^^^^^ check this for second call already have localstream
            //////self.CreateAndAttachDataChannel()
            
            //************************************************
            //DONT ATTACH ANY STREAM
            //////self.addLocalMediaStreamToPeerConnection()
            
            
            //^^^^^^^^^^^^^^^^^^^^^^^newwwwww self.pc.addStream(self.getLocalMediaStream())
            otherID=msg[0]["by"].int!
            currentID=msg[0]["to"].int!
            
            
            if(msg[0]["username"].description != username! && self.pc.remoteDescription == nil){
                var sessionDescription=RTCSessionDescription(type: msg[0]["type"].description, sdp: msg[0]["sdp"]["sdp"].description)
                self.pc.setRemoteDescriptionWithDelegate(self, sessionDescription: sessionDescription)
            }
            
        }
        
        if(msg[0]["type"].string! == "answer" && msg[0]["by"].int != currentID)
        {//SCREEN SHARED CODE
            if(self.videoshared==true){
            print("answer received screen")
            var sessionDescription=RTCSessionDescription(type: msg[0]["type"].description, sdp: msg[0]["sdp"]["sdp"].description)
            self.pc.setRemoteDescriptionWithDelegate(self, sessionDescription: sessionDescription)
            }
            
            
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
    
    func handlePeerConnected(data:AnyObject!)
    {
        print("received peer.connected.new Video obj from server")
        
        //Both joined same room
        
        var datajson=JSON(data!)
        print(datajson.debugDescription)
        
        if(datajson[0]["username"].description != username!){
            otherID=datajson[0]["id"].int
            iamincallWith=datajson[0]["username"].description
            isInitiator=true
            iamincallWith = datajson[0]["username"].description
            
            
            //////optional
            if(self.pc == nil) //^^^^^^^^^^^^^^^^^^newwww tryyy
            {
                self.createPeerConnectionObject()
            }
            /////////////////////self.CreateAndAttachDataChannel()
            //***************************************************
            //DONT ATTACH ANY STREAM
            //self.addLocalMediaStreamToPeerConnection()
            ////////^^^^^print("peer attached stream")
            
            
            self.pc.createOfferWithDelegate(self, constraints: self.rtcMediaConst!)
        }
        
    }
    
    
    
    func handlePeerDisconnected(data:AnyObject!)
    {
        print("received peer.disconnected video obj from server")
        
        //Both joined same room
        
        var datajson=JSON(data!)
        print(datajson.debugDescription)
        
        if(datajson[0]["id"].int == otherID)
        {
            if(self.pc != nil)
            {
                print("peer disconnectedddd received \(datajson[0])")
                
                print("hangupppppp received \(datajson.debugDescription)")
                self.remoteDisconnected()
                
                
                socketObj.socket.emit("leave",["room":joinedRoomInCall])
                self.disconnect()
            }
            
        }
    }
    
    func handleConferenceStream(data:AnyObject!)
    {
        print("received conference.streamVideo obj from server")
        var datajson=JSON(data!)
        print(datajson.debugDescription)
        /////////////////////////////////VIDEO AND SCREEN
        
        if(datajson[0]["username"].debugDescription != username! && datajson[0]["type"].debugDescription == "video" && datajson[0]["action"].boolValue==true )
        {self.videoshared=true
        //Handle Screen sharing
        print("handle video sharing")
        self.pc.createOfferWithDelegate(self, constraints: self.rtcMediaConst)
        }
        //TOGLE CODE VIDEO
       /*if(datajson[0]["username"].debugDescription != username! && datajson[0]["type"].debugDescription == "video" && self.rtcRemoteVideoStream.videoTracks.count>0)
        {
        print("toggle remote video stream")
        ////////////self.rtcVideoTrackReceived.setEnabled((datajson[0]["action"].bool!))
        if(datajson[0]["action"].bool! == false)
        {
            ////UI CODE VIDEO
        /*self.localView.hidden=true
        self.remoteView.hidden=true
        }
        if(datajson[0]["action"].bool! == true)
        {
        self.localView.hidden=true
        self.remoteView.hidden=false
        }*/
        }
        }*/
    }
    
    func handleMessage(data:AnyObject!)
    {
        var msg=JSON(data)
        print(msg.debugDescription)
        print("confused msg received \(msg.description)")
        //*****************************CONFUSED JOINING ROOM AGAIN
        /*if(msg[0]["type"]=="room_name")
        {
            
            ////////////////////////////////////////////////////////////////
            //////////////^^^^^^^^^^^^^^^^^^^^^^newww isInitiator=false
            //What to do if already in a room??
            
            if(joinedRoomInCall=="")
            {
                var CurrentRoomName=msg[0]["room"].string!
                print("got room name as \(joinedRoomInCall)")
                print("trying to join room")
                
                /*socketObj.socket.emitWithAck("init", ["room":CurrentRoomName,"username":username!])(timeoutAfter: 1500000000) {data in
                print("room joined got ack")
                var a=JSON(data)
                print(a.debugDescription)
                currentID=a[1].int!
                joinedRoomInCall=msg[0]["room"].string!
                print("current id is \(currentID)")
                //}
                }*/
                socketObj.socket.emitWithAck("init.new", ["room":CurrentRoomName,"username":username!,"supportcall":""])(timeoutAfter: 1500000000) {data in
                    print("room joined got ack")
                    var a=JSON(data)
                    print(a.debugDescription)
                    currentID=a[1].int!
                    joinedRoomInCall=msg[0]["room"].string!
                    print("current id is \(currentID)")
                    //}
                }
            }
                ////////////////////////newwwwwww
            else
            {
                isInitiator = false
            }
            
        }*/
        
        if(msg[0]=="Accept Call")
        {var roomname=""
            if(joinedRoomInCall == "")
            {
                print("inside accept call")
                /// roomname="test"
                if(isConference == true)
                {print("conference name is\(ConferenceRoomName)")
                    roomname=ConferenceRoomName
                }
                else{
                    roomname=self.randomStringWithLength(9) as String
                }
                //iamincallWith=username!
                areYouFreeForCall=false
                joinedRoomInCall=roomname as String
                socketObj.socket.emitWithAck("init.new", ["room":joinedRoomInCall,"username":username!])(timeoutAfter: 150000000) {data in
                    print("room joined by got ack")
                    var a=JSON(data)
                    print(a.debugDescription)
                    currentID=a[1].int!
                    print("current id is \(currentID)")
                    var aa=JSON(["msgVideo":["type":"room_name","room":roomname as String],"room":globalroom,"to":iamincallWith!,"username":username!])
                    print(aa.description)
                    socketObj.socket.emit("message",aa.object)
                    
                }//end data
            }
            
            
        }
        if(msg[0]=="Reject Call")
        {
            
            print("inside reject call")
            var roomname=""
            iamincallWith=""
            areYouFreeForCall=true
            callerName=""
            joinedRoomInCall=""
            if(self.pc != nil)
            {self.pc.close()}
            /////////////////////////////////self.dismissViewControllerAnimated(true, completion: nil)
            
            
        }
        
        
        if(msg[0]=="hangup")
        {
            if(self.pc != nil)
            {
                print("hangupppppp received \(msg[0])")
                
                print("hangupppppp received \(msg.debugDescription)")
                self.remoteDisconnected()
                
                
                socketObj.socket.emit("leave",["room":joinedRoomInCall])
                self.disconnect()
            }
            
        }
        
        if(msg[0]["type"]=="Missed")
        {
            let todoItem = NotificationItem(otherUserName: "\(iamincallWith!)", message: "You have received a missed call", type: "missed call", UUID: "111", deadline: NSDate())
            notificationsMainClass.sharedInstance.addItem(todoItem) // schedule a local notification to persist this item
            
        }
        if(msg[0]=="Conference Call")
        {
            var roomname=""
            if(joinedRoomInCall == "")
            {
                print("inside accept call")
                if(isConference == true)
                {
                    roomname=ConferenceRoomName
                }
                else{
                    roomname=self.randomStringWithLength(9) as String
                }
                //iamincallWith=username!
                areYouFreeForCall=false
                joinedRoomInCall=roomname as String
                socketObj.socket.emitWithAck("init.new", ["room":joinedRoomInCall,"username":username!])(timeoutAfter: 150000000) {data in
                    print("room joined by got ack")
                    var a=JSON(data)
                    print(a.debugDescription)
                    currentID=a[1].int!
                    print("current id is \(currentID)")
                    var aa=JSON(["msgVideo":["type":"room_name","room":roomname as String],"room":globalroom,"to":iamincallWith!,"username":username!])
                    print(aa.description)
                    socketObj.socket.emit("message",aa.object)
                }}
            
        }
        
        
        
        
        
        
    }
   /* func channel(channel: RTCDataChannel!, didChangeBufferedAmount amount: UInt) {
        print("didChangeBufferedAmount \(amount)")
        
    }
    func channel(channel: RTCDataChannel!, didReceiveMessageWithBuffer buffer: RTCDataBuffer!) {
        print("didReceiveMessageWithBuffer")
        print(buffer.data.debugDescription)
        var channelJSON=JSON(buffer.data!)
        print(channelJSON.debugDescription)
        
    }
    func channelDidChangeState(channel: RTCDataChannel!) {
        print("channelDidChangeState")
        print(channel.debugDescription)
        
    }*/
    
    

    
}

protocol ConferenceVideoViewDelegate:class
{
    //func didReceiveRemoteAudioTrack(remoteAudioTrack:RTCAudioTrack);
    //func didReceiveLocalVideoTrack(localVideoTrack:RTCVideoTrack);
    func didReceiveRemoteVideoTrack(remoteVideoTrack:RTCVideoTrack);
   
}

