//
//  NotesViewController.swift
//  Chat
//
//  Created by My App Templates Team on 26/08/14.
//  Copyright (c) 2014 My App Templates. All rights reserved.
//

import UIKit
import SQLite
import Contacts
class NotesViewController: UIViewController,InviteContactsDelegate,UITextFieldDelegate,UISearchBarDelegate,UISearchResultsUpdating {
    
    
    var filteredArray = Array<Row>()
    
    var shouldShowSearchResults = false
    
    var searchController: UISearchController!
    var alladdressContactsArray=Array<Row>()
    var alert:UIAlertController!
    var delegate:InviteContactsDelegate!
    @IBOutlet var viewForTitle : UIView!
    @IBOutlet var ctrlForChat : UISegmentedControl!
    @IBOutlet var btnForLogo : UIButton!
    @IBOutlet var itemForSearch : UIBarButtonItem!
    @IBOutlet var tblForNotes : UITableView!
    var messageFrame = UIView()
    var activityIndicator = UIActivityIndicatorView()
    var strLabel = UILabel()
    var currentIndex:Int!
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        // Custom initialization
    }
    
    
    
    @IBAction func btnAddNewContact(sender: AnyObject) {
        var contactdata:[String:String]!
        
        dispatch_async(dispatch_get_main_queue(),{
            self.alert = UIAlertController(title: "Add new contact", message: "Please Fill details", preferredStyle: .Alert)
            
            //2. Add the text field. You can configure it however you need.
            self.alert.addTextFieldWithConfigurationHandler({(textField: UITextField!) in
                textField.placeholder = "First Name"
                textField.secureTextEntry = false
                // textField.addTarget(self, action: "textChanged", forControlEvents: .EditingChanged)
            })
            
            self.alert.addTextFieldWithConfigurationHandler({(textField: UITextField!) in
                textField.placeholder = "Last Name"
                textField.secureTextEntry = false
                // textField.addTarget(self, action: "textChanged", forControlEvents: .EditingChanged)
            })
            
            self.alert.addTextFieldWithConfigurationHandler({(textField: UITextField!) in
                textField.placeholder = "Phone Number"
                textField.secureTextEntry = false
                //textField.addTarget(self, action: "textChanged", forControlEvents: .EditingChanged)
            })
            
            /* alert.addTextFieldWithConfigurationHandler({ (textField) -> Void in
             textField.text = ""
             })*/
            
            var cancelAction=UIAlertAction(title: "Cancel", style: .Cancel, handler: { (action) -> Void in
                
                
                
            })
            
            //3. Grab the value from the text field, and print it when the user clicks OK.
            var okAction=UIAlertAction(title: "Ok", style: .Default, handler: { (action) -> Void in
                
                let textFieldFname = self.alert.textFields![0] as UITextField
                let textFieldLname = self.alert.textFields![1] as UITextField
                let textFieldPhone = self.alert.textFields![2] as UITextField
                //username = textField.text!
                // print("Text field: \(textField.text)")
                contactdata=["fname":textFieldFname.text!,"lname":textFieldLname.text!,"phone":textFieldPhone.text!]
                
                contactsList.saveToAddressBook(contactdata){(result) -> () in
                    if(result==true)
                    {
                        var alert = UIAlertController(title: "Add new contact", message: "Please Fill details", preferredStyle: .Alert)
                        
                    }
                    
                }})
            
            
            
            self.alert.addAction(cancelAction)
            self.alert.addAction(okAction)
            // self.alert.actions[1].enabled=false
            
            self.presentViewController(self.alert, animated: true, completion:
                {
                    
                    
            })
            
            
            // contactsList.saveToAddressBook(["fname":"kibo new user","lname":"","phone":"1234567890"])
            print("new contact added")
            
            
            
        })
    }
    
    /* func textChanged(textField: UITextField) {
     //TODO: Text changed handler
     //if(sender.text != "")
     //{
     if(textField.text != "")
     {
     alert.actions[1].enabled=true
     }
     //}
     }*/
    
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
    
   /* override func viewWillLayoutSubviews() {
        
        var rect = tblForNotes.tableHeaderView!.frame;
        //rect.origin.y =
       // rect.origin.y = MIN(0, self.contentOffset.y);
        tblForNotes.tableHeaderView!.frame = rect;
    }*/
    func configureSearchController() {
        // Initialize and perform a minimum configuration to the search controller.
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search here..."
        searchController.searchBar.delegate = self
        //searchController.searchBar.sizeToFit()
        
        
        // Place the search bar view to the tableview headerview.
        tblForNotes.tableHeaderView = searchController.searchBar
    }
    
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        shouldShowSearchResults = true
        tblForNotes.reloadData()
    }
    
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        shouldShowSearchResults = false
        tblForNotes.reloadData()
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        if !shouldShowSearchResults {
            shouldShowSearchResults = true
            tblForNotes.reloadData()
        }
        
        searchController.searchBar.resignFirstResponder()
    }
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        let searchString = searchController.searchBar.text
        let name = Expression<String?>("name")
        // Filter the data array and get only those countries that match the search text.
        filteredArray = alladdressContactsArray.filter({ (contactname) -> Bool in
            let countryText: NSString = contactname.get(name)!
            
            return (countryText.rangeOfString(searchString!, options: NSStringCompareOptions.CaseInsensitiveSearch).location) != NSNotFound
        })
        
        // Reload the tableview.
        tblForNotes.reloadData()
    }
    
    
    
    override func viewWillAppear(animated: Bool) {
        
        tblForNotes.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contactsList.delegate=self
        self.navigationItem.titleView = viewForTitle
        //self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: btnForLogo)
        //self.navigationItem.rightBarButtonItem = itemForSearch
        self.tabBarController?.tabBar.tintColor = UIColor.greenColor()
        
        
        var allcontactslist1=sqliteDB.allcontacts
        
        
        let phone = Expression<String>("phone")
        let kibocontact = Expression<Bool>("kiboContact")
        let name = Expression<String?>("name")
        let email = Expression<String?>("email")
        
        //alladdressContactsArray = Array(try sqliteDB.db.prepare(allcontactslist1))
        
        
        configureSearchController()
        do
        {alladdressContactsArray = Array(try sqliteDB.db.prepare(allcontactslist1))
            
        }
        catch
        {
            
        }
        
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
        if shouldShowSearchResults {
            return filteredArray.count
        }
        else
        {
            return alladdressContactsArray.count
        }
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
        
        /////////////%%%'5 cellPrivate.labelNamePrivate.text=contacts[indexPath.row].givenName+" "+contacts[indexPath.row].familyName
        
        // %%%%%%%%%%%%%%%%%%%%%%%%%_------------------------- need to show names also ------
        
        
        var allcontactslist1=sqliteDB.allcontacts
        var alladdressContactsArray:Array<Row>
        
        let phone = Expression<String>("phone")
        let kibocontact = Expression<Bool>("kiboContact")
        let name = Expression<String?>("name")
        
        //alladdressContactsArray = Array(try sqliteDB.db.prepare(allcontactslist1))
        
        
        do
        {alladdressContactsArray = Array(try sqliteDB.db.prepare(allcontactslist1))
            
            if shouldShowSearchResults {
                cellPrivate.labelNamePrivate.text=filteredArray[indexPath.row].get(name)
                if(filteredArray[indexPath.row].get(kibocontact)==true)
                {
                    cellPrivate.labelStatusPrivate.hidden=false
                }
            }
            else
            {
                cellPrivate.labelNamePrivate.text=alladdressContactsArray[indexPath.row].get(name)
                if(alladdressContactsArray[indexPath.row].get(kibocontact)==true)
                {
                    cellPrivate.labelStatusPrivate.hidden=false
                }
            }
            //alladdressContactsArray[indexPath.row].
            
        }
        catch{
            print("error 123")
        }
        /*
         
         if (contacts[indexPath.row].isKeyAvailable(CNContactPhoneNumbersKey)) {
         for phoneNumber:CNLabeledValue in contacts[indexPath.row].phoneNumbers {
         let a = phoneNumber.value as! CNPhoneNumber
         //print("\()
         var phone=a.valueForKey("digits") as! String
         for(var i=0;i<availableEmailsList.count;i++)
         {
         if(phone == availableEmailsList[i])
         {
         cellPrivate.labelStatusPrivate.hidden=false
         }
         
         }
         
         }
         }*/
        
        /*do{
         let em = try contacts[indexPath.row].emailAddresses.first
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
         }*/
        
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
    
    
    /* func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!){
     
     
     //let indexPath = tableView.indexPathForSelectedRow();
     //let currentCell = tableView.cellForRowAtIndexPath(indexPath!) as UITableViewCell!;
     
     //print(ContactNames[indexPath.row], terminator: "")
     self.performSegueWithIdentifier("contactDetailsSegue", sender: nil);
     //slideToChat
     
     }*/
    
    
    // #pragma mark - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue?, sender: AnyObject?) {
        
        if segue!.identifier == "contactDetailsSegue" {
            print("contactDetailsSegue")
            let contactsDetailController = segue!.destinationViewController as? contactsDetailsTableViewController
            //let addItemViewController = navigationController?.topViewController as? AddItemViewController
            
            if let viewController = contactsDetailController {
                contactsDetailController?.contactIndex=tblForNotes.indexPathForSelectedRow!.row
                var cell=tblForNotes.cellForRowAtIndexPath(tblForNotes.indexPathForSelectedRow!) as! AllContactsCell
                if(cell.labelStatusPrivate.hidden==false)
                {
                    contactsDetailController?.isKiboContact = true
                    //print("hidden falseeeeeee")
                }
                
                
            }
        }
        
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    
    
    func receivedContactsUpdateUI() {
        
        tblForNotes.reloadData()
    }
}