//
//  ViewController.swift
//  Chat
//
//  Created by My App Templates Team on 24/08/14.
//  Copyright (c) 2014 My App Templates. All rights reserved.
//

import UIKit
import AccountKit
import Alamofire


class ViewController: UIViewController{
    
    var accountKit: AKFAccountKit!
    
    @IBOutlet weak var accountID: UILabel!
    //@IBOutlet weak var accountID: UILabel!
    //@IBOutlet weak var labeltype: UILabel!
    //@IBOutlet weak var phoneornumber: UILabel!
    
    @IBOutlet weak var phoneornumber: UILabel!
    @IBOutlet weak var labeltype: UILabel!
    //@IBOutlet weak var labeltype: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        print("loaded .. *****")
        // initialize Account Kit
        if accountKit == nil {
            
            //specify AKFResponseType.AccessToken
            self.accountKit = AKFAccountKit(responseType: AKFResponseType.AccessToken)
            accountKit.requestAccount{
                (account, error) -> Void in
                
                
                
                
                //**********
                
                                if(account != nil){
                                    var url=Constants.MainUrl+Constants.getContactsList
                                    
                                    let header:[String:String]=["kibo-token":(self.accountKit.currentAccessToken?.tokenString)!]
                                    
                                    print(header)
                                    

                Alamofire.request(.GET,"\(url)",headers:header).validate(statusCode: 200..<300)
                    .response { (request1, response1, data1, error1) in
                        print("success")
                        
                        
                        
                        
                        //============GOT Contacts SECCESS=================
                        
                        
                        ////////////////////////
                        //^^^^^ dispatch_async(dispatch_get_main_queue(), {
                        //self.fetchContacts(self.AuthToken)
                        /// activityOverlayView.dismissAnimated(true)
                        
                        
                        if response1?.statusCode==200 {
                            
                            
                        }}
                }
                
                /*Alamofire.request(.POST,"\(url)",headers:header).response{
                    request, response_, _data, error in
                    print(error)
                    
                    if response_?.statusCode==200
                        
                    {
                       
                        
                    }
                }*/
                self.accountID.text = account?.accountID
                
                
                if account?.emailAddress?.characters.count > 0 {
                    //if the user is logged with email
                    self.labeltype.text = "Email Address"
                    self.phoneornumber.text = account!.emailAddress
                    
                }
                else if account?.phoneNumber?.phoneNumber != nil {
                    //if the user is logged with phone
                    self.labeltype.text = "Phone Number"
                    self.phoneornumber.text = account!.phoneNumber?.stringRepresentation()
                }
                
                
                
                
            }
            
        }
    }
    
    
    @IBAction func logout(sender: AnyObject) {
        //You can invoke the logOut method to log a user out of Account Kit.
        accountKit.logOut()
        dismissViewControllerAnimated(true, completion: nil)
    }
    /*@IBAction func logout(sender: AnyObject) {
        //You can invoke the logOut method to log a user out of Account Kit.
        accountKit.logOut()
        dismissViewControllerAnimated(true, completion: nil)
    }*/
    
}


