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
        self.readBy=sqliteDB.getGroupsChatReadStatusList(message_unique_id)
        self.deliveredTo=sqliteDB.getGroupsChatDeliveredStatusList(message_unique_id)
    }
    
   /* func retrieveChatFromSqlite(completion:(result:Bool)->())
    {
        print("retrieveChatFromSqlite called---------")
        ///^^messages.removeAllObjects()
        let messages2=NSMutableArray()
        var statusObjectsList=sqliteDB.getGroupsChatStatusObjectList(message_ubique_id)
        
        for(var i=0;i<statusObjectsList.count;i++)
        {
            messages2.addObject(["msg_unique_id":statusObjectsList[i]["msg_unique_id"] as! String, "Status":statusObjectsList[i]["Status"] as! String, "user_phone":statusObjectsList[i]["user_phone"] as! String,"read_date":statusObjectsList[i]["read_date"] as! NSDate, "delivered_date":statusObjectsList[i]["delivered_date"] as! NSDate])
        }
        
        messages.setArray(messages2 as [AnyObject])
        completion(result:true)
        
    }*/
    
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
        return 60
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
    
    
    
    
    
    
}
