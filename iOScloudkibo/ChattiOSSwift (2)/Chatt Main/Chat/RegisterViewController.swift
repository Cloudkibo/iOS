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

class RegisterViewController: UIViewController,UITextFieldDelegate {

    var rt=NetworkingLibAlamofire()
    
    
    @IBOutlet weak var labelError: UILabel!
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

        txtEmail.delegate=self
        txtFirstname.delegate=self
        txtPassword.delegate=self
        txtLastname.delegate=self
        txtPhone.delegate=self
        txtUsername.delegate=self
        
        // Do any additional setup after loading the view.
    }

    @IBAction func backBtnRegister(sender: AnyObject) {
        self.dismissViewControllerAnimated(true) { () -> Void in
            
            
        }
    }
    @IBAction func btnRegisterTapped(sender: AnyObject) {
        
        var url=Constants.MainUrl+Constants.createNewUser
        KeychainWrapper.setString(txtPassword.text!, forKey: "password")
        var param:[String:String]=["username": txtUsername.text!,"password":txtPassword.text!,"firstname":txtFirstname.text!,"lastname":txtLastname.text!,"phone":txtPhone.text!,"email":txtEmail.text!]
        
        
        var param2:[String:AnyObject]=["username":"\(txtUsername.text!)","password":"\(txtPassword.text!)","firstname":"\(txtFirstname.text!)","lastname":"\(txtLastname.text)","phone":"\(txtPhone.text!)","email":"\(txtEmail.text!)"]
        /*var fff=JSONStringify(param2, prettyPrinted: false)
        var okk=JSON(param2)
        var okkpretty=JSONStringify(okk.object, prettyPrinted: false)
        var json=JSONStringify(param, prettyPrinted: false)
*/
        //var registerParams=["user":json.object]
        var pp="{\"user\":[{\"username\":\(txtUsername.text!),\"password\":\(txtPassword.text!),\"firstname\":\(txtFirstname.text!),\"lastname\":\(txtLastname.text!),\"phone\":\(txtPhone.text!),\"email\":\(txtEmail.text!)}]}"
        var jj=JSON(pp)
        var ppdata = pp.dataUsingEncoding(NSUTF8StringEncoding)
        let ppjson = JSON(data: ppdata!)
        
        print(pp, terminator: "")
        print(ppjson["user"].description)
        var pppp=JSON(["username":"\(txtUsername.text!)","password":"\(txtPassword.text!)","firstname":"\(txtFirstname.text!)","lastname":"\(txtLastname.text!)","phone":"\(txtPhone.text!)","email":"\(txtEmail.text!)"])
        ////var i=JSONStringify(pppp.object, prettyPrinted: false)
        /*var j1=json.stringByReplacingOccurrencesOfString("\\n", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
        var j2=j1.stringByReplacingOccurrencesOfString("\\", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
        var j3=j2.stringByReplacingOccurrencesOfString("\"", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
        */
        ////var j1=okkpretty.stringByReplacingOccurrencesOfString("\n", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
        ////var j2=j1.stringByReplacingOccurrencesOfString("\"", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
        //var j3=j2.stringByReplacingOccurrencesOfString("\"", withString: "\"", options: NSStringCompareOptions.LiteralSearch, range: nil)
        var finalP: JSON=["username":txtUsername.text!,"password":txtPassword.text!,"firstname":txtFirstname.text!,"lastname":txtLastname.text!,"phone":txtPhone.text!,"email":txtEmail.text!]
        ////var a=JSONStringify(pppp.dictionaryObject!, prettyPrinted: false)
        Alamofire.request(.POST,"\(url)",parameters: ["username":"\(txtUsername.text!)","password":"\(txtPassword.text!)","firstname":"\(txtFirstname.text!)","lastname":"\(txtLastname.text!)","phone":"\(txtPhone.text!)","email":"\(txtEmail.text!)"]).response{
        //ppjson["user"].arrayValue
        //Alamofire.request(.POST,"\(url)",parameters:["user":"[\"username\":\(txtUsername.text!),\"password\":\(txtPassword.text!),\"firstname\":\(txtFirstname.text!),\"lastname\":\(txtLastname.text!),\"phone\":\(txtPhone.text!),\"email\":\(txtEmail.text!)]"]).response{
            request, response_, data, error in
            print(error)
            
            if response_?.statusCode==200
                
            {
                let alert = UIAlertController(title: "Success", message: "Registration successful!", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
                print("Registration success")
                
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
                var getUserDataURL=userDataUrl
                Alamofire.request(.GET,"\(getUserDataURL)",headers:header).validate(statusCode: 200..<300).responseJSON{response in
                    var response1=response.response
                    var request1=response.request
                    var data1=response.result.value
                    var error1=response.result.error
                    
                    //===========INITIALISE SOCKETIOCLIENT=========
                    dispatch_async(dispatch_get_main_queue(), {
                        
                       self.dismissViewControllerAnimated(true, completion: nil);
                        ////self.performSegueWithIdentifier("loginSegue", sender: nil)
                        self.labelError.text=""

                        if response1?.statusCode==200 {
                            print("got user success")
                            //self.gotToken=true
                            var json=JSON(data1!)
                            //KeychainWrapper.setData(data1!, forKey: "loggedUserObj")
                            //loggedUserObj=json(loggedUserObj)
                           
                            loggedUserObj=json
                            
                            ///KeychainWrapper.setString(JSONStringify(json.object, prettyPrinted: true), forKey:"loggedIDKeyChain")
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
                            
                            print(json["_id"])
                            
                            let tbl_accounts = sqliteDB.accounts
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
                            do {
                                let rowid = try sqliteDB.db.run(tbl_accounts.insert(_id<-json["_id"].string!,
                                    firstname<-json["firstname"].string!,
                                    lastname<-json["lastname"].string!,
                                    email<-json["email"].string!,
                                    username<-json["username"].string!,
                                    status<-json["status"].string!,
                                    phone<-json["phone"].string!))
                                print("inserted id: \(rowid)")
                            } catch {
                                print("insertion failed: \(error)")
                            }
                            /*
                            let insert=tbl_accounts.insert(_id<-json["_id"].string!,
                                firstname<-json["firstname"].string!,
                                lastname<-json["lastname"].string!,
                                email<-json["email"].string!,
                                username<-json["username"].string!,
                                status<-json["status"].string!,
                                phone<-json["phone"].string!)
                            if let rowid = insert.rowid {
                                print("inserted id: \(rowid)")
                            } else if insert.statement.failed {
                                print("insertion failed: \(insert.statement.reason)")
                            }
                            */
                            //// self.fetchContacts(AuthToken)
                            do{
                            for account in try sqliteDB.db.prepare(tbl_accounts) {
                                print("id: \(account[_id]), email: \(account[email]), firstname: \(account[firstname])")
                                // id: 1, email: alice@mac.com, name: Optional("Alice")
                            }
                            }catch{
                             print("query not runned tblaccounts")
                            }
                            
                            
                            
                            
                            //...........
                            /*  let stmt = sqliteDB.db.prepare("SELECT * FROM accounts")
                            print(stmt.columnNames)
                            for row in stmt {
                            print("...................... firstname: \(row[1]), email: \(row[3])")
                            // id: Optional(1), email: Optional("alice@mac.com")
                            }*/
                            
                        } else {
                            print(error1)
                            print(response1)
                            print(data1)
                            //self.labelLoginUnsuccessful.text="Sorry, you are not registered"
                            //self.txtForEmail.text=nil
                            //self.txtForPassword.text=nil
                            
                            print("GOT USER FAILED")
                        }
                    })
                    
                    if(response_!.statusCode==401)
                    {
                        print("got user failed token expired")
                        
                        self.rt.refrToken()
                    }
                   
                }
                
            }
                
            else
            {
                self.labelError.text=""
                if(response_!.statusCode==401)
                {
                    let alert = UIAlertController(title: "Error", message: "Registration Failed!", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                    
                    print("registration failed token expired")
                    self.rt.refrToken()
                    //self.labelError.text=error?.description
                }
                if(response_?.statusCode==422)
                {
                    /*let alert = UIAlertController(title: "Failure", message: "Registration Failed. User is already registered", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)*/
                    print("registration failed something duplicate")
                    //self.labelError.text=error?.description
                    
                }
                self.labelError.text=""
                print("status code is \(response_?.statusCode)")
                print(error)
                //self.labelError.text=error["messages"]?.description
                //print(response_?.debugDescription)
                //print(data!.debugDescription)
                var jj=JSON(data:data!)
                //var json=JSON(data!.debugDescription)
                print(jj.object)
                print("rrrrrr")
                self.labelError.textColor=UIColor.redColor()
                
                print(jj.description)
                print("..\(jj["errors"][0])")
                    
                    if(jj["errors"]["email"] != nil){
                        print("email error exists \(jj["errors"]["username"]["email"]) \r\n")
                         self.labelError.text=self.labelError.text!+"\(jj["errors"]["email"]["message"]) \r\n"
                    }
                    if(jj["errors"]["firstName"] != nil){
                        print("hashedPassword error exists \(jj["errors"]["username"]["firstName"]) \r\n")
                         self.labelError.text=self.labelError.text!+"\(jj["errors"]["hashedPassword"]["message"]) \r\n"
                    }
                    if(jj["errors"]["lastName"] != nil){
                         self.labelError.text=self.labelError.text!+"\(jj["errors"]["hashedPassword"]["message"]) \r\n"
                        print("hashedPassword error exists \(jj["errors"]["username"]["lastName"]) \r\n")
                    }
                    
                    if(jj["errors"]["username"] != nil){
                         self.labelError.text=self.labelError.text!+"\(jj["errors"]["username"]["message"]) \r\n"
                        
                        print("username error exists \(jj["errors"]["username"]["message"])")
                    }
                    if(jj["errors"]["hashedPassword"] != nil){
                         self.labelError.text=self.labelError.text!+"\(jj["errors"]["hashedPassword"]["message"]) \r\n"
                        print("hashedPassword error exists \(jj["errors"]["username"]["hashedPassword"]) \r\n")
                    }
                 
                
                
                KeychainWrapper.removeObjectForKey("password")
                print("registration failed")
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
    
    func textFieldDidBeginEditing(textField: UITextField) {
        
        
    }
    func textFieldDidEndEditing(textField: UITextField) {
        
        
    }
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        return true

        
    }
    
    func textFieldShouldClear(textField: UITextField) -> Bool {
        return true

        
    }
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        return true

        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
        
    }
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        return true

        
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
