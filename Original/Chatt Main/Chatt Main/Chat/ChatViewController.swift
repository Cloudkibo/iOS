//
//  ChatViewController.swift
//  Chat
//
//  Created by My App Templates Team on 24/08/14.
//  Copyright (c) 2014 My App Templates. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SQLite

class ChatViewController: UIViewController {

    @IBOutlet var viewForTitle : UIView!
    @IBOutlet var ctrlForChat : UISegmentedControl!
    @IBOutlet var btnForLogo : UIButton!
    @IBOutlet var itemForSearch : UIBarButtonItem!
    @IBOutlet var tblForChat : UITableView!
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        // Custom initialization
    }
    
    required init(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.titleView = viewForTitle
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: btnForLogo)
        self.navigationItem.rightBarButtonItem = itemForSearch
        self.tabBarController?.tabBar.tintColor = UIColor.greenColor()
        self.performSegueWithIdentifier("loginSegue", sender: nil)
        
        if(globalToken != "")
        {
            Alamofire.request(.GET, "https://www.cloudkibo.com/api/contactslist/?access_token=" + globalToken)
                .responseJSON { (request, response, data1, error) in
                    
                    println(data1)
                    println(response)
                    println(error)
                    
                    let c_jsonData = JSON(data1!);
                    let c_jsonArray = JSON(c_jsonData.arrayObject!)
                    
                    for contact in c_jsonArray {
                        println("INSERTED DATA: contact username: \(contact)")
                        
                    }
                    let db = Database("/Users/cloudkibo/Desktop/iOS/db.sqlite3")
                    
                    let contacts = db["contacts"]
                    let c_id = Expression<String>("id")
                    let c_username = Expression<String>("username")
                    let c_firstname = Expression<String>("firstname")
                    let c_lastname = Expression<String>("lastname")
                    let c_phone = Expression<String>("phone")
                    let detailshared = Expression<String>("detailshared")
                    let c_status = Expression<String>("status")
                    
                    db.drop(table: contacts, ifExists: true);
                    
                    db.create(table: contacts, ifNotExists: true) { t in
                        t.column(c_id, defaultValue: "Anonymous")
                        t.column(c_username, defaultValue: "Anonymous")
                        t.column(c_firstname, defaultValue: "Anonymous")
                        t.column(c_lastname, defaultValue: "Anonymous")
                        t.column(c_phone, defaultValue: "0987")
                        t.column(c_status, defaultValue: "Anonymous")
                        t.column(detailshared, defaultValue: "Anonymous")
                        
                    }// db created
                    
                    
                    for (index: String, subJson: JSON) in c_jsonData {
                        
                        let  c_insertID = contacts.insert(
                            c_username <- c_jsonArray["username"].string!,
                            c_firstname <- c_jsonArray["firstname"].string!,
                            c_lastname <- c_jsonArray["lastname"].string!,
                            c_phone <- c_jsonArray["phone"].string!,
                            c_id <- c_jsonArray["id"].string!,
                            c_status <- c_jsonArray["status"].string!,
                            detailshared <- c_jsonArray["detailshared"].string!)
                        
                    }
                    
            }
            
            
        }
        
        
        
        
        
       // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func unwindToChat (segueSelected : UIStoryboardSegue) {
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func numberOfSectionsInTableView(tableView: UITableView!) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        if (indexPath.row%2 == 0){
            return tblForChat.dequeueReusableCellWithIdentifier("ChatPrivateCell") as! UITableViewCell
        } else {
            return tblForChat.dequeueReusableCellWithIdentifier("ChatPublicCell") as! UITableViewCell
        }
    }
    
    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!){
        self.performSegueWithIdentifier("slideToChat", sender: nil);
    }

    
    
    /*
    // #pragma mark - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue?, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
