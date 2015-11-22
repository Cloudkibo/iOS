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
            println(msg.debugDescription)
            
            if(msg[0]["type"].string! == "offer")
            {
                if(joinedRoomInCall=="")
                {}
                
                println("offer received")
                var sessionDescription=RTCSessionDescription(type: "offer", sdp: msg[0]["sdp"]["sdp"].string!)
                //self.by=msg[0]["by"].int!
                self.pc.setRemoteDescriptionWithDelegate(self, sessionDescription: sessionDescription)
                
               // socketObj.socket.emit("msg",["by":currentId!,"to":msg["by"].string!])
                
            }
            if(msg[0]["type"].string! == "answer")
            {println("answer received")
                var sessionDescription=RTCSessionDescription(type: "answer", sdp: msg[0]["sdp"]["sdp"].string!)
                self.pc.setRemoteDescriptionWithDelegate(self, sessionDescription: sessionDescription)
                                // socketObj.socket.emit("msg",["by":currentId!,"to":msg["by"].string!])
                
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
        
        addHandlers()
        
        socketObj.socket.on("message"){data,ack in
            println("received messageee")
            var msg=JSON(data!)
            println(msg.debugDescription)
            
            if(msg[0]["type"]=="room_name")
            {
                if(joinedRoomInCall=="")
                {println("do nothing u are initiator")}
                else
                {
                joinedRoomInCall=msg[0]["room"].string!
                otherID=msg[0]["from"].string!
                println("got room name as \(joinedRoomInCall)")
                println("trying to join room")
                //socketObj.socket.emit("init",["room":joinedRoomInCall,"username":username!])
                //socketObj.socket.emitWithAck("init",["room":joinedRoomInCall,"username":username!])(timeout: 0)
                
                socketObj.socket.emitWithAck("init", ["room":joinedRoomInCall,"username":username!])(timeout: 1500) {data in
                    println("got ack")
                    var a=JSON(data!)
                    println(a.debugDescription)
                    currentID=a[0][1].debugDescription
                }
                }
            }
            if(msg[0]=="Accept Call")
            {
                println("inside accept call")
                var roomname=self.randomStringWithLength(9)
                areYouFreeForCall=false
                var aa=JSON(["msg":["type":"room_name","room":roomname],"room":globalroom,"to":iamincallWith!,"username":username!])
                //socketObj.socket.emit("message",["type":"room_name","room":roomname,"room":globalroom,"to":iamincallWith!,"username":username!])
                /////^^^^^^^^^socketObj.sendMessagesOfMessageType(aa.description)
                socketObj.socket.emit("message",aa.object)
                self.pc.createOfferWithDelegate(self, constraints: self.rtcMediaConst!)
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

        
        
        socketObj.socket.on("peer.connected"){data,ack in
            println("received peer.connected obj from server")
            var datajson=JSON(data!)
            println(datajson.debugDescription)
            
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
        
        
       //rtcVideoRenderer.renderFrame()
        //rtcMediaStream.videoTracks[0].update()
                //^^^^^localView.updateConstraints()
        //^^^^^^localViewTop.addSubview(localView)
        //localView.setNeedsDisplay()
        ////rtcMediaStream.
        //'localView' is RTCEAGLVideoView object in story board
       /* var captureSession = AVCaptureSession()
        var input = AVCaptureDeviceInput()
        input=AVCaptureDeviceInput(device: device[0] as! AVCaptureDevice, error: {return nil}())
        
        captureSession.addInput(input)
        var previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        localView.layer.addSublayer(previewLayer)
*/
        //println("add renderer")
        
        
        
           
/*
    
        if let lvt=rtcVideoTrack
        {
            var addedVideoTrack=rtcMediaStream.addVideoTrack(rtcVideoTrack)
            println(addedVideoTrack)
            println("got video track")
        }
    
        //^^^rtcVideoTrack.addRenderer(localView)

    
         rtcVideoTrack.addRenderer(localView)
        */
/*
        /*
        var mainICEServerURL:NSURL=NSURL(fileURLWithPath: Constants.MainUrl)!
        var rtcICEarray:[RTCICEServer]=[RTCICEServer]()
        var rtcICEobj=RTCICEServer(URI: mainICEServerURL, username: username!, password: password!)
        rtcICEarray.append(rtcICEobj)
        println("rtcICEServerObj is \(rtcICEarray[0])")
        rtcFact=RTCPeerConnectionFactory.alloc()
        //rtcFact.peerConnectionWithICEServers(rtcICEarray, constraints: nil, delegate: self)
        pc=RTCPeerConnection.alloc()
        pc.delegate=self
        println(pc.description)
        */
        
        ////
        //^^var localStream:RTCMediaStream=createLocalMediaStream()
        //^^pc.addStream(localStream)
        ///
        //var rtcMediaStream:RTCMediaStream=pc.localStreams[0] as! RTCMediaStream
        
        
        //pc.createOfferWithDelegate(self, constraints: RTCMediaConstraints(mandatoryConstraints: nil, optionalConstraints: nil))
        // Do any additional setup after loading the view.
        
        var mainICEServerURL:NSURL=NSURL(fileURLWithPath: Constants.MainUrl)!
        var rtcICEarray:[RTCICEServer]=[RTCICEServer]()
        var rtcICEobj=RTCICEServer(URI: mainICEServerURL, username: username!, password: password!)
        rtcICEarray.append(rtcICEobj)
        println("rtcICEServerObj is \(rtcICEarray[0])")
        //^^^^rtcFact=RTCPeerConnectionFactory.alloc()
        RTCPeerConnectionFactory.initializeSSL()
        //rtcFact=RTCPeerConnectionFactory.alloc()
        //pc=rtcFact.peerConnectionWithICEServers(rtcICEarray, constraints: RTCMediaConstraints(mandatoryConstraints: nil, optionalConstraints: nil), delegate: self)
        //rtcFact.peerConnectionWithICEServers(rtcICEarray, constraints: nil, delegate: self)
        pc=RTCPeerConnection.alloc()
        pc.delegate=self
        println(pc.description)
        
        var rtcMediaStream=rtcFact.mediaStreamWithLabel("kibo")
        var rtcAudioTrack=rtcFact.audioTrackWithID("kiboa0")
        rtcMediaStream.addAudioTrack(rtcAudioTrack)
        
        
        
        
        */
        
        
        
        /*
AVCaptureDevice *device;
for (AVCaptureDevice *captureDevice in [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo] ) {
if (captureDevice.position == AVCaptureDevicePositionFront) {
device = captureDevice;
break;
}
}

// Create a video track and add it to the media stream
if (device) {
RTCVideoSource *videoSource;
RTCVideoCapturer *capturer = [RTCVideoCapturer capturerWithDeviceName:device.localizedName];
videoSource = [factory videoSourceWithCapturer:capturer constraints:nil];
RTCVideoTrack *videoTrack = [factory videoTrackWithID:videoId source:videoSource];
[localStream addVideoTrack:videoTrack];
}
*/


        /*rtcVideoSource=RTCVideoSource.alloc()
        // RTCVideoTrack=RTCVideoTrack
        rtcMediaConst=RTCMediaConstraints.alloc()
        

        
        
        var localStream:RTCMediaStream=createLocalMediaStream()
        pc.addStream(localStream)

*/
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(animated: Bool) {
       
        self.localViewTop.setSize(CGSize(width: 500, height: 500))
    
        /* var cc=UIColor.redColor()
        var cc1=UIColor.redColor()
        
        localView.layer.backgroundColor=cc.CGColor
        localViewTop.layer.backgroundColor=cc1.CGColor
        //localViewTop.backgroundColor=(UIColor.blueColor())
        println(localViewTop.subviews.count)
        println(localView.subviews.count)
*/
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    /*
    func createLocalMediaStream()->RTCMediaStream
    {
        var mediaStreamLabel:String!
        var mediaAudioLabel:String!
        mediaStreamLabel="kibo"
        mediaAudioLabel="kiboa1"
        var localStream:RTCMediaStream!
        
        //localStream=rtcFact.mediaStreamWithLabel("kibo")
        
        var localVideoTrack:RTCVideoTrack!=createLocalVideoTrack()
       
        if let lvt=localVideoTrack
        {
            localStream.addVideoTrack(localVideoTrack)
            
            
        }
        //localStream.addAudioTrack(rtcFact.audioTrackWithID(mediaAudioLabel!))
        println("localStreammm ")
        print(localStream.description)
        localVideoTrack.addRenderer(localView)
        return localStream
        /*
        
        RTCMediaStream* localStream = [_factory mediaStreamWithLabel:@"ARDAMS"];
        
        RTCVideoTrack *localVideoTrack = [self createLocalVideoTrack];
        if (localVideoTrack) {
        [localStream addVideoTrack:localVideoTrack];
        [_delegate appClient:self didReceiveLocalVideoTrack:localVideoTrack];
        }
        
        [localStream addAudioTrack:[_factory audioTrackWithID:@"ARDAMSa0"]];
        return localStream;
*/
        
        
    }
    
    */
    /*
    func createLocalVideoTrack()->RTCVideoTrack
    {
        var cameraID:NSString!
        for aaa in AVCaptureDevice.devicesWithMediaType(AVMediaTypeVideo)
        {
            if aaa.position==AVCaptureDevicePosition.Front
            {
                //println(aaa.description)
                //println(aaa.deviceCurrentTime)
                //println(aaa.localizedName!)
                //println(aaa.localStreams.description!)
                //println(aaa.localizedModel!)
                cameraID=aaa.localizedName!!
                //println(aaa.description)
                //println(aaa.localizedDescription)
                println(cameraID!)
                println("got front camera")
                break
            }
            
        }
        if cameraID==nil
            
        {println("failed to get camera")}
        
        //AVCaptureDevice
        rtcVideoCapturer=RTCVideoCapturer(deviceName: cameraID! as String)
        
        println(rtcVideoCapturer.debugDescription)
        rtcMediaConst=RTCMediaConstraints(mandatoryConstraints: nil, optionalConstraints: nil)
            //RTCMediaConstraints(mandatoryConstraints: nil, optionalConstraints: nil)
        println(rtcMediaConst.debugDescription)
               //var rtcVideoSource:RTCVideoSource
            //rtcVideoSource.
        //rtcVideoCapturer=rtcVideoCapturer()
        println(rtcVideoSource.debugDescription)
        rtcVideoSource=rtcFact.videoSourceWithCapturer(rtcVideoCapturer, constraints: nil)
        println("outttt")
       
        rtcVideoTrack1=RTCVideoTrack(factory: rtcFact!, source: rtcVideoSource, trackId: "sss")
        //rtcVideoTrack=rtcFact.videoTrackWithID("sss", source: rtcVideoSource)
         println("out of error")
        return rtcVideoTrack1
    }
    
    */
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
        /*
NSLog(@"Received %lu video tracks and %lu audio tracks",
(unsigned long)stream.videoTracks.count,
(unsigned long)stream.audioTracks.count);
if (stream.videoTracks.count) {
RTCVideoTrack *videoTrack = stream.videoTracks[0];
[_delegate appClient:self didReceiveRemoteVideoTrack:videoTrack];
*/

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
        println("did create session description success")
        self.pc.setLocalDescriptionWithDelegate(self, sessionDescription: sdp)
        
        //current id and by are those received in acknowlegement when room is created and peer.connected
        //socketObj.socket.emit("msg",["by":currentID,"to":otherID,"sdp":sdp,"type":"answer"])
        


/*

pc.setLocalDescription(sdp);
socket.emit('msg', { by: currentId, to: data.by, sdp: sdp, type: 'answer' });
*/

    }
    func peerConnection(peerConnection: RTCPeerConnection!, didSetSessionDescriptionWithError error: NSError!) {
        //println(error.localizedDescription)
        println("did crate session desc with error")
    }
    
    
}
