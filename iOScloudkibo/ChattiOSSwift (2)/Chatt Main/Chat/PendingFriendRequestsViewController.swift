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

class PendingFriendRequestsViewController: UIViewController {

    @IBOutlet weak var tbl_pendingContacts: UITableView!
    var pendingContactsNames:[String]=[]
    
    override func viewDidLoad() {
        super.viewDidLoad()
loadPendingRequests()
        // Do any additional setup after loading the view.
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
        var url=Constants.MainUrl+Constants.getPendingFriendRequestsContacts+"?access_token=\(AuthToken)"
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
    
   /* func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!){
        
        //let indexPath = tableView.indexPathForSelectedRow();
        //let currentCell = tableView.cellForRowAtIndexPath(indexPath!) as UITableViewCell!;
        
        //println(ContactNames[indexPath.row])
        self.performSegueWithIdentifier("pendingRequestSegue", sender: nil);
        //slideToChat
        
    }
*/

}
