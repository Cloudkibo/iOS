//
//  VideoViewController.swift
//  Chat
//
//  Created by Cloudkibo on 03/11/2015.
//  Copyright (c) 2015 MyAppTemplates. All rights reserved.
//

import UIKit
import AVFoundation
import Foundation
import SwiftyJSON



class VideoViewController: UIViewController,RTCPeerConnectionDelegate,RTCSessionDescriptionDelegate,RTCEAGLVideoViewDelegate {

   
    @IBOutlet var localViewOutlet: UIView!
    var rtcLocalMediaStream:RTCMediaStream!
    var videoAction=false
    var audioAction=true
    var rtcMediaStream:RTCMediaStream!
    var rtcFact:RTCPeerConnectionFactory!
    var pc:RTCPeerConnection!
    //var rtcVideoTrack1:RTCVideoTrack!
    var rtcMediaConst:RTCMediaConstraints!
    var rtcVideoSource:RTCVideoSource!
    var rtcVideoCapturer:RTCVideoCapturer!
    //var rtcVideoTrack:RTCVideoTrack!
    var rtcVideoRenderer:RTCVideoRenderer!
    //var abc:RTCVideoTrack!!
    var rtcLocalVideoTrack:RTCVideoTrack!
    //var currentId:String!
     var rtcICEarray:[RTCICEServer]=[]
    var by:Int!
    var rtcStreamReceived:RTCMediaStream!
    var rtcVideoTrackReceived:RTCVideoTrack!
    var rtcAudioTrackReceived:RTCAudioTrack!
    
    
    
    func randomStringWithLength (len : Int) -> NSString {
        
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        
        var randomString : NSMutableString = NSMutableString(capacity: len)
        
        for (var i=0; i < len; i++){
            var length = UInt32 (letters.length)
            var rand = arc4random_uniform(length)
            randomString.appendFormat("%C", letters.characterAtIndex(Int(rand)))
        }
        
        return randomString
    }
    
    
    func addHandlers()
    {
        socketObj.socket.on("msg"){data,ack in
            println("msg reeived.. check if offer answer or ice")
            var msg=JSON(data!)
            println(msg[0].description)
            
            if(msg[0]["type"].string! == "offer")
            {
                if(joinedRoomInCall == "" && isInitiator.description == "false")
                {
                println("room joined is null")}
                
                println("offer received")
                //var sdpNew=msg[0]["sdp"].object
                self.createPeerConnectionObject()
                self.pc.addStream(self.getLocalMediaStream())
                otherID=msg[0]["by"].int!
                currentID=msg[0]["to"].int!
                
                socketObj.socket.emit("conference.stream", ["username":username!,"id":currentID!,"type":"video","action":"false"])
                socketObj.socket.emit("conference.stream", ["username":username!,"id":currentID!,"type":"audio","action":"true"])
                
                   var sdpNew = msg[0]["sdp"]["sdp"].description.stringByReplacingOccurrencesOfString("\n", withString: "")
                //sdpNew=sdpNew.string!.stringByReplacingOccurrencesOfString("\r", withString: "")
                println("***************** \(sdpNew)")
                var sessionDescription=RTCSessionDescription(type: msg[0]["type"].description, sdp: msg[0]["sdp"]["sdp"].description)
                ////var sessionDescription=RTCSessionDescription(type: "offer", sdp: sdpNew)
               

                self.pc.setRemoteDescriptionWithDelegate(self, sessionDescription: sessionDescription)
                
               // socketObj.socket.emit("msg",["by":currentId!,"to":msg["by"].string!])
                
            }
            if(msg[0]["type"].string! == "answer")
            {
                if(isInitiator.description=="true")
                {println("answer received")
                var sessionDescription=RTCSessionDescription(type: msg[0]["type"].description, sdp: msg[0]["sdp"]["sdp"].description)
                self.pc.setRemoteDescriptionWithDelegate(self, sessionDescription: sessionDescription)
                }
                
            }
            if(msg[0]["type"].string! == "ice")
            {println("ice received of other peer")
                if(msg[0]["ice"].description=="null")
                {println("last ice as null so ignore")}
                else{
                    if(msg[0]["by"].intValue != currentID)
                    {var iceCandidate=RTCICECandidate(mid: msg[0]["ice"]["sdpMid"].description, index: msg[0]["ice"]["sdpMLineIndex"].int!, sdp: msg[0]["ice"]["candidate"].description)
                    println(iceCandidate.description)
                var addedcandidate=self.pc.addICECandidate(iceCandidate)
                println("ice candidate added \(addedcandidate)")
                    }
                //self.pc.addICECandi
                // socketObj.socket.emit("msg",["by":currentId!,"to":msg["by"].string!])
                }
                
            }
            

       
            
        }
        
        //socket.emit('msg', { by: currentId, to: id, sdp: sdp, type: 'offer', username: username });
    }
    
