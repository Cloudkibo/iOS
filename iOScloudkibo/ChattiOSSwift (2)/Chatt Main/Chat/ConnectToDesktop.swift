//
//  ConnectToDesktop.swift
//  kiboApp
//
//  Created by Cloudkibo on 01/05/2017.
//  Copyright © 2017 MyAppTemplates. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class ConnectToDesktop{
    
    init()
    {
        
    }
    
    func startInitialDataLoad(phone:String,to_connection_id:String,from_connection_id:String,data:AnyObject,type:String)
    {
        print("inside loading initial data to desktop app")
       /* platform_room_message` with following payload:
        
        {
            phone : <phone number>
            to_connection_id : <id of the other platform>
            from_connection_id : <sender id>
            data: <data that we want to send>
            type: <type of the data>
        }*/
        var dataInput=["phone":phone,
            "to_connection_id" : to_connection_id,
            "from_connection_id" : from_connection_id,
            "data":data,
            "type": type] as [String : Any]
        socketObj.socket.emitWithAck("platform_room_message", dataInput).timingOut(after: 500000){data in
            
            print(data)
            print(JSON(data))
        }
        

    }
    
   
    

    
}
