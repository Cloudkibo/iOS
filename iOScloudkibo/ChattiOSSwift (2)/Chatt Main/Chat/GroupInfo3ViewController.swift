//
//  GroupInfo3ViewController.swift
//  kiboApp
//
//  Created by Cloudkibo on 01/09/2016.
//  Copyright © 2016 MyAppTemplates. All rights reserved.
//

import UIKit

class GroupInfo3ViewController: UIViewController {

    @IBOutlet weak var tblGroupInfo: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.titleView = setTitle("Group Info", subtitle: "Sumaira")
        //self.navigationController?.navigationBar.tintColor=UIColor.whiteColor()
        
    
       // self.navigationItem.title="Group Info"
        self.navigationController?.navigationBar.tintColor=UIColor.whiteColor()

        
        // Do any additional setup after loading the view.
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if(indexPath.row != 3)
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
        return 4
    }

     func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell=tblGroupInfo.dequeueReusableCellWithIdentifier("AddParticipants1Cell")! as UITableViewCell
        if(indexPath.row==0)
        {
            
            
            return cell
            
        }
        if(indexPath.row==1)
        {
             cell=tblGroupInfo.dequeueReusableCellWithIdentifier("ExportChatsCell")! as UITableViewCell
            
            return cell
            
        }
        if(indexPath.row==2)
        {
             cell=tblGroupInfo.dequeueReusableCellWithIdentifier("ChatPrivateCell")! as UITableViewCell
            
            return cell
            
        }
        else
        {
             cell=tblGroupInfo.dequeueReusableCellWithIdentifier("ExitClearChatCell")! as UITableViewCell
            
            return cell
            
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
