//
//  MeetingRoomVideo.swift
//  Chat
//
//  Created by Cloudkibo on 07/02/2016.
//  Copyright © 2016 MyAppTemplates. All rights reserved.
//

import Foundation
import AVFoundation
import Foundation
import SwiftyJSON
import UIKit

class MeetingRoomVideo:NSObject,RTCPeerConnectionDelegate,RTCSessionDescriptionDelegate,RTCMediaStreamTrackDelegate{
    var localvideoshared=false
    var pc:RTCPeerConnection!
    var rtcMediaConst:RTCMediaConstraints!
    var rtcLocalVideoTrack:RTCVideoTrack!
    var rtcRemoteVideoTrack:RTCVideoTrack!
    var rtcLocalstream:RTCMediaStream!
    var rtcStreamReceived:RTCMediaStream!
    var streambackup:RTCMediaStream!
    var delegateConference:ConferenceDelegate!
    var videoshared=false
    var delegateConferenceEnd:ConferenceEndDelegate!
    override init()
    {
        
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
        rtcFact=RTCPeerConnectionFactory()*/
        super.init()
    }
    
    func mediaStreamTrackDidChange(_ mediaStreamTrack: RTCMediaStreamTrack!) {
        
        print("****************** rtc media stream video track changed")
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
        
        //march 30 2016 --- newwww commented
        /*if(self.pc != nil)
        {
            print("pc closeddddd")
            
            self.pc.close()
            self.pc = nil
        }*/
        
        //---
        
        ///////////////////////////
        if(rtcFact == nil)
            
        {RTCPeerConnectionFactory.initializeSSL()
            rtcFact=RTCPeerConnectionFactory()
        }
        ////////////////////////
        socketObj.socket.emit("logClient","IPHONE-LOG: \(username!) creating video peer connection object with \(iamincallWith!)")
        
        //march 30 2016 new if
        if(pc == nil)
        {
        self.pc=rtcFact.peerConnection(withICEServers: rtcICEarray, constraints: self.rtcMediaConst, delegate:self)
        }
        
        //march 30 2016 --- newwww commented
        /*if(rtcLocalstream != nil)
        {
            
            pc.addStream(streambackup)
        }
        else{
            print("no local stream added")
        }
        */
    }
    
    /*func createLocalVideoStream()->RTCMediaStream
    {print("inside createlocalvideostream")
        
        var localStream:RTCMediaStream!
        
        localStream=rtcFact.mediaStreamWithLabel("ARDAMS")
        
        self.rtcLocalVideoTrack = createLocalVideoTrack()
        if let lvt=self.rtcLocalVideoTrack
        {
            let addedVideo=localStream.addVideoTrack(self.rtcLocalVideoTrack)
            self.rtcLocalstream=localStream
            
            print("video stream \(addedVideo)")
            ////////////////////////////////pc.addStream(self.rtcLocalstream)
            ////++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
            dispatch_async(dispatch_get_main_queue(), {
                //////self.didReceiveLocalVideoTrack(localVideoTrack)
                
                
                self.delegateConference.didReceiveLocalVideoTrack(self.rtcLocalVideoTrack)
                //////self.didReceiveLocalVideoTrack()
            })
            
        }
        print("localStreammm ")
        print(localStream.description, terminator: "")
        //^^^localVideoTrack.addRenderer(localView)
        return localStream
    }
    
    
    
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
        /////////////self.rtcLocalVideoTrack=nil
        self.rtcLocalVideoTrack=rtcFact.videoTrackWithID("ARDAMSv0", source: VideoSource)
        print("sending localVideoTrack")
        return self.rtcLocalVideoTrack
        
    }

*/
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
    
