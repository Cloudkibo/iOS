//
//  ConferenceCallViewController.swift
//  Chat
//
//  Created by Cloudkibo on 04/02/2016.
//  Copyright © 2016 MyAppTemplates. All rights reserved.
//

import UIKit
import AVFoundation
import SwiftyJSON

class ConferenceCallViewController: UIViewController,ConferenceDelegate,ConferenceScreenReceiveDelegate,ConferenceRoomDisconnectDelegate {
    var rtcLocalVideoTrack:RTCVideoTrack!
    ////////////////////////////////////////var rtcLocalstream:RTCMediaStream!
    var mvideo:MeetingRoomVideo!
    var mdata:MeetingRoomData!
    //var mvideo:MeetingRoomVideo!
    ////////////////var rtcRemoteVideoStream:RTCMediaStream!
    var svideo:MeetingRoomScreen!
    var rtcVideoTrackReceived:RTCVideoTrack! = nil
    var localView:RTCEAGLVideoView! = nil
    var remoteView:RTCEAGLVideoView! = nil
    ////////////////////////////////////////////var rtcLocalVideoTrack:RTCVideoTrack! = nil
    var actionVideo:Bool=false
    var rtcLocalVideoStream:RTCMediaStream!
    var rtcDataChannel:RTCDataChannel!
    var countTimer=1
    var mAudio:MeetingRoomAudio!
    
    @IBOutlet var localViewOutlet: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mAudio=MeetingRoomAudio()
        mAudio.initAudio()
        mAudio.delegateDisconnect=self
        
        print("inside controller did load")
        mvideo=MeetingRoomVideo()
        mvideo.addHandlers()
        mvideo.delegateConference=self
        
        svideo=MeetingRoomScreen()
        svideo.addHandlers()
        svideo.delegateConference=self
        
        mdata=MeetingRoomData()
        mdata.addHandlers()
        
        
        
        //isInitiator=true
        //self.localView=RTCEAGLVideoView()
        var w=localViewOutlet.bounds.width-(localViewOutlet.bounds.width*0.23)
        var h=localViewOutlet.bounds.height-(localViewOutlet.bounds.height*0.27)
        
        dispatch_async(dispatch_get_main_queue(), {
        self.localView=RTCEAGLVideoView(frame: CGRect(x: w, y: h, width: 90, height: 85))
        self.localView.drawRect(CGRect(x: w, y: h, width: 90, height: 85))
        
        //self.localView=RTCEAGLVideoView(frame: CGRect(x: 0, y: 50, width: 90, height: 85))
        //self.localView.drawRect(CGRect(x: 0, y: 50, width: 90, height: 85))
        
        ///self.remoteView=RTCEAGLVideoView()
        self.remoteView=RTCEAGLVideoView(frame: CGRect(x: 0, y: 50, width: 400, height: 370))
        self.remoteView.drawRect(CGRect(x: 0, y: 50, width: 400, height: 370))
        //w 500 h 450
        print("size is... \(self.localViewOutlet.bounds.width)")
        print("size is.self... \(self.localViewOutlet.bounds.height)")
        })
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func endCallBtnPressed(sender: AnyObject) {
        self.disconnectAll()
        
    }
    
    @IBAction func toggleVideoBtnPressed(sender: AnyObject) {
        actionVideo = !actionVideo
        if(mvideo == nil)
        {print("my video was nil)")
            mvideo=MeetingRoomVideo()
            mvideo.addHandlers()
            mvideo.delegateConference=self
        }
        if(actionVideo == true)
        {//isInitiator=true
            ///self.rtcLocalVideoStream=getLocalMediaStream()
            if(self.rtcLocalVideoStream == nil)
            {self.rtcLocalVideoStream=createLocalVideoStream()}
            mvideo.toggleVideo(actionVideo,s: rtcLocalVideoStream)
        }
        else{
            
            mvideo.toggleVideo(actionVideo,s: nil)
            //isInitiator=false
           //////////////////// resetVideo()
            //mvideo.removeLocalMediaStreamFromPeerConnection()
            //////////////////^^^^^^^^^^newwwwwwwwwwwww mvideo.pc=nil
            /////////////////////////////////////////////////^^^^^^^^^^
            
           /* if(self.rtcLocalVideoTrack != nil)
            {
               didremoveLocalVideoTrack()
                
                ////rtcLocalVideoStream=nil
                
            }*/
            
            
        }
        
        /////socketObj.socket.emit("conference.chat", ["message":"This is test mesage from iphone","username":username!])
        
        
    }
    
