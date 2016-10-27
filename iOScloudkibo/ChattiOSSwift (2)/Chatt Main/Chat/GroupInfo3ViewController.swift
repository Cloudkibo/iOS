//
//  GroupInfo3ViewController.swift
//  kiboApp
//
//  Created by Cloudkibo on 01/09/2016.
//  Copyright © 2016 MyAppTemplates. All rights reserved.
//

import UIKit
import SQLite
class GroupInfo3ViewController: UIViewController {

    var messages:NSMutableArray!
    var membersnames=[String]()
    var groupid=""
    @IBOutlet weak var tblGroupInfo: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        messages=NSMutableArray()
        self.navigationItem.titleView = setTitle("Group Info", subtitle: "Sumaira")
        //self.navigationController?.navigationBar.tintColor=UIColor.whiteColor()
      
    
       // self.navigationItem.title="Group Info"
        self.navigationController?.navigationBar.tintColor=UIColor.whiteColor()

        
        // Do any additional setup after loading the view.
    }
    
    
    func retrieveChatFromSqlite(completion:(result:Bool)->())
    {
        //print("retrieveChatFromSqlite called---------")
        ///^^messages.removeAllObjects()
        var messages2=NSMutableArray()
        
        let group_unique_id = Expression<String>("group_unique_id")
        let member_phone = Expression<String>("member_phone")
        let isAdmin = Expression<String>("isAdmin")
        let membership_status = Expression<String>("membership_status")
        let date_joined = Expression<NSDate>("date_joined")
        let date_left = Expression<NSDate>("date_left")
        let group_member_displayname = Expression<String>("group_member_displayname")
        
        
        
        var tbl_groupmembers=sqliteDB.group_member
        var res=tbl_groupmembers.filter(group_unique_id==groupid)
        //to==selecteduser || from==selecteduser
        //print("chat from sqlite is")
        //print(res)
        do
        {
           
            //for tblContacts in try sqliteDB.db.prepare(tbl_userchats.filter(owneruser==owneruser1)){
            ////print("queryy runned count is \(tbl_contactslists.count)")
            for members in try sqliteDB.db.prepare(tbl_groupmembers.filter(group_unique_id==groupid)){
                
                 print("found matched idss")
                messages2.addObject(["name":members[group_member_displayname],"isAdmin":members[isAdmin]])
            }
        }
        catch
        {
            print("error in getting members")
        }
        messages.setArray(messages2 as [AnyObject])
        ////////////self.messages.addObjectsFromArray(messages2 as [AnyObject])
        
        
        completion(result:true)

    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if(indexPath.row != (messages.count+1))
        {return 73}
        else{
        
        return 228
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count+3
    }

     func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
       
        if(indexPath.row==0)
        {
             var cell=tblGroupInfo.dequeueReusableCellWithIdentifier("AddParticipants1Cell")! as UITableViewCell
            
            return cell
            
        }
        /*if(indexPath.row==1)
        {
             cell=tblGroupInfo.dequeueReusableCellWithIdentifier("ExportChatsCell")! as UITableViewCell
            
            return cell
            
        }*/
        else
        {if(indexPath.row==1)
        {
            print("export chat")
             var cell=tblGroupInfo.dequeueReusableCellWithIdentifier("ExportChatsCell")! as! UITableViewCell
            
            return cell
            
        }
        else
        {
            if(indexPath.row==(messages.count+1))
            {
                print("exit/clear chat")
             var cell=tblGroupInfo.dequeueReusableCellWithIdentifier("ExitClearChatCell")! as UITableViewCell
            
            return cell
            }
            else
            {
                print("inside show participants")
                var cell=tableView.dequeueReusableCellWithIdentifier("ParticipantsInfoCell")! as! GroupInfoCell
                cell.lbl_groupAdmin.hidden=true

                var messageDic = messages.objectAtIndex(indexPath.row-1) as! [String : String];
                // NSLog(messageDic["message"]!, 1)
                let name = messageDic["name"] as NSString!
                let isAdmin = messageDic["isAdmin"] as NSString!
                
                if(isAdmin=="Yes")
                {
                   cell.lbl_groupAdmin.hidden=false
                }
                
                cell.lbl_participant_name.text=name as! String

                return cell
                
                

}
            
        }
        }
    }
    
    func setTitle(title:String, subtitle:String) -> UIView {
        //Create a label programmatically and give it its property's
        let titleLabel = UILabel(frame: CGRectMake(0, 0, 0, 0)) //x, y, width, height where y is to offset from the view center
        titleLabel.backgroundColor = UIColor.clearColor()
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.font = UIFont.boldSystemFontOfSize(17)
        titleLabel.text = title
        titleLabel.sizeToFit()
        
        //Create a label for the Subtitle
        let subtitleLabel = UILabel(frame: CGRectMake(0, 18, 0, 0))
        subtitleLabel.backgroundColor = UIColor.clearColor()
        //subtitleLabel.textColor = UIColor.lightGrayColor()
        subtitleLabel.textColor = UIColor.blackColor()
        
        subtitleLabel.font = UIFont.systemFontOfSize(12)
        subtitleLabel.text = subtitle
        subtitleLabel.sizeToFit()
        
        // Create a view and add titleLabel and subtitleLabel as subviews setting
        let titleView = UIView(frame: CGRectMake(0, 0, max(titleLabel.frame.size.width, subtitleLabel.frame.size.width), 30))
        
        // Center title or subtitle on screen (depending on which is larger)
        if titleLabel.frame.width >= subtitleLabel.frame.width {
            var adjustment = subtitleLabel.frame
            adjustment.origin.x = titleView.frame.origin.x + (titleView.frame.width/2) - (subtitleLabel.frame.width/2)
            subtitleLabel.frame = adjustment
        } else {
            var adjustment = titleLabel.frame
            adjustment.origin.x = titleView.frame.origin.x + (titleView.frame.width/2) - (titleLabel.frame.width/2)
            titleLabel.frame = adjustment
        }
        
        titleView.addSubview(titleLabel)
        titleView.addSubview(subtitleLabel)
        
        return titleView
    }

    override func viewWillAppear(animated: Bool) {
               var imageavatar1=UIImage(named: "avatar.png")
        //   imageavatar1=ResizeImage(imageavatar1!,targetSize: s)
        
        //var img=UIImage(data:ContactsProfilePic[indexPath.row])
        var w=imageavatar1!.size.width
        var h=imageavatar1!.size.height
        //var wOld=(self.navigationController?.navigationBar.frame.width)!-5
        var hOld=(self.navigationController?.navigationBar.frame.height)!-10
        var scale:CGFloat=h/hOld
        
        
        ///var s=CGSizeMake((self.navigationController?.navigationBar.frame.height)!-5,(self.navigationController?.navigationBar.frame.height)!-5)
        
        
        var barAvatarImage=UIImageView.init(image: UIImage(data: UIImagePNGRepresentation(UIImage(named: "profile-pic1")!)!, scale: scale))
        
        barAvatarImage.layer.borderWidth = 1.0
        barAvatarImage.layer.masksToBounds = false
        barAvatarImage.layer.borderColor = UIColor.whiteColor().CGColor
        barAvatarImage.layer.cornerRadius = barAvatarImage.frame.size.width/2
        barAvatarImage.clipsToBounds = true
        
        print("bav avatar size is \(barAvatarImage.frame.width) .. \(barAvatarImage.frame.width)")
        var avatarbutton=UIBarButtonItem.init(customView: barAvatarImage)
        self.navigationItem.rightBarButtonItem=avatarbutton
       
        self.retrieveChatFromSqlite { (result) in
            self.tblGroupInfo.reloadData()
            if(self.messages.count>1)
            {
                var indexPath = NSIndexPath(forRow:self.messages.count+1, inSection: 0)
                self.tblGroupInfo.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Bottom, animated: true)
                
            }
            
        }
       


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