    @IBAction func endCallBtnPressed(sender: AnyObject) {
        
        socketObj.socket.emit("message",["msg":"hangup","room":globalroom,"to":iamincallWith!,"username":username!])
        socketObj.socket.emit("leave",["room":joinedRoomInCall])
        
        //self.rtcMediaStream.removeAudioTrack(self.rtcAudioTrackReceived)
       // self.rtcMediaStream.removeVideoTrack(self.rtcVideoTrackReceived)
        self.pc=nil
        joinedRoomInCall=""
        iamincallWith=""
        isInitiator=false
        areYouFreeForCall=true
        rtcLocalMediaStream.videoTracks[0].stopRunning
        //self.rtcMediaStream.videoTracks[0].stopRunning()
        self.rtcLocalVideoTrack=nil
        self.rtcLocalVideoTrack=nil
        self.rtcVideoTrackReceived=nil
        self.rtcAudioTrackReceived=nil
        
        rtcLocalMediaStream=nil //test and try-------------
        //rtcMediaStream=nil //test and try---------------------

        //AVCaptureSession.stopRunning(<#AVCaptureSession#>)
        dismissViewControllerAnimated(true, completion: { () -> Void in
    
            for(var i=self.localViewOutlet.subviews.count;i<0;i--)
            {
                if(i<=(self.localViewOutlet.subviews.count-1))
                {
                self.localViewOutlet.subviews[i].removeFromParentViewController()
                }
                
            }
            
        })

        
    
    }
    
    @IBAction func toggleVideoBtnPressed(sender: AnyObject) {
        videoAction = !videoAction.boolValue
        socketObj.socket.emit("conference.stream", ["username":username!,"id":currentID!,"type":"video","action":videoAction.boolValue])
        
        

    }
    
