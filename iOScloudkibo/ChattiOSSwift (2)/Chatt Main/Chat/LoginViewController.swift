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
    
    var contactsJsonObj:JSON=""
    @IBOutlet var viewForContent : UIScrollView!
    @IBOutlet var viewForUser : UIView!
    @IBOutlet var txtForEmail : UITextField!
    @IBOutlet var txtForPassword : UITextField!
    
    @IBOutlet weak var labelLoginUnsuccessful: UILabel!
    //var AuthToken:String=""
    var authParams:String=""
    var currentUserData:JSON=""
    var gotToken:Bool=false
    var gotUser:Bool=false
    
    
    var joinedRoom:Bool=false
    var UserDictionary:[String:AnyObject] = ["":""]
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        // Custom initialization
       /* socketObj.connect()
        
        socketObj.socket.on("connect") {data, ack in
        NSLog("connected to socket")
        }
        
        */
        
        
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
        
        socketObj.connect()
        
        socketObj.socket.on("connect") {data, ack in
            NSLog("connected to socket")
        }
        
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
        //============================ Authenticate User ================
        var url=Constants.MainUrl+Constants.authentictionUrl
        var param:[String:String]=["username": txtForEmail.text!,"password":txtForPassword.text!]
        Alamofire.request(.POST,"\(url)",parameters: param).response{
            request, response, data, error in
            println(error)
            
            if response?.statusCode==200
                
            {
                println("login success")
                self.labelLoginUnsuccessful.text=nil
                self.gotToken=true
                
                //======GETTING REST API TO GET CURRENT USER=======================
                
                var userDataUrl=Constants.MainUrl+Constants.getCurrentUser
                //let index: String.Index = advance(self.AuthToken.startIndex, 10)
                
                //======================STORING Token========================
                let jsonLogin = JSON(data: data!)
                let token = jsonLogin["token"]
                AuthToken=token.string!
                
                //========GET USER DETAILS===============
                var getUserDataURL=userDataUrl+"?access_token="+AuthToken
                Alamofire.request(.GET,"\(getUserDataURL)").responseJSON{
                    request1, response1, data1, error1 in
                    
                    if response1?.statusCode==200
                        
                    {   // println("got user success")
                        self.gotToken=true
                      //  let json = JSON(data: data1!)
                      //  self.currentUserData=json
                        
                        //===========INITIALISE SOCKETIOCLIENT=========
                            dispatch_async(dispatch_get_main_queue(), {
                            
                             self.dismissViewControllerAnimated(true, completion: nil);
                          /// self.performSegueWithIdentifier("loginSegue", sender: nil)
                            

                            if response1?.statusCode==200 {
                                println("got user success")
                                self.gotToken=true
                                var json=JSON(data1!)
                                       socketObj.socket.on("youareonline") {data,ack in
                                    
                                    println("you onlineeee \(ack)")
                                }
                                
                                var jsonNew=JSON("{\"room\": \"globalchatroom\",\"user\": {\"username\":\"sabachanna\"}}")
                                 //socketObj.socket.emit("join global chatroom", ["room": "globalchatroom", "user": ["username":"sabachanna"]]) WORKINGGG
                                
                               socketObj.socket.emit("join global chatroom",["room": "globalchatroom", "user": json.object])
                                
                                
                                
                               //// self.fetchContacts(AuthToken)
                                
                                
                            } else {
                               println("GOT USER FAILED")
                            }
                        })
                    
                    
                    
                    
                    /////////
                        
                      //^^^^^^^  socketObj.socket.emit("join global chatroom","\(joinChatParas)")
                        
                        // self.socketObj.socket.emit("join global chatroom","\(joinChatParas)")
                        
                        
                        
                       // ^^socketObj.socket.on("youareonline") {data,ack in
                            
                         //   println("you onlineeee")
                       //^^ }
                        
                        //self.dismissViewControllerAnimated(true, completion: nil);
                        
                        
                        

                        
                }
                        
            else{
                        println("got user failed")
                        self.labelLoginUnsuccessful.text="Sorry, you are not registered"
                        self.txtForEmail.text=nil
                        self.txtForPassword.text=nil
                    }
                }
            }
                
            else
            {
                println("login failed")
                self.labelLoginUnsuccessful.text="Sorry, you are not registered"
                self.txtForEmail.text=nil
                self.txtForPassword.text=nil
            }
        }
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
   /* override func prepareForSegue(segue: UIStoryboardSegue?, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        if segue!.identifier == "loginSegue" {
            if let destinationVC = segue!.destinationViewController as? ChatViewController{
                destinationVC.AuthToken = AuthToken
                destinationVC.contactsJsonObj=self.contactsJsonObj
            }
        }
    }*/


}
