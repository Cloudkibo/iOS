//
//  CallRingingViewController.swift
//  Chat
//
//  Created by Cloudkibo on 22/10/2015.
//  Copyright (c) 2015 MyAppTemplates. All rights reserved.
//

import UIKit
import Foundation

import AVFoundation

class CallRingingViewController: UIViewController//RTCPeerConnectionDelegate,RTCSessionDescriptionDelegate
{

   // var rtcFact:RTCPeerConnectionFactory!
    //var pc:RTCPeerConnection!
    //var rtcFact:RTCPeerConnectionFactory
    //@IBOutlet weak var localView: RTCEAGLVideoView!
    
    @IBOutlet weak var localView: RTCEAGLVideoView!
    @IBOutlet weak var txtCallingDialing: UILabel!
    @IBOutlet weak var txtCallerName: UILabel!
    @IBAction func btnAcceptPressed(sender: AnyObject) {
    /*
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
        println(rtcVideoSource.debugDescription)
        println("outttt")
        
        var rtcVideoTrack=RTCVideoTrack(factory: rtcFact, source: rtcVideoSource, trackId: "sss")
        println(rtcVideoTrack.debugDescription)
        /*
        
        if let lvt=rtcVideoTrack
        {
            rtcMediaStream.addVideoTrack(rtcVideoTrack)
            
            println("got video track")
        }
        
        //^^^rtcVideoTrack.addRenderer(localView)
        */
        //pc.addStream(rtcMediaStream)
        //return localStream

        */

       var next = self.storyboard?.instantiateViewControllerWithIdentifier("Main2") as! VideoViewController
        
        self.presentViewController(next, animated: true, completion: {
            ////^^^^next.rtcVideoTrack=RTCVideoTrack(factory: rtcFact, source: rtcVideoSource, trackId: "sss")
            /*
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
            println(rtcVideoSource.debugDescription)
            println("outttt")
            
            var rtcVideoTrack=RTCVideoTrack(factory: rtcFact, source: rtcVideoSource, trackId: "sss")
            println(rtcVideoTrack.debugDescription)
            /*
            
            if let lvt=rtcVideoTrack
            {
            rtcMediaStream.addVideoTrack(rtcVideoTrack)
            
            println("got video track")
            }
            
            //^^^rtcVideoTrack.addRenderer(localView)
            */
            //pc.addStream(rtcMediaStream)
            //return localStream
            

            next.rtcFact=rtcFact
            next.rtcMediaStream=rtcMediaStream
            next.rtcVideoTrack=rtcVideoTrack
            next.rtcVideoSource=rtcVideoSource
            
            */
            println("showing video")
        })


        
       /* var mainICEServerURL:NSURL=NSURL(fileURLWithPath: Constants.MainUrl)!
        var rtcICEarray:[RTCICEServer]=[RTCICEServer]()
        var rtcICEobj=RTCICEServer(URI: mainICEServerURL, username: username!, password: password!)
        rtcICEarray.append(rtcICEobj)
        println("rtcICEServerObj is \(rtcICEarray[0])")
        rtcFact=RTCPeerConnectionFactory.alloc()
        //rtcFact.peerConnectionWithICEServers(rtcICEarray, constraints: nil, delegate: self)
        pc=RTCPeerConnection.alloc()
        pc.delegate=self
        println(pc.description)
       // var rtcMediaStream:RTCMediaStream=pc.localStreams[0] as! RTCMediaStream
        var localStream:RTCMediaStream=createLocalMediaStream()
        pc.addStream(localStream)
        
                //pc.createOfferWithDelegate(self, constraints: RTCMediaConstraints(mandatoryConstraints: nil, optionalConstraints: nil))
        
        /*
RTCMediaStream *localStream = [self createLocalMediaStream];
[_peerConnection addStream:localStream];
if (_isInitiator) {
[self sendOffer];
} else {
[self waitForAnswer];
}
}

- (void)sendOffer {
[_peerConnection createOfferWithDelegate:self
constraints:[self defaultOfferConstraints]];
}

*/






*/
        
    }
    @IBAction func btnRejectPressed(sender: AnyObject) {
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        
    
        // Do any additional setup after loading the view.
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    {
        var rtcVideoTrack:RTCVideoTrack
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
                //break
            }
            
        }
        if cameraID==nil
            
        {println("failed to get camera")}
        
        //AVCaptureDevice
        var rtcVideoCapturer=RTCVideoCapturer(deviceName: cameraID! as String)
        println(rtcVideoCapturer.description)
        var rtcMediaConst=RTCMediaConstraints(mandatoryConstraints: nil, optionalConstraints: nil)
        var rtcVideoSource=RTCVideoSource.alloc()
        rtcVideoSource=rtcFact.videoSourceWithCapturer(rtcVideoCapturer, constraints: rtcMediaConst)
        rtcVideoTrack=rtcFact.videoTrackWithID("sss", source: rtcVideoSource)
        
        return rtcVideoTrack

    }
    */

   /* func peerConnection(peerConnection: RTCPeerConnection!, addedStream stream: RTCMediaStream!) {
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
        
    }*/
}