    func toggleVideo(_ videoAction:Bool,s:RTCMediaStream!)
    {
        /*
        toggleVideo: function (p, s) {
        if (!p) {
        peerConnections = {};
        }
        if(p) localVideoShared = true;
        else localVideoShared = false;
        stream = s;
        console.log('letting other peer know that video is being shared')
        socket.emit('conference.streamVideo', { username: username, type: 'video', action: p, id: currentId });
        
*/
        if(videoAction==false)
        {
            pc=nil
            //tryy march 31
            self.rtcLocalVideoTrack=nil
            //////////////////////////^^^^^^^^^^^^^^^^^^newwwww
            
            DispatchQueue.main.async(execute: {
                
                self.delegateConference.didremoveLocalVideoTrack()
            })
        
        }
        localvideoshared=videoAction
        rtcLocalstream=s
        streambackup=s
        
        
        
        /*if(videoAction==false)
        {
           //self.pc=nil
        }
        if(videoAction==true)
        {
            socketObj.socket.emit("logClient","IPHONE-LOG: \(username!) is sharing video")
            //videoshared=false
            localvideoshared=true
            self.rtcLocalstream=s
            self.streambackup=s
           
            ///////march2016 tryyyy
            pc=nil ////march 2016
        }
        else
        {
            socketObj.socket.emit("logClient","IPHONE-LOG: \(username!) is hiding video ")
            localvideoshared=false
            self.streambackup=s
            self.rtcLocalstream=s
            ///////////////////////self.rtcLocalstream=nil
            self.rtcLocalVideoTrack=nil
            //////////////////////////^^^^^^^^^^^^^^^^^^newwwww
          dispatch_async(dispatch_get_main_queue(), {
                
           self.delegateConference.didremoveLocalVideoTrack()
         })
        }
        
        */

        socketObj.socket.emit("conference.streamVideo", ["username":username!,"id":currentID!,"type":"video","action":videoAction])
        
        
        
        
        ///////////////////OLD logicc////////
        /*
        if(self.pc == nil && videoAction == true)
        //if(videoAction==true)
        {
            createPeerConnection()
        }
        if(videoAction==false)
        {
            self.rtcLocalVideoTrack=nil
            self.rtcLocalstream=nil
            //self.pc.close()
            self.pc=nil
            //////////////////^^^^^^^^^^^^newwwww testinggggg
            ////if(videoshared==true)
            ////{createPeerConnection()}
            
            //////////^^^^^^^^^^^^^^^^^^^^^^^^
            
            
            
            ////pc.removeStream(self.rtcLocalstream)
            ////////////^^^^^^^^^^^newwww testttttt
            //if(self.pc != nil){
              //  self.pc=nil}

        }
        socketObj.socket.emit("conference.streamVideo", ["username":username!,"id":currentID!,"type":"video","action":videoAction.boolValue])

*/
        
    }
    
    
    
