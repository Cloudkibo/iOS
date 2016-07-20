//
//  FileTransferWebRTCclient.swift
//  kiboApp
//
//  Created by Cloudkibo on 19/07/2016.
//  Copyright © 2016 MyAppTemplates. All rights reserved.
//


/*
import Foundation
import UIKit
import AVFoundation
import Foundation
import SwiftyJSON
import MobileCoreServices

class FileTransferWebRTCclient:NSObject,RTCPeerConnectionDelegate,RTCSessionDescriptionDelegate,SocketClientDelegateWebRTC,RTCDataChannelDelegate,UIDocumentPickerDelegate,UIDocumentMenuDelegate{

public var delegateFileReceived:FileReceivedAlertDelegate!

@IBOutlet var btnShareFile: UIBarButtonItem!

var fileTransferCompleted=false
@IBOutlet weak var btnAudio: UIButton!
@IBOutlet weak var btnVideo: UIButton!
@IBOutlet weak var btnEndCall: UIButton!

@IBOutlet weak var txtLabelUsername: UILabel!
@IBOutlet weak var txtLabelMainPage: UITextView!
var fileSize1:UInt64=0
public var delegateSendScreenDatachannel:DelegateSendScreenshotDelegate!
//////var screenCaptureToggle=false
var newjson:JSON!
var myJSONdata:JSON!
var chunknumber:Int!
var strData:String!


var localFull:RTCEAGLVideoView!

@IBOutlet weak var btnViewFile: UIBarButtonItem!
var myfid=0
var fid:Int!=0
var bytesarraytowrite:Array<UInt8>!
var jsonnnn:Dictionary<String, AnyObject>!
var numberOfChunksReceived:Int=0
var fu=FileUtility()
var filePathImage:String!
////** new commented april 2016var fileSize:Int!
var fileContents:NSData!
var chunknumbertorequest:Int=0
var numberOfChunksInFileToSave:Double=0
var filePathReceived:String!
var fileSizeReceived:Int!
var fileContentsReceived:NSData!

@IBOutlet var btncapture: UIBarButtonItem!
//------
var localvideoshared=false
var remotevideoshared=false
var screenshared=false
var delegate:SocketClientDelegateWebRTC!
@IBOutlet var localViewOutlet: UIView!
var localView:RTCEAGLVideoView! = nil
var remoteView:RTCEAGLVideoView! = nil
var remoteScreenView:RTCEAGLVideoView! = nil
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
var rtcScreenTrackReceived:RTCVideoTrack! = nil
//var currentId:String!

var by:Int!
var rtcStreamReceived:RTCMediaStream! = nil
weak var rtcVideoTrackReceived:RTCVideoTrack! = nil
var rtcAudioTrackReceived:RTCAudioTrack! = nil
// var rtcCaptureSession:AVCaptureSession!
var rtcDataChannel:RTCDataChannel! = nil
var countTimer=1




/*
@IBAction func btnCapturePressed(sender: UIBarButtonItem) {
    
    
    screenCaptureToggle = !screenCaptureToggle
    //////// mdata.toggleScreen(screenAction, tempstream: <#T##RTCMediaStream!#>)
    
    if(screenCaptureToggle)
    {
        // socketObj.socket.emit("conference.stream", ["username":username!,"id":currentID!,"type":"screenAndroid","action":"true"])
        
        socketObj.socket.emit("conference.stream", ["username":username!,"id":currentID!,"type":"screenAndroid","action":"true"])
        
        
        btncapture.title! = "Hide"
        webMeetingModel.delegateScreen.screenCapture()
        /////atimer=NSTimer(timeInterval: 0.1, target: self, selector: "timerFiredScreenCapture", userInfo: nil, repeats: true)
        
    }
    else
    {
        btncapture.title! = "Capture"
        
        //socketObj.socket.emit("conference.stream", ["username":username!,"id":currentID!,"type":"screenAndroid","action":"false"])
        
        socketObj.socket.emit("conference.stream", ["username":username!,"id":currentID!,"type":"screenAndroid","action":"false"])
        
        webMeetingModel.delegateScreen.screenCapture()
        
        //atimer=NSTimer(timeInterval: 0.1, target: self, selector: "timerFiredScreenCapture", userInfo: nil, repeats: true)
        
        
        
    }
    
    /* dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)) { () -> Void in
     while(screenCaptureToggle)
     //for(var i=0;i<30000;i++)
     {
     atimer.fire()
     sleep(1)
     }
     
     }*/
    
    
}
*/
func sendImageFromDataChannel(screenshot: UIImage!) {
    var chunkLength=64000
    var imageData:NSData = UIImageJPEGRepresentation(screenshot, 1.0)!
    var numchunks=0
    var len=imageData.length
    print("length is\(len)")
    numchunks=len/chunkLength
    print("numchunks are \(numchunks)")
    
    var test="\(imageData.length)"
    
    self.sendDataBuffer(test, isb: false)
    
    for(var j=0;j<numchunks;j++)
    {
        var start=j*chunkLength
        var end=(j+1)*chunkLength
        self.sendImage(imageData.subdataWithRange(NSMakeRange(start,len-start)))
        
    }
    if((len%chunkLength) > 0)
    {
        //imageData.getBytes(&imageData, length: numchunks*chunkLength)
        self.sendImage(imageData.subdataWithRange(NSMakeRange(numchunks*chunkLength, len%chunkLength)))
        
    }
    
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

/*func addLocalMediaStreamToPeerConnection()
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
*/
func CreateAndAttachDataChannel()
{///tyrrr new april 2016
    if(rtcDataChannel == nil)
    {
        print("\(username) is creating and attaching data channel")
        socketObj.socket.emit("logClient","\(username) is creating and attaching data channel")
        var rtcInit=RTCDataChannelInit.init()
        // rtcInit.isNegotiated=true
        //rtcInit.isOrdered=true
        // rtcInit.maxRetransmits=30
        
        rtcDataChannel=pc.createDataChannelWithLabel("channel", config: rtcInit)
        if(rtcDataChannel != nil)
        {
            socketObj.socket.emit("logClient","\(username!) data channel not nil")
            print("datachannel not nil")
            rtcDataChannel.delegate=self
            
            //////// var senttt=rtcDataChannel.sendData(RTCDataBuffer(data: NSData(base64EncodedString: "helloooo iphone sendind data through data channel", options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters),isBinary: true))
            /// print("datachannel message sent is \(senttt)")
            ///var test="hellooo"
            
        }
    }
}

@IBAction func endCallBtnPressed(sender: AnyObject) {
    webMeetingModel.messages.removeAllObjects()
    
    //  if(meetingStarted==true && self.pc != nil)
    // {
    self.endMeeting()
    // }
    /*else{
     var aa=JSON(["to":iamincallWith!,"msg":["callerphone":username!,"calleephone":iamincallWith!,"status":"missing","type":"call"]])
     
     joinedRoomInCall=""
     ConferenceRoomName=""
     areYouFreeForCall=true
     iOSstartedCall=false
     
     
     self.rtcLocalMediaStream=nil
     //print(aa.description)
     socketObj.socket.emit("logClient","IPHONE-LOG: \(aa.object)")
     socketObj.socket.emit("message",aa.object)
     self.localView.renderFrame(nil)
     //self.remoteView.renderFrame(nil)
     self.localFull.renderFrame(nil)
     if((self.rtcLocalVideoTrack) != nil)
     {print("remove localtrack renderer")
     
     self.rtcLocalVideoTrack.removeRenderer(self.localView)
     //////////////////////////////////////////////////////
     self.rtcLocalVideoTrack=nil
     self.localView.removeFromSuperview()
     /////////////////////////////////////////////////////
     }
     
     dispatch_async(dispatch_get_main_queue(), { () -> Void in
     //%%%%%%%% let next = self.storyboard!.instantiateViewControllerWithIdentifier("mainpage") as! LoginViewController
     
     
     //MainChatView
     
     print("views removed from parent")
     
     self.dismissViewControllerAnimated(false, completion: { () -> Void in
     
     
     })})
     
     
     }
     
     */
    /*
     if(isConference != true)
     {print("ending meeting 1-1 call")
     meetingStarted=false
     isConference=false
     iOSstartedCall=false
     ConferenceRoomName=""
     // ********$$$$$$$$$$$$$$$$$$$$$$
     if(self.pc != nil)
     {
     socketObj.socket.emit("logClient","IPHONE-LOG: \(iamincallWith) is disconnecting from call")
     
     
     print("hangupppppp emitteddd")
     self.remoteDisconnected()
     
     //socketObj.socket.emit("message",["msg":"hangup","room":globalroom,"to":iamincallWith!,"username":username!, "id":currentID!])
     
     //%%%%%%%% new
     /*
     socketObj.socket.emit("message",["msg":"hangup","room":globalroom,"to":iamincallWith!,"username":username!, "id":currentID!])
     socketObj.socket.emit("leave",["room":joinedRoomInCall])
     socketObj.socket.emit("leave",["room":joinedRoomInCall])
     */
     
     //%%%%%%%%%%% self.disconnect()
     }
     socketObj.socket.disconnect()
     socketObj.socket.connect()
     self.disconnect()
     
     
     }
     else
     { if(iamincallWith != nil)
     {print("ending meeting")
     meetingStarted=false
     //// socketObj.socket.disconnect()
     if(currentID != nil){
     //socketObj.socket.emit("peer.disconnected", ["username":username!,"id":currentID!,"room":ConferenceRoomName])
     socketObj.socket.emit("peer.disconnected", ["username":username!,"id":currentID!,"room":ConferenceRoomName])
     
     
     //socketObj.socket.emit("message",["msg":"hangup","room":globalroom,"to":iamincallWith!,"username":username!, "id":currentID!])
     
     socketObj.socket.emit("message",["msg":"hangup","room":globalroom,"to":iamincallWith!,"username":username!, "id":currentID!])
     
     socketObj.socket.emit("leave",["room":joinedRoomInCall,"id":currentID!])
     }
     }
     
     socketObj.socket.disconnect()
     socketObj=nil
     
     //self.pc=nil
     joinedRoomInCall=""
     //iamincallWith=nil
     isInitiator=false
     //rtcFact=nil
     areYouFreeForCall=true
     currentID=nil
     otherID=nil
     self.rtcLocalMediaStream=nil
     self.rtcStreamReceived=nil
     //self.pc.close()
     
     //self.pc=nil
     //rtcFact=nil //**********important********
     //iamincallWith=nil
     self.localView.renderFrame(nil)
     self.remoteView.renderFrame(nil)
     
     if((self.rtcDataChannel) != nil){
     self.rtcDataChannel.close()
     self.rtcDataChannel=nil
     //newwwwwwww tryy
     //rtcDataChannel.close()
     }
     
     
     //^^^^^^^^^^^newwwww self.disconnect()
     //if((self.pc) != nil)
     //{
     
     
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
     ConferenceRoomName=""
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
     
     if(self.localView.superview != nil)
     {
     print("localview was a subview. remmoving")
     self.localView.removeFromSuperview()
     }
     if(self.remoteView.superview != nil)
     {
     print("remoteview was a subview. remmoving")
     
     self.remoteView.removeFromSuperview()
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
     self.rtcStreamReceived.removeAudioTrack(self.rtcStreamReceived.audioTracks[0] as! RTCAudioTrack)
     /////rtcStreamReceived.videoTracks[0].stopRunning()
     //rtcStreamReceived.audioTracks[0].stopRunning()
     }
     
     print("views removed from parent")
     /// **** neww may 2016}
     
     joinedRoomInCall=""
     iamincallWith=""
     isInitiator=false
     areYouFreeForCall=true
     
     self.rtcLocalMediaStream=nil //test and try-------------
     self.rtcStreamReceived=nil
     screenCaptureToggle=false
     ConferenceRoomName=""
     
     socketObj.socket.emit("logClient","IPHONE-LOG: \(username!) pressed end call. going back to contacts list")
     dispatch_async(dispatch_get_main_queue(), { () -> Void in
     //%%%%%%%% let next = self.storyboard!.instantiateViewControllerWithIdentifier("mainpage") as! LoginViewController
     
     let next = self.storyboard!.instantiateViewControllerWithIdentifier("MainChatView") as! ChatViewController
     //MainChatView
     self.presentViewController(next, animated: false, completion: { () -> Void in
     print("nexttttt viewwww")
     
     })//end present controller
     
     })//end dispatch_async
     
     
     
     
     
     }//end else
     
     */ */
    
    
    
}

