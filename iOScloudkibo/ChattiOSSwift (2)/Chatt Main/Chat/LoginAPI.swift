//
//  LoginAPI.swift
//  Chat
//
//  Created by Cloudkibo on 13/08/2015.
//  Copyright (c) 2015 MyAppTemplates. All rights reserved.
//

import Foundation
import Alamofire


class LoginAPI{
    
    var socket:SocketIOClient
    init(url:String){
        socket=SocketIOClient(socketURL: "\(url)", opts: ["log": true])
        
    }
    func connect()
    {
        self.socket.on("connect") {data, ack in
            NSLog("connected to socket")
        }
        
        self.socket.connect()
        println(socket.connected)
    }
    
   
    
    func getSocket()->SocketIOClient{
        return self.socket
    }
    
    
}