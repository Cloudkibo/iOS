//
//  StatusViewController.swift
//  kiboApp
//
//  Created by Cloudkibo on 24/05/2017.
//  Copyright © 2017 MyAppTemplates. All rights reserved.
//

import UIKit
import Kingfisher
import SQLite
import AlamofireImage

class StatusViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    var imageCache=AutoPurgingImageCache()
    var messagesMyStatus:NSMutableArray!
    var messagesOthersStatus:NSMutableArray!
    
    
    func getTimeDuration(mydate:Date)->String
    {
        let date22=Date()
        let formatter = DateFormatter();
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ";
        //formatter.dateFormat = "MM/dd hh:mm a"";
        formatter.timeZone = TimeZone.autoupdatingCurrent
        //formatter.dateStyle = .ShortStyle
        //formatter.timeStyle = .ShortStyle
        let defaultTimeZoneStr2 = formatter.string(from: date22);
        let defaultTimeZoneStr = formatter.date(from: defaultTimeZoneStr2)
        
        
      print("mydate is \(mydate)")
        // mydate.timeIntervalSinceNow
        let formatter2 = DateComponentsFormatter()
        formatter2.allowedUnits = [.day, .hour, .minute]
        formatter2.unitsStyle = .full
        var string = formatter2.string(from: mydate, to: date22)
        
        ///////////////==========var defaultTimeeee = formatter2.stringFromDate(defaultTimeZoneStr!)
       print("elapsed time is \(string!)")
        
        return string!
       
    }
    
    func retrieveStatuses()
    {
        //file table from-username - section 1 my statuses
        sqliteDB.deleteOldDayStatuses()

        var daystatuses=sqliteDB.getDayStatusesData()
        var messagesMyStatus2=NSMutableArray()
        var messagesOthersStatus2=NSMutableArray()

        print("daystatuses list \(daystatuses)")
        /*
         let to = Expression<String>("to")
         let from = Expression<String>("from")
         let date = Expression<Date>("date")
         let uniqueid = Expression<String>("uniqueid")
         let contactPhone = Expression<String>("contactPhone")
         let type = Expression<String>("type")
         let file_name = Expression<String>("file_name")
         let file_size = Expression<String>("file_size")
         let file_type = Expression<String>("file_type")
         let file_path = Expression<String>("file_path")
         let file_caption = Expression<String>("file_caption")
         
         */
        
        for statuses in daystatuses{
            
            var messages_to=statuses["to"] as! String
            var messages_from=statuses["from"] as! String
            //self.ContactIDs.removeAll(keepCapacity: false)
           
            
          
            
            var uploadtime=statuses["date"] as! Date
            var messages_duration = self.getTimeDuration(mydate:statuses["date"] as! Date)+" ago"
            var messages_uniqueid=statuses["uniqueid"] as! String
            var messages_contactphone=statuses["contactPhone"] as! String
            var messages_type=statuses["type"] as! String
            var messages_file_name=statuses["file_name"] as! String
            ////////////////////////
            var messages_file_size=statuses["file_size"] as! String
            ////////
            
            var messages_file_type=statuses["file_type"] as! String
            ////self.ContactsEmail.removeAll(keepCapacity: false)
            //////self.ContactMsgRead.removeAll(keepCapacity: false)
            var messages_file_pic=Data.init()
            //var messages_pic=Data.init()
            var messages_file_caption=statuses["file_caption"] as! String
            
            let dirPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
            let docsDir1 = dirPaths[0]
            var documentDir=docsDir1 as NSString
            var imgPath=documentDir.appendingPathComponent(messages_file_name)
            print("imgpath is \(imgPath)")
            if (FileManager.default.contents(atPath: imgPath) != nil)
            {
                var imgdata=FileManager.default.contents(atPath: imgPath)!
                messages_file_pic=imgdata
            }
            
            
            if(statuses["from"] as! String == username!){
                messagesMyStatus2.add(["messages_from":messages_from,"messages_duration":messages_duration,"messages_file_type":messages_file_type,"messages_uniqueid":messages_uniqueid,"messages_file_name":messages_file_name,"messages_file_caption":messages_file_caption,"messages_file_pic":messages_file_pic,"uploadtime":uploadtime])
            }
            else{
                messagesOthersStatus2.add(["messages_from":messages_from,"messages_duration":messages_duration,"messages_file_type":messages_file_type,"messages_uniqueid":messages_uniqueid,"messages_file_name":messages_file_name,"messages_file_caption":messages_file_caption,"messages_file_pic":messages_file_pic,"uploadtime":uploadtime])
            }
            
        }
        if(messagesMyStatus2.count>0)
        {
        self.messagesMyStatus.setArray(messagesMyStatus2 as [AnyObject])
        }
        else{
        self.messagesOthersStatus.setArray(messagesOthersStatus2 as [AnyObject])
        }
    }

    
    @IBOutlet weak var tblStatusUpdates: UITableView!
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        sqliteDB.getOldDayStatuses()
        //messagesMyStatus=NSMutableArray()
        //messagesOthersStatus=NSMutableArray()
        // messagesOthersStatus.add(["displayName":"Sojharo","time":"1 hour ago"])
        //messagesOthersStatus.add(["displayName":"XYZ","time":"just now"])
        self.retrieveStatuses()
        self.tblStatusUpdates.reloadData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        sqliteDB.getOldDayStatuses()
        messagesMyStatus=NSMutableArray()
        messagesOthersStatus=NSMutableArray()
       // messagesOthersStatus.add(["displayName":"Sojharo","time":"1 hour ago"])
        //messagesOthersStatus.add(["displayName":"XYZ","time":"just now"])
        self.retrieveStatuses()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(section==0)
        {
            return 1
        }
        else{
            if(messagesOthersStatus.count>0)
            {
            return messagesOthersStatus.count
            }
            else{
                return 1
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //var messageDic = messagesOthersStatus.object(at: indexPath.row) as! [String : AnyObject];
       // NSLog(messageDic["message"]!, 1)
        //let nameDict = messageDic["displayName"] as! NSString!
        //let timeDict = messageDic["time"] as NSString!
        
        var cell = tblStatusUpdates.dequeueReusableCell(withIdentifier: "StatusCell")! as! UITableViewCell

        
        var messages_from = ""
        var messages_duration = "just now"
        var messages_file_type=""
        var messages_uniqueid=""
        var messages_file_name=""
        var messages_file_caption=""
        var messages_file_pic=Data.init()
        
        if(indexPath.section==0)
        {
             cell = tblStatusUpdates.dequeueReusableCell(withIdentifier: "myStatusCell")! as! UITableViewCell
            
            
            //show only recent status
            if(messagesMyStatus.count>0){
            var messageDic = messagesMyStatus.lastObject as! [String : AnyObject];
                //.object(at: indexPath.row) as! [String : AnyObject];
            
            messages_from = messageDic["messages_from"] as! String
            messages_duration = messageDic["messages_duration"] as! String
            messages_file_type=messageDic["messages_file_type"] as! String
            messages_uniqueid=messageDic["messages_uniqueid"] as! String
            messages_file_name=messageDic["messages_file_name"] as! String
            messages_file_caption=messageDic["messages_file_caption"] as! String
            messages_file_pic=messageDic["messages_file_pic"] as! Data
            

          
            
            var profilePic=cell.viewWithTag(1) as! UIImageView
            //varcell.viewWitTag(1) as UILabel
            var timeElapsed=cell.viewWithTag(3) as! UILabel
            var btninfo=cell.viewWithTag(4) as! UIButton
            
            if let img=UIImage(data:messages_file_pic)
            {
            profilePic.layer.borderWidth = 1.0
            profilePic.layer.masksToBounds = false
            profilePic.layer.borderColor = UIColor.white.cgColor
            profilePic.layer.cornerRadius = profilePic.frame.size.width/2
            profilePic.clipsToBounds = true
            
            imageCache.removeImage(withIdentifier: messages_uniqueid)
            imageCache.add(img, withIdentifier: messages_uniqueid)
            
            // Fetch
            var cachedAvatar = imageCache.image(withIdentifier: messages_uniqueid)
            cachedAvatar=UtilityFunctions.init().resizedAvatar(img: cachedAvatar, size: CGSize(width: profilePic.bounds.width,height: profilePic.bounds.height), sizeStyle: "Fill")
            
            profilePic.image=cachedAvatar

            
        }
                if(messages_duration=="0 minutes")
                {
                    timeElapsed.text="just now"
                }
                else{
            timeElapsed.text=messages_duration
                }
            }
            else{
               cell = tblStatusUpdates.dequeueReusableCell(withIdentifier: "StatusCell")! as! UITableViewCell
            }
        }
        else{
            
           
            if(messagesOthersStatus.count<1)
            {
             cell = tblStatusUpdates.dequeueReusableCell(withIdentifier: "StatusCell")! as! UITableViewCell
            }
            else{
                 var messageDic = messagesOthersStatus.object(at: indexPath.row) as! [String : AnyObject];
                cell = tblStatusUpdates.dequeueReusableCell(withIdentifier: "myStatusCell")! as! UITableViewCell
                var name=cell.viewWithTag(2) as! UILabel
                var time=cell.viewWithTag(3) as! UILabel
                //name.text=nameDict as String?
                //time.text=timeDict as String?

            }

        }
        
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if(section==0)
        {
            return 25
        }
        else{
            return 50
        }
    }
     func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if(section==1)
        {
        return "Viewed Updates"
        }
        else{
        return ""
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         if(indexPath.section==0)
         {
            if(messagesMyStatus.count>0)
            {
                //segue to view status
                
                self.performSegue(withIdentifier: "slideshowHybridSegue", sender: self)
               // self.performSegue(withIdentifier: "viewStatusSlideshowMine", sender: self)
            }
            else{
                //segue to add new status
            }
        }
         else{
            if(messagesOthersStatus.count>0)
            {
                //segue to view status of others
            }
            else{
                
            }
        }
    }

    override func prepare(for segue: UIStoryboardSegue?, sender: Any?) {
        
        //newGroupDetailsSegue
        //addParticipantsSegue
        //slideshowHybridSegue
       // if segue!.identifier == "viewStatusSlideshowMine" {
        if segue!.identifier == "slideshowHybridSegue" {
            if let destinationVC = segue!.destination as? StatusHybridSlideshowViewController{
                
                
                var selectedRow=tblStatusUpdates.indexPathForSelectedRow
                destinationVC.slideshowarray=self.messagesMyStatus
                
                                //selectedRow = tblForChat.indexPathForSelectedRow!.row
                //messageDic = messages.object(at: selectedRow) as! [String : AnyObject];
                //ContactUsernames = messageDic["ContactUsernames"] as! String
                
                
                
                //destinationVC.participants.removeAll()
                //destinationVC.statusInfo = "newGroup"
                //destinationVC.participants=self.participantsSelected
                //  let selectedRow = tblForChat.indexPathForSelectedRow!.row
                
            }}
        
    }

}