/*
@IBAction func toggleVideoBtnPressed(sender: AnyObject) {
    videoAction = !videoAction.boolValue
    localvideoshared=videoAction.boolValue
    var w=localViewOutlet.bounds.width-(localViewOutlet.bounds.width*0.23)
    var h=localViewOutlet.bounds.height-(localViewOutlet.bounds.height*0.27)
    if(localvideoshared==false)
    {socketObj.socket.emit("logClient","IPHONE-LOG: \(username!) is sharing video")
        localFull.hidden=true
        localView.hidden=true
        btnVideo.setImage(UIImage(named: "video_off"), forState: .Normal)
    }
    else{
        socketObj.socket.emit("logClient","IPHONE-LOG: \(username!) is hiding video")
        btnVideo.setImage(UIImage(named: "video_on"), forState: .Normal)
        if(remotevideoshared==true){
            //////self.rtcLocalVideoTrack.removeRenderer(self.localFull)
            self.rtcLocalVideoTrack.addRenderer(self.localView)
            self.localViewOutlet.addSubview(self.localView)
            
            self.localViewOutlet.updateConstraintsIfNeeded()
            localFull.setNeedsDisplay()
            self.localView.setNeedsDisplay()
            self.localViewOutlet.setNeedsDisplay()
            
            
            localFull.hidden=true
            localView.hidden=false}
        else{
            /////self.rtcLocalVideoTrack.removeRenderer(self.localView)
            localFull.hidden=false
            localView.hidden=true
        }
    }
    if(socketObj != nil){
        //socketObj.socket.emit("conference.stream", ["username":username!,"id":currentID!,"type":"video","action":videoAction.boolValue])
        
        socketObj.socket.emit("conference.stream", ["username":username!,"id":currentID!,"type":"video","action":videoAction.boolValue])
        
    }
    /* if(remotevideoshared==true && localvideoshared==true)
     {
     print("yesss sharedd")
     dispatch_async(dispatch_get_main_queue(), {
     //self.rtcLocalVideoTrack.removeRenderer(self.localView)
     
     self.localView=RTCEAGLVideoView(frame: CGRect(x: w, y: h, width: 90, height: 85))
     self.localView.drawRect(CGRect(x: w, y: h, width: 90, height: 85))
     
     // self.remoteView.addConstraints(mediaConstraints.d)
     
     //self.rtcLocalVideoTrack.addRenderer(self.localView)
     
     ///self.localViewOutlet.addSubview(self.localView)
     self.localView.updateConstraints()
     self.localViewOutlet.updateConstraintsIfNeeded()
     self.localView.setNeedsDisplay()
     self.localViewOutlet.setNeedsDisplay()
     
     })
     
     
     }*/
    
    
    
}
*/
    
    /*
@IBAction func toggleAudioPressed(sender: AnyObject) {
    audioAction = !audioAction.boolValue
    if(audioAction==true)
    {
        socketObj.socket.emit("logClient","IPHONE-LOG: \(username!) is unmuted")
        btnAudio.setImage(UIImage(named: "audio_on"), forState: .Normal)
    }
    else
    {
        socketObj.socket.emit("logClient","IPHONE-LOG: \(username!) is mute")
        btnAudio.setImage(UIImage(named: "audio_off"), forState: .Normal)
    }
    self.rtcLocalMediaStream!.audioTracks[0].setEnabled(audioAction)
}
*/
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
                //if((self.rtcVideoTrackReceived) != nil && (self.videoAction==true || self.screenshared==true))
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
            
            ///////tryy april 2016 iamincallWith=nil
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
            
            
            if(isConference==true)
            {
                endedCall=true
                socketObj.socket.emit("logClient","IPHONE-LOG: inside end call, isConference is true")
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    
                    
                    
                    self.dismissViewControllerAnimated(true, completion: { () -> Void in
                        
                    })
                    
                    
                })
                
                
                /* dispatch_async(dispatch_get_main_queue(), { () -> Void in
                 let next = self.storyboard!.instantiateViewControllerWithIdentifier("mainpage") as! LoginViewController
                 self.presentViewController(next, animated: false, completion: { () -> Void in
                 print("nexttttt viewwww")
                 
                 })//end present controller
                 
                 })//end dispatch_async
                 */
            }//end if
            
            if(isConference != true)
            {
                //%%%%%%% new june 2016
                
                socketObj.socket.emit("logClient","IPHONE-LOG: inside end call, isConference is false")
                endedCall=true
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    
                    
                    
                    self.dismissViewControllerAnimated(true, completion: { () -> Void in
                        areYouFreeForCall=true
                    })
                    
                    
                })}
        }
        
        
    }
    else
    {
        if(isConference==true)
        {
            endedCall=true
            socketObj.socket.emit("logClient","IPHONE-LOG: inside end call, isConference is true and pc is nil")
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                
                
                
                self.dismissViewControllerAnimated(true, completion: { () -> Void in
                    areYouFreeForCall=true
                })
                
                
            })
            
            
            /* dispatch_async(dispatch_get_main_queue(), { () -> Void in
             let next = self.storyboard!.instantiateViewControllerWithIdentifier("mainpage") as! LoginViewController
             self.presentViewController(next, animated: false, completion: { () -> Void in
             print("nexttttt viewwww")
             
             })//end present controller
             
             })//end dispatch_async
             */
        }//end if
        
        if(isConference != true)
        {
            socketObj.socket.emit("logClient","IPHONE-LOG: inside end call, isConference is false, pc is nil")
            endedCall=true
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                
                
                
                self.dismissViewControllerAnimated(true, completion: { () -> Void in
                    areYouFreeForCall=true
                })
                
                
            })}
        //}
        
        
        
    }
}
/*
required init?(coder aDecoder: NSCoder)
{
    bytesarraytowrite=Array<UInt8>()
    super.init(coder: aDecoder)
    //print(AuthToken!)
    
}
override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
    
    super.init(nibName: nibNameOrNil,bundle: nibBundleOrNil)
}
*/
    
