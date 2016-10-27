//
//  GroupInfo3ViewController.swift
//  kiboApp
//
//  Created by Cloudkibo on 01/09/2016.
//  Copyright © 2016 MyAppTemplates. All rights reserved.
//

import UIKit
import SQLite
import ContactsUI
import Alamofire


var participantsSelected=[EPContact]()
var picker:CNContactPickerViewController!
var btnNewGroup:UIButton!

class GroupInfo3ViewController: UIViewController,CNContactPickerDelegate,
EPPickerDelegate,SWTableViewCellDelegate {

    //var uniqueid=""
    var singleGroupInfo=[String:AnyObject!]()
    var messages:NSMutableArray!
   // var membersnames=[String]()
    var groupid=""
    @IBOutlet weak var tblGroupInfo: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        messages=NSMutableArray()
        singleGroupInfo=sqliteDB.getSingleGroupInfo(groupid)
        
        self.navigationItem.titleView = setTitle(singleGroupInfo["group_name"] as! String, subtitle: "Sumaira")
        //self.navigationController?.navigationBar.tintColor=UIColor.whiteColor()
      
    
       // self.navigationItem.title="Group Info"
        self.navigationController?.navigationBar.tintColor=UIColor.whiteColor()

        
        // Do any additional setup after loading the view.
    }
    
    
    func retrieveChatFromSqlite(completion:(result:Bool)->())
    {
       print("retrieveChatFromSqlite called---------")
        ///^^messages.removeAllObjects()
        var messages2=NSMutableArray()
        
        let group_unique_id = Expression<String>("group_unique_id")
        let member_phone = Expression<String>("member_phone")
        let isAdmin = Expression<String>("isAdmin")
        let membership_status = Expression<String>("membership_status")
        let date_joined = Expression<NSDate>("date_joined")
        let date_left = Expression<NSDate>("date_left")
        let group_member_displayname = Expression<String>("group_member_displayname")
        
        
        
        var tbl_groupmembers=sqliteDB.group_member
        var res=tbl_groupmembers.filter(group_unique_id==groupid)
        //to==selecteduser || from==selecteduser
        //print("chat from sqlite is")
        //print(res)
        do
        {
           
            //for tblContacts in try sqliteDB.db.prepare(tbl_userchats.filter(owneruser==owneruser1)){
            ////print("queryy runned count is \(tbl_contactslists.count)")
            for members in try sqliteDB.db.prepare(tbl_groupmembers.filter(group_unique_id==groupid)){
                
                 print("found matched idss")
                messages2.addObject(["name":members[group_member_displayname],"isAdmin":members[isAdmin]])
            }
        }
        catch
        {
            print("error in getting members")
        }
        messages.setArray(messages2 as [AnyObject])
        ////////////self.messages.addObjectsFromArray(messages2 as [AnyObject])
        
        
        completion(result:true)

    }
    
    
    
    func BtnnewGroupClicked(sender:UIButton)
    {
        
        
        let contactPickerScene = EPContactsPicker(delegate: self, multiSelection:true, subtitleCellType: SubtitleCellValue.PhoneNumber)
        let navigationController = UINavigationController(rootViewController: contactPickerScene)
        self.presentViewController(navigationController, animated: true, completion: nil)
        
        
        
        participantsSelected.removeAll()
        print("BtnnewGroupClicked")
        picker = CNContactPickerViewController();
        picker.title="Add Participants"
        picker.navigationItem.leftBarButtonItem=picker.navigationController?.navigationItem.backBarButtonItem
        
        picker.predicateForEnablingContact = NSPredicate.init(value: true) //.fromValue(true); // make everything selectable
        
        // Respond to selection
        picker.delegate = self;
        self.presentViewController(picker, animated: true, completion: nil)
        
        
        
        // Display picker
        
        // UIApplication.sharedApplication().keyWindow!.rootViewController!.presentViewController(picker, animated: true, completion: nil);
        
        
    }
    
    
    func epContactPicker(_: EPContactsPicker, didContactFetchFailed error : NSError)
    {
        print("Failed with error \(error.description)")
    }
    
    func epContactPicker(_: EPContactsPicker, didSelectContact contact : EPContact)
    {
        print("Contact \(contact.displayName()) has been selected")
    }
    
    func epContactPicker(_: EPContactsPicker, didCancel error : NSError)
    {
        print("User canceled the selection");
    }
    
    
    
    func epContactPicker(_: EPContactsPicker, didSelectMultipleContacts contacts: [EPContact]) {
        print("The following contacts are selected")
        
        
        
        print("didSelectContacts \(contacts)")
        
        //get seleced participants
        participantsSelected.appendContentsOf(contacts)
        addToGroup()
       ///// self.performSegueWithIdentifier("newGroupDetailsSegue2", sender: nil);
        
        
        for contact in contacts {
            print("\(contact.displayName())")
        }
    }
    
    func addToGroup()
    {
        //create group
        //save data in sqlite
        
        /*var uid=randomStringWithLength(7)
        
        var date=NSDate()
        var calendar = NSCalendar.currentCalendar()
        var year=calendar.components(NSCalendarUnit.Year,fromDate: date).year
        var month=calendar.components(NSCalendarUnit.Month,fromDate: date).month
        var day=calendar.components(.Day,fromDate: date).day
        var hr=calendar.components(NSCalendarUnit.Hour,fromDate: date).hour
        var min=calendar.components(NSCalendarUnit.Minute,fromDate: date).minute
        var sec=calendar.components(NSCalendarUnit.Second,fromDate: date).second
        print("\(year) \(month) \(day) \(hr) \(min) \(sec)")
        uniqueid="\(uid)\(year)\(month)\(day)\(hr)\(min)\(sec)"
        */
        
        print("saving in database")
        
        
        // let cell=tblNewGroupDetails.dequeueReusableCellWithIdentifier("NewGroupDetailsCell") as! ContactsListCell
        //  "NewGroupParticipantsCell"
       // var cell=tblNewGroupDetails.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as! ContactsListCell
        
     /*   groupname=singleGroupInfo["group_name"] as! String
        var memberphones=[String]()
        var membersnames=[String]()
        for(var i=0;i<participants.count;i++)
        {
            memberphones.append(participants[i].getPhoneNumber())
            membersnames.append(participants[i].displayName())
        }
        print("group_name is \(groupname)")
        print("memberphones are \(memberphones.debugDescription)")
        
        sqliteDB.storeGroups(groupname, groupicon1: imgdata, datecreation1: NSDate(), uniqueid1: uniqueid)
        
        let firstname = Expression<String>("firstname")
        let phone = Expression<String>("phone")
        
        var myname=""
        let tbl_accounts = sqliteDB.accounts
        do{for account in try sqliteDB.db.prepare(tbl_accounts) {
            myname=account[firstname]
            username=account[phone]
            
            }
        }
        catch
        {
            if(socketObj != nil){
                socketObj.socket.emit("error getting data from accounts table")
            }
            print("error in getting data from accounts table")
            
        }
        
        //sqliteDB.storeMembers(uniqueid,member_displayname1: myname,member_phone1: username!, isAdmin1: "Yes", membershipStatus1: "joined", date_joined1: NSDate.init())
        sqliteDB.storeMembers(uniqueid,member_displayname1: myname, member_phone1: username!, isAdmin1: "Yes", membershipStatus1: "joined", date_joined1: NSDate.init())
        
        for(var i=0;i<memberphones.count;i++)
        {
            var isAdmin="No"
            
            print("members phone comparison \(memberphones[i]) \(username)")
            if(memberphones[i] == username)
            {
                print("adding group admin")
                isAdmin="Yes"
                sqliteDB.storeMembers(uniqueid,member_displayname1: myname, member_phone1: memberphones[i], isAdmin1: isAdmin, membershipStatus1: "joined", date_joined1: NSDate.init())
                
            }
            else{
                
                sqliteDB.storeMembers(uniqueid,member_displayname1: membersnames[i], member_phone1: memberphones[i], isAdmin1: isAdmin, membershipStatus1: "joined", date_joined1: NSDate.init())
            }
            
        }*/
        var memberphones=[String]()
        
        for(var i=0;i<participantsSelected.count;i++)
        {
            memberphones.append(participantsSelected[i].getPhoneNumber())
        }
        addGroupMembersAPI(memberphones,uniqueid: groupid)
        //send to server
        
        //segue to chat page
        
        
        }
        
        func addGroupMembersAPI(members:[String],uniqueid:String)
        {
            //show progress wheen somewhere
            
            var url=Constants.MainUrl+Constants.addGroupMembersUrl
            Alamofire.request(.POST,"\(url)",parameters:["members":members, "group_unique_id":uniqueid],headers:header,encoding:.JSON).validate().responseJSON { response in
                
                /*
                 
                 "__v" = 0;
                 "_id" = 57c69e61dfff9e5223a8fcb2;
                 activeStatus = Yes;
                 companyid = cd89f71715f2014725163952;
                 createdby = 554896ca78aed92f4e6db296;
                 creationdate = "2016-08-31T09:07:45.236Z";
                 groupid = 57c69e61dfff9e5223a8fcb1;
                 "msg_channel_description" = "This channel is for general discussions";
                 "msg_channel_name" = General;
                 
                 
                 */
                print("Add Members API called")
                if(response.result.isSuccess)
                {
                    print(response.result.debugDescription)
                    print("save in database")
                    print("saving in database")
                    
                    
                    // let cell=tblNewGroupDetails.dequeueReusableCellWithIdentifier("NewGroupDetailsCell") as! ContactsListCell
                    //  "NewGroupParticipantsCell"
                    // var cell=tblNewGroupDetails.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as! ContactsListCell
                    
                    //groupname=singleGroupInfo["group_name"] as! String
                    var memberphones=[String]()
                    var membersnames=[String]()
                    for(var i=0;i<participantsSelected.count;i++)
                    {
                        memberphones.append(participantsSelected[i].getPhoneNumber())
                        membersnames.append(participantsSelected[i].displayName())
                    }
                   // print("group_name is \(groupname)")
                    print("memberphones are \(memberphones.debugDescription)")
                    
                   // sqliteDB.storeGroups(groupname, groupicon1: imgdata, datecreation1: NSDate(), uniqueid1: uniqueid)
                    
                    let firstname = Expression<String>("firstname")
                    let phone = Expression<String>("phone")
                    
                    var myname=""
                    let tbl_accounts = sqliteDB.accounts
                    do{for account in try sqliteDB.db.prepare(tbl_accounts) {
                        myname=account[firstname]
                        username=account[phone]
                        
                        }
                    }
                    catch
                    {
                        if(socketObj != nil){
                            socketObj.socket.emit("error getting data from accounts table")
                        }
                        print("error in getting data from accounts table")
                        
                    }
                    
                    //sqliteDB.storeMembers(uniqueid,member_displayname1: myname,member_phone1: username!, isAdmin1: "Yes", membershipStatus1: "joined", date_joined1: NSDate.init())
                    //sqliteDB.storeMembers(uniqueid,member_displayname1: myname, member_phone1: username!, isAdmin1: "Yes", membershipStatus1: "joined", date_joined1: NSDate.init())
                    
                    for(var i=0;i<memberphones.count;i++)
                    {
                        var isAdmin="No"
                        
                        print("members phone comparison \(memberphones[i]) \(username)")
                        if(memberphones[i] == username)
                        {
                            print("adding admin not allowed")
                           // isAdmin="Yes"
                           // sqliteDB.storeMembers(uniqueid,member_displayname1: myname, member_phone1: memberphones[i], isAdmin1: isAdmin, membershipStatus1: "joined", date_joined1: NSDate.init())
                            
                        }
                        else{
                            
                            sqliteDB.storeMembers(uniqueid,member_displayname1: membersnames[i], member_phone1: memberphones[i], isAdmin1: isAdmin, membershipStatus1: "joined", date_joined1: NSDate.init())
                            self.messages.addObject(["name":membersnames[i],"isAdmin":"No"])
                        }
                        
                    }

                    
                    /* var syncMembers=syncGroupService.init()
                     syncMembers.SyncGroupMembersAPI(){(result,error,groupinfo) in
                     print("...")
                     self.performSegueWithIdentifier("groupChatStartSegue", sender: nil)
                     }*/
                    
                    
                    //self.performSegueWithIdentifier("groupChatStartSegue", sender: nil)
                    
                    self.dismissViewControllerAnimated(true, completion:{ ()-> Void in
                        
                        
                        self.tblGroupInfo.reloadData()
                        
                    })
                    
                    /*  self.dismissViewControllerAnimated(true, completion: {
                     
                     
                     })*/
                }
                else{
                    print(response.result.debugDescription)
                    print("error in create group endpoint")
                    
                }
            }
            
        }
        
        func randomStringWithLength (len : Int) -> NSString {
            
            let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
            
            let randomString : NSMutableString = NSMutableString(capacity: len)
            
            for (var i=0; i < len; i++){
                let length = UInt32 (letters.length)
                let rand = arc4random_uniform(length)
                randomString.appendFormat("%C", letters.characterAtIndex(Int(rand)))
            }
            
            return randomString
        }
        
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if(((indexPath.row > 2)  && ((indexPath.row<(messages.count)+2) || messages.count<1)) || indexPath.row==0 || indexPath.row==1 || indexPath.row==2)
        {
            return 73
         
        }
       else
        {
            return 228
        }
        /*if(indexPath.row != (messages.count+1))
        {return 73}
        else{
        
        return 228
        }*/
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count+4
    }

     func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //GroupNamePicInfoCell
        if(indexPath.row==0)
        {
            var cell=tblGroupInfo.dequeueReusableCellWithIdentifier("GroupNamePicInfoCell")! as! GroupInfoCell
            cell.lbl_groupName.text=singleGroupInfo["group_name"] as! String
            
            return cell
            
        }
        if(indexPath.row==1)
        {
             var cell=tblGroupInfo.dequeueReusableCellWithIdentifier("AddParticipants1Cell")! as! GroupInfoCell
            btnNewGroup=cell.btnAddPatricipants
            //btnNewGroup=cell.btnNewGroupOutlet
            
            //cell.btnAddPatricipants.tag=section
            cell.btnAddPatricipants.addTarget(self, action: Selector("BtnnewGroupClicked:"), forControlEvents:.TouchUpInside)

            return cell
            
        }
        /*if(indexPath.row==1)
        {
             cell=tblGroupInfo.dequeueReusableCellWithIdentifier("ExportChatsCell")! as UITableViewCell
            
            return cell
            
        }*/
        else
        {if(indexPath.row==2)
        {
            print("export chat")
             var cell=tblGroupInfo.dequeueReusableCellWithIdentifier("ExportChatsCell")! as! UITableViewCell
            
            return cell
            
        }
        else
        {
            if(indexPath.row==3 && (messages.count==0))
           // if(indexPath.row==2 && (messages.count+1))
            {
                print("exit/clear chat")
             var cell=tblGroupInfo.dequeueReusableCellWithIdentifier("ExitClearChatCell")! as UITableViewCell
            
            return cell
            }
            else
            {
                if(indexPath.row<(messages.count+3))
                {
                print("inside show participants")
                var cell=tableView.dequeueReusableCellWithIdentifier("ParticipantsInfoCell")! as! GroupInfoCell
                cell.lbl_groupAdmin.hidden=true

                var messageDic = messages.objectAtIndex(indexPath.row-3) as! [String : String];
                // NSLog(messageDic["message"]!, 1)
                let name = messageDic["name"] as NSString!
                let isAdmin = messageDic["isAdmin"] as NSString!
                
                if(isAdmin=="Yes")
                {
                   cell.lbl_groupAdmin.hidden=false
                }
                
                cell.lbl_participant_name.text=name as! String

                return cell
                }
                else
                {
                    //last cell
                    print("exit/clear chat")
                    var cell=tblGroupInfo.dequeueReusableCellWithIdentifier("ExitClearChatCell")! as UITableViewCell
                    
                    return cell
                }
                
                

}
            
        }
        }
    }
    
    func setTitle(title:String, subtitle:String) -> UIView {
        //Create a label programmatically and give it its property's
        let titleLabel = UILabel(frame: CGRectMake(0, 0, 0, 0)) //x, y, width, height where y is to offset from the view center
        titleLabel.backgroundColor = UIColor.clearColor()
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.font = UIFont.boldSystemFontOfSize(17)
        titleLabel.text = title
        titleLabel.sizeToFit()
        
        //Create a label for the Subtitle
        let subtitleLabel = UILabel(frame: CGRectMake(0, 18, 0, 0))
        subtitleLabel.backgroundColor = UIColor.clearColor()
        //subtitleLabel.textColor = UIColor.lightGrayColor()
        subtitleLabel.textColor = UIColor.blackColor()
        
        subtitleLabel.font = UIFont.systemFontOfSize(12)
        subtitleLabel.text = subtitle
        subtitleLabel.sizeToFit()
        
        // Create a view and add titleLabel and subtitleLabel as subviews setting
        let titleView = UIView(frame: CGRectMake(0, 0, max(titleLabel.frame.size.width, subtitleLabel.frame.size.width), 30))
        
        // Center title or subtitle on screen (depending on which is larger)
        if titleLabel.frame.width >= subtitleLabel.frame.width {
            var adjustment = subtitleLabel.frame
            adjustment.origin.x = titleView.frame.origin.x + (titleView.frame.width/2) - (subtitleLabel.frame.width/2)
            subtitleLabel.frame = adjustment
        } else {
            var adjustment = titleLabel.frame
            adjustment.origin.x = titleView.frame.origin.x + (titleView.frame.width/2) - (titleLabel.frame.width/2)
            titleLabel.frame = adjustment
        }
        
        titleView.addSubview(titleLabel)
        titleView.addSubview(subtitleLabel)
        
        return titleView
    }

    override func viewWillAppear(animated: Bool) {
               var imageavatar1=UIImage(named: "avatar.png")
        //   imageavatar1=ResizeImage(imageavatar1!,targetSize: s)
        
        //var img=UIImage(data:ContactsProfilePic[indexPath.row])
        var w=imageavatar1!.size.width
        var h=imageavatar1!.size.height
        //var wOld=(self.navigationController?.navigationBar.frame.width)!-5
        var hOld=(self.navigationController?.navigationBar.frame.height)!-10
        var scale:CGFloat=h/hOld
        
        
        ///var s=CGSizeMake((self.navigationController?.navigationBar.frame.height)!-5,(self.navigationController?.navigationBar.frame.height)!-5)
        
        
        var barAvatarImage=UIImageView.init(image: UIImage(data: UIImagePNGRepresentation(UIImage(named: "profile-pic1")!)!, scale: scale))
        
        barAvatarImage.layer.borderWidth = 1.0
        barAvatarImage.layer.masksToBounds = false
        barAvatarImage.layer.borderColor = UIColor.whiteColor().CGColor
        barAvatarImage.layer.cornerRadius = barAvatarImage.frame.size.width/2
        barAvatarImage.clipsToBounds = true
        
        print("bav avatar size is \(barAvatarImage.frame.width) .. \(barAvatarImage.frame.width)")
        var avatarbutton=UIBarButtonItem.init(customView: barAvatarImage)
        self.navigationItem.rightBarButtonItem=avatarbutton
       
        self.retrieveChatFromSqlite { (result) in
            self.tblGroupInfo.reloadData()
           // if(self.messages.count>1)
            //{
               /* var indexPath = NSIndexPath(forRow:self.messages.count+2, inSection: 0)
                self.tblGroupInfo.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Bottom, animated: true)
                */
           // }
            
        }
       


    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
