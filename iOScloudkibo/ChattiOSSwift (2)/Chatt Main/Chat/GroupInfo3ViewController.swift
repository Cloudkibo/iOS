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
var btnRetryAddMember:UIButton!
class GroupInfo3ViewController: UIViewController,CNContactPickerDelegate,
EPPickerDelegate,SWTableViewCellDelegate {

    var addmemberfailed=false
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
        
        
        print("groupid segue is \(groupid) && group id is \(group_unique_id)")
        var tbl_groupmembers=sqliteDB.group_member
       // var res=tbl_groupmembers.filter((singleGroupInfo["group_unique_id"] as! String) = groupid)
        //to==selecteduser || from==selecteduser
        //print("chat from sqlite is")
        //print(res)
        do
        {
           var membersArrayOfGroup=sqliteDB.getGroupMembersOfGroup(groupid)
            for(var i=0;i<membersArrayOfGroup.count;i++)
            {
                print("found matched idss")
                messages2.addObject(["name":membersArrayOfGroup[i]["group_member_displayname"] as! String,"isAdmin":membersArrayOfGroup[i]["isAdmin"] as! String])
            }
            //for tblContacts in try sqliteDB.db.prepare(tbl_userchats.filter(owneruser==owneruser1)){
            ////print("queryy runned count is \(tbl_contactslists.count)")
            /*for members in try sqliteDB.db.prepare(tbl_groupmembers.filter(tbl_groupmembers[group_unique_id]==groupid)){
                
                 print("found matched idss")
                messages2.addObject(["name":members[group_member_displayname],"isAdmin":members[isAdmin]])
            }*/
        }
        catch
        {
            print("error in getting members")
        }
        messages.setArray(messages2 as [AnyObject])
        ////////////self.messages.addObjectsFromArray(messages2 as [AnyObject])
        
        
        completion(result:true)

    }
    
    
    func BtnTryAgainTapped(sender:UIButton)
    {
        print("inside groupaddmember try again func")
    addToGroup()
    }
    func BtnExitGroupClicked(sender:UIButton)
    {
        print("inside exit group func")
        
        exitGroup()
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
        
           addmemberfailed=true
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
        var membersnames=[String]()
        for(var i=0;i<participantsSelected.count;i++)
        {
            memberphones.append(participantsSelected[i].getPhoneNumber())
             membersnames.append(participantsSelected[i].displayName())
            self.messages.addObject(["name":membersnames[i],"isAdmin":"No"])
           
            //tblGroupInfo.reloadData()

        }
                 addGroupMembersAPI(memberphones,uniqueid: groupid)
        //send to server
        
        //segue to chat page
        
        
        }
    
    
    
    func adminRemovesMember(memberPhone:String)
    {
        let shareMenu = UIAlertController(title: nil, message: "Are you sure you want to remove \(memberPhone)?", preferredStyle: .ActionSheet)
        
        let yes = UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default,handler: { (action) -> Void in
            
            var url=Constants.MainUrl+Constants.removeMemberFromGroup
            Alamofire.request(.POST,"\(url)",parameters:["group_unique_id":self.groupid,"phone":memberPhone],headers:header,encoding:.JSON).validate().responseJSON { response in
                
                
                print("exit group response \(response.description)")
                if(response.result.isSuccess)
                {
                    print("removed member from group")
                    print(response.result.value)
                    var uniqueidMsg=self.generateUniqueid()
                    // var dateString=self.getDateString(NSDate())
                    
                    sqliteDB.storeGroupsChat(username!, group_unique_id1: self.groupid, type1: "log_leftGroup", msg1: "You have left this group", from_fullname1: "", date1:NSDate() , unique_id1: uniqueidMsg)
                    
                    self.tblGroupInfo.reloadData()
                }
            }
            
            
            
        })
        let no = UIAlertAction(title: "No", style: UIAlertActionStyle.Default,handler: { (action) -> Void in
            
        })
        shareMenu.addAction(yes)
        shareMenu.addAction(no)
        
        self.presentViewController(shareMenu, animated: true) {
            
            
        }
    }
    func exitGroup()
    {
        let shareMenu = UIAlertController(title: nil, message: "Are you sure you want to leave this group?", preferredStyle: .ActionSheet)
        
        let yes = UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default,handler: { (action) -> Void in
            
            var url=Constants.MainUrl+Constants.leaveGroup
            Alamofire.request(.POST,"\(url)",parameters:["group_unique_id":self.groupid],headers:header,encoding:.JSON).validate().responseJSON { response in
                
                
                print("exit group response \(response.description)")
                if(response.result.isSuccess)
                {
                    print("left group")
                    print(response.result.value)
                    var uniqueidMsg=self.generateUniqueid()
                   // var dateString=self.getDateString(NSDate())
                    
                    sqliteDB.storeGroupsChat(username!, group_unique_id1: self.groupid, type1: "log_leftGroup", msg1: "You have left this group", from_fullname1: "", date1:NSDate() , unique_id1: uniqueidMsg)
                    
                    self.tblGroupInfo.reloadData()
                }
            }
            

            
        })
        let no = UIAlertAction(title: "No", style: UIAlertActionStyle.Default,handler: { (action) -> Void in
            
            })
            shareMenu.addAction(yes)
            shareMenu.addAction(no)
        
        self.presentViewController(shareMenu, animated: true) { 
            
            
        }
           }
    
    
    
    func getDateString(datetime:NSDate)->String
    {
        var formatter2 = NSDateFormatter();
        formatter2.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        formatter2.timeZone = NSTimeZone.localTimeZone()
        var defaultTimeeee = formatter2.stringFromDate(datetime)
        return defaultTimeeee
    }

    
    func generateUniqueid()->String
    {
        
        var uid=randomStringWithLength(7)
        
        var date=NSDate()
        var calendar = NSCalendar.currentCalendar()
        var year=calendar.components(NSCalendarUnit.Year,fromDate: date).year
        var month=calendar.components(NSCalendarUnit.Month,fromDate: date).month
        var day=calendar.components(.Day,fromDate: date).day
        var hr=calendar.components(NSCalendarUnit.Hour,fromDate: date).hour
        var min=calendar.components(NSCalendarUnit.Minute,fromDate: date).minute
        var sec=calendar.components(NSCalendarUnit.Second,fromDate: date).second
        print("\(year) \(month) \(day) \(hr) \(min) \(sec)")
        var uniqueid="\(uid)\(year)\(month)\(day)\(hr)\(min)\(sec)"
        
        return uniqueid
        
        
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
                        
                        /*if(self.addmemberfailed==true)
                        {
                        self.messages.removeObjectAtIndex(self.messages.count-1)
                        }*/
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
                           
                        }
                        
                    }

                    
                    /* var syncMembers=syncGroupService.init()
                     syncMembers.SyncGroupMembersAPI(){(result,error,groupinfo) in
                     print("...")
                     self.performSegueWithIdentifier("groupChatStartSegue", sender: nil)
                     }*/
                    
                    
                    //self.performSegueWithIdentifier("groupChatStartSegue", sender: nil)
                    self.addmemberfailed=false
                    
                    //self.dismissViewControllerAnimated(true, completion:{ ()-> Void in
                        
                        
                        self.tblGroupInfo.reloadData()
                        
                   // })
                    
                    /*  self.dismissViewControllerAnimated(true, completion: {
                     
                     
                     })*/
                }
                else{
                    self.addmemberfailed=true
                    var memberphones=[String]()
                    var membersnames=[String]()
                    for(var i=0;i<participantsSelected.count;i++)
                    {
                        memberphones.append(participantsSelected[i].getPhoneNumber())
                        membersnames.append(participantsSelected[i].displayName())
                       
                        var isAdmin="No"
                        self.messages.removeObjectAtIndex(self.messages.count-1)
                      
                    }
                    for(var i=0;i<memberphones.count;i++)
                    {
                        var isAdmin="No"
                        self.messages.addObject(["name":membersnames[i],"isAdmin":"No","newmember":"Yes"])
                        
                    }
                    print(response.result.debugDescription)
                    print("error in create group endpoint")
                    var arrayIndexPaths=[NSIndexPath]()
                    arrayIndexPaths.append((NSIndexPath.init(index: self.messages.count+1)))
                    arrayIndexPaths.append((NSIndexPath.init(index: self.messages.count+2)))
                    
                    
                //    self.dismissViewControllerAnimated(true, completion:{ ()-> Void in
                       // self.tblGroupInfo.reloadRowsAtIndexPaths(arrayIndexPaths, withRowAnimation: UITableViewRowAnimation.Automatic)                       
                       self.tblGroupInfo.reloadData()
                        
                 //   })

                    
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

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        var messageDic = messages.objectAtIndex(indexPath.row-3) as! [String : String];
       // NSLog(messageDic["message"]!, 1)
       // let msgType = messageDic["type"] as NSString!
        if(messageDic["newmember"] != nil)
        {
            messages.removeObjectAtIndex(indexPath.row-3)
            
             self.addToGroup()
        }
        else
        {
            //show actions for removing group
            let shareMenu = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
            
            let makeAdmin = UIAlertAction(title: "Make Group Admin", style: UIAlertActionStyle.Default,handler: { (action) -> Void in
                
               /* var url=Constants.MainUrl+Constants.removeMemberFromGroup
                Alamofire.request(.POST,"\(url)",parameters:["group_unique_id":self.groupid,"phone":memberPhone],headers:header,encoding:.JSON).validate().responseJSON { response in
                    
                    
                    print("exit group response \(response.description)")
                    if(response.result.isSuccess)
                    {
                        print("removed member from group")
                        print(response.result.value)
                        var uniqueidMsg=self.generateUniqueid()
                        // var dateString=self.getDateString(NSDate())
                        
                        sqliteDB.storeGroupsChat(username!, group_unique_id1: self.groupid, type1: "log_leftGroup", msg1: "You have left this group", from_fullname1: "", date1:NSDate() , unique_id1: uniqueidMsg)
                        
                        self.tblGroupInfo.reloadData()
                    }
                }
                */
                
                
            })
            let removeMember = UIAlertAction(title: "Remove \(memberSelectedName) ?", style: UIAlertActionStyle.Default,handler: { (action) -> Void in
                
            })
            let cancel = UIAlertAction(title: "No", style: UIAlertActionStyle.Default,handler: { (action) -> Void in
                
            })
            shareMenu.addAction(makeAdmin)
            shareMenu.addAction(removeMember)
             shareMenu.addAction(cancel)
            
            self.presentViewController(shareMenu, animated: true) {
                
                
            }

            
        }
        
      /*  if(msgType.isEqualToString("5")||msgType.isEqualToString("6")){
            //self.performSegueWithIdentifier("showFullDocSegue", sender: nil);
            self.addToGroup()

        
        }*/
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
              
                //newmember
                if(isAdmin=="Yes")
                {
                   cell.lbl_groupAdmin.hidden=false
                    
                }
                else{
                 /*   if(addmemberfailed==true)
{
    cell.lbl_groupAdmin.text="(!)"
cell.lbl_groupAdmin.hidden=false
}*/
                    if(messageDic["newmember"] != nil)
                    {
                        cell.lbl_groupAdmin.text="(!)"
                        cell.lbl_groupAdmin.hidden=false
                        cell.lbl_participant_status.text="Failed to add member. Tap here to retry."
                       
                        /*var tempUIView=UIButton()
                        tempUIView=cell.lbl_participant_status.targetForAction(Selector("BtnTryAgainTapped:"), withSender: nil) as! UIButton
                        tempUIView.addTarget(self, action: Selector("BtnTryAgainTapped:"), forControlEvents:.TouchUpInside)
                        
                        

                        */
                        //addTarget(self, action: , forControlEvents:.TouchUpInside)
                        

                        
                    }
                    else
                    {
                        //cell.lbl_groupAdmin.text="(!)"
                        cell.lbl_groupAdmin.hidden=true
                        cell.lbl_participant_status.text="Hey there! I am using Kibo Chat"
                        

                    }
                    
                    }
                    cell.lbl_participant_name.text=name as! String
                    
               

                return cell
                }
                else
                {
                    //last cell
                    print("exit/clear chat")
                    var cell=tblGroupInfo.dequeueReusableCellWithIdentifier("ExitClearChatCell")! as! GroupInfoCell
                    
                    
                    btnNewGroup=cell.btn_exitGroup
                    //btnNewGroup=cell.btnNewGroupOutlet
                    
                    //cell.btnAddPatricipants.tag=section
                    cell.btn_exitGroup.addTarget(self, action: Selector("BtnExitGroupClicked:"), forControlEvents:.TouchUpInside)

                    
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
       print("messages count is \(messages.count)")
        if(self.addmemberfailed==false)
{
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
