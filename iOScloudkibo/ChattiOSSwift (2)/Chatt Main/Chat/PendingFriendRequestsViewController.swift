//
//  PendingFriendRequestsViewController.swift
//  Chat
//
//  Created by Cloudkibo on 17/09/2015.
//  Copyright (c) 2015 MyAppTemplates. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SQLite

class PendingFriendRequestsViewController: UIViewController {

    @IBOutlet weak var tbl_pendingContacts: UITableView!
    var pendingContactsNames:[String]=[]
    var pendingContactsObj:[JSON]=[]
    var ContactIDs:[String]=[]
    var ContactLastNAme:[String]=[]
    var ContactFirstNAme:[String]=[]
    var ContactNames:[String]=[]
    var ContactStatus:[String]=[]
    var ContactUsernames:[String]=[]
    var ContactsObjectss:[JSON]=[]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if loggedUserObj==""
        {
            if let loggd=KeychainWrapper.objectForKey("loggedUserObj")
            {
                loggedUserObj=JSON(loggd)
            }
        }
        
        loadPendingRequests()
        // Do any additional setup after loading the view.
       socketObj.socket.on("friendrequest"){data,ack in
            println("friend request socket received")
            var freindReqJSON=JSON(data!)
            println(freindReqJSON)
        println("$$$$$$$$$$")
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
        
        
        let tbl_contactslists=sqliteDB.db["contactslists"]
        
        //-========Remove old values=====================
       
        for var i=0;i<freindReqJSON.count;i++
        {
            let insert=tbl_contactslists.insert(contactid<-freindReqJSON[i]["contactid"]["_id"].string!,
                detailsshared<-freindReqJSON[i]["detailsshared"].string!,
                
                unreadMessage<-freindReqJSON[i]["unreadMessage"].boolValue,
                
                userid<-freindReqJSON[i]["userid"].string!,
                firstname<-freindReqJSON[i]["contactid"]["firstname"].string!,
                lastname<-freindReqJSON[i]["contactid"]["lastname"].string!,
                email<-freindReqJSON[i]["contactid"]["email"].string!,
                phone<-freindReqJSON[i]["contactid"]["_id"].string!,
                username<-freindReqJSON[i]["contactid"]["username"].string!,
                status<-freindReqJSON[i]["contactid"]["status"].string!)
            
            //self.transportItems.insert(contactsJsonObj[i]["contactid"]["firstname"].string!+" "+contactsJsonObj[i]["contactid"]["lastname"].string!, atIndex: i)
            
            self.ContactsObjectss.append(freindReqJSON[i]["contactid"])
            self.ContactNames.append(freindReqJSON[i]["contactid"]["firstname"].string!+" "+freindReqJSON[i]["contactid"]["lastname"].string!)
            self.ContactUsernames.append(freindReqJSON[i]["contactid"]["username"].string!)
            self.ContactIDs.append(freindReqJSON[i]["contactid"]["_id"].string!)
            self.ContactFirstNAme.append(freindReqJSON[i]["contactid"]["firstname"].string!)
            self.ContactLastNAme.append(freindReqJSON[i]["contactid"]["lastname"].string!)
            self.ContactStatus.append(freindReqJSON[i]["contactid"]["status"].string!)
            if let rowid = insert.rowid {
                println("inserted id: \(rowid)")
                self.tbl_pendingContacts.reloadData()
            } else if insert.statement.failed {
                println("insertion failed: \(insert.statement.reason)")
            }
        //saveContact()
        }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    
    func loadPendingRequests()
    {
        //var pendingReqHTTP=NetworkingLibAlamofire()
        var url=Constants.MainUrl+Constants.getPendingFriendRequestsContacts+"?access_token=\(AuthToken!)"
       //println(pendingList.description)
       // println(pendingList.count)
        Alamofire.request(.GET,"\(url)").responseJSON{
            request1, response1, data1, error1 in
            
            //===========INITIALISE SOCKETIOCLIENT=========
            dispatch_async(dispatch_get_main_queue(), {
                
                //self.dismissViewControllerAnimated(true, completion: nil);
                /// self.performSegueWithIdentifier("loginSegue", sender: nil)
                
                if response1?.statusCode==200 {
                    println("Request success")
                    var json=JSON(data1!)
                    for(var i=0;i<json.count;i++){
                        //println(json[i])
                    self.pendingContactsNames.append(json[i]["userid"]["username"].string!)
                        self.pendingContactsObj.append(json[i]["userid"])
                        println(".,.,.,.,.,><><><>....")
                        println(json[i])
                    }
                    self.tbl_pendingContacts.reloadData()
                    //self.dataMy=JSON(data1!)
                    //println(data1!.description)
                    //println(self.dataMy)
                    //println(dataMy.description)
                    
                    
                }
                else
                {
                    println("request failed")
                   // self.errorMy=JSON(error1!)
                    //println(errorMy.description)
                    
                }
            })
        }

        
    }
    
    @IBAction func unwindToChat (segueSelected : UIStoryboardSegue) {
        println("unwind chat")
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //refreshControl.addTarget(self, action: Selector("fetchContacts"), forControlEvents: UIControlEvents.ValueChanged)
        
        println(pendingContactsNames.count)
        return pendingContactsNames.count
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
        var cell=tbl_pendingContacts.dequeueReusableCellWithIdentifier("ChatPrivateCell") as! PendingRequestsListCell
        
        cell.labelFriendName.text=pendingContactsNames[indexPath.row]
        
        
        return cell
        
    }
    
    /*func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .Delete, title: "Delete") { (action, indexPath) in
            // delete item at indexPath
        }
        
        let share = UITableViewRowAction(style: .Normal, title: "Disable") { (action, indexPath) in
            // share item at indexPath
        }
        
        share.backgroundColor = UIColor.blueColor()
        
        return [delete, share]
    }
*/
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject]? {
        var selectedRow = indexPath.row
        let Delete = UITableViewRowAction(style: .Normal, title: "Delete") { action, index in
            println("reject button tapped")
            //var selectedRow = indexPath.row
            
            println("inside delete old func")
           
            var url=Constants.MainUrl+Constants.rejectPendingFriendRequest+"?access_token=\(AuthToken!)"
            var usernameToReject=self.pendingContactsObj[selectedRow]["username"]
            //var params=self.ContactsObjectss[selectedRow].arrayValue
            Alamofire.request(.POST,"\(url)",parameters:["username":"\(usernameToReject)"]
                //Alamofire.request(.POST,"\(url)",parameters:["index":"\(selectedRow)"]
                ).responseJSON{
                    request1, response1, data1, error1 in
                    
                    //===========INITIALISE SOCKETIOCLIENT=========
                    dispatch_async(dispatch_get_main_queue(), {
                        
                        //self.dismissViewControllerAnimated(true, completion: nil);
                        /// self.performSegueWithIdentifier("loginSegue", sender: nil)
                        
                        if response1?.statusCode==200 {
                            //println("got user success")
                            println("Request successfully rejected")
                            self.pendingContactsNames.removeAtIndex(selectedRow)
                            var json=JSON(data1!)
                            
                            
                            println(json)
                            self.tbl_pendingContacts.reloadData()
                            
                        }
                        else
                        {
                            println("request failed")
                            //var json=JSON(error1!)
                            println(error1?.description)
                            println(response1?.statusCode)
                            
                        }
                    })
            }
            
            
        }
        
    Delete.backgroundColor = UIColor.redColor()
    
        let accept = UITableViewRowAction(style: .Normal, title: "Accept") { action, index in
            println("accept button tapped")
            
            var url=Constants.MainUrl+Constants.approvePendingFriendRequest+"?access_token=\(AuthToken!)"
            var usernameToReject=self.pendingContactsObj[selectedRow]["username"]
            //var params=self.ContactsObjectss[selectedRow].arrayValue
            Alamofire.request(.POST,"\(url)",parameters:["username":"\(usernameToReject)"]
                //Alamofire.request(.POST,"\(url)",parameters:["index":"\(selectedRow)"]
                ).responseJSON{
                    request1, response1, data1, error1 in
                    
                    //===========INITIALISE SOCKETIOCLIENT=========
                    dispatch_async(dispatch_get_main_queue(), {
                        
                        //self.dismissViewControllerAnimated(true, completion: nil);
                        /// self.performSegueWithIdentifier("loginSegue", sender: nil)
                        
                        if response1?.statusCode==200 {
                            //println("got user success")
                            println("Request successfully rejected")
                            self.pendingContactsNames.removeAtIndex(selectedRow)
                            var json=JSON(data1!)
                            
                            
                            println(json)
                            self.tbl_pendingContacts.reloadData()
                            
                        }
                        else
                        {
                            println("request failed")
                            //var json=JSON(error1!)
                            println(error1?.description)
                            println(response1?.statusCode)
                            
                        }
                    })
            }
            

            
        }
        accept.backgroundColor = UIColor.grayColor()
    
        
        return [Delete, accept]
    }
    

    
    //=====Accept or Deny Annimation------------------------=============
   func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
       
