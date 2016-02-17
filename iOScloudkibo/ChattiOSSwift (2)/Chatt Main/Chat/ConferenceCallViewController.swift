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
    
    var mvideo:MeetingRoomVideo!
    var mdata:MeetingRoomData!
    //var mvideo:MeetingRoomVideo!
    var svideo:MeetingRoomScreen!
    var rtcVideoTrackReceived:RTCVideoTrack! = nil
    var localView:RTCEAGLVideoView! = nil
    var remoteView:RTCEAGLVideoView! = nil
    var rtcLocalVideoTrack:RTCVideoTrack! = nil
    var actionVideo:Bool=false
    var rtcLocalVideoStream:RTCMediaStream!
    //var rtcDataChannel:RTCDataChannel!
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
        
        self.localView=RTCEAGLVideoView(frame: CGRect(x: w, y: h, width: 90, height: 85))
        self.localView.drawRect(CGRect(x: w, y: h, width: 90, height: 85))
        
        //self.localView=RTCEAGLVideoView(frame: CGRect(x: 0, y: 50, width: 90, height: 85))
        //self.localView.drawRect(CGRect(x: 0, y: 50, width: 90, height: 85))
        
        ///self.remoteView=RTCEAGLVideoView()
        self.remoteView=RTCEAGLVideoView(frame: CGRect(x: 0, y: 50, width: 500, height: 450))
        self.remoteView.drawRect(CGRect(x: 0, y: 50, width: 500, height: 450))
        print("size is... \(localViewOutlet.bounds.width)")
        print("size is... \(localViewOutlet.bounds.height)")
        
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
        {isInitiator=true
            ///self.rtcLocalVideoStream=getLocalMediaStream()
            
            self.rtcLocalVideoStream=mvideo.createLocalVideoStream()
            mvideo.toggleVideo(actionVideo,tempstream: rtcLocalVideoStream)
        }
        else{
            mvideo.toggleVideo(actionVideo,tempstream: rtcLocalVideoStream)
            mvideo.removeLocalMediaStreamFromPeerConnection()
            mvideo.pc=nil
            if((self.rtcLocalVideoTrack) != nil)
            {
                print("remove local video renderer")
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.rtcLocalVideoTrack.removeRenderer(self.localView)
                    self.rtcLocalVideoStream.removeVideoTrack(self.rtcLocalVideoTrack)
                    self.localView.removeFromSuperview()
                    self.rtcLocalVideoTrack=nil
                })
                
                
                ////rtcLocalVideoStream=nil
                
            }
            
            
        }
        
        socketObj.socket.emit("conference.chat", ["message":"This is test mesage from iphone","username":username!])
        
        
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
        
        
        
        
        atimer=NSTimer(timeInterval: 0.5, target: self, selector: "timerFiredScreenCapture", userInfo: nil, repeats: true)
        
        
        countTimer++
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            
            atimer.fire()
            
            ///if(countTimer==10){
            // atimer.invalidate()
            print("timer stopped1")
        })
        
    }
    
    func timerFiredScreenCapture()
    {print("inside timerFiredScreenCapture")
        // var myscreen=UIScreen.mainScreen().snapshotViewAfterScreenUpdates(true)
        
        //if(countTimer%2 == 0){
        
        //while(atimer.timeInterval < 3000)
        for(var i=0;i<30;i++)
        {
            for window in UIApplication.sharedApplication().windows{
                
                var bitmapBytesPerRow = Int(window.layer.bounds.size.width * 4)
                var bitmapByteCount = Int(bitmapBytesPerRow * Int(window.layer.bounds.size.height))
                var bitmapData=malloc(bitmapByteCount)
                var colorSpace = CGColorSpaceCreateDeviceRGB()
                var ww=Int(window.layer.bounds.size.width)
                var hh=Int(window.layer.bounds.size.height)
                //////CGBitmapContextCreate(bitmapData, ww , hh, 8, bitmapBytesPerRow, colorSpace,)
                
                ////UIGraphicsBeginImageContext(self.view.layer.bounds.size)
                UIGraphicsBeginImageContext(window.layer.bounds.size)
                ///    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.view.drawViewHierarchyInRect(UIScreen.mainScreen().bounds, afterScreenUpdates: true)
                
                ///// window.layer.renderInContext(UIGraphicsGetCurrentContext()!)
                var screenshot:UIImage=UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                ////////////////// saveImage(screenshot)
                var imageData:NSData = UIImageJPEGRepresentation(screenshot, 1.0)!
                /////
                ///////IMAGE SAVE CODE
                /////
                /*UIImageWriteToSavedPhotosAlbum(screenshot, nil, nil, nil)
                ///  })
                var paths:NSArray=NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.PicturesDirectory, NSSearchPathDomainMask.UserDomainMask, true)
                var documentPath:NSString=paths.objectAtIndex(0) as! NSString
                /////var filePath:NSString=documentPath.stringByAppendingPathComponent("cloudkibo\(self.countTimer).jpg")
                UIImageWriteToSavedPhotosAlbum(screenshot, nil, nil, nil)
                ////imageData.writeToFile(filePath as String, atomically: true)
                ////print("image saved \(filePath)")
                print("screen captured")
                */
                
                mdata.sendImage(imageData)
                ///////var imageSent=rtcDataChannel.sendData(RTCDataBuffer(data: imageData, isBinary: true))
                //////print("image senttttt \(imageSent)")
                
                //// }
                ///else{
                ////  print("not captured")
                ///}
            }}
        print("outside")
        atimer.invalidate()
        print("timer stopped")
        
        
        
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
        ////self.localView.setSize(CGSize(width: 200,height: 250))
        if(self.localView.superview != nil)
        {
            self.localView.removeFromSuperview()
        }
        
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
            print("remove remote video renderer")
            
            self.rtcVideoTrackReceived.removeRenderer(self.remoteView)
            self.rtcVideoTrackReceived=nil
            self.remoteView.removeFromSuperview()
            
        }
        
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
        mvideo.rtcLocalstream=nil
        mvideo.rtcLocalVideoTrack=nil
        mvideo.rtcRemoteVideoTrack=nil
        mvideo.rtcStreamReceived=nil
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
        
        let fm = NSFileManager.defaultManager()
        let dirPaths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let docsDir1 = dirPaths[0]
        
        var documentDir=docsDir1 as NSString
        /*var filePath=documentDir.stringByAppendingPathComponent("file1.txt")
        fm.createFileAtPath(filePath, contents: nil, attributes: nil)*/
        var filePath=documentDir.stringByAppendingPathComponent("file3.jpg")
        print(filePath)
        var s=fm.createFileAtPath(filePath, contents: NSData(contentsOfFile: "This is a test file on iphone.sdfsdkmfnskdfnjsdfnsjdfnsjkdnfsjdnfsjkdfnjksdfnsjdnfskjdnfjsnfjksdnfjsdknfnf sdfnsjdfnsjkf sdf sdjkfnsdf dsf sdf sdfsbdfjsd fksdf sdbfsf sdnf sdkf sndm fsdf sdf sdf dmnsf sdhf sdnmf sdf msnd snd fsdbnf nds fsnd fnsdbfndsf bdnsbfnsdbfnsdbfnsdbfnds fnbdsf nsdf bnsdf nsbdf nsdf nsdfb dhsbfdhsbdnsbfhsdbf sdhfb dnsf vdhb dsbvshd fbdnsbhdsf dbfvdnbfhdbfhdsfbhsdfhsdfhsdfbsdhbfhsdfhsjdfvhsdjfhsfhsfhjsfhsfvhsfvshvhjdfvhdsfvdhjsfvhdsfhdsfvhjsdvfhdjsfhsdfvhsdvfhjsdfv"), attributes: nil)
        print("file created \(s)")
        
        
        
        
        /*var paths:NSArray=NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.PicturesDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        var documentPath:NSString=paths.objectAtIndex(0) as! NSString
        var filePath2:NSString=documentPath.stringByAppendingPathComponent("IMG_0036.jpg")
        
        */
        let dirPaths2 = NSSearchPathForDirectoriesInDomains(.DocumentDirectory,
            .UserDomainMask, true)
        
        let docsDir2 = dirPaths2[0] as! NSString
        var filePath3:NSString=docsDir2.stringByAppendingPathComponent("file3.jpg")
        var fileSize : UInt64 = 0
        
        do {
            let attr : NSDictionary? = try NSFileManager.defaultManager().attributesOfItemAtPath(filePath3 as String)
            
            if let fileattribs = attr {
                let type = fileattribs["NSFileType"] as! String
                print("File type \(type)")
            }
            /*if let _attr = attr {
                fileSize = _attr.fileSize();
                print(fileSize)
                print(_attr.fileType())
                
            }*/
        } catch {
            print("Error: \(error)")
        }
        
    }
}