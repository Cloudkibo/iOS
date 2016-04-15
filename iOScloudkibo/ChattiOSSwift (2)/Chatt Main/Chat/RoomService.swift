//
//  RoomService.swift
//  Chat
//
//  Created by Cloudkibo on 09/11/2015.
//  Copyright (c) 2015 MyAppTemplates. All rights reserved.
//

import Foundation
class RoomService{
    /*
    var peers:[Peer]=[]
    var streams:[RTCMediaStream]=[]
   
    init(id:String)    {
    
        var foundPeer=false
        var ind=0
        
        for var i=0;i<peers.count;i++
        {
            if(peers[i].getID()==id)
            {
                //peer already in list
                foundPeer=true;
                break
            }
        
        }
        //if not in list
        if(foundPeer==false)
        {
            peers.append(Peer(id: id, username: username!))
            //return peers[peers.count].pc
            
        }
        else{
           // return peers[ind].pc
        }
        
        
    }
    func joinRoom(roomname:String)
    {
        socketObj.socket.emit("init",["room": roomname, "username": username! ])
        
        /*
if (!connected) {
socket.emit('init', { room: r, username: username }, function (roomid, id) {
if(id === null){
alert('You cannot join conference. Room is full');
connected = false;
return;
}
currentId = id;
roomId = roomid;
});
connected = true;
}
*/


    }
    func makeOffer(id:String)
    {var foundPeer=false
        var ind=0
        for var i=0;i<peers.count;i++
        {
            if(peers[i].getID()==id)
            {
                //peer already in list
                foundPeer=true;
                ind=i
                break
            }
        }
        
        //if not in list
        if(foundPeer)
        {
            peers[ind].createOffer()
        }
        
        
    }
    
    */
}
