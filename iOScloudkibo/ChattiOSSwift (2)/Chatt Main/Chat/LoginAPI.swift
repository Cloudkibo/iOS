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
    init(){
        socket=SocketIOClient(socketURL: "")
    }
    
    func connect(url:String){
        socket=SocketIOClient(socketURL: "\(url)")
    }
    
    func getSocket()->SocketIOClient{
        return self.socket
    }
    
    
}