/*
override func viewDidLoad() {
    
    super.viewDidLoad()
    print("video controller loadeddddd")
    //txtLabelUsername.text=username!
    
    if(displayname=="")
    {
        txtLabelUsername.text=KeychainWrapper.stringForKey("username")
    }
    else{
        txtLabelUsername.text=displayname
    }
    
    //  if(isConference==true){
    webMeetingModel.delegateSendScreenshotDataChannel=self
    // }
    if(socketObj.delegateWebRTC == nil)
    {
        socketObj.delegateWebRTC=self
    }
    
    
    socketObj.socket.on("disconnected") {data, ack in
        
        if(meetingStarted==true && ConferenceRoomName != ""){
            print("\(username!) socket is disconnected in between meeting")
            socketObj.socket.emit("logClient","IPHONE-LOG: \(username!) socket is disconnected in between meeting")
            
        }
    }
    socketObj.socket.on("connect") {data, ack in
        
        
        
        
        print("meeting disconnected in video view controller")
        socketObj.socket.emit("logClient","IPHONE-LOG: meeting disconnected in video view controller")
        /*if(meetingStarted==true && ConferenceRoomName != "" && isConference==true){
         socketObj.socket.emit("logClient","IPHONE-LOG: \(username!) is trying to connect in room again")
         print("connecting to room again")
         socketObj.socket.emitWithAck("init", ["room":ConferenceRoomName,"username":username!])(timeoutAfter: 6000000) {data in
         meetingStarted=true
         print("room joined by got ack")
         var a=JSON(data)
         print(a.debugDescription)
         currentID=a[1].int!
         print("current id is \(currentID)")
         print("room joined is\(ConferenceRoomName)")
         }
         }*/
        
    }
    /*if(socketObj.delegateWebRTC == nil)
     {
     socketObj.delegateWebRTC=self
     }*/
    
    //--------------
    //----------------
    ///////////addHandlers()
    /*if(socketObj == nil)
     {
     print("socket is nillll", terminator: "")
     socketObj=LoginAPI(url:"\(Constants.MainUrl)")
     ///socketObj.connect()
     socketObj.addHandlers()
     socketObj.addWebRTCHandlers()
     
     }
     */
    
    /*if(meetingStarted==true && ConferenceRoomName != ""){
     print("connecting to room first time")
     socketObj.socket.emitWithAck("init", ["room":ConferenceRoomName,"username":username!])(timeoutAfter: 6000000) {data in
     meetingStarted=true
     print("room joined by got ack")
     var a=JSON(data)
     print(a.debugDescription)
     currentID=a[1].int!
     print("current id is \(currentID)")
     print("room joined is\(ConferenceRoomName)")
     }
     }*/
    
    
    // ******************************************************************************
    /* self.localViewTop.setSize(CGSize(width: 500, height: 500))*/
    ////self.localView=RTCEAGLVideoView(frame: CGRect(x: 0, y: 50, width: 500, height: 450))
    ////self.localView.drawRect(CGRect(x: 0, y: 50, width: 500, height: 450))
    
    
    ////// self.remoteView=RTCEAGLVideoView(frame: CGRect(x: 0, y: 50, width: 500, height: 450))
    //// self.remoteView.drawRect(CGRect(x: 0, y: 50, width: 500, height: 450))
    var w=localViewOutlet.bounds.width-(localViewOutlet.bounds.width*0.23)
    var h=localViewOutlet.bounds.height-(localViewOutlet.bounds.height*0.27)
    
    //Dimensions to show large video
    
    self.localFull=RTCEAGLVideoView(frame: CGRect(x: 0, y: localViewOutlet.bounds.height*0.08, width: localViewOutlet.bounds.width, height: (localViewOutlet.bounds.height*0.80)))
    self.localFull.drawRect(CGRect(x: 0, y: localViewOutlet.bounds.height*0.08, width: localViewOutlet.bounds.width, height: (localViewOutlet.bounds.height*0.80)))
    
    
    
    //Dimensions to show small video
    self.localView=RTCEAGLVideoView(frame: CGRect(x: w, y: h, width: 90, height: 85))
    self.localView.drawRect(CGRect(x: w, y: h, width: 90, height: 85))
    
    //Dimensions to show small remote video
    //self.remoteView=RTCEAGLVideoView(frame: CGRect(x: 0, y: 50, width: 400, height: 370))
    //self.remoteView.drawRect(CGRect(x: 0, y: 50, width: 400, height: 370))
    
    self.remoteView=RTCEAGLVideoView(frame: CGRect(x: 0, y: localViewOutlet.bounds.height*0.08, width: localViewOutlet.bounds.width, height: (localViewOutlet.bounds.height*0.80)))
    self.remoteView.drawRect(CGRect(x: 0, y: localViewOutlet.bounds.height*0.08, width: localViewOutlet.bounds.width, height: (localViewOutlet.bounds.height*0.80)))
    
    
    self.remoteScreenView=RTCEAGLVideoView(frame: CGRect(x: 0, y: 50, width: 400, height: 370))
    self.remoteScreenView.drawRect(CGRect(x: 0, y: 50, width: 400, height: 370))
    
    
    
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
    
    //$$$$
    //////%%%% neww commented july2016 meetingStarted=true
    if(isConference == true)
    {print("conference name is\(ConferenceRoomName)")
        if(isSocketConnected==true){
            //socketObj.socket.emitWithAck("init", ["room":ConferenceRoomName,"username":username!])(timeoutAfter: 1500000) {data in
            
            socketObj.socket.emitWithAck("init", ["room":ConferenceRoomName,"username":username!])(timeoutAfter: 1500000) {data in
                
                print("conference room joined by got ack")
                var a=JSON(data)
                print(a.debugDescription)
                currentID=a[1].int!
                print("current id is \(currentID)")
                print("room joined is\(ConferenceRoomName)")
            }
        }
        
        //roomname=ConferenceRoomName
    }
    else{
        /* if(iOSstartedCall==true){
         var roomname=self.randomStringWithLength(9) as String
         //joinedRoomInCall=roomname as String
         ConferenceRoomName=roomname
         socketObj.socket.emit("logClient","IPHONE-LOG: \(username) is trying to join room \(ConferenceRoomName)")
         areYouFreeForCall=false
         //}
         //iamincallWith=username!
         
         //joinedRoomInCall=roomname as String
         //socketObj.socket.emitWithAck("init", ["room":ConferenceRoomName,"username":username!])(timeoutAfter: 1500000) {data in
         
         socketObj.socket.emitWithAck("init", ["room":ConferenceRoomName,"username":username!])(timeoutAfter: 1500000) {data in
         
         meetingStarted=true
         print("1-1 call room joined by got ack")
         var a=JSON(data)
         socketObj.socket.emit("logClient","IPHONE-LOG: \(username!) joined room\(ConferenceRoomName) and got id \(a[1].int!) , also \(a.debugDescription)")
         print(a.debugDescription)
         currentID=a[1].int!
         print("current id is \(currentID)")
         //var aa=JSON(["msg":["type":"room_name","room":ConferenceRoomName as String],"room":globalroom,"to":iamincallWith!,"username":username!])
         
         var aa=JSON(["msg":["type":"room_name","room":ConferenceRoomName as String],"room":globalroom,"to":iamincallWith!,"username":username!])
         
         print(aa.description)
         socketObj.socket.emit("logClient","IPHONE-LOG: \(aa.object)")
         socketObj.socket.emit("message",aa.object)
         
         }
         }// end if iOs started calll
         
         
         */
    }//end else
    
    
    print("waiting now")
}
*/
    
