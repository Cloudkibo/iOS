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




class VideoViewController: UIViewController,RTCPeerConnectionDelegate,RTCSessionDescriptionDelegate,RTCEAGLVideoViewDelegate,SocketClientDelegateWebRTC {
    
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
    func addHandlers()
    {
        socketObj.socket.on("msg"){data,ack in
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
                
                self.addLocalMediaStreamToPeerConnection()
                
                
                //^^^^^^^^^^^^^^^^^^^^^^^newwwwww self.pc.addStream(self.getLocalMediaStream())
                otherID=msg[0]["by"].int!
                currentID=msg[0]["to"].int!
                
                ///////socketObj.socket.emit("conference.stream", ["username":username!,"id":currentID!,"type":"video","action":"false"])
                ////////socketObj.socket.emit("conference.stream", ["username":username!,"id":currentID!,"type":"audio","action":"true"])
                
                if(msg[0]["username"].description != username! && self.pc.remoteDescription == nil){
                var sessionDescription=RTCSessionDescription(type: msg[0]["type"].description, sdp: msg[0]["sdp"]["sdp"].description)
                self.pc.setRemoteDescriptionWithDelegate(self, sessionDescription: sessionDescription)
                }
                
            }
            
            if(msg[0]["type"].string! == "answer" && msg[0]["by"].int != currentID)
            {
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
        
        
        
        
        ///////////////////////
        /////////////////////////////////////
        socketObj.socket.on("peer.connected"){data,ack in
            print("received peer.connected obj from server")
            
            //Both joined same room
            
            var datajson=JSON(data)
            print(datajson.debugDescription)
            
            if(datajson[0]["username"].description != username!){
                otherID=datajson[0]["id"].int
                iamincallWith=datajson[0]["username"].description
                isInitiator=true
                iamincallWith = datajson[0]["username"].description
                
                
                //////optional
                if(self.pc == nil) //^^^^^^^^^^^^^^^^^^newwww tryyy
                { //^^^^^^^^^^^^^^^^^^^^newwwwwww another time call get local media stream.. view will appear is not working may be.....
                    // RTCPeerConnectionFactory.initializeSSL()
                    //rtcFact=RTCPeerConnectionFactory()
                    ///////self.rtcLocalMediaStream=self.getLocalMediaStream()
                    
                    self.createPeerConnectionObject()
                }
                
                self.addLocalMediaStreamToPeerConnection()
                //^^^^^^^^^^^^^^^^^^newwwww self.pc.addStream(self.rtcLocalMediaStream)
                print("peer attached stream")
                //^^^^^^^^^^^self.pc.addStream(self.getLocalMediaStream())
                //////socketObj.socket.emit("conference.stream", ["username":username!,"id":currentID!,"type":"video","action":"false"])
                ///////socketObj.socket.emit("conference.stream", ["username":username!,"id":currentID!,"type":"audio","action":"true"])
                
                
                self.pc.createOfferWithDelegate(self, constraints: self.rtcMediaConst!)
            }
        }
        
        socketObj.socket.on("conference.stream"){data,ack in
            
            print("received conference.stream obj from server")
            var datajson=JSON(data)
            print(datajson.debugDescription)
            //if(datajson[0]["id"].intValue == otherID! && datajson[0]["type"].description == "video")
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
        
        socketObj.socket.on("peer.stream"){data,ack in
            print("received peer.stream obj from server")
            var datajson=JSON(data)
            print(datajson.debugDescription)
            
        }
        socketObj.socket.on("peer.disconnected"){data,ack in
            print("received peer.disconnected obj from server")
            var datajson=JSON(data)
            print(datajson.debugDescription)
            
        }
        
        
        
        
        socketObj.socket.on("message"){data,ack in
            print("received messageee11")
            var msg=JSON(data)
            print(msg.debugDescription)
            
            if(msg[0]["type"]=="room_name")
            {////////////////////////////////////////////////////////////////
                //////////////^^^^^^^^^^^^^^^^^^^^^^newww isInitiator=false
                //What to do if already in a room??
                
                if(joinedRoomInCall=="")
                {
                    var CurrentRoomName=msg[0]["room"].string!
                    print("got room name as \(joinedRoomInCall)")
                    print("trying to join room")
                    //socketObj.socket.emit("init",["room":joinedRoomInCall,"username":username!])
                    //socketObj.socket.emitWithAck("init",["room":joinedRoomInCall,"username":username!])(timeout: 0)
                    
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
            {
                if(joinedRoomInCall == "")
                {
                    print("inside accept call")
                    var roomname=self.randomStringWithLength(9)
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
                        
                    }
                }
                
                
                /*^^^^^^^^^var aa=JSON(["msg":["type":"room_name","room":roomname as String],"room":globalroom,"to":iamincallWith!,"username":username!])
                print(aa.description)
                */
                //socketObj.socket.emit("message",["type":"room_name","room":roomname,"room":globalroom,"to":iamincallWith!,"username":username!])
                /////^^^^^^^^^socketObj.sendMessagesOfMessageType(aa.description)
                //^^^^^^^ socketObj.socket.emit("message",aa.object)
                //^^^^^^^^^self.pc.createOfferWithDelegate(self, constraints: self.rtcMediaConst!)
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
                /*            areYouFreeForCall=true
                
                joinedRoomInCall=""
                isInitiator=false
                rtcFact=nil
                areYouFreeForCall=true
                currentID=nil
                otherID=nil
                //self.disconnect()
                if((self.rtcLocalVideoTrack) != nil)
                {print("remove localtrack renderer")
                self.rtcLocalVideoTrack = nil
                ///////  self.rtcLocalVideoTrack.removeRenderer(self.localView)
                }
                /*if((self.rtcVideoTrackReceived) != nil)
                {print("remove remotetrack renderer")
                self.rtcVideoTrackReceived.removeRenderer(self.remoteView)
                }
                */
                self.rtcLocalVideoTrack=nil
                self.localView.renderFrame(nil)
                //  self.remoteView.renderFrame(nil)
                
                self.remoteView.removeFromSuperview()
                self.localView.removeFromSuperview()
                
                */
                //////self.localViewOutlet.removeFromSuperview()
                //self.dismissViewControllerAnimated(true, completion: { () -> Void in
                //print("doneee hanguppp")
                // })
                //self.performSegueWithIdentifier("endCallSegue", sender: nil);
                //  })
                /*
                // if(self.rtcCaptureSession.running==false)
                // {
                self.dismissViewControllerAnimated(true, completion: { () -> Void in
                areYouFreeForCall=true
                if((self.rtcLocalVideoTrack) != nil)
                { self.rtcLocalVideoTrack.removeRenderer(self.localView)
                self.rtcLocalVideoTrack=nil
                self.rtcLocalMediaStream=nil
                self.localView.renderFrame(nil)
                }
                if((self.rtcVideoTrackReceived) != nil)
                {
                self.rtcVideoTrackReceived.removeRenderer(self.remoteView)
                
                self.rtcVideoTrackReceived=nil
                self.rtcAudioTrackReceived=nil
                self.rtcStreamReceived=nil
                self.remoteView.renderFrame(nil)
                
                }
                self.pc=nil
                joinedRoomInCall=""
                iamincallWith=""
                isInitiator=false
                rtcFact=nil
                self.localView=nil
                self.remoteView=nil
                
                /*for(var i=self.localViewOutlet.subviews.count;i<0;i--)
                {
                if(i<=(self.localViewOutlet.subviews.count-1))
                {
                self.localViewOutlet.subviews[i].removeFromParentViewController()
                }
                
                }*/
                })
                
                */
                
                // }
                // if(joinedRoomInCall != "")
                // {
                //socketObj.socket.emit("leave",["room":joinedRoomInCall])
                
                //self.rtcMediaStream.removeAudioTrack(self.rtcAudioTrackReceived)
                // self.rtcMediaStream.removeVideoTrack(self.rtcVideoTrackReceived)
                
                /* self.dismissViewControllerAnimated(true, completion: { () -> Void in
                
                for(var i=self.localViewOutlet.subviews.count;i<0;i--)
                {
                if(i<=(self.localViewOutlet.subviews.count-1))
                {
                self.localViewOutlet.subviews[i].removeFromParentViewController()
                }
                
                }
                })*/
                //}
                /*else
                {
                print("hangup by youuu")
                
                }
                */
                
            }
            
            if(msg[0]["type"]=="Missed")
            {
                let todoItem = NotificationItem(otherUserName: "\(iamincallWith!)", message: "You have received a missed call", type: "missed call", UUID: "111", deadline: NSDate())
                notificationsMainClass.sharedInstance.addItem(todoItem) // schedule a local notification to persist this item
                
            }
            
            
            
            
            
        }
        
        //socket.emit('msg', { by: currentId, to: id, sdp: sdp, type: 'offer', username: username });
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
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    
                    
                    
                    self.dismissViewControllerAnimated(true, completion: { () -> Void in
                        /*^^^^^^^^^^^^^^^^^^^^^neewww:::::::
                        for(var i=self.localViewOutlet.subviews.count;i<0;i--)
                        {
                        if(i<=(self.localViewOutlet.subviews.count-1))
                        {
                        self.localViewOutlet.subviews[i].removeFromParentViewController()
                        }
                        
                        }
                        */
                    })
                    
                    
                })
            }
            
            
        }
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        //print(AuthToken!)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        if(socketObj.delegateWebRTC == nil)
        {
        socketObj.delegateWebRTC=self
        }
        ////////////////addHandlers()
        print("video view loadddddd")
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
        ///dispatch_async(dispatch_get_global_queue(Int(QOS_CLASS_USER_INITIATED.value),0)){
            // self.localView=RTCEAGLVideoView(frame: CGRect(x: 0, y: 0, width: 500, height: 500))
            
            //self.localView.drawRect(CGRect(x: 0, y: 0, width: 500, height: 500))
            /*if((self.rtcLocalVideoTrack) != nil)
            {
                self.rtcLocalVideoTrack.removeRenderer(self.localView)
                ///////////////////self.rtcLocalVideoTrack=nil
                self.localView.renderFrame(nil)
            }
            self.rtcLocalVideoTrack=localVideoTrack
            self.rtcLocalVideoTrack.addRenderer(self.localView)
            self.localViewOutlet.addSubview(self.localView)*/
        
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
       /// }
    }
    
    func didReceiveLocalStream(stream:RTCMediaStream)
    {
        dispatch_async(dispatch_get_main_queue(), {
            self.localView=RTCEAGLVideoView(frame: CGRect(x: 0, y: 0, width: 500, height: 500))
            
            self.localView.drawRect(CGRect(x: 0, y: 0, width: 500, height: 500))
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
       // dispatch_async(dispatch_get_global_queue(Int(QOS_CLASS_USER_INITIATED.value),0)){
        
          /*  if(self.rtcVideoTrackReceived != nil)
            {
                self.remoteView.renderFrame(nil)
                self.rtcVideoTrackReceived.removeRenderer(self.remoteView)
                //self.rtcVideoTrackReceived.delete(self)
                ///////////////////self.rtcLocalVideoTrack=nil
                self.rtcVideoTrackReceived=nil
                
            }*/
            /*
            //self.remoteView=RTCEAGLVideoView(frame: CGRect(x: 0, y: 0, width: 500, height: 500))
            //self.remoteView.drawRect(CGRect(x: 0, y: 0, width: 500, height: 500))
            self.rtcVideoTrackReceived=remoteVideoTrack
            /////////self.remoteView=RTCEAGLVideoView(frame: CGRect(x: 0, y: 0, width: 500, height: 500))
            //////////self.remoteView.drawRect(CGRect(x: 0, y: 0, width: 500, height: 500))
            
            self.rtcVideoTrackReceived.addRenderer(self.remoteView)
            //////////////remoteVideoTrack.addRenderer(self.remoteView)
            self.remoteView.hidden=true // ^^^^newww
            self.localViewOutlet.addSubview(self.remoteView)
            
            */
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
    override func viewWillAppear(animated: Bool) {
        
        ///////////addHandlers()
        
        
        
        
        /*^^^^^^^^^^^^^^^newwww
        
        var mainICEServerURL:NSURL=NSURL(fileURLWithPath: Constants.MainUrl)!
        
        rtcICEarray.append(RTCICEServer(URI: NSURL(string:"turn:45.55.232.65:3478?transport=udp"), username: "cloudkibo", password: "cloudkibo"))
        rtcICEarray.append(RTCICEServer(URI: NSURL(string:"turn:45.55.232.65:3478?transport=tcp"), username: "cloudkibo", password: "cloudkibo"))
        rtcICEarray.append(RTCICEServer(URI: NSURL(string:"stun:stun.l.google.com:19302"), username: "", password: ""))
        rtcICEarray.append(RTCICEServer(URI: NSURL(string:"stun:23.21.150.121"), username: "", password: ""))
        rtcICEarray.append(RTCICEServer(URI: NSURL(string:"stun:stun.anyfirewall.com:3478"), username: "", password: ""))
        rtcICEarray.append(RTCICEServer(URI: NSURL(string:"turn:turn.bistri.com:80?transport=udp"), username: "homeo", password: "homeo"))
        rtcICEarray.append(RTCICEServer(URI: NSURL(string:"turn:turn.bistri.com:80?transport=tcp"), username: "homeo", password: "homeo"))
        rtcICEarray.append(RTCICEServer(URI: NSURL(string:"turn:turn.anyfirewall.com:443?transport=tcp"), username: "webrtc", password: "webrtc"))
        
        
        print("rtcICEServerObj is \(rtcICEarray[0])")
        
        //self.createPeerConnectionObject()
        RTCPeerConnectionFactory.initializeSSL()
        rtcFact=RTCPeerConnectionFactory()
        self.rtcLocalMediaStream=self.getLocalMediaStream()
        
        */
        //^^^^^didReceiveLocalStream(self.getLocalMediaStream())
        //^^^^^^^^^^^^^^^^newwww didReceiveLocalStream(self.rtcLocalMediaStream)
        
        
        
        
        
        //******************************************************************************
        /* self.localViewTop.setSize(CGSize(width: 500, height: 500))*/
        self.localView=RTCEAGLVideoView(frame: CGRect(x: 0, y: 0, width: 500, height: 500))
        
        self.localView.drawRect(CGRect(x: 0, y: 0, width: 500, height: 500))
        // self.remoteView.addConstraints(mediaConstraints.d)
        /* self.localViewOutlet.addSubview(self.localView)
        self.localViewOutlet.updateConstraintsIfNeeded()
        self.localView.setNeedsDisplay()
        self.localViewOutlet.setNeedsDisplay()*/
        
        self.remoteView=RTCEAGLVideoView(frame: CGRect(x: 0, y: 0, width: 500, height: 500))
        self.remoteView.drawRect(CGRect(x: 0, y: 0, width: 500, height: 500))
        
        var mainICEServerURL:NSURL=NSURL(fileURLWithPath: Constants.MainUrl)
        
        rtcICEarray.append(RTCICEServer(URI: NSURL(string:"turn:45.55.232.65:3478?transport=udp"), username: "cloudkibo", password: "cloudkibo"))
        rtcICEarray.append(RTCICEServer(URI: NSURL(string:"turn:45.55.232.65:3478?transport=tcp"), username: "cloudkibo", password: "cloudkibo"))
        rtcICEarray.append(RTCICEServer(URI: NSURL(string:"stun:stun.l.google.com:19302"), username: "", password: ""))
        rtcICEarray.append(RTCICEServer(URI: NSURL(string:"stun:23.21.150.121"), username: "", password: ""))
        rtcICEarray.append(RTCICEServer(URI: NSURL(string:"stun:stun.anyfirewall.com:3478"), username: "", password: ""))
        rtcICEarray.append(RTCICEServer(URI: NSURL(string:"turn:turn.bistri.com:80?transport=udp"), username: "homeo", password: "homeo"))
        rtcICEarray.append(RTCICEServer(URI: NSURL(string:"turn:turn.bistri.com:80?transport=tcp"), username: "homeo", password: "homeo"))
        rtcICEarray.append(RTCICEServer(URI: NSURL(string:"turn:turn.anyfirewall.com:443?transport=tcp"), username: "webrtc", password: "webrtc"))
        
        
        print("rtcICEServerObj is \(rtcICEarray[0])")
        
        //self.createPeerConnectionObject()
        RTCPeerConnectionFactory.initializeSSL()
        rtcFact=RTCPeerConnectionFactory()
        self.rtcLocalMediaStream=self.getLocalMediaStream()
        
        
    }
    
    func peerConnection(peerConnection: RTCPeerConnection!, addedStream stream: RTCMediaStream!) {
        print("added stream \(stream.debugDescription)")
        print(stream.videoTracks.count)
        print(stream.audioTracks.count)
        
        // dispatch_async(dispatch_get_main_queue(), {
        
        self.rtcStreamReceived=stream
        /*^^^^^^^newwwww self.rtcStreamReceived=stream
        
        self.remoteView=RTCEAGLVideoView(frame: CGRect(x: 0, y: 0, width: 500, height: 500))
        self.remoteView.drawRect(CGRect(x: 0, y: 0, width: 500, height: 500))
        var mediaConstraints=RTCMediaConstraints(mandatoryConstraints: [RTCPair(key: "maxWidth", value: "640"),RTCPair(key: "minWidth", value: "640"),RTCPair(key: "maxHeight", value: "480"),RTCPair(key: "minHeight", value: "480"),RTCPair(key: "maxFrameRate", value: "30"),RTCPair(key: "minFrameRate", value: "5"),RTCPair(key: "googLeakyBucket", value: "true")], optionalConstraints: nil)
        
        */
        if(stream.videoTracks.count>0)
        {print("remote video track count is greater than one")
            let remoteVideoTrack=stream.videoTracks[0] as! RTCVideoTrack
            //^^^^^^newwwww self.rtcVideoTrackReceived=stream.videoTracks[0] as! RTCVideoTrack
            dispatch_async(dispatch_get_main_queue(), {
                
            self.didReceiveRemoteVideoTrack(remoteVideoTrack)
            })
            
            /* ^^^^^^ self.rtcVideoTrackReceived.addRenderer(self.remoteView)
            
            self.remoteView.hidden=true // ^^^^newww
            self.localViewOutlet.addSubview(self.remoteView)
            self.localViewOutlet.updateConstraintsIfNeeded()
            self.remoteView.setNeedsDisplay()
            self.localViewOutlet.setNeedsDisplay()
            */
            
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
            
            print(["by":currentID!,"to":otherID,"sdp":["type":sdp.type!,"sdp":sdp.description],"type":sdp.type!,"username":username!])
            
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
        {                         self.createPeerConnectionObject()
        }
        
        self.addLocalMediaStreamToPeerConnection()
        //^^^^^^^^^^^^^^^^^^newwwww self.pc.addStream(self.rtcLocalMediaStream)
        print("peer attached stream")
        
        
        self.pc.createOfferWithDelegate(self, constraints: self.rtcMediaConst!)
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
            {
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
        {
            if(joinedRoomInCall == "")
            {
            print("inside accept call")
            var roomname=self.randomStringWithLength(9)
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

    
        
        
        
    
    }

}
