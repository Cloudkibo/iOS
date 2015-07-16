//
//  ChatDetailViewController.swift
//  Chat
//
//  Created by My App Templates Team on 26/08/14.
//  Copyright (c) 2014 My App Templates. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SQLite

protocol DetailsDelegate { func labelDelegateMethodWithString(string: String) }


class ChatDetailViewController: UIViewController {

    @IBOutlet var tblForChats : UITableView!
    @IBOutlet var chatComposeView : UIView!
    @IBOutlet var txtFldMessage : UITextField!
    var messages : NSMutableArray!
    
    
   
    
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        // Custom initialization
    }

    required init(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        
        let db = Database("/Users/cloudkibo/Desktop/iOS/db.sqlite3")
        
        let user = db["users"]
        let user_username = Expression<String>("username")
        
        
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("willShowKeyBoard:"), name:UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("willHideKeyBoard:"), name:UIKeyboardWillHideNotification, object: nil)
        
        
        messages = NSMutableArray()
        //self.addMessage("Its actually pretty good!", ofType: "1")
        //self.addMessage("What do you think of this tool!", ofType: "2")
        //self.addMessage("Saba here !", ofType: "2")
        
   
        //println(globalToken)
        Alamofire.request(.POST, "https://www.cloudkibo.com/api/userchat/?access_token=" + globalToken ,parameters: ["user1" : "sabachanna", "user2" : "sojharo"])
            .responseJSON { (request, response, data, error) in
                println(request)
                println(response)
                println(data)
                println(error)
                
                
                let uc_res_jsonData = JSON(data!)
                
                let uc_jsonArray = JSON(uc_res_jsonData["msg"].arrayObject!)
                
                //println(uc_jsonArray)
                
                let userchat = db["userchat"]
                let uc_id = Expression<String>("_id")
                let uc_date = Expression<String>("date")
                let uc_from = Expression<String>("from")
                let uc_msg = Expression<String>("msg")
                let uc_fromFullName = Expression<String>("fromFullName")
                let owneruser = Expression<String>("owneruser")
                let uc_to = Expression<String>("to")
                
                db.drop(table: userchat, ifExists: true);
                
                db.create(table: userchat, ifNotExists: true) { t in
                    t.column(uc_id, defaultValue: "Anonymous")
                    t.column(uc_date, defaultValue: "Anonymous")
                    t.column(uc_from, defaultValue: "Anonymous")
                    t.column(uc_msg, defaultValue: "Anonymous")
                    t.column(uc_fromFullName, defaultValue: "0987")
                    t.column(owneruser, defaultValue: "Anonymous")
                    t.column(uc_to, defaultValue: "Anonymous")
                    
                }// db created
                
                 for (index: String, subJson: JSON) in uc_jsonArray {
                    
                    //println(subJson)
                    let  c_insertID = userchat.insert(
                        uc_id <- subJson["_id"].string!,
                        uc_date <- subJson["date"].string!,
                        uc_from <- subJson["from"].string!,
                        uc_msg <- subJson["msg"].string!,
                        uc_fromFullName <- subJson["fromFullName"].string!,
                        owneruser <- subJson["owneruser"].string!,
                        uc_to <- subJson["to"].string!)
                
                }
                ///println("row inserted are  ");
                
                //println(userchat.count)
                
                for chat in userchat {
                    println("INSERTED DATA: msg: \(chat[uc_msg]), from: \(chat[uc_fromFullName]), to: \(chat[uc_to])")
                    
                    let str1: String = user.first!.get(user_username)
                    let str2: String = chat[uc_to]
                    
                    if(str1 == str2){
                        
                        self.addMessage(chat[uc_msg], ofType: "1")
                    
                    }
                    else{
                    
                        self.addMessage(chat[uc_msg], ofType: "2")
                        
                    }
                    
                    
                    
                    self.tblForChats.reloadData()
                }
                
                
        }//alamofire
        
        

        

        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addMessage(message: String, ofType msgType:String) {
        messages.addObject(["message":message, "type":msgType])
    }
    
    
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView!) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        var messageDic = messages.objectAtIndex(indexPath.row) as! [String : String];
        var msg: NSString = messageDic["message"] as NSString!
        var sizeOFStr = self.getSizeOfString(msg)
        return sizeOFStr.height + 70
    }
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        var cell : UITableViewCell!
        var messageDic = messages.objectAtIndex(indexPath.row) as! [String : String];
        NSLog(messageDic["message"]!, 1)
        var msgType = messageDic["type"] as NSString!
        var msg = messageDic["message"] as NSString!
        var sizeOFStr = self.getSizeOfString(msg)
        
        if (msgType.isEqualToString("1")){
            cell = tblForChats.dequeueReusableCellWithIdentifier("ChatSentCell") as! UITableViewCell
            var textLable = cell.viewWithTag(12) as! UILabel
            var chatImage = cell.viewWithTag(1) as! UIImageView
            var profileImage = cell.viewWithTag(2) as! UIImageView
            chatImage.frame = CGRectMake(chatImage.frame.origin.x, chatImage.frame.origin.y, ((sizeOFStr.width + 60)  > 100 ? (sizeOFStr.width + 60) : 100), sizeOFStr.height + 40)
            chatImage.image = UIImage(named: "chat_new_receive")?.stretchableImageWithLeftCapWidth(40,topCapHeight: 20);
            textLable.frame = CGRectMake(textLable.frame.origin.x, textLable.frame.origin.y, textLable.frame.size.width, sizeOFStr.height)
            profileImage.center = CGPointMake(profileImage.center.x, textLable.frame.origin.y + textLable.frame.size.height - profileImage.frame.size.height/2 + 10)
            textLable.text = msg as String;
        } else {
            cell = tblForChats.dequeueReusableCellWithIdentifier("ChatReceivedCell") as! UITableViewCell
            var deliveredLabel = cell.viewWithTag(13) as! UILabel
            var textLable = cell.viewWithTag(12) as! UILabel
            var timeLabel = cell.viewWithTag(11) as! UILabel
            var chatImage = cell.viewWithTag(1) as! UIImageView
            var profileImage = cell.viewWithTag(2) as! UIImageView
            var distanceFactor = (170.0 - sizeOFStr.width) < 130 ? (170.0 - sizeOFStr.width) : 130
            chatImage.frame = CGRectMake(20 + distanceFactor, chatImage.frame.origin.y, ((sizeOFStr.width + 60)  > 100 ? (sizeOFStr.width + 60) : 100), sizeOFStr.height + 40)
            chatImage.image = UIImage(named: "chat_new_send")?.stretchableImageWithLeftCapWidth(20,topCapHeight: 20);
            textLable.frame = CGRectMake(36 + distanceFactor, textLable.frame.origin.y, textLable.frame.size.width, sizeOFStr.height)
            profileImage.center = CGPointMake(profileImage.center.x, textLable.frame.origin.y + textLable.frame.size.height - profileImage.frame.size.height/2 + 10)
            timeLabel.frame = CGRectMake(36 + distanceFactor, timeLabel.frame.origin.y, timeLabel.frame.size.width, timeLabel.frame.size.height)
            deliveredLabel.frame = CGRectMake(deliveredLabel.frame.origin.x, textLable.frame.origin.y + textLable.frame.size.height + 20, deliveredLabel.frame.size.width, deliveredLabel.frame.size.height)
            textLable.text = msg as String;
        }
        return cell
    }
    
    func willShowKeyBoard(notification : NSNotification){
        
        var userInfo: NSDictionary!
        userInfo = notification.userInfo
        
        var duration : NSTimeInterval = 0
        var curve = userInfo.objectForKey(UIKeyboardAnimationCurveUserInfoKey) as! UInt
        duration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSTimeInterval
        var keyboardF:NSValue = userInfo.objectForKey(UIKeyboardFrameEndUserInfoKey) as! NSValue
        var keyboardFrame = keyboardF.CGRectValue()
        
        UIView.animateWithDuration(duration, delay: 0, options:nil, animations: {
            self.chatComposeView.frame = CGRectMake(self.chatComposeView.frame.origin.x, self.chatComposeView.frame.origin.y - keyboardFrame.size.height+self.chatComposeView.frame.size.height+3, self.chatComposeView.frame.size.width, self.chatComposeView.frame.size.height)
            
            self.tblForChats.frame = CGRectMake(self.tblForChats.frame.origin.x, self.tblForChats.frame.origin.y, self.tblForChats.frame.size.width, self.tblForChats.frame.size.height - keyboardFrame.size.height+49);
            }, completion: nil)
        var indexPath = NSIndexPath(forRow:messages.count-1, inSection: 0)
        tblForChats.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Bottom, animated: true)
        
    }
    
    func willHideKeyBoard(notification : NSNotification){
        
        var userInfo: NSDictionary!
        userInfo = notification.userInfo
        
        var duration : NSTimeInterval = 0
        var curve = userInfo.objectForKey(UIKeyboardAnimationCurveUserInfoKey)as! UInt
        duration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSTimeInterval
        var keyboardF:NSValue = userInfo.objectForKey(UIKeyboardFrameEndUserInfoKey) as! NSValue
        var keyboardFrame = keyboardF.CGRectValue()
        
        UIView.animateWithDuration(duration, delay: 0, options:nil, animations: {
            self.chatComposeView.frame = CGRectMake(self.chatComposeView.frame.origin.x, self.chatComposeView.frame.origin.y + keyboardFrame.size.height-self.chatComposeView.frame.size.height-3, self.chatComposeView.frame.size.width, self.chatComposeView.frame.size.height)
            self.tblForChats.frame = CGRectMake(self.tblForChats.frame.origin.x, self.tblForChats.frame.origin.y, self.tblForChats.frame.size.width, self.tblForChats.frame.size.height + keyboardFrame.size.height-49);
            }, completion: nil)
        
    }
    
    func textFieldShouldReturn (textField: UITextField!) -> Bool{
        textField.resignFirstResponder()
        return true
    }
    
    var delegate: DetailsDelegate!
    
    @IBAction func postBtnTapped() {
    
        self.addMessage(txtFldMessage.text, ofType: "1")
        self.addMessage(txtFldMessage.text, ofType: "2")
        txtFldMessage.text = "";
        tblForChats.reloadData()
        
        delegate.labelDelegateMethodWithString("hello")
        
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
        return labelSize.size//
        
        
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
