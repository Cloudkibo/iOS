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

/*
class VideoViewController: UIViewController,ChatAppClientDelegate,RTCEAGLVideoViewDelegate {
    
    func videoView(videoView: RTCEAGLVideoView!, didChangeVideoSize size: CGSize) {
        
        println("video size changed")
    }
    
    @IBOutlet var localViewTop: RTCEAGLVideoView!
    
    @IBOutlet weak var localViewTrailing: NSLayoutConstraint!
    
    @IBOutlet weak var localViewLeading: NSLayoutConstraint!
    var rtcMediaStream:RTCMediaStream!
    var rtcFact:RTCPeerConnectionFactory!
    var pc:RTCPeerConnection!
    var rtcLocalVideoTrack:RTCVideoTrack!
    var rtcMediaConst:RTCMediaConstraints!
    var rtcVideoSource:RTCVideoSource!
    var rtcVideoCapturer:RTCVideoCapturer!
    var rtcRemoteVideoTrack:RTCVideoTrack!
    var rtcVideoRenderer:RTCVideoRenderer!
    var abc:RTCVideoTrack!!
    var client:ChatAppClient!
   
    @IBOutlet weak var remoteView: RTCEAGLVideoView!
    @IBOutlet weak var localView: RTCEAGLVideoView!
    override func viewDidLoad() {
        super.viewDidLoad()

        println("inside video view controller class")
        
        //self.remoteView.delegate=self
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(animated: Bool) {
        self.client=ChatAppClient(delegate: self)
        
    }
    
    
    
    
    
    /*

//Display the Local View full screen while connecting to Room
[self.localViewBottomConstraint setConstant:0.0f];
[self.localViewRightConstraint setConstant:0.0f];
[self.localViewHeightConstraint setConstant:self.view.frame.size.height];
[self.localViewWidthConstraint setConstant:self.view.frame.size.width];
[self.footerViewBottomConstraint setConstant:0.0f];

//Connect to the room
[self disconnect];
self.client = [[ARDAppClient alloc] initWithDelegate:self];
[self.client setServerHostUrl:SERVER_HOST_URL];
[self.client connectToRoomWithId:self.roomName options:nil];

[self.urlLabel setText:self.roomUrl];
*/
    func appClient(client: ChatAppClient, didChangeState state: ChatAppClientState) {
        switch (state) {
        case ChatAppClientState.kARDAppClientStateConnected:
           println("Client connected.")
            break;
        case ChatAppClientState.kARDAppClientStateConnecting:
           println("Client connecring.")
           break;
        case .kARDAppClientStateDisconnected:
            println("client disconnected")
            
           // [self remoteDisconnected];
            break;
        }
    }
    func appClient(client: ChatAppClient, didError error: NSError) {
        println("errorrrrrrrr")
        
        
    }
    func appClient(client: ChatAppClient, didReceiveLocalVideoTrack localVideoTrack: RTCVideoTrack) {
     if let lvt=self.rtcLocalVideoTrack
     {
    self.rtcLocalVideoTrack.removeRenderer(self.localView)
        self.rtcLocalVideoTrack=nil
        self.localView.renderFrame(nil)
    }
        self.rtcLocalVideoTrack=localVideoTrack
        self.rtcLocalVideoTrack.addRenderer(self.localView)
    }
    func appClient(client: ChatAppClient, didReceiveRemoteVideoTrack remoteVideoTrack: RTCVideoTrack) {
        self.rtcRemoteVideoTrack=remoteVideoTrack
        self.rtcRemoteVideoTrack.addRenderer(self.remoteView)
        UIView.animateWithDuration(0.4, animations: { () -> Void in
            self.view.layoutIfNeeded()
        })
    }
    
    
    /*

- (void)appClient:(ARDAppClient *)client didReceiveRemoteVideoTrack:(RTCVideoTrack *)remoteVideoTrack {
self.remoteVideoTrack = remoteVideoTrack;
[self.remoteVideoTrack addRenderer:self.remoteView];

[UIView animateWithDuration:0.4f animations:^{
[self.localViewBottomConstraint setConstant:28.0f];
[self.localViewRightConstraint setConstant:28.0f];
[self.localViewHeightConstraint setConstant:self.view.frame.size.height/4.0f];
[self.localViewWidthConstraint setConstant:self.view.frame.size.width/4.0f];
[self.footerViewBottomConstraint setConstant:-80.0f];
[self.view layoutIfNeeded];
}];
}

- (void)appClient:(ARDAppClient *)client didError:(NSError *)error {
UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:nil
message:[NSString stringWithFormat:@"%@", error]
delegate:nil
cancelButtonTitle:@"OK"
otherButtonTitles:nil];
[alertView show];
[self disconnect];
}*/

    
    */

