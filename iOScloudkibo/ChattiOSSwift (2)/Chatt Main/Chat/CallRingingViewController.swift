//
//  CallRingingViewController.swift
//  Chat
//
//  Created by Cloudkibo on 22/10/2015.
//  Copyright (c) 2015 MyAppTemplates. All rights reserved.
//

import UIKit

class CallRingingViewController: UIViewController,RTCPeerConnectionDelegate,RTCSessionDescriptionDelegate {

  
    
    @IBOutlet weak var txtCallingDialing: UILabel!
    @IBOutlet weak var txtCallerName: UILabel!
    @IBAction func btnAcceptPressed(sender: AnyObject) {
        
        var mainICEServerURL:NSURL=NSURL(fileURLWithPath: Constants.MainUrl)!
        var rtcICEarray:[RTCICEServer]=[RTCICEServer]()
        var rtcICEobj=RTCICEServer(URI: mainICEServerURL, username: username!, password: password!)
        rtcICEarray.append(rtcICEobj)
        println("rtcICEServerObj is \(rtcICEarray[0])")
        var rtcFact:RTCPeerConnectionFactory=RTCPeerConnectionFactory.alloc()
        //rtcFact.peerConnectionWithICEServers(rtcICEarray, constraints: nil, delegate: self)
        var pc:RTCPeerConnection=RTCPeerConnection.alloc()
        pc.delegate=self
        
        println(pc.description)
       // var rtcMediaStream:RTCMediaStream=pc.localStreams[0] as! RTCMediaStream
        
        
        
        
        
        
        
        
        

        
    }
    @IBAction func btnRejectPressed(sender: AnyObject) {
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        
    
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

    func peerConnection(peerConnection: RTCPeerConnection!, addedStream stream: RTCMediaStream!) {
        
    
    }
    func peerConnection(peerConnection: RTCPeerConnection!, didOpenDataChannel dataChannel: RTCDataChannel!) {
        
    }
    func peerConnection(peerConnection: RTCPeerConnection!, gotICECandidate candidate: RTCICECandidate!) {
        
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
        
    }
}
