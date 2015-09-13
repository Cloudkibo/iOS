//
//  ChatDetailViewController.swift
//  Chat
//
//  Created by My App Templates Team on 26/08/14.
//  Copyright (c) 2014 My App Templates. All rights reserved.
//

import UIKit
import SwiftyJSON
import SQLite
import Alamofire

class ChatDetailViewController: UIViewController {
    
    @IBOutlet weak var NewChatNavigationTitle: UINavigationItem!
    @IBOutlet weak var labelToName: UILabel!
    @IBOutlet var tblForChats : UITableView!
    @IBOutlet var chatComposeView : UIView!
    @IBOutlet var txtFldMessage : UITextField!
    
    
    
    var selectedContact=""
    var selectedID=""
    var selectedUserObj=JSON("")
    let to = Expression<String>("to")
    let from = Expression<String>("from")
    let fromFullName = Expression<String>("fromFullName")
    let msg = Expression<String>("msg")
    let date = Expression<NSDate>("date")
    
    var tbl_userchats:Query!
    
    var messages : NSMutableArray!
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?)
    {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        println(NSBundle)
        
        // Custom initialization
    }
    
    required init(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        //println("hiiiiii22 \(self.AuthToken)")
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("willShowKeyBoard:"), name:UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("willHideKeyBoard:"), name:UIKeyboardWillHideNotification, object: nil)
        messages = NSMutableArray()
        //self.performSegueWithIdentifier("chatSegue", sender: nil)
        
        println("chat detail view")
        
        // dispatch_async(dispatch_get_main_queue(), {
        
        
        FetchChatServer()
        //self.getUserObjectById()
        /*dispatch_async(dispatch_get_main_queue(), {
        
        
        self.markChatAsRead()
        })
        */
        /*dispatch_async(dispatch_get_global_queue(Int(QOS_CLASS_USER_INITIATED.value), 0)) { // 1
        //let overlayImage = self.faceOverlayImageFromImage(self.image)
        self.getUserObjectById()
        self.markChatAsRead()
        
        dispatch_async(dispatch_get_main_queue()) { // 2
        //self.fadeInNewImage(overlayImage) // 3
        
        
        }
        }*/
        // })
        
        //getUserObjectById()
        //markChatAsRead()
        
        
        //^^self.tbl_userchats=sqliteDB.db["userschats"]
        self.NewChatNavigationTitle.title=selectedContact
        var receivedMsg=JSON("")
        socketObj.socket.on("im") {data,ack in
            
            println("chat sent to server.ack received")
            var chatJson=JSON(data!)
            println(chatJson[0]["msg"])
            receivedMsg=chatJson[0]["msg"]
            var username=chatJson[0]["fullName"]
            
            
            self.addMessage(receivedMsg.description, ofType: "1")
            
            
            
            self.tblForChats.reloadData()
            var indexPath = NSIndexPath(forRow:self.messages.count-1, inSection: 0)
            self.tblForChats.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Bottom, animated: true)
            
            sqliteDB.SaveChat(chatJson[0]["to"].string!, from1: chatJson[0]["from"].string!, fromFullName1: chatJson[0]["fromFullName"].string!, msg1: chatJson[0]["msg"].string!)
            /* ^^^let insert=self.tbl_userchats.insert(self.fromFullName<-chatJson[0]["fromFullName"].string!,
            self.msg<-chatJson[0]["msg"].string!,
            //self.owneruser<-chatJson[0]["owneruser"].string!,
            self.to<-chatJson[0]["to"].string!,
            self.from<-chatJson[0]["from"].string!
            )
            if let rowid = insert.rowid {
            println("inserted id: \(rowid)")
            } else if insert.statement.failed {
            println("insertion failed: \(insert.statement.reason)")
            }
            */
        }
        /*  self.addMessage("Its actually pretty good!", ofType: "1")
        self.addMessage("What do you think of this tool!", ofType: "2")*/
    }
    func getUserObjectById()
    {
        var getUserbByIdURL=Constants.MainUrl+Constants.getSingleUserByID+self.selectedID+"?access_token="+AuthToken
        println(getUserbByIdURL.debugDescription+"..........")
        Alamofire.request(.GET,"\(getUserbByIdURL)").response{
            request, response, data, error in
            //println(error)
            
            if response?.statusCode==200
                
            {
                println("got userrrrrrr")
                println(data!.debugDescription)
                self.selectedUserObj=JSON(data!)
            }
            else
            {
                println("didnt get userrrrr")
                println(error)
                println(data)
                println(response)
            }
        }
        
    }
    
    func markChatAsRead()
    {
        
        var markChatReadURL=Constants.MainUrl+Constants.markAsRead+"?access_token=\(AuthToken)"
        println(["user1":"\(loggedUserObj)","user2":"\(self.selectedUserObj)"])
        println("**")
        Alamofire.request(.POST,"\(markChatReadURL)",parameters: ["user1":"\(loggedUserObj)","user2":"\(self.selectedUserObj)"]
            ).responseJSON{
                request1, response1, data1, error1 in
                
                //===========INITIALISE SOCKETIOCLIENT=========
                // dispatch_async(dispatch_get_main_queue(), {
                
                //self.dismissViewControllerAnimated(true, completion: nil);
                /// self.performSegueWithIdentifier("loginSegue", sender: nil)
                
                if response1?.statusCode==200 {
                    println("chat marked as read")
                    //println(request1)
                    println(data1)
                    var UserchatJson=JSON(data1!)
                }
                else
                {println("chat not marked as read")
                    println(error1)
                    println(data1)}
        }
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addMessage(message: String, ofType msgType:String) {
        messages.addObject(["message":message, "type":msgType])
    }
    
    func fetchChatSQlite(){
        
        
    }
    
    func FetchChatServer()
    {
        
        println("[user1:\(username!),user2:\(selectedContact)]")
        
        var bringUserChatURL=Constants.MainUrl+Constants.bringUserChat+"?access_token="+AuthToken
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        Alamofire.request(.POST,"\(bringUserChatURL)",parameters: ["user1":"\(username!)","user2":"\(selectedContact)"]
            ).responseJSON{
                request1, response1, data1, error1 in
                
                //===========INITIALISE SOCKETIOCLIENT=========
                // dispatch_async(dispatch_get_main_queue(), {
                
                //self.dismissViewControllerAnimated(true, completion: nil);
                /// self.performSegueWithIdentifier("loginSegue", sender: nil)
                
                if response1?.statusCode==200 {
                    println("chatttttttt:::::")
                    //println(request1)
                    // println(data1)
                    var UserchatJson=JSON(data1!)
                    println(UserchatJson["msg"][0])
                    println(UserchatJson["msg"][0]["to"])
                    
                    //Overwrite sqlite db
                    sqliteDB.deleteChat(self.selectedContact)
                    for var i=0;i<UserchatJson["msg"].count
                        ;i++
                    {
                        sqliteDB.SaveChat(UserchatJson["msg"][i]["to"].string!, from1: UserchatJson["msg"][i]["from"].string!, fromFullName1: UserchatJson["msg"][i]["fromFullName"].string!, msg1: UserchatJson["msg"][i]["msg"].string!)
                        
                        if (UserchatJson["msg"][i]["from"].string==username)
                            
                        {//type1
                            self.addMessage(UserchatJson["msg"][i]["msg"].string!, ofType: "2")
                        }
                        else
                        {//type2
                            self.addMessage(UserchatJson["msg"][i]["msg"].string!, ofType: "1")
                            
                        }
                        self.tblForChats.reloadData()
                        var indexPath = NSIndexPath(forRow:self.messages.count-1, inSection: 0)
                        self.tblForChats.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Bottom, animated: true)
                        
                    }
                }
                else
                {
                    println("chatttttt faileddddddd")
                    println(request1)
                    println(error1)
                    println(data1)
                }
                //})
        }
        
        
    }
    
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView!) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        var messageDic = messages.objectAtIndex(indexPath.row) as! [String : String];
        var msg = messageDic["message"] as NSString!
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
            textLable.text = "\(msg)"
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
        var curve = userInfo.objectForKey(UIKeyboardAnimationCurveUserInfoKey) as! UInt
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
    
    @IBAction func postBtnTapped() {
        
        
        ///=== code for sending chat here
        ///=================
        
        var imParas=["from":"\(username!)","to":"\(selectedContact)","from_id":"55351437fff0f13a73518ae1","to_id":"55dafd46aa4c720e78e23776","fromFullName":"Sabach Channa","msg":"\(txtFldMessage.text)"]
        
        println(imParas)
        println()
        ///=== code for sending chat here
        ///=================
        
        
        socketObj.socket.emit("im",["room":"globalchatroom","stanza":imParas])
        
        //////
        
        sqliteDB.SaveChat("\(selectedContact)", from1: "\(username)", fromFullName1: "Sabach Channa", msg1: "\(txtFldMessage.text)")
        
        /*insert(self.fromFullName<-"Sabach Channa",
        self.msg<-"\(txtFldMessage.text)",
        //self.owneruser<-"sabachanna",
        self.to<-"sumi",
        self.from<-"sabachanna"
        )
        if let rowid = insert.rowid {
        println("inserted id: \(rowid)")
        } else if insert.statement.failed {
        println("insertion failed: \(insert.statement.reason)")
        }*/
        
        
        self.addMessage(txtFldMessage.text, ofType: "2")
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
    
    
    
    /*
    // #pragma mark - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue?, sender: AnyObject?) {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    
    
    }
    */
    
    
}