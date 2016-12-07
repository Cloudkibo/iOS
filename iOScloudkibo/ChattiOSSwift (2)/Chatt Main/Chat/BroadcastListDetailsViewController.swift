//
//  BroadcastListDetailsViewController.swift
//  kiboApp
//
//  Created by Cloudkibo on 07/12/2016.
//  Copyright © 2016 MyAppTemplates. All rights reserved.
//

import UIKit

class BroadcastListDetailsViewController: UIViewController,UINavigationControllerDelegate {

    
    var broadcastmembers=[String]()
    var broadcastlistID=""
    var membersnames=[String]()
    @IBOutlet weak var tblForBroadcastList: UITableView!
    
    required init?(coder aDecoder: NSCoder){
        
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //memberphone
        //uniqueid
        
       /* broadcastmembers=sqliteDB.getBroadcastListMembers(broadcastlistID)
        
        for(var i=0;i<broadcastmembers.count;i++)
        {
            membersnames.append(sqliteDB.getNameFromAddressbook(broadcastmembers[i]))
        }*/
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(animated: Bool) {
       broadcastmembers=sqliteDB.getBroadcastListMembers(broadcastlistID)
        
        for(var i=0;i<broadcastmembers.count;i++)
        {
            membersnames.append(sqliteDB.getNameFromAddressbook(broadcastmembers[i]))
        }
        print(")count for broadcast members is \(broadcastmembers.count+1)")
        tblForBroadcastList.reloadData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(section==0)
        {
            return 1
        }
        else{
        return broadcastmembers.count+1
        }
    }
    
    
    
    func numberOfSectionsInTableView(tableView: UITableView!) -> Int {
        return 2
    }
    
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if(section==0)
        {
            return " "
        }
        else
        {
            return "List Recipients"
        }
        
        
    }

    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 60    }
    
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        
        print("count for broadcast members is \(broadcastmembers.count+1)")
        //if (indexPath.row%2 == 0){
        //var cellPrivate = tblForNotes.dequeueReusableCellWithIdentifier("NotePrivateCell")! as UITableViewCell
        //var messageDic = broadcastlistmessages.objectAtIndex(indexPath.row) as! [String : String];
        //var listname=messageDic["listname"] as! NSString
        //var membersnames=messageDic["membersnames"] as! NSString
        
        var cell = tblForBroadcastList.dequeueReusableCellWithIdentifier("ListNameCell")! as! UITableViewCell
        
        if(indexPath.section==0)
        {
            cell = tblForBroadcastList.dequeueReusableCellWithIdentifier("ListNameCell")! as! UITableViewCell
            
        }
        else{
            //if(indexPath.row>0){
                if(indexPath.row<membersnames.count)
                {
                    cell = tblForBroadcastList.dequeueReusableCellWithIdentifier("NameCell")! as! UITableViewCell
                    
                    var namelabel=cell.viewWithTag(1) as! UILabel
                    namelabel.text=membersnames[indexPath.row]
                }
                else{
                    //show edit
                    cell = tblForBroadcastList.dequeueReusableCellWithIdentifier("EditListCell")! as! UITableViewCell
                }
            }
        
            
       
       
        return cell
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
