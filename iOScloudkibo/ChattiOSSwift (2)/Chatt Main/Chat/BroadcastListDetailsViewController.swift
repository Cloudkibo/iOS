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
import Kingfisher
//import Haneke

class BroadcastListDetailsViewController: UIViewController,UINavigationControllerDelegate,UITextFieldDelegate {

    
    var broadcastlistinfo=[String:AnyObject]()
    var broadcastmembers=[String]()
    var broadcastlistID=""
    var membersnames=[String]()
    var memberavatars=[Data]()
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

    override func viewWillAppear(_ animated: Bool) {
        
        broadcastlistinfo=sqliteDB.getSinglebroadcastlist(self.broadcastlistID)
       broadcastmembers=sqliteDB.getBroadcastListMembers(broadcastlistID)
        membersnames.removeAll()
        for i in 0 ..< broadcastmembers.count
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
                do{var foundcontact=try contactStore.unifiedContact(withIdentifier: joinrows[0].get(uniqueidentifier), keysToFetch: keys as [CNKeyDescriptor])
                
                if(foundcontact.imageDataAvailable==true)
                {
                    //foundcontact.imageData
                    memberavatars.append(foundcontact.imageData!)
                   // ContactsProfilePic=foundcontact.imageData!
                    //picfound=true
                }
                else{
                    memberavatars.append(Data.init())
                }
                
                
            }
                catch
                {
                    
                }
           
            }
            else{
                
                
                self.memberavatars.append(Data.init())
            }
            
        }
        print(")count for broadcast members is \(broadcastmembers.count+1)")
        tblForBroadcastList.reloadData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func leftJoinContactsTables(_ phone1:String)->Array<Row>
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
        var joinquery=allcontacts?.join(.leftOuter, contactslists!, on: (contactslists?[phone])! == (allcontacts?[phone])!).filter((allcontacts?[phone])!==phone1)
        
        do{for joinresult in try sqliteDB.db.prepare(joinquery!) {
            
            resultrow.append(joinresult)
            }
        }
        catch{
            print("error in join query \(error)")
        }
        return resultrow
        
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(section==0)
        {
            return 1
        }
        else{
        return broadcastmembers.count+1
        }
    }
    
    
    
    func numberOfSectionsInTableView(_ tableView: UITableView!) -> Int {
        return 2
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if(section==0)
        {
            return " "
        }
        else
        {
            return "List Recipients".localized
        }
        
        
    }

    
    func tableView(_ tableView: UITableView, heightForRowAtIndexPath indexPath: IndexPath) -> CGFloat {
        
        return 68    }
    
    
    
    func textFieldShouldReturn (_ textField: UITextField!) -> Bool{
        
        textField.resignFirstResponder()
        print("textfield text is \(textField.text!)")
        sqliteDB.updateBroadcastlistName(self.broadcastlistID, listname1: textField.text!)
        var cell = tblForBroadcastList.dequeueReusableCell(withIdentifier: "ListNameCell")
        
        if(cell != nil)
        {
            var txtfld=cell!.viewWithTag(1) as! UITextField
            
            txtfld.resignFirstResponder()
            
        }
        return true
    }
    func tableView(_ tableView: UITableView!, cellForRowAtIndexPath indexPath: IndexPath!) -> UITableViewCell! {
        
        print("count for broadcast members is \(broadcastmembers.count+1)")
        //if (indexPath.row%2 == 0){
        //var cellPrivate = tblForNotes.dequeueReusableCellWithIdentifier("NotePrivateCell")! as UITableViewCell
        //var messageDic = broadcastlistmessages.objectAtIndex(indexPath.row) as! [String : String];
        //var listname=messageDic["listname"] as! NSString
        //var membersnames=messageDic["membersnames"] as! NSString
        
        let uniqueid = Expression<String>("uniqueid")
        let listname = Expression<String>("listname")
        
        var cell = tblForBroadcastList.dequeueReusableCell(withIdentifier: "ListNameCell")! 
        
        if(indexPath.section==0)
        {
            cell = tblForBroadcastList.dequeueReusableCell(withIdentifier: "ListNameCell")! 
            var txtfld=cell.viewWithTag(1) as! UITextField
            txtfld.text=self.broadcastlistinfo["listname"] as! String
            txtfld.delegate=self
            
            
        }
        else{
            //if(indexPath.row>0){
                if(indexPath.row<membersnames.count)
                {
                    cell = tblForBroadcastList.dequeueReusableCell(withIdentifier: "NameCell")! 
                    
                    var namelabel=cell.viewWithTag(1) as! UILabel
                     var imageavatar=cell.viewWithTag(2) as! UIImageView
                    
                  
                    //var resizedimage=scaledimage.resizeImage(UIImage(data:ContactsProfilePic)!)
                    
                    if(memberavatars[indexPath.row] != Data.init())
                    {
                        //imageavatar.layer.borderWidth = 1.0
                        imageavatar.layer.masksToBounds = true
                        
                        imageavatar.layer.cornerRadius = imageavatar.frame.size.width/2
                        imageavatar.clipsToBounds=true
                        
                        
                        
                        var profilepic=UIImage(data: self.memberavatars[indexPath.row])
                        
                        ImageCache.default.retrieveImage(forKey: broadcastmembers[indexPath.row], options: nil) {
                            image, cacheType in
                            if let image = image {
                                print("Get image \(image), cacheType: \(cacheType).")
                                //In this code snippet, the `cacheType` is .disk
                                
                            } else {
                                print("Not exist in cache.")
                                ImageCache.default.store(profilepic!, forKey: self.broadcastmembers[indexPath.row])
                                ImageCache.default.isImageCached(forKey: self.broadcastmembers[indexPath.row])
                                ImageCache.default.isImageCached(forKey: self.broadcastmembers[indexPath.row])
                                
                            }
                        }
                        
                        var picurl=URL(fileURLWithPath: self.broadcastmembers[indexPath.row])
                        
                       imageavatar.kf.setImage(with: picurl)
                        
                        var scaledimage=imageavatar.image?.kf.resize(to: CGSize(width: imageavatar.bounds.width,height: imageavatar.bounds.height))
                        
                        
                        
                        
                        
                        //----replacing image lib
                        /*
                          var scaledimage=ImageResizer(size: CGSize(width: imageavatar.bounds.width,height: imageavatar.bounds.height), scaleMode: .AspectFill, allowUpscaling: true, compressionQuality: 0.5)
                        
                        
                        
                        print("found avatar in broadcast page")
                        imageavatar.hnk_setImage(scaledimage.resizeImage(UIImage(data:self.memberavatars[indexPath.row])!), key: broadcastmembers[indexPath.row])
                        
                        */
                    }
                    else
                    {
                        print("not found avatar in broadcast page")
                    }
                    namelabel.text=membersnames[indexPath.row]
                }
                else{
                    //show edit
                    cell = tblForBroadcastList.dequeueReusableCell(withIdentifier: "EditListCell")! 
                }
            }
        
            
       
       
        return cell
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        
       /* let phone = Expression<String>("phone")
        let kibocontact = Expression<Bool>("kiboContact")
        let name = Expression<String?>("name")
        let email = Expression<String?>("email")
        let uniqueidentifier = Expression<String?>("uniqueidentifier")
    
        
        var allcontactslist1=sqliteDB.allcontacts
        
        
        var alladdressContactsArray=Array<Row>()
        
        //alladdressContactsArray = Array(try sqliteDB.db.prepare(allcontactslist1))
        
        
        //////configureSearchController()
        do
        {alladdressContactsArray = Array(try sqliteDB.db.prepare(allcontactslist1.filter(kibocontact==true).order(name.asc)))
            
                   }
        catch
        {
            
        }*/

        //editbroadcastlistSegue
        if segue.identifier == "editbroadcastlistSegue" {
            
            
            if let destinationVC = segue.destination as? AddParticipantsViewController{
                
                destinationVC.prevScreen="editbroadcastlist"
                var identifierslist=[String]()
                destinationVC.editbroadcastlistID=broadcastlistID
                for i in 0 ..< broadcastmembers.count
                {
                    identifierslist.append(sqliteDB.getIdentifierFRomPhone(broadcastmembers[i]))
                    var found=UtilityFunctions.init().findContact(sqliteDB.getIdentifierFRomPhone(broadcastmembers[i]))
                    destinationVC.participantsSelected1.append(EPContact(contact:(found.first!)))
                    
                }
                print("from edit, current list has \(destinationVC.participantsSelected1.count) selectedparticipants")
                
                //==--destinationVC.participants.removeAll()
                
                //  let selectedRow = tblForChat.indexPathForSelectedRow!.row
                
            }}
    
       
        
       //==-- var found=UtilityFunctions.init().findContact(alladdressContactsArray[indexPath.row].get(uniqueidentifier)!)
        
        ////print("index above is \(indexPath.row)")
        //print("selected is \(found.first?.givenName)")
        
        
        
    }
 

}
