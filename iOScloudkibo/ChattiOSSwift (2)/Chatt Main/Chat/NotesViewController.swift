//
//  NotesViewController.swift
//  Chat
//
//  Created by My App Templates Team on 26/08/14.
//  Copyright (c) 2014 My App Templates. All rights reserved.
//

import UIKit
import SQLite

class NotesViewController: UIViewController,InviteContactsDelegate {

    var delegate:InviteContactsDelegate!
    @IBOutlet var viewForTitle : UIView!
    @IBOutlet var ctrlForChat : UISegmentedControl!
    @IBOutlet var btnForLogo : UIButton!
    @IBOutlet var itemForSearch : UIBarButtonItem!
    @IBOutlet var tblForNotes : UITableView!
    var messageFrame = UIView()
    var activityIndicator = UIActivityIndicatorView()
    var strLabel = UILabel()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        // Custom initialization
    }

    
    func progressBarDisplayer(msg:String, _ indicator:Bool ) {
        print(msg)
        strLabel = UILabel(frame: CGRect(x: 50, y: 0, width: 250, height: 50))
        strLabel.text = msg
        strLabel.textColor = UIColor.whiteColor()
        messageFrame = UIView(frame: CGRect(x: view.frame.midX - 110, y: view.frame.midY - 25 , width: 230, height: 50))
        messageFrame.layer.cornerRadius = 15
        messageFrame.backgroundColor = UIColor(white: 0, alpha: 0.7)
        if indicator {
            activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.White)
            activityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
            activityIndicator.startAnimating()
            messageFrame.addSubview(activityIndicator)
        }
        messageFrame.addSubview(strLabel)
        view.addSubview(messageFrame)
    }
    
    override func viewWillAppear(animated: Bool) {
        
        tblForNotes.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        contactsList.delegate=self
        self.navigationItem.titleView = viewForTitle
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: btnForLogo)
        self.navigationItem.rightBarButtonItem = itemForSearch
        self.tabBarController?.tabBar.tintColor = UIColor.greenColor()
        
        
        /*
        progressBarDisplayer("Fetching Contacts", true)
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            // do some task start to show progress wheel
        contactsList.fetch(){ (result) -> () in
            
            
            dispatch_async(dispatch_get_main_queue()) {
                // update some UI
                //remove progress wheel
                print("got server response")
                socketObj.socket.emit("logClient", "Got contacts List from device")
                self.messageFrame.removeFromSuperview()
                //move to next screen
                //self.saveButton.enabled = true
            }

            socketObj.socket.emit("logClient", "done fetched contacts from iphone")
          
            print("notes view loaded. fetch")
            for r in result{
                self.tblForNotes.reloadData()
            }
            socketObj.socket.emit("logClient", "Fetching whole contacts list")
        }
        }*/
        
        
        // Do any additional setup after loading the view.
    }
    
    

   /* required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }*/
    required init?(coder aDecoder: NSCoder){

        super.init(coder: aDecoder)
    }
        
    @IBAction func unwindToChat (segueSelected : UIStoryboardSegue) {
        
    }
    
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView!) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
       //if (indexPath.row%2 == 0){
            //var cellPrivate = tblForNotes.dequeueReusableCellWithIdentifier("NotePrivateCell")! as UITableViewCell
        
        let email = Expression<String>("email")
     
        

            let tbl_contactslist = sqliteDB.contactslists
            var cellPrivate = tblForNotes.dequeueReusableCellWithIdentifier("NotePrivateCell")! as! AllContactsCell
            print("namelist count is \(nameList.count)")
            //cellPrivate.labelNamePrivate.text=nameList[indexPath.row]
        
            cellPrivate.labelStatusPrivate.hidden=true
        
            cellPrivate.labelNamePrivate.text=contacts[indexPath.row].givenName
        do{
            let em = try contacts[indexPath.row].phoneNumbers 
            if(em != nil && em != "")
            {
                for(var i=0;i<availableEmailsList.count;i++)
                {print(em!.value as! String)
                    print(availableEmailsList[i])
                    
                    if(em!.value as! String == availableEmailsList[i])
                    {
                        cellPrivate.labelStatusPrivate.hidden=false
                    }
                }
            }
        }
        
            return cellPrivate
            /*
            let cellPublic=tblForChat.dequeueReusableCellWithIdentifier("ChatPublicCell") as! ContactsListCell
            
            let cell=tblForChat.dequeueReusableCellWithIdentifier("ChatPrivateCell") as! ContactsListCell
            
            cell.contactName?.text=ContactNames[indexPath.row]
*/
       // }
        
        /*else {
           // var cellPublic = tblForNotes.dequeueReusableCellWithIdentifier("NotePublicCell")! as UITableViewCell
            
            var cellPublic = tblForNotes.dequeueReusableCellWithIdentifier("NotePrivateCell")! as! AllContactsCell
            
            
            return cellPublic
        }*/
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // #pragma mark - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue?, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    func receivedContactsUpdateUI() {
        
        tblForNotes.reloadData()
    }
}
