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
    
    var token:String=""
    init(){
        
    }
    

func performLogin(url:String,params:[String:String]){
    var responseObj=Alamofire.request(.POST, "\(url)", parameters: params)
        .response { request, response, data, error in
           // println(request)
            println("response is \(response)")
            self.token=NSString(data: data!, encoding: NSUTF8StringEncoding)! as String
           // println(error)
          //  println("......\(response?.statusCode)")
            
    }
  //   println("result is \(responseObj)")
    //return responseObj.response?.statusCode
    }
    
    
    
}