//
//  MeetingRoomScreen.swift
//  Chat
//
//  Created by Cloudkibo on 07/02/2016.
//  Copyright © 2016 MyAppTemplates. All rights reserved.
//

import Foundation
import AVFoundation
import Foundation
import SwiftyJSON

class MeetingRoomData:NSObject,RTCPeerConnectionDelegate,RTCSessionDescriptionDelegate,RTCDataChannelDelegate{
    
    var pc:RTCPeerConnection!
    var rtcMediaConst:RTCMediaConstraints!
    //////var rtcLocalVideoTrack:RTCVideoTrack!
    ///////var rtcRemoteVideoTrack:RTCVideoTrack!
    var stream:RTCMediaStream!
    //////var delegateConference:ConferenceScreenDelegate!
    var screenshared=false
    var rtcDataChannel:RTCDataChannel!
    //var rtcInit:RTCDataChannelInit!
    override init()
    {/*var mainICEServerURL:NSURL=NSURL(fileURLWithPath: Constants.MainUrl)
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
        rtcFact=RTCPeerConnectionFactory()*/
        
        //rtcInit=RTCDataChannelInit.init()
        super.init()
    }
    /*func joinRoom(var roomname:String,id:Int)
    {
    if(joinedRoomInCall == "")
    {
    print("inside accept call")
    /// roomname="test"
    print("conference name is\(ConferenceRoomName)")
    roomname=ConferenceRoomName
    
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
    else{print("you are already in room\(joinedRoomInCall))")
    }
    }*/
    
    
    func createPeerConnection()
    {
        //Initialise Peer Connection Object
        print("inside create peer conn object method")
        self.rtcMediaConst=RTCMediaConstraints(mandatoryConstraints: [RTCPair(key: "OfferToReceiveAudio", value: "false"),RTCPair(key: "OfferToReceiveVideo", value: "true")], optionalConstraints: nil)
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
    
   /* func createLocalVideoStream()->RTCMediaStream
    {print("inside createlocalvideostream")
        
        var localStream:RTCMediaStream!
        
        localStream=rtcFact.mediaStreamWithLabel("ARDAMS")
        
        self.rtcLocalVideoTrack = createLocalVideoTrack()
        if let lvt=self.rtcLocalVideoTrack
        {
            let addedVideo=localStream.addVideoTrack(self.rtcLocalVideoTrack)
            self.stream=localStream
            print("video stream \(addedVideo)")
            ////++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
            dispatch_async(dispatch_get_main_queue(), {
                //////self.didReceiveLocalVideoTrack(localVideoTrack)
                
                
                self.delegateConference.didReceiveLocalScreen(self.rtcLocalVideoTrack)
                //////self.didReceiveLocalVideoTrack()
            })
            
        }
        print("localStreammm ")
        print(localStream.description, terminator: "")
        //^^^localVideoTrack.addRenderer(localView)
        return localStream
    }*/
    
    
    /*
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
    /* func removeLocalMediaStreamFromPeerConnection()
    {
    
    //self.pc.removeStream(stream)
    
    if((self.rtcLocalVideoTrack) != nil)
    {print("remove localtrack renderer")
    self.rtcLocalVideoTrack.removeRenderer(self.localView)
    }
    /*if((self.rtcVideoTrackReceived) != nil)
    {print("remove remotetrack renderer")
    self.rtcVideoTrackReceived.removeRenderer(self.remoteView)
    }
    */
    print("out of removing remoterenderer")
    self.rtcLocalVideoTrack=nil
    self.rtcLocalVideoStream=nil
    
    
    }*/
    
    func sendOffer()
    {
        self.pc.createOfferWithDelegate(self, constraints: self.rtcMediaConst!)
    }
    
    
    func sendAnswer()
    {
        self.pc.createAnswerWithDelegate(self, constraints: self.rtcMediaConst)
        
    }
    
    func toggleScreen(videoAction:Bool,tempstream:RTCMediaStream!)
    {
        if(self.pc == nil)
        {
            createPeerConnection()
        }
        
        socketObj.socket.emit("conference.streamScreen", ["username":username!,"id":currentID!,"type":"screenAndroid","action":videoAction.boolValue])
        
    }
    
    
    
    func peerConnection(peerConnection: RTCPeerConnection!, addedStream stream1: RTCMediaStream!) {
        print("added remote data stream")
        /*if(stream1.videoTracks.count>0)
        {self.rtcRemoteVideoTrack=stream1.videoTracks[0] as! RTCVideoTrack
            dispatch_async(dispatch_get_main_queue(), {
                
                self.delegateConference.didReceiveRemoteScreen(self.rtcRemoteVideoTrack)
            })
            
        }*/
        
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
                
                socketObj.socket.emit("msgData",["by":currentID!,"to":otherID,"sdp":["type":sdp.type!,"sdp":sdp.description],"type":sdp.type!,"username":username!])
                print("\(sdp.type) emitteddd")
            }
            if(self.pc.localDescription == nil){
                print("\(sdp.type) creatddddd")
                print(sdp.debugDescription)
                let sessionDescription=RTCSessionDescription(type: sdp.type!, sdp: sdp.description)
                
                self.pc.setLocalDescriptionWithDelegate(self, sessionDescription: sessionDescription)
                
                ////print(["by":currentID!,"to":otherID,"sdp":["type":sdp.type!,"sdp":sdp.description],"type":sdp.type!,"username":username!])
                
                socketObj.socket.emit("msgData",["by":currentID!,"to":otherID,"sdp":["type":sdp.type!,"sdp":sdp.description],"type":sdp.type!,"username":username!])
                print("\(sdp.type) emitteddd")
            }
            
        }
        else
        {
            print("sdp created with error \(error.localizedDescription)")
        }
        
    }
    func peerConnection(peerConnection: RTCPeerConnection!, didOpenDataChannel dataChannel: RTCDataChannel!) {
        
        
    }
    func peerConnection(peerConnection: RTCPeerConnection!, didSetSessionDescriptionWithError error: NSError!) {
        
        print("inside didSetSessionDescriptionWithError")
        
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
    func peerConnection(peerConnection: RTCPeerConnection!, gotICECandidate candidate: RTCICECandidate!) {
        
        var cnd=JSON(["sdpMLineIndex":candidate.sdpMLineIndex,"sdpMid":candidate.sdpMid!,"candidate":candidate.sdp!])
        
        var aa=JSON(["msgData":["by":currentID!,"to":otherID,"ice":cnd.object,"type":"ice"]])
        //print(aa.description)
        socketObj.socket.emit("msgData",["by":currentID!,"to":otherID,"ice":cnd.object,"type":"ice"])
        
        
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
    
    
    
    
    
    func handlemsg(data:AnyObject!)
    {
        print("msgData reeived.. check if offer answer or ice")
        print(data.description)
        var msg=JSON(data)
        print(msg.description)
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
                self.createPeerConnection()
            }
            //^^^^^^^^^^^^^^^^^^ check this for second call already have localstream
            self.CreateAndAttachDataChannel()
            
            
            ////self.stream=self.createLocalVideoStream()
            //////pc.addStream(self.stream)
            
            
            //^^^^^^^^^^^^^^^^^^^^^^^newwwwww self.pc.addStream(self.getLocalMediaStream())
            otherID=msg[0]["by"].int!
            currentID=msg[0]["to"].int!
            
            print("...sending remotedesciption")
            if(msg[0]["username"].description != username! && self.pc.remoteDescription == nil){
                var sessionDescription=RTCSessionDescription(type: msg[0]["type"].description, sdp: msg[0]["sdp"]["sdp"].description)
                self.pc.setRemoteDescriptionWithDelegate(self, sessionDescription: sessionDescription)
            }
            
        }
        
        if(msg[0]["type"].string! == "answer" && msg[0]["by"].int != currentID)
        {
            if(self.screenshared==true){
                print("answer received video")
                var sessionDescription=RTCSessionDescription(type: msg[0]["type"].description, sdp: msg[0]["sdp"]["sdp"].description)
                self.pc.setRemoteDescriptionWithDelegate(self, sessionDescription: sessionDescription)
            }
            
            ///// if(isInitiator.description == "true")
            if(isInitiator.description == "true" && self.pc.remoteDescription == nil)
            {print("answer received data")
                var sessionDescription=RTCSessionDescription(type: msg[0]["type"].description, sdp: msg[0]["sdp"]["sdp"].description)
                self.pc.setRemoteDescriptionWithDelegate(self, sessionDescription: sessionDescription)
            }
            
        }
        if(msg[0]["type"].string! == "ice")
        {print("ice data received of other peer")
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
    
    
    
    func handleConferenceStream(data:AnyObject!)
    {
        var datajson=JSON(data!)
        print(datajson.debugDescription)
        /////////////////////////////////VIDEO AND SCREEN
        if(self.pc == nil)
        {
            createPeerConnection()
            
        }
        
        if(datajson[0]["username"].debugDescription != username! && datajson[0]["type"].debugDescription == "screen" && datajson[0]["action"].boolValue==true )
        {self.screenshared=true
            //Handle Screen sharing
            print("handle screen sharing data")
            self.pc.createOfferWithDelegate(self, constraints: self.rtcMediaConst)
        }
        
        
        
    }
    func addHandlers()
    {
        socketObj.socket.on("msgData"){data,ack in
            
            //self.delegateWebRTCVideo.socketReceivedMSGWebRTCVideo("msgData", data: data)
            
            //print("msgData reeived.. check if offer answer or ice")
            print("msgData received from socket")
            self.handlemsg(data)
            /*switch(message){
            
            // case "peer.connected.new":
            //   handlePeerConnected(data)
            
            
            case "peer.connected":
            print("error old peer.connected received from socket")
            /// handlePeerConnected(data)
            
            case "conference.streamVideo":
            handleConferenceStream(data)
            
            case "peer.disconnected":
            print("error old peer.disconnected received from socket")
            
            case "peer.disconnected.new":
            handlePeerDisconnected(data)
            
            default:print("wrong video socket other mesage received \(message)")
            }
            */
            
        }
        
        
        socketObj.socket.on("peer.connected.new"){data,ack in
            print("received peer.connected.new data obj from server")
            // self.delegateWebRTCVideo.socketReceivedOtherWebRTCVideo("peer.connected.new", data: data)
            //handlePeerConnected(data)
            //Both joined same room
            var datajson=JSON(data)
            print(datajson.debugDescription)
            
            if(datajson[0]["username"].description != username!){
                otherID=datajson[0]["id"].int
                iamincallWith=datajson[0]["username"].description
                isInitiator=true
            }
            //////optional
            if(self.pc == nil) //^^^^^^^^^^^^^^^^^^newwww tryyy
            {
                self.createPeerConnection()
            }
            self.CreateAndAttachDataChannel()
            ////self.addLocalMediaStreamToPeerConnection()
            //^^^^^^^^^^^^^^^^^^newwwww self.pc.addStream(self.rtcLocalMediaStream)
            print("peer created datachannel")
            
            
            self.pc.createOfferWithDelegate(self, constraints: self.rtcMediaConst!)
        
            
        }
        
        
        socketObj.socket.on("conference.streamData"){data,ack in
            
            print("received conference.streamData obj from server")
            self.handleConferenceStream(data)
            //self.delegateWebRTCVideo.socketReceivedOtherWebRTCVideo("conference.streamVideo", data: data)
            
        }
        
        /*socketObj.socket.on("peer.stream"){data,ack in
        print("received peer.stream obj from server")
        var datajson=JSON(data)
        print(datajson.debugDescription)
        
        }
        */
        socketObj.socket.on("peer.disconnected.new"){data,ack in
            print("received peer.disconnected obj from server")
            var datajson=JSON(data)
            print(datajson.debugDescription)
            //handlePeerDisconnected(data)
            
            //self.delegateWebRTCVideo.socketReceivedOtherWebRTCVideo("peer.disconnected.new", data: data)
            
        }
        
        
        socketObj.socket.on("message"){data,ack in
            print("received messageee11")
            // self.delegateWebRTCVideo.socketReceivedMessageWebRTCVideo("message",data: data)
            
            
            
        }
        
        
        
        
    }
    
    
    /*func removeLocalMediaStreamFromPeerConnection()
    {
        
        //self.pc.removeStream(stream)
        
        if((self.rtcLocalVideoTrack) != nil)
        {print("remove localtrack renderer")
            ////////// ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^self.rtcLocalVideoTrack.removeRenderer(self.localView)
        }
        /*if((self.rtcVideoTrackReceived) != nil)
        {print("remove remotetrack renderer")
        self.rtcVideoTrackReceived.removeRenderer(self.remoteView)
        }
        */
        print("out of removing remoterenderer")
        self.rtcLocalVideoTrack=nil
        ///self.rtcLocalVideoStream=nil
        
        
    }*/
    
    func sendDataBuffer(message:String,isb:Bool)
    {
        var my="{\"eventName\":\"data_msg\",\"data\":{\"file_meta\":{}}}"
        let buffer2 = RTCDataBuffer(
            data: (my.dataUsingEncoding(NSUTF8StringEncoding))!,
            isBinary: false
        )
        var sent=self.rtcDataChannel.sendData(buffer2)
        print("datachannel file sample METADATA sent is \(sent)")
        
        
        let buffer = RTCDataBuffer(
            data: (message.dataUsingEncoding(NSUTF8StringEncoding))!,
            isBinary: false
        )
        var sentFile=self.rtcDataChannel.sendData(buffer)
        print("datachannel file METADATA sent is \(sent)")
       
        
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
    func CreateAndAttachDataChannel()
    {
        
        
        // rtcInit.isNegotiated=true
        //rtcInit.isOrdered=true
        // rtcInit.maxRetransmits=30
        var rtcInit=RTCDataChannelInit.init()
        rtcDataChannel=pc.createDataChannelWithLabel("channel", config: rtcInit)
        if(rtcDataChannel != nil)
        {
            print("datachannel not nil")
            rtcDataChannel.delegate=self
            
            //////////////////
            var senttt=rtcDataChannel.sendData(RTCDataBuffer(data: NSData(base64EncodedString: "helloooo iphone sendind data through data channel", options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters),isBinary: true))
             print("datachannel message sent is \(senttt)")
            ///var test="hellooo"
            
           //// rtcDataChannel.sendData(RTCDataBuffer()
            
        }
        
    }
    func channel(channel: RTCDataChannel!, didChangeBufferedAmount amount: UInt) {
        print("didChangeBufferedAmount \(amount)")
        
    }
    var newjson:JSON!
    var myJSONdata:JSON!
    var chunknumber:Int!
    func channel(channel: RTCDataChannel!, didReceiveMessageWithBuffer buffer: RTCDataBuffer!) {
        
        //////buffer.data.length// make array of this size
        print("didReceiveMessageWithBuffer")
        //print(buffer.data.debugDescription)
        var channelJSON=JSON(buffer.data!)
       ///// print(channelJSON.debugDescription)
        //var bytes:[UInt8]
        var bytes=Array<UInt8>(count: buffer.data.length, repeatedValue: 0)
        
       // bytes.append(buffer.data.bytes)
        buffer.data.getBytes(&bytes, length: buffer.data.length)
       // print(bytes.debugDescription)
        var sssss=NSString(bytes: &bytes, length: buffer.data.length, encoding: NSUTF8StringEncoding)
        print(sssss!.description)
        //buffer.data.
        
        myJSONdata=JSON(sssss!)
        print("myjsondata is \(myJSONdata)")
        
        var oldjsombrackets=myJSONdata.description.stringByReplacingOccurrencesOfString("{", withString: "[")
        var new=oldjsombrackets.stringByReplacingOccurrencesOfString("}", withString: "]")
        print("new is \(new)")
        newjson=JSON(rawValue: new)!
        
        let count = buffer.data.length
        var doubles: [Double] = []
        ///let data = NSData(bytes: doubles, length: count)
        var result = [UInt8](count: count, repeatedValue: 0)
        buffer.data.getBytes(&result, length: count)
     //////   print(result.debugDescription)
       
        var strData=String(bytes)
        print("strdata")
        print(strData)
        var jsonStrData=JSON(strData)
        print("jsonStrData")
        print(jsonStrData.debugDescription)
       
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
            if(myJSONdata != "Speaking" && myJSONdata != "Silent" && myJSONdata["data"].isExists()){
             
                    if myJSONdata["data"]["chunk"].isExists() {
                        print("chunk number is \(myJSONdata["data"]["chunk"].rawValue)")
                        print(myJSONdata["data"][0]["browser"].debugDescription)
                        print(myJSONdata["data"][0]["chunk"].intValue)
                        chunknumber=myJSONdata["data"][0]["chunk"].intValue
                        requestchunk(chunknumber)
                    }
            }
           /* if(strData != "Silent" && strData != "Speaking" && newjson["data"].debugDescription != "null")
            { print("file chunk request received")
                print("strdata is \(strData)")
               // var jj=myJSONdata!["data"] as! JSON
                //var ch=jj["chunk"].int!
                //var ch = newjson.object as! JSON
                
                //print(ch)
               
            var a=newjson["data"] as! [JSON]
            for chunk in a
            {
                if(chunk["chunk"].int != nil)
                {
                    print("file chunk info received")
                    print(chunk["chunk"].int!)
                }
            }
            }
            */
            /////var chnum = [Int]()
            
           
        
        }
            /*
            if let dataFromString = message.body.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false) {
            let json = JSON(data: dataFromString)
            if let status = json["status"].string {
            */
            /*  do {
            let json = try NSJSONSerialization.JSONObjectWithData(sssss, options: .AllowFragments)
            
            if let blogs = json["data"] as? [[String: AnyObject]] {
            for blog in blogs {
            if let chunkNum = blog["chunk"] as? Int {
            print(chunkNum)
            chnum.append(chunkNum)
            }
            }
            }
            } catch {
            print("error serializing JSON: \(error)")
            }*/
            
            ////print(chnum) // ["Bloxus test", "Manila Test"]
            
            
            
            /* if(a. ["chunk"].int != nil)
            {
            //as! [[String: AnyObject]]
            
            
            print("file chunk info received")
            print(a!["chunk"].int!)
            }*/
            else
            {
                print("yes binary")
            }
        //}
        //else{
          //  print("not binary")
        //}
        /*
ByteBuffer data = buffer.data;
final byte[] bytes = new byte[ data.capacity() ];
data.get(bytes);

if(buffer.binary){

String strData = new String( bytes );
Log.w("FILE_TRANSFER", strData);

for(int i=0; i<bytes.length; i++)
fileBytesArray.add(bytes[i]);

*/

    }
    func requestchunk(num:Int!)
    {
        
    }
    func channelDidChangeState(channel: RTCDataChannel!) {
        print("channelDidChangeState")
       // print(channel.debugDescription)
        
    }
    
    func sendImage(imageData:NSData)
    {
        
        var imageSent=rtcDataChannel.sendData(RTCDataBuffer(data: imageData, isBinary: true))
        print("image senttttt \(imageSent)")

    }
    
}
/*
protocol ConferenceScreenDelegate:class
{
    func didReceiveRemoteScreen(remoteAudioTrack:RTCVideoTrack);
    //func didReceiveLocalVideoTrack(localVideoTrack:RTCVideoTrack);
    func didReceiveLocalScreen(remoteVideoTrack:RTCVideoTrack);
    
}*/