    func peerConnection(_ peerConnection: RTCPeerConnection!, addedStream stream: RTCMediaStream!) {
        print("video added remote stream count is \(stream.videoTracks.count)")
        
        
        videoshared=true
        ///-----
        self.rtcStreamReceived=stream
        if(stream.videoTracks.count>0)
        {self.rtcRemoteVideoTrack=stream.videoTracks[0] as! RTCVideoTrack
            //////////////////dispatch_async(dispatch_get_main_queue(), {
                
        self.delegateConference.didReceiveRemoteVideoTrack(self.rtcRemoteVideoTrack)
         ///////////////   })
            
        }
        
    }
    func peerConnection(_ peerConnection: RTCPeerConnection!, didCreateSessionDescription sdp: RTCSessionDescription!, error: NSError!) {
        
        print("video did create offer/answer session description success")
        //^^^^^^^^^^^^^^^^^^^newwwww
        ////dispatch_async(dispatch_get_main_queue(), {
        
        ///if (error==nil && self.pc.localDescription == nil){
        if (error==nil && pc != nil){
           ///// if(pc.localDescription==nil){
           /* if(self.videoshared == true)
            {
                print("\(sdp.type) creatddddd")
                print(sdp.debugDescription)
                let sessionDescription=RTCSessionDescription(type: sdp.type!, sdp: sdp.description)
                
                self.pc.setLocalDescriptionWithDelegate(self, sessionDescription: sessionDescription)
                
                print(["by":currentID!,"to":otherID,"sdp":["type":sdp.type!,"sdp":sdp.description],"type":sdp.type!,"username":username!])
                
                socketObj.socket.emit("msgVideo",["by":currentID!,"to":otherID,"sdp":["type":sdp.type!,"sdp":sdp.description],"type":sdp.type!,"username":username!])
                print("\(sdp.type) emitteddd")
            }*/
            if(self.pc.localDescription == nil){
                print("\(sdp.type) creatddddd")
                //print(sdp.debugDescription)
                let sessionDescription=RTCSessionDescription(type: sdp.type!, sdp: sdp.description)
                
                self.pc.setLocalDescriptionWith(self, sessionDescription: sessionDescription)
                
                ////print(["by":currentID!,"to":otherID,"sdp":["type":sdp.type!,"sdp":sdp.description],"type":sdp.type!,"username":username!])
                socketObj.socket.emit("logClient","IPHONE-LOG: \(username!) sending video \(sdp.type) to \(iamincallWith!)")
                socketObj.socket.emit("msgVideo",["by":currentID!,"to":otherID,"sdp":["type":sdp.type!,"sdp":sdp.description],"type":sdp.type!,"username":username!])
                print("\(sdp.type) emitteddd")
         }
            else
            {
                print("local was not nillll")
            }
            ///////}
        }
        else
        {
            if(error != nil)
            {print("sdp created with error \(error.localizedDescription)")}
            if(pc == nil)
            {
                print("error pc is nil")
                
            }
        }
        
    }
    func peerConnection(_ peerConnection: RTCPeerConnection!, didOpen dataChannel: RTCDataChannel!) {
        
        
    }
    func peerConnection(_ peerConnection: RTCPeerConnection!, didSetSessionDescriptionWithError error: NSError!) {
        
        print("inside videodidSetSessionDescriptionWithError")
        
        // If we are acting as the callee then generate an answer to the offer.
        //^^^^^^^^^^^^^^newwwwwwww
        /////dispatch_async(dispatch_get_main_queue(), {
        
        if (error == nil && self.pc != nil) {
            print("did set remote sdp no error")
            
            print("isinitiator is \(isInitiator)")
            ///march 30 2016 commented
            if(pc.localDescription == nil && videoshared == false)
            
                {
                    socketObj.socket.emit("logClient","IPHONE-LOG: \(username!) created video answer for \(iamincallWith!)")
                    self.pc.createAnswer(with: self, constraints: self.rtcMediaConst)
                }
                    /* if isInitiator == true &&
                    self.pc.localDescription == nil {
                    print("creating answer")
                    //^^^^^^^^^ new self.pc.addStream(self.rtcMediaStream)
                    self.pc.createAnswerWithDelegate(self, constraints: self.rtcMediaConst)

*/
            
            else
                {
                    print("local not nil or videoshared is true")
                    ///////////
                    //print(self.pc.localDescription.description)
                
                }
            
        } else {
            print(".......sdp set ERROR: \(error.localizedDescription)", terminator: "")
        }
        ///// })
        

        
    }
    func peerConnection(_ peerConnection: RTCPeerConnection!, gotICECandidate candidate: RTCICECandidate!) {
        print("got icecand video")
        var cnd=JSON(["sdpMLineIndex":candidate.sdpMLineIndex,"sdpMid":candidate.sdpMid!,"candidate":candidate.sdp!])
        
        var aa=JSON(["msgVideo":["by":currentID!,"to":otherID,"ice":cnd.object,"type":"ice"]])
        //print(aa.description)
        
        socketObj.socket.emit("msgVideo",["by":currentID!,"to":otherID,"ice":cnd.object,"type":"ice"])
        socketObj.socket.emit("logClient","IPHONE-LOG: \(username!) sent video ice candidates to \(iamincallWith!)")
        
    }
    func peerConnection(_ peerConnection: RTCPeerConnection!, iceConnectionChanged newState: RTCICEConnectionState) {
        
        
    }
    func peerConnection(_ peerConnection: RTCPeerConnection!, iceGatheringChanged newState: RTCICEGatheringState) {
        
        
    }
    func peerConnection(_ peerConnection: RTCPeerConnection!, removedStream stream: RTCMediaStream!) {
        
        
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
        
                print("msgVideo reeived.. check if offer answer or ice")
        //print(data.description)
        var msg=JSON(data)
        print(msg.description)
        print(msg[0].description)
        iamincallWith=msg[0]["username"].debugDescription
        
        /////march 30 2016 newwwww
        

        if(self.pc == nil)
        {
            self.createPeerConnection()
        }
        
        if(msg[0]["type"].string! == "offer" && msg[0]["by"].intValue != currentID)
        {
            socketObj.socket.emit("logClient","IPHONE-LOG: \(username!) received video offer from \(iamincallWith!)")
           /* if(rtcLocalVideoTrack != nil || rtcLocalstream != nil)
            {
                rtcLocalstream = nil
                rtcLocalVideoTrack = nil
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    
                    self.delegateConference.didremoveLocalVideoTrack()
                })
                pc=nil
            
            }*/
            
            
            
            
            /////march 2016 workaroun commented out
            
            
            if(rtcStreamReceived != nil)
            {
                rtcStreamReceived = nil
                rtcRemoteVideoTrack = nil
                
                self.delegateConference.didRemoveRemoteVideoTrack()
                
                
                ////workaround
                
                videoshared=false
                //
                self.pc=nil
                //march 2016 new added
                 self.createPeerConnection()
            }
            
            
            //^^^^^^^^^^^^^^^^newwwww if(joinedRoomInCall == "" && isInitiator.description == "false")
            
            
            print("offer received")
            //var sdpNew=msg[0]["sdp"].object
            
            
            
            //////   march2016 tryyyyy
            //pc=nil ////////////march 2016
            //videoshared=false //march 2016
            
            
            //march 30 2016 commenting
           /* if(self.pc == nil) //^^^^^^^^^^^^^^^^^^newwwww tryyy
            {
                self.createPeerConnection()
            }
            */
            
            
            //^^^^^^^^^^^^^^^^^^ check this for second call already have localstream
            ////self.CreateAndAttachDataChannel()
            
            
            /////////self.rtcLocalstream=self.createLocalVideoStream()
            ///if(pc.localStreams.count<1)
            ///////{
            
            ////if(rtcLocalstream != nil || streambackup != nil)
            //{
                pc.add(streambackup)
            ///}
            
            
            
            
            ////workaround march 2016
            
            
            ////////}
                    //NSLog("First Log")
            
                    ///////////////////^^^^^^^^^^newwwww pc.addStream(self.rtcLocalstream)
            
            
            /*


            if(otherStream[data.by]){ // workaround for firefox as it doesn't support renegotiation (ice restart unsupported error in firefox)
            otherStream[data.by] = false;
            delete peerConnections[data.by];
            pc = getPeerConnection(data.by);
            }
            pc.addStream(stream);
*/
            //^^^^^^^^^^^^^^^^^^^^^^^newwwwww self.pc.addStream(self.getLocalMediaStream())
            otherID=msg[0]["by"].int!
            currentID=msg[0]["to"].int!
            iamincallWith=msg[0]["username"].description
            
            print("...sending remotedesciption")
            /////^^^^^^^^^^^^^^^^^^newwwwww testtttif(msg[0]["username"].description != username! && self.pc.remoteDescription == nil){
            if(msg[0]["username"].description != username!){
                var sessionDescription=RTCSessionDescription(type: msg[0]["type"].description, sdp: msg[0]["sdp"]["sdp"].description)
                self.pc.setRemoteDescriptionWithDelegate(self, sessionDescription: sessionDescription)
                socketObj.socket.emit("logClient","IPHONE-LOG: \(username!) set video remote sdp")
                ////self.pc.createAnswerWithDelegate(self, constraints: self.rtcMediaConst)
            }
            
        }
        
        if(msg[0]["type"].string! == "answer" && msg[0]["by"].int != currentID)
        {
            /*if(self.videoshared==true){
                print("answer received video")
                var sessionDescription=RTCSessionDescription(type: msg[0]["type"].description, sdp: msg[0]["sdp"]["sdp"].description)
                self.pc.setRemoteDescriptionWithDelegate(self, sessionDescription: sessionDescription)
            }
            */
            
            
           ///// if(isInitiator.description == "true")
       //////////// if(isInitiator.description == "true" && self.pc.remoteDescription == nil)
            //////////{
            
            socketObj.socket.emit("logClient","IPHONE-LOG: \(username!) received video answer from \(iamincallWith!)")
                print("answer received")
                var sessionDescription=RTCSessionDescription(type: msg[0]["type"].description, sdp: msg[0]["sdp"]["sdp"].description)
            
                self.pc.setRemoteDescriptionWithDelegate(self, sessionDescription: sessionDescription)
            /////////////^^^^^^^^newwww}
            
        }
        if(msg[0]["type"].string! == "ice")
        {print("ice received of other peer")
            if(msg[0]["ice"].description=="null" && msg[0]["by"].intValue != currentID)
            {print("last iceVideo as null so ignore")}
            else{
                if(msg[0]["by"].intValue != currentID)
                {var iceCandidate=RTCICECandidate(mid: msg[0]["ice"]["sdpMid"].description, index: msg[0]["ice"]["sdpMLineIndex"].int!, sdp: msg[0]["ice"]["candidate"].description)
                    //print(iceCandidate.description)
                    
                    
                    /////////////neww testttttt
                    if(self.pc != nil)
                    {
                    //////if(self.pc.localDescription != nil && self.pc.remoteDescription != nil)
                        
                    ////{
                        
                        socketObj.socket.emit("logClient","IPHONE-LOG: \(username!) is adding ice candidates from \(iamincallWith!)")

                        var addedcandidate=self.pc.addICECandidate(iceCandidate)
                        print("iceVideo candidate added \(addedcandidate)")
                    ////////}
                    }
                }
            }
            
        }
       
    }
    
        

