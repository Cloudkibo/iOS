//
//  NewGroupSetDetails.swift
//  kiboApp
//
//  Created by Cloudkibo on 27/08/2016.
//  Copyright © 2016 MyAppTemplates. All rights reserved.
//

//import Cocoa
import Contacts
import Alamofire
import SQLite
import Photos
import AssetsLibrary

class NewGroupSetDetails: UITableViewController,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITextFieldDelegate{

    
    var activeTextField = UITextField()
    @IBOutlet weak var btnCreateGroupOutlet: UIBarButtonItem!
    var filePathImage2=""
    var ftype=""
    var fileSize1:UInt64=0
    var filePathImage:String!
    ////** new commented april 2016var fileSize:Int!
    var fileContents:Data!
    
    var file_name1=""
    var uniqueid=""
    var groupname=""
   /// @IBOutlet weak var txtFieldGroupName: UITextField!
    var imgdata=Data.init()
   // var participants=[CNContact]()
    var participants=[EPContact]()
       @IBOutlet var tblNewGroupDetails: UITableView!
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 2
    }
    
    func textFieldShouldReturn (_ textField: UITextField!) -> Bool{
        
        let cell=tblNewGroupDetails.cellForRow(at: IndexPath(row: 0, section: 0)) as! ContactsListCell
        
        cell.groupNameFieldOutlet.resignFirstResponder()
        return true

    }
    
   
    func textFieldDidChange(_ textField: UITextField) {
        print("textfield editing")
    //var cell=tblNewGroupDetails.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as! ContactsListCell
       // let cell=tblNewGroupDetails.dequeueReusableCellWithIdentifier("NewGroupDetailsCell") as! ContactsListCell
        
    if(!textField.text!.isEmpty)
    {
        
    btnCreateGroupOutlet.isEnabled = true
    
    }
    else
    {
    btnCreateGroupOutlet.isEnabled = false
    }
}
    
    @IBAction func btnCreateGroupDone(_ sender: AnyObject) {
        //create group
        //save data in sqlite
        
        var uid=randomStringWithLength(7)
        
        var date=Date()
        var calendar = Calendar.current
        var year=(calendar as NSCalendar).components(NSCalendar.Unit.year,from: date).year
        var month=(calendar as NSCalendar).components(NSCalendar.Unit.month,from: date).month
        var day=(calendar as NSCalendar).components(.day,from: date).day
        var hr=(calendar as NSCalendar).components(NSCalendar.Unit.hour,from: date).hour
        var min=(calendar as NSCalendar).components(NSCalendar.Unit.minute,from: date).minute
        var sec=(calendar as NSCalendar).components(NSCalendar.Unit.second,from: date).second
        print("\(year) \(month) \(day) \(hr) \(min) \(sec)")
        uniqueid="\(uid)\(year!)\(month!)\(day!)\(hr!)\(min!)\(sec!)"
        

        
        print("saving in database")
        
        
       // let cell=tblNewGroupDetails.dequeueReusableCellWithIdentifier("NewGroupDetailsCell") as! ContactsListCell
      //  "NewGroupParticipantsCell"
        var cell=tblNewGroupDetails.cellForRow(at: IndexPath(row: 0, section: 0)) as! ContactsListCell
        
        groupname=cell.groupNameFieldOutlet.text!
        
        var memberphones=[String]()
        var membersnames=[String]()
        for i in 0 ..< participants.count
        {
            memberphones.append(participants[i].getPhoneNumber())
            membersnames.append(participants[i].displayName())
        }
        print("group_name is \(groupname)")
        print("memberphones are \(memberphones)")
        print("memberphones.debugDescription are \(memberphones.debugDescription)")
        
        //==========sqliteDB.storeGroups(groupname, groupicon1: imgdata, datecreation1: NSDate(), uniqueid1: uniqueid)
        
        let firstname = Expression<String>("firstname")
        let phone = Expression<String>("phone")
        
        var myname=""
        let tbl_accounts = sqliteDB.accounts
        do{for account in try sqliteDB.db.prepare(tbl_accounts!) {
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
       
        
        //might uncomment.. moved in next function for test and sync
        /*sqliteDB.storeMembers(uniqueid,member_displayname1: myname, member_phone1: username!, isAdmin1: "Yes", membershipStatus1: "joined", date_joined1: NSDate.init())
        
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
        
        createGroupAPI(groupname,members: memberphones,uniqueid: uniqueid)
        //send to server
        
        //segue to chat page
        
        
    }
    
    func createGroupAPI(_ groupname:String,members:[String],uniqueid:String)
    {
        //show progress wheen somewhere
       
       // var memberphones=[String]()
        var membersnames=[String]()
        for i in 0 ..< participants.count
        {
          //  memberphones.append(participants[i].getPhoneNumber())
            membersnames.append(participants[i].displayName())
        }
        
        
        
        var url=Constants.MainUrl+Constants.createGroupUrl
        
        let request = Alamofire.request("\(url)", method: .post, parameters:["group_name":groupname,"members":members, "unique_id":uniqueid],encoding: JSONEncoding.default,headers:header).responseJSON { response in
         
            
       // Alamofire.request(.POST,"\(url)",parameters:["group_name":groupname,"members":members, "unique_id":uniqueid],headers:header,encoding:.JSON).validate().responseJSON { response in
            
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
            print("Create Group API called")
            if(response.result.isSuccess)
            {
                
                print(response.result.debugDescription)
                print("showing group chats page now")
                
                let firstname = Expression<String>("firstname")
                let phone = Expression<String>("phone")
                
                var myname=""
                let tbl_accounts = sqliteDB.accounts
                do{for account in try sqliteDB.db.prepare(tbl_accounts!) {
                    myname=account[firstname]
                    username=account[phone]
                    
                    }
                }
                catch
                {
                   
                    print("error in getting data from accounts table")
                    
                }
                

               /* var syncMembers=syncGroupService.init()
                syncMembers.SyncGroupMembersAPI(){(result,error,groupinfo) in
                    print("...")
                     self.performSegueWithIdentifier("groupChatStartSegue", sender: nil)
                }*/
                
                //check if status not temp
                sqliteDB.storeGroups(groupname, groupicon1: self.imgdata, datecreation1: NSDate() as Date, uniqueid1: uniqueid, status1: "new")
                
                //=====MUTE GROUP====
                sqliteDB.storeMuteGroupSettingsTable(uniqueid, isMute1: false, muteTime1: NSDate() as Date, unMuteTime1: NSDate() as Date)
                
                
                sqliteDB.storeGroupsChat(username!, group_unique_id1: uniqueid, type1: "log", msg1: "You created this group", from_fullname1: username!, date1: NSDate() as Date, unique_id1: UtilityFunctions.init().generateUniqueid())
                
                sqliteDB.storeMembers(uniqueid,member_displayname1: myname, member_phone1: username!, isAdmin1: "Yes", membershipStatus1: "joined", date_joined1: NSDate.init() as Date)
              
                
                 var membersarray=[String]()
                for var i in 0 ..< members.count
                {
                    var isAdmin="No"
                    
                    print("members phone comparison \(members[i]) \(username)")
                    if(members[i] == username)
                    {
                        print("adding group admin")
                        isAdmin="Yes"
                        sqliteDB.storeMembers(uniqueid,member_displayname1: myname, member_phone1: members[i], isAdmin1: isAdmin, membershipStatus1: "joined", date_joined1: NSDate.init() as Date)
                        
                    }
                    else{
                        
                        sqliteDB.storeMembers(uniqueid,member_displayname1: membersnames[i], member_phone1: members[i], isAdmin1: isAdmin, membershipStatus1: "joined", date_joined1: NSDate.init() as Date)
                    }
                    
                }
                
                if(self.imgdata != NSData.init() as Data && self.filePathImage2 != "")
                {
                    print("profile image is selected")
                    print("call API to upload image")
                    
                    //save filename
                   
                    /////var filetype="png"
                    managerFile.uploadProfileImage(uniqueid,filePath1: self.filePathImage2,filename: self.file_name1,fileType: self.ftype,completion: {(result,error) in
                    
                    })
 
                }
                //---uncomment later --- self.performSegueWithIdentifier("groupChatStartSegue", sender: nil)
          self.performSegue(withIdentifier: "backToChatsSegue", sender: nil)
                
                  /*self.dismiss(true, completion: {
                    
                    
                })*/
                var groupParams=[String:AnyObject]()
                //groupname, groupicon1: self.imgdata, datecreation1: NSDate() as Date, uniqueid1: uniqueid
                
                groupParams=["unique_id":uniqueid as AnyObject,"group_name":groupname as AnyObject,"is_mute":"\(false)" as AnyObject,"date_creation":"\(NSDate() as Date)" as AnyObject]
               
          //loading_group_members
                
            UtilityFunctions.init().sendDataToDesktopApp(data1: groupParams as AnyObject ,type1: "loading_groups")
                UtilityFunctions.init().sendDataToDesktopApp(data1: members as AnyObject ,type1: "loading_group_members")
            }
            else{
                 print(response.result.debugDescription)
                print("error in create group endpoint")
                let firstname = Expression<String>("firstname")
                let phone = Expression<String>("phone")
                
                var myname=""
                let tbl_accounts = sqliteDB.accounts
                do{for account in try sqliteDB.db.prepare(tbl_accounts!) {
                    myname=account[firstname]
                    username=account[phone]
                    
                    }
                }
                catch
                {
                    
                    print("error in getting data from accounts table")
                    
                }
                //updateGroupsCreateNewStatus
                sqliteDB.storeGroups(groupname, groupicon1: self.imgdata, datecreation1: NSDate() as Date, uniqueid1: uniqueid, status1: "temp")
               
                //=====MUTE GROUP====
                sqliteDB.storeMuteGroupSettingsTable(uniqueid, isMute1: false, muteTime1: NSDate() as Date, unMuteTime1: NSDate() as Date)
                
                
                sqliteDB.storeGroupsChat("Log:", group_unique_id1: uniqueid, type1: "log", msg1: "Failed to create group. Tap to try again", from_fullname1: "log", date1: NSDate() as Date, unique_id1: UtilityFunctions.init().generateUniqueid())
                
                sqliteDB.storeMembers(uniqueid,member_displayname1: myname, member_phone1: username!, isAdmin1: "Yes", membershipStatus1: "temp", date_joined1: NSDate() as Date)
                
                
                
                for i in 0 ..< members.count
                {
                    var isAdmin="No"
                    
                    print("members phone comparison \(members[i]) \(username)")
                    if(members[i] == username)
                    {
                        print("adding group admin")
                        isAdmin="Yes"
                        sqliteDB.storeMembers(uniqueid,member_displayname1: myname, member_phone1: members[i], isAdmin1: isAdmin, membershipStatus1: "temp", date_joined1: NSDate() as Date)
                        
                    }
                    else{
                        
                        sqliteDB.storeMembers(uniqueid,member_displayname1: membersnames[i], member_phone1: members[i], isAdmin1: isAdmin, membershipStatus1: "temp", date_joined1: NSDate() as Date)
                    }
                    
                }
                
                if(self.imgdata != NSData.init() as Data && self.filePathImage2 != "")
                {
                    print("profile image is selected")
                    print("call API to upload image")
                    
                    //save filename
                    
                    //var filetype="png"
                    managerFile.uploadProfileImage(uniqueid,filePath1: self.filePathImage2,filename: self.file_name1,fileType: self.ftype,completion: {(result,error) in
                        
                    })
                    
                }

                
                print("dismiss new group now")
                self.dismiss(animated: true, completion: { 
                   print("dismissing newgroupcreate")
                    UIDelegates.getInstance().UpdateMainPageChatsDelegateCall()
                })
                //self.performSegueWithIdentifier("backToMainChatSegue", sender: nil)
            
            }
        }
        
    }
    
       
    func randomStringWithLength (_ len : Int) -> NSString {
        
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        
        let randomString : NSMutableString = NSMutableString(capacity: len)
        
        for  i in 0 ..< len{
            let length = UInt32 (letters.length)
            let rand = arc4random_uniform(length)
            randomString.appendFormat("%C", letters.character(at: Int(rand)))
        }
        
        return randomString
    }
    
    func ResizeImage(_ image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / image.size.width
        let heightRatio = targetSize.height / image.size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(indexPath.row==0)
        {
        let cell=tblNewGroupDetails.dequeueReusableCell(withIdentifier: "NewGroupDetailsCell") as! ContactsListCell
        "NewGroupParticipantsCell"
            
            cell.groupNameFieldOutlet.delegate=self
            cell.groupNameFieldOutlet.addTarget(self, action: #selector(NewGroupSetDetails.textFieldDidChange(_:)), for: UIControlEvents.editingChanged)
            cell.btn_edit_profilePic.isHidden=true
            cell.txt_label_group_details.text="Please provide a group subject and optional group icon".localized
            groupname=cell.groupNameFieldOutlet.text!.localized
            if(imgdata != Data.init())
            {
                cell.btn_edit_profilePic.isHidden=false
                let tempimg=UIImage(data: imgdata)
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
                
                
                cell.profilePicCameraOutlet.layer.borderWidth = 1.0
                cell.profilePicCameraOutlet.layer.masksToBounds = false
                cell.profilePicCameraOutlet.layer.borderColor = UIColor.white.cgColor
                cell.profilePicCameraOutlet.layer.cornerRadius = cell.profilePicCameraOutlet.frame.size.width/2
                cell.profilePicCameraOutlet.clipsToBounds = true
                
                
                let w=tempimg!.size.width
                var h=tempimg!.size.height
                let wOld=(cell.profilePicCameraOutlet.frame.width)
                var hOld=(cell.profilePicCameraOutlet.frame.height)
                let scale:CGFloat=w/wOld
                
                 cell.profilePicCameraOutlet.image=UIImage(data: imgdata,scale: scale)
              //  cell.profilePicCameraOutlet.image=UIImage(data: imgdata)
                 //Add the recognizer to your view.
                // chatImage.addGestureRecognizer(tapRecognizer)
                
               /* let tapRecognizerOld = UITapGestureRecognizer(target: self, action: Selector("imageTapped:"))
                
                cell.profilePicCameraOutlet.removeGestureRecognizer(tapRecognizerOld)
                */
                let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(NewGroupSetDetails.imageEditTapped(_:)))
                
                cell.profilePicCameraOutlet.addGestureRecognizer(tapRecognizer)
               
                let tapRecognizer2 = UITapGestureRecognizer(target: self, action: #selector(NewGroupSetDetails.imageEditTapped(_:)))
                cell.btn_edit_profilePic.addGestureRecognizer(tapRecognizer2)
            }
            else
            {
                let tempimg=UIImage(named:"chat_camera")
                imgdata=UIImagePNGRepresentation(tempimg!)!
                cell.profilePicCameraOutlet.layer.borderWidth = 1.0
                cell.profilePicCameraOutlet.layer.masksToBounds = false
                cell.profilePicCameraOutlet.layer.borderColor = UIColor.white.cgColor
                cell.profilePicCameraOutlet.layer.cornerRadius = cell.profilePicCameraOutlet.frame.size.width/2
                cell.profilePicCameraOutlet.clipsToBounds = true
                
                
                let w=tempimg!.size.width
                var h=tempimg!.size.height
                let wOld=(cell.profilePicCameraOutlet.frame.width)
                var hOld=(cell.profilePicCameraOutlet.frame.height)
                let scale:CGFloat=wOld/w
                
                cell.profilePicCameraOutlet.image=UIImage(data: imgdata,scale: scale)
                
            let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(NewGroupSetDetails.imageTapped(_:)))
            //Add the recognizer to your view.
           // chatImage.addGestureRecognizer(tapRecognizer)
            
            cell.profilePicCameraOutlet.addGestureRecognizer(tapRecognizer)
            }
            
        return cell
        }
        else{
            let cell=tblNewGroupDetails.dequeueReusableCell(withIdentifier: "NewGroupParticipantsCell") as! ContactsListCell
            cell.lbl_participantsNumberFromOne.text="PARTICIPANTS \(participants.count) of 256"
            cell.participantsCollection.delegate=self
            cell.participantsCollection.dataSource=self
            
            return cell
        }
        
    }
    
    func imageEditTapped(_ gestureRecognizer: UITapGestureRecognizer) {
        //tappedImageView will be the image view that was tapped.
        //dismiss it, animate it off screen, whatever.
        let shareMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let resetImage = UIAlertAction(title: "Reset Image".localized, style: UIAlertActionStyle.default,handler: { (action) -> Void in
            
            self.imgdata=Data.init()
            gestureRecognizer.view?.removeGestureRecognizer(gestureRecognizer)
            self.tblNewGroupDetails.reloadData()
            
            //// self.removeChatHistory(self.ContactUsernames[indexPath.row],indexPath: indexPath)
            
            //call Mute delegate or method
        })
        
        let SelectImage = UIAlertAction(title: "Select Image".localized, style: UIAlertActionStyle.default,handler: { (action) -> Void in
            
            self.selectImage(gestureRecognizer)
            
            // swipeindex=index
            //self.performSegueWithIdentifier("groupInfoSegue", sender: nil)
            //// self.removeChatHistory(self.ContactUsernames[indexPath.row],indexPath: indexPath)
            
            //call Mute delegate or method
        })
        
        let cancel = UIAlertAction(title: "Cancel".localized, style: UIAlertActionStyle.cancel, handler: { (action) -> Void in
            
            // swipeindex=index
            //self.performSegueWithIdentifier("groupInfoSegue", sender: nil)
            //// self.removeChatHistory(self.ContactUsernames[indexPath.row],indexPath: indexPath)
            
            //call Mute delegate or method
        })
    shareMenu.addAction(resetImage)
    shareMenu.addAction(SelectImage)
        shareMenu.addAction(cancel)
        
        self.present(shareMenu, animated: true) { 
            
            
        }
    
        
        //selectedImage=tappedImageView.image
        // self.performSegueWithIdentifier("showFullImageSegue", sender: nil);
        
    }
    
    func selectImage(_ gestureRecognizer: UITapGestureRecognizer)
    {
        
       let tappedImageView = gestureRecognizer.view
        
        let picker=UIImagePickerController.init()
        picker.delegate=self
        
        picker.allowsEditing = true;
        //picker.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
        // if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary))
        //  {
        
        //savedPhotosAlbum
        // picker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        //}
        picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        ////picker.mediaTypes=[kUTTypeMovie as NSString as String,kUTTypeMovie as NSString as String]
        //[self presentViewController:picker animated:YES completion:NULL];
        DispatchQueue.main.async
        { () -> Void in
            //  picker.addChildViewController(UILabel("hiiiiiiiiiiiii"))
            
            self.present(picker, animated: true,completion: {
                print("done choosing image")

            tappedImageView!.removeGestureRecognizer(gestureRecognizer)
            })
        }

    }
    
    
    func imageTapped(_ gestureRecognizer: UITapGestureRecognizer) {
        //tappedImageView will be the image view that was tapped.
        //dismiss it, animate it off screen, whatever.
        let tappedImageView = gestureRecognizer.view! as! UIImageView
        
        let picker=UIImagePickerController.init()
        picker.delegate=self
        
        picker.allowsEditing = true;
        //picker.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
        // if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary))
        //  {
        
        //savedPhotosAlbum
        // picker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        //}
        picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        ////picker.mediaTypes=[kUTTypeMovie as NSString as String,kUTTypeMovie as NSString as String]
        //[self presentViewController:picker animated:YES completion:NULL];
        DispatchQueue.main.async
        { () -> Void in
            //  picker.addChildViewController(UILabel("hiiiiiiiiiiiii"))
            
            self.present(picker, animated: true, completion: { 
                
                //new
                print("removing gesture")
                tappedImageView.removeGestureRecognizer(gestureRecognizer)
            })
            
        }
        
        //selectedImage=tappedImageView.image
       // self.performSegueWithIdentifier("showFullImageSegue", sender: nil);
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        
        self.dismiss(animated: true, completion:{ ()-> Void in
            print("cancelled and dismissing image picker")
           // imgdata=NSData.init()
            self.tblNewGroupDetails.reloadData()
        })
        
        
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
        
        
        //  var filesizenew=""
        
        
        let imageUrl          = editingInfo![UIImagePickerControllerReferenceURL] as! URL
        let imageName         = imageUrl.lastPathComponent
        let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first as String!
        let photoURL          = URL(fileURLWithPath: documentDirectory!)
        let localPath         = photoURL.appendingPathComponent(imageName)
        let image             = editingInfo![UIImagePickerControllerOriginalImage]as! UIImage
        let data              = UIImagePNGRepresentation(image)
        
        
         imgdata              = UIImagePNGRepresentation(image)!
        
       
        
        if let imageURL = editingInfo![UIImagePickerControllerReferenceURL] as? URL {
            let result = PHAsset.fetchAssets(withALAssetURLs: [imageURL], options: nil)
            
            var asset=result.firstObject! as PHAsset
            self.file_name1=asset.originalFilename!
            //==----self.file_name1 = (result.firstObject?.burstIdentifier)!
            // var myasset=result.firstObject as! PHAsset
            ////print(myasset.mediaType)
            print("original filename is \(self.file_name1)")
            
            
        }
        ///
        
        var furl=URL(string: localPath.absoluteString)
        
        //print(furl!.pathExtension!)
        //print(furl!.deletingLastPathComponent())
        ftype=furl!.pathExtension
        var fname=furl!.deletingLastPathComponent()
        
        
        let dirPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let docsDir1 = dirPaths[0]
        var documentDir=docsDir1 as NSString
        filePathImage2=documentDir.appendingPathComponent(self.file_name1)
        var fm=FileManager.default
        
        var fileAttributes:[String:AnyObject]=["":"" as AnyObject]
        do {
            /// let fileAttributes : NSDictionary? = try NSFileManager.defaultManager().attributesOfItemAtPath(furl!.path!)
            ///    let fileAttributes : NSDictionary? = try NSFileManager.defaultManager().attributesOfItemAtPath(imageUrl.path!)
            let fileAttributes : NSDictionary? = try FileManager.default.attributesOfItem(atPath: filePathImage2) as NSDictionary?
            if let _attr = fileAttributes {
                self.fileSize1 = _attr.fileSize();
                   }
        } catch {
          //  socketObj.socket.emit("logClient","IPHONE-LOG: error: \(error)")
            //print("Error:+++ \(error)")
        }
        
        
        //print("filename is \(self.filename) destination path is \(filePathImage2) image name \(imageName) imageurl \(imageUrl) photourl \(photoURL) localPath \(localPath).. \(localPath.absoluteString)")
        
        var s=fm.createFile(atPath: filePathImage2, contents: nil, attributes: nil)
        
        //  var written=fileData!.writeToFile(filePathImage2, atomically: false)
        
        //filePathImage2
        print("before reloading, filePathImage2 is \(filePathImage2)")
        var written=(try? data!.write(to: URL(fileURLWithPath: filePathImage2), options: [.atomic])) != nil
        
        ///
        if(written==true)
{
        self.dismiss(animated: true, completion:{ ()-> Void in
            print("dismissing image picker")
            print("selected image is \(image)")
            self.tblNewGroupDetails.reloadData()
        })
}
        else{
            print("failed to write profile pic file")
        }
        /* if let imageURL = editingInfo![UIImagePickerControllerReferenceURL] as? NSURL {
            let result = PHAsset.fetchAssetsWithALAssetURLs([imageURL], options: nil)
            
            
            self.filename = result.firstObject?.filename ?? ""
            
            // var myasset=result.firstObject as! PHAsset
            //print(myasset.mediaType)
            
            
            
        }*/
        

    }
    override func viewWillAppear(_ animated: Bool) {
        let cell=tblNewGroupDetails.dequeueReusableCell(withIdentifier: "NewGroupDetailsCell") as! ContactsListCell
        //cell=tblNewGroupDetails.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as! ContactsListCell
        cell.groupNameFieldOutlet.delegate=self

      //  btnCreateGroupOutlet.enabled=false
       
    }
    
    override func viewDidLoad() {
          //sqliteDB.db. groups.delete()
        btnCreateGroupOutlet.isEnabled=false
        
    }
    
    
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        guard let tableViewCell = cell as? ContactsListCell else { return }
        
       // tableViewCell.setCollectionViewDataSourceDelegate(self, forRow: indexPath.row)
        
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(indexPath.row==0)
        {
        return 150
        }
        else{
            return tableView.frame.height-100
            
        }
    }
    
   /* func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    // make a cell for each cell index path
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        print("collectionview...")
        // get a reference to our storyboard cell
       // let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ParticipantsAvatarsCell", forIndexPath: indexPath) as! UICollectionViewCell
        let collectionview=tblNewGroupDetails.dequeueReusableCellWithIdentifier("NewGroupParticipantsCell") as! ContactsListCell
        
        
        let cell = collectionview.participantsCollection.dequeueReusableCellWithReuseIdentifier("ParticipantsAvatarsCell", forIndexPath: indexPath) as! UICollectionViewCell
        
        // Use the outlet in our custom class to get a reference to the UILabel in the cell
        //cell.myLabel.text = self.items[indexPath.item]
        //cell.backgroundColor = UIColor.yellowColor() // make cell more visible in our example project
        cell.backgroundColor=UIColor.redColor()
        return cell
    }
    
*/


}

extension NewGroupSetDetails: UICollectionViewDelegate, UICollectionViewDataSource {
    
  
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return participants.count
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print("collectionview...")
        // get a reference to our storyboard cell
        // let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ParticipantsAvatarsCell", forIndexPath: indexPath) as! UICollectionViewCell
      /*  let collectionview=tblNewGroupDetails.dequeueReusableCellWithIdentifier("NewGroupParticipantsCell") as! ContactsListCell
        */
        
       // let cell = collectionview.participantsCollection.dequeueReusableCellWithReuseIdentifier("ParticipantsAvatarsCell", forIndexPath: indexPath)
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ParticipantsAvatarsCell", for: indexPath) as! ParticipantsCollectionCell
       //cell.participantsName.text=participants[indexPath.row].givenName
        cell.participantsName.text=participants[indexPath.row].displayName()
        
        
        
                let contactStore = CNContactStore()
        
        var keys = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactEmailAddressesKey, CNContactPhoneNumbersKey, CNContactImageDataAvailableKey,CNContactThumbnailImageDataKey, CNContactImageDataKey]
        
        do
        {//var foundcontact=try contactStore.unifiedContactWithIdentifier(participants[indexPath.row].identifier, keysToFetch: keys)
           // var foundcontact=try contactStore.unifiedContactWithIdentifier(participants[indexPath.row].identifier, keysToFetch: keys)
            

        
       // var foundcontact=try contactStore.unifiedContactWithIdentifier(picquery[uniqueidentifier], keysToFetch: keys)
        if(participants[indexPath.row].thumbnailProfileImage != nil)
           // if(foundcontact.imageDataAvailable==true)
        {
            print("here image found")
         //   foundcontact.imageData
            
            
            
            
            
            
            
           /*
            var img=participants[indexPath.row].thumbnailProfileImage
           // var img=UIImage(data:foundcontact.imageData!)
            var w=img!.size.width
            var h=img!.size.height
            var wOld=cell.bounds.width-10
            var hOld=cell.bounds.height-10
            var scale:CGFloat=w/wOld
            
            ////self.ResizeImage(img!, targetSize: CGSizeMake(cell.profilePic.bounds.width,cell.profilePic.bounds.height))
            ///var avatarimage1=UIImageView.init(image: UIImage(data: (foundcontact.imageData)!,scale:scale))
            cell.participantsProfilePic.layer.borderWidth = 1.0
           cell.participantsProfilePic.layer.masksToBounds = false
            cell.participantsProfilePic.layer.borderColor = UIColor.whiteColor().CGColor
           cell.participantsProfilePic.layer.cornerRadius = cell.participantsProfilePic.frame.size.width/2
            cell.participantsProfilePic.clipsToBounds = true
            
            */
            
            cell.participantsProfilePic.layer.masksToBounds = true
            cell.participantsProfilePic.layer.cornerRadius = cell.participantsProfilePic.frame.size.width/2
           
            
            
            // cell.participantsProfilePic.image=UIImage(data: foundcontact.imageData!, scale: scale)
           // cell.participantsProfilePic.image=UIImage(data: participants[indexPath.row].thumbnailProfileImage, scale: scale)
            //cell.participantsProfilePic=UIImageView(image: UIImage()
            
            cell.participantsProfilePic.image=participants[indexPath.row].thumbnailProfileImage
            
      

        }
        }
        catch{
           let errormsg = UIAlertView(title: "Error".localized, message: "Failed to fetch avatar image".localized, delegate: self, cancelButtonTitle: "Ok".localized)
            errormsg.show()
            
        }
        
        
        // Use the outlet in our custom class to get a reference to the UILabel in the cell
        //cell.myLabel.text = self.items[indexPath.item]
        //cell.backgroundColor = UIColor.yellowColor() // make cell more visible in our example project
        //cell.backgroundColor=UIColor.redColor()
        return cell
}



    /*func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    // make a cell for each cell index path
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        print("collectionview...")
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ParticipantsAvatarsCell", forIndexPath: indexPath) as! UICollectionViewCell
        
        // Use the outlet in our custom class to get a reference to the UILabel in the cell
        //cell.myLabel.text = self.items[indexPath.item]
        //cell.backgroundColor = UIColor.yellowColor() // make cell more visible in our example project
        cell.backgroundColor=UIColor.redColor()
        return cell
    }
    
    */
    /*func collectionView(collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        
        return 2
    }
    
    func collectionView(collectionView: UICollectionView,
                        cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell",
                                                                         forIndexPath: indexPath)
        
        cell.backgroundColor = model[collectionView.tag][indexPath.item]
        
        return cell
    }*/

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        //groupChatStartSegue
        if segue.identifier == "groupChatStartSegue" {
            
            if let destinationVC = segue.destination as? GroupChatingDetailController{
                destinationVC.mytitle=groupname
                destinationVC.groupid1=uniqueid
                //destinationVC.navigationItem.leftBarButtonItem?.enabled=false
                //destinationVC.navigationItem.rightBarButtonItem?.image=nil
                //destinationVC.navigationItem.rightBarButtonItem?.enabled=false
            }}
    }
}