    @IBAction func toggleAudioBtnPressed(sender: AnyObject) {
    }
    
    @IBAction func backbtnPressed(sender: AnyObject) {
        print("backkkkkkkkkkkkkk pressed")
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    @IBAction func btnCapturePressed(sender: AnyObject) {
        
        //////// mdata.toggleScreen(screenAction, tempstream: <#T##RTCMediaStream!#>)
        if(mdata.pc == nil)
        {
            mdata.createPeerConnection()
            mdata.CreateAndAttachDataChannel()
        }
        socketObj.socket.emit("conference.streamScreen", ["username":username!,"id":currentID!,"type":"screenAndroid","action":"true"])
        atimer=NSTimer(timeInterval: 0.1, target: self, selector: "timerFiredScreenCapture", userInfo: nil, repeats: true)
        
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) { () -> Void in
            
            for(var i=0;i<30000;i++)
            {
                atimer.fire()
                sleep(1)
            }
            
   
        }
        
        //NOT hanging capture pressed again and again
       /* var firedate=NSDate(timeIntervalSinceNow: 0.1)
        atimer=NSTimer.init(fireDate: firedate, interval: 0.5, target: self, selector: "timerFiredScreenCapture", userInfo: nil, repeats: true)
       // while(true)
        //{
        //atimer.fire()
        //}
        //atimer=NSTimer(timeInterval: 0.1, target: self, selector: "timerFiredScreenCapture", userInfo: nil, repeats: true)
        var mainRunLoop=NSRunLoop()
        //mainRunLoop.addt
        //atimer.fire()
        mainRunLoop.addTimer(atimer, forMode: NSRunLoopCommonModes)
        //atimer.fire()
        //while(true)
        //{
        
            mainRunLoop.runUntilDate(NSDate(timeIntervalSinceNow: NSTimeInterval(9999999999
                
                )))
        atimer.fire()

*/
       /* mainRunLoop.run()

        mainRunLoop.run()
        mainRunLoop.run()
        mainRunLoop.run()
        mainRunLoop.run()
        mainRunLoop.run()
        mainRunLoop.run()
        mainRunLoop.run()
        mainRunLoop.run()
        mainRunLoop.run()
        mainRunLoop.run()
        mainRunLoop.run()
        mainRunLoop.run()
        mainRunLoop.run()
        mainRunLoop.run()
        mainRunLoop.run()
        mainRunLoop.run()
        mainRunLoop.run()
        mainRunLoop.run()
        mainRunLoop.run()
        mainRunLoop.run()
        mainRunLoop.run()
        mainRunLoop.run()
        mainRunLoop.run()
        mainRunLoop.run()
        mainRunLoop.run()
        mainRunLoop.run()
        mainRunLoop.run()
        mainRunLoop.run()
        mainRunLoop.run()
        mainRunLoop.run()
        mainRunLoop.run()
*/
            
        ///}
       // while(true)
        //{
          //  }
        
    
        /*
[[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
*/
        
        //countTimer++
       /* dispatch_async(dispatch_get_main_queue(), { () -> Void in
            
            atimer.fire()
            
            ///if(countTimer==10){
            // atimer.invalidate()
            print("timer stopped1")
        })*/
        
    }
    
