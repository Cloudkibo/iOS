//
//  MoreTableViewController.swift
//  Chat
//
//  Created by Rajkumar Sharma on 04/09/14.
//  Copyright (c) 2014 MyAppTemplates. All rights reserved.
//

import UIKit
import SwiftyJSON
import AccountKit
//import SQLite


class MoreTableViewController: UITableViewController {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    var accountKit:AKFAccountKit!
    @IBOutlet var tblOptions : UITableView?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        self.tblOptions?.tableFooterView = UIView(frame: CGRect.zero)
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return 6
    }
    
    

    /*
    override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as UITableViewCell

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView!, canEditRowAtIndexPath indexPath: NSIndexPath!) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView!, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath!) {
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
    override func tableView(tableView: UITableView!, moveRowAtIndexPath fromIndexPath: NSIndexPath!, toIndexPath: NSIndexPath!) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView!, canMoveRowAtIndexPath indexPath: NSIndexPath!) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */
    
    override func prepare(for segue: UIStoryboardSegue?, sender: Any?) {
        //var newController=segue ?.destinationViewController
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        
        //if segue!.identifier == "chatSegue" {
        if segue!.identifier == "logoutSegue" {
            print("Logging out", terminator: "")
            if let destinationVC = segue!.destination as? LoginViewController{
                
                //%%%%%% new phone model
                
                if accountKit == nil {
                    
                    //specify AKFResponseType.AccessToken
                    self.accountKit = AKFAccountKit(responseType: AKFResponseType.accessToken)
                    
                }
                self.accountKit.logOut()
                firstTimeLogin=true
                emailList.removeAll()
                nameList.removeAll()
                phonesList.removeAll()
                
                
                AuthToken=""
                var tbl_contactslists=sqliteDB.contactslists
                var tbl_accounts=sqliteDB.accounts
                let tbl_userchats=sqliteDB.userschats
                tbl_contactslists?.delete()
                tbl_accounts?.delete()
                tbl_userchats?.delete()
                KeychainWrapper.removeObjectForKey("access_token")
                KeychainWrapper.removeObjectForKey("username")
                KeychainWrapper.removeObjectForKey("password")
                KeychainWrapper.removeObjectForKey("loggedFullName")
                KeychainWrapper.removeObjectForKey("loggedPhone")
                KeychainWrapper.removeObjectForKey("loggedEmail")
                KeychainWrapper.removeObjectForKey("_id")
                loggedUserObj=JSON("[]")
               
                //let dbSQLite=DatabaseHandler(dbName: "/cloudKibo.sqlite3")
                print("loggedout", terminator: "")
                
            }
        }
    }
}
