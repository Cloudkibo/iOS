//
//  RenameGroupViewController.swift
//  kiboApp
//
//  Created by Cloudkibo on 27/04/2017.
//  Copyright © 2017 MyAppTemplates. All rights reserved.
//

import UIKit
import Alamofire
import Foundation
class RenameGroupViewController: UIViewController,UITextFieldDelegate {

    var internetavailable=false
    var groupid=""
    var oldgroupname=""
    @IBOutlet weak var btnCancel: UIBarButtonItem!
   // @IBOutlet weak var tblRenameGroup: UITableView!
    @IBOutlet weak var btnDone: UIBarButtonItem!
    @IBOutlet weak var txtFieldGroupName: UITextField!
    @IBOutlet weak var lblCount: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        NotificationCenter.default.addObserver(self, selector: #selector(RenameGroupViewController.checkForReachability(_:)),name: ReachabilityChangedNotification,object: reachability)
        
        // Do any additional setup after loading the view.
    }

    @IBAction func txtChanged(_ sender: UITextField) {
        print("txtchanged..")
        lblCount.text="\(sender.text!.characters.count)"
        if(oldgroupname==sender.text! || sender.text! == nil)
        {
            btnDone.isEnabled=false
        }
        else{
            btnDone.isEnabled=true
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func changingText(_ sender: UITextField) {
        
        if(oldgroupname==sender.text! || sender.text! == nil)
        {
            btnDone.isEnabled=false
        }
        else{
            btnDone.isEnabled=true
        }
    }
    
    @IBAction func donePressed(_ sender: Any) {
        if(internetAvailable==true)
        {
        self.renameGroup(groupid: groupid,newname: txtFieldGroupName.text!)
        }
        else{
            let shareMenu = UIAlertController(title: nil, message: "Internet connectivity is required to change group name".localized, preferredStyle: .actionSheet)
            
            let yes = UIAlertAction(title: "OK".localized, style: UIAlertActionStyle.default,handler: { (action) -> Void in
                
            })
            shareMenu.addAction(yes)
            self.present(shareMenu, animated: true, completion:nil)
        }
    
        }

    

    func checkForReachability(_ notification:Notification)
    {
        print("checking internet")
        // Remove the next two lines of code. You cannot instantiate the object
        // you want to receive notifications from inside of the notification
        // handler that is meant for the notifications it emits.
        
        //var networkReachability = Reachability.reachabilityForInternetConnection()
        //networkReachability.startNotifier()
        
        let networkReachability = notification.object as! Reachability;
        var remoteHostStatus = networkReachability.currentReachabilityStatus
        
        if (remoteHostStatus == Reachability.NetworkStatus.notReachable)
        {
            print("Not Reachable")
            internetAvailable = false
        }
        else if (remoteHostStatus == Reachability.NetworkStatus.reachableViaWiFi)
        {
            print("Reachable via Wifi")
            if(username != nil && username != "")
            {
                //self.synchroniseChatData()
                internetAvailable=true
            }
        }
        else
        {
            print("Reachable")
            if(username != nil && username != "")
            {
                //self.synchroniseChatData()
                internetAvailable=true
            }
        }
    }
    
    @IBAction func btnCancelPressed(_ sender: Any) {
        if let nav = self.navigationController {
            nav.popViewController(animated: true)
        }
        else{
        self.dismiss(animated: true,completion:nil)    }
    }
    
    func renameGroup(groupid:String,newname:String)
    {
        var url=Constants.MainUrl+Constants.updateGroupName
        
        let request = Alamofire.request("\(url)", method: .post, parameters:["group_name":newname, "unique_id":groupid],encoding: JSONEncoding.default,headers:header).responseJSON { response in
        
            print("Update GRoup name called")
            if(response.result.isSuccess)
            {
                print("group name changed success")
                sqliteDB.updateGroupname(groupid:groupid,newname:newname)
                var uniqueid1=UtilityFunctions.init().generateUniqueid()
                
                sqliteDB.storeGroupsChat("Log:", group_unique_id1: groupid, type1: "log", msg1: "You changed the subject to \(newname)", from_fullname1: "", date1: Date(), unique_id1: uniqueid1)
                if let nav = self.navigationController {
                    nav.popViewController(animated: true)
                }
                else{
                self.dismiss(animated: true,completion:nil)
                }
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
