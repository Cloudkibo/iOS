//
//  GroupChatingDetailController.swift
//  kiboApp
//
//  Created by Cloudkibo on 31/08/2016.
//  Copyright © 2016 MyAppTemplates. All rights reserved.
//

import UIKit

class GroupChatingDetailController: UITableViewController {
    
    @IBOutlet var tblForGroupChat: UITableView!
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 60
    }
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if(indexPath.row==0)
        {
        var cell = tblForGroupChat.dequeueReusableCellWithIdentifier("ChatSentCell")! as UITableViewCell
            let nameLabel = cell.viewWithTag(15) as! UILabel
            nameLabel.text="Sojharo"
        return cell
        }
        if(indexPath.row==1)
        {
            var cell = tblForGroupChat.dequeueReusableCellWithIdentifier("ChatReceivedCell")! as UITableViewCell
            let msgLabel = cell.viewWithTag(12) as! UILabel
            msgLabel.text="Hello people!"
            return cell

        }
        if(indexPath.row==2)
        {
            var cell = tblForGroupChat.dequeueReusableCellWithIdentifier("ChatSentCell")! as UITableViewCell
            let nameLabel = cell.viewWithTag(15) as! UILabel
            nameLabel.textColor=UIColor.blueColor()
            nameLabel.text="Sumaira"
            let msgLabel = cell.viewWithTag(12) as! UILabel
            msgLabel.text="Wsalaam. I am fine"
            
            return cell
        }
       /* if(indexPath.row==3)
        {
            var cell = tblForGroupChat.dequeueReusableCellWithIdentifier("ChatReceivedCell")! as UITableViewCell
            
            return cell
        }*/
        if(indexPath.row==3)
        {
            var cell = tblForGroupChat.dequeueReusableCellWithIdentifier("ChatSentCell")! as UITableViewCell
            let nameLabel = cell.viewWithTag(15) as! UILabel
            nameLabel.text="Sojharo"
            let msgLabel = cell.viewWithTag(12) as! UILabel
            msgLabel.text="Done with tasks?"
            return cell
        }
        else{
            var cell = tblForGroupChat.dequeueReusableCellWithIdentifier("ChatReceivedCell")! as UITableViewCell
            let msgLabel = cell.viewWithTag(12) as! UILabel
            msgLabel.text="Yes. I am done"
            return cell
        }
        
    }

}
