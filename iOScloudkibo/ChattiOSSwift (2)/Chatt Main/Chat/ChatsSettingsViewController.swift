//
//  ChatsSettingsViewController.swift
//  kiboApp
//
//  Created by Cloudkibo on 07/03/2017.
//  Copyright © 2017 MyAppTemplates. All rights reserved.
//

import UIKit

class ChatsSettingsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tbl_ChatsSettings: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
            return 1
       
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        var cell = tbl_ChatsSettings.dequeueReusableCell(withIdentifier: "ChatBackupCell")! as! UITableViewCell
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
        self.performSegue(withIdentifier: "BackupSettingsSegue", sender: nil)
    }
    
   /* func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //
        if(indexPath.section>0)
        {
            var messageDic = messages.object(at: indexPath.row) as! [String : String];
            // NSLog(messageDic["message"]!, 1)
            var status = messageDic["status"] as String!
            var segue = messageDic["segue"] as String!
            
            
            //let cell=tbl_inviteContacts.dequeueReusableCellWithIdentifier("ContactsInviteCell")! as! ContactsInviteCell
            let selectedCell=tbl_Settings.cellForRow(at: indexPath)! as UITableViewCell
            self.performSegue(withIdentifier: segue!, sender: nil)
        }
        
    }*/
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