    @IBAction func toggleAudioPressed(sender: AnyObject) {
        audioAction = !audioAction.boolValue
        self.rtcLocalMediaStream!.audioTracks[0].setEnabled(audioAction)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
         addHandlers()
        
        var mainICEServerURL:NSURL=NSURL(fileURLWithPath: Constants.MainUrl)!
        
        //var rtcICEarray:[RTCICEServer]=[]
        
        //var roomServer=RoomService(id: _id!)
        ////self.pc=roomServer.peers[0].getPC()
        //roomServer.joinRoom(_id!)
        //roomServer.makeOffer(_id!)
        
        self.rtcICEarray.append(RTCICEServer(URI: NSURL(string:"turn:45.55.232.65:3478?transport=udp"), username: "cloudkibo", password: "cloudkibo"))
        self.rtcICEarray.append(RTCICEServer(URI: NSURL(string:"turn:45.55.232.65:3478?transport=tcp"), username: "cloudkibo", password: "cloudkibo"))
        self.rtcICEarray.append(RTCICEServer(URI: NSURL(string:"stun:stun.l.google.com:19302"), username: "", password: ""))
        self.rtcICEarray.append(RTCICEServer(URI: NSURL(string:"stun:23.21.150.121"), username: "", password: ""))
        self.rtcICEarray.append(RTCICEServer(URI: NSURL(string:"stun:stun.anyfirewall.com:3478"), username: "", password: ""))
        self.rtcICEarray.append(RTCICEServer(URI: NSURL(string:"turn:turn.bistri.com:80?transport=udp"), username: "homeo", password: "homeo"))
        self.rtcICEarray.append(RTCICEServer(URI: NSURL(string:"turn:turn.bistri.com:80?transport=tcp"), username: "homeo", password: "homeo"))
        self.rtcICEarray.append(RTCICEServer(URI: NSURL(string:"turn:turn.anyfirewall.com:443?transport=tcp"), username: "webrtc", password: "webrtc"))
        
        
        println("rtcICEServerObj is \(self.rtcICEarray[0])")
        
        //self.createPeerConnectionObject()
        RTCPeerConnectionFactory.initializeSSL()
        self.rtcFact=RTCPeerConnectionFactory()
         didReceiveLocalStream(self.getLocalMediaStream())
        
        
        socketObj.socket.on("peer.connected"){data,ack in
            println("received peer.connected obj from server")
            
            //Both joined same room
            
            var datajson=JSON(data!)
            println(datajson.debugDescription)
            otherID=datajson[0]["id"].int
            iamincallWith=datajson[0]["username"].description
            isInitiator=true
            //^^^^^^^^ new self.pc.addStream(self.rtcMediaStream)
            /*socketObj.socket.emit("conference.stream", ["username":username!,"id":currentID!,"type":"video","action":"true"])
            socketObj.socket.emit("conference.stream", ["username":username!,"id":currentID!,"type":"audio","action":"true"])
*/
            self.createPeerConnectionObject()
            self.pc.addStream(self.getLocalMediaStream())
            socketObj.socket.emit("conference.stream", ["username":username!,"id":currentID!,"type":"video","action":"false"])
            socketObj.socket.emit("conference.stream", ["username":username!,"id":currentID!,"type":"audio","action":"true"])
            

            self.pc.createOfferWithDelegate(self, constraints: self.rtcMediaConst!)
            
        }
        
        socketObj.socket.on("conference.stream"){data,ack in
            println("received conference.stream obj from server")
            var datajson=JSON(data!)
            println(datajson.debugDescription)
            //if(datajson[0]["id"].intValue == otherID! && datajson[0]["type"].description == "video")
                if(datajson[0]["username"].debugDescription != username! && datajson[0]["type"].debugDescription == "video")
            {
                println("toggle remote video stream")
                self.rtcVideoTrackReceived.setEnabled((datajson[0]["action"].bool!))
                if(datajson[0]["action"].bool! == false)
                {
                    //self.rtcVideoTrackReceived=nil
                }
            }
            
        }

        socketObj.socket.on("peer.stream"){data,ack in
            println("received peer.stream obj from server")
            var datajson=JSON(data!)
            println(datajson.debugDescription)
            
        }
        socketObj.socket.on("peer.disconnected"){data,ack in
            println("received peer.disconnected obj from server")
            var datajson=JSON(data!)
            println(datajson.debugDescription)
            
        }

        
       
        
        socketObj.socket.on("message"){data,ack in
            println("received messageee")
            var msg=JSON(data!)
            println(msg.debugDescription)
            
            if(msg[0]["type"]=="room_name")
            {
                isInitiator=false
                //What to do if already in a room??
                
                //if(joinedRoomInCall=="")
                //{
                var CurrentRoomName=msg[0]["room"].string!
                println("got room name as \(joinedRoomInCall)")
                println("trying to join room")
                //socketObj.socket.emit("init",["room":joinedRoomInCall,"username":username!])
                //socketObj.socket.emitWithAck("init",["room":joinedRoomInCall,"username":username!])(timeout: 0)
                
                socketObj.socket.emitWithAck("init", ["room":CurrentRoomName,"username":username!])(timeout: 15000) {data in
                    println("room joined got ack")
                    var a=JSON(data!)
                    println(a.debugDescription)
                    currentID=a[1].int!
                    joinedRoomInCall=msg[0]["room"].string!
                    println("current id is \(currentID)")
                //}
                }
                
            }
            if(msg[0]=="Accept Call")
            {
                println("inside accept call")
                var roomname=self.randomStringWithLength(9)
                //iamincallWith=username!
                areYouFreeForCall=false
                joinedRoomInCall=roomname as String
                socketObj.socket.emitWithAck("init", ["room":joinedRoomInCall,"username":username!])(timeout: 1500) {data in
                    println("room joined by got ack")
                    var a=JSON(data!)
                    println(a.debugDescription)
                    currentID=a[1].int!
                    println("current id is \(currentID)")
                    var aa=JSON(["msg":["type":"room_name","room":roomname as String],"room":globalroom,"to":iamincallWith!,"username":username!])
                    println(aa.description)
                    socketObj.socket.emit("message",aa.object)

                }

                
                
                /*^^^^^^^^^var aa=JSON(["msg":["type":"room_name","room":roomname as String],"room":globalroom,"to":iamincallWith!,"username":username!])
                println(aa.description)
*/
                //socketObj.socket.emit("message",["type":"room_name","room":roomname,"room":globalroom,"to":iamincallWith!,"username":username!])
                /////^^^^^^^^^socketObj.sendMessagesOfMessageType(aa.description)
               //^^^^^^^ socketObj.socket.emit("message",aa.object)
                //^^^^^^^^^self.pc.createOfferWithDelegate(self, constraints: self.rtcMediaConst!)
            }
            if(msg[0]=="Reject Call")
            {
                println("inside reject call")
                var roomname=""
                iamincallWith=""
                areYouFreeForCall=true
                callerName=""
                joinedRoomInCall=""
                
                self.pc.close()
                self.dismissViewControllerAnimated(true, completion: nil)
                
            }
      

            if(msg[0]=="hangup")
            {
                
                println("hangupppppp received")
               // self.rtcMediaStream.removeAudioTrack(self.rtcAudioTrackReceived)
                //self.rtcMediaStream.removeVideoTrack(self.rtcVideoTrackReceived)
                self.rtcLocalVideoTrack=nil
                self.rtcVideoTrackReceived=nil
                self.rtcAudioTrackReceived=nil
                self.pc=nil
                socketObj.socket.emit("message",["msg":"hangup","room":globalroom,"to":iamincallWith!,"username":username!])
                socketObj.socket.emit("leave",["room":joinedRoomInCall])
                joinedRoomInCall=""
                iamincallWith=""
                isInitiator=false
                areYouFreeForCall=true
                
                
                
                /*
                When we hangup or end call
                var localStreams:RTCMediaStream=self.pc.localStreams[0] as! RTCMediaStream
                localStreams.removeVideoTrack(localStreams.videoTracks[0] as! RTCVideoTrack)
                
                self.pc.removeStream(localStreams as RTCMediaStream)
                
                */


                self.removeFromParentViewController()
                self.dismissViewControllerAnimated(true, completion: nil);
                
            }
                                /*
                
                socket.emitWithAck("canUpdate", cur)(timeoutAfter: 0) {data in
                socket.emit("update", ["amount": cur + 2.50])
                }
                
                socket.emit('init', { room: r, username: username }, function (roomid, id) {
                if(id === null){
                alert('You cannot join conference. Room is full');
                connected = false;
                return;
                }
                currentId = id;
                roomId = roomid;
                });
                connected = true;
                */
            
        }

        
        
        
        
        
        
          }
    
