//
//  BlockedContactsViewController.swift
//  kiboApp
//
//  Created by Cloudkibo on 15/03/2017.
//  Copyright © 2017 MyAppTemplates. All rights reserved.
//

import UIKit
import SQLite
class BlockedContactsViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet weak var tblBlockedContacts: UITableView!
    
    var blockedList=[[String: Any]]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.retrieveBlockedByMeContacts()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        retrieveBlockedByMeContacts()
        DispatchQueue.main.async {
           /* self.tblBlockedContacts.headerView(forSection: 0)?.textLabel? .numberOfLines=0
            self.tblBlockedContacts.headerView(forSection: 0)?.textLabel?.lineBreakMode=NSLineBreakMode.byWordWrapping
            self.tblBlockedContacts.headerView(forSection: 0)?.textLabel?.sizeToFit()*/
            self.tblBlockedContacts.reloadData()
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
        let phone = Expression<String>("phone")
        let blockedByMe = Expression<Bool>("blockedByMe")
        let IamBlocked = Expression<Bool>("IamBlocked")
        
        var tbl_contactsList=sqliteDB.contactslists
        
          blockedList=[[String: Any]]()
        //var count=sqliteDB.db.scalar((tbl_contactsList?.filter(blockedByMe==true).count)!)
        //countBlocked=count
        do{for blockedlist in try sqliteDB.db.prepare((tbl_contactsList?.filter(blockedByMe==true))!)
         {
            
         var newEntry: [String: Any] = [:]
         newEntry["phone"]=blockedlist.get(phone) as String
         var name=sqliteDB.getNameFromAddressbook(newEntry["phone"] as! String!)
         if(name != nil)
         {
         newEntry["name"]=name
         
         }
         else
         {
         newEntry["name"]=blockedlist.get(phone) as String
         }
         blockedList.append(newEntry)
         
         }
        }
        catch
        {
            print("error in reading blocked contacts from db")
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return blockedList.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        var cell = tblBlockedContacts.dequeueReusableCell(withIdentifier: "BlockedContactCell")! as! UITableViewCell
        
        
        var lbl_blockedname=cell.viewWithTag(1) as! UILabel
        
        lbl_blockedname.text=blockedList[indexPath.row]["name"] as! String
        
        // }
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return ""
       // return "Blocked contacts will no longer be able to call you or send you message"
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 150
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