    func handleConferenceStream(_ data:AnyObject!)
    {
        var datajson=JSON(data!)
        print(datajson.debugDescription)
        if(datajson[0]["username"].debugDescription != username!){
            
            if(datajson[0]["type"].debugDescription == "video" && datajson[0]["action"].boolValue==false) {
                print("video falseeeeeeeee")
                print("here .. 1")
                socketObj.socket.emit("logClient","IPHONE-LOG: \(username!)was informed that \(iamincallWith!) is hiding video")
                //////tryyyyy 28march2016
                videoshared=false
                rtcStreamReceived=nil
                rtcRemoteVideoTrack=nil
                //////dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.delegateConference.didRemoveRemoteVideoTrack()
                //////////RESOLVED PC NOT NILL///////////
                //////// })
                
                //video=false
                
                
                //pc.close()
                /////////////////////////////////pc=nil
                // pc=nil
            }

            
        if(rtcStreamReceived != nil && datajson[0]["action"].boolValue==true)
        {
            print("here .. 2")
                return
        }
            if(datajson[0]["type"].debugDescription == "video" && datajson[0]["action"].boolValue==true )
            { //video=true
                videoshared=true
                socketObj.socket.emit("logClient","IPHONE-LOG: \(username!)was informed that \(iamincallWith!) is sharing video")

                print("here .. 31")
                ///////////////////////////////^^^^^^^^^^^^^^^^^^newwwww
               ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                if(localvideoshared==true) //localvideoshared==true
                {print("here .. 32")
                    rtcStreamReceived=nil
                    rtcRemoteVideoTrack=nil
                    self.pc=nil
                    
                    ////march 30 2016
                    //---
                    videoshared=false
                }
                //modify march 2016 commented
                /*rtcStreamReceived=nil
                rtcRemoteVideoTrack=nil
                pc=nil
*/
                
                
                self.createPeerConnection()
                
                
                self.sendOffer()

            }
            //march 30 2016 remove else
           //// else
            ////{
                
            //march 30 2016 add else
            else
                {
                    print("here .. 4")
                    videoshared=false
                    rtcStreamReceived=nil
                    rtcRemoteVideoTrack=nil
                    pc=nil
                    //-------- might add remove remotevideo
            }
            }
        ////}
        /*
        if(data.action) {
        if(localVideoShared) { // workaround for firefox as it doesn't support renegotiation (ice restart unsupported error in firefox)
        otherStream[data.id] = false;
        delete peerConnections[data.id];
        }
        makeOffer(data.id);
        } else {
        otherStream[data.id] = false;
        delete peerConnections[data.id];
        }
        }
*/
        
        
        ////////////////////OLD LOGICCCC//////////////
        /*var datajson=JSON(data!)
        print(datajson.debugDescription)
        
        if(datajson[0]["username"].debugDescription != username! && datajson[0]["type"].debugDescription == "video" && datajson[0]["action"].boolValue==true )
        {
            if(videoshared==true)
            {
                rtcRemoteVideoTrack=nil
                rtcStreamReceived=nil
                pc=nil
            }
            if(pc == nil)
            {
                createPeerConnection()
            }
            self.pc.createOfferWithDelegate(self, constraints: self.rtcMediaConst)
            
            
        }
        else{
            rtcRemoteVideoTrack=nil
            rtcStreamReceived=nil
            pc=nil
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.delegateConference.didRemoveRemoteVideoTrack()
            })
        }
        
        */
   /////////////////////////////////VIDEO AND SCREEN
  
        /*if(self.pc == nil)
    {
        createPeerConnection()
        
    }
    if(datajson[0]["username"].debugDescription != username! && datajson[0]["type"].debugDescription == "video" && datajson[0]["action"].boolValue==true )
    {/////////self.videoshared=true
        //Handle Screen sharing
        print("remote is sharing video")
        otherID=datajson[0]["id"].int
        iamincallWith=datajson[0]["username"].description
        isInitiator=true
        videoshared=true
        print("handle video sharing")
        self.pc.createOfferWithDelegate(self, constraints: self.rtcMediaConst)
    }
        
        if(datajson[0]["id"].int != currentID! && datajson[0]["type"].debugDescription == "video" && datajson[0]["action"].boolValue==false)
        {print("remote is hiding video")
            self.rtcRemoteVideoTrack=nil
            //self.pc.close()
            //////////
            isInitiator=false/////////////^^^^^^^^^^^newwwwwww
            self.videoshared=false
            self.rtcStreamReceived=nil
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.delegateConference.didRemoveRemoteVideoTrack()
            })
            //self.pc.removeStream(rtcLocalstream)
            //self.pc.close()
            self.pc=nil
            /*if(rtcLocalstream == nil)
            {self.pc=nil}
            else
            {self.pc.close()}*/
        }
        */
        
    }
