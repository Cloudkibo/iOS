//
//  contactsDetailsTableViewController.swift
//  kiboApp
//
//  Created by Cloudkibo on 07/06/2016.
//  Copyright © 2016 MyAppTemplates. All rights reserved.
//

import UIKit
import Contacts

class contactsDetailsTableViewController: UITableViewController {
    var contactIndex:Int=1
    var isKiboContact=false

    override func viewDidLoad() {
        super.viewDidLoad()

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
        var currentContact=contacts[contactIndex]
        
        //if(indexPath.row==1)
        //{
        var cell = tableView.dequeueReusableCellWithIdentifier("Name_Cell", forIndexPath: indexPath) as! AllContactsCell
        
        
       // cell.lbl_contactName.text=currentContact.givenName+currentContact.familyName
        cell.hidden=true
        if(indexPath.row==0)
        {
         cell = tableView.dequeueReusableCellWithIdentifier("Name_Cell", forIndexPath: indexPath) as! AllContactsCell
        
        
        cell.lbl_contactName.text=currentContact.givenName+" "+currentContact.familyName
            cell.hidden=false
        }
        //}
        if(indexPath.row==1)
        {
             cell = tableView.dequeueReusableCellWithIdentifier("Phone_Cell", forIndexPath: indexPath) as! AllContactsCell
            // Set the contact's home email address.
            cell.hidden=true
            
            
            
            if (contacts[contactIndex].isKeyAvailable(CNContactPhoneNumbersKey)) {
                for phoneNumber:CNLabeledValue in contacts[contactIndex].phoneNumbers {
                     let a = phoneNumber.value as! CNPhoneNumber
                    //{
                    cell.lbl_phone.text=a.stringValue
                    cell.hidden=false
                    
                   // }
                    
                }
            }
            
        }
        
        if(indexPath.row==2)
        {
             cell = tableView.dequeueReusableCellWithIdentifier("Email_Cell", forIndexPath: indexPath) as! AllContactsCell
        // Set the contact's home email address.
        
            cell.hidden=true
            var homeEmailAddress: String!
        for emailAddress in currentContact.emailAddresses {
            if emailAddress.label == CNLabelHome {
                cell.lbl_email.text=emailAddress.value as! String
                homeEmailAddress = emailAddress.value as! String
                cell.hidden=false
                
                break
            }
        }
        }
        if(indexPath.row==3 && isKiboContact==true)
        {
            cell = tableView.dequeueReusableCellWithIdentifier("Status_Cell", forIndexPath: indexPath) as! AllContactsCell
            cell.hidden=false
            cell.lbl_status.text="Hey there! I am using KiboApp"
            
        }
        
        //cell.lbl_phone
        // Configure the cell...

        return cell
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
