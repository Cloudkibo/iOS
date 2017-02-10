//
//  ChatHistoryTableViewController.swift
//  kiboApp
//
//  Created by Cloudkibo on 28/06/2016.
//  Copyright © 2016 MyAppTemplates. All rights reserved.
//

import UIKit
import SQLite

class CallHistoryTableViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{
    
  
    @IBOutlet weak var tblForCallsHistory: UITableView!
    var CallHist: NSMutableArray!
    override func viewDidLoad() {
        super.viewDidLoad()
        tblForCallsHistory.delegate=self
        tblForCallsHistory.dataSource=self

        CallHist=NSMutableArray()
        
        ///self.retrieveCallHistoryData()
        /*
        var date22=NSDate()
        var formatter = DateFormatter();
        formatter.dateFormat = "MM/dd hh:mm a"";
        formatter.timeZone = NSTimeZone.local()
        ////formatter.dateStyle = .ShortStyle
        //formatter.timeStyle = .ShortStyle
        let defaultTimeZoneStr = formatter.stringFromDate(date22);
        
        
        //self.addCallData("User 1", dateTime: defaultTimeZoneStr, type: "Outgoing")
        //self.addCallData("User 2", dateTime: defaultTimeZoneStr, type: "Missed")
        
        let name = Expression<String>("name")
        let dateTime = Expression<String>("dateTime")
        let type = Expression<String>("type")
        
        
        var tblcallHistory = sqliteDB.callHistory
        
        do{
            for call in try sqliteDB.db.prepare(tblcallHistory) {
                self.addCallData(call[name], dateTime: call[dateTime], type: call[type])
              //  print("id: \(user[username]), email: \(user[email])")
                
            }
            tblForCallsHistory.reloadData()
        }
        catch
        {
            print("error in call hist")
        }
        */
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func viewWillAppear(_ animated: Bool) {
    self.retrieveCallHistoryData()
        
    }
    
    func retrieveCallHistoryData()
    {
        let date22=Date()
        let formatter = DateFormatter();
        formatter.dateFormat = "MM/dd hh:mm a";
        formatter.timeZone = TimeZone.autoupdatingCurrent
        ////formatter.dateStyle = .ShortStyle
        //formatter.timeStyle = .ShortStyle
        let defaultTimeZoneStr = formatter.string(from: date22);
        
        
        //self.addCallData("User 1", dateTime: defaultTimeZoneStr, type: "Outgoing")
        //self.addCallData("User 2", dateTime: defaultTimeZoneStr, type: "Missed")
        
        let name = Expression<String>("name")
        let dateTime = Expression<String>("dateTime")
        let type = Expression<String>("type")
        
        
        let tblcallHistory = sqliteDB.callHistory
        
        do{
            for call in try sqliteDB.db.prepare(tblcallHistory!) {
                self.addCallData(call[name], dateTime: call[dateTime], type: call[type])
                //  print("id: \(user[username]), email: \(user[email])")
                
            }
            tblForCallsHistory.reloadData()
        }
        catch
        {
            print("error in call hist")
        }

    }
    
    func addCallData(_ name:String,dateTime:String,type:String)
    {
        CallHist.add(["name":name,"dateTime":dateTime,"type":type])
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return CallHist.count
    }
    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var CallHistDictionary = CallHist.object(at: indexPath.row) as! [String : String];
        let cell = tblForCallsHistory.dequeueReusableCell(withIdentifier: "CallHistoryCell")! as! CallHistCell
        let name=CallHistDictionary["name"]! as String
        let dateTime=CallHistDictionary["dateTime"]! as String
        let callType=CallHistDictionary["type"]! as String
        
        
        cell.imgCallOut.isHidden=true
        cell.lblName.text=name
        cell.lblDateTime.text=dateTime
        if(callType == "Outgoing")
        {
            cell.lblName.textColor=UIColor.black
            cell.imgCallOut.isHidden=false
        }
        if(callType == "Missed")
        {
            cell.lblName.textColor=UIColor.red
        }
        if(callType == "Incoming")
        {
            cell.lblName.textColor=UIColor.black
                    }
        // Configure the cell...
        
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
