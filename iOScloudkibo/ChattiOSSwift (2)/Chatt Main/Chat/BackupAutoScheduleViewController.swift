//
//  BackupAutoScheduleViewController.swift
//  kiboApp
//
//  Created by Cloudkibo on 08/03/2017.
//  Copyright © 2017 MyAppTemplates. All rights reserved.
//

import UIKit

class BackupAutoScheduleViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tbl_backupAutoScheduleSettings: UITableView!
    
    var messages:NSMutableArray!
    override func viewDidLoad() {
        super.viewDidLoad()

        messages=NSMutableArray()
        messages=[["option":"Daily","status":"false"],["option":"Weekly","status":"false"],["option":"Monthly","status":"false"],["option":"Off","status":"true"]]
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        var messageDic = messages.object(at: indexPath.row) as! [String : String];
       // NSLog(messageDic["message"]!, 1)
        let option = messageDic["option"] as String!
        let status = messageDic["status"] as String!
        
        var cell = tbl_backupAutoScheduleSettings.dequeueReusableCell(withIdentifier: "BackupAutoScheduleOptionsCell")! as! UITableViewCell
        
        let textLable = cell.viewWithTag(1) as! UILabel
        
        if let backupValue=UserDefaults.standard.value(forKey: "BackupTime")
        {
            
            if(option == backupValue as! String)
            {
                //got option
                cell.accessoryType=UITableViewCellAccessoryType.checkmark
                
            }
        }
        else{
            if(option == "Off")
            {
                cell.accessoryType=UITableViewCellAccessoryType.checkmark
                UserDefaults.standard.set("Off", forKey: "BackupTime")
            }
        }
        
       /* if(status=="true")
        {
        cell.accessoryType=UITableViewCellAccessoryType.checkmark
        }
        else
        {
            cell.accessoryType=UITableViewCellAccessoryType.none
        }*/
        textLable.text=option
        print("backupValue is \(UserDefaults.standard.value(forKey: "BackupTime"))")
        
     return cell
    }
    

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
     if(indexPath.section==0)
     {
        return 50
        }
     else{
        return 200
        }
     
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if(section==0)
        {
            return 20
        }
        
        else
        {
            return 100
        }
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if(section==1)
        {
        var titleSection:UILabel=UILabel.init()
        titleSection.text="To avoid excessive data charges, connect your phone to Wi-Fi or disable cellular data for iCloud: iPhone Settings > iCloud > iCloud Drive > Use Cellular Data > OFF"
        titleSection.numberOfLines=0
        titleSection.lineBreakMode = .byWordWrapping
        titleSection.backgroundColor = UIColor.white
        
        
        return titleSection
        }
        else{
            return nil
        }
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if(section==0)
        {return " "
        }
        else{
            return "To avoid excessive data charges, connect your phone to Wi-Fi or disable cellular data for iCloud: iPhone Settings > iCloud > iCloud Drive > Use Cellular Data > OFF".localized
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if(section==0)
        {
            return messages.count

        }
        else{
            return 0}
        //return 2
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 2
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
        var messageDic = messages.object(at: indexPath.row) as! [String : String];
        // NSLog(messageDic["message"]!, 1)
        var status = messageDic["status"] as String!
        
        
        //let cell=tbl_inviteContacts.dequeueReusableCellWithIdentifier("ContactsInviteCell")! as! ContactsInviteCell
        let selectedCell=tbl_backupAutoScheduleSettings.cellForRow(at: indexPath)! as UITableViewCell
        
        //let selectedCell=tbl_inviteContacts.cellForRowAtIndexPath(indexPath)
        //cell.textLabel?.text = "hiii"
        
        
        if selectedCell.accessoryType == UITableViewCellAccessoryType.none
        {
                       //selected save in userdefaults
            //remove check from all others
            
            for i in 0 ..< messages.count
            {
                var allmessages = messages.object(at: i) as! [String : String]
                  allmessages["status"]="false"
                var cellcounter=tbl_backupAutoScheduleSettings.cellForRow(at: IndexPath(row: i,section: 0))! as UITableViewCell
                cellcounter.accessoryType = UITableViewCellAccessoryType.none
                
            }
           /* for var statuses in messages as! [[String : String]]
            {
                ///var messageDic = messages.object(at: indexPath.row) as! [String : String];
                
               statuses["status"]="false"
                
                
            }*/
            
            UserDefaults.standard.set(messageDic["option"], forKey: "BackupTime")
            messageDic["status"]="true"
            selectedCell.accessoryType = UITableViewCellAccessoryType.checkmark
            

            
        }
        else
        {
           // messageDic["status"]="false"
           // selectedCell.accessoryType = UITableViewCellAccessoryType.none
            
            /*let ind=selectedEmails.index(of: selectedCell.contactEmail.text!)
            //var ind=selectedEmails.indexOf((selectedCell?.textLabel?.text!)!)
            selectedEmails.remove(at: ind!)
 */
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
