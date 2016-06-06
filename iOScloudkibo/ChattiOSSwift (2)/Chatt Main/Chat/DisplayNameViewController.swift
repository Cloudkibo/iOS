//
//  DisplayNameViewController.swift
//  kiboApp
//
//  Created by Cloudkibo on 02/06/2016.
//  Copyright © 2016 MyAppTemplates. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
class DisplayNameViewController: UIViewController {
    
    
    @IBOutlet weak var txtDisplayName: UITextField!
    var messageFrame = UIView()
    var activityIndicator = UIActivityIndicatorView()
    var strLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func progressBarDisplayer(msg:String, _ indicator:Bool ) {
        print(msg)
        strLabel = UILabel(frame: CGRect(x: 50, y: 0, width: 250, height: 50))
        strLabel.text = msg
        strLabel.textColor = UIColor.whiteColor()
        messageFrame = UIView(frame: CGRect(x: view.frame.midX - 110, y: view.frame.midY - 25 , width: 230, height: 50))
        messageFrame.layer.cornerRadius = 15
        messageFrame.backgroundColor = UIColor(white: 0, alpha: 0.7)
        if indicator {
            activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.White)
            activityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
            activityIndicator.startAnimating()
            messageFrame.addSubview(activityIndicator)
        }
        messageFrame.addSubview(strLabel)
        view.addSubview(messageFrame)
    }
    
    
    
    func sendNameToServer(var displayName:String)
    {
        progressBarDisplayer("Contacting Server", true)
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            // do some task start to show progress wheel
            
            var urlToSendDisplayName=Constants.MainUrl+Constants.firstTimeLogin
            var nn="{display_name:displayName}"
            //var getUserDataURL=userDataUrl
            
            socketObj.socket.emit("logClient", "")
            Alamofire.request(.GET,"\(urlToSendDisplayName)",headers:header,parameters:["display_name":displayName]).responseJSON{
                response in
                
                //===========INITIALISE SOCKETIOCLIENT=========
               // dispatch_async(dispatch_get_main_queue(), {
                    
                    //self.dismissViewControllerAnimated(true, completion: nil);
                    /// self.performSegueWithIdentifier("loginSegue", sender: nil)
                    
                
            
          /*  Alamofire.request(.GET,"\(urlToSendDisplayName)",headers:header,parameters:["display_name":displayName])
                .validate(statusCode: 200..<300)
                .response { (request, response, data, error) in
                    
                    */
                    
                    print(response.data?.debugDescription)
                    
                    print("display name is \(displayName)")
                    /*Alamofire.request(.GET,"\(urlToSendDisplayName)",headers:header,parameters:["display_name":"\(displayName)"]).validate(statusCode: 200..<300).responseJSON{response in
                */
                    dispatch_async(dispatch_get_main_queue()) {
                        // update some UI
                        //remove progress wheel
                        print("got server response")
                        self.messageFrame.removeFromSuperview()
                        //move to next screen
                        //self.saveButton.enabled = true
                    }
                    switch response.result {
                        
                        
                        
                    case .Success:
                        print("display name sent to server")
                        firstTimeLogin=false
                        socketObj.socket.emit("logClient", "display name \(displayName) sent to server successfully")
                        //print(response.data)
                        //let json = JSON(data!)
                        //print("JSON: \(json)")
                        //%%%%%*******************
                        firstTimeLogin=false
                        
                        //////// %%%%%%%%%%%%%%***************self.performSegueWithIdentifier("fetchContactsSegue", sender: self)
                        //self.performSegueWithIdentifier("fetchaddressbooksegue", sender: self)
                        //*********************%%%%%%%%%%%%%%%%%%%%%%%%% commented new
                        
                        self.dismissViewControllerAnimated(false, completion: { () -> Void in
                            
                            print("logged in going to contactlist")
                        })
                        
                        
                        //self.performSegueWithIdentifier(<#T##identifier: String##String#>, sender: <#T##AnyObject?#>)
                        
                   case .Failure(let error):
                       print(error)
                        socketObj.socket.emit("logClient","\(error)")
                        
                    
                    
                    
                    
                    //when server sends response:
                    
            }
        
        
        
    }
        }
    }
    @IBAction func btnDonePressed(sender: AnyObject) {
        var displayName=txtDisplayName.text!
        if(accountKit!.currentAccessToken != nil)
        {
        header=["kibo-token":accountKit!.currentAccessToken!.tokenString]
        }
        self.sendNameToServer(displayName)
    }
}

    /*
    func sendNameToServer(var displayName:String)
    {
        progressBarDisplayer("Contacting Server", true)
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            // do some task start to show progress wheel
            
            var urlToSendDisplayName=Constants.MainUrl+Constants.firstTimeLogin
            //var nn="{display_name:displayName}"
            //var getUserDataURL=userDataUrl
            
            
            
            socketObj.socket.emit("logClient", "contacting server to register user(if new)")
            Alamofire.request(.GET,"\(urlToSendDisplayName)",headers:header,parameters:["display_name":displayName])
                .validate(statusCode: 200..<300)
                .response { (request, response, data, error) in
                    
                    
                    socketObj.socket.emit("logClient","got server response ..")
                    username=displayName
                    displayname=displayName
                    print("display name is \(displayName)")
                    /*Alamofire.request(.GET,"\(urlToSendDisplayName)",headers:header,parameters:["display_name":"\(displayName)"]).validate(statusCode: 200..<300).responseJSON{response in
                    */
                    dispatch_async(dispatch_get_main_queue()) {
                        // update some UI
                        //remove progress wheel
                        print("got server response")
                        self.messageFrame.removeFromSuperview()
                        //move to next screen
                        //self.saveButton.enabled = true
                    }
                    
                    print(data?.debugDescription)
                    switch response!.statusCode {
                        
                    case 200:
                        print("display name sent to server")
                        firstTimeLogin=false
                        socketObj.socket.emit("logClient", "display name \(displayName) sent to server successfully")
                        print(data)
                        
                        let json = JSON(data!)
                        
                        print("JSON: \(json[0].debugDescription)")
                        print("data: \(json.debugDescription)")
                        
                        
                        //%%%%%*******************
                        firstTimeLogin=false
                        
                        //////// %%%%%%%%%%%%%%***************self.performSegueWithIdentifier("fetchContactsSegue", sender: self)
                        //self.performSegueWithIdentifier("fetchaddressbooksegue", sender: self)
                        //*********************%%%%%%%%%%%%%%%%%%%%%%%%% commented new
                        
                        self.dismissViewControllerAnimated(false, completion: { () -> Void in
                            
                            print("logged in going to contactlist")
                        })
                        
                        
                        //self.performSegueWithIdentifier(<#T##identifier: String##String#>, sender: <#T##AnyObject?#>)
                        
                    default:
                        print(error)
                        socketObj.socket.emit("logClient","error in display name routine \(error)")
                        
                        
                    }
                    
                    
                    
                    //when server sends response:
                    
            }
        }
        
        
    }
    
    */
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */



/*
// MARK: - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
// Get the new view controller using segue.destinationViewController.
// Pass the selected object to the new view controller.
}
*/

*/
