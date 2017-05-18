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
    
    
    var swipeindexRow:Int!

    var indexForInfo = -1
    
    @IBOutlet weak var editButtonOutlet: UIBarButtonItem!
    
    @IBOutlet weak var navigationitem1: UINavigationItem!
    @IBOutlet weak var veiwForContent: UIScrollView!
    @IBOutlet weak var tblBroadcastList: UITableView!
    var broadcastlistmessages:NSMutableArray!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
        self.navigationitem1.title="Broadcast Lists".localized
        
        broadcastlistmessages=NSMutableArray()
        retrieveBroadCastLists()
        tblBroadcastList.reloadData()
       // self.navigationItem.titleView = "Broadcast Lists"
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
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
    
    func getRightUtilityButtonsToCell()-> NSMutableArray{
        let utilityButtons: NSMutableArray = NSMutableArray()
        
        
        //!!!utilityButtons.sw_addUtilityButton(with: UtilityFunctions.init().hexStringToUIColor("#DCDEE0"), icon: UIImage(named:"more.png".localized))
        
        //utilityButtons.sw_addUtilityButtonWithColor(UIColor.redColor(), title: NSLocalizedString("ABC", comment: ""))
        //DCDEE0
        utilityButtons.sw_addUtilityButton(with: UtilityFunctions.init().hexStringToUIColor("#24669A"), icon: UIImage(named:"archive.png".localized))
        return utilityButtons
        //24669A
    }
    
    
    
    func tableView(_ tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: IndexPath) {
        
        var messageDic = broadcastlistmessages.object(at: indexPath.row) as! [String : AnyObject];
        
        //// if editingStyle == .Delete {
        if(editingStyle == UITableViewCellEditingStyle.delete){
            
            var messageDic = broadcastlistmessages.object(at: indexPath.row) as! [String : String];
            var listname=messageDic["listname"] as! NSString
            var uniqueid=messageDic["uniqueid"] as! NSString
            
            var membersnames=messageDic["membersnames"] as! NSString
            
            sqliteDB.deleteBroadcastList(uniqueid as String)
            retrieveBroadCastLists()
            tblBroadcastList.reloadData()
            
            
    //delete
            
        }
        else{
            if(editingStyle == UITableViewCellEditingStyle.insert)
            {
          print("another swipe button")
            }
        }
    }
    func tableView(_ tableView: UITableView, canEditRowAtIndexPath indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    func retrieveBroadCastLists()
    {
      //listname string
      //membersnames string
       let broadcastlistmessages2=NSMutableArray()
        //uniqueid
        var aaa = sqliteDB.getBroadcastListDataForController()
        print("aaa is \(aaa.description)")
        for i in 0 ..< aaa.count
        {
        broadcastlistmessages2.add(["listname":aaa[i]["listname"] as! String,"membersnames":aaa[i]["membersnames"] as! String,"uniqueid":aaa[i]["uniqueid"] as! String])
        }
        
        broadcastlistmessages.setArray(broadcastlistmessages2 as [AnyObject])
        
    }
    
    @IBAction func btnNewBroadcastListClicked(_ sender: AnyObject) {
        
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
       
        
        
        self.performSegue(withIdentifier: "addParticipantsSegue", sender: self)
        
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
    
 
    @IBAction func backButtonPressed(_ sender: AnyObject) {
        print("unwind broadcast list")
        self.performSegue(withIdentifier: "FromBroadCastToChatTabSegue", sender: nil);
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
        participantsSelected.append(contentsOf: contacts)
        
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
        for i in 0 ..< participantsSelected.count
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return broadcastlistmessages.count
    }
    
   
    
    func numberOfSectionsInTableView(_ tableView: UITableView!) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAtIndexPath indexPath: IndexPath) -> CGFloat {
        
        return 90
    }
    
    
    func swipeableTableViewCell(_ cell: SWTableViewCell!, didTriggerRightUtilityButtonWith index: Int) {
        print("tapped swipe \(index)")
        swipeindexRow=tblBroadcastList.indexPath(for: cell)!.row
        // if(index==0)
        // {
        var messageDic = broadcastlistmessages.object(at: swipeindexRow) as! [String : AnyObject];
       /*
        let ContactsLastMsgDate = messageDic["ContactsLastMsgDate"] as! String
        let ContactLastMessage = messageDic["ContactLastMessage"] as! String
        let ContactLastNAme=messageDic["ContactLastNAme"] as! String
        var ContactNames=messageDic["ContactNames"] as! String
        let ContactStatus=messageDic["ContactStatus"] as! String
        let ContactUsernames=messageDic["ContactUsernames"] as! String
        let ContactOnlineStatus=messageDic["ContactOnlineStatus"] as! Int
        let ContactFirstname=messageDic["ContactFirstname"] as! String
        let ContactsPhone=messageDic["ContactsPhone"] as! String
        let ContactCountMsgRead=messageDic["ContactCountMsgRead"] as! Int
        let ContactsProfilePic=messageDic["ContactsProfilePic"] as! Data
        let ChatType=messageDic["ChatType"] as! NSString
        */
        print("RightUtilityButton index of more is \(index)")
        //if(editButtonOutlet.title==NSLocalizedString("Edit", tableName: nil, bundle: Bundle.main, value: "", comment: "Edit"))
        //"Edit")
        // {//UITableViewCellEditingStyle
        if(index==0)
        {
           
                sqliteDB.updateArchiveStatusBroadcast(bid: messageDic["uniqueid"] as! NSString, status: true)
               // var params=["id":ContactUsernames,"isArchived":"No"]
                //id
                //isArchived
                //UtilityFunctions.init().sendDataToDesktopApp(data1: params as AnyObject, type1: "chat_unarchive")
                
                DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.default).async
                    {
                        retrieveBroadCastLists()
                            //    DispatchQueue.main.async
                            //  {
                            // self.tblForChats.reloadData()
                            
                            //commenting newwwwwwww -===-===-=
                            DispatchQueue.main.async
                                {
                                    tblBroadcastList.reloadData()
                                    
                            }
                            }
            
                
                
            
        }
        //}
    }
    

    
    func tableView(_ tableView: UITableView!, cellForRowAtIndexPath indexPath: IndexPath!) -> UITableViewCell! {
        //if (indexPath.row%2 == 0){
        //var cellPrivate = tblForNotes.dequeueReusableCellWithIdentifier("NotePrivateCell")! as UITableViewCell
        var messageDic = broadcastlistmessages.object(at: indexPath.row) as! [String : String];
        let listname=messageDic["listname"] as! NSString
        var uniqueid=messageDic["uniqueid"] as! NSString
        
        let membersnames=messageDic["membersnames"] as! NSString
        
        let cell = tblBroadcastList.dequeueReusableCell(withIdentifier: "BroadcastListCell")! as! BroadcastItemCell
        cell.rightUtilityButtons=self.getRightUtilityButtonsToCell() as [AnyObject]
        cell.delegate=self
        
        if(listname == "")
        {let memberscount=membersnames.components(separatedBy: ",").count
        cell.lbl_recipents_count.text="Recipents:".localized+"\(memberscount)"
        }
        else{
            cell.lbl_recipents_count.text=listname as String
        }
        
        cell.lbl_recipentsName.text=membersnames as String
        cell.broadcastlist_info.addTarget(self, action: #selector(BroadcastListViewController.BtnBroadcastInfoClicked(_:)), for:.touchUpInside)
        
        //cell.lbl_recipentsName.text="Sojharo,Sumaira991"
        
        return cell
    }
    
    
       // if(msgType.isEqualToString("5")||msgType.isEqualToString("6")){
        
        
        //broadcastChatSegue
       // self.performSegueWithIdentifier("broadcastChatSegue", sender: nil);
        //===--self.performSegueWithIdentifier("showSingleBroadcastListCellSegue", sender: nil);
        //}
   // }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath)
    {
        self.performSegue(withIdentifier: "broadcastChatSegue", sender: nil);
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        //editlistsegue
        
        if segue.identifier == "addParticipantsSegue" {
            
            if let destinationVC = segue.destination as? AddParticipantsViewController{
                //destinationVC.participants.removeAll()
                destinationVC.prevScreen="newBroadcastList"
                //destinationVC.participants=self.participantsSelected
                //  let selectedRow = tblForChat.indexPathForSelectedRow!.row
                
            }}
        //broadcastChatSegue
        if segue.identifier == "broadcastChatSegue" {
            
            if let destinationVC = segue.destination as? ChatDetailViewController{
                
                let selectedRow = tblBroadcastList.indexPathForSelectedRow!.row
                var messageDic = broadcastlistmessages.object(at: selectedRow) as! [String : String];
                
                let uniqueid = messageDic["uniqueid"] as NSString!
                
                destinationVC.broadcastlistmessages=broadcastlistmessages
                destinationVC.broadcastlistID1=uniqueid as! String
                //destinationVC.participants.removeAll()
                //==destinationVC.prevScreen="newBroadcastList"
                //destinationVC.participants=self.participantsSelected
                //  let selectedRow = tblForChat.indexPathForSelectedRow!.row
                
            }}
        
        if segue.identifier == "showSingleBroadcastListCellSegue" {
            if let destinationVC = segue.destination as? BroadcastListDetailsViewController{
               // let selectedRow = tblBroadcastList.indexPathForSelectedRow!.row
                
                    let selectedRow = indexForInfo
                
                var messageDic = broadcastlistmessages.object(at: selectedRow) as! [String : String];
                
                let uniqueid = messageDic["uniqueid"] as NSString!
                //selectedText=filename as String
                //destinationVC.tabBarController?.selectedIndex=0
                //self.tabBarController?.selectedIndex=0
                print("broadcastlistID is \(uniqueid)")
                destinationVC.broadcastlistID=uniqueid as! String
                
                /*self.dismiss(true, completion: { () -> Void in
                    
                    
              
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
    
    func BtnBroadcastInfoClicked(_ sender:AnyObject!)
    { let buttonPosition = sender.convert(CGPoint.zero, to: tblBroadcastList)
        var indexPath = self.tblBroadcastList.indexPathForRow(at: buttonPosition)!
        self.indexForInfo=indexPath.row
self.performSegue(withIdentifier: "showSingleBroadcastListCellSegue", sender: nil);
        
    }

    //broadcastlistID
    
}
