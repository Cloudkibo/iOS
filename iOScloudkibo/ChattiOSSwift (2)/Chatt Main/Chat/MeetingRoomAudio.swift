//
//  MeetingRoomAudio.swift
//  Chat
//
//  Created by Cloudkibo on 03/02/2016.
//  Copyright © 2016 MyAppTemplates. All rights reserved.
//

import Foundation
import SwiftyJSON

class MeetingRoomAudio:NSObject,SocketClientDelegateWebRTC,RTCPeerConnectionDelegate,RTCSessionDescriptionDelegate{
    
    
    ///////perform segue completion handler pass webmeetingModel
    var pc:RTCPeerConnection!
    /////var username =username!
    var stream:RTCMediaStream!
    var nullStream:RTCMediaStream!
    var audioAction=true
    var rtcMediaConst:RTCMediaConstraints! = nil
    var delegateDisconnect:ConferenceRoomDisconnectDelegate!
    var delegateChat:WebMeetingChatDelegate!
    var webmeetingModel:webmeetingMsgsModel!
    var delegateConferenceEnd:ConferenceEndDelegate!
    
    override init()
    {
        webmeetingModel=webmeetingMsgsModel()
        
        super.init()
    }
    
    func initAudio()
    {var mainICEServerURL:NSURL=NSURL(fileURLWithPath: Constants.MainUrl)
        //turn:turn.cloudkibo.com:3478?transport=udp
        //turn:turn.cloudkibo.com:3478?transport=udp
        /*rtcICEarray.append(RTCICEServer(URI: NSURL(string: "turn:turn.cloudkibo.com:3478?transport=udp"), username: "", password: ""))
        rtcICEarray.append(RTCICEServer(URI: NSURL(string: "turn:turn.cloudkibo.com:3478?transport=tcp"), username: "", password: ""))
        */
        rtcICEarray.append(RTCICEServer(URI: NSURL(string:"turn:45.55.232.65:3478?transport=udp"), username: "cloudkibo", password: "cloudkibo"))
        rtcICEarray.append(RTCICEServer(URI: NSURL(string:"turn:45.55.232.65:3478?transport=tcp"), username: "cloudkibo", password: "cloudkibo"))
        
        rtcICEarray.append(RTCICEServer(URI: NSURL(string:"stun:stun.l.google.com:19302"), username: "", password: ""))
        rtcICEarray.append(RTCICEServer(URI: NSURL(string:"stun:23.21.150.121"), username: "", password: ""))
        rtcICEarray.append(RTCICEServer(URI: NSURL(string:"stun:stun.anyfirewall.com:3478"), username: "", password: ""))
        rtcICEarray.append(RTCICEServer(URI: NSURL(string:"turn:turn.bistri.com:80?transport=udp"), username: "homeo", password: "homeo"))
        rtcICEarray.append(RTCICEServer(URI: NSURL(string:"turn:turn.bistri.com:80?transport=tcp"), username: "homeo", password: "homeo"))
        rtcICEarray.append(RTCICEServer(URI: NSURL(string:"turn:turn.anyfirewall.com:443?transport=tcp"), username: "webrtc", password: "webrtc")
        )
        
        
        print("rtcICEServerObj is \(rtcICEarray[0])")
        
        //self.createPeerConnectionObject()
        RTCPeerConnectionFactory.initializeSSL()
        rtcFact=RTCPeerConnectionFactory()
        
        if(socketObj.delegateWebRTC == nil)
        {
            socketObj.delegateWebRTC=self
        }
        self.stream=self.getLocalMediaStream()
        print("waiting now")
        
        

    }
    func getPeerConnection()->RTCPeerConnection!
    {
        return pc
    }
    
    func receivedChatMessage(message:String,username:String)
    {
        webmeetingModel.addChatMsg(message, usr: username)
        
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
        
        if(self.stream != nil)
        {
            self.pc.addStream(self.stream)
        }
        else
        {
            self.stream=self.getLocalMediaStream()
            self.pc.addStream(self.stream)
            
            
            ///////////////self.pc.addStream(self.getLocalMediaStream())
        }
    }

    
    func toggleAudioPressed(sender: AnyObject) {
        audioAction = !audioAction.boolValue
        self.stream!.audioTracks[0].setEnabled(audioAction)
    }
    
    func disconnect()
    {
        print("inside disconnect")
        /*if((self.pc) != nil)
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
                }
                
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    
                    
                    
                    self.dismissViewControllerAnimated(true, completion: { () -> Void in
                        
                    })
                    
                    
                })
            }
            
            
        }*/
    }

    func remoteDisconnected()
    {
        print("inside remote disconnected")
      /*  if((self.rtcVideoTrackReceived) != nil)
        {
            self.rtcVideoTrackReceived.removeRenderer(self.remoteView)
        }
        self.rtcVideoTrackReceived=nil
        if((remoteView) != nil)
        {self.remoteView.renderFrame(nil)}
        print("remote disconnected")*/
    }
    
    func getLocalMediaStream()->RTCMediaStream!
    {
        print("getlocalmediastream")
        
        self.stream=createLocalMediaStream()
        
        
        //print(rtcLocalMediaStream.audioTracks.count)
        
        // print(rtcLocalMediaStream.videoTracks.count)
        return stream
        
    }
    
    
    func createPeerConnectionObject()
    {//Initialise Peer Connection Object
        print("inside create peer conn object method")
        self.rtcMediaConst=RTCMediaConstraints(mandatoryConstraints: [RTCPair(key: "OfferToReceiveAudio", value: "true"),RTCPair(key: "OfferToReceiveVideo", value: "false")], optionalConstraints: nil)
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
        ////CreateAndAttachDataChannel()
    }
    
    
    
    func createLocalMediaStream()->RTCMediaStream
    {print("inside createlocalaudiotrack")
        
        var localStream:RTCMediaStream!
        
        localStream=rtcFact.mediaStreamWithLabel("ARDAMS")
        /////////////************^^^
        ///////var localVideoTrack=createLocalVideoTrack()
        
        /*self.rtcLocalVideoTrack = createLocalVideoTrack()
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
*/
        let audioTrack=rtcFact.audioTrackWithID("ARDAMSa0")
        audioTrack.setEnabled(true)
        let addedAudioStream=localStream.addAudioTrack(audioTrack)
        
        print("audio stream \(addedAudioStream)")
        //localStream.addAudioTrack(mediaAudioLabel!)
        print("localStreammmAudio ")
        print(localStream.description, terminator: "")
        //^^^localVideoTrack.addRenderer(localView)
        return localStream
    }
    
    func didReceiveRemoteAudioTrack(remoteAudioTrack:RTCAudioTrack)
    {
        print("didreceiveremoteaudiotrack")
        
        /////self.rtcVideoTrackReceived=remoteAudioTrack
       
        ///////HANDLE AUDIO RENDER UI
        
        /*self.rtcVideoTrackReceived.addRenderer(self.remoteView)
        self.remoteView.hidden=true // ^^^^newww
        if(self.screenshared==true){
            self.remoteView.hidden=false
        }
        
        self.localViewOutlet.addSubview(self.remoteView)
        
        self.localViewOutlet.updateConstraintsIfNeeded()
        self.remoteView.setNeedsDisplay()
        self.localViewOutlet.setNeedsDisplay()
        */
        
    }

    
    /*func didReceiveLocalStream(stream:RTCMediaStream)
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
    }*/
    

    func peerConnection(peerConnection: RTCPeerConnection!, addedStream stream: RTCMediaStream!) {
        print("added stream \(stream.debugDescription)")
        print(stream.videoTracks.count)
        print(stream.audioTracks.count)
        
        // dispatch_async(dispatch_get_main_queue(), {
        
        self.stream=stream
        if(stream.audioTracks.count>0)
        {print("remote audio track count is greater than one")
            let remoteAudioTrack=stream.audioTracks[0] as! RTCAudioTrack
            dispatch_async(dispatch_get_main_queue(), {
                
                self.didReceiveRemoteAudioTrack(remoteAudioTrack)
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
        
        var aa=JSON(["msgAudio":["by":currentID!,"to":otherID,"ice":cnd.object,"type":"ice"]])
        //print(aa.description)
        socketObj.socket.emit("msgAudio",["by":currentID!,"to":otherID,"ice":cnd.object,"type":"ice"])
        
        
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
            //SCREEN CLASS WILL HANDLE
            
           /* if(self.screenshared == true)
            {
                print("\(sdp.type) creatddddd")
                print(sdp.debugDescription)
                let sessionDescription=RTCSessionDescription(type: sdp.type!, sdp: sdp.description)
                
                self.pc.setLocalDescriptionWithDelegate(self, sessionDescription: sessionDescription)
                
                print(["by":currentID!,"to":otherID,"sdp":["type":sdp.type!,"sdp":sdp.description],"type":sdp.type!,"username":username!])
                
                socketObj.socket.emit("msg",["by":currentID!,"to":otherID,"sdp":["type":sdp.type!,"sdp":sdp.description],"type":sdp.type!,"username":username!])
                print("\(sdp.type) emitteddd")
            }
*/
            if(self.pc.localDescription == nil){
                print("\(sdp.type) creatddddd")
                print(sdp.debugDescription)
                let sessionDescription=RTCSessionDescription(type: sdp.type!, sdp: sdp.description)
                
                self.pc.setLocalDescriptionWithDelegate(self, sessionDescription: sessionDescription)
                
                ////print(["by":currentID!,"to":otherID,"sdp":["type":sdp.type!,"sdp":sdp.description],"type":sdp.type!,"username":username!])
                
                socketObj.socket.emit("msgAudio",["by":currentID!,"to":otherID,"sdp":["type":sdp.type!,"sdp":sdp.description],"type":sdp.type!,"username":username!])
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
    
    func socketReceivedMSGWebRTC(message:String,data:AnyObject!)
    {print("socketReceivedMSGWebRTC inside")
        switch(message){
        case "msgAudio":
            print("msgAudio received from socket")
            handlemsg(data)
            
        case "msg":
            print("error old msg received from socket")
            
        default:print("wrong socket msg received \(message)")
        }
    }
    
    func socketReceivedOtherWebRTC(message:String,data:AnyObject!)
    {
        print("socketReceivedOtherWebRTC inside")
        switch(message){
         
        case "peer.connected.new":
            handlePeerConnected(data)
            
        case "peer.connected":
            print("error old peer.connected received from socket")
           /// handlePeerConnected(data)
            
       //// case "conference.stream":
           //// handleConferenceStream(data)
            
            case "peer.disconnected":
            print("error old peer.disconnected received from socket")
            
        case "peer.disconnected.new":
            handlePeerDisconnected(data)
            self.delegateConferenceEnd.disconnectAll()
            
        case "conference.chat":
            print("\(data)")
            var chat=JSON(data)
            print(JSON(data))
            ///self.delegateChat=WebmeetingChatViewController
            print(chat[0]["message"].description)
            print(chat[0]["username"].description)
            print(chat[0]["message"].string)
            print(chat[0]["username"].string)
            self.receivedChatMessage(chat[0]["message"].description,username: "\(chat[0]["username"].description)")
        
        default:print("wrong socket other mesage received \(message)")
        }
        
    }
    
    func socketReceivedMessageWebRTC(message:String,data:AnyObject!)
    {print("socketReceivedMessageWebRTC inside")
        switch(message){
            
        case "message":
            handleMessage(data)
            
            
        default:print("wrong socket message received \(message)")
            
        }
    }
    
    
    
    func handlemsg(data:AnyObject!)
    {
        print("msgAudio reeived.. check if offer answer or ice")
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
            //////self.CreateAndAttachDataChannel()
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
        {//SCREEN SHARED CODE
            /*if(self.screenshared==true){
                print("answer received screen")
                var sessionDescription=RTCSessionDescription(type: msg[0]["type"].description, sdp: msg[0]["sdp"]["sdp"].description)
                self.pc.setRemoteDescriptionWithDelegate(self, sessionDescription: sessionDescription)
            }
*/
            
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
        print("received peer.connected.new Audio obj from server")
        
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
            /////////////////////self.CreateAndAttachDataChannel()
            self.addLocalMediaStreamToPeerConnection()
            print("peer attached stream")
            
            
            self.pc.createOfferWithDelegate(self, constraints: self.rtcMediaConst!)
        }
        
    }
    
    
    
    func handlePeerDisconnected(data:AnyObject!)
    {
        print("received peer.disconnected audio obj from server")
        
        //Both joined same room
        
        
        
        var datajson=JSON(data!)
        print(datajson.debugDescription)
        
        delegateDisconnect.disconnectAll()
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
    
    /*func handleConferenceStream(data:AnyObject!)
    {
        print("received conference.stream obj from server")
        var datajson=JSON(data!)
        print(datajson.debugDescription)
        /////////////////////////////////VIDEO AND SCREEN
        
       /* if(datajson[0]["username"].debugDescription != username! && datajson[0]["type"].debugDescription == "screen" && datajson[0]["action"].boolValue==true )
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
        }*/
    }
    */
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
                
                /*socketObj.socket.emitWithAck("init", ["room":CurrentRoomName,"username":username!])(timeoutAfter: 1500000000) {data in
                    print("room joined got ack")
                    var a=JSON(data)
                    print(a.debugDescription)
                    currentID=a[1].int!
                    joinedRoomInCall=msg[0]["room"].string!
                    print("current id is \(currentID)")
                    //}
                }*/
                socketObj.socket.emitWithAck("init.new", ["room":CurrentRoomName,"username":username!,"supportcall":""])(timeoutAfter: 1500000000) {data in
                    print("room joined got ack")
                    var a=JSON(data)
                    print(a.debugDescription)
                    currentID=a[1].int!
                    joinedRoomInCall=msg[0]["room"].string!
                    print("current id is \(currentID)")
                    //}
                }
            }
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
                socketObj.socket.emitWithAck("init.new", ["room":joinedRoomInCall,"username":username!])(timeoutAfter: 150000000) {data in
                    print("room joined by got ack")
                    var a=JSON(data)
                    print(a.debugDescription)
                    currentID=a[1].int!
                    print("current id is \(currentID)")
                    var aa=JSON(["msgAudio":["type":"room_name","room":roomname as String],"room":globalroom,"to":iamincallWith!,"username":username!])
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
            /////////////////////////////////self.dismissViewControllerAnimated(true, completion: nil)
            
            
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
                    var aa=JSON(["msgAudio":["type":"room_name","room":roomname as String],"room":globalroom,"to":iamincallWith!,"username":username!])
                    print(aa.description)
                    socketObj.socket.emit("message",aa.object)
                }}
            
        }
        
        
        
        
        
        
    }
    func channel(channel: RTCDataChannel!, didChangeBufferedAmount amount: UInt) {
        print("didChangeBufferedAmount \(amount)")
        
    }
    func channel(channel: RTCDataChannel!, didReceiveMessageWithBuffer buffer: RTCDataBuffer!) {
        print("didReceiveMessageWithBuffer")
        print(buffer.data.debugDescription)
        var channelJSON=JSON(buffer.data!)
        print(channelJSON.debugDescription)
        
    }
    func channelDidChangeState(channel: RTCDataChannel!) {
        print("channelDidChangeState")
        print(channel.debugDescription)
        
    }
    
}
protocol ConferenceRoomDisconnectDelegate:class
{
    func disconnectAll();
}
protocol WebMeetingChatDelegate:class
{
    func receivedChatMessage(message:String,username:String);
}