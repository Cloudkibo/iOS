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
    var messageString=""
    var datetime=""
    
    override func viewDidLoad() {
        messages=NSMutableArray()
        
    }
    
    
    
    override func viewWillAppear(_ animated: Bool)
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

        if(readBy.count>0)
        {
            for i in 0 ..< readBy.count
            {
            self.deliveredTo.append(self.readBy[i])
            }
        }
        
        
        
        print("datetime on button is \(datetime)")
        
        
        let formatter = DateFormatter();
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS";
        //formatter.dateFormat = "MM/dd hh:mm a";
        formatter.timeZone = TimeZone.autoupdatingCurrent
        let defaultTimeZoneStr = formatter.date(from: datetime)
        
        
        let formatter2 = DateFormatter();
        formatter2.timeZone=TimeZone.autoupdatingCurrent
        formatter2.dateFormat = "MM/dd hh:mm a";
        let displaydate=formatter2.string(from: defaultTimeZoneStr!)
        
        chatMsg_lbl.text=messageString
        logDate_btn.setTitle(displaydate, for: .normal)
        
        
        
    }
    
    //getGroupsChatStatusObjectList
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        if(section==0)
        {
           return deliveredTo.count
        }
        else
        {
           return readBy.count
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAtIndexPath indexPath: IndexPath) -> CGFloat
    {
        return 120
    }
    
    func numberOfSectionsInTableView(_ tableView: UITableView) -> Int
    {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if(section==0)
        {
            return "DELIVERED TO"
        }
        else
        {
            return "READ BY"
        }
       
        
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tblMessageInfo.dequeueReusableCell(withIdentifier: "messageInfoCell")! as UITableViewCell
        var name=cell.viewWithTag(1) as! UILabel
        
        var datetimeStatusUpdate=cell.viewWithTag(3) as! UILabel
        
        if(indexPath.row<deliveredTo.count)
        {
        name.text=sqliteDB.getNameGroupMemberNameFromMembersTable(deliveredTo[indexPath.row]["user_phone"] as! String)
            //delivered_date
            //read_date
            var date=self.deliveredTo[indexPath.row]["delivered_date"] as! Date?
            
            let formatter2 = DateFormatter();
            formatter2.timeZone=TimeZone.autoupdatingCurrent
            formatter2.dateFormat = "MM/dd hh:mm a";
            let displaydate=formatter2.string(from: date!)
            datetimeStatusUpdate.text=displaydate
            
        }
        else
        {
            name.text=sqliteDB.getNameGroupMemberNameFromMembersTable(readBy[indexPath.row - deliveredTo.count]["user_phone"] as! String)
            var date=self.readBy[indexPath.row]["read_date"] as! Date?
            
            let formatter2 = DateFormatter();
            formatter2.timeZone=TimeZone.autoupdatingCurrent
            formatter2.dateFormat = "MM/dd hh:mm a";
            let displaydate=formatter2.string(from: date!)
            datetimeStatusUpdate.text=displaydate
            
        }
        
        return cell
        
        
    }
    
    
    
    
    
    
    
}
