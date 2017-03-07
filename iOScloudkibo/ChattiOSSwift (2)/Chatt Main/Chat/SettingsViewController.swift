//
//  SettingsViewController.swift
//  kiboApp
//
//  Created by Cloudkibo on 07/03/2017.
//  Copyright © 2017 MyAppTemplates. All rights reserved.
//

import UIKit
import SQLite

class SettingsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tbl_Settings: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title="Settings"
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return " "
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if(section==0)
        {
          return 1
        }
        else{
            return 1
        }
        //return 2
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 2
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tbl_Settings.dequeueReusableCell(withIdentifier: "TopCell")! as! SettingsCells
        if(indexPath.section==0)
        {
            let firstname = Expression<String>("firstname")
            let tbl_accounts = sqliteDB.accounts
            do
            {
                
            for account in try sqliteDB.db.prepare(tbl_accounts!)
            {
                cell.lbl_name.text=account[firstname]

            }
            }
            catch
            {
                print("accounts table not accessible")
            }
        }
        if(indexPath.section>0)
        {
            cell = tbl_Settings.dequeueReusableCell(withIdentifier: "Settings")! as! SettingsCells

        }
        return cell
        
    }
    
   
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if(indexPath.section==0)
        {
            return 70
        }
        else{
            return 50
        }
        //return 100
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
