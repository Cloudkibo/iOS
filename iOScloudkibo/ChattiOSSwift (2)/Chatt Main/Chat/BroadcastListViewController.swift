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
    
    
    var indexForInfo = -1
    
    @IBOutlet weak var editButtonOutlet: UIBarButtonItem!
    
    @IBOutlet weak var navigationitem1: UINavigationItem!
    @IBOutlet weak var veiwForContent: UIScrollView!
    @IBOutlet weak var tblBroadcastList: UITableView!
    var broadcastlistmessages:NSMutableArray!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.navigationItem.rightBarButtonItem = self.editButtonItem();
        //==--editButtonOutlet=self.editButtonOutlet
        /*if(tblBroadcastList.editing.boolValue==false)
        {
            editButtonOutlet.title="Edit"
            self.navigationItem.leftBarButtonItem!.title = "Edit"
        }
        else
        {
            editButtonOutlet.title="Done"
            self.navigationItem.leftBarButtonItem!.title = "Done"
        }*/
        
        self.tblBroadcastList.estimatedRowHeight = 125.0;
        self.tblBroadcastList.rowHeight = UITableViewAutomaticDimension;
        
        self.navigationItem.leftBarButtonItem?.title="<"
        self.navigationitem1.title="Broadcast Lists"
        
        broadcastlistmessages=NSMutableArray()
        retrieveBroadCastLists()
        tblBroadcastList.reloadData()
       // self.navigationItem.titleView = "Broadcast Lists"
    }
    
    override func setEditing(editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tblBroadcastList.setEditing(editing, animated: animated)
        print("editingggg....2")
        
        tblBroadcastList.reloadData()
    }
    
    required init?(coder aDecoder: NSCoder){
        
        super.init(coder: aDecoder)
    }
    
    
    
   /* @IBAction func btneditBroadcastItemClicked(sender: AnyObject) {
        
        tblBroadcastList.setEditing(true, animated: true)
    }
    */
    
    
    
    
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        var messageDic = broadcastlistmessages.objectAtIndex(indexPath.row) as! [String : AnyObject];
        
        //// if editingStyle == .Delete {
        if(editingStyle == UITableViewCellEditingStyle.Delete){
            
            var messageDic = broadcastlistmessages.objectAtIndex(indexPath.row) as! [String : String];
            var listname=messageDic["listname"] as! NSString
            var uniqueid=messageDic["uniqueid"] as! NSString
            
            var membersnames=messageDic["membersnames"] as! NSString
            
            sqliteDB.deleteBroadcastList(uniqueid as String)
            retrieveBroadCastLists()
            tblBroadcastList.reloadData()
            
            
    //delete
            
        }
    }
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    func retrieveBroadCastLists()
    {
      //listname string
      //membersnames string
       var broadcastlistmessages2=NSMutableArray()
        //uniqueid
        var aaa = sqliteDB.getBroadcastListDataForController()
        print("aaa is \(aaa.description)")
        for(var i=0;i<aaa.count;i++)
        {
        broadcastlistmessages2.addObject(["listname":aaa[i]["listname"] as! String,"membersnames":aaa[i]["membersnames"] as! String,"uniqueid":aaa[i]["uniqueid"] as! String])
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
        
        //commenting for testing
       
        
        
        self.performSegueWithIdentifier("addParticipantsSegue", sender: self)
        
        /*let contactPickerScene = EPContactsPicker(delegate: self, multiSelection:true, subtitleCellType: SubtitleCellValue.PhoneNumber)
        let navigationController = UINavigationController(rootViewController: contactPickerScene)
        self.presentViewController(navigationController, animated: true, completion: nil)
 
        
        
        participantsSelected.removeAll()
        print("BtnnewBroadcastListClicked")
        picker = CNContactPickerViewController();
        picker.displayedPropertyKeys=[CNContactGivenNameKey, CNContactFamilyNameKey, CNContactEmailAddressesKey, CNContactPhoneNumbersKey, CNContactImageDataAvailableKey,CNContactThumbnailImageDataKey, CNContactImageDataKey]
        
        picker.title="Recipients"
        picker.navigationItem.leftBarButtonItem=picker.navigationController?.navigationItem.backBarButtonItem
        
        picker.predicateForEnablingContact = NSPredicate.init(value: true) //.fromValue(true); // make everything selectable
        
        // Respond to selection
        picker.delegate = self;
        
        //=====addmemberfailed=true
        self.presentViewController(picker, animated: true, completion: nil)
        */
        
        
        // Display picker
        
        // UIApplication.sharedApplication().keyWindow!.rootViewController!.presentViewController(picker, animated: true, completion: nil);
        
        
    }
    
 
    @IBAction func backButtonPressed(sender: AnyObject) {
        print("unwind broadcast list")
        self.performSegueWithIdentifier("FromBroadCastToChatTabSegue", sender: nil);
    }
   
    
    /*@IBAction func prepareForUnwind(segue: UIStoryboardSegue){
       // if(prevScreen=="newBroadcastList")
        //{
        print("unwind broadcast list")
            self.performSegueWithIdentifier("GoToBroadCastSegue", sender: nil);
        //}
        
    }*/
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
        participantsSelected.removeAll()
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
        {print("appending memberphone now of participantselected \(participantsSelected[i].getPhoneNumber())")
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
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 90
    }

    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        //if (indexPath.row%2 == 0){
        //var cellPrivate = tblForNotes.dequeueReusableCellWithIdentifier("NotePrivateCell")! as UITableViewCell
        var messageDic = broadcastlistmessages.objectAtIndex(indexPath.row) as! [String : String];
        var listname=messageDic["listname"] as! NSString
        var uniqueid=messageDic["uniqueid"] as! NSString
        
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
        cell.broadcastlist_info.addTarget(self, action: Selector("BtnBroadcastInfoClicked:"), forControlEvents:.TouchUpInside)
        
        //cell.lbl_recipentsName.text="Sojharo,Sumaira991"
        
        return cell
    }
    
    
       // if(msgType.isEqualToString("5")||msgType.isEqualToString("6")){
        
        
        //broadcastChatSegue
       // self.performSegueWithIdentifier("broadcastChatSegue", sender: nil);
        //===--self.performSegueWithIdentifier("showSingleBroadcastListCellSegue", sender: nil);
        //}
   // }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        self.performSegueWithIdentifier("broadcastChatSegue", sender: nil);
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        //editlistsegue
        
        if segue.identifier == "addParticipantsSegue" {
            
            if let destinationVC = segue.destinationViewController as? AddParticipantsViewController{
                //destinationVC.participants.removeAll()
                destinationVC.prevScreen="newBroadcastList"
                //destinationVC.participants=self.participantsSelected
                //  let selectedRow = tblForChat.indexPathForSelectedRow!.row
                
            }}
        //broadcastChatSegue
        if segue.identifier == "broadcastChatSegue" {
            
            if let destinationVC = segue.destinationViewController as? ChatDetailViewController{
                
                let selectedRow = tblBroadcastList.indexPathForSelectedRow!.row
                var messageDic = broadcastlistmessages.objectAtIndex(selectedRow) as! [String : String];
                
                let uniqueid = messageDic["uniqueid"] as NSString!
                
                destinationVC.broadcastlistmessages=broadcastlistmessages
                destinationVC.broadcastlistID1=uniqueid as String
                //destinationVC.participants.removeAll()
                //==destinationVC.prevScreen="newBroadcastList"
                //destinationVC.participants=self.participantsSelected
                //  let selectedRow = tblForChat.indexPathForSelectedRow!.row
                
            }}
        
        if segue.identifier == "showSingleBroadcastListCellSegue" {
            if let destinationVC = segue.destinationViewController as? BroadcastListDetailsViewController{
               // let selectedRow = tblBroadcastList.indexPathForSelectedRow!.row
                
                    let selectedRow = indexForInfo
                
                var messageDic = broadcastlistmessages.objectAtIndex(selectedRow) as! [String : String];
                
                let uniqueid = messageDic["uniqueid"] as NSString!
                //selectedText=filename as String
                //destinationVC.tabBarController?.selectedIndex=0
                //self.tabBarController?.selectedIndex=0
                print("broadcastlistID is \(uniqueid)")
                destinationVC.broadcastlistID=uniqueid as String
                
                /*self.dismissViewControllerAnimated(true, completion: { () -> Void in
                    
                    
              
                    })*/
            }
        }
        //groupChatStartSegue
       /* if segue.identifier == "groupChatStartSegue" {
            
            if let destinationVC = segue.destinationViewController as? BroadcastListDetailsViewController{
               // destinationVC.mytitle=groupname
                destinationVC.broadcastlistID=uniqueid
                //destinationVC.navigationItem.leftBarButtonItem?.enabled=false
                //destinationVC.navigationItem.rightBarButtonItem?.image=nil
                //destinationVC.navigationItem.rightBarButtonItem?.enabled=false
            }}*/
    }
    
    func BtnBroadcastInfoClicked(sender:AnyObject!)
    { var buttonPosition = sender.convertPoint(CGPointZero, toView: tblBroadcastList)
        var indexPath = self.tblBroadcastList.indexPathForRowAtPoint(buttonPosition)!
        self.indexForInfo=indexPath.row
self.performSegueWithIdentifier("showSingleBroadcastListCellSegue", sender: nil);
        
    }

    //broadcastlistID
    
}
