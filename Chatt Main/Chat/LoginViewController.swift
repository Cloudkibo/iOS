//
//  LoginViewController.swift
//  Chat
//
//  Created by My App Templates Team on 24/08/14.
//  Copyright (c) 2014 My App Templates. All rights reserved.
//

import UIKit
import Alamofire
<<<<<<< HEAD
import Foundation

var tokenC : String = "abc";

=======
//import SwiftRequest
>>>>>>> 6241025801c2de31056ac795dd23669f5507cf99

class LoginViewController: UIViewController, UITextFieldDelegate{
    
    @IBOutlet var viewForContent : UIScrollView!
    @IBOutlet var viewForUser : UIView!
    @IBOutlet var txtForEmail : UITextField!
    @IBOutlet var txtForPassword : UITextField!
    
<<<<<<< HEAD
=======
    // Signup fields
    
    
    
>>>>>>> 6241025801c2de31056ac795dd23669f5507cf99
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
        
        // Do any additional setup after loading the view.
    }
    
    func willShowKeyBoard(notification : NSNotification){
    
        var userInfo: NSDictionary!
        userInfo = notification.userInfo

        var duration : NSTimeInterval = 0
        var curve = userInfo.objectForKey(UIKeyboardAnimationCurveUserInfoKey) as UInt
        duration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as NSTimeInterval
        var keyboardF:NSValue = userInfo.objectForKey(UIKeyboardFrameEndUserInfoKey) as NSValue
        var keyboardFrame = keyboardF.CGRectValue()
        
        UIView.animateWithDuration(duration, delay: 0, options:nil, animations: {
            self.viewForContent.contentOffset = CGPointMake(0, keyboardFrame.size.height)
            
            }, completion: nil)
       
    }
    
    func willHideKeyBoard(notification : NSNotification){
        
        var userInfo: NSDictionary!
        userInfo = notification.userInfo
        
        var duration : NSTimeInterval = 0
        var curve = userInfo.objectForKey(UIKeyboardAnimationCurveUserInfoKey) as UInt
        duration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as NSTimeInterval
        var keyboardF:NSValue = userInfo.objectForKey(UIKeyboardFrameEndUserInfoKey) as NSValue
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
<<<<<<< HEAD
=======
        
        
>>>>>>> 6241025801c2de31056ac795dd23669f5507cf99
        self.dismissViewControllerAnimated(true, completion: nil);
    }
    
    @IBAction func loginBtnTapped() {
        
<<<<<<< HEAD
        
        
        var error: NSError?

        
        
        Alamofire.request(.POST, "https://www.cloudkibo.com/auth/local", parameters: ["username" : txtForEmail.text, "password" : txtForPassword.text])
            .responseJSON { (request, response, data, error) in
                //println(request)
                //println(response)
                println(data)
                //tokenC = data;
                //println(error)
               
        }
        
        
        
        
        /*
        let url = NSURL(string: "https://www.cloudkibo.com/auth/local")

        
        Alamofire.request(.POST, url!, parameters: ["username" : txtForEmail.text, "password" : txtForPassword.text])
            .responseJSON { (req, res, json, error) in
                if(error != nil) {
                    NSLog("Error: \(error)")
                    println(req)
                    println(res)
                }
                else {
                    NSLog("Success: \(url)")
                    var json = JSON(json!)
                }
        }
        */

        
        self.dismissViewControllerAnimated(true, completion: nil);
=======
        Alamofire.request(.POST, "https://www.cloudkibo.com/auth/local", parameters: ["username": txtForEmail.text, "password": txtForPassword.text])
            .responseJSON { (request, response, data, error) in
                //println(request)
                println(response)
                println(data)
                //println(error)

        }

        self.dismissViewControllerAnimated(true, completion: nil);
/*
        let url = "http://localhost:8000";
        var swiftRequest = SwiftRequest();
        var params:[String:String] = [
            "username" : txtForEmail!.text,
            "password" : txtForPassword!.text
        ];
        
        swiftRequest.post(url + "https://wwww.cloudkibo.com/auth/local", data: params, callback: {err, response, body in
            if( err == nil && response!.statusCode == 200) {
                if((body as NSDictionary)["success"] as Int == 1) {
                    self.showAlert("User successfully authenticated!");
                } else {
                    self.showAlert("That token isn't valid");
                }
            } else {
                self.showAlert("We're sorry, something went wrong");
            }
        })*/
        
        
>>>>>>> 6241025801c2de31056ac795dd23669f5507cf99
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
    

    /*
    // #pragma mark - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue?, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
