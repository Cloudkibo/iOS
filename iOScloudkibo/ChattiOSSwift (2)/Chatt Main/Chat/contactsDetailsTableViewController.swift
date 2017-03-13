//
//  contactsDetailsTableViewController.swift
//  kiboApp
//
//  Created by Cloudkibo on 07/06/2016.
//  Copyright © 2016 MyAppTemplates. All rights reserved.
//

import UIKit
import Contacts
import SQLite
import MessageUI
import AlamofireImage

class contactsDetailsTableViewController: UITableViewController,MFMailComposeViewControllerDelegate,MFMessageComposeViewControllerDelegate {
    
    var iamBlocked=false
    var blockedByMe=false
    var selectedContactphone=""
    var imageCache=AutoPurgingImageCache()
    var sendType=""
    var contactIndex:Int=1
    var isKiboContact=false
      var alladdressContactsArray = Array<Row>()
    let name = Expression<String?>("name")
    override func viewDidLoad() {
        super.viewDidLoad()

        let allcontactslist1=sqliteDB.allcontacts
        print("selectedContactphone \(selectedContactphone)")
        
        
        
        //alladdressContactsArray = Array(try sqliteDB.db.prepare(allcontactslist1))
      
        
        do
        {alladdressContactsArray = Array(try sqliteDB.db.prepare((allcontactslist1?.order(name.asc))!))
            
        }
        catch
        {
            print("errorr ... ")
        }
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 7
        //return 6
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        let phone = Expression<String>("phone")
        let kibocontact = Expression<Bool>("kiboContact")
        let name = Expression<String?>("name")
        let email = Expression<String?>("email")
       // var currentContact=contacts[contactIndex]
        
        //if(indexPath.row==1)
        //{
        var cell = tableView.dequeueReusableCell(withIdentifier: "Name_Cell", for: indexPath) as! AllContactsCell
        
        
       // cell.lbl_contactName.text=currentContact.givenName+currentContact.familyName
        cell.isHidden=true
        if(indexPath.row==0)
        {
         cell = tableView.dequeueReusableCell(withIdentifier: "Name_Cell", for: indexPath) as! AllContactsCell
        
       // alladdressContactsArray[contactIndex].get(name)
        //cell.lbl_contactName.text=currentContact.givenName+" "+currentContact.familyName
            cell.lbl_contactName.text=alladdressContactsArray[contactIndex].get(name)
            
            cell.isHidden=false
            
            let tbl_allcontacts=sqliteDB.allcontacts
            
            
            let phone = Expression<String>("phone")
            let contactProfileImage = Expression<Data>("profileimage")
            
            //----------------
            let uniqueidentifier = Expression<String>("uniqueidentifier")
            
            
            //--------------
            
            let queryPic = tbl_allcontacts?.filter((tbl_allcontacts?[phone])! == alladdressContactsArray[contactIndex].get(phone))          // SELECT "email" FROM "users"
            
            
            do{
                for picquery in try sqliteDB.db.prepare(queryPic!) {
                    
                    let contactStore = CNContactStore()
                    
                    let keys = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactEmailAddressesKey, CNContactPhoneNumbersKey, CNContactImageDataAvailableKey,CNContactThumbnailImageDataKey, CNContactImageDataKey]
                    let foundcontact=try contactStore.unifiedContact(withIdentifier: picquery[uniqueidentifier], keysToFetch: keys as [CNKeyDescriptor])
                    if(foundcontact.imageDataAvailable==true)
                    {
                        //foundcontact.imageData
                        
                        let imageavatar1=UIImage.init(data:(foundcontact.imageData)!)
                        
                        imageCache.add(imageavatar1!, withIdentifier: alladdressContactsArray[contactIndex].get(phone))
                        
                        // Fetch
                        var cachedAvatar = imageCache.image(withIdentifier: alladdressContactsArray[contactIndex].get(phone))
                        cachedAvatar=UtilityFunctions.init().resizedAvatar(img: cachedAvatar, size: CGSize(width: cell.profileAvatar.bounds.width,height: cell.profileAvatar.bounds.height), sizeStyle: "Fill")
                
                        
                        let circularImage = cachedAvatar?.af_imageRoundedIntoCircle()
                        cell.profileAvatar.image=circularImage
                        //   imageavatar1=ResizeImage(imageavatar1!,targetSize: s)
                        
                        //var img=UIImage(data:ContactsProfilePic[indexPath.row])
                       /* let w=imageavatar1!.size.width
                        var h=imageavatar1!.size.height
                        let wOld=cell.profileAvatar.frame.width
                        var hOld=cell.profileAvatar.frame.height
                        let scale:CGFloat=w/wOld
                        
                        
                        ///var s=CGSizeMake((self.navigationController?.navigationBar.frame.height)!-5,(self.navigationController?.navigationBar.frame.height)!-5)
                        
                        cell.profileAvatar.image=UIImage(data: (foundcontact.imageData)!,scale:scale)
                        
                        cell.profileAvatar.layer.borderWidth = 1.0
                        cell.profileAvatar.layer.masksToBounds = false
                        cell.profileAvatar.layer.borderColor = UIColor.white.cgColor
                        cell.profileAvatar.layer.cornerRadius = cell.profileAvatar.frame.size.width/2
                        cell.profileAvatar.clipsToBounds = true
                        */
                      
                        //ContactsProfilePic.append(foundcontact.imageData!)
                        //picfound=true
                    }
                    
                    
                }
            }
            catch
            {
                print("error in fetching profile image")
            }
            
            
            
            //----------
           /* do{
                let queryPic = tbl_allcontacts.filter(tbl_allcontacts[phone] == alladdressContactsArray[contactIndex].get(phone))          // SELECT "email" FROM "users"
                
                var profilepic = Array(try sqliteDB.db.prepare(queryPic))
                if(profilepic.first != nil)
                {
                    // match found of phone number , iskiboContact
                    //now check if has avatarbutton
                    
                    if((profilepic.first?.get(contactProfileImage) != NSData.init()) && (profilepic.first?.get(contactProfileImage) != nil))
                    {
                        //has avatar
                        //var imageavatar1=UIImage.init(named: "profile-pic1")
                        var imageavatar1=UIImage.init(data:(profilepic.first?.get(contactProfileImage))!)
                        //   imageavatar1=ResizeImage(imageavatar1!,targetSize: s)
                        
                        //var img=UIImage(data:ContactsProfilePic[indexPath.row])
                        var w=imageavatar1!.size.width
                        var h=imageavatar1!.size.height
                        var wOld=cell.profileAvatar.frame.height
                        var hOld=cell.profileAvatar.frame.width
                        var scale:CGFloat=w/wOld
                        
                        
                        ///var s=CGSizeMake((self.navigationController?.navigationBar.frame.height)!-5,(self.navigationController?.navigationBar.frame.height)!-5)
                        cell.profileAvatar.image=UIImage(data: (profilepic.first?.get(contactProfileImage))!,scale:scale)
                        //var barAvatarImage=UIImageView.init(image: UIImage(data: (profilepic.first?.get(contactProfileImage))!,scale:scale))
                        
                        cell.profileAvatar.layer.borderWidth = 1.0
                        cell.profileAvatar.layer.masksToBounds = false
                        cell.profileAvatar.layer.borderColor = UIColor.whiteColor().CGColor
                        cell.profileAvatar.layer.cornerRadius = cell.profileAvatar.frame.size.width/2
                        cell.profileAvatar.clipsToBounds = true
                        
                        
                       
                        
                        
                    }
                    
                }
                
            }
            catch
            {
                print("error in fetching profile image")
            }
*/
        }
        //}
        if(indexPath.row==1)
        {
             cell = tableView.dequeueReusableCell(withIdentifier: "Phone_Cell", for: indexPath) as! AllContactsCell
            // Set the contact's home email address.
            cell.isHidden=true
            
            
            if(alladdressContactsArray[contactIndex].get(phone) != "")
            {
                cell.lbl_phone.text=alladdressContactsArray[contactIndex].get(phone)
                cell.isHidden=false
                
            }
            /*if (contacts[contactIndex].isKeyAvailable(CNContactPhoneNumbersKey)) {
                for phoneNumber:CNLabeledValue in contacts[contactIndex].phoneNumbers {
                     let a = phoneNumber.value as! CNPhoneNumber
                    //{
                    cell.lbl_phone.text=a.stringValue
                    cell.hidden=false
                    
                   // }
                    
                }
            }*/
            
        }
        ////%%%%%%% needs work here
        if(indexPath.row==2)
        {
             cell = tableView.dequeueReusableCell(withIdentifier: "Email_Cell", for: indexPath) as! AllContactsCell
        // Set the contact's home email address.
        
            cell.isHidden=true
            
            
            if(alladdressContactsArray[contactIndex].get(email) != "")
            {
                cell.lbl_email.text=alladdressContactsArray[contactIndex].get(email)
               // cell.lbl_email.text=emailAddress.value as! String
                //homeEmailAddress = emailAddress.value as! String
                cell.isHidden=false
                
            }
            
        /*    var homeEmailAddress: String!
        for emailAddress in currentContact.emailAddresses {
            if emailAddress.label == CNLabelHome {
                cell.lbl_email.text=emailAddress.value as! String
                homeEmailAddress = emailAddress.value as! String
                cell.hidden=false
                
                break
            }
        }*/
        }
        if(indexPath.row==3 && isKiboContact==true)
        {
            cell = tableView.dequeueReusableCell(withIdentifier: "Status_Cell", for: indexPath) as! AllContactsCell
            cell.isHidden=false
            cell.lbl_status.text="Hey there! I am using KiboApp"
            
        }
        if(indexPath.row==4 && isKiboContact==false)
        {
            cell = tableView.dequeueReusableCell(withIdentifier: "invite_kibo_cell", for: indexPath) as! AllContactsCell
            
            cell.isHidden=false
        }
        if(indexPath.row==5)
        {
            //block
            //BlockThisContactCell
            cell = tableView.dequeueReusableCell(withIdentifier: "BlockThisContactCell", for: indexPath) as! AllContactsCell
            if(blockedByMe==true)
            {
               cell.btn_lbl_blockContact.text="Unblock this contact"
            }
            else{
                cell.btn_lbl_blockContact.text="Block this contact"
            }
            
        }
        
