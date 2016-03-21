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
    var pc:RTCPeerConnection!
    var rtcMediaConst:RTCMediaConstraints!
    //////var rtcLocalVideoTrack:RTCVideoTrack!
    ///////var rtcRemoteVideoTrack:RTCVideoTrack!
    var stream:RTCMediaStream!
    var delegateConferenceEnd:ConferenceEndDelegate!
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
        bytesarraytowrite=Array<UInt8>()
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
            print("received peer.disconnected.new obj from server")
            var datajson=JSON(data)
            print(datajson.debugDescription)
            self.delegateConferenceEnd.disconnectAll()
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
    var strData:String!
    
    func channel(channel: RTCDataChannel!, didReceiveMessageWithBuffer buffer: RTCDataBuffer!) {
        
       
        
        ///var dictttt=buffer.data.dictionaryWithValuesForKeys(["event_name","data"])
        ///print("dicttt is \(dictttt)")
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
                        requestchunk(chunknumbertorequest)
                        
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
                        requestchunk(chunknumbertorequest)
                        
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


    }
    func requestchunk(num:Int!)
    {

    }
    func channelDidChangeState(channel: RTCDataChannel!) {
        print("channelDidChangeState \(channel.state)")
        

        /*if(channel==nil || rtcDataChannel==nil)
        {
            var rtcInit=RTCDataChannelInit.init()
            rtcDataChannel=pc.createDataChannelWithLabel("channel", config: rtcInit)
            if(rtcDataChannel != nil)
            {
                print("datachannel not nil")
                rtcDataChannel.delegate=self
                
            }
            
        }*/
       // print(channel.debugDescription)
       /* var rtcInit=RTCDataChannelInit.init()
        rtcDataChannel=pc.createDataChannelWithLabel("channel", config: rtcInit)
        if(rtcDataChannel != nil)
        {
            print("datachannel not nil")
            rtcDataChannel.delegate=self
            
        }*/

    }

    func sendImage(imageData:NSData)
    {
        
        //var test="{length:\(imageData.length)}"
        

        //dispatch_async(dispatch_get_main_queue(), { () -> Void in
        var buf=Double(rtcDataChannel.bufferedAmount).value
        var buflimit:Int64=16000000
        
        //if(buf < buflimit.value)
       // {
        var imageSent=self.rtcDataChannel.sendData(RTCDataBuffer(data: imageData, isBinary: true))
            print("image senttttt \(imageSent)")
        //}
        
        //})
       
    }
    func sharefile(fileurl:String!)
    {
        myfid++;
        let fm = NSFileManager.defaultManager()
        let dirPaths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let docsDir1 = dirPaths[0]
        var documentDir=docsDir1 as NSString
        /*var filePath=documentDir.stringByAppendingPathComponent("file1.txt")
        fm.createFileAtPath(filePath, contents: nil, attributes: nil)*/
        /*var filePath=documentDir.stringByAppendingPathComponent("file3.pdf")
        print(filePath)
        var s=fm.createFileAtPath(filePath, contents: NSData(contentsOfFile: "This is a test file on iphone.sdfsdkmfnskdfnjsdfnsjdfnsjkdnfsjdnfsjkdfnjksdfnsjdnfskjdnfjsnfjksdnfjsdknfnf sdfnsjdfnsjkf sdf sdjkfnsdf dsf sdf sdfsbdfjsd fksdf sdbfsf sdnf sdkf sndm fsdf sdf sdf dmnsf sdhf sdnmf sdf msnd snd fsdbnf nds fsnd fnsdbfndsf bdnsbfnsdbfnsdbfnsdbfnds fnbdsf nsdf bnsdf nsbdf nsdf nsdfb dhsbfdhsbdnsbfhsdbf sdhfb dnsf vdhb dsbvshd fbdnsbhdsf dbfvdnbfhdbfhdsfbhsdfhsdfhsdfbsdhbfhsdfhsjdfvhsdjfhsfhsfhjsfhsfvhsfvshvhjdfvhdsfvdhjsfvhdsfhdsfvhjsdvfhdjsfhsdfvhsdvfhjsdfv"), attributes: nil)
        print("file created \(s)")
        */
        ///filePathImage=documentDir.stringByAppendingPathComponent("file3.pdf")
        
       /////////newwwww filePathImage=documentDir.stringByAppendingPathComponent("cloudkibo.jpg")
        //filePathImage="file:///private/var/mobile/Containers/Data/Application/F4137E3A-02E9-4A4D-8F20-089484823C88/tmp/iCloud.MyAppTemplates.cloudkibo-Inbox/regularExpressions.html"
        filePathImage=fileurl!
        print(filePathImage)
        var furl=NSURL(string: filePathImage)
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
        
        fileSize=fileSizeNumber.integerValue
        
        //FILE METADATA size
        print(fileSize)
        
        /////let text2 = fm.contentsAtPath(filePath)
        ////////print(text2)
        /////////print(JSON(text2!))
        fileContents=fm.contentsAtPath(filePathImage)!
        var filecontentsJSON=JSON(fm.contentsAtPath(filePathImage)!)
        print(filecontentsJSON)
        var mjson="{\"file_meta\":{\"name\":\"\(fname!)\",\"size\":\"\(fileSize.description)\",\"filetype\":\"\(ftype)\",\"browser\":\"firefox\",\"uname\":\"\(username!)\",\"fid\":\(myfid),\"senderid\":\(currentID!)}}"
        var fmetadata="{\"eventName\":\"data_msg\",\"data\":\(mjson)}"
        self.sendDataBuffer(fmetadata,isb: false)
        socketObj.socket.emit("conference.chat", ["message":"You have received a file. Download and Save it.","username":username!])
        
       
    }

}
protocol ConferenceEndDelegate:class
{
    func disconnectAll();
}
/*
protocol ConferenceScreenDelegate:class
{
    func didReceiveRemoteScreen(remoteAudioTrack:RTCVideoTrack);
    //func didReceiveLocalVideoTrack(localVideoTrack:RTCVideoTrack);
    func didReceiveLocalScreen(remoteVideoTrack:RTCVideoTrack);
    
}*/