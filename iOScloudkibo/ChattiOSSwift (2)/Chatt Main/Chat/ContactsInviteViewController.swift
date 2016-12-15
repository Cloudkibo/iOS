//
//  ContactsInviteViewController.swift
//  Chat
//
//  Created by Cloudkibo on 27/01/2016.
//  Copyright © 2016 MyAppTemplates. All rights reserved.
//

import UIKit
import SQLite
import MessageUI

class ContactsInviteViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,MFMailComposeViewControllerDelegate,MFMessageComposeViewControllerDelegate {
    
    var sendType:String=""
    var selectedEmails=[String]()
    
    /*var selectedEmails=[String]()
    var emailList=[String]()
    var notAvailableEmails=[String]()*/
   // @IBOutlet weak var contactsInviteNames: UILabel!
    @IBOutlet weak var tbl_inviteContacts: UITableView!
    
    var inviteContactsNames=[String]()
    var inviteContactsEmails=[String]()
    var inviteContactsPhones=[String]()
    
    override func viewWillAppear(animated: Bool) {
       /* contactsList.fetch(){ (result) -> () in
            emailList = result
            contactsList.searchContactsByEmail(emailList){ (result) -> () in
                notAvailableEmails=result
                dispatch_async(dispatch_get_main_queue()) { () -> Void in
                    
                    self.tbl_inviteContacts.reloadData()
                }
            }
        }
        */
        

                /*dispatch_async(dispatch_get_main_queue()) { () -> Void in
                    
                                           self.tbl_inviteContacts.reloadData()
            }*/
        
    }
    override func viewDidLoad() {
        tbl_inviteContacts.delegate=self
        tbl_inviteContacts.dataSource=self
        
        super.viewDidLoad()
        print("fetch contacts from address book")
        
       // if(firstTimeLogin==true){
       
        let tbl_contactslists=sqliteDB.contactslists
        
        
        
        inviteContactsNames.removeAll(keepCapacity: false)
        inviteContactsEmails.removeAll(keepCapacity: false)
        selectedEmails.removeAll(keepCapacity: false)
        inviteContactsPhones.removeAll(keepCapacity: false)
        var allcontactslist1=sqliteDB.allcontacts
        var alladdressContactsArray:Array<Row>
        
        let email = Expression<String>("email")
        let kibocontact = Expression<Bool>("kiboContact")
        let name = Expression<String?>("name")
        let phone = Expression<String?>("phone")
        //  alladdressContactsArray = Array(try sqliteDB.db.prepare(allcontactslist1))
        //alladdressContactsArray[indexPath.row].get(name)
        
        
        do{
            if(sendType=="Mail")
            {
                
                
            let query = allcontactslist1.select(kibocontact,name,email,phone)           // SELECT "email" FROM "users"
                .filter(kibocontact == false)//.filter(email != "")     // WHERE "kiboContact" IS false
            for ccc in try sqliteDB.db.prepare(query.filter(email != "")) {
                
                print("invite contact is \(ccc[name]) .. \(ccc[email])")
                inviteContactsNames.append(ccc[name]!)
                inviteContactsEmails.append(ccc[email])
                inviteContactsPhones.append(ccc[phone]!)
            //try sqliteDB.db.run(query.update(kibocontact <- true))
            }
            }
            else
            {
                let query = allcontactslist1.select(kibocontact,name,email,phone)           // SELECT "email" FROM "users"
                    .filter(kibocontact == false)//.filter(email != "")     // WHERE "kiboContact" IS false
                for ccc in try sqliteDB.db.prepare(query.filter(phone != "")) {
                    
                    print("invite contact is \(ccc[name]) .. \(ccc[email])")
                    inviteContactsNames.append(ccc[name]!)
                    inviteContactsPhones.append(ccc[phone]!)
                }
            }
        }
            catch
            {
                print("error in invite list")
            }
        
        //OLD LOGIC COMMENTED
        /*contactsList.fetch(){ (result) -> () in
            
            for r in result
            {
                emailList.append(r)
            }
            
            //emailList = result
            contactsList.searchContactsByPhone(emailList){ (result2) -> () in
                
                for r2 in result2
                {
                        notAvailableEmails.append(r2)
                }
                //notAvailableEmails=result2
                //dispatch_async(dispatch_get_main_queue()) { () -> Void in
                    
                    self.tbl_inviteContacts.reloadData()
                //}
            }
        }
        
        
        */
        //}
        
               self.tbl_inviteContacts.reloadData()
        ////contactsList.fetch()
        
        // Do any additional setup after loading the view.
    }

