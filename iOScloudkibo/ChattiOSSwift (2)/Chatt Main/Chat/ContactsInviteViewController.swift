//
//  ContactsInviteViewController.swift
//  Chat
//
//  Created by Cloudkibo on 27/01/2016.
//  Copyright © 2016 MyAppTemplates. All rights reserved.
//

import UIKit

class ContactsInviteViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    
    @IBOutlet weak var contactsInviteNames: UILabel!
    @IBOutlet weak var tbl_inviteContacts: UITableView!
    var eeee=[String]()
    override func viewWillAppear(animated: Bool) {
        
        ////contactsList.fetch()
    }
    override func viewDidLoad() {
        tbl_inviteContacts.delegate=self
        tbl_inviteContacts.dataSource=self
        
        super.viewDidLoad()

        ////contactsList.fetch()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //refreshControl.addTarget(self, action: Selector("fetchContacts"), forControlEvents: UIControlEvents.ValueChanged)
        
        return 3
    }
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        
        
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
        
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell=tbl_inviteContacts.dequeueReusableCellWithIdentifier("ContactsInviteCell",forIndexPath: indexPath) as UITableViewCell
        
        
        cell.textLabel?.text = "hiii"
        ////cell.textLabel?.text =contactsList.notAvailableContacts[indexPath.row]
        ///tbl_inviteContacts.reloadData()
        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
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
