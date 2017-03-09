//
//  BackupSettingsViewController.swift
//  kiboApp
//
//  Created by Cloudkibo on 07/03/2017.
//  Copyright © 2017 MyAppTemplates. All rights reserved.
//

import UIKit

class BackupSettingsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    
    var mycontainer:URL?=nil
    
    @IBOutlet weak var tbl_BackupSettings: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        
        var fileManager=FileManager.default
        var currentiCloudToken=fileManager.ubiquityIdentityToken
        if(currentiCloudToken != nil)
        {
            print("currentiCloudToken is \(currentiCloudToken)")
            var newTokenData:NSData=NSKeyedArchiver.archivedData(withRootObject: currentiCloudToken!) as NSData
            UserDefaults.standard.set(newTokenData, forKey: "com.apple.Chat.UbiquityIdentityToken")
            
        }
        else{
            UserDefaults.standard.removeObject(forKey: "com.apple.Chat.UbiquityIdentityToken")
        }
        
        DispatchQueue.global(qos: .utility).async {
            
            self.mycontainer = FileManager.default.url(forUbiquityContainerIdentifier:"iCloud.iCloud.MyAppTemplates.cloudkibo")
            
            if(self.mycontainer != nil)
            {
                //write
                DispatchQueue.main.async {
                    self.showError("Success", message: "You can backup your data on iCloud", button1: "Ok")
                    print("write to icloud")
                    
                    
                    
                }
            }
                
            else
            {
                DispatchQueue.main.async {
                    self.showError("Failed to access iCloud", message: "Please sign in to correct iCloud account to resume backup service", button1: "Ok")
                    print("no permission to write to icloud")
                }
            }
        }
        
        NotificationCenter.default.addObserver(self, selector: "iCloudAccountAvailabilityChanged:",name: nil, object: nil)
        
        
        // Do any additional setup after loading the view.
    }

    
    func iCloudAccountAvailabilityChanged(_ sender:Notification)
    {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showError(_ title:String,message:String,button1:String) {
        
        // create the alert
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        // add the actions (buttons)
        alert.addAction(UIAlertAction(title: button1, style: UIAlertActionStyle.default, handler: nil))
        //alert.addAction(UIAlertAction(title: button2, style: UIAlertActionStyle.Cancel, handler: nil))
        
        // show the alert
        UIApplication.shared.keyWindow!.rootViewController!.present(alert, animated: true, completion: nil)
        //self.present(alert, animated: true, completion: nil)
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if(indexPath.section==0)
        {
            return 114
        }
        else{
            return 50
        }
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
            return 3
        }
        //return 2
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 2
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
       
        
        var cell = tbl_BackupSettings.dequeueReusableCell(withIdentifier: "BackupInfoCell")! as! UITableViewCell
       
        if(indexPath.section==1)
        {
            
            if(indexPath.row==0)
            {
           cell = tbl_BackupSettings.dequeueReusableCell(withIdentifier: "BackUpNowCell")! as! UITableViewCell
            
            }
            if(indexPath.row==1){
                
            cell = tbl_BackupSettings.dequeueReusableCell(withIdentifier: "AutoBackupCell")! as! UITableViewCell
                
                //IncludeVideosCell
            
            }
            
            if(indexPath.row==2){
                
                cell = tbl_BackupSettings.dequeueReusableCell(withIdentifier: "IncludeVideosCell")! as! UITableViewCell
                var switchIncludeVideos=cell.viewWithTag(2) as! UISwitch
                switchIncludeVideos.tag=111
                if (UserDefaults.standard.value(forKey: Constants.defaultsBackupIncludeVideosKey) == nil)
                {
                    UserDefaults.standard.set("Off", forKey: Constants.defaultsBackupIncludeVideosKey)
                    
                }
                if(UserDefaults.standard.value(forKey: Constants.defaultsBackupIncludeVideosKey) as! String == "On")
                {
                switchIncludeVideos.setOn(true, animated: true)
                }
                else
                {
                   switchIncludeVideos.setOn(false, animated: true)
                }
                ///switchIncludeVideos.addTarget(self, action: Selector("stateChanged:"), for: UIControlEvents.valueChanged)
                //2
                
                //
                
            }
            
           
 
            ///AutoBackupCell
        }
        
        return cell
    }
    
    @IBAction func switchStateChanged(_ sender: UISwitch) {
        
        if(sender.tag==111){
            if sender.isOn {
                //
                print("switch is ON")
                UserDefaults.standard.set("On", forKey: Constants.defaultsBackupIncludeVideosKey)
                
            } else {
                  print("switch is Off")
                UserDefaults.standard.set("Off", forKey: Constants.defaultsBackupIncludeVideosKey)
                
            }
        }
    }
   /* func stateChanged(sender: UISwitch) {
        print("switch pressed")
         let switch1 = sender as! UISwitch
        if(switch1.tag==111){
        if switch1.isOn {
           //
            UserDefaults.standard.set("On", forKey: Constants.defaultsBackupIncludeVideosKey)
            
        } else {
            UserDefaults.standard.set("Off", forKey: Constants.defaultsBackupIncludeVideosKey)
            
        }
        }
        }*/
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("didselect")
        if(indexPath.section==1 && indexPath.row == 0)
        {
            print("section1")
            
            if(mycontainer != nil)
            {
                print("container not nil")
                UtilityFunctions.init().backupFiles()
            }
            else{
                print("container nil")
                
            }
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
