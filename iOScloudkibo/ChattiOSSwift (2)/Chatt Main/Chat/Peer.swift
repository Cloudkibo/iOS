//
//  Peer.swift
//  Chat
//
//  Created by Cloudkibo on 08/11/2015.
//  Copyright (c) 2015 MyAppTemplates. All rights reserved.
//

import Foundation

class Peer{
  
    var pc:RTCPeerConnection!
    var id:Int!
    var usrname:String!
    var isInitiator:Bool!
    var iamInCallWith:String!
    var callerName:String!
    var joinedRoomInCall:String!
    
}