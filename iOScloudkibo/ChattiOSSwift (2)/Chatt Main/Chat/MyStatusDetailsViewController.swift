//
//  MyStatusDetailsViewController.swift
//  kiboApp
//
//  Created by Cloudkibo on 25/05/2017.
//  Copyright © 2017 MyAppTemplates. All rights reserved.
//

import UIKit
import ActiveLabel
import Photos
import PhotosUI
import ImagePicker
import MediaPlayer
class MyStatusDetailsViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

      var messages:NSMutableArray!
    @IBOutlet weak var bottomToolbar: UIToolbar!
    @IBOutlet weak var btnEditOutlet: UIBarButtonItem!
    @IBOutlet weak var tblMyStatus: UITableView!
    
 
    override func viewDidLoad() {
        super.viewDidLoad()

        messages=NSMutableArray()
        messages.add(["picID":"1","time":"1 hour ago","viewCount":"2"])
        messages.add(["picID":"2","time":"just now","viewCount":"0"])
        
        tblMyStatus.allowsMultipleSelectionDuringEditing = true
        
        
        //!!tblMyStatus.setEditing(true, animated: false)
        
        // Do any additional setup after loading the view.
    }
    func numberOfSections(in tableView: UITableView) -> Int {

        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(section==0)
        {
            return messages.count
        }
        else{
            
                return 0
            }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
    }
    
    @IBAction func btnDeletePressed(_ sender: Any) {
        let shareMenu = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
        shareMenu.modalPresentationStyle=UIModalPresentationStyle.overCurrentContext
        
        
        let unblockAction = UIAlertAction(title: "Delete Status update".localized, style: UIAlertActionStyle.destructive,handler: { (action) -> Void in
           
            var indexesSelected=self.tblMyStatus.indexPathsForSelectedRows
            for ind in indexesSelected!
            {
                self.messages.removeObject(at:ind.row)
            }
            self.tblMyStatus.isEditing=false
            self.btnEditOutlet.title="Edit"
            self.bottomToolbar.isHidden=true
            self.tblMyStatus.reloadData()
            
            
            
        })
        let cancelAction = UIAlertAction(title: "Cancel".localized, style: UIAlertActionStyle.cancel, handler:{ (action) -> Void in
            
            return
            
        })
        
        
        shareMenu.addAction(unblockAction)
        shareMenu.addAction(cancelAction)
        
        
        
        self.present(shareMenu, animated: true, completion: {
            
        })
        
        
      
    }
    @IBAction func btnEditPressed(_ sender: Any) {
        //!tblMyStatus.isEditing
      tblMyStatus.setEditing(!tblMyStatus.isEditing, animated: false)
        if(tblMyStatus.isEditing==true)
        {
        bottomToolbar.isHidden=false
            btnEditOutlet.title="Done"
        }
        else{
            bottomToolbar.isHidden=true
            btnEditOutlet.title="Edit"

        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var messageDic = messages.object(at: indexPath.row) as! [String : String];
        // NSLog(messageDic["message"]!, 1)
        let viewCount = messageDic["viewCount"] as NSString!
        let timeDict = messageDic["time"] as NSString!
        
        var cell = tblMyStatus.dequeueReusableCell(withIdentifier: "MyStatusUpdatesCell")! as! UITableViewCell
        
        if(indexPath.section==0)
        {
            cell = tblMyStatus.dequeueReusableCell(withIdentifier: "MyStatusUpdatesCell")! as! UITableViewCell
            
        }
            /*
        else{
            if(messages.count<1)
            {
                cell = tblStatusUpdates.dequeueReusableCell(withIdentifier: "StatusCell")! as! UITableViewCell
            }
            else{
                cell = tblStatusUpdates.dequeueReusableCell(withIdentifier: "myStatusCell")! as! UITableViewCell
                var name=cell.viewWithTag(2) as! UILabel
                var time=cell.viewWithTag(3) as! UILabel
                name.text=nameDict as String?
                time.text=timeDict as String?
                
            }
            
        }
        */
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 71
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if(section==0)
        {
            return 25
        }
        else{
            return tableView.frame.height
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if(section==1)
        {
    
            var outerview=ActiveLabel.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.size.width, height: tableView.frame.height))
            
            var headerview=ActiveLabel.init(frame: CGRect.init(x: 10, y: 5, width: tableView.frame.size.width-10, height: 60))
        headerview.text="Updates will be removed from all the contacts after 24hours"
        headerview.lineBreakMode = .byWordWrapping
        headerview.numberOfLines=0
            headerview.textAlignment = .center
            outerview.addSubview(headerview)
       // outerview.backgroundColor = UIColor.lightGray
        return outerview
        }
        else{
                var headerview=ActiveLabel.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.size.width, height: 30))
           // headerview.backgroundColor = UIColor.lightGray
            return headerview
        }
    }
   /*
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if(section==1)
        {
            return "Updates will be removed after 24hours"
        }
        else{
            return ""
        }
    }*/

    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        var messageDic = messages.object(at: indexPath.row) as! [String : AnyObject];
        
        //// if editingStyle == .Delete {
        if(editingStyle == UITableViewCellEditingStyle.delete){
            
            var messageDic = messages.object(at: indexPath.row) as! [String : String];
            var listname=messageDic["listname"] as! NSString
            var uniqueid=messageDic["uniqueid"] as! NSString
            
            var membersnames=messageDic["membersnames"] as! NSString
            
            //!!sqliteDB.deleteBroadcastList(uniqueid as String)
            //!!retrieveBroadCastLists()
           
            tblMyStatus.reloadData()
            
            
            //delete
            
        }
        else{
            if(editingStyle == UITableViewCellEditingStyle.insert)
            {
                print("another swipe button")
            }
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tblMyStatus.setEditing(editing, animated: animated)
        print("editingggg....2")
        
        tblMyStatus.reloadData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