      /*
        if editingStyle == .Delete {
            
            println("inside delete old func")
            var selectedRow = indexPath.row
            println(selectedRow.description+" selected")
            
            
            var url=Constants.MainUrl+Constants.rejectPendingFriendRequest+"?access_token=\(AuthToken)"
            var usernameToReject=self.pendingContactsObj[selectedRow]["username"]
            //var params=self.ContactsObjectss[selectedRow].arrayValue
            Alamofire.request(.POST,"\(url)",parameters:["username":"\(usernameToReject)"]
            //Alamofire.request(.POST,"\(url)",parameters:["index":"\(selectedRow)"]
                ).responseJSON{
                    request1, response1, data1, error1 in
                    
                    //===========INITIALISE SOCKETIOCLIENT=========
                    dispatch_async(dispatch_get_main_queue(), {
                        
                        //self.dismissViewControllerAnimated(true, completion: nil);
                        /// self.performSegueWithIdentifier("loginSegue", sender: nil)
                        
                        if response1?.statusCode==200 {
                            //println("got user success")
                            println("Request successfully rejected")
                            self.pendingContactsNames.removeAtIndex(selectedRow)
                            var json=JSON(data1!)
                            
                            
                            println(json)
                            self.tbl_pendingContacts.reloadData()
                             
                        }
                        else
                        {
                            println("request failed")
                            //var json=JSON(error1!)
                            println(error1?.description)
                            println(response1?.statusCode)
                            
                        }
                    })
            }
                   } else if editingStyle == .Insert {
            
                
            
            println("hi")
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }*/
    }

    func saveContact()
    {
        
        
    }
    
   /* func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!){
        
        //let indexPath = tableView.indexPathForSelectedRow();
        //let currentCell = tableView.cellForRowAtIndexPath(indexPath!) as UITableViewCell!;
        
        //println(ContactNames[indexPath.row])
        self.performSegueWithIdentifier("pendingRequestSegue", sender: nil);
        //slideToChat
        
    }
*/

}
