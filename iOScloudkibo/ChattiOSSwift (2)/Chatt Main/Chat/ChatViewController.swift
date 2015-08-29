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

        if AuthToken==""
        {performSegueWithIdentifier("loginSegue", sender: nil)}
      
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
                        // let contactsJsonObj = JSON(data: data1!)
                        //println(contactsJsonObj["userid"])
                        //let contact=JSON(contactsJsonObj["contactid"])
                        //   println(contact["firstname"])
                      println("Contactsss fetcheddddddd")
                        //var userr=contactsJsonObj["userid"]
                        // println(self.contactsJsonObj.count)
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


