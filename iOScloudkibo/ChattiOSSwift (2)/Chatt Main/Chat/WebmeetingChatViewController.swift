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

class WebmeetingChatViewController
//: UIViewController,WebMeetingChatDelegate,FileReceivedAlertDelegate 
{

/*
        var rt=NetworkingLibAlamofire()
        
        var delegateFileReceived:FileReceivedAlertDelegate!
        @IBOutlet weak var NewChatNavigationTitle: UINavigationItem!
        @IBOutlet weak var labelToName: UILabel!
        @IBOutlet var tblForChats : UITableView!
        @IBOutlet var chatComposeView : UIView!
        @IBOutlet var txtFldMessage : UITextField!
        var videoCont:VideoViewController!
        @IBOutlet weak var btn_chatDeleteHistory: UIBarButtonItem!
        
        var tbl_userchats:Table!
        
        var messages : NSMutableArray!
    
        var delegateChat:WebMeetingChatDelegate!
    
    func receivedChatMessageApdateUI(_ message: String, username: String) {
        //Reload table
        tblForChats.reloadData()
    
    }
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?)
        {
            super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
            print(Bundle.debugDescription())
            
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
        
    override func viewWillAppear(_ animated: Bool) {
        
        //videoCont=VideoViewController.init(nibName: "VideoViewController", bundle: nil)
        //videoCont.delegateFileReceived=self
        
    }
        override func viewDidLoad() {
            super.viewDidLoad()
            //videoCont=VideoViewController.init(nibName: "VideoViewController", bundle: nil)
            //videoCont.delegateFileReceived=self
            NotificationCenter.default.addObserver(self, selector: #selector(WebmeetingChatViewController.willShowKeyBoard(_:)), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(WebmeetingChatViewController.willHideKeyBoard(_:)), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
            
            
            messages = webMeetingModel.messages
            webMeetingModel.delegateWebmeetingChat=self
            
            
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
    
    func receivedChatMessageUpdateUI(_ message: String, username: String) {
        
        tblForChats.reloadData()
    }
    
    
    func addMessage(_ message: String, ofType msgType:String,usr:String) {
            messages.add(["message":message, "type":msgType,"username":usr])
            tblForChats.reloadData()
            
        }
    
        
    
        func tableView(_ tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
            return messages.count
            
        }
        
        func numberOfSectionsInTableView(_ tableView: UITableView!) -> Int {
            return 1
        }
        
        func tableView(_ tableView: UITableView, heightForRowAtIndexPath indexPath: IndexPath) -> CGFloat {
            var messageDic = messages.object(at: indexPath.row) as! [String : String];
            let msg = messageDic["message"] as NSString!
            let sizeOFStr = self.getSizeOfString(msg!)
            return sizeOFStr.height + 70
        }
        
        func tableView(_ tableView: UITableView!, cellForRowAtIndexPath indexPath: IndexPath!) -> UITableViewCell! {
            var cell : UITableViewCell!
            var messageDic = messages.object(at: indexPath.row) as! [String : String];
            NSLog(messageDic["message"]!, 1)
            let msgType = messageDic["type"] as NSString!
            let msg = messageDic["message"] as NSString!
            let sizeOFStr = self.getSizeOfString(msg!)
            let myInitialUsername=username!.substring(username!.characters.index(username!.startIndex, offsetBy: 1)).uppercased() as String
            
            let initialOfName=messageDic["username"]!.substring(messageDic["username"]!.characters.index(messageDic["username"]!.startIndex, offsetBy: 1)).uppercased() as String
            if (msgType?.isEqual(to: "1"))!{
                cell = tblForChats.dequeueReusableCell(withIdentifier: "ChatSentCell")! as UITableViewCell
                let textLable = cell.viewWithTag(12) as! UILabel
                let chatImage = cell.viewWithTag(1) as! UIImageView
                let profileImage = cell.viewWithTag(2) as! UIImageView
                let labelName = cell.viewWithTag(5) as! UILabel
                
                chatImage.frame = CGRect(x: chatImage.frame.origin.x, y: chatImage.frame.origin.y, width: ((sizeOFStr.width + 60)  > 100 ? (sizeOFStr.width + 60) : 100), height: sizeOFStr.height + 40)
                chatImage.image = UIImage(named: "chat_new_receive")?.stretchableImage(withLeftCapWidth: 40,topCapHeight: 20);
                textLable.frame = CGRect(x: textLable.frame.origin.x, y: textLable.frame.origin.y, width: textLable.frame.size.width, height: sizeOFStr.height)
                profileImage.center = CGPoint(x: profileImage.center.x, y: textLable.frame.origin.y + textLable.frame.size.height - profileImage.frame.size.height/2 + 10)
                textLable.text = "\(msg)"
                labelName.text=initialOfName
                print("ifffffffff")
                
            } else {
                cell = tblForChats.dequeueReusableCell(withIdentifier: "ChatReceivedCell")! as UITableViewCell
                let deliveredLabel = cell.viewWithTag(13) as! UILabel
                let textLable = cell.viewWithTag(12) as! UILabel
                let timeLabel = cell.viewWithTag(11) as! UILabel
                let chatImage = cell.viewWithTag(1) as! UIImageView
                let profileImage = cell.viewWithTag(2) as! UIImageView
                let labelName = cell.viewWithTag(5) as! UILabel
                let distanceFactor = (170.0 - sizeOFStr.width) < 130 ? (170.0 - sizeOFStr.width) : 130
                
                chatImage.frame = CGRect(x: 20 + distanceFactor, y: chatImage.frame.origin.y, width: ((sizeOFStr.width + 60)  > 100 ? (sizeOFStr.width + 60) : 100), height: sizeOFStr.height + 40)
                chatImage.image = UIImage(named: "chat_new_send")?.stretchableImage(withLeftCapWidth: 20,topCapHeight: 20);
                textLable.frame = CGRect(x: 36 + distanceFactor, y: textLable.frame.origin.y, width: textLable.frame.size.width, height: sizeOFStr.height)
                profileImage.center = CGPoint(x: profileImage.center.x, y: textLable.frame.origin.y + textLable.frame.size.height - profileImage.frame.size.height/2 + 10)
                //******
                
                //*******
                timeLabel.frame = CGRect(x: 36 + distanceFactor, y: timeLabel.frame.origin.y, width: timeLabel.frame.size.width, height: timeLabel.frame.size.height)
                deliveredLabel.frame = CGRect(x: deliveredLabel.frame.origin.x, y: textLable.frame.origin.y + textLable.frame.size.height + 20, width: deliveredLabel.frame.size.width, height: deliveredLabel.frame.size.height)
                textLable.text = "\(msg)"
                labelName.text=myInitialUsername
                print("elseeeeee")
            }
            return cell
        }
        
        func willShowKeyBoard(_ notification : Notification){
            
            var userInfo: NSDictionary!
            userInfo = notification.userInfo as NSDictionary!
            
            var duration : TimeInterval = 0
            var curve = userInfo.object(forKey: UIKeyboardAnimationCurveUserInfoKey) as! UInt
            duration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as! TimeInterval
            let keyboardF:NSValue = userInfo.object(forKey: UIKeyboardFrameEndUserInfoKey) as! NSValue
            let keyboardFrame = keyboardF.cgRectValue
            
            UIView.animate(withDuration: duration, delay: 0, options:[], animations: {
                self.chatComposeView.frame = CGRect(x: self.chatComposeView.frame.origin.x, y: self.chatComposeView.frame.origin.y - keyboardFrame.size.height+self.chatComposeView.frame.size.height+3, width: self.chatComposeView.frame.size.width, height: self.chatComposeView.frame.size.height)
                
                self.tblForChats.frame = CGRect(x: self.tblForChats.frame.origin.x, y: self.tblForChats.frame.origin.y, width: self.tblForChats.frame.size.width, height: self.tblForChats.frame.size.height - keyboardFrame.size.height+49);
                }, completion: nil)
            if(messages.count>1)
            {
            let indexPath = IndexPath(row:messages.count-1, section: 0)
            tblForChats.scrollToRow(at: indexPath, at: UITableViewScrollPosition.bottom, animated: true)
            }
            
        }
        
        func willHideKeyBoard(_ notification : Notification){
            
            var userInfo: NSDictionary!
            userInfo = notification.userInfo as NSDictionary!
            
            var duration : TimeInterval = 0
            var curve = userInfo.object(forKey: UIKeyboardAnimationCurveUserInfoKey) as! UInt
            duration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as! TimeInterval
            let keyboardF:NSValue = userInfo.object(forKey: UIKeyboardFrameEndUserInfoKey) as! NSValue
            let keyboardFrame = keyboardF.cgRectValue
            
            
            UIView.animate(withDuration: duration, delay: 0, options:[], animations: {
                self.chatComposeView.frame = CGRect(x: self.chatComposeView.frame.origin.x, y: self.chatComposeView.frame.origin.y + keyboardFrame.size.height-self.chatComposeView.frame.size.height-3, width: self.chatComposeView.frame.size.width, height: self.chatComposeView.frame.size.height)
                self.tblForChats.frame = CGRect(x: self.tblForChats.frame.origin.x, y: self.tblForChats.frame.origin.y, width: self.tblForChats.frame.size.width, height: self.tblForChats.frame.size.height + keyboardFrame.size.height-49);
                }, completion: nil)
            
        }
        
        func textFieldShouldReturn (_ textField: UITextField!) -> Bool{
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
            
            
            //%%%%%% socketObj.socket.emit("conference.chat",["message":"\(txtFldMessage.text!)","username":username!])
            
            socketObj.socket.emit("conference.chat",["message":"\(txtFldMessage.text!)","phone":iamincallWith!])
            
            //////
            
            
            
            self.addMessage(txtFldMessage.text!, ofType: "2",usr: username!)
            txtFldMessage.text = "";
            tblForChats.reloadData()
            
            let indexPath = IndexPath(row:messages.count-1, section: 0)
            tblForChats.scrollToRow(at: indexPath, at: UITableViewScrollPosition.bottom, animated: true)
        }
        
        func getSizeOfString(_ postTitle: NSString) -> CGSize {
            // Get the height of the font
            let constraintSize = CGSize(width: 170, height: CGFloat.greatestFiniteMagnitude)
            
            let attributes = [NSFontAttributeName:UIFont.systemFont(ofSize: 11.0)]
            let labelSize = postTitle.boundingRect(with: constraintSize,
                options: NSStringDrawingOptions.usesLineFragmentOrigin,
                attributes: attributes,
                context: nil)
            return labelSize.size
        }
        
   
        
    @IBAction func btnBackToConferencePressed(_ sender: AnyObject) {
    
        self.dismiss(animated: true, completion: nil)
    }
    func didReceiveFileConference()
    {print("hereeeeee")
        //videoCont.btnViewFile.enabled=true
        let alert = UIAlertController(title: "Success", message: "You have received a new file. You can view files by clicking on \"View\" button present on Main conference page.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        //alert.showViewController(videoCont, sender: nil)
        self.present(alert, animated: true, completion: nil)
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
    */*/*/
}
