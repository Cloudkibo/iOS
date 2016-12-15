//
//  BroadcastListDetailsViewController.swift
//  kiboApp
//
//  Created by Cloudkibo on 07/12/2016.
//  Copyright © 2016 MyAppTemplates. All rights reserved.
//

import UIKit
import Contacts
import ContactsUI
import SQLite
import Haneke

class BroadcastListDetailsViewController: UIViewController,UINavigationControllerDelegate,UITextFieldDelegate {

    
    var broadcastmembers=[String]()
    var broadcastlistID=""
    var membersnames=[String]()
    var memberavatars=[NSData]()
    @IBOutlet weak var tblForBroadcastList: UITableView!
    
    required init?(coder aDecoder: NSCoder){
        
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //memberphone
        //uniqueid
        
       /* broadcastmembers=sqliteDB.getBroadcastListMembers(broadcastlistID)
        
        for(var i=0;i<broadcastmembers.count;i++)
        {
            membersnames.append(sqliteDB.getNameFromAddressbook(broadcastmembers[i]))
        }*/
        // Do any additional setup after loading the view.
    }
    let uniqueidentifier = Expression<String>("uniqueidentifier")

    override func viewWillAppear(animated: Bool) {
       broadcastmembers=sqliteDB.getBroadcastListMembers(broadcastlistID)
        
        for(var i=0;i<broadcastmembers.count;i++)
        {
            membersnames.append(sqliteDB.getNameFromAddressbook(broadcastmembers[i]))
            
            
            var joinrows=self.leftJoinContactsTables(broadcastmembers[i])
            
            if(joinrows.count>0)
            {print(joinrows.debugDescription)
                print("found uniqueidentifier from join in broadcast list is \(joinrows[0].get(uniqueidentifier))")
                //==========----------let queryPic = tbl_allcontacts.filter(tbl_allcontacts[phone] == ccc[contactPhone])
                
                //do{
                //=======------- for picquery in try sqliteDB.db.prepare(queryPic) {
                
                let contactStore = CNContactStore()
                
                var keys = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactEmailAddressesKey, CNContactPhoneNumbersKey, CNContactImageDataAvailableKey,CNContactThumbnailImageDataKey, CNContactImageDataKey]
                //--- var foundcontact=try contactStore.unifiedContactWithIdentifier(picquery[uniqueidentifier], keysToFetch: keys)
                do{var foundcontact=try contactStore.unifiedContactWithIdentifier(joinrows[0].get(uniqueidentifier), keysToFetch: keys)
                
                if(foundcontact.imageDataAvailable==true)
                {
                    //foundcontact.imageData
                    memberavatars.append(foundcontact.imageData!)
                   // ContactsProfilePic=foundcontact.imageData!
                    //picfound=true
                }
                else{
                    memberavatars.append(NSData.init())
                }
                
                
            }
                catch
                {
                    
                }
           
            }
            else{
                
                
                self.memberavatars.append(NSData.init())
            }
            
        }
        print(")count for broadcast members is \(broadcastmembers.count+1)")
        tblForBroadcastList.reloadData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func leftJoinContactsTables(phone1:String)->Array<Row>
    {
        print("inside broadcast messages leftjoin \(phone1)")
        var resultrow=Array<Row>()
        let name = Expression<String>("name")
        let phone = Expression<String>("phone")
        let actualphone = Expression<String>("actualphone")
        let email = Expression<String>("email")
        let kiboContact = Expression<Bool>("kiboContact")
        /////////////////////let profileimage = Expression<NSData>("profileimage")
        let uniqueidentifier = Expression<String>("uniqueidentifier")
        //
        var allcontacts = sqliteDB.allcontacts
        //========================================================
        let contactid = Expression<String>("contactid")
        let detailsshared = Expression<String>("detailsshared")
        let unreadMessage = Expression<Bool>("unreadMessage")
        
        let userid = Expression<String>("userid")
        let firstname = Expression<String>("firstname")
        let lastname = Expression<String>("lastname")
        //---let email = Expression<String>("email")
        //--- let phone = Expression<String>("phone")
        let username = Expression<String>("username")
        let status = Expression<String>("status")
        
        var contactslists = sqliteDB.contactslists
        //=================================================
        var joinquery=allcontacts.join(.LeftOuter, contactslists, on: contactslists[phone] == allcontacts[phone]).filter(allcontacts[phone]==phone1)
        
        do{for joinresult in try sqliteDB.db.prepare(joinquery) {
            
            resultrow.append(joinresult)
            }
        }
        catch{
            print("error in join query \(error)")
        }
        return resultrow
        
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(section==0)
        {
            return 1
        }
        else{
        return broadcastmembers.count+1
        }
    }
    
    
    
