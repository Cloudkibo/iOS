//
//  RegisterViewController.swift
//  Chat
//
//  Created by Cloudkibo on 14/10/2015.
//  Copyright (c) 2015 MyAppTemplates. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SQLite

class RegisterViewController: UIViewController {

    var rt=NetworkingLibAlamofire()
    
    
    @IBOutlet weak var txtFirstname: UITextField!
    @IBOutlet weak var txtLastname: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPhone: UITextField!
    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    /*@IBOutlet var txtFirstname: UIView!
    @IBOutlet var txtLastname: UIView!
    @IBOutlet var txtEmail: UIView!
    @IBOutlet var txtPhone: UIView!
    @IBOutlet var txtUsername: UIView!
    @IBOutlet var txtPassword: UIView!
*/
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func btnRegisterTapped(sender: AnyObject) {
        
        var url=Constants.MainUrl+Constants.createNewUser
        KeychainWrapper.setString(txtPassword.text!, forKey: "password")
        var param:[String:String]=["username": txtUsername.text!,"password":txtPassword.text!,"firstname":txtFirstname.text!,"lastname":txtLastname.text!,"phone":txtPhone.text!,"email":txtEmail.text!]
        var json=JSON(param)
        var registerParams=["user":json.object]
        var pp="[\"username\":\(txtUsername.text!),\"password\":\(txtPassword.text!),\"firstname\":\(txtFirstname.text!),\"lastname\":\(txtLastname.text!),\"phone\":\(txtPhone.text!),\"email\":\(txtEmail.text!)]"
        println(pp)
        Alamofire.request(.POST,"\(url)",parameters:["user":pp]).response{
            request, response, data, error in
            println(error)
            
            if response?.statusCode==200
                
            {
                println("Registration success")
                //self.labelLoginUnsuccessful.text=nil
                //self.gotToken=true
                
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
                        
                        self.dismissViewControllerAnimated(true, completion: nil);
                        /// self.performSegueWithIdentifier("loginSegue", sender: nil)
                        
                        if response1?.statusCode==200 {
                            println("got user success")
                            //self.gotToken=true
                            var json=JSON(data1!)
                            //KeychainWrapper.setData(data1!, forKey: "loggedUserObj")
                            //loggedUserObj=json(loggedUserObj)
                           
                            loggedUserObj=json
                            
                            KeychainWrapper.setString(JSONStringify(json.object, prettyPrinted: true), forKey:"loggedIDKeyChain")
                            //===========saving username======================
                            
                            KeychainWrapper.setString(json["username"].string!, forKey: "username")
                            KeychainWrapper.setString(json["firstname"].string!+" "+json["lastname"].string!, forKey: "loggedFullName")
                            KeychainWrapper.setString(json["phone"].string!, forKey: "loggedPhone")
                            KeychainWrapper.setString(json["email"].string!, forKey: "loggedEmail")
                            KeychainWrapper.setString(json["_id"].string!, forKey: "_id")
                            KeychainWrapper.setString(self.txtPassword.text!, forKey: "password")
                            
                            
                            socketObj.addHandlers()
                            
                            //var jsonNew=JSON("{\"room\": \"globalchatroom\",\"user\": {\"username\":\"sabachanna\"}}")
                            //socketObj.socket.emit("join global chatroom", ["room": "globalchatroom", "user": ["username":"sabachanna"]]) WORKINGGG
                            
                            socketObj.socket.emit("join global chatroom",["room": "globalchatroom", "user": json.object])
                            
                            println(json["_id"])
                            
                            let tbl_accounts = sqliteDB.db["accounts"]
                            let _id = Expression<String>("_id")
                            let firstname = Expression<String?>("firstname")
                            let lastname = Expression<String?>("lastname")
                            let email = Expression<String>("email")
                            let phone = Expression<String>("phone")
                            let username = Expression<String>("username")
                            let status = Expression<String>("status")
                            let date = Expression<String>("date")
                            let accountVerified = Expression<String>("accountVerified")
                            let role = Expression<String>("role")
                            
                            
                            // let insert = users.insert(email <- "alice@mac.com")
                            
                            
                            tbl_accounts.delete()
                            
                            let insert=tbl_accounts.insert(_id<-json["_id"].string!,
                                firstname<-json["firstname"].string!,
                                lastname<-json["lastname"].string!,
                                email<-json["email"].string!,
                                username<-json["username"].string!,
                                status<-json["status"].string!,
                                phone<-json["phone"].string!)
                            if let rowid = insert.rowid {
                                println("inserted id: \(rowid)")
                            } else if insert.statement.failed {
                                println("insertion failed: \(insert.statement.reason)")
                            }
                            
                            //// self.fetchContacts(AuthToken)
                            for account in tbl_accounts {
                                println("id: \(account[_id]), email: \(account[email]), firstname: \(account[firstname])")
                                // id: 1, email: alice@mac.com, name: Optional("Alice")
                            }
                            
                            
                            
                            
                            //...........
                            /*  let stmt = sqliteDB.db.prepare("SELECT * FROM accounts")
                            println(stmt.columnNames)
                            for row in stmt {
                            println("...................... firstname: \(row[1]), email: \(row[3])")
                            // id: Optional(1), email: Optional("alice@mac.com")
                            }*/
                            
                        } else {
                            println(error1)
                            println(response1)
                            println(data1)
                            //self.labelLoginUnsuccessful.text="Sorry, you are not registered"
                            //self.txtForEmail.text=nil
                            //self.txtForPassword.text=nil
                            
                            println("GOT USER FAILED")
                        }
                    })
                    
                    if(response?.statusCode==401)
                    {
                        println("got user failed token expired")
                        self.rt.refrToken()
                    }
                   
                }
                
            }
                
            else
            {
                if(response?.statusCode==401)
                {
                    println("registration failed token expired")
                    self.rt.refrToken()
                }
                if(response?.statusCode==422)
                {
                    println("registration failed something duplicate")
                    
                }
                println("status code is \(response?.statusCode)")
                println(error)
                println(response?.debugDescription)
                println(data!.debugDescription)
                var jj=JSON(data:data!)
                //var json=JSON(data!.debugDescription)
                println(jj.object)
                println(jj.description)
                
                KeychainWrapper.removeObjectForKey("password")
                println("registration failed")
               // self.labelLoginUnsuccessful.text="Sorry, you are not registered"
                //self.txtForEmail.text=nil
                //self.txtForPassword.text=nil
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
