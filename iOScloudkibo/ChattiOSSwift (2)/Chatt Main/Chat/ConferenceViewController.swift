//
//  ConferenceViewController.swift
//  Chat
//
//  Created by Cloudkibo on 07/02/2016.
//  Copyright © 2016 MyAppTemplates. All rights reserved.
//

import UIKit
import Foundation

class ConferenceViewController: UIViewController {

    var rtcLocalVideoTrack:RTCVideoTrack!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //var mrv=MeetingRoomVideo()
        //mrv.delegateConference=self

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
   /* func didReceiveLocalVideoTrack(localVideoTrack:RTCVideoTrack)
    {
        /////////dispatch_async(dispatch_get_main_queue(), {
        self.rtcLocalVideoTrack=localVideoTrack
        self.rtcLocalVideoTrack.addRenderer(self.localView)
        self.localViewOutlet.addSubview(self.localView)
        self.localViewOutlet.updateConstraintsIfNeeded()
        self.localView.setNeedsDisplay()
        self.localViewOutlet.setNeedsDisplay()
        ///////////////})
    
    }}
*/
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    



}
