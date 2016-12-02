//
//  BroadcastListViewController.swift
//
//
//  Created by Cloudkibo on 01/12/2016.
//
//

import Foundation
import UIKit
import ContactsUI
import Alamofire
import AssetsLibrary
import Photos

class BroadcastListViewController: UIViewController,UINavigationControllerDelegate,CNContactPickerDelegate,EPPickerDelegate,SWTableViewCellDelegate,UIImagePickerControllerDelegate {
    
    
    @IBOutlet weak var navigationitem1: UINavigationItem!
    @IBOutlet weak var veiwForContent: UIScrollView!
    @IBOutlet weak var tblBroadcastList: UITableView!
    var broadcastlistmessages:NSMutableArray!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tblBroadcastList.estimatedRowHeight = 95.0;
        self.tblBroadcastList.rowHeight = UITableViewAutomaticDimension;
        
        self.navigationItem.leftBarButtonItem?.title="<"
        self.navigationitem1.title="Broadcast Lists"
        
        broadcastlistmessages=NSMutableArray()
       // self.navigationItem.titleView = "Broadcast Lists"
    }
    
    required init?(coder aDecoder: NSCoder){
        
        super.init(coder: aDecoder)
    }
    
    func retrieveBroadCastLists()
    {
      //listname string
      //membersnames string
       var broadcastlistmessages2=NSMutableArray()
        var aaa = sqliteDB.getBroadcastListDataForController()
        for(var i=0;i<aaa.count;i++)
        {
        broadcastlistmessages2.addObject(["listname":aaa[i]["listname"] as! String,"membersnames":aaa[i]["membersnames"] as! String])
        }
        
        broadcastlistmessages.setArray(broadcastlistmessages2 as [AnyObject])
        
    }
    
    @IBAction func btnNewBroadcastListClicked(sender: AnyObject) {
        
        //making new list so removing old data
        participantsSelected.removeAll()
        
        //add participants clicked
       /* var identifiersarray=[String]()
        for(var i=0;i<membersArrayOfGroup.count;i++)
        {
            var identifier=sqliteDB.getIdentifierFRomPhone(membersArrayOfGroup[i]["member_phone"] as! String)
            if(identifier != "")
            {
                identifiersarray.append(identifier)
            }
        }*/
        
        let contactPickerScene = EPContactsPicker(delegate: self, multiSelection:true, subtitleCellType: SubtitleCellValue.PhoneNumber)
        let navigationController = UINavigationController(rootViewController: contactPickerScene)
        self.presentViewController(navigationController, animated: true, completion: nil)
        
        
        
        participantsSelected.removeAll()
        print("BtnnewBroadcastListClicked")
        picker = CNContactPickerViewController();
        picker.title="Recipients"
        picker.navigationItem.leftBarButtonItem=picker.navigationController?.navigationItem.backBarButtonItem
        
        picker.predicateForEnablingContact = NSPredicate.init(value: true) //.fromValue(true); // make everything selectable
        
        // Respond to selection
        picker.delegate = self;
        
        //=====addmemberfailed=true
        self.presentViewController(picker, animated: true, completion: nil)
        
        
        
        // Display picker
        
        // UIApplication.sharedApplication().keyWindow!.rootViewController!.presentViewController(picker, animated: true, completion: nil);
        
        
    }
    
    
    func epContactPicker(_: EPContactsPicker, didContactFetchFailed error : NSError)
    {
        print("Failed with error \(error.description)")
    }
    
    func epContactPicker(_: EPContactsPicker, didSelectContact contact : EPContact)
    {
        print("Contact \(contact.displayName()) has been selected")
    }
    
    func epContactPicker(_: EPContactsPicker, didCancel error : NSError)
    {
        print("User canceled the selection");
    }
    
    
    
    func epContactPicker(_: EPContactsPicker, didSelectMultipleContacts contacts: [EPContact]) {
        print("The following contacts are selected")
        
        
        
        print("didSelectContacts \(contacts)")
        
        //get seleced participants
        participantsSelected.appendContentsOf(contacts)
        
        addToBroadcastList()
        
        
        ///// self.performSegueWithIdentifier("newGroupDetailsSegue2", sender: nil);
        
        
        for contact in contacts {
            print("\(contact.displayName())")
        }
    }
    
    func addToBroadcastList()
    {
        
        var memberphones=[String]()
        var membersnames=[String]()
        for(var i=0;i<participantsSelected.count;i++)
        {
            memberphones.append(participantsSelected[i].getPhoneNumber())
            membersnames.append(participantsSelected[i].displayName())
            //self.messages.addObject(["member_phone":memberphones[i],"name":membersnames[i],"isAdmin":"No"])
            
            //tblGroupInfo.reloadData()
            
        }
        
        var broadcastlistID=UtilityFunctions.init().generateUniqueid()
        sqliteDB.storeBroadcastList(broadcastlistID, ListName1: "")
        sqliteDB.storeBroadcastListMembers(broadcastlistID, memberphones: memberphones)
        retrieveBroadCastLists()
        tblBroadcastList.reloadData()
        
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return broadcastlistmessages.count
    }
    
   
    
    func numberOfSectionsInTableView(tableView: UITableView!) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        //if (indexPath.row%2 == 0){
        //var cellPrivate = tblForNotes.dequeueReusableCellWithIdentifier("NotePrivateCell")! as UITableViewCell
        var messageDic = broadcastlistmessages.objectAtIndex(indexPath.row) as! [String : String];
        var listname=messageDic["listname"] as! NSString
        var membersnames=messageDic["membersnames"] as! NSString
        
        var cell = tblBroadcastList.dequeueReusableCellWithIdentifier("BroadcastListCell")! as! BroadcastItemCell
        if(listname == "")
        {var memberscount=membersnames.componentsSeparatedByString(",").count
        cell.lbl_recipents_count.text="Recipents:\(memberscount)"
        }
        else{
            cell.lbl_recipents_count.text=listname as! String
        }
        cell.lbl_recipentsName.text=membersnames as String
        
        //cell.lbl_recipentsName.text="Sojharo,Sumaira991"
        
        return cell
    }
    
}