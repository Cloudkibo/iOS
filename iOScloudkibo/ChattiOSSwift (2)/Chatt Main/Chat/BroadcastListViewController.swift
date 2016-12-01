//
//  BroadcastListViewController.swift
//
//
//  Created by Cloudkibo on 01/12/2016.
//
//

import Foundation
import UIKit
class BroadcastListViewController: UIViewController,UINavigationControllerDelegate {
    
    
    @IBOutlet weak var navigationitem1: UINavigationItem!
    @IBOutlet weak var veiwForContent: UIScrollView!
    @IBOutlet weak var tblBroadcastList: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem?.title="<"
        self.navigationitem1.title="Broadcast Lists"
       // self.navigationItem.titleView = "Broadcast Lists"
    }
    
    required init?(coder aDecoder: NSCoder){
        
        super.init(coder: aDecoder)
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 103
    }
    
    func numberOfSectionsInTableView(tableView: UITableView!) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        //if (indexPath.row%2 == 0){
        //var cellPrivate = tblForNotes.dequeueReusableCellWithIdentifier("NotePrivateCell")! as UITableViewCell
        
        var cell = tblBroadcastList.dequeueReusableCellWithIdentifier("BroadcastListCell")! as! BroadcastItemCell
        
        cell.lbl_recipents_count.text="Recipents:2"
        cell.lbl_recipentsName.text="Sojharo,Sumaira991"
        
        return cell
    }
    
}