    func timerFiredScreenCapture()
    {print("inside timerFiredScreenCapture")
        // var myscreen=UIScreen.mainScreen().snapshotViewAfterScreenUpdates(true)
        
        //if(countTimer%2 == 0){
        
        //while(atimer.timeInterval < 3000)
        var chunkLength=64000
        
       // for(var i=0;i<3000;i++)
        //{
            //////for window in UIApplication.sharedApplication().windows{
                //print("i is \(i)")
               
                ////UIGraphicsBeginImageContext(window.layer.bounds.size)
            
      // dispatch_async(dispatch_get_main_queue(), { () -> Void in
                
                UIGraphicsBeginImageContext(UIScreen.mainScreen().bounds.size)
                self.view.drawViewHierarchyInRect(UIScreen.mainScreen().bounds, afterScreenUpdates: true)
                print("width is \(UIScreen.mainScreen().bounds.width), height is \(UIScreen.mainScreen().bounds.height)")
                var screenshot:UIImage=UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                var imageData:NSData = UIImageJPEGRepresentation(screenshot, 1.0)!
                var numchunks=0
                var len=imageData.length
                print("length is\(len)")
                numchunks=len/chunkLength
                print("numchunks are \(numchunks)")
        
        var test="\(imageData.length)"
        /*let buffer = RTCDataBuffer(
            data: (test.dataUsingEncoding(NSUTF8StringEncoding))!,
            isBinary: false
        )
        */
        self.mdata.sendDataBuffer(test, isb: false)
        
        for(var j=0;j<numchunks;j++)
        {
            var start=j*chunkLength
            var end=(j+1)*chunkLength
            self.mdata.sendImage(imageData.subdataWithRange(NSMakeRange(start,len-start)))
            
        }
        if((len%chunkLength) > 0)
        {
            //imageData.getBytes(&imageData, length: numchunks*chunkLength)
            self.mdata.sendImage(imageData.subdataWithRange(NSMakeRange(numchunks*chunkLength, len%chunkLength)))
            
        }
        
        /*
var CHUNK_LEN = 64000;
// Get the image bytes and calculate the number of chunks
var img = canvas.getImageData(0, 0, canvasWidth, canvasHeight);
var len = img.data.byteLength;
var numChunks = len / CHUNK_LEN | 0;
// Let the other peer know in advance how many bytes to expect in total
dataChannel.send(len);
// Split the photo in chunks and send it over the data channel
for (var i = 0; i < n; i++) {
var start = i * CHUNK_LEN;
var end = (i+1) * CHUNK_LEN;
dataChannel.send(img.data.subarray(start, end));
}
// Send the reminder, if any
if (len % CHUNK_LEN) {
dataChannel.send(img.data.subarray(n * CHUNK_LEN));
}*/
        
        /*
            var start=0;
            if(len<chunkLength)
            {
                print("inside first if")
                print("len \(len) start \(start) start+chunklength is \(start+chunkLength)")
                
                print("chunk numberrrrr is \(numchunks)")
                self.mdata.sendImage(imageData.subdataWithRange(NSMakeRange(0,len)))
            }
            else
            {
                var j=0
                for(j=0;j<numchunks;j++)
                {
                    print("inside for loop")
                    
                    start=j*chunkLength
                    //var end=(i+1)*chunkLength
                    
                    /*if(end>len)
                    {
                    end=len-1
                    }*/
                    print("len \(len) start \(start) start+chunklength is \(start+chunkLength)")
                    if(start+chunkLength > len)
                    {
                        print("inside screen if")
                        self.mdata.sendImage(imageData.subdataWithRange(NSMakeRange(start, len-start)))
                        
                        /////////self.mdata.sendImage(imageData.subdataWithRange(NSMakeRange(start, start-len)))
                        ////self.mdata.sendImage(imageData.subdataWithRange(NSMakeRange(start, len%chunkLength)))
                        break
                        
                        
                        /*len=start+chunkLength-len-1
                        print("changed len \(len) start \(start) start+chunklength is \(start+chunkLength)")
                        break
                        */
                    }
                     self.mdata.sendImage(imageData.subdataWithRange(NSMakeRange(start, chunkLength)))
                   /// self.mdata.sendImage(imageData.subdataWithRange(NSMakeRange(start, chunkLength-1)))
                }
                print("j is \(j)")
                if(len%chunkLength>0)
                {print("len%chunklength is \(len%chunkLength)")
                    self.mdata.sendImage(imageData.subdataWithRange(NSMakeRange(start+chunkLength,len%chunkLength)))
                    
                    print("inside mod if")
                    ////self.mdata.sendImage(imageData.subdataWithRange(NSMakeRange(numchunks*chunkLength,len-(numchunks*chunkLength))))
                    //self.mdata.sendImage(imageData.subdataWithRange(NSMakeRange(numchunks*chunkLength,len)))
                }

                
            }
            */

                /////self.mdata.sendImage(imageData)
                
        // })
            
            
            
            
                //mdata.sendImage(imageData)
        ////////    }
      //for loop end  }
        print("outside")
       /// atimer.invalidate()
       /// print("timer stopped")
        
        
        
    }
    
    
    
    func createLocalVideoStream()->RTCMediaStream
    {print("inside createlocalvideostream")
        
        var localStream:RTCMediaStream!
        
        localStream=rtcFact.mediaStreamWithLabel("ARDAMS")
        
        self.rtcLocalVideoTrack = createLocalVideoTrack()
        if let lvt=self.rtcLocalVideoTrack
        {
            let addedVideo=localStream.addVideoTrack(self.rtcLocalVideoTrack)
            self.rtcLocalVideoStream=localStream
            
            print("video stream \(addedVideo)")
            ////////////////////////////////pc.addStream(self.rtcLocalstream)
            ////++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
            dispatch_async(dispatch_get_main_queue(), {
                //////self.didReceiveLocalVideoTrack(localVideoTrack)
                
                
                self.didReceiveLocalVideoTrack(self.rtcLocalVideoTrack)
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
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func didReceiveLocalVideoTrack(localVideoTrack: RTCVideoTrack) {
        
        self.rtcLocalVideoTrack=localVideoTrack
        self.rtcLocalVideoTrack.addRenderer(self.localView)
        self.localViewOutlet.addSubview(self.localView)
        /////////////////self.localViewOutlet.updateConstraintsIfNeeded()
        self.remoteView.setNeedsDisplay()
        self.localView.setNeedsDisplay()
        self.localViewOutlet.setNeedsDisplay()
        
        //// mvideo.addLocalMediaStreamToPeerConnection(rtcLocalVideoStream)
        
    }
    func didReceiveRemoteVideoTrack(remoteVideoTrack:RTCVideoTrack)
    {
        print("didreceiveremotevideotrack11")
        
        dispatch_async(dispatch_get_main_queue(), {
        
        
        //////CODE TO RENDER REMOTE VIDEO
        
        
        self.rtcVideoTrackReceived=remoteVideoTrack
        /////////self.remoteView=RTCEAGLVideoView(frame: CGRect(x: 0, y: 0, width: 500, height: 500))
        //////////self.remoteView.drawRect(CGRect(x: 0, y: 0, width: 500, height: 500))
        
        self.rtcVideoTrackReceived.addRenderer(self.remoteView)
        //////////////remoteVideoTrack.addRenderer(self.remoteView)
        ///////self.remoteView.hidden=true // ^^^^newww
        ////self.localView.setSize(CGSize(width: 200,height: 250))
       
        self.localViewOutlet.addSubview(self.remoteView)
        //self.localView=RTCEAGLVideoView(frame: CGRect(x: 0, y: 50, width: 50, height: 45))
        //////////^^^^^^self.localView.setSize(CGSize(width: 50,height: 45))
        //self.localView.drawRect(CGRect(x: 0, y: 50, width: 50, height: 45))
        ///////^^^^^^^^^self.localView.updateConstraintsIfNeeded()
        //////////^^^^^^^self.localViewOutlet.addSubview(localView)
        /////self.localViewOutlet.addSubview(self.localView)
        ///self.localViewOutlet.addSubview(self.remoteView)
        self.localViewOutlet.updateConstraintsIfNeeded()
        
        //////////self.remoteView.updateConstraintsIfNeeded()
        self.remoteView.setNeedsDisplay()
        self.localView.setNeedsDisplay()
        self.localViewOutlet.setNeedsDisplay()
        if(self.localView.superview != nil)
        {
            self.localView.setNeedsDisplay()
        }
        })
        
    }
    
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
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
    
    func didRemoveRemoteScreen()
    {
        if((self.rtcVideoTrackReceived) != nil)
        {print("remove remote screen renderer")
            
            self.rtcVideoTrackReceived.removeRenderer(self.remoteView)
            self.rtcVideoTrackReceived=nil
            self.remoteView.removeFromSuperview()
        }
    }
    
    
    func didRemoveRemoteVideoTrack()
    {
       
        
        if((self.rtcVideoTrackReceived) != nil)
        {
             dispatch_async(dispatch_get_main_queue(), { () -> Void in
            print("remove remote video renderer")
            
            self.rtcVideoTrackReceived.removeRenderer(self.remoteView)
            self.rtcVideoTrackReceived=nil
            //self.remoteView.hidden=true
            self.remoteView.removeFromSuperview()
            })
            
        }
        
    }
     func didremoveLocalVideoTrack()
     {
        print("remove local video renderer")
       //// dispatch_async(dispatch_get_main_queue(), { () -> Void in
        self.localView.renderFrame(nil)
            self.rtcLocalVideoTrack.removeRenderer(self.localView)
            
            self.rtcLocalVideoStream.removeVideoTrack(self.rtcLocalVideoTrack)
            self.rtcLocalVideoStream = nil
            //self.localView.hidden=true
            self.localView.removeFromSuperview()
                //if(self.remoteView.superview != nil)
                //{
                   // self.remoteView.setNeedsDisplay()
        //}
        
            localViewOutlet.setNeedsDisplay()
        remoteView.setNeedsDisplay()
            self.rtcLocalVideoTrack=nil
       ///// })
        
    }
    
    
    
    func disconnectAll()
    {
        if(mvideo.pc != nil)
        {
            mvideo.pc=nil
        }
        
        if(self.rtcLocalVideoTrack != nil)
        {
            self.rtcLocalVideoTrack.removeRenderer(self.localView)
        }
        if(self.rtcVideoTrackReceived != nil)
        {
            self.rtcVideoTrackReceived.removeRenderer(self.remoteView)
        }
        //mvideo.rtcLocalstream=nil
        //mvideo.rtcLocalVideoTrack=nil
        //mvideo.rtcRemoteVideoTrack=nil
        //mvideo.rtcStreamReceived=nil
        mvideo=nil
        
        
        mAudio.stream=nil
        mAudio.pc=nil
        mAudio=nil
        
        
        
        if(svideo.pc != nil)
        {
            svideo.pc=nil
        }
        svideo=nil
        
        
        if(mdata.pc != nil)
        {
            mdata.pc=nil
        }
        
        mAudio=MeetingRoomAudio()
        mAudio.initAudio()
        mAudio.delegateDisconnect=self
        
        
        mdata=MeetingRoomData()
        mdata.addHandlers()
        
        mvideo=MeetingRoomVideo()
        mvideo.addHandlers()
        mvideo.delegateConference=self
        
        svideo=MeetingRoomScreen()
        svideo.addHandlers()
        svideo.delegateConference=self
        
        
    }
    
    @IBAction func btnFileSharePressed(sender: AnyObject) {
        
        //var documentDir:String!
        print(NSOpenStepRootDirectory())
        
        mdata.sharefile()
    }
    
    func resetVideo()
    {print("resetttttt")
        if(mvideo.streambackup != nil)
        {
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                
            
                self.mvideo.streambackup=nil
            //self.rtcVideoTrackReceived.removeRenderer(self.remoteView)
            //self.rtcVideoTrackReceived=nil
              //  self.mvideo.rtcRemoteVideoTrack=nil
              //  self.rtcVideoTrackReceived=nil
              //  self.remoteView.removeFromSuperview()
            //self.=nil
            })
    }
        /*
resetVideo: function () {
logger.log('going to stop local video stream')
if(videoStream || videoStream.getTracks()[0]) {

logger.log('stopping local video stream now')
videoStream.getTracks()[0].stop();
videoStream = null;

}
*/
    }
}