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

class VideoViewController: UIViewController,RTCPeerConnectionDelegate,RTCSessionDescriptionDelegate {

    @IBOutlet var localViewTop: RTCEAGLVideoView!
    
    @IBOutlet weak var localViewTrailing: NSLayoutConstraint!
    
    @IBOutlet weak var localViewLeading: NSLayoutConstraint!
    var rtcMediaStream:RTCMediaStream!
    var rtcFact:RTCPeerConnectionFactory!
    var pc:RTCPeerConnection!
    var rtcVideoTrack1:RTCVideoTrack!
    var rtcMediaConst:RTCMediaConstraints!
    var rtcVideoSource:RTCVideoSource!
    var rtcVideoCapturer:RTCVideoCapturer!
    //var rtcVideoTrack:RTCVideoTrack!
    var rtcVideoRenderer:RTCVideoRenderer!
    var abc:RTCVideoTrack!!
   
    @IBOutlet weak var localView: RTCEAGLVideoView!
    override func viewDidLoad() {
        super.viewDidLoad()
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
        var rtcFact=RTCPeerConnectionFactory()
        
        rtcMediaConst=RTCMediaConstraints(mandatoryConstraints: [RTCPair(key: "OfferToReceiveAudio", value: "true"),RTCPair(key: "OfferToReceiveVideo", value: "true")], optionalConstraints: nil)
        
        var pc=rtcFact.peerConnectionWithICEServers(rtcICEarray, constraints: rtcMediaConst, delegate:self)
        
        

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
        
    }
    func peerConnection(peerConnection: RTCPeerConnection!, didSetSessionDescriptionWithError error: NSError!) {
        
    }
}
