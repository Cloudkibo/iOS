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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        var cell = tbl_backupAutoScheduleSettings.dequeueReusableCell(withIdentifier: "BackupAutoScheduleOptionsCell")! as! UITableViewCell
        
     
     return cell
    }
    

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
     
        return 50
     
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if(section==0)
        {return " "
        }
        else{
            return "To avoid excessive data charges, connect your phone to Wi-Fi or disable cellular data for iCloud: iPhone Settings > iCloud > iCloud Drive > Use Cellular Data > OFF"
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if(section==0)
        {
            return 1
        }
        else{
            return 0
        }
        //return 2
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 2
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