func addHandlers()
{
    
    socketObj.socket.on("msgVideo"){data,ack in
        
        //self.delegateWebRTCVideo.socketReceivedMSGWebRTCVideo("msgVideo", data: data)
        
        //print("msgVideo reeived.. check if offer answer or ice")
        print("msgVideo received from socket")
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
            //pc.getStatsWithDelegate(<#T##delegate: RTCStatsDelegate!##RTCStatsDelegate!#>, mediaStreamTrack: <#T##RTCMediaStreamTrack!#>, statsOutputLevel: <#T##RTCStatsOutputLevel#>)
            
        }
        
    }
    
    
    socketObj.socket.on("conference.streamVideo"){data,ack in
        
        print("received conference.streamVideo obj from server")
        self.handleConferenceStream(data as AnyObject!)
        //self.delegateWebRTCVideo.socketReceivedOtherWebRTCVideo("conference.streamVideo", data: data)
        
    }
    
    socketObj.socket.on("conference.disconnected.new"){data,ack in
        
        print("received conference.disconnected.new obj from server")
        self.rtcRemoteVideoTrack=nil
        self.rtcStreamReceived=nil
        self.delegateConference.didRemoveRemoteVideoTrack()
        self.delegateConferenceEnd.disconnectAll()
        //////self.handleConferenceStream(data)
        //self.delegateWebRTCVideo.socketReceivedOtherWebRTCVideo("conference.streamVideo", data: data)
        
    }
    
    /*socketObj.socket.on("peer.stream"){data,ack in
    print("received peer.stream obj from server")
    var datajson=JSON(data)
    print(datajson.debugDescription)
    
    }
    */
    socketObj.socket.on("peer.disconnected.new"){data,ack in
        print("video channel received peer.disconnected.new obj from server")
        var datajson=JSON(data)
        print(datajson.debugDescription)
        
        self.rtcRemoteVideoTrack=nil
        self.rtcStreamReceived=nil
        self.delegateConference.didRemoveRemoteVideoTrack()
        self.delegateConferenceEnd.disconnectAll()
        //handlePeerDisconnected(data)

        //self.delegateWebRTCVideo.socketReceivedOtherWebRTCVideo("peer.disconnected.new", data: data)
        
    }
    
    
    socketObj.socket.on("message"){data,ack in
        print("received messageee33")
       // self.delegateWebRTCVideo.socketReceivedMessageWebRTCVideo("message",data: data)
        
        
        
    }


        
        
    }
    

    func removeLocalMediaStreamFromPeerConnection()
    {
        
        //self.pc.removeStream(stream)
        
        if((self.rtcLocalVideoTrack) != nil)
        {self.rtcLocalVideoTrack=nil
            self.rtcLocalstream=nil
        
            print("remove localtrack renderer")
            ////////// ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^self.rtcLocalVideoTrack.removeRenderer(self.localView)
        }
        /*if((self.rtcVideoTrackReceived) != nil)
        {print("remove remotetrack renderer")
        self.rtcVideoTrackReceived.removeRenderer(self.remoteView)
        }
        */
        print("out of removing localrenderer")
        
        ///self.rtcLocalVideoStream=nil
        
        
    }
    
}

protocol ConferenceDelegate:class
{
    func didReceiveRemoteVideoTrack(_ remoteAudioTrack:RTCVideoTrack);
    func didRemoveRemoteVideoTrack();
    //func didReceiveLocalVideoTrack(localVideoTrack:RTCVideoTrack);
    func didReceiveLocalVideoTrack(_ remoteVideoTrack:RTCVideoTrack);
    func didremoveLocalVideoTrack();
}