extension Date {
    
    func getElapsedInterval() -> String {
        
        let date22=Date()
        let formatter = DateFormatter();
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ";
        //formatter.dateFormat = "MM/dd hh:mm a"";
        formatter.timeZone = TimeZone.autoupdatingCurrent
        //formatter.dateStyle = .ShortStyle
        //formatter.timeStyle = .ShortStyle
        let defaultTimeZoneStr2 = formatter.string(from: date22);
        let defaultTimeZoneStr = formatter.date(from: defaultTimeZoneStr2)
        
    var interval=NSCalendar.current.dateComponents([Calendar.Component.year], from: self, to: defaultTimeZoneStr!).year
        
        
        //var interval = NSCalendar.currentCalendar.dateComponents(.Year, fromDate: self, toDate: NSDate(), options: []).year
        if(interval != nil)
        {
        if interval! > 0 {
            return interval == 1 ? "\(interval)" + " " + "year" :
                "\(interval)" + " " + "years"
        }
        }
        interval = NSCalendar.current.dateComponents([Calendar.Component.year], from: self, to: defaultTimeZoneStr!).month
        if(interval != nil)
        {
        if interval! > 0 {
            return interval == 1 ? "\(interval)" + " " + "month" :
                "\(interval)" + " " + "months"
        }
        }
        interval = NSCalendar.current.dateComponents([Calendar.Component.year], from: self, to: defaultTimeZoneStr!).day
        if(interval != nil)
        {
        if interval! > 0 {
            return interval == 1 ? "\(interval)" + " " + "day" :
                "\(interval)" + " " + "days"
        }
        }
        interval = NSCalendar.current.dateComponents([Calendar.Component.year], from: self, to: defaultTimeZoneStr!).hour
        if(interval != nil)
        {
        if interval! > 0 {
            return interval == 1 ? "\(interval)" + " " + "hour" :
                "\(interval)" + " " + "hours"
        }
        }
        interval = NSCalendar.current.dateComponents([Calendar.Component.year], from: self, to: defaultTimeZoneStr!).minute
        if(interval != nil)
        {
        if interval! > 0 {
            return interval == 1 ? "\(interval)" + " " + "minute" :
                "\(interval)" + " " + "minutes"
        }
        }
        
        return "a moment ago"
    }
}
