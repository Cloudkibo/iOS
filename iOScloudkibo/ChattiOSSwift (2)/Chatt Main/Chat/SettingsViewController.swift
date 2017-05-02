//
//  SettingsViewController.swift
//  kiboApp
//
//  Created by Cloudkibo on 07/03/2017.
//  Copyright © 2017 MyAppTemplates. All rights reserved.
//

import UIKit
import SQLite
import AlamofireImage

class SettingsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,SocketClientDelegateDesktopApp {

    
    var delegateDesktopApp:SocketClientDelegateDesktopApp!
    @IBOutlet weak var tbl_Settings: UITableView!
    
    let imageCache = AutoPurgingImageCache()
    var messages:NSMutableArray!
    override func viewDidLoad() {
        super.viewDidLoad()
        socketObj.delegateDesktopApp=self
        self.navigationItem.title="Settings"
        
        messages=NSMutableArray()
        messages=[["label":"Chats".localized,"logo":"navi_logo.png","segue":"BackupSegue"],["label":"Accounts".localized,"logo":"chat_lock.png","segue":"PrivacySegue"],["label":"Connect to Desktop app".localized,"logo":"chat_lock.png","segue":""]]
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
            return messages.count
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
            var messageDic = messages.object(at: indexPath.row) as! [String : String];
            // NSLog(messageDic["message"]!, 1)
            let optionLabel = messageDic["label"] as String!
            let optionLogo = messageDic["logo"] as String!
            
            
            cell = tbl_Settings.dequeueReusableCell(withIdentifier: "Settings")! as! SettingsCells
            cell.lbl_settings.text = optionLabel
            var logo=UIImage(named: optionLogo!)
            imageCache.add(logo!, withIdentifier: optionLabel!)
            
            // Fetch
            let cachedAvatar = imageCache.image(withIdentifier: optionLabel!)
            cell.img_logo.image=cachedAvatar
        }
        return cell
        
    }
    
    func showAlertConnectToDesktop()
    {
       // if(socketObj != nil)
       // {
          //  if(socketObj.desktopAppRoomJoined == false)
          //  {
                
                //socketObj.joinDesktopApp()
                
        let alert = UIAlertController(title: "Error", message: "Please enter ID displayed on your desktop app to connect".localized , preferredStyle: .alert)
        
        //2. Add the text field. You can configure it however you need.
        alert.addTextField(configurationHandler: { (textField) -> Void in
            textField.text = ""
        })
        
        
        //3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "OK".localized, style: .default, handler: { (action) -> Void in
            let textField = alert.textFields![0] as UITextField
            var socketIDdesktop=textField.text!
            print("compare \(desktopRoomID.description) and \(socketIDdesktop)")
            desktopRoomID=socketIDdesktop
            socketObj.joinDesktopApp()
            
            /*if(socketObj.desktopRoomID.description ==socketIDdesktop)
            {
                //connected
                socketObj.desktopAppRoomJoined=true
            }
            else{
                socketObj.desktopAppRoomJoined=false
               self.showAlertConnectToDesktop()
            }*/
            
        }))
                alert.addAction(UIAlertAction(title: "Cancel".localized, style: .cancel, handler: { (action) -> Void in
                    
                }))
        
        // 4. Present the alert.
        self.present(alert, animated: true, completion:
            {
                
                
        }
        )
           // }
            /*else{
                 let alert = UIAlertController(title: "Error", message: "You are already connected to desktop app".localized , preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "OK".localized, style: .cancel, handler: { (action) -> Void in
                }))
            
                self.present(alert, animated: true, completion:
                    {
                        
                        
                })
            }*/
        //}
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //
        if(indexPath.section>0)
        {
        var messageDic = messages.object(at: indexPath.row) as! [String : String];
        // NSLog(messageDic["message"]!, 1)
        var status = messageDic["status"] as String!
        var segue = messageDic["segue"] as String!
        
        
        //let cell=tbl_inviteContacts.dequeueReusableCellWithIdentifier("ContactsInviteCell")! as! ContactsInviteCell
            if(segue != "")
            {
                let selectedCell=tbl_Settings.cellForRow(at: indexPath)! as UITableViewCell
                self.performSegue(withIdentifier: segue!, sender: nil)
            }
            else{
                //tap action
                //show alert ID of desktop app
                self.showAlertConnectToDesktop()
                
                
            }
        }
        
    }
    
    func socketReceivedDesktopAppMessage(_ message: String, data: AnyObject!) {
        
        //if connected, ask for ID
        if(message=="joined_platform_room")
        {
        //showAlertConnectToDesktop()
        }
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
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.

            
            //contactdetailsinfosegue
            /*if segue.identifier == "BackupSegue" {
                if let destinationVC = segue.destination as? contactsDetailsTableViewController{
                    destinationVC.selectedContactphone=self.selectedContact
                }
            }*/
    }
 

}
