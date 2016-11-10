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

    
    var readBy=[[String]]()
    var deliveredTo=[[String]]()
    
    @IBOutlet weak var logDate_btn: UIButton!
    @IBOutlet weak var tblMessageInfo: UITableView!
    @IBOutlet weak var chatImage: UIImageView!
    @IBOutlet weak var chatMsg_lbl: UILabel!
    @IBOutlet weak var time_lbl: UILabel!
    
    
    override func viewDidLoad() {
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        
    }
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
    
    
    
    
    
    
}