    @IBAction func btn_BackPressed(sender: AnyObject) {
        
        //Go to contacts list
        //var next = self.storyboard?.instantiateViewControllerWithIdentifier("MainChatView") as! ChatViewController
        
        //self.presentViewController(ChatViewController() as! UIViewController, animated: true) { () -> Void in
        ////// ************%%%%%%%%%%%%%%%%
        selectedEmails.removeAll()
        //self.performSegueWithIdentifier("invitetochatsegue", sender: self)
        
        //}
        //}
        
        
        //*************************%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% newww
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
            
            //contactsList.contacts.removeAll()
            //contactsList.notAvailableContacts.removeAll()
            self.selectedEmails.removeAll()

        })

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //refreshControl.addTarget(self, action: Selector("fetchContacts"), forControlEvents: UIControlEvents.ValueChanged)
        
        return inviteContactsNames.count
            
        /////// old return notAvailableEmails.count
        //return emailList.count
    }
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        
        
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
        
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell=tbl_inviteContacts.dequeueReusableCellWithIdentifier("ContactsInviteCell")! as! ContactsInviteCell
        
            cell.contactName.text=inviteContactsNames[indexPath.row]
        if(sendType=="Mail")
        {
            cell.contactEmail.text=inviteContactsEmails[indexPath.row]
        }
        else
        {
            cell.contactEmail.text=inviteContactsPhones[indexPath.row]
   
        }
        //WORKING OLD
        // old cell.textLabel?.text = notAvailableEmails[indexPath.row]
                /*
        if ( theSelectedCell.accessoryType == UITableViewCellAccessoryNone ) {
        
        // This cell hasn't already been selected - switch on the checkmark
        thisCell.accessoryType = UITableViewCellAccessoryCheckmark;
        
        // Grab the peerID from the cell's detailTextLabel
        NSString *peerID = thisCell.detailTextLabel.text;
        
        // Add this peerID to the array of selections at the location
        // that corresponds to the cell's position in the table
        [selectedRows setObject:peerID forKey:keyString];
        
        } else {
        
        // This cell has already been selected - so switch OFF the checkmark
        thisCell.accessoryType = UITableViewCellAccessoryNone;
        
        // And remove the peerID from the array of selections
        [selectedRows removeObjectForKey:keyString];
        
        }
        */

        ///tbl_inviteContacts.reloadData()
        return cell
        
            }
    
    
    
    
    
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        
        //let cell=tbl_inviteContacts.dequeueReusableCellWithIdentifier("ContactsInviteCell")! as! ContactsInviteCell
        let selectedCell=tbl_inviteContacts.cellForRowAtIndexPath(indexPath) as! ContactsInviteCell
        
        //let selectedCell=tbl_inviteContacts.cellForRowAtIndexPath(indexPath)
        //cell.textLabel?.text = "hiii"
        
        
        if selectedCell.accessoryType == UITableViewCellAccessoryType.None
        {
            selectedCell.accessoryType = UITableViewCellAccessoryType.Checkmark
            if(sendType=="Mail")
            {
            selectedEmails.append(inviteContactsEmails[indexPath.row])
            }
            else
            {
                
                selectedEmails.append(inviteContactsPhones[indexPath.row])
            }
            //selectedEmails.append(notAvailableEmails[indexPath.row])
            
        }
        else
        {
            
            selectedCell.accessoryType = UITableViewCellAccessoryType.None
            var ind=selectedEmails.indexOf(selectedCell.contactEmail.text!)
            //var ind=selectedEmails.indexOf((selectedCell?.textLabel?.text!)!)
            selectedEmails.removeAtIndex(ind!)
        }
        print(selectedEmails.description)
        
        
    }
    
    
    
    @IBAction func btn_DoneInvite(sender: AnyObject) {
        
        if(sendType=="Mail")
        {
            let mailComposeViewController = self.configuredMailComposeViewController()
            if MFMailComposeViewController.canSendMail() {
                self.presentViewController(mailComposeViewController, animated: true, completion: nil)
            } else {
                self.showSendMailErrorAlert()
            }
        }
        else{
            
        var messageVC = MFMessageComposeViewController()
            
            messageVC.body = "Hey, \n \n I just downloaded Kibo App on my iPhone. \n \n It is a smartphone messenger with added features. It provides integrated and unified voice, video, and data communication. \n \n It is available for both Android and iPhone and there is no PIN or username to remember. \n \n Get it now from https://api.cloudkibo.com and say good-bye to SMS!";
            messageVC.recipients = selectedEmails
            messageVC.messageComposeDelegate = self;
            
            self.presentViewController(messageVC, animated: false, completion: nil)
        }
        



        
        /*
        contactsList.sendInvite(selectedEmails){ (result) -> () in
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                var alertview=UIAlertController(title: "Info:", message: result, preferredStyle: UIAlertControllerStyle.Alert)
                //self.dismissViewControllerAnimated(true, completion: { () -> Void in
                //alertview.addAction(<#T##action: UIAlertAction##UIAlertAction#>)
                var okAction=UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: { (action:UIAlertAction) -> Void in
                    
                })
                alertview.addAction(okAction)
                self.presentViewController(alertview, animated: true, completion: { () -> Void in
                    
                })
                
                //})
            }
 
 
        }
 
 */
        // get msg as completionresult
        
        
        //WORKING OLD
       /* dispatch_async(dispatch_get_main_queue()) { () -> Void in
            var alertview=UIAlertController(title: "Success", message: "Invitations are sent to selected contacts", preferredStyle: UIAlertControllerStyle.Alert)
            //self.dismissViewControllerAnimated(true, completion: { () -> Void in
            //alertview.addAction(<#T##action: UIAlertAction##UIAlertAction#>)
            var okAction=UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: { (action:UIAlertAction) -> Void in
                
            })
            alertview.addAction(okAction)
            self.presentViewController(alertview, animated: true, completion: { () -> Void in
                
                })
                
            //})
        }*/
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
        mailComposerVC.setToRecipients(selectedEmails)
        mailComposerVC.setSubject("Invitation for joining Kibo App")
        mailComposerVC.setMessageBody("Hey, \n \n I just downloaded Kibo App on my iPhone. \n \n It is a smartphone messenger with added features. It provides integrated and unified voice, video, and data communication. \n \n It is available for both Android and iPhone and there is no PIN or username to remember. \n \n Get it now from https://api.cloudkibo.com and say good-bye to SMS!", isHTML: false)
        
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
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
