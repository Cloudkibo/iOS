//
//  ConferenceCallViewController.swift
//  Chat
//
//  Created by Cloudkibo on 04/02/2016.
//  Copyright © 2016 MyAppTemplates. All rights reserved.
//

import UIKit
import AVFoundation

class ConferenceCallViewController: UIViewController,ConferenceDelegate,ConferenceScreenDelegate {

    var mvideo:MeetingRoomVideo!
   /// var mvideo:MeetingVideo!
    //var mvideo:MeetingRoomVideo!
    var svideo:MeetingRoomScreen!
    var rtcVideoTrackReceived:RTCVideoTrack! = nil
    var localView:RTCEAGLVideoView! = nil
    var remoteView:RTCEAGLVideoView! = nil
    var rtcLocalVideoTrack:RTCVideoTrack! = nil
    var actionVideo:Bool=false
    var rtcLocalVideoStream:RTCMediaStream!
    
    @IBOutlet var localViewOutlet: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print("inside controller did load")
        mvideo=MeetingRoomVideo()
        mvideo.addHandlers()
        mvideo.delegateConference=self
        
        svideo=MeetingRoomScreen()
        svideo.addHandlers()
        svideo.delegateConference=self
        //////mvideo=MeetingVideo()
        //////mvideo.initVideo()
        /////mvideo.delegate=self
        
        //isInitiator=true
        self.localView=RTCEAGLVideoView(frame: CGRect(x: 0, y: 50, width: 500, height: 450))
        self.localView.drawRect(CGRect(x: 0, y: 50, width: 500, height: 450))
        self.remoteView=RTCEAGLVideoView(frame: CGRect(x: 0, y: 50, width: 500, height: 450))
        self.remoteView.drawRect(CGRect(x: 0, y: 50, width: 500, height: 450))
        
