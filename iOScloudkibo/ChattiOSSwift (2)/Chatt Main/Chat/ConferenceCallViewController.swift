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
import MobileCoreServices
import MediaPlayer

class ConferenceCallViewController: UIViewController,ConferenceDelegate,ConferenceScreenReceiveDelegate,ConferenceRoomDisconnectDelegate,ConferenceEndDelegate,ConferenceFileDelegate,UIDocumentMenuDelegate,UIDocumentPickerDelegate {
    var rtcLocalVideoTrack:RTCVideoTrack!
    ////////////////////////////////////////var rtcLocalstream:RTCMediaStream!
    var mvideo:MeetingRoomVideo!
    var mdata:MeetingRoomData!
    //var mvideo:MeetingRoomVideo!
    ////////////////var rtcRemoteVideoStream:RTCMediaStream!
    var videostream:RTCMediaStream!
    var vidstream:RTCMediaStream!
    @IBOutlet weak var btnFileView: UIBarButtonItem!
    
    @IBOutlet weak var btncapture: UIBarButtonItem!
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
    var screenCaptureToggle:Bool=false
    
    @IBOutlet var localViewOutlet: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //var mpVolumeView=MPVolumeView.init(frame: CGRect(x:0, y:0, width: 400,height: 400))
            //self.view.addSubview(mpVolumeView)
        mAudio=MeetingRoomAudio()
        mAudio.initAudio()
        mAudio.delegateDisconnect=self
        mAudio.delegateConferenceEnd=self
        
        print("inside controller did load")
        mvideo=MeetingRoomVideo()
        mvideo.addHandlers()
        mvideo.delegateConference=self
        mvideo.delegateConferenceEnd=self
        
        svideo=MeetingRoomScreen()
        svideo.addHandlers()
        svideo.delegateConference=self
        svideo.delegateConferenceEnd=self
        
        mdata=MeetingRoomData()
        mdata.addHandlers()
        
