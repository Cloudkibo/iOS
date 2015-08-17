//
//  LoginViewController.swift
//  Chat
//
//  Created by My App Templates Team on 24/08/14.
//  Copyright (c) 2014 My App Templates. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON


class LoginViewController: UIViewController, UITextFieldDelegate{
    
    
    @IBOutlet var viewForContent : UIScrollView!
    @IBOutlet var viewForUser : UIView!
    @IBOutlet var txtForEmail : UITextField!
    @IBOutlet var txtForPassword : UITextField!
    
    @IBOutlet weak var labelLoginUnsuccessful: UILabel!
    var AuthToken:String=""
    var authParams:String=""
    var currentUserData:String=""
    var gotToken:Bool=false
    var gotUser:Bool=false
    
    
    
    var joinedRoom:Bool=false
    var UserDictionary:[String:AnyObject] = ["":""]
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        // Custom initialization
        
    }
    
    required init(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        var size = UIScreen.mainScreen().bounds.size
        viewForContent.contentSize = CGSizeMake(size.width, 568)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var size = UIScreen.mainScreen().bounds.size
        viewForContent.contentSize = CGSizeMake(size.width, 568)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("willShowKeyBoard:"), name:UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("willHideKeyBoard:"), name:UIKeyboardWillHideNotification, object: nil)
        
        println("loginviewcontrollerrr")
        // Do any additional setup after loading the view.
    }
    
    func willShowKeyBoard(notification : NSNotification){
    
        var userInfo: NSDictionary!
        userInfo = notification.userInfo

        var duration : NSTimeInterval = 0
        var curve = userInfo.objectForKey(UIKeyboardAnimationCurveUserInfoKey) as! UInt
        duration = userInfo[UIKeyboardAnimationDurationUserInfoKey]as! NSTimeInterval
        var keyboardF:NSValue = userInfo.objectForKey(UIKeyboardFrameEndUserInfoKey)as! NSValue
        var keyboardFrame = keyboardF.CGRectValue()
        
        UIView.animateWithDuration(duration, delay: 0, options:nil, animations: {
            self.viewForContent.contentOffset = CGPointMake(0, keyboardFrame.size.height)
            
            }, completion: nil)
       
    }
    
    func willHideKeyBoard(notification : NSNotification){
        
        var userInfo: NSDictionary!
        userInfo = notification.userInfo
        
        var duration : NSTimeInterval = 0
        var curve = userInfo.objectForKey(UIKeyboardAnimationCurveUserInfoKey) as! UInt
        duration = userInfo[UIKeyboardAnimationDurationUserInfoKey]as! NSTimeInterval
        var keyboardF:NSValue = userInfo.objectForKey(UIKeyboardFrameEndUserInfoKey) as! NSValue
        var keyboardFrame = keyboardF.CGRectValue()
        
        UIView.animateWithDuration(duration, delay: 0, options:nil, animations: {
            self.viewForContent.contentOffset = CGPointMake(0, 0)
            
            }, completion: nil)
        
    }
    
    func textFieldShouldReturn (textField: UITextField!) -> Bool{
        if ((textField == txtForEmail)){
            txtForPassword.becomeFirstResponder();
        } else if (textField == txtForPassword){
            textField.resignFirstResponder()
        }
        return true
    }
    
    @IBAction func registerBtnTapped() {
        self.dismissViewControllerAnimated(true, completion: nil);
    }
    
    
    func convertStringToDictionary(text: String) -> [String:String]? {
        println(text)
        if let data = text.dataUsingEncoding(NSUTF8StringEncoding) {
            println(data.debugDescription)
            var error: NSError?
            let json = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.allZeros, error: &error) as? [String:String]
            if error != nil {
                println(error)
            }
            return json
        }
        return nil
    }
    
    
    @IBAction func loginBtnTapped() {
        
        
        //==login button tapped
        
      //  var loginObj=LoginAPI()
       
        //============================================================= Authenticate User 1 sabachanna ================
        var url=Constants.MainUrl+Constants.authentictionUrl
        var param:[String:String]=["username": txtForEmail.text!,"password":txtForPassword.text!]
        
        
        //requesting server response , sending username and password
       Alamofire.request(.POST,"\(url)",parameters: param).response{
            request, response, data, error in
            println(request)
            println(response)
           println(data)
            println(error)
        
       
            self.AuthToken=NSString(data: data!, encoding: NSUTF8StringEncoding)! as String
             //   self.authParams=NSString(data: data!, encoding: NSUTF8StringEncoding)! as String
            println("token..... is \(self.AuthToken)")
     //   println("\(authParams.valueForKey(token:String))")
            //if username and password matched on server
            if response?.statusCode==200
                
            {
                //...........................=======================sabachana suthenticated GOT token........=================
                println("login success")
                self.labelLoginUnsuccessful.text=nil
                // self.dismissViewControllerAnimated(true, completion: nil);
                
                
                self.gotToken=true
                
                var userDataUrl=Constants.MainUrl+Constants.getCurrentUser
                let index: String.Index = advance(self.AuthToken.startIndex, 10)
               // var tokennnnn=self.AuthToken.substringFromIndex(index)
               // println("........\(tokennnnn)")
                var tokenParams:[String:String]=["access_token":"\(self.AuthToken)"]
                
                ////println("?????????\(tokenParams)")
                var aaa=self.AuthToken[advance(self.AuthToken.startIndex,10)..<self.AuthToken.endIndex]
            var indexx=advance(aaa.endIndex, -2)
                var getUserDataURL=userDataUrl+"?access_token="+aaa.substringToIndex(indexx);
                
                println("????? \(getUserDataURL)")
                Alamofire.request(.GET,"\(getUserDataURL)").response{
                    request1, response1, data1, error1 in
                   // println(request1)
                     println(NSString(data: data1!, encoding: NSUTF8StringEncoding)! as String) //prints all attributes like
                    self.currentUserData=NSString(data: data1!, encoding: NSUTF8StringEncoding)! as String
                    
                    println(NSString(data: data1!, encoding: NSUTF8StringEncoding)! as String) //prints all attributes like id,role,firsname,lastname,...
                    
                    //println(data1)
                    //println(error1)
                    
                    /* self.AuthToken=NSString(data: data!, encoding: NSUTF8StringEncoding)! as String
                    println("token..... is \(self.AuthToken)")
                    */
                    //if correct user got
                    
                    if response1?.statusCode==200
                        
                    {println("got user success")
                        self.gotToken=true
                        
                        ///
                        
                        
                        
                        
                        
                        
                    
                        let json = JSON(data: data1!)
                        let username = json["username"].stringValue
                        println("\(username)")
                        
                        var jsonChatRoomUserObj=JSON(["username":"\(username)"])
                        println("\(jsonChatRoomUserObj)")
                        var jsonGlobalChatFormat=JSON(["room":"globalchatroom","user":"\(jsonChatRoomUserObj)"])
                       //var jsonGlobalChatFormat=JSON(["room":"globalchatroom","user":"\(jsonChatRoomUserObj)"])
                        ///////??????????????????????
                        
                        
                        
                        
                    
                        let data2: NSData!=data1
                        var jsonError: NSError?
                        let decodedJson = NSJSONSerialization.JSONObjectWithData(data2, options: nil, error: &jsonError) as! Dictionary<String, AnyObject>
                        if (jsonError != nil) {
                            println(decodedJson["username"]!)
                        }
                      //  println(decodedJson["username"]!)
                        
                       /*
                        let jsonError: NSError
                        let decodedJson = NSJSONSerialization.JSONObjectWithData(data1!, options: nil, error: &jsonError) as! Dictionary<String, AnyObject>
                        if (jsonError != nil) {
                            println(decodedJson["email"])
                        }
                        */

                        ///
                        
                      /*(  let result = self.convertStringToDictionary("[email:hii]") // ["name": "James"]
                        println(result)
                        if let name = result?["email"] { // The `?` is here because our `convertStringToDictionary` function returns an Optional
                            println(name) // "James"
                        }
          */
                        
                        
                       // self.labelLoginUnsuccessful.text=nil
                        
                        
                       // var IDDD=convertStringToDictionary(self.currentUserData)
                     //   var IDFetched=IDDD?["_id"]
                      //  println(";;;;;;;;;;;;;;;;; \(IDDD)")
                        var iddddddd=decodedJson["_id"] as! String
                        var joinRoomParams=["room":"globalchatroom","_id":"\(iddddddd)"]
                        
                        let socket = SocketIOClient(socketURL: "https://www.cloudkibo.com")
                        
                        
                        socket.connect()
                        ////////  var userObj={["username":"sabachanna","_id:"]}
                        //username:sabachanna _id:
                         var myUsername=decodedJson["username"]! as! String
                     //   println("\(myUsername)")
                        var usernameKeyValue=["username":"\(myUsername)"]
                    var GlobalChatRoomParasssss=["user":"{\(myUsername)}"]
                        var ppppp=["\"room\"":"\"globalchatroom\"","\"user\"":"{\"username\":\""+"\(myUsername)\"}"]
                        println(";;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;")
                       // println("\(ppppp)")
                      ///  var ppppp=["room":"globalchatroom","user":"\(iddddddd)"]
                     //   println("\(GlobalChatRoomParasssss)")
                      
                        
                        println("\(jsonGlobalChatFormat.dictionaryValue)")
                        
                        // println("{\"room\":\"globalchatroom\",\"user\":{\"username\":\"sabachanna\"}}")
                        socket.emit("join global chatroom", "\(jsonGlobalChatFormat.dictionaryValue)")
                        socket.on("youareonline") {data,ack in
                            println("socket connected")
                            println(data)
                            
                        }
                        
                        socket.emit("whozonline", ppppp)
                        socket.on("theseareonline") {data,ack in
                            println("these are online")
                            println(data)
                            
                        }
                      /*  socket.on("join global chatroom?\(joinRoomParams)"){data,ack in
                            println("response im ... \(data)")
                            println("listening")
                        }
*/
                       // socket.connect()
                      
                        println(socket.connected)
                        

                    }
                        
                    else
                    {
                        //if login failed
                        println("got user failed")
                        
                        // var errorMsg=NSString(data: data!, encoding: NSUTF8StringEncoding)! as String
                        self.labelLoginUnsuccessful.text="Sorry, you are not registered"
                        self.txtForEmail.text=nil
                    self.txtForPassword.text=nil
                    }
                }
        
            }
             
            else
            {
                //if login failed
                println("login failed")
                
               // var errorMsg=NSString(data: data!, encoding: NSUTF8StringEncoding)! as String
                self.labelLoginUnsuccessful.text="Sorry, you are not registered"
                self.txtForEmail.text=nil
                self.txtForPassword.text=nil
            }
        }
    
        
      //=========
        //=========
        //Fetching user data
        ////======================
        
       // }
       // var UserID=self.currentUserData["_id"]!
        /*

        if(self.gotUser==true){
            
            
                
            var IDDD=convertStringToDictionary(self.currentUserData)
            var IDFetched=IDDD?["_id"]
            println(";;;;;;;;;;;;;;;;; \(IDDD)")
            var joinRoomParams=["roomname":"globalchatroom","_id":"\(IDFetched)"]
        
        let socket = SocketIOClient(socketURL: "https://www.cloudkibo.com")
        
        
        socket.connect()
        ////////  var userObj={["username":"sabachanna","_id:"]}
        //username:sabachanna _id:
        socket.on("youareonline") {data,ack in
            println("socket connected")
            
        }
        socket.on("join global chatroom"){data,ack in
            println("response im ... \(data)")
            println("listening")
        }
        socket.connect()
        println(socket.connected)
        
        }
        */
        
        //////////////DISMISS VIEWwwwww//
               self.dismissViewControllerAnimated(true, completion: nil);
        
        
        
        
        
        
        //-==========================================================
  /*      let socket = SocketIOClient(socketURL: "https://www.cloudkibo.com")
        
        
        socket.connect()
        ////////  var userObj={["username":"sabachanna","_id:"]}
        //username:sabachanna _id:
        socket.on("youareonline") {data,ack in
            println("socket connected")
            
        }
        socket.on("join global chatroom"){data,ack in
            println("response im ... \(data)")
            println("listening")
        }
        socket.connect()
        println(socket.connected)
*/
        ////////////////////----
        /////////////////--------------------------------------
        
        
               /*Alamofire.request(.POST, "https://cloudkibo.com/auth/local/", parameters: ["username": "sabachanna","password":"sabachanna"])
            .response { request, response, data, error in
                println(request)
                println(response)
                println(error)
        }*/
        println("Login pressed")
     /*   let socket = SocketIOClient(socketURL: "https://www.cloudkibo.com")
        
        
        
        socket.on("im") {data, ack in
            
            println("socket connected")
            
        }*/
       //// println("response is \(loginResponse)")
        

       
    }

    @IBAction func facebookBtnTapped() {
        self.dismissViewControllerAnimated(true, completion: nil);
    }
    
    @IBAction func twitterBtnTapped() {
        self.dismissViewControllerAnimated(true, completion: nil);
    }
    
    @IBAction func forgotPasswordBtnTapped() {
        self.dismissViewControllerAnimated(true, completion: nil);  
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // #pragma mark - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    /*override func prepareForSegue(segue: UIStoryboardSegue?, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        if segue!.identifier == "loginSegue" {
            if let destinationVC = segue!.destinationViewController as? ChatViewController{
                destinationVC.AuthToken = self.AuthToken
            }
        }
    }*/


}