        //cell.lbl_phone
        // Configure the cell...

        return cell
    }

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        //var messageDic = messages.object(at: indexPath.row) as! [String : String];
        // NSLog(messageDic["message"]!, 1)
        //var status = messageDic["status"] as String!
        
        
        //let cell=tbl_inviteContacts.dequeueReusableCellWithIdentifier("ContactsInviteCell")! as! ContactsInviteCell
        //let selectedCell=tableView.cellForRow(at: indexPath)! as AllContactsCell
        if(indexPath.row==5)
        {
              let phone = Expression<String>("phone")
            if(alladdressContactsArray[contactIndex].get(phone) != "")
            {
              
                var phoneselectd=alladdressContactsArray[contactIndex].get(phone)
               // cell.isHidden=false
                if(blockedByMe==false)
                    {
                 // sqliteDB.BlockContactUpdateStatus(phone1: phoneselectd, status1: true)
                        UtilityFunctions.init().blockContact(phone1: phoneselectd)
                }
                else
                    {
                        UtilityFunctions.init().unblockContact(phone1: phoneselectd)
                  //  sqliteDB.BlockContactUpdateStatus(phone1: phoneselectd, status1: false)
                }
                
            }
        
        }
        
        
    }
    
    @IBAction func inviteTokiboButtonPressed(_ sender: AnyObject) {
        
            let shareMenu = UIAlertController(title: nil, message: "Invite using", preferredStyle: .actionSheet)
        
        let phone = Expression<String>("phone")
         let email = Expression<String>("email")
            let twitterAction = UIAlertAction(title: "email \(self.alladdressContactsArray[self.contactIndex].get(email))", style: UIAlertActionStyle.default,handler: { (action) -> Void in
                
                let mailComposeViewController = self.configuredMailComposeViewController()
                if MFMailComposeViewController.canSendMail() {
                    self.present(mailComposeViewController, animated: true, completion: nil)
                } else {
                    self.showSendMailErrorAlert()
                }
                //////self.sendType="Mail"
                /////self.performSegueWithIdentifier("inviteSegueContacts",sender: nil)
                /*let mailComposeViewController = self.configuredMailComposeViewController()
                 if MFMailComposeViewController.canSendMail() {
                 self.presentViewController(mailComposeViewController, animated: true, completion: nil)
                 } else {
                 self.showSendMailErrorAlert()
                 }*/
            })
            let msgAction = UIAlertAction(title: "mobile \(self.alladdressContactsArray[self.contactIndex].get(phone))", style: UIAlertActionStyle.default, handler: { (action) -> Void in
                
                
                let messageVC = MFMessageComposeViewController()
                
                messageVC.body = "Hey, \n \n I just downloaded Kibo App on my iPhone. \n \n It is a smartphone messenger with added features. It provides integrated and unified voice, video, and data communication. \n \n It is available for both Android and iPhone and there is no PIN or username to remember. \n \n Get it now from https://itunes.apple.com/us/app/kibo-chat/id1099977984?ls=1&mt=8 and say good-bye to SMS!";
                
                
                
               
                messageVC.recipients = [self.alladdressContactsArray[self.contactIndex].get(phone)]
                
                messageVC.messageComposeDelegate = self;
                
                self.present(messageVC, animated: false, completion: nil)

                //////self.sendType="Message"
                ///////self.performSegueWithIdentifier("inviteSegueContacts",sender: nil)
                /*var messageVC = MFMessageComposeViewController()
                 
                 messageVC.body = "Enter a message";
                 messageVC.recipients = ["03201211991"]
                 messageVC.messageComposeDelegate = self;
                 
                 self.presentViewController(messageVC, animated: false, completion: nil)
                 */
            })
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler:nil)
        shareMenu.addAction(msgAction)
        shareMenu.addAction(twitterAction)
            shareMenu.addAction(cancelAction)
            
            
            self.present(shareMenu, animated: true, completion: {
                
            })
            
        
    }
    
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController!, didFinishWith result: MessageComposeResult) {
        switch (result) {
        case .cancelled:
            print("Message was cancelled")
            self.dismiss(animated: true, completion: nil)
        case .failed:
            print("Message failed")
            self.dismiss(animated: true, completion: nil)
        case .sent:
            print("Message was sent")
            self.dismiss(animated: true, completion: nil)
        default:
            break;
        }
    }
    
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        
        //mailComposerVC.setToRecipients(["someone@somewhere.com"])
       // mailComposerVC.setToRecipients(selectedEmails)
        let email = Expression<String>("email")
       mailComposerVC.setToRecipients([alladdressContactsArray[contactIndex].get(email)])
        
        mailComposerVC.setSubject("Invitation for joining Kibo App")
        mailComposerVC.setMessageBody("Hey, \n \n I just downloaded Kibo App on my iPhone. \n \n It is a smartphone messenger with added features. It provides integrated and unified voice, video, and data communication. \n \n It is available for both Android and iPhone and there is no PIN or username to remember. \n \n Get it now from https://itunes.apple.com/us/app/kibo-chat/id1099977984?ls=1&mt=8 and say good-bye to SMS!", isHTML: false)
        
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertView(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", delegate: self, cancelButtonTitle: "OK")
        sendMailErrorAlert.show()
    }
    
    // MARK: MFMailComposeViewControllerDelegate Method
    func mailComposeController(_ controller: MFMailComposeViewController!, didFinishWith result: MFMailComposeResult, error: Error!) {
        controller.dismiss(animated: true, completion: nil)
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue?, sender: Any?) {
        
        if segue!.identifier == "inviteSegueContacts" {
            let destinationNavigationController = segue!.destination as! UINavigationController
            let destinationVC = destinationNavigationController.topViewController as? ContactsInviteViewController
            
            destinationVC?.sendType=self.sendType
            
            
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
 

}
