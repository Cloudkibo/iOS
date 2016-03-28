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
import MobileCoreServices



class VideoViewController: UIViewController,RTCPeerConnectionDelegate,RTCSessionDescriptionDelegate,RTCEAGLVideoViewDelegate,SocketClientDelegateWebRTC,RTCDataChannelDelegate,UIDocumentPickerDelegate,UIDocumentMenuDelegate {
    
    var newjson:JSON!
    var myJSONdata:JSON!
    var chunknumber:Int!
    var strData:String!
    
    @IBOutlet weak var btnViewFile: UIBarButtonItem!
    var myfid=0
    var fid:Int!
    var bytesarraytowrite:Array<UInt8>!
    var jsonnnn:Dictionary<String, AnyObject>!
    var numberOfChunksReceived:Int=0
    var fu=FileUtility()
    var filePathImage:String!
    var fileSize:Int!
    var fileContents:NSData!
    var chunknumbertorequest:Int=0
    var numberOfChunksInFileToSave:Double=0
    var filePathReceived:String!
    var fileSizeReceived:Int!
    var fileContentsReceived:NSData!

    //------
    var screenshared=false
    var delegate:SocketClientDelegateWebRTC!
    @IBOutlet var localViewOutlet: UIView!
    var localView:RTCEAGLVideoView! = nil
    var remoteView:RTCEAGLVideoView! = nil
    var rtcLocalMediaStream:RTCMediaStream! = nil
    var videoAction=false
    var audioAction=true
    //var rtcMediaStream:RTCMediaStream!
    
    var pc:RTCPeerConnection! = nil
    //var rtcVideoTrack1:RTCVideoTrack!
    var rtcMediaConst:RTCMediaConstraints! = nil
    var rtcVideoSource:RTCVideoSource! = nil
    var rtcVideoCapturer:RTCVideoCapturer! = nil
    //var rtcVideoTrack:RTCVideoTrack!
    var rtcVideoRenderer:RTCVideoRenderer! = nil
    //var abc:RTCVideoTrack!!
    var rtcLocalVideoTrack:RTCVideoTrack! = nil
    //var currentId:String!
    
    var by:Int!
    var rtcStreamReceived:RTCMediaStream! = nil
    var rtcVideoTrackReceived:RTCVideoTrack! = nil
    var rtcAudioTrackReceived:RTCAudioTrack! = nil
    // var rtcCaptureSession:AVCaptureSession!
    var rtcDataChannel:RTCDataChannel!
    var countTimer=1
    
    
    func saveImage(screen:UIImage){
        
    }
    
    
    
