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
import ContactsUI
import Kingfisher
//import Haneke


class AddParticipantsViewController: UIViewController,InviteContactsDelegate,UITextFieldDelegate,UISearchBarDelegate,UISearchDisplayDelegate/*,UISearchResultsUpdating*/,UIScrollViewDelegate,RefreshContactsList,UITableViewDelegate,UITableViewDataSource {
    
    
    var groupid=""
    var identifiersarrayAlreadySelected=[String]()
    var editbroadcastlistID=""
    var prevScreen=""
    var participantsSelected1=[EPContact]()
    var selectedcontacts=[CNContact]()
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
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        // Custom initialization
    }
    

    
   
    func addToBroadcastList()
    {
        
        var memberphones=[String]()
        var membersnames=[String]()
        for i in 0 .. participantsSelected1.count
        {print("appending memberphone now of participantselected \(participantsSelected1[i].getPhoneNumber())")
            memberphones.append(participantsSelected1[i].getPhoneNumber())
            membersnames.append(participantsSelected1[i].displayName())
            //self.messages.addObject(["member_phone":memberphones[i],"name":membersnames[i],"isAdmin":"No"])
            
            //tblGroupInfo.reloadData()
            
        }
        
        var broadcastlistID=UtilityFunctions.init().generateUniqueid()
        sqliteDB.storeBroadcastList(broadcastlistID, ListName1: "")
        sqliteDB.storeBroadcastListMembers(broadcastlistID, memberphones: memberphones)
       // let next = self.storyboard?.instantiateViewControllerWithIdentifier("BroadcastListView") as! BroadcastListViewController
      //  self.dismissViewControllerAnimated(true, completion: nil);
        
        
       /* self.presentViewController(next, animated: true, completion: {
         
            })*/
        
        
       self.performSegue(withIdentifier: "GoToBroadCastSegue", sender: nil);
        
        //self.dismissViewControllerAnimated(true, completion: nil);
        //retrieveBroadCastLists()
        //===----tblBroadcastList.reloadData()
        
        
    }
    func updateBroadcastList()
    {
        
        var memberphones=[String]()
        var membersnames=[String]()
        for i in 0 .. participantsSelected1.count
        {print("appending memberphone now of participantselected \(participantsSelected1[i].getPhoneNumber())")
            memberphones.append(participantsSelected1[i].getPhoneNumber())
            membersnames.append(participantsSelected1[i].displayName())
            //self.messages.addObject(["member_phone":memberphones[i],"name":membersnames[i],"isAdmin":"No"])
            
            //tblGroupInfo.reloadData()
            
        }
        
        //==----var broadcastlistID=UtilityFunctions.init().generateUniqueid()
        //==----sqliteDB.storeBroadcastList(broadcastlistID, ListName1: "")
        sqliteDB.UpdateBroadcastlistMembers(self.editbroadcastlistID, members: memberphones)
        // let next = self.storyboard?.instantiateViewControllerWithIdentifier("BroadcastListView") as! BroadcastListViewController
        //  self.dismissViewControllerAnimated(true, completion: nil);
        
        
        /* self.presentViewController(next, animated: true, completion: {
         
         })*/
        
        
        self.performSegue(withIdentifier: "GoToBroadCastSegue", sender: nil);
        
        //self.dismissViewControllerAnimated(true, completion: nil);
        //retrieveBroadCastLists()
        //===----tblBroadcastList.reloadData()
        
        
    }
    
    @IBAction func btnAddNewContact(_ sender: AnyObject) {
        var contactdata:[String:String]!
        
        
        if(prevScreen=="newGroup")
        {
         //participantsSelected.appendContentsOf(selectedcontacts)
         self.performSegue(withIdentifier: "newGroupDetailsSegue1", sender: nil);
        }
        if(prevScreen=="newBroadcastList")
        {
            addToBroadcastList()
           // self.dismissViewControllerAnimated(true, completion: nil);
        }
        if(prevScreen=="editbroadcastlist")
        {
            self.updateBroadcastList()
            // self.dismissViewControllerAnimated(true, completion: nil);
        }
        //Groupinfo
        if(prevScreen=="Groupinfo")
        {
            self.performSegue(withIdentifier: "gobackToGroupInfoSegue",sender: nil)
            //self.updateBroadcastList()
            // self.dismissViewControllerAnimated(true, completion: nil);
        }
      
        
         
        /* for contact in contacts {
         print("\(contact.displayName())")
         }*/
         
 
        
        
      /*  dispatch_async(dispatch_get_main_queue(),{
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
        */
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
    
    func progressBarDisplayer(_ msg:String, _ indicator:Bool ) {
        print(msg)
        strLabel = UILabel(frame: CGRect(x: 50, y: 0, width: 250, height: 50))
        strLabel.text = msg
        strLabel.textColor = UIColor.white
        messageFrame = UIView(frame: CGRect(x: view.frame.midX - 110, y: view.frame.midY - 25 , width: 230, height: 50))
        messageFrame.layer.cornerRadius = 15
        messageFrame.backgroundColor = UIColor(white: 0, alpha: 0.7)
        if indicator {
            activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.white)
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
    
    
    
    func filterContentForSearchText(_ searchText: String) {
        // Filter the array using the filter method
        
        
        if self.alladdressContactsArray.count == 0 {
            self.filteredArray.removeAll()
            return
        }
        
        let name = Expression<String?>("name")
        // Filter the data array and get only those countries that match the search text.
        filteredArray = alladdressContactsArray.filter({ (contactname) -> Bool in
            let countryText: NSString = contactname.get(name)! as NSString
            
            return (countryText.rangeOfString(searchText, options: NSString.CompareOptions.CaseInsensitiveSearch).location) != NSNotFound
        })
        
      tblForNotes.reloadData()
       /* self.speciesSearchResults = self.species!.filter({( aSpecies: StarWarsSpecies) -> Bool in
            // to start, let's just search by name
            return aSpecies.name!.lowercaseString.rangeOfString(searchText.lowercaseString) != nil
        })*/
    }
    
    func searchDisplayController(_ controller: UISearchDisplayController!, shouldReloadTableForSearch searchString: String!) -> Bool {
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
    
    let phone = Expression<String>("phone")
    let kibocontact = Expression<Bool>("kiboContact")
    let name = Expression<String?>("name")
    let email = Expression<String?>("email")
    let uniqueidentifier = Expression<String?>("uniqueidentifier")
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        let allcontactslist1=sqliteDB.allcontacts
        
       
        //alladdressContactsArray = Array(try sqliteDB.db.prepare(allcontactslist1))
        
        if(prevScreen=="newBroadcastList")
            
        {
            if(participantsSelected1.count<2)
            {
                navigationItem.rightBarButtonItem?.isEnabled=false
            }
            else
            {
                navigationItem.rightBarButtonItem?.isEnabled=true
                
            }
        }
        //////configureSearchController()
        do
        {alladdressContactsArray = Array(try sqliteDB.db.prepare((allcontactslist1?.filter(kibocontact==true).order(name.asc))!))
            
            tblForNotes.reloadData()
        }
        catch
        {
            
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contactsList.delegate=self
      //  self.navigationItem.titleView. = "Add Participants"
        
        self.searchDisplayController?.searchBar.tintColor=UIColor.blue
        ////self.searchDisplayController?.searchBar.barTintColor=UIColor.redColor()
        
         //self.searchDisplayController?.navigationItem?.title="Searchhh"
      ///  self.searchDisplayController?.displaysSearchBarInNavigationBar=true
        self.searchDisplayController!.searchBar.searchBarStyle = UISearchBarStyle.default
        
        // Include the search bar within the navigation bar.
       /// self.navigationItem.titleView = self.searchDisplayController!.searchBar;
        
        self.definesPresentationContext = true;
        
        
        
        //self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: btnForLogo)
        //self.navigationItem.rightBarButtonItem = itemForSearch
        self.tabBarController?.tabBar.tintColor = UIColor.green
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
    
    
    
    @IBAction func unwindToChat (_ segueSelected : UIStoryboardSegue) {
        
    }
    
    func tableView(_ tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
         if tableView == self.searchDisplayController!.searchResultsTableView {
        //if shouldShowSearchResults {
            return filteredArray.count
        }
        else
        {
            return alladdressContactsArray.count
        }
    }
    
    func numberOfSections(in tableView: UITableView!) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView!, cellForRowAt indexPath: IndexPath) -> UITableViewCell! {
        //if (indexPath.row%2 == 0){
        //var cellPrivate = tblForNotes.dequeueReusableCellWithIdentifier("NotePrivateCell")! as UITableViewCell
        
        let email = Expression<String>("email")
        
        
       // let tbl_contactslist = sqliteDB.contactslists
        var cellPrivate = tblForNotes.dequeueReusableCell(withIdentifier: "NotePrivateCell1")! as! AllContactsCell
        cellPrivate.isUserInteractionEnabled=true
        
        print("namelist count is \(nameList.count)")
        //cellPrivate.labelNamePrivate.text=nameList[indexPath.row]
        
        cellPrivate.lbl_new_subtitle.isHidden=true
        cellPrivate.accessoryType = UITableViewCellAccessoryType.none
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
                cellPrivate.lbl_new_name.text=filteredArray[indexPath.row].get(name)
                cellPrivate.lbl_new_subtitle.text=filteredArray[indexPath.row].get(phone)
                if(filteredArray[indexPath.row].get(kibocontact)==true)
                {
                    cellPrivate.lbl_new_subtitle.isHidden=false
                    
                    // @IBOutlet weak var lbl_new_name: UILabel!
                   // @IBOutlet weak var lbl_new_subtitle: UILabel!
                }
            }
            else
            {
                cellPrivate.lbl_new_name.text=alladdressContactsArray[indexPath.row].get(name)
               
                cellPrivate.lbl_new_subtitle.text=alladdressContactsArray[indexPath.row].get(phone)
                
                //if already a member
                if(alladdressContactsArray[indexPath.row].get(kibocontact)==true)
                {
                    cellPrivate.lbl_new_subtitle.isHidden=false
                    
                    if(prevScreen=="Groupinfo" && identifiersarrayAlreadySelected.count>0)
                    {
                        print("identifiersarrayAlreadySelected is \(identifiersarrayAlreadySelected)")
                        for eachh in identifiersarrayAlreadySelected
                        {
                            if(alladdressContactsArray[indexPath.row].get(uniqueidentifier)! == eachh)
                            {
                                print("alrady member")
                               cellPrivate.lbl_new_subtitle.text="Already a member"
                                cellPrivate.isUserInteractionEnabled=false
                            }
                            
                        }
                    }
                    
                    
                    
                    var found=UtilityFunctions.init().findContact(alladdressContactsArray[indexPath.row].get(uniqueidentifier)!).first!
                    
                    
                    var foundid=alladdressContactsArray[indexPath.row].get(uniqueidentifier)!
                    var count=0
                    for eachh in participantsSelected1
                    {
                        if(eachh.contactId==alladdressContactsArray[indexPath.row].get(uniqueidentifier)!)
                        {
                            //found selected contact
                            cellPrivate.accessoryType = UITableViewCellAccessoryType.checkmark
                           //==-- participantsSelected1.removeAtIndex(count)
                            
                           //==--- break
                        }
                        count += 1
                    }
                    
                    
                    /*print("index below is \(indexPath.row)")
                    var found=UtilityFunctions.init().findContact(alladdressContactsArray[indexPath.row].get(uniqueidentifier)!)
                    selectedCell.accessoryType = UITableViewCellAccessoryType.None
                    
                    // participantsSelected
                    var foundid=alladdressContactsArray[indexPath.row].get(uniqueidentifier)!
                    var count=0
                    for eachh in participantsSelected1
                    {
                        if(eachh.contactId==alladdressContactsArray[indexPath.row].get(uniqueidentifier)!)
                        {
                            participantsSelected1.removeAtIndex(count)
                            
                            break
                        }
                        count++
                    }*/
                    
                    
                    
                    
                    if(found.imageDataAvailable==true)
                    {
                        //foundcontact.imageData
                        cellPrivate.img_avatar.layer.cornerRadius = cellPrivate.img_avatar.frame.size.width/2
                        cellPrivate.img_avatar.clipsToBounds = true
                        //cell.profilePic.hnk_format=Format<UIImage>
                        
                        //var imgURL=URL(dataRepresentation: found.imageData!, relativeTo: URL(string: alladdressContactsArray[indexPath.row].get(phone)))
                        
                        
                        //let path = Bundle.main.path(forResource: "profile-pic1", ofType: "png")
                        //let imgURL = URL(fileURLWithPath: path!)
                        
                        var profilepic=UIImage(data: found.imageData!)
                        
                        ImageCache.default.retrieveImage(forKey: alladdressContactsArray[indexPath.row].get(phone), options: nil) {
                            image, cacheType in
                            if let image = image {
                                print("Get image \(image), cacheType: \(cacheType).")
                                //In this code snippet, the `cacheType` is .disk
                                
                            } else {
                                print("Not exist in cache.")
                                ImageCache.default.store(profilepic!, forKey: self.alladdressContactsArray[indexPath.row].get(phone))
                                ImageCache.default.isImageCached(forKey: self.alladdressContactsArray[indexPath.row].get(phone))
                                ImageCache.default.isImageCached(forKey: self.alladdressContactsArray[indexPath.row].get(phone))
                                
                            }
                        }
                        
                        
                        cellPrivate.img_avatar.kf.setImage(with: profilepic as! Resource?)
                        
                        var scaledimage=cellPrivate.img_avatar.image?.kf.resize(to: CGSize(width: cellPrivate.img_avatar.bounds.width,height: cellPrivate.img_avatar.bounds.height))
                        
                        
                        //----replacing image lib
                        //var scaledimage=ImageResizer(size: CGSize(width: cellPrivate.img_avatar.bounds.width,height: cellPrivate.img_avatar.bounds.height), scaleMode: .AspectFill, allowUpscaling: true, compressionQuality: 0.5)
                        
                        //var resizedimage=scaledimage.resizeImage(UIImage(data:ContactsProfilePic)!)
                         //cellPrivate.img_avatar.hnk_setImage(scaledimage.resizeImage(UIImage(data:found.imageData!)!))
                        
                        //----replacing image lib
                        //cellPrivate.img_avatar.hnk_setImage(scaledimage.resizeImage(UIImage(data:found.imageData!)!), key: alladdressContactsArray[indexPath.row].get(phone))
                        
                       

                       // memberavatars.append(foundcontact.imageData!)
                        // ContactsProfilePic=foundcontact.imageData!
                        //picfound=true
                    }
                    else{
                        let path = Bundle.main.path(forResource: "profile-pic1", ofType: "png")
                        let imgURL = URL(fileURLWithPath: path!)
                        var profilepic=UIImage(named: "profile-pic1")
                        
                        ImageCache.default.retrieveImage(forKey: "profile-pic1", options: nil) {
                            image, cacheType in
                            if let image = image {
                                print("Get image \(image), cacheType: \(cacheType).")
                                //In this code snippet, the `cacheType` is .disk
                                
                            } else {
                                print("Not exist in cache.")
                                ImageCache.default.store(profilepic!, forKey: "profile-pic1")
                                ImageCache.default.isImageCached(forKey: "profile-pic1")
                                ImageCache.default.isImageCached(forKey: "profile-pic1")
                                
                            }
                        }
                        
                       
                        //var imgURL=URL(UIImage(imageLiteral: "profile-pic1"), relativeTo: URL(string: alladdressContactsArray[indexPath.row].get(phone)))
                        
                        
                        cellPrivate.img_avatar.kf.setImage(with: imgURL)

                        //----replacing image lib
                        
                         //cellPrivate.img_avatar.hnk_setImage(UIImage(imageLiteral: "profile-pic1"), key: alladdressContactsArray[indexPath.row].get(phone))
                     //   memberavatars.append(NSData.init())
                    }

                    
                   
                    
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
    
    func getAddressBookIndex(_ phone1:String)->Int
    {
        var allcontactslist1=sqliteDB.allcontacts
        
        
        let phone = Expression<String>("phone")
        let kibocontact = Expression<Bool>("kiboContact")
        let name = Expression<String?>("name")
        let email = Expression<String?>("email")
        
        //alladdressContactsArray = Array(try sqliteDB.db.prepare(allcontactslist1))
        
        var alladdressContactsArray=Array<Row>()
        //////configureSearchController()
        var newindexphone = -1
        do
        { alladdressContactsArray = Array(try sqliteDB.db.prepare(allcontactslist1!))
            for i in 0 .. alladdressContactsArray.count
            {
                if(alladdressContactsArray[i].get(phone)==phone1)
                {
                    newindexphone=i
                }
                
            }
        }
        catch
        {
            print("error in finding index in addressbook")
        }
        
        return newindexphone
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
        //let cell=tbl_inviteContacts.dequeueReusableCellWithIdentifier("ContactsInviteCell")! as! ContactsInviteCell
        let selectedCell=tblForNotes.cellForRow(at: indexPath) as! AllContactsCell
        
        //let selectedCell=tbl_inviteContacts.cellForRowAtIndexPath(indexPath)
        //cell.textLabel?.text = "hiii"
        
       if selectedCell.accessoryType == UITableViewCellAccessoryType.none
        {
            selectedCell.accessoryType = UITableViewCellAccessoryType.checkmark
            
            //self.getAddressBookIndex(selectedCell.phone)
            var found=UtilityFunctions.init().findContact(alladdressContactsArray[indexPath.row].get(uniqueidentifier)!)
            
            print("index above is \(indexPath.row)")
            print("selected is \(found.first?.givenName)")
            participantsSelected1.append(EPContact(contact:(found.first!)))
            //===selectedcontacts.append(UtilityFunctions.init().findContact(alladdressContactsArray[newindex].get(uniqueidentifier)))
           // participantsSelected.append(EPContact(contact: UtilityFunctions.init().findContact(alladdressContactsArray[indexPath.row].get(uniqueidentifier)!)).first!)
            
           /* if(sendType=="Mail")
            {
                selectedEmails.append(inviteContactsEmails[indexPath.row])
            }
            else
            {
                
                selectedEmails.append(inviteContactsPhones[indexPath.row])
            }
            */
        }
        else
        {
            print("index below is \(indexPath.row)")
            var found=UtilityFunctions.init().findContact(alladdressContactsArray[indexPath.row].get(uniqueidentifier)!)
            selectedCell.accessoryType = UITableViewCellAccessoryType.none
            
           // participantsSelected
            var foundid=alladdressContactsArray[indexPath.row].get(uniqueidentifier)!
            var count=0
            for eachh in participantsSelected1
            {
                if(eachh.contactId==alladdressContactsArray[indexPath.row].get(uniqueidentifier)!)
                {
                    participantsSelected1.remove(at: count)
                    
                break
                }
                count += 1
            }
           //////-- var searchformat=NSPredicate(format: "contactId = %@",foundid)
            
            //var resultArray=participantsSelected1.filteredArrayUsingPredicate(searchformat)
            //cfpresultArray.first
            
            ///---var foundInd=participantsSelected1.filter
        
            
            
            //participantsSelected1.
          //  var ind=participantsSelected1.indexOf(EPContact(contact:(found.first!)))
          //---=== participantsSelected1.removeAtIndex(foundInd)
            //participantsSelected.removeAtIndex(indexPath.row)
           // var ind=selectedEmails.indexOf(selectedCell.contactEmail.text!)
            // selectedEmails.removeAtIndex(ind!)
        }
        if(prevScreen=="newBroadcastList")
        
        {
          if(participantsSelected1.count<2)
          {
            navigationItem.rightBarButtonItem?.isEnabled=false
            }
            else
          {
            navigationItem.rightBarButtonItem?.isEnabled=true
            
            }
        }
       // print(selectedEmails.description)
        
        
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
    override func prepare(for segue: UIStoryboardSegue?, sender: Any?) {
        
        
        //gobackToGroupInfoSegue
        if segue!.identifier == "gobackToGroupInfoSegue" {
            
            
            if let destinationVC = segue!.destination as? GroupInfo3ViewController{
                //==---destinationVC.participants.removeAll()
                
                //==----destinationVC.addmemberfailed=true
                participantsSelected.removeAll()
                
               // var memberphones=[String]()
                //var membersnames=[String]()
                for i in 0 .. participantsSelected1.count
                {print()
                    
                    //groupinfo participants adding
                    participantsSelected.append(participantsSelected1[i])
                    
                    
                  /*  memberphones.append(participantsSelected1[i].getPhoneNumber())
                    membersnames.append(participantsSelected1[i].displayName())
                    destinationVC.messages.addObject(["member_phone":memberphones[i],"name":membersnames[i],"isAdmin":"No"])
                    */
                    
                    //tblGroupInfo.reloadData()
                    
                }
                
                destinationVC.seguemsg="gobackToGroupInfoSegue"
                destinationVC.groupid=groupid
                //participantsSelected=participantsSelected1
                //  let selectedRow = tblForChat.indexPathForSelectedRow!.row
                
            }}
        
        if segue!.identifier == "newGroupDetailsSegue1" {
            
        
        if let destinationVC = segue!.destination as? NewGroupSetDetails{
            destinationVC.participants.removeAll()
            destinationVC.participants=participantsSelected1
            //  let selectedRow = tblForChat.indexPathForSelectedRow!.row
            
        }}
    
    
        if segue!.identifier == "contactDetailsSegue" {
            print("contactDetailsSegue")
            let contactsDetailController = segue!.destination as? contactsDetailsTableViewController
            //let addItemViewController = navigationController?.topViewController as? AddItemViewController
            
            if let viewController = contactsDetailController {
                
                
                if self.searchDisplayController!.isActive {
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
                        {alladdressContactsArray = Array(try sqliteDB.db.prepare((allcontactslist1?.order(name.asc))!))
                      
                            var selectedphone=filteredArray[indexPath!.row].get(phone)
                            var selectedname=filteredArray[indexPath!.row].get(name)
                            print("selected phone is \(selectedphone)")
                            print("selected phone is \(selectedname)")
                            
                            for i in 0 .. alladdressContactsArray.count
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
                var cell=tblForNotes.cellForRow(at: tblForNotes.indexPathForSelectedRow!) as! AllContactsCell
                if(cell.labelStatusPrivate.isHidden==false)
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
    //let name = Expression<String?>("name")
    
    func receivedContactsUpdateUI() {
         let allcontactslist1=sqliteDB.allcontacts
        do
        {alladdressContactsArray = Array(try sqliteDB.db.prepare((allcontactslist1?.order(name.asc))!))
            
        }
        catch
        {
            
        }
        
        tblForNotes.reloadData()
    }
    
    func refreshContactsList(_ message: String) {
         let allcontactslist1=sqliteDB.allcontacts
        DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.background).async
        {
        do
        {
           
            self.alladdressContactsArray = Array(try sqliteDB.db.prepare((allcontactslist1?.order(self.name.asc))!))
            
            
            DispatchQueue.main.async
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
