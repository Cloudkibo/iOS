//
//  ChatDetailViewController.swift
//  Chat
//
//  Created by My App Templates Team on 26/08/14.
//  Copyright (c) 2014 My App Templates. All rights reserved.
//

import UIKit
import SwiftyJSON
import SQLite
import Alamofire
import AVFoundation
import MobileCoreServices
import Foundation
import AssetsLibrary
import Photos
import Contacts
import Compression
import ContactsUI
import MediaPlayer
import AVKit
import Kingfisher
import GooglePlacePicker
import GooglePlaces
import GoogleMaps
import ActiveLabel
import MessageUI
//import URLEmbeddedView
//import GoogleMaps

class ChatDetailViewController: UIViewController,SocketClientDelegate,UpdateChatDelegate,UIDocumentPickerDelegate,UIDocumentMenuDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,FileManagerDelegate,showUploadProgressDelegate,UpdateChatViewsDelegate,UpdateSingleChatDetailDelegate,CNContactPickerDelegate,CNContactViewControllerDelegate,UIPickerViewDelegate,AVAudioRecorderDelegate,CLLocationManagerDelegate,insertChatAtLastDelegate,updateChatStatusRowDelegate,insertBulkChatsSyncDelegate,insertBulkChatsStatusesSyncDelegate,ActiveLabelDelegate,MFMessageComposeViewControllerDelegate,CheckConversationWindowOpenDelegate
{
    
    var imgCaption=""
var swipe=false
var isKiboContact="false"
    //var view: UIView!
    var urlTitle=""
    var urlDesc=""
    var urlURL=""
    
    
    var hasURL=false
    var contactCardSelected="0"
    //,UIPickerViewDelegate{
    var contactshared=false
   // weak var viewMap: GMSMapView!
    var delegateInsertChatAtLast:insertChatAtLastDelegate!
    var delegateUpdateChatStatusRow:updateChatStatusRowDelegate!
    var delegateInsertBulkChatSync:insertBulkChatsSyncDelegate!
    var delegateBulkChatStatus:insertBulkChatsStatusesSyncDelegate!
    var checkConvWindowUser:CheckConversationWindowOpenDelegate!
    
    var searchUniqueid:String!=nil
    var scrolledRowIndex = -1
    var isBlocked=false
    var iamblocked=false
    var locationManager = CLLocationManager()
    
    var didFindMyLocation = false
    var audioFilePlayName=""
    var moviePlayer : MPMoviePlayerController!
    var audioPlayer = AVAudioPlayer()
    var Q_serial1=DispatchQueue(label: "Q_serial1",attributes: [])
   
    
    
    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    
    @IBOutlet weak var btnSendAudio: UIButton!
    @IBOutlet weak var btnSendChat: UIButton!
    
    var delegatechatdetail:UpdateSingleChatDetailDelegate!
    var broadcastlistID1=""
    var broadcastlistmessages:NSMutableArray!
    var broadcastMembersPhones=[String]()
   /// var manager = NetworkingManager.sharedManager
    var cellY:CGFloat=0
    var delegateChatRefr:UpdateChatViewsDelegate!

    var delegateProgressUpload:showUploadProgressDelegate!
    var shareMenu = UIAlertController()
    var selectedImage:UIImage!
    var filename=""
    var showKeyboard=false
    var keyFrame:CGRect!
    var keyheight:CGFloat!
    var myfid=0
    var fid:Int!=0
    var fileSize1:UInt64=0
    var filePathImage:String!
    ////** new commented april 2016var fileSize:Int!
    var fileContents:Data!
    var chunknumbertorequest:Int=0
    var numberOfChunksInFileToSave:Double=0
    var filePathReceived:String!
    var fileSizeReceived:Int!
    var fileContentsReceived:Data!
    
    
    var ContactNames=""
    var ContactOnlineStatus:Int!=0
    var delegateChat:UpdateChatDelegate!
    var delegate:SocketClientDelegate!
    //var socketEventID:NSUUID
    var rt=NetworkingLibAlamofire()
    @IBOutlet weak var NewChatNavigationTitle: UINavigationItem!
    @IBOutlet weak var labelToName: UILabel!
    @IBOutlet var tblForChats : UITableView!
    @IBOutlet var chatComposeView : UIView!
    @IBOutlet var txtFldMessage : UITextField!
    
    @IBOutlet weak var btn_chatDeleteHistory: UIBarButtonItem!
    
    var selectedIndex:Int!
    var selectedContact="" //username
    ///////var selectedID=""
    var selectedFirstName=""
    var selectedLastName=""
    var selectedUserObj=JSON("[]")
    let to = Expression<String>("to")
    let from = Expression<String>("from")
    let fromFullName = Expression<String>("fromFullName")
    let msg = Expression<String>("msg")
    let date = Expression<Date>("date")
    
    var tbl_userchats:Table!
    
    var messages:NSMutableArray!
    
  
      override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?)
    {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        //print(NSBundle.debugDescription())
        
        // Custom initialization
    }
    
    func didSelect(_ text: String, type: ActiveType) {
        
        print("did select activelabel \(text) type \(type)")
    }
    
    
    
    @IBAction func btnRecordTouchDown(_ sender: UIButton) {
    
    print("btnRecordTouchDown")
        txtFldMessage.text="< Slide left to cancel".localized
     ////   self.startRecording()
    }
    
    /*
   @IBAction func btnRecordTouchUpInside(_ sender: UIButton) {
    txtFldMessage.text=""
        print("btnRecordTouchUpInside")
          finishRecording(success: true)
        
       
        
    }
   
   */
    
    @IBAction func btnRecordAudioTouchDragExit(_ sender: UIButton) {
        print("btnRecordAudioTouchDragExit")
       
        /*finishRecording(success: false)
        var deleted=audioRecorder.deleteRecording()
        print("audio deleted \(deleted)")
        txtFldMessage.text=""
        //not saved
          //finishRecording(success: false)
        */
        
    }
    
    
    func finishRecording(success: Bool) {
        audioRecorder.stop()
        ////audioRecorder = nil
        
        if !success {
            
            btnSendAudio.setTitle("Record".localized, for: .normal)
            // recording failed :(
        }  else {
            btnSendAudio.setTitle("Record".localized, for: .normal)
            //add audio component
            //save to database
            //send chat
            
            var uniqueID=UtilityFunctions.init().generateUniqueid()
            print("uniqueid audio is \(uniqueID)")
            
            
            let dirPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
            let docsDir1 = dirPaths[0]
            var documentDir=docsDir1 as NSString
            var filePathImage2=documentDir.appendingPathComponent(self.filename)
            
            var furl=URL(string: filePathImage2)
            //print(furl!.pathExtension!)
            //print(furl!.deletingLastPathComponent())
            var ftype=furl!.pathExtension
            var fname=furl!.deletingLastPathComponent()
            var filesize=0
            do {
                let fileAttributes : NSDictionary? = try FileManager.default.attributesOfItem(atPath: filePathImage2) as NSDictionary?
                if let _attr = fileAttributes {
                    self.fileSize1 = _attr.fileSize();
                    filesize=Int(_attr.fileSize());
                    //print("file size is \(self.fileSize1)")
                    //// ***april 2016 neww self.fileSize=(fileSize1 as! NSNumber).integerValue
                }
            } catch {
                socketObj.socket.emit("logClient","IPHONE-LOG: error: \(error)")
                //print("Error:+++ \(error)")
            }
            
            
            var statusNow="pending"
            var imParas=["from":"\(username!)","to":"\(self.selectedContact)","fromFullName":"\(displayname)","msg":self.filename,"uniqueid":uniqueID,"type":"file","file_type":"audio","status":statusNow]
            //print("imparas are \(imParas)")
            
            
            //------
            
            
            
            sqliteDB.saveFile(self.selectedContact, from1: username!, owneruser1: username!, file_name1: self.filename, date1: nil, uniqueid1: uniqueID, file_size1: "\(self.fileSize1)", file_type1: ftype, file_path1: filePathImage2, type1: "audio",caption1:"")
            
            self.addUploadInfo(self.selectedContact,uniqueid1: uniqueID, rowindex: self.messages.count, uploadProgress: 0.0, isCompleted: false)
            
            print("uploading audio")
            if(self.selectedContact != ""){
                sqliteDB.SaveChat(self.selectedContact, from1: username!, owneruser1: username!, fromFullName1: displayname, msg1: self.filename, date1: nil, uniqueid1: uniqueID, status1: statusNow, type1: "file", file_type1: "audio", file_path1: filePathImage2)
            
                
                managerFile.uploadFile(filePathImage2, to1: self.selectedContact, from1: username!, uniqueid1: uniqueID, file_name1: self.filename, file_size1: "\(self.fileSize1)", file_type1: ftype,type1:"audio",label1:"")
            }
            else{
                for i in 0 ..< broadcastMembersPhones.count
                {
                    //imParas2.append(["from":"\(username!)","to":"\(broadcastMembersPhones[i])","fromFullName":"\(displayname)","msg":"\(msgbody)","uniqueid":"\(uniqueID)","type":"location","file_type":"","date":"\(dateSentDateType!)"])
                    
                    
                    sqliteDB.SaveBroadcastChat("\(broadcastMembersPhones[i])", from1: username!, owneruser1: username!, fromFullName1: displayname, msg1: self.filename, date1: nil, uniqueid1: uniqueID, status1: statusNow, type1: "broadcast_file", file_type1: "audio", file_path1: filePathImage2, broadcastlistID1: broadcastlistID1)
                    //broadcastMembersPhones[i]
                }

                
                managerFile.uploadBroadcastFile(filePathImage2, to1: self.broadcastMembersPhones, from1: username!, uniqueid1: uniqueID, file_name1: self.filename, file_size1: "\(self.fileSize1)", file_type1: ftype,type1:"audio", totalmembers: "\(self.broadcastMembersPhones.count)")
            }

            self.retrieveChatFromSqlite(self.selectedContact,completion:{(result)-> () in
                DispatchQueue.main.async
                    {
                        self.tblForChats.reloadData()
                        
                        if(self.messages.count>1)
                        { print("scrollinggg 224 line")
                            //var indexPath = NSIndexPath(forRow:self.messages.count-1, inSection: 0)
                            let indexPath = IndexPath(row:self.tblForChats.numberOfRows(inSection: 0)-1, section: 0)
                            self.tblForChats.scrollToRow(at: indexPath, at: UITableViewScrollPosition.bottom, animated: false)
                        }
                }
            })
            
            
            
        }
    }
    
    
    @IBAction func didChangeText(_ sender: UITextField) {
        print("value text changed")
        if(sender.text==nil)
        {
            //show Record button
            self.btnSendChat.isHidden=true
            self.btnSendAudio.isHidden=false
        }
        else{
            self.btnSendChat.isHidden=false
            self.btnSendAudio.isHidden=true
           
        }

    }
    
    @IBAction func txtfieldChangedText(_ sender: UITextField) {
        print("value text changed.......")
        if(sender.text==nil || sender.text=="")
        {
            //show Record button
            self.btnSendChat.isHidden=true
            self.btnSendAudio.isHidden=false
        }
        else{
            self.btnSendChat.isHidden=false
            self.btnSendAudio.isHidden=true
            
            /*
            var urlArray=UtilityFunctions.init().getURLs(text: sender.text!)
            print()
            
            let slp = SwiftLinkPreview()
            slp.preview(
                sender.text,
                onSuccess: { result in
                    
                    self.hasURL=true
                    print("url result is \(result)")
                    
                  //  let embeddedView = URLEmbeddedView()
                   // embeddedView.loadURL(sender.text!)
                    print("title \(result[.title] as! String)")
                    self.urlTitle=result[.title] as! String
                    self.urlDesc=result[SwiftLinkResponseKey.description] as! String
                    self.urlURL="\(result[SwiftLinkResponseKey.url])" // as! String
                    //var urlURLimage=result[SwiftLinkResponseKey.image] as! String
                    //Chat.SwiftLinkResponseKey.description
                    //Chat.SwiftLinkResponseKey.images
                    //Chat.SwiftLinkResponseKey.title
                    //Chat.SwiftLinkResponseKey.url
            },
                onError: { error in
                    
                    print("error: in url is \(error)")
                    
            }
            )*/
           // urlArray.first
        }
}
    
    /* @IBAction func btnBackToChatsPressed(sender: AnyObject) {
     //backToChatPushSegue
     
     self.dismiss(true) { () -> Void in
     
     
     }
     //self.tabBarController?.selectedIndex=1
     //if self.rootViewController as? UITabBarController != nil {
     // var tababarController = self.window!.rootViewController as UITabBarController
     //    tababarController.selectedIndex = 1
     //}
     
     /*
     var next=self.storyboard?.instantiateViewControllerWithIdentifier("MainChatView") as! ChatViewController
     self.navigationController?.presentViewController(next, animated: true, completion: { () -> Void in
     
     
     })
     */
     /*
     var myviewChat=ChatViewController.init(nibName: nil, bundle: nil)
     var mynav=UINavigationController.init(rootViewController: myviewChat)
     self.presentViewController(mynav, animated: true) { () -> Void in
     
     
     }*/
     
     /* MyViewController *myViewController = [[MyViewController alloc] initWithNibName:nil bundle:nil];
     UINavigationController *navigationController =
     [[UINavigationController alloc] initWithRootViewController:myViewController];
     
     //now present this navigation controller modally
     [self presentViewController:navigationController
     animated:YES
     completion:^{
     
     }];*/
     /*
     RootViewController *vController=[[RootViewController alloc] initWithNibName:@"RootViewController" bundle:nil];
     [self.navigationController pushViewController:vController animated:YES];
     */
     
     
     }
     */
    
    /*
     required init?(coder aDecoder: NSCoder) {
     fatalError("init(coder:) has not been implemented")
     }*/
    
    
   
    func fileManager(_ fileManager: FileManager, shouldProceedAfterError error: Error, copyingItemAtPath srcPath: String, toPath dstPath: String) -> Bool {
        if (error != nil) {
            do {
                //var new path=dstPath.re
                try fileManager.removeItem(atPath: dstPath)
                //print("Existing file deleted.")
            } catch {
                //print("Failed to delete existing file:\n\((error as NSError).description)")
            }
            do {
                try fileManager.copyItem(atPath: srcPath, toPath: dstPath)
                //print("File saved.")
            } catch {
                //print("File not saved:\n\((error as NSError).description)")
            }
            return true
        } else {
            
            return false
        }
    }
    
    required init?(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
        ////print("hiiiiii22 \(self.AuthToken)")
        
    }
    
    func getLastSeen()->String
    {var lastseen=""
      //  let slp = SwiftLinkPreview()
        Alamofire.request(Constants.MainUrl+Constants.getLastSeen, method: .post, parameters: ["phone":selectedContact], encoding: JSONEncoding.default, headers: header).responseJSON { (response) in
            
            if(response.response?.statusCode==200)
            {
           var dataGot=JSON(response.data)
            print(dataGot)
                //lastseen=dataGot.description
                lastseen=dataGot["last_seen"].string!
                print("last seen: \(lastseen)")
                var datedisplay=UtilityFunctions.init().getDateShortened(date2: lastseen)
                let subtitleLabel = UILabel(frame: CGRect(x: 0, y: 27, width: 100, height: 0))
                subtitleLabel.backgroundColor = UIColor.clear
                //subtitleLabel.textColor = UIColor.lightGrayColor()
                subtitleLabel.textColor = UIColor.black
                
                subtitleLabel.font = UIFont.systemFont(ofSize: 12)
                subtitleLabel.text = "Last seen: \(datedisplay)"
                subtitleLabel.sizeToFit()
                subtitleLabel.textAlignment = NSTextAlignment.center
                
                let button =  UIButton(type: .custom)
                button.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
                button.backgroundColor = self.NewChatNavigationTitle.titleView?.backgroundColor
                button.setTitle(self.selectedFirstName, for: .normal)
                button.addSubview(subtitleLabel)
                button.addTarget(self, action: #selector(ChatDetailViewController.contactTapped(_:)), for: .touchUpInside)
                self.NewChatNavigationTitle.titleView=button
            }
            else{
                print("error in getting last seen")
            }
        }
        return lastseen
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //print("chat will appear")
        socketObj.socket.emit("logClient","IPHONE-LOG: chat page will appear")
        
        
        delegateCheckConvWindow=self
        
        
        let blockedByMe = Expression<Bool>("blockedByMe")
        let IamBlocked = Expression<Bool>("IamBlocked")
        let phone = Expression<String>("phone")
        
        //setNavigationTitle(subtitle: "tap")
        //contactsDetailController?.contactIndex=tblForNotes.indexPathForSelectedRow!.row
        //var cell=tblForNotes.cellForRowAtIndexPath(tblForNotes.indexPathForSelectedRow!) as! AllContactsCell
        
        
        //if(ContactStatus != "")
        // {
        //print("hidden falseeeeeee")
        //}
        
        self.getLastSeen()
        
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(ChatDetailViewController.longPressedRecord(_:)))
         self.btnSendAudio.addGestureRecognizer(longPressRecognizer)
        
      /*  let PanDraggedRecognizer = UIPanGestureRecognizer(target: self, action: #selector(ChatDetailViewController.PanDraggedRecord(_:)))
        self.btnSendAudio.addGestureRecognizer(PanDraggedRecognizer)
 */

        
        
        
        let tbl_contactslists=sqliteDB.contactslists
        isBlocked=false
        do{for resultrows in try sqliteDB.db.prepare((tbl_contactslists?.filter(phone==selectedContact && blockedByMe==true))!)
        {
            print("blocked by me")
            //blockedcontact=true
            isBlocked=true
            }
        }
        catch{
            print("not blocked coz not in contact list")
        }
        
        
        if(isBlocked==true)
        {
            //self.btnSendChat.isEnabled=false
            //self.btnSendAudio.isEnabled=false
        }
        else
        {
            //self.btnSendChat.isEnabled=true
            //self.btnSendAudio.isEnabled=true

        }
        
        UIDelegates.getInstance().delegateSingleChatDetails1=self
        delegateRefreshChat=self
        UIDelegates.getInstance().delegateInsertChatAtLast1=self
        UIDelegates.getInstance().delegateInsertBulkChatsSync1=self
        UIDelegates.getInstance().delegateInsertBulkChatsStatusesSync=self
        UIDelegates.getInstance().delegateUpdateChatStatusRow1=self
        
       /* NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("applicationWillResignActive:"), name:UIApplicationWillResignActiveNotification, object: nil)
        
        //
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("applicationDidBecomeActive:"), name:UIApplicationDidBecomeActiveNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("willShowKeyBoard:"), name:UIKeyboardWillShowNotification, object: nil)
        */
        
        //%%%%%%%%%%%%%% commented new socket connected again and again
        /*if(socketObj == nil)
         {
         //print("socket is nillll", terminator: "")
         
         
         socketObj=LoginAPI(url:"\(Constants.MainUrl)")
         /////////// //print("connected issssss \(socketObj.socket.connected)")
         ///socketObj.connect()
         socketObj.addHandlers()
         socketObj.addWebRTCHandlers()
         }*/
        
      //  dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED,0))
//{
      
        
        
        
        
        broadcastMembersPhones = sqliteDB.getBroadcastListMembers(broadcastlistID1)
        
        self.retrieveChatFromSqliteOnAppear(self.selectedContact,completion:{(result)-> () in
            
        //    DispatchQueue.main.async
          //  {
           // self.tblForChats.reloadData()
            
            //commenting newwwwwwww -===-===-=
         //   DispatchQueue.main.async
//{
    self.tblForChats.reloadData()

            if(self.messages.count>1)
            {
                //var indexPath = NSIndexPath(forRow:self.messages.count-1, inSection: 0)
                
                if(self.searchUniqueid != nil)
                {
                    var predicate=NSPredicate(format: "uniqueid = %@", self.searchUniqueid)
                    var resultArray=self.messages.filtered(using: predicate)
                    if(resultArray.count > 0)
                    {
                        print("scrollinggg 451 line")
                        var foundindex=self.messages.index(of: resultArray.first!)
                         let indexPath = IndexPath(row:foundindex, section: 0)
                       // self.tblForChats.seth
                        self.tblForChats.cellForRow(at: indexPath)?.setHighlighted(true, animated: true)
                        self.tblForChats.cellForRow(at: indexPath)?.backgroundColor=UIColor.lightGray
                        self.tblForChats.scrollToRow(at: indexPath, at: UITableViewScrollPosition.bottom, animated: false)
                    }
                    else{
                         print("scrollinggg 460 line")
                            let indexPath = IndexPath(row:self.tblForChats.numberOfRows(inSection: 0)-1, section: 0)
                            self.tblForChats.scrollToRow(at: indexPath, at: UITableViewScrollPosition.bottom, animated: false)
                        }
                    
                   
                }
                else{
                 print("scrollinggg 468 line")
                let indexPath = IndexPath(row:self.tblForChats.numberOfRows(inSection: 0)-1, section: 0)
                self.tblForChats.scrollToRow(at: indexPath, at: UITableViewScrollPosition.bottom, animated: false)
                }
            }
            self.searchUniqueid=nil
            //}
            //}
       // })
        })
 
        
        
        
        
        
        
        
        //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%------------ commented june 16 FetchChatServer()
        //print("calling retrieveChat")
        
        // if(appJustInstalled[self.selectedIndex] == true)
        //{
        
        //%%%%% new imp commented for testing ***** ******** ***** $$$$ $$$
        //--------------------------------
        //____+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        /*
         FetchChatServer(){ (result) -> () in
         if(result==true)
         {
         //          appJustInstalled[self.selectedIndex] = false
         self.retrieveChatFromSqlite(self.selectedContact)
         
         }
         }
         // ****************__________________________
         */
        
        //}
        //else
        //{
        //self.retrieveChatFromSqlite(selectedContact)
        //}
        ///////%%%%% self.retrieveChatFromSqlite(selectedContact)
        //sqliteDB.retrieveChat(username!)
        
    }
    
    
    func ResizeImage(_ image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / image.size.width
        let heightRatio = targetSize.height / image.size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        print("last cell pos y is \(tblForChats.visibleCells.last?.frame.origin.y)")
        
        if(isBlocked==true)
        {
           // self.btnSendChat.isEnabled=false
          //  self.btnSendAudio.isEnabled=false
        }
        else
        {
          //  self.btnSendChat.isEnabled=true
           // self.btnSendAudio.isEnabled=true
            
        }
      
    }
    
    func startRecording() {
       var uniqueID = UtilityFunctions.init().generateUniqueid()
        
        
        let dirPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let docsDir1 = dirPaths[0]
        let documentDir=docsDir1 as NSString
        let audioFilename =  documentDir.appendingPathComponent("\(uniqueID).m4a")
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(url: URL.init(fileURLWithPath: audioFilename), settings: settings)
            audioRecorder.delegate = self
            audioRecorder.record()
            self.filename="\(uniqueID).m4a"
            print("recording audio \(uniqueID).m4a ")
            
            //////audioRecorder.deleterecording()
            btnSendAudio.setTitle("Tap to Stop", for: .normal)
        } catch {
            print("error finish recording.. not recorded \(uniqueID).m4a")
            finishRecording(success: false)
        }
    }
    
    func setNavigationTitle(subtitleLabel:UILabel,button:UIButton,subtitle:String)
    {
        //subtitleLabel = UILabel(frame: CGRect(x: 0, y: 27, width: 0, height: 0))
        subtitleLabel.backgroundColor = UIColor.clear
        //subtitleLabel.textColor = UIColor.lightGrayColor()
        subtitleLabel.textColor = UIColor.black
        
        subtitleLabel.font = UIFont.systemFont(ofSize: 12)
        subtitleLabel.text = title
        subtitleLabel.sizeToFit()
        
       // button =  UIButton(type: .custom)
        button.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
        button.backgroundColor = NewChatNavigationTitle.titleView?.backgroundColor
        button.setTitle(selectedFirstName, for: .normal)
        button.addSubview(subtitleLabel)
        button.addTarget(self, action: #selector(ChatDetailViewController.contactTapped(_:)), for: .touchUpInside)
        self.NewChatNavigationTitle.titleView=button
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //contactPickerViewController.delegate = self
        
        
        locationManager.delegate = self
        
        //do on button click
               recordingSession = AVAudioSession.sharedInstance()
        
        do {
            try recordingSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
           // try recordingSession.setCategory(AVAudioSessionCategoryPlayAndRecord, options: AVAudioSessionCategoryOptions.DefaultToSpeaker)
            try recordingSession.setActive(true)
            recordingSession.requestRecordPermission() { [unowned self] allowed in
                DispatchQueue.main.async {
                    if allowed {
                       // self.loadRecordingUI()
                        self.btnSendAudio.isUserInteractionEnabled=true
                        
                       } else {
                        // failed to record!
                        self.btnSendAudio.isUserInteractionEnabled=false
                        
                    }
                }
            }
        } catch {
            // failed to record!
        }
        
        self.tblForChats.estimatedRowHeight = 40.0

        self.tblForChats.rowHeight = UITableViewAutomaticDimension;
        /*
        let nib1 = UINib(nibName: "ChatSentCell", bundle: nil)
        let nib2 = UINib(nibName: "ChatReceivedCell", bundle: nil)
        let nib3 = UINib(nibName: "FileImageSentCell", bundle: nil)
        let nib4 = UINib(nibName: "FileImageReceivedCell", bundle: nil)
        let nib5 = UINib(nibName: "DocSentCell", bundle: nil)
        let nib6 = UINib(nibName: "DocReceivedCell", bundle: nil)
        self.tblForChats.registerNib(nib1, forCellReuseIdentifier:"ChatSentCell")
        self.tblForChats.registerNib(nib2, forCellReuseIdentifier:"ChatReceivedCell")
        self.tblForChats.registerNib(nib3, forCellReuseIdentifier:"FileImageSentCell")
        self.tblForChats.registerNib(nib4, forCellReuseIdentifier:"FileImageReceivedCell")
        self.tblForChats.registerNib(nib5, forCellReuseIdentifier:"DocSentCell")
        self.tblForChats.registerNib(nib6, forCellReuseIdentifier:"DocReceivedCell")
        */
        //restorationIdentifier = "ChatDetailViewController"
        //restorationClass = ChatDetailViewController.self
        
        //UIApplicationWillEnterForegroundNotification
        
       UIDelegates.getInstance().delegateInsertChatAtLast1=self
       UIDelegates.getInstance().delegateInsertBulkChatsSync1=self
        UIDelegates.getInstance().delegateInsertBulkChatsStatusesSync=self
        UIDelegates.getInstance().delegateUpdateChatStatusRow1=self
        
        delegateRefreshChat=self
        NotificationCenter.default.removeObserver(self, name:NSNotification.Name.UIApplicationWillResignActive, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(UIApplicationDelegate.applicationWillResignActive(_:)), name:NSNotification.Name.UIApplicationWillResignActive, object: nil)
        
        //
        
        NotificationCenter.default.removeObserver(self, name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(UIApplicationDelegate.applicationDidBecomeActive(_:)), name:NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
        
        
        
        
        NotificationCenter.default.removeObserver(self, name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ChatDetailViewController.willShowKeyBoard(_:)), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        
        ///NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("willHideKeyBoard:"), name:UIKeyboardWillHideNotification, object: nil)
        
 
        messages = NSMutableArray()
        //uploadInfo=NSMutableArray()
        managerFile.delegateProgressUpload=self
        
        //print("chat on load")
        if(socketObj != nil)
        {
        socketObj.socket.emit("logClient","IPHONE-LOG: chat page loading")
        socketObj.delegate=self
        socketObj.delegateChat=self
        }
        
        
                //%%%%%%%%%%%%%%%%%&&&&&&&&&&&&&&&&&&^^^^^^^^^
        //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%FetchChatServer()
        
        let subtitleLabel = UILabel(frame: CGRect(x: 0, y: 27, width: 100, height: 0))
        subtitleLabel.backgroundColor = UIColor.clear
        //subtitleLabel.textColor = UIColor.lightGrayColor()
        subtitleLabel.textColor = UIColor.black
        
        subtitleLabel.font = UIFont.systemFont(ofSize: 12)
        subtitleLabel.text = "tap here for info"
        subtitleLabel.sizeToFit()
        subtitleLabel.textAlignment = NSTextAlignment.center
        
        let button =  UIButton(type: .custom)
        button.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
        button.backgroundColor = NewChatNavigationTitle.titleView?.backgroundColor
        button.setTitle(selectedFirstName, for: .normal)
        button.addSubview(subtitleLabel)
        button.addTarget(self, action: #selector(ChatDetailViewController.contactTapped(_:)), for: .touchUpInside)
        self.NewChatNavigationTitle.titleView=button
       ///==-- self.NewChatNavigationTitle.title=selectedFirstName
        
        
        /*let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(ChatDetailViewController.contactTapped(_:)))
         self.NewChatNavigationTitle.titleView?.addGestureRecognizer(tapRecognizer)
        */
        self.navigationItem.leftBarButtonItem = self.navigationItem.backBarButtonItem
        var receivedMsg=JSON("")
        
        
        //let tbl_userchats=sqliteDB.userschats
       // let tbl_contactslists=sqliteDB.contactslists
        let tbl_allcontacts=sqliteDB.allcontacts
        
        
        let phone = Expression<String>("phone")
       //////////// let contactProfileImage = Expression<NSData>("profileimage")
        let uniqueidentifier = Expression<String>("uniqueidentifier")

        
        //--------------
        
        
        if(selectedContact != ""){
        let queryPic = tbl_allcontacts?.filter((tbl_allcontacts?[phone])! == selectedContact)          // SELECT "email" FROM "users"
        
        
        do{
            for picquery in try sqliteDB.db.prepare(queryPic!) {
                
                let contactStore = CNContactStore()
                
                var keys = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactEmailAddressesKey, CNContactPhoneNumbersKey, CNContactImageDataAvailableKey,CNContactThumbnailImageDataKey, CNContactImageDataKey]
                var foundcontact=try contactStore.unifiedContact(withIdentifier: picquery[uniqueidentifier], keysToFetch: keys as [CNKeyDescriptor])
                if(foundcontact.imageDataAvailable==true)
                {
                    foundcontact.imageData
                    var imageavatar1=UIImage.init(data:(foundcontact.imageData)!)
                    //   imageavatar1=ResizeImage(imageavatar1!,targetSize: s)
                    
                    //var img=UIImage(data:ContactsProfilePic[indexPath.row])
                    var w=imageavatar1!.size.width
                    var h=imageavatar1!.size.height
                    var wOld=(self.navigationController?.navigationBar.frame.height)!-5
                    var hOld=(self.navigationController?.navigationBar.frame.width)!-5
                    var scale:CGFloat=w/wOld
                    
                    
                    ///var s=CGSizeMake((self.navigationController?.navigationBar.frame.height)!-5,(self.navigationController?.navigationBar.frame.height)!-5)
                    
                    var barAvatarImage=UIImageView.init(image: UIImage(data: (foundcontact.imageData)!,scale:scale))
                    
                    barAvatarImage.layer.borderWidth = 1.0
                    barAvatarImage.layer.masksToBounds = false
                    barAvatarImage.layer.borderColor = UIColor.white.cgColor
                    barAvatarImage.layer.cornerRadius = barAvatarImage.frame.size.width/2
                    barAvatarImage.clipsToBounds = true
                    
                    //print("bav avatar size is \(barAvatarImage.frame.width) .. \(barAvatarImage.frame.width)")
                    
                    var avatarbutton=UIBarButtonItem.init(customView: barAvatarImage)
                    self.navigationItem.rightBarButtonItems?.insert(avatarbutton, at: 0)
                    
                    //ContactsProfilePic.append(foundcontact.imageData!)
                    //picfound=true
                }
                
             
            }
        }
        catch
        {
            //print("error in fetching profile image")
        }
    }

        
         if(isBlocked==true)
         {
          //  self.btnSendChat.isEnabled=false
          //  self.btnSendAudio.isEnabled=false
        }
         else
         {
           // self.btnSendChat.isEnabled=true
           // self.btnSendAudio.isEnabled=true
            
        }

    
    }
    
    func showError(_ title:String,message:String,button1:String) {
        
        // create the alert
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        // add the actions (buttons)
        alert.addAction(UIAlertAction(title: button1, style: UIAlertActionStyle.default, handler: nil))
        //alert.addAction(UIAlertAction(title: button2, style: UIAlertActionStyle.Cancel, handler: nil))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func btnCallPressed(_ sender: AnyObject) {
        socketObj.socket.emit("logClient","IPHONE-LOG: \(username!) is trying to call \(selectedContact)")
        /*if(self.ContactOnlineStatus==0)
         {
         self.showError("Info:", message: "Contact is offline. Please try again later.", button1: "Ok")
         //print("contact is offline")
         socketObj.socket.emit("logClient","IPHONE-LOG: contact \(selectedContact) is offline")
         }*/
        // else{
        
        sqliteDB.saveCallHist(ContactNames, dateTime1: Date().debugDescription, type1: "Outgoing")
        
        //socketObj.socket.emit("callthisperson",["room" : "globalchatroom","callee": self.ContactUsernames[selectedRow], "caller":username!])
        // &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&**************************
        
        
        //username=KeychainWrapper.stringForKey("username")
       
        //new addition
        let username1 = Expression<String>("username")
        let tbl_accounts = sqliteDB.accounts
        do{for account in try sqliteDB.db.prepare(tbl_accounts!) {
            username=account[username1]
            
            }
        }
        catch{
            
        }
        
        
        socketObj.socket.emit("logClient","IPHONE-LOG: callthisperson,room:globalchatroom,calleephone: \(selectedContact),callerphone:\(username!)")
        //print("callthisperson,room : globalchatroom,callee: \(selectedContact), caller:\(username!)")
        
        
        var ack1=socketObj.socket.emitWithAck("callthisperson",["room" : "globalchatroom","calleephone": selectedContact, "callerphone":username!])/*{data in
            var chatmsg=JSON(data)
            
            //print(data[0])
            //print(data[0]["calleephone"]!!)
            //print(data[0]["status"]!!.debugDescription!)
            
            //print("username is ... \(username!)")
            
            isInitiator=true
            callerName=username!
            iamincallWith=self.selectedContact
            
            iOSstartedCall=true
            socketObj.socket.emit("logClient","IPHONE-LOG: \(username!) is going to videoViewController")
            ////
            var next = self.storyboard!.instantiateViewControllerWithIdentifier("MainV2") as! VideoViewController
            
            self.presentViewController(next, animated: true, completion: {
            })
            
        }*/
        
        
        ack1.timingOut(after: 150000) { (data) in
            var chatmsg=JSON(data)
            
            //print(data[0])
            //print(data[0]["calleephone"]!!)
            //print(data[0]["status"]!!.debugDescription!)
            
            //print("username is ... \(username!)")
            
            isInitiator=true
            callerName=username!
            iamincallWith=self.selectedContact
            
            iOSstartedCall=true
            socketObj.socket.emit("logClient","IPHONE-LOG: \(username!) is going to videoViewController")
            ////
            var next = self.storyboard!.instantiateViewController(withIdentifier: "MainV2") as! VideoViewController
            
            self.present(next, animated: true, completion: {
            })
        }
        
        //  }
        
    }
    

    
    func retrieveChatFromSqliteOnAppear(_ selecteduser:String,completion:@escaping (_ result:Bool)->())
    {
        //print("retrieveChatFromSqlite called---------")
        ///^^messages.removeAllObjects()
        
       
       DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async
    {
        var messages2=NSMutableArray()
        
        let to = Expression<String>("to")
        let from = Expression<String>("from")
        let owneruser = Expression<String>("owneruser")
        let fromFullName = Expression<String>("fromFullName")
        let msg = Expression<String>("msg")
        let date = Expression<Date>("date")
        let status = Expression<String>("status")
        let uniqueid = Expression<String>("uniqueid")
        let type = Expression<String>("type")
         let file_type = Expression<String>("file_type")
        
        let broadcastlistID = Expression<String>("broadcastlistID")
        var tbl_userchats=sqliteDB.userschats
        //broadcastlistID
        
       // if(self.selectedContact != "")
        //{
            //var tbl_userchats=sqliteDB.userschats
        //var res=tbl_userchats?.filter(to==selecteduser || from==selecteduser)
        //to==selecteduser || from==selecteduser
        //print("chat from sqlite is")
        //print(res)
            
            
            do
            {
                
                //for tblContacts in try sqliteDB.db.prepare(tbl_userchats.filter(owneruser==owneruser1)){
                ////print("queryy runned count is \(tbl_contactslists.count)")
                
                var query:Table
                if(self.selectedContact != "")
                {
                    query=(tbl_userchats?.filter(to==selecteduser || from==selecteduser).order(date.asc))!
                }
                else{
                    
                    query=(tbl_userchats?.filter(broadcastlistID == self.broadcastlistID1 && from == username!).order(date.asc).group(uniqueid))!
                }
                

            
            
            
            //for tblContacts in try sqliteDB.db.prepare(tbl_userchats.filter(owneruser==owneruser1)){
            ////print("queryy runned count is \(tbl_contactslists.count)")
            for tblContacts in try sqliteDB.db.prepare(query){
                
                //print("===fetch date from database is tblContacts[date] \(tblContacts[date])")
                /*
                var formatter = DateFormatter();
                formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS";
                //formatter.dateFormat = "MM/dd hh:mm a";
                formatter.timeZone = NSTimeZone(name: "UTC")
                */
                // formatter.timeZone = NSTimeZone.local()
               // var defaultTimeZoneStr = formatter..date(from:tblContacts[date])
               // var defaultTimeZoneStr2 = formatter.stringFromDate(defaultTimeZoneStr!)
                
                
                var formatter2 = DateFormatter();
                formatter2.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
                formatter2.timeZone = NSTimeZone.local
                var defaultTimeeee = formatter2.string(from: tblContacts[date])
                
                //print("===fetch date from database is tblContacts[date] ... date converted is \(defaultTimeZoneStr)... string is \(defaultTimeZoneStr2)... defaultTimeeee \(defaultTimeeee)")
                
                /*//print(tblContacts[to])
                //print(tblContacts[from])
                //print(tblContacts[msg])
                //print(tblContacts[date])
                //print(tblContacts[status])
                //print("--------")
                */
                
             
                
                
                
                if(tblContacts[from]==selecteduser && (tblContacts[status]=="delivered"))
                {
                    sqliteDB.UpdateChatStatus(tblContacts[uniqueid], newstatus: "seen")
                    
                    sqliteDB.saveMessageStatusSeen("seen", sender1: tblContacts[from], uniqueid1: tblContacts[uniqueid])
                    
                    self.sendChatStatusUpdateMessage(tblContacts[uniqueid],status: "seen",sender: tblContacts[from])
                   
                    //OLD SOCKET LOGIC OF SENDING CHAT STATUS
                  /*  socketObj.socket.emitWithAck("messageStatusUpdate", ["status":"seen","uniqueid":tblContacts[uniqueid],"sender": tblContacts[from]])(timeoutAfter: 15000){data in
                        var chatmsg=JSON(data)
                        
                        //print(data[0])
                        //print(data[0]["uniqueid"]!!)
                        //print(data[0]["uniqueid"]!!.debugDescription!)
                        //print(chatmsg[0]["uniqueid"].string!)
                        ////print(data[0]["status"]!!.string!+" ... "+data[0]["uniqueid"]!!.string!)
                        //print("chat status seen emitted")
                        sqliteDB.removeMessageStatusSeen(data[0]["uniqueid"]!!.debugDescription!)
                        socketObj.socket.emit("logClient","\(username) chat status emitted")
                        
                    }
                    */
                }
                
                if (tblContacts[from]==username!)
                    
                {//type1
                    /////print("statussss is \(tblContacts[status])")
                    if(tblContacts[file_type]=="image")
                    {
                       // var filedownloaded=sqliteDB.checkIfFileExists(tblContacts[uniqueid])
                      
                        /*if(filedownloaded==false)
{
//checkpendingfiles
    managerFile.checkPendingFiles(tblContacts[uniqueid])
}*/
                      //  self.addUploadInfo(selectedContact, uniqueid1: tblContacts[uniqueid], rowindex: messages.count, uploadProgress: 1, isCompleted: true)
                      
                        messages2.add(["message":tblContacts[msg]+" (\(tblContacts[status]))","filename":tblContacts[msg],"type":"4", "date":defaultTimeeee, "uniqueid":tblContacts[uniqueid],"status":tblContacts[status],"caption":""])
                        
                        
                        //messages2.addObject(["message":tblContacts[msg], "type":"4", "date":tblContacts[date], "uniqueid":tblContacts[uniqueid]])
                        
                       //^^^ self.addMessage(tblContacts[msg], ofType: "4",date: tblContacts[date],uniqueid: tblContacts[uniqueid])
                        
                    }
                    else{
                    if(tblContacts[file_type]=="document")
                    {
                      //  var filedownloaded=sqliteDB.checkIfFileExists(tblContacts[uniqueid])
                        
                       /* if(filedownloaded==false)
                        {
                            //checkpendingfiles
                            managerFile.checkPendingFiles(tblContacts[uniqueid])
                        }*/
                      ////  self.addUploadInfo(selectedContact, uniqueid1: tblContacts[uniqueid], rowindex: messages.count, uploadProgress: 1, isCompleted: true)
                       
                        messages2.add(["message":tblContacts[msg]+" (\(tblContacts[status]))","filename":tblContacts[msg], "type":"6","status":tblContacts[status],"date":defaultTimeeee, "uniqueid":tblContacts[uniqueid]])
                        
                       //^^^^ self.addMessage(tblContacts[msg], ofType: "6",date: tblContacts[date],uniqueid: tblContacts[uniqueid])
                        
                    }
                    else
                    {
                        if(tblContacts[type]=="contact")
                        {
                            messages2.add(["message":tblContacts[msg]/*+" (\(tblContacts[status])) "*/,"status":tblContacts[status], "type":"8", "date":defaultTimeeee, "uniqueid":tblContacts[uniqueid]])
                            
                            
                        }
                        else{
                            if(tblContacts[file_type]=="video")
                            {
                                print("found contact received")
                                messages2.add(["message":tblContacts[msg],"status":tblContacts[status], "type":"10", "date":defaultTimeeee, "uniqueid":tblContacts[uniqueid]])
                            }else{
                                
                                
                                if(tblContacts[file_type]=="audio")
                                {
                                    
                                    
                                    messages2.add(["message":tblContacts[msg],"status":tblContacts[status], "type":"12", "date":defaultTimeeee, "uniqueid":tblContacts[uniqueid]])
                                }else{
                                    if(tblContacts[type]=="location")
                                    {
                                        
                                        
                                        messages2.add(["message":tblContacts[msg],"status":tblContacts[status], "type":"14", "date":defaultTimeeee, "uniqueid":tblContacts[uniqueid]])
                                    }else{
                                        if(tblContacts[type]=="link")
                                        {
                                            
                                            var urlArray=UtilityFunctions.init().getURLs(text: tblContacts[msg])
                                            if(urlArray.count>0)
                                            {
                                                print("found url \(urlArray.first!)")
                                                var urlInfoDB=sqliteDB.getSingleURLInfo(tblContacts[uniqueid])
                                                if(urlInfoDB.count>0){
                                                    
                                                    var title=urlInfoDB["title"]
                                                    var description=urlInfoDB["desc"]
                                                    var url=urlInfoDB["url"]
                                                    //newEntry["msg"]=URLinfo.get(msg) as AnyObject
                                                    messages2.add(["message":tblContacts[msg]/*+" (\(tblContacts[status])) "*/,"status":tblContacts[status], "type":"22", "date":defaultTimeeee, "uniqueid":tblContacts[uniqueid],"title":title,"description":description,"url":url])
                                                    
                                                    
                                                }
                                                else{
                                                    print("type link but not in db")
                                                    //messages2.add(["message":tblContacts[msg]+" (\(tblContacts[status])) ","status":tblContacts[status], "type":"2", "date":defaultTimeeee, "uniqueid":tblContacts[uniqueid]])
                                                    
                                                    //}
                                                }
                                                
                                                
                                            }else{
                                                
                                                messages2.add(["message":tblContacts[msg]+" (\(tblContacts[status])) ","status":tblContacts[status], "type":"2", "date":defaultTimeeee, "uniqueid":tblContacts[uniqueid]])
                                            }
                                            
                                            //  messages2.add(["message":tblContacts[msg]+" (\(tblContacts[status])) ","status":tblContacts[status], "type":"22", "date":defaultTimeeee, "uniqueid":tblContacts[uniqueid],"title"])
                                        }
                                        else{
                                        print("hereee 2 ")
                                        
                                       /* var urlArray=UtilityFunctions.init().getURLs(text: tblContacts[msg])
                                        if(urlArray.count>0)
                                        {
                                            print("found url \(urlArray.first!)")
                                           var urlInfoDB=sqliteDB.getSingleURLInfo("\(urlArray.first!)")
                                            if(urlInfoDB.count>0){
                                        
                                                 var title=urlInfoDB["title"]
                                                var description=urlInfoDB["desc"]
                                                var url=urlInfoDB["url"]
                                                //newEntry["msg"]=URLinfo.get(msg) as AnyObject
                                                messages2.add(["message":tblContacts[msg]/*+" (\(tblContacts[status])) "*/,"status":tblContacts[status], "type":"22", "date":defaultTimeeee, "uniqueid":tblContacts[uniqueid],"title":title,"description":description,"url":url])
                                                

                                            }
                                            else{
                                                messages2.add(["message":tblContacts[msg]/*+" (\(tblContacts[status])) "*/,"status":tblContacts[status], "type":"22", "date":defaultTimeeee, "uniqueid":tblContacts[uniqueid]])
                                                
                                            }
                                        }
                                        
                                      */

                                      //  else{
                                        messages2.add(["message":tblContacts[msg]+" (\(tblContacts[status])) ","status":tblContacts[status], "type":"2", "date":defaultTimeeee, "uniqueid":tblContacts[uniqueid]])
                                        //}
                                        /*var urlArray=UtilityFunctions.init().getURLs(text: tblContacts[msg])
                                        print()
                                        
                                        let slp = SwiftLinkPreview()
                                        slp.preview(
                                            tblContacts[msg],
                                            onSuccess: { result in
                                                
                                                self.hasURL=true
                                                print("url result in retrieve is \(result)")
                                                
                                                //  let embeddedView = URLEmbeddedView()
                                                // embeddedView.loadURL(sender.text!)
                                                print("title \(result[.title] as! String)")
                                                self.urlTitle=result[.title] as! String
                                                self.urlDesc=result[SwiftLinkResponseKey.description] as! String
                                                //self.urlURL=result[SwiftLinkResponseKey.url] as! String
                                                var urlURLimage=result[SwiftLinkResponseKey.image] as! String
                                                //Chat.SwiftLinkResponseKey.description
                                                //Chat.SwiftLinkResponseKey.images
                                                //Chat.SwiftLinkResponseKey.title
                                                //Chat.SwiftLinkResponseKey.url
                                                //
                                                 self.messages.add(["message":tblContacts[msg]+" (\(tblContacts[status])) ","status":tblContacts[status], "type":"2", "date":defaultTimeeee, "uniqueid":tblContacts[uniqueid],"title":result[.title] as! String,"description":result[SwiftLinkResponseKey.description] as! String,"url":"\(result[.url]!)"])
                                                 self.tblForChats.reloadData()
                                        },
                                            onError: { error in
                                                 self.messages.add(["message":tblContacts[msg]+" (\(tblContacts[status])) ","status":tblContacts[status], "type":"2", "date":defaultTimeeee, "uniqueid":tblContacts[uniqueid]])
                                                print("error: in url is \(error)")
                                                
                                        }
                                       
                                        )*/
                                            
                                        }
                       
                                    }
                                }
                            }
                       
                        }
                    //^^^^self.addMessage(tblContacts[msg]+" (\(tblContacts[status])) ", ofType: "2",date: tblContacts[date],uniqueid: tblContacts[uniqueid])
                    }
                    }
                }
                else
                {//type2
                   //// //print("statussss is \(tblContacts[status])")
                    if(tblContacts[file_type]=="image")
                    {
                        var filedownloaded=sqliteDB.checkIfFileExists(tblContacts[uniqueid])
                        
                        if(filedownloaded==false)
                        {
                            //checkpendingfiles
                          if(tblContacts[type]=="file")
                          {
                            //self.addUploadInfo(self.selectedContact,uniqueid1: tblContacts[uniqueid], rowindex: self.messages.count, uploadProgress: 0.0, isCompleted: false)
                            managerFile.checkPendingFiles(tblContacts[uniqueid])
                            }
                            if(tblContacts[type]=="broadcast_file")
                            {
                                managerFile.checkPendingFilesBroadcasr(tblContacts[uniqueid])
                            }
                        }

                      //  self.addUploadInfo(selectedContact, uniqueid1: tblContacts[uniqueid], rowindex: messages.count, uploadProgress: 1, isCompleted: true)
                        messages2.add(["message":tblContacts[msg],"filename":tblContacts[msg],"status":tblContacts[status], "type":"3", "date":defaultTimeeee, "uniqueid":tblContacts[uniqueid],"caption":""])
                       
                        
                      //^^^^  self.addMessage(tblContacts[msg] , ofType: "3",date: tblContacts[date],uniqueid: tblContacts[uniqueid])
                        
                    }
                    else
                    {if(tblContacts[file_type]=="document")
                    {
                        var filedownloaded=sqliteDB.checkIfFileExists(tblContacts[uniqueid])
                        
                        if(filedownloaded==false)
                        {
                           // self.addUploadInfo(self.selectedContact,uniqueid1: tblContacts[uniqueid], rowindex: self.messages.count, uploadProgress: 0.0, isCompleted: false)
                            //checkpendingfiles
                            if(tblContacts[type]=="file")
                            {
                                managerFile.checkPendingFiles(tblContacts[uniqueid])
                            }
                            if(tblContacts[type]=="broadcast_file")
                            {
                                managerFile.checkPendingFilesBroadcasr(tblContacts[uniqueid])
                            }
                        }

                       // self.addUploadInfo(selectedContact, uniqueid1: tblContacts[uniqueid], rowindex: messages.count, uploadProgress: 1, isCompleted: true)
                        messages2.add(["message":tblContacts[msg],"filename":tblContacts[msg],"status":tblContacts[status], "type":"5", "date":defaultTimeeee, "uniqueid":tblContacts[uniqueid]])
                       
                        
                       //^^^^ self.addMessage(tblContacts[msg], ofType: "5",date: tblContacts[date],uniqueid: tblContacts[uniqueid])
                        
                    }
                    else
                    {
                        if(tblContacts[type]=="contact")
                        {
                            print("found contact received")
                            messages2.add(["message":tblContacts[msg],"status":tblContacts[status], "type":"7", "date":defaultTimeeee, "uniqueid":tblContacts[uniqueid]])
                        }
                        else{
                            if(tblContacts[file_type]=="video")
                            {
                                print("checking if video is pending")
                                var filedownloaded=sqliteDB.checkIfFileExists(tblContacts[uniqueid])
                                
                                if(filedownloaded==false)
                                {
                                   // self.addUploadInfo(self.selectedContact,uniqueid1: tblContacts[uniqueid], rowindex: self.messages.count, uploadProgress: 0.0, isCompleted: false)
                                    print("video is not downloaded locally")
                                    //checkpendingfiles
                                    if(tblContacts[type]=="file")
                                    {
                                        managerFile.checkPendingFiles(tblContacts[uniqueid])
                                    }
                                    if(tblContacts[type]=="broadcast_file")
                                    {
                                        managerFile.checkPendingFilesBroadcasr(tblContacts[uniqueid])
                                    }
                                }
                                
                                print("found video received")
                                messages2.add(["message":tblContacts[msg],"status":tblContacts[status], "type":"9", "date":defaultTimeeee, "uniqueid":tblContacts[uniqueid]])
                            }
                            else{
                                
                                if(tblContacts[file_type]=="audio")
                                {
                                    print("checking if audio is pending")
                                    var filedownloaded=sqliteDB.checkIfFileExists(tblContacts[uniqueid])
                                    
                                    if(filedownloaded==false)
                                    {
                                        //self.addUploadInfo(self.selectedContact,uniqueid1: tblContacts[uniqueid], rowindex: self.messages.count, uploadProgress: 0.0, isCompleted: false)
                                        print("audio is not downloaded locally")
                                        //checkpendingfiles
                                        if(tblContacts[type]=="file")
                                        {
                                            managerFile.checkPendingFiles(tblContacts[uniqueid])
                                        }
                                        if(tblContacts[type]=="broadcast_file")
                                        {
                                            managerFile.checkPendingFilesBroadcasr(tblContacts[uniqueid])
                                        }
                                    }

                                    
                                    messages2.add(["message":tblContacts[msg],"status":tblContacts[status], "type":"11", "date":defaultTimeeee, "uniqueid":tblContacts[uniqueid]])
                                }else{
                                    
                                    if(tblContacts[type]=="location")
                                    {
                                         messages2.add(["message":tblContacts[msg],"status":tblContacts[status], "type":"13", "date":defaultTimeeee, "uniqueid":tblContacts[uniqueid]])
                                        
                                    }else{
                                        
                                        if(tblContacts[type]=="link")
                                        {
                                        var urlArray=UtilityFunctions.init().getURLs(text: tblContacts[msg])
                                        if(urlArray.count>0)
                                        {
                                            print("found url \(urlArray.first!)")
                                            var urlInfoDB=sqliteDB.getSingleURLInfo(tblContacts[uniqueid])
                                            if(urlInfoDB.count>0){
                                                
                                                var title=urlInfoDB["title"]
                                                var description=urlInfoDB["desc"]
                                                var url=urlInfoDB["url"]
                                                //newEntry["msg"]=URLinfo.get(msg) as AnyObject
                                                messages2.add(["message":tblContacts[msg]/*+" (\(tblContacts[status])) "*/,"status":tblContacts[status], "type":"23", "date":defaultTimeeee, "uniqueid":tblContacts[uniqueid],"title":title,"description":description,"url":url])
                                                
                                                
                                            }
                                            else{
                                                print("type link but not in db")
                                                //messages2.add(["message":tblContacts[msg]+" (\(tblContacts[status])) ","status":tblContacts[status], "type":"2", "date":defaultTimeeee, "uniqueid":tblContacts[uniqueid]])
                                                
                                                //}
                                            }
                                            
                                            
                                        }else{
                                            
                                            messages2.add(["message":tblContacts[msg]+" (\(tblContacts[status])) ","status":tblContacts[status], "type":"1", "date":defaultTimeeee, "uniqueid":tblContacts[uniqueid]])
                                        }
                                        
                                        //  messages2.add(["message":tblContacts[msg]+" (\(tblContacts[status])) ","status":tblContacts[status], "type":"22", "date":defaultTimeeee, "uniqueid":tblContacts[uniqueid],"title"])
                                    }
                                    
                                    else{
                                        messages2.add(["message":tblContacts[msg],"status":tblContacts[status], "type":"1", "date":defaultTimeeee, "uniqueid":tblContacts[uniqueid]])
                                    }
                                    }
                                }
                            }
                        }
                        
                   ///^^^ self.addMessage(tblContacts[msg], ofType: "1", date: tblContacts[date],uniqueid: tblContacts[uniqueid])
                    }
                    }
                    
                }
                /* if(self.messages.count>1)
                 {
                 var indexPath = NSIndexPath(forRow:self.messages.count-1, inSection: 0)
                 
                 self.tblForChats.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Bottom, animated: false)
                 }*/
                
                //self.tblForChats.reloadData()
                
            }
           ////////// self.messages.removeAllObjects()
           
            ////////////self.messages.addObjectsFromArray(messages2 as [AnyObject])
        
   DispatchQueue.main.async
   {
     self.messages.setArray(messages2 as [AnyObject])
            return completion(true)
            }
           }
        catch(let error)
        {
            DispatchQueue.main.async
            {
                return completion(false)
            }
                       //print(error)
        }
       // }
        //!!
        /*else
        {var tbl_userchats=sqliteDB.userschats
            var res=tbl_userchats?.filter(broadcastlistID==self.broadcastlistID1 && from==username!).group(uniqueid)
            //to==selecteduser || from==selecteduser
            //print("chat from sqlite is")
            //print(res)
            do
            {
                print("here in appear")
                
                //for tblContacts in try sqliteDB.db.prepare(tbl_userchats.filter(owneruser==owneruser1)){
                ////print("queryy runned count is \(tbl_contactslists.count)")
                for tblContacts in try sqliteDB.db.prepare(res!){
                    
                    //print("===fetch date from database is tblContacts[date] \(tblContacts[date])")
                    /*
                     var formatter = DateFormatter();
                     formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS";
                     //formatter.dateFormat = "MM/dd hh:mm a";
                     formatter.timeZone = NSTimeZone(name: "UTC")
                     */
                    // formatter.timeZone = NSTimeZone.local()
                    // var defaultTimeZoneStr = formatter..date(from:tblContacts[date])
                    // var defaultTimeZoneStr2 = formatter.stringFromDate(defaultTimeZoneStr!)
                    
                    
                    var formatter2 = DateFormatter();
                    formatter2.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
                    formatter2.timeZone = NSTimeZone.local
                    var defaultTimeeee = formatter2.string(from: tblContacts[date])
                    
                    //print("===fetch date from database is tblContacts[date] ... date converted is \(defaultTimeZoneStr)... string is \(defaultTimeZoneStr2)... defaultTimeeee \(defaultTimeeee)")
                    
                    /*//print(tblContacts[to])
                     //print(tblContacts[from])
                     //print(tblContacts[msg])
                     //print(tblContacts[date])
                     //print(tblContacts[status])
                     //print("--------")
                     */
                    
                    
                    
                    
                    
                    if(tblContacts[from]==selecteduser && (tblContacts[status]=="delivered"))
                    {
                        sqliteDB.UpdateChatStatus(tblContacts[uniqueid], newstatus: "seen")
                        
                        sqliteDB.saveMessageStatusSeen("seen", sender1: tblContacts[from], uniqueid1: tblContacts[uniqueid])
                        
                        self.sendChatStatusUpdateMessage(tblContacts[uniqueid],status: "seen",sender: tblContacts[from])
                        
                        //OLD SOCKET LOGIC OF SENDING CHAT STATUS
                        /*  socketObj.socket.emitWithAck("messageStatusUpdate", ["status":"seen","uniqueid":tblContacts[uniqueid],"sender": tblContacts[from]])(timeoutAfter: 15000){data in
                         var chatmsg=JSON(data)
                         
                         //print(data[0])
                         //print(data[0]["uniqueid"]!!)
                         //print(data[0]["uniqueid"]!!.debugDescription!)
                         //print(chatmsg[0]["uniqueid"].string!)
                         ////print(data[0]["status"]!!.string!+" ... "+data[0]["uniqueid"]!!.string!)
                         //print("chat status seen emitted")
                         sqliteDB.removeMessageStatusSeen(data[0]["uniqueid"]!!.debugDescription!)
                         socketObj.socket.emit("logClient","\(username) chat status emitted")
                         
                         }
                         */
                    }
                    
                    if (tblContacts[from]==username!)
                        
                    {//type1
                        /////print("statussss is \(tblContacts[status])")
                        if(tblContacts[file_type]=="image")
                        {
                            // var filedownloaded=sqliteDB.checkIfFileExists(tblContacts[uniqueid])
                            
                            /*if(filedownloaded==false)
                             {
                             //checkpendingfiles
                             managerFile.checkPendingFiles(tblContacts[uniqueid])
                             }*/
                            //  self.addUploadInfo(selectedContact, uniqueid1: tblContacts[uniqueid], rowindex: messages.count, uploadProgress: 1, isCompleted: true)
                            
                            messages2.add(["message":tblContacts[msg]+" (\(tblContacts[status]))","filename":tblContacts[msg],"type":"4", "date":defaultTimeeee, "uniqueid":tblContacts[uniqueid],"status":tblContacts[status]])
                            
                            
                            //messages2.addObject(["message":tblContacts[msg], "type":"4", "date":tblContacts[date], "uniqueid":tblContacts[uniqueid]])
                            
                            //^^^ self.addMessage(tblContacts[msg], ofType: "4",date: tblContacts[date],uniqueid: tblContacts[uniqueid])
                            
                        }
                        else{
                            if(tblContacts[file_type]=="document")
                            {
                                //  var filedownloaded=sqliteDB.checkIfFileExists(tblContacts[uniqueid])
                                
                                /* if(filedownloaded==false)
                                 {
                                 //checkpendingfiles
                                 managerFile.checkPendingFiles(tblContacts[uniqueid])
                                 }*/
                                ////  self.addUploadInfo(selectedContact, uniqueid1: tblContacts[uniqueid], rowindex: messages.count, uploadProgress: 1, isCompleted: true)
                                
                                messages2.add(["message":tblContacts[msg]+" (\(tblContacts[status]))","filename":tblContacts[msg], "type":"6","status":tblContacts[status],"date":defaultTimeeee, "uniqueid":tblContacts[uniqueid]])
                                
                                //^^^^ self.addMessage(tblContacts[msg], ofType: "6",date: tblContacts[date],uniqueid: tblContacts[uniqueid])
                                
                            }
                            else{
                                
                                if(tblContacts[type]=="link")
                                {
                                    
                                    var urlArray=UtilityFunctions.init().getURLs(text: tblContacts[msg])
                                    if(urlArray.count>0)
                                    {
                                        print("found url \(urlArray.first!)")
                                        var urlInfoDB=sqliteDB.getSingleURLInfo(tblContacts[uniqueid])
                                        if(urlInfoDB.count>0){
                                            
                                            var title=urlInfoDB["title"]
                                            var description=urlInfoDB["desc"]
                                            var url=urlInfoDB["url"]
                                            //newEntry["msg"]=URLinfo.get(msg) as AnyObject
                                            messages2.add(["message":tblContacts[msg]/*+" (\(tblContacts[status])) "*/,"status":tblContacts[status], "type":"22", "date":defaultTimeeee, "uniqueid":tblContacts[uniqueid],"title":title,"description":description,"url":url])
                                            
                                            
                                        }
                                        else{
                                            print("type link but not in db")
                                            //messages2.add(["message":tblContacts[msg]+" (\(tblContacts[status])) ","status":tblContacts[status], "type":"2", "date":defaultTimeeee, "uniqueid":tblContacts[uniqueid]])
                                            
                                            //}
                                        }
                                  
                                        
                                    }else{
                                      
                                          messages2.add(["message":tblContacts[msg]+" (\(tblContacts[status])) ","status":tblContacts[status], "type":"2", "date":defaultTimeeee, "uniqueid":tblContacts[uniqueid]])
                                    }
                                        
                             //  messages2.add(["message":tblContacts[msg]+" (\(tblContacts[status])) ","status":tblContacts[status], "type":"22", "date":defaultTimeeee, "uniqueid":tblContacts[uniqueid],"title"])
                                }
                                else{
                              /*
                                var urlArray=UtilityFunctions.init().getURLs(text: tblContacts[msg])
                                if(urlArray.count>0)
                                {
                                    print("found url \(urlArray.first!)")
                                    var urlInfoDB=sqliteDB.getSingleURLInfo("\(urlArray.first!)")
                                    if(urlInfoDB.count>0){
                                        
                                        var title=urlInfoDB["title"]
                                        var description=urlInfoDB["desc"]
                                        var url=urlInfoDB["url"]
                                        //newEntry["msg"]=URLinfo.get(msg) as AnyObject
                                        messages2.add(["message":tblContacts[msg]/*+" (\(tblContacts[status])) "*/,"status":tblContacts[status], "type":"22", "date":defaultTimeeee, "uniqueid":tblContacts[uniqueid],"title":title,"description":description,"url":url])
                                        
                                        
                                    }
                                    else{
 
                                        messages2.add(["message":tblContacts[msg]+" (\(tblContacts[status])) ","status":tblContacts[status], "type":"2", "date":defaultTimeeee, "uniqueid":tblContacts[uniqueid]])
                                        
                                    //}
                                }
                                    
                                    
                                    
                                else{*/
                                    messages2.add(["message":tblContacts[msg]+" (\(tblContacts[status])) ","status":tblContacts[status], "type":"2", "date":defaultTimeeee, "uniqueid":tblContacts[uniqueid]])
                              //  }
                                
                                
                               /////=-=-= messages2.add(["message":tblContacts[msg]+" (\(tblContacts[status])) ","status":tblContacts[status], "type":"2", "date":defaultTimeeee, "uniqueid":tblContacts[uniqueid]])
                                /*var urlArray=UtilityFunctions.init().getURLs(text: tblContacts[msg])
                                print()
                                
                                let slp = SwiftLinkPreview()
                                slp.preview(
                                    tblContacts[msg],
                                    onSuccess: { result in
                                        
                                        self.hasURL=true
                                        print("url result in retrieve is \(result)")
                                        
                                        //  let embeddedView = URLEmbeddedView()
                                        // embeddedView.loadURL(sender.text!)
                                        print("title \(result[.title] as! String)")
                                        self.urlTitle=result[.title] as! String
                                        self.urlDesc=result[SwiftLinkResponseKey.description] as! String
                                        //self.urlURL=result[SwiftLinkResponseKey.url] as! String
                                        var urlURLimage=result[SwiftLinkResponseKey.image] as! String
                                        //Chat.SwiftLinkResponseKey.description
                                        //Chat.SwiftLinkResponseKey.images
                                        //Chat.SwiftLinkResponseKey.title
                                        //Chat.SwiftLinkResponseKey.url
                                        //
                                        messages2.add(["message":tblContacts[msg]+" (\(tblContacts[status])) ","status":tblContacts[status], "type":"2", "date":defaultTimeeee, "uniqueid":tblContacts[uniqueid],"title":result[.title] as! String,"description":result[SwiftLinkResponseKey.description] as! String,"url":"\(result[.url])"])
                                        self.tblForChats.reloadData()
                                },
                                    onError: { error in
                                        messages2.add(["message":tblContacts[msg]+" (\(tblContacts[status])) ","status":tblContacts[status], "type":"2", "date":defaultTimeeee, "uniqueid":tblContacts[uniqueid]])
                                        print("error: in url is \(error)")
                                        
                                })
                                
                                
                              */
                            }
                            /*{
                                messages2.add(["message":tblContacts[msg]+" (\(tblContacts[status])) ","status":tblContacts[status], "type":"2", "date":defaultTimeeee, "uniqueid":tblContacts[uniqueid]])
                             
                             
                                //^^^^self.addMessage(tblContacts[msg]+" (\(tblContacts[status])) ", ofType: "2",date: tblContacts[date],uniqueid: tblContacts[uniqueid])
                            }*/
                        }
                        }
                    }
                    else
                    {//type2
                        //// //print("statussss is \(tblContacts[status])")
                        if(tblContacts[file_type]=="image")
                        {
                            var filedownloaded=sqliteDB.checkIfFileExists(tblContacts[uniqueid])
                            
                            if(filedownloaded==false)
                            {
                                //checkpendingfiles
                                if(tblContacts[type]=="file")
                                {
                                    managerFile.checkPendingFiles(tblContacts[uniqueid])
                                }
                                if(tblContacts[type]=="broadcast_file")
                                {
                                    managerFile.checkPendingFilesBroadcasr(tblContacts[uniqueid])
                                }
                            }
                            
                            //  self.addUploadInfo(selectedContact, uniqueid1: tblContacts[uniqueid], rowindex: messages.count, uploadProgress: 1, isCompleted: true)
                            messages2.add(["message":tblContacts[msg],"filename":tblContacts[msg],"status":tblContacts[status], "type":"3", "date":defaultTimeeee, "uniqueid":tblContacts[uniqueid]])
                            
                            
                            //^^^^  self.addMessage(tblContacts[msg] , ofType: "3",date: tblContacts[date],uniqueid: tblContacts[uniqueid])
                            
                        }
                        else
                        {if(tblContacts[file_type]=="document")
                        {
                            var filedownloaded=sqliteDB.checkIfFileExists(tblContacts[uniqueid])
                            
                            if(filedownloaded==false)
                            {
                                //checkpendingfiles
                                if(tblContacts[type]=="file")
                                {
                                    managerFile.checkPendingFiles(tblContacts[uniqueid])
                                }
                                if(tblContacts[type]=="broadcast_file")
                                {
                                    managerFile.checkPendingFilesBroadcasr(tblContacts[uniqueid])
                                }
                            }
                            
                            // self.addUploadInfo(selectedContact, uniqueid1: tblContacts[uniqueid], rowindex: messages.count, uploadProgress: 1, isCompleted: true)
                            messages2.add(["message":tblContacts[msg],"filename":tblContacts[msg],"status":tblContacts[status], "type":"5", "date":defaultTimeeee, "uniqueid":tblContacts[uniqueid]])
                            
                            
                            //^^^^ self.addMessage(tblContacts[msg], ofType: "5",date: tblContacts[date],uniqueid: tblContacts[uniqueid])
                            
                        }
                        else
                        {
                            if(tblContacts[type]=="link")
                            {
                                
                                var urlArray=UtilityFunctions.init().getURLs(text: tblContacts[msg])
                                if(urlArray.count>0)
                                {
                                    print("found url \(urlArray.first!)")
                                    var urlInfoDB=sqliteDB.getSingleURLInfo(tblContacts[uniqueid])
                                    if(urlInfoDB.count>0){
                                        
                                        var title=urlInfoDB["title"]
                                        var description=urlInfoDB["desc"]
                                        var url=urlInfoDB["url"]
                                        //newEntry["msg"]=URLinfo.get(msg) as AnyObject
                                        messages2.add(["message":tblContacts[msg]/*+" (\(tblContacts[status])) "*/,"status":tblContacts[status], "type":"22", "date":defaultTimeeee, "uniqueid":tblContacts[uniqueid],"title":title,"description":description,"url":url])
                                        
                                        
                                    }
                                    else{
                                        print("type link but not in db")
                                        //messages2.add(["message":tblContacts[msg]+" (\(tblContacts[status])) ","status":tblContacts[status], "type":"2", "date":defaultTimeeee, "uniqueid":tblContacts[uniqueid]])
                                        
                                        //}
                                    }
                                    
                                    
                                }else{
                                    
                                    messages2.add(["message":tblContacts[msg]+" (\(tblContacts[status])) ","status":tblContacts[status], "type":"2", "date":defaultTimeeee, "uniqueid":tblContacts[uniqueid]])
                                }
                                
                                //  messages2.add(["message":tblContacts[msg]+" (\(tblContacts[status])) ","status":tblContacts[status], "type":"22", "date":defaultTimeeee, "uniqueid":tblContacts[uniqueid],"title"])
                            }

                            else{
                                
                                messages2.add(["message":tblContacts[msg]+" (\(tblContacts[status])) ","status":tblContacts[status], "type":"2", "date":defaultTimeeee, "uniqueid":tblContacts[uniqueid]])
                            }
                            ///^^^ self.addMessage(tblContacts[msg], ofType: "1", date: tblContacts[date],uniqueid: tblContacts[uniqueid])
                            }
                        }
                        
                    }
                    /* if(self.messages.count>1)
                     {
                     var indexPath = NSIndexPath(forRow:self.messages.count-1, inSection: 0)
                     
                     self.tblForChats.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Bottom, animated: false)
                     }*/
                    
                    //self.tblForChats.reloadData()
                    
                }
                ////////// self.messages.removeAllObjects()
                
                ////////////self.messages.addObjectsFromArray(messages2 as [AnyObject])
                
                DispatchQueue.main.async
                {
                    self.messages.setArray(messages2 as [AnyObject])
                    return completion(true)
                }
            }
            catch(let error)
            {
                DispatchQueue.main.async
                {
                    return completion(false)
                }
                //print(error)
            }
        }
        */
        /////var tbl_userchats=sqliteDB.db["userschats"]
        }
    }
    
    func sorterfunc(_ obj1:AnyObject!,obj2:AnyObject!) -> ComparisonResult
    {
        let datestr1=obj1[""] as! NSString
        let datestr2=obj1[""] as! NSString
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let date1 = dateFormatter.date(from: datestr1 as String)
        let date2 = dateFormatter.date(from: datestr2 as String)
        return date2!.compare(date1!)
        
    }
    
    func retrieveChatFromSqlite(_ selecteduser:String,completion:@escaping (_ result:Bool)->())
    {
        //print("retrieveChatFromSqlite called---------")
        ///^^messages.removeAllObjects()
        
      //  dispatch_async(Q_serial1)
        //{
            
       // }
       DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.default).async
        {
            var messages2=NSMutableArray()
            
            let to = Expression<String>("to")
            let from = Expression<String>("from")
            let owneruser = Expression<String>("owneruser")
            let fromFullName = Expression<String>("fromFullName")
            let msg = Expression<String>("msg")
            let date = Expression<Date>("date")
            let status = Expression<String>("status")
            let uniqueid = Expression<String>("uniqueid")
            let type = Expression<String>("type")
            let file_type = Expression<String>("file_type")
            let broadcastlistID = Expression<String>("broadcastlistID")
            var tbl_userchats=sqliteDB.userschats
           var res=tbl_userchats?.filter(to==selecteduser || from==selecteduser)
            //to==selecteduser || from==selecteduser
            //print("chat from sqlite is")
            //print(res)
            do
            {
                
                //for tblContacts in try sqliteDB.db.prepare(tbl_userchats.filter(owneruser==owneruser1)){
                ////print("queryy runned count is \(tbl_contactslists.count)")
                
                var query:Table
                if(self.selectedContact != "")
                {
                query=(tbl_userchats?.filter(to==selecteduser || from==selecteduser).order(date.asc))!
                }
                else{
                
                    query=(tbl_userchats?.filter(broadcastlistID == self.broadcastlistID1 && from == username!).group(uniqueid).order(date.asc))!
                        //.group(uniqueid).order(date.desc)
}
        
       /* var queryruncount=0
        do{for ccc in try sqliteDB.db.prepare(myquery) {

}*/
                for tblContacts in try sqliteDB.db.prepare(query){
                    print("found data \(tblContacts.get(to))")
                    //print("===fetch date from database is tblContacts[date] \(tblContacts[date])")
                    /*
                     var formatter = DateFormatter();
                     formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS";
                     //formatter.dateFormat = "MM/dd hh:mm a";
                     formatter.timeZone = NSTimeZone(name: "UTC")
                     */
                    // formatter.timeZone = NSTimeZone.local()
                    // var defaultTimeZoneStr = formatter..date(from:tblContacts[date])
                    // var defaultTimeZoneStr2 = formatter.stringFromDate(defaultTimeZoneStr!)
                    
                    
                    var formatter2 = DateFormatter();
                    formatter2.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
                    formatter2.timeZone = NSTimeZone.local
                    var defaultTimeeee = formatter2.string(from: tblContacts[date])
                    
                    //print("===fetch date from database is tblContacts[date] ... date converted is \(defaultTimeZoneStr)... string is \(defaultTimeZoneStr2)... defaultTimeeee \(defaultTimeeee)")
                    
                    /*//print(tblContacts[to])
                     //print(tblContacts[from])
                     //print(tblContacts[msg])
                     //print(tblContacts[date])
                     //print(tblContacts[status])
                     //print("--------")
                     */
                    
                    
                    
                    
                    
                    if(tblContacts[from]==selecteduser && ((tblContacts[status]=="delivered") || tblContacts[status]=="sent"))
                    {print("sent by \(tblContacts[from]) msg \(tblContacts[msg]) status is \(tblContacts[status])")
                        sqliteDB.UpdateChatStatus(tblContacts[uniqueid], newstatus: "seen")
                        
                        sqliteDB.saveMessageStatusSeen("seen", sender1: tblContacts[from], uniqueid1: tblContacts[uniqueid])
                        
                        self.sendChatStatusUpdateMessage(tblContacts[uniqueid],status: "seen",sender: tblContacts[from])
                        
                        //OLD SOCKET LOGIC OF SENDING CHAT STATUS
                        /*  socketObj.socket.emitWithAck("messageStatusUpdate", ["status":"seen","uniqueid":tblContacts[uniqueid],"sender": tblContacts[from]])(timeoutAfter: 15000){data in
                         var chatmsg=JSON(data)
                         
                         //print(data[0])
                         //print(data[0]["uniqueid"]!!)
                         //print(data[0]["uniqueid"]!!.debugDescription!)
                         //print(chatmsg[0]["uniqueid"].string!)
                         ////print(data[0]["status"]!!.string!+" ... "+data[0]["uniqueid"]!!.string!)
                         //print("chat status seen emitted")
                         sqliteDB.removeMessageStatusSeen(data[0]["uniqueid"]!!.debugDescription!)
                         socketObj.socket.emit("logClient","\(username) chat status emitted")
                         
                         }
                         */
                    }
                    
                    if (tblContacts[from]==username!)
                        
                    {//type1
                        /////print("statussss is \(tblContacts[status])")
                        if(tblContacts[file_type]=="image")
                        {
                            // var filedownloaded=sqliteDB.checkIfFileExists(tblContacts[uniqueid])
                            
                            /*if(filedownloaded==false)
                             {
                             //checkpendingfiles
                             managerFile.checkPendingFiles(tblContacts[uniqueid])
                             }*/
                            //  self.addUploadInfo(selectedContact, uniqueid1: tblContacts[uniqueid], rowindex: messages.count, uploadProgress: 1, isCompleted: true)
                            
                            messages2.add(["message":tblContacts[msg]+" (\(tblContacts[status]))","filename":tblContacts[msg],"type":"4", "date":defaultTimeeee, "uniqueid":tblContacts[uniqueid],"status":tblContacts[status],"caption":""])
                            
                            
                            //messages2.addObject(["message":tblContacts[msg], "type":"4", "date":tblContacts[date], "uniqueid":tblContacts[uniqueid]])
                            
                            //^^^ self.addMessage(tblContacts[msg], ofType: "4",date: tblContacts[date],uniqueid: tblContacts[uniqueid])
                            
                        }
                        else{
                            if(tblContacts[file_type]=="document")
                            {
                                //  var filedownloaded=sqliteDB.checkIfFileExists(tblContacts[uniqueid])
                                
                                /* if(filedownloaded==false)
                                 {
                                 //checkpendingfiles
                                 managerFile.checkPendingFiles(tblContacts[uniqueid])
                                 }*/
                                ////  self.addUploadInfo(selectedContact, uniqueid1: tblContacts[uniqueid], rowindex: messages.count, uploadProgress: 1, isCompleted: true)
                                
                                messages2.add(["message":tblContacts[msg]+" (\(tblContacts[status]))","filename":tblContacts[msg], "type":"6", "date":defaultTimeeee, "uniqueid":tblContacts[uniqueid]])
                                
                                //^^^^ self.addMessage(tblContacts[msg], ofType: "6",date: tblContacts[date],uniqueid: tblContacts[uniqueid])
                                
                            }
                            else
                            {
                                if(tblContacts[type]=="contact")
                                {
                                    messages2.add(["message":tblContacts[msg]/*+" (\(tblContacts[status])) ") "*/,"status":tblContacts[status], "type":"8", "date":defaultTimeeee, "uniqueid":tblContacts[uniqueid]])
                                    

                                }
                                else{
                                    
                                    if(tblContacts[file_type]=="video")
                                    {
                                        print("found video received")
                                        messages2.add(["message":tblContacts[msg],"status":tblContacts[status], "type":"10", "date":defaultTimeeee, "uniqueid":tblContacts[uniqueid]])
                                    }else{
                                        
                                        if(tblContacts[file_type]=="audio")
                                        {
                                            
                                            
                                            messages2.add(["message":tblContacts[msg],"status":tblContacts[status], "type":"12", "date":defaultTimeeee, "uniqueid":tblContacts[uniqueid]])
                                        }else{
                                            
                                            
                                            if(tblContacts[type]=="location")
                                            {
                                                
                                                
                                                messages2.add(["message":tblContacts[msg],"status":tblContacts[status], "type":"14", "date":defaultTimeeee, "uniqueid":tblContacts[uniqueid]])
                                            }
                                                
                                                
                                                
                                                
                                                ////////adddd
                                            else{
                                                
                                                print("2 in onload retrieve")
                                                if(tblContacts[type]=="link")
                                                {
                                                    
                                                    var urlArray=UtilityFunctions.init().getURLs(text: tblContacts[msg])
                                                    if(urlArray.count>0)
                                                    {
                                                        print("found url \(urlArray.first!)")
                                                        var urlInfoDB=sqliteDB.getSingleURLInfo(tblContacts[uniqueid])
                                                        if(urlInfoDB.count>0){
                                                            
                                                            var title=urlInfoDB["title"]
                                                            var description=urlInfoDB["desc"]
                                                            var url=urlInfoDB["url"]
                                                            //newEntry["msg"]=URLinfo.get(msg) as AnyObject
                                                            messages2.add(["message":tblContacts[msg]/*+" (\(tblContacts[status])) "*/,"status":tblContacts[status], "type":"22", "date":defaultTimeeee, "uniqueid":tblContacts[uniqueid],"title":title,"description":description,"url":url])
                                                            
                                                            
                                                        }
                                                        else{
                                                            print("type link but not in db")
                                                            //messages2.add(["message":tblContacts[msg]+" (\(tblContacts[status])) ","status":tblContacts[status], "type":"2", "date":defaultTimeeee, "uniqueid":tblContacts[uniqueid]])
                                                            
                                                            //}
                                                        }
                                                        
                                                        
                                                    }else{
                                                        
                                                        messages2.add(["message":tblContacts[msg]+" (\(tblContacts[status])) ","status":tblContacts[status], "type":"2", "date":defaultTimeeee, "uniqueid":tblContacts[uniqueid]])
                                                    }
                                                    
                                                    //  messages2.add(["message":tblContacts[msg]+" (\(tblContacts[status])) ","status":tblContacts[status], "type":"22", "date":defaultTimeeee, "uniqueid":tblContacts[uniqueid],"title"])
                                                }
                                                else{
                                                
                                messages2.add(["message":tblContacts[msg]+" (\(tblContacts[status])) ","status":tblContacts[status], "type":"2", "date":defaultTimeeee, "uniqueid":tblContacts[uniqueid]])
                                                }
                                    }
                                        }
                                    }
                                
                                //^^^^self.addMessage(tblContacts[msg]+" (\(tblContacts[status])) ", ofType: "2",date: tblContacts[date],uniqueid: tblContacts[uniqueid])
                                }
                                
                                }
                        }
                    } //end i was sender
                    else
                    {//type2
                        //// //print("statussss is \(tblContacts[status])")
                        if(tblContacts[file_type]=="image")
                        {
                            var filedownloaded=sqliteDB.checkIfFileExists(tblContacts[uniqueid])
                            
                            if(filedownloaded==false)
                            {
                               // self.addUploadInfo(self.selectedContact,uniqueid1: tblContacts[uniqueid], rowindex: self.messages.count, uploadProgress: 0.0, isCompleted: false)
                                //checkpendingfiles
                                
                                if(tblContacts[type]=="file")
                                {
                                    managerFile.checkPendingFiles(tblContacts[uniqueid])
                                }
                                if(tblContacts[type]=="broadcast_file")
                                {
                                    managerFile.checkPendingFilesBroadcasr(tblContacts[uniqueid])
                                }                            }
                            
                            //  self.addUploadInfo(selectedContact, uniqueid1: tblContacts[uniqueid], rowindex: messages.count, uploadProgress: 1, isCompleted: true)
                            messages2.add(["message":tblContacts[msg],"filename":tblContacts[msg],"status":tblContacts[status], "type":"3", "date":defaultTimeeee, "uniqueid":tblContacts[uniqueid],"caption":""])
                            
                            
                            //^^^^  self.addMessage(tblContacts[msg] , ofType: "3",date: tblContacts[date],uniqueid: tblContacts[uniqueid])
                            
                        }
                        else
                        {if(tblContacts[file_type]=="document")
                        {
                            var filedownloaded=sqliteDB.checkIfFileExists(tblContacts[uniqueid])
                            
                            if(filedownloaded==false)
                            {
                               // self.addUploadInfo(self.selectedContact,uniqueid1: tblContacts[uniqueid], rowindex: self.messages.count, uploadProgress: 0.0, isCompleted: false)
                                //checkpendingfiles
                                
                                if(tblContacts[type]=="file")
                                {
                                    managerFile.checkPendingFiles(tblContacts[uniqueid])
                                }
                                if(tblContacts[type]=="broadcast_file")
                                {
                                    managerFile.checkPendingFilesBroadcasr(tblContacts[uniqueid])
                                }
                            }
                            
                            // self.addUploadInfo(selectedContact, uniqueid1: tblContacts[uniqueid], rowindex: messages.count, uploadProgress: 1, isCompleted: true)
                            messages2.add(["message":tblContacts[msg],"filename":tblContacts[msg],"status":tblContacts[status], "type":"5", "date":defaultTimeeee, "uniqueid":tblContacts[uniqueid]])
                            
                            
                            //^^^^ self.addMessage(tblContacts[msg], ofType: "5",date: tblContacts[date],uniqueid: tblContacts[uniqueid])
                            
                        }
                    
                        else
                        {
                            if(tblContacts[type]=="contact")
                            {
                                print("found contact received")
                                messages2.add(["message":tblContacts[msg],"status":tblContacts[status], "type":"7", "date":defaultTimeeee, "uniqueid":tblContacts[uniqueid]])
                            }
                            else{
                                
                                if(tblContacts[file_type]=="video")
                                {
                                    print("checking if video is pending")
                                    var filedownloaded=sqliteDB.checkIfFileExists(tblContacts[uniqueid])
                                    
                                    if(filedownloaded==false)
                                    {
                                      //  self.addUploadInfo(self.selectedContact,uniqueid1: tblContacts[uniqueid], rowindex: self.messages.count, uploadProgress: 0.0, isCompleted: false)
                                        print("video is not downloaded locally")
                                        //checkpendingfiles
                                        if(tblContacts[type]=="file")
                                        {
                                            managerFile.checkPendingFiles(tblContacts[uniqueid])
                                        }
                                        if(tblContacts[type]=="broadcast_file")
                                        {
                                            managerFile.checkPendingFilesBroadcasr(tblContacts[uniqueid])
                                        }
                                    }

                                    print("found contact received")
                                    messages2.add(["message":tblContacts[msg],"status":tblContacts[status], "type":"9", "date":defaultTimeeee, "uniqueid":tblContacts[uniqueid]])
                                }
                                else{
                                    
                                    if(tblContacts[file_type]=="audio")
                                    {

                                        
                                           messages2.add(["message":tblContacts[msg],"status":tblContacts[status], "type":"11", "date":defaultTimeeee, "uniqueid":tblContacts[uniqueid]])
                                        }else{
                                        
                                        if(tblContacts[type]=="location")
                                        {
                                            
                                            
                                            messages2.add(["message":tblContacts[msg],"status":tblContacts[status], "type":"13", "date":defaultTimeeee, "uniqueid":tblContacts[uniqueid]])
                                        }else{
                                            
                                            if(tblContacts[type]=="link")
                                            {
                                                var urlArray=UtilityFunctions.init().getURLs(text: tblContacts[msg])
                                                if(urlArray.count>0)
                                                {
                                                    print("found url \(urlArray.first!)")
                                                    var urlInfoDB=sqliteDB.getSingleURLInfo(tblContacts[uniqueid])
                                                    if(urlInfoDB.count>0){
                                                        
                                                        var title=urlInfoDB["title"]
                                                        var description=urlInfoDB["desc"]
                                                        var url=urlInfoDB["url"]
                                                        //newEntry["msg"]=URLinfo.get(msg) as AnyObject
                                                        messages2.add(["message":tblContacts[msg]/*+" (\(tblContacts[status])) "*/,"status":tblContacts[status], "type":"23", "date":defaultTimeeee, "uniqueid":tblContacts[uniqueid],"title":title,"description":description,"url":url])
                                                        
                                                        
                                                    }
                                                    else{
                                                        print("type link but not in db")
                                                        //messages2.add(["message":tblContacts[msg]+" (\(tblContacts[status])) ","status":tblContacts[status], "type":"2", "date":defaultTimeeee, "uniqueid":tblContacts[uniqueid]])
                                                        
                                                        //}
                                                    }
                                                    
                                                    
                                                }else{
                                                    
                                                    messages2.add(["message":tblContacts[msg]+" (\(tblContacts[status])) ","status":tblContacts[status], "type":"1", "date":defaultTimeeee, "uniqueid":tblContacts[uniqueid]])
                                                }
                                                
                                                //  messages2.add(["message":tblContacts[msg]+" (\(tblContacts[status])) ","status":tblContacts[status], "type":"22", "date":defaultTimeeee, "uniqueid":tblContacts[uniqueid],"title"])
                                            }
                                            else{
                            messages2.add(["message":tblContacts[msg],"status":tblContacts[status], "type":"1", "date":defaultTimeeee, "uniqueid":tblContacts[uniqueid]])
                                            }
                                        }
                                        }
                                }
                            }
                            
                            ///^^^ self.addMessage(tblContacts[msg], ofType: "1", date: tblContacts[date],uniqueid: tblContacts[uniqueid])
                            }
                        }
                        
                    }
                    /* if(self.messages.count>1)
                     {
                     var indexPath = NSIndexPath(forRow:self.messages.count-1, inSection: 0)
                     
                     self.tblForChats.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Bottom, animated: false)
                     }*/
                    
                    //self.tblForChats.reloadData()
                    
                }
                ////////// self.messages.removeAllObjects()
                
                ////////////self.messages.addObjectsFromArray(messages2 as [AnyObject])
               // messages2.sortUsingComparator(self.sorterfunc)
                DispatchQueue.main.async
                {
                    self.messages.setArray(messages2 as [AnyObject])
                    return completion(true)
                }
            }
            catch(let error)
            {
                DispatchQueue.main.async
                {
                    return completion(false)
                }            //print(error)
            }
            /////var tbl_userchats=sqliteDB.db["userschats"]
        }
    }

    func removeChatHistory(){
        //print("header is \(header) selectedContact is \(selectedContact)")
        
        //var loggedUsername=loggedUserObj["username"]
        //print("inside mark funcc", terminator: "")
        var removeChatHistoryURL=Constants.MainUrl+Constants.removeChatHistory
        
        //Alamofire.request(.POST,"\(removeChatHistoryURL)",headers:header,parameters: ["username":"\(selectedContact)"]).validate(statusCode: 200..<300).response{
       
        
        Alamofire.request("\(removeChatHistoryURL)", method: .post, parameters:  ["phone":selectedContact],headers:header).response{
            response in

        
            //alamofire4
        /*Alamofire.request(.POST,"\(removeChatHistoryURL)",headers:header,parameters: ["phone":selectedContact]).validate(statusCode: 200..<300).response{
            
            request1, response1, data1, error1 in
            */
            //===========INITIALISE SOCKETIOCLIENT=========
            // dispatch_async(dispatch_get_main_queue(), {
            
            //self.dismiss(true, completion: nil);
            /// self.performSegueWithIdentifier("loginSegue", sender: nil)
            
            if response.response?.statusCode==200 {
                //print("chat history deleted")
                ////print(request1)
                //print(data1?.debugDescription)
                
                sqliteDB.deleteChat(self.selectedContact.debugDescription)
                
                self.messages.removeAllObjects()
                DispatchQueue.main.async
                {
                    self.tblForChats.reloadData()
                }
            }
            else
            {//print("chat history not deleted")
                //print(error1)
                //print(data1)
            }
            if(response.response?.statusCode==401)
            {
                //print("chat history not deleted token refresh needed")
                if(username==nil || password==nil)
                {
                    self.performSegue(withIdentifier: "loginSegue", sender: nil)
                }
                else{
                    self.rt.refrToken()
                }
            }
        }
        
        
    }
    
    /*func markChatAsRead()
    {
        //print("inside mark as read", terminator: "")
        var markChatReadURL=Constants.MainUrl+Constants.markAsRead
        ////print(["user1":"\(loggedUserObj)","user2":"\(selectedUserObj)"])
        //print("**", terminator: "")
        //^^^^^ var loggedID=loggedUserObj["_id"]
        var loggedID=_id
        //^^^^//print(loggedID.description+" logged id")
        //print(loggedID!+" logged id", terminator: "")
        //print(self.selectedID+" selected id", terminator: "")
        Alamofire.request(.POST,"\(markChatReadURL)",headers:header,parameters: ["user1":"\(loggedID!)","user2":"\(self.selectedID)"]
            ).responseJSON{response in
                var response1=response.response
                var request1=response.request
                var data1=response.data
                var error1=response.result.error
                
                if(error1==nil)
                {//print("chat marked as read")}
                else
                {
                    self.rt.refrToken()
                }
                //===========INITIALISE SOCKETIOCLIENT=========
                // dispatch_async(dispatch_get_main_queue(), {
                
                //self.dismiss(true, completion: nil);
                /// self.performSegueWithIdentifier("loginSegue", sender: nil)
                
                //^^ if response1?.statusCode==200 {
                //print("chat marked as read")
                //print(response1)
                ////print(data1?.debugDescription)
                //var UserchatJson=JSON(data1!)
                //^^}
                /*else
                 {//print("chat marked as read but status code is not 200")
                 //print(error1)
                 ////print(response1?.statusCode)
                 ////print(data1)
                 }
                 */
                /*if(response1?.statusCode==401)
                 {
                 //print("chat not marked as read refresh token needed")
                 self.rt.refrToken()
                 }
                 */
        }
        
        
    }*/
    
    override func awakeFromNib() {
      //  NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("applicationWillBecomeActive:"), name:UIApplicationDidBecomeActiveNotification, object: nil)
       //print("awakeeeeeeeee")
        /*NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("applicationWillResignActive:"), name:UIApplicationWillResignActiveNotification, object: nil)
        
        //
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("applicationDidBecomeActive:"), name:UIApplicationWillEnterForegroundNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("willShowKeyBoard:"), name:UIKeyboardWillShowNotification, object: nil)
        */
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addMessage(_ message: String,status:String, ofType msgType:String, date:String, uniqueid:String) {
        messages.add(["message":message,"status":status, "type":msgType, "date":date, "uniqueid":uniqueid])
    }
    
   
    
    func updateProgressUpload(_ progress: Float, uniqueid: String) {
        
        //print("progress delegate called \(progress) .. uniqueid is \(uniqueid)")
        //uploadInfo.indexOfObject(<#T##anObject: AnyObject##AnyObject#>)
       /* uploadInfo.filterUsingPredicate(NSPredicate(block: { ("uniqueid", uniqueid) -> Bool in
            
         
        })*/
        
        var predicate=NSPredicate(format:"uniqueid = %@", uniqueid)
        var resultArray=self.messages.filtered(using: predicate)
        if(resultArray.count > 0)
        {
            print("scrollinggg 451 line")
            var foundindex=self.messages.index(of: resultArray.first!)
            let indexPath = IndexPath(row:foundindex, section: 0)
            // self.tblForChats.seth
          
            var newcell=self.tblForChats.cellForRow(at: indexPath)
           
            //self.tblForChats.scrollToRow(at: indexPath, at: UITableViewScrollPosition.bottom, animated: false)
            if(newcell != nil)
            {
                do{
                    var newprogressview = try newcell!.viewWithTag(14) as! KDCircularProgress!
                    var intangle=(progress*360) as NSNumber
                    
                    //print("from \(newprogressview.angle) to \(intangle.integerValue)")
                    newprogressview?.isHidden=false
                    newprogressview?.animate(toAngle: Double(intangle), duration: 0.7, completion: { (result) in
                        if(intangle.intValue==360)
                        {
                            newprogressview?.isHidden=true
                            
                            self.tblForChats.beginUpdates()
                            //var indexp=IndexPath(row:indexP, section:0)
                            self.tblForChats.reloadRows(at: [indexPath] as! [IndexPath], with: UITableViewRowAnimation.none)
                            self.tblForChats.endUpdates()
                            
                            //!!self.tblForChats.reloadRows(at: [indexPath], with: UITableViewRowAnimation.none)
                        }
                        else
                        {
                            newprogressview?.isHidden=false
                        }
                        
                        
                    })
                }
            }
        }
        
            
            
            
            
            
            /*
            
        var predicate=NSPredicate(format: "uniqueid = %@", uniqueid)
        var foundcellIndex=messages.filtered(using: predicate)
        if(foundcellIndex.count>0)
        {
            var newcell=self.tblForChats.ind cellForRow(at: foundcellIndex.first as! IndexPath)
            if(newcell != nil)
            {
                do{
                var newprogressview = try newcell!.viewWithTag(14) as! KDCircularProgress!
                var intangle=(progress*360) as NSNumber
                
                //print("from \(newprogressview.angle) to \(intangle.integerValue)")
                newprogressview?.isHidden=false
                newprogressview?.animate(toAngle: Double(intangle), duration: 0.7, completion: { (result) in
                    if(intangle.intValue==360)
                    {
                        newprogressview?.isHidden=true
                        
                        self.tblForChats.beginUpdates()
                        //var indexp=IndexPath(row:indexP, section:0)
                        self.tblForChats.reloadRows(at: foundcellIndex as! [IndexPath], with: UITableViewRowAnimation.none)
                        self.tblForChats.endUpdates()
                        
                        //!!self.tblForChats.reloadRows(at: [indexPath], with: UITableViewRowAnimation.none)
                    }
                    else
                    {
                        newprogressview?.isHidden=false
                    }
                    
                    
                })
        }
            }
        }*/
    }
    
            
            /*
        var resultArray=uploadInfo.filtered(using: predicate)
        //cfpresultArray.first
        if(resultArray.count==0)
        {
            
            self.addUploadInfo(self.selectedContact,uniqueid1: uniqueid, rowindex: self.messages.count, uploadProgress: 0.0, isCompleted: false)
            resultArray=uploadInfo.filtered(using: predicate)

        }
        if(resultArray.count>0)
        {
            
        var foundInd=uploadInfo.index(of: resultArray.first!)
        var resultArrayMsgs=messages.filtered(using: predicate)

        
         var foundMsgInd=messages.index(of: resultArrayMsgs.first!)
        //if(foundInd != NSNotFound)
            if(resultArray.count>0){
               // //print("found uniqueID index as \(foundInd)")
                var newuser=(resultArray.first! as AnyObject).value(forKey: "selectedUser")
                var newuniqueid=(resultArray.first! as AnyObject).value(forKey: "uniqueid")
                var newrowindex=foundMsgInd
                var newuploadProgress=progress
                ///var newIsCompleted=resultArray.first!.valueForKey("isCompleted")
                
                var newIsCompleted=false
                if(progress==1.0)
                    {
                        newIsCompleted=true
                    }
                
                var aaa:[String:AnyObject]=["selectedUser":newuser! as AnyObject,"uniqueid":newuniqueid! as AnyObject,"rowIndex":newrowindex as AnyObject,"uploadProgress":newuploadProgress as AnyObject,"isCompleted":newIsCompleted as AnyObject]
                
               /////// uploadInfo.insertObject(aaa, atIndex: foundInd)
                
                
                //let newObject=["selectedUser":newuser,"uniqueid":newuniqueid,"rowIndex":newrowindex,"uploadProgress":newuploadProgress,"isCompleted":newIsCompleted]
                uploadInfo.replaceObject(at: messages.index(of: resultArrayMsgs.first!), with: aaa)
                /*
 ["selectedUser":selectedUser1,"uniqueid":uniqueid1,"rowIndex":rowindex,"uploadProgress":uploadProgress,"isCompleted":isCompleted]
 */
                //=progress
               // var foundMsgInd=messages.indexOfObject(messages.valueForKey("uniqueid") as! String==uniqueid)
                var indexPath = IndexPath(row: messages.index(of: resultArrayMsgs.first!), section: 0)
                
                DispatchQueue.main.async
                {
                    
                    var newcell=self.tblForChats.cellForRow(at: indexPath)
                    if(newcell != nil)
                    {do{
                    var newprogressview = try newcell!.viewWithTag(14) as! KDCircularProgress!
                    var intangle=(progress*360) as NSNumber
                    
                    //print("from \(newprogressview.angle) to \(intangle.integerValue)")
                    newprogressview?.isHidden=false
                    newprogressview?.animate(toAngle: Double(intangle), duration: 0.7, completion: { (result) in
                        if(intangle.intValue==360)
                        {
                            newprogressview?.isHidden=true
                            
                            self.tblForChats.beginUpdates()
                            //var indexp=IndexPath(row:indexP, section:0)
                            self.tblForChats.reloadRows(at: [indexPath], with: UITableViewRowAnimation.none)
                            self.tblForChats.endUpdates()
                            
                             //!!self.tblForChats.reloadRows(at: [indexPath], with: UITableViewRowAnimation.none)
                        }
                        else
                        {
                            newprogressview?.isHidden=false
                        }
 
                        
                    })/* animateToAngle(intangle.intValue, duration: 0.7, completion: { (Bool) in
                        
                        if(intangle.intValue==360)
                        {
                            newprogressview?.isHidden=true
                        }
                        else
                        {
                            newprogressview?.isHidden=false
                        }
                        //newprogressview.angle=intangle.integerValue
                        
                    })
 */
 
                   
                    
                    //var cell=self.tblForChats.dequeueReusableCellWithIdentifier("")! as UITableViewCell
                    }
                    
                    catch
                    {
                        //print("errorrrrr 788")
                    }
                }
                }
                
            }
    }
    }
    
    */
    
    
    func addUploadInfo(_ selectedUser1:String,uniqueid1:String,rowindex:Int,uploadProgress:Float,isCompleted:Bool)
    {
        uploadInfo.add(["selectedUser":selectedUser1,"uniqueid":uniqueid1,"rowIndex":rowindex,"uploadProgress":uploadProgress,"isCompleted":isCompleted])
    }
    
   
    
    
    //***** was working but not needed
    /*func FetchChatServer(completion:(result:Bool)->())
     {
     
     //print("[user1:\(username!),user2:\(selectedContact)]", terminator: "")
     ///POST GET april 2016
     var bringUserChatURL=Constants.MainUrl+Constants.bringUserChat
     let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
     let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
     dispatch_async(dispatch_get_global_queue(priority, 0)) {
     Alamofire.request(.POST,"\(bringUserChatURL)",headers:header,parameters: ["user1":"\(username!)","user2":"\(self.selectedContact)"]
     ).validate(statusCode: 200..<300).responseJSON{response in
     var response1=response.response
     var request1=response.request
     var data1=response.result.value
     var error1=response.result.error
     
     
     
     /*.validate(statusCode: 200..<300)
     .response { (request1, response1, data1, error1) in*/
     
     
     //===========INITIALISE SOCKETIOCLIENT=========
     // dispatch_async(dispatch_get_main_queue(), {
     
     //self.dismiss(true, completion: nil);
     /// self.performSegueWithIdentifier("loginSegue", sender: nil)
     
     if response1?.statusCode==200 {
     //print("chatttttttt:::::")
     //print(response1)
     //print(data1)
     var UserchatJson=JSON(data1!)
     //print(UserchatJson)
     socketObj.socket.emit("logClient","user chat fetched \(UserchatJson)")
     //print(":::::^^^&&&&&")
     ////print(UserchatJson["msg"][0]["to"])
     
     //Overwrite sqlite db
     sqliteDB.deleteChat(self.selectedContact)
     
     socketObj.socket.emit("logClient","IPHONE-LOG: chat messages count is \(UserchatJson["msg"].count)")
     for var i=0;i<UserchatJson["msg"].count
     ;i++
     {
     
     
     sqliteDB.SaveChat(UserchatJson["msg"][i]["to"].string!, from1: UserchatJson["msg"][i]["from"].string!,owneruser1:UserchatJson["msg"][i]["owneruser"].string! , fromFullName1: UserchatJson["msg"][i]["fromFullName"].string!, msg1: UserchatJson["msg"][i]["msg"].string!,date1:UserchatJson["msg"][i]["date"].string!)
     
     //%%%%%%%%%%%%%%%%%%%%%%%%%
     //%%%%%%%%%%%%%%%%%%%%%%%%%%
     //_______________________________commenting june 2016 for testing--------
     
     
     /*if (UserchatJson["msg"][i]["from"].string==username!)
     
     {//type1
     self.addMessage(UserchatJson["msg"][i]["msg"].string!, ofType: "2")
     }
     else
     {//type2
     self.addMessage(UserchatJson["msg"][i]["msg"].string!, ofType: "1")
     
     }
     
     self.tblForChats.reloadData()
     if(self.messages.count>1)
     {
     var indexPath = NSIndexPath(forRow:self.messages.count-1, inSection: 0)
     self.tblForChats.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Bottom, animated: false)
     }
     */
     
     }
     DispatchQueue.main.async {
     completion(result:true)
     }
     }
     else
     {
     
     //print("chatttttt faileddddddd")
     //print(response1)
     //print(error1)
     //print(data1)
     completion(result:false)
     }
     
     
     // })
     if(response1?.statusCode==401)
     {
     socketObj.socket.emit("logClient","IPHONE-LOG: error in fetching chat status 401")
     //print("chatttttt fetch faileddddddd token expired")
     self.rt.refrToken()
     }
     }
     }
     
     
     }*/
    

    
    func tableView(_ tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func numberOfSectionsInTableView(_ tableView: UITableView!) -> Int {
        return 1
    }
    /*func tableView(tableView: UITableView, heightForFooterInSection section: NSInteger) -> CGFloat
    {
     return 10
    }*/
    

    /*func tableView(_ tableView: UITableView, heightForRowAtIndexPath indexPath: IndexPath) -> CGFloat {
        
      // print("cal height for row \(indexPath.row) and dixt object count is \(messages.count)")
       // label.text = "This is a Label"
        
        if(messages.count > 0 && (messages.count > indexPath.row))
        {
        var messageDic = messages.object(at: indexPath.row) as! [String : String];
        
        let msg = messageDic["message"] as NSString!
        let msgType = messageDic["type"]! as NSString
        
        /*var textLable = UILabel(frame: CGRectMake(0, 0, 170, 15))
        textLable.numberOfLines=0
        textLable.font=textLable.font.fontWithSize(11)
        textLable.textAlignment = NSTextAlignment.Left
        textLable.contentMode = .TopLeft
        textLable.text = "\(msg)"
        textLable.lineBreakMode = .ByWordWrapping
        
        textLable.sizeToFit()
        print("previous height is \(textLable.frame.height) msg is \(msg)")
        var correctheight=textLable.frame.height
        */
      // if(msgType.isEqualToString("3")||msgType.isEqualToString("4"))
        //{
            if(msgType.isEqual(to: "3") || msgType.isEqual(to: "13"))
            {
            //FileImageSentCell
            let cell = tblForChats.dequeueReusableCell(withIdentifier: "FileImageSentCell")! as UITableViewCell
                let chatImage = cell.viewWithTag(1) as! UIImageView
                
                
                if(chatImage.frame.height <= 230)
                {
                    return chatImage.frame.height+20
                }
                else
                {
                    return 200
                }
            }
           else
            {
               if(msgType.isEqual(to: "4") || msgType.isEqual(to: "14"))
               {
            let cell = tblForChats.dequeueReusableCell(withIdentifier: "FileImageReceivedCell")! as UITableViewCell
            let chatImage = cell.viewWithTag(1) as! UIImageView
            
            
            if(chatImage.frame.height <= 230)
            {
            return chatImage.frame.height+20
            }
            else
            {
            return 200
            }
            }//end 4
               else{
                
                if(msgType.isEqual(to: "7") || msgType.isEqual(to: "8") || msgType.isEqual(to: "11") || msgType.isEqual(to: "12"))
                {
                    let cell = tblForChats.dequeueReusableCell(withIdentifier: "ContactSentCell")! as UITableViewCell
                    let chatImage = cell.viewWithTag(1) as! UIImageView
                    
                    
                    if(chatImage.frame.height <= 180)
                    {
                        return chatImage.frame.height+20
                    }
                    else
                    {
                        return 180
                    }
                }
                else{
                    if(msgType.isEqual(to: "9") || msgType.isEqual(to: "10"))
                    {
                        return 215
                    }
                    else{
                if(tblForChats.cellForRow(at: indexPath) != nil)
{
    let cell=tblForChats.cellForRow(at: indexPath)
    let chatImage = cell!.viewWithTag(1) as! UIImageView
  
     return chatImage.frame.height+5

}else{
                  if(msgType.isEqual(to: "22"))
                  {
                    return getSizeOfStringHeight(msg!).height+25+60+10
                //=== ==== --return correctheight+25
                    }
                  else{
                    return getSizeOfStringHeight(msg!).height+25
                    }
                        }}
                }
                /*if(msgType.isEqualToString("1"))
                 {
                    var cell = tblForChats.dequeueReusableCellWithIdentifier("ChatSentCell")! as UITableViewCell
                    let chatImage = cell.viewWithTag(1) as! UIImageView
                   return self.getSizeOfStringHeight(msg).height+20
                    //return chatImage.frame.height+10
                    
                }//end 1
                else
                 {
                    if(msgType.isEqualToString("2"))
                    {
                        var cell = tblForChats.dequeueReusableCellWithIdentifier("ChatReceivedCell")! as UITableViewCell
                        let chatImage = cell.viewWithTag(1) as! UIImageView
                        return self.getSizeOfStringHeight(msg).height+30
                        //return chatImage.frame.height+10
                    }//end 2
                    else
                    {
                        if(msgType.isEqualToString("5"))
                        {
                            var cell = tblForChats.dequeueReusableCellWithIdentifier("DocSentCell")! as UITableViewCell
                            let chatImage = cell.viewWithTag(1) as! UIImageView
                            return self.getSizeOfStringHeight(msg).height+20
                            //return chatImage.frame.height+10
                        }//end 5
                        else
                        {
                            //6
                            var cell = tblForChats.dequeueReusableCellWithIdentifier("DocReceivedCell")! as UITableViewCell
                            
                            let chatImage = cell.viewWithTag(1) as! UIImageView
                            return self.getSizeOfStringHeight(msg).height+20
                            //return chatImage.frame.height+10
                                
}
                    }
                }
                }*/
            }
        }
        }
        else
        {
            return 0
        }
        
      /*  }
        else
        {
        let sizeOFStr = self.getSizeOfStringHeight("\(msg)")
           // if(msgType.isEqualToString("2"))
           // {
            
           //(
           /* var cell = tblForChats.cellForRowAtIndexPath(indexPath)
                
                let chatImage = cell!.viewWithTag(1) as! UIImageView
                return chatImage.frame.height+10
          */
            
        
        return sizeOFStr.height + 25
          ///  return 100
        }*/
        /* var cell : UITableViewCell!
         cell = tblForChats.dequeueReusableCellWithIdentifier("ChatSentCell")! as UITableViewCell
         
         /*
         [self configureCell:self.prototypeCell forRowAtIndexPath:indexPath];
         [self.prototypeCell layoutIfNeeded];
         
         CGSize size = [self.prototypeCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
         return size.height+1;
         */
         
         // height = [NSLayoutConstraint constraintWithItem:chatUserImage attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.f constant:25.0f];
         
         //var hhh = NSLayoutConstraint(item: txtFldMessage, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 25.0)
         
         var size:CGSize=cell.contentView.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize);
         
         var messageDic = messages.objectAtIndex(indexPath.row) as! [String : String];
         let msg = messageDic["message"] as NSString!
         
         let sizeOFStr = self.getSizeOfString(msg)
         //var hh1 = msg.boundingRectWithSize(CGSizeMake(220.0,CGFloat.max), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: nil, context: nil).size
         
         return sizeOFStr.height + 70
         ////print("size old is \(sizeOFStr.height) and my height is \(size.height)")
         //return size.height+1;
         
         */
    }
    */
     func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath) {
        if(messages.count > 0 && messages.count > indexPath.row)
        {
        var messageDic = messages.object(at: indexPath.row) as! [String : String];
        NSLog(messageDic["message"]!, 1)
        let msgType = messageDic["type"] as NSString!
        let msg = messageDic["message"] as NSString!
        
        if((msgType?.isEqual(to: "5"))!||(msgType?.isEqual(to: "6"))!){
        self.performSegue(withIdentifier: "showFullDocSegue", sender: nil);
        }
            if((msgType?.isEqual(to: "14"))! || (msgType?.isEqual(to: "13"))!){
                self.performSegue(withIdentifier: "MapViewSegue", sender: nil);
            }
        }
    }
    
    
    
    
    //urlPopView.xib
    func loadViewFromXibFile() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "urlPopView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }
    

    func tableView(_ tableView: UITableView!, cellForRowAtIndexPath indexPath: IndexPath!) -> UITableViewCell! {
        var cell : UITableViewCell!
       // print("reloading of cellsssssssss......------------===========++++++")
        cell = tblForChats.dequeueReusableCell(withIdentifier: "ChatSentCell")! as UITableViewCell
        
               //print("cellForRowAtIndexPath called \(indexPath)")
       // if(messages.count > 0 && messages.count > indexPath.row)
        //{
        //print("inside cellforrow updating row \(indexPath.row) and messages count is \(messages.count)")
        var messageDic = messages.object(at: indexPath.row) as! [String : String];
        NSLog(messageDic["message"]!, 1)
        let msgType = messageDic["type"] as NSString!
        let msg = messageDic["message"] as NSString!
        let date2=messageDic["date"] as NSString!
        var sizeOFStr = self.getSizeOfString(msg!)
        let uniqueidDictValue=messageDic["uniqueid"] as NSString!
        let status=messageDic["status"] as NSString!
        
       // cell = tblForChats.dequeueReusableCellWithIdentifier("ChatSentCell")! as UITableViewCell

        //cell.tag=indexPath.row
        //print("sizeOFStr for \(msg) is \(sizeOFStr)")
       //// //print("sizeOfstr is width \(sizeOFStr.width) and height is \(sizeOFStr.height)")
        
        //var sizeOFStr=msg.boundingRectWithSize(CGSizeMake(220.0,CGFloat.max), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: nil, context: nil).size
        /*
         
         Messagesize = [message.userMessage boundingRectWithSize:CGSizeMake(220.0f, CGFLOAT_MAX)
         options:NSStringDrawingUsesLineFragmentOrigin
         attributes:@{NSFontAttributeName:fontArray[1]}
         context:nil].size;
         
         
         Timesize = [@"Time" boundingRectWithSize:CGSizeMake(220.0f, CGFLOAT_MAX)
         options:NSStringDrawingUsesLineFragmentOrigin
         attributes:@{NSFontAttributeName:fontArray[2]}
         context:nil].size;
         
         
         size.height = Messagesize.height + Namesize.height + Timesize.height + 48.0f;
         */
        
        if (msgType?.isEqual(to: "1"))!{
            if(cell==nil)
{//ChatSentCell
            cell = tblForChats.dequeueReusableCell(withIdentifier: "ChatSentCell")! as UITableViewCell
}
           
            let textLable = cell.viewWithTag(12) as! ActiveLabel
            let chatImage = cell.viewWithTag(1) as! UIImageView
            let profileImage = cell.viewWithTag(2) as! UIImageView
            let timeLabel = cell.viewWithTag(11) as! UILabel
           
 
            //textLable.dataDetectorTypes = UIDataDetectorTy
            textLable.text = msg! as! String
           // var range=textLable.rangeOfString("www.iba.edu.pk")
            //textLable.link
            /*textLable.lineBreakMode = .ByWordWrapping
            textLable.numberOfLines=0
            textLable.sizeToFit()
            print("previous height is \(textLable.frame.height) msg is \(msg)")
            var correctheight=textLable.frame.height
            */
            let correctheight=getSizeOfStringHeight(msg!).height
            
            chatImage.frame = CGRect(x: chatImage.frame.origin.x, y: chatImage.frame.origin.y,width: ((sizeOFStr.width + 107)  > 207 ? (sizeOFStr.width + 107) : 200), height: correctheight + 20)
            //====new  chatImage.frame = CGRectMake(chatImage.frame.origin.x, chatImage.frame.origin.y, ((sizeOFStr.width + 100)  > 200 ? (sizeOFStr.width + 100) : 200), sizeOFStr.height + 40)
            chatImage.image = UIImage(named: "chat_receive")?.stretchableImage(withLeftCapWidth: 40,topCapHeight: 20);
            //******
            
          textLable.frame = CGRect(x: textLable.frame.origin.x, y: textLable.frame.origin.y, width: chatImage.frame.width-36, height: correctheight)
            
         //==new  textLable.frame = CGRectMake(textLable.frame.origin.x, textLable.frame.origin.y, textLable.frame.size.width, sizeOFStr.height)
            
            
            ////// profileImage.center = CGPointMake(profileImage.center.x, textLable.frame.origin.y + textLable.frame.size.height - profileImage.frame.size.height/2 + 10)
            profileImage.center = CGPoint(x: profileImage.center.x, y: textLable.frame.origin.y + textLable.frame.size.height - profileImage.frame.size.height/2+20)
            textLable.text = msg! as! String
            
            //textLable.text = msg! as! String
            textLable.numberOfLines = 0
            textLable.enabledTypes = [.mention, .hashtag, .url]
            // textLable.text = "This is a post with #hashtags and a @userhandle."
            textLable.textColor = .black
            textLable.handleHashtagTap { hashtag in
                print("Success. You just tapped the \(hashtag) hashtag")
            }
            textLable.handleURLTap({ (url) in
                print("Success. You just tapped the \(url) url")
                var stringURL="\(url)"
                if !(stringURL.contains("http")) {
                    stringURL = "http://" + stringURL
                }
                
                var res=UIApplication.shared.openURL(NSURL.init(string: stringURL) as! URL)
                print("open url \(res)")
            })

            
            
            ////////!!!!!!!!
            
            textLable.isHidden=false
            textLable.text = msg! as! String
            ////textLable.numberOfLines = 0
            textLable.enabledTypes = [.mention, .hashtag, .url]
            // textLable.text = "This is a post with #hashtags and a @userhandle."
            textLable.textColor = .black
            textLable.handleHashtagTap { hashtag in
                print("Success. You just tapped the \(hashtag) hashtag")
            }
            textLable.handleURLTap({ (url) in
                print("Success. You just tapped the \(url) url")
                var stringURL="\(url)"
                if !(stringURL.contains("http")) {
                    stringURL = "http://" + stringURL
                }
                
                var res=UIApplication.shared.openURL(NSURL.init(string: stringURL) as! URL)
                print("open url \(res)")
            })
            print("message is \(textLable.text!)")
            print("url encode is \(textLable.text?.urlEncode())  and isvalidurl  \(textLable.text?.isValidURL())")
            
            if(textLable.text!.isValidURL() == true)
            {
                //update database and fetch metadata in background
                if !(textLable.text!.contains("http")) {
                    textLable.text! = "http://" + textLable.text!
                }
                
                let slp = SwiftLinkPreview()
                slp.preview(
                    textLable.text! as String!,
                    onSuccess: { result in
                        
                        self.hasURL=true
                        var description="-"
                        if let desc=result[SwiftLinkResponseKey.description]
                        {
                            description=desc as! String
                        }
                        print("url result in retrieve is \(result)")
                        sqliteDB.SaveURLData(uniqueidDictValue! as! String,title1:result[.title] as! String,desc1:description/*result[SwiftLinkResponseKey.description] as! String*/,url1:"\(result[SwiftLinkResponseKey.url]!)",msg1:msg! as String!,image1:nil//Data.init(base64Encoded:result[SwiftLinkResponseKey.image] as! String)!
                        )
                        
                        sqliteDB.UpdateChat(uniqueidDictValue! as! String, type1: "link")
                        
                        //  let embeddedView = URLEmbeddedView()
                        // embeddedView.loadURL(sender.text!)
                        
                        
                        
                        
                        
                        print("title \(result[.title] as! String)")
                        messageDic["title"]=result[.title] as! String
                        messageDic["description"]=description
                        //result[SwiftLinkResponseKey.description] as! String
                        messageDic["url"]="\(result[SwiftLinkResponseKey.url]!)!"
                        messageDic["image"]=result[SwiftLinkResponseKey.image] as! String
                        
                        
                        var messageDicSingle = self.messages.object(at: indexPath.row) as! [String : String];
                        let msgType = messageDicSingle["type"] as String!
                        let msg = messageDicSingle["message"] as String!
                        let date2=messageDicSingle["date"] as String!
                        var sizeOFStr = self.getSizeOfString(msg! as! NSString)
                        let uniqueidDictValue=messageDicSingle["uniqueid"] as String!
                        let status=messageDicSingle["status"] as String!
                        
                        
                        
                        var messages2=["message":msg!/*+" (\(status)) "*/,"status":status, "type":"11", "date":date2, "uniqueid":uniqueidDictValue,"title":result[.title] as! String,"description":description,"url":"\(result[SwiftLinkResponseKey.url]!)!"]
                        
                        self.messages.replaceObject(at: indexPath.row, with: messages2)
                        //NSLog(messageDic["message"]!, 1)
                        
                        //self.tblForChats.reloadRows(at: [indexp], with: UITableViewRowAnimation.bottom)
                        self.urlTitle=result[.title] as! String
                        self.urlDesc=description
                        //self.urlURL=result[SwiftLinkResponseKey.url] as! String
                        var urlURLimage=result[SwiftLinkResponseKey.image] as! String
                        
                        /* title.isHidden=false
                         desc.isHidden=false
                         urllbl.isHidden=false
                         activityIndicator.stopAnimating()
                         
                         
                         
                         title.text=result[.title] as! String
                         desc.text=result[SwiftLinkResponseKey.description] as! String
                         urllbl.text="\(result[SwiftLinkResponseKey.url]!)"
                         */
                        self.tblForChats.beginUpdates()
                        //var indexp=IndexPath(row:indexP, section:0)
                        self.tblForChats.reloadRows(at: [indexPath], with: UITableViewRowAnimation.none)
                        self.tblForChats.endUpdates()
                        //Chat.SwiftLinkResponseKey.description
                        //Chat.SwiftLinkResponseKey.images
                        //Chat.SwiftLinkResponseKey.title
                        //Chat.SwiftLinkResponseKey.url
                        //
                        /// self.messages.add(["message":tblContacts[msg]+" (\(tblContacts[status])) ","status":tblContacts[status], "type":"2", "date":defaultTimeeee, "uniqueid":tblContacts[uniqueid],"title":result[.title] as! String,"description":result[SwiftLinkResponseKey.description] as! String,"url":"\(result[.url]!)"])
                        
                        
                        // var urlinfoObject=sqliteDBgetSingleURLInfo(url1:"\(result[SwiftLinkResponseKey.url])")
                        
                        
                        
                        
                        
                },
                    onError: { error in
                        ///self.messages.add(["message":tblContacts[msg]+" (\(tblContacts[status])) ","status":tblContacts[status], "type":"2", "date":defaultTimeeee, "uniqueid":tblContacts[uniqueid]])
                        print("error: in url is \(error)")
                        /* desc.isHidden=false
                         desc.text="Unable to load data"
                         activityIndicator.stopAnimating()*/
                        
                        
                }
                    
                )
            }
            
         
            
            
            
            
            
            
            
            
            //////
            
            
             /*
             let dateFormatter = DateFormatter()
            dateFormatter.timeZone=NSTimeZone.local()
             dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
           //  let datens2 = dateFormatter.date(from:date2.debugDescription)
            //2016-09-18T19:13:00.588Z
             let datens2 = dateFormatter.date(from:"2016-09-18T19:13:00.588")
             //print(".... \(datens2)")
            */
             //let formatter2 = DateFormatter()
             //formatter2.dateStyle = NSDateFormatterStyle.ShortStyle
             //formatter2.timeStyle = .ShortStyle
             
             //let dateString = formatter.stringFromDate(datens2!)
           // //print("dateeeeeee \(dateString)")
            
            //print("date received in chat is \(date2.debugDescription)")
            let formatter = DateFormatter();
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS";
            //formatter.dateFormat = "MM/dd hh:mm a";
            formatter.timeZone = TimeZone.autoupdatingCurrent
            print("line 2055")
            let defaultTimeZoneStr = formatter.date(from: date2 as! String)
            //print("defaultTimeZoneStr \(defaultTimeZoneStr)")
            
            let formatter2 = DateFormatter();
            formatter2.timeZone=TimeZone.autoupdatingCurrent
            formatter2.dateFormat = "MM/dd hh:mm a";
            let displaydate=formatter2.string(from: defaultTimeZoneStr!)
            //formatter.dateFormat = "MM/dd hh:mm a";
            
            
            //!!timeLabel.frame = CGRect(x: textLable.frame.origin.x, y: textLable.frame.origin.y+textLable.frame.height, width: chatImage.frame.size.width-46, height: timeLabel.frame.size.height)
            
            
           //===new   timeLabel.frame = CGRectMake(textLable.frame.origin.x, textLable.frame.origin.y+textLable.frame.height+10, chatImage.frame.size.width-46, timeLabel.frame.size.height)
            
            
            //print("displaydate is \(displaydate)")
            timeLabel.text=displaydate
            //timeLabel.text=date2.debugDescription
            
            
            
        }
        if (msgType?.isEqual(to: "23"))!{
            cell=tableView.dequeueReusableCell(withIdentifier: "ChatSentCell11")
            if(cell==nil)
            {
                cell = tblForChats.dequeueReusableCell(withIdentifier: "ChatSentCell11")! as UITableViewCell
            }
            let deliveredLabel = cell.viewWithTag(13) as! UILabel
            var textLable = cell.viewWithTag(12) as! ActiveLabel
            let timeLabel = cell.viewWithTag(11) as! UILabel
            let chatImage = cell.viewWithTag(1) as! UIImageView
            let profileImage = cell.viewWithTag(2) as! UIImageView
            let urlView = cell.viewWithTag(22)
            
            
            var title=urlView?.viewWithTag(19) as! UILabel
            var desc=urlView?.viewWithTag(20) as! ActiveLabel
            var urllbl=urlView?.viewWithTag(21) as! UILabel
            var activityIndicator=urlView?.viewWithTag(24) as! UIActivityIndicatorView
            
            
            
            //title.isHidden=true
            //desc.isHidden=true
            urllbl.isHidden=false
            activityIndicator.stopAnimating()
            
            
            /*  let documentDirectory = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first as String!
             let photoURL          = NSURL(fileURLWithPath: documentDirectory)
             let imgPath         = photoURL.URLByAppendingPathComponent(self.filename)
             var imgNSData=NSFileManager.default.contents(atPath:imgPath.path!)
             if(imgNSData != nil)
             {
             chatImage.image = UIImage(data: imgNSData!)
             chatImage.contentMode = .ScaleAspectFit
             }
             */
            //// //print("here 905 msgtype is \(msgType)")
            //// //print("distanceFactor for \(msg) is \(distanceFactor)")
            
            
            ////    //print("chatImage.x for \(msg) is \(20 + distanceFactor) and chatimage.wdith is \(chatImage.frame.width)")
            
            // let range=(textLable.text as! NSString).range(of: "www.iba.edu.pk")
            //let range = nsString.rangeOfString(name)
            //let url = NSURL(string: "www.iba.edu.pk")!
            ////(textLable.text as! NSString).addLinkToURL(url, withRange: range)
            
            //textLable = ActiveLabel()
            textLable.text = msg! as! String
            textLable.numberOfLines = 0
            textLable.enabledTypes = [.mention, .hashtag, .url]
            // textLable.text = "This is a post with #hashtags and a @userhandle."
            textLable.textColor = .black
            textLable.handleHashtagTap { hashtag in
                print("Success. You just tapped the \(hashtag) hashtag")
            }
            textLable.handleURLTap({ (url) in
                print("Success. You just tapped the \(url) url")
                var stringURL="\(url)!"
                if !(stringURL.contains("http")) {
                    stringURL = "http://" + stringURL
                }
                
                var res=UIApplication.shared.openURL(NSURL.init(string: stringURL) as! URL)
                print("open url \(res)")
            })
            urlView?.isHidden=false
            textLable.isHidden=false
            title.isHidden=false
            desc.isHidden=false
            urllbl.isHidden=false
            
            /*textLable.lineBreakMode = .ByWordWrapping
             textLable.numberOfLines=0
             textLable.sizeToFit()
             print("previous height is \(textLable.frame.height) msg is \(msg)")
             var correctheight=textLable.frame.height
             */
            let correctheight=getSizeOfStringHeight(msg!).height
            
            
            var urlArray=UtilityFunctions.init().getURLs(text: msg! as String!)
            
            print("messageDic url 11  i \(messageDic)")
            //if(messageDic["title"] != nil)
            //{
            print("detected URL")
            
            title.text=messageDic["title"] as! String!
            desc.text=messageDic["description"] as! String!
            urllbl.text=messageDic["url"]! as! String!
            
            var sizeOFStrDesc = self.getSizeOfString(messageDic["description"]! as! NSString)
            var temp=sizeOFStr
            /*if(sizeOFStrDesc.height>sizeOFStr.height)
             {
             sizeOFStr=sizeOFStrDesc
             }
             else{
             sizeOFStr=temp+
             }*/
            
            //!!let distanceFactor = (197.0 - sizeOFStr.width) < 107 ? (197.0 - sizeOFStr.width) : 107
            
            desc.numberOfLines = 0
            desc.enabledTypes = [.mention, .hashtag, .url]
            desc.lineBreakMode = .byWordWrapping
            // textLable.text = "This is a post with #hashtags and a @userhandle."
            desc.textColor = .black
            desc.handleHashtagTap { hashtag in
                print("Success. You just tapped the \(hashtag) hashtag")
            }
            desc.handleURLTap({ (url) in
                print("Success. You just tapped the \(url) url")
                var stringURL="\(url)"
                if !(stringURL.contains("http")) {
                    stringURL = "http://" + stringURL
                }
                
                var res=UIApplication.shared.openURL(NSURL.init(string: stringURL) as! URL)
                print("open url \(res)")
            })
            
            //!!let correctheightViewDesc=getSizeOfStringHeight(messageDic["description"] as! NSString).height
            
            /*}
             else
             {
             let slp = SwiftLinkPreview()
             slp.preview(
             msg! as String!,
             onSuccess: { result in
             
             self.hasURL=true
             print("url result in retrieve is \(result)")
             sqliteDB.SaveURLData(UtilityFunctions.init().generateUniqueid(),title1:result[.title] as! String,desc1:result[SwiftLinkResponseKey.description] as! String,url1:"\(result[SwiftLinkResponseKey.url])",msg1:msg! as String!,image1:nil//Data.init(base64Encoded:result[SwiftLinkResponseKey.image] as! String)!
             )
             
             //  let embeddedView = URLEmbeddedView()
             // embeddedView.loadURL(sender.text!)
             print("title \(result[.title] as! String)")
             messageDic["title"]=result[.title] as! String
             messageDic["description"]=result[SwiftLinkResponseKey.description] as! String
             messageDic["url"]="\(result[SwiftLinkResponseKey.url]!)"
             messageDic["image"]=result[SwiftLinkResponseKey.image] as! String
             
             
             self.tblForChats.beginUpdates()
             //self.tblForChats.reloadRows(at: [indexp], with: UITableViewRowAnimation.bottom)
             self.urlTitle=result[.title] as! String
             self.urlDesc=result[SwiftLinkResponseKey.description] as! String
             //self.urlURL=result[SwiftLinkResponseKey.url] as! String
             var urlURLimage=result[SwiftLinkResponseKey.image] as! String
             
             title.isHidden=false
             desc.isHidden=false
             urllbl.isHidden=false
             activityIndicator.stopAnimating()
             
             
             
             title.text=result[.title] as! String
             desc.text=result[SwiftLinkResponseKey.description] as! String
             urllbl.text="\(result[SwiftLinkResponseKey.url]!)"
             
             
             self.tblForChats.endUpdates()
             //Chat.SwiftLinkResponseKey.description
             //Chat.SwiftLinkResponseKey.images
             //Chat.SwiftLinkResponseKey.title
             //Chat.SwiftLinkResponseKey.url
             //
             /// self.messages.add(["message":tblContacts[msg]+" (\(tblContacts[status])) ","status":tblContacts[status], "type":"2", "date":defaultTimeeee, "uniqueid":tblContacts[uniqueid],"title":result[.title] as! String,"description":result[SwiftLinkResponseKey.description] as! String,"url":"\(result[.url]!)"])
             
             
             // var urlinfoObject=sqliteDBgetSingleURLInfo(url1:"\(result[SwiftLinkResponseKey.url])")
             
             
             
             
             
             },
             onError: { error in
             ///self.messages.add(["message":tblContacts[msg]+" (\(tblContacts[status])) ","status":tblContacts[status], "type":"2", "date":defaultTimeeee, "uniqueid":tblContacts[uniqueid]])
             print("error: in url is \(error)")
             desc.isHidden=false
             desc.text="Unable to load data"
             activityIndicator.stopAnimating()
             
             
             }
             
             )
             }*/
            
            
            /*if(messageDic["title"] != nil)
             {print("detected URL")
             title.text=messageDic["title"] as? String!
             desc.text=messageDic["description"] as? String!
             urllbl.text=messageDic["url"] as? String!
             
             }*/
            
            
            
            //!!urlView?.frame = CGRect(x: 25 + distanceFactor, y: (urlView?.frame.origin.y)!, width:  ((sizeOFStrDesc.width + 107+30)  > 207 ? (sizeOFStrDesc.width + 107-40) : 200-40), height: correctheightViewDesc + 30/*(urlView?.frame.height)!*/)
            
            
            // urlView?.frame = CGRect(x: 20 + distanceFactor, y: (urlView?.frame.origin.y)!, width: (urlView?.frame.width)!, height: 0)
            //urlView?.isHidden=true
            
            //chatImage.frame = CGRect(x: 20 + distanceFactor, y: chatImage.frame.origin.y, width: ((sizeOFStr.width + 107)  > 207 ? (sizeOFStr.width + 107) : 200), height: correctheight + (urlView?.frame.height)! + 20)
            
            /////==--chatImage.frame = CGRect(x: 20 + distanceFactor, y: ((urlView?.frame.origin.y)!-5), width: ((urlView?.frame.width)!  > 207 ? (sizeOFStr.width + 107) : 200), height: correctheight + (urlView?.frame.height)! + 20+10)
            
            //!!chatImage.frame = CGRect(x: 20 + distanceFactor, y: ((urlView?.frame.origin.y)!-5), width: (urlView?.frame.width)!+40 , height: correctheight + (urlView?.frame.height)! + 20+10)
            
            //==== newwww chatImage.frame = CGRectMake(20 + distanceFactor, chatImage.frame.origin.y, ((sizeOFStr.width + 107)  > 207 ? (sizeOFStr.width + 107) : 200), sizeOFStr.height + 40)
            //chatImage.frame = CGRectMake(20 + distanceFactor, chatImage.frame.origin.y, ((sizeOFStr.width + 100)  > 200 ? (sizeOFStr.width + 100) : 200), sizeOFStr.height + 40)
            //!!chatImage.image = UIImage(named: "chat_send")?.stretchableImage(withLeftCapWidth: 40,topCapHeight: 20);
            //*********
            
            //getSizeOfStringHeight(msg).height
            //desc
            
            // urllbl
            //!!urllbl.frame = CGRect(x: urllbl.frame.origin.x, y: (urlView?.frame.height)!-20, width: (urllbl.frame.width), height: urllbl.frame.height)
            
            //!!desc.frame = CGRect(x: desc.frame.origin.x, y: desc.frame.origin.y, width: (urlView?.frame.width)!, height: correctheightViewDesc)
            
            
            //!!textLable.frame = CGRect(x: 26 + distanceFactor, y: textLable.frame.origin.y, width: chatImage.frame.width-36, height: correctheight)
            
            
            // newwwwwwwwww textLable.frame = CGRectMake(26 + distanceFactor, textLable.frame.origin.y, chatImage.frame.width-36, getSizeOfStringHeight(msg).height)
            //  print("new height is \(textLable.frame.height) msg is \(msg)")
            //=====newwwwwww  textLable.frame = CGRectMake(26 + distanceFactor, textLable.frame.origin.y, chatImage.frame.width-36, sizeOFStr.height)
            //==== new textLable.frame = CGRectMake(36 + distanceFactor, textLable.frame.origin.y, textLable.frame.size.width, sizeOFStr.height)
            ///  //print("textLable.x for \(msg) is \(textLable.frame.origin.x) and textLable.width is \(textLable.frame.width)")
            
            ////profileImage.center = CGPointMake(profileImage.center.x, textLable.frame.origin.y + textLable.frame.size.height - profileImage.frame.size.height/2 + 10)
            
            //!!profileImage.center = CGPoint(x: profileImage.center.x, y: textLable.frame.origin.y + textLable.frame.size.height - profileImage.frame.size.height/2+10)
            
            //==uncomment if needed timeLabel.frame = CGRectMake(36 + distanceFactor, timeLabel.frame.origin.y, timeLabel.frame.size.width, timeLabel.frame.size.height)
            
            //!!timeLabel.frame = CGRect(x: 36 + distanceFactor, y: textLable.frame.origin.y+textLable.frame.height, width: chatImage.frame.size.width-46, height: timeLabel.frame.size.height)
            
            //!!deliveredLabel.frame = CGRect(x: deliveredLabel.frame.origin.x, y: textLable.frame.origin.y + textLable.frame.size.height + 15, width: deliveredLabel.frame.size.width, height: deliveredLabel.frame.size.height)
            
            
            
            
            //print("date received in chat post 2 is \(date2.debugDescription)")
            // //print("date received in chat is \(date2.debugDescription)")
            let formatter = DateFormatter();
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS";
            //formatter.dateFormat = "MM/dd hh:mm a";
            formatter.timeZone = TimeZone.autoupdatingCurrent
            let defaultTimeZoneStr = formatter.date(from: date2 as! String)
            //print("defaultTimeZoneStr \(defaultTimeZoneStr)")
            
            if(defaultTimeZoneStr == nil)
            {
                timeLabel.text=date2 as! String
                
            }
            else
            {
                let formatter2 = DateFormatter();
                formatter2.timeZone=TimeZone.autoupdatingCurrent
                formatter2.dateFormat = "MM/dd hh:mm a";
                let displaydate=formatter2.string(from: defaultTimeZoneStr!)
                //formatter.dateFormat = "MM/dd hh:mm a";
                
                timeLabel.text=displaydate
            }
            
            //local date already shortened then added to dictionary when post button is pressed
            //timeLabel.text=date2.debugDescription
        }
        if (msgType?.isEqual(to: "22"))!{
            cell=tableView.dequeueReusableCell(withIdentifier: "ChatReceivedCell22")
            
            if(cell==nil)
            {
            cell = tblForChats.dequeueReusableCell(withIdentifier: "ChatReceivedCell22")! as UITableViewCell
            }
            
            let deliveredLabel = cell.viewWithTag(13) as! UILabel
            var textLable = cell.viewWithTag(12) as! ActiveLabel
            let timeLabel = cell.viewWithTag(11) as! UILabel
            let chatImage = cell.viewWithTag(1) as! UIImageView
            let profileImage = cell.viewWithTag(2) as! UIImageView
            let urlView = cell.viewWithTag(22)
            
            
            var title=urlView?.viewWithTag(19) as! UILabel
            var desc=urlView?.viewWithTag(20) as! ActiveLabel
            var urllbl=urlView?.viewWithTag(21) as! UILabel
            var activityIndicator=urlView?.viewWithTag(24) as! UIActivityIndicatorView
            

            
            //title.isHidden=true
            //desc.isHidden=true
            urllbl.isHidden=false
            activityIndicator.stopAnimating()

            
            /*  let documentDirectory = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first as String!
             let photoURL          = NSURL(fileURLWithPath: documentDirectory)
             let imgPath         = photoURL.URLByAppendingPathComponent(self.filename)
             var imgNSData=NSFileManager.default.contents(atPath:imgPath.path!)
             if(imgNSData != nil)
             {
             chatImage.image = UIImage(data: imgNSData!)
             chatImage.contentMode = .ScaleAspectFit
             }
             */
           //// //print("here 905 msgtype is \(msgType)")
           //// //print("distanceFactor for \(msg) is \(distanceFactor)")
            
           
         ////    //print("chatImage.x for \(msg) is \(20 + distanceFactor) and chatimage.wdith is \(chatImage.frame.width)")
            
        // let range=(textLable.text as! NSString).range(of: "www.iba.edu.pk")
            //let range = nsString.rangeOfString(name)
            //let url = NSURL(string: "www.iba.edu.pk")!
            ////(textLable.text as! NSString).addLinkToURL(url, withRange: range)
            
            //textLable = ActiveLabel()
            textLable.text = msg! as! String
            textLable.numberOfLines = 0
            textLable.enabledTypes = [.mention, .hashtag, .url]
           // textLable.text = "This is a post with #hashtags and a @userhandle."
            textLable.textColor = .black
            textLable.handleHashtagTap { hashtag in
                print("Success. You just tapped the \(hashtag) hashtag")
            }
            textLable.handleURLTap({ (url) in
                 print("Success. You just tapped the \(url) url")
                var stringURL="\(url)!"
                if !(stringURL.contains("http")) {
                    stringURL = "http://" + stringURL
                }
                
                var res=UIApplication.shared.openURL(NSURL.init(string: stringURL) as! URL)
                print("open url \(res)")
            })
            urlView?.isHidden=false
            textLable.isHidden=false
            title.isHidden=false
            desc.isHidden=false
            urllbl.isHidden=false
            
            /*textLable.lineBreakMode = .ByWordWrapping
            textLable.numberOfLines=0
            textLable.sizeToFit()
            print("previous height is \(textLable.frame.height) msg is \(msg)")
            var correctheight=textLable.frame.height
            */
            let correctheight=getSizeOfStringHeight(msg!).height
            
            
            var urlArray=UtilityFunctions.init().getURLs(text: msg! as String!)
            
            print("messageDic url 22 i \(messageDic)")
            //if(messageDic["title"] != nil)
            //{
                print("detected URL")
                
                title.text=messageDic["title"] as! String!
                desc.text=messageDic["description"] as! String!
                urllbl.text=messageDic["url"]! as! String!
            
            var sizeOFStrDesc = self.getSizeOfString(messageDic["description"]! as! NSString)
            var temp=sizeOFStr
            /*if(sizeOFStrDesc.height>sizeOFStr.height)
            {
               sizeOFStr=sizeOFStrDesc
            }
            else{
                sizeOFStr=temp+
            }*/
            
            //!!let distanceFactor = (197.0 - sizeOFStr.width) < 107 ? (197.0 - sizeOFStr.width) : 107
            
            desc.numberOfLines = 0
            desc.enabledTypes = [.mention, .hashtag, .url]
            desc.lineBreakMode = .byWordWrapping
            // textLable.text = "This is a post with #hashtags and a @userhandle."
            desc.textColor = .black
            desc.handleHashtagTap { hashtag in
                print("Success. You just tapped the \(hashtag) hashtag")
            }
            desc.handleURLTap({ (url) in
                print("Success. You just tapped the \(url) url")
                var stringURL="\(url)"
                if !(stringURL.contains("http")) {
                    stringURL = "http://" + stringURL
                }
                
                var res=UIApplication.shared.openURL(NSURL.init(string: stringURL) as! URL)
                print("open url \(res)")
            })
            
            //!!let correctheightViewDesc=getSizeOfStringHeight(messageDic["description"] as! NSString).height
                
            /*}
            else
            {
            let slp = SwiftLinkPreview()
            slp.preview(
                msg! as String!,
                onSuccess: { result in
                    
                    self.hasURL=true
                    print("url result in retrieve is \(result)")
                    sqliteDB.SaveURLData(UtilityFunctions.init().generateUniqueid(),title1:result[.title] as! String,desc1:result[SwiftLinkResponseKey.description] as! String,url1:"\(result[SwiftLinkResponseKey.url])",msg1:msg! as String!,image1:nil//Data.init(base64Encoded:result[SwiftLinkResponseKey.image] as! String)!
                    )
                    
                    //  let embeddedView = URLEmbeddedView()
                    // embeddedView.loadURL(sender.text!)
                    print("title \(result[.title] as! String)")
                    messageDic["title"]=result[.title] as! String
                    messageDic["description"]=result[SwiftLinkResponseKey.description] as! String
                    messageDic["url"]="\(result[SwiftLinkResponseKey.url]!)"
                    messageDic["image"]=result[SwiftLinkResponseKey.image] as! String

                    
                    self.tblForChats.beginUpdates()
                    //self.tblForChats.reloadRows(at: [indexp], with: UITableViewRowAnimation.bottom)
                    self.urlTitle=result[.title] as! String
                    self.urlDesc=result[SwiftLinkResponseKey.description] as! String
                    //self.urlURL=result[SwiftLinkResponseKey.url] as! String
                    var urlURLimage=result[SwiftLinkResponseKey.image] as! String
                    
                    title.isHidden=false
                    desc.isHidden=false
                    urllbl.isHidden=false
                    activityIndicator.stopAnimating()

                    
                    
                    title.text=result[.title] as! String
                    desc.text=result[SwiftLinkResponseKey.description] as! String
                    urllbl.text="\(result[SwiftLinkResponseKey.url]!)"

                    
                     self.tblForChats.endUpdates()
                    //Chat.SwiftLinkResponseKey.description
                    //Chat.SwiftLinkResponseKey.images
                    //Chat.SwiftLinkResponseKey.title
                    //Chat.SwiftLinkResponseKey.url
                    //
                   /// self.messages.add(["message":tblContacts[msg]+" (\(tblContacts[status])) ","status":tblContacts[status], "type":"2", "date":defaultTimeeee, "uniqueid":tblContacts[uniqueid],"title":result[.title] as! String,"description":result[SwiftLinkResponseKey.description] as! String,"url":"\(result[.url]!)"])
                    
                 
                   // var urlinfoObject=sqliteDBgetSingleURLInfo(url1:"\(result[SwiftLinkResponseKey.url])")
                    
                   
                
                    
                   
            },
                onError: { error in
                    ///self.messages.add(["message":tblContacts[msg]+" (\(tblContacts[status])) ","status":tblContacts[status], "type":"2", "date":defaultTimeeee, "uniqueid":tblContacts[uniqueid]])
                    print("error: in url is \(error)")
                    desc.isHidden=false
                    desc.text="Unable to load data"
                    activityIndicator.stopAnimating()

                    
            }
                
            )
        }*/
        
            
            /*if(messageDic["title"] != nil)
            {print("detected URL")
                 title.text=messageDic["title"] as? String!
                desc.text=messageDic["description"] as? String!
                urllbl.text=messageDic["url"] as? String!
                
            }*/
            
            
            
            //!!urlView?.frame = CGRect(x: 25 + distanceFactor, y: (urlView?.frame.origin.y)!, width:  ((sizeOFStrDesc.width + 107+30)  > 207 ? (sizeOFStrDesc.width + 107-40) : 200-40), height: correctheightViewDesc + 30/*(urlView?.frame.height)!*/)
           
            
            // urlView?.frame = CGRect(x: 20 + distanceFactor, y: (urlView?.frame.origin.y)!, width: (urlView?.frame.width)!, height: 0)
            //urlView?.isHidden=true
            
            //chatImage.frame = CGRect(x: 20 + distanceFactor, y: chatImage.frame.origin.y, width: ((sizeOFStr.width + 107)  > 207 ? (sizeOFStr.width + 107) : 200), height: correctheight + (urlView?.frame.height)! + 20)
            
            /////==--chatImage.frame = CGRect(x: 20 + distanceFactor, y: ((urlView?.frame.origin.y)!-5), width: ((urlView?.frame.width)!  > 207 ? (sizeOFStr.width + 107) : 200), height: correctheight + (urlView?.frame.height)! + 20+10)
            
            //!!chatImage.frame = CGRect(x: 20 + distanceFactor, y: ((urlView?.frame.origin.y)!-5), width: (urlView?.frame.width)!+40 , height: correctheight + (urlView?.frame.height)! + 20+10)
            
           //==== newwww chatImage.frame = CGRectMake(20 + distanceFactor, chatImage.frame.origin.y, ((sizeOFStr.width + 107)  > 207 ? (sizeOFStr.width + 107) : 200), sizeOFStr.height + 40)
            //chatImage.frame = CGRectMake(20 + distanceFactor, chatImage.frame.origin.y, ((sizeOFStr.width + 100)  > 200 ? (sizeOFStr.width + 100) : 200), sizeOFStr.height + 40)
            //!!chatImage.image = UIImage(named: "chat_send")?.stretchableImage(withLeftCapWidth: 40,topCapHeight: 20);
            //*********
           
            //getSizeOfStringHeight(msg).height
            //desc
            
           // urllbl
            //!!urllbl.frame = CGRect(x: urllbl.frame.origin.x, y: (urlView?.frame.height)!-20, width: (urllbl.frame.width), height: urllbl.frame.height)
            
            //!!desc.frame = CGRect(x: desc.frame.origin.x, y: desc.frame.origin.y, width: (urlView?.frame.width)!, height: correctheightViewDesc)
            
            
           //!!textLable.frame = CGRect(x: 26 + distanceFactor, y: textLable.frame.origin.y, width: chatImage.frame.width-36, height: correctheight)
            
            
           // newwwwwwwwww textLable.frame = CGRectMake(26 + distanceFactor, textLable.frame.origin.y, chatImage.frame.width-36, getSizeOfStringHeight(msg).height)
          //  print("new height is \(textLable.frame.height) msg is \(msg)")
           //=====newwwwwww  textLable.frame = CGRectMake(26 + distanceFactor, textLable.frame.origin.y, chatImage.frame.width-36, sizeOFStr.height)
             //==== new textLable.frame = CGRectMake(36 + distanceFactor, textLable.frame.origin.y, textLable.frame.size.width, sizeOFStr.height)
          ///  //print("textLable.x for \(msg) is \(textLable.frame.origin.x) and textLable.width is \(textLable.frame.width)")
            
            ////profileImage.center = CGPointMake(profileImage.center.x, textLable.frame.origin.y + textLable.frame.size.height - profileImage.frame.size.height/2 + 10)
            
            //!!profileImage.center = CGPoint(x: profileImage.center.x, y: textLable.frame.origin.y + textLable.frame.size.height - profileImage.frame.size.height/2+10)
            
            //==uncomment if needed timeLabel.frame = CGRectMake(36 + distanceFactor, timeLabel.frame.origin.y, timeLabel.frame.size.width, timeLabel.frame.size.height)
            
            //!!timeLabel.frame = CGRect(x: 36 + distanceFactor, y: textLable.frame.origin.y+textLable.frame.height, width: chatImage.frame.size.width-46, height: timeLabel.frame.size.height)
                
            //!!deliveredLabel.frame = CGRect(x: deliveredLabel.frame.origin.x, y: textLable.frame.origin.y + textLable.frame.size.height + 15, width: deliveredLabel.frame.size.width, height: deliveredLabel.frame.size.height)
            
            
            
            
            //print("date received in chat post 2 is \(date2.debugDescription)")
           // //print("date received in chat is \(date2.debugDescription)")
            let formatter = DateFormatter();
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS";
            //formatter.dateFormat = "MM/dd hh:mm a";
            formatter.timeZone = TimeZone.autoupdatingCurrent
            let defaultTimeZoneStr = formatter.date(from: date2 as! String)
            //print("defaultTimeZoneStr \(defaultTimeZoneStr)")
            
            if(defaultTimeZoneStr == nil)
            {
                timeLabel.text=date2 as! String

            }
            else
            {
            let formatter2 = DateFormatter();
            formatter2.timeZone=TimeZone.autoupdatingCurrent
            formatter2.dateFormat = "MM/dd hh:mm a";
            let displaydate=formatter2.string(from: defaultTimeZoneStr!)
            //formatter.dateFormat = "MM/dd hh:mm a";
            
            timeLabel.text=displaydate
            }
            
            //local date already shortened then added to dictionary when post button is pressed
           //timeLabel.text=date2.debugDescription
        }
        if (msgType?.isEqual(to: "2"))!{
            cell=tableView.dequeueReusableCell(withIdentifier: "ChatReceivedCell")
            if(cell==nil)
            {
                cell = tblForChats.dequeueReusableCell(withIdentifier: "ChatReceivedCell")! as UITableViewCell
            }
            let deliveredLabel = cell.viewWithTag(13) as! UILabel
            let textLable = cell.viewWithTag(12) as! ActiveLabel
            let timeLabel = cell.viewWithTag(11) as! UILabel
            let chatImage = cell.viewWithTag(1) as! UIImageView
            let profileImage = cell.viewWithTag(2) as! UIImageView
         
            
            ////!!let distanceFactor = (197.0 - sizeOFStr.width) < 107 ? (197.0 - sizeOFStr.width) : 107;
            textLable.isHidden=false
            textLable.text = msg! as! String
            ////textLable.numberOfLines = 0
            textLable.enabledTypes = [.mention, .hashtag, .url]
            // textLable.text = "This is a post with #hashtags and a @userhandle."
            textLable.textColor = .black
            textLable.handleHashtagTap { hashtag in
                print("Success. You just tapped the \(hashtag) hashtag")
            }
            textLable.handleURLTap({ (url) in
                print("Success. You just tapped the \(url) url")
                var stringURL="\(url)"
                if !(stringURL.contains("http")) {
                    stringURL = "http://" + stringURL
                }
                
                var res=UIApplication.shared.openURL(NSURL.init(string: stringURL) as! URL)
                print("open url \(res)")
            })
            print("message is \(textLable.text!)")
            print("url encode is \(textLable.text?.urlEncode())  and isvalidurl  \(textLable.text?.isValidURL())")
            
            if(textLable.text!.isValidURL() == true)
            {
                //update database and fetch metadata in background
                if !(textLable.text!.contains("http")) {
                    textLable.text! = "http://" + textLable.text!
                }
                
                    let slp = SwiftLinkPreview()
                    slp.preview(
                        textLable.text! as String!,
                        onSuccess: { result in
                            
                            self.hasURL=true
                            var description="-"
                            if let desc=result[SwiftLinkResponseKey.description]
                            {
                               description=desc as! String
                            }
                            print("url result in retrieve is \(result)")
                            sqliteDB.SaveURLData(uniqueidDictValue! as! String,title1:result[.title] as! String,desc1:description/*result[SwiftLinkResponseKey.description] as! String*/,url1:"\(result[SwiftLinkResponseKey.url]!)",msg1:msg! as String!,image1:nil//Data.init(base64Encoded:result[SwiftLinkResponseKey.image] as! String)!
                            )
                            
                            sqliteDB.UpdateChat(uniqueidDictValue! as! String, type1: "link")
                            
                            //  let embeddedView = URLEmbeddedView()
                            // embeddedView.loadURL(sender.text!)
                           

                            
                            
                            
                            print("title \(result[.title] as! String)")
                            messageDic["title"]=result[.title] as! String
                            messageDic["description"]=description
                                //result[SwiftLinkResponseKey.description] as! String
                            messageDic["url"]="\(result[SwiftLinkResponseKey.url]!)!"
                            messageDic["image"]=result[SwiftLinkResponseKey.image] as! String
                            
                            
                            var messageDicSingle = self.messages.object(at: indexPath.row) as! [String : String];
                            let msgType = messageDicSingle["type"] as String!
                            let msg = messageDicSingle["message"] as String!
                            let date2=messageDicSingle["date"] as String!
                            var sizeOFStr = self.getSizeOfString(msg! as! NSString)
                            let uniqueidDictValue=messageDicSingle["uniqueid"] as String!
                            let status=messageDicSingle["status"] as String!
                            
                            
                            
                            var messages2=["message":msg!/*+" (\(status)) "*/,"status":status, "type":"22", "date":date2, "uniqueid":uniqueidDictValue,"title":result[.title] as! String,"description":description,"url":"\(result[SwiftLinkResponseKey.url]!)!"]
                            
                            self.messages.replaceObject(at: indexPath.row, with: messages2)
                            //NSLog(messageDic["message"]!, 1)
                            
                            //self.tblForChats.reloadRows(at: [indexp], with: UITableViewRowAnimation.bottom)
                            self.urlTitle=result[.title] as! String
                            self.urlDesc=description
                            //self.urlURL=result[SwiftLinkResponseKey.url] as! String
                            var urlURLimage=result[SwiftLinkResponseKey.image] as! String
                            
                           /* title.isHidden=false
                            desc.isHidden=false
                            urllbl.isHidden=false
                            activityIndicator.stopAnimating()
                            
                            
                            
                            title.text=result[.title] as! String
                            desc.text=result[SwiftLinkResponseKey.description] as! String
                            urllbl.text="\(result[SwiftLinkResponseKey.url]!)"
                            */
                            self.tblForChats.beginUpdates()
                            //var indexp=IndexPath(row:indexP, section:0)
                            self.tblForChats.reloadRows(at: [indexPath], with: UITableViewRowAnimation.none)
                            self.tblForChats.endUpdates()
                            //Chat.SwiftLinkResponseKey.description
                            //Chat.SwiftLinkResponseKey.images
                            //Chat.SwiftLinkResponseKey.title
                            //Chat.SwiftLinkResponseKey.url
                            //
                            /// self.messages.add(["message":tblContacts[msg]+" (\(tblContacts[status])) ","status":tblContacts[status], "type":"2", "date":defaultTimeeee, "uniqueid":tblContacts[uniqueid],"title":result[.title] as! String,"description":result[SwiftLinkResponseKey.description] as! String,"url":"\(result[.url]!)"])
                            
                            
                            // var urlinfoObject=sqliteDBgetSingleURLInfo(url1:"\(result[SwiftLinkResponseKey.url])")
                            
                            
                            
                            
                            
                    },
                        onError: { error in
                            ///self.messages.add(["message":tblContacts[msg]+" (\(tblContacts[status])) ","status":tblContacts[status], "type":"2", "date":defaultTimeeee, "uniqueid":tblContacts[uniqueid]])
                            print("error: in url is \(error)")
                           /* desc.isHidden=false
                            desc.text="Unable to load data"
                            activityIndicator.stopAnimating()*/
                            
                            
                    }
                        
                    )
                }
                
         
            let correctheight=getSizeOfStringHeight(msg!).height
            
            ////!!chatImage.frame = CGRect(x: 20 + distanceFactor, y: chatImage.frame.origin.y, width: ((sizeOFStr.width + 107)  > 207 ? (sizeOFStr.width + 107) : 200), height: correctheight + 20)
            
              ////!!  chatImage.image = UIImage(named: "chat_send")?.stretchableImage(withLeftCapWidth: 40,topCapHeight: 20);
            //*********
            
            //getSizeOfStringHeight(msg).height
            
            //!!textLable.frame = CGRect(x: 26 + distanceFactor, y: textLable.frame.origin.y, width: chatImage.frame.width-36, height: correctheight)
            
            //!!profileImage.center = CGPoint(x: profileImage.center.x, y: textLable.frame.origin.y + textLable.frame.size.height - profileImage.frame.size.height/2+10)
            
            //!!timeLabel.frame = CGRect(x: 36 + distanceFactor, y: textLable.frame.origin.y+textLable.frame.height, width: chatImage.frame.size.width-46, height: timeLabel.frame.size.height)
            
           //!! deliveredLabel.frame = CGRect(x: deliveredLabel.frame.origin.x, y: textLable.frame.origin.y + textLable.frame.size.height + 15, width: deliveredLabel.frame.size.width, height: deliveredLabel.frame.size.height)
            
             let formatter = DateFormatter();
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS";
            //formatter.dateFormat = "MM/dd hh:mm a";
            formatter.timeZone = TimeZone.autoupdatingCurrent
            let defaultTimeZoneStr = formatter.date(from: date2 as! String)
            //print("defaultTimeZoneStr \(defaultTimeZoneStr)")
            
            if(defaultTimeZoneStr == nil)
            {
                timeLabel.text=date2 as! String
                
            }
            else
            {
                let formatter2 = DateFormatter();
                formatter2.timeZone=TimeZone.autoupdatingCurrent
                formatter2.dateFormat = "MM/dd hh:mm a";
                let displaydate=formatter2.string(from: defaultTimeZoneStr!)
                //formatter.dateFormat = "MM/dd hh:mm a";
                
                timeLabel.text=displaydate
            }
            
            //local date already shortened then added to dictionary when post button is pressed
            //timeLabel.text=date2.debugDescription
        }
        if (msgType?.isEqual(to: "3"))!
        
        {
            cell = ///tblForChats.dequeueReusableCellWithIdentifier("ChatReceivedCell")! as UITableViewCell
               
                //FileImageReceivedCell
                tblForChats.dequeueReusableCell(withIdentifier: "FileImageSentCell22")! as UITableViewCell
            
          //=== uncomment   cell.tag = indexPath.row
            let viewRect=cell.viewWithTag(1)! as UIView
            let chatImage = viewRect.viewWithTag(2) as! UIImageView
            let textLabel = viewRect.viewWithTag(3) as! UILabel
          
            
            /*
            let deliveredLabel = cell.viewWithTag(13) as! UILabel
            let textLable = cell.viewWithTag(12) as! UILabel
            let timeLabel = cell.viewWithTag(11) as! UILabel
            let chatImage = cell.viewWithTag(1) as! UIImageView
            let profileImage = cell.viewWithTag(2) as! UIImageView
            */
            
            let progressView = cell.viewWithTag(14) as! KDCircularProgress!
            
            //////chatImage.contentMode = .Center
            
            chatImage.image = nil
            //chatImage.frame = CGRectMake(80, chatImage.frame.origin.y, 220, 220)
            /*let documentDirectory = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first as String!
             let photoURL          = NSURL(fileURLWithPath: documentDirectory)
             let imgPath         = photoURL.URLByAppendingPathComponent(msg as! String)
             
             */
            let status=messageDic["status"] as! NSString
            
            let filename=messageDic["filename"] as! NSString
            var caption=messageDic["caption"] as! NSString
            
            let dirPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
            let docsDir1 = dirPaths[0]
            let documentDir=docsDir1 as NSString
            //==== --var imgPath=documentDir.appendingPathComponent(msg as! String)
            let imgPath=documentDir.appendingPathComponent(filename as! String)
            

            //filename
          //  print("uniqueid image is \(uniqueidDictValue) filename is \(filename) imgPath is \(imgPath) ")
            
            let imgNSData=FileManager.default.contents(atPath: imgPath)
            
       //===     print("imgNSData is \(imgNSData)")
            //var imgNSData=NSFileManager.default.contents(atPath:imgPath.path!)
            //print("hereee imgPath.path! is \(imgPath)")
            
            
            let formatter = DateFormatter();
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS";
            //formatter.dateFormat = "MM/dd hh:mm a";
            formatter.timeZone = TimeZone.autoupdatingCurrent
            let defaultTimeZoneStr = formatter.date(from: date2 as! String)
            //print("defaultTimeZoneStr \(defaultTimeZoneStr)")
            
            let formatter2 = DateFormatter();
            formatter2.timeZone=TimeZone.autoupdatingCurrent
            formatter2.dateFormat = "MM/dd hh:mm a";
            let displaydate=formatter2.string(from: defaultTimeZoneStr!)
            textLabel.isHidden=false
            chatImage.image=nil
            if(imgNSData != nil/* && (cell.tag == indexPath.row)*/)
            {
                chatImage.isUserInteractionEnabled = true
                var filesData=sqliteDB.getFilesData(uniqueidDictValue as! String)
                if(filesData["file_caption"] != nil)
                {
                caption=filesData["file_caption"] as! NSString
                }
                else{
                    caption=""
                }
                /*var predicate=NSPredicate(format: "uniqueid = %@", uniqueidDictValue)
                var resultArray=uploadInfo.filteredArrayUsingPredicate(predicate)
                if(resultArray.count>0)
                {
                    
                    
                    var uploadDone = resultArray.first!.valueForKey("isCompleted") as! Bool
                    if(uploadDone==false)
                    {
                        progressView.hidden=false
                    }
                    else
                    {
                        progressView.hidden=true

                    }
                    
                    // progressView.hidden=false
                    // //print("yes uploading predicate satisfiedd")
                  //  var bbb = resultArray.first!.valueForKey("uploadProgress") as! Float
                    
                    
                    /*//print("yes uploading predicate satisfiedd \(bbb)")
                    var newAngleValue=(bbb*360) as NSNumber
                    //print("\(progressView.angle) to newangle is \(newAngleValue.integerValue)")
                    if(progressView.angle<newAngleValue.integerValue)
                    {
                        progressView.animateFromAngle(progressView.angle, toAngle: newAngleValue.integerValue, duration: 0.5, completion: nil)
                    }*/
 
                    
                    
                    // progressView.animateToAngle(newAngleValue.integerValue, duration: 0.5, completion: nil)
                    //return true
                }
 
 */
                
                chatImage.image = UIImage(data: imgNSData!)!
                
                //now you need a tap gesture recognizer
                //note that target and action point to what happens when the action is recognized.
                let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(ChatDetailViewController.imageTapped(_:)))
                //Add the recognizer to your view.
                chatImage.addGestureRecognizer(tapRecognizer)
                
                
                chatImage.frame = CGRect(x: chatImage.frame.origin.x, y: chatImage.frame.origin.y, width: 200, height: 200)
                
                chatImage.image = UIImage(data: imgNSData!)!
                ///.stretchableImageWithLeftCapWidth(40,topCapHeight: 20);
                chatImage.contentMode = .scaleAspectFit
                //===== uncomment later chatImage.setNeedsDisplay()
                //print("file shownnnnnnnnn")
              //!!  textLable.isHidden=true
                
                textLabel.text=" \(caption) \(displaydate) (\(status))"

               //!! timeLabel.text="\(displaydate) (\(status))"
                //timeLabel.text=date2.debugDescription
            }
            
            textLabel.text="\(caption) \(displaydate) (\(status))"
            
            //!!timeLabel.text="\(caption) \(displaydate) (\(status))"
            /* var imgNSURL = NSURL(fileURLWithPath: msg as String)
             var imgNSData=NSFileManager.default.contents(atPath:imgNSURL.path!)
             if(imgNSData != nil)
             {
             chatImage.image = UIImage(contentsOfFile: msg as String)
             //print("file shownnnnnnnnn")
             }
             */
        }
        if (msgType?.isEqual(to: "4"))!
        {
            cell = ///tblForChats.dequeueReusableCellWithIdentifier("ChatReceivedCell")! as UITableViewCell
                
                //FileImageReceivedCell
                tblForChats.dequeueReusableCell(withIdentifier: "FileImageReceivedCell22")! as UITableViewCell
            
            //=====cell.tag = indexPath.row
            let viewRect=cell.viewWithTag(1)! as UIView
            let chatImage = viewRect.viewWithTag(2) as! UIImageView
            let textLabel = viewRect.viewWithTag(3) as! UILabel
            
           // let profileImage = cell.viewWithTag(2) as! UIImageView
            //let progressView = cell.viewWithTag(14) as! KDCircularProgress!
            
            //////chatImage.contentMode = .Center
            
            //chatImage.frame = CGRectMake(80, chatImage.frame.origin.y, 220, 220)
            /*let documentDirectory = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first as String!
             let photoURL          = NSURL(fileURLWithPath: documentDirectory)
             let imgPath         = photoURL.URLByAppendingPathComponent(msg as! String)
             
             */
            
            // var status=messageDic["status"] as! NSString
            
            let filename=messageDic["filename"] as! NSString
            let status=messageDic["status"] as! NSString
            var caption=messageDic["caption"] as! NSString

            //!!let status=(msg as! String).replacingOccurrences(of: filename as String, with: "", options: NSString.CompareOptions.literal, range: nil)
            
            let dirPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
            let docsDir1 = dirPaths[0]
            let documentDir=docsDir1 as NSString
            
            let imgPath=documentDir.appendingPathComponent(filename as String)
            //  print("uniqueid image is \(uniqueidDictValue) filename is \(filename) imgPath is \(imgPath)")
            
            let imgNSData=FileManager.default.contents(atPath: imgPath)
            
            //====     print("imgNSData is \(imgNSData)")
            
            //var imgNSData=NSFileManager.default.contents(atPath:imgPath.path!)
            //print("hereee imgPath.path! is \(imgPath)")
            
            //!!timeLabel.frame = CGRect(x: chatImage.frame.origin.x, y: chatImage.frame.origin.y+180, width: chatImage.frame.width,  height: timeLabel.frame.height)
            
            
            let formatter = DateFormatter();
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS";
            //formatter.dateFormat = "MM/dd hh:mm a";
            formatter.timeZone = TimeZone.autoupdatingCurrent
            let defaultTimeZoneStr = formatter.date(from: date2 as! String)
            //print("defaultTimeZoneStr \(defaultTimeZoneStr)")
            
            let formatter2 = DateFormatter();
            formatter2.timeZone=TimeZone.autoupdatingCurrent
            formatter2.dateFormat = "MM/dd hh:mm a";
            let displaydate=formatter2.string(from: defaultTimeZoneStr!)
            
            if(imgNSData != nil /*&& (cell.tag == indexPath.row)*/)
            {
                chatImage.isUserInteractionEnabled = true
                var filesData=sqliteDB.getFilesData(uniqueidDictValue as! String)
                caption=filesData["file_caption"] as! NSString
                //now you need a tap gesture recognizer
                //note that target and action point to what happens when the action is recognized.
                let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(ChatDetailViewController.imageTapped(_:)))
                //Add the recognizer to your view.
                
                
                let predicate=NSPredicate(format: "uniqueid = %@", uniqueidDictValue!)
                let resultArray=uploadInfo.filtered(using: predicate)
                if(resultArray.count>0)
                {
                    
                    //!!
                   /* let uploadDone = (resultArray.first! as AnyObject).value(forKey: "isCompleted") as! Bool
                    if(uploadDone==false)
                    {
                        progressView?.isHidden=false
                    }
                    else
                    {
                        progressView?.isHidden=true
                        
                    }*/
                    
                }
                /*var predicate=NSPredicate(format: "uniqueid = %@", uniqueidDictValue)
                 var resultArray=uploadInfo.filteredArrayUsingPredicate(predicate)
                 if(resultArray.count>0)
                 {
                 // progressView.hidden=false
                 // //print("yes uploading predicate satisfiedd")
                 var bbb = resultArray.first!.valueForKey("uploadProgress") as! Float
                 //print("yes uploading predicate satisfiedd \(bbb)")
                 var newAngleValue=(bbb*360) as NSNumber
                 //print("\(progressView.angle) to newangle is \(newAngleValue.integerValue)")
                 if(progressView.angle<newAngleValue.integerValue)
                 {
                 progressView.animateFromAngle(progressView.angle, toAngle: newAngleValue.integerValue, duration: 0.5, completion: nil)
                 }
                 
                 
                 // progressView.animateToAngle(newAngleValue.integerValue, duration: 0.5, completion: nil)
                 //return true
                 }
                 */
                chatImage.addGestureRecognizer(tapRecognizer)
                
                
              chatImage.frame = CGRect(x: chatImage.frame.origin.x, y: chatImage.frame.origin.y, width: 218, height: 200)
                
                chatImage.image = UIImage(data: imgNSData!)!
                ///.stretchableImageWithLeftCapWidth(40,topCapHeight: 20);
                chatImage.contentMode = .scaleAspectFit
                //======= uncomment later chatImage.setNeedsDisplay()
                //print("file shownnnnnnnnn")
                //!!textLable.isHidden=true
                
                
                //print("date received in chat is \(date2.debugDescription)")
                print("image status is \(status)")
                textLabel.text="\(caption) \(displaydate) (\(status))"
                // timeLabel.text=date2.debugDescription
            }
            textLabel.text="\(caption) \(displaydate) (\(status))"
            
            /* var imgNSURL = NSURL(fileURLWithPath: msg as String)
             var imgNSData=NSFileManager.default.contents(atPath:imgNSURL.path!)
             if(imgNSData != nil)
             {
             chatImage.image = UIImage(contentsOfFile: msg as String)
             //print("file shownnnnnnnnn")
             }
             */
        }
        
        /*{
            cell = ///tblForChats.dequeueReusableCellWithIdentifier("ChatReceivedCell")! as UITableViewCell
                
                //FileImageReceivedCell
                tblForChats.dequeueReusableCell(withIdentifier: "FileImageReceivedCell")! as UITableViewCell
            
             //=====cell.tag = indexPath.row
            
            let deliveredLabel = cell.viewWithTag(13) as! UILabel
            let textLable = cell.viewWithTag(12) as! UILabel
            let timeLabel = cell.viewWithTag(11) as! UILabel
            let chatImage = cell.viewWithTag(1) as! UIImageView
            let profileImage = cell.viewWithTag(2) as! UIImageView
            let progressView = cell.viewWithTag(14) as! KDCircularProgress!
            
            //////chatImage.contentMode = .Center
            
            //chatImage.frame = CGRectMake(80, chatImage.frame.origin.y, 220, 220)
            /*let documentDirectory = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first as String!
             let photoURL          = NSURL(fileURLWithPath: documentDirectory)
             let imgPath         = photoURL.URLByAppendingPathComponent(msg as! String)
             
             */
            
           // var status=messageDic["status"] as! NSString
            
            let filename=messageDic["filename"] as! NSString
            let status=messageDic["status"] as! NSString
            
            //!!let status=(msg as! String).replacingOccurrences(of: filename as String, with: "", options: NSString.CompareOptions.literal, range: nil)
            
            let dirPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
            let docsDir1 = dirPaths[0]
            let documentDir=docsDir1 as NSString
            
            let imgPath=documentDir.appendingPathComponent(filename as String)
          //  print("uniqueid image is \(uniqueidDictValue) filename is \(filename) imgPath is \(imgPath)")
            
            let imgNSData=FileManager.default.contents(atPath: imgPath)
            
        //====     print("imgNSData is \(imgNSData)")
            
            //var imgNSData=NSFileManager.default.contents(atPath:imgPath.path!)
            //print("hereee imgPath.path! is \(imgPath)")
            
            //!!timeLabel.frame = CGRect(x: chatImage.frame.origin.x, y: chatImage.frame.origin.y+180, width: chatImage.frame.width,  height: timeLabel.frame.height)
            

            let formatter = DateFormatter();
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS";
            //formatter.dateFormat = "MM/dd hh:mm a";
            formatter.timeZone = TimeZone.autoupdatingCurrent
            let defaultTimeZoneStr = formatter.date(from: date2 as! String)
            //print("defaultTimeZoneStr \(defaultTimeZoneStr)")
            
            let formatter2 = DateFormatter();
            formatter2.timeZone=TimeZone.autoupdatingCurrent
            formatter2.dateFormat = "MM/dd hh:mm a";
            let displaydate=formatter2.string(from: defaultTimeZoneStr!)
            
            if(imgNSData != nil /*&& (cell.tag == indexPath.row)*/)
            {
                chatImage.isUserInteractionEnabled = true
                //now you need a tap gesture recognizer
                //note that target and action point to what happens when the action is recognized.
                let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(ChatDetailViewController.imageTapped(_:)))
                //Add the recognizer to your view.
    
    
                let predicate=NSPredicate(format: "uniqueid = %@", uniqueidDictValue!)
                let resultArray=uploadInfo.filtered(using: predicate)
                if(resultArray.count>0)
                {
                    
                    
                    let uploadDone = (resultArray.first! as AnyObject).value(forKey: "isCompleted") as! Bool
                    if(uploadDone==false)
                    {
                        progressView?.isHidden=false
                    }
                    else
                    {
                        progressView?.isHidden=true
                        
                    }
                    
                }
    /*var predicate=NSPredicate(format: "uniqueid = %@", uniqueidDictValue)
                var resultArray=uploadInfo.filteredArrayUsingPredicate(predicate)
                if(resultArray.count>0)
                {
                    // progressView.hidden=false
                    // //print("yes uploading predicate satisfiedd")
                    var bbb = resultArray.first!.valueForKey("uploadProgress") as! Float
                    //print("yes uploading predicate satisfiedd \(bbb)")
                    var newAngleValue=(bbb*360) as NSNumber
                    //print("\(progressView.angle) to newangle is \(newAngleValue.integerValue)")
                    if(progressView.angle<newAngleValue.integerValue)
                    {
                        progressView.animateFromAngle(progressView.angle, toAngle: newAngleValue.integerValue, duration: 0.5, completion: nil)
                    }
 
                    
                    // progressView.animateToAngle(newAngleValue.integerValue, duration: 0.5, completion: nil)
                    //return true
                }
 */
                chatImage.addGestureRecognizer(tapRecognizer)
                
                
                chatImage.frame = CGRect(x: chatImage.frame.origin.x, y: chatImage.frame.origin.y, width: 218, height: 200)
                
                chatImage.image = UIImage(data: imgNSData!)!
                ///.stretchableImageWithLeftCapWidth(40,topCapHeight: 20);
                chatImage.contentMode = .scaleAspectFill
                //======= uncomment later chatImage.setNeedsDisplay()
                //print("file shownnnnnnnnn")
                textLable.isHidden=true
                
                
                //print("date received in chat is \(date2.debugDescription)")
              print("image status is \(status)")
                  timeLabel.text="\(displaydate) (\(status))"
               // timeLabel.text=date2.debugDescription
            }
             timeLabel.text="\(displaydate) (\(status))"
            
            /* var imgNSURL = NSURL(fileURLWithPath: msg as String)
             var imgNSData=NSFileManager.default.contents(atPath:imgNSURL.path!)
             if(imgNSData != nil)
             {
             chatImage.image = UIImage(contentsOfFile: msg as String)
             //print("file shownnnnnnnnn")
             }
             */
        }*/
        if(msgType?.isEqual(to: "5"))!
        {
            //print("type is 5 hereeeeeeeeeeee")
            cell = ///tblForChats.dequeueReusableCellWithIdentifier("ChatReceivedCell")! as UITableViewCell
                
                //FileImageReceivedCell
                tblForChats.dequeueReusableCell(withIdentifier: "DocSentCell")! as UITableViewCell
            let deliveredLabel = cell.viewWithTag(13) as! UILabel
            let textLable = cell.viewWithTag(12) as! UILabel
            let timeLabel = cell.viewWithTag(11) as! UILabel
            let chatImage = cell.viewWithTag(1) as! UIImageView
            let profileImage = cell.viewWithTag(2) as! UIImageView
             let progressView=cell.viewWithTag(14) as! KDCircularProgress
            
            //!!let distanceFactor = (170.0 - sizeOFStr.width) < 100 ? (170.0 - sizeOFStr.width) : 100
            
            
            /*
            var predicate=NSPredicate(format: "uniqueid = %@", uniqueidDictValue)
            var resultArray=uploadInfo.filteredArrayUsingPredicate(predicate)
            if(resultArray.count>0)
            {
                
                
                var uploadDone = resultArray.first!.valueForKey("isCompleted") as! Bool
                if(uploadDone==false)
                {
                    progressView.hidden=false
                }
                else
                {
                    progressView.hidden=true
                    
                }
                
                
            }
            */
            /*var predicate=NSPredicate(format: "uniqueid = %@", uniqueidDictValue)
            var resultArray=uploadInfo.filteredArrayUsingPredicate(predicate)
            if(resultArray.count>0)
{
   // progressView.hidden=false
   // //print("yes uploading predicate satisfiedd")
   var bbb = resultArray.first!.valueForKey("uploadProgress") as! Float
    //print("yes uploading predicate satisfiedd \(bbb)")
    var newAngleValue=(bbb*360) as NSNumber
    //print("\(progressView.angle) to newangle is \(newAngleValue.integerValue)")
    if(progressView.angle<newAngleValue.integerValue)
    {
        progressView.animateFromAngle(progressView.angle, toAngle: newAngleValue.integerValue, duration: 0.5, completion: nil)
    }

    //progressView.animateToAngle(newAngleValue.integerValue, duration: 0.5, completion: nil)
    //return true
}
 
 */
          /*  var uploading=uploadInfo.contains({ (predicate) -> Bool in
             //   return ((predicate as? Int) == intValue)
                //print("yes uploading predicate satisfiedd")
                var newAngleValue=270
                progressView.animateToAngle(newAngleValue, duration: 0.5, completion: nil)
                return true
            })
 */
            
            
           //  chatImage.frame = CGRectMake(chatImage.frame.origin.x, chatImage.frame.origin.y, 200, 200)
            
            ///chatImage.frame = CGRectMake(20 + distanceFactor, chatImage.frame.origin.y, ((sizeOFStr.width + 100)  > 200 ? (sizeOFStr.width + 100) : 200), sizeOFStr.height + 40)
            let correctheight=getSizeOfStringHeight(msg!).height
            
            textLable.isHidden=false
            //chatImage.frame = CGRectMake(20 + distanceFactor, chatImage.frame.origin.y, ((sizeOFStr.width + 100)  > 200 ? (sizeOFStr.width + 100) : 200), sizeOFStr.height + 40)
            //!!chatImage.image = UIImage(named: "chat_receive")?.stretchableImage(withLeftCapWidth: 40,topCapHeight: 20);
            
             //!!chatImage.frame = CGRect(x: chatImage.frame.origin.x, y: chatImage.frame.origin.y, width: ((sizeOFStr.width + 100)  > 200 ? (sizeOFStr.width + 100) : 200), height: correctheight + 20)
            
            
            
            
            //!!textLable.frame = CGRect(x: 60, y: textLable.frame.origin.y+10, width: chatImage.frame.width-70, height: correctheight)
            
            
            // newwwwwwwwww textLable.frame = CGRectMake(26 + distanceFactor, textLable.frame.origin.y, chatImage.frame.width-36, getSizeOfStringHeight(msg).height)
            //print("new height is \(textLable.frame.height) msg is \(msg)")
            //=====newwwwwww  textLable.frame = CGRectMake(26 + distanceFactor,
            
            
            //!!timeLabel.frame = CGRect(x: 35, y: textLable.frame.origin.y+textLable.frame.height, width: chatImage.frame.size.width-46, height: timeLabel.frame.size.height)
            
            //!!profileImage.center = CGPoint(x: 45, y: chatImage.frame.origin.y+10 + (profileImage.frame.size.height)/2+5)
            
            
            
            // chatImage.layer.borderColor=UIColor.greenColor().CGColor
            //  chatImage.layer.borderWidth = 3.0;
            // chatImage.highlighted=true
            // *********
            
            //old was 36 in place of 60
            ///textLable.frame = CGRectMake(60 + textLable.frame.origin.x, textLable.frame.origin.y, textLable.frame.size.width, sizeOFStr.height)
            
            
           //// profileImage.center = CGPointMake(45+textLable.frame.origin.x, textLable.frame.origin.y + textLable.frame.size.height - profileImage.frame.size.height/2+10)
            
            ////////profileImage.setNeedsDisplay()
            
            ////timeLabel.frame = CGRectMake(35 + distanceFactor, chatImage.frame.origin.y+sizeOFStr.height + 20, chatImage.frame.size.width-40, timeLabel.frame.size.height)
            
            
            //////chatImage.contentMode = .Center
            
            //chatImage.frame = CGRectMake(80, chatImage.frame.origin.y, 220, 220)
 
            
            let filename=messageDic["filename"] as! NSString
            let dirPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
            let docsDir1 = dirPaths[0]
            let documentDir=docsDir1 as NSString
            let docPath=documentDir.appendingPathComponent(filename as String)
            
            
            
            let docData=FileManager.default.contents(atPath: docPath)
            if(docData != nil)
            {
            textLable.text = msg! as! String
            }
            else{
                textLable.text = "Downloading...".localized
            }
            
            selectedText = filename as String
            
            /// var imgNSData=NSFileManager.default.contents(atPath:imgPath)
            chatImage.isUserInteractionEnabled=true
            //var filelabel=UILabel(frame: CGRect(x: 20 + chatImage.frame.origin.x, y: chatImage.frame.origin.y + sizeOFStr.height + 40,width: ((sizeOFStr.width + 100)  > 200 ? (sizeOFStr.width + 100) : 200), height: sizeOFStr.height + 40))
            //filelabel.text="rtf   95kb 3:23am"
            //chatImage.addSubview(filelabel)
            // UILabel(frame: 0,0,((sizeOFStr.width + 100)  > 200 ? (sizeOFStr.width + 100) : 200), sizeOFStr.height + 40)
           
            //let tapRecognizer = UITapGestureRecognizer(target: self, action: Selector("docTapped:"))
            //Add the recognizer to your view.
            
            
           //chatImage.addGestureRecognizer(tapRecognizer)
            
            //print("date received in chat is \(date2.debugDescription)")
            let formatter = DateFormatter();
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS";
            //formatter.dateFormat = "MM/dd hh:mm a";
            formatter.timeZone = TimeZone.autoupdatingCurrent
            let defaultTimeZoneStr = formatter.date(from: date2 as! String)
            //print("defaultTimeZoneStr \(defaultTimeZoneStr)")
            
            let formatter2 = DateFormatter();
            formatter2.timeZone=TimeZone.autoupdatingCurrent
            formatter2.dateFormat = "MM/dd hh:mm a";
            let displaydate=formatter2.string(from: defaultTimeZoneStr!)
            
            timeLabel.text=displaydate
            //timeLabel.text=date2.debugDescription
        }
        if(msgType?.isEqual(to: "6"))!
        {
            //print("type is 6 hereeeeeeeeeeee")
            cell = ///tblForChats.dequeueReusableCellWithIdentifier("ChatReceivedCell")! as UITableViewCell
                
                //FileImageReceivedCell
                tblForChats.dequeueReusableCell(withIdentifier: "DocReceivedCell")! as UITableViewCell
            let deliveredLabel = cell.viewWithTag(13) as! UILabel
            let textLable = cell.viewWithTag(12) as! UILabel
            let timeLabel = cell.viewWithTag(11) as! UILabel
            let chatImage = cell.viewWithTag(1) as! UIImageView
            let profileImage = cell.viewWithTag(2) as! UIImageView
            let progressView=cell.viewWithTag(14) as! KDCircularProgress
           
            
            
           // let distanceFactor = (170.0 - sizeOFStr.width) < 100 ? (170.0 - sizeOFStr.width) : 100
    
            //!!let distanceFactor = (197.0 - sizeOFStr.width) < 107 ? (197.0 - sizeOFStr.width) : 107
            
            //===== neww  let distanceFactor = (197.0 - sizeOFStr.width) < 107 ? (197.0 - sizeOFStr.width) : 107
            //print("distanceFactor for \(msg) is \(distanceFactor)")
            
        /////    chatImage.frame = CGRectMake(20 + distanceFactor, chatImage.frame.origin.y, ((sizeOFStr.width + 107)  > 207 ? (sizeOFStr.width + 107) : 200), sizeOFStr.height + 40)
          //  //print("chatImage.x for \(msg) is \(20 + distanceFactor) and chatimage.wdith is \(chatImage.frame.width)")
            

            
            let predicate=NSPredicate(format: "uniqueid = %@", uniqueidDictValue!)
            let resultArray=uploadInfo.filtered(using: predicate)
            if(resultArray.count>0)
            {
                
                
                let uploadDone = (resultArray.first! as AnyObject).value(forKey: "isCompleted") as! Bool
                if(uploadDone==false)
                {
                    progressView.isHidden=false
                }
                else
                {
                    progressView.isHidden=true
                    
                }
                
                
            }
    
   
            
            textLable.isHidden=false
            textLable.text = msg as! String
            /*textLable.lineBreakMode = .ByWordWrapping
            textLable.numberOfLines=0
            textLable.sizeToFit()
            print("previous height is \(textLable.frame.height) msg is \(msg)")
            var correctheight=textLable.frame.height
            */
            let correctheight=getSizeOfStringHeight(msg!).height
            
            //!!chatImage.frame = CGRect(x: 20 + distanceFactor, y: chatImage.frame.origin.y, width: ((sizeOFStr.width + 107)  > 207 ? (sizeOFStr.width + 107) : 200), height: correctheight + 20)
            //!!chatImage.image = UIImage(named: "chat_send")?.stretchableImage(withLeftCapWidth: 40,topCapHeight: 20);
            //*********
            
            //getSizeOfStringHeight(msg).height
            
            //!!textLable.frame = CGRect(x: 60 + distanceFactor, y: textLable.frame.origin.y, width: chatImage.frame.width-70, height: correctheight)
            
            
            // newwwwwwwwww textLable.frame = CGRectMake(26 + distanceFactor, textLable.frame.origin.y, chatImage.frame.width-36, getSizeOfStringHeight(msg).height)
           // print("new height is \(textLable.frame.height) msg is \(msg)")
            //=====newwwwwww  textLable.frame = CGRectMake(26 + distanceFactor, 
            
            
            //!!timeLabel.frame = CGRect(x: 36 + distanceFactor, y: textLable.frame.origin.y+textLable.frame.height, width: chatImage.frame.size.width-46, height: timeLabel.frame.size.height)
            
            //!!profileImage.center = CGPoint(x: 45+distanceFactor, y: chatImage.frame.origin.y + (profileImage.frame.size.height)/2+5)
           
           
            
            
            textLable.isHidden=false
        
            
            let filename=messageDic["filename"] as! NSString
            let dirPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
            let docsDir1 = dirPaths[0]
            var documentDir=docsDir1 as NSString
            ////var imgPath=documentDir.appendingPathComponent(msg as! String)
            
            selectedText = filename as String
            /// var imgNSData=NSFileManager.default.contents(atPath:imgPath)
            chatImage.isUserInteractionEnabled=true
             //print("date received in chat is \(date2.debugDescription)")
            let formatter = DateFormatter();
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS";
            //formatter.dateFormat = "MM/dd hh:mm a";
            formatter.timeZone = TimeZone.autoupdatingCurrent
            let defaultTimeZoneStr = formatter.date(from: date2 as! String)
            //print("defaultTimeZoneStr \(defaultTimeZoneStr)")
            
            let formatter2 = DateFormatter();
            formatter2.timeZone=TimeZone.autoupdatingCurrent
            formatter2.dateFormat = "MM/dd hh:mm a";
            let displaydate=formatter2.string(from: defaultTimeZoneStr!)
            
            timeLabel.text=displaydate

           // timeLabel.text=date2.debugDescription
        }
        
        if(msgType?.isEqual(to: "7"))!
        {
            print("contact received is \(msg)")
            cell = tableView.dequeueReusableCell(withIdentifier: "ContactReceivedCell")! as UITableViewCell
            if(cell==nil)
            {
                cell = tblForChats.dequeueReusableCell(withIdentifier: "ContactReceivedCell")! as UITableViewCell
                
            }
            let textLable = cell.viewWithTag(12) as! UILabel
            let chatImage = cell.viewWithTag(1) as! UIImageView
            let profileImage = cell.viewWithTag(2) as! UIImageView
            let timeLabel = cell.viewWithTag(11) as! UILabel
            let buttonSave = cell.viewWithTag(15) as! UIButton
            
            let buttonsView = cell.viewWithTag(16)! as UIView
            let btnInviteView = buttonsView.viewWithTag(0) as! UIButton
            let btnSaveView = buttonsView.viewWithTag(1) as! UIButton
            let btnMessageView = buttonsView.viewWithTag(2) as! UIButton
            
            
            //buttonSave.tag=indexPath.row
            buttonSave.isHidden=true
           
            print("components now seperating by : \(msg!)")
            let contactinfo=msg!.components(separatedBy: ":") ///return array string
            textLable.text = contactinfo[0]
            contactreceivedphone=contactinfo[1]
            //btnSaveView.setValue(contactinfo[1], forUndefinedKey: "phone")
            btnSaveView.addTarget(self, action: #selector(ChatDetailViewController.BtnSaveContactClicked(_:)), for:.touchUpInside)
          
            
            
            isKiboContact=contactinfo[2]
            if(isKiboContact=="false")
            {
                btnInviteView.isHidden=false
                btnSaveView.isHidden=true
                btnMessageView.isHidden=true
                print("isKiboContact is \(isKiboContact)")
                 //btnInviteView.frame=CGRect(x:btnInviteView.origin.x,y:btnInviteView.origin.y,width:btnInviteView.bounds.width,height:btnInviteView.bounds.height)
                btnInviteView.addTarget(self, action: #selector(ChatDetailViewController.BtnInviteContactClicked(_:)), for:.touchUpInside)
                

            }
            else{
                btnInviteView.isHidden=true
                btnSaveView.isHidden=false
                btnMessageView.isHidden=false
                print("isKiboContact is \(isKiboContact)")
            }
            timeLabel.text = contactinfo[1]
            if((textLable.text!.characters.count) > 21){
               var newtextlabel = textLable.text!.trunc(19)+".."
                textLable.text = newtextlabel
            }
                        
            /*textLable.lineBreakMode = .ByWordWrapping
             textLable.numberOfLines=0
             textLable.sizeToFit()
             print("previous height is \(textLable.frame.height) msg is \(msg)")
             var correctheight=textLable.frame.height
             */
            let correctheight=getSizeOfStringHeight(UtilityFunctions.init().compareLongerString(txt1: timeLabel.text!, txt2: textLable.text!) as NSString).height
            
            sizeOFStr=getSizeOfString(UtilityFunctions.init().compareLongerString(txt1: timeLabel.text!, txt2: textLable.text!) as NSString)
            
            //Setting Chat cell area
            chatImage.frame = CGRect(x: chatImage.frame.origin.x, y: chatImage.frame.origin.y,width: ((sizeOFStr.width + 107)  > 207 ? (sizeOFStr.width + 107) : 200), height: ((correctheight + 20)  > 75 ? (correctheight+20) : 75))
           
            chatImage.image = UIImage(named: "chat_receive")?.stretchableImage(withLeftCapWidth: 40,topCapHeight: 20);
            buttonsView.frame=CGRect(x:chatImage.frame.origin.x,y: buttonsView.frame.origin.y,width:chatImage.frame.width,height:buttonsView.frame.height)
            

            
            //Setting Contact Avatar
             //profileImage.center = CGPoint(x: chatImage.frame.origin.x+60, y: chatImage.frame.origin.y+30)
            
            profileImage.center = CGPoint(x: CGFloat(Float(chatImage.image!.leftCapWidth)+30.0), y: chatImage.frame.height/2)
            
           //Setting Contact Name
            textLable.frame = CGRect(x: profileImage.center.x+35, y: profileImage.center.y-15, width: chatImage.frame.width-36, height: correctheight)
            
            
           // textLable.text = msg! as! String
            
            let formatter = DateFormatter();
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS";
            //formatter.dateFormat = "MM/dd hh:mm a";
            formatter.timeZone = TimeZone.autoupdatingCurrent
            print("line 2055")
            let defaultTimeZoneStr = formatter.date(from: date2 as! String)
            //print("defaultTimeZoneStr \(defaultTimeZoneStr)")
            
            let formatter2 = DateFormatter();
            formatter2.timeZone=TimeZone.autoupdatingCurrent
            formatter2.dateFormat = "MM/dd hh:mm a";
            let displaydate=formatter2.string(from: defaultTimeZoneStr!)
            //formatter.dateFormat = "MM/dd hh:mm a";
            
            
            timeLabel.frame = CGRect(x: profileImage.center.x+35, y: textLable.frame.origin.y+textLable.frame.height, width: chatImage.frame.size.width-46, height: timeLabel.frame.size.height)
            print("textlabel is \(textLable.text!) and timelabel is \(timeLabel.text!)")
            print("textlabel is \(textLable.bounds.debugDescription) and timelabel is \(timeLabel.bounds.debugDescription)")
            
            buttonSave.frame = CGRect(x: chatImage.frame.width-40, y: chatImage.frame.height-25, width: buttonSave.frame.size.width, height: buttonSave.frame.size.height)
            //timeLabel.text=date2.debugDescription
        }
        if(msgType?.isEqual(to: "8"))!
        {
            
            print("UI chat type is \(msgType!)")
            cell=tableView.dequeueReusableCell(withIdentifier: "ContactSentCell")
            if(cell==nil)
            {
                cell = tblForChats.dequeueReusableCell(withIdentifier: "ContactSentCell")! as UITableViewCell
            }
            let deliveredLabel = cell.viewWithTag(13) as! UILabel
            let textLable = cell.viewWithTag(12) as! UILabel
            let timeLabel = cell.viewWithTag(11) as! UILabel
            let chatImage = cell.viewWithTag(1) as! UIImageView
            let profileImage = cell.viewWithTag(2) as! UIImageView
            let buttonsView = cell.viewWithTag(16)! as UIView
            let btnInviteView = buttonsView.viewWithTag(0) as! UIButton
            let btnSaveView = buttonsView.viewWithTag(1) as! UIButton
            let btnMessageView = buttonsView.viewWithTag(2) as! UIButton
            print("components now seperating by : \(msg!)")
            
            
            let contactinfo=msg!.components(separatedBy: ":") ///return array string
            textLable.text = contactinfo[0]
            var number=contactinfo[1]
            print("components now seperating by space \(number)")
            let number2=number.components(separatedBy: ":")
               number=number2[0]
            let kibo2=number.components(separatedBy: " ")
         isKiboContact="\(UtilityFunctions.init().isKiboContact(phone1:number2[0]))"
            
            btnSaveView.addTarget(self, action: #selector(ChatDetailViewController.BtnSaveContactClicked(_:)), for:.touchUpInside)
            

            print("isKiboContact is \(isKiboContact)")
            if(isKiboContact=="false")
            {print("isKiboContact is \(isKiboContact)")
                btnInviteView.isHidden=false
                btnSaveView.isHidden=false
                btnMessageView.isHidden=true
                
                
               /// btnInviteView.frame=CGRect(x:btnInviteView.origin.x,y:btnInviteView.origin.y,width:btnInviteView.bounds.width,height:btnInviteView.bounds.height)
                btnInviteView.addTarget(self, action: #selector(ChatDetailViewController.BtnInviteContactClicked(_:)), for:.touchUpInside)
                
                
            }
            else{
                print("isKiboContact is \(isKiboContact)")
                btnInviteView.isHidden=true
                btnSaveView.isHidden=false
                btnMessageView.isHidden=false
            }

            
            if((textLable.text!.characters.count) > 21){
                var newtextlabel = textLable.text!.trunc(19)+".."
                textLable.text = newtextlabel
            }
            sizeOFStr=getSizeOfString(textLable.text! as! NSString)
            print("sizeOFStr of \(textLable.text!) is \(sizeOFStr)")
            //// //print("here 905 msgtype is \(msgType)")
            let distanceFactor = (197.0 - sizeOFStr.width) < 90 ? (197.0 - sizeOFStr.width) : 90
            textLable.isHidden=false
            //textLable.text = msg! as! String
          
            
            let correctheight=getSizeOfStringHeight(msg!).height
             //chatImage.frame = CGRect(x: 20 + distanceFactor, y: chatImage.frame.origin.y, width: ((sizeOFStr.width + 107)  > 207 ? (sizeOFStr.width + 107) : 200), height: ((correctheight + 20)  > 100 ? (correctheight+20) : 100))
            
            
            chatImage.frame = CGRect(x: /*chatImage.frame.origin.x*/ 20 + distanceFactor, y: chatImage.frame.origin.y,width: ((sizeOFStr.width + 107)  > 210 ? (sizeOFStr.width + 107) : 210), height: ((correctheight + 20)  > 75 ? (correctheight+20) : 75))
            

            buttonsView.frame=CGRect(x:chatImage.frame.origin.x,y: buttonsView.frame.origin.y,width:chatImage.frame.width,height:buttonsView.frame.height)
            
               chatImage.image = UIImage(named: "chat_send")?.stretchableImage(withLeftCapWidth: 40,topCapHeight: 20);
            
            //!!==--contactCardSelected=number
            let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(ChatDetailViewController.contactSharedTapped(_:)))
            //Add the recognizer to your view.
            chatImage.addGestureRecognizer(tapRecognizer)
            
            //*********
            
            //getSizeOfStringHeight(msg).height
            
            //textLable.frame = CGRect(x: 26 + distanceFactor, y: textLable.frame.origin.y, width: chatImage.frame.width-36, height: correctheight)
            
            //profileImage.center = CGPoint(x: profileImage.center.x, y: textLable.frame.origin.y + textLable.frame.size.height - profileImage.frame.size.height/2+10)
            
            profileImage.center = CGPoint(x: chatImage.frame.origin.x+30, y: chatImage.frame.height/2)
            
            //Setting Contact Name
            textLable.frame = CGRect(x: profileImage.center.x+35, y: profileImage.center.y-15, width: chatImage.frame.width-36, height: correctheight)
            
            
            
            //==uncomment if needed timeLabel.frame = CGRectMake(36 + distanceFactor, timeLabel.frame.origin.y, timeLabel.frame.size.width, timeLabel.frame.size.height)
            
           // timeLabel.frame = CGRect(x: 36 + distanceFactor, y: textLable.frame.origin.y+textLable.frame.height, width: chatImage.frame.size.width-46, height: timeLabel.frame.size.height)
            timeLabel.frame = CGRect(x: profileImage.center.x+35, y: textLable.frame.origin.y+textLable.frame.height, width: chatImage.frame.size.width-46, height: timeLabel.frame.size.height)
            
            deliveredLabel.frame = CGRect(x: deliveredLabel.frame.origin.x, y: textLable.frame.origin.y + textLable.frame.size.height + 15, width: deliveredLabel.frame.size.width, height: deliveredLabel.frame.size.height)
            
            
            
           // let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(ChatDetailViewController.videoTapped(_:)))
            //Add the recognizer to your view.
            //videoView?.addGestureRecognizer(tapRecognizer)
            
            
            //print("date received in chat post 2 is \(date2.debugDescription)")
            // //print("date received in chat is \(date2.debugDescription)")
            let formatter = DateFormatter();
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS";
            //formatter.dateFormat = "MM/dd hh:mm a";
            formatter.timeZone = TimeZone.autoupdatingCurrent
            let defaultTimeZoneStr = formatter.date(from: date2 as! String)
            //print("defaultTimeZoneStr \(defaultTimeZoneStr)")
            
            if(defaultTimeZoneStr == nil)
            {
                timeLabel.text=date2 as! String
                
            }
            else
            {
                let formatter2 = DateFormatter();
                formatter2.timeZone=TimeZone.autoupdatingCurrent
                formatter2.dateFormat = "MM/dd hh:mm a";
                let displaydate=formatter2.string(from: defaultTimeZoneStr!)
                //formatter.dateFormat = "MM/dd hh:mm a";
                
                let status=messageDic["status"] as NSString!
                timeLabel.text="\(displaydate) (\(status!))"
            }
            
            //local date already shortened then added to dictionary when post button is pressed
            //timeLabel.text=date2.debugDescription
        }
        if(msgType?.isEqual(to: "9"))!
        {
            print("video received is \(msg)")
            cell = tableView.dequeueReusableCell(withIdentifier: "VideoReceivedCell")! as UITableViewCell
            if(cell==nil)
            {
                cell = tblForChats.dequeueReusableCell(withIdentifier: "VideoReceivedCell")! as UITableViewCell
            }
            
            let videoView = cell.viewWithTag(0)
            let videoLabel = videoView?.viewWithTag(1) as! UILabel
            let timeLabel = videoView?.viewWithTag(3) as! UILabel
            
            videoLabel.text=msg as String?
            
            let dirPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
            let docsDir1 = dirPaths[0]
            var documentDir=docsDir1 as NSString
            var videoPath=documentDir.appendingPathComponent(msg as! String)
           // let videoLabel = videoView?.viewWithTag(1) as! UILabel
            let videoLabelStatus = videoView?.viewWithTag(2) as! UILabel
            
            
            let url = NSURL.fileURL(withPath: videoPath)
            
            let docData=FileManager.default.contents(atPath: videoPath)
            if(docData != nil)
            {
                videoLabelStatus.text = "Play".localized
            }
            else{
                videoLabelStatus.text = "Downloading...".localized
            }

            /*
            self.moviePlayer = MPMoviePlayerController(contentURL: url)
            if let player = self.moviePlayer {
               // player.view.frame=(videoView?.frame)!
                
                player.view.frame = CGRect(x: (videoView?.frame.origin.x)!+10, y: (videoView?.frame.origin.y)!, width: 200, height: 200)
                player.scalingMode = .aspectFit
                 player.prepareToPlay()
                ///player.scalingMode = MPMovieScalingMode.fill
                player.isFullscreen = true
                player.controlStyle = MPMovieControlStyle.embedded
                player.movieSourceType = MPMovieSourceType.file
               player.repeatMode = MPMovieRepeatMode.none
                player.shouldAutoplay=false
                ////player.play()
                */
            
            
            let formatter = DateFormatter();
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS";
            //formatter.dateFormat = "MM/dd hh:mm a";
            formatter.timeZone = TimeZone.autoupdatingCurrent
            print("line 2055")
            let defaultTimeZoneStr = formatter.date(from: date2 as! String)
            //print("defaultTimeZoneStr \(defaultTimeZoneStr)")
            
            let formatter2 = DateFormatter();
            formatter2.timeZone=TimeZone.autoupdatingCurrent
            formatter2.dateFormat = "MM/dd hh:mm a";
            let displaydate=formatter2.string(from: defaultTimeZoneStr!)
            //formatter.dateFormat = "MM/dd hh:mm a";
            
            
            timeLabel.frame = CGRect(x: (videoView?.frame.origin.x)!, y: (videoView?.frame.origin.y)!+(videoView?.frame.height)!, width: (videoView?.frame.size.width)!-46, height: timeLabel.frame.size.height)
            
            
            //===new   timeLabel.frame = CGRectMake(textLable.frame.origin.x, textLable.frame.origin.y+textLable.frame.height+10, chatImage.frame.size.width-46, timeLabel.frame.size.height)
            
            
            //print("displaydate is \(displaydate)")
            timeLabel.text=displaydate+" (\(status as! String))"
            
            let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(ChatDetailViewController.videoTapped(_:)))
            //Add the recognizer to your view.
            videoView?.addGestureRecognizer(tapRecognizer)
            
            
                //self.view.addSubview(player.view)
                //cell.addSubview(player.view)
               // videoView?.addSubview(player.view)
                //videoView?.bringSubview(toFront: player.view)
                
            
            /*let textLable = cell.viewWithTag(12) as! UILabel
            let chatImage = cell.viewWithTag(1) as! UIImageView
            let profileImage = cell.viewWithTag(2) as! UIImageView
            let timeLabel = cell.viewWithTag(11) as! UILabel
            let buttonSave = cell.viewWithTag(15) as! UIButton
 
            
            buttonSave.addTarget(self, action: #selector(ChatDetailViewController.BtnSaveContactClicked(_:)), for:.touchUpInside)
            
            
            let contactinfo=msg!.components(separatedBy: ":") ///return array string
            textLable.text = contactinfo[0]
            contactreceivedphone=contactinfo[1]
            timeLabel.text = contactinfo[1]
            if((textLable.text!.characters.count) > 21){
                var newtextlabel = textLable.text!.trunc(19)+".."
                textLable.text = newtextlabel
            }
            
           
            let correctheight=getSizeOfStringHeight(UtilityFunctions.init().compareLongerString(txt1: timeLabel.text!, txt2: textLable.text!) as NSString).height
            
            sizeOFStr=getSizeOfString(UtilityFunctions.init().compareLongerString(txt1: timeLabel.text!, txt2: textLable.text!) as NSString)
 
            //Setting Chat cell area
            chatImage.frame = CGRect(x: chatImage.frame.origin.x, y: chatImage.frame.origin.y,width: ((sizeOFStr.width + 107)  > 207 ? (sizeOFStr.width + 107) : 200), height: ((correctheight + 20)  > 85 ? (correctheight+20) : 85))
            
            ////////////////chatImage.image = UIImage(named: "chat_receive")?.stretchableImage(withLeftCapWidth: 40,topCapHeight: 20);
            
            
            //Setting Contact Avatar
            
            profileImage.center = CGPoint(x: CGFloat(Float(chatImage.image!.leftCapWidth)+30.0), y: chatImage.frame.height/2)
            
            //Setting Contact Name
            textLable.frame = CGRect(x: profileImage.center.x+35, y: profileImage.center.y-15, width: chatImage.frame.width-36, height: correctheight)
            
            
            // textLable.text = msg! as! String
            
            let formatter = DateFormatter();
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS";
            //formatter.dateFormat = "MM/dd hh:mm a";
            formatter.timeZone = TimeZone.autoupdatingCurrent
            print("line 2055")
            let defaultTimeZoneStr = formatter.date(from: date2 as! String)
            //print("defaultTimeZoneStr \(defaultTimeZoneStr)")
            
            let formatter2 = DateFormatter();
            formatter2.timeZone=TimeZone.autoupdatingCurrent
            formatter2.dateFormat = "MM/dd hh:mm a";
            let displaydate=formatter2.string(from: defaultTimeZoneStr!)
            //formatter.dateFormat = "MM/dd hh:mm a";
            
            
            timeLabel.frame = CGRect(x: profileImage.center.x+35, y: textLable.frame.origin.y+textLable.frame.height, width: chatImage.frame.size.width-46, height: timeLabel.frame.size.height)
            print("textlabel is \(textLable.text!) and timelabel is \(timeLabel.text!)")
            print("textlabel is \(textLable.bounds.debugDescription) and timelabel is \(timeLabel.bounds.debugDescription)")
            
            buttonSave.frame = CGRect(x: chatImage.frame.width-40, y: chatImage.frame.height-25, width: buttonSave.frame.size.width, height: buttonSave.frame.size.height)
            //timeLabel.text=date2.debugDescription
            
            */
    
    }

        if(msgType?.isEqual(to: "10"))!
        {
            print("video sent is \(msg)")
            cell = tableView.dequeueReusableCell(withIdentifier: "VideoSentCell")! as UITableViewCell
            if(cell==nil)
            {
                cell = tblForChats.dequeueReusableCell(withIdentifier: "VideoSentCell")! as UITableViewCell
            }
            
            let videoView = cell.viewWithTag(0)
    let videoLabel = videoView?.viewWithTag(1) as! UILabel
            let videoLabelStatus = videoView?.viewWithTag(2) as! UILabel
            
            let timeLabel = videoView?.viewWithTag(3) as! UILabel
            
    videoLabel.text=msg as String?
            //let filename=messageDic["filename"] as! NSString
            let dirPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
            let docsDir1 = dirPaths[0]
            var documentDir=docsDir1 as NSString
            var videoPath=documentDir.appendingPathComponent(msg! as! String)
            
            
            
             // var moviePlayer : MPMoviePlayerController!
            
            let url = NSURL.fileURL(withPath: videoPath)
            let docData=FileManager.default.contents(atPath: videoPath)
            if(docData != nil)
            {
                videoLabelStatus.text = "Play".localized
            }
            else{
                videoLabelStatus.text = "Downloading...".localized
            }
            /*self.moviePlayer = MPMoviePlayerController(contentURL: url)
            if let player = self.moviePlayer {
                player.view.frame = CGRect(x: self.view.frame.width/3, y: (videoView?.frame.origin.y)!, width: 200, height: 200)
                //player.prepareToPlay()

                player.scalingMode = .aspectFit
                ///player.scalingMode = MPMovieScalingMode.fill
                player.isFullscreen = false
                player.controlStyle = MPMovieControlStyle.embedded
                player.movieSourceType = MPMovieSourceType.file
                player.controlStyle = .embedded
                //player.repeatMode = MPMovieRepeatMode.
                player.prepareToPlay()
                ////player.play()
                player.shouldAutoplay=false
                
                self.view.addSubview(player.view)
                */
            
            let formatter = DateFormatter();
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS";
            //formatter.dateFormat = "MM/dd hh:mm a";
            formatter.timeZone = TimeZone.autoupdatingCurrent
            let defaultTimeZoneStr = formatter.date(from: date2 as! String)
            //print("defaultTimeZoneStr \(defaultTimeZoneStr)")
            
            if(defaultTimeZoneStr == nil)
            {
                timeLabel.text=date2 as! String
                
            }
            else
            {
                let formatter2 = DateFormatter();
                formatter2.timeZone=TimeZone.autoupdatingCurrent
                formatter2.dateFormat = "MM/dd hh:mm a";
                let displaydate=formatter2.string(from: defaultTimeZoneStr!)
                //formatter.dateFormat = "MM/dd hh:mm a";
                
                timeLabel.text=displaydate+" (\(status as! String))"
            }
            
            
            let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(ChatDetailViewController.videoTapped(_:)))
            //Add the recognizer to your view.
            videoView?.addGestureRecognizer(tapRecognizer)
           
            
            /*let player = AVPlayer(url: url)
            let playerViewController = AVPlayerViewController()
            playerViewController.player = player
            self.present(playerViewController, animated: true) {
              */
                //videoView?.addSubview(player.view)
                //videoView?.bringSubview(toFront: player.view)
            
        }
        
        if(msgType?.isEqual(to: "11"))!
        {
           //audio received
            print("audio received is \(msg)")
            cell = tableView.dequeueReusableCell(withIdentifier: "AudioReceivedCell")! as UITableViewCell
            if(cell==nil)
            {
                cell = tblForChats.dequeueReusableCell(withIdentifier: "AudioReceivedCell")! as UITableViewCell
            }
            let textLable = cell.viewWithTag(12) as! UILabel
            let chatImage = cell.viewWithTag(1) as! UIImageView
            let profileImage = cell.viewWithTag(2) as! UIImageView
            let timeLabel = cell.viewWithTag(11) as! UILabel
            let buttonSave = cell.viewWithTag(15) as! UIButton
            
            audioFilePlayName=msg! as! String
            /*buttonSave.addTarget(self, action: #selector(ChatDetailViewController.BtnPlayAudioClicked(_:)), for:.touchUpInside)
            */
            
            textLable.text = msg! as! String
            let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(ChatDetailViewController.BtnPlayAudioClicked(_:)))
            //Add the recognizer to your view.
            
            cell.contentView.addGestureRecognizer(tapRecognizer)
            
           
            
            
           /* let contactinfo=msg!.components(separatedBy: ":") ///return array string
            textLable.text = contactinfo[0]
            contactreceivedphone=contactinfo[1]
            timeLabel.text = contactinfo[1]
            if((textLable.text!.characters.count) > 21){
                var newtextlabel = textLable.text!.trunc(19)+".."
                textLable.text = newtextlabel
            }
            */
            
            /*textLable.lineBreakMode = .ByWordWrapping
             textLable.numberOfLines=0
             textLable.sizeToFit()
             print("previous height is \(textLable.frame.height) msg is \(msg)")
             var correctheight=textLable.frame.height
             */
            let correctheight=getSizeOfStringHeight(UtilityFunctions.init().compareLongerString(txt1: timeLabel.text!, txt2: textLable.text!) as NSString).height
            
            sizeOFStr=getSizeOfString(UtilityFunctions.init().compareLongerString(txt1: timeLabel.text!, txt2: textLable.text!) as NSString)
            
            //Setting Chat cell area
            chatImage.frame = CGRect(x: chatImage.frame.origin.x, y: chatImage.frame.origin.y,width: ((sizeOFStr.width + 107)  > 207 ? (sizeOFStr.width + 107) : 200), height: ((correctheight + 20)  > 85 ? (correctheight+20) : 85))
            
            chatImage.image = UIImage(named: "chat_receive")?.stretchableImage(withLeftCapWidth: 40,topCapHeight: 20);
            
            
            //Setting Contact Avatar
            //profileImage.center = CGPoint(x: chatImage.frame.origin.x+60, y: chatImage.frame.origin.y+30)
            
            profileImage.center = CGPoint(x: CGFloat(Float(chatImage.image!.leftCapWidth)+30.0), y: chatImage.frame.height/2)
            
            //Setting Contact Name
            textLable.frame = CGRect(x: profileImage.center.x+35, y: profileImage.center.y-15, width: chatImage.frame.width-36, height: correctheight)
            
            
            // textLable.text = msg! as! String
            
            let formatter = DateFormatter();
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS";
            //formatter.dateFormat = "MM/dd hh:mm a";
            formatter.timeZone = TimeZone.autoupdatingCurrent
            print("line 2055")
            let defaultTimeZoneStr = formatter.date(from: date2 as! String)
            //print("defaultTimeZoneStr \(defaultTimeZoneStr)")
            
            let formatter2 = DateFormatter();
            formatter2.timeZone=TimeZone.autoupdatingCurrent
            formatter2.dateFormat = "MM/dd hh:mm a";
            let displaydate=formatter2.string(from: defaultTimeZoneStr!)
            //formatter.dateFormat = "MM/dd hh:mm a";
            
            
            timeLabel.frame = CGRect(x: profileImage.center.x+35, y: textLable.frame.origin.y+textLable.frame.height, width: chatImage.frame.size.width-100, height: timeLabel.frame.size.height)
            print("textlabel is \(textLable.text!) and timelabel is \(timeLabel.text!)")
            print("textlabel is \(textLable.bounds.debugDescription) and timelabel is \(timeLabel.bounds.debugDescription)")
            
            buttonSave.frame = CGRect(x: chatImage.frame.width-40, y: chatImage.frame.height-25, width: buttonSave.frame.size.width, height: buttonSave.frame.size.height)
            timeLabel.text=displaydate

            
        }
        if(msgType?.isEqual(to: "12"))!
        {
            
            print("UI chat type is \(msgType!)")
            cell=tableView.dequeueReusableCell(withIdentifier: "AudioSentCell")
            if(cell==nil)
            {
                cell = tblForChats.dequeueReusableCell(withIdentifier: "AudioSentCell")! as UITableViewCell
            }
            let deliveredLabel = cell.viewWithTag(13) as! UILabel
            let textLable = cell.viewWithTag(12) as! UILabel
            let timeLabel = cell.viewWithTag(11) as! UILabel
            let chatImage = cell.viewWithTag(1) as! UIImageView
            let profileImage = cell.viewWithTag(2) as! UIImageView
            
            /*
            let contactinfo=msg!.components(separatedBy: ":") ///return array string
            textLable.text = contactinfo[0]
            if((textLable.text!.characters.count) > 21){
                var newtextlabel = textLable.text!.trunc(19)+".."
                textLable.text = newtextlabel
            }*/
            textLable.text=msg as! String
            sizeOFStr=getSizeOfString(textLable.text! as! NSString)
            print("sizeOFStr of \(textLable.text!) is \(sizeOFStr)")
            //// //print("here 905 msgtype is \(msgType)")
            let distanceFactor = (197.0 - sizeOFStr.width) < 90 ? (197.0 - sizeOFStr.width) : 90
            textLable.isHidden=false
            //textLable.text = msg! as! String
            
            
            let correctheight=getSizeOfStringHeight(msg!).height
            //chatImage.frame = CGRect(x: 20 + distanceFactor, y: chatImage.frame.origin.y, width: ((sizeOFStr.width + 107)  > 207 ? (sizeOFStr.width + 107) : 200), height: ((correctheight + 20)  > 100 ? (correctheight+20) : 100))
            
            
            chatImage.frame = CGRect(x: /*chatImage.frame.origin.x*/ 20 + distanceFactor, y: chatImage.frame.origin.y,width: ((sizeOFStr.width + 107)  > 210 ? (sizeOFStr.width + 107) : 210), height: ((correctheight + 20)  > 75 ? (correctheight+20) : 75))
            
            
            
            chatImage.image = UIImage(named: "chat_send")?.stretchableImage(withLeftCapWidth: 40,topCapHeight: 20);
            //*********
            
            //getSizeOfStringHeight(msg).height
            
            //textLable.frame = CGRect(x: 26 + distanceFactor, y: textLable.frame.origin.y, width: chatImage.frame.width-36, height: correctheight)
            
            //profileImage.center = CGPoint(x: profileImage.center.x, y: textLable.frame.origin.y + textLable.frame.size.height - profileImage.frame.size.height/2+10)
            
            profileImage.center = CGPoint(x: chatImage.frame.origin.x+30, y: chatImage.frame.height/2)
            
            //Setting Contact Name
            textLable.frame = CGRect(x: profileImage.center.x+35, y: profileImage.center.y-15, width: chatImage.frame.width-36, height: correctheight)
            
            
            
            //==uncomment if needed timeLabel.frame = CGRectMake(36 + distanceFactor, timeLabel.frame.origin.y, timeLabel.frame.size.width, timeLabel.frame.size.height)
            
            // timeLabel.frame = CGRect(x: 36 + distanceFactor, y: textLable.frame.origin.y+textLable.frame.height, width: chatImage.frame.size.width-46, height: timeLabel.frame.size.height)
            timeLabel.frame = CGRect(x: profileImage.center.x+35, y: textLable.frame.origin.y+textLable.frame.height, width: chatImage.frame.size.width-46, height: timeLabel.frame.size.height)
            
            deliveredLabel.frame = CGRect(x: deliveredLabel.frame.origin.x, y: textLable.frame.origin.y + textLable.frame.size.height + 15, width: deliveredLabel.frame.size.width, height: deliveredLabel.frame.size.height)
            
            
            
            
            //print("date received in chat post 2 is \(date2.debugDescription)")
            // //print("date received in chat is \(date2.debugDescription)")
            let formatter = DateFormatter();
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS";
            //formatter.dateFormat = "MM/dd hh:mm a";
            formatter.timeZone = TimeZone.autoupdatingCurrent
            let defaultTimeZoneStr = formatter.date(from: date2 as! String)
            //print("defaultTimeZoneStr \(defaultTimeZoneStr)")
            
            if(defaultTimeZoneStr == nil)
            {
                timeLabel.text=date2 as! String
                
            }
            else
            {
                let formatter2 = DateFormatter();
                formatter2.timeZone=TimeZone.autoupdatingCurrent
                formatter2.dateFormat = "MM/dd hh:mm a";
                let displaydate=formatter2.string(from: defaultTimeZoneStr!)
                //formatter.dateFormat = "MM/dd hh:mm a";
                
                let status=messageDic["status"] as NSString!
                timeLabel.text="\(displaydate) (\(status!))"
            }
        
            audioFilePlayName=msg! as! String
            
            let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(ChatDetailViewController.BtnPlayAudioClicked(_:)))
            //Add the recognizer to your view.
            
            cell.contentView.addGestureRecognizer(tapRecognizer)
           
            
            
            
            //local date already shortened then added to dictionary when post button is pressed
            //timeLabel.text=date2.debugDescription
        }
        if (msgType?.isEqual(to: "13"))!{
            cell = ///tblForChats.dequeueReusableCellWithIdentifier("ChatReceivedCell")! as UITableViewCell
                
                //FileImageReceivedCell
                tblForChats.dequeueReusableCell(withIdentifier: "LocationReceivedCell")! as UITableViewCell
            
            //=== uncomment   cell.tag = indexPath.row
            
            let deliveredLabel = cell.viewWithTag(13) as! UILabel
            let textLable = cell.viewWithTag(12) as! UILabel
            let timeLabel = cell.viewWithTag(11) as! UILabel
            let chatImage = cell.viewWithTag(1) as! UIImageView
            let profileImage = cell.viewWithTag(2) as! UIImageView
            
            let progressView = cell.viewWithTag(14) as! KDCircularProgress!
            
            //////chatImage.contentMode = .Center
            
            //chatImage.frame = CGRectMake(80, chatImage.frame.origin.y, 220, 220)
            /*let documentDirectory = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first as String!
             let photoURL          = NSURL(fileURLWithPath: documentDirectory)
             let imgPath         = photoURL.URLByAppendingPathComponent(msg as! String)
             
             */
            let status=messageDic["status"] as NSString!
            print("components now seperating by : \(msg!)")
            let contactinfo=msg!.components(separatedBy: ":") ///return array string
            var latitude = contactinfo[0]
            var longitude = contactinfo[1]
            //===     print("imgNSData is \(imgNSData)")
            //var imgNSData=NSFileManager.default.contents(atPath:imgPath.path!)
            //print("hereee imgPath.path! is \(imgPath)")
            
            
            let formatter = DateFormatter();
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS";
            //formatter.dateFormat = "MM/dd hh:mm a";
            formatter.timeZone = TimeZone.autoupdatingCurrent
            let defaultTimeZoneStr = formatter.date(from: date2 as! String)
            //print("defaultTimeZoneStr \(defaultTimeZoneStr)")
            
            let formatter2 = DateFormatter();
            formatter2.timeZone=TimeZone.autoupdatingCurrent
            formatter2.dateFormat = "MM/dd hh:mm a";
            let displaydate=formatter2.string(from: defaultTimeZoneStr!)
            
            var url=URL.init(string: "http://maps.google.com/maps/api/staticmap?center=\(latitude),\(longitude)&zoom=18&size=500x300&sensor=TRUE_OR_FALSE&key=AIzaSyDdmboY4sJuQi0arQAcAebJrvNjdDXACfQ")
            let resource = ImageResource(downloadURL: url!, cacheKey: "\(uniqueidDictValue)")
            chatImage.kf.setImage(with: resource)
            textLable.text=msg! as! String
            textLable.isHidden=true

            timeLabel.text="\(displaydate) (\(status))" /* var imgNSURL = NSURL(fileURLWithPath: msg as String)
             var imgNSData=NSFileManager.default.contents(atPath:imgNSURL.path!)
             if(imgNSData != nil)
             {
             chatImage.image = UIImage(contentsOfFile: msg as String)
             //print("file shownnnnnnnnn")
             }
             */
        }
        if (msgType?.isEqual(to: "14"))!{
            cell = ///tblForChats.dequeueReusableCellWithIdentifier("ChatReceivedCell")! as UITableViewCell
                
                //FileImageReceivedCell
                tblForChats.dequeueReusableCell(withIdentifier: "LocationSentCell")! as UITableViewCell
            
            //=====cell.tag = indexPath.row
            
            let deliveredLabel = cell.viewWithTag(13) as! UILabel
            let textLable = cell.viewWithTag(12) as! UILabel
            let timeLabel = cell.viewWithTag(11) as! UILabel
            let chatImage = cell.viewWithTag(1) as! UIImageView
            let profileImage = cell.viewWithTag(2) as! UIImageView
            let progressView = cell.viewWithTag(14) as! KDCircularProgress!
            
         
            timeLabel.frame = CGRect(x: chatImage.frame.origin.x, y: chatImage.frame.origin.y+180, width: chatImage.frame.width,  height: timeLabel.frame.height)
            
            
            let formatter = DateFormatter();
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS";
            //formatter.dateFormat = "MM/dd hh:mm a";
            formatter.timeZone = TimeZone.autoupdatingCurrent
            let defaultTimeZoneStr = formatter.date(from: date2 as! String)
            //print("defaultTimeZoneStr \(defaultTimeZoneStr)")
            
            var displaydate=""
            if(defaultTimeZoneStr == nil)
            {
                displaydate=date2 as! String
                
            }
            else
            {
                let formatter2 = DateFormatter();
                formatter2.timeZone=TimeZone.autoupdatingCurrent
                formatter2.dateFormat = "MM/dd hh:mm a";
                let displaydate=formatter2.string(from: defaultTimeZoneStr!)
                //formatter.dateFormat = "MM/dd hh:mm a";
                
               // timeLabel.text=displaydate
            }
        print("components now seperating by : \(msg!)")
            let contactinfo=msg!.components(separatedBy: ":") ///return array string
            var latitude = contactinfo[0]
            //var longitude = contactinfo[1]
            
            //coz message has mag+ \(status)
            print("components now seperating by space \(contactinfo[1])")
            var longitude = contactinfo[1].components(separatedBy: " ")[0]
          ////  var longitude = contactinfo[1]
          ///  var url=URL.init("http://maps.google.com/maps/api/staticmap?center=\(latitude) , \(longitude) &zoom=18&size=500x300&sensor=TRUE_OR_FALSE")
            var url=URL.init(string: "http://maps.google.com/maps/api/staticmap?center=\(latitude),\(longitude)&zoom=18&size=500x300&sensor=TRUE_OR_FALSE")
            
            print("\(latitude)    \(longitude)")
            
           //// var url=URL.init(string:"https://maps.googleapis.com/maps/api/staticmap?center=\(latitude),\(longitude)&zoom=12&size=100x100&key=AIzaSyA4ayZ7WiMRkulzF6OxZhBa8WXp7w4BkhI")
            let resource = ImageResource(downloadURL: url!, cacheKey: "\(uniqueidDictValue)")
            chatImage.kf.setImage(with: resource)
            textLable.text=msg! as! String
            textLable.isHidden=true
            timeLabel.text="\(displaydate) \(status!)"
         
        }

        
        
        //let resource = ImageResource(downloadURL: url, cacheKey: "my_cache_key")
        //imageView.kf.setImage(with: resource)
        
        /*
         do {
         audioPlayer = try AVAudioPlayer(contentsOfURL: CatSound)
         audioPlayer.prepareToPlay()
         } catch {
         print("Problem in getting File")
         }
         audioPlayer.play()
 */
        return cell
           }
    
    var contactreceivedphone=""
    func BtnInviteContactClicked(_ sender:UIButton)
    {
        let messageVC = MFMessageComposeViewController()
        
        messageVC.body = "Hey, \n \n I just downloaded KiboChat App on my iPhone. \n \n It is a smartphone messenger with added features. It provides integrated and unified voice, video, and data communication. \n \n It is available for both Android and iPhone and there is no PIN or username to remember. \n \n Get it now from https://api.cloudkibo.com and say good-bye to SMS!".localized;
        
        var cell=sender.superview?.superview?.superview as! UITableViewCell
        var indexPath=tblForChats.indexPath(for: cell)
        print("save new contact clicked")
        let contact = CNMutableContact()
        var rowselected=indexPath?.row
        var messageDic = messages.object(at: rowselected!) as! [String : String];
        let msg = messageDic["message"] as NSString!
        
        //sender.tag=15
        
        let contactinfo=msg?.components(separatedBy: ":") ///return array string
        //textLable.text = contactinfo[0]
        //contactreceivedphone=(contactinfo?[1])!
        
        //var phonevalue=sender.value(forKey: "phone")
        //var phoneIdentifier=sqliteDB.getIdentifierFRomPhone((contactinfo?[1])!)
        messageVC.recipients = [(contactinfo?[1])!]
        
        //!!messageVC.recipients = [contactreceivedphone]
        messageVC.messageComposeDelegate = self;
        
        self.present(messageVC, animated: false, completion: nil)
        
        
       // let next = self.storyboard?.instantiateViewController(withIdentifier: "Main4") as! ContactsInviteViewController
        //next.sendType="Message"
        //self.present(next,animated:true,completion:nil)
        
    }
    func BtnSaveContactClicked(_ sender:UIButton)
    {
        var cell=sender.superview?.superview?.superview as! UITableViewCell
        var indexPath=tblForChats.indexPath(for: cell)
        print("save new contact clicked")
        let contact = CNMutableContact()
        var rowselected=indexPath?.row
        var messageDic = messages.object(at: rowselected!) as! [String : String];
        let msg = messageDic["message"] as NSString!
        
        //sender.tag=15
        
        let contactinfo=msg?.components(separatedBy: ":") ///return array string
        //textLable.text = contactinfo[0]
        //contactreceivedphone=(contactinfo?[1])!
        
        //var phonevalue=sender.value(forKey: "phone")
        var phoneIdentifier=sqliteDB.getIdentifierFRomPhone((contactinfo?[1])!)
      //var phoneIdentifier=sqliteDB.getIdentifierFRomPhone(contactreceivedphone)
        if(phoneIdentifier != nil)
        {
            
        }
        else{
            
        }
        contact.phoneNumbers = [CNLabeledValue(
            label:CNLabelPhoneNumberiPhone,
           // value:CNPhoneNumber(stringValue:contactreceivedphone))]
             value:CNPhoneNumber(stringValue:(contactinfo?[1])!))]
        let contactViewController = CNContactViewController(forNewContact: contact)
        contactViewController.delegate=self
        //var contactDetailShow=CNContactViewControllr.init(contact)
        self.navigationController!.pushViewController(contactViewController,animated: false)
    }
    
    func BtnPlayAudioClicked(_ gestureRecognizer: UITapGestureRecognizer)
    {
        let tappedAudioView = gestureRecognizer.view! as! UIView
        let textLable = tappedAudioView.viewWithTag(12) as! UILabel
        print("playing audio.. \(textLable.text!)")
        
        let dirPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let docsDir1 = dirPaths[0]
        var documentDir=docsDir1 as NSString
        //var audiopath=documentDir.appendingPathComponent(audioFilePlayName)
        var audiopath=documentDir.appendingPathComponent(textLable.text!)
        do{
            
            audioPlayer=try AVAudioPlayer.init(contentsOf: URL.init(fileURLWithPath: audiopath))
            print("playing now... \(textLable.text!)")
        audioPlayer.play()
        }
        catch{
            print("invalid audio file")
            //sender.isUserInteractionEnabled=false
            

        }
        
         }
    
    func contactViewController(_ viewController: CNContactViewController, didCompleteWith contact: CNContact?) {
        
        /*
        DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.background).async
            {
                syncServiceContacts.startSyncService()
        }
        */
        print("inside cncontatc didcomplete....")
        self.dismiss(animated: true, completion:{ ()-> Void in
            
        //=----------
        
        viewController.displayedPropertyKeys=[CNContactGivenNameKey]
        if(contact != nil){
        UtilityFunctions.init().AddtoAddressBook(contact!,isKibo: true) { (result) in
            
            if(result==true)
            {
                if(self.showKeyboard==true)
                {
                    self.textFieldShouldReturn(self.txtFldMessage)
                    //uncomment later
                    /*var duration : NSTimeInterval = 0
                     
                     
                     UIView.animateWithDuration(duration, delay: 0, options:[], animations: {
                     self.chatComposeView.frame = CGRectMake(self.chatComposeView.frame.origin.x, self.chatComposeView.frame.origin.y + self.keyheight-self.chatComposeView.frame.size.height-3, self.chatComposeView.frame.size.width, self.chatComposeView.frame.size.height)
                     self.tblForChats.frame = CGRectMake(self.tblForChats.frame.origin.x, self.tblForChats.frame.origin.y, self.tblForChats.frame.size.width, self.tblForChats.frame.size.height + self.keyFrame.size.height-49);
                     }, completion: nil)
                     self.showKeyboard=false
                     */
                }
                
                if(self.messages.count>1)
                {
                    //var indexPath = NSIndexPath(forRow:self.messages.count-1, inSection: 0)
                    let indexPath = IndexPath(row:self.tblForChats.numberOfRows(inSection: 0)-1, section: 0)
                     print("scrollinggg 4044 line")
                    self.tblForChats.scrollToRow(at: indexPath, at: UITableViewScrollPosition.bottom, animated: false)
                }

              //  self.refreshChatsUI(nil, uniqueid: <#T##String!#>, from: <#T##String!#>, date1: <#T##Date!#>, type: <#T##String!#>)
            }
        }
            
        }
        else{
            print("no contact selected")          }
             });
        
        
        //self.navigationController!.popViewController(animated: true)
       // self.dismiss(animated: true, completion:{ ()-> Void in
            if(self.showKeyboard==true)
            {
                self.textFieldShouldReturn(self.txtFldMessage)
                //uncomment later
                /*var duration : NSTimeInterval = 0
                 
                 
                 UIView.animateWithDuration(duration, delay: 0, options:[], animations: {
                 self.chatComposeView.frame = CGRectMake(self.chatComposeView.frame.origin.x, self.chatComposeView.frame.origin.y + self.keyheight-self.chatComposeView.frame.size.height-3, self.chatComposeView.frame.size.width, self.chatComposeView.frame.size.height)
                 self.tblForChats.frame = CGRectMake(self.tblForChats.frame.origin.x, self.tblForChats.frame.origin.y, self.tblForChats.frame.size.width, self.tblForChats.frame.size.height + self.keyFrame.size.height-49);
                 }, completion: nil)
                 self.showKeyboard=false
                 */
            }
            
            if(self.messages.count>1)
            {
                //var indexPath = NSIndexPath(forRow:self.messages.count-1, inSection: 0)
               // let indexPath = IndexPath(row:self.tblForChats.numberOfRows(inSection: 0)-1, section: 0)
                
                let indexPath = IndexPath(row:self.tblForChats.numberOfRows(inSection: 0)-1, section: 0)
                
                 print("scrollinggg 4082 line")
                self.tblForChats.scrollToRow(at: indexPath, at: UITableViewScrollPosition.bottom, animated: false)
            }
        self.navigationController!.popViewController(animated: true)
        //})
    }
   /* override func encodeRestorableStateWithCoder(coder: NSCoder) {
        //1
     
        //coder.encode
        if let messages = messages {
            coder.encodeObject(messages, forKey: "messages")
        }
     
        //2
        super.encodeRestorableStateWithCoder(coder)
    }
    
    override func decodeRestorableStateWithCoder(coder: NSCoder) {
        messages = coder.decodeObjectForKey("messages") as! NSMutableArray
        
        super.decodeRestorableStateWithCoder(coder)
    }
    
    override func applicationFinishedRestoringState() {
        guard let messages = messages else { return }
        //tblForChats.reloadData()
        //messages = MatchedPetsManager.sharedManager.petForId(petId)
    }
    */
    
    
    
    //func contactTapped(_ gestureRecognizer: UITapGestureRecognizer) {
    
    //longPressedRecord
    
    //PanDraggedRecord
    func PanDraggedRecord(_ gestureRecognizer: UIPanGestureRecognizer) {
    print("inside PanDraggedRecord")
        if(gestureRecognizer.state == UIGestureRecognizerState.ended)
        {
            print("PanDraggedRecord ended")
        }
    }
    
    func longPressedRecord(_ gestureRecognizer: UILongPressGestureRecognizer) {
        print("long pressed state \(gestureRecognizer.state.rawValue)")
        var locationButton=gestureRecognizer.location(in: btnSendAudio)
        print("locationButton \(locationButton.x)")
        /*(if(locationButton.x<0)
        {
            swipe=true
        }
        else{
            swipe=false
        }*/
        if (gestureRecognizer.state == UIGestureRecognizerState.ended) {
            print("long pressed ended")
            if(locationButton.x>0){
            txtFldMessage.text=""
            print("btnRecordTouchUpInside")
            finishRecording(success: true)
            }
            else{
                finishRecording(success: false)
                var deleted=audioRecorder.deleteRecording()
                print("audio deleted \(deleted)")
                txtFldMessage.text=""
                //not saved
                //finishRecording(success: false)
            }
            
            
        }
        if (gestureRecognizer.state == UIGestureRecognizerState.began) {
 print("long pressed")
// print("btnRecordTouchDown")
 txtFldMessage.text="< Slide left to cancel".localized
 self.startRecording()
        }
 }/*
   // func longPressedRecord(_ button: UIButton) {
        /*if (gestureRecognizer.state == UIGestureRecognizerState.){
            print("longCancelled")
            finishRecording(success: false)
            var deleted=audioRecorder.deleteRecording()
            //print("audio deleted \(deleted)")
            txtFldMessage.text=""

        }*/
        /*if (gestureRecognizer.state == UIGestureRecognizerState.ended) {
            print("long pressed ended")
            txtFldMessage.text=""
            print("btnRecordTouchUpInside")
            finishRecording(success: true)
            
            
        }*/
        /*else{
            print("long pressed")
            print("btnRecordTouchDown")
            txtFldMessage.text="< Slide left to cancel"
            self.startRecording()
            
        }*/
        
    }
 */
    func contactTapped(_ button: UIButton) {
        print("contact title tapped \(self.selectedContact)")
        //tappedImageView will be the image view that was tapped.
        //dismiss it, animate it off screen, whatever.
        //let tappedImageView = gestureRecognizer.view! as! UIImageView
        //selectedImage=tappedImageView.image
        self.performSegue(withIdentifier: "contactdetailsinfosegue", sender: nil);
        
    }
    
    
    
    func imageTapped(_ gestureRecognizer: UITapGestureRecognizer) {
        //tappedImageView will be the image view that was tapped.
        //dismiss it, animate it off screen, whatever.
        let tappedImageView = gestureRecognizer.view! as! UIImageView
        selectedImage=tappedImageView.image
         self.performSegue(withIdentifier: "showFullImageSegue", sender: nil);
        
    }
    func mapTapped(_ gestureRecognizer: UITapGestureRecognizer) {
        //tappedImageView will be the image view that was tapped.
        //dismiss it, animate it off screen, whatever.
        //let tappedImageView = gestureRecognizer.view! as! UIImageView
        //selectedImage=tappedImageView.image
        self.performSegue(withIdentifier: "MapViewSegue", sender: nil);
        
    }
    func videoTapped(_ gestureRecognizer: UITapGestureRecognizer) {
        //tappedImageView will be the image view that was tapped.
        //dismiss it, animate it off screen, whatever.
        let tappedVideoView = gestureRecognizer.view! as! UIView
        let videonameLabel=tappedVideoView.viewWithTag(1) as! UILabel
        let dirPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let docsDir1 = dirPaths[0]
        var documentDir=docsDir1 as NSString
        var videoPath=documentDir.appendingPathComponent(videonameLabel.text!)
        
        let player = AVPlayer(url: URL.init(fileURLWithPath: videoPath))
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        contactshared=false
        self.present(playerViewController, animated: true) {
            
       //  self.performSegue(withIdentifier: "showFullImageSegue", sender: nil);
        
    }
      
    }
    
    func contactSharedTapped(_ gestureRecognizer: UITapGestureRecognizer) {
        //tappedImageView will be the image view that was tapped.
        //dismiss it, animate it off screen, whatever.
        var cell = gestureRecognizer.view?.superview?.superview as! UITableViewCell
        var indexPath=tblForChats.indexPath(for: cell as! UITableViewCell)
        print("get contact info shared")
        let contact = CNMutableContact()
        var rowselected=indexPath?.row
        var messageDic = messages.object(at: rowselected!) as! [String : String];
        let msg = messageDic["message"] as NSString!
        
        //sender.tag=15
        
        let contactinfo=msg?.components(separatedBy: ":") ///return array string
        //textLable.text = contactinfo[0]
        //contactreceivedphone=(contactinfo?[1])!
        
        //var phonevalue=sender.value(forKey: "phone")
       // var phoneIdentifier=sqliteDB.getIdentifierFRomPhone((contactinfo?[1])!)
        self.contactCardSelected=(contactinfo?[1])!
        contactshared=true
        
        self.performSegue(withIdentifier: "contactdetailsinfosegue", sender: nil);

    }
    
    func docTapped(_ gestureRecognizer: UITapGestureRecognizer) {
        //tappedImageView will be the image view that was tapped.
        //dismiss it, animate it off screen, whatever.
        //print("docTapped hereee")
        
        let tappedImageView = gestureRecognizer.view! as! UIImageView
        //selectedImage=tappedImageView.image
        self.performSegue(withIdentifier: "showFullDocSegue", sender: nil);
        
    }
    
    
    func applicationDidBecomeActive(_ notification : Notification)
    {print("app active chat details view")
       //print("didbecomeactivenotification=========")
      //  NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("applicationWillResignActive:"), name:UIApplicationWillResignActiveNotification, object: nil)
        
        //
     //   NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("applicationDidBecomeActive:"), name:UIApplicationDidBecomeActiveNotification, object: nil)
          NotificationCenter.default.removeObserver(self, name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ChatDetailViewController.willShowKeyBoard(_:)), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        
 
        delegateRefreshChat=self
       //// NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("willHideKeyBoard:"), name:UIKeyboardWillHideNotification, object: nil)
    }
    func applicationWillResignActive(_ notification : Notification){
        /////////self.view.endEditing(true)
        //print("applicationWillResignActive=========")
         NotificationCenter.default.removeObserver(self, name:NSNotification.Name.UIKeyboardWillShow, object: nil)
    
    }
    @IBOutlet weak var viewForContent: UIScrollView!
    func willShowKeyBoard(_ notification : Notification){
       
        
        
        /*let info = notification.userInfo as! [String: AnyObject],
        kbSize = (info[UIKeyboardFrameBeginUserInfoKey] as! NSValue).CGRectValue().size,
        contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: kbSize.height, right: 0)
        
        self.tblForChats.contentInset = contentInsets
        self.tblForChats.scrollIndicatorInsets = contentInsets
        
        // If active text field is hidden by keyboard, scroll it so it's visible
        // Your app might not need or want this behavior.
        var aRect = self.view.frame
        aRect.size.height -= kbSize.height
        
        if !CGRectContainsPoint(aRect, chatComposeView!.frame.origin) {
            self.tblForChats.scrollRectToVisible(chatComposeView!.frame, animated: true)
        }
        */
        //print("showkeyboardNotification============")
        
        if(showKeyboard==false)
        {
            
            var userInfo: NSDictionary!
            userInfo = notification.userInfo as NSDictionary!
            
            var duration : TimeInterval = 0
            var curve = userInfo.object(forKey: UIKeyboardAnimationCurveUserInfoKey) as! UInt
            duration = userInfo[UIKeyboardAnimationDurationUserInfoKey]as! TimeInterval
            let keyboardF:NSValue = userInfo.object(forKey: UIKeyboardFrameEndUserInfoKey)as! NSValue
            let keyboardFrame = keyboardF.cgRectValue
            print("keyboard y is \(keyboardFrame.origin.y)")
            
            if(keyheight==nil)
            {
                keyheight=keyboardFrame.size.height
            }
            if(keyFrame==nil)
            {
                keyFrame=keyboardFrame
            }
            
            print("keyboard height is \(keyheight)")
            
     
            
            if(messages.count>0)
{
            let lastind=IndexPath.init(index: self.messages.count)
            let rectOfCellInTableView = tblForChats.rectForRow(at: lastind)
            let rectOfCellInSuperview = tblForChats.convert(rectOfCellInTableView, to: nil)
            print("last cell pos y is \(tblForChats.visibleCells.last?.frame.origin.y)")
            
            print("Y of Cell is: \(rectOfCellInSuperview.origin.y.truncatingRemainder(dividingBy: viewForContent.frame.height))")
            print("content offset is \(tblForChats.contentOffset.y)")
            
            cellY=(tblForChats.visibleCells.last?.frame.origin.y)!+(tblForChats.visibleCells.last?.frame.height)!
    
            }
            print("cellY is \(cellY)")
            
                     if(cellY>(keyboardFrame.origin.y/*+20*/))
            {
            UIView.animate(withDuration: duration, delay: 0, options:[], animations: {
                    self.viewForContent.contentOffset = CGPoint(x: 0, y: keyboardFrame.size.height)
                    
                    }, completion: nil)
            }else{
                UIView.animate(withDuration: duration, delay: 0, options:[], animations: {
                    let newY=self.chatComposeView.frame.origin.y-keyboardFrame.size.height
                    self.chatComposeView.frame=CGRect(x: self.chatComposeView.frame.origin.x,y: newY,width: self.chatComposeView.frame.width,height: self.chatComposeView.frame.height)
                   
                    //== self.viewForContent.contentOffset = CGPointMake(0, keyboardFrame.size.height)
                    
                    }, completion: nil)

}
            
           
            /*var userInfo: NSDictionary!
        userInfo = notification.userInfo
        
        var duration : NSTimeInterval = 0
        var curve = userInfo.objectForKey(UIKeyboardAnimationCurveUserInfoKey) as! UInt
        duration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSTimeInterval
        let keyboardF:NSValue = userInfo.objectForKey(UIKeyboardFrameEndUserInfoKey) as! NSValue
        let keyboardFrame = keyboardF.CGRectValue()
        
        if(keyheight==nil)
        {
        keyheight=keyboardFrame.size.height
        }
        if(keyFrame==nil)
        {
        keyFrame=keyboardFrame
        }
        
        
        UIView.animateWithDuration(duration, delay: 0, options:[], animations: {
            self.chatComposeView.frame = CGRectMake(self.chatComposeView.frame.origin.x, self.chatComposeView.frame.origin.y - self.keyheight+self.chatComposeView.frame.size.height+3, self.chatComposeView.frame.size.width, self.chatComposeView.frame.size.height)
            
            self.tblForChats.frame = CGRectMake(self.tblForChats.frame.origin.x, self.tblForChats.frame.origin.y, self.tblForChats.frame.size.width, self.tblForChats.frame.size.height-self.keyFrame.size.height+49);
            }, completion: nil)
        */
        showKeyboard=true
        
    }
    
   /*  tblForChats.reloadData()
        if(messages.count>1)
        {
            let indexPath = NSIndexPath(forRow:messages.count-1, inSection: 0)
            tblForChats.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Bottom, animated: false)
        }
 */
        
    }
    
    func willHideKeyBoard(_ notification : Notification){
       
       /*
        let contentInsets = UIEdgeInsetsZero
        self.tblForChats.contentInset = contentInsets
        self.tblForChats.scrollIndicatorInsets = contentInsets
        */
        
       var userInfo: NSDictionary!
         userInfo = notification.userInfo as NSDictionary!
         
         var duration : TimeInterval = 0
         var curve = userInfo.object(forKey: UIKeyboardAnimationCurveUserInfoKey) as! UInt
         duration = userInfo[UIKeyboardAnimationDurationUserInfoKey]as! TimeInterval
         let keyboardF:NSValue = userInfo.object(forKey: UIKeyboardFrameEndUserInfoKey) as! NSValue
         let keyboardFrame = keyboardF.cgRectValue
        
        
        
        
        if(cellY>(keyboardFrame.origin.y/*+20*/))
        {
            UIView.animate(withDuration: duration, delay: 0, options:[], animations: {
                self.viewForContent.contentOffset = CGPoint(x: 0, y: 0)
                
                }, completion:{ (true)-> Void in
                    self.showKeyboard=false
            })
        }else{
            UIView.animate(withDuration: duration, delay: 0, options:[], animations: {
                let newY=self.chatComposeView.frame.origin.y+keyboardFrame.size.height
                self.chatComposeView.frame=CGRect(x: self.chatComposeView.frame.origin.x,y: newY,width: self.chatComposeView.frame.width,height: self.chatComposeView.frame.height)
                
                //== self.viewForContent.contentOffset = CGPointMake(0, keyboardFrame.size.height)
                
                },completion:{ (true)-> Void in
                    self.showKeyboard=false
                })
        }

            
            
          //uncomment
        /* UIView.animateWithDuration(duration, delay: 0, options:[], animations: {
         self.viewForContent.contentOffset = CGPointMake(0, 0)
         
            }, completion:{ (true)-> Void in
        self.showKeyboard=false
        })*/
 
        /*
        var userInfo: NSDictionary!
        userInfo = notification.userInfo
        
        var duration : NSTimeInterval = 0
        var curve = userInfo.objectForKey(UIKeyboardAnimationCurveUserInfoKey) as! UInt
        duration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSTimeInterval
        let keyboardF:NSValue = userInfo.objectForKey(UIKeyboardFrameEndUserInfoKey) as! NSValue
        let keyboardFrame = keyboardF.CGRectValue()
        /////// keyheight=keyboardFrame.size.height
        
        UIView.animateWithDuration(duration, delay: 0, options:[], animations: {
            self.chatComposeView.frame = CGRectMake(self.chatComposeView.frame.origin.x, self.chatComposeView.frame.origin.y + self.keyheight-self.chatComposeView.frame.size.height-3, self.chatComposeView.frame.size.width, self.chatComposeView.frame.size.height)
            self.tblForChats.frame = CGRectMake(self.tblForChats.frame.origin.x, self.tblForChats.frame.origin.y, self.tblForChats.frame.size.width, self.tblForChats.frame.size.height + keyboardFrame.size.height-49);
            }, completion: nil)
        */
    }
  
    func textFieldShouldReturn (_ textField: UITextField!) -> Bool {
        
        textField.resignFirstResponder()
        let duration : TimeInterval = 0
        let keyboardFrame = keyFrame
        
       
        if(cellY>(keyboardFrame?.origin.y/*+20*/)!)
        {
            UIView.animate(withDuration: duration, delay: 0, options:[], animations: {
                self.viewForContent.contentOffset = CGPoint(x: 0, y: 0)
                
                }, completion:{ (true)-> Void in
                    self.showKeyboard=false
            })
        }else{
            UIView.animate(withDuration: duration, delay: 0, options:[], animations: {
                let newY=self.chatComposeView.frame.origin.y+(keyboardFrame?.size.height)!
                self.chatComposeView.frame=CGRect(x: self.chatComposeView.frame.origin.x,y: newY,width: self.chatComposeView.frame.width,height: self.chatComposeView.frame.height)
                
                //== self.viewForContent.contentOffset = CGPointMake(0, keyboardFrame.size.height)
                
                },completion:{ (true)-> Void in
                    self.showKeyboard=false
            })
        }
        
      //  var userInfo: NSDictionary!
       // userInfo = notification.userInfo
        
        /*
        var duration : NSTimeInterval = 0

        
        
        
        /*var userInfo: NSDictionary!
        userInfo = notification.userInfo
        
        var duration : NSTimeInterval = 0
        var curve = userInfo.objectForKey(UIKeyboardAnimationCurveUserInfoKey) as! UInt
        duration = userInfo[UIKeyboardAnimationDurationUserInfoKey]as! NSTimeInterval
        let keyboardF:NSValue = userInfo.objectForKey(UIKeyboardFrameEndUserInfoKey) as! NSValue
        var keyboardFrame = keyboardF.CGRectValue()
        
        UIView.animateWithDuration(duration, delay: 0, options:[], animations: {
            self.viewForContent.contentOffset = CGPointMake(0, 0)
            
            }, completion: nil)

        */
        
        UIView.animateWithDuration(duration, delay: 0, options:[], animations: {
            self.chatComposeView.frame = CGRectMake(self.chatComposeView.frame.origin.x, self.chatComposeView.frame.origin.y + self.keyheight-self.chatComposeView.frame.size.height-3, self.chatComposeView.frame.size.width, self.chatComposeView.frame.size.height)
            self.tblForChats.frame = CGRectMake(self.tblForChats.frame.origin.x, self.tblForChats.frame.origin.y, self.tblForChats.frame.size.width, self.tblForChats.frame.size.height + self.keyFrame.size.height-49);
            }, completion: nil)
        showKeyboard=false
*/
        
        
        
        //uncomment later if needed
        /*
        var duration : NSTimeInterval = 0
        
        UIView.animateWithDuration(duration, delay: 0, options:[], animations: {
            self.viewForContent.contentOffset = CGPointMake(0, 0)
            
            }, completion:{ (true)-> Void in
                self.showKeyboard=false
        })
        */
        return true
        
        
    }
    
    
    func randomStringWithLength (_ len : Int) -> NSString {
        
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        
        let randomString : NSMutableString = NSMutableString(capacity: len)
        
        for i in 0 ..< len{
            let length = UInt32 (letters.length)
            let rand = arc4random_uniform(length)
            randomString.appendFormat("%C", letters.character(at: Int(rand)))
        }
        
        return randomString
    }
    
    @IBAction func btnShareFileInChatPressed(_ sender: AnyObject)
    {
        let contactPickerViewController = CNContactPickerViewController()
        contactPickerViewController.delegate=self
        
        
        let shareMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        shareMenu.modalPresentationStyle=UIModalPresentationStyle.overCurrentContext
        
        
        let cameraAction = UIAlertAction(title: "Camera".localized, style: UIAlertActionStyle.default,handler: { (action) -> Void in
            
            let imagePicker=UIImagePickerController.init()
           /// imagePicker =  UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            
            self.present(imagePicker, animated: true, completion: nil)

        })
        
        let videoAction = UIAlertAction(title: "Share Video".localized, style: UIAlertActionStyle.default,handler: { (action) -> Void in
            
            let picker=UIImagePickerController.init()
            picker.delegate=self
           
            picker.allowsEditing = true;
            //picker.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
            // if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary))
            //  {
           
            //savedPhotosAlbum
            // picker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            //}
            picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
            picker.mediaTypes=["public.movie"]
            ////picker.mediaTypes=[kUTTypeMovie as NSString as String,kUTTypeMovie as NSString as String]
            //[self presentViewController:picker animated:YES completion:NULL];
            DispatchQueue.main.async
            { () -> Void in
              //  picker.addChildViewController(UILabel("hiiiiiiiiiiiii"))
                if(self.showKeyboard==true)
                {self.textFieldShouldReturn(self.txtFldMessage)
                }
                self.present(picker, animated: true, completion: nil)
                
            }
            
        
        })
        let photoAction = UIAlertAction(title: "Photo/Video Library".localized, style: UIAlertActionStyle.default,handler: { (action) -> Void in
            
            let picker=UIImagePickerController.init()
            picker.delegate=self
            
            picker.allowsEditing = true;
            //picker.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
            // if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary))
            //  {
            
            //savedPhotosAlbum
            // picker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            //}
            picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
            picker.mediaTypes=["public.image"]
            //var popview=picker.popoverPresentationController
            
            ////picker.mediaTypes=[kUTTypeMovie as NSString as String,kUTTypeMovie as NSString as String]
            //[self presentViewController:picker animated:YES completion:NULL];
            DispatchQueue.main.async
                { () -> Void in
                    //  picker.addChildViewController(UILabel("hiiiiiiiiiiiii"))
                    if(self.showKeyboard==true)
                    {self.textFieldShouldReturn(self.txtFldMessage)
                    }
                    self.present(picker, animated: true, completion: nil)
                    
            }
            
            
        })
        let documentAction = UIAlertAction(title: "Share Document".localized, style: UIAlertActionStyle.default, handler: { (action) -> Void in
            
            //print(NSOpenStepRootDirectory())
            ///var UTIs=UTTypeCopyPreferredTagWithClass("public.image", kUTTypeImage)?.takeRetainedValue() as! [String]
            
            //let importMenu = UIDocumentMenuViewController(documentTypes: [kUTTypeText as NSString as String, kUTTypeImage as String,"com.adobe.pdf","public.jpeg","public.html","public.content","public.data","public.item",kUTTypeBundle as String],
             //   inMode: .Import)
            
            let importMenu = UIDocumentMenuViewController(documentTypes: [kUTTypeText as NSString as String,"com.adobe.pdf","public.html",/*"public.content",*/"public.text",/*kUTTypeBundle as String,"com.apple.rtfd"*/"com.adobe.pdf","com.microsoft.word.doc","org.openxmlformats.wordprocessingml.document"],
                in: .import)
            ///////let importMenu = UIDocumentMenuViewController(documentTypes: UTIs, inMode: .Import)
            importMenu.delegate = self
            
            DispatchQueue.main.async { () -> Void in
                if(self.showKeyboard==true)
                {self.textFieldShouldReturn(self.txtFldMessage)
                }
                self.present(importMenu, animated: true, completion: nil)
                
                
            }

            
        })
        
        let locationAction = UIAlertAction(title: "Share Location".localized, style: UIAlertActionStyle.default,handler: { (action) -> Void in
            
            print("here share location prompt")
            
            
            let config = GMSPlacePickerConfig(viewport: nil)
            let placePicker = GMSPlacePicker(config: config)
            
            placePicker.pickPlace(callback: { (place, error) -> Void in
                if let error = error {
                    print("Pick Place error: \(error.localizedDescription)")
                    return
                }
                
                guard let place = place else {
                    print("No place selected")
                    return
                }
                
                print("Place name \(place.name)")
                print("Place address \(place.formattedAddress)")
                print("Place attributions \(place.coordinate)")
                var latitude=place.coordinate.latitude.description
                var longitude=place.coordinate.longitude.description
                self.sendCoordinates(latitude: latitude, longitude: longitude)
            })
            
            
            //self.locationManager.delegate=self
           /* self.locationManager.requestWhenInUseAuthorization()
            
            self.locationManager.startUpdatingLocation()
            
            //if(locationManager.location
         //  if(self.didFindMyLocation==true)
         //   {
                print("her in got permission")
            //self.locationManager.requestLocation()
           // self.locationManager(manager: self.locationm, didUpdateLocations: <#T##[CLLocation]#>)
            if(self.locationManager.location != nil)
            {self.sendCoordinates(location: self.locationManager.location!)}
            else{
                self.showError("Error", message: "Unable to read your location. Please check your internet connection", button1: "Ok")
            }
          //  }
            
*/
            
            
        })
        let contactAction = UIAlertAction(title: "Share Contact".localized, style: UIAlertActionStyle.default, handler: { (action) -> Void in
            
            
           // contactPickerViewController.predicateForEnablingContact = NSPredicate(format: "birthday != nil")
            
            self.present(contactPickerViewController, animated: true, completion: nil)
        
        })
        
        let cancelAction = UIAlertAction(title: "Cancel".localized, style: UIAlertActionStyle.cancel, handler:nil)
        
        shareMenu.addAction(cameraAction)
        shareMenu.addAction(photoAction)
        shareMenu.addAction(videoAction)
        shareMenu.addAction(documentAction)
        shareMenu.addAction(locationAction)
        shareMenu.addAction(contactAction)
        shareMenu.addAction(cancelAction)
        
        
        
        self.present(shareMenu, animated: true, completion: {
            
        })

        
        
        
        
        
        
        
        //................................
        
        /*
        //socketObj.socket.emit("logClient","\(username!) is sharing file with \(iamincallWith)")
        //print(NSOpenStepRootDirectory())
        ///var UTIs=UTTypeCopyPreferredTagWithClass("public.image", kUTTypeImage)?.takeRetainedValue() as! [String]
        
        let importMenu = UIDocumentMenuViewController(documentTypes: [kUTTypeText as NSString as String, kUTTypeImage as String,"com.adobe.pdf","public.jpeg","public.html","public.content","public.data","public.item",kUTTypeBundle as String],
                                                      inMode: .Import)
        ///////let importMenu = UIDocumentMenuViewController(documentTypes: UTIs, inMode: .Import)
        importMenu.delegate = self
        if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary))
        {
        importMenu.addOptionWithTitle("Photots and Movies", image: nil, order: UIDocumentMenuOrder.First) {
            var picker=UIImagePickerController.init()
            picker.delegate=self
            
            picker.allowsEditing = true;
           // if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary))
          //  {
                picker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            //}
            
            //[self presentViewController:picker animated:YES completion:NULL];
            DispatchQueue.main.async { () -> Void in
                self.presentViewController(picker, animated: true, completion: nil)
                
                
            }

            
        }
    }
        DispatchQueue.main.async { () -> Void in
            self.presentViewController(importMenu, animated: true, completion: nil)
            
            
        }
        */
    }
    
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
        print("inside contact selected")
        //navigationController?.popViewController(animated: true)
        //self.navigationController?.popViewController(animated: true)
       
            var name=contact.givenName
            print("selected contact is \(name)")
            var epcontact=EPContact.init(contact: contact)
            var phone=epcontact.getPhoneNumber()
            var fullname=epcontact.displayName()
        var msgbody=fullname+":"+phone
        print("msgbody is \(msgbody)")
               /* var randNum5=self.randomStringWithLength(5) as String
                
                let date1=Date()
                let calendar = Calendar.current
                let year=(calendar as NSCalendar).components(NSCalendar.Unit.year,from: date1).year
                let month=(calendar as NSCalendar).components(NSCalendar.Unit.month,from: date1).month
                let day=(calendar as NSCalendar).components(.day,from: date1).day
                let hr=(calendar as NSCalendar).components(NSCalendar.Unit.hour,from: date1).hour
                let min=(calendar as NSCalendar).components(NSCalendar.Unit.minute,from: date1).minute
                let sec=(calendar as NSCalendar).components(NSCalendar.Unit.second,from: date1).second
                print("\(randNum5) \(year) \(month) \(day) \(hr) \(min) \(sec)")
                //var uniqueID=randNum5+year+month+day+hr+min+sec
                var uniqueID="\(randNum5)\(year!)\(month!)\(day!)\(hr!)\(min!) \(sec!)"
        */
        var uniqueID=UtilityFunctions.init().generateUniqueid()
        
        
                var date=Date()
                var formatterDateSend = DateFormatter();
                formatterDateSend.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ";
                ///newwwwwwww
                ////formatterDateSend.timeZone = NSTimeZone.local()
                let dateSentString = formatterDateSend.string(from: date);
                
                
                var formatterDateSendtoDateType = DateFormatter();
                formatterDateSendtoDateType.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ";
                var dateSentDateType = formatterDateSendtoDateType.date(from: dateSentString)
                
                
                //2016-10-15T22:18:16.000
                var imParas=[String:String]()
                var imParas2=[[String:String]]()
                
                var statusNow=""
                statusNow="pending"
                
                
                if(selectedContact != "")
                {
                    imParas=["from":"\(username!)","to":"\(selectedContact)","fromFullName":"\(displayname)","msg":"\(msgbody)","uniqueid":"\(uniqueID)","type":"contact","file_type":"","status":statusNow,"date":"\(dateSentDateType!)"]
                    
                    
                    
                    sqliteDB.SaveChat("\(selectedContact)", from1: username!, owneruser1: username!, fromFullName1: displayname, msg1: msgbody, date1: dateSentDateType, uniqueid1: uniqueID, status1: statusNow, type1: "contact", file_type1: "", file_path1: "")
                    
                }
                else{
                    //save as broadcast message
                    for i in 0 ..< broadcastMembersPhones.count
                    {
                        imParas2.append(["from":"\(username!)","to":"\(broadcastMembersPhones[i])","fromFullName":"\(displayname)","msg":"\(msgbody)","uniqueid":"\(uniqueID)","type":"contact","file_type":"","status":statusNow,"date":"\(dateSentDateType!)"])
                        
                        
                        sqliteDB.SaveBroadcastChat("\(broadcastMembersPhones[i])", from1: username!, owneruser1: username!, fromFullName1: displayname, msg1: msgbody, date1: dateSentDateType, uniqueid1: uniqueID, status1: statusNow, type1: "contact", file_type1: "", file_path1: "", broadcastlistID1: broadcastlistID1)
                        //broadcastMembersPhones[i]
                    }
                }
                var formatter = DateFormatter();
                formatter.timeZone = TimeZone.autoupdatingCurrent
                formatter.dateFormat = "MM/dd hh:mm a";
                //formatter.dateStyle = .ShortStyle
                //formatter.timeStyle = .ShortStyle
                let defaultTimeZoneStr = formatter.string(from: date);
                let defaultTimeZoneStr2=formatter.date(from: defaultTimeZoneStr as! String)
                
                
                
                var msggg=msgbody
                
                
                //txtFldMessage.text = "";
        
                
                //DispatchQueue.main.async
                //{
                print("adding msg \(msggg)")
                
                //==--self.tblForChats.reloadRowsAtIndexPaths([lastrowindexpath], withRowAnimation: .None)
                self.addMessage(msggg/*+" (\(statusNow))"*/,status:statusNow,ofType: "8",date:defaultTimeZoneStr, uniqueid: uniqueID)
                
                self.tblForChats.reloadData()
                if(self.messages.count>1)
                {
                     print("scrollinggg 4771 line")
                    // let indexPath = NSIndexPath(forRow:self.messages.count-1, inSection: 0)
                    let indexPath = IndexPath(row:self.tblForChats.numberOfRows(inSection: 0)-1, section: 0)
                    self.tblForChats.scrollToRow(at: indexPath, at: UITableViewScrollPosition.bottom, animated: false)
                    
                    
                    
                }
                // }
                // })
                //  }
                
                
                //print("messages count before sending msg is \(self.messages.count)")
                print("sending msg \(msggg)")
                if(selectedContact != ""){
                    self.sendChatMessage(imParas){ (uniqueid,result) -> () in
                        
                        if(result==true)
                        {
                            var searchformat=NSPredicate(format: "uniqueid = %@",uniqueid!)
                            
                            var resultArray=self.messages.filtered(using: searchformat)
                            var ind=self.messages.index(of: resultArray.first!)
                            //cfpresultArray.first
                            //resultArray.first
                            var aa=self.messages.object(at: ind) as! [String:AnyObject]
                            var actualmsg=aa["message"] as! String
                            
                            self.updateChatStatusRow(aa["message"] as! String, uniqueid: aa["uniqueid"] as! String, status: aa["status"] as! String, filename: "", type: aa["type"] as! String, date: aa["date"] as! String,caption:"")
                            
                            
                            /*actualmsg=actualmsg.removeCharsFromEnd(10)
                            //var actualmsg=newmsg
                            aa["message"]="\(actualmsg) (sent)" as AnyObject?
                            self.messages.replaceObject(at: ind, with: aa)
                            //  self.messages.objectAtIndex(ind).message="\(self.messages[ind]["message"]) (sent)"
                            var indexp=IndexPath(row:ind, section:0)
                            DispatchQueue.main.async
                                {
                                    self.tblForChats.reloadData()
                            }
                            */
                        }
                        else
                        {
                            print("unable to send chat \(imParas)")
                        }
                    }
                }
                else{
                    print("here sending broadcast message")
                    var result1=false
                    var uniqueid1=""
                    var count=0
                    for i in 0 ..< imParas2.count
                    {
                        self.sendChatMessage(imParas2[i]){ (uniqueid,result) -> () in
                            count += 1
                            if(result==true && count==1){
                                var searchformat=NSPredicate(format: "uniqueid = %@",uniqueid!)
                                
                                var resultArray=self.messages.filtered(using: searchformat)
                                var ind=self.messages.index(of: resultArray.first!)
                                //cfpresultArray.first
                                //resultArray.first
                                var aa=self.messages.object(at: ind) as! [String:AnyObject]
                                var actualmsg=aa["message"] as! String
                                actualmsg=actualmsg.removeCharsFromEnd(10)
                                //var actualmsg=newmsg
                                aa["message"]="\(actualmsg) (sent)" as AnyObject?
                                self.messages.replaceObject(at: ind, with: aa)
                                //  self.messages.objectAtIndex(ind).message="\(self.messages[ind]["message"]) (sent)"
                                var indexp=IndexPath(row:ind, section:0)
                                self.tblForChats.beginUpdates()
                                self.tblForChats.reloadRows(at: [indexp], with: UITableViewRowAnimation.none)
                                self.tblForChats.endUpdates()
                                
                                /*DispatchQueue.main.async
                                    {
                                        self.tblForChats.reloadData()
                                        // print("messages count is \(self.messages.count)")
                                }*/
                            }
                        }}
                    
                    
                    /*  }
                     }*/
                }
                
                
                
                
        
    }
    
    
 
   /* func contactPicker(_ picker: CNContactPickerViewController, didSelect contacts: [CNContact])
    {
        
        for contactsfetched in contacts{
            var name=contactsfetched.givenName
            var phones=contactsfetched.phoneNumbers
            print("selected contact2 is \(name)")
            
            
        }
        
    }
    */
   /* func imagePickerController(  didFinishPickingMediaWithInfo info:NSDictionary!) {
        videoUrl = info[UIImagePickerControllerMediaURL] as! NSURL!
        let pathString = videoUrl.relativePath
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    */
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        print("in here imagepicker")
        let mediaType:AnyObject? = info[UIImagePickerControllerMediaType] as AnyObject?
        var videoURL=info[UIImagePickerControllerReferenceURL] as? URL
        if let type:AnyObject = mediaType {
            if type is String {
                let stringType = type as! String
                if stringType == kUTTypeMovie as! String {
                    let urlOfVideo = info[UIImagePickerControllerMediaURL] as! URL
                    print("url video is \(urlOfVideo)")
                    
                    
                    self.dismiss(animated: true, completion: { 
                        
                        self.sendVideo(urlOfVideoGetMetadata: videoURL!, urlOfVideoPath: urlOfVideo)
                        
                    })
                     /*if let url = urlOfVideo {
                        // 2
                        AssetsLibrary.writeVideoAtPathToSavedPhotosAlbum(url,
                                                                         completionBlock: {(url: NSURL!, error: NSError!) in
                                                                            if let theError = error{
                                                                                println("Error saving video = \(theError)")
                                                                            }
                                                                            else {
                                                                                println("no errors happened")
                                                                            }
                        })
                    }*/
                }
                else{
                    print("choosen type is not video")
                    if (picker.sourceType == UIImagePickerControllerSourceType.camera) {
                        print ("from camera")
                    }
                    
                     //!!  self.imagePickerController(picker, didFinishPickingImage: (info[UIImagePickerControllerOriginalImage] as? UIImage)!, editingInfo: info as [String : AnyObject]?)
                    
                    self.dismiss(animated: true, completion: {
                        
                        
                    
                    var labelcaption=""
                    let alert = UIAlertController(title: "Add caption".localized, message: "", preferredStyle: .alert)
                    
                    //2. Add the text field. You can configure it however you need.
                    alert.addTextField(configurationHandler: { (textField) -> Void in
                         self.imgCaption = ""
                        textField.text = ""
                    })
                    
                    
                    //3. Grab the value from the text field, and print it when the user clicks OK.
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                        let textField = alert.textFields![0] as UITextField
                        self.imgCaption = textField.text!
                       // let textField = alert.textFields![0] as UITextField
                       
                        self.imagePickerController(picker, didFinishPickingImage: (info[UIImagePickerControllerOriginalImage] as? UIImage)!, editingInfo: info as [String : AnyObject]?)
                        

                        if(self.showKeyboard==true)
                        {
                            self.textFieldShouldReturn(textField)
                            
                        }
                        
                        

                        
                    }))
                      self.present(alert, animated: true, completion: {
                                                                     })
                
                    })
                    
                   
                }
            }
        
        
    }
    }
    
    func sendVideo(urlOfVideoGetMetadata:URL,urlOfVideoPath:URL)
    { print("urlOfVideoGetMetadata is \(urlOfVideoGetMetadata) and urlOfVideoPath is \(urlOfVideoPath)")
        
        var furl=URL(string: urlOfVideoPath.absoluteString)
        //print(furl!.pathExtension!)
        //print(furl!.deletingLastPathComponent())
        var ftype=furl!.pathExtension
        var fname=furl!.deletingLastPathComponent()
        
        let result = PHAsset.fetchAssets(withALAssetURLs: [urlOfVideoGetMetadata], options: nil)
        var asset=result.firstObject! as PHAsset
        self.filename=asset.originalFilename!
        print("video assettype is \(asset.mediaType)")
    
     //   print("ext is \(asset.
        //asset.mediaType
        PHImageManager.default().requestAVAsset (forVideo: asset, options: nil) { (avasset, _, _) in
            var originalSizeStr: String?
            if let urlAsset = avasset as? AVURLAsset {
                let dict = try! urlAsset.url.resourceValues(forKeys: [URLResourceKey.fileSizeKey])
                //let size = dict. .allValues[URLResourceKey.fileSizeKey]// fileSize// [URLResourceKey.fileSizeKey] as! Int
                print("video metadata \(urlOfVideoGetMetadata) ...name is  \(self.filename) ... type is \(ftype) ")
            }
        }
        //==----self.file_name1 = (result.firstObject?.burstIdentifier)!
        // var myasset=result.firstObject as! PHAsset
        ////print(myasset.mediaType)
        print("original filename of video is \(self.filename)")
        
        
        let shareMenu = UIAlertController(title: nil, message: "Send".localized+"  \(filename) "+"?".localized/* to \(selectedFirstName) ? "*/, preferredStyle: .actionSheet)
        shareMenu.modalPresentationStyle=UIModalPresentationStyle.overCurrentContext
        let confirm = UIAlertAction(title: "Yes", style: UIAlertActionStyle.default,handler: { (action) -> Void in
            
            socketObj.socket.emit("logClient","IPHONE-LOG: \(username!) selected image ")
            //print("file gotttttt")
           //// var furl=URL(string: urlOfVideo)
         
        

            
            let dirPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
            let docsDir1 = dirPaths[0]
            var documentDir=docsDir1 as NSString
            var filePathImage2=documentDir.appendingPathComponent(self.filename)
            var fm=FileManager.default
            
            var fileAttributes:[String:AnyObject]=["":"" as AnyObject]
       
            var s=fm.createFile(atPath: filePathImage2, contents: nil, attributes: nil)
            
            //  var written=fileData!.writeToFile(filePathImage2, atomically: false)
            
            //filePathImage2
            do{var data=try Data.init(contentsOf: urlOfVideoPath)
            try? data.write(to: URL(fileURLWithPath: filePathImage2), options: [.atomic])
            // data!.writeToFile(localPath.absoluteString, atomically: true)
            }
            catch{
                print("cannot write file \(error)")
                self.showError("Error".localized, message: "Unable to get video".localized, button1: "Ok".localized)
            }
            
          /*  let calendar = Calendar.current
            let comp = (calendar as NSCalendar).components([.hour, .minute], from: Date())
            let year = String(describing: comp.year)
            let month = String(describing: comp.month)
            let day = String(describing: comp.day)
            let hour = String(describing: comp.hour)
            let minute = String(describing: comp.minute)
            let second = String(describing: comp.second)
            
            
            var randNum5=self.randomStringWithLength(5) as String
            var uniqueID=randNum5+year+month+day+hour+minute+second
            */
            var uniqueID=UtilityFunctions.init().generateUniqueid()
            print("uniqueid video is \(uniqueID)")
            var statusNow="pending"
            
            var imParas=["from":"\(username!)","to":"\(self.selectedContact)","fromFullName":"\(displayname)","msg":self.filename,"uniqueid":uniqueID,"type":"file","file_type":"video","status":statusNow]
            //print("imparas are \(imParas)")
            
            
            //------
           
        
            sqliteDB.saveFile(self.selectedContact, from1: username!, owneruser1: username!, file_name1: self.filename, date1: nil, uniqueid1: uniqueID, file_size1: "\(self.fileSize1)", file_type1: ftype, file_path1: filePathImage2, type1: "video",caption1:self.imgCaption)
            
            self.addUploadInfo(self.selectedContact,uniqueid1: uniqueID, rowindex: self.messages.count, uploadProgress: 0.0, isCompleted: false)
            
                if(self.selectedContact != "")
                {   sqliteDB.SaveChat(self.selectedContact, from1: username!, owneruser1: username!, fromFullName1: displayname, msg1: self.filename, date1: nil, uniqueid1: uniqueID, status1: statusNow, type1: "file", file_type1: "video", file_path1: filePathImage2)
                    
          
                    
                    managerFile.uploadFile(filePathImage2, to1: self.selectedContact, from1: username!, uniqueid1: uniqueID, file_name1: self.filename, file_size1: "\(self.fileSize1)", file_type1: ftype,type1:"video",label1:"")
            }else{
                    for i in 0 ..< self.broadcastMembersPhones.count
                    {
                        //imParas2.append(["from":"\(username!)","to":"\(broadcastMembersPhones[i])","fromFullName":"\(displayname)","msg":"\(msgbody)","uniqueid":"\(uniqueID)","type":"location","file_type":"","date":"\(dateSentDateType!)"])
                        
                        
                        sqliteDB.SaveBroadcastChat("\(self.broadcastMembersPhones[i])", from1: username!, owneruser1: username!, fromFullName1: displayname, msg1: self.filename, date1: nil, uniqueid1: uniqueID, status1: statusNow, type1: "broadcast_file", file_type1: "video", file_path1: filePathImage2, broadcastlistID1: self.broadcastlistID1)
                        //broadcastMembersPhones[i]
                    }

                    
                managerFile.uploadBroadcastFile(filePathImage2, to1: self.broadcastMembersPhones, from1: username!, uniqueid1: uniqueID, file_name1: self.filename, file_size1: "\(self.fileSize1)", file_type1: ftype,type1:"video", totalmembers: "\(self.broadcastMembersPhones.count)")
            }
            self.retrieveChatFromSqlite(self.selectedContact,completion:{(result)-> () in
                DispatchQueue.main.async
                    {
                        self.tblForChats.reloadData()
                        
                        if(self.messages.count>1)
                        {
                             print("scrollinggg 5032 line")
                            //var indexPath = NSIndexPath(forRow:self.messages.count-1, inSection: 0)
                            let indexPath = IndexPath(row:self.tblForChats.numberOfRows(inSection: 0)-1, section: 0)
                            self.tblForChats.scrollToRow(at: indexPath, at: UITableViewScrollPosition.bottom, animated: false)
                        }
                }
            })
            self.dismiss(animated: true, completion:{ ()-> Void in
                
            })
    })
       // let notConfirm = UIAlertAction(title: "No", style: UIAlertActionStyle.cancel, handler: { (action) -> Void in
            
      //  })

       shareMenu.addAction(confirm)
        //shareMenu.addAction(notConfirm)
        self.present(shareMenu, animated: true) {
            
            
        }
        
        
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
        print("image pickerrr")
        
        var ftype=""
          //  var filesizenew=""
        var data:Data!=Data.init()
        if(picker.sourceType == UIImagePickerControllerSourceType.camera)
        {
        var imgCaptured = editingInfo?[UIImagePickerControllerOriginalImage] as? UIImage
            if(!(imgCaptured?.imageOrientation == UIImageOrientation.up ||
                imgCaptured?.imageOrientation == UIImageOrientation.upMirrored))
            {
                var imgsize = imgCaptured?.size;
                UIGraphicsBeginImageContext(imgsize!);
                imgCaptured?.draw(in: CGRect.init(x: 0.0, y: 0.0, width: (imgsize?.width)!, height:(imgsize?.height)!))
                imgCaptured = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
            }
            data              = UIImagePNGRepresentation(imgCaptured!)
            //UIImageWriteToSavedPhotosAlbum(img, Any?, Selector?, contextInfo: UnsafeMutableRawPointer?)
           // var assetRequest=PHAssetChangeRequest.creationRequestForAsset(from: imgCaptured!)
            
            var imageIdentifier=""
            PHPhotoLibrary.shared().performChanges({ () -> Void in
                let changeRequest = PHAssetChangeRequest.creationRequestForAsset(from: image)
                let placeHolder = changeRequest.placeholderForCreatedAsset
                imageIdentifier = (placeHolder?.localIdentifier)!
            }, completionHandler: { (success, error) -> Void in
                if success {
                    //completion(localIdentifier: imageIdentifier)
                    let result = PHAsset.fetchAssets(withLocalIdentifiers: [imageIdentifier], options: nil)
                    
                    var asset=result.firstObject! as PHAsset
                    
                    self.filename=asset.originalFilename!
                    print("camera filename is \(self.filename)")
                    
                    PHImageManager.default().requestImageData(for: result.firstObject!, options: nil, resultHandler: { _, _, _, info in
                        
                        if let filetype = (info?["PHImageFileURLKey"] as? NSURL)?.pathExtension {
                            ftype=filetype
                            
                            print("camera ftype is \(ftype)")
                        }
                    })
                    print("saved successfully")

                } else if let error = error {
                    print("Save photo failed with error")
                    
                }
                else {
                    print("Save photo failed with no error")
                }
            })
            
            
            
            
            
 
        }
        else
        {
        let imageUrl          = editingInfo![UIImagePickerControllerReferenceURL] as! URL
        let imageName         = imageUrl.lastPathComponent
        let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first as String!
        let photoURL          = URL(fileURLWithPath: documentDirectory!)
        let localPath         = photoURL.appendingPathComponent(imageName)
        let image             = editingInfo![UIImagePickerControllerOriginalImage]as! UIImage
        data              = UIImagePNGRepresentation(image)
       
        if let imageURL = editingInfo![UIImagePickerControllerReferenceURL] as? URL {
            let result = PHAsset.fetchAssets(withALAssetURLs: [imageURL], options: nil)
            
            PHImageManager.default().requestImageData(for: result.firstObject!, options: nil, resultHandler: { _, _, _, info in
                
                if let fileName1 = (info?["PHImageFileURLKey"] as? NSURL)?.lastPathComponent {
                    //do sth with file name
                    self.filename=fileName1
                    
                }
            })
         /////====-----------  self.filename = result.firstObject?.filename ?? ""
           
           // var myasset=result.firstObject as! PHAsset
            ////print(myasset.mediaType)
            
            
            
        }
            var furl=URL(string: localPath.absoluteString)
            
            //print(furl!.pathExtension!)
            //print(furl!.deletingLastPathComponent())
            ftype=furl!.pathExtension
        
            
        }
        let shareMenu = UIAlertController(title: nil, message: " Send \" \(filename) \" to \(selectedFirstName) ? ", preferredStyle: .actionSheet)
        shareMenu.modalPresentationStyle=UIModalPresentationStyle.overCurrentContext
        let confirm = UIAlertAction(title: "Yes", style: UIAlertActionStyle.default,handler: { (action) -> Void in
            
        socketObj.socket.emit("logClient","IPHONE-LOG: \(username!) selected image ")
        //print("file gotttttt")
      
       // var fname=furl!.deletingLastPathComponent()
        
        
        let dirPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let docsDir1 = dirPaths[0]
        var documentDir=docsDir1 as NSString
        var filePathImage2=documentDir.appendingPathComponent(self.filename)
        var fm=FileManager.default
       
        var fileAttributes:[String:AnyObject]=["":"" as AnyObject]
        do {
           let fileAttributes : NSDictionary? = try FileManager.default.attributesOfItem(atPath: filePathImage2) as NSDictionary?
            if let _attr = fileAttributes {
                self.fileSize1 = _attr.fileSize();
                print("........ filetype -- \(_attr.fileType())")
                //print("file size is \(self.fileSize1)")
                //// ***april 2016 neww self.fileSize=(fileSize1 as! NSNumber).integerValue
            }
        } catch {
            socketObj.socket.emit("logClient","IPHONE-LOG: error: \(error)")
            //print("Error:+++ \(error)")
        }
        

        //print("filename is \(self.filename) destination path is \(filePathImage2) image name \(imageName) imageurl \(imageUrl) photourl \(photoURL) localPath \(localPath).. \(localPath.absoluteString)")
        
            var s=fm.createFile(atPath: filePathImage2, contents: nil, attributes: nil)
        
      //  var written=fileData!.writeToFile(filePathImage2, atomically: false)
        
        //filePathImage2
        
         try? data!.write(to: URL(fileURLWithPath: filePathImage2), options: [.atomic])
      // data!.writeToFile(localPath.absoluteString, atomically: true)
        
            
            /*let calendar = Calendar.current
            let comp = (calendar as NSCalendar).components([.hour, .minute], from: Date())
            let year = String(describing: comp.year)
            let month = String(describing: comp.month)
            let day = String(describing: comp.day)
            let hour = String(describing: comp.hour)
            let minute = String(describing: comp.minute)
            let second = String(describing: comp.second)
            
            
            var randNum5=self.randomStringWithLength(5) as String
            var uniqueID=randNum5+year+month+day+hour+minute+second
            */var uniqueID=UtilityFunctions.init().generateUniqueid()
            
            
            var statusNow="pending"
            
            
            if(self.selectedContact != "")
            {
            var imParas=["from":"\(username!)","to":"\(self.selectedContact)","fromFullName":"\(displayname)","msg":self.filename,"uniqueid":uniqueID,"type":"file","file_type":"image","status":statusNow]
            //print("imparas are \(imParas)")
            
            
            //------
            sqliteDB.SaveChat(self.selectedContact, from1: username!, owneruser1: username!, fromFullName1: displayname, msg1: self.filename, date1: nil, uniqueid1: uniqueID, status1: statusNow, type1: "file", file_type1: "image", file_path1: filePathImage2)
            }
            else{
                //save as broadcast message
                //var imParas2=[[String:String]]()
                for i in 0 ..< self.broadcastMembersPhones.count
                {
                
                    //imParas2.append(["from":"\(username!)","to":"\(self.broadcastMembersPhones[i])","fromFullName":"\(displayname)","msg":self.filename,"uniqueid":uniqueID,"type":"file","file_type":"image","date":"\(Date())"])
                    
                    
                    sqliteDB.SaveBroadcastChat("\(self.broadcastMembersPhones[i])", from1: username!, owneruser1: username!, fromFullName1: displayname, msg1: self.filename, date1: Date(), uniqueid1: uniqueID, status1: statusNow, type1: "broadcast_file", file_type1: "image", file_path1: filePathImage2, broadcastlistID1: self.broadcastlistID1)
                    //broadcastMembersPhones[i]
                }
            }
            
            //do when upload finish
            //think about pending file
           /* socketObj.socket.emitWithAck("im",["room":"globalchatroom","stanza":imParas])(timeoutAfter: 150000)
            {data in
                
                //print("chat ack received  \(data)")
                statusNow="sent"
                var chatmsg=JSON(data)
                //print(data[0])
                //print(chatmsg[0])
                sqliteDB.UpdateChatStatus(chatmsg[0]["uniqueid"].string!, newstatus: chatmsg[0]["status"].string!)
                
                self.retrieveChatFromSqlite(self.selectedContact)
                //self.tblForChats.reloadData()
                
                
                
            }
            */
            
            //sqliteDB.SaveChat(self.selectedContact, from1: username!, owneruser1: username!, fromFullName1: displayname, msg1: self.filename, date1: nil, uniqueid1: uniqueID, status1: "pending", type1: "image", file_type1: ftype, file_path1: filePathImage2)
            
            
            
            
            sqliteDB.saveFile(self.selectedContact, from1: username!, owneruser1: username!, file_name1: self.filename, date1: nil, uniqueid1: uniqueID, file_size1: "\(self.fileSize1)", file_type1: ftype, file_path1: filePathImage2, type1: "image",caption1:self.imgCaption)
            
            self.addUploadInfo(self.selectedContact,uniqueid1: uniqueID, rowindex: self.messages.count, uploadProgress: 0.0, isCompleted: false)
            
            if(self.selectedContact != "")
            {
                managerFile.uploadFile(filePathImage2, to1: self.selectedContact, from1: username!, uniqueid1: uniqueID, file_name1: self.filename, file_size1: "\(self.fileSize1)", file_type1: ftype,type1:"image",label1:self.imgCaption)
         
            }
            else{
           // else use upload broadcast
            managerFile.uploadBroadcastFile(filePathImage2, to1: self.broadcastMembersPhones, from1: username!, uniqueid1: uniqueID, file_name1: self.filename, file_size1: "\(self.fileSize1)", file_type1: ftype,type1:"image", totalmembers: "\(self.broadcastMembersPhones.count)")
            }
            
            self.retrieveChatFromSqlite(self.selectedContact,completion:{(result)-> () in
               DispatchQueue.main.async
{
                self.tblForChats.reloadData()
                
                if(self.messages.count>1)
                {
                     print("scrollinggg 5259 line")
                    //var indexPath = NSIndexPath(forRow:self.messages.count-1, inSection: 0)
                    let indexPath = IndexPath(row:self.tblForChats.numberOfRows(inSection: 0)-1, section: 0)
                    self.tblForChats.scrollToRow(at: indexPath, at: UITableViewScrollPosition.bottom, animated: false)
                }
                }
            })
        self.dismiss(animated: true, completion:{ ()-> Void in
        
            if(self.showKeyboard==true)
            {
                 self.textFieldShouldReturn(self.txtFldMessage)
             
            }
            
            if(self.messages.count>1)
            {
                 print("scrollinggg 5276 line")
                //var indexPath = NSIndexPath(forRow:self.messages.count-1, inSection: 0)
                let indexPath = IndexPath(row:self.tblForChats.numberOfRows(inSection: 0)-1, section: 0)
                self.tblForChats.scrollToRow(at: indexPath, at: UITableViewScrollPosition.bottom, animated: false)
            }

        });
        
     
        
        })
        
        let notConfirm = UIAlertAction(title: "No".localized, style: UIAlertActionStyle.cancel, handler: { (action) -> Void in
            
                    })
        
        shareMenu.addAction(confirm)
        shareMenu.addAction(notConfirm)
        
        ////self.dismiss(animated: true, completion:{ ()-> Void in
            
            if(self.showKeyboard==true)
            {
                self.textFieldShouldReturn(self.txtFldMessage)
              
            }
            self.tblForChats.reloadData()
            if(self.messages.count>1)
            {
               // var indexPath = NSIndexPath(forRow:self.messages.count-1, inSection: 0)
                 print("scrollinggg 5306 line")
                let indexPath = IndexPath(row:self.tblForChats.numberOfRows(inSection: 0)-1, section: 0)
                self.tblForChats.scrollToRow(at: indexPath, at: UITableViewScrollPosition.bottom, animated: false)
                
            }
            
            self.present(shareMenu, animated: true) {
                
                
            }
            
       //// });
        

        
       /* self.presentViewController(shareMenu, animated: true) {
            
            
        }*/
   //// }
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("picker cancelled")
        DispatchQueue.main.async { () -> Void in
            self.dismiss(animated: true, completion: { ()-> Void in
                
                if(self.showKeyboard==true)
                {
                    print("hidinggg keyboard")
                    self.textFieldShouldReturn(self.txtFldMessage)
                   // uncomment later
                    /*var duration : NSTimeInterval = 0
                    
                    
                    UIView.animateWithDuration(duration, delay: 0, options:[], animations: {
                        self.chatComposeView.frame = CGRectMake(self.chatComposeView.frame.origin.x, self.chatComposeView.frame.origin.y + self.keyheight-self.chatComposeView.frame.size.height-3, self.chatComposeView.frame.size.width, self.chatComposeView.frame.size.height)
                        self.tblForChats.frame = CGRectMake(self.tblForChats.frame.origin.x, self.tblForChats.frame.origin.y, self.tblForChats.frame.size.width, self.tblForChats.frame.size.height + self.keyFrame.size.height-49);
                        }, completion: nil)
                    self.showKeyboard=false
                    
                     
                }*/
                }});
        }
        
    }
    
    
    func sendBroadcastChatMessage(_ chatstanza:[String:AnyObject],completion:@escaping (_ uniqueid:String?,_ result:Bool)->())
    {
        var url=Constants.MainUrl+Constants.sendbroadcastmessage
        DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.default).async{
            ///Alamofire.request(Constants.MainUrl+Constants.getLastSeen, method: .post, parameters: ["phone":selectedContact], encoding: JSONEncoding.default, headers: header)
            
            Alamofire.request(url, method: .post, parameters:chatstanza, encoding: JSONEncoding.default, headers: header).response{ response in
                //(url, method: .post, parameters:chatstanza.object,encoding: JSONEncoding.default, headers:header).responseJSON { response in
                
                if(response.response?.statusCode==200)
                {
                    
                    var statusNow="sent"
                    
                    sqliteDB.UpdateChatStatus(chatstanza["uniqueid"] as! String, newstatus: "sent")
                    
                    
                    
                    print("broadcast message sent to \(chatstanza)")
                    print("main thread of send chat")
                    DispatchQueue.main.async {
                        
                        return completion(chatstanza["uniqueid"] as! String,true)
                    }
                    
                }//if success
                else{print("error sending broadcast message : \(response.error)")
                    DispatchQueue.main.async {
                        
                        return completion(nil, false)
                    }
                }
            }//)
        }
        
    }
    
    func sendChatMessage(_ chatstanza:[String:String],completion:@escaping (_ uniqueid:String?,_ result:Bool)->())
    {
          var url=Constants.MainUrl+Constants.sendChatURL
        DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.default).async{
    
    let request = Alamofire.request("\(url)", method: .post, parameters:  chatstanza,headers:header).responseJSON { response in

                    if(response.response?.statusCode==200)
                {
                  
                var statusNow="sent"
                    
                sqliteDB.UpdateChatStatus(chatstanza["uniqueid"]!, newstatus: "sent")
                
        
                    
                
                     print("main thread of send chat")
                    DispatchQueue.main.async {

                return completion(chatstanza["uniqueid"]!,true)
                    }
                  
            }//if success
            else{
                    DispatchQueue.main.async {

                        return completion(nil, false)
                    }
}
            }//)
        }
        
    }
    
    
    
    func sendChatStatusUpdateMessage(_ uniqueid:String,status:String,sender:String)
    {
        print("sending chat status update")
        
        ///let queue = dispatch_queue_create("com.kibochat.manager-response-queue1", DISPATCH_QUEUE_CONCURRENT)
        
        var url=Constants.MainUrl+Constants.sendChatStatusURL
        
        
        DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.default).async
        {
            
            let request=Alamofire.request("\(url)", method: .post, parameters: ["uniqueid":uniqueid,"sender":sender,"status":status],headers:header).responseJSON { response in
                
         //alamofire4
                //let request = Alamofire.request(.POST, "\(url)", parameters: ["uniqueid":uniqueid,"sender":sender,"status":status],headers:header).responseJSON { response in
            
            
        /*let request = Alamofire.request(.POST, "\(url)", parameters: ["uniqueid":uniqueid,"sender":sender,"status":status],headers:header)
        request.response(
            queue: queue,
            responseSerializer: Request.JSONResponseSerializer(options: .AllowFragments),
            completionHandler: { response in
                
                */
                // You are now running on the concurrent `queue` you created earlier.
                //print("Parsing JSON on thread: \(NSThread.currentThread()) is main thread: \(NSThread.isMainThread())")
                
                // Validate your JSON response and convert into model objects if necessary
             //   //print(response.result.value!) //status, uniqueid
                
                
                // To update anything on the main thread, just jump back on like so.
                
                if(response.response?.statusCode==200)
                {
                    
                    var resJSON=JSON.init(data:response.data!)
                    //print("json is \(resJSON)")
                    
                    
                  ////  DispatchQueue.main.async {
                        //print("Am I back on the main thread: \(NSThread.isMainThread())")
                        //print("uniqueid is \(resJSON["uniqueid"].string!)")
                    
                    
                    sqliteDB.removeMessageStatusSeen(resJSON["uniqueid"].string!)
                    
                    
                    //print("chat message status ack received")
                        
                        ////print(data[0]["status"]!!.string!+" ... "+data[0]["uniqueid"]!!.string!)
                        //print("chat status seen emitted")
                        
                        socketObj.socket.emit("logClient","\(username) chat status emitted")
                        
                        

                        
                        
                    /////}
                }
            }
        }
       // )
    }
    
    func sendPostButtonPressed()
    {
        var randNum5=self.randomStringWithLength(5) as String
        /*
         let date1=Date()
         let calendar = Calendar.current
         let year=(calendar as NSCalendar).components(NSCalendar.Unit.year,from: date1).year
         let month=(calendar as NSCalendar).components(NSCalendar.Unit.month,from: date1).month
         let day=(calendar as NSCalendar).components(.day,from: date1).day
         let hr=(calendar as NSCalendar).components(NSCalendar.Unit.hour,from: date1).hour
         let min=(calendar as NSCalendar).components(NSCalendar.Unit.minute,from: date1).minute
         let sec=(calendar as NSCalendar).components(NSCalendar.Unit.second,from: date1).second
         print("\(randNum5) \(year) \(month) \(day) \(hr) \(min) \(sec)")
         //var uniqueID=randNum5+year+month+day+hr+min+sec
         var uniqueID="\(randNum5)\(year!)\(month!)\(day!)\(hr!)\(min!) \(sec!)"
         */
        var uniqueID=UtilityFunctions.init().generateUniqueid()
        var date=Date()
        var formatterDateSend = DateFormatter();
        formatterDateSend.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ";
        ///newwwwwwww
        ////formatterDateSend.timeZone = NSTimeZone.local()
        let dateSentString = formatterDateSend.string(from: date);
        
        
        var formatterDateSendtoDateType = DateFormatter();
        formatterDateSendtoDateType.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ";
        var dateSentDateType = formatterDateSendtoDateType.date(from: dateSentString)
        
        
        //2016-10-15T22:18:16.000
        var imParas=[String:String]()
        var imParas2=[String:AnyObject]()
        
        var statusNow=""
        statusNow="pending"
        
        
        if(self.selectedContact != "")
        {
            imParas=["from":"\(username!)","to":"\(self.selectedContact)","fromFullName":"\(displayname)","msg":"\(self.txtFldMessage.text!)","uniqueid":"\(uniqueID)","type":"chat","status":statusNow,"file_type":"","date":"\(dateSentDateType!)"]
            
            
            
            sqliteDB.SaveChat("\(self.selectedContact)", from1: username!, owneruser1: username!, fromFullName1: displayname, msg1: self.txtFldMessage.text!, date1: dateSentDateType, uniqueid1: uniqueID, status1: statusNow, type1: "chat", file_type1: "", file_path1: "")
            
        }
        else{
            //save as broadcast message
           /* for i in 0 ..< self.broadcastMembersPhones.count
            {
                to: req.body.to, // this should be array of phone numbers
                from: req.body.from,
                date: req.body.date,
                fromFullName: req.body.fromFullName,
                msg: req.body.msg,
                uniqueid : req.body.uniqueid,
                type : req.body.type,
                file_type : req.body.file_type
                */
            
                imParas2=["from":"\(username!)" as AnyObject,"to":self.broadcastMembersPhones.description as AnyObject,"fromFullName":"\(displayname)" as AnyObject,"msg":"\(self.txtFldMessage.text!)" as AnyObject,"uniqueid":"\(uniqueID)" as AnyObject,"type":"chat" as AnyObject,"file_type":"" as AnyObject,"date":"\(dateSentDateType!)" as AnyObject]
                
            for i in 0 ..< self.broadcastMembersPhones.count
            {
                
                sqliteDB.SaveBroadcastChat("\(self.broadcastMembersPhones[i])", from1: username!, owneruser1: username!, fromFullName1: displayname, msg1: self.txtFldMessage.text!, date1: dateSentDateType, uniqueid1: uniqueID, status1: statusNow, type1: "chat", file_type1: "", file_path1: "", broadcastlistID1: self.broadcastlistID1)
                //broadcastMembersPhones[i]
            }
        }
        var formatter = DateFormatter();
        formatter.timeZone = TimeZone.autoupdatingCurrent
        formatter.dateFormat = "MM/dd hh:mm a";
        //formatter.dateStyle = .ShortStyle
        //formatter.timeStyle = .ShortStyle
        let defaultTimeZoneStr = formatter.string(from: date);
        let defaultTimeZoneStr2=formatter.date(from: defaultTimeZoneStr as! String)
        
        
        
        var msggg=self.txtFldMessage.text!
        
        
        self.txtFldMessage.text = "";
        self.txtfieldChangedText(self.txtFldMessage)
        //txtfieldChangedText
        //DispatchQueue.main.async
        //{
        print("adding msg \(msggg)")
        
        //==--self.tblForChats.reloadRowsAtIndexPaths([lastrowindexpath], withRowAnimation: .None)
        
        
        // if(hasURL==true)
        //{
        //  self.insertChatRowAtLast(msggg/*+" (\(statusNow))"*/, uniqueid: uniqueID, status: statusNow, filename: "", type: "22", date: defaultTimeZoneStr, from: username!)
        // }
        // else{
        self.insertChatRowAtLast(msggg+" (\(statusNow))", uniqueid: uniqueID, status: statusNow, filename: "", type: "2", date: defaultTimeZoneStr, from: username!,caption:"")
        //}
        
        /*self.addMessage(msggg+" (\(statusNow))",status:statusNow,ofType: "2",date:defaultTimeZoneStr, uniqueid: uniqueID)
         
         self.tblForChats.reloadData()
         if(self.messages.count>1)
         {
         // let indexPath = NSIndexPath(forRow:self.messages.count-1, inSection: 0)
         let indexPath = IndexPath(row:self.tblForChats.numberOfRows(inSection: 0)-1, section: 0)
         self.tblForChats.scrollToRow(at: indexPath, at: UITableViewScrollPosition.bottom, animated: false)
         
         
         
         }
         */
        
        
        
        // }
        // })
        //  }
        
        
        //print("messages count before sending msg is \(self.messages.count)")
        print("sending msg \(msggg)")
        if(self.selectedContact != ""){
            self.sendChatMessage(imParas){ (uniqueid,result) -> () in
                
                if(result==true)
                {
                    var searchformat=NSPredicate(format: "uniqueid = %@",uniqueid!)
                    
                    var resultArray=self.messages.filtered(using: searchformat)
                    var ind=self.messages.index(of: resultArray.first!)
                    //cfpresultArray.first
                    //resultArray.first
                    var aa=self.messages.object(at: ind) as! [String:AnyObject]
                    
                    
                    var actualmsg=aa["message"] as! String
                    
                    
                    
                    actualmsg=actualmsg.removeCharsFromEnd(10)
                    //var actualmsg=newmsg
                    aa["message"]="\(actualmsg) (sent)" as AnyObject?
                    aa["status"]="sent" as AnyObject?
                    ///////==-------self.messages.replaceObject(at: ind, with: aa)
                    //  self.messages.objectAtIndex(ind).message="\(self.messages[ind]["message"]) (sent)"
                    var indexp=IndexPath(row:ind, section:0)
                    /// DispatchQueue.main.async
                    /// {
                    //==--- self.tblForChats.reloadData()
                    print("update2 rowss 5628")
                    self.updateChatStatusRow(aa["message"] as! String, uniqueid: aa["uniqueid"] as! String, status: aa["status"] as! String, filename: "", type: aa["type"] as! String, date: aa["date"] as! String,caption:"")
                    
                    /*
                     self.tblForChats.beginUpdates()
                     self.tblForChats.reloadRows(at: [indexp], with: UITableViewRowAnimation.bottom)
                     self.tblForChats.endUpdates()
                     self.tblForChats.scrollToRow(at: NSIndexPath.init(row: ind, section: 0) as IndexPath, at: UITableViewScrollPosition.bottom, animated: false)
                     */
                    ///}
                    
                }
                else
                {
                    print("unable to send chat \(imParas)")
                }
            }
        }
        else{
            
            var result1=false
            var uniqueid1=""
            var count=0
            
            /*to: req.body.to, // this should be array of phone numbers
            from: req.body.from,
            date: req.body.date,
            fromFullName: req.body.fromFullName,
            msg: req.body.msg,
            uniqueid : req.body.uniqueid,
            type : req.body.type,
            file_type : req.body.file_type
            */
            
            var jsonObj:[String:AnyObject]=["from":username! as AnyObject,"to":self.broadcastMembersPhones as AnyObject,"fromFullName":displayname as AnyObject,"msg":msggg as AnyObject,"uniqueid":uniqueID as AnyObject,"type":"chat" as AnyObject,"file_type":"" as AnyObject,"date":"\(dateSentDateType!)" as AnyObject]
            
            self.sendBroadcastChatMessage(jsonObj, completion: { (uniqueid, result) in
                if(result==true)
                {
                 var searchformat=NSPredicate(format: "uniqueid = %@",uniqueid!)
                var resultArray=self.messages.filtered(using: searchformat)
                var ind=self.messages.index(of: resultArray.first!)
                //cfpresultArray.first
                //resultArray.first
                var aa=self.messages.object(at: ind) as! [String:AnyObject]
                var actualmsg=aa["message"] as! String
                actualmsg=actualmsg.removeCharsFromEnd(10)
                //var actualmsg=newmsg
                aa["message"]="\(actualmsg) (sent)" as AnyObject?
                self.messages.replaceObject(at: ind, with: aa)
                //  self.messages.objectAtIndex(ind).message="\(self.messages[ind]["message"]) (sent)"
                var indexp=IndexPath(row:ind, section:0)
                print("update rowsssss 5671 line")
                self.tblForChats.beginUpdates()
                self.tblForChats.reloadRows(at: [indexp], with: UITableViewRowAnimation.bottom)
                self.tblForChats.endUpdates()
                }

                
            })
            
            //change in broadcase endpoint
            /*
            for i in 0 ..< imParas2.count
            {
                
                //replace with single downward sync api
                self.sendChatMessage(imParas2[i]){ (uniqueid,result) -> () in
                    count += 1
                    if(result==true && count==1){
                        var searchformat=NSPredicate(format: "uniqueid = %@",uniqueid!)
                        
                        var resultArray=self.messages.filtered(using: searchformat)
                        var ind=self.messages.index(of: resultArray.first!)
                        //cfpresultArray.first
                        //resultArray.first
                        var aa=self.messages.object(at: ind) as! [String:AnyObject]
                        var actualmsg=aa["message"] as! String
                        actualmsg=actualmsg.removeCharsFromEnd(10)
                        //var actualmsg=newmsg
                        aa["message"]="\(actualmsg) (sent)" as AnyObject?
                        self.messages.replaceObject(at: ind, with: aa)
                        //  self.messages.objectAtIndex(ind).message="\(self.messages[ind]["message"]) (sent)"
                        var indexp=IndexPath(row:ind, section:0)
                        print("update rowsssss 5671 line")
                        self.tblForChats.beginUpdates()
                        self.tblForChats.reloadRows(at: [indexp], with: UITableViewRowAnimation.bottom)
                        self.tblForChats.endUpdates()
                        ////self.tblForChats.scrollToRow(at: NSIndexPath.init(row: messages.count-1, section: 0) as IndexPath, at: UITableViewScrollPosition.bottom, animated: false)
                        /* DispatchQueue.main.async
                         {
                         self.tblForChats.reloadData()
                         // print("messages count is \(self.messages.count)")
                         }*/
                    }
                }}
            
            
            */
            
            /*  }
             }*/
        }
    }
    
    @IBAction func postBtnTapped() {
       
        if(isBlocked==true)
        {
        let shareMenu = UIAlertController(title: "", message: "Unblock contact to send a message".localized, preferredStyle: .actionSheet)
        shareMenu.modalPresentationStyle=UIModalPresentationStyle.overCurrentContext
        
        
        let unblockAction = UIAlertAction(title: "UnBlock".localized, style: UIAlertActionStyle.default,handler: { (action) -> Void in
            UtilityFunctions.init().unblockContact(phone1: self.selectedContact)
            //completion result

            self.sendPostButtonPressed()
       
        
     
        })
        let cancelAction = UIAlertAction(title: "Cancel".localized, style: UIAlertActionStyle.cancel, handler:{ (action) -> Void in
            
            return
            
        })
        
        
        shareMenu.addAction(unblockAction)
        shareMenu.addAction(cancelAction)
        
        
        
        self.present(shareMenu, animated: true, completion: {
            
        })
    }
        else{
            self.sendPostButtonPressed()
        }
}
        

    func getSizeOfString(_ postTitle: NSString) -> CGSize {
        
        
        // Get the height of the font
        let constraintSize = CGSize(width: 170, height: CGFloat.greatestFiniteMagnitude)
        
        //let constraintSize = CGSizeMake(220, CGFloat.max)
        
        
        
        /*let attributes = [NSFontAttributeName:UIFont.systemFontOfSize(11.0)]
         let labelSize = postTitle.boundingRectWithSize(constraintSize,
         options: NSStringDrawingOptions.UsesLineFragmentOrigin,
         attributes: attributes,
         context: nil)*/
        
        
        let style = NSMutableParagraphStyle()
        style.lineBreakMode = .byWordWrapping
        let labelSize = postTitle.boundingRect(with: constraintSize,
                                                       options: NSStringDrawingOptions.usesLineFragmentOrigin,
                                                       attributes:[NSFontAttributeName : UIFont.systemFont(ofSize: 11.0),NSParagraphStyleAttributeName: style],
                                                       context: nil)
        ////print("size is width \(labelSize.width) and height is \(labelSize.height)")
        return labelSize.size
    }
    func getSizeOfStringHeight(_ postTitle: NSString) -> CGSize {
        
        
        // Get the height of the font
        let constraintSize = CGSize(width: 270, height: CGFloat.greatestFiniteMagnitude)
        
        //let constraintSize = CGSizeMake(220, CGFloat.max)
        
        
        
        /*let attributes = [NSFontAttributeName:UIFont.systemFontOfSize(11.0)]
         let labelSize = postTitle.boundingRectWithSize(constraintSize,
         options: NSStringDrawingOptions.UsesLineFragmentOrigin,
         attributes: attributes,
         context: nil)*/
        
        
        let style = NSMutableParagraphStyle()
        style.lineBreakMode = .byWordWrapping
        let labelSize = postTitle.boundingRect(with: constraintSize,
                                                       options: NSStringDrawingOptions.usesLineFragmentOrigin,
                                                       attributes:[NSFontAttributeName : UIFont.systemFont(ofSize: 11.0),NSParagraphStyleAttributeName: style],
                                                       context: nil)
        ////print("size is width \(labelSize.width) and height is \(labelSize.height)")
        return labelSize.size
    }
    
    @IBAction func btn_deleteChatHistoryPressed(_ sender: AnyObject) {
        
        removeChatHistory()
        /*sqliteDB.deleteChat(selectedContact.debugDescription)
         
         messages.removeAllObjects()
         tblForChats.reloadData()*/
    }
    
    func socketReceivedMessage(_ message: String, data: AnyObject!) {
        /*
         //print("socketReceivedMessage inside im got", terminator: "")
         var msg=JSON(data)
         //print("$$ \(message) is this \(msg)")
         //print(message)
         switch(message)
         {
         case "im":
         //print("chat sent to server.ack received 222 ")
         var chatJson=JSON(data)
         //print("chat received \(chatJson.debugDescription)")
         //print(chatJson[0]["msg"])
         var receivedMsg=chatJson[0]["msg"]
         
         self.addMessage(receivedMsg.description, ofType: "1",date: NSDate().debugDescription)
         self.tblForChats.reloadData()
         if(self.messages.count>1)
         {
         var indexPath = NSIndexPath(forRow:self.messages.count-1, inSection: 0)
         
         self.tblForChats.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Bottom, animated: false)
         }
         
         
         default:
         //print("error: wrong messgae received2 \(message)")
         
         }
         */
        
    }
    func socketReceivedSpecialMessage(_ message: String, params: JSON!) {
        
        
    }
    func socketReceivedMessageChat(_ message: String, data: AnyObject!) {
        
        ////print("socketReceivedMessage inside im got", terminator: "")
        switch(message)
        {
        /*case "im":
            var msg=JSON(data)
            //print("$$ \(message) is this \(msg)")
            //print(message)
            
            //print("chat sent to server.ack received 222 ")
            
            var chatJson=JSON(data)
            //print("chat received \(chatJson.debugDescription)")
            //print(chatJson[0]["msg"])
            var receivedMsg=chatJson[0]["msg"]
            
            
            var date22=NSDate()
            var formatter = DateFormatter();
            //formatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZ";
            formatter.dateFormat = "MM/dd hh:mm a";
            formatter.timeZone = NSTimeZone.local()
            // formatter.dateStyle = .ShortStyle
            //formatter.timeStyle = .ShortStyle
            let defaultTimeZoneStr = formatter.stringFromDate(date22);
            
             var uniqueid=chatJson[0]["uniqueid"].string!
            
            
            self.addMessage(receivedMsg.description, ofType: "1",date: defaultTimeZoneStr,uniqueid: uniqueid)
            
            self.retrieveChatFromSqlite(self.selectedContact)
            if(self.messages.count>1)
            {
                var indexPath = NSIndexPath(forRow:self.messages.count-1, inSection: 0)
                
                self.tblForChats.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Bottom, animated: false)
            }
            */
            
            //%%%%% OLD working logic.. changed coz of bubble unread
            
            /*
             self.tblForChats.reloadData()
             if(self.messages.count>1)
             {
             var indexPath = NSIndexPath(forRow:self.messages.count-1, inSection: 0)
             
             self.tblForChats.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Bottom, animated: false)
             }
             
             */
        case "updateUI":
            print("received updateUI from socket")
            
            //print("$$ \(message)")
            //print(message)

            /*self.self.retrieveChatFromSqlite(self.selectedContact,completion:{(result)-> () in
                
                //    DispatchQueue.main.async
                //  {
                // self.tblForChats.reloadData()
                
                //commenting newwwwwwww -===-===-=
                //   DispatchQueue.main.async
                //{
                self.tblForChats.reloadData()
                
                if(self.messages.count>1)
                {
                    //var indexPath = NSIndexPath(forRow:self.messages.count-1, inSection: 0)
                    let indexPath = IndexPath(row:self.tblForChats.numberOfRows(inSection: 0)-1, section: 0)
                    self.tblForChats.scrollToRow(at: indexPath, at: UITableViewScrollPosition.bottom, animated: false)
                }
                //}
                //}
                // })
            })*/
           /* self.retrieveChatFromSqlite(self.selectedContact)
            if(self.messages.count>1)
            {
                var indexPath = NSIndexPath(forRow:self.messages.count-1, inSection: 0)
                
                self.tblForChats.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Bottom, animated: false)
            }*/

           /* self.retrieveChatFromSqlite(selectedContact,completion:{(result)-> () in
                self.tblForChats.reloadData()
                
                if(self.messages.count>1)
                {
                    var indexPath = NSIndexPath(forRow:self.messages.count-1, inSection: 0)
                    
                    self.tblForChats.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Bottom, animated: false)
                }
            })*/
 
            // DispatchQueue.main.async
            //  {
            //     self.tblForChats.reloadData()
            // }
            
            
        default:
            print("error: wrong messgae received2 \(message)")
            
            
        }
    }
    
    /*
     // delete slider to delete individual row
     // Override to support editing the table view.
     func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
     if editingStyle == .Delete {
     messages.removeObjectAtIndex(indexPath.row)
     // Delete the row from the data source
     tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
     } else if editingStyle == .Insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    
    
    // #pragma mark - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue?, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        
        
        //contactdetailsinfosegue
        if segue!.identifier == "contactdetailsinfosegue" {
            if let destinationVC = segue!.destination as? contactsDetailsTableViewController{
                
                if(contactshared==true)
                {
                    destinationVC.selectedContactphone=self.contactCardSelected
                }
                else{
                destinationVC.selectedContactphone=self.selectedContact
                }
                let blockedByMe = Expression<Bool>("blockedByMe")
                let IamBlocked = Expression<Bool>("IamBlocked")
                let phone = Expression<String>("phone")
                
                
                //contactsDetailController?.contactIndex=tblForNotes.indexPathForSelectedRow!.row
                //var cell=tblForNotes.cellForRowAtIndexPath(tblForNotes.indexPathForSelectedRow!) as! AllContactsCell
                
                
                //if(ContactStatus != "")
               // {
                    destinationVC.isKiboContact = true
                    //print("hidden falseeeeeee")
                //}
                let tbl_contactslists=sqliteDB.contactslists
                
                do{for resultrows in try sqliteDB.db.prepare((tbl_contactslists?.filter(phone==selectedContact && blockedByMe==true))!)
                {
                    print("blocked by me")
                    //blockedcontact=true
                    destinationVC.blockedByMe=true
                    break
                    }
                }
                catch{
                    print("not blocked coz not in contact list")
                }
                
            }
        }
        
         if segue!.identifier == "showFullImageSegue" {
         if let destinationVC = segue!.destination as? ShowImageViewController{
         //destinationVC.tabBarController?.selectedIndex=0
         //self.tabBarController?.selectedIndex=0
             destinationVC.newimage=self.selectedImage
                    self.dismiss(animated: true, completion: { () -> Void in
         
                       

         })
         }
         }
        
        
        if segue!.identifier == "MapViewSegue" {
            if let destinationVC = segue!.destination as? MapViewController{
                //destinationVC.tabBarController?.selectedIndex=0
                //self.tabBarController?.selectedIndex=0
                let selectedRow = tblForChats.indexPathForSelectedRow!.row
                var messageDic = messages.object(at: selectedRow) as! [String : String];
                let coordinates = messageDic["message"] as NSString!
                
                
                print("components now seperating by : \(coordinates!)")
                let locationinfo=coordinates!.components(separatedBy: ":") ///return array string
                var latitude = locationinfo[0]
                var longitude = locationinfo[1]
                destinationVC.latitude=latitude
                destinationVC.longitude=longitude
                self.dismiss(animated: true, completion: { () -> Void in
                    
                    
                    
                })
            }
        }
        if segue!.identifier == "showFullDocSegue" {
            if let destinationVC = segue!.destination as? textDocumentViewController{
                let selectedRow = tblForChats.indexPathForSelectedRow!.row
                var messageDic = messages.object(at: selectedRow) as! [String : String];
                
                let filename = messageDic["filename"] as NSString!
                selectedText=filename! as! String
                //destinationVC.tabBarController?.selectedIndex=0
                //self.tabBarController?.selectedIndex=0
                destinationVC.newtext=selectedText
                self.dismiss(animated: true, completion: { () -> Void in
                    
                    
                    
                })
            }
        }
 //MapViewSegue
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        
        
        
        
        
        //print("yess pickeddd document")
        var furl=URL(string: url.absoluteString)
        
        
        //METADATA FILE NAME,TYPE
        //print(furl!.pathExtension!)
        //print(furl!.deletingLastPathComponent())
        var ftype=furl!.pathExtension
        var fname=furl!.deletingPathExtension().lastPathComponent
        ////var fname=furl!.URLByDeletingPathExtension?.URLString
        //var attributesError=nil
        var fileAttributes:[String:AnyObject]=["":"" as AnyObject]
        //message: "Send".localized+" \" \(fname) .\(ftype) \" "+"?".localized
         shareMenu = UIAlertController(title: nil, message: "Send".localized+" \" \(fname) .\(ftype) \" "+"?".localized, preferredStyle: .actionSheet)
       // shareMenu.modalPresentationStyle=UIModalPresentationStyle.OverCurrentContext
        let confirm = UIAlertAction(title: "Yes".localized, style: UIAlertActionStyle.default,handler: { (action) -> Void in
            

            
        
        
        if (controller.documentPickerMode == UIDocumentPickerMode.import) {
          //  NSLog("Opened ", url.path!);
            //print("picker url is \(url)")
            //print("opened \(url.path!)")
            
            
            url.startAccessingSecurityScopedResource()
            let coordinator = NSFileCoordinator()
            var error:NSError? = nil
            //var downloadedalready=false
            do{
                var downloadkeyresult=try furl!.resourceValues(forKeys: [URLResourceKey.ubiquitousItemDownloadingStatusKey])
           /// var downloadkeyresult=try url.resourceValuesForKeys([NSURLUbiquitousItemDownloadingStatusKey])
                //print("... ... \(downloadkeyresult.debugDescription)")
           //////var downloadedalready=try NSFileManager.defaultManager().startDownloadingUbiquitousItemAtURL(furl!)
           
           ////// //print("downloadedalready is \(downloadedalready)")
         //   if(downloadedalready != nil)
//{
                
                
                if(downloadkeyresult.allValues.count>0)
{
    var downloadedalready=try FileManager.default.startDownloadingUbiquitousItem(at: furl!)
    

}
            coordinator.coordinate(readingItemAt: url, options: [], error: &error) { (url) -> Void in
                
                //print("error is \(error)")

                // do something with it
                let fileData = try? Data(contentsOf: url)
                /////////////////////////print(fileData?.description)
                socketObj.socket.emit("logClient","IPHONE-LOG: \(username!) selected file ")
                //print("file gotttttt")
               
                do {
                    let fileAttributes : NSDictionary? = try FileManager.default.attributesOfItem(atPath: furl!.path) as NSDictionary?
                    
                    if let _attr = fileAttributes {
                        self.fileSize1 = _attr.fileSize();
                        //print("file size is \(self.fileSize1)")
                        //// ***april 2016 neww self.fileSize=(fileSize1 as! NSNumber).integerValue
                    }
                } catch {
                    socketObj.socket.emit("logClient","IPHONE-LOG: error: \(error)")
                    //print("Error:.... \(error)")
                }
                
                urlLocalFile=url
                /////let text2 = fm.contentsAtPath(filePath)
                //////////print(text2)
                ///////////print(JSON(text2!))
                ///mdata.fileContents=fm.contentsAtPath(filePathImage)!
                self.fileContents=try? Data(contentsOf: url)
                self.filePathImage=url.absoluteString
                //var filecontentsJSON=JSON(NSData(contentsOfURL: url)!)
                ////print(filecontentsJSON)
                //print("file url is \(self.filePathImage) file type is \(ftype)")
                
                
                
                
                
                let dirPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
                let docsDir1 = dirPaths[0]
                var documentDir=docsDir1 as NSString
                var filePathImage2=documentDir.appendingPathComponent(fname+"."+ftype)
                var fm=FileManager.default
                
                /*var fileAttributes:[String:AnyObject]=["":""]
                do {
                    /// let fileAttributes : NSDictionary? = try NSFileManager.defaultManager().attributesOfItemAtPath(furl!.path!)
                    let fileAttributes : NSDictionary? = try NSFileManager.defaultManager().attributesOfItemAtPath(imageUrl.path!)
                    
                    if let _attr = fileAttributes {
                        self.fileSize1 = _attr.fileSize();
                        //print("file size is \(self.fileSize1)")
                        //// ***april 2016 neww self.fileSize=(fileSize1 as! NSNumber).integerValue
                    }
                } catch {
                    socketObj.socket.emit("logClient","IPHONE-LOG: error: \(error)")
                    //print("Error:+++ \(error)")
                }*/
                
                
              //  //print("filename is \(self.filename) destination path is \(filePathImage2) image name \(imageName) imageurl \(imageUrl) photourl \(photoURL) localPath \(localPath).. \(localPath.absoluteString)")
                
                var s=fm.createFile(atPath: filePathImage2, contents: nil, attributes: nil)
                
                //  var written=fileData!.writeToFile(filePathImage2, atomically: false)
                
                //filePathImage2
                //var data=NSData(contentsOfFile: self.filePathImage)
                do{
                    var writefile = try fileData!.write(to: URL(fileURLWithPath: filePathImage2))
                    //.writeToFile(filePathImage2, atomically: true)
                }
                catch{
                    print("unable to write")
                }
                
                
                
                
              /*
                var filename=fname!+"."+ftype
                socketObj.socket.emit("logClient","\(username!) is sending file \(fname)")
                
                var mjson="{\"file_meta\":{\"name\":\"\(filename)\",\"size\":\"\(self.fileSize1.description)\",\"filetype\":\"\(ftype)\",\"browser\":\"firefox\",\"uname\":\"\(username!)\",\"fid\":\(self.myfid),\"senderid\":\(currentID!)}}"
                var fmetadata="{\"eventName\":\"data_msg\",\"data\":\(mjson)}"
                */
                
                //----------sendDataBuffer(fmetadata,isb: false)
                
                /*
                let calendar = Calendar.current
                let comp = (calendar as NSCalendar).components([.hour, .minute], from: Date())
                let year = String(describing: comp.year)
                let month = String(describing: comp.month)
                let day = String(describing: comp.day)
                let hour = String(describing: comp.hour)
                let minute = String(describing: comp.minute)
                let second = String(describing: comp.second)
                
                
                var randNum5=self.randomStringWithLength(5) as String
                var uniqueID=randNum5+year+month+day+hour+minute+second
                */var uniqueID=UtilityFunctions.init().generateUniqueid()
                
                
                
                //var uniqueID=randNum5+year
                //print("unique ID is \(uniqueID)")
                
                //^^var firstNameSelected=selectedUserObj["firstname"]
                //^^^var lastNameSelected=selectedUserObj["lastname"]
                //^^^var fullNameSelected=firstNameSelected.string!+" "+lastNameSelected.string!
                
                 var statusNow="pending"
                var imParas=["from":"\(username!)","to":"\(self.selectedContact)","fromFullName":"\(displayname)","msg":fname+"."+ftype,"uniqueid":uniqueID,"type":"file","file_type":"document","status":statusNow]
                //print("imparas are \(imParas)")
                //print(imParas, terminator: "")
                //print("", terminator: "")
                ///=== code for sending chat here
                ///=================
                
                //socketObj.socket.emit("logClient","IPHONE-LOG: \(username!) is sending chat message")
                //////socketObj.socket.emit("im",["room":"globalchatroom","stanza":imParas])
                //var statusNow=""
                /*if(isSocketConnected==true)
                 {
                 statusNow="sent"
                 
                 }
                 else
                 {
                 */
               
                //}
                
                ////sqliteDB.SaveChat("\(selectedContact)", from1: username!, owneruser1: username!, fromFullName1: displayname!, msg1: fname!+"."+ftype, date1: nil, uniqueid1: uniqueID, status1: statusNow, type1: "chat", file_type1: "", file_path1: "")
                // sqliteDB.SaveChat("\(selectedContact)", from1: "\(username!)",owneruser1: "\(username!)", fromFullName1: "\(loggedFullName!)", msg1: "\(txtFldMessage.text!)",date1: nil,uniqueid1: uniqueID, status1: statusNow)
                
            
                
                //------
                
                
                //emit when uploaded 
                
               /* socketObj.socket.emitWithAck("im",["room":"globalchatroom","stanza":imParas])(timeoutAfter: 150000)
                {data in
                    
                    //print("chat ack received  \(data)")
                    statusNow="sent"
                    var chatmsg=JSON(data)
                    //print(data[0])
                    //print(chatmsg[0])
                    sqliteDB.UpdateChatStatus(chatmsg[0]["uniqueid"].string!, newstatus: chatmsg[0]["status"].string!)
                    
                    self.retrieveChatFromSqlite(self.selectedContact)
                    //self.tblForChats.reloadData()
                    
                    
                    
                }*/
                

                sqliteDB.saveFile(self.selectedContact, from1: username!, owneruser1: username!, file_name1: fname+"."+ftype, date1: nil, uniqueid1: uniqueID, file_size1: "\(self.fileSize1)", file_type1: ftype, file_path1: filePathImage2, type1: "document",caption1:"")
                
               
                self.addUploadInfo(self.selectedContact,uniqueid1: uniqueID, rowindex: self.messages.count, uploadProgress: 0.0, isCompleted: false)
                if(self.selectedContact != "")
                {
                    sqliteDB.SaveChat(self.selectedContact, from1: username!, owneruser1: username!, fromFullName1: displayname, msg1: fname+"."+ftype, date1: nil, uniqueid1: uniqueID, status1: statusNow, type1: "file", file_type1: "document", file_path1: filePathImage2)
                    
                    
           
                    
                    managerFile.uploadFile(filePathImage2, to1: self.selectedContact, from1: username!, uniqueid1: uniqueID, file_name1: fname+"."+ftype, file_size1: "\(self.fileSize1)", file_type1: ftype, type1:"document",label1:"")
                }else{
                    
                    //save as broadcast message
                    for i in 0 ..< self.broadcastMembersPhones.count
                    {
                        //imParas2.append(["from":"\(username!)","to":"\(broadcastMembersPhones[i])","fromFullName":"\(displayname)","msg":"\(msgbody)","uniqueid":"\(uniqueID)","type":"location","file_type":"","date":"\(dateSentDateType!)"])
                        
                        
                        sqliteDB.SaveBroadcastChat("\(self.broadcastMembersPhones[i])", from1: username!, owneruser1: username!, fromFullName1: displayname, msg1: fname+"."+ftype, date1: nil, uniqueid1: uniqueID, status1: statusNow, type1: "broadcast_file", file_type1: "document", file_path1: filePathImage2, broadcastlistID1: self.broadcastlistID1)
                        //broadcastMembersPhones[i]
                    }

                    
                managerFile.uploadBroadcastFile(filePathImage2, to1: self.broadcastMembersPhones, from1: username!, uniqueid1: uniqueID, file_name1: fname+"."+ftype, file_size1: "\(self.fileSize1)", file_type1: ftype,type1:"document", totalmembers: "\(self.broadcastMembersPhones.count)")
                }
                
              ////  sqliteDB.saveChatImage(self.selectedContact, from1: username!, owneruser1: username!, fromFullName1: "fafa", msg1: fname!+"."+ftype, date1: nil, uniqueid1: uniqueID, status1: "pending", type1: "document", file_type1: ftype, file_path1: filePathImage2)
                
               //// sqliteDB.saveChatImage(self.selectedContact, from1: username!,fromFullName1: displayname, owneruser1:username!, msg1: fname!+"."+ftype, date1: nil, uniqueid1: uniqueID, status1: "pending", type1: "doc",file_type1: ftype, file_path1: filePathImage2)
                selectedText = filePathImage2
                
               ////  self.retrieveChatFromSqlite(self.selectedContact)
                self.retrieveChatFromSqlite(self.selectedContact,completion:{(result)-> () in
                    //==---
                    
                    DispatchQueue.main.async
{
                    self.tblForChats.reloadData()
                    
                    if(self.messages.count>1)
                    {
                      //  var indexPath = NSIndexPath(forRow:self.messages.count-1, inSection: 0)
                        let indexPath = IndexPath(row:self.tblForChats.numberOfRows(inSection: 0)-1, section: 0)
                        self.tblForChats.scrollToRow(at: indexPath, at: UITableViewScrollPosition.bottom, animated: false)
                    }
                    }
                })
                
                ////  sqliteDB.SaveChat(self.selectedContact, from1: username!, owneruser1: username!, fromFullName1: displayname, msg1: filename, date1: nil, uniqueid1: uniqueID, status1: "pending")
                
                /////socketObj.socket.emit("conference.chat", ["message":"You have received a file. Download and Save it.","username":username!])
                
               /* let alert = UIAlertController(title: "Success", message: "Your file has been successfully sent", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
                
                */
            }
         //       }
            url.stopAccessingSecurityScopedResource()
            //mdata.sharefile(url)
        }
            
            
            
            catch
            {
               //print("eeee \(error)")
            }
            }
        })
        
        
        let notConfirm = UIAlertAction(title: "No".localized, style: UIAlertActionStyle.cancel, handler: { (action) -> Void in
            
        })
        
        shareMenu.addAction(confirm)
        shareMenu.addAction(notConfirm)
        
        self.present(shareMenu, animated: true, completion: {
            
        })

        
        
    }
    
    
    
    func documentMenu(_ documentMenu: UIDocumentMenuViewController, didPickDocumentPicker documentPicker: UIDocumentPickerViewController) {
        
        documentPicker.delegate = self
        present(documentPicker, animated: true, completion: nil)
        
        
    }
    
    
    
    func documentMenuWasCancelled(_ documentMenu: UIDocumentMenuViewController) {
        
        
    }
    
    
    
    func refreshChatsUI(_ message: String!, uniqueid:String!, from:String!, date1:Date!, type:String!) {
        
      //  var chatJSON=JSON(data!)
   // var uniqueid=chatJSON["un"]
        
        /*if(type! == "chat" || type! == "document" || type! == "image" || type! == "contact")
        {
            
            //update status seen in table
            //save status seen in sync table
            //http send status seen
                       //managerFile.sendChatStatusUpdateMessage(chatJson[0]["uniqueid"].string!, status: status, sender: chatJson[0]["from"].string!)
            
            
            if(from! == selectedContact)
            {
                
                sqliteDB.UpdateChatStatus(uniqueid, newstatus: "seen")
                
                sqliteDB.saveMessageStatusSeen("seen", sender1: from, uniqueid1: uniqueid)
                
                sendChatStatusUpdateMessage(uniqueid,status: "seen",sender:from)
                
  
                
            //check if on correct chat window where new message is received
        /*var formatter = DateFormatter();
        
        formatter.timeZone = NSTimeZone.local()
        formatter.dateFormat = "MM/dd hh:mm a";
        //formatter.dateStyle = .ShortStyle
        //formatter.timeStyle = .ShortStyle
        let defaultTimeZoneStr = formatter.stringFromDate(date1);
                */
                
                
                
                
                var formatter2 = DateFormatter();
                formatter2.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
                formatter2.timeZone = TimeZone.autoupdatingCurrent
                var defaultTimeeee = formatter2.string(from: date1)
      //  let defaultTimeZoneStr2=formatter..date(from:defaultTimeZoneStr)
        
        
        //print("date is \(defaultTimeZoneStr2)")
                print("adding message received")
        
                switch(type!)
                {
                    case "chat":
                    
                        self.addMessage(message,status: "sent", ofType: "1",date:defaultTimeeee, uniqueid: uniqueid)
                    

                    case "document":
                    
                        self.addMessage(message,status: "sent", ofType: "5",date:defaultTimeeee, uniqueid: uniqueid)
                    

                    case "image":
                        self.addMessage(message,status: "sent", ofType: "3",date:defaultTimeeee, uniqueid: uniqueid)
                    

                    
                    case "contact":
                        self.addMessage(message,status: "sent", ofType: "7",date:defaultTimeeee, uniqueid: uniqueid)
                    
                
                    default: print("invalid chat type received")

                }
               // self.addMessage(message,status: "sent", ofType: "1",date:defaultTimeeee, uniqueid: uniqueid)
        
        
        txtFldMessage.text = "";
                self.txtfieldChangedText(txtFldMessage)
                
                DispatchQueue.main.async
                {
        self.tblForChats.reloadData()
        if(self.messages.count>1)
        {
           // let indexPath = NSIndexPath(forRow:self.messages.count-1, inSection: 0)
            let indexPath = IndexPath(row:self.tblForChats.numberOfRows(inSection: 0)-1, section: 0)
            self.tblForChats.scrollToRow(at: indexPath, at: UITableViewScrollPosition.bottom, animated: false)
            
        }
                }
               
        }
    }
        else{
        
        //received status
        print("refreshing chats details UI now type not cat but \(type!)")
        //dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0))
        //{
            self.retrieveChatFromSqlite(self.selectedContact,completion:{(result)-> () in
           ///// DispatchQueue.main.async
           ///// {
                print("refreshing chats details UI now ........")
                
            DispatchQueue.main.async
            {
                self.tblForChats.reloadData()
                
            if(self.messages.count>1)
            {
                
                //var indexPath = NSIndexPath(forRow:self.messages.count-1, inSection: 0)
                let indexPath = IndexPath(row:self.tblForChats.numberOfRows(inSection: 0)-1, section: 0)
                
                self.tblForChats.scrollToRow(at: indexPath, at: UITableViewScrollPosition.bottom, animated: false)
            }
            }
          //////  }
        })
         //   }
       /* self.retrieveChatFromSqlite(self.selectedContact)
        if(self.messages.count>1)
        {
            var indexPath = NSIndexPath(forRow:self.messages.count-1, inSection: 0)
            
            self.tblForChats.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Bottom, animated: false)
        }*/
        }
        */
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //print("disappearrrrrrrrr")
        super.viewWillDisappear(animated)
        if(socketObj != nil)
{
        socketObj.delegateChat=nil
    }
        delegateRefreshChat=nil
        ////delegateChatRefr=nil
        delegatechatdetail=nil
        delegateInsertChatAtLast=nil
        UIDelegates.getInstance().delegateSingleChatDetails1=nil
        ////delegateRefreshChat=nil
        UIDelegates.getInstance().delegateInsertChatAtLast1=nil
        UIDelegates.getInstance().delegateInsertBulkChatsSync1=nil
        UIDelegates.getInstance().delegateInsertBulkChatsStatusesSync=nil
        UIDelegates.getInstance().delegateUpdateChatStatusRow1=nil
        delegateCheckConvWindow=nil
       /////  NSNotificationCenter.defaultCenter().removeObserver(self, name:UIKeyboardWillShowNotification, object: nil)    
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    /* override func viewDidLayoutSubviews() {
     
     super.viewDidLayoutSubviews()
     }*/
    
    func refreshSingleChatDetailUI(_ message: String, data: AnyObject!) {
        print("inside refreshSingleChatDetailUI")
        self.retrieveChatFromSqlite(self.selectedContact,completion:{(result)-> () in
            
        self.tblForChats.reloadData()
        
        if(self.messages.count>1)
        {
            //var indexPath = NSIndexPath(forRow:self.messages.count-1, inSection: 0)
            let indexPath = IndexPath(row:self.tblForChats.numberOfRows(inSection: 0)-1, section: 0)
            self.tblForChats.scrollToRow(at: indexPath, at: UITableViewScrollPosition.bottom, animated: false)
        }
        //}
        //}
        // })
    })
    }
    
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.authorizedWhenInUse {
           // viewMap.isMyLocationEnabled = true
            //got location
            print("location permission granted")
            self.didFindMyLocation=true
        }
        else{
            print("location pemission not granted")
        }
    }
    
    
   /* override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>) {
        if !didFindMyLocation {
            let myLocation: CLLocation = change[NSKeyValueChangeNewKey] as CLLocation
            viewMap.camera = GMSCameraPosition.camera(withTarget: myLocation.coordinate, zoom: 10.0)
            viewMap.settings.myLocationButton = true
            
            didFindMyLocation = true
        }
    }*/
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        print("here taking location")
        let userLocation:CLLocation = locations[0] as CLLocation
        
        manager.stopUpdatingLocation()
        
        let coordinations = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude,longitude: userLocation.coordinate.longitude)
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: NSError)
    {
        print("error here taking location \(error)")

    }
    
    /*func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("here taking location")
        let userLocation:CLLocation = locations[0] as CLLocation
        
        manager.stopUpdatingLocation()
        
        let coordinations = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude,longitude: userLocation.coordinate.longitude)
      //  let span = MKCoordinateSpanMake(0.2,0.2)
       // let region = MKCoordinateRegion(center: coordinations, span: span)
        
       // mapView.setRegion(region, animated: true)
       //////    sendCoordinates(location: userLocation)
    }
*/
  
    
    
    func sendCoordinates(latitude:String,longitude:String)
    {
        //var msgbody="\(location.coordinate.latitude):\(location.coordinate.longitude)"
        
        var msgbody="\(latitude):\(longitude)"
        
        print("msgbody is \(msgbody)")
        /* var randNum5=self.randomStringWithLength(5) as String
         
         let date1=Date()
         let calendar = Calendar.current
         let year=(calendar as NSCalendar).components(NSCalendar.Unit.year,from: date1).year
         let month=(calendar as NSCalendar).components(NSCalendar.Unit.month,from: date1).month
         let day=(calendar as NSCalendar).components(.day,from: date1).day
         let hr=(calendar as NSCalendar).components(NSCalendar.Unit.hour,from: date1).hour
         let min=(calendar as NSCalendar).components(NSCalendar.Unit.minute,from: date1).minute
         let sec=(calendar as NSCalendar).components(NSCalendar.Unit.second,from: date1).second
         print("\(randNum5) \(year) \(month) \(day) \(hr) \(min) \(sec)")
         //var uniqueID=randNum5+year+month+day+hr+min+sec
         var uniqueID="\(randNum5)\(year!)\(month!)\(day!)\(hr!)\(min!) \(sec!)"
         */
        var uniqueID=UtilityFunctions.init().generateUniqueid()
        
        
        var date=Date()
        var formatterDateSend = DateFormatter();
        formatterDateSend.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ";
        ///newwwwwwww
        ////formatterDateSend.timeZone = NSTimeZone.local()
        let dateSentString = formatterDateSend.string(from: date);
        
        
        var formatterDateSendtoDateType = DateFormatter();
        formatterDateSendtoDateType.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ";
        var dateSentDateType = formatterDateSendtoDateType.date(from: dateSentString)
        
        
        //2016-10-15T22:18:16.000
        var imParas=[String:String]()
        var imParas2=[[String:String]]()
        
        var statusNow=""
        statusNow="pending"
        
        
        if(selectedContact != "")
        {
            imParas=["from":"\(username!)","to":"\(selectedContact)","fromFullName":"\(displayname)","msg":"\(msgbody)","uniqueid":"\(uniqueID)","type":"location","file_type":"","date":"\(dateSentDateType!)","status":statusNow]
            
            
            
            sqliteDB.SaveChat("\(selectedContact)", from1: username!, owneruser1: username!, fromFullName1: displayname, msg1: msgbody, date1: dateSentDateType, uniqueid1: uniqueID, status1: statusNow, type1: "location", file_type1: "", file_path1: "")
            
        }
        else{
            //save as broadcast message
            for i in 0 ..< broadcastMembersPhones.count
            {
                imParas2.append(["from":"\(username!)","to":"\(broadcastMembersPhones[i])","fromFullName":"\(displayname)","msg":"\(msgbody)","uniqueid":"\(uniqueID)","type":"location","file_type":"","date":"\(dateSentDateType!)"])
                
                
                sqliteDB.SaveBroadcastChat("\(broadcastMembersPhones[i])", from1: username!, owneruser1: username!, fromFullName1: displayname, msg1: msgbody, date1: dateSentDateType, uniqueid1: uniqueID, status1: statusNow, type1: "location", file_type1: "", file_path1: "", broadcastlistID1: broadcastlistID1)
                //broadcastMembersPhones[i]
            }
        }
        var formatter = DateFormatter();
        formatter.timeZone = TimeZone.autoupdatingCurrent
        formatter.dateFormat = "MM/dd hh:mm a";
        //formatter.dateStyle = .ShortStyle
        //formatter.timeStyle = .ShortStyle
        let defaultTimeZoneStr = formatter.string(from: date);
        let defaultTimeZoneStr2=formatter.date(from: defaultTimeZoneStr as! String)
        
        
        
        var msggg=msgbody
        
        
        //txtFldMessage.text = "";
        
        
        //DispatchQueue.main.async
        //{
        print("adding msg \(msggg)")
       
        
        self.addMessage(msggg+" (\(statusNow))",status:statusNow,ofType: "14",date:defaultTimeZoneStr, uniqueid: uniqueID)
        
        self.tblForChats.reloadData()
        if(self.messages.count>1)
        {
            // let indexPath = NSIndexPath(forRow:self.messages.count-1, inSection: 0)
            let indexPath = IndexPath(row:self.tblForChats.numberOfRows(inSection: 0)-1, section: 0)
            self.tblForChats.scrollToRow(at: indexPath, at: UITableViewScrollPosition.bottom, animated: false)
            
            
            
        }
        // }
        // })
        //  }
        
        
        //print("messages count before sending msg is \(self.messages.count)")
        print("sending msg \(msggg)")
        if(selectedContact != ""){
            //in chat window
            self.sendChatMessage(imParas){ (uniqueid,result) -> () in
                
                if(result==true)
                {
                    var searchformat=NSPredicate(format: "uniqueid = %@",uniqueid!)
                    
                    var resultArray=self.messages.filtered(using: searchformat)
                    var ind=self.messages.index(of: resultArray.first!)
                    //cfpresultArray.first
                    //resultArray.first
                    var aa=self.messages.object(at: ind) as! [String:AnyObject]
                    var actualmsg=aa["message"] as! String
                    actualmsg=actualmsg.removeCharsFromEnd(10)
                    //var actualmsg=newmsg
                    aa["message"]="\(actualmsg) (sent)" as AnyObject?
                    self.messages.replaceObject(at: ind, with: aa)
                    //  self.messages.objectAtIndex(ind).message="\(self.messages[ind]["message"]) (sent)"
                    var indexp=IndexPath(row:ind, section:0)
                    DispatchQueue.main.async
                        {
                            self.tblForChats.reloadData()
                    }
                    
                }
                else
                {
                    print("unable to send chat \(imParas)")
                }
            }
        }
        else{
            
            var result1=false
            var uniqueid1=""
            var count=0
            for i in 0 ..< imParas2.count
            {
                self.sendChatMessage(imParas2[i]){ (uniqueid,result) -> () in
                    count += 1
                    if(result==true && count==1){
                        var searchformat=NSPredicate(format: "uniqueid = %@",uniqueid!)
                        
                        var resultArray=self.messages.filtered(using: searchformat)
                        var ind=self.messages.index(of: resultArray.first!)
                        //cfpresultArray.first
                        //resultArray.first
                        var aa=self.messages.object(at: ind) as! [String:AnyObject]
                        var actualmsg=aa["message"] as! String
                        actualmsg=actualmsg.removeCharsFromEnd(10)
                        //var actualmsg=newmsg
                        aa["message"]="\(actualmsg) (sent)" as AnyObject?
                        self.messages.replaceObject(at: ind, with: aa)
                        //  self.messages.objectAtIndex(ind).message="\(self.messages[ind]["message"]) (sent)"
                        var indexp=IndexPath(row:ind, section:0)
                        DispatchQueue.main.async
                            {
                                self.tblForChats.reloadData()
                                // print("messages count is \(self.messages.count)")
                        }
                    }
                }
            }
            /*  }
             }*/
        }
    }
    
 
    
    func insertChatRowAtLast(_ message: String, uniqueid: String, status: String, filename: String, type: String, date: String,from:String,caption:String) {
        
        /*tblForChats.beginUpdates()
        messages.add(["message":message,"filename":filename,"type":type,"date":date,"uniqueid":uniqueid])
        var predicate=NSPredicate(format: "uniqueid = %@", uniqueid)
        var resultArray=self.messages.filtered(using: predicate)
        
        if(resultArray.count > 0)
        {
            var foundindex=self.messages.index(of: resultArray.first!)
             tblForChats.insertRows(at: [NSIndexPath.init(row: foundindex, section: 0) as IndexPath], with: UITableViewRowAnimation.bottom)
            //insertRow(at: NSIndexPath(forRow: foundindex, inSection: 0), with: UITableViewRowAnimation.bottom)
        }
       
        tblForChats.endUpdates()
        */
        print("message \(message) .. filename \(filename) .. type is \(type)")
        messages.add(["message":message,"filename":filename,"type":type,"date":date,"uniqueid":uniqueid, "status":status,"caption":caption])
        //tblForChats.beginUpdates()
        
        tblForChats.insertRows(at: [NSIndexPath.init(row: messages.count-1, section: 0) as IndexPath], with: UITableViewRowAnimation.bottom)
        
       // tblForChats.endUpdates()
        self.tblForChats.scrollToRow(at: NSIndexPath.init(row: messages.count-1, section: 0) as IndexPath, at: UITableViewScrollPosition.bottom, animated: false)
        
        if(from == selectedContact)
        {
            
            sqliteDB.UpdateChatStatus(uniqueid, newstatus: "seen")
            
            sqliteDB.saveMessageStatusSeen("seen", sender1: from, uniqueid1: uniqueid)
            
            sendChatStatusUpdateMessage(uniqueid,status: "seen",sender:from)
        }
        
    }
    
    func insertBulkChats(statusArray: [[String : AnyObject]]) {
      
        tblForChats.beginUpdates()
        for chats  in statusArray
        {
        //var messageDic = chats.object(at: indexPath.row) as! [String : String];
            messages.add(["message":chats["message"],"filename":chats["filename"],"type":chats["type"],"date":chats["date"],"uniqueid":chats["uniqueid"],"status":chats["status"]])
        tblForChats.insertRows(at: [NSIndexPath.init(row: messages.count-1, section: 0) as IndexPath], with: UITableViewRowAnimation.bottom)
        }
        tblForChats.endUpdates()
        
    }
    
    func insertBulkChatStatusesSync(statusArray: [[String : AnyObject]]) {
        
        tblForChats.beginUpdates()
        for chats in statusArray
        {
            var predicate=NSPredicate(format: "uniqueid = %@", chats["uniqueid"] as! String)
            var resultArray=self.messages.filtered(using: predicate)
            if(resultArray.count > 0)
            {
                var foundindex=self.messages.index(of: resultArray.first!)
                var newrow:[String:AnyObject]=["message":"\(chats["message"]!) (\(chats["status"])" as AnyObject,"filename":chats["filename"]!,"type":chats["type"]!,"date":chats["date"]!,"uniqueid":chats["uniqueid"]!,"status":chats["status"]!]
                
                //messages.add(["message":chats["message"],"filename":chats["filename"],"type":chats["type"],"date":chats["date"],"uniqueid":chats["uniqueid"]])
            tblForChats.insertRows(at: [NSIndexPath.init(row: resultArray.first as! Int, section: 0) as IndexPath], with: UITableViewRowAnimation.bottom)
            }
        }
        tblForChats.endUpdates()
    }
    
    func updateChatStatusRow(_ message: String, uniqueid: String, status: String, filename: String, type: String, date: String,caption:String) {
        
        var predicate=NSPredicate(format: "uniqueid = %@", uniqueid)
        var resultArray=self.messages.filtered(using: predicate)
        if(resultArray.count > 0)
        {
            var foundindex=self.messages.index(of: resultArray.first!)
            var aa=self.messages.object(at: foundindex) as! [String:AnyObject]
            var actualmsg=aa["message"] as! String
            
            //find bracket from last
            var oldstatus=aa["status"] as! String
            
            // let indExt=actualmsg.sub
            //let filetype=filejustreceivednameToSave.substring(from: indExt!)
            
            
            var statusCount=oldstatus.characters.count+3
            if(type != "location")
            {
            actualmsg=actualmsg.removeCharsFromEnd(statusCount)
            
            print("found old message is \(message)")
            }
            var url=""
            if(type == "link")
            {
                url=aa["url"] as! String
            }
            var newrow:[String:AnyObject]=["message":"\(actualmsg) (\(status))"/*"\(message) \((status))"*/  /*"message":"\(actualmsg) (\(status))"*/ as AnyObject,"filename":filename as AnyObject,"type":aa["type"] as AnyObject,"date":aa["date"] as AnyObject,"uniqueid":aa["uniqueid"] as AnyObject,"status":status as AnyObject,"url":url as AnyObject,"caption":"" as AnyObject]
            
            print("replaced with \(newrow["message"])")
            
            messages.replaceObject(at: foundindex, with: newrow)
            
            tblForChats.beginUpdates()
            
            tblForChats.reloadRows(at: [NSIndexPath.init(row: foundindex, section: 0) as IndexPath], with: UITableViewRowAnimation.bottom)
            
            tblForChats.endUpdates()
            
            
            
            //// self.tblForChats.scrollToRow(at: NSIndexPath.init(row: messages.count-1, section: 0) as IndexPath, at: UITableViewScrollPosition.bottom, animated: false)
            
        }
    }
    
    /*!
     @method     messageComposeViewController:didFinishWithResult:
     @abstract   Delegate callback which is called upon user's completion of message composition.
     @discussion This delegate callback will be called when the user completes the message composition.
     How the user chose to complete this task will be given as one of the parameters to the
     callback.  Upon this call, the client should remove the view associated with the controller,
     typically by dismissing modally.
     @param      controller   The MFMessageComposeViewController instance which is returning the result.
     @param      result       MessageComposeResult indicating how the user chose to complete the composition process.
     */
    @available(iOS 4.0, *)
    public func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        
            switch (result) {
            case .cancelled:
                print("Message was cancelled")
                self.dismiss(animated: true, completion: nil)
            case .failed:
                print("Message failed")
                self.dismiss(animated: true, completion: nil)
            case .sent:
                print("Message was sent")
                self.dismiss(animated: true, completion: nil)
            default:
                break;
            }
        
    }
    
    func checkConversationWindowOpen(phone: String)->Bool {
        print("checking group conversation window compare \(phone) .. \(selectedContact)")
        if(phone==self.selectedContact)
        {
            return true
        }
        else
        {
            return false
        }
    }
    
}


extension String {
    
    func removeCharsFromEnd(_ count_:Int) -> String {
        print("...... inside removeCharsFromEnd \(self)")
        let stringLength = self.characters.count
        
        let substringIndex = (stringLength < count_) ? 0 : stringLength - count_
        
        return self.substring(to: self.characters.index(self.startIndex, offsetBy: substringIndex))
    }
    
    var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }
}


/*
 extension ChatDetailViewController: UIViewControllerRestoration {
 static func viewControllerWithRestorationIdentifierPath(identifierComponents: [AnyObject],
 coder: NSCoder) -> UIViewController? {
 let vc = ChatDetailViewController()
 return vc
 }
 }*/