        // Do any additional setup after loading the view.
    }

    @IBAction func endCallBtnPressed(sender: AnyObject) {
    }
    
    @IBAction func toggleVideoBtnPressed(sender: AnyObject) {
        actionVideo = !actionVideo
        if(mvideo == nil)
        {
            mvideo=MeetingRoomVideo()
            mvideo.addHandlers()
            mvideo.delegateConference=self
        }
        if(actionVideo == true)
        {
            ///self.rtcLocalVideoStream=getLocalMediaStream()
            
            self.rtcLocalVideoStream=mvideo.createLocalVideoStream()
            mvideo.toggleVideo(actionVideo,tempstream: rtcLocalVideoStream)
        }
        else{
            mvideo.toggleVideo(actionVideo,tempstream: rtcLocalVideoStream)
             mvideo.removeLocalMediaStreamFromPeerConnection()
            mvideo.pc.close()
            
        }
        
        
    }
    
    @IBAction func toggleAudioBtnPressed(sender: AnyObject) {
    }
    
    @IBAction func backbtnPressed(sender: AnyObject) {
    }
    
    
    @IBAction func btnCapturePressed(sender: AnyObject) {
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func didReceiveLocalVideoTrack(localVideoTrack: RTCVideoTrack) {
        
        self.rtcLocalVideoTrack=localVideoTrack
        self.rtcLocalVideoTrack.addRenderer(self.localView)
        self.localViewOutlet.addSubview(self.localView)
        self.localViewOutlet.updateConstraintsIfNeeded()
        self.localView.setNeedsDisplay()
        self.localViewOutlet.setNeedsDisplay()
        
        //// mvideo.addLocalMediaStreamToPeerConnection(rtcLocalVideoStream)
        
    }
    func didReceiveRemoteVideoTrack(remoteVideoTrack:RTCVideoTrack)
    {
        print("didreceiveremotevideotrack11")
        
        ////dispatch_async(dispatch_get_main_queue(), {
        
        
        //////CODE TO RENDER REMOTE VIDEO
        
        
        self.rtcVideoTrackReceived=remoteVideoTrack
        /////////self.remoteView=RTCEAGLVideoView(frame: CGRect(x: 0, y: 0, width: 500, height: 500))
        //////////self.remoteView.drawRect(CGRect(x: 0, y: 0, width: 500, height: 500))
        
        self.rtcVideoTrackReceived.addRenderer(self.remoteView)
        //////////////remoteVideoTrack.addRenderer(self.remoteView)
        ///////self.remoteView.hidden=true // ^^^^newww
        self.localViewOutlet.addSubview(self.remoteView)
        
        ///self.localViewOutlet.addSubview(self.remoteView)
        self.localViewOutlet.updateConstraintsIfNeeded()
        //////////self.remoteView.updateConstraintsIfNeeded()
        self.remoteView.setNeedsDisplay()
        self.localViewOutlet.setNeedsDisplay()

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
    func getLocalMediaStream()->RTCMediaStream!
    {
        print("getlocalmediastream")
        
        self.rtcLocalVideoStream=createLocalVideoStream()
        mvideo.pc.addStream(self.rtcLocalVideoStream)
        
        //print(rtcLocalMediaStream.audioTracks.count)
        
        // print(rtcLocalMediaStream.videoTracks.count)
        return self.rtcLocalVideoStream
        
    }
    
    func createLocalVideoStream()->RTCMediaStream
    {print("inside createlocalvideotrack")
        
        var localStream:RTCMediaStream!
        
        localStream=rtcFact.mediaStreamWithLabel("ARDAMS")
        /////////////************^^^
        var localVideoTrack=createLocalVideoTrack()
        
        self.rtcLocalVideoTrack = createLocalVideoTrack()
        if let lvt=self.rtcLocalVideoTrack
        {
            let addedVideo=localStream.addVideoTrack(self.rtcLocalVideoTrack)
            
            print("video stream \(addedVideo)")
            ////++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
            dispatch_async(dispatch_get_main_queue(), {
                //********************
                //TELL CONTROLLER TO SHOW LOCAL VIDEO
                self.didReceiveLocalVideoTrack(self.rtcLocalVideoTrack)
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
        self.rtcLocalVideoTrack=nil
        self.rtcLocalVideoTrack=rtcFact.videoTrackWithID("ARDAMSv0", source: VideoSource)
        print("sending localVideoTrack")
        return self.rtcLocalVideoTrack
        
    }
    */
   

    
   
    func didReceiveRemoteVideoTrack(remoteVideoTrack:RTCVideoTrack)
    {//******************
        print("didreceiveremotevideotrack11")
        ////dispatch_async(dispatch_get_main_queue(), {
        
        
        //////CODE TO RENDER REMOTE VIDEO
        
        
        self.rtcVideoTrackReceived=remoteVideoTrack
        /////////self.remoteView=RTCEAGLVideoView(frame: CGRect(x: 0, y: 0, width: 500, height: 500))
        //////////self.remoteView.drawRect(CGRect(x: 0, y: 0, width: 500, height: 500))
        
        self.rtcVideoTrackReceived.addRenderer(self.remoteView)
        //////////////remoteVideoTrack.addRenderer(self.remoteView)
        self.remoteView.hidden=true // ^^^^newww
        
        
        //..********************************
        //SCREEN SHARING CODE
        /////////
        
        /*if(self.screenshared==true){
        self.remoteView.hidden=false
        }*/
        
        self.localViewOutlet.addSubview(self.remoteView)
        
        ///self.localViewOutlet.addSubview(self.remoteView)
        self.localViewOutlet.updateConstraintsIfNeeded()
        //////////self.remoteView.updateConstraintsIfNeeded()
        self.remoteView.setNeedsDisplay()
        self.localViewOutlet.setNeedsDisplay()
        

        
        /// })
        // }
        
    }

   

}*/*/*/
    func didReceiveRemoteScreen(remoteVideoTrack:RTCVideoTrack){
        print("didreceiveremotevideotrack11")
        
        ////dispatch_async(dispatch_get_main_queue(), {
        
        
        //////CODE TO RENDER REMOTE VIDEO
        
        
        self.rtcVideoTrackReceived=remoteVideoTrack
        /////////self.remoteView=RTCEAGLVideoView(frame: CGRect(x: 0, y: 0, width: 500, height: 500))
        //////////self.remoteView.drawRect(CGRect(x: 0, y: 0, width: 500, height: 500))
        
        self.rtcVideoTrackReceived.addRenderer(self.remoteView)
        //////////////remoteVideoTrack.addRenderer(self.remoteView)
        ///////self.remoteView.hidden=true // ^^^^newww
        self.localViewOutlet.addSubview(self.remoteView)
        
        ///self.localViewOutlet.addSubview(self.remoteView)
        self.localViewOutlet.updateConstraintsIfNeeded()
        //////////self.remoteView.updateConstraintsIfNeeded()
        self.remoteView.setNeedsDisplay()
        self.localViewOutlet.setNeedsDisplay()
}
    //func didReceiveLocalVideoTrack(localVideoTrack:RTCVideoTrack);
    func didReceiveLocalScreen(localVideoTrack:RTCVideoTrack){
        self.rtcLocalVideoTrack=localVideoTrack
        self.rtcLocalVideoTrack.addRenderer(self.localView)
        self.localViewOutlet.addSubview(self.localView)
        self.localViewOutlet.updateConstraintsIfNeeded()
        self.localView.setNeedsDisplay()
        self.localViewOutlet.setNeedsDisplay()
    }
}