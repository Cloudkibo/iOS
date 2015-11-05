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

    var rtcMediaStream:RTCMediaStream!
    var rtcFact:RTCPeerConnectionFactory!
    var pc:RTCPeerConnection!
    var rtcVideoTrack:RTCVideoTrack!
    var rtcMediaConst:RTCMediaConstraints!
    var rtcVideoSource:RTCVideoSource!
    var rtcVideoCapturer:RTCVideoCapturer!
    //var rtcVideoTrack:RTCVideoTrack!
    var rtcVideoRenderer:RTCVideoRenderer!
    
   
    @IBOutlet weak var localView: RTCEAGLVideoView!
    override func viewDidLoad() {
        super.viewDidLoad()
        //rtcVideoTrack=RTCVideoTrack(factory: rtcFact, source: rtcVideoSource, trackId: "sss")
        
        var mainICEServerURL:NSURL=NSURL(fileURLWithPath: Constants.MainUrl)!
        var rtcICEarray:[RTCICEServer]=[RTCICEServer]()
        var rtcICEobj=RTCICEServer(URI: mainICEServerURL, username: username!, password: password!)
        rtcICEarray.append(rtcICEobj)
        println("rtcICEServerObj is \(rtcICEarray[0])")
        //^^^^rtcFact=RTCPeerConnectionFactory.alloc()
        RTCPeerConnectionFactory.initializeSSL()
        var rtcFact=RTCPeerConnectionFactory()
        
        //rtcFact=RTCPeerConnectionFactory.alloc()
        //pc=rtcFact.peerConnectionWithICEServers(rtcICEarray, constraints: RTCMediaConstraints(mandatoryConstraints: nil, optionalConstraints: nil), delegate: self)
        //rtcFact.peerConnectionWithICEServers(rtcICEarray, constraints: nil, delegate: self)
        var pc=RTCPeerConnection.alloc()
        //pc.delegate=self
        println(pc.description)
        RTCMediaStream.initialize()
        
        var rtcMediaStream=rtcFact.mediaStreamWithLabel("@kibo")
        
        ///rtcMediaStream=rtcFact.mediaStreamWithLabel("@kibo:)")
        ////rtcFact.mediaStreamWithLabel("@kibo")
        var rtcAudioTrack=rtcFact.audioTrackWithID("@kiboa0")
        rtcMediaStream.addAudioTrack(rtcAudioTrack)
        
        
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
                cameraID=aaa.localizedName!
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
        var rtcVideoCapturer=RTCVideoCapturer(deviceName: cameraID! as String)
        
        println(rtcVideoCapturer.debugDescription)
        var rtcMediaConst=RTCMediaConstraints(mandatoryConstraints: nil, optionalConstraints: nil)
        //RTCMediaConstraints(mandatoryConstraints: nil, optionalConstraints: nil)
        println(rtcMediaConst.debugDescription)
        //var rtcVideoSource:RTCVideoSource
        //rtcVideoSource.
        //rtcVideoCapturer=rtcVideoCapturer()
        //println(rtcVideoSource.debugDescription)
        var rtcVideoSource=rtcFact.videoSourceWithCapturer(rtcVideoCapturer, constraints: nil)
        //var rtcVideoSource=rtcFact.videoSourceWithCapturer(rtcVideoCapturer, constraints: RTCMediaConstraints(mandatoryConstraints: nil, optionalConstraints: nil))
        println(rtcVideoSource.debugDescription)
        println("outttt")
        
        var rtcVideoTrack=RTCVideoTrack(factory: rtcFact, source: rtcVideoSource, trackId: "sss")
        println(rtcVideoTrack.debugDescription)
        
        
        if let lvt=rtcVideoTrack
        {
        var addedVideoTrack=rtcMediaStream.addVideoTrack(rtcVideoTrack)
        println(addedVideoTrack)
        println("got video track")
        }
        
        rtcVideoTrack.addRenderer(localView)
        println("add renderer")
        //pc.addStream(rtcMediaStream)
        //return localStream
        
        
           
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
       

        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
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
       
        rtcVideoTrack=RTCVideoTrack(factory: rtcFact!, source: rtcVideoSource, trackId: "sss")
        //rtcVideoTrack=rtcFact.videoTrackWithID("sss", source: rtcVideoSource)
         println("out of error")
        return rtcVideoTrack
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
}