override func viewWillAppear(animated: Bool) {
    
    
    //%%******* later instantiate remoteview and localview here also for socond time call
    txtLabelMainPage.font=UIFont.boldSystemFontOfSize(20)
    if(isFileReceived==true){
        print("here1")
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            self.btnViewFile.enabled=true
        }
    }
    if(rtcFact != nil){
        print("here2")
        if(isSocketConnected==true){
            if(socketObj.delegateWebRTC == nil)
            {
                socketObj.delegateWebRTC=self
            }
        }}
    
    
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
    remotevideoshared=false
    remoteView.hidden=true
    localView.hidden=true
    print("remote disconnected")
    
    txtLabelMainPage.font=UIFont.boldSystemFontOfSize(20)
    txtLabelMainPage.text="Welcome to cloudkibo meeting. Waiting for other peer to connect"
}


func createPeerConnectionObject(completion:(result:Bool)->())
{//Initialise Peer Connection Object
    socketObj.socket.emit("logClient","IPHONE-LOG: iphoneLog: \(username!) is trying to make peer connection")
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
    return completion(result: true)
    //Create Data channel
    //%%%%% new commented iOS to iOS ....
    ///////CreateAndAttachDataChannel()
}




func peerConnection(peerConnection: RTCPeerConnection!, addedStream stream: RTCMediaStream!) {
    print("added stream \(stream.debugDescription)")
    
    /*var session: AVAudioSession = AVAudioSession.sharedInstance()
    var e:NSError!
    do{
        let res=try session.overrideOutputAudioPort(AVAudioSessionPortOverride.Speaker)
        print("speaker got correctly")
        socketObj.socket.emit("logClient","IPHONE-LOG: success speaker iphone is ON")
    }
    catch _
    {
        socketObj.socket.emit("logClient","IPHONE-LOG: cannot enable speakers2 error..")
        print("Speaker errorrr3")
        
    }
    print(stream.videoTracks.count)
    print(stream.audioTracks.count)
    
    // dispatch_async(dispatch_get_main_queue(), {
    
    self.rtcStreamReceived=stream
    if(stream.videoTracks.count>0)
    {print("remote video track count is greater than one \(stream.videoTracks.count)")
        let remoteVideoTrack=stream.videoTracks[0] as! RTCVideoTrack
        //^^^^^^newwwww self.rtcVideoTrackReceived=stream.videoTracks[0] as! RTCVideoTrack
        socketObj.socket.emit("logClient","IPHONE-LOG: iphone user received audio/video stream from \(iamincallWith)")
        dispatch_async(dispatch_get_main_queue(), {
            
            ///self.didReceiveRemoteVideoTrack(remoteVideoTrack)
            self.didReceiveRemoteVideoTrack(remoteVideoTrack)
        })
        
    }*/
    
    // })
    
    
}
func peerConnection(peerConnection: RTCPeerConnection!, didOpenDataChannel dataChannel: RTCDataChannel!) {
    print(".................. did open data channel")
    
    
    print("\(username!) did open data channel received")
    socketObj.socket.emit("logClient","\(username!) did open data channel received")
    if(rtcDataChannel==nil)
    {socketObj.socket.emit("logClient","\(username!) is setting data channel received")
        print("\(username!) is setting data channel received")
        self.rtcDataChannel=dataChannel
        dataChannel.delegate=self
        /*
         var rtcInit=RTCDataChannelInit.init()
         // rtcInit.isNegotiated=true
         //rtcInit.isOrdered=true
         // rtcInit.maxRetransmits=30
         
         rtcDataChannel=pc.createDataChannelWithLabel(dataChannel.label, config: rtcInit)
         
         rtcDataChannel.delegate=self
         
         */
        var senttt=rtcDataChannel.sendData(RTCDataBuffer(data: NSData(base64EncodedString: "helloooo iphone sendind data through data channel", options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters),isBinary: true))
        print("datachannel message sent is \(senttt)")
        
        
        
    }
    
    //%%% old from here.....
    print(dataChannel.description)
    ////// %%%%% newww
    dispatch_async(dispatch_get_main_queue()) { () -> Void in
        self.btncapture.enabled=true
        self.btnShareFile.enabled=true
        
    }
    
    
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
            socketObj.socket.emit("logClient","IPHONE-LOG: \(username!) did create \(sdp.type) success")
            print("\(sdp.type) creatddddd")
            print(sdp.debugDescription)
            let sessionDescription=RTCSessionDescription(type: sdp.type!, sdp: sdp.description)
            
            self.pc.setLocalDescriptionWithDelegate(self, sessionDescription: sessionDescription)
            
            //print(["by":currentID!,"to":otherID,"sdp":["type":sdp.type!,"sdp":sdp.description],"type":sdp.type!,"username":username!])
            
            
            print(["by":currentID!,"to":otherID,"sdp":["type":sdp.type!,"sdp":sdp.description],"type":sdp.type!,"username":username!])
            
            //socketObj.socket.emit("msg",["by":currentID!,"to":otherID,"sdp":["type":sdp.type!,"sdp":sdp.description],"type":sdp.type!,"username":username!])
            
            socketObj.socket.emit("msg",["by":currentID!,"to":otherID,"sdp":["type":sdp.type!,"sdp":sdp.description],"type":sdp.type!,"username":username!])
            
            print("\(sdp.type) emitteddd")
        }
        if(self.pc.localDescription == nil){
            socketObj.socket.emit("logClient","IPHONE-LOG: \(username!) did create \(sdp.type) success, currentID is \(currentID!) and otherID is\(otherID!)")
            print("\(sdp.type) creatddddd")
            print(sdp.debugDescription)
            let sessionDescription=RTCSessionDescription(type: sdp.type!, sdp: sdp.description)
            
            self.pc.setLocalDescriptionWithDelegate(self, sessionDescription: sessionDescription)
            
            ////print(["by":currentID!,"to":otherID,"sdp":["type":sdp.type!,"sdp":sdp.description],"type":sdp.type!,"username":username!])
            
            //socketObj.socket.emit("msg",["by":currentID!,"to":otherID,"sdp":["type":sdp.type!,"sdp":sdp.description],"type":sdp.type!,"username":username!])
            
            socketObj.socket.emit("msg",["by":currentID!,"to":otherID,"sdp":["type":sdp.type!,"sdp":sdp.description],"type":sdp.type!,"username":username!])
            
            print("\(sdp.type) emitteddd")
        }
        
    }
    else
    {
        socketObj.socket.emit("logClient","IPHONE-LOG: \(username!) error creating \(sdp.type)")
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
            socketObj.socket.emit("logClient","IPHONE-LOG: \(username!) is creating answer")
            //^^^^^^^^^ new self.pc.addStream(self.rtcMediaStream)
            self.pc.createAnswerWithDelegate(self, constraints: self.rtcMediaConst)
        }
        else
        {
            socketObj.socket.emit("logClient","IPHONE-LOG: \(username!) local not nil or initiator is true")
            print("local not nil or initiator is true")
            //print(self.pc.localDescription.description)
            
        }
        
    } else {
        socketObj.socket.emit("logClient","IPHONE-LOG: \(username!) .......sdp set ERROR: \(error.localizedDescription)")
        print(".......sdp set ERROR: \(error.localizedDescription)", terminator: "")
    }
    ///// })
    
}