    func getLocalMediaStream()->RTCMediaStream!
    {
        println("setlocalmediastream")
         //var localStream:RTCMediaStream=createLocalMediaStream()
        
        self.rtcLocalMediaStream=createLocalMediaStream()
       
        ///self.rtcMediaStream.addAudioTrack(localStream.audioTracks[0] as! RTCAudioTrack)
        ///self.rtcMediaStream.addVideoTrack(localStream.videoTracks[0] as! RTCVideoTrack)

        println(rtcLocalMediaStream.audioTracks.count)
        
        println(rtcLocalMediaStream.videoTracks.count)
        return rtcLocalMediaStream
        //self.pc.addStream(rtcLocalMediaStream)
    }
    
    
    func createPeerConnectionObject()
    {//Initialise Peer Connection Object
        self.rtcMediaConst=RTCMediaConstraints(mandatoryConstraints: [RTCPair(key: "OfferToReceiveAudio", value: "true"),RTCPair(key: "OfferToReceiveVideo", value: "true")], optionalConstraints: nil)
        
    self.pc=self.rtcFact.peerConnectionWithICEServers(self.rtcICEarray, constraints: self.rtcMediaConst, delegate:self)
    }
    
    func createLocalMediaStream()->RTCMediaStream
    {
      
        var localStream:RTCMediaStream!
        localStream=rtcFact.mediaStreamWithLabel("ARDAMS")
        
        var localVideoTrack:RTCVideoTrack! = createLocalVideoTrack()
        if let lvt=localVideoTrack
        {
            var addedVideo=localStream.addVideoTrack(localVideoTrack)
            
            println("video stream \(addedVideo)")
            
        }
        var audioTrack=rtcFact.audioTrackWithID("ARDAMSa0")
        var addedAudioStream=localStream.addAudioTrack(audioTrack)
        
        println("audio stream \(addedAudioStream)")
        //localStream.addAudioTrack(mediaAudioLabel!)
        println("localStreammm ")
        print(localStream.description)
        //^^^localVideoTrack.addRenderer(localView)
        

        return localStream
    }

