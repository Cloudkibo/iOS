//
//  ContactsInviteViewController.swift
//  Chat
//
//  Created by Cloudkibo on 27/01/2016.
//  Copyright © 2016 MyAppTemplates. All rights reserved.
//

import UIKit

class ContactsInviteViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    /*var selectedEmails=[String]()
    var emailList=[String]()
    var notAvailableEmails=[String]()*/
    @IBOutlet weak var contactsInviteNames: UILabel!
    @IBOutlet weak var tbl_inviteContacts: UITableView!
    
    var eeee=[String]()
    
    
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
        
       // if(firstTimeLogin==true){
        contactsList.fetch(){ (result) -> () in
            
            for r in result
            {
                emailList.append(r)
            }
            
            //emailList = result
            contactsList.searchContactsByEmail(emailList){ (result2) -> () in
                
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
        //}
        
               self.tbl_inviteContacts.reloadData()
        ////contactsList.fetch()
        
        // Do any additional setup after loading the view.
    }

    @IBAction func btn_BackPressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
            
            //contactsList.contacts.removeAll()
            //contactsList.notAvailableContacts.removeAll()
            selectedEmails.removeAll()

        })
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //refreshControl.addTarget(self, action: Selector("fetchContacts"), forControlEvents: UIControlEvents.ValueChanged)
        
        return notAvailableEmails.count
        //return emailList.count
    }
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        
        
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
        
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell=tbl_inviteContacts.dequeueReusableCellWithIdentifier("ContactsInviteCell")! as UITableViewCell
        //cell.textLabel?.text = emailList[indexPath.row]
        cell.textLabel?.text = notAvailableEmails[indexPath.row]
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
        
        ///let cell=tbl_inviteContacts.dequeueReusableCellWithIdentifier("ContactsInviteCell")! as UITableViewCell
        let selectedCell=tbl_inviteContacts.cellForRowAtIndexPath(indexPath)
        //cell.textLabel?.text = "hiii"
        
        
        if selectedCell!.accessoryType == UITableViewCellAccessoryType.None
        {
            selectedCell!.accessoryType = UITableViewCellAccessoryType.Checkmark
            //selectedEmails.append(emailList[indexPath.row])
            selectedEmails.append(notAvailableEmails[indexPath.row])
            
        }
        else
        {
            
            selectedCell!.accessoryType = UITableViewCellAccessoryType.None
            var ind=selectedEmails.indexOf((selectedCell?.textLabel?.text!)!)
            selectedEmails.removeAtIndex(ind!)
        }
        print(selectedEmails.description)
        
        
    }
    
    
    
    @IBAction func btn_DoneInvite(sender: AnyObject) {
        contactsList.sendInvite(selectedEmails)
        
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            var alertview=UIAlertController(title: "Success", message: "Invitations are sent to selected contacts", preferredStyle: UIAlertControllerStyle.Alert)
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
