//
//  ForgotPasswordViewController.swift
//  Chat
//
//  Created by Cloudkibo on 15/07/2015.
//  Copyright (c) 2015 MyAppTemplates. All rights reserved.
//

import Foundation

/*class ForgotPasswordViewController: UIViewController {

    let userEmail = userEmailTextField.textPFUser.requestPasswordResetForEmailInBackground(userEmail) {
        (success:Bool, error:NSError?) -> Void in
        if(success)
        {
            let successMessage = “Email message was sent to you at \(userEmail)”
            self.displayMessage(successMessage)
            return
        }
        if(error != nil)
        {
            let errorMessage:String = error!.userInfo![“error,”] as! String
            self.displayMessage(errorMessage)
        }
    }
    
    var emailVar = emailField.text
    PFUser.requestPasswordResetForEmailInBackground(emailVar) { (success: Bool, error: NSError!) -> Void in
    
    if (error == nil) {
    
    let alertView = UIAlertController(title: "Password recovery e-mail sent", message: "Please check your e-mail inbox for recovery", preferredStyle: .Alert)
    alertView.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
    self.presentViewController(alertView, animated: true, completion: nil)
    
    }else {
    
    let alertView = UIAlertController(title: "Could not found your e-mail", message: "There is no such e-mail in our database", preferredStyle: .Alert)
    alertView.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
    self.presentViewController(alertView, animated: true, completion: nil)
    
    }
    }
    
}*/