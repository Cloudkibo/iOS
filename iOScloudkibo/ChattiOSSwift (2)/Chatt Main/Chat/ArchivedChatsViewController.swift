//
//  ArchivedChatsViewController.swift
//  kiboApp
//
//  Created by Cloudkibo on 03/09/2016.
//  Copyright © 2016 MyAppTemplates. All rights reserved.
//

import UIKit
import SwiftyJSON
import SQLite
import AlamofireImage
import Contacts

class ArchivedChatsViewController: UIViewController, UINavigationControllerDelegate,SWTableViewCellDelegate {

    var swipeindexRow:Int!
    var messages:NSMutableArray!
    var contactPhoneNumber=""
    var contatName=""
    var groupchatmessages=Array<Row>()
    var chatmessages=Array<Row>()
    var mycontainer:URL?=nil
    let imageCache = AutoPurgingImageCache()
    var pendingGroupIcons=[String]()
   // var messages:NSMutableArray!
    var pendinggroupchatsarray=[[String:AnyObject]]()
    var groupsObjectList=[[String:AnyObject]]()

    let _id = Expression<String>("_id")
    let firstname = Expression<String?>("firstname")
    let lastname = Expression<String?>("lastname")
    let email = Expression<String>("email")
    let phone = Expression<String>("phone")
    let username1 = Expression<String>("username")
    let status = Expression<String>("status")
    let date = Expression<String>("date")
    let accountVerified = Expression<String>("accountVerified")
    let role = Expression<String>("role")
    let country_prefix = Expression<String>("country_prefix")
    let nationalNumber = Expression<String>("nationalNumber")
     var allkiboContactsArray=Array<Row>()
    var messageFrame = UIView()

    
    @IBOutlet weak var tblArchivedChats: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        messages=NSMutableArray()
        // Do any additional setup after loading the view.
        DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.default).async
            {
                self.retrieveSingleChatsAndGroupsChatData({(result)-> () in
                    
                    
                    //    DispatchQueue.main.async
                    //  {
                    // self.tblForChats.reloadData()
                    
                    //commenting newwwwwwww -===-===-=
                    DispatchQueue.main.async
                        {
                            self.tblArchivedChats.reloadData()
                    }
                }
        )
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
     func numberOfSectionsInTableView(_ tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
     func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        
        
        var messageDic=[String : AnyObject]()
        var ContactLastMessage=""
        
        var ContactUsernames=""
        var ContactsLastMsgDate = ""
        var ContactLastNAme=""
        var ContactNames=""
        var ContactStatus=""
        // let ContactUsernames=""
        var ContactOnlineStatus=0
        var ContactFirstname=""
        var ContactsPhone=""
        var ContactCountMsgRead=0
        var ContactsProfilePic:Data! = nil
        var ChatType=""
        
        messageDic = messages.object(at: indexPath.row) as! [String : AnyObject];
        
        ContactsLastMsgDate = messageDic["ContactsLastMsgDate"] as! String
        ContactLastMessage = messageDic["ContactLastMessage"] as! String
        ContactLastNAme=messageDic["ContactLastNAme"] as! String
        ContactNames=messageDic["ContactNames"] as! String
        ContactStatus=messageDic["ContactStatus"] as! String
        ContactUsernames=messageDic["ContactUsernames"] as! String
        ContactOnlineStatus=messageDic["ContactOnlineStatus"] as! Int
        ContactFirstname=messageDic["ContactFirstname"] as! String
        ContactsPhone=messageDic["ContactsPhone"] as! String
        ContactCountMsgRead=messageDic["ContactCountMsgRead"] as! Int
        ContactsProfilePic=messageDic["ContactsProfilePic"] as! Data
        ChatType=(messageDic["ChatType"] as! NSString) as String

        let cell = tblArchivedChats.dequeueReusableCell(withIdentifier: "ArchivedChatsCell")! as! ArchivedChatModelCell
        cell.rightUtilityButtons=self.getRightUtilityButtonsToCell() as [AnyObject]
        cell.delegate=self
/*
         @IBOutlet weak var profilePicOutlet: UIImageView!
         
         @IBOutlet weak var lblTitle: UILabel!
         @IBOutlet weak var lblTime: UILabel!
         
         @IBOutlet weak var lblSubTitle: UILabel!
         
         @IBOutlet weak var lblMsg: UILabel!
         
         @IBOutlet weak var lblARCHIVED: UILabel!

 */
            cell.lblTitle.text=ContactNames
        cell.lblSubTitle.text=ContactLastMessage
        cell.lblTime.text=ContactsLastMsgDate
            if(ContactsProfilePic != Data.init())
            {
                
                print("ound avatar in favourites")
                
                if let img=UIImage(data:ContactsProfilePic)
                {let w=img.size.width
                    var h=img.size.height
                    let wOld=cell.profilePicOutlet.bounds.width
                    let hOld=cell.profilePicOutlet.bounds.height
                    let scale:CGFloat=w/wOld
                    
                    ////self.ResizeImage(img!, targetSize: CGSizeMake(cell.profilePic.bounds.width,cell.profilePic.bounds.height))
                    
                    cell.profilePicOutlet.layer.borderWidth = 1.0
                    cell.profilePicOutlet.layer.masksToBounds = false
                    cell.profilePicOutlet.layer.borderColor = UIColor.white.cgColor
                    cell.profilePicOutlet.layer.cornerRadius = cell.profilePicOutlet.frame.size.width/2
                    cell.profilePicOutlet.clipsToBounds = true
                    
                    imageCache.removeImage(withIdentifier: ContactUsernames)
                    imageCache.add(img, withIdentifier: ContactUsernames)
                    
                    // Fetch
                    var cachedAvatar = imageCache.image(withIdentifier: ContactUsernames)
                    cachedAvatar=UtilityFunctions.init().resizedAvatar(img: cachedAvatar, size: CGSize(width: cell.profilePicOutlet.bounds.width,height: cell.profilePicOutlet.bounds.height), sizeStyle: "Fill")
                    
                    cell.profilePicOutlet.image=cachedAvatar
                }
                /*cell.profilePic.image=UIImage(data: ContactsProfilePic, scale: scale)
                 ///cell.profilePic.image=UIImage(data:ContactsProfilePic[indexPath.row])
                 UIImage(data: ContactsProfilePic, scale: scale)
                 print("image size is s \(UIImage(data:ContactsProfilePic)?.size.width) and h \(UIImage(data:ContactsProfilePic)?.size.height)")*/
            }
            else
            {
                print("not found avatar in favourites")
                cell.profilePicOutlet.image=UIImage(named: "profile-pic1")
                
            }
            
      
            if(ContactCountMsgRead > 0)
            {
                //!! show bubble for unread
                /*cell.newMsg.isHidden=false
                cell.countNewmsg.text="\(ContactCountMsgRead)"
                cell.countNewmsg.isHidden=false
 */
            }
            
        
        
        return cell
        
        
    }
    func swipeableTableViewCell(_ cell: SWTableViewCell!, didTriggerLeftUtilityButtonWith index: Int) {
        print("archive tapped")
    }
    func swipeableTableViewCell(_ cell: SWTableViewCell!, didTriggerRightUtilityButtonWith index: Int) {
        print("tapped swipe \(index)")
        swipeindexRow=tblArchivedChats.indexPath(for: cell)!.row
        // if(index==0)
        // {
        var messageDic = messages.object(at: swipeindexRow) as! [String : AnyObject];
        
        let ContactsLastMsgDate = messageDic["ContactsLastMsgDate"] as! String
        let ContactLastMessage = messageDic["ContactLastMessage"] as! String
        let ContactLastNAme=messageDic["ContactLastNAme"] as! String
        var ContactNames=messageDic["ContactNames"] as! String
        let ContactStatus=messageDic["ContactStatus"] as! String
        let ContactUsernames=messageDic["ContactUsernames"] as! String
        let ContactOnlineStatus=messageDic["ContactOnlineStatus"] as! Int
        let ContactFirstname=messageDic["ContactFirstname"] as! String
        let ContactsPhone=messageDic["ContactsPhone"] as! String
        let ContactCountMsgRead=messageDic["ContactCountMsgRead"] as! Int
        let ContactsProfilePic=messageDic["ContactsProfilePic"] as! Data
        let ChatType=messageDic["ChatType"] as! NSString
        
        print("RightUtilityButton index of more is \(index)")
        //if(editButtonOutlet.title==NSLocalizedString("Edit", tableName: nil, bundle: Bundle.main, value: "", comment: "Edit"))
            //"Edit")
       // {//UITableViewCellEditingStyle
            if(index==0)
            {
                if(ChatType != "single")
                {

                }
                else{
                    sqliteDB.updateArchiveStatus(contactPhone1: ContactUsernames, status: false)
                    var params=["id":ContactUsernames,"isArchived":"No"]
                    //id
                    //isArchived
                    UtilityFunctions.init().sendDataToDesktopApp(data1: params as AnyObject, type1: "chat_unarchive")
                    
                    DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.default).async
                        {
                            self.retrieveSingleChatsAndGroupsChatData({(result)-> () in
                                
                                
                                //    DispatchQueue.main.async
                                //  {
                                // self.tblForChats.reloadData()
                                
                                //commenting newwwwwwww -===-===-=
                                DispatchQueue.main.async
                                    {
                                        self.tblArchivedChats.reloadData()
                                }
                                }
                            )
                    }

                }
            }
        //}
    }
    func getRightUtilityButtonsToCell()-> NSMutableArray{
        let utilityButtons: NSMutableArray = NSMutableArray()
        
        
        //!!!utilityButtons.sw_addUtilityButton(with: UtilityFunctions.init().hexStringToUIColor("#DCDEE0"), icon: UIImage(named:"more.png".localized))
        
        //utilityButtons.sw_addUtilityButtonWithColor(UIColor.redColor(), title: NSLocalizedString("ABC", comment: ""))
        //DCDEE0
        utilityButtons.sw_addUtilityButton(with: UtilityFunctions.init().hexStringToUIColor("#24669A"), icon: UIImage(named:"unarchive.png".localized))
        return utilityButtons
        //24669A
    }
    
    func tableView(_ tableView: UITableView, heightForRowAtIndexPath indexPath: IndexPath) -> CGFloat {
        
        return 70
        
    }
    
    
    func retrieveSingleChatsAndGroupsChatData(_ completion:(_ result:Bool)->())
    {
        var pendingGroupIcons2=[String]()
        
        var messages2=NSMutableArray()
        var ContactsLastMsgDate=""
        var ContactLastMessage=""
        //self.ContactIDs.removeAll(keepCapacity: false)
        var ContactLastNAme=""
        var ContactNames=""
        var ContactStatus=""
        var ContactUsernames=""
        var ContactOnlineStatus=0
        ////////////////////////
        var ContactFirstname=""
        ////////
        
        var ContactsPhone=""
        ////self.ContactsEmail.removeAll(keepCapacity: false)
        //////self.ContactMsgRead.removeAll(keepCapacity: false)
        var ContactCountMsgRead=0
        var ContactsProfilePic=Data.init()
        var ChatType=""
        
        
        /*
        ///==dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0))
        
        self.groupsObjectList=sqliteDB.getGroupDetails() as [[String : AnyObject]]
        do{
            groupchatmessages=Array(try sqliteDB.db.prepare((sqliteDB.group_chat)!))
        }
        catch
        {
            print("error getting group chats")
        }
        for i in 0 ..< self.groupsObjectList.count
        {
            ContactsProfilePic=Data.init()
            //print("date is \(self.groupsObjectList[i]["date_creation"] as! NSDate)")
            
            if((self.groupsObjectList[i]["status"] as! String) == "temp")
            {
                print("group_failed called")
                ChatType="group_failed"
                
                //ChatType.append("group_failed")
            }
            else
            {
                ChatType="group"
                //ChatType.append("group")
            }
            //print("group name is \(self.groupsObjectList[i]["group_name"] as! String)")
            ContactNames=self.groupsObjectList[i]["group_name"] as! String
            ContactFirstname=self.groupsObjectList[i]["group_name"] as! String
            ContactLastNAme=""
            
            // ContactNames.append(groupsObjectList[i]["group_name"] as! String)
            //ContactFirstname.append(groupsObjectList[i]["group_name"] as! String)
            //ContactLastNAme.append("")
            
            var formatter2 = DateFormatter();
            formatter2.dateFormat = "MM/dd hh:mm a"
            formatter2.timeZone = TimeZone.autoupdatingCurrent
            ///////////////==========var defaultTimeeee = formatter2.stringFromDate(defaultTimeZoneStr!)
            var defaultTimeeee = formatter2.string(from: self.groupsObjectList[i]["date_creation"] as! Date)
            
            
            
            ContactStatus=""
            ContactUsernames=self.groupsObjectList[i]["unique_id"] as! String
            ContactOnlineStatus=0
            
            ContactsPhone=self.groupsObjectList[i]["unique_id"] as! String
            
            
            /*
             self.ContactStatus.append("")
             self.ContactUsernames.append(groupsObjectList[i]["unique_id"] as! String)
             ContactOnlineStatus.append(0)
             
             self.ContactsPhone.append(groupsObjectList[i]["unique_id"] as! String)
             */
            
            
            //check unread for group
            var unreadcount=sqliteDB.getGroupsUnreadMessagesCount(self.groupsObjectList[i]["unique_id"] as! String)
            //===================================
            ContactCountMsgRead=unreadcount
            
            
            //check file table and get path
            //NSData at contents at path
            //group_icon
            
            //group icon exists on server
            //var singleGroupInfo=sqliteDB.getSingleGroupInfo(self.groupsObjectList[i]["unique_id"] as! String)
            var filedata=sqliteDB.getFilesData(self.groupsObjectList[i]["unique_id"] as! String)
            if(filedata.count>0)
            {
                print("found group icon")
                print("actual path is \(filedata["file_path"])")
                //======
                
                //=======
                let dirPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
                let docsDir1 = dirPaths[0]
                var documentDir=docsDir1 as NSString
                var imgPath=documentDir.appendingPathComponent(filedata["file_name"] as! String)
                print("imgpath is \(imgPath)")
                if (FileManager.default.contents(atPath: imgPath) != nil)
                {
                    var imgdata=FileManager.default.contents(atPath: imgPath)!
                    ContactsProfilePic=imgdata
                }
                else
                {
                    // print("didnot find group icon")
                    pendingGroupIcons2.append(self.groupsObjectList[i]["unique_id"] as! String)
                    
                    ContactsProfilePic=Data.init()
                }
                
                // print("found path is \(imgNSData)")
                
                //  self.ContactsProfilePic.append(imgNSData!)
            }
                
            else
            {
                print("groups icon not exists")
            }
            
            let from = Expression<String>("from")
            let group_unique_id = Expression<String>("group_unique_id")
            let type = Expression<String>("type")
            let msg = Expression<String>("msg")
            let from_fullname = Expression<String>("from_fullname")
            let date = Expression<Date>("date")
            let unique_id = Expression<String>("unique_id")
            
            
            var tbl_groupchats=sqliteDB.group_chat
            
            let myquerylastmsg=tbl_groupchats?.filter(group_unique_id==(self.groupsObjectList[i]["unique_id"] as! String)).order(date.desc)
            
            var queryruncount=0
            
            var chatexists=false
            
            
            do{for ccclastmsg in try sqliteDB.db.prepare(myquerylastmsg!) {
                //print("date received in chat view is \(ccclastmsg[date])")
                
                var formatter2 = DateFormatter();
                formatter2.dateFormat = "MM/dd hh:mm a"
                formatter2.timeZone = NSTimeZone.local
                ///////////////==========var defaultTimeeee = formatter2.stringFromDate(defaultTimeZoneStr!)
                var defaultTimeeee = formatter2.string(from: ccclastmsg[date])
                //print("===fetch date from database is ccclastmsg[date] \(ccclastmsg[date])... defaultTimeeee \(defaultTimeeee)")
                
                
                // print("last msg is \(ccclastmsg[msg])")
                ContactsLastMsgDate=defaultTimeeee
                ContactLastMessage=ccclastmsg[msg]
                
                chatexists=true
                break
                }}catch{
                    print("error in fetching last msg")
            }
            if(chatexists==false)
            {
                ContactsLastMsgDate=defaultTimeeee
                ContactLastMessage="Welcome to the group".localized
            }
            /*
             var ContactsLastMsgDate=""
             var ContactLastMessage=""
             //self.ContactIDs.removeAll(keepCapacity: false)
             var ContactLastNAme=""
             var ContactNames=""
             var ContactStatus=""
             var ContactUsernames=""
             var ContactOnlineStatus=0
             ////////////////////////
             var ContactFirstname=""
             ////////
             
             var ContactsPhone=""
             ////self.ContactsEmail.removeAll(keepCapacity: false)
             //////self.ContactMsgRead.removeAll(keepCapacity: false)
             var ContactCountMsgRead=0
             var ContactsProfilePic=NSData.init()
             var ChatType=""
             */
            messages2.add(["ContactsLastMsgDate":ContactsLastMsgDate,"ContactLastMessage":ContactLastMessage,"ContactLastNAme":ContactLastNAme,"ContactNames":ContactNames,"ContactStatus":ContactStatus,"ContactUsernames":ContactUsernames,"ContactOnlineStatus":ContactOnlineStatus,"ContactFirstname":ContactFirstname,"ContactsPhone":ContactsPhone,"ContactCountMsgRead":ContactCountMsgRead,"ContactsProfilePic":ContactsProfilePic,"ChatType":ChatType])
            
            
            
        }
        
        */
        //=============================-----------------------------
        let tbl_userchats=sqliteDB.userschats
        let tbl_contactslists=sqliteDB.contactslists
        let tbl_allcontacts=sqliteDB.allcontacts
        let to = Expression<String>("to")
        let from = Expression<String>("from")
        let date = Expression<Date>("date")
        let msg = Expression<String>("msg")
        let fromFullName = Expression<String>("fromFullName")
        
        
        let uniqueid = Expression<String>("uniqueid")
        
        
        
        let contactPhone = Expression<String>("contactPhone")
        /////////// let contactProfileImage = Expression<NSData>("profileimage")
        let uniqueidentifier = Expression<String>("uniqueidentifier")
        let isArchived = Expression<Bool>("isArchived")
        
        let blockedByMe = Expression<Bool>("blockedByMe")
        let IamBlocked = Expression<Bool>("IamBlocked")
        
        
        // let myquery=tbl_userchats.join(tbl_contactslists, on: tbl_contactslists[phone] == tbl_userchats[contactPhone]).group(tbl_userchats[contactPhone]).order(date.desc)
        
        do
        {
            chatmessages=Array(try sqliteDB.db.prepare(((tbl_userchats)?.filter(isArchived==true))!))
            
        }
        catch
        {
            print("error: unable to get chats")
        }
        
        
        let myquery=tbl_userchats?.filter(isArchived==true).group((tbl_userchats?[contactPhone])!).order(date.desc)
        
        var queryruncount=0
        do{for ccc in try sqliteDB.db.prepare(myquery!) {
            
            /*var blockedcontact=false
             for resultrows in try sqliteDB.db.prepare((tbl_contactslists?.filter(phone==ccc[contactPhone] && blockedByMe==true))!)
             {
             print()
             blockedcontact=true
             break
             }
             if(blockedcontact==false)
             {*/
            /// tbl_contactslists?[blockedByMe])! == false
            queryruncount=queryruncount+1
            //print("queryruncount is \(queryruncount)")
            var picfound=false
            // print(ccc[phone])
            //print(ccc[contactPhone])
            //print(ccc[msg])
            //print(ccc[date])
            
            /*Alamofire.request(.POST,"\(Constants.MainUrl+Constants.urllog)",headers:header,parameters: ["data":"IPHONE_LOG: database date is \(ccc[date])"]).response{
             request, response_, data, error in
             print(error)
             }*/
            //print(ccc[uniqueid])
            //////print(ccc[tbl_userchats[status]])
            //print(ccc[self.status])
            //print(ccc[from])
            //print(ccc[fromFullName])
            
            //print("*************")
            ////////////ContactNames.append(ccc[firstname]+" "+ccc[lastname])
            //ContactUsernames.append(ccc[username])
            //print("ContactUsernames is \(ccc[username])")
            // %%%%%%%%%%%%%%%%************ CHAT BUG ID %%%%%%%%%%%
            // ContactIDs.append(ccc[contactid])
            // ContactIDs.append(tblContacts[userid])
            
            
            var nameFoundInAddressBook=false
            
            //!! error indexbounds
            /*let myquery1=tbl_userchats?.join(tbl_contactslists!, on: (tbl_contactslists?[self.phone])! == ccc[contactPhone] /*&& (tbl_contactslists?[blockedByMe])! == false*/)//.group(tbl_userchats[contactPhone]).order(date.desc)
            
            //  var queryruncount=0
            //do{
            for ccc1 in try sqliteDB.db.prepare(myquery1!) {
                nameFoundInAddressBook=true
                //print("name found \(ccc1[firstname]+" "+ccc1[lastname])")
                ContactNames=ccc1[self.firstname]!+" "+ccc1[self.lastname]!
                ContactFirstname=ccc1[self.firstname]!
                ContactLastNAme=ccc1[self.lastname]!
                break
                
            }
            if(nameFoundInAddressBook==false)
            {
                let myquery3=tbl_userchats?.filter((tbl_userchats?[from])! != username && (tbl_userchats?[contactPhone])!==ccc[contactPhone] && isArchived==true)
                
                
                for ccc3 in try sqliteDB.db.prepare(myquery3!) {
                    print("name not found \(ccc[fromFullName])")
                    ContactNames=ccc3[fromFullName]
                    ContactFirstname=ccc3[fromFullName]
                    ContactLastNAme=""
                    break
                    
                }
 
                //ccc[fromFullName]
                
                
            }*/
            
            ContactStatus="Hey there! I am using Kibo App".localized
            
            ////////////// ContactUsernames.append(ccc[phone])
            
            var name=sqliteDB.getNameFromAddressbook(ccc[contactPhone])
            if(name != "" && name != nil)
            {
            ContactNames=name!
            }
            else{
                ContactNames=ccc[contactPhone]
            }
            ContactUsernames=ccc[contactPhone]
            ///// ContactsEmail.append(ccc[email])
            /////ContactsPhone.append(ccc[phone])
            ContactsPhone=ccc[contactPhone]
            ContactOnlineStatus=0
            
            ChatType="single"
            
            
            let myquerylastmsg=tbl_userchats?.filter(isArchived==true && ( to==ccc[contactPhone] || from==ccc[contactPhone])).order(date.desc)
            
            var queryruncount=0
            
            
            
            
            do{for ccclastmsg in try sqliteDB.db.prepare(myquerylastmsg!) {
                //  print("date received in chat view is \(ccclastmsg[date])")
                
                
                var formatter2 = DateFormatter();
                formatter2.dateFormat = "MM/dd hh:mm a"
                formatter2.timeZone = NSTimeZone.local
                ///////////////==========var defaultTimeeee = formatter2.stringFromDate(defaultTimeZoneStr!)
                var defaultTimeeee = formatter2.string(from: ccclastmsg[date])
                // print("===fetch date from database is ccclastmsg[date] \(ccclastmsg[date])... defaultTimeeee \(defaultTimeeee)")
                
                
                
                //print("last msg is \(ccclastmsg[msg])")
                ContactsLastMsgDate=defaultTimeeee
                ContactLastMessage=ccclastmsg[msg]
                break
                }}catch{
                    print("error in fetching last msg")
            }
            //////ContactLastMessage.append(ccc[msg])
            
            // print("date of chat view page is to be converted \(ccc[date])")
            
            
            /// ContactsLastMsgDate.append(defaultTimeeee)
            ///////==========ContactsLastMsgDate.append(ccc[date])
            
            //do join query of allcontacts and contactslist table to get avatar
            
            
            
            //!! error index bounds
           /* var joinrows=UtilityFunctions.init().leftJoinContactsTables(ccc[contactPhone])
            
            if(joinrows.count>0)
            {
                for ii in 0 ..< joinrows.count{
                    //print(joinrows.debugDescription)
                    //print("found uniqueidentifier from joinnn is \(joinrows[0].get(uniqueidentifier))")
                    //==========----------let queryPic = tbl_allcontacts.filter(tbl_allcontacts[phone] == ccc[contactPhone])
                    
                    //do{
                    //=======------- for picquery in try sqliteDB.db.prepare(queryPic) {
                    
                    let contactStore = CNContactStore()
                    
                    var keys = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactEmailAddressesKey, CNContactPhoneNumbersKey, CNContactImageDataAvailableKey,CNContactThumbnailImageDataKey, CNContactImageDataKey]
                    //--- var foundcontact=try contactStore.unifiedContactWithIdentifier(picquery[uniqueidentifier], keysToFetch: keys)
                    var foundcontact=try contactStore.unifiedContact(withIdentifier: joinrows[ii].get(uniqueidentifier), keysToFetch: keys as [CNKeyDescriptor])
                    
                    
                    
                    if(foundcontact.imageDataAvailable==true)
                    {
                        foundcontact.imageData
                        ContactsProfilePic=foundcontact.imageData!
                        picfound=true
                        break
                    }
                }
                
            }
            */
            if(picfound==false)
            {
                //print("no pic found for \(ContactUsernames)")
                ContactsProfilePic=NSData.init() as Data
                // print("picquery NOT found for \(ccc[phone]) and is \(NSData.init())")
            }
           
            let query = tbl_userchats?.filter(from == ccc[contactPhone] && self.status == "delivered")          // SELECT "email" FROM "users"
            
            
            self.allkiboContactsArray = Array(try sqliteDB.db.prepare(query!))
            if(self.allkiboContactsArray.first==nil)
            {
                ContactCountMsgRead=0
            }
            else{
                ContactCountMsgRead=self.allkiboContactsArray.count
            }
            
            messages2.add(["ContactsLastMsgDate":ContactsLastMsgDate,"ContactLastMessage":ContactLastMessage,"ContactLastNAme":ContactLastNAme,"ContactNames":ContactNames,"ContactStatus":ContactStatus,"ContactUsernames":ContactUsernames,"ContactOnlineStatus":ContactOnlineStatus,"ContactFirstname":ContactFirstname,"ContactsPhone":ContactsPhone,"ContactCountMsgRead":ContactCountMsgRead,"ContactsProfilePic":ContactsProfilePic,"ChatType":ChatType])
            }
        
            //}
        }
        catch{
            
        }
      
        messages2.sort(comparator: {
            let obj1 = $0 as! [String:AnyObject]
            let obj2 = $1 as! [String:AnyObject]
            var datestr1=obj1["ContactsLastMsgDate"] as! String
            var datestr2=obj2["ContactsLastMsgDate"] as! String
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd hh:mm a"
            let date1 = dateFormatter.date(from: datestr1 as String)
            let date2 = dateFormatter.date(from: datestr2 as String)
            let result=date1!.compare(date2!)
            // print("date1comparator is \(date1) date2comparator is \(date2)")
            if(result == ComparisonResult.orderedAscending)
            {
                return .orderedDescending
            }
            if(result == ComparisonResult.orderedSame)
            {
                return .orderedSame
            }
            return ComparisonResult.orderedAscending
        })
        //self.messages.setArray(sortedmessages as [AnyObject])
        
        self.messages.setArray(messages2 as [AnyObject])
        self.messageFrame.removeFromSuperview()
        self.pendingGroupIcons.removeAll()
        for i in 0 ..< pendingGroupIcons2.count
        {
            self.pendingGroupIcons.append(pendingGroupIcons2[i])
        }
        return completion(true)
    }
    
    //call from UI
    
    func unArchiveChats(phone1:String)
    {
        sqliteDB.updateArchiveStatus(contactPhone1: phone1, status: false)
    }
    
    func tableView(_ tableView: UITableView!, didSelectRowAtIndexPath indexPath: IndexPath!){
        
        //let indexPath = tableView.indexPathForSelectedRow();
        //let currentCell = tableView.cellForRowAtIndexPath(indexPath!) as UITableViewCell!;
        //if(indexPath.row < (ContactNames.count))
        //{
        //print(ContactNames[indexPath.row], terminator: "")
        self.performSegue(withIdentifier: "archivedChatsDetailSegue", sender: nil);
        //}
        //slideToChat
        
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue?, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        //archivedChatsDetailSegue
        if segue?.identifier == "archivedChatsDetailSegue" {
            
            if let destinationVC = segue!.destination as? ChatDetailViewController{
                
                let selectedRow = tblArchivedChats.indexPathForSelectedRow!.row
                
                var messageDic = messages.object(at: selectedRow) as! [String : AnyObject];
                
                
                //destinationVC.selectedContact = ContactNames[selectedRow]
                destinationVC.selectedContact = messageDic["ContactUsernames"] as! String
                destinationVC.selectedFirstName=messageDic["ContactNames"] as! String
                destinationVC.selectedLastName=""
                // destinationVC.selectedID=ContactIDs[selectedRow]
                //destinationVC.AuthToken = self.AuthToken
                
                //
                /* var getUserbByIdURL=Constants.MainUrl+Constants.getSingleUserByID+ContactIDs[selectedRow]+"?access_token="+AuthToken
                 print(getUserbByIdURL.debugDescription+"..........")
                 Alamofire.request(.GET,"\(getUserbByIdURL)").response{
                 request, response, data, error in
                 print(error)
                 
                 if response?.statusCode==200
                 
                 {
                 print("got userrrrrrr")
                 print(data?.debugDescription)
                 print(":::::::::")
                 destinationVC.selectedUserObj=JSON(data!)
                 }
                 else
                 {
                 print("didnt get userrrrr")
                 print(error)
                 print(data)
                 print(response)
                 }
                 }*/
                
                //
            }
        }
    }
    

}