    func createLocalVideoTrack()->RTCVideoTrack
    {
        var localVideoTrack:RTCVideoTrack
        var cameraID:NSString!
        for aaa in AVCaptureDevice.devicesWithMediaType(AVMediaTypeVideo)
        {
            if aaa.position==AVCaptureDevicePosition.Front
            {
                println(aaa.description)
                println(aaa.deviceCurrentTime)
                println(aaa.localizedName!)
                //println(aaa.localStreams.description!)
                //println(aaa.localizedModel!)
                
                cameraID=aaa.localizedName!!
                println("got front cameraaa as id \(cameraID)")
                //break
            }
            
        }
        if cameraID==nil
            
        {println("failed to get front camera")}
        
        
        //AVCaptureDevice
        var capturer=RTCVideoCapturer(deviceName: cameraID! as String)
        println(capturer.description)
        //^^^^^new var mediaConstraints:RTCMediaConstraints=self.rtcMediaConst
        //var mediaConstraints=RTCMediaConstraints(mandatoryConstraints: [RTCPair(key: "OfferToReceiveAudio", value: "true"),RTCPair(key: "OfferToReceiveVideo", value: "true")], optionalConstraints: nil)
     
        var VideoSource=RTCVideoSource.alloc()
        var mediaConstraints=RTCMediaConstraints(mandatoryConstraints: [RTCPair(key: "maxWidth", value: "640"),RTCPair(key: "minWidth", value: "640"),RTCPair(key: "maxHeight", value: "480"),RTCPair(key: "minHeight", value: "480"),RTCPair(key: "maxFrameRate", value: "30"),RTCPair(key: "minFrameRate", value: "5"),RTCPair(key: "googLeakyBucket", value: "true")], optionalConstraints: nil)
        //VideoSource=rtcFact.videoSourceWithCapturer(capturer, constraints: mediaConstraints)
        VideoSource=rtcFact.videoSourceWithCapturer(capturer, constraints: nil)
        
        localVideoTrack=rtcFact.videoTrackWithID("ARDAMSv0", source: VideoSource)
        
        
        
        
        println("sending localVideoTrack")
        return localVideoTrack
        
    }
    
