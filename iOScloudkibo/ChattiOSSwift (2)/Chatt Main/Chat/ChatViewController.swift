//
//  ChatViewController.swift
//  Chat
//
//  Created by My App Templates Team on 24/08/14.
//  Copyright (c) 2014 My App Templates. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import SQLite

class ChatViewController: UIViewController {

    
    //var contactsJsonObj:JSON="[]"
    @IBOutlet var viewForTitle : UIView!
    @IBOutlet var ctrlForChat : UISegmentedControl!
    @IBOutlet var btnForLogo : UIButton!
    @IBOutlet var itemForSearch : UIBarButtonItem!
    @IBOutlet var tblForChat : UITableView!
    //var AuthToken:String=""
    //var socketObj=LoginAPI(url: "\(Constants.MainUrl)")

    let transportItems = ["Bus","Helicopter","Truck","Boat","Bicycle","Motorcycle","Plane","Train","Car","Scooter","Caravan"]
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        // Custom initialization
       //println("tokennn abovee1")
    }
    
    required init(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        println(AuthToken)
      ///  fetchContacts(AuthToken)
        
        //println("tokennn abovee2")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.titleView = viewForTitle
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: btnForLogo)
        self.navigationItem.rightBarButtonItem = itemForSearch
        self.tabBarController?.tabBar.tintColor = UIColor.greenColor()
        println("////////////////////// new class tokn \(AuthToken)")

        let username = Expression<String?>("username")
        //if sqliteDB.db["accounts"].count(username)<1
        //if AuthToken==""
        
        //everytime new login
        KeychainWrapper.removeObjectForKey("access_token")
        let retrievedToken=KeychainWrapper.stringForKey("access_token")
        if retrievedToken==nil
        {performSegueWithIdentifier("loginSegue", sender: nil)}
        else
        {println("rrrrrrrrr \(retrievedToken)")
            
            //performSegueWithIdentifier("loginSegue", sender: nil)
        }
      
        
       // Do any additional setup after loading the view.
       
        
    }
   
    override func viewWillAppear(animated: Bool) {
        
        fetchContacts(AuthToken)
        var db=DatabaseHandler(dbName: "abc.sqlite")
        
    }
    
    
    func fetchContacts(token:String){
        
        var fetchChatURL=Constants.MainUrl+Constants.getContactsList+"?access_token="+token
        
        println(fetchChatURL)
        
        Alamofire.request(.GET,"\(fetchChatURL)").response{
            
            request1, response1, data1, error1 in
            
            
            
            //============GOT Contacts SECCESS=================
            
            
                ////////////////////////
                dispatch_async(dispatch_get_main_queue(), {
                    //self.fetchContacts(self.AuthToken)
                    /// activityOverlayView.dismissAnimated(true)
                    
                    
                    if response1?.statusCode==200 {
                        //println("Contacts fetched success")
                         let contactsJsonObj = JSON(data: data1!)
                        println(contactsJsonObj)
                        //println(contactsJsonObj["userid"])
                        //let contact=JSON(contactsJsonObj["contactid"])
                        //   println(contact["firstname"])
                      println("Contactsss fetcheddddddd")
                        //var userr=contactsJsonObj["userid"]
                        // println(self.contactsJsonObj.count)
                        let contactid = Expression<String>("contactid")
                        let detailsshared = Expression<String>("detailsshared")
                        let unreadMessage = Expression<String>("unreadMessage")
                        let userid = Expression<String>("userid")
                        let firstname = Expression<String>("firstname")
                        let lastname = Expression<String>("lastname")
                        let email = Expression<String>("email")
                        let phone = Expression<String>("phone")
                        let username = Expression<String>("username")
                        let status = Expression<String>("status")
                        
                        
                        let tbl_contactslists=sqliteDB.db["contactslists"]
                        for var i=0;i<contactsJsonObj.count;i++
                        {
                        let insert=tbl_contactslists.insert(contactid<-contactsJsonObj[i]["contactid"]["_id"].string!,
                            detailsshared<-contactsJsonObj[i]["detailsshared"].string!,
                            //unreadMessage<-contactsJsonObj[i]["unreadMessage"].string!,
                            userid<-contactsJsonObj[i]["userid"].string!,
                            firstname<-contactsJsonObj[i]["contactid"]["firstname"].string!,
                            lastname<-contactsJsonObj[i]["contactid"]["lastname"].string!,
                            email<-contactsJsonObj[i]["contactid"]["email"].string!,
                            phone<-contactsJsonObj[i]["contactid"]["_id"].string!,
                            username<-contactsJsonObj[i]["contactid"]["username"].string!,
                            status<-contactsJsonObj[i]["contactid"]["status"].string!)
                        if let rowid = insert.rowid {
                            println("inserted id: \(rowid)")
                        } else if insert.statement.failed {
                            println("insertion failed: \(insert.statement.reason)")
                        }
                        }

                        
                        
                    } else {
                        println("FETCH CONTACTS FAILED")
                    }
                })
                
                
            
        }
        
    }

    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func unwindToChat (segueSelected : UIStoryboardSegue) {
        println("unwind chat")
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transportItems.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView!) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        
      /* if (indexPath.row%2 == 0){
            return tblForChat.dequeueReusableCellWithIdentifier("ChatPrivateCell") as! UITableViewCell
        } else {
            return tblForChat.dequeueReusableCellWithIdentifier("ChatPublicCell")as! UITableViewCell
        }
*/
        var cell=tblForChat.dequeueReusableCellWithIdentifier("ChatPrivateCell") as! ContactsListCell
        
        cell.contactName?.text=transportItems[indexPath.row]
        
        return cell
        
    }
    
    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!){
        self.performSegueWithIdentifier("contactChat", sender: nil);
        //slideToChat
    }

    
    
    
    // #pragma mark - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    /*override func prepareForSegue(segue: UIStoryboardSegue?, sender: AnyObject?) {
        //var newController=segue ?.destinationViewController
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        if segue!.identifier == "chatSegue" {
            if let destinationVC = segue!.destinationViewController as? ChatDetailViewController{
                destinationVC.AuthToken = self.AuthToken
            }
        }
    
    }*/
}


