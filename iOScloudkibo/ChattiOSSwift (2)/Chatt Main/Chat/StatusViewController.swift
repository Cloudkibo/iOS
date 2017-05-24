//
//  StatusViewController.swift
//  kiboApp
//
//  Created by Cloudkibo on 24/05/2017.
//  Copyright © 2017 MyAppTemplates. All rights reserved.
//

import UIKit
import SQLite
class StatusViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    
    var messages:NSMutableArray!
    
    @IBOutlet weak var tblStatusUpdates: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        messages=NSMutableArray()
        messages.add(["displayName":"Sojharo","time":"1 hour ago"])
        messages.add(["displayName":"XYZ","time":"just now"])
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(section==0)
        {
            return 1
        }
        else{
            if(messages.count>0)
            {
            return messages.count
            }
            else{
                return 1
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var messageDic = messages.object(at: indexPath.row) as! [String : String];
       // NSLog(messageDic["message"]!, 1)
        let nameDict = messageDic["displayName"] as NSString!
        let timeDict = messageDic["time"] as NSString!
        
        var cell = tblStatusUpdates.dequeueReusableCell(withIdentifier: "StatusCell")! as! UITableViewCell

        if(indexPath.section==0)
        {
             cell = tblStatusUpdates.dequeueReusableCell(withIdentifier: "myStatusCell")! as! UITableViewCell

        }
        else{
            if(messages.count<1)
            {
             cell = tblStatusUpdates.dequeueReusableCell(withIdentifier: "StatusCell")! as! UITableViewCell
            }
            else{
                cell = tblStatusUpdates.dequeueReusableCell(withIdentifier: "myStatusCell")! as! UITableViewCell
                var name=cell.viewWithTag(2) as! UILabel
                var time=cell.viewWithTag(3) as! UILabel
                name.text=nameDict as String?
                time.text=timeDict as String?

            }

        }
        
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if(section==0)
        {
            return 25
        }
        else{
            return 50
        }
    }
     func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if(section==1)
        {
        return "Viewed Updates"
        }
        else{
        return ""
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