class VideoViewController: UIViewController,RTCPeerConnectionDelegate,RTCSessionDescriptionDelegate {

    @IBOutlet var localViewTop: RTCEAGLVideoView!

    @IBOutlet weak var localViewTrailing: NSLayoutConstraint!

    @IBOutlet weak var localViewLeading: NSLayoutConstraint!
      @IBOutlet weak var remoteView: RTCEAGLVideoView!
    var rtcMediaStream:RTCMediaStream!
    var rtcFact:RTCPeerConnectionFactory!
    var pc:RTCPeerConnection!
    var rtcVideoTrack1:RTCVideoTrack!
    var rtcMediaConst:RTCMediaConstraints!
    var rtcVideoSource:RTCVideoSource!
    var rtcVideoCapturer:RTCVideoCapturer!
    var rtcVideoTrack:RTCVideoTrack!
    var rtcVideoRenderer:RTCVideoRenderer!
    var abc:RTCVideoTrack!!
    //var currentId:String!
    var by:Int!
    
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
                if(joinedRoomInCall=="")
                {
                println("room joined is null")}
                
                println("offer received")
                //var sdpNew=msg[0]["sdp"].object
                otherID=msg[0]["by"].int!
                currentID=msg[0]["to"].int!
                
                   var sdpNew = msg[0]["sdp"]["sdp"].description.stringByReplacingOccurrencesOfString("\n", withString: "")
                //sdpNew=sdpNew.string!.stringByReplacingOccurrencesOfString("\r", withString: "")
                println("***************** \(sdpNew)")
                var sessionDescription=RTCSessionDescription(type: msg[0]["type"].description, sdp: msg[0]["sdp"]["sdp"].description)
                ////var sessionDescription=RTCSessionDescription(type: "offer", sdp: sdpNew)
                self.pc.setRemoteDescriptionWithDelegate(self, sessionDescription: sessionDescription)
                
