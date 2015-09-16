//
//  NetworkingLibAlamofire.swift
//  Chat
//
//  Created by Cloudkibo on 16/09/2015.
//  Copyright (c) 2015 MyAppTemplates. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class NetworkingLibAlamofire{
    
    init()
    {
        
    }
    func sendRequestGetWithoutParameters(method:String,url:String)
    {
        var dataMy:JSON="[]"
        var errorMy:JSON="[]"
        Alamofire.request(.GET,"\( url)").responseJSON{
            request1, response1, data1, error1 in
            
            //===========INITIALISE SOCKETIOCLIENT=========
            dispatch_async(dispatch_get_main_queue(), {
                
                //self.dismissViewControllerAnimated(true, completion: nil);
                /// self.performSegueWithIdentifier("loginSegue", sender: nil)
                
                if response1?.statusCode==200 {
                    println("Request success")
                    //dataMy=JSON(data1!)
                    //println(dataMy.description)

                
                }
                else
                {
                    println("request failed")
                   //errorMy=JSON(error1!)
                    //println(errorMy.description)

                }
            })
        }
     //return dataMy
    }
    
    
    func sendRequestPOST(method:String,url:String,parameters1:[String:String])
        {
            var dataMy:JSON="[]"
            var errorMy:JSON="[]"
            Alamofire.request(.POST,"\(url)",parameters:parameters1).responseJSON{
                request1, response1, data1, error1 in
                
                //===========INITIALISE SOCKETIOCLIENT=========
                dispatch_async(dispatch_get_main_queue(), {
                    
                    //self.dismissViewControllerAnimated(true, completion: nil);
                    /// self.performSegueWithIdentifier("loginSegue", sender: nil)
                    
                    if response1?.statusCode==200 {
                        //println("got user success")
                        println("Request success")
                        
                        //dataMy=JSON(data1!)
                        //println(dataMy.description)
                        
                    }
                    else
                    {
                        println("request failed")

                        //errorMy=JSON(error1!)
                       // println(errorMy.description)
                    }
                })
            }
            //return dataMy
    }
    
    
}