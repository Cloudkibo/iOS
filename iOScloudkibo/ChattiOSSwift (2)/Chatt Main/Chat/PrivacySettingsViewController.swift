//
//  PrivacySettingsViewController.swift
//  kiboApp
//
//  Created by Cloudkibo on 14/03/2017.
//  Copyright © 2017 MyAppTemplates. All rights reserved.
//

import UIKit
import SQLite

class PrivacySettingsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    
    @IBOutlet weak var tbl_PrivacySettings: UITableView!
    var countBlocked:Int=0
    //var blockedList=[[String: Any]]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //messages=NSMutableArray()
        
        // Do any additional setup after loading the view.
        retrieveBlockedByMeContacts()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        
        retrieveBlockedByMeContacts()
        DispatchQueue.main.async {
            self.tbl_PrivacySettings.reloadData()
        }
       
    }

    func retrieveBlockedByMeContacts()
    {
        /*
        let contactid = Expression<String>("contactid")
        let detailsshared = Expression<String>("detailsshared")
        let unreadMessage = Expression<Bool>("unreadMessage")
        let userid = Expression<String>("userid")
        let firstname = Expression<String>("firstname")
        let lastname = Expression<String>("lastname")
        let email = Expression<String>("email")
        let phone = Expression<String>("phone")
        let username = Expression<String>("username")
        let status = Expression<String>("status")
        */
        let blockedByMe = Expression<Bool>("blockedByMe")
        let IamBlocked = Expression<Bool>("IamBlocked")
        
        var tbl_contactsList=sqliteDB.contactslists
        
      //  blockedList=[[String: Any]]()
        do
        {var count=try sqliteDB.db.scalar((tbl_contactsList?.filter(blockedByMe==true).count)!)
        countBlocked=count
        }
        catch{
            print("error: cannot count blocked contacts")
        }
        /*for blockedlist in try sqliteDB.db.prepare((tbl_contactsList?.filter(blockedByMe==true))!)
        {
            var newEntry: [String: Any] = [:]
            newEntry["phone"]=blockedlist.get(phone) as String
            var name=sqliteDB.getNameFromAddressbook(newEntry["phone"])
            if(name != nil)
            {
                newEntry["name"]=name

            }
            else
            {
                newEntry["name"]=blockedlist.get(phone) as String
            }
            blockedList.append(newEntry)

        }*/
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        var cell = tbl_PrivacySettings.dequeueReusableCell(withIdentifier: "PrivacyBlockedCell")! as! UITableViewCell
        
        
        var lbl_blockedCount=cell.viewWithTag(2) as! UILabel
        
         lbl_blockedCount.text="\(countBlocked) contacts"
        
        // }
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //
       /* if(indexPath.section>0)
        {
            var messageDic = messages.object(at: indexPath.row) as! [String : String];
            // NSLog(messageDic["message"]!, 1)
            let optionSegue = messageDic["segue"] as String!
            
            
            //let cell=tbl_inviteContacts.dequeueReusableCellWithIdentifier("ContactsInviteCell")! as! ContactsInviteCell
            let selectedCell=tbl_accountsSettings.cellForRow(at: indexPath)! as UITableViewCell
            self.performSegue(withIdentifier: optionSegue!, sender: nil)
        }*/
        self.performSegue(withIdentifier: "BlockedContactsSegue", sender: nil)
        
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