    @IBAction func btnCapturePressed(sender: UIBarButtonItem) {
        ///DATA SENT CODE
        /* var senttt=rtcDataChannel.sendData(RTCDataBuffer(data: NSData(base64EncodedString: "helloooo iphone sendind data through data channel", options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters),isBinary: true))
        print("datachannel message sent is \(senttt)")
        var test="hellooo"
        let buffer = RTCDataBuffer(
        data: (test.dataUsingEncoding(NSUTF8StringEncoding))!,
        isBinary: false
        )
        
        let result = self.rtcDataChannel!.sendData(buffer)
        print("datachannel message sent is \(result)")
        */
        
        ////////////CORRECT CODE TO CAPTURE IMAGES
        socketObj.socket.emit("conference.stream", ["username":username!,"id":currentID!,"type":"androidScreen","action":"true"])
        socketObj.socket.emit("conference.stream", ["username":username!,"id":currentID!,"type":"screenAndroid","action":"true"])
        
        atimer=NSTimer(timeInterval: 0.5, target: self, selector: "timerFiredScreenCapture", userInfo: nil, repeats: true)
        
        
        countTimer++
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            
            atimer.fire()
            
            ///if(countTimer==10){
            // atimer.invalidate()
            print("timer stopped1")
        })
        
        
    }
    /*@IBAction func backbtnPressed(sender: UIBarButtonItem) {
        print("backkkkkkkkkkkkkk pressed")
        self.dismissViewControllerAnimated(true, completion: nil)
    }*/
    func timerFiredScreenCapture()
    {print("inside timerFiredScreenCapture")
        // var myscreen=UIScreen.mainScreen().snapshotViewAfterScreenUpdates(true)
        
        //if(countTimer%2 == 0){
        
        //while(atimer.timeInterval < 3000)
        for(var i=0;i<10;i++)
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
                
                var imageSent=rtcDataChannel.sendData(RTCDataBuffer(data: imageData, isBinary: true))
                print("image senttttt \(imageSent)")
                
                //// }
                ///else{
                ////  print("not captured")
                ///}
            }}
        print("outside")
        atimer.invalidate()
        print("timer stopped")
        
        
        
    }
    
    
    func randomStringWithLength (len : Int) -> NSString {
        
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        
        let randomString : NSMutableString = NSMutableString(capacity: len)
        
        for (var i=0; i < len; i++){
            let length = UInt32 (letters.length)
            let rand = arc4random_uniform(length)
            randomString.appendFormat("%C", letters.characterAtIndex(Int(rand)))
        }
        
        return randomString
    }
    
    func addLocalMediaStreamToPeerConnection()
    {
        
        if(self.rtcLocalMediaStream != nil)
        {
            self.pc.addStream(self.rtcLocalMediaStream)
        }
        else
        {
            self.rtcLocalMediaStream=self.getLocalMediaStream()
            self.pc.addStream(self.rtcLocalMediaStream)
            
            
            ///////////////self.pc.addStream(self.getLocalMediaStream())
        }
    }
    
    func CreateAndAttachDataChannel()
    {
        
        var rtcInit=RTCDataChannelInit.init()
        // rtcInit.isNegotiated=true
        //rtcInit.isOrdered=true
        // rtcInit.maxRetransmits=30
        
        rtcDataChannel=pc.createDataChannelWithLabel("channel", config: rtcInit)
        if(rtcDataChannel != nil)
        {
            print("datachannel not nil")
            rtcDataChannel.delegate=self
            
            //////// var senttt=rtcDataChannel.sendData(RTCDataBuffer(data: NSData(base64EncodedString: "helloooo iphone sendind data through data channel", options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters),isBinary: true))
            /// print("datachannel message sent is \(senttt)")
            ///var test="hellooo"
            
        }
        
    }
    
    @IBAction func endCallBtnPressed(sender: AnyObject) {
        socketObj.socket.emit("message",["msg":"hangup","room":globalroom,"to":iamincallWith!,"username":username!])
        socketObj.socket.emit("leave",["room":joinedRoomInCall])
        
        //self.pc=nil
        joinedRoomInCall=""
        //iamincallWith=nil
        isInitiator=false
        //rtcFact=nil
        areYouFreeForCall=true
        currentID=nil
        otherID=nil
        rtcLocalMediaStream=nil
        rtcStreamReceived=nil
        //self.pc.close()
        
        //self.pc=nil
        //rtcFact=nil //**********important********
        //iamincallWith=nil
        self.localView.renderFrame(nil)
        self.remoteView.renderFrame(nil)
        //^^^^^^^^^^^newwwww self.disconnect()
        if((self.pc) != nil)
        {
            if((self.rtcLocalVideoTrack) != nil)
            {print("remove localtrack renderer")
                
                self.rtcLocalVideoTrack.removeRenderer(self.localView)
                //////////////////////////////////////////////////////
                self.rtcLocalVideoTrack=nil
                self.localView.removeFromSuperview()
                /////////////////////////////////////////////////////
            }
            if((self.rtcVideoTrackReceived) != nil)
            {print("remove remotetrack renderer")
                self.rtcVideoTrackReceived.removeRenderer(self.remoteView)
            }
            print("out of removing remoterenderer")
            ////self.rtcLocalVideoTrack=nil
            ////self.rtcVideoTrackReceived=nil
            //kjkljkljkkhkjhkj
            
            self.pc=nil
            joinedRoomInCall=""
            //iamincallWith=nil
            isInitiator=false
            rtcFact=nil
            areYouFreeForCall=true
            currentID=nil
            otherID=nil
            ////// self.remoteDisconnected()
            
            ////// socketObj.socket.emit("message",["msg":"hangup","room":globalroom,"to":iamincallWith!,"username":username!])
            
            
            // iamincallWith=nil
            print("hangup emitted")
            
            if(localView.superview != nil)
            {
                print("localview was a subview. remmoving")
                localView.removeFromSuperview()
            }
            if(remoteView.superview != nil)
            {
                print("remoteview was a subview. remmoving")
                
                remoteView.removeFromSuperview()
            }
            
            if(self.rtcLocalMediaStream != nil)
            {
                print("stopped local stream")
                ///// rtcLocalMediaStream.videoTracks[0].stopRunning()
                //rtcLocalMediaStream.audioTracks[0].stopRunning()
            }
            if(self.rtcStreamReceived != nil)
            {
                print("stopped remote stream")
                self.rtcStreamReceived.removeAudioTrack(rtcStreamReceived.audioTracks[0] as! RTCAudioTrack)
                /////rtcStreamReceived.videoTracks[0].stopRunning()
                //rtcStreamReceived.audioTracks[0].stopRunning()
            }
            
            print("views removed from parent")
        }
        
        joinedRoomInCall=""
        iamincallWith=""
        isInitiator=false
        areYouFreeForCall=true
        
        rtcLocalMediaStream=nil //test and try-------------
        rtcStreamReceived=nil
        if(rtcDataChannel != nil){
            rtcDataChannel=nil
            //newwwwwwww tryy
            //rtcDataChannel.close()
        }
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
            
            print("doneeeeeee")
            
        })
        
        
    }
    
    
    @IBAction func toggleVideoBtnPressed(sender: AnyObject) {
        videoAction = !videoAction.boolValue
        socketObj.socket.emit("conference.stream", ["username":username!,"id":currentID!,"type":"video","action":videoAction.boolValue])
        
        
        
    }
    
    @IBAction func toggleAudioPressed(sender: AnyObject) {
        audioAction = !audioAction.boolValue
        self.rtcLocalMediaStream!.audioTracks[0].setEnabled(audioAction)
    }
    
    func disconnect()
    {
        print("inside disconnect")
        if((self.pc) != nil)
        {
            dispatch_async(dispatch_get_global_queue(Int(QOS_CLASS_USER_INITIATED.rawValue),0)){
                
                if((self.rtcLocalVideoTrack) != nil)
                {print("remove localtrack renderer")
                    self.rtcLocalVideoTrack.removeRenderer(self.localView)
                }
                if((self.rtcVideoTrackReceived) != nil)
                {print("remove remotetrack renderer")
                    self.rtcVideoTrackReceived.removeRenderer(self.remoteView)
                }
                print("out of removing remoterenderer")
                self.rtcLocalVideoTrack=nil
                
                //////////////self.localView.renderFrame(nil)
                /////////////self.remoteView.renderFrame(nil)
                self.pc=nil
                joinedRoomInCall=""
                //iamincallWith=nil
                isInitiator=false
                // rtcFact=nil
                areYouFreeForCall=true
                currentID=nil
                otherID=nil
                //self.remoteDisconnected()
                
                //////////////socketObj.socket.emit("message",["msg":"hangup","room":globalroom,"to":iamincallWith!,"username":username!])
                
                iamincallWith=nil
                //self.localView.removeFromSuperview()
                //self.remoteView.removeFromSuperview()
                self.localView=nil
                self.remoteView=nil
                
                //^^^^^^^^^^^^newwwwww
                self.rtcLocalMediaStream = nil
                self.rtcStreamReceived = nil//^^^^^^^^^^^^^^^^newwwww
                
                
                if(self.rtcDataChannel != nil){
                    self.rtcDataChannel.close()
                    ////////newwwwwww
                    self.rtcDataChannel=nil
                }
                
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    
                    
                    
                    self.dismissViewControllerAnimated(true, completion: { () -> Void in
                        
                    })
                    
                    
                })
            }
            
            
        }
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        bytesarraytowrite=Array<UInt8>()
        super.init(coder: aDecoder)
        //print(AuthToken!)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        /*if(socketObj.delegateWebRTC == nil)
        {
            socketObj.delegateWebRTC=self
        }*/
        
        //--------------
        //----------------
        ///////////addHandlers()
        
        if(socketObj.delegateWebRTC == nil)
        {
            socketObj.delegateWebRTC=self
        }
        
        
        //******************************************************************************
        /* self.localViewTop.setSize(CGSize(width: 500, height: 500))*/
        self.localView=RTCEAGLVideoView(frame: CGRect(x: 0, y: 50, width: 500, height: 450))
        self.localView.drawRect(CGRect(x: 0, y: 50, width: 500, height: 450))
        self.remoteView=RTCEAGLVideoView(frame: CGRect(x: 0, y: 50, width: 500, height: 450))
        self.remoteView.drawRect(CGRect(x: 0, y: 50, width: 500, height: 450))
        
        var mainICEServerURL:NSURL=NSURL(fileURLWithPath: Constants.MainUrl)
        
        
        rtcICEarray.append(RTCICEServer(URI: NSURL(string:"turn:45.55.232.65:3478?transport=udp"), username: "cloudkibo", password: "cloudkibo"))
        rtcICEarray.append(RTCICEServer(URI: NSURL(string:"turn:45.55.232.65:3478?transport=tcp"), username: "cloudkibo", password: "cloudkibo"))
        rtcICEarray.append(RTCICEServer(URI: NSURL(string:"stun:stun.l.google.com:19302"), username: "", password: ""))
        rtcICEarray.append(RTCICEServer(URI: NSURL(string:"stun:23.21.150.121"), username: "", password: ""))
        rtcICEarray.append(RTCICEServer(URI: NSURL(string:"stun:stun.anyfirewall.com:3478"), username: "", password: ""))
        rtcICEarray.append(RTCICEServer(URI: NSURL(string:"turn:turn.bistri.com:80?transport=udp"), username: "homeo", password: "homeo"))
        rtcICEarray.append(RTCICEServer(URI: NSURL(string:"turn:turn.bistri.com:80?transport=tcp"), username: "homeo", password: "homeo"))
        rtcICEarray.append(RTCICEServer(URI: NSURL(string:"turn:turn.anyfirewall.com:443?transport=tcp"), username: "webrtc", password: "webrtc"))
        
        /*
        {"url":"stun:turn01.uswest.xirsys.com"},
        {"username":"bcd62532-f1cd-11e5-a87b-5883419cfa3a","url":"turn:turn01.uswest.xirsys.com:443?transport=udp","credential":"bcd625be-f1cd-11e5-b663-8968345edd51"},
        {"username":"bcd62532-f1cd-11e5-a87b-5883419cfa3a","url":"turn:turn01.uswest.xirsys.com:443?transport=tcp","credential":"bcd625be-f1cd-11e5-b663-8968345edd51"},
        {"username":"bcd62532-f1cd-11e5-a87b-5883419cfa3a","url":"turn:turn01.uswest.xirsys.com:5349?transport=udp","credential":"bcd625be-f1cd-11e5-b663-8968345edd51"},
        {"username":"bcd62532-f1cd-11e5-a87b-5883419cfa3a","url":"turn:turn01.uswest.xirsys.com:5349?transport=tcp","credential":"bcd625be-f1cd-11e5-b663-8968345edd51"},
        {"url":"turn:turn.cloudkibo.com:3478?transport=tcp","username":"cloudkibo","credential":"cloudkibo"},
        {"url":"turn:turn.cloudkibo.com:3478?transport=udp","username":"cloudkibo","credential":"cloudkibo"},
        {"url":"turn:numb.viagenie.ca:3478","username":"support@cloudkibo.com","credential":"cloudkibo"}
        */
        print("rtcICEServerObj is \(rtcICEarray[0])")
        
        //self.createPeerConnectionObject()
        RTCPeerConnectionFactory.initializeSSL()
        rtcFact=RTCPeerConnectionFactory()
        self.rtcLocalMediaStream=self.getLocalMediaStream()
        print("waiting now")
    }
    
    func remoteDisconnected()
    {
        print("inside remote disconnected")
        if((self.rtcVideoTrackReceived) != nil)
        {
            self.rtcVideoTrackReceived.removeRenderer(self.remoteView)
        }
        self.rtcVideoTrackReceived=nil
        if((remoteView) != nil)
        {self.remoteView.renderFrame(nil)}
        print("remote disconnected")
    }
    
    func getLocalMediaStream()->RTCMediaStream!
    {
        print("getlocalmediastream")
        
        self.rtcLocalMediaStream=createLocalMediaStream()
        
        
        //print(rtcLocalMediaStream.audioTracks.count)
        
        // print(rtcLocalMediaStream.videoTracks.count)
        return rtcLocalMediaStream
        
    }
    
    
    func createPeerConnectionObject()
    {//Initialise Peer Connection Object
        print("inside create peer conn object method")
        self.rtcMediaConst=RTCMediaConstraints(mandatoryConstraints: [RTCPair(key: "OfferToReceiveAudio", value: "true"),RTCPair(key: "OfferToReceiveVideo", value: "true")], optionalConstraints: nil)
        //rtcFact=nil
        if(self.pc != nil)
        {
            print("pc closeddddd")
            
            self.pc.close()
            self.pc = nil
        }
        ///////////////////////////
        if(rtcFact == nil)
            
        {RTCPeerConnectionFactory.initializeSSL()
            rtcFact=RTCPeerConnectionFactory()
        }
        ////////////////////////
        self.pc=rtcFact.peerConnectionWithICEServers(rtcICEarray, constraints: self.rtcMediaConst, delegate:self)
        
        //Create Data channel
        CreateAndAttachDataChannel()
    }
    
    
    
    func createLocalMediaStream()->RTCMediaStream
    {print("inside createlocalvideotrack")
        
        var localStream:RTCMediaStream!
        
        localStream=rtcFact.mediaStreamWithLabel("ARDAMS")
        /////////////************^^^
        ///////var localVideoTrack=createLocalVideoTrack()
        
        self.rtcLocalVideoTrack = createLocalVideoTrack()
        if let lvt=self.rtcLocalVideoTrack
        {
            let addedVideo=localStream.addVideoTrack(self.rtcLocalVideoTrack)
            
            print("video stream \(addedVideo)")
            ////++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
            dispatch_async(dispatch_get_main_queue(), {
                //////self.didReceiveLocalVideoTrack(localVideoTrack)
                self.didReceiveLocalVideoTrack(self.rtcLocalVideoTrack)
            })
            
        }
        let audioTrack=rtcFact.audioTrackWithID("ARDAMSa0")
        audioTrack.setEnabled(true)
        let addedAudioStream=localStream.addAudioTrack(audioTrack)
        
        print("audio stream \(addedAudioStream)")
        //localStream.addAudioTrack(mediaAudioLabel!)
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
    
    
    
    
    func didReceiveLocalVideoTrack(localVideoTrack:RTCVideoTrack)
    {
        /////////dispatch_async(dispatch_get_main_queue(), {
        self.rtcLocalVideoTrack=localVideoTrack
        self.rtcLocalVideoTrack.addRenderer(self.localView)
        self.localViewOutlet.addSubview(self.localView)
        
        //////////////////////////
        //self.rtcLocalVideoTrack.addRenderer(self.localView)
        //self.localViewOutlet.addSubview(self.localView)
        
        //self.localViewOutlet.addSubview(self.localView)
        //////////////////////////////////
        self.localViewOutlet.updateConstraintsIfNeeded()
        self.localView.setNeedsDisplay()
        self.localViewOutlet.setNeedsDisplay()
        ///////////////})
    }
    
    
    
    
    func didReceiveLocalStream(stream:RTCMediaStream)
    {
        dispatch_async(dispatch_get_main_queue(), {
            self.localView=RTCEAGLVideoView(frame: CGRect(x: 0 , y: 150, width: 500, height: 350))
            
            self.localView.drawRect(CGRect(x: 0, y: 150, width: 500, height: 350))
            // self.remoteView.addConstraints(mediaConstraints.d)
            if(stream.videoTracks.count>0)
            {print("local video track count is greater than one")
                self.rtcLocalVideoTrack=stream.videoTracks[0] as! RTCVideoTrack
                
                self.rtcLocalVideoTrack.addRenderer(self.localView)
                
                self.localViewOutlet.addSubview(self.localView)
                self.localViewOutlet.updateConstraintsIfNeeded()
                self.localView.setNeedsDisplay()
                self.localViewOutlet.setNeedsDisplay()
            }
        })
    }
    
    
    
    
    func didReceiveRemoteVideoTrack(remoteVideoTrack:RTCVideoTrack)
    {
        print("didreceiveremotevideotrack")
        ////dispatch_async(dispatch_get_main_queue(), {
        
        self.rtcVideoTrackReceived=remoteVideoTrack
        /////////self.remoteView=RTCEAGLVideoView(frame: CGRect(x: 0, y: 0, width: 500, height: 500))
        //////////self.remoteView.drawRect(CGRect(x: 0, y: 0, width: 500, height: 500))
        
        self.rtcVideoTrackReceived.addRenderer(self.remoteView)
        //////////////remoteVideoTrack.addRenderer(self.remoteView)
        self.remoteView.hidden=true // ^^^^newww
        if(self.screenshared==true){
            self.remoteView.hidden=false
        }
        
        self.localViewOutlet.addSubview(self.remoteView)
        
        ///self.localViewOutlet.addSubview(self.remoteView)
        self.localViewOutlet.updateConstraintsIfNeeded()
        //////////self.remoteView.updateConstraintsIfNeeded()
        self.remoteView.setNeedsDisplay()
        self.localViewOutlet.setNeedsDisplay()
        
        /// })
        // }
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    /*override func viewWillAppear(animated: Bool) {
        
        ///////////addHandlers()
        
        if(socketObj.delegateWebRTC == nil)
        {
            socketObj.delegateWebRTC=self
        }
        
        
        //******************************************************************************
        /* self.localViewTop.setSize(CGSize(width: 500, height: 500))*/
        self.localView=RTCEAGLVideoView(frame: CGRect(x: 0, y: 50, width: 500, height: 450))
        self.localView.drawRect(CGRect(x: 0, y: 50, width: 500, height: 450))
        self.remoteView=RTCEAGLVideoView(frame: CGRect(x: 0, y: 50, width: 500, height: 450))
        self.remoteView.drawRect(CGRect(x: 0, y: 50, width: 500, height: 450))
        
        var mainICEServerURL:NSURL=NSURL(fileURLWithPath: Constants.MainUrl)
        
        
        rtcICEarray.append(RTCICEServer(URI: NSURL(string:"turn:45.55.232.65:3478?transport=udp"), username: "cloudkibo", password: "cloudkibo"))
        rtcICEarray.append(RTCICEServer(URI: NSURL(string:"turn:45.55.232.65:3478?transport=tcp"), username: "cloudkibo", password: "cloudkibo"))
        rtcICEarray.append(RTCICEServer(URI: NSURL(string:"stun:stun.l.google.com:19302"), username: "", password: ""))
        rtcICEarray.append(RTCICEServer(URI: NSURL(string:"stun:23.21.150.121"), username: "", password: ""))
        rtcICEarray.append(RTCICEServer(URI: NSURL(string:"stun:stun.anyfirewall.com:3478"), username: "", password: ""))
        rtcICEarray.append(RTCICEServer(URI: NSURL(string:"turn:turn.bistri.com:80?transport=udp"), username: "homeo", password: "homeo"))
        rtcICEarray.append(RTCICEServer(URI: NSURL(string:"turn:turn.bistri.com:80?transport=tcp"), username: "homeo", password: "homeo"))
        rtcICEarray.append(RTCICEServer(URI: NSURL(string:"turn:turn.anyfirewall.com:443?transport=tcp"), username: "webrtc", password: "webrtc"))
        
        /*
        {"url":"stun:turn01.uswest.xirsys.com"},
        {"username":"bcd62532-f1cd-11e5-a87b-5883419cfa3a","url":"turn:turn01.uswest.xirsys.com:443?transport=udp","credential":"bcd625be-f1cd-11e5-b663-8968345edd51"},
        {"username":"bcd62532-f1cd-11e5-a87b-5883419cfa3a","url":"turn:turn01.uswest.xirsys.com:443?transport=tcp","credential":"bcd625be-f1cd-11e5-b663-8968345edd51"},
        {"username":"bcd62532-f1cd-11e5-a87b-5883419cfa3a","url":"turn:turn01.uswest.xirsys.com:5349?transport=udp","credential":"bcd625be-f1cd-11e5-b663-8968345edd51"},
        {"username":"bcd62532-f1cd-11e5-a87b-5883419cfa3a","url":"turn:turn01.uswest.xirsys.com:5349?transport=tcp","credential":"bcd625be-f1cd-11e5-b663-8968345edd51"},
        {"url":"turn:turn.cloudkibo.com:3478?transport=tcp","username":"cloudkibo","credential":"cloudkibo"},
        {"url":"turn:turn.cloudkibo.com:3478?transport=udp","username":"cloudkibo","credential":"cloudkibo"},
        {"url":"turn:numb.viagenie.ca:3478","username":"support@cloudkibo.com","credential":"cloudkibo"}
*/
        print("rtcICEServerObj is \(rtcICEarray[0])")
        
        //self.createPeerConnectionObject()
        RTCPeerConnectionFactory.initializeSSL()
        rtcFact=RTCPeerConnectionFactory()
        self.rtcLocalMediaStream=self.getLocalMediaStream()
        print("waiting now")
        
    }*/*/
    
    func peerConnection(peerConnection: RTCPeerConnection!, addedStream stream: RTCMediaStream!) {
        print("added stream \(stream.debugDescription)")
        print(stream.videoTracks.count)
        print(stream.audioTracks.count)
        
        // dispatch_async(dispatch_get_main_queue(), {
        
        self.rtcStreamReceived=stream
        if(stream.videoTracks.count>0)
        {print("remote video track count is greater than one")
            let remoteVideoTrack=stream.videoTracks[0] as! RTCVideoTrack
            //^^^^^^newwwww self.rtcVideoTrackReceived=stream.videoTracks[0] as! RTCVideoTrack
            dispatch_async(dispatch_get_main_queue(), {
                
                self.didReceiveRemoteVideoTrack(remoteVideoTrack)
            })
            
        }
        
        // })
        
        
    }
    func peerConnection(peerConnection: RTCPeerConnection!, didOpenDataChannel dataChannel: RTCDataChannel!) {
        print(".................. did open data channel")
        print(dataChannel.description)
        
    }
    func peerConnection(peerConnection: RTCPeerConnection!, gotICECandidate candidate: RTCICECandidate!) {
        ////////print("got ice candidate")
        
        //// dispatch_async(dispatch_get_main_queue(), {
        
        ////////print(candidate.description)
        
        var cnd=JSON(["sdpMLineIndex":candidate.sdpMLineIndex,"sdpMid":candidate.sdpMid!,"candidate":candidate.sdp!])
        
        var aa=JSON(["msg":["by":currentID!,"to":otherID,"ice":cnd.object,"type":"ice"]])
        //print(aa.description)
        socketObj.socket.emit("msg",["by":currentID!,"to":otherID,"ice":cnd.object,"type":"ice"])
        
        
        //// })
    }
    func peerConnection(peerConnection: RTCPeerConnection!, iceConnectionChanged newState: RTCICEConnectionState) {
        ////////print("............... ice connection changed new state is \(newState.value.description)")
        
    }
    func peerConnection(peerConnection: RTCPeerConnection!, iceGatheringChanged newState: RTCICEGatheringState) {
        ///////// print("............... ice gathering changed \(newState.value.description)")
    }
    func peerConnection(peerConnection: RTCPeerConnection!, removedStream stream: RTCMediaStream!) {
        print("...............removed stream")
        
    }
    func peerConnection(peerConnection: RTCPeerConnection!, signalingStateChanged stateChanged: RTCSignalingState) {
        //////// print("................signalling state changed")
        ////////print(stateChanged.value)
        
    }
    func peerConnectionOnRenegotiationNeeded(peerConnection: RTCPeerConnection!) {
        ///////////print("............... on negotiation needed")
        
    }
    
    func peerConnection(peerConnection: RTCPeerConnection!, didCreateSessionDescription sdp: RTCSessionDescription!, error: NSError!) {
        print("did create offer/answer session description success")
        //^^^^^^^^^^^^^^^^^^^newwwww
        ////dispatch_async(dispatch_get_main_queue(), {
        
        ///if (error==nil && self.pc.localDescription == nil){
        if (error==nil){
            if(self.screenshared == true)
            {
                print("\(sdp.type) creatddddd")
                print(sdp.debugDescription)
                let sessionDescription=RTCSessionDescription(type: sdp.type!, sdp: sdp.description)
                
                self.pc.setLocalDescriptionWithDelegate(self, sessionDescription: sessionDescription)
                
                print(["by":currentID!,"to":otherID,"sdp":["type":sdp.type!,"sdp":sdp.description],"type":sdp.type!,"username":username!])
                
                socketObj.socket.emit("msg",["by":currentID!,"to":otherID,"sdp":["type":sdp.type!,"sdp":sdp.description],"type":sdp.type!,"username":username!])
                print("\(sdp.type) emitteddd")
            }
            if(self.pc.localDescription == nil){
                print("\(sdp.type) creatddddd")
                print(sdp.debugDescription)
                let sessionDescription=RTCSessionDescription(type: sdp.type!, sdp: sdp.description)
                
                self.pc.setLocalDescriptionWithDelegate(self, sessionDescription: sessionDescription)
                
                ////print(["by":currentID!,"to":otherID,"sdp":["type":sdp.type!,"sdp":sdp.description],"type":sdp.type!,"username":username!])
                
                socketObj.socket.emit("msg",["by":currentID!,"to":otherID,"sdp":["type":sdp.type!,"sdp":sdp.description],"type":sdp.type!,"username":username!])
                print("\(sdp.type) emitteddd")
            }
            
        }
        else
        {
            print("sdp created with error \(error.localizedDescription)")
        }
        
        
        //// })
        
    }
    func peerConnection(peerConnection: RTCPeerConnection!, didSetSessionDescriptionWithError error: NSError!) {
        //print(error.localizedDescription)
        
        // If we are acting as the callee then generate an answer to the offer.
        //^^^^^^^^^^^^^^newwwwwwww
        /////dispatch_async(dispatch_get_main_queue(), {
        
        if error == nil {
            print("did set remote sdp no error")
            
            print("isinitiator is \(isInitiator)")
            if isInitiator == false &&
                self.pc.localDescription == nil {
                    print("creating answer")
                    //^^^^^^^^^ new self.pc.addStream(self.rtcMediaStream)
                    self.pc.createAnswerWithDelegate(self, constraints: self.rtcMediaConst)
            }
            else
            {
                print("local not nil or initiator is true")
                //print(self.pc.localDescription.description)
                
            }
            
        } else {
            print(".......sdp set ERROR: \(error.localizedDescription)", terminator: "")
        }
        ///// })
        
    }
    
    func videoView(videoView: RTCEAGLVideoView!, didChangeVideoSize size: CGSize) {
        
        print("video size has changed")
        
    }
    
    func createOrJoinRoom()
    {
        
    }
    func leaveRoom()
    {
        
    }
    func connectToRoom()
    {
        
    }
    func createOffer()
    {
        
    }
    func socketReceivedMSGWebRTC(message:String,data:AnyObject!)
    {print("socketReceivedMSGWebRTC inside")
        switch(message){
        case "msg":
            handlemsg(data)
            
            
        default:print("wrong socket msg received")
        }
    }
    
    func socketReceivedOtherWebRTC(message:String,data:AnyObject!)
    {
        print("socketReceivedOtherWebRTC inside")
        switch(message){
            
        case "peer.connected":
            handlePeerConnected(data)
            
        case "conference.stream":
            handleConferenceStream(data)
            
        case "peer.disconnected":
            handlePeerDisconnected(data)
            
        case "conference.chat":
            print("\(data)")
            var chat=JSON(data)
            print(JSON(data))
            ///self.delegateChat=WebmeetingChatViewController
            print(chat[0]["message"].description)
            print(chat[0]["username"].description)
            print(chat[0]["message"].string)
            print(chat[0]["username"].string)
            //self.receivedChatMessage(chat[0]["message"].description,username: "\(chat[0]["username"].description)")
            webMeetingModel.addChatMsg(message, usr: username!)
            
        default:print("wrong socket other mesage received")
        }
        
    }
    
    func socketReceivedMessageWebRTC(message:String,data:AnyObject!)
    {print("socketReceivedMessageWebRTC inside")
        switch(message){
            
        case "message":
            handleMessage(data)
            
            
        default:print("wrong socket message received")
            
        }
    }
    
    
    
    func handlemsg(data:AnyObject!)
    {
        print("msg reeived.. check if offer answer or ice")
        var msg=JSON(data)
        print(msg[0].description)
        
        if(msg[0]["type"].string! == "offer")
        {
            //^^^^^^^^^^^^^^^^newwwww if(joinedRoomInCall == "" && isInitiator.description == "false")
            if(joinedRoomInCall == "")
            {
                print("room joined is null")
            }
            
            print("offer received")
            //var sdpNew=msg[0]["sdp"].object
            if(self.pc == nil) //^^^^^^^^^^^^^^^^^^newwwww tryyy
            {
                self.createPeerConnectionObject()
            }
            //^^^^^^^^^^^^^^^^^^ check this for second call already have localstream
            self.CreateAndAttachDataChannel()
            self.addLocalMediaStreamToPeerConnection()
            
            
            //^^^^^^^^^^^^^^^^^^^^^^^newwwwww self.pc.addStream(self.getLocalMediaStream())
            otherID=msg[0]["by"].int!
            currentID=msg[0]["to"].int!
            
            
            if(msg[0]["username"].description != username! && self.pc.remoteDescription == nil){
                var sessionDescription=RTCSessionDescription(type: msg[0]["type"].description, sdp: msg[0]["sdp"]["sdp"].description)
                self.pc.setRemoteDescriptionWithDelegate(self, sessionDescription: sessionDescription)
            }
            
        }
        
        if(msg[0]["type"].string! == "answer" && msg[0]["by"].int != currentID)
        {
            if(self.screenshared==true){
                print("answer received screen")
                var sessionDescription=RTCSessionDescription(type: msg[0]["type"].description, sdp: msg[0]["sdp"]["sdp"].description)
                self.pc.setRemoteDescriptionWithDelegate(self, sessionDescription: sessionDescription)
            }
            
            if(isInitiator.description == "true" && self.pc.remoteDescription == nil)
            {print("answer received")
                var sessionDescription=RTCSessionDescription(type: msg[0]["type"].description, sdp: msg[0]["sdp"]["sdp"].description)
                self.pc.setRemoteDescriptionWithDelegate(self, sessionDescription: sessionDescription)
            }
            
        }
        if(msg[0]["type"].string! == "ice")
        {print("ice received of other peer")
            if(msg[0]["ice"].description=="null")
            {print("last ice as null so ignore")}
            else{
                if(msg[0]["by"].intValue != currentID)
                {var iceCandidate=RTCICECandidate(mid: msg[0]["ice"]["sdpMid"].description, index: msg[0]["ice"]["sdpMLineIndex"].int!, sdp: msg[0]["ice"]["candidate"].description)
                    print(iceCandidate.description)
                    
                    if(self.pc.localDescription != nil && self.pc.remoteDescription != nil)
                        
                    {var addedcandidate=self.pc.addICECandidate(iceCandidate)
                        print("ice candidate added \(addedcandidate)")
                    }
                }
            }
            
        }
        
        
    }
    
    func handlePeerConnected(data:AnyObject!)
    {
        print("received peer.connected obj from server")
        
        //Both joined same room
        
        var datajson=JSON(data!)
        print(datajson.debugDescription)
        
        if(datajson[0]["username"].description != username!){
            otherID=datajson[0]["id"].int
            iamincallWith=datajson[0]["username"].description
            isInitiator=true
            iamincallWith = datajson[0]["username"].description
            
            
            //////optional
            if(self.pc == nil) //^^^^^^^^^^^^^^^^^^newwww tryyy
            {
                self.createPeerConnectionObject()
            }
            self.CreateAndAttachDataChannel()
            self.addLocalMediaStreamToPeerConnection()
            //^^^^^^^^^^^^^^^^^^newwwww self.pc.addStream(self.rtcLocalMediaStream)
            print("peer attached stream")
            
            
            self.pc.createOfferWithDelegate(self, constraints: self.rtcMediaConst!)
        }
        
    }
    
    
    
    func handlePeerDisconnected(data:AnyObject!)
    {
        print("received peer.disconnected obj from server")
        
        //Both joined same room
        
        var datajson=JSON(data!)
        print(datajson.debugDescription)
        
        if(datajson[0]["id"].int == otherID)
        {
            if(self.pc != nil)
            {
                print("peer disconnectedddd received \(datajson[0])")
                
                print("hangupppppp received \(datajson.debugDescription)")
                self.remoteDisconnected()
                
                
                socketObj.socket.emit("leave",["room":joinedRoomInCall])
                self.disconnect()
            }
            
        }
    }
    
    func handleConferenceStream(data:AnyObject!)
    {
        print("received conference.stream obj from server")
        var datajson=JSON(data!)
        print(datajson.debugDescription)
        
        if(datajson[0]["username"].debugDescription != username! && datajson[0]["type"].debugDescription == "screen" && datajson[0]["action"].boolValue==true )
        {self.screenshared=true
            //Handle Screen sharing
            print("handle screen sharing")
            self.pc.createOfferWithDelegate(self, constraints: self.rtcMediaConst)
        }
        
        if(datajson[0]["username"].debugDescription != username! && datajson[0]["type"].debugDescription == "video" && self.rtcVideoTrackReceived != nil)
        {
            print("toggle remote video stream")
            ////////////self.rtcVideoTrackReceived.setEnabled((datajson[0]["action"].bool!))
            if(datajson[0]["action"].bool! == false)
            {
                self.localView.hidden=true
                self.remoteView.hidden=true
            }
            if(datajson[0]["action"].bool! == true)
            {
                self.localView.hidden=true
                self.remoteView.hidden=false
            }
        }
    }
    
    func handleMessage(data:AnyObject!)
    {
        var msg=JSON(data)
        print(msg.debugDescription)
        
        if(msg[0]["type"]=="room_name")
        {
            
            ////////////////////////////////////////////////////////////////
            //////////////^^^^^^^^^^^^^^^^^^^^^^newww isInitiator=false
            //What to do if already in a room??
            
            if(joinedRoomInCall=="")
            {//newwwwwww tryyy isinitiator
                isInitiator = false
                var CurrentRoomName=msg[0]["room"].string!
                print("got room name as \(joinedRoomInCall)")
                print("trying to join room")
                
                socketObj.socket.emitWithAck("init", ["room":CurrentRoomName,"username":username!])(timeoutAfter: 1500000000) {data in
                    print("room joined got ack")
                    var a=JSON(data)
                    print(a.debugDescription)
                    currentID=a[1].int!
                    joinedRoomInCall=msg[0]["room"].string!
                    print("current id is \(currentID)")
                    //}
                }}
                ////////////////////////newwwwwww
            else
            {
                isInitiator = false
            }
            
        }
        if(msg[0]=="Accept Call")
        {var roomname=""
            if(joinedRoomInCall == "")
            {
                print("inside accept call")
                /// roomname="test"
                if(isConference == true)
                {print("conference name is\(ConferenceRoomName)")
                    roomname=ConferenceRoomName
                }
                else{
                    roomname=self.randomStringWithLength(9) as String
                }
                //iamincallWith=username!
                areYouFreeForCall=false
                joinedRoomInCall=roomname as String
                socketObj.socket.emitWithAck("init", ["room":joinedRoomInCall,"username":username!])(timeoutAfter: 150000000) {data in
                    print("room joined by got ack")
                    var a=JSON(data)
                    print(a.debugDescription)
                    currentID=a[1].int!
                    print("current id is \(currentID)")
                    var aa=JSON(["msg":["type":"room_name","room":roomname as String],"room":globalroom,"to":iamincallWith!,"username":username!])
                    print(aa.description)
                    socketObj.socket.emit("message",aa.object)
                    
                }//end data
            }
            
            
        }
        if(msg[0]=="Reject Call")
        {
            
            print("inside reject call")
            var roomname=""
            iamincallWith=""
            areYouFreeForCall=true
            callerName=""
            joinedRoomInCall=""
            if(self.pc != nil)
            {self.pc.close()}
            self.dismissViewControllerAnimated(true, completion: nil)
            
            
        }
        
        
        if(msg[0]=="hangup")
        {
            if(self.pc != nil)
            {
                print("hangupppppp received \(msg[0])")
                
                print("hangupppppp received \(msg.debugDescription)")
                self.remoteDisconnected()
                
                
                socketObj.socket.emit("leave",["room":joinedRoomInCall])
                self.disconnect()
            }
            
        }
        
        if(msg[0]["type"]=="Missed")
        {
            let todoItem = NotificationItem(otherUserName: "\(iamincallWith!)", message: "You have received a missed call", type: "missed call", UUID: "111", deadline: NSDate())
            notificationsMainClass.sharedInstance.addItem(todoItem) // schedule a local notification to persist this item
            
        }
        if(msg[0]=="Conference Call")
        {
            var roomname=""
            if(joinedRoomInCall == "")
            {
                print("inside accept call")
                if(isConference == true)
                {
                    roomname=ConferenceRoomName
                }
                else{
                    roomname=self.randomStringWithLength(9) as String
                }
                //iamincallWith=username!
                areYouFreeForCall=false
                joinedRoomInCall=roomname as String
                socketObj.socket.emitWithAck("init", ["room":joinedRoomInCall,"username":username!])(timeoutAfter: 150000000) {data in
                    print("room joined by got ack")
                    var a=JSON(data)
                    print(a.debugDescription)
                    currentID=a[1].int!
                    print("current id is \(currentID)")
                    var aa=JSON(["msg":["type":"room_name","room":roomname as String],"room":globalroom,"to":iamincallWith!,"username":username!])
                    print(aa.description)
                    socketObj.socket.emit("message",aa.object)
                }}
            
        }
        
        
        
        
        
        
    }
    
    
    func sendDataBuffer(message:String,isb:Bool)
    {
        //var my="{\"eventName\":\"data_msg\",\"data\":{\"file_meta\":{}}}"
        //let buffer2 = RTCDataBuffer(
        //data: (my.dataUsingEncoding(NSUTF8StringEncoding))!,
        //isBinary: false
        // )
        //var sent=self.rtcDataChannel.sendData(buffer2)
        // print("datachannel file sample METADATA sent is \(sent)")
        
        
        let buffer = RTCDataBuffer(
            data: (message.dataUsingEncoding(NSUTF8StringEncoding))!,
            isBinary: isb
        )
        var sentFile=self.rtcDataChannel.sendData(buffer)
        print("datachannel file METADATA sent is \(sentFile) OR image chunk size is sent \(sentFile)")
        
        
        /*var senttt=rtcDataChannel.sendData(RTCDataBuffer(data: NSData(base64EncodedString: "{helloooo iphone sendind data through data channel}", options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters),isBinary: true))
        print("datachannel message sent is \(senttt)")*/
        /*var test="{hellooo}"
        let buffer = RTCDataBuffer(
        data: (test.dataUsingEncoding(NSUTF8StringEncoding))!,
        isBinary: false
        )
        
        let result = self.rtcDataChannel!.sendData(buffer)
        print("datachannel message sent is \(result)")
        */
        
    }


    func channel(channel: RTCDataChannel!, didChangeBufferedAmount amount: UInt) {
        print("didChangeBufferedAmount \(amount)")
        
    }
    
    
    
    func channel(channel: RTCDataChannel!, didReceiveMessageWithBuffer buffer: RTCDataBuffer!) {
        print("didReceiveMessageWithBuffer")
        print(buffer.data.debugDescription)
        //var channelJSON=JSON(buffer.data!)
        //print(channelJSON.debugDescription)
        
        //----------------------
        //-----------------------
        var new:String!
        //////buffer.data.length// make array of this size
        print("didReceiveMessageWithBuffer")
        //print(buffer.data.debugDescription)
        var channelJSON=JSON(buffer.data!)
        print(channelJSON.debugDescription)
        //var bytes:[UInt8]
        var bytes=Array<UInt8>(count: buffer.data.length, repeatedValue: 0)
        
        // bytes.append(buffer.data.bytes)
        buffer.data.getBytes(&bytes, length: buffer.data.length)
        print(bytes.debugDescription)
        
        NSUTF8StringEncoding
        
        
        var sssss=NSString(bytes: &bytes, length: buffer.data.length, encoding: NSUTF8StringEncoding)
        sssss=sssss?.stringByReplacingOccurrencesOfString("\\", withString: "")
        print(sssss?.description)
        
        
        
        //JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&e];
        
        
        //buffer.data.
        var tryyyyy=NSData(bytes: &bytes , length: buffer.data.length)
        var mytryyJSON=JSON(tryyyyy)
        
        if(sssss != nil){
            
            var jjj:NSData = (sssss?.dataUsingEncoding(NSUTF8StringEncoding))!
            
            do
            {jsonnnn = try NSJSONSerialization.JSONObjectWithData(jjj, options: NSJSONReadingOptions.MutableContainers) as! Dictionary<String, AnyObject>
                print("jsonnn")
                print(jsonnnn)
            }catch
            {print("hi")
                // print(jsonnnn)
            }
            
            
            myJSONdata=JSON(sssss!)
            print("myjsondata is \(myJSONdata)")
            var oldjsombrackets=myJSONdata.description.stringByReplacingOccurrencesOfString("{", withString: "[")
            new=oldjsombrackets.stringByReplacingOccurrencesOfString("}", withString: "]")
            print("new is \(new)")
            
            newjson=JSON(rawValue: new)!
            print("new json is \(newjson)")
            /////  var dddd:[String:AnyObject]=newjson.debugDescription as! [String:AnyObject]
            //////print("ddddddddd is \(dddd)")
            
            let count = buffer.data.length
            var doubles: [Double] = []
            ///let data = NSData(bytes: doubles, length: count)
            var result = [UInt8](count: count, repeatedValue: 0)
            buffer.data.getBytes(&result, length: count)
            //////   print(result.debugDescription)
            
            strData=String(bytes)
            print("strdata")
            print(strData)
            var jsonStrData=JSON(strData)
            print("jsonStrData")
            print(jsonStrData.debugDescription)
        }
        else
        {
            print("sssss is nil and binary is\(buffer.isBinary)")
            
            
        }
        // }
        
        if(!buffer.isBinary)
        {
            print("not binary")
            if(strData=="Speaking")
            {
                print("speakingggggg")
            }
            if(strData=="Silent")
            {
                print("Silentttt")
            }
            // if(jsonStrData["data"].count > 0)
            //{
            //////print("json data found")
            ////print(jsonStrData["data"].debugDescription)
            /*var resjson=jsonStrData["data"] as! [AnyObject]
            for item in resjson{
            if((item["chunk"]) != nil)
            {
            print("got key chain")
            }
            }*/
            print("newjson[data][chunk.debugDescription is:")
            print("newjson[data][chunk].debugDescription")
            print(myJSONdata)
            print(myJSONdata["data"].isExists())
            if(myJSONdata != "Speaking" && myJSONdata != "Silent" && !jsonnnn.isEmpty){
                print("inside 1")
                print(jsonnnn["eventName"]!)
                //if (myJSONdata["data"]["file_meta"].isExists())
                if(jsonnnn["eventName"]!.debugDescription == "data_msg")
                    //&& myJSONdata["data"]["file_meta"].debugDescription != "null")
                {   print("myjsondata....")
                    print(myJSONdata["data"]["file_meta"])
                    print("jsonnnn.valueForKey.......")
                    print(jsonnnn["eventName"])
                    print(jsonnnn["data"]!["file_meta"]!!["size"]!)
                    
                    print("file received \(myJSONdata["data"]["file_meta"].isExists())")
                    
                    var sizeee=Int.init((jsonnnn["data"]!["file_meta"]!!["size"]!?.debugDescription)!)
                    fileSizeReceived=sizeee
                    fid=Int.init((jsonnnn["data"]!["file_meta"]!!["fid"]!?.debugDescription)!)
                    print("fid is \(fid)")
                    
                    //////////filePathReceived=channelJSON["data"]["file_meta"]["name"].debugDescription
                    filePathReceived=jsonnnn["data"]!["file_meta"]!!["name"]!!.debugDescription
                    ////fileSizeReceived=jsonnnn["data"]!["file_meta"]!!["size"]!! as! Int
                    print("file sizeeee jsonnnn is \(channelJSON["data"]["file_meta"]["size"].debugDescription)")
                    
                    print("file sizeeee channelJSON is \(jsonnnn["data"]!["file_meta"]!!["size"].debugDescription)")
                    print("file sizeeee sizeee is \(sizeee)")
                    /////////////fileSizeReceived = channelJSON["data"]["file_meta"]["size"].intValue
                    
                    ///fileSizeReceived=myJSONdata["data"]["file_meta"]["size"].intValue
                    
                    
                    
                    ///NEW ADDITION MAKE FILENAME GLOBAL
                    filejustreceivedname=filePathReceived!
                    /////////
                    var x=Double(fileSizeReceived / fu.chunkSize)
                    numberOfChunksInFileToSave = ceil(x)
                    print("number of chunks to save in received file are \(numberOfChunksInFileToSave)")
                    numberOfChunksReceived=0
                    chunknumbertorequest=0
                    if(fu.isFreeSpacAvailable(fileSizeReceived))
                    {
                        print("requesting chunk now")
                        //requestchunk(chunknumbertorequest)
                        
                        var mjson="{\"chunk\":\(chunknumbertorequest),\"browser\":\"firefox\",\"fid\":\(fid!),\"requesterid\":\(currentID!)}"
                        var fmetadata="{\"eventName\":\"request_chunk\",\"data\":\(mjson)}"
                        self.sendDataBuffer(fmetadata,isb: false)
                        
                        
                    }
                    else
                    {
                        print("need more space")
                    }
                    //UPDATE FILE UI..........................................receivedfileoffer
                    
                    
                    /*
                    public void onClick(DialogInterface dialog, int whichButton) {
                    onStatusChanged("Receiving file...");
                    if (Utility.isFreeSpaceAvailableForFileSize(sizeOfFileToSave)) {
                    Log.w("FILE_TRANSFER", "Free space is available for file save, requesting chunk now");
                    fileTransferService.requestChunk();
                    } else {
                    Log.w("FILE_TRANSFER", "Need more space to save this file");
                    onStatusChanged("Need more free space to save this file");
                    }
                    }*/
                    
                    
                    //var fileSizeReceived:Int!
                    //var fileContentsReceived:NSData!
                    /*
                    fileNameToSave = jsonData.getJSONObject("data").getJSONObject("file_meta").getString("name");
                    sizeOfFileToSave = jsonData.getJSONObject("data").getJSONObject("file_meta").getInt("size");
                    numberOfChunksInFileToSave = (int) Math.ceil(sizeOfFileToSave / Utility.getChunkSize());
                    numberOfChunksReceived = 0;
                    chunkNumberToRequest = 0;
                    fileBytesArray = new ArrayList<Byte>();
                    
                    mListener.receivedFileOffer(fileNameToSave + " : " + FileUtils.getReadableFileSize(sizeOfFileToSave), sizeOfFileToSave);
                    */
                    
                    ///var ccccc:Int
                    ////ccccc=0
                    
                    
                    /*
                    request_chunk.put("eventName", "request_chunk");
                    JSONObject request_data = new JSONObject();
                    request_data.put("chunk", chunkNumberToRequest);
                    request_data.put("browser", "firefox"); // This firefox is hardcoded for testing purpose
                    request_chunk.put("data", request_data);
                    */
                    
                }
                else
                {
                    print("inside 2")
                    print(jsonnnn["eventName"]!)
                    //if (myJSONdata["data"]["chunk"].isExists() && myJSONdata["data"]["chunk"].debugDescription != "" )
                    if(jsonnnn["eventName"]!.debugDescription == "request_chunk")
                    {
                        print("chunk number is \(myJSONdata["data"]["chunk"].rawValue)")
                        print(channelJSON["data"][0]["browser"].debugDescription)
                        print(channelJSON["data"][0]["chunk"].intValue)
                        chunknumber=myJSONdata["data"][0]["chunk"].intValue
                        
                        ////////FU utility
                        if(chunknumber % fu.chunks_per_ack == 0)
                        {
                            for(var i=0;i<fu.chunks_per_ack;i++)
                            {
                                if(fileSize < fu.chunkSize)
                                {
                                    var bytebuffer=fu.convert_file_to_byteArray(filePathImage)
                                    var byteToNSstring=NSString(bytes: &bytebuffer, length: bytebuffer.count, encoding: NSUTF8StringEncoding)
                                    var bytestringfile=NSData(contentsOfFile: byteToNSstring as! String)
                                    print("file size smaller than chunk")
                                    if(bytestringfile==nil)
                                    {
                                        bytestringfile=NSData(contentsOfURL: urlLocalFile)
                                    }
                                    var check=self.rtcDataChannel.sendData(RTCDataBuffer(data: bytestringfile,isBinary: true))
                                    print("chunk has been sent \(check)")
                                    break
                                    
                                }
                                print("file size is \(fileSize)")
                                var x=CGFloat(fileContents.length/fu.chunkSize)
                                if(CGFloat(chunknumber+i) >= ceil(x))
                                {
                                    print("file size came in math ceiling condition")
                                }
                                var upperlimit=(chunknumber+i+1)*fu.chunkSize
                                if(upperlimit > fileContents.length)
                                {
                                    upperlimit = fileContents.length-1
                                }
                                var lowerlimit=(chunknumber+i)*fu.chunkSize
                                print("lowerlimit \(lowerlimit) upper limit \(upperlimit)")
                                if(lowerlimit > upperlimit)
                                {break}
                                
                                var bytestringfile=NSFileManager.defaultManager().contentsAtPath(filePathImage)
                                if(bytestringfile==nil)
                                {
                                    bytestringfile=NSData(contentsOfURL: urlLocalFile)
                                }
                                /// var bytestringfile=NSData(contentsOfFile: bytebuffer)
                                var newbuffer=Array<UInt8>(count: upperlimit-lowerlimit, repeatedValue: 0)
                                bytestringfile?.getBytes(&newbuffer, range: NSRange(location: lowerlimit,length: upperlimit-lowerlimit))
                                self.rtcDataChannel.sendData(RTCDataBuffer(data: bytestringfile,isBinary: true))
                                print("chunk has been sent")
                                
                            }
                        }
                        //requestchunk(chunknumber)
                        
                    }//if data chunk exists
                    
                }//end else
                
            }//if speaking!=nil
            
            
        }
            
        else
        {
            print("yes binary")
            
            for eachbyte in bytes
            {
                bytesarraytowrite.append(eachbyte)
            }
            
            var modanswer=numberOfChunksReceived % fu.chunks_per_ack
            if(modanswer==(fu.chunks_per_ack-1) || numberOfChunksInFileToSave == (Double(numberOfChunksReceived+1)))
            {
                
                
                if(numberOfChunksInFileToSave > Double(numberOfChunksReceived))
                {
                    chunknumbertorequest += fu.chunks_per_ack
                    print("asking other chunk..")
                    //requestchunk(chunknumbertorequest)
                    
                    var mjson="{\"chunk\":\(chunknumbertorequest),\"browser\":\"firefox\",\"fid\":\(fid) ,\"requesterid\":\(currentID!)}"
                    var fmetadata="{\"eventName\":\"request_chunk\",\"data\":\(mjson)}"
                    self.sendDataBuffer(fmetadata,isb: false)
                }
            }
            else{
                if(numberOfChunksInFileToSave == Double(numberOfChunksReceived))
                {
                    print("file transfer completed..")
                    //////bytesarraytowrite=Array<UInt8>()
                }
            }
            numberOfChunksReceived++
            /*
            if(buffer.binary){
            
            String strData = new String( bytes );
            Log.w("FILE_TRANSFER", strData);
            
            for(int i=0; i<bytes.length; i++)
            fileBytesArray.add(bytes[i]);
            
            if (numberOfChunksReceived % Utility.getChunksPerACK() == (Utility.getChunksPerACK() - 1)
            || numberOfChunksInFileToSave == (numberOfChunksReceived + 1)) {
            if (numberOfChunksInFileToSave > numberOfChunksReceived) {
            chunkNumberToRequest += Utility.getChunksPerACK();
            Log.w("FILETRANSFER", "Asking other chunk");
            requestChunk();
            }
            } else {
            if (numberOfChunksInFileToSave == numberOfChunksReceived) {
            Log.w("FILETRANSFER", "File transfer completed");
            mListener.fileTransferCompleteNotification(fileNameToSave + " : " +
            FileUtils.getReadableFileSize(sizeOfFileToSave), fileBytesArray, fileNameToSave);
            }
            }
            
            numberOfChunksReceived++;s
            */
            
            
            
            /* let writeString = "Hello, world!"
            
            let filePath = NSHomeDirectory() + "/Library/Caches/test.txt"
            
            do {
            _ = try writeString.writeToFile(filePath, atomically: true, encoding: NSUTF8StringEncoding)
            } catch let error as NSError {
            print(error.description)
            }
            
            */
            //let fm = NSFileManager.defaultManager()
            let dirPaths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
            let docsDir1 = dirPaths[0]
            var documentDir=docsDir1 as NSString
            var filePathImage2=documentDir.stringByAppendingPathComponent(filejustreceivedname!)
            filejustreceivedPathURL=NSURL(fileURLWithPath: filePathImage2)
            print("filejustreceivedPathURL is \(filejustreceivedPathURL)")
            var fm=NSFileManager.defaultManager()
            
            
            //////////^^^^^^^newww tryy var filedata:NSData=fu.convert_byteArray_to_fileNSData(bytes)
            var filedata:NSData=fu.convert_byteArray_to_fileNSData(bytesarraytowrite)
            
            var s=fm.createFileAtPath(filePathImage2, contents: nil, attributes: nil)
            
            var written=filedata.writeToFile(filePathImage2, atomically: true)
            
            if(written==true)
            {
                var furl2=NSURL(fileURLWithPath: filePathImage2)
                print("local furl2 is\(furl2)")
                
                //documentInteractionController = UIDocumentInteractionController(URL: fileURL)
                //documentInteractionController.delegate=self
                //documentInteractionController.presentOpenInMenuFromRect(CGRect(x: 20, y: 100, width: 300, height: 200), inView: self.view, animated: true)
                
                
                
                
                /* var fileManager=NSFileManager.defaultManager()
                var e:NSError!
                print("saving to iCloud")
                //dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0), { () -> Void in
                var dest=fileManager.URLForUbiquityContainerIdentifier(nil)
                print("desi is \(dest)")
                if(fileManager.fileExistsAtPath((dest?.URLByAppendingPathComponent("Documents").URLString)!))
                {
                print("yess file directory dest document existss")
                }
                //?.URLByAppendingPathComponent("Documents")
                
                do
                {
                //var newdest=dest!.URLByAppendingPathComponent("Documents", isDirectory: true)
                //print("newdest is \(newdest.debugDescription)")
                //var ans=try fileManager.setUbiquitous(true, itemAtURL: self.fileURL, destinationURL: newdest)
                var ans=try fileManager.setUbiquitous(true, itemAtURL: furl2, destinationURL: dest!.URLByAppendingPathComponent("myfile.doc"))
                
                print("ans is \(ans)")
                
                }catch
                {
                print("error is \(error)")
                }
                */
                
                
                // })
                
                
                
                
                btnViewFile.enabled=true
                print("file writtennnnn \(s) \(filedata.debugDescription)")
            }
            /*var receivedfile=fm.contentsAtPath(filePathImage2)
            do{var receivedfile2=try NSString(contentsOfFile: filePathImage2, encoding: NSUTF8StringEncoding)
            print("file output is ")
            print(receivedfile2)
            
            }catch let error as NSError
            {
            print(error)
            }
            catch
            {
            
            }*/
            
            /*
            //to convert NSData to pdf
            NSData *data     = [NSData dataWithBytes:(void)wdslBytes length:sizeOf(wdslBytes)];
            CFDataRef myPDFData  = (CFDataRef)data;
            CGDataProviderRef provider = CGDataProviderCreateWithCFData(myPDFData);
            CGPDFDocumentRef pdf   = CGPDFDocumentCreateWithProvider(provider);
            */
            
            // var bytesreceived=Array<UInt8>(count: fileSizereceived, repeatedValue: 0)
            
            // bytes.append(buffer.data.bytes)
            //buffer.data.getBytes(&bytesreceived, length: buffer.data.length)
            // print(bytes.debugDescription)
            ///////// var sssss=NSString(bytes: &bytes, length: buffer.data.length, encoding: NSUTF8StringEncoding)
            /*
            let writeString = "Hello, world!"
            
            let filePath = NSHomeDirectory() + "/Library/Caches/test.txt"
            
            do {
            _ = try writeString.writeToFile(filePath, atomically: true, encoding: NSUTF8StringEncoding)
            } catch let error as NSError {
            print(error.description)
            }
            */
        }

        
        
        //-----------------------
        //----------------------
        
        
        
        
    }
    func channelDidChangeState(channel: RTCDataChannel!) {
        print("channelDidChangeState")
        print(channel.debugDescription)
        
    }
    
    @IBAction func btnFilePressed(sender: AnyObject) {
        
        print(NSOpenStepRootDirectory())
        ///var UTIs=UTTypeCopyPreferredTagWithClass("public.image", kUTTypeImage)?.takeRetainedValue() as! [String]
        
        let importMenu = UIDocumentMenuViewController(documentTypes: [kUTTypeText as NSString as String],
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
            
            self.fileSize=fileSizeNumber.integerValue
            
            //FILE METADATA size
            print(self.fileSize)
            urlLocalFile=url
            /////let text2 = fm.contentsAtPath(filePath)
            ////////print(text2)
            /////////print(JSON(text2!))
            ///mdata.fileContents=fm.contentsAtPath(filePathImage)!
            self.fileContents=NSData(contentsOfURL: url)
            self.filePathImage=url.URLString
            var filecontentsJSON=JSON(NSData(contentsOfURL: url)!)
            print(filecontentsJSON)
            var mjson="{\"file_meta\":{\"name\":\"\(fname!)\",\"size\":\"\(self.fileSize.description)\",\"filetype\":\"\(ftype)\",\"browser\":\"firefox\",\"uname\":\"\(username!)\",\"fid\":\(self.myfid),\"senderid\":\(currentID!)}}"
            var fmetadata="{\"eventName\":\"data_msg\",\"data\":\(mjson)}"
            self.sendDataBuffer(fmetadata,isb: false)
            socketObj.socket.emit("conference.chat", ["message":"You have received a file. Download and Save it.","username":username!])
            
            
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

    
}