//
//  CallRingingViewController.swift
//  Chat
//
//  Created by Cloudkibo on 22/10/2015.
//  Copyright (c) 2015 MyAppTemplates. All rights reserved.
//

import UIKit
import Foundation
import SwiftyJSON
import AVFoundation
import SQLite
class CallRingingViewController: UIViewController//RTCPeerConnectionDelegate,RTCSessionDescriptionDelegate
{

   // var rtcFact:RTCPeerConnectionFactory!
    //var pc:RTCPeerConnection!
    //var rtcFact:RTCPeerConnectionFactory
    //@IBOutlet weak var localView: RTCEAGLVideoView!
    
    @IBOutlet weak var localView: RTCEAGLVideoView!
    @IBOutlet weak var txtCallingDialing: UILabel!
    @IBOutlet weak var txtCallerName: UILabel!
    var iamincall:Bool=false
    var othersideringing:Bool=false
    var callerName:String!
    //var data:JSON
    var currentusernameretrieved:String!
    
    
    @IBAction func btnAcceptPressed(sender: AnyObject) {
        areYouFreeForCall=false
        iamincall=true
        isInitiator=false
      /////^^  iamincallWith=txtCallerName.text!
        if(txtCallerName.text! == username!)
        {
        //i am not initiator
        isInitiator=false
            
            //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% neww june 2016
            iamincallWith=txtCallerName.text!
        }
        else
        {   iamincallWith=txtCallerName.text!
            
            //^^^socketObj.sendMessagesOfMessageType("Accept Call")
        }
        
        var nameOfCaller=""
        var allcontacts=sqliteDB.allcontacts
        //var contactsKibo=sqliteDB.contactslists
        
        
        let phone = Expression<String>("phone")
        let usernameFromDb = Expression<String?>("username")
        let name = Expression<String?>("name")
        
       nameOfCaller=txtCallerName.text!
        //do
        //{allkiboContactsArray = Array(try sqliteDB.db.prepare(contactsKibo))
        do{
            for all in try sqliteDB.db.prepare(allcontacts) {
                if(all[phone]==txtCallerName.text!) //if we found contact in our AddressBook
                    
                {
                    //Matched phone number. Got contact
                    if(all[name] != "" || all[name] != nil)
                    {
                        nameOfCaller=all[name]!
                        //cell.contactName?.text=all[name]
                    }}}}
        catch
        {
            print("error here 111")
        }
        
        sqliteDB.saveCallHist(nameOfCaller, dateTime1: NSDate().debugDescription, type1: "Incoming")
        
        
        
       let next = self.storyboard?.instantiateViewControllerWithIdentifier("MainV2") as! VideoViewController
        
        self.presentViewController(next, animated: true, completion: {
            var aa=JSON(["to":iamincallWith!,"msg":["callerphone":iamincallWith,"calleephone":username!,"status":"callaccepted","type":"call"]])
            
            //print(aa.description)
            socketObj.socket.emit("logClient","IPHONE-LOG: \(aa.object)")
            socketObj.socket.emit("message",aa.object)
            
            /////socketObj.sendMessagesOfMessageType("Accept Call")
                    })


        
           }
    @IBAction func btnRejectPressed(sender: AnyObject) {
        areYouFreeForCall=true
        if(iamincallWith != nil && iamincallWith != "")
        {
            socketObj.socket.emit("noiambusy",["mycaller" :iamincallWith!, "me":username!])
            
            var nameOfCaller=""
            var allcontacts=sqliteDB.allcontacts
            //var contactsKibo=sqliteDB.contactslists
            
            
            let phone = Expression<String>("phone")
            let usernameFromDb = Expression<String?>("username")
            let name = Expression<String?>("name")
            
            nameOfCaller=iamincallWith
            //do
            //{allkiboContactsArray = Array(try sqliteDB.db.prepare(contactsKibo))
            do{
                for all in try sqliteDB.db.prepare(allcontacts) {
                    if(all[phone]==iamincallWith) //if we found contact in our AddressBook
                        
                    {
                        //Matched phone number. Got contact
                        if(all[name] != "" || all[name] != nil)
                        {
                            nameOfCaller=all[name]!
                            //cell.contactName?.text=all[name]
                        }}}}
            catch
            {
                print("error here 111")
            }
            
            sqliteDB.saveCallHist(nameOfCaller, dateTime1: NSDate().debugDescription, type1: "Incoming")
        
            
            
        }
        
        dismissViewControllerAnimated(true, completion: {
        iamincallWith=""
            self.othersideringing=false
            if(joinedRoomInCall != "")
            {
            socketObj.socket.emit("message", ["msg":"hangup"])
            }
        })
    }
    
    override func viewWillAppear(animated: Bool) {
        
        if(endedCall==true)
        {
            socketObj.socket.emit("logClient","IPHONE-LOG: ended call, going back from call ringing view")
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            
            
            
            self.dismissViewControllerAnimated(true, completion: { () -> Void in
                endedCall=false
            })
            
            
        })
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        socketObj.socket.on("message"){data,ack in
            print("received messageee")
            var msg=JSON(data)
            var missedMsg=""
            var nameOfCaller=""
            print(msg.debugDescription)
            var mmm=msg[0].debugDescription
            let start = mmm.startIndex
            
            let end = mmm.characters.indexOf(":")?.advancedBy(1)
            
            if (end != nil) {
                missedMsg = mmm[start...end!]
                print(missedMsg)
                var startNameChar=end
                var lastChar=missedMsg.characters.indices.last
                nameOfCaller=mmm[startNameChar!...lastChar!]
                print(nameOfCaller)
            }
            if(missedMsg == "Missed Incoming Call: ")
            {print("inside missed notification")
                let todoItem = NotificationItem(otherUserName: nameOfCaller, message: "you received a mised call", type: "missed call", UUID: "111", deadline: NSDate())
                notificationsMainClass.sharedInstance.addItem(todoItem) // schedule a local notification to persist this item
                
            }
        }
        
        //on othersideringing var iamincall:Bool=false var othersideringing:Bool=false var callerName:String!

        /*socketObj.socket.on("othersideringing"){data,ack in
            print("otherside ringing")
            var msg=JSON(data)
            self.othersideringing=true;
            print(msg.debugDescription)
            self.callerName=msg[0]["callee"].string!
            iamincallWith=msg[0]["callee"].string!
            
            print("callee is \(self.callerName)")
        }*/
        
    
        // Do any additional setup after loading the view.
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    func createLocalMediaStream()->RTCMediaStream
    {
        var mediaStreamLabel:String!
        var mediaAudioLabel:String!
        mediaStreamLabel="cloudkiboStream"
        mediaAudioLabel="cloudkiboaudio"
        var localStream:RTCMediaStream!
        //localStream=rtcFact.mediaStreamWithLabel(mediaStreamLabel!)
        
        var localVideoTrack:RTCVideoTrack!=createLocalVideoTrack()
        if let lvt=localVideoTrack
        {
            localStream.addVideoTrack(localVideoTrack)
        
            
        }
        //localStream.addAudioTrack(rtcFact.audioTrackWithID(mediaAudioLabel!))
        print("localStreammm ")
        print(localStream.description)
        localVideoTrack.addRenderer(localView)
        return localStream
        /*
        
RTCMediaStream* localStream = [_factory mediaStreamWithLabel:@"ARDAMS"];

RTCVideoTrack *localVideoTrack = [self createLocalVideoTrack];
if (localVideoTrack) {
[localStream addVideoTrack:localVideoTrack];
[_delegate appClient:self didReceiveLocalVideoTrack:localVideoTrack];
}

[localStream addAudioTrack:[_factory audioTrackWithID:@"ARDAMSa0"]];
return localStream;
*/

    }

    func createLocalVideoTrack()->RTCVideoTrack
    {
        var rtcVideoTrack:RTCVideoTrack
        var cameraID:NSString!
        for aaa in AVCaptureDevice.devicesWithMediaType(AVMediaTypeVideo)
        {
            if aaa.position==AVCaptureDevicePosition.Front
            {
                print(aaa.description)
                print(aaa.deviceCurrentTime)
                print(aaa.localizedName!)
                //print(aaa.localStreams.description!)
                //print(aaa.localizedModel!)
                cameraID=aaa.localizedName!
                print("got front camera")
                //break
            }
            
        }
        if cameraID==nil
            
        {print("failed to get camera")}
        
        //AVCaptureDevice
        var rtcVideoCapturer=RTCVideoCapturer(deviceName: cameraID! as String)
        print(rtcVideoCapturer.description)
        var rtcMediaConst=RTCMediaConstraints(mandatoryConstraints: nil, optionalConstraints: nil)
        var rtcVideoSource=RTCVideoSource.alloc()
        rtcVideoSource=rtcFact.videoSourceWithCapturer(rtcVideoCapturer, constraints: rtcMediaConst)
        rtcVideoTrack=rtcFact.videoTrackWithID("sss", source: rtcVideoSource)
        
        return rtcVideoTrack

    }
    */

   /* func peerConnection(peerConnection: RTCPeerConnection!, addedStream stream: RTCMediaStream!) {
        print("added stream")
    
    }
    func peerConnection(peerConnection: RTCPeerConnection!, didOpenDataChannel dataChannel: RTCDataChannel!) {
        
    }
    func peerConnection(peerConnection: RTCPeerConnection!, gotICECandidate candidate: RTCICECandidate!) {
        print("got ice candidate")
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
    
    func peerConnection(peerConnection: RTCPeerConnection!, didCreateSessionDescription sdp: RTCSessionDescription!, error: NSError!) {
        
    }
    func peerConnection(peerConnection: RTCPeerConnection!, didSetSessionDescriptionWithError error: NSError!) {
        
    }*/
}
