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
    var dataMy:JSON="[]"
    var errorMy:JSON="[]"

    init()
    {
        
    }
    func sendRequestGetWithoutParameters(method:String,url:String)->JSON
    {
        println(url)
        
                Alamofire.request(.GET,"\(url)").responseJSON{
            request1, response1, data1, error1 in
            
            //===========INITIALISE SOCKETIOCLIENT=========
            dispatch_async(dispatch_get_main_queue(), {
                
                //self.dismissViewControllerAnimated(true, completion: nil);
                /// self.performSegueWithIdentifier("loginSegue", sender: nil)
                
                if response1?.statusCode==200 {
                    println("Request success")
                    self.dataMy=JSON(data1!)
                    //println(data1!.description)
                    //println(self.dataMy)
                    //println(dataMy.description)

                
                }
                else
                {
                    println("request failed")
              self.errorMy=JSON(error1!)
                    //println(errorMy.description)

                }
            })
        }
     return self.dataMy
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
    
    
    func getToken(userid:String?,passw:String?)
    {
        
        var url=Constants.MainUrl+Constants.authentictionUrl
        //KeychainWrapper.setString(txtForPassword.text!, forKey: "password")
        var param:[String:String]=["username": userid!,"password":passw!]
        Alamofire.request(.POST,"\(url)",parameters: param).response{
            request, response, data, error in
            println(error)
            
            if response?.statusCode==200
                
            {
                println("login success")
               // self.labelLoginUnsuccessful.text=nil
                //self.gotToken=true
                
                //======GETTING REST API TO GET CURRENT USER=======================
                
                var userDataUrl=Constants.MainUrl+Constants.getCurrentUser
                //let index: String.Index = advance(self.AuthToken.startIndex, 10)
                
                //======================STORING Token========================
                let jsonLogin = JSON(data: data!)
                let token = jsonLogin["token"]
                KeychainWrapper.setString(token.string!, forKey: "access_token")
                AuthToken=token.string!
            }
            else
            {
                
                println("Login failed")
            }
        }

    }
    
    func rtt()
    {
        var url=Constants.MainUrl+Constants.authentictionUrl
        //KeychainWrapper.setString(txtForPassword.text!, forKey: "password")
        var param:[String:String]=["username": username!,"password": password!]
        Alamofire.request(.POST,"\(url)",parameters: param).response{
            request, response, data, error in
            println(error)
            
            if response?.statusCode==200
                
            {
                println("Refresh Token success")
                
                
                //======GETTING REST API TO GET CURRENT USER=======================
                
                
                //======================STORING Token========================
                let jsonLogin = JSON(data: data!)
                let token = jsonLogin["token"]
                KeychainWrapper.setString(token.string!, forKey: "access_token")
                AuthToken=token.string!
            }
            else
            {
                println("Token refresh failed........")
            }
        }
    }
    
    func refrToken()
    {
        var url=Constants.MainUrl+Constants.authentictionUrl
        //KeychainWrapper.setString(txtForPassword.text!, forKey: "password")
        var param:[String:String]=["username": username!,"password":password!]
        Alamofire.request(.POST,"\(url)",parameters: param).response{
            request, response, data, error in
            println(error)
            
            if response?.statusCode==200
                
            {
                println("login success")
               // self.labelLoginUnsuccessful.text=nil
               // self.gotToken=true
                
                //======GETTING REST API TO GET CURRENT USER=======================
                
                var userDataUrl=Constants.MainUrl+Constants.getCurrentUser
                //let index: String.Index = advance(self.AuthToken.startIndex, 10)
                
                //======================STORING Token========================
                let jsonLogin = JSON(data: data!)
                let token = jsonLogin["token"]
                KeychainWrapper.setString(token.string!, forKey: "access_token")
                AuthToken=token.string!
                
                //========GET USER DETAILS===============
                var getUserDataURL=userDataUrl+"?access_token="+AuthToken!
                Alamofire.request(.GET,"\(getUserDataURL)").validate(statusCode: 200..<300).responseJSON{
                    request1, response1, data1, error1 in
                    
                    //===========INITIALISE SOCKETIOCLIENT=========
                    dispatch_async(dispatch_get_main_queue(), {
                        
                        //self.dismissViewControllerAnimated(true, completion: nil);
                        /// self.performSegueWithIdentifier("loginSegue", sender: nil)
                        
                        if response1?.statusCode==200 {
                            println("got user success")
                           // self.gotToken=true
                            var json=JSON(data1!)
                            //KeychainWrapper.setData(data1!, forKey: "loggedUserObj")
                            //loggedUserObj=json(loggedUserObj)
                            loggedUserObj=json
                            ///KeychainWrapper.setString(JSONStringify(json, prettyPrinted: true), forKey:"loggedIDKeyChain")
                            //===========saving username======================
                            KeychainWrapper.setString(json["username"].string!, forKey: "username")
                            KeychainWrapper.setString(json["firstname"].string!+" "+json["lastname"].string!, forKey: "loggedFullName")
                            KeychainWrapper.setString(json["phone"].string!, forKey: "loggedPhone")
                            KeychainWrapper.setString(json["email"].string!, forKey: "loggedEmail")
                            KeychainWrapper.setString(json["_id"].string!, forKey: "_id")
                            //KeychainWrapper.setString(self.txtForPassword.text!, forKey: "password")
                            
                            
                            socketObj.addHandlers()
                            
                            var jsonNew=JSON("{\"room\": \"globalchatroom\",\"user\": {\"username\":\"sabachanna\"}}")
                            //socketObj.socket.emit("join global chatroom", ["room": "globalchatroom", "user": ["username":"sabachanna"]]) WORKINGGG
                            
                            socketObj.socket.emit("join global chatroom",["room": "globalchatroom", "user": json.object])
                            
                            println(json["_id"])
                            
                            
                            
                            //...........
                            /*  let stmt = sqliteDB.db.prepare("SELECT * FROM accounts")
                            println(stmt.columnNames)
                            for row in stmt {
                            println("...................... firstname: \(row[1]), email: \(row[3])")
                            // id: Optional(1), email: Optional("alice@mac.com")
                            }*/
                            
                        } else {
                            
                            
                            println("GOT USER FAILED")
                        }
                    })
                    
                   
                }
                
            }
                
            else
            {
                KeychainWrapper.removeObjectForKey("password")
                println("login failed")
                
            }
        }

    }
    
}