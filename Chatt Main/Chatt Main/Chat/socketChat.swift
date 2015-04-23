//
//  socketChat.swift
//  Chat
//
//  Created by Cloudkibo on 23/04/2015.
//  Copyright (c) 2015 MyAppTemplates. All rights reserved.
//

import Foundation
import Socket_IO_Client_Swift

var io = require('socket.io')();
io.on('connection', function(socket){});
io.listen(3000);


let socket = SocketIOClient(socketURL: "localhost:8080")

socket.on("connect") {data, ack in
    println("socket connected")
}

socket.on("currentUser") {data, ack in
    if let cur = data?[0] as? Double {
        socket.emitWithAck("canUpdate", cur)(timeout: 0) {data in
            socket.emit("update", ["user": cur + 2.50])
        }
        
        ack?("Got your userAcount", "hi")
    }
}

// Connect
socket.connect()