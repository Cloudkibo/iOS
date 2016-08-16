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

class contactsDetailsTableViewController: UITableViewController,MFMailComposeViewControllerDelegate,MFMessageComposeViewControllerDelegate {
    
    var sendType=""
    var contactIndex:Int=1
    var isKiboContact=false
      var alladdressContactsArray = Array<Row>()
    override func viewDidLoad() {
        super.viewDidLoad()

        var allcontactslist1=sqliteDB.allcontacts
        
        
        
        
        //alladdressContactsArray = Array(try sqliteDB.db.prepare(allcontactslist1))
      
        
        do
        {alladdressContactsArray = Array(try sqliteDB.db.prepare(allcontactslist1))
            
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

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 6
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        
        let phone = Expression<String>("phone")
        let kibocontact = Expression<Bool>("kiboContact")
        let name = Expression<String?>("name")
        let email = Expression<String?>("email")
       // var currentContact=contacts[contactIndex]
        
        //if(indexPath.row==1)
        //{
        var cell = tableView.dequeueReusableCellWithIdentifier("Name_Cell", forIndexPath: indexPath) as! AllContactsCell
        
        
       // cell.lbl_contactName.text=currentContact.givenName+currentContact.familyName
        cell.hidden=true
        if(indexPath.row==0)
        {
         cell = tableView.dequeueReusableCellWithIdentifier("Name_Cell", forIndexPath: indexPath) as! AllContactsCell
        
       // alladdressContactsArray[contactIndex].get(name)
        //cell.lbl_contactName.text=currentContact.givenName+" "+currentContact.familyName
            cell.lbl_contactName.text=alladdressContactsArray[contactIndex].get(name)
            
            cell.hidden=false
            
            let tbl_allcontacts=sqliteDB.allcontacts
            
            
            let phone = Expression<String>("phone")
            let contactProfileImage = Expression<NSData>("profileimage")
            
            //----------------
            let uniqueidentifier = Expression<String>("uniqueidentifier")
            
            
            //--------------
            
            let queryPic = tbl_allcontacts.filter(tbl_allcontacts[phone] == alladdressContactsArray[contactIndex].get(phone))          // SELECT "email" FROM "users"
            
            
            do{
                for picquery in try sqliteDB.db.prepare(queryPic) {
                    
                    let contactStore = CNContactStore()
                    
                    var keys = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactEmailAddressesKey, CNContactPhoneNumbersKey, CNContactImageDataAvailableKey,CNContactThumbnailImageDataKey, CNContactImageDataKey]
                    var foundcontact=try contactStore.unifiedContactWithIdentifier(picquery[uniqueidentifier], keysToFetch: keys)
                    if(foundcontact.imageDataAvailable==true)
                    {
                        foundcontact.imageData
                        var imageavatar1=UIImage.init(data:(foundcontact.imageData)!)
                        //   imageavatar1=ResizeImage(imageavatar1!,targetSize: s)
                        
                        //var img=UIImage(data:ContactsProfilePic[indexPath.row])
                        var w=imageavatar1!.size.width
                        var h=imageavatar1!.size.height
                        var wOld=cell.profileAvatar.frame.width
                        var hOld=cell.profileAvatar.frame.height
                        var scale:CGFloat=w/wOld
                        
                        
                        ///var s=CGSizeMake((self.navigationController?.navigationBar.frame.height)!-5,(self.navigationController?.navigationBar.frame.height)!-5)
                        
                        cell.profileAvatar.image=UIImage(data: (foundcontact.imageData)!,scale:scale)
                        
                        cell.profileAvatar.layer.borderWidth = 1.0
                        cell.profileAvatar.layer.masksToBounds = false
                        cell.profileAvatar.layer.borderColor = UIColor.whiteColor().CGColor
                        cell.profileAvatar.layer.cornerRadius = cell.profileAvatar.frame.size.width/2
                        cell.profileAvatar.clipsToBounds = true
                        
                      
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
             cell = tableView.dequeueReusableCellWithIdentifier("Phone_Cell", forIndexPath: indexPath) as! AllContactsCell
            // Set the contact's home email address.
            cell.hidden=true
            
            
            if(alladdressContactsArray[contactIndex].get(phone) != "")
            {
                cell.lbl_phone.text=alladdressContactsArray[contactIndex].get(phone)
                cell.hidden=false
                
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
             cell = tableView.dequeueReusableCellWithIdentifier("Email_Cell", forIndexPath: indexPath) as! AllContactsCell
        // Set the contact's home email address.
        
            cell.hidden=true
            
            
            if(alladdressContactsArray[contactIndex].get(email) != "")
            {
                cell.lbl_email.text=alladdressContactsArray[contactIndex].get(email)
               // cell.lbl_email.text=emailAddress.value as! String
                //homeEmailAddress = emailAddress.value as! String
                cell.hidden=false
                
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
            cell = tableView.dequeueReusableCellWithIdentifier("Status_Cell", forIndexPath: indexPath) as! AllContactsCell
            cell.hidden=false
            cell.lbl_status.text="Hey there! I am using KiboApp"
            
        }
        if(indexPath.row==4 && isKiboContact==false)
        {
            cell = tableView.dequeueReusableCellWithIdentifier("invite_kibo_cell", forIndexPath: indexPath) as! AllContactsCell
            
            cell.hidden=false
        }
        
        //cell.lbl_phone
        // Configure the cell...

        return cell
    }


    @IBAction func inviteTokiboButtonPressed(sender: AnyObject) {
        
            let shareMenu = UIAlertController(title: nil, message: "Invite using", preferredStyle: .ActionSheet)
        
        let phone = Expression<String>("phone")
         let email = Expression<String>("email")
            let twitterAction = UIAlertAction(title: "email \(self.alladdressContactsArray[self.contactIndex].get(email))", style: UIAlertActionStyle.Default,handler: { (action) -> Void in
                
                let mailComposeViewController = self.configuredMailComposeViewController()
                if MFMailComposeViewController.canSendMail() {
                    self.presentViewController(mailComposeViewController, animated: true, completion: nil)
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
            let msgAction = UIAlertAction(title: "mobile \(self.alladdressContactsArray[self.contactIndex].get(phone))", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
                
                
                var messageVC = MFMessageComposeViewController()
                
                messageVC.body = "Hey, \n \n I just downloaded Kibo App on my iPhone. \n \n It is a smartphone messenger with added features. It provides integrated and unified voice, video, and data communication. \n \n It is available for both Android and iPhone and there is no PIN or username to remember. \n \n Get it now from https://itunes.apple.com/us/app/kibo-chat/id1099977984?ls=1&mt=8 and say good-bye to SMS!";
                
                
                
               
                messageVC.recipients = [self.alladdressContactsArray[self.contactIndex].get(phone)]
                
                messageVC.messageComposeDelegate = self;
                
                self.presentViewController(messageVC, animated: false, completion: nil)

                //////self.sendType="Message"
                ///////self.performSegueWithIdentifier("inviteSegueContacts",sender: nil)
                /*var messageVC = MFMessageComposeViewController()
                 
                 messageVC.body = "Enter a message";
                 messageVC.recipients = ["03201211991"]
                 messageVC.messageComposeDelegate = self;
                 
                 self.presentViewController(messageVC, animated: false, completion: nil)
                 */
            })
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler:nil)
        shareMenu.addAction(msgAction)
        shareMenu.addAction(twitterAction)
            shareMenu.addAction(cancelAction)
            
            
            self.presentViewController(shareMenu, animated: true, completion: {
                
            })
            
        
    }
    
    
    func messageComposeViewController(controller: MFMessageComposeViewController!, didFinishWithResult result: MessageComposeResult) {
        switch (result) {
        case MessageComposeResultCancelled:
            print("Message was cancelled")
            self.dismissViewControllerAnimated(true, completion: nil)
        case MessageComposeResultFailed:
            print("Message failed")
            self.dismissViewControllerAnimated(true, completion: nil)
        case MessageComposeResultSent:
            print("Message was sent")
            self.dismissViewControllerAnimated(true, completion: nil)
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
    func mailComposeController(controller: MFMailComposeViewController!, didFinishWithResult result: MFMailComposeResult, error: NSError!) {
        controller.dismissViewControllerAnimated(true, completion: nil)
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
    override func prepareForSegue(segue: UIStoryboardSegue?, sender: AnyObject?) {
        
        if segue!.identifier == "inviteSegueContacts" {
            let destinationNavigationController = segue!.destinationViewController as! UINavigationController
            let destinationVC = destinationNavigationController.topViewController as? ContactsInviteViewController
            
            destinationVC?.sendType=self.sendType
            
            
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
 

}
