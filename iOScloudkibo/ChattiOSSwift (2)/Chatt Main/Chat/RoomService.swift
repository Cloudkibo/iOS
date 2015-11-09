//
//  RoomService.swift
//  Chat
//
//  Created by Cloudkibo on 09/11/2015.
//  Copyright (c) 2015 MyAppTemplates. All rights reserved.
//

import Foundation
class RoomService{
    
    var peers:[Peer]!
    var streams:[RTCMediaStream]=[]
   
    func getPeerConnection(var id:String)
    {
        for var i=0;i<peers.count;i++
        {
            if(peers[i].getID()==id)
            {
                //peer already in list
            }
        }
    }
    func joinRoom(var roomname:String)
    {
        
        
    }
    func makeOffer()
    {
        //socket.emit('msg', { by: currentId, to: id, sdp: sdp, type: 'offer', username: username });
    }
    
    
}
