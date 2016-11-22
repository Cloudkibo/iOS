//
//  EPContactsPicker.swift
//  EPContacts
//
//  Created by Prabaharan Elangovan on 12/10/15.
//  Copyright © 2015 Prabaharan Elangovan. All rights reserved.
//

import UIKit
import Contacts
import SQLite

@objc public protocol EPPickerDelegate {
    optional    func epContactPicker(_: EPContactsPicker, didContactFetchFailed error: NSError)
    optional    func epContactPicker(_: EPContactsPicker, didCancel error: NSError)
    optional    func epContactPicker(_: EPContactsPicker, didSelectContact contact: EPContact)
    optional    func epContactPicker(_: EPContactsPicker, didSelectMultipleContacts contacts: [EPContact])

}

typealias ContactsHandler = (contacts : [CNContact] , error : NSError?) -> Void

public enum SubtitleCellValue{
    case PhoneNumber
    case Email
    case Birthday
    case Organization
}

public class EPContactsPicker: UITableViewController, UISearchResultsUpdating, UISearchBarDelegate {
    
    // MARK: - Properties
    
    var alreadySelectedContactsIdentifiers=[String]() // already selected so disable
    public var contactDelegate: EPPickerDelegate?
    var contactsStore: CNContactStore?
    var resultSearchController = UISearchController()
    var orderedContacts = [String: [CNContact]]() //Contacts ordered in dicitonary alphabetically
    var sortedContactKeys = [String]()
    
    var selectedContacts = [EPContact]()
    var filteredContacts = [CNContact]()
    
    var subtitleCellValue = SubtitleCellValue.PhoneNumber
    var multiSelectEnabled: Bool = false //Default is single selection contact
    
    // MARK: - Lifecycle Methods
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        self.title = EPGlobalConstants.Strings.contactsTitle
        print("loading group contacts")
        registerContactCell()
        inititlizeBarButtons()
        initializeSearchBar()
        reloadContacts()
    }
    
    public override func viewWillAppear(animated: Bool) {
        
        print("group contacts will appear")
    }
    
    func initializeSearchBar() {
        self.resultSearchController = ( {
            let controller = UISearchController(searchResultsController: nil)
            controller.searchResultsUpdater = self
            controller.dimsBackgroundDuringPresentation = false
            controller.searchBar.sizeToFit()
            
            controller.searchBar.delegate = self
            self.tableView.tableHeaderView = controller.searchBar
            return controller
        })()
    }
    
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet() as NSCharacterSet).uppercaseString
        
        if (cString.hasPrefix("#")) {
            cString = cString.substringFromIndex(cString.startIndex.advancedBy(1))
        }
        
        if ((cString.characters.count) != 6) {
            return UIColor.grayColor()
        }
        
        var rgbValue:UInt32 = 0
        NSScanner(string: cString).scanHexInt(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    func inititlizeBarButtons() {
        
     //   self.navigationItem.titleView?.tintColor=UIColor.blackColor()
        self.navigationController?.navigationBar.barTintColor=hexStringToUIColor("#1E9530")  //      self.navigationController?.navigationBar.30 149 48   #1E9530
    //    UIColor(
    
        self.navigationItem.title="Add Participants"
        self.navigationController?.navigationBar.tintColor=UIColor.whiteColor()
       // self.navigationItem.titleView?.tintColor=UIColor.blackColor()
        let cancelButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Cancel, target: self, action: #selector(onTouchCancelButton))
        self.navigationItem.leftBarButtonItem = cancelButton
        if multiSelectEnabled {
            let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: #selector(onTouchDoneButton))
            
            self.navigationItem.rightBarButtonItem = doneButton
            self.navigationItem.rightBarButtonItem?.title="Create"
            
            
        }
    }
    
    private func registerContactCell() {
        
        let podBundle = NSBundle(forClass: self.classForCoder)
        if let bundleURL = podBundle.URLForResource(EPGlobalConstants.Strings.bundleIdentifier, withExtension: "bundle") {
            
            if let bundle = NSBundle(URL: bundleURL) {
                
                let cellNib = UINib(nibName: EPGlobalConstants.Strings.cellNibIdentifier, bundle: bundle)
                tableView.registerNib(cellNib, forCellReuseIdentifier: "Cell")
            }
            else {
                assertionFailure("Could not load bundle")
            }
        }
        else {
            
            let cellNib = UINib(nibName: EPGlobalConstants.Strings.cellNibIdentifier, bundle: nil)
            tableView.registerNib(cellNib, forCellReuseIdentifier: "Cell")
        }
    }

    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Initializers
  
    convenience public init(delegate: EPPickerDelegate?) {
        self.init(delegate: delegate, multiSelection: false)
    }
    
    convenience public init(delegate: EPPickerDelegate?, multiSelection : Bool) {
        self.init(style: .Plain)
        self.multiSelectEnabled = multiSelection
        contactDelegate = delegate
    }

    convenience public init(delegate: EPPickerDelegate?, multiSelection : Bool, subtitleCellType: SubtitleCellValue) {
        self.init(style: .Plain)
        self.multiSelectEnabled = multiSelection
        contactDelegate = delegate
        subtitleCellValue = subtitleCellType
    }
    
    convenience public init(delegate: EPPickerDelegate?, multiSelection : Bool, subtitleCellType: SubtitleCellValue,alreadySelectedContactsIdentifiers:[String]) {
        self.init(style: .Plain)
        self.multiSelectEnabled = multiSelection
        contactDelegate = delegate
        subtitleCellValue = subtitleCellType
        self.alreadySelectedContactsIdentifiers=alreadySelectedContactsIdentifiers
    }
    
    // MARK: - Contact Operations
  
      public func reloadContacts() {
        getContacts( {(contacts, error) in
            if (error == nil) {
                dispatch_async(dispatch_get_main_queue(), {
                    self.tableView.reloadData()
                })
            }
        })
      }
  
    func getContacts(completion:  ContactsHandler) {
        if contactsStore == nil {
            //ContactStore is control for accessing the Contacts
            contactsStore = CNContactStore()
        }
        let error = NSError(domain: "EPContactPickerErrorDomain", code: 1, userInfo: [NSLocalizedDescriptionKey: "No Contacts Access"])
        
        switch CNContactStore.authorizationStatusForEntityType(CNEntityType.Contacts) {
            case CNAuthorizationStatus.Denied, CNAuthorizationStatus.Restricted:
                //User has denied the current app to access the contacts.
                
                let productName = NSBundle.mainBundle().infoDictionary!["CFBundleName"]!
                
                let alert = UIAlertController(title: "Unable to access contacts", message: "\(productName) does not have access to contacts. Kindly enable it in privacy settings ", preferredStyle: UIAlertControllerStyle.Alert)
                let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: {  action in
                    self.contactDelegate?.epContactPicker!(self, didContactFetchFailed: error)
                    completion(contacts: [], error: error)
                    self.dismissViewControllerAnimated(true, completion: nil)
                })
                alert.addAction(okAction)
                self.presentViewController(alert, animated: true, completion: nil)
            
            case CNAuthorizationStatus.NotDetermined:
                //This case means the user is prompted for the first time for allowing contacts
                contactsStore?.requestAccessForEntityType(CNEntityType.Contacts, completionHandler: { (granted, error) -> Void in
                    //At this point an alert is provided to the user to provide access to contacts. This will get invoked if a user responds to the alert
                    if  (!granted ){
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            completion(contacts: [], error: error!)
                        })
                    }
                    else{
                        self.getContacts(completion)
                    }
                })
            
            case  CNAuthorizationStatus.Authorized:
                //Authorization granted by user for this app.
                var contactsArray = [CNContact]()
                
                let contactFetchRequest = CNContactFetchRequest(keysToFetch: allowedContactKeys())
                
                do {
                    try contactsStore?.enumerateContactsWithFetchRequest(contactFetchRequest, usingBlock: { (contact, stop) -> Void in
                        //Ordering contacts based on alphabets in firstname
                        //check in database  contact.identifier
                        
                        var allcontactslist1=sqliteDB.allcontacts
                        var alladdressContactsArray:Array<Row>
                        
                        //let phone = Expression<String>("phone")
                        let kibocontact = Expression<Bool>("kiboContact")
                        let name = Expression<String?>("name")
                        /////////////let contactProfileImage = Expression<NSData>("profileimage")
                        let uniqueidentifier = Expression<String>("uniqueidentifier")
                        
                        
                        //  alladdressContactsArray = Array(try sqliteDB.db.prepare(allcontactslist1))
                        //alladdressContactsArray[indexPath.row].get(name)
                        do{for ccc in try sqliteDB.db.prepare(allcontactslist1) {
                            if(ccc[uniqueidentifier] == contact.identifier)
                            {
                                
                            }
                            
                            
                            
                            }
                        }catch{}
                        
                        contactsArray.append(contact)
                        var key: String = "#"
                        //If ordering has to be happening via family name change it here.
                        if let firstLetter = contact.givenName[0..<1] where firstLetter.containsAlphabets() {
                            key = firstLetter.uppercaseString
                        }
                        var contacts = [CNContact]()
                        
                        if let segregatedContact = self.orderedContacts[key] {
                            contacts = segregatedContact
                        }
                        contacts.append(contact)
                        self.orderedContacts[key] = contacts

                    })
                    self.sortedContactKeys = Array(self.orderedContacts.keys).sort(<)
                    if self.sortedContactKeys.first == "#" {
                        self.sortedContactKeys.removeFirst()
                        self.sortedContactKeys.append("#")
                    }
                    completion(contacts: contactsArray, error: nil)
                }
                //Catching exception as enumerateContactsWithFetchRequest can throw errors
                catch let error as NSError {
                    print(error.localizedDescription)
                }
            
        }
    }
    
    func allowedContactKeys() -> [CNKeyDescriptor]{
        //We have to provide only the keys which we have to access. We should avoid unnecessary keys when fetching the contact. Reducing the keys means faster the access.
        return [CNContactNamePrefixKey,
            CNContactGivenNameKey,
            CNContactFamilyNameKey,
            CNContactOrganizationNameKey,
            CNContactBirthdayKey,
            CNContactImageDataKey,
            CNContactThumbnailImageDataKey,
            CNContactImageDataAvailableKey,
            CNContactPhoneNumbersKey,
            CNContactEmailAddressesKey,
        ]
    }
    
    // MARK: - Table View DataSource
    
    override public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if resultSearchController.active { return 1 }
        return sortedContactKeys.count
    }
    
    override public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if resultSearchController.active { return filteredContacts.count }
        if let contactsForSection = orderedContacts[sortedContactKeys[section]] {
            return contactsForSection.count
        }
        return 0
    }

    // MARK: - Table View Delegates

    func checkIfAlreadySelected(newcontact:CNContact)->Bool
    {
        var alreadyselected=false
        //match identifier
        for(var i=0;i<alreadySelectedContactsIdentifiers.count;i++)
        {
            if(newcontact.identifier == alreadySelectedContactsIdentifiers[i])
            {
                alreadyselected=true
                break
            }
            
        }
        return alreadyselected
    }
    
    override public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! EPContactCell
        cell.accessoryType = UITableViewCellAccessoryType.None
        //Convert CNContact to EPContact
        var contact = EPContact()
        var alreadyselected=false
        if resultSearchController.active {
            contact = EPContact(contact: filteredContacts[indexPath.row])
            alreadyselected=checkIfAlreadySelected(filteredContacts[indexPath.row])
            
            /*if(contact.isKiboContact())
            {
                cell.userInteractionEnabled=false
                cell.contactDetailTextLabel.textColor=UIColor.grayColor()
                cell.contactDetailTextLabel.text="Not a kibo contact"
            }*/
            
        } else {
            if let contactsForSection = orderedContacts[sortedContactKeys[indexPath.section]] {
                contact =  EPContact(contact: contactsForSection[indexPath.row])
                alreadyselected=checkIfAlreadySelected(contactsForSection[indexPath.row])
            }
        }
        if multiSelectEnabled  && selectedContacts.contains({ $0.contactId == contact.contactId }) {
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
        }
        cell.updateContactsinUI(contact, indexPath: indexPath, subtitleType: subtitleCellValue, isalreadyselected: alreadyselected)
        return cell
    }
    
    func checkIfKiboContact(identifier1:String)
    {
        //pick phone using identifier in allcontacts table
        //join with contactlist to match phone number
    }
    
    override public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! EPContactCell
        let selectedContact =  cell.contact!
        if multiSelectEnabled {
            //Keeps track of enable=ing and disabling contacts
            if cell.accessoryType == UITableViewCellAccessoryType.Checkmark {
                cell.accessoryType = UITableViewCellAccessoryType.None
                selectedContacts = selectedContacts.filter(){
                    return selectedContact.contactId != $0.contactId
                }
            }
            else {
                cell.accessoryType = UITableViewCellAccessoryType.Checkmark
                selectedContacts.append(selectedContact)
            }
        }
        else {
            //Single selection code
            contactDelegate?.epContactPicker!(self, didSelectContact: selectedContact)
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    override public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60.0
    }
    
    override public func tableView(tableView: UITableView, sectionForSectionIndexTitle title: String, atIndex index: Int) -> Int {
        if resultSearchController.active { return 0 }
        tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: 0, inSection: index), atScrollPosition: UITableViewScrollPosition.Top , animated: false)        
        return sortedContactKeys.indexOf(title)!
    }
    
    override  public func sectionIndexTitlesForTableView(tableView: UITableView) -> [String]? {
        if resultSearchController.active { return nil }
        return sortedContactKeys
    }

    override public func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if resultSearchController.active { return nil }
        return sortedContactKeys[section]
    }
    
    // MARK: - Button Actions
    
    func onTouchCancelButton() {
        contactDelegate?.epContactPicker!(self, didCancel: NSError(domain: "EPContactPickerErrorDomain", code: 2, userInfo: [ NSLocalizedDescriptionKey: "User Canceled Selection"]))
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func onTouchDoneButton() {
        contactDelegate?.epContactPicker!(self, didSelectMultipleContacts: selectedContacts)
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - Search Actions
    
    public func updateSearchResultsForSearchController(searchController: UISearchController)
    {
        if let searchText = resultSearchController.searchBar.text where searchController.active {
            
            let predicate: NSPredicate
            if searchText.characters.count > 0 {
                predicate = CNContact.predicateForContactsMatchingName(searchText)
            } else {
                predicate = CNContact.predicateForContactsInContainerWithIdentifier(contactsStore!.defaultContainerIdentifier())
            }
            
            let store = CNContactStore()
            do {
                filteredContacts = try store.unifiedContactsMatchingPredicate(predicate,
                    keysToFetch: allowedContactKeys())
                
                //print("\(filteredContacts.count) count")
                
                self.tableView.reloadData()
                
            }
            catch {
                print("Error!")
            }
        }
    }
    
    public func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        
        dispatch_async(dispatch_get_main_queue(), {
            self.tableView.reloadData()
        })
    }
    
}