    func didReceiveLocalStream(stream:RTCMediaStream)
{
    
    
            var localView=RTCEAGLVideoView(frame: CGRect(x: 0, y: 0, width: 500, height: 500))
        localView.drawRect(CGRect(x: 0, y: 0, width: 500, height: 500))
        // self.remoteView.addConstraints(mediaConstraints.d)
        if(stream.videoTracks.count>0)
        {println("remote video track count is greater than one")
            self.rtcLocalVideoTrack=stream.videoTracks[0] as! RTCVideoTrack
            
            self.rtcLocalVideoTrack.addRenderer(localView)
            
            self.localViewOutlet.addSubview(localView)
            self.localViewOutlet.updateConstraintsIfNeeded()
            localView.setNeedsDisplay()
            self.localViewOutlet.setNeedsDisplay()
        }
        
   
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(animated: Bool) {
       
       /* self.localViewTop.setSize(CGSize(width: 500, height: 500))*/
    
    
    }

      func peerConnection(peerConnection: RTCPeerConnection!, addedStream stream: RTCMediaStream!) {
        println("added stream")
        dispatch_async(dispatch_get_main_queue(), {
        self.rtcStreamReceived=stream
        //var fff=RTCI420Frame.alloc()
        //fff.width=300
        //fff.height=300
        //fff.
        //if(!self.remoteView)
        //{
        
            var remoteView=RTCEAGLVideoView(frame: CGRect(x: 0, y: 0, width: 500, height: 500))
        remoteView.drawRect(CGRect(x: 0, y: 0, width: 500, height: 500))
        var mediaConstraints=RTCMediaConstraints(mandatoryConstraints: [RTCPair(key: "maxWidth", value: "640"),RTCPair(key: "minWidth", value: "640"),RTCPair(key: "maxHeight", value: "480"),RTCPair(key: "minHeight", value: "480"),RTCPair(key: "maxFrameRate", value: "30"),RTCPair(key: "minFrameRate", value: "5"),RTCPair(key: "googLeakyBucket", value: "true")], optionalConstraints: nil)
       // self.remoteView.addConstraints(mediaConstraints.d)
        if(stream.videoTracks.count>0)
        {println("remote video track count is greater than one")
            self.rtcVideoTrackReceived=stream.videoTracks[0] as! RTCVideoTrack
        
            self.rtcVideoTrackReceived.addRenderer(remoteView)
            
            self.localViewOutlet.addSubview(remoteView)
            self.localViewOutlet.updateConstraintsIfNeeded()
            remoteView.setNeedsDisplay()
            self.localViewOutlet.setNeedsDisplay()
            
        }
            
      
        })

    }
    func peerConnection(peerConnection: RTCPeerConnection!, didOpenDataChannel dataChannel: RTCDataChannel!) {
        println(".................. did open data channel")
        println(dataChannel.description)
    }
    func peerConnection(peerConnection: RTCPeerConnection!, gotICECandidate candidate: RTCICECandidate!) {
        println("got ice candidate")
        
        dispatch_async(dispatch_get_main_queue(), {
            
        println(candidate.description)
        //var cnd=JSON(["type":"candidate","sdpMLineIndex":candidate.sdpMLineIndex,"sdpMid":candidate.sdpMid!,"candidate":candidate.sdp!])
        var cnd=JSON(["sdpMLineIndex":candidate.sdpMLineIndex,"sdpMid":candidate.sdpMid!,"candidate":candidate.sdp!])
        
        var aa=JSON(["msg":["by":currentID!,"to":otherID,"ice":cnd.object,"type":"ice"]])
        //println(aa.description)
        socketObj.socket.emit("msg",["by":currentID!,"to":otherID,"ice":cnd.object,"type":"ice"])

        /*
        
        var aa=JSON(["msg":["by":currentID,"to":otherID,"sdp":sdp.description,"type":sdp.type!],"room":globalroom,"to":iamincallWith!,"username":username!])
        println(aa.description)
        
        socketObj.socket.emit("message",aa.object)
        
        
        socket.emit('msg', { by: currentId, to: id, ice: evnt.candidate, type: 'ice' });
        JSONObject cnd = new JSONObject();
        cnd.put("type", "candidate");
        cnd.put("sdpMLineIndex", candidate.sdpMLineIndex);
        cnd.put("sdpMid", candidate.sdpMid);
        cnd.put("candidate", candidate.sdp);
        
        JSONObject payload = new JSONObject();
        payload.put("ice", cnd);
        payload.put("type", "ice");*/
        
       //// socketObj.socket.emit(<#event: String#>, <#items: AnyObject#>...)
        })
    }
    func peerConnection(peerConnection: RTCPeerConnection!, iceConnectionChanged newState: RTCICEConnectionState) {
         println("............... ice connection changed new state is \(newState)")
    }
    func peerConnection(peerConnection: RTCPeerConnection!, iceGatheringChanged newState: RTCICEGatheringState) {
        println("............... ice gathering changed \(newState)")
    }
    func peerConnection(peerConnection: RTCPeerConnection!, removedStream stream: RTCMediaStream!) {
        println("...............removed stream")
    }
    func peerConnection(peerConnection: RTCPeerConnection!, signalingStateChanged stateChanged: RTCSignalingState) {
        println("................signalling state changed")
        println(stateChanged.value)
        
    }
    func peerConnectionOnRenegotiationNeeded(peerConnection: RTCPeerConnection!) {
        println("............... on negotiation needed")
    }
    
    func peerConnection(peerConnection: RTCPeerConnection!, didCreateSessionDescription sdp: RTCSessionDescription!, error: NSError!) {
        println("did create offer/answer session description success")
        dispatch_async(dispatch_get_main_queue(), {
            
        if error==nil{
        //####println(sdp.debugDescription)
        var sessionDescription=RTCSessionDescription(type: sdp.type!, sdp: sdp.description)
        
        self.pc.setLocalDescriptionWithDelegate(self, sessionDescription: sessionDescription)
            
            /*socketObj.socket.emit("conference.stream", ["username":username!,"id":currentID!,"type":"video","action":"true"])
            socketObj.socket.emit("conference.stream", ["username":username!,"id":currentID!,"type":"audio","action":"true"])
            */
            
           // if(sdp.type! == "answer"){
            //socketObj.socket.emit("msg",["by":currentID!,"to":otherID,"sdp":["sdp":sdp.debugDescription,"type":sdp.type!],"type":sdp.type!])
            //}
           // if(sdp.type! == "offer"){

            socketObj.socket.emit("msg",["by":currentID!,"to":otherID,"sdp":["type":sdp.type!,"sdp":sdp.description],"type":sdp.type!,"username":username!])
            //}
            /*
            pc.setLocalDescription(sdp);
            $log.debug('Creating an offer for', id);
            socket.emit('msg', { by: currentId, to: id, sdp: sdp, type: 'offer', username: username });
*/
            ///^^^var aa=JSON(["msg":["by":currentID!,"to":otherID,"sdp":sdp.description,"type":sdp.type!]])
            //^^^^println(aa.description)
            
            //^^^^^^^socketObj.socket.emit("msg",["by":currentID!,"to":otherID,"sdp":sdp.description,"type":sdp.type!])
            
            /*
            var aa=JSON(["msg":["type":"room_name","room":roomname as String],"room":globalroom,"to":iamincallWith!,"username":username!])
            println(aa.description)
            //socketObj.socket.emit("message",["type":"room_name","room":roomname,"room":globalroom,"to":iamincallWith!,"username":username!])
            /////^^^^^^^^^socketObj.sendMessagesOfMessageType(aa.description)
            socketObj.socket.emit("message",aa.object)

            
            
socket.emit('msg', { by: currentId, to: data.by, sdp: sdp, type: 'answer' });
*/
        //current id and by are those received in acknowlegement when room is created and peer.connected
        //socketObj.socket.emit("msg",["by":currentID,"to":otherID,"sdp":sdp,"type":"answer"])
        
        }
        else
        {
            println("sdp created with error \(error.localizedDescription)")
        }

/*

pc.setLocalDescription(sdp);
socket.emit('msg', { by: currentId, to: data.by, sdp: sdp, type: 'answer' });
*/
        })

    }
    func peerConnection(peerConnection: RTCPeerConnection!, didSetSessionDescriptionWithError error: NSError!) {
        //println(error.localizedDescription)
        
        // If we are acting as the callee then generate an answer to the offer.
        dispatch_async(dispatch_get_main_queue(), {
            
        if error == nil {
            println("did set remote sdp no error")
            
                println("isinitiator is \(isInitiator)")
                if isInitiator == false &&
                    self.pc.localDescription == nil {
                        println("creating answer")
                        //^^^^^^^^^ new self.pc.addStream(self.rtcMediaStream)
                                               self.pc.createAnswerWithDelegate(self, constraints: self.rtcMediaConst)
                }
                else
                {
                    println("local not nil or initiator is true")
                    //println(self.pc.localDescription.description)
                    
                }
            
        } else {
            print(".......sdp set ERROR: \(error.localizedDescription)")
        }
        })

    }
    
    func videoView(videoView: RTCEAGLVideoView!, didChangeVideoSize size: CGSize) {
        
        println("video size has changed")
        
    }
}
