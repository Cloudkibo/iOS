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
class NewGroupSetDetails: UITableViewController,UINavigationControllerDelegate,UIImagePickerControllerDelegate{

    
    var file_name1=""
    var uniqueid=""
    var groupname=""
   /// @IBOutlet weak var txtFieldGroupName: UITextField!
    var imgdata=NSData.init()
   // var participants=[CNContact]()
    var participants=[EPContact]()
       @IBOutlet var tblNewGroupDetails: UITableView!
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 2
    }
    
    func textFieldShouldReturn (textField: UITextField!) -> Bool{
        
        var cell=tblNewGroupDetails.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as! ContactsListCell
        
        cell.groupNameFieldOutlet.resignFirstResponder()
        return true

    }
    
    @IBAction func btnCreateGroupDone(sender: AnyObject) {
        //create group
        //save data in sqlite
        
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
        uniqueid="\(uid)\(year)\(month)\(day)\(hr)\(min)\(sec)"
        

        print("saving in database")
        
        
       // let cell=tblNewGroupDetails.dequeueReusableCellWithIdentifier("NewGroupDetailsCell") as! ContactsListCell
      //  "NewGroupParticipantsCell"
        var cell=tblNewGroupDetails.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as! ContactsListCell
        
        groupname=cell.groupNameFieldOutlet.text!
        var memberphones=[String]()
        var membersnames=[String]()
        for(var i=0;i<participants.count;i++)
        {
            memberphones.append(participants[i].getPhoneNumber())
            membersnames.append(participants[i].displayName())
        }
        print("group_name is \(groupname)")
        print("memberphones are \(memberphones.debugDescription)")
        
        //==========sqliteDB.storeGroups(groupname, groupicon1: imgdata, datecreation1: NSDate(), uniqueid1: uniqueid)
        
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
    
    func createGroupAPI(groupname:String,members:[String],uniqueid:String)
    {
        //show progress wheen somewhere
       
       // var memberphones=[String]()
        var membersnames=[String]()
        for(var i=0;i<participants.count;i++)
        {
          //  memberphones.append(participants[i].getPhoneNumber())
            membersnames.append(participants[i].displayName())
        }
        
        var url=Constants.MainUrl+Constants.createGroupUrl
        Alamofire.request(.POST,"\(url)",parameters:["group_name":groupname,"members":members, "unique_id":uniqueid],headers:header,encoding:.JSON).validate().responseJSON { response in
            
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
                do{for account in try sqliteDB.db.prepare(tbl_accounts) {
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
                sqliteDB.storeGroups(groupname, groupicon1: self.imgdata, datecreation1: NSDate(), uniqueid1: uniqueid, status1: "new")
                
                sqliteDB.storeMembers(uniqueid,member_displayname1: myname, member_phone1: username!, isAdmin1: "Yes", membershipStatus1: "joined", date_joined1: NSDate.init())
              
                
                
                for(var i=0;i<members.count;i++)
                {
                    var isAdmin="No"
                    
                    print("members phone comparison \(members[i]) \(username)")
                    if(members[i] == username)
                    {
                        print("adding group admin")
                        isAdmin="Yes"
                        sqliteDB.storeMembers(uniqueid,member_displayname1: myname, member_phone1: members[i], isAdmin1: isAdmin, membershipStatus1: "joined", date_joined1: NSDate.init())
                        
                    }
                    else{
                        
                        sqliteDB.storeMembers(uniqueid,member_displayname1: membersnames[i], member_phone1: members[i], isAdmin1: isAdmin, membershipStatus1: "joined", date_joined1: NSDate.init())
                    }
                    
                }
                
                if(self.imgdata != NSData.init())
                {
                    print("profile image is selected")
                    print("call API to upload image")
                    
                    //save filename
                   
                    var filetype="png"
                    self.uploadProfileImage(uniqueid,filename: self.file_name1,fileType: filetype,completion: {(result,error) in
                    
                    })
 
                }
                self.performSegueWithIdentifier("groupChatStartSegue", sender: nil)
              /*  self.dismissViewControllerAnimated(true, completion: {
                    
                    
                })*/
            }
            else{
                 print(response.result.debugDescription)
                print("error in create group endpoint")
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
                    
                    print("error in getting data from accounts table")
                    
                }
                .
                
                    sqliteDB.storeGroups(groupname, groupicon1: self.imgdata, datecreation1: NSDate(), uniqueid1: uniqueid, status1:"temp")
               
                
                sqliteDB.storeGroupsChat("Log:", group_unique_id1: uniqueid, type1: "log", msg1: "Failed to create group. Tap to try again", from_fullname1: "log", date1: NSDate(), unique_id1: UtilityFunctions.init().generateUniqueid())
                
                sqliteDB.storeMembers(uniqueid,member_displayname1: myname, member_phone1: username!, isAdmin1: "Yes", membershipStatus1: "temp", date_joined1: NSDate())
                
                
                
                for(var i=0;i<members.count;i++)
                {
                    var isAdmin="No"
                    
                    print("members phone comparison \(members[i]) \(username)")
                    if(members[i] == username)
                    {
                        print("adding group admin")
                        isAdmin="Yes"
                        sqliteDB.storeMembers(uniqueid,member_displayname1: myname, member_phone1: members[i], isAdmin1: isAdmin, membershipStatus1: "temp", date_joined1: NSDate())
                        
                    }
                    else{
                        
                        sqliteDB.storeMembers(uniqueid,member_displayname1: membersnames[i], member_phone1: members[i], isAdmin1: isAdmin, membershipStatus1: "temp", date_joined1: NSDate())
                    }
                    
                }
                
                if(self.imgdata != NSData.init())
                {
                    print("profile image is selected")
                    print("call API to upload image")
                    
                    //save filename
                    
                    var filetype="png"
                    self.uploadProfileImage(uniqueid,filename: self.file_name1,fileType: filetype,completion: {(result,error) in
                        
                    })
                    
                }

                
                
                self.dismissViewControllerAnimated(true, completion: { 
                    
                    UIDelegates.getInstance().UpdateMainPageChatsDelegateCall()
                })
                //self.performSegueWithIdentifier("backToMainChatSegue", sender: nil)
            
            }
        }
        
    }
    
    func uploadProfileImage(groupUniqueID:String,filename:String,fileType:String,completion:(result:Bool,error:String!)->())
    {
        var url=Constants.MainUrl+Constants.uploadProfileImage
        var parameters = [
            "unique_id": groupUniqueID]
           /* "from": from1,
            "uniqueid": uniqueid1,
            "filename": file_name1,
            "filesize": file_size1,
            "filetype": file_type1]
 */

       //// Alamofire.request(.POST,"\(url)",parameters:["unique_id":uniqueid],headers:header,encoding:.JSON).validate().responseJSON { response in
            
            
            var urlupload=Constants.MainUrl+Constants.uploadFile
            Alamofire.upload(
                .POST,
                urlupload,
                headers: header,
                multipartFormData: { multipartFormData in
                    multipartFormData.appendBodyPart(data: self.imgdata, name: "file"
                        ,fileName: filename, mimeType: managerFile.MimeType(fileType))
                    //,fileName: file_name1, mimeType: "image/\(file_type1)")
                    for (key, value) in parameters {
                        multipartFormData.appendBodyPart(data: value.dataUsingEncoding(NSUTF8StringEncoding)!, name: key)
                    }
                    ///multipartFormData.appendBodyPart(data: jsonParameterData!, name: "goesIntoForm")
                    
                },
                encodingCompletion: { encodingResult in
                    switch encodingResult {
                    case .Success(let upload, _, _):
                        upload.progress { bytesWritten, totalBytesWritten, totalBytesExpectedToWrite in
                            dispatch_async(dispatch_get_main_queue()) {
                                let percent = (Float(totalBytesWritten) / Float(totalBytesExpectedToWrite))
                                /////progress(percent: percent)
                              
                                //uncomment later
                                /*  if(self.delegateProgressUpload != nil)
                                {
                                    if(percent<1.0)
                                    {
                                        self.delegateProgressUpload.updateProgressUpload(percent,uniqueid: uniqueid1)
                                    }
                                    
                                }*/
                                //Redraw specific table cell
                                print("percentage is \(percent)")
                            }
                        }
                        upload.validate()
                        upload.responseJSON { response in
                            print(response.response?.statusCode)
                            print(response.data!)
                            
                            switch response.result {
                            case .Success:print("file uploaded successss")
                              
                                
                            case .Failure(let error):
                                print("file upload failure")
                            }
                            
                            
                            
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
            print("Add profile pic called")
            if(response.result.isSuccess)
            {
                print("success uploading image profile")
            }
                      

        }
        case .Failure(let error):
                        print("file upload failure")
                    }})
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
    
    func ResizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / image.size.width
        let heightRatio = targetSize.height / image.size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSizeMake(size.width * heightRatio, size.height * heightRatio)
        } else {
            newSize = CGSizeMake(size.width * widthRatio,  size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRectMake(0, 0, newSize.width, newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.drawInRect(rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if(indexPath.row==0)
        {
        let cell=tblNewGroupDetails.dequeueReusableCellWithIdentifier("NewGroupDetailsCell") as! ContactsListCell
        "NewGroupParticipantsCell"
            
            
            cell.btn_edit_profilePic.hidden=true
            groupname=cell.groupNameFieldOutlet.text!
            if(imgdata != NSData.init())
            {
                cell.btn_edit_profilePic.hidden=false
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
                
                
                cell.profilePicCameraOutlet.layer.borderWidth = 1.0
                cell.profilePicCameraOutlet.layer.masksToBounds = false
                cell.profilePicCameraOutlet.layer.borderColor = UIColor.whiteColor().CGColor
                cell.profilePicCameraOutlet.layer.cornerRadius = cell.profilePicCameraOutlet.frame.size.width/2
                cell.profilePicCameraOutlet.clipsToBounds = true
                
                
                var w=tempimg!.size.width
                var h=tempimg!.size.height
                var wOld=(cell.profilePicCameraOutlet.frame.width)
                var hOld=(cell.profilePicCameraOutlet.frame.height)
                var scale:CGFloat=w/wOld
                
                 cell.profilePicCameraOutlet.image=UIImage(data: imgdata,scale: scale)
              //  cell.profilePicCameraOutlet.image=UIImage(data: imgdata)
                 //Add the recognizer to your view.
                // chatImage.addGestureRecognizer(tapRecognizer)
                
               /* let tapRecognizerOld = UITapGestureRecognizer(target: self, action: Selector("imageTapped:"))
                
                cell.profilePicCameraOutlet.removeGestureRecognizer(tapRecognizerOld)
                */
                let tapRecognizer = UITapGestureRecognizer(target: self, action: Selector("imageEditTapped:"))
                
                cell.profilePicCameraOutlet.addGestureRecognizer(tapRecognizer)
               
                let tapRecognizer2 = UITapGestureRecognizer(target: self, action: Selector("imageEditTapped:"))
                cell.btn_edit_profilePic.addGestureRecognizer(tapRecognizer2)
            }
            else
            {
                var tempimg=UIImage(named:"chat_camera")
                imgdata=UIImagePNGRepresentation(tempimg!)!
                cell.profilePicCameraOutlet.layer.borderWidth = 1.0
                cell.profilePicCameraOutlet.layer.masksToBounds = false
                cell.profilePicCameraOutlet.layer.borderColor = UIColor.whiteColor().CGColor
                cell.profilePicCameraOutlet.layer.cornerRadius = cell.profilePicCameraOutlet.frame.size.width/2
                cell.profilePicCameraOutlet.clipsToBounds = true
                
                
                var w=tempimg!.size.width
                var h=tempimg!.size.height
                var wOld=(cell.profilePicCameraOutlet.frame.width)
                var hOld=(cell.profilePicCameraOutlet.frame.height)
                var scale:CGFloat=wOld/w
                
                cell.profilePicCameraOutlet.image=UIImage(data: imgdata,scale: scale)
                
            let tapRecognizer = UITapGestureRecognizer(target: self, action: Selector("imageTapped:"))
            //Add the recognizer to your view.
           // chatImage.addGestureRecognizer(tapRecognizer)
            
            cell.profilePicCameraOutlet.addGestureRecognizer(tapRecognizer)
            }
            
        return cell
        }
        else{
            let cell=tblNewGroupDetails.dequeueReusableCellWithIdentifier("NewGroupParticipantsCell") as! ContactsListCell
            cell.lbl_participantsNumberFromOne.text="PARTICIPANTS \(participants.count) of 256"
            cell.participantsCollection.delegate=self
            cell.participantsCollection.dataSource=self
            
            return cell
        }
        
    }
    
    func imageEditTapped(gestureRecognizer: UITapGestureRecognizer) {
        //tappedImageView will be the image view that was tapped.
        //dismiss it, animate it off screen, whatever.
        let shareMenu = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        
        let resetImage = UIAlertAction(title: "Reset Image", style: UIAlertActionStyle.Default,handler: { (action) -> Void in
            
            self.imgdata=NSData.init()
            gestureRecognizer.view?.removeGestureRecognizer(gestureRecognizer)
            self.tblNewGroupDetails.reloadData()
            
            //// self.removeChatHistory(self.ContactUsernames[indexPath.row],indexPath: indexPath)
            
            //call Mute delegate or method
        })
        
        let SelectImage = UIAlertAction(title: "Select Image", style: UIAlertActionStyle.Default,handler: { (action) -> Void in
            
            self.selectImage(gestureRecognizer)
            
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
            self.tblNewGroupDetails.reloadData()
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
        
        
         imgdata              = UIImagePNGRepresentation(image)!
        
       
        
        
        self.dismissViewControllerAnimated(true, completion:{ ()-> Void in
            print("dismissing image picker")
            print("selected image is \(image)")
            self.tblNewGroupDetails.reloadData()
        })
        /* if let imageURL = editingInfo![UIImagePickerControllerReferenceURL] as? NSURL {
            let result = PHAsset.fetchAssetsWithALAssetURLs([imageURL], options: nil)
            
            
            self.filename = result.firstObject?.filename ?? ""
            
            // var myasset=result.firstObject as! PHAsset
            //print(myasset.mediaType)
            
            
            
        }*/
        

    }
    
    
    override func viewDidLoad() {
          //sqliteDB.db. groups.delete()
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        guard let tableViewCell = cell as? ContactsListCell else { return }
        
       // tableViewCell.setCollectionViewDataSourceDelegate(self, forRow: indexPath.row)
        
    }
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
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
    
  
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return participants.count
    }
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    // make a cell for each cell index path
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        print("collectionview...")
        // get a reference to our storyboard cell
        // let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ParticipantsAvatarsCell", forIndexPath: indexPath) as! UICollectionViewCell
      /*  let collectionview=tblNewGroupDetails.dequeueReusableCellWithIdentifier("NewGroupParticipantsCell") as! ContactsListCell
        */
        
       // let cell = collectionview.participantsCollection.dequeueReusableCellWithReuseIdentifier("ParticipantsAvatarsCell", forIndexPath: indexPath)
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ParticipantsAvatarsCell", forIndexPath: indexPath) as! ParticipantsCollectionCell
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
           var errormsg = UIAlertView(title: "Error", message: "Failed to fetch avatar image", delegate: self, cancelButtonTitle: "Ok")
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

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        
        //groupChatStartSegue
        if segue.identifier == "groupChatStartSegue" {
            
            if let destinationVC = segue.destinationViewController as? GroupChatingDetailController{
                destinationVC.mytitle=groupname
                destinationVC.groupid1=uniqueid
                //destinationVC.navigationItem.leftBarButtonItem?.enabled=false
                //destinationVC.navigationItem.rightBarButtonItem?.image=nil
                //destinationVC.navigationItem.rightBarButtonItem?.enabled=false
            }}
    }
}
