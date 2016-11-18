//
//  GroupMessageStatusViewController.swift
//  kiboApp
//
//  Created by Cloudkibo on 11/11/2016.
//  Copyright © 2016 MyAppTemplates. All rights reserved.
//

import UIKit
import Foundation


class GroupMessageStatusViewController: UIViewController {

    
    var readBy=[[String:AnyObject]]()
    var deliveredTo=[[String:AnyObject]]()
    var message_unique_id=""
    var messages:NSMutableArray!
    @IBOutlet weak var logDate_btn: UIButton!
    @IBOutlet weak var tblMessageInfo: UITableView!
    @IBOutlet weak var chatImage: UIImageView!
    @IBOutlet weak var chatMsg_lbl: UILabel!
    @IBOutlet weak var time_lbl: UILabel!
    
    
    override func viewDidLoad() {
        messages=NSMutableArray()
        
    }
    
    override func viewWillAppear(animated: Bool)
    {
        
        /*
    
         let msg_unique_id = Expression<String>("msg_unique_id")
         let Status = Expression<String>("Status")
         
         let user_phone = Expression<String>("user_phone")
         
         let read_date = Expression<NSDate>("read_date")
         let delivered_date = Expression<NSDate>("delivered_date")
        
         */
        
        print("here inside groupmessagestatus view unique id is \(message_unique_id)")
        self.readBy=sqliteDB.getGroupsChatReadStatusList(message_unique_id)
        self.deliveredTo=sqliteDB.getGroupsChatDeliveredStatusList(message_unique_id)
    
    }
    
    //getGroupsChatStatusObjectList
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        if(section==0)
        {
           return deliveredTo.count
        }
        else
        {
           return readBy.count
        }
    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return 200
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 2
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if(section==0)
        {
            return "DELIVERED TO"
        }
        else
        {
            return "READ BY"
        }
       
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tblMessageInfo.dequeueReusableCellWithIdentifier("messageInfoCell")! as UITableViewCell
        var name=cell.viewWithTag(1) as! UILabel
        if(indexPath.row<readBy.count)
        {
        name.text=sqliteDB.getNameGroupMemberNameFromMembersTable(readBy[indexPath.row]["user_phone"] as! String)
        }
        
        return cell
        
        
    }
    
    
    
    
    
    
    
}