        mdata.delegateConferenceEnd=self
        mdata.delegateConferenceFile=self
        
        
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
            mvideo.delegateConferenceEnd=self
        }
        if(actionVideo == true)
        {//isInitiator=true
            ///self.rtcLocalVideoStream=getLocalMediaStream()
            
            if(self.rtcLocalVideoStream == nil)
            {self.rtcLocalVideoStream=createLocalVideoStream()}
            videostream=rtcLocalVideoStream
            vidstream=rtcLocalVideoStream
            
            mvideo.toggleVideo(actionVideo,s: vidstream)
        }
        else{
            
            mvideo.toggleVideo(actionVideo,s: vidstream)
            //isInitiator=false
           resetVideo()
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
        ///self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    @IBAction func btnCapturePressed(sender: AnyObject) {
        
        screenCaptureToggle = !screenCaptureToggle
        //////// mdata.toggleScreen(screenAction, tempstream: <#T##RTCMediaStream!#>)
        
        if(screenCaptureToggle)
        {
            socketObj.socket.emit("conference.streamScreen", ["username":username!,"id":currentID!,"type":"screenAndroid","action":"true"])
            
            btncapture.title! = "Hide"
        
        if(mdata.pc == nil)
        {
            mdata.createPeerConnection()
            mdata.CreateAndAttachDataChannel()
        }
        
           ////////////tryy march 31 2016  socketObj.socket.emit("conference.streamScreen", ["username":username!,"id":currentID!,"type":"screenAndroid","action":"true"])
            atimer=NSTimer(timeInterval: 0.1, target: self, selector: "timerFiredScreenCapture", userInfo: nil, repeats: true)
            
        }
        else
        {
            btncapture.title! = "Capture"
            
            socketObj.socket.emit("conference.streamScreen", ["username":username!,"id":currentID!,"type":"screenAndroid","action":"false"])
            atimer=NSTimer(timeInterval: 0.1, target: self, selector: "timerFiredScreenCapture", userInfo: nil, repeats: true)
        
            
            mdata.pc = nil
        }
        
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)) { () -> Void in
            
            while(self.screenCaptureToggle)
            //for(var i=0;i<30000;i++)
            {
                atimer.fire()
                sleep(1)
            }
            
   
        }
        
 
        
    }
    
    func timerFiredScreenCapture()
    {print("inside timerFiredScreenCapture")
        
        //if(countTimer%2 == 0){
        
        //while(atimer.timeInterval < 3000)
        var chunkLength=64000
        //UIImage(myscreen)
       // for(var i=0;i<3000;i++)
        //{
           ////for window in UIApplication.sharedApplication().windows{
           var screenshot:UIImage!
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                /*
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
                */
                //////////working 
                var myscreen=UIScreen.mainScreen().snapshotViewAfterScreenUpdates(true)
                //var myscreen=UIApplication.sharedApplication().keyWindow?.snapshotViewAfterScreenUpdates(true)
                //UIGraphicsBeginImageContext(myscreen!.bounds.size)
        
                ///workingg
                UIGraphicsBeginImageContext(UIScreen.mainScreen().bounds.size)
                ////////UIGraphicsBeginImageContext( UIScreen.mainScreen().bounds.size)
                ///self.view.drawViewHierarchyInRect(window.layer.bounds, afterScreenUpdates: true)
                 self.view.drawViewHierarchyInRect(myscreen.bounds, afterScreenUpdates: true)
                //print("width is \(UIScreen.mainScreen().bounds.width), height is \(UIScreen.mainScreen().bounds.height)")
                print("width is \(myscreen.layer.bounds.width), height is \(myscreen.layer.bounds.height)")
                //var context:CGContextRef=UIGraphicsGetCurrentContext()!;
                //myscreen!.layer.renderInContext(context)
                
                screenshot=UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                
        
                var imageData:NSData = UIImageJPEGRepresentation(screenshot, 1.0)!
                var numchunks=0
                var len=imageData.length
                print("length is\(len)")
                numchunks=len/chunkLength
                print("numchunks are \(numchunks)")
        
        var test="\(imageData.length)"
      
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
        })
       //// }//end for windows
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
        
        
        
        /*
        self.rtcVideoTrackReceived=remoteVideoTrack
        self.rtcVideoTrackReceived.addRenderer(self.remoteView)
        self.localViewOutlet.addSubview(self.remoteView)
        self.localViewOutlet.updateConstraintsIfNeeded()
        
        self.remoteView.setNeedsDisplay()
        self.localView.setNeedsDisplay()
        self.localViewOutlet.setNeedsDisplay()
        if(self.localView.superview != nil)
        {
        self.localView.setNeedsDisplay()
        }
*/
        self.rtcLocalVideoTrack=localVideoTrack
        self.rtcLocalVideoTrack.addRenderer(self.localView)
        self.localViewOutlet.addSubview(self.localView)
        
        
        //////march 30 2016
        self.localViewOutlet.updateConstraintsIfNeeded()
        
        self.localView.setNeedsDisplay()
        
        
        //march 30 2016
        self.remoteView.setNeedsDisplay()
        
        
        self.localViewOutlet.setNeedsDisplay()
        
        /////march 30 2016
        //--------
        if(self.remoteView.superview != nil)
        {
            self.remoteView.setNeedsDisplay()
        }
        
        ///-----
        //// mvideo.addLocalMediaStreamToPeerConnection(rtcLocalVideoStream)
        
    }
    func didReceiveRemoteVideoTrack(remoteVideoTrack:RTCVideoTrack)
    {
        print("didreceiveremotevideotrack11")
        
        dispatch_async(dispatch_get_main_queue(), {
        
        
        //////CODE TO RENDER REMOTE VIDEO
        
        
        self.rtcVideoTrackReceived=remoteVideoTrack
        self.rtcVideoTrackReceived.addRenderer(self.remoteView)
        self.localViewOutlet.addSubview(self.remoteView)
        self.localViewOutlet.updateConstraintsIfNeeded()
        
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
        print("didreceiveremotescreentrack11")
        
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
    
    func didReceiveFile() {
        print("file receivedddddddddddddd;;;;;;;;")
        btnFileView.enabled=true
        let alert = UIAlertController(title: "Success", message: "You have received a new file", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
        //btnFileView.tintColor=UIColor.blackColor()
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
        mAudio.delegateDisconnect=self
        
        mdata=MeetingRoomData()
        mdata.addHandlers()
        mdata.delegateConferenceEnd=self
        mdata.delegateConferenceFile=self
        
        mvideo=MeetingRoomVideo()
        mvideo.addHandlers()
        mvideo.delegateConference=self
        mvideo.delegateConferenceEnd=self
        
        svideo=MeetingRoomScreen()
        svideo.addHandlers()
        svideo.delegateConference=self
        svideo.delegateConferenceEnd=self
        
    }
    
    @IBAction func btnFileSharePressed(sender: AnyObject) {
        
        //var documentDir:String!
        print(NSOpenStepRootDirectory())
        ///var UTIs=UTTypeCopyPreferredTagWithClass("public.image", kUTTypeImage)?.takeRetainedValue() as! [String]
        
        let importMenu = UIDocumentMenuViewController(documentTypes: [kUTTypePackage as String, kUTTypeText as NSString as String, kUTTypePDF as String,kUTTypeJPEG as String, kUTTypeMP3 as String, kUTTypeContent as String, kUTTypeData as String, kUTTypeDiskImage as String,"com.apple.iwork.keynote.key","com.apple.iwork.numbers.numbers","com.apple.iwork.pages.pages",
            "public.text","com.microsoft.word.doc","com.microsoft.excel.xls", "com.microsoft.powerpoint.ppt", "com.adobe.pdf"],
            inMode: .Import)
        ///////let importMenu = UIDocumentMenuViewController(documentTypes: UTIs, inMode: .Import)
        importMenu.delegate = self
        self.presentViewController(importMenu, animated: true, completion: nil)
        //////////mdata.sharefile()
        
        /*let documentPicker = UIDocumentPickerViewController(documentTypes: [kUTTypeText as NSString as String],
            inMode: .Import)
        documentPicker.delegate = self
        presentViewController(documentPicker, animated: true, completion: nil)*/
    }
    
    func documentPicker(controller: UIDocumentPickerViewController, didPickDocumentAtURL url: NSURL) {
        
        print("picker url is \(url)")
        
        url.startAccessingSecurityScopedResource()
        let coordinator = NSFileCoordinator()
        var error:NSError? = nil
        coordinator.coordinateReadingItemAtURL(url, options: [], error: &error) { (url) -> Void in
            // do something with it
            let fileData = NSData(contentsOfURL: url)
            print(fileData?.description)
            print("file gotttttt")
            ///////////self.mdata.sharefile(url.URLString)
            var furl=NSURL(string: url.URLString)
            //ADDEDDDDD
            //////furl=fileurl
            /////////////////newwwwwvar furl=NSURL(fileURLWithPath: filePathImage)
            
            ///// var furl=NSURL(fileURLWithPath:"file:///private/var/mobile/Containers/Data/Application/F4137E3A-02E9-4A4D-8F20-089484823C88/tmp/iCloud.MyAppTemplates.cloudkibo-Inbox/regularExpressions.html")
            
            //METADATA FILE NAME,TYPE
            print(furl!.pathExtension!)
            print(furl!.URLByDeletingPathExtension?.lastPathComponent!)
            var ftype=furl!.pathExtension!
            var fname=furl!.URLByDeletingPathExtension?.lastPathComponent!
            //var attributesError=nil
            var fileAttributes:[String:AnyObject]=["":""]
            do{
                fileAttributes = try NSFileManager.defaultManager().attributesOfItemAtPath(furl!.path!)
                
            }catch
            {print("error")
                print(fileAttributes)
            }
            
            let fileSizeNumber = fileAttributes[NSFileSize]! as! NSNumber
            print(fileAttributes[NSFileType] as! String)
            
            self.mdata.fileSize=fileSizeNumber.integerValue
            
            //FILE METADATA size
            print(self.mdata.fileSize)
            urlLocalFile=url
            /////let text2 = fm.contentsAtPath(filePath)
            ////////print(text2)
            /////////print(JSON(text2!))
            ///mdata.fileContents=fm.contentsAtPath(filePathImage)!
            self.mdata.fileContents=NSData(contentsOfURL: url)
            self.mdata.filePathImage=url.URLString
            var filecontentsJSON=JSON(NSData(contentsOfURL: url)!)
            print(filecontentsJSON)
            var mjson="{\"file_meta\":{\"name\":\"\(fname!)\",\"size\":\"\(self.mdata.fileSize.description)\",\"filetype\":\"\(ftype)\",\"browser\":\"firefox\",\"uname\":\"\(username!)\",\"fid\":\(self.mdata.myfid),\"senderid\":\(currentID!)}}"
            var fmetadata="{\"eventName\":\"data_msg\",\"data\":\(mjson)}"
            self.mdata.sendDataBuffer(fmetadata,isb: false)
            socketObj.socket.emit("conference.chat", ["message":"You have received a file. Download and Save it.","username":username!])
            
            let alert = UIAlertController(title: "Success", message: "Your file has been successfully sent", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            
        }

    
        url.stopAccessingSecurityScopedResource()
        //mdata.sharefile(url)
    }
    
    
    
    func documentMenu(documentMenu: UIDocumentMenuViewController, didPickDocumentPicker documentPicker: UIDocumentPickerViewController) {
        
        documentPicker.delegate = self
        presentViewController(documentPicker, animated: true, completion: nil)
        
        
    }
    func documentMenuWasCancelled(documentMenu: UIDocumentMenuViewController) {
        
        
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