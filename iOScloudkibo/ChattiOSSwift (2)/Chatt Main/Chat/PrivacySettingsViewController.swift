//
//  PrivacySettingsViewController.swift
//  kiboApp
//
//  Created by Cloudkibo on 14/03/2017.
//  Copyright © 2017 MyAppTemplates. All rights reserved.
//

import UIKit

class PrivacySettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //  if(section==0)
        // {
        //     return 1
        // }
        // else{
        return messages.count
        //}
        //return 2
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        var cell = tbl_accountsSettings.dequeueReusableCell(withIdentifier: "AccountSettingsCell")! as! UITableViewCell
        
        
        var lbl_name=cell.viewWithTag(1) as! UILabel
        //if(indexPath.section>0)
        // {
        var messageDic = messages.object(at: indexPath.row) as! [String : String];
        // NSLog(messageDic["message"]!, 1)
        let optionLabel = messageDic["label"] as String!
        let optionSegue = messageDic["segue"] as String!
        lbl_name.text=optionLabel
        
        // }
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //
        if(indexPath.section>0)
        {
            var messageDic = messages.object(at: indexPath.row) as! [String : String];
            // NSLog(messageDic["message"]!, 1)
            let optionSegue = messageDic["segue"] as String!
            
            
            //let cell=tbl_inviteContacts.dequeueReusableCellWithIdentifier("ContactsInviteCell")! as! ContactsInviteCell
            let selectedCell=tbl_accountsSettings.cellForRow(at: indexPath)! as UITableViewCell
            self.performSegue(withIdentifier: optionSegue!, sender: nil)
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