    func numberOfSectionsInTableView(tableView: UITableView!) -> Int {
        return 2
    }
    
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if(section==0)
        {
            return " "
        }
        else
        {
            return "List Recipients"
        }
        
        
    }

    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 68    }
    
    
    
    func textFieldShouldReturn (textField: UITextField!) -> Bool{
        var cell = tblForBroadcastList.dequeueReusableCellWithIdentifier("ListNameCell")
        
        if(cell != nil)
        {
            var txtfld=cell!.viewWithTag(1) as! UITextField
            
            txtfld.resignFirstResponder()
            
        }
        return true
    }
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        
        print("count for broadcast members is \(broadcastmembers.count+1)")
        //if (indexPath.row%2 == 0){
        //var cellPrivate = tblForNotes.dequeueReusableCellWithIdentifier("NotePrivateCell")! as UITableViewCell
        //var messageDic = broadcastlistmessages.objectAtIndex(indexPath.row) as! [String : String];
        //var listname=messageDic["listname"] as! NSString
        //var membersnames=messageDic["membersnames"] as! NSString
        
        var cell = tblForBroadcastList.dequeueReusableCellWithIdentifier("ListNameCell")! as! UITableViewCell
        
        if(indexPath.section==0)
        {
            cell = tblForBroadcastList.dequeueReusableCellWithIdentifier("ListNameCell")! as! UITableViewCell
            var txtfld=cell.viewWithTag(1) as! UITextField
            txtfld.delegate=self
            
            
        }
        else{
            //if(indexPath.row>0){
                if(indexPath.row<membersnames.count)
                {
                    cell = tblForBroadcastList.dequeueReusableCellWithIdentifier("NameCell")! as! UITableViewCell
                    
                    var namelabel=cell.viewWithTag(1) as! UILabel
                     var imageavatar=cell.viewWithTag(2) as! UIImageView
                    
                  
                    //var resizedimage=scaledimage.resizeImage(UIImage(data:ContactsProfilePic)!)
                    
                    if(memberavatars[indexPath.row] != NSData.init())
                    {
                        //imageavatar.layer.borderWidth = 1.0
                        imageavatar.layer.masksToBounds = true
                        
                        imageavatar.layer.cornerRadius = imageavatar.frame.size.width/2
                        imageavatar.clipsToBounds=true
                        
                          var scaledimage=ImageResizer(size: CGSize(width: imageavatar.bounds.width,height: imageavatar.bounds.height), scaleMode: .AspectFill, allowUpscaling: true, compressionQuality: 0.5)
                        
                        
                        
                        print("found avatar in broadcast page")
                        imageavatar.hnk_setImage(scaledimage.resizeImage(UIImage(data:self.memberavatars[indexPath.row])!), key: broadcastmembers[indexPath.row])
                    }
                    else
                    {
                        print("not found avatar in broadcast page")
                    }
                    namelabel.text=membersnames[indexPath.row]
                }
                else{
                    //show edit
                    cell = tblForBroadcastList.dequeueReusableCellWithIdentifier("EditListCell")! as! UITableViewCell
                }
            }
        
            
       
       
        return cell
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