               // socketObj.socket.emit("msg",["by":currentId!,"to":msg["by"].string!])
                
            }
            if(msg[0]["type"].string! == "answer")
            {println("answer received")
                var sessionDescription=RTCSessionDescription(type: msg[0]["type"].description, sdp: msg[0]["sdp"]["sdp"].description)
                self.pc.setRemoteDescriptionWithDelegate(self, sessionDescription: sessionDescription)
                                // socketObj.socket.emit("msg",["by":currentId!,"to":msg["by"].string!])
                
            }
            if(msg[0]["type"].string! == "ice")
            {println("ice received of other peer")
                if(msg[0]["ice"].description=="null")
                {println("last ice as null so ignore")}
                else{
                var iceCandidate=RTCICECandidate(mid: msg[0]["ice"]["sdpMid"].description, index: msg[0]["ice"]["sdpMLineIndex"].int!, sdp: msg[0]["ice"]["candidate"].description)
                    println(iceCandidate.description)
                var addedcandidate=self.pc.addICECandidate(iceCandidate)
                println("ice candidate added \(addedcandidate)")
                //self.pc.addICECandi
                // socketObj.socket.emit("msg",["by":currentId!,"to":msg["by"].string!])
                }
                
            }
            

            
            /*
            
            pc.setLocalDescription(sdp);
            socket.emit('msg', { by: currentId, to: data.by, sdp: sdp, type: 'answer' });
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
*/
            
        }
        
        //socket.emit('msg', { by: currentId, to: id, sdp: sdp, type: 'offer', username: username });
    }
    @IBOutlet weak var localView: RTCEAGLVideoView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        socketObj.socket.on("peer.connected"){data,ack in
            println("received peer.connected obj from server")
            var datajson=JSON(data!)
            println(datajson.debugDescription)
            otherID=datajson[0]["id"].int
            iamincallWith=datajson[0]["username"].description
            self.pc.createOfferWithDelegate(self, constraints: self.rtcMediaConst!)
            
        }

        
        addHandlers()
        
        socketObj.socket.on("message"){data,ack in
            println("received messageee")
            var msg=JSON(data!)
            println(msg.debugDescription)
            
            if(msg[0]["type"]=="room_name")
            {
                if(joinedRoomInCall=="")
                {
                joinedRoomInCall=msg[0]["room"].string!
                //^^^^^^otherID=msg[0]["from"].string!
                println("got room name as \(joinedRoomInCall)")
                println("trying to join room")
                //socketObj.socket.emit("init",["room":joinedRoomInCall,"username":username!])
                //socketObj.socket.emitWithAck("init",["room":joinedRoomInCall,"username":username!])(timeout: 0)
                
                socketObj.socket.emitWithAck("init", ["room":joinedRoomInCall,"username":username!])(timeout: 1500) {data in
                    println("room joined got ack")
                    var a=JSON(data!)
                    println(a.debugDescription)
                    currentID=a[1].int!
                    println("current id is \(currentID)")
                }
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
                self.dismissViewControllerAnimated(true, completion: nil)
                joinedRoomInCall=""
            }
      

            if(msg[0]=="hangup")
            {
                joinedRoomInCall=""
                iamincallWith=""
                
                self.dismissViewControllerAnimated(true, completion: nil);
                
            }
            if(msg[0]=="peer.connected")
            {
                println("inside peer.connected")
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

        
        
        
        
        
                var mainICEServerURL:NSURL=NSURL(fileURLWithPath: Constants.MainUrl)!
        
        var rtcICEarray:[RTCICEServer]=[]
        
        //var roomServer=RoomService(id: _id!)
        ////self.pc=roomServer.peers[0].getPC()
        //roomServer.joinRoom(_id!)
        //roomServer.makeOffer(_id!)
    
      rtcICEarray.append(RTCICEServer(URI: NSURL(string:"turn:45.55.232.65:3478?transport=udp"), username: "cloudkibo", password: "cloudkibo"))
        rtcICEarray.append(RTCICEServer(URI: NSURL(string:"turn:45.55.232.65:3478?transport=tcp"), username: "cloudkibo", password: "cloudkibo"))
        rtcICEarray.append(RTCICEServer(URI: NSURL(string:"stun:stun.l.google.com:19302"), username: "", password: ""))
        rtcICEarray.append(RTCICEServer(URI: NSURL(string:"stun:23.21.150.121"), username: "", password: ""))
        rtcICEarray.append(RTCICEServer(URI: NSURL(string:"stun:stun.anyfirewall.com:3478"), username: "", password: ""))
        rtcICEarray.append(RTCICEServer(URI: NSURL(string:"turn:turn.bistri.com:80?transport=udp"), username: "homeo", password: "homeo"))
        rtcICEarray.append(RTCICEServer(URI: NSURL(string:"turn:turn.bistri.com:80?transport=tcp"), username: "homeo", password: "homeo"))
        rtcICEarray.append(RTCICEServer(URI: NSURL(string:"turn:turn.anyfirewall.com:443?transport=tcp"), username: "webrtc", password: "webrtc"))
        
        
               println("rtcICEServerObj is \(rtcICEarray[0])")
        RTCPeerConnectionFactory.initializeSSL()
        self.rtcFact=RTCPeerConnectionFactory()
        
        rtcMediaConst=RTCMediaConstraints(mandatoryConstraints: [RTCPair(key: "OfferToReceiveAudio", value: "true"),RTCPair(key: "OfferToReceiveVideo", value: "true")], optionalConstraints: nil)
        
        self.pc=rtcFact.peerConnectionWithICEServers(rtcICEarray, constraints: rtcMediaConst, delegate:self)
        
        

        RTCMediaStream.initialize()
        
        var rtcMediaStream=rtcFact.mediaStreamWithLabel("@kibo")
        var rtcAudioTrack=rtcFact.audioTrackWithID("@kiboa0")
        var addedAudioStream=rtcMediaStream.addAudioTrack(rtcAudioTrack)
        
        var device11:AnyObject!
        var cameraID:NSString!
   
        let captureDevice = AVCaptureDevice.devices();
        // Loop through all the capture devices on this phone
        for device in captureDevice {
            // Make sure this particular device supports video
            if (device.hasMediaType(AVMediaTypeVideo)) {
                // Finally check the position and confirm we've got the front camera
                if(device.position == AVCaptureDevicePosition.Front) {
                    device11 = device as! AVCaptureDevice
                    if device11 != nil {
                        println("got device")
                        cameraID=device11.localizedName
                        println(cameraID!)
                        //beginSession()
                        break
                    }
                }
            }
        }
        if cameraID==nil
         {println("failed to get camera")}
        
        
        rtcVideoRenderer=localView
        rtcVideoRenderer.self.setSize(CGSize(width: 300, height: 320))
        println("size is set")
        
        //AVCaptureDevice
        var rtcVideoCapturer=RTCVideoCapturer(deviceName: cameraID! as String)
        //println(rtcVideoCapturer.debugDescription)
        
        var rtcVideoSource=rtcFact.videoSourceWithCapturer(rtcVideoCapturer, constraints: rtcMediaConst)
        
        //println(rtcVideoSource.debugDescription)
        var rtcVideoTrack=RTCVideoTrack(factory: rtcFact, source: rtcVideoSource, trackId: "sss")
        rtcVideoTrack.setEnabled(true)
        //println(rtcVideoTrack.debugDescription)
        
        localViewTop.setSize(CGSize(width: 500, height: 500))
        localViewTop.drawRect(CGRect(x: 50,y: 50,width: 300,height: 320))
        
        localView.setSize(CGSize(width: 400, height: 400))
        localView.drawRect(CGRect(x: 50,y: 50,width: 300,height: 320))
        
        //localView.setSize(400,400)
        //localViewTop.sizeToFit()


        if let lvt=rtcVideoTrack
        {
            rtcVideoTrack.addRenderer(localView)
        var addedVideoTrack=rtcMediaStream.addVideoTrack(rtcVideoTrack)
            
            
        println(addedVideoTrack)
        println("got video track")
            println(addedAudioStream)
        println("got audio track")
        }
        pc.addStream(rtcMediaStream)
        peerConnection(pc, addedStream: rtcMediaStream)
      
        rtcVideoTrack.addRenderer(localView)
        rtcMediaStream.audioTracks[0].addRenderer(localView)
        rtcMediaStream
        
          }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(animated: Bool) {
       
        self.localViewTop.setSize(CGSize(width: 500, height: 500))
    
    
    }

      func peerConnection(peerConnection: RTCPeerConnection!, addedStream stream: RTCMediaStream!) {
        println("added stream")
        println(stream.videoTracks.count)
        println(stream.audioTracks.count)
        if(stream.videoTracks.count>0)
        {
            self.rtcVideoTrack1=stream.videoTracks[0] as! RTCVideoTrack
             rtcVideoTrack1.addRenderer(localView)
            localViewTop.setSize(CGSize(width: 300,height: 300))
            localViewTop.setNeedsDisplayInRect(CGRect(x: 20,y: 20,width: 300,height: 300))
            rtcVideoTrack1.addRenderer(localView)
            
        }
        

    }
    func peerConnection(peerConnection: RTCPeerConnection!, didOpenDataChannel dataChannel: RTCDataChannel!) {
        println(".................. did open data channel")
        println(dataChannel.description)
    }
    func peerConnection(peerConnection: RTCPeerConnection!, gotICECandidate candidate: RTCICECandidate!) {
        println("got ice candidate")
        //println(candidate.description)
        var cnd=JSON(["type":"candidate","sdpMLineIndex":candidate.sdpMLineIndex,"sdpMid":candidate.sdpMid!,"candidate":candidate.sdp!])
        var aa=JSON(["msg":["by":currentID!,"to":otherID,"ice":cnd.object,"type":"ice"]])
        println(aa.description)
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
        
    }
    func peerConnection(peerConnection: RTCPeerConnection!, iceConnectionChanged newState: RTCICEConnectionState) {
         println("............... ice connection changed")
    }
    func peerConnection(peerConnection: RTCPeerConnection!, iceGatheringChanged newState: RTCICEGatheringState) {
        println("............... ice gathering changed")
    }
    func peerConnection(peerConnection: RTCPeerConnection!, removedStream stream: RTCMediaStream!) {
        println("...............removed stream")
    }
    func peerConnection(peerConnection: RTCPeerConnection!, signalingStateChanged stateChanged: RTCSignalingState) {
        println("................signalling state changed")
    }
    func peerConnectionOnRenegotiationNeeded(peerConnection: RTCPeerConnection!) {
        println("............... on negotiation needed")
    }
    
    func peerConnection(peerConnection: RTCPeerConnection!, didCreateSessionDescription sdp: RTCSessionDescription!, error: NSError!) {
        println("did create session description success")
        if error==nil{
        println(sdp.debugDescription)
        var sessionDescription=RTCSessionDescription(type: sdp.type!, sdp: sdp.description)
        
        self.pc.setLocalDescriptionWithDelegate(self, sessionDescription: sessionDescription)
            if(sdp.type!=="answer"){
            socketObj.socket.emit("msg",["by":currentID!,"to":otherID,"sdp":["sdp":sdp.description,"type":sdp.type!],"type":sdp.type!])
            }
            if(sdp.type!=="offer"){

            socketObj.socket.emit("msg",["by":currentID!,"to":otherID,"sdp":["sdp":sdp.description,"type":sdp.type!],"type":sdp.type!,"username":username!])
            }
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

    }
    func peerConnection(peerConnection: RTCPeerConnection!, didSetSessionDescriptionWithError error: NSError!) {
        //println(error.localizedDescription)
        
        // If we are acting as the callee then generate an answer to the offer.
        if error == nil {
            println("did set sdp no error")
            dispatch_async(dispatch_get_main_queue()) {
                println("isinitiator is \(isInitiator)")
                if isInitiator==false &&
                    self.pc.localDescription == nil {
                        println("creating answer")
                        self.pc.createAnswerWithDelegate(self, constraints: self.rtcMediaConst)
                }
                else
                {
                    println("local not nil or initiator is true")
                    //println(self.pc.localDescription.description)
                    
                }
            }
        } else {
            print(".......sdp set ERROR: \(error.localizedDescription)")
        }

    }
    
    
}
