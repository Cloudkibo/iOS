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
class NotesViewController: UIViewController,InviteContactsDelegate,UITextFieldDelegate,UISearchBarDelegate,UISearchDisplayDelegate/*,UISearchResultsUpdating*/,UIScrollViewDelegate,RefreshContactsList {
    
    
    var delegateContctsList:RefreshContactsList!
    
    var filteredArray = Array<Row>()
    
    var shouldShowSearchResults = false
    
    //var searchController: UISearchController!
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
    
    /*func scrollViewDidScrollToTop(scrollView: UIScrollView) {
        
        print("scroll1 called")
        let searchBar:UISearchBar = searchController.searchBar
        var searchBarFrame:CGRect = searchBar.frame
        if searchController.active {
            searchBarFrame.origin.y = 10
        }
        else {
            searchBarFrame.origin.y = max(0, scrollView.contentOffset.y + scrollView.contentInset.top)
            
        }
        searchController.searchBar.frame = searchBarFrame
        
    }
    */
    /*func scrollViewDidScroll(scrollView: UIScrollView)
    {/*
     UISearchBar *searchBar = searchDisplayController.searchBar;
     CGRect rect = searchBar.frame;
     rect.origin.y = MIN(0, scrollView.contentOffset.y);
     searchBar.frame = rect;*/
     
       // UISearchBar *searchBar = searchDisplayController.searchBar;
        
         var rect = self.searchDisplayController?.searchBar.frame;
        if self.searchDisplayController!.active {
            rect!.origin.y=scrollView.contentOffset.y
            print("searchbar y value is \(scrollView.contentOffset.y)")
        }
        else
        {
             rect!.origin.y = max(0, scrollView.contentOffset.y);
             print("searchbar y2 value is \(rect!.origin.y)")
        }
       
       
        //rect!.origin.y = min(0, 200);
        self.searchDisplayController?.searchBar.frame = rect!;
        
     
        print("scroll2 called")/*
        let searchBar:UISearchBar = searchController.searchBar
        var rect = searchBar.frame;
        rect.origin.y = 80;
        searchBar.frame = rect;*/
        
        /*
        var tableBounds:CGRect = self.tblForNotes.bounds;
        var searchBarFrame:CGRect = searchBar.frame;
        
        // make sure the search bar stays at the table's original x and y as the content moves
        searchBar.frame = CGRectMake(tblForNotes.frame.origin.x,
                                          tblForNotes.frame.origin.y+50,
                                          searchBarFrame.size.width,
                                          searchBarFrame.size.height
        );*/
    }
    */
    
   /* let searchBar:UISearchBar = searchController.searchBar
    var searchBarFrame:CGRect = searchBar.frame
    if searchController.active {
    searchBarFrame.origin.y = 50
    }
    else {
    searchBarFrame.origin.y = max(0, scrollView.contentOffset.y + scrollView.contentInset.top)
    
    }
    searchController.searchBar.frame = searchBarFrame*/


   /* func configureSearchController() {
        // Initialize and perform a minimum configuration to the search controller.
        
        /*
         
         self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, topOffset, 320, 40)];
         [self.view addSubview:self.searchBar];
         
         self.tableView.contentInset = UIEdgeInsetsMake(self.searchBar.frame.size.height, 0, 0, 0);
         self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(self.searchBar.frame.size.height, 0, 0, 0);
 */
                searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search here..."
        searchController.searchBar.delegate = self
        searchController.searchBar.sizeToFit()
        
        
        // Place the search bar view to the tableview headerview.
       // self.navigationController?.navigationBar.addSubview(searchController.searchBar)
        tblForNotes.tableHeaderView = searchController.searchBar
      
    }
    */
    
   /* func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
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
    */
    
    
    
    func filterContentForSearchText(searchText: String) {
        // Filter the array using the filter method
        
        
        if self.alladdressContactsArray.count == 0 {
            self.filteredArray.removeAll()
            return
        }
        
        let name = Expression<String?>("name")
        // Filter the data array and get only those countries that match the search text.
        filteredArray = alladdressContactsArray.filter({ (contactname) -> Bool in
            let countryText: NSString = contactname.get(name)!
            
            return (countryText.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch).location) != NSNotFound
        })
        
      tblForNotes.reloadData()
       /* self.speciesSearchResults = self.species!.filter({( aSpecies: StarWarsSpecies) -> Bool in
            // to start, let's just search by name
            return aSpecies.name!.lowercaseString.rangeOfString(searchText.lowercaseString) != nil
        })*/
    }
    
    func searchDisplayController(controller: UISearchDisplayController!, shouldReloadTableForSearchString searchString: String!) -> Bool {
        self.filterContentForSearchText(searchString)
        return true
    }
    
    
    /*
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return self.searchDisplayController!.searchBar
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return searchDisplayController!.searchBar.frame.height
    }
    */
    
    override func viewWillAppear(animated: Bool) {
        
        var allcontactslist1=sqliteDB.allcontacts
        
        
        let phone = Expression<String>("phone")
        let kibocontact = Expression<Bool>("kiboContact")
        let name = Expression<String?>("name")
        let email = Expression<String?>("email")
        
        //alladdressContactsArray = Array(try sqliteDB.db.prepare(allcontactslist1))
        
        
        //////configureSearchController()
        do
        {alladdressContactsArray = Array(try sqliteDB.db.prepare(allcontactslist1.order(name.asc)))
            
            tblForNotes.reloadData()
        }
        catch
        {
            
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contactsList.delegate=self
        self.navigationItem.titleView = viewForTitle
        
        self.searchDisplayController?.searchBar.tintColor=UIColor.blueColor()
        ////self.searchDisplayController?.searchBar.barTintColor=UIColor.redColor()
        
         //self.searchDisplayController?.navigationItem?.title="Searchhh"
      ///  self.searchDisplayController?.displaysSearchBarInNavigationBar=true
        self.searchDisplayController!.searchBar.searchBarStyle = UISearchBarStyle.Default
        
        // Include the search bar within the navigation bar.
       /// self.navigationItem.titleView = self.searchDisplayController!.searchBar;
        
        self.definesPresentationContext = true;
        
        
        
        //self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: btnForLogo)
        //self.navigationItem.rightBarButtonItem = itemForSearch
        self.tabBarController?.tabBar.tintColor = UIColor.greenColor()
        syncServiceContacts.delegateRefreshContactsList=self
        
        
    
        
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
         if tableView == self.searchDisplayController!.searchResultsTableView {
        //if shouldShowSearchResults {
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
        
        
        
       // let tbl_contactslist = sqliteDB.contactslists
        var cellPrivate = tblForNotes.dequeueReusableCellWithIdentifier("NotePrivateCell")! as! AllContactsCell
        print("namelist count is \(nameList.count)")
        //cellPrivate.labelNamePrivate.text=nameList[indexPath.row]
        
        cellPrivate.labelStatusPrivate.hidden=true
        
        /////////////%%%'5 cellPrivate.labelNamePrivate.text=contacts[indexPath.row].givenName+" "+contacts[indexPath.row].familyName
        
        // %%%%%%%%%%%%%%%%%%%%%%%%%_------------------------- need to show names also ------
        
        
       /* var allcontactslist1=sqliteDB.allcontacts
        var alladdressContactsArray:Array<Row>
        
        let phone = Expression<String>("phone")
        let kibocontact = Expression<Bool>("kiboContact")
        let name = Expression<String?>("name")
        */
        
        let phone = Expression<String>("phone")
        let kibocontact = Expression<Bool>("kiboContact")
        let name = Expression<String?>("name")
        
        //alladdressContactsArray = Array(try sqliteDB.db.prepare(allcontactslist1))
        
        
       // do
       // {alladdressContactsArray = Array(try sqliteDB.db.prepare(allcontactslist1))
            
            if tableView == self.searchDisplayController!.searchResultsTableView {
            //if shouldShowSearchResults {
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
            
       // }
       // catch{
       //     print("error 123")
        //}
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
                
                
                if self.searchDisplayController!.active {
                    print("searchbar active")
                    let indexPath = self.searchDisplayController?.searchResultsTableView.indexPathForSelectedRow
                    print("selected indexpath of search result is \(indexPath?.row)") //filtered array index
                    if indexPath != nil {
                        
                        var allcontactslist1=sqliteDB.allcontacts
                        var alladdressContactsArray:Array<Row>
                        
                        let phone = Expression<String>("phone")
                        let kibocontact = Expression<Bool>("kiboContact")
                        let name = Expression<String?>("name")
                        
                        //alladdressContactsArray = Array(try sqliteDB.db.prepare(allcontactslist1))
                        var newindexphone=0
                        
                        do
                        {alladdressContactsArray = Array(try sqliteDB.db.prepare(allcontactslist1.order(name.asc)))
                      
                            var selectedphone=filteredArray[indexPath!.row].get(phone)
                            var selectedname=filteredArray[indexPath!.row].get(name)
                            print("selected phone is \(selectedphone)")
                            print("selected phone is \(selectedname)")
                            
                            for (var i=0;i<alladdressContactsArray.count;i++)
                            {
                                if(alladdressContactsArray[i].get(phone)==selectedphone)
                                {
                                    newindexphone=i
                                }
                                
                            }
                            /*
                            var predicate=NSPredicate(format: "phone = %@", selectedphone)
                            var newarray=alladdressContactsArray.filter({_ in alladdressContactsArray[phone]==selectedphone})
                            
                            print("newarray is .. \(newarray.debugDescription)")
                            var newindexphone=alladdressContactsArray.indexOf({ (newarray) -> Bool in
                                
                                print("predicate found")
                                return true
                                
                            })
                            
                            */
                           /* var newindexphone=alladdressContactsArray.indexOf({ (predicate) -> Bool in
                                
                                      print("predicate found")
                                return true
                                
                            })*/
                            print("new index is \(newindexphone)")
                            contactsDetailController?.contactIndex=newindexphone
                            
                            
                             contactsDetailController?.isKiboContact = alladdressContactsArray[newindexphone].get(kibocontact)
                            
                           /* var cell=tblForNotes.cellForRowAtIndexPath(newindexphone!) as! AllContactsCell
                            if(cell.labelStatusPrivate.hidden==false)
                            {
                               
                                //print("hidden falseeeeeee")
                            }*/
                        }
                        catch{
                            print("error 576")
                        }
                        
                            //var resultArray=uploadInfo.filteredArrayUsingPredicate(predicate)
                            //cfpresultArray.first
                            
                            //var foundInd=uploadInfo.indexOfObject(resultArray.first!)
                            
                            //alladdressContactsArray.indexof
                            /*if(filteredArray[indexPath.row].get(kibocontact)==true)
                            {

                            }*/
                        }
                        
                      
                }
                    else{
                    print("search bar not active")
                contactsDetailController?.contactIndex=tblForNotes.indexPathForSelectedRow!.row
                var cell=tblForNotes.cellForRowAtIndexPath(tblForNotes.indexPathForSelectedRow!) as! AllContactsCell
                if(cell.labelStatusPrivate.hidden==false)
                {
                    contactsDetailController?.isKiboContact = true
                    //print("hidden falseeeeeee")
                }
                
                }
            }
        }
        
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    let name = Expression<String?>("name")
    
    func receivedContactsUpdateUI() {
         var allcontactslist1=sqliteDB.allcontacts
        do
        {alladdressContactsArray = Array(try sqliteDB.db.prepare(allcontactslist1.order(name.asc)))
            
        }
        catch
        {
            
        }
        
        tblForNotes.reloadData()
    }
    
    func refreshContactsList(message: String) {
         var allcontactslist1=sqliteDB.allcontacts
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND,0))
        {
        do
        {
           
            self.alladdressContactsArray = Array(try sqliteDB.db.prepare(allcontactslist1.order(self.name.asc)))
            
            
            dispatch_async(dispatch_get_main_queue())
            {
                
            self.tblForNotes.reloadData()
                
            }
            
        }
        catch
        {
            
        }
        }
        
       
        
    }
}