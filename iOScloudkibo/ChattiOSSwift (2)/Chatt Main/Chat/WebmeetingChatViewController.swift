//
//  WebmeetingChatViewController.swift
//  Chat
//
//  Created by Cloudkibo on 16/02/2016.
//  Copyright © 2016 MyAppTemplates. All rights reserved.
//

import UIKit
import SwiftyJSON
import SQLite
import Alamofire

class WebmeetingChatViewController: UIViewController {
    
        var rt=NetworkingLibAlamofire()
        
        @IBOutlet weak var NewChatNavigationTitle: UINavigationItem!
        @IBOutlet weak var labelToName: UILabel!
        @IBOutlet var tblForChats : UITableView!
        @IBOutlet var chatComposeView : UIView!
        @IBOutlet var txtFldMessage : UITextField!
        
        @IBOutlet weak var btn_chatDeleteHistory: UIBarButtonItem!
        
        var tbl_userchats:Table!
        
        var messages : NSMutableArray!
    
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?)
        {
            super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
            print(NSBundle.debugDescription())
            
            // Custom initialization
        }
        
        
        /*
        required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        }*/
    
        required init?(coder aDecoder: NSCoder){
            super.init(coder: aDecoder)
            //print("hiiiiii22 \(self.AuthToken)")
            
        }
        
        
        override func viewDidLoad() {
            super.viewDidLoad()
            NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("willShowKeyBoard:"), name:UIKeyboardWillShowNotification, object: nil)
            NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("willHideKeyBoard:"), name:UIKeyboardWillHideNotification, object: nil)
            
            messages = webMeetingModel.messages
            
            
            
            self.NewChatNavigationTitle.title="webmeeting/test"
            var receivedMsg=JSON("")
            
            ///////messages.addObject(["message":"helloo","hiiii":"tstingggg","type":"1"])
            /*  self.addMessage("Its actually pretty good!", ofType: "1")
            self.addMessage("What do you think of this tool!", ofType: "2")*/
        }
    
        
        
    
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }
    
        /*func receivedChatMessage(message:String,username:String)
        {
            messages.addObject(["message":"\(username): \(message)","type":"1"])
            self.tblForChats.reloadData()
            var indexPath = NSIndexPath(forRow:self.messages.count-1, inSection: 0)
            self.tblForChats.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Bottom, animated: true)
        }*/
        
        func addMessage(message: String, ofType msgType:String) {
            messages.addObject(["message":message, "type":msgType])
            tblForChats.reloadData()
            
        }
    
        
    
        func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
            return messages.count
            
        }
        
        func numberOfSectionsInTableView(tableView: UITableView!) -> Int {
            return 1
        }
        
        func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
            var messageDic = messages.objectAtIndex(indexPath.row) as! [String : String];
            let msg = messageDic["message"] as NSString!
            let sizeOFStr = self.getSizeOfString(msg)
            return sizeOFStr.height + 70
        }
        
        func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
            var cell : UITableViewCell!
            var messageDic = messages.objectAtIndex(indexPath.row) as! [String : String];
            NSLog(messageDic["message"]!, 1)
            let msgType = messageDic["type"] as NSString!
            let msg = messageDic["message"] as NSString!
            let sizeOFStr = self.getSizeOfString(msg)
            
            if (msgType.isEqualToString("1")){
                cell = tblForChats.dequeueReusableCellWithIdentifier("ChatSentCell")! as UITableViewCell
                let textLable = cell.viewWithTag(12) as! UILabel
                let chatImage = cell.viewWithTag(1) as! UIImageView
                let profileImage = cell.viewWithTag(2) as! UIImageView
                chatImage.frame = CGRectMake(chatImage.frame.origin.x, chatImage.frame.origin.y, ((sizeOFStr.width + 60)  > 100 ? (sizeOFStr.width + 60) : 100), sizeOFStr.height + 40)
                chatImage.image = UIImage(named: "chat_new_receive")?.stretchableImageWithLeftCapWidth(40,topCapHeight: 20);
                textLable.frame = CGRectMake(textLable.frame.origin.x, textLable.frame.origin.y, textLable.frame.size.width, sizeOFStr.height)
                profileImage.center = CGPointMake(profileImage.center.x, textLable.frame.origin.y + textLable.frame.size.height - profileImage.frame.size.height/2 + 10)
                textLable.text = "\(msg)"
            } else {
                cell = tblForChats.dequeueReusableCellWithIdentifier("ChatReceivedCell")! as UITableViewCell
                let deliveredLabel = cell.viewWithTag(13) as! UILabel
                let textLable = cell.viewWithTag(12) as! UILabel
                let timeLabel = cell.viewWithTag(11) as! UILabel
                let chatImage = cell.viewWithTag(1) as! UIImageView
                let profileImage = cell.viewWithTag(2) as! UIImageView
                let distanceFactor = (170.0 - sizeOFStr.width) < 130 ? (170.0 - sizeOFStr.width) : 130
                chatImage.frame = CGRectMake(20 + distanceFactor, chatImage.frame.origin.y, ((sizeOFStr.width + 60)  > 100 ? (sizeOFStr.width + 60) : 100), sizeOFStr.height + 40)
                chatImage.image = UIImage(named: "chat_new_send")?.stretchableImageWithLeftCapWidth(20,topCapHeight: 20);
                textLable.frame = CGRectMake(36 + distanceFactor, textLable.frame.origin.y, textLable.frame.size.width, sizeOFStr.height)
                profileImage.center = CGPointMake(profileImage.center.x, textLable.frame.origin.y + textLable.frame.size.height - profileImage.frame.size.height/2 + 10)
                timeLabel.frame = CGRectMake(36 + distanceFactor, timeLabel.frame.origin.y, timeLabel.frame.size.width, timeLabel.frame.size.height)
                deliveredLabel.frame = CGRectMake(deliveredLabel.frame.origin.x, textLable.frame.origin.y + textLable.frame.size.height + 20, deliveredLabel.frame.size.width, deliveredLabel.frame.size.height)
                textLable.text = "\(msg)"
            }
            return cell
        }
        
        func willShowKeyBoard(notification : NSNotification){
            
            var userInfo: NSDictionary!
            userInfo = notification.userInfo
            
            var duration : NSTimeInterval = 0
            var curve = userInfo.objectForKey(UIKeyboardAnimationCurveUserInfoKey) as! UInt
            duration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSTimeInterval
            let keyboardF:NSValue = userInfo.objectForKey(UIKeyboardFrameEndUserInfoKey) as! NSValue
            let keyboardFrame = keyboardF.CGRectValue()
            
            UIView.animateWithDuration(duration, delay: 0, options:[], animations: {
                self.chatComposeView.frame = CGRectMake(self.chatComposeView.frame.origin.x, self.chatComposeView.frame.origin.y - keyboardFrame.size.height+self.chatComposeView.frame.size.height+3, self.chatComposeView.frame.size.width, self.chatComposeView.frame.size.height)
                
                self.tblForChats.frame = CGRectMake(self.tblForChats.frame.origin.x, self.tblForChats.frame.origin.y, self.tblForChats.frame.size.width, self.tblForChats.frame.size.height - keyboardFrame.size.height+49);
                }, completion: nil)
            if(messages.count>1)
            {
            let indexPath = NSIndexPath(forRow:messages.count-1, inSection: 0)
            tblForChats.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Bottom, animated: true)
            }
            
        }
        
        func willHideKeyBoard(notification : NSNotification){
            
            var userInfo: NSDictionary!
            userInfo = notification.userInfo
            
            var duration : NSTimeInterval = 0
            var curve = userInfo.objectForKey(UIKeyboardAnimationCurveUserInfoKey) as! UInt
            duration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSTimeInterval
            let keyboardF:NSValue = userInfo.objectForKey(UIKeyboardFrameEndUserInfoKey) as! NSValue
            let keyboardFrame = keyboardF.CGRectValue()
            
            
            UIView.animateWithDuration(duration, delay: 0, options:[], animations: {
                self.chatComposeView.frame = CGRectMake(self.chatComposeView.frame.origin.x, self.chatComposeView.frame.origin.y + keyboardFrame.size.height-self.chatComposeView.frame.size.height-3, self.chatComposeView.frame.size.width, self.chatComposeView.frame.size.height)
                self.tblForChats.frame = CGRectMake(self.tblForChats.frame.origin.x, self.tblForChats.frame.origin.y, self.tblForChats.frame.size.width, self.tblForChats.frame.size.height + keyboardFrame.size.height-49);
                }, completion: nil)
            
        }
        
        func textFieldShouldReturn (textField: UITextField!) -> Bool{
            textField.resignFirstResponder()
            return true
        }
        
        @IBAction func postBtnTapped() {
            
            
            ///=== code for sending chat here
            ///=================
            
            //^^^^var loggedid=loggedUserObj["_id"]
            //var loggedid=_id!
            //^^var firstNameSelected=selectedUserObj["firstname"]
            //^^^var lastNameSelected=selectedUserObj["lastname"]
            //^^^var fullNameSelected=firstNameSelected.string!+" "+lastNameSelected.string!
           
            
            ///=== code for sending chat here
            ///=================
            
            
            socketObj.socket.emit("conference.chat",["message":"\(txtFldMessage.text!)","username":username!])
            
            //////
            
            
            
            self.addMessage(txtFldMessage.text!, ofType: "2")
            txtFldMessage.text = "";
            tblForChats.reloadData()
            
            var indexPath = NSIndexPath(forRow:messages.count-1, inSection: 0)
            tblForChats.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Bottom, animated: true)
        }
        
        func getSizeOfString(postTitle: NSString) -> CGSize {
            // Get the height of the font
            let constraintSize = CGSizeMake(170, CGFloat.max)
            
            let attributes = [NSFontAttributeName:UIFont.systemFontOfSize(11.0)]
            let labelSize = postTitle.boundingRectWithSize(constraintSize,
                options: NSStringDrawingOptions.UsesLineFragmentOrigin,
                attributes: attributes,
                context: nil)
            return labelSize.size
        }
        
   
        
    @IBAction func btnBackToConferencePressed(sender: AnyObject) {
    
        self.dismissViewControllerAnimated(true, completion: nil)
    }
        
        /*
        // delete slider to delete individual row
        // Override to support editing the table view.
        func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
        messages.removeObjectAtIndex(indexPath.row)
        // Delete the row from the data source
        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
        }
        
        */
        
        
        /*
        // #pragma mark - Navigation
        
        // In a storyboard-based application, you will often want to do a little preparation before navigation
        override func prepareForSegue(segue: UIStoryboardSegue?, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        
        
        
        }
        */
        
        
}
