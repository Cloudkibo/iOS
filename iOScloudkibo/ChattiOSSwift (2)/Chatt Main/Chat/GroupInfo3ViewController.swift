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
import AssetsLibrary
import Photos

var internetAvailable=false
var participantsSelected=[EPContact]()
var picker:CNContactPickerViewController!
var btnNewGroup:UIButton!
var btnRetryAddMember:UIButton!
class GroupInfo3ViewController: UIViewController,UINavigationControllerDelegate,CNContactPickerDelegate,
EPPickerDelegate,SWTableViewCellDelegate,UIImagePickerControllerDelegate {

    
    var seguemsg=""
     var identifiersarray=[String]()
    var membersArrayOfGroup=[[String:AnyObject]]()
    var filePathImage2=""
    var ftype=""
    var fileSize1:UInt64=0
    var filePathImage:String!
    ////** new commented april 2016var fileSize:Int!
    var fileContents:NSData!
    
    var file_name1=""

    
    var imgdata=NSData.init()
    var addmemberfailed=false
    //var uniqueid=""
    var singleGroupInfo=[String:AnyObject!]()
    var messages:NSMutableArray!
   // var membersnames=[String]()
    var groupid=""
    @IBOutlet weak var tblGroupInfo: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        
        do{reachability = try Reachability.reachabilityForInternetConnection()
            try reachability.startNotifier();
            //  NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("checkForReachability:"), name:ReachabilityChangedNotification, object: reachability)
        }
        catch{
            print("error in reachability")
        }
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("checkForReachability:"), name:ReachabilityChangedNotification, object: reachability)
        
        
        
        
        messages=NSMutableArray()
        singleGroupInfo=sqliteDB.getSingleGroupInfo(groupid)
        var filedata=sqliteDB.getFilesData(groupid)
        if(filedata.count>0)
        {
            print("found group icon")
            print("actual path is \(filedata["file_path"])")
            //======
            
            //=======
            let dirPaths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
            let docsDir1 = dirPaths[0]
            var documentDir=docsDir1 as NSString
            var imgPath=documentDir.stringByAppendingPathComponent(filedata["file_name"] as! String)
            
            imgdata=NSFileManager.defaultManager().contentsAtPath(imgPath)!
            
            // print("found path is \(imgNSData)")
            
          //  self.ContactsProfilePic.append(imgNSData!)
        }
        
        
        self.navigationItem.titleView = setTitle(singleGroupInfo["group_name"] as! String, subtitle: "Sumaira")
        //self.navigationController?.navigationBar.tintColor=UIColor.whiteColor()
      
    
       // self.navigationItem.title="Group Info"
        self.navigationController?.navigationBar.tintColor=UIColor.whiteColor()

        
        // Do any additional setup after loading the view.
    }
    func checkForReachability(notification:NSNotification)
    {
        print("checking internet")
        // Remove the next two lines of code. You cannot instantiate the object
        // you want to receive notifications from inside of the notification
        // handler that is meant for the notifications it emits.
        
        //var networkReachability = Reachability.reachabilityForInternetConnection()
        //networkReachability.startNotifier()
        
        let networkReachability = notification.object as! Reachability;
        var remoteHostStatus = networkReachability.currentReachabilityStatus
        
        if (remoteHostStatus == Reachability.NetworkStatus.NotReachable)
        {
            print("Not Reachable")
            internetAvailable = false
        }
        else if (remoteHostStatus == Reachability.NetworkStatus.ReachableViaWiFi)
        {
            print("Reachable via Wifi")
            if(username != nil && username != "")
            {
                //self.synchroniseChatData()
                internetAvailable=true
            }
        }
        else
        {
            print("Reachable")
            if(username != nil && username != "")
            {
                //self.synchroniseChatData()
                internetAvailable=true
            }
        }
    }
    
   
    
    func retrieveChatFromSqlite(completion:(result:Bool)->())
    {
       print("retrieveChatFromSqlite called---------")
        ///^^messages.removeAllObjects()
        let messages2=NSMutableArray()
        
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
           membersArrayOfGroup=sqliteDB.getGroupMembersOfGroup(groupid)
            for(var i=0;i<membersArrayOfGroup.count;i++)
            {
                print("found matched idss")
                if((membersArrayOfGroup[i]["membership_status"] as! String) == "joined")
                {
                messages2.addObject(["member_phone":membersArrayOfGroup[i]["member_phone"] as! String,"name":membersArrayOfGroup[i]["group_member_displayname"] as! String,"isAdmin":membersArrayOfGroup[i]["isAdmin"] as! String])
                }
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
        if(internetAvailable==true)
{
        exitGroup()
}
else{

            let shareMenu = UIAlertController(title: nil, message: "Internet connectivity is required to exit this group", preferredStyle: .ActionSheet)
        
        let yes = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: { (action) -> Void in
            
            })
            shareMenu.addAction(yes)
            self.presentViewController(shareMenu, animated: true, completion:nil)
        }
    }
    
    
    
    @IBAction func btnBackPressed(sender: AnyObject) {
      //  groupinfotochatstabsegue
        self.performSegueWithIdentifier("groupinfotochatstabsegue", sender: nil)
    }
    
    
    
    
    
    
    
    func BtnAddParticipantsClicked(sender:UIButton)
    {
        //add participants clicked
       
        identifiersarray.removeAll()
for(var i=0;i<membersArrayOfGroup.count;i++)
{
   if((membersArrayOfGroup[i]["membership_status"] as! String) == "joined")
    {
var identifier=sqliteDB.getIdentifierFRomPhone(membersArrayOfGroup[i]["member_phone"] as! String)
if(identifier != "")
{
identifiersarray.append(identifier)
}
    }
}
        
        addmemberfailed=true
        
        participantsSelected.removeAll()
       /* let contactPickerScene = EPContactsPicker(delegate: self, multiSelection:true, subtitleCellType: SubtitleCellValue.PhoneNumber, alreadySelectedContactsIdentifiers:identifiersarray)
        let navigationController = UINavigationController(rootViewController: contactPickerScene)
        self.presentViewController(navigationController, animated: true, completion: nil)
        
        
        
        print("BtnAddParticipantsClicked")
        picker = CNContactPickerViewController();
        picker.title="Add Participants"
        picker.navigationItem.leftBarButtonItem=picker.navigationController?.navigationItem.backBarButtonItem
        
        picker.predicateForEnablingContact = NSPredicate.init(value: true) //.fromValue(true); // make everything selectable
        
        // Respond to selection
        picker.delegate = self;
        
        self.presentViewController(picker, animated: true, completion: nil)
        */
        self.performSegueWithIdentifier("addparticipantstogroupsegue", sender: nil)
        
        
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
        participantsSelected.removeAll()
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
        print("saving in database")
        
                var memberphones=[String]()
        var membersnames=[String]()
        for(var i=0;i<participantsSelected.count;i++)
        {print()
            memberphones.append(participantsSelected[i].getPhoneNumber())
             membersnames.append(participantsSelected[i].displayName())
            self.messages.addObject(["member_phone":memberphones[i],"name":membersnames[i],"isAdmin":"No"])
           
            //tblGroupInfo.reloadData()

        }
        
        
        addGroupMembersAPI(singleGroupInfo["group_name"] as! String,members: memberphones,uniqueid: groupid)
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
                   
                    sqliteDB.updateMembershipStatus(self.groupid,memberphone1: memberPhone, membership_status1: "left")
                    
                    sqliteDB.storeGroupsChat("Log:", group_unique_id1: self.groupid, type1: "log", msg1: "\(memberPhone) is removed", from_fullname1: "", date1:NSDate() , unique_id1: uniqueidMsg)
                    
                   /// sqliteDB.storeGroupsChat(username!, group_unique_id1: self.groupid, type1: "log_leftGroup", msg1: "You have left this group", from_fullname1: "", date1:NSDate() , unique_id1: uniqueidMsg)
                    
                    
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
 
            
            
        })
        let no = UIAlertAction(title: "No", style: UIAlertActionStyle.Default,handler: { (action) -> Void in
            
        })
        shareMenu.addAction(yes)
        shareMenu.addAction(no)
        
        self.presentViewController(shareMenu, animated: true) {
            
            
        }
    }
    
    
    func changeRole(member:String,isAdmin:String)
    {
       // let shareMenu = UIAlertController(title: nil, message: "Are you sure you want to remove \(memberPhone)?", preferredStyle: .ActionSheet)
        
      //  let yes = UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default,handler: { (action) -> Void in
            
            
            var url=Constants.MainUrl+Constants.changeRole
            Alamofire.request(.POST,"\(url)",parameters:["group_unique_id":self.groupid,"member_phone":member,"makeAdmin":isAdmin],headers:header,encoding:.JSON).validate().responseJSON { response in
                
                
                print("change member role response \(response.description)")
                if(response.result.isSuccess)
                {
                    print("change member role  success")
                    print(response.result.value)
                    var uniqueidMsg=self.generateUniqueid()
                    // var dateString=self.getDateString(NSDate())
                    
                    //change role in database 
                    
                    
                    
                    sqliteDB.changeRole(self.groupid, member1: member, isAdmin1: isAdmin)
                    
                    //sqliteDB.updateMembershipStatus(memberPhone, membership_status1: "left")
                    
                    //sqliteDB.storeGroupsChat("Log:", group_unique_id1: self.groupid, type1: "log", msg1: "You have left this group", from_fullname1: "", date1:NSDate() , unique_id1: uniqueidMsg)
                    
                    /// sqliteDB.storeGroupsChat(username!, group_unique_id1: self.groupid, type1: "log_leftGroup", msg1: "You have left this group", from_fullname1: "", date1:NSDate() , unique_id1: uniqueidMsg)
                    
                    self.tblGroupInfo.reloadData()
                }
                else
                {
                    print("failed to update role")
                }
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
                    
                    sqliteDB.updateMembershipStatus(self.groupid,memberphone1: username!,membership_status1: "left")
                    sqliteDB.storeGroupsChat("Log:", group_unique_id1: self.groupid, type1: "log", msg1: "You have left this group", from_fullname1: "", date1:NSDate() , unique_id1: uniqueidMsg)
                    
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
    func addGroupMembersAPI(groupname:String,members:[String],uniqueid:String)
        {
            //show progress wheen somewhere
            
            var url=Constants.MainUrl+Constants.addGroupMembersUrl
            Alamofire.request(.POST,"\(url)",parameters:["group_name":groupname,"members":members, "group_unique_id":uniqueid],headers:header,encoding:.JSON).validate().responseJSON { response in
                
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
                        self.messages.addObject(["member_phone":memberphones[i] as! String,"name":membersnames[i],"isAdmin":"No","newmember":"Yes"])
                        
                    }
                    print(response.result.debugDescription)
                    print("error in add group members endpoint")
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
        if(indexPath.row == 0)
        {
return 95
}
        if(((indexPath.row > 2)  && ((indexPath.row<=(messages.count)+2) || messages.count<1)) || indexPath.row==1 || indexPath.row==2)
        {
            return 65
         
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
        if(indexPath.row>=3){
            print("here....")
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
            if(sqliteDB.getGroupAdmin(groupid)==username!)
            {
            var selectedMemberPhone=messageDic["member_phone"]
            var selectedMemberName=messageDic["name"]
            var selectedMemberIsAdmin=messageDic["isAdmin"]
            
            if(selectedMemberPhone!.lowercaseString != username!)
            {
                
            
            
            //show actions for removing group
            let shareMenu = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
            
            let makeAdmin = UIAlertAction(title: "Make Group Admin", style: UIAlertActionStyle.Default,handler: { (action) -> Void in
                
                
                self.changeRole(selectedMemberPhone!,isAdmin: "Yes")
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
            let removeMember = UIAlertAction(title: "Remove \(selectedMemberName!) ?", style: UIAlertActionStyle.Default,handler: { (action) -> Void in
                if(internetAvailable==true)
{
                self.adminRemovesMember(selectedMemberPhone!)
                }
else{
                let shareMenu = UIAlertController(title: nil, message: "Internet connectivity is required to remove any member", preferredStyle: .ActionSheet)
                
                let yes = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: { (action) -> Void in
                    
                })
                shareMenu.addAction(yes)
                self.presentViewController(shareMenu, animated: true, completion:nil)
                }
            })
            let cancel = UIAlertAction(title: "No", style: UIAlertActionStyle.Default,handler: { (action) -> Void in
                
            })
                
                if(selectedMemberIsAdmin!.lowercaseString == "no")
                {
                    shareMenu.addAction(makeAdmin)
                   }//end of not Admin
                
                shareMenu.addAction(removeMember)
                shareMenu.addAction(cancel)
            
                self.presentViewController(shareMenu, animated: true) {
                
                
            }
     
            
            
        }//end of mee
        }
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
         
            //cell.userInteractionEnabled=false
                
                cell.btnEditProfilePicOutlet.hidden=true
               // groupname=cell.groupNameFieldOutlet.text!
                if(imgdata != NSData.init())
                {
                   // cell.btnEditProfilePicOutlet.hidden=false
                    var tempimg=UIImage(data: imgdata)
                    /* var s = CGSizeMake(cell.profilePicCameraOutlet.frame.width, cell.profilePicCameraOutlet.frame.height)
                     var newimg=ResizeImage(tempimg!, targetSize: s)
                     cell.profilePicCameraOutlet.layer.masksToBounds = true
                     cell.profilePicCameraOutlet.layer.cornerRadius = cell.profilePicCameraOutlet.frame.size.width/2
                     cell.profilePicCameraOutlet.image=newimg
                     
                     */
                    
                    /*
                     cell.profilePicCameraOutlet.layer.masksToBounds = true
                     cell.profilePicCameraOutlet.layer.cornerRadius = cell.profilePicCameraOutlet.frame.size.width/2
                     */
                    
                    
                    cell.cameraProfilePicOutlet.layer.borderWidth = 1.0
                    cell.cameraProfilePicOutlet.layer.masksToBounds = false
                    cell.cameraProfilePicOutlet.layer.borderColor = UIColor.whiteColor().CGColor
                    cell.cameraProfilePicOutlet.layer.cornerRadius = cell.cameraProfilePicOutlet.frame.size.width/2
                    cell.cameraProfilePicOutlet.clipsToBounds = true
                    
                    
                    var w=tempimg!.size.width
                    var h=tempimg!.size.height
                    var wOld=(cell.cameraProfilePicOutlet.frame.width)
                    var hOld=(cell.cameraProfilePicOutlet.frame.height)
                    var scale:CGFloat=w/wOld
                    
                    cell.cameraProfilePicOutlet.image=UIImage(data: imgdata,scale: scale)
                    //  cell.profilePicCameraOutlet.image=UIImage(data: imgdata)
                    //Add the recognizer to your view.
                    // chatImage.addGestureRecognizer(tapRecognizer)
                    
                    /* let tapRecognizerOld = UITapGestureRecognizer(target: self, action: Selector("imageTapped:"))
                     
                     cell.profilePicCameraOutlet.removeGestureRecognizer(tapRecognizerOld)
                     */
                    let tapRecognizer = UITapGestureRecognizer(target: self, action: Selector("imageEditTapped:"))
                    
                    cell.cameraProfilePicOutlet.addGestureRecognizer(tapRecognizer)
                    
                    let tapRecognizer2 = UITapGestureRecognizer(target: self, action: Selector("imageEditTapped:"))
                    cell.btnEditProfilePicOutlet.addGestureRecognizer(tapRecognizer2)
                }
                else
                {
                    print("displaying camera pic programatically")
                    var tempimg=UIImage(named:"chat_camera")
                    imgdata=UIImagePNGRepresentation(tempimg!)!
                    cell.cameraProfilePicOutlet.layer.borderWidth = 1.0
                    cell.cameraProfilePicOutlet.layer.masksToBounds = false
                    cell.cameraProfilePicOutlet.layer.borderColor = UIColor.whiteColor().CGColor
                    cell.cameraProfilePicOutlet.layer.cornerRadius = cell.cameraProfilePicOutlet.frame.size.width/2
                    cell.cameraProfilePicOutlet.clipsToBounds = true
                    
                    
                    var w=tempimg!.size.width
                    var h=tempimg!.size.height
                    var wOld=(cell.cameraProfilePicOutlet.frame.width)
                    var hOld=(cell.cameraProfilePicOutlet.frame.height)
                    var scale:CGFloat=wOld/w
                    
                    cell.cameraProfilePicOutlet.image=UIImage(data: imgdata,scale: scale)
                    
                    let tapRecognizer = UITapGestureRecognizer(target: self, action: Selector("imageTapped:"))
                    //Add the recognizer to your view.
                    // chatImage.addGestureRecognizer(tapRecognizer)
                    
                    cell.cameraProfilePicOutlet.addGestureRecognizer(tapRecognizer)
                }
                
              //  return cell
            
            
            return cell
            
        }
        if(indexPath.row==1)
        {
             var cell=tblGroupInfo.dequeueReusableCellWithIdentifier("AddParticipants1Cell")! as! GroupInfoCell
            btnNewGroup=cell.btnAddPatricipants
            //btnNewGroup=cell.btnNewGroupOutlet
            if(sqliteDB.getGroupAdmin(groupid)==username!)
            {
            //cell.btnAddPatricipants.tag=section
            cell.btnAddPatricipants.addTarget(self, action: Selector("BtnAddParticipantsClicked:"), forControlEvents:.TouchUpInside)
            }
            else
            {
                //btnNewGroup=cell.btnAddPatricipants
                //btnNewGroup.titleLabel?.textColor=UIColor.grayColor()
                //btnNewGroup.titleLabel?.text="You are a group member in this group and cannot add participants"
               
                print("disabled")
                //cell.btnAddPatricipants.titlt
                //cell.btnAddPatricipants.titleLabel?.enabled=false
                //UIColor.grayColor()
                       cell.userInteractionEnabled=false
                cell.btnAddPatricipants.enabled=false
               // cell.btnAddPatricipants.setTitle("You are a group member", forState: UIControlState.Disabled)
                    //="You are a group member in this group and cannot add participants"
                //cell.btnAddPatricipants.currentTitleColor=UIColor.grayColor()
                //cell.btnAddPatricipants.titleLabel?.text="You are a group member in this group and cannot add participants"
         
                
            }
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
            print("Mute group chat cell")
             var cell=tblGroupInfo.dequeueReusableCellWithIdentifier("MuteChatsCell")! as! UITableViewCell
            cell.userInteractionEnabled=false
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
                    var messageDic = messages.objectAtIndex(indexPath.row-3) as! [String : String];
                    // NSLog(messageDic["message"]!, 1)
                    let name = messageDic["name"] as NSString!
                    let isAdmin = messageDic["isAdmin"] as NSString!
                print("inside show participants")
                var cell=tableView.dequeueReusableCellWithIdentifier("ParticipantsInfoCell")! as! GroupInfoCell
                cell.lbl_groupAdmin.hidden=true

                
                //newmember
                if(isAdmin.lowercaseString == "yes")
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
    

    func imageEditTapped(gestureRecognizer: UITapGestureRecognizer) {
        //tappedImageView will be the image view that was tapped.
        //dismiss it, animate it off screen, whatever.
        print("image edit tapped")
        let shareMenu = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        
        let resetImage = UIAlertAction(title: "Reset Image", style: UIAlertActionStyle.Default,handler: { (action) -> Void in
            
            if(internetAvailable==true)
{
            self.imgdata=NSData.init()
            gestureRecognizer.view?.removeGestureRecognizer(gestureRecognizer)
            self.tblGroupInfo.reloadData()
            
}
else{
                let shareMenu = UIAlertController(title: nil, message: "Internet connectivity is required to change group icon", preferredStyle: .ActionSheet)
                
                let yes = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: { (action) -> Void in
                    
                })
                shareMenu.addAction(yes)
                self.presentViewController(shareMenu, animated: true, completion:nil)
                
            }
            //// self.removeChatHistory(self.ContactUsernames[indexPath.row],indexPath: indexPath)
            
            //call Mute delegate or method
        })
        
        let SelectImage = UIAlertAction(title: "Select Image", style: UIAlertActionStyle.Default,handler: { (action) -> Void in
            
            if(internetAvailable==true)
{
            self.selectImage(gestureRecognizer)
            
}
else{
                let shareMenu = UIAlertController(title: nil, message: "Internet connectivity is required to change group icon", preferredStyle: .ActionSheet)
                
                let yes = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: { (action) -> Void in
                    
                })
                shareMenu.addAction(yes)
                self.presentViewController(shareMenu, animated: true, completion:nil)
            }
            

            // swipeindex=index
            //self.performSegueWithIdentifier("groupInfoSegue", sender: nil)
            //// self.removeChatHistory(self.ContactUsernames[indexPath.row],indexPath: indexPath)
            
            //call Mute delegate or method
        })
        
        let cancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: { (action) -> Void in
            
            // swipeindex=index
            //self.performSegueWithIdentifier("groupInfoSegue", sender: nil)
            //// self.removeChatHistory(self.ContactUsernames[indexPath.row],indexPath: indexPath)
            
            //call Mute delegate or method
        })
        shareMenu.addAction(resetImage)
        shareMenu.addAction(SelectImage)
        shareMenu.addAction(cancel)
        
        self.presentViewController(shareMenu, animated: true) {
            
            
        }
        
        
        //selectedImage=tappedImageView.image
        // self.performSegueWithIdentifier("showFullImageSegue", sender: nil);
        
    }
    
    func selectImage(gestureRecognizer: UITapGestureRecognizer)
    {
        
        let tappedImageView = gestureRecognizer.view
        
        var picker=UIImagePickerController.init()
        picker.delegate=self
        
        picker.allowsEditing = true;
        //picker.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
        // if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary))
        //  {
        
        //savedPhotosAlbum
        // picker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        //}
        picker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        ////picker.mediaTypes=[kUTTypeMovie as NSString as String,kUTTypeMovie as NSString as String]
        //[self presentViewController:picker animated:YES completion:NULL];
        dispatch_async(dispatch_get_main_queue())
        { () -> Void in
            //  picker.addChildViewController(UILabel("hiiiiiiiiiiiii"))
            
            self.presentViewController(picker, animated: true,completion: {
                print("done choosing image")
                
                tappedImageView!.removeGestureRecognizer(gestureRecognizer)
            })
        }
        
    }
    
    func imageTapped(gestureRecognizer: UITapGestureRecognizer) {
        //tappedImageView will be the image view that was tapped.
        //dismiss it, animate it off screen, whatever.
        print("image tapped")
        let tappedImageView = gestureRecognizer.view! as! UIImageView
        
        var picker=UIImagePickerController.init()
        picker.delegate=self
        
        picker.allowsEditing = true;
        //picker.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
        // if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary))
        //  {
        
        //savedPhotosAlbum
        // picker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        //}
        picker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        ////picker.mediaTypes=[kUTTypeMovie as NSString as String,kUTTypeMovie as NSString as String]
        //[self presentViewController:picker animated:YES completion:NULL];
        dispatch_async(dispatch_get_main_queue())
        { () -> Void in
            //  picker.addChildViewController(UILabel("hiiiiiiiiiiiii"))
            
            self.presentViewController(picker, animated: true, completion: {
                
                //new
                print("removing gesture")
                tappedImageView.removeGestureRecognizer(gestureRecognizer)
            })
            
        }
        
        //selectedImage=tappedImageView.image
        // self.performSegueWithIdentifier("showFullImageSegue", sender: nil);
        
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        
        
        self.dismissViewControllerAnimated(true, completion:{ ()-> Void in
            print("cancelled and dismissing image picker")
            // imgdata=NSData.init()
            self.tblGroupInfo.reloadData()
        })
        
        
    }
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
        
        
        //  var filesizenew=""
        
        
        let imageUrl          = editingInfo![UIImagePickerControllerReferenceURL] as! NSURL
        let imageName         = imageUrl.lastPathComponent
        let documentDirectory = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first as String!
        let photoURL          = NSURL(fileURLWithPath: documentDirectory)
        let localPath         = photoURL.URLByAppendingPathComponent(imageName!)
        let image             = editingInfo![UIImagePickerControllerOriginalImage]as! UIImage
        let data              = UIImagePNGRepresentation(image)
        
        
        imgdata              = UIImagePNGRepresentation(image)!
        
        
        
        if let imageURL = editingInfo![UIImagePickerControllerReferenceURL] as? NSURL {
            let result = PHAsset.fetchAssetsWithALAssetURLs([imageURL], options: nil)
            
            
            self.file_name1 = result.firstObject?.filename ?? ""
            
            // var myasset=result.firstObject as! PHAsset
            ////print(myasset.mediaType)
            
            
            
        }
        
        ///
        
        var furl=NSURL(string: localPath.URLString)
        
        //print(furl!.pathExtension!)
        //print(furl!.URLByDeletingPathExtension?.lastPathComponent!)
        ftype=furl!.pathExtension!
        var fname=furl!.URLByDeletingPathExtension?.lastPathComponent!
        
        
        let dirPaths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let docsDir1 = dirPaths[0]
        var documentDir=docsDir1 as NSString
        filePathImage2=documentDir.stringByAppendingPathComponent(self.file_name1)
        var fm=NSFileManager.defaultManager()
        
        var fileAttributes:[String:AnyObject]=["":""]
        do {
            /// let fileAttributes : NSDictionary? = try NSFileManager.defaultManager().attributesOfItemAtPath(furl!.path!)
            ///    let fileAttributes : NSDictionary? = try NSFileManager.defaultManager().attributesOfItemAtPath(imageUrl.path!)
            let fileAttributes : NSDictionary? = try NSFileManager.defaultManager().attributesOfItemAtPath(filePathImage2)
            if let _attr = fileAttributes {
                self.fileSize1 = _attr.fileSize();
            }
        } catch {
            //  socketObj.socket.emit("logClient","IPHONE-LOG: error: \(error)")
            //print("Error:+++ \(error)")
        }
        
        
        //print("filename is \(self.filename) destination path is \(filePathImage2) image name \(imageName) imageurl \(imageUrl) photourl \(photoURL) localPath \(localPath).. \(localPath.absoluteString)")
        
        var s=fm.createFileAtPath(filePathImage2, contents: nil, attributes: nil)
        
        //  var written=fileData!.writeToFile(filePathImage2, atomically: false)
        
        //filePathImage2
        print("before reloading, filePathImage2 is \(filePathImage2)")
        data!.writeToFile(filePathImage2, atomically: true)
        
        
        //====================================UPLOAD HERE===============================
        if(self.imgdata != NSData.init())
        {
            print("profile image is selected")
            print("call API to upload image")
            
            //save filename
            
            /////var filetype="png"
            
            if(internetAvailable==true)
{
            managerFile.uploadProfileImage(groupid,filePath1: self.filePathImage2,filename: self.file_name1,fileType: self.ftype,completion: {(result,error) in
                
            })
}
else
            {
                let shareMenu = UIAlertController(title: nil, message: "Internet connectivity is required to upload group icon", preferredStyle: .ActionSheet)
                
                let yes = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: { (action) -> Void in
                    
                })
                shareMenu.addAction(yes)
                self.presentViewController(shareMenu, animated: true, completion:nil)
            }
            
            
        }
        
        ///
        
        self.dismissViewControllerAnimated(true, completion:{ ()-> Void in
            print("dismissing image picker")
            print("selected image is \(image)")
            self.tblGroupInfo.reloadData()
        })
        /* if let imageURL = editingInfo![UIImagePickerControllerReferenceURL] as? NSURL {
         let result = PHAsset.fetchAssetsWithALAssetURLs([imageURL], options: nil)
         
         
         self.filename = result.firstObject?.filename ?? ""
         
         // var myasset=result.firstObject as! PHAsset
         //print(myasset.mediaType)
         
         
         
         }*/
        
        
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
      
        subtitleLabel.adjustsFontSizeToFitWidth=false
        subtitleLabel.lineBreakMode=NSLineBreakMode.ByTruncatingTail
        
        
       //===== subtitleLabel.sizeToFit()
        
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
        
              /* var imageavatar1=UIImage(named: "avatar.png")
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
        */
        
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
        if(seguemsg=="gobackToGroupInfoSegue")
        {
            
            addToGroup()
        }

    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        
        //identifiersarrayAlreadySelected
        if segue.identifier == "addparticipantstogroupsegue" {
            
            
            if let destinationVC = segue.destinationViewController as? AddParticipantsViewController{
                destinationVC.prevScreen="Groupinfo"
                destinationVC.identifiersarrayAlreadySelected.removeAll()
                destinationVC.identifiersarrayAlreadySelected=identifiersarray
                destinationVC.groupid=groupid
                //  let selectedRow = tblForChat.indexPathForSelectedRow!.row
                
            }}
    }
 

}
