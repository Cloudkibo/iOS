//
//  RestoreChatsViewController.swift
//  kiboApp
//
//  Created by Cloudkibo on 09/03/2017.
//  Copyright © 2017 MyAppTemplates. All rights reserved.
//

import UIKit

class RestoreChatsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tbl_RestoreChats: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
            return 100
        }
            
        else
        {
            return 20
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        var cell = tbl_RestoreChats.dequeueReusableCell(withIdentifier: "RestoreChatInfoCell")! as! UITableViewCell
        
        if(indexPath.section==0)
        {
            cell = tbl_RestoreChats.dequeueReusableCell(withIdentifier: "RestoreChatInfoCell")! as! UITableViewCell
            
        let ltbl_LastBackupDate = cell.viewWithTag(1) as! UILabel
        let lbl_BackupInfoText = cell.viewWithTag(2) as! UITextView
        }
        if(indexPath.section==1)
        {
            cell = tbl_RestoreChats.dequeueReusableCell(withIdentifier: "RestoreFromICloudCell")! as! UITableViewCell
            
            //RestoreFromICloudCell
            //let ltbl_LastBackupDate = cell.viewWithTag(1) as! UILabel
            //let lbl_BackupInfoText = cell.viewWithTag(2) as! UITextView
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if(section==0)
        {
            return 1
            
        }
        if(section==1)
        {
            return 1
            
        }
        
            return 0
            
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 3
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
