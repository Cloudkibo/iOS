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

class ChatDetailViewController: UIViewController{
    
    var rt=NetworkingLibAlamofire()
    @IBOutlet weak var NewChatNavigationTitle: UINavigationItem!
    @IBOutlet weak var labelToName: UILabel!
    @IBOutlet var tblForChats : UITableView!
    @IBOutlet var chatComposeView : UIView!
    @IBOutlet var txtFldMessage : UITextField!
    
    @IBOutlet weak var btn_chatDeleteHistory: UIBarButtonItem!
    
    
    var selectedContact="" //username
    var selectedID=""
    var selectedFirstName=""
    var selectedLastName=""
    var selectedUserObj=JSON("[]")
    let to = Expression<String>("to")
    let from = Expression<String>("from")
    let fromFullName = Expression<String>("fromFullName")
    let msg = Expression<String>("msg")
    let date = Expression<NSDate>("date")
    
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
        messages = NSMutableArray()
        
        
                //self.performSegueWithIdentifier("chatSegue", sender: nil)
       
       /* var tbl_contactList=sqliteDB.db["contactslists"]
        let username = Expression<String>("username")
        let email = Expression<String>("email")
        let _id = Expression<String>("_id")
        //let detailsshared = Expression<String>("detailsshared")
        //let unreadMessage = Expression<Bool>("unreadMessage")
        let userid = Expression<String>("userid")
        let firstname = Expression<String>("firstname")
        let lastname = Expression<String>("lastname")
        let phone = Expression<String>("phone")
        let status = Expression<String>("status")
        
        for user in tbl_contactList.select(username, email,_id,userid,firstname,lastname,phone,status).filter(username==selectedContact) {
            print("id: \(user[username]), email: \(user[email])")
            var userObj=JSON(["_id":"\(user[_id])","userid":"\(user[userid])","firstname":"\(user[firstname])","lastname":"\(user[lastname])","email":"\(user[email])","phone":"\(user[phone])","status":"\(user[status])"])
            self.selectedUserObj=userObj
        print("chat detail view")
        }*/
       /* if loggedUserObj==nil
        {
            if let loggd=KeychainWrapper.objectForKey("loggedUserObj")
            {
                loggedUserObj=JSON(loggd)
            }
        }*/
        // dispatch_async(dispatch_get_main_queue(), {
        
        
        FetchChatServer()
        //^^self.getUserObjectById()
        ///^^^^^^^^markChatAsRead()
        
        //^^self.tbl_userchats=sqliteDB.db["userschats"]
        self.NewChatNavigationTitle.title=selectedContact
        var receivedMsg=JSON("")
        socketObj.socket.on("im") {data,ack in
            
            print("chat sent to server.ack received")
            var chatJson=JSON(data)
            print(chatJson[0]["msg"])
            receivedMsg=chatJson[0]["msg"]
            var username=chatJson[0]["fullName"]
            
            
            self.addMessage(receivedMsg.description, ofType: "1")
                        
            self.tblForChats.reloadData()
            var indexPath = NSIndexPath(forRow:self.messages.count-1, inSection: 0)
            self.tblForChats.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Bottom, animated: true)
            
            sqliteDB.SaveChat(chatJson[0]["to"].string!, from1: chatJson[0]["from"].string!, fromFullName1: chatJson[0]["fromFullName"].string!, msg1: chatJson[0]["msg"].string!)
           
        }
        /*  self.addMessage("Its actually pretty good!", ofType: "1")
        self.addMessage("What do you think of this tool!", ofType: "2")*/
    }
    func getUserObjectById()
    {
        var tbl_contactList=sqliteDB.contactslists
        ////var tbl_contactList=sqliteDB.db["contactslists"]
        let username = Expression<String>("username")
        let email = Expression<String>("email")
        let _id = Expression<String>("_id")
        //let detailsshared = Expression<String>("detailsshared")
        //let unreadMessage = Expression<Bool>("unreadMessage")
        let userid = Expression<String>("userid")
        let firstname = Expression<String>("firstname")
        let lastname = Expression<String>("lastname")
        let phone = Expression<String>("phone")
        let status = Expression<String>("status")
        let contactid = Expression<String>("contactid")
        
        do{
        for user in try sqliteDB.db.prepare(tbl_contactList) {
            print("id: \(user[username]), email: \(user[email])")
            // id: 1, name: Optional("Alice"), email: alice@mac.com
            var userObj=JSON(["_id":"\(user[_id])","userid":"\(user[contactid])","firstname":"\(user[firstname])","lastname":"\(user[lastname])","email":"\(user[email])","phone":"\(user[phone])","status":"\(user[status])"])
            
            self.selectedUserObj=userObj
            }}catch{
            
        }
        
        
       /* for user in tbl_contactList.select(username, email,_id,contactid,firstname,lastname,phone,status).filter(username==selectedContact) {
            print("id: \(user[username]), email: \(user[email])")
            //^^^^var userObj=JSON(["_id":"\(user[_id])","userid":"\(user[userid])","firstname":"\(user[firstname])","lastname":"\(user[lastname])","email":"\(user[email])","phone":"\(user[phone])","status":"\(user[status])"])
            var userObj=JSON(["_id":"\(user[_id])","userid":"\(user[contactid])","firstname":"\(user[firstname])","lastname":"\(user[lastname])","email":"\(user[email])","phone":"\(user[phone])","status":"\(user[status])"])
            
            self.selectedUserObj=userObj
            // id: 1, email: alice@mac.com
        }*/
        
        //removeChatHistory()
        
        self.markChatAsRead()
    }
    
    
    func removeChatHistory(){
        //var loggedUsername=loggedUserObj["username"]
        print("inside mark funcc", terminator: "")
        var removeChatHistoryURL=Constants.MainUrl+Constants.removeChatHistory+"?access_token=\(AuthToken!)"
        
        Alamofire.request(.POST,"\(removeChatHistoryURL)",parameters: ["username":"\(selectedContact)"]).validate(statusCode: 200..<300).response{
                request1, response1, data1, error1 in
                
                //===========INITIALISE SOCKETIOCLIENT=========
                // dispatch_async(dispatch_get_main_queue(), {
                
                //self.dismissViewControllerAnimated(true, completion: nil);
                /// self.performSegueWithIdentifier("loginSegue", sender: nil)
                
                if response1?.statusCode==200 {
                    print("chat history deleted")
                    //print(request1)
                    print(data1?.debugDescription)
                    
                }
                else
                {print("chat history not deleted")
                    print(error1)
                    print(data1)
            }
            if(response1?.statusCode==401)
            {
                print("chat history not deleted token refresh needed")
                if(username==nil || password==nil)
                {
                    self.performSegueWithIdentifier("loginSegue", sender: nil)
                }
                else{
                self.rt.refrToken()
                }
            }
        }
        

    }
    
    func markChatAsRead()
    {
        print("inside mark as read", terminator: "")
        var markChatReadURL=Constants.MainUrl+Constants.markAsRead+"?access_token=\(AuthToken!)"
        //print(["user1":"\(loggedUserObj)","user2":"\(selectedUserObj)"])
        print("**", terminator: "")
       //^^^^^ var loggedID=loggedUserObj["_id"]
        var loggedID=_id
        //^^^^print(loggedID.description+" logged id")
        print(loggedID!+" logged id", terminator: "")
        print(self.selectedID+" selected id", terminator: "")
        Alamofire.request(.POST,"\(markChatReadURL)",parameters: ["user1":"\(loggedID!)","user2":"\(self.selectedID)"]
            ).responseJSON{response in
                    var response1=response.response
                    var request1=response.request
                    var data1=response.data
                    var error1=response.result.error
                
                if(error1==nil)
                {print("chat marked as read")}
                else
                {
                    self.rt.refrToken()
                }
                //===========INITIALISE SOCKETIOCLIENT=========
                // dispatch_async(dispatch_get_main_queue(), {
                
                //self.dismissViewControllerAnimated(true, completion: nil);
                /// self.performSegueWithIdentifier("loginSegue", sender: nil)
                
               //^^ if response1?.statusCode==200 {
                    print("chat marked as read")
                    print(response1)
                    //print(data1?.debugDescription)
                    //var UserchatJson=JSON(data1!)
                //^^}
               /*else
                {print("chat marked as read but status code is not 200")
                    print(error1)
                     //print(response1?.statusCode)
                    //print(data1)
                }
*/
                /*if(response1?.statusCode==401)
                {
                    print("chat not marked as read refresh token needed")
                    self.rt.refrToken()
                }
*/
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
        
        print("[user1:\(username!),user2:\(selectedContact)]", terminator: "")
        
        var bringUserChatURL=Constants.MainUrl+Constants.bringUserChat+"?access_token="+AuthToken!
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        Alamofire.request(.POST,"\(bringUserChatURL)",parameters: ["user1":"\(username!)","user2":"\(selectedContact)"]
            ).validate(statusCode: 200..<300).responseJSON{response in
                var response1=response.response
                var request1=response.request
                var data1=response.data
                var error1=response.result.error
                
                //===========INITIALISE SOCKETIOCLIENT=========
                dispatch_async(dispatch_get_main_queue(), {
                
                //self.dismissViewControllerAnimated(true, completion: nil);
                /// self.performSegueWithIdentifier("loginSegue", sender: nil)
                
                if response1?.statusCode==200 {
                    print("chatttttttt:::::")
                    print(response1)
                     print(data1)
                    var UserchatJson=JSON(data1!)
                    print(UserchatJson)
                    print(":::::^^^&&&&&")
                    //print(UserchatJson["msg"][0]["to"])
                    
                    //Overwrite sqlite db
                    sqliteDB.deleteChat(self.selectedContact)
                    for var i=0;i<UserchatJson["msg"].count
                        ;i++
                    {
                        sqliteDB.SaveChat(UserchatJson["msg"][i]["to"].string!, from1: UserchatJson["msg"][i]["from"].string!, fromFullName1: UserchatJson["msg"][i]["fromFullName"].string!, msg1: UserchatJson["msg"][i]["msg"].string!)
                        
                        if (UserchatJson["msg"][i]["from"].string==username!)
                            
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
                    print("chatttttt faileddddddd")
                    print(response1)
                    print(error1)
                    print(data1)
                }
                
               
                })
                if(response1?.statusCode==401)
                {
                    print("chatttttt fetch faileddddddd token expired")
                    self.rt.refrToken()
                }
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
        let indexPath = NSIndexPath(forRow:messages.count-1, inSection: 0)
        tblForChats.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Bottom, animated: true)
        
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
        var loggedid=_id!
        //^^var firstNameSelected=selectedUserObj["firstname"]
        //^^^var lastNameSelected=selectedUserObj["lastname"]
        //^^^var fullNameSelected=firstNameSelected.string!+" "+lastNameSelected.string!
        var imParas=["from":"\(username!)","to":"\(selectedContact)","from_id":"\(loggedid)","to_id":"\(self.selectedID)","fromFullName":"\(loggedFullName!)","msg":"\(txtFldMessage.text)"]
        
        print(imParas, terminator: "")
        print("", terminator: "")
        ///=== code for sending chat here
        ///=================
        
        
        socketObj.socket.emit("im",["room":"globalchatroom","stanza":imParas])
        
        //////
        
        sqliteDB.SaveChat("\(selectedContact)", from1: "\(username!)", fromFullName1: "\(loggedFullName!)", msg1: "\(txtFldMessage.text)")
        
        /*insert(self.fromFullName<-"Sabach Channa",
        self.msg<-"\(txtFldMessage.text)",
        //self.owneruser<-"sabachanna",
        self.to<-"sumi",
        self.from<-"sabachanna"
        )
        if let rowid = insert.rowid {
        print("inserted id: \(rowid)")
        } else if insert.statement.failed {
        print("insertion failed: \(insert.statement.reason)")
        }*/
        
        
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
    
    
    @IBAction func btn_deleteChatHistoryPressed(sender: AnyObject) {
        removeChatHistory()
        sqliteDB.deleteChat(selectedContact.debugDescription)
        
        messages.removeAllObjects()
        tblForChats.reloadData()
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
