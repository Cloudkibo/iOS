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
import UIKit

class NetworkingLibAlamofire{
    var dataMy:JSON="[]"
    var errorMy:JSON="[]"

    init()
    {
        
    }
    func sendRequestGetWithoutParameters(method:String,url:String)->JSON
    {
        print(url)
        
        Alamofire.request(.GET,"\(url)").responseJSON{response in
            var response1=response.response
            var request1=response.request
            var data1=response.data
            var error1=response.result.error
            
            //===========INITIALISE SOCKETIOCLIENT=========
            dispatch_async(dispatch_get_main_queue(), {
                
                //self.dismissViewControllerAnimated(true, completion: nil);
                /// self.performSegueWithIdentifier("loginSegue", sender: nil)
                
                if response1?.statusCode==200 {
                    print("Request success")
                    self.dataMy=JSON(data1!)
                    //print(data1!.description)
                    //print(self.dataMy)
                    //print(dataMy.description)

                
                }
                else
                {
                    print("request failed")
              self.errorMy=JSON(error1!)
                    //print(errorMy.description)

                }
            })
        }
     return self.dataMy
    }
    
    
    func sendRequestPOST(method:String,url:String,parameters1:[String:String])
        {
            var dataMy:JSON="[]"
            var errorMy:JSON="[]"
            Alamofire.request(.POST,"\(url)",parameters:parameters1).responseJSON{response in
                var response1=response.response
                var request1=response.request
                var data1=response.data
                var error1=response.result.error
                //===========INITIALISE SOCKETIOCLIENT=========
                dispatch_async(dispatch_get_main_queue(), {
                    
                    //self.dismissViewControllerAnimated(true, completion: nil);
                    /// self.performSegueWithIdentifier("loginSegue", sender: nil)
                    
                    if response1?.statusCode==200 {
                        //print("got user success")
                        print("Request success")
                        
                        //dataMy=JSON(data1!)
                        //print(dataMy.description)
                        
                    }
                    else
                    {
                        print("request failed")

                        //errorMy=JSON(error1!)
                       // print(errorMy.description)
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
            print(error)
            
            if response?.statusCode==200
                
            {
                print("login success")
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
                
                print("Login failed")
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
            print(error)
            
            if response?.statusCode==200
                
            {
                print("Refresh Token success")
                
                
                //======GETTING REST API TO GET CURRENT USER=======================
                
                
                //======================STORING Token========================
                let jsonLogin = JSON(data: data!)
                let token = jsonLogin["token"]
                KeychainWrapper.setString(token.string!, forKey: "access_token")
                AuthToken=token.string!
            }
            else
            {
                print("Token refresh failed........")
            }
        }
    }
    
    func refrToken()
    {
        var url=Constants.MainUrl+Constants.authentictionUrl
        //KeychainWrapper.setString(txtForPassword.text!, forKey: "password")
        
        //dismiss and show login screen
        var param:[String:String]=["username": username!,"password":password!]
        Alamofire.request(.POST,"\(url)",parameters: param).response{
            request, response, data, error in
            print(error)
            
            if response?.statusCode==200
                
            {
                print("login success")
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
                Alamofire.request(.GET,"\(getUserDataURL)").validate(statusCode: 200..<300).responseJSON{response in
                    var response1=response.response
                    var request1=response.request
                    var data1=response.data
                    var error1=response.result.error
                    
                    //===========INITIALISE SOCKETIOCLIENT=========
                    dispatch_async(dispatch_get_main_queue(), {
                        
                        //self.dismissViewControllerAnimated(true, completion: nil);
                        /// self.performSegueWithIdentifier("loginSegue", sender: nil)
                        
                        if response1?.statusCode==200 {
                            print("got user success")
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
                            
                            print(json["_id"])
                            
                            
                            
                            //...........
                            /*  let stmt = sqliteDB.db.prepare("SELECT * FROM accounts")
                            print(stmt.columnNames)
                            for row in stmt {
                            print("...................... firstname: \(row[1]), email: \(row[3])")
                            // id: Optional(1), email: Optional("alice@mac.com")
                            }*/
                            
                        } else {
                            
                            
                            print("GOT USER FAILED")
                        }
                    })
                    
                   
                }
                
            }
                
            else
            {
                KeychainWrapper.removeObjectForKey("password")
                print("login failed")
                
            }
        }

    }
    
}