//
//  ChatComposeViewController.swift
//  Chat
//
//  Created by My App Templates Team on 26/08/14.
//  Copyright (c) 2014 My App Templates. All rights reserved.
//

import UIKit

class ChatComposeViewController: UIViewController {

    @IBOutlet var recepientTextField : UITextField!
    @IBOutlet var chatComposeView : UIView!

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        // Custom initialization
    }

    
/*
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }*/
    required init?(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(ChatComposeViewController.willShowKeyBoard(_:)), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        recepientTextField.becomeFirstResponder()
        // Do any additional setup after loading the view.
    }
    
    func willShowKeyBoard(_ notification : Notification){
        
        var userInfo: NSDictionary!
        userInfo = notification.userInfo as NSDictionary!
        
        var duration : TimeInterval = 0
        var curve = userInfo.object(forKey: UIKeyboardAnimationCurveUserInfoKey) as! UInt
        duration = userInfo[UIKeyboardAnimationDurationUserInfoKey]as! TimeInterval
        let keyboardF:NSValue = userInfo.object(forKey: UIKeyboardFrameEndUserInfoKey)as! NSValue
        let keyboardFrame = keyboardF.cgRectValue
        
        UIView.animate(withDuration: duration, delay: 0, options:[], animations: {
            self.chatComposeView.frame = CGRect(x: self.chatComposeView.frame.origin.x, y: self.chatComposeView.frame.origin.y - keyboardFrame.size.height, width: self.chatComposeView.frame.size.width, height: self.chatComposeView.frame.size.height)
            }, completion: nil)
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func canceBtnTapped(){
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func postBtnTapped(){
        self.dismiss(animated: true, completion: nil)
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