func videoView(videoView: RTCEAGLVideoView!, didChangeVideoSize size: CGSize) {
    
    print("video size has changed")
    
}


func socketReceivedMSGWebRTC(message:String,data:AnyObject!)
{print("socketReceivedMSGWebRTC inside")
    switch(message){
    case "msg":
        handlemsg(data)
        
        
    default:print("wrong socket msg received")
    print(data)
    }
}

func socketReceivedOtherWebRTC(message:String,data:AnyObject!)
{
    var msg=JSON(data)
    socketObj.socket.emit("logClient","IPHONE-LOG: \(username!) received message \(msg)")
    
    print("socketReceivedOtherWebRTC inside \(msg)")
    switch(message){
        
    case "peer.connected":
        print("peer.connected received")
        
        handlePeerConnected(data)
        
        /*case "peer.connected.new":
         print("peer.connected.new received")
         handlePeerConnected(data)
         */
    case "conference.stream":
        handleConferenceStream(data)
        
    case "peer.disconnected":
        handlePeerDisconnected(data)
        
    case "peer.disconnected.new":
        handlePeerDisconnected(data)
        
        //DIRECTLY DONE IN LOGIN API
        /*case "conference.chat":
         print("\(data)")
         var chat=JSON(data)
         print(JSON(data))
         ///self.delegateChat=WebmeetingChatViewController
         print(chat[0]["message"].description)
         print(chat[0]["username"].description)
         print(chat[0]["message"].string)
         print(chat[0]["username"].string)
         //self.receivedChatMessage(chat[0]["message"].description,username: "\(chat[0]["username"].description)")
         webMeetingModel.addChatMsg(chat[0]["message"].description, usr: chat[0]["username"].description)
         */
    default:print("wrong socket other mesage received")
    var msg=JSON(data)
    print(msg.description)
    socketObj.socket.emit("logClient","IPHONE-LOG: \(username!)received wrong socket message  \(msg.description)")
    }
    
}

func receivedChatMessage(message:String,username:String)
{
    socketObj.socket.emit("logClient","IPHONE-LOG: received chat message \(message) from \(username)")
    webMeetingModel.addChatMsg(message, usr: username)
    
}

func socketReceivedMessageWebRTC(message:String,data:AnyObject!)
{print("socketReceivedMessageWebRTC inside")
    var msg=JSON(data!)
    socketObj.socket.emit("logClient","IPHONE-LOG: \(username!) received socketReceivedMessageWebRTC  \(msg)")
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
    print(msg.description)
    
    if(msg[0]["type"].string! == "offer")
    {
        //^^^^^^^^^^^^^^^^newwwww if(joinedRoomInCall == "" && isInitiator.description == "false")
        if(joinedRoomInCall == "")
        {
            socketObj.socket.emit("logClient","IPHONE-LOG: room joined is null")
            print("room joined is null")
        }
        
        socketObj.socket.emit("logClient","IPHONE-LOG: \(username) received offer")
        print("offer received")
        isInitiator=false
        //var sdpNew=msg[0]["sdp"].object
        
        if(self.pc == nil) //^^^^^^^^^^^^^^^^^^newwwww tryyy
        {
            self.createPeerConnectionObject({(result) -> () in
                
                
            })
        }
        //^^^^^^^^^^^^^^^^^^ check this for second call already have localstream
        ////self.CreateAndAttachDataChannel()
        ////-------- self.addLocalMediaStreamToPeerConnection()
        
        
        //^^^^^^^^^^^^^^^^^^^^^^^newwwwww self.pc.addStream(self.getLocalMediaStream())
        otherID=msg[0]["by"].int!
        currentID=msg[0]["to"].int!
        //iamincallWith=msg[0]["username"].description
        
        iamincallWith=msg[0]["username"].description
        socketObj.socket.emit("logClient","IPHONE-LOG: \(username) id is \(currentID) , \(iamincallWith) id is \(otherID)")
        //if(msg[0]["username"].description != username! && self.pc.remoteDescription == nil){
        
        if(msg[0]["username"].description != username! && self.pc.remoteDescription == nil){
            
            txtLabelMainPage.font=UIFont.boldSystemFontOfSize(20)
            txtLabelMainPage.text="You are now connected in call with \(iamincallWith)"
            var sessionDescription=RTCSessionDescription(type: msg[0]["type"].description, sdp: msg[0]["sdp"]["sdp"].description)
            socketObj.socket.emit("logClient","IPHONE-LOG: \(username) is setting remote sdp")
            self.pc.setRemoteDescriptionWithDelegate(self, sessionDescription: sessionDescription)
        }
        
    }
    
    if(msg[0]["type"].string! == "answer" && msg[0]["by"].int != currentID)
    {
        if(self.screenshared==true){
            print("answer received screen")
            socketObj.socket.emit("logClient","IPHONE-LOG: \(username) received screen answer")
            var sessionDescription=RTCSessionDescription(type: msg[0]["type"].description, sdp: msg[0]["sdp"]["sdp"].description)
            self.pc.setRemoteDescriptionWithDelegate(self, sessionDescription: sessionDescription)
        }
        
        if(isInitiator.description == "true" && self.pc.remoteDescription == nil)
        {
            socketObj.socket.emit("logClient","IPHONE-LOG: \(username) received answer")
            
            print("answer received")
            var sessionDescription=RTCSessionDescription(type: msg[0]["type"].description, sdp: msg[0]["sdp"]["sdp"].description)
            self.pc.setRemoteDescriptionWithDelegate(self, sessionDescription: sessionDescription)
        }
        
    }
    if(msg[0]["type"].string! == "ice")
    {print("ice received of other peer")
        socketObj.socket.emit("logClient","IPHONE-LOG: \(username) received ice candidate")
        if(msg[0]["ice"].description=="null")
        {print("last ice as null so ignore")}
        else{
            if(msg[0]["by"].intValue != currentID)
            {var iceCandidate=RTCICECandidate(mid: msg[0]["ice"]["sdpMid"].description, index: msg[0]["ice"]["sdpMLineIndex"].int!, sdp: msg[0]["ice"]["candidate"].description)
                print(iceCandidate.description)
                
                if(self.pc.localDescription != nil && self.pc.remoteDescription != nil)
                    
                {var addedcandidate=self.pc.addICECandidate(iceCandidate)
                    socketObj.socket.emit("logClient","IPHONE-LOG: \(username) added ice candidate")
                    print("ice candidate added \(addedcandidate)")
                }
            }
        }
        
    }
    
    
}

func handlePeerConnected(data:AnyObject!)
{
    // print("received peer.connected obj from server")
    
    //Both joined same room
    
    var datajson=JSON(data!)
    print(datajson.debugDescription)
    socketObj.socket.emit("logClient","peer connected \(datajson.debugDescription)")
    //if(datajson[0]["username"].description != username!){
    
    if(datajson[0]["username"].description != username!){
        //if(datajson[0]["id"].int != currentID!)
        // {
        otherID=datajson[0]["id"].int
        iamincallWith=datajson[0]["username"].description
        isInitiator=true
        //iamincallWith = datajson[0]["phone"].description
        //txtLabelMainPage.font
        
        txtLabelMainPage.font=UIFont.boldSystemFontOfSize(20)
        txtLabelMainPage.text="You are now connected in call with \(iamincallWith)"
        
        print("socketObj value new is \(socketObj)")
        //////optional
        if(self.pc == nil) //^^^^^^^^^^^^^^^^^^newwww tryyy
        {
            self.createPeerConnectionObject({(result) -> () in
                if(result==true)
                {
                    self.CreateAndAttachDataChannel()
                }
            })
        }
        //%%%%%%%% old commented newww
        
        socketObj.socket.emit("logClient","IPHONE-LOG: \(username) is creating data channel for \(iamincallWith)")
        
        
        
        /////self.CreateAndAttachDataChannel()
        //-------self.addLocalMediaStreamToPeerConnection()
        
        
        //  ******* april 2016
        
        //  ******** april 2016
        
        
        //^^^^^^^^^^^^^^^^^^newwwww self.pc.addStream(self.rtcLocalMediaStream)
       // print("peer attached stream")
        //socketObj.socket.emit("logClient","IPHONE-LOG: \(username) attached stream")
        //socketObj.socket.emit("logClient","IPHONE-LOG: \(username) is creating offer for \(iamincallWith)")
        self.pc.createOfferWithDelegate(self, constraints: self.rtcMediaConst!)
        
        
        
    }
    
}



func handlePeerDisconnected(data:AnyObject!)
{
    print("received peer.disconnected obj from server")
    
    var datajson=JSON(data!)
    print(datajson.debugDescription)
    
    if(datajson[0]["id"].int == otherID)
    {
        webMeetingModel.messages.removeAllObjects()
        if(self.pc != nil)
        {
            socketObj.socket.emit("logClient","iphone got info that \(iamincallWith) has disconnected")
            print("peer disconnectedddd received \(datajson[0])")
            if(screenCaptureToggle==true)
            {
                screenCaptureToggle=false
            }
            //print("hangupppppp received \(datajson.debugDescription)")
            self.remoteDisconnected()
            
            
            
            dispatch_async(dispatch_get_global_queue(Int(QOS_CLASS_USER_INITIATED.rawValue),0)){
             
                //////////////self.localView.renderFrame(nil)
                /////////////self.remoteView.renderFrame(nil)
                self.pc=nil
                joinedRoomInCall=""
                //iamincallWith=nil
                isInitiator=false
                // rtcFact=nil
                areYouFreeForCall=true
                otherID=nil
                self.rtcStreamReceived = nil//^^^^^^^^^^^^^^^^newwwww
                
                
                if(self.rtcDataChannel != nil){
                    self.rtcDataChannel.close()
                    ////////newwwwwww
                    self.rtcDataChannel=nil
                }
            }
        }
        
    }
    //Both joined same room
    
    //////  var datajson=JSON(data!)
    print(datajson.debugDescription)
    
    ////// if(datajson[0]["id"].int == otherID)
    //{
    webMeetingModel.messages.removeAllObjects()
    self.endMeeting()
    
    //}
}


func handleMessage(data:AnyObject!)
{
    var message=JSON(data)
    print(message.debugDescription)
    socketObj.socket.emit("logClient","webrtc message received \(message[0].debugDescription)")
    if(message[0]["type"]=="room_name")
    {
        
        ////////////////////////////////////////////////////////////////
        //////////////^^^^^^^^^^^^^^^^^^^^^^newww isInitiator=false
        //What to do if already in a room??
        
        //%%%%%%%% new commented call june 201//6
        //if(joinedRoomInCall=="")
        // {//newwwwwww tryyy isinitiator
        isInitiator = false
        var CurrentRoomName=message[0]["room_name"].string!
        socketObj.socket.emit("logClient","IPHONE-LOG: \(username) got room name as \(CurrentRoomName)")
        print("got room name as \(joinedRoomInCall)")
        print("trying to join room")
        print("line #1394")
        socketObj.socket.emitWithAck("init", ["room":CurrentRoomName,"username":username!])(timeoutAfter: 600000) {data in
            meetingStarted=true
            print("room joined got ack")
            socketObj.socket.emit("logClient","IPHONE-LOG: \(username) joined room \(CurrentRoomName)")
            var a=JSON(data)
            print(a.debugDescription)
            socketObj.socket.emit("logClient","\(username!) got room ack as \(a.debugDescription)")
            currentID=a[1].int!
            joinedRoomInCall=message[0]["room_name"].string!
            print("current id is \(currentID)")
            //}
            //   }}
            ////////////////////////newwwwwww
            //%%%%%%%%% commented now june 2016
            
            /* else
             {
             isInitiator = false
             }*/
        }
    }
    if(message[0]["status"]=="callaccepted")
    {
        
        socketObj.socket.emit("logClient","IPHONE-LOG: \(username!) accept call in video view")
        print("accept call in video view")
        
        if(iOSstartedCall==true){
            var roomname=self.randomStringWithLength(9) as String
            //joinedRoomInCall=roomname as String
            ConferenceRoomName=roomname
            socketObj.socket.emit("logClient","IPHONE-LOG: \(username) is trying to join room \(ConferenceRoomName)")
            areYouFreeForCall=false
            //}
            //iamincallWith=username!
            
            //joinedRoomInCall=roomname as String
            //socketObj.socket.emitWithAck("init", ["room":ConferenceRoomName,"username":username!])(timeoutAfter: 1500000) {data in
            
            socketObj.socket.emitWithAck("init", ["room":ConferenceRoomName,"username":username!])(timeoutAfter: 1500000) {data in
                
                meetingStarted=true
                print("1-1 call room joined by got ack")
                var a=JSON(data)
                socketObj.socket.emit("logClient","IPHONE-LOG: \(username!) joined room\(ConferenceRoomName) and got id \(a[1].int!) , also \(a.debugDescription)")
                print(a.debugDescription)
                currentID=a[1].int!
                print("current id is \(currentID)")
                //var aa=JSON(["msg":["type":"room_name","room":ConferenceRoomName as String],"room":globalroom,"to":iamincallWith!,"username":username!])
                
                var aa=JSON(["to":iamincallWith!,"msg":["callerphone":username!,"calleephone":iamincallWith!,"type":"room_name","room_name":ConferenceRoomName as String]])
                
                //print(aa.description)
                socketObj.socket.emit("logClient","IPHONE-LOG: \(aa.object)")
                socketObj.socket.emit("message",aa.object)
                
            }
        }
        
        
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
    socketObj.socket.emit("logClient","IPHONE-LOG: \(username!) datachannel file METADATA sent is \(sentFile) OR image chunk size is sent \(sentFile)")
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
    //socketObj.socket.emit("logClient","IPHONE-LOG: \(username!) received message \(channelJSON) from datachannel")
    print(" hi hereee \(channelJSON.debugDescription)")
    //var bytes:[UInt8]
    var bytes=Array<UInt8>(count: buffer.data.length, repeatedValue: 0)
    
    // bytes.append(buffer.data.bytes)
    buffer.data.getBytes(&bytes, length: buffer.data.length)
    print(" hi hereee2 \(bytes.debugDescription)")
    
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
            print("jsonnn...........")
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
            {   fileTransferCompleted=false
                
                print("myjsondata....")
                print(myJSONdata["data"]["file_meta"])
                print("jsonnnn.valueForKey.......")
                print(jsonnnn["eventName"])
                print(jsonnnn["data"]!["file_meta"]!!["size"]!)
                
                print("file received \(myJSONdata["data"]["file_meta"].isExists())")
                
                var sizeee=Int.init((jsonnnn["data"]!["file_meta"]!!["size"]!?.debugDescription)!)
                fileSizeReceived=sizeee
                //fid=Int.init((jsonnnn["data"]!["file_meta"]!!["fid"]!?.debugDescription)!)
                //print("fid is \(fid)")
                
                //////////filePathReceived=channelJSON["data"]["file_meta"]["name"].debugDescription
                filePathReceived=jsonnnn["data"]!["file_meta"]!!["name"]!!.debugDescription
                socketObj.socket.emit("logClient","\(username!) received file name \(filePathReceived)")
                ////fileSizeReceived=jsonnnn["data"]!["file_meta"]!!["size"]!! as! Int
                print("file sizeeee jsonnnn is \(channelJSON["data"]["file_meta"]["size"].debugDescription)")
                
                print("file sizeeee channelJSON is \(jsonnnn["data"]!["file_meta"]!!["size"].debugDescription)")
                print("file sizeeee sizeee is \(sizeee)")
                /////////////fileSizeReceived = channelJSON["data"]["file_meta"]["size"].intValue
                
                ///fileSizeReceived=myJSONdata["data"]["file_meta"]["size"].intValue
                
                
                
                ///NEW ADDITION MAKE FILENAME GLOBAL
                filejustreceivedname=filePathReceived!
                
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
                            if(Int(fileSize1) < fu.chunkSize)
                            {
                                var bytebuffer=fu.convert_file_to_byteArray(filePathImage)
                                var byteToNSstring=NSString(bytes: &bytebuffer, length: bytebuffer.count, encoding: NSUTF8StringEncoding)
                                var bytestringfile:NSData!
                                do{
                                    
                                    bytestringfile=try NSData(contentsOfFile: byteToNSstring as! String)
                                }catch
                                {
                                    bytestringfile=NSData(contentsOfURL: urlLocalFile)
                                }
                                print("file size smaller than chunk")
                                if(bytestringfile==nil)
                                {
                                    bytestringfile=NSData(contentsOfURL: urlLocalFile)
                                }
                                var check=self.rtcDataChannel.sendData(RTCDataBuffer(data: bytestringfile,isBinary: true))
                                print("chunk has been sent \(check)")
                                break
                                
                            }
                            print("file size is \(fileSize1)")
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
                        print("here 555..")
                    }
                    print("here 444..")
                    //requestchunk(chunknumber)
                    
                }//if data chunk exists
                print("here 333..")
                
            }//end else
            print("here 222")
            
        }//if speaking!=nil
        print("here 111")
        
    }
        
    else
    {
        print("yes binary")
        
        for eachbyte in bytes
        {
            print("appending bytes array")
            bytesarraytowrite.append(eachbyte)
        }
        
        var modanswer=numberOfChunksReceived % fu.chunks_per_ack
        if(modanswer==(fu.chunks_per_ack-1) || numberOfChunksInFileToSave == (Double(numberOfChunksReceived+1)))
        {
            
            
            if(numberOfChunksInFileToSave > Double(numberOfChunksReceived))
            {
                chunknumbertorequest += fu.chunks_per_ack
                socketObj.socket.emit("logClient","IPHONE-LOG: \(username) is asking for other file chunk")
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
                socketObj.socket.emit("logClient","IPHONE-LOG: \(username) file transfer completed")
                print("file transfer completed..")
                fileTransferCompleted=true;
                
                
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
        
        var written=filedata.writeToFile(filePathImage2, atomically: false)
        
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
            
            
            
            
            print("file writtennnnn \(s) \(filedata.debugDescription)")
            if(fileTransferCompleted==true)
            {
                isFileReceived=true
                bytesarraytowrite=Array<UInt8>()
                numberOfChunksReceived=0
                numberOfChunksInFileToSave=0
                
                // **** neww may 2016
                dispatch_async(dispatch_get_main_queue()) { () -> Void in
                    self.btnViewFile.enabled=true
                }
                // **
                
                let alert = UIAlertController(title: "Success", message: "You have received a new file. Click on \"View\" button at top to View and Save it.", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                //UIApplication.sharedApplication().keyWindow?.rootViewController!.presentViewController(alert, animated: true, completion: nil)
                //if(UIApplication.sharedApplication().keyWindow?.rootViewController.present)
                self.presentViewController(alert, animated: true, completion: nil)
                //delegateFileReceived.didReceiveFileConference()
                
                self.delegateFileReceived?.didReceiveFileConference()
                //self.didReceiveFileConference()
            }
            ///self.didReceiveFileConference()
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
    //kRTCDataChannelStateClosed
    if(channel.state == kRTCDataChannelStateConnecting)
    {
        print("data channel connecting now")
    }
    
    if(channel.state == kRTCDataChannelStateOpen)
    {
        ///self.rtcDataChannel=channel
        print("data channel opened now")
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            self.btncapture.enabled=true
            self.btnShareFile.enabled=true
            
        }
    }
    if(channel.state == kRTCDataChannelStateClosed)
    {
        print("data channel closed now")
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            self.btncapture.enabled=false
            self.btnShareFile.enabled=false
            
        }
    }
    
}

@IBAction func btnFilePressed(sender: AnyObject) {
    socketObj.socket.emit("logClient","\(username!) is sharing file with \(iamincallWith)")
    print(NSOpenStepRootDirectory())
    ///var UTIs=UTTypeCopyPreferredTagWithClass("public.image", kUTTypeImage)?.takeRetainedValue() as! [String]
    
    let importMenu = UIDocumentMenuViewController(documentTypes: [kUTTypeText as NSString as String, kUTTypeImage as String,"com.adobe.pdf","public.jpeg","public.html","public.content","public.data","public.item",kUTTypeBundle as String],
                                                  inMode: .Import)
    ///////let importMenu = UIDocumentMenuViewController(documentTypes: UTIs, inMode: .Import)
    importMenu.delegate = self
    dispatch_async(dispatch_get_main_queue()) { () -> Void in
        self.presentViewController(importMenu, animated: true, completion: nil)
        
        
    }
    
    //////////mdata.sharefile()
    
    /*let documentPicker = UIDocumentPickerViewController(documentTypes: [kUTTypeText as NSString as String],
     inMode: .Import)
     documentPicker.delegate = self
     presentViewController(documentPicker, animated: true, completion: nil)*/
}

func documentPicker(controller: UIDocumentPickerViewController, didPickDocumentAtURL url: NSURL) {
    
    
    if (controller.documentPickerMode == UIDocumentPickerMode.Import) {
        NSLog("Opened ", url.path!);
        
        
        
        print("picker url is \(url)")
        
        url.startAccessingSecurityScopedResource()
        let coordinator = NSFileCoordinator()
        var error:NSError? = nil
        coordinator.coordinateReadingItemAtURL(url, options: [], error: &error) { (url) -> Void in
            // do something with it
            let fileData = NSData(contentsOfURL: url)
            print(fileData?.description)
            socketObj.socket.emit("logClient","IPHONE-LOG: \(username!) selected file ")
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
            ////var fname=furl!.URLByDeletingPathExtension?.URLString
            //var attributesError=nil
            var fileAttributes:[String:AnyObject]=["":""]
            do {
                let fileAttributes : NSDictionary? = try NSFileManager.defaultManager().attributesOfItemAtPath(furl!.path!)
                
                if let _attr = fileAttributes {
                    self.fileSize1 = _attr.fileSize();
                    print("file size is \(self.fileSize1)")
                    //// ***april 2016 neww self.fileSize=(fileSize1 as! NSNumber).integerValue
                }
            } catch {
                socketObj.socket.emit("logClient","IPHONE-LOG: error: \(error)")
                print("Error: \(error)")
            }
            /*do{
             /// fileAttributes = try NSFileManager.defaultManager().attributesOfItemAtPath(furl!.path!)
             fileAttributes = try NSFileManager.defaultManager().attributesOfItemAtPath(url.URLString)
             
             }catch
             {print("error")
             print(error)
             }
             */
            /* NEW COMMENTED APRIL @)!^
             let fileSizeNumber = fileAttributes[NSFileSize]! as! NSNumber
             print(fileAttributes[NSFileType] as! String)
             
             self.fileSize=fileSizeNumber.integerValue
             */
            //FILE METADATA size
            //print(self.fileSize)
            urlLocalFile=url
            /////let text2 = fm.contentsAtPath(filePath)
            ////////print(text2)
            /////////print(JSON(text2!))
            ///mdata.fileContents=fm.contentsAtPath(filePathImage)!
            self.fileContents=NSData(contentsOfURL: url)
            self.filePathImage=url.URLString
            //var filecontentsJSON=JSON(NSData(contentsOfURL: url)!)
            //print(filecontentsJSON)
            print("file url is \(self.filePathImage) file type is \(ftype)")
            var filename=fname!+"."+ftype
            socketObj.socket.emit("logClient","\(username!) is sending file \(fname)")
            
            var mjson="{\"file_meta\":{\"name\":\"\(filename)\",\"size\":\"\(self.fileSize1.description)\",\"filetype\":\"\(ftype)\",\"browser\":\"firefox\",\"uname\":\"\(username!)\",\"fid\":\(self.myfid),\"senderid\":\(currentID!)}}"
            var fmetadata="{\"eventName\":\"data_msg\",\"data\":\(mjson)}"
            
            /*
             var mjson="{\"file_meta\":{\"name\":\"\(fname!)\",\"size\":\"\(self.fileSize1.description)\",\"filetype\":\"\(ftype)\",\"browser\":\"firefox\",\"uname\":\"\(username!)\",\"fid\":\(self.myfid),\"senderid\":\(currentID!)}}"
             var fmetadata="{\"eventName\":\"data_msg\",\"data\":\(mjson)}"*/
            
            
            
            self.sendDataBuffer(fmetadata,isb: false)
            
            
            
            
            //%%%%%%%%%% socketObj.socket.emit("conference.chat", ["message":"You have received a file. Download and Save it.","username":username!])
            socketObj.socket.emit("conference.chat", ["message":"You have received a file. Download and Save it.","username":username!])
            
            let alert = UIAlertController(title: "Success", message: "Your file has been successfully sent", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            
            
        }
        
        url.stopAccessingSecurityScopedResource()
        //mdata.sharefile(url)
    }
}



func documentMenu(documentMenu: UIDocumentMenuViewController, didPickDocumentPicker documentPicker: UIDocumentPickerViewController) {
    
    documentPicker.delegate = self
    presentViewController(documentPicker, animated: true, completion: nil)
    
    
}

func documentMenuWasCancelled(documentMenu: UIDocumentMenuViewController) {
    
    
}

public func sendImage(imageData:NSData)
{
    var buflimit:Int64=16000000

    var imageSent=self.rtcDataChannel.sendData(RTCDataBuffer(data: imageData, isBinary: true))
    ////var imageSent=self.rtcDataChannel.sendData(RTCDataBuffer(data: imageWithHeaderBinary, isBinary: false))
    socketObj.socket.emit("logClient","IPHONE-LOG: \(username) image senttttt \(imageSent)")
    print("image senttttt \(imageSent)")
    //}
    
    //})
    
}


override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "chatConferenceSegue" {
        print("segueee chattt")
        let conferenceChatView = segue.destinationViewController as? WebmeetingChatViewController
        //let addItemViewController = navigationController?.topViewController as? AddItemViewController
        
        if let viewController = conferenceChatView {
            self.delegateFileReceived=viewController
        }
    }
    if segue.identifier == "filePreviewSegue" {
        print("segueee chattt")
        let filePreviewView = segue.destinationViewController as? FileReceivedViewController
        //let addItemViewController = navigationController?.topViewController as? AddItemViewController
        
        if let viewController = filePreviewView {
            self.delegateFileReceived=viewController
        }
    }
    //
}

override func viewDidLayoutSubviews() {
    
    txtLabelMainPage.font=UIFont.boldSystemFontOfSize(20)
}

func endMeeting()
{
    print("ending meeting")
    endedCall=true
    meetingStarted=false
    //// socketObj.socket.disconnect()
    if(currentID != nil){
        //socketObj.socket.emit("peer.disconnected", ["username":username!,"id":currentID!,"room":ConferenceRoomName])
        socketObj.socket.emit("peer.disconnected", ["username":username!,"id":currentID!,"room":ConferenceRoomName])
        
        
        //socketObj.socket.emit("message",["msg":"hangup","room":globalroom,"to":iamincallWith!,"username":username!, "id":currentID!])
        
        //socketObj.socket.emit("message",["msg":"hangup","room":globalroom,"to":iamincallWith!,"username":username!, "id":currentID!])
        
        // socketObj.socket.emit("leave",["room":joinedRoomInCall,"id":currentID!])
    }
    
    socketObj.socket.close()
    socketObj.socket.disconnect()
    socketObj=nil
    print("socket is nillll", terminator: "")
    //dispatch_async(dispatch_get_main_queue())
    //{
    socketObj=LoginAPI(url:"\(Constants.MainUrl)")
    ///socketObj.connect()
    //            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND,0))
    //{
    socketObj.addHandlers()
    socketObj.addWebRTCHandlers()
    
    /////////// socketObj.socket.connect()
    //socketObj=nil
    
    //self.pc=nil
    joinedRoomInCall=""
    //iamincallWith=nil
    isInitiator=false
    //rtcFact=nil
    areYouFreeForCall=true
    currentID=nil
    otherID=nil
    self.rtcLocalMediaStream=nil
    self.rtcStreamReceived=nil
    //self.pc.close()
    
    //self.pc=nil
    //rtcFact=nil //**********important********
    //iamincallWith=nil
    
    if((self.rtcDataChannel) != nil){
        self.rtcDataChannel.close()
        self.rtcDataChannel=nil
        //newwwwwwww tryy
        //rtcDataChannel.close()
    }
    
    
    //^^^^^^^^^^^newwwww self.disconnect()
    //if((self.pc) != nil)
    //{
    
    //%%%%%%%% neww june
    
    self.localView.renderFrame(nil)
    self.remoteView.renderFrame(nil)
    self.localFull.renderFrame(nil)
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
    ConferenceRoomName=""
    //iamincallWith=nil
    isInitiator=false
    rtcFact=nil
    areYouFreeForCall=true
    currentID=nil
    otherID=nil
    ////// self.remoteDisconnected()
    
    ////// socketObj.socket.emit("message",["msg":"hangup","room":globalroom,"to":iamincallWith!,"username":username!])
    
    
    // iamincallWith=nil
    //print("hangup emitted")
    
    
    if(self.localFull.superview != nil)
    {
        print("localFull was a subview. remmoving")
        self.localFull.removeFromSuperview()
    }
    
    
    if(self.localView.superview != nil)
    {
        print("localview was a subview. remmoving")
        self.localView.removeFromSuperview()
    }
    if(self.remoteView.superview != nil)
    {
        print("remoteview was a subview. remmoving")
        
        self.remoteView.removeFromSuperview()
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
        self.rtcStreamReceived.removeAudioTrack(self.rtcStreamReceived.audioTracks[0] as! RTCAudioTrack)
        /////rtcStreamReceived.videoTracks[0].stopRunning()
        //rtcStreamReceived.audioTracks[0].stopRunning()
    }
    
    print("views removed from parent")
    ///**** neww may 2016}
    
    joinedRoomInCall=""
    iamincallWith=""
    isInitiator=false
    areYouFreeForCall=true
    
    self.rtcLocalMediaStream=nil //test and try-------------
    self.rtcStreamReceived=nil
    screenCaptureToggle=false
    ConferenceRoomName=""
    
    
    //socketObj.socket.emit("logClient","IPHONE-LOG: \(username!) pressed end call. going back to contacts list")
    dispatch_async(dispatch_get_main_queue(), { () -> Void in
        //%%%%%%%% let next = self.storyboard!.instantiateViewControllerWithIdentifier("mainpage") as! LoginViewController
        
        
        //MainChatView
        
        print("views removed from parent")
        self.dismissViewControllerAnimated(false, completion: { () -> Void in
            
            
        })
        
        //let storyboard : UIStoryboard = UIStoryboard(name: "AccountStoryboard", bundle: nil)
        /* let vc : ChatViewController = self.storyboard!.instantiateViewControllerWithIdentifier("MainChatView") as! ChatViewController
         //vc.teststring = "hello"
         
         let navigationController = UINavigationController(rootViewController: vc)
         
         self.presentViewController(navigationController, animated: true, completion: nil)
         */
        
        
        /*  let next = self.storyboard!.instantiateViewControllerWithIdentifier("MainChatView") as! ChatViewController
         self.presentViewController(next, animated: false, completion: { () -> Void in
         print("nexttttt viewwww")
         
         })
         */
        //end present controller
        
    })//end dispatch_async
    
}//end function

}
 */*/*/*/