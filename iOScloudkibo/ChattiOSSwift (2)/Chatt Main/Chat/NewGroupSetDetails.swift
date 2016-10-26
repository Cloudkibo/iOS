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
        
        var members=[String]()
        for(var i=0;i<participants.count;i++)
        {
            members.append(participants[i].getPhoneNumber())
        }
        print("group_name is \(groupname)")
        print("members are \(members.debugDescription)")
        
        sqliteDB.storeGroups(groupname, groupicon1: imgdata, datecreation1: NSDate(), uniqueid1: uid as String)
        
        let firstname = Expression<String>("firstname")
        
        
        
        let tbl_accounts = sqliteDB.accounts
        do{for account in try sqliteDB.db.prepare(tbl_accounts) {
            username=account[username1]
            //displayname=account[firstname]
            
            }
        }
        catch
        {
            if(socketObj != nil){
                socketObj.socket.emit("error getting data from accounts table")
            }
            print("error in getting data from accounts table")
            
        }
        
        sqliteDB.storeMembers(uniqueid, member_phone1: username!, isAdmin1: "Yes", membershipStatus1: "joined", date_joined1: NSDate.init())
        
        for(var i=0;i<members.count;i++)
        {
            var isAdmin="Yes"
            
            
            if(members[i] == username)
            {
               // isAdmin
                
            }
            else{
            sqliteDB.storeMembers(uniqueid, member_phone1: members[i], isAdmin1: "Yes", membershipStatus1: "joined", date_joined1: NSDate.init())
            }
            
        }
        
        createGroupAPI(groupname,members: members,uniqueid: uniqueid)
        //send to server
        
        //segue to chat page
        
        
    }
    
    func createGroupAPI(groupname:String,members:[String],uniqueid:String)
    {
        //show progress wheen somewhere
        var url=Constants.MainUrl+Constants.createGroupUrl
        Alamofire.request(.POST,"\(url)",parameters:["group_name":groupname,"members":members, "unique_id":uniqueid],headers:header,encoding:.JSON).validate().responseJSON { response in
            
            /* print(response)
             print(".......")
             print(response.data!)
             print(".......")
             print(response.result.value!)*/
            
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
                self.performSegueWithIdentifier("groupChatStartSegue", sender: nil)
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
            
            groupname=cell.groupNameFieldOutlet.text!
            if(imgdata != NSData.init())
            {
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
            
            }
            let tapRecognizer = UITapGestureRecognizer(target: self, action: Selector("imageTapped:"))
            //Add the recognizer to your view.
           // chatImage.addGestureRecognizer(tapRecognizer)
            
            cell.profilePicCameraOutlet.addGestureRecognizer(tapRecognizer)
            
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
            
            self.presentViewController(picker, animated: true, completion: nil)
            
        }
        
        //selectedImage=tappedImageView.image
       // self.performSegueWithIdentifier("showFullImageSegue", sender: nil);
        
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
            
            
            
            
            
          /*  var imageavatar1=UIImage.init(data:(foundcontact.imageData)!)
            //   imageavatar1=ResizeImage(imageavatar1!,targetSize: s)
            
            //var img=UIImage(data:ContactsProfilePic[indexPath.row])
            var w=imageavatar1!.size.width
            var h=imageavatar1!.size.height
            var wOld=(cell.frame.width)-5
            var hOld=(cell.frame.height)-15
            var scale:CGFloat=w/wOld
            
            
            ///var s=CGSizeMake((self.navigationController?.navigationBar.frame.height)!-5,(self.navigationController?.navigationBar.frame.height)!-5)
            
            var avatarimage1=UIImageView.init(image: UIImage(data: (foundcontact.imageData)!,scale:scale))
            
            avatarimage1.layer.borderWidth = 1.0
            avatarimage1.layer.masksToBounds = false
            avatarimage1.layer.borderColor = UIColor.whiteColor().CGColor
            avatarimage1.layer.cornerRadius = avatarimage1.frame.size.width/2
            avatarimage1.clipsToBounds = true
            
            
            cell.participantsProfilePic.image=avatarimage1.image
*/
            /////cell.participantsProfilePic.image=avatarimage.image
            
            
            //workingg
            /*avatarimage=UIImageView.init(image: UIImage(data: (foundcontact.imageData)!,scale:scale))
            
            avatarimage.layer.borderWidth = 1.0
            avatarimage.layer.masksToBounds = false
            avatarimage.layer.borderColor = UIColor.whiteColor().CGColor
            avatarimage.layer.cornerRadius = avatarimage.frame.size.width/2
            avatarimage.clipsToBounds = true
            
            cell.participantsProfilePic.image=avatarimage.image
            
            
            */
            
            
            /*
             var imageavatar1=UIImage.init(data:(foundcontact.imageData)!)
             //   imageavatar1=ResizeImage(imageavatar1!,targetSize: s)
             
             //var img=UIImage(data:ContactsProfilePic[indexPath.row])
             var w=imageavatar1!.size.width
             var h=imageavatar1!.size.height
             var wOld=(self.navigationController?.navigationBar.frame.height)!-5
             var hOld=(self.navigationController?.navigationBar.frame.width)!-5
             var scale:CGFloat=w/wOld
             
             
             ///var s=CGSizeMake((self.navigationController?.navigationBar.frame.height)!-5,(self.navigationController?.navigationBar.frame.height)!-5)
             
             var barAvatarImage=UIImageView.init(image: UIImage(data: (foundcontact.imageData)!,scale:scale))
             
             barAvatarImage.layer.borderWidth = 1.0
             barAvatarImage.layer.masksToBounds = false
             barAvatarImage.layer.borderColor = UIColor.whiteColor().CGColor
             barAvatarImage.layer.cornerRadius = barAvatarImage.frame.size.width/2
             barAvatarImage.clipsToBounds = true
             
             
             var avatarbutton=UIBarButtonItem.init(customView: barAvatarImage)
             self.navigationItem.rightBarButtonItems?.insert(avatarbutton, atIndex: 0)
             
 */
            //////var avatarbutton=UIBarButtonItem.init(customView: barAvatarImage)
           ///////self.navigationItem.rightBarButtonItems?.insert(avatarbutton, atIndex: 0)
            
            //ContactsProfilePic.append(foundcontact.imageData!)
            //picfound=true

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
