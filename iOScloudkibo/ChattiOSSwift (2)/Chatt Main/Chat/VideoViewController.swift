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

    
    var rtcFact:RTCPeerConnectionFactory!
    var pc:RTCPeerConnection!
    
    @IBOutlet weak var localView: RTCEAGLVideoView!
    override func viewDidLoad() {
        super.viewDidLoad()

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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(animated: Bool) {
        
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

        
        var localStream:RTCMediaStream=createLocalMediaStream()
        pc.addStream(localStream)
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
        mediaStreamLabel="cloudkiboStream"
        mediaAudioLabel="cloudkiboaudio"
        var localStream:RTCMediaStream!
        //localStream=rtcFact.mediaStreamWithLabel(mediaStreamLabel!)
        
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
    { var rtcVideoTrack:RTCVideoTrack
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
                cameraID=aaa.localizedName!
                println("got front camera")
                break
            }
            
        }
        if cameraID==nil
            
        {println("failed to get camera")}
        
        //AVCaptureDevice
        var rtcVideoCapturer=RTCVideoCapturer(deviceName: cameraID! as String)
        println(rtcVideoCapturer.description)
        var rtcMediaConst=RTCMediaConstraints()
        rtcMediaConst=RTCMediaConstraints(mandatoryConstraints: nil, optionalConstraints: nil)
        println(rtcMediaConst)
        //var rtcVideoSource=RTCVideoSource.alloc()
        var rtcVideoSource:RTCVideoSource()
            
        
        rtcVideoSource=rtcFact.videoSourceWithCapturer(rtcVideoCapturer, constraints: rtcMediaConst)
        rtcVideoTrack=rtcFact.videoTrackWithID("sss", source: rtcVideoSource!)
        
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
