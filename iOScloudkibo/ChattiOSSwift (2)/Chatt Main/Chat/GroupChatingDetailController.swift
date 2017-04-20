//
//  GroupChatingDetailController.swift
//  kiboApp
//
//  Created by Cloudkibo on 31/08/2016.
//  Copyright © 2016 MyAppTemplates. All rights reserved.
//

import UIKit
import Alamofire
import SQLite
import SwiftyJSON
import Kingfisher
import MediaPlayer
import AVKit
import Photos
import Contacts
import AssetsLibrary
import Photos
import Contacts
import Compression
import ContactsUI
import Foundation
import AssetsLibrary
import MobileCoreServices
import GooglePlacePicker
import GooglePlaces
import GoogleMaps
import ActiveLabel
//import PHAsset
//import PhotosUI
//import Haneke
class GroupChatingDetailController: UIViewController,UIDocumentPickerDelegate,UIDocumentMenuDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,FileManagerDelegate,UpdateGroupChatDetailsDelegate,CNContactPickerDelegate,CNContactViewControllerDelegate,UIPickerViewDelegate,AVAudioRecorderDelegate,CLLocationManagerDelegate {
    
    var contactreceivedphone=""
    var contactCardSelected="0"
    var contactshared=false
     var shareMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
    var locationManager = CLLocationManager()
    
   
    var didFindMyLocation = false
    
    var fileSize1:UInt64=0
    var audioFilePlayName=""
    
    var selectedImage:UIImage!
    @IBOutlet weak var btnSendChat: UIButton!
    @IBOutlet weak var btnSendAudio: UIButton!
    var cellY:CGFloat=0
    var showKeyboard=false
    var keyFrame:CGRect!
    var keyheight:CGFloat!
    /////
    
    var filename=""
    var searchUniqueid:String! = nil
    @IBOutlet weak var viewForContent: UIScrollView!
    var searcheduniqueid:String!=nil
    var swipedRow:Int!
    ///@IBOutlet weak var viewForTableAndTextfield: UIView!
    var membersList=[[String:AnyObject]]()
    var delegateReload:UpdateGroupChatDetailsDelegate!
    var mytitle=""
    var groupid1=""
    var groupimage:Data!=nil
    var messages:NSMutableArray!
    @IBOutlet var tblForGroupChat: UITableView!
    
    @IBOutlet weak var txtFieldMessage: UITextField!
   
    @IBOutlet weak var chatComposeView: UIView!
    
    var moviePlayer : MPMoviePlayerController!
    var audioPlayer = AVAudioPlayer()
    var Q_serial1=DispatchQueue(label: "Q_serial1",attributes: [])
    
    
    
    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    
    
    @IBAction func didValueChanged(_ sender: UITextField) {
        
        
        print("value text changed....... ")
        if(sender.text==nil || sender.text=="")
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
    
    @IBAction func didEditingChnged(_ sender: UITextField) {
        
        print("value text changed")
        if(sender.text==nil || sender.text=="")
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
    
    
    @IBAction func backBtnPressed(_ sender: AnyObject) {
        self.dismiss(animated: true) { 
            
            
        }
    }
    func setTitle(_ title:String, subtitle:String) -> UIView {
        //Create a label programmatically and give it its property's
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0)) //x, y, width, height where y is to offset from the view center
        titleLabel.backgroundColor = UIColor.clear
        titleLabel.textColor = UIColor.white
        titleLabel.font = UIFont.boldSystemFont(ofSize: 17)
        titleLabel.text = title
        titleLabel.sizeToFit()
        
        //Create a label for the Subtitle
        let subtitleLabel = UILabel(frame: CGRect(x: 0, y: 18, width: 0, height: 0))
        subtitleLabel.backgroundColor = UIColor.clear
        //subtitleLabel.textColor = UIColor.lightGrayColor()
        subtitleLabel.textColor = UIColor.black
        
        subtitleLabel.font = UIFont.systemFont(ofSize: 12)
        subtitleLabel.text = subtitle
        subtitleLabel.sizeToFit()
        
        //===
        let titleView = UIView(frame: CGRect(x: 0, y: 0, width: max(titleLabel.frame.size.width, subtitleLabel.frame.size.width), height: 30))
        titleView.addSubview(titleLabel)
        titleView.addSubview(subtitleLabel)
        
        let widthDiff = subtitleLabel.frame.size.width - titleLabel.frame.size.width
        
        var frame = titleLabel.frame
        frame.origin.x = widthDiff / 2
        titleLabel.frame = frame.integral
        /*if widthDiff > 0 {
            var frame = titleLabel.frame
            frame.origin.x = widthDiff / 2
            titleLabel.frame = CGRectIntegral(frame)
        } else {
            var frame = subtitleLabel.frame
            frame.origin.x = abs(widthDiff) / 2
            titleLabel.frame = CGRectIntegral(frame)
        }*/

        ///===
        /*
        // Create a view and add titleLabel and subtitleLabel as subviews setting
        let titleView = UIView(frame: CGRectMake(0, 0, max(titleLabel.frame.size.width, subtitleLabel.frame.size.width), 30))
        
        // Center title or subtitle on screen (depending on which is larger)
        if titleLabel.frame.width >= subtitleLabel.frame.width {
            var adjustment = subtitleLabel.frame
            adjustment.origin.x = titleView.frame.origin.x + (titleView.frame.width/2) - (subtitleLabel.frame.width/2)
            subtitleLabel.frame = adjustment
        } else {
            var adjustment = titleLabel.frame
            adjustment.origin.x = titleView.frame.origin.x + (titleView.frame.width/2) - (titleLabel.frame.width/2)
            titleLabel.frame = adjustment
        }
        
        titleView.addSubview(titleLabel)
        titleView.addSubview(subtitleLabel)
        */
        return titleView
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
                        ////====----------------self.fileContents=try? Data(contentsOf: url)
                        //////====--------------self.filePathImage=url.absoluteString
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
                       // var imParas=["from":"\(username!)","to":"\(self.selectedContact)","fromFullName":"\(displayname)","msg":fname+"."+ftype,"uniqueid":uniqueID,"type":"file","file_type":"document"]
                        //print("imparas are \(imParas)")
                        //print(imParas, terminator: "")
                        //print("", terminator: "")
                        ///=== code for sending chat here
                        ///=================
                        
                        //socketObj.socket.emit("logClient","IPHONE-LOG: \(username!) is sending chat message")
                        //////socketObj.socket.emit("im",["room":"globalchatroom","stanza":imParas])
                        var statusNow=""
                        /*if(isSocketConnected==true)
                         {
                         statusNow="sent"
                         
                         }
                         else
                         {
                         */
                        ///statusNow="pending"
                        //}
                        
                        ////sqliteDB.SaveChat("\(selectedContact)", from1: username!, owneruser1: username!, fromFullName1: displayname!, msg1: fname!+"."+ftype, date1: nil, uniqueid1: uniqueID, status1: statusNow, type1: "chat", file_type1: "", file_path1: "")
                        // sqliteDB.SaveChat("\(selectedContact)", from1: "\(username!)",owneruser1: "\(username!)", fromFullName1: "\(loggedFullName!)", msg1: "\(txtFldMessage.text!)",date1: nil,uniqueid1: uniqueID, status1: statusNow)
                        
                        
                        
                        //------
                        
                             sqliteDB.storeGroupsChat(username!, group_unique_id1: self.groupid1, type1: "document", msg1: fname+"."+ftype, from_fullname1: displayname, date1: Date(), unique_id1: uniqueID)
                        
                        for i in 0 ..< self.membersList.count
                        {
                            /*
                             let member_phone = Expression<String>("member_phone")
                             let isAdmin = Expression<String>("isAdmin")
                             let membership_status
                             */
                            if((self.membersList[i]["member_phone"] as! String) != username! && (self.membersList[i]["membership_status"] as! String) != "left")
                            {
                                print("adding group chat status for \(self.membersList[i]["member_phone"])")
                                sqliteDB.storeGRoupsChatStatus(uniqueID, status1: "pending", memberphone1: self.membersList[i]["member_phone"]! as! String, delivereddate1: UtilityFunctions.init().minimumDate(), readDate1: UtilityFunctions.init().minimumDate())
                            }
                        }

                        
                      ///  sqliteDB.SaveChat(self.selectedContact, from1: username!, owneruser1: username!, fromFullName1: displayname, msg1: fname+"."+ftype, date1: nil, uniqueid1: uniqueID, status1: statusNow, type1: "file", file_type1: "document", file_path1: filePathImage2)
                        
                        
                        
                        
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
                        
                        
                        sqliteDB.saveFile(self.groupid1, from1: username!, owneruser1: username!, file_name1: fname+"."+ftype, date1: nil, uniqueid1: uniqueID, file_size1: "\(self.fileSize1)", file_type1: ftype, file_path1: filePathImage2, type1: "document")
                        
                        
                       ///// self.addUploadInfo(self.selectedContact,uniqueid1: uniqueID, rowindex: self.messages.count, uploadProgress: 0.0, isCompleted: false)
                        
                        managerFile.uploadFileInGroup(filePathImage2, groupid1: self.groupid1, from1: username!, uniqueid1: uniqueID, file_name1: fname+"."+ftype, file_size1: "\(self.fileSize1)", file_type1: ftype, type1: "document")
                        
                        //(filePathImage2, to1: self.selectedContact, from1: username!, uniqueid1: uniqueID, file_name1: fname+"."+ftype, file_size1: "\(self.fileSize1)", file_type1: ftype, type1:"document")
                        
                        ////  sqliteDB.saveChatImage(self.selectedContact, from1: username!, owneruser1: username!, fromFullName1: "fafa", msg1: fname!+"."+ftype, date1: nil, uniqueid1: uniqueID, status1: "pending", type1: "document", file_type1: ftype, file_path1: filePathImage2)
                        
                        //// sqliteDB.saveChatImage(self.selectedContact, from1: username!,fromFullName1: displayname, owneruser1:username!, msg1: fname!+"."+ftype, date1: nil, uniqueid1: uniqueID, status1: "pending", type1: "doc",file_type1: ftype, file_path1: filePathImage2)
                        selectedText = filePathImage2
                        
                        ////  self.retrieveChatFromSqlite(self.selectedContact)
                       
                        
                        self.retrieveChatFromSqlite({ (result) in
                            
                            
                            // })
                            // (self.selectedContact,completion:{(result)-> () in
                            DispatchQueue.main.async
                                {
                                    self.tblForGroupChat.reloadData()
                                    
                                    if(self.messages.count>1)
                                    {
                                        print("scrollinggg 5032 line")
                                        //var indexPath = NSIndexPath(forRow:self.messages.count-1, inSection: 0)
                                        let indexPath = IndexPath(row:self.tblForGroupChat.numberOfRows(inSection: 0)-1, section: 0)
                                        self.tblForGroupChat.scrollToRow(at: indexPath, at: UITableViewScrollPosition.bottom, animated: false)
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

    
    
    @IBAction func btnSendTapped(_ sender: AnyObject){
        
        var uniqueid_chat=generateUniqueid()
        var date=getDateString(Date())
        var status="pending"
        messages.add(["msg":txtFieldMessage.text!+" (pending)", "type":"2", "fromFullName":"","date":date,"uniqueid":uniqueid_chat])
        
        
  
        
        //save chat
        sqliteDB.storeGroupsChat(username!, group_unique_id1: groupid1, type1: "chat", msg1: txtFieldMessage.text!, from_fullname1: username!, date1: Date(), unique_id1: uniqueid_chat)
        
        
        //get members and store status as pending
        for i in 0 ..< membersList.count
        {
            /*
             let member_phone = Expression<String>("member_phone")
             let isAdmin = Expression<String>("isAdmin")
             let membership_status
 */
            if((membersList[i]["member_phone"] as! String) != username! && (membersList[i]["membership_status"] as! String) != "left")
            {
                print("adding group chat status for \(membersList[i]["member_phone"])")
                sqliteDB.storeGRoupsChatStatus(uniqueid_chat, status1: "pending", memberphone1: membersList[i]["member_phone"]! as! String, delivereddate1: UtilityFunctions.init().minimumDate(), readDate1: UtilityFunctions.init().minimumDate())
            }
        }
        
        var chatmsg=txtFieldMessage.text!
        txtFieldMessage.text = "";
        self.didValueChanged(txtFieldMessage)
        tblForGroupChat.reloadData()
        if(messages.count>1)
        {
            var indexPath = IndexPath(row:messages.count-1, section: 0)
            tblForGroupChat.scrollToRow(at: indexPath, at: UITableViewScrollPosition.bottom, animated: true)
  
        
            
        }
        
        /////// dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED,0))
        ////// {
        
        DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.default).async
        {
            print("messages count before sending msg is \(self.messages.count)")
            self.sendChatMessage(self.groupid1, from: username!, type: "chat", msg: chatmsg, fromFullname: username!, uniqueidChat: uniqueid_chat, completion: { (result) in
                
                print("chat sent")
                if(result==true)
                {
                    for i in 0 ..< self.membersList.count
                    {
                    if((self.membersList[i]["member_phone"] as! String) != username! && (self.membersList[i]["membership_status"] as! String) != "left")
                    {
                        sqliteDB.updateGroupChatStatus(uniqueid_chat, memberphone1: self.membersList[i]["member_phone"]! as! String, status1: "sent", delivereddate1: Date(), readDate1: Date())
                        
                         // === wrong sqliteDB.storeGRoupsChatStatus(uniqueid_chat, status1: "sent", memberphone1: self.membersList[i]["member_phone"]! as! String, delivereddate1: UtilityFunctions.init().minimumDate(), readDate1: UtilityFunctions.init().minimumDate())
                    }
                    }

                   //==== sqliteDB.updateGroupChatStatus(uniqueid_chat, memberphone1: username!,status1: "sent", delivereddate1: UtilityFunctions.init().minimumDate(), readDate1: UtilityFunctions.init().minimumDate())
                    
                    UIDelegates.getInstance().UpdateGroupChatDetailsDelegateCall()
                }
            })
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
                            self.textFieldShouldReturn(self.txtFieldMessage)
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
                            let indexPath = IndexPath(row:self.tblForGroupChat.numberOfRows(inSection: 0)-1, section: 0)
                            print("scrollinggg 4044 line")
                            self.tblForGroupChat.scrollToRow(at: indexPath, at: UITableViewScrollPosition.bottom, animated: false)
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
            self.textFieldShouldReturn(self.txtFieldMessage)
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
            
            let indexPath = IndexPath(row:self.tblForGroupChat.numberOfRows(inSection: 0)-1, section: 0)
            
            print("scrollinggg 4082 line")
            self.tblForGroupChat.scrollToRow(at: indexPath, at: UITableViewScrollPosition.bottom, animated: false)
        }
        self.navigationController!.popViewController(animated: true)
        //})
    }
    
    
    
    
    
    
    
    
    
    
    
    func sendChatMessage(_ group_id:String,from:String,type:String,msg:String,fromFullname:String,uniqueidChat:String,completion:@escaping (_ result:Bool)->())
    {
        // let queue=dispatch_get_global_queue(QOS_CLASS_USER_INITIATED,0)
        // let queue = dispatch_queue_create("com.kibochat.manager-response-queue", DISPATCH_QUEUE_CONCURRENT)
        /*  let request = Alamofire.request(.POST, "\(url)", parameters: chatstanza,headers:header)
         request.response(
         queue: queue,
         responseSerializer: Request.JSONResponseSerializer(options: .AllowFragments),
         completionHandler: { response in
         */
        
        //group_unique_id = <group_unique_id>, from, type, msg, from_fullname, unique_id
        
        var url=Constants.MainUrl+Constants.sendGroupChat
        print(url)
        print("..")
        
        let request=Alamofire.request("\(url)", method: .post, parameters: ["group_unique_id":group_id,"from":from,"type":type,"msg":msg,"from_fullname":fromFullname,"unique_id":uniqueidChat],headers:header).responseJSON { response in            
        
      //  let request = Alamofire.request(.POST, "\(url)", parameters: ["group_unique_id":group_id,"from":from,"type":type,"msg":msg,"from_fullname":fromFullname,"unique_id":uniqueidChat],headers:header).responseJSON { response in
            
            
            // You are now running on the concurrent `queue` you created earlier.
            //print("Parsing JSON on thread: \(NSThread.currentThread()) is main thread: \(NSThread.isMainThread())")
            
            // Validate your JSON response and convert into model objects if necessary
            //print(response.result.value) //status, uniqueid
            
            // To update anything on the main thread, just jump back on like so.
            //print("\(chatstanza) ..  \(response)")
            print("status code is \(response.response?.statusCode)")
            print(response)
            print(response.result.error)
            if(response.response?.statusCode==200 || response.response?.statusCode==201)
            {
                
                //print("chat ack received")
                var statusNow="sent"
                ///var chatmsg=JSON(data)
                /// //print(data[0])
                /////print(chatmsg[0])
                //print("chat sent unikque id \(chatstanza["uniqueid"])")
                
              //  sqliteDB.UpdateChatStatus(chatstanza["uniqueid"]!, newstatus: "sent")
                
                
                
                
                
                
                
                /////    DispatchQueue.main.async {
                //print("Am I back on the main thread: \(NSThread.isMainThread())")
                
                print("MAINNNNNNNNNNNN")
                completion(true)
                //self.retrieveChatFromSqlite(self.selectedContact)
                
                
                
                
                /////// }
            }
            else{
                completion(false)
                
                }
        }//)
        
    }
    

    
    @IBAction func btnRecordTouchDown(_ sender: UIButton) {
        
        print("btnRecordTouchDown")
        txtFieldMessage.text="< Slide left to cancel".localized
        self.startRecording()
    }
    
    
    @IBAction func btnRecordTouchUpInside(_ sender: UIButton) {
        txtFieldMessage.text=""
        print("btnRecordTouchUpInside")
        finishRecording(success: true)
        
        
        
    }
    
    
    
    @IBAction func btnRecordAudioTouchDragExit(_ sender: UIButton) {
        print("btnRecordAudioTouchDragExit")
        finishRecording(success: false)
        var deleted=audioRecorder.deleteRecording()
        print("audio deleted \(deleted)")
        txtFieldMessage.text=""
        //not saved
        //finishRecording(success: false)
        
        
    }
    
    func finishRecording(success: Bool) {
        audioRecorder.stop()
        ////audioRecorder = nil
        var filesize1=0
        if !success {
            
            btnSendAudio.setTitle("Record".localized, for: .normal)
            // recording failed :(
        }  else {
            btnSendAudio.setTitle("Record".localized, for: .normal)
            
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
            
            do {
                let fileAttributes : NSDictionary? = try FileManager.default.attributesOfItem(atPath: filePathImage2) as NSDictionary?
                if let _attr = fileAttributes {
                    //var filesize1 = _attr.fileSize();
                    filesize1=Int(_attr.fileSize());
                    //print("file size is \(self.fileSize1)")
                    //// ***april 2016 neww self.fileSize=(fileSize1 as! NSNumber).integerValue
                }
            } catch {
                socketObj.socket.emit("logClient","IPHONE-LOG: error: audio : \(error)")
                //print("Error:+++ \(error)")
            }
            
            
            
            ///var date=self.getDateString(Date())
            var status="pending"
            
            ///messages.add(["msg":txtFieldMessage.text!+" (pending)", "type":"2", "fromFullName":"","date":date,"uniqueid":uniqueid_chat])
            
            
            
            
            //save chat
            sqliteDB.storeGroupsChat(username!, group_unique_id1: self.groupid1, type1: "audio", msg1: self.filename, from_fullname1: username!, date1: Date(), unique_id1: uniqueID)
            
            
            
            //self.addUploadInfo(self.groupid,uniqueid1: uniqueid_chat, rowindex: self.messages.count, uploadProgress: 0.0, isCompleted: false)
            
            
            //get members and store status as pending
            for i in 0 ..< self.membersList.count
            {
                /*
                 let member_phone = Expression<String>("member_phone")
                 let isAdmin = Expression<String>("isAdmin")
                 let membership_status
                 */
                if((self.membersList[i]["member_phone"] as! String) != username! && (self.membersList[i]["membership_status"] as! String) != "left")
                {
                    print("adding group chat status for \(self.membersList[i]["member_phone"])")
                    sqliteDB.storeGRoupsChatStatus(uniqueID, status1: "pending", memberphone1: self.membersList[i]["member_phone"]! as! String, delivereddate1: UtilityFunctions.init().minimumDate(), readDate1: UtilityFunctions.init().minimumDate())
                    
                    sqliteDB.saveFile(self.membersList[i]["member_phone"]! as! String, from1: username!, owneruser1: username!, file_name1: self.filename, date1: nil, uniqueid1: uniqueID, file_size1: "\(filesize1)", file_type1: ftype, file_path1: filePathImage2, type1: "audio")
                    
                }
            }
            
            
            
            
            
            
            self.tblForGroupChat.reloadData()
            if(self.messages.count>1)
            {
                var indexPath = IndexPath(row:self.messages.count-1, section: 0)
                self.tblForGroupChat.scrollToRow(at: indexPath, at: UITableViewScrollPosition.bottom, animated: true)
                
                
                
            }
            
            
                       //// self.addUploadInfo(self.selectedContact,uniqueid1: uniqueID, rowindex: self.messages.count, uploadProgress: 0.0, isCompleted: false)
            
            print("uploading audio")
            managerFile.uploadFileInGroup(filePathImage2, groupid1:self.groupid1,from1:username!,uniqueid1:uniqueID,file_name1:self.filename,file_size1:"\(filesize1)",file_type1:ftype,type1:"audio")
            
            
            //uploadFileInGroup(_ filePath1:String,groupid1:String,from1:String, uniqueid1:String,file_name1:String,file_size1:String,file_type1:String,type1:String){
            
            
            
            //(filePathImage2, to1: self.selectedContact, from1: username!, uniqueid1: uniqueID, file_name1: self.filename, file_size1: "\(self.fileSize1)", file_type1: ftype,type1:"image")
            // })
            
            self.retrieveChatFromSqlite({ (result) in
                
                
                // })
                // (self.selectedContact,completion:{(result)-> () in
                DispatchQueue.main.async
                    {
                        self.tblForGroupChat.reloadData()
                        
                        if(self.messages.count>1)
                        {
                            print("scrollinggg 5032 line")
                            //var indexPath = NSIndexPath(forRow:self.messages.count-1, inSection: 0)
                            let indexPath = IndexPath(row:self.tblForGroupChat.numberOfRows(inSection: 0)-1, section: 0)
                            self.tblForGroupChat.scrollToRow(at: indexPath, at: UITableViewScrollPosition.bottom, animated: false)
                        }
                }
            })
            
            
            //add audio component
            //save to database
            //send chat
   
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
   
    
 
    override func viewWillAppear(_ animated: Bool) {
        
        
        //======== self.navigationController?.title=mytitle
        
        
       /* let swipeRecognizer = UISwipeGestureRecognizer(target: self, action: Selector("chatSwipped"))
        //Add the recognizer to your view.
        swipeRecognizer.direction = .left
        
        tblForGroupChat.addGestureRecognizer(swipeRecognizer)
        */
 
        UIDelegates.getInstance().delegateGroupChatDetails1=self
        membersList=sqliteDB.getGroupMembersOfGroup(self.groupid1)
        
   
        
        var namesList=[String]()
        for i in 0 ..< membersList.count
        {
            //var fullname=""
            if(membersList[i]["membership_status"] as! String != "left")
            {
            if((sqliteDB.getNameFromAddressbook(membersList[i]["member_phone"] as! String)) != nil)
            {
                namesList.append(sqliteDB.getNameFromAddressbook(membersList[i]["member_phone"]  as! String))
            }
            else
            {
                if((sqliteDB.getNameGroupMemberNameFromMembersTable(membersList[i]["member_phone"] as! String)) != nil)
                {
                    namesList.append(sqliteDB.getNameGroupMemberNameFromMembersTable(membersList[i]["member_phone"] as! String))
                }
                else
                {
                    namesList.append(membersList[i]["member_phone"] as! String)
                }
            }
        }
        }
        var subtitleMembers=namesList.joined(separator: ",").trunc(20)
      self.navigationItem.titleView = setTitle(mytitle, subtitle: subtitleMembers)
       // self.navigationItem.title = mytitle
       // self.navigationItem.prompt=subtitleMembers
  
        self.retrieveChatFromSqlite { (result) in
            
            
                self.tblForGroupChat.reloadData()
            
            if(self.messages.count>1)
            {
                
                if(self.searchUniqueid != nil)
                {
                    var predicate=NSPredicate(format: "uniqueid = %@", self.searchUniqueid)
                    var resultArray=self.messages.filtered(using: predicate)
                    if(resultArray.count > 0)
                    {
                        
                        var foundindex=self.messages.index(of: resultArray.first!)
                        let indexPath = IndexPath(row:foundindex, section: 0)
                        // self.tblForChats.seth
                        self.tblForGroupChat.cellForRow(at: indexPath)?.setHighlighted(true, animated: true)
                        self.tblForGroupChat.cellForRow(at: indexPath)?.backgroundColor=UIColor.lightGray
                        self.tblForGroupChat.scrollToRow(at: indexPath, at: UITableViewScrollPosition.bottom, animated: false)
                    }
                    else{
                        
                        let indexPath = IndexPath(row:self.tblForGroupChat.numberOfRows(inSection: 0)-1, section: 0)
                        self.tblForGroupChat.scrollToRow(at: indexPath, at: UITableViewScrollPosition.bottom, animated: false)
                    }
                    
                    
                }
                else{
                    
                    let indexPath = IndexPath(row:self.tblForGroupChat.numberOfRows(inSection: 0)-1, section: 0)
                    self.tblForGroupChat.scrollToRow(at: indexPath, at: UITableViewScrollPosition.bottom, animated: false)
                }
            }
            self.searchUniqueid=nil

               // var indexPath = IndexPath(row:self.messages.count-1, section: 0)
                
               // self.tblForGroupChat.scrollToRow(at: indexPath, at: UITableViewScrollPosition.bottom, animated: true)
            }
        
        
    }
    
    override func viewDidLoad() {
        
        
        
        locationManager.delegate = self
        
        self.btnSendChat.isEnabled=true
        self.btnSendAudio.isEnabled=true
        locationManager.delegate=self
       //   self.navigationItem.titleView = setTitle(mytitle, subtitle: "Sumaira,xyz,abc")
        messages=NSMutableArray()
        
        
        NotificationCenter.default.removeObserver(self, name:NSNotification.Name.UIApplicationWillResignActive, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(UIApplicationDelegate.applicationWillResignActive(_:)), name:NSNotification.Name.UIApplicationWillResignActive, object: nil)
        
        //
        
        NotificationCenter.default.removeObserver(self, name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(UIApplicationDelegate.applicationDidBecomeActive(_:)), name:NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
        
        
        
        
        NotificationCenter.default.removeObserver(self, name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(GroupChatingDetailController.keyboardWillShow(_:)), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        
       //uncomment later NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name: UIKeyboardWillHideNotification, object: nil)
        

       /* NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name: UIKeyboardWillHideNotification, object: nil)
        */
        
        
        if(groupimage != nil)
        {
            print("found group icon avatar \(self.navigationItem.rightBarButtonItems?.count)")
            
            /*
             //var w=imageavatar1!.size.width
             //  var h=imageavatar1!.size.height
             var wOld=(self.navigationController?.navigationBar.frame.height)!-5
             var hOld=(self.navigationController?.navigationBar.frame.width)!-5
             //var scale:CGFloat=w/wOld
             
             cell!.profilePic.layer.cornerRadius = cell!.profilePic.frame.size.width/2
             cell!.profilePic.clipsToBounds = true
             */
            //cell.profilePic.hnk_format=Format<UIImage>
            var scaledimagegroupicon=UIImage(data:groupimage)!.kf.resize(to: CGSize(width: (self.navigationController?.navigationBar.frame.height)!,height: (self.navigationController?.navigationBar.frame.height)!))
            
            /////////var scaledimage=ImageResizer(size: CGSize(width: (self.navigationController?.navigationBar.frame.height)!,height: (self.navigationController?.navigationBar.frame.height)!), scaleMode: .AspectFit, allowUpscaling: true, compressionQuality: 0.5)
            //var resizedimage=scaledimage.resizeImage(UIImage(data:ContactsProfilePic)!)
            //==---cell!.profilePic.hnk_setImage(scaledimage.resizeImage(UIImage(data:ContactsProfilePic)!), key: groupid1)
            
            
            ///var s=CGSizeMake((self.navigationController?.navigationBar.frame.height)!-5,(self.navigationController?.navigationBar.frame.height)!-5)
            ///////////var groupiconimage=scaledimage.resizeImage(UIImage(data:groupimage)!)
            
            
            var barAvatarImage=UIImageView.init(image: scaledimagegroupicon)
            
            ///var barAvatarImage=UIImageView.init(image: groupiconimage)
            
            barAvatarImage.layer.borderWidth = 1.0
            //==--barAvatarImage.layer.masksToBounds = false
            barAvatarImage.layer.borderColor = UIColor.white.cgColor
            //==---barAvatarImage.layer.cornerRadius = barAvatarImage.frame.size.width/2
            //==--- barAvatarImage.clipsToBounds = true
            
            //print("bav avatar size is \(barAvatarImage.frame.width) .. \(barAvatarImage.frame.width)")
            
            
            var avatarbutton=UIBarButtonItem.init(customView: barAvatarImage)
            self.navigationItem.rightBarButtonItems?.first?.customView = avatarbutton.customView
            
            //==---self.navigationItem.leftBarButtonItems?.insert(avatarbutton, atIndex: 1)
            
        }
        
        /*var filedata=sqliteDB.getFilesData(groupid1)
        if(filedata.count>0)
        {
            print("found group icon")
            print("actual path is \(filedata["file_path"])")
            //======
            
            //=======
            let dirPaths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
            let docsDir1 = dirPaths[0]
            var documentDir=docsDir1 as NSString
            var imgPath=documentDir.stringByAppendingPathComponent(filedata["file_name"] as! String)
            
            var imgNSData=NSFileManager.defaultManager().contentsAtPath(imgPath)

            //==
            var imageavatar1=UIImage.init(data:(imgNSData)!)
            //   imageavatar1=ResizeImage(imageavatar1!,targetSize: s)
            
            //var img=UIImage(data:ContactsProfilePic[indexPath.row])
            var w=imageavatar1!.size.width
            var h=imageavatar1!.size.height
            var wOld=(self.navigationController?.navigationBar.frame.height)!-5
            var hOld=(self.navigationController?.navigationBar.frame.width)!-5
            var scale:CGFloat=w/wOld
            
            
            ///var s=CGSizeMake((self.navigationController?.navigationBar.frame.height)!-5,(self.navigationController?.navigationBar.frame.height)!-5)
            
            var barAvatarImage=UIImageView.init(image: UIImage(data: (imgNSData)!,scale:scale))
            
            barAvatarImage.layer.borderWidth = 1.0
            barAvatarImage.layer.masksToBounds = false
            barAvatarImage.layer.borderColor = UIColor.whiteColor().CGColor
            barAvatarImage.layer.cornerRadius = barAvatarImage.frame.size.width/2
            barAvatarImage.clipsToBounds = true
            
            //print("bav avatar size is \(barAvatarImage.frame.width) .. \(barAvatarImage.frame.width)")
            
            var avatarbutton=UIBarButtonItem.init(customView: barAvatarImage)
            self.navigationItem.rightBarButtonItems?.insert(avatarbutton, atIndex: 0)
            
            //ContactsProfilePic.append(foundcontact.imageData!)
            //picfound=true
        }*/
  



    }
    
    func applicationDidBecomeActive(_ notification : Notification)
    {print("app active chat details view")
        //print("didbecomeactivenotification=========")
        //  NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("applicationWillResignActive:"), name:UIApplicationWillResignActiveNotification, object: nil)
        
        //
        //   NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("applicationDidBecomeActive:"), name:UIApplicationDidBecomeActiveNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(GroupChatingDetailController.keyboardWillShow(_:)), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        
        UIDelegates.getInstance().delegateGroupChatDetails1=self
        //// NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("willHideKeyBoard:"), name:UIKeyboardWillHideNotification, object: nil)
    }
    func applicationWillResignActive(_ notification : Notification){
        /////////self.view.endEditing(true)
        //print("applicationWillResignActive=========")
        NotificationCenter.default.removeObserver(self, name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        
    }
    

    func getDateString(_ datetime:Date)->String
    {
        let formatter2 = DateFormatter();
        formatter2.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        formatter2.timeZone = TimeZone.autoupdatingCurrent
        let defaultTimeeee = formatter2.string(from: datetime)
        return defaultTimeeee
    }
    
    
    func retrieveChatFromSqlite(_ completion:(_ result:Bool)->())
    {
        //print("retrieveChatFromSqlite called---------")
        ///^^messages.removeAllObjects()
        var messages2=NSMutableArray()
        
        let from = Expression<String>("from")
        let group_unique_id = Expression<String>("group_unique_id")
        let type = Expression<String>("type")
        let msg = Expression<String>("msg")
        let from_fullname = Expression<String>("from_fullname")
        let date = Expression<Date>("date")
        let unique_id = Expression<String>("unique_id")
        
        var tbl_userchats=sqliteDB.group_chat
        var res=tbl_userchats?.filter(group_unique_id==groupid1)
        //to==selecteduser || from==selecteduser
        //print("chat from sqlite is")
        //print(res)
        do
        {
            
            //for tblContacts in try sqliteDB.db.prepare(tbl_userchats.filter(owneruser==owneruser1)){
            ////print("queryy runned count is \(tbl_contactslists.count)")
            for tblUserChats in try sqliteDB.db.prepare((tbl_userchats?.filter(group_unique_id==groupid1).order(date.asc))!){
                
                print("data of group table chat got is \(tblUserChats)")
                //print("===fetch date from database is tblContacts[date] \(tblContacts[date])")
                /*
                 var formatter = NSDateFormatter();
                 formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS";
                 //formatter.dateFormat = "MM/dd hh:mm a"";
                 formatter.timeZone = NSTimeZone(name: "UTC")
                 */
                // formatter.timeZone = NSTimeZone.local()
                // var defaultTimeZoneStr = formatter.dateFromString(tblContacts[date])
                // var defaultTimeZoneStr2 = formatter.stringFromDate(defaultTimeZoneStr!)
                
                
                var formatter2 = DateFormatter();
                formatter2.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
                formatter2.timeZone = NSTimeZone.local
                var defaultTimeeee = formatter2.string(from: tblUserChats[date])
                
                var fullname=""
                if((sqliteDB.getNameFromAddressbook(tblUserChats[from])) != nil)
                {
                    fullname=sqliteDB.getNameFromAddressbook(tblUserChats[from])
                }
                else
                {
                    if((sqliteDB.getNameGroupMemberNameFromMembersTable(tblUserChats[from])) != nil)
                    {
                        fullname=sqliteDB.getNameGroupMemberNameFromMembersTable(tblUserChats[from])
                    }
                    else
                    {
                        fullname=tblUserChats[from]
                    }
                }
                
                //print("===fetch date from database is tblContacts[date] ... date converted is \(defaultTimeZoneStr)... string is \(defaultTimeZoneStr2)... defaultTimeeee \(defaultTimeeee)")
                
                /*//print(tblContacts[to])
                 //print(tblContacts[from])
                 //print(tblContacts[msg])
                 //print(tblContacts[date])
                 //print(tblContacts[status])
                 //print("--------")
                 */
                
                
                
                
                //uncomment later
                if(tblUserChats[from] != username!)
                    
                    //&& (sqliteDB.getGroupsChatStatusSingle(tblUserChats[unique_id], user_phone1: username!)=="delivered"))
                {
                    var singleStatus=sqliteDB.getGroupsChatStatusSingle(tblUserChats[unique_id], user_phone1: username!)
                   
                    if(singleStatus == "delivered")
                    {print("yes it is delivered")
                        
                    sqliteDB.saveGroupStatusTemp("seen", sender1: tblUserChats[from], messageuniqueid1: tblUserChats[unique_id])
                     self.sendGroupChatStatus(tblUserChats[unique_id],status1: "seen")
                    }

                  /*  for(var i=0;i<membersList.count;i++)
                    {
                        /*
                         let member_phone = Expression<String>("member_phone")
                         let isAdmin = Expression<String>("isAdmin")
                         let membership_status
                         */
                        
                        if((membersList[i]["member_phone"] as! String) != username! && (membersList[i]["membership_status"] as! String) != "left")
                        {
                            //unique_id
                           var singleStatusObject=sqliteDB.getGroupsChatStatusSingle(tblUserChats[unique_id], user_phone1: membersList[i]["member_phone"] as! String)
                            if(singleStatusObject["Status"] == "delivered")
                            {
                                sqliteDB.updateGroupChatStatus(tblContacts[uniqueid],status: "seen",sender: tblContacts[from], delivereddate1: NSDate(), readDate1:NSDate())
                                self.sendGroupChatStatus(tblContacts[uniqueid],"seen")
                                
                            }
                        }
                        
                    }
                     
                     
                    
                    */
                    //sqliteDB.updateGroupChatStatus(tblUserChats[unique_id], memberphone1: username!, status1: "seen")
                    
                    //==done sqliteDB.UpdateChatStatus(tblContacts[uniqueid], newstatus: "seen")
                    
                    
                    
                    
                    //== do later saving temprarily === sqliteDB.saveMessageStatusSeen("seen", sender1: tblContacts[from], uniqueid1: tblContacts[uniqueid])
                    
                    //===sendChatStatusUpdateMessage(tblContacts[uniqueid],status: "seen",sender: tblContacts[from])
                    
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
                    
                   //}

                    
                   /* if(tblContacts[from]==selecteduser && (tblContacts[status]=="delivered"))
                    {
                        sqliteDB.UpdateChatStatus(tblContacts[uniqueid], newstatus: "seen")
                        
                        sqliteDB.saveMessageStatusSeen("seen", sender1: tblContacts[from], uniqueid1: tblContacts[uniqueid])
                        
                        self.sendChatStatusUpdateMessage(tblContacts[uniqueid],status: "seen",sender: tblContacts[from])
                    }*/
                }
 
 
                if(tblUserChats[type].lowercased()=="log")//check left
                {
                    
                    
                    var memStatus=sqliteDB.getMemberShipStatus(self.groupid1, memberphone: username!)
                   if(memStatus == "left")
                   {
                    self.txtFieldMessage.text="You left the group".localized
                    self.chatComposeView.isUserInteractionEnabled=false
                    }
                }
                
                if (tblUserChats[from]==username!)
                {
                    var status="pending"
                    
                    var allseen=sqliteDB.checkGroupMessageisAllSeen(tblUserChats[unique_id], members_phones1: membersList)
                    if(allseen==true)
                    {
                        status="seen"
                    }
                    else
                    {
                        var alldelivered=sqliteDB.checkGroupMessageisAllDelevered(tblUserChats[unique_id], members_phones1: membersList)
                        if(alldelivered==true)
                        {
                            status="delivered"
                        }
                        else{
                            var allsent=sqliteDB.checkGroupMessageisAnySent(tblUserChats[unique_id], members_phones1: membersList)
                            if(allsent==true)
                            {
                                status="sent"
                            }
                        }
                    }
                    if(tblUserChats[type]=="image")
                    {
                        messages2.add(["msg":tblUserChats[msg],"type":"4", "fromFullName":fullname,"date":defaultTimeeee, "uniqueid":tblUserChats[unique_id],"filename":tblUserChats[msg],"status":status])
                    }
                    if(tblUserChats[type]=="audio")
                    {
                        messages2.add(["msg":tblUserChats[msg],"type":"12", "fromFullName":fullname,"date":defaultTimeeee, "uniqueid":tblUserChats[unique_id],"filename":tblUserChats[msg],"status":status])
                    }
                    if(tblUserChats[type]=="document")
                    {
                        //  var filedownloaded=sqliteDB.checkIfFileExists(tblContacts[uniqueid])
                        
                        /* if(filedownloaded==false)
                         {
                         //checkpendingfiles
                         managerFile.checkPendingFiles(tblContacts[uniqueid])
                         }*/
                        ////  self.addUploadInfo(selectedContact, uniqueid1: tblContacts[uniqueid], rowindex: messages.count, uploadProgress: 1, isCompleted: true)
                        
                       messages2.add(["msg":tblUserChats[msg]+" (\(status))","type":"6", "fromFullName":fullname,"date":defaultTimeeee, "uniqueid":tblUserChats[unique_id],"filename":tblUserChats[msg],"status":status])
                        //^^^^ self.addMessage(tblContacts[msg], ofType: "6",date: tblContacts[date],uniqueid: tblContacts[uniqueid])
                        
                    }
                    
                    if(tblUserChats[type]=="video")
                    {
                          messages2.add(["msg":tblUserChats[msg],"type":"10", "fromFullName":fullname,"date":defaultTimeeee, "uniqueid":tblUserChats[unique_id],"filename":tblUserChats[msg],"status":status])
                        
                       /// messages2.add(["message":tblContacts[msg],"status":tblContacts[status], "type":"10", "date":defaultTimeeee, "uniqueid":tblContacts[uniqueid]])
                    }
                    
                    if(tblUserChats[type]=="location")
                    {
                         messages2.add(["msg":tblUserChats[msg], "type":"14", "fromFullName":fullname,"date":defaultTimeeee, "uniqueid":tblUserChats[unique_id],"status":status])
                        
                        
                    }
                    
                    
                    if(tblUserChats[type]=="contact")
                    {
                        
                         messages2.add(["msg":tblUserChats[msg]+" (\(status))", "type":"8", "fromFullName":fullname,"date":defaultTimeeee, "uniqueid":tblUserChats[unique_id],"status":status])
                        
                        
                    
                        
                        
                    }
                    
                    
                    if(tblUserChats[type]=="chat")
                    {

                    //messages2.add(["message":tblContacts[msg]+" (\(tblContacts[status]))","filename":tblContacts[msg],"type":"4", "date":defaultTimeeee, "uniqueid":tblContacts[uniqueid]])
                    

                            messages2.add(["msg":tblUserChats[msg]+" (\(status))", "type":"2", "fromFullName":fullname,"date":defaultTimeeee, "uniqueid":tblUserChats[unique_id],"status":status])
                    }
                }
                else
                {
                    if(tblUserChats[type]=="image")
                    {
                        var filedownloaded=sqliteDB.checkIfFileExists(tblUserChats[unique_id])
                        
                        if(filedownloaded==false)
                        {
                            //checkpendingfiles
                            
                            managerFile.checkPendingFilesInGroup(tblUserChats[unique_id])
                        }

                        messages2.add(["msg":tblUserChats[msg],"type":"3", "fromFullName":fullname,"date":defaultTimeeee, "uniqueid":tblUserChats[unique_id],"filename":tblUserChats[msg],"status":""])
                    }
                    if(tblUserChats[type]=="audio")
                    {
                        print("checking if audio is pending")
                        var filedownloaded=sqliteDB.checkIfFileExists(tblUserChats[unique_id])
                        
                        if(filedownloaded==false)
                        {
                            print("audio is not downloaded locally")
                            //checkpendingfiles
                            
                            managerFile.checkPendingFilesInGroup(tblUserChats[unique_id])
                        }
                        
                        
                         messages2.add(["msg":tblUserChats[msg], "type":"11", "fromFullName":fullname,"date":defaultTimeeee, "uniqueid":tblUserChats[unique_id]])
                    }
                    if(tblUserChats[type]=="document")
                    {
                        //  var filedownloaded=sqliteDB.checkIfFileExists(tblContacts[uniqueid])
                        var filedownloaded=sqliteDB.checkIfFileExists(tblUserChats[unique_id])
                         print("checking if document is pending")
                        if(filedownloaded==false)
                        {
                            print("document is not downloaded locally")
                            //checkpendingfiles
                            
                            managerFile.checkPendingFilesInGroup(tblUserChats[unique_id])
                        }
                        /* if(filedownloaded==false)
                         {
                         //checkpendingfiles
                         managerFile.checkPendingFiles(tblContacts[uniqueid])
                         }*/
                        ////  self.addUploadInfo(selectedContact, uniqueid1: tblContacts[uniqueid], rowindex: messages.count, uploadProgress: 1, isCompleted: true)
                        
                      messages2.add(["msg":tblUserChats[msg], "type":"5", "fromFullName":fullname,"date":defaultTimeeee, "uniqueid":tblUserChats[unique_id],"filename":tblUserChats[msg]])
                        //^^^^ self.addMessage(tblContacts[msg], ofType: "6",date: tblContacts[date],uniqueid: tblContacts[uniqueid])
                        
                    }
                    
                    if(tblUserChats[type]=="video")
                    {
                        print("checking if video is pending")
                        var filedownloaded=sqliteDB.checkIfFileExists(tblUserChats[unique_id])
                        
                        if(filedownloaded==false)
                        {
                            print("video is not downloaded locally")
                            //checkpendingfiles
                            
                            managerFile.checkPendingFilesInGroup(tblUserChats[unique_id])
                        }
                        
                        print("found video received")
                        messages2.add(["msg":tblUserChats[msg], "type":"9", "fromFullName":fullname,"date":defaultTimeeee, "uniqueid":tblUserChats[unique_id],"filename":tblUserChats[msg]])

                        
                    }
                    
                    if(tblUserChats[type]=="location")
                    {
                        
                        messages2.add(["msg":tblUserChats[msg], "type":"13", "fromFullName":fullname,"date":defaultTimeeee, "uniqueid":tblUserChats[unique_id]])
                        
                    }
                    
                    
                    if(tblUserChats[type]=="contact")
                    {
                        print("found contact received")
                        
                        
                         messages2.add(["msg":tblUserChats[msg], "type":"7", "fromFullName":fullname,"date":defaultTimeeee, "uniqueid":tblUserChats[unique_id]])
                        
                    }

                    
                    
                    
                    if(tblUserChats[type]=="chat"){
                    messages2.add(["msg":tblUserChats[msg], "type":"1", "fromFullName":fullname,"date":defaultTimeeee, "uniqueid":tblUserChats[unique_id]])
                    }
             
                }
                
                
            }
            ////////// self.messages.removeAllObjects()
            messages.setArray(messages2 as [AnyObject])
            ////////////self.messages.addObjectsFromArray(messages2 as [AnyObject])
            
            
            completion(true)
            /*
             self.tblForChats.reloadData()
             
             if(self.messages.count>1)
             {
             var indexPath = NSIndexPath(forRow:self.messages.count-1, inSection: 0)
             
             self.tblForChats.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Bottom, animated: true)
             }*/
            
        }
        catch(let error)
        {
            //print(error)
        }
        /////var tbl_userchats=sqliteDB.db["userschats"]
        
    }
    
    
    func addMessage(_ message: String, ofType msgType:String, date:String, uniqueid:String)
    {
        messages.add(["message":message, "type":msgType, "date":date, "uniqueid":uniqueid])
    }
    
    //uncomment later
    /*func textFieldShouldReturn (textField: UITextField!) -> Bool{
        txtFieldMessage.resignFirstResponder()
        return true
    
    }*/
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAtIndexPath indexPath: IndexPath) -> CGFloat {
        
        ////======return 60
        if(messages.count > 0 && (messages.count > indexPath.row))
        {
            
        var messageDic = messages.object(at: indexPath.row) as! [String : String];
        
        let msg = messageDic["msg"] as NSString!
        let msgType = messageDic["type"]! as NSString
        
        if(msgType.isEqual(to: "3") || msgType.isEqual(to: "13"))
        {
            //FileImageSentCell
            let cell = tblForGroupChat.dequeueReusableCell(withIdentifier: "FileImageSentCell")! as UITableViewCell
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
        else{
        if(msgType.isEqual(to: "14")||msgType.isEqual(to: "4"))
        {
            let cell = tblForGroupChat.dequeueReusableCell(withIdentifier: "FileImageReceivedCell")! as UITableViewCell
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
            if(msgType.isEqual(to: "7") || msgType.isEqual(to: "8") || msgType.isEqual(to: "11") || msgType.isEqual(to: "12"))
            {
                let cell = tblForGroupChat.dequeueReusableCell(withIdentifier: "ContactSentCell")! as UITableViewCell
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
            let sizeOFStr = self.getSizeOfString(msg!)
            
            return sizeOFStr.height + 70
                }
            }
        }
        }
    }
        else{
            return 0

        }
    }
    
    func numberOfSectionsInTableView(_ tableView: UITableView) -> Int {
        
        return 1
    }
    
    
    func chatSwipped(_ sender : UISwipeGestureRecognizer)
    {
        let gesture:UISwipeGestureRecognizer = sender as! UISwipeGestureRecognizer
        if(gesture.direction == .left)
        {
            
            var location = gesture.location(in: tblForGroupChat)
            print("swipe location is \(location)")
            var swipedIndexPath = tblForGroupChat.indexPathForRow(at: location)
            swipedRow=swipedIndexPath!.row
            print("swiped row is \(swipedRow)")
           var swipedCell  = tblForGroupChat.cellForRow(at: swipedIndexPath!)

            
            
           // swipeGesture.i
            self.performSegue(withIdentifier: "groupMessageInfoSegue", sender: nil)
            /*var frame:CGRect = self.mainView.frame;
            frame.origin.x = -self.leftButton.frame.width;
            self.mainView.frame = frame;*/
        }
       
        
    }
    
     func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        
      
         var cell = tblForGroupChat.dequeueReusableCell(withIdentifier: "ChatReceivedCell")! as UITableViewCell
        var messageDic = messages.object(at: indexPath.row) as! [String : String];
       // NSLog(messageDic["message"]!, 1)
        let msgType = messageDic["type"] as NSString!
        let msg = messageDic["msg"] as NSString!
        let date2=messageDic["date"] as NSString!
        let fullname=messageDic["fromFullName"] as NSString!
        var sizeOFStr = self.getSizeOfString(msg!)
        let uniqueidDictValue=messageDic["uniqueid"] as NSString!
        
        
        if(msgType?.isEqual("2"))!
        {
            print("my msg \(msg)")
            //i am sender
             cell = tblForGroupChat.dequeueReusableCell(withIdentifier: "ChatReceivedCell")! as UITableViewCell
            let msgLabel = cell.viewWithTag(12) as! ActiveLabel
            let chatImage = cell.viewWithTag(1) as! UIImageView
            let timeLabel = cell.viewWithTag(11) as! UILabel
            
            
            
            
            
            let distanceFactor = (197.0 - sizeOFStr.width) < 107 ? (197.0 - sizeOFStr.width) : 107
            //// //print("distanceFactor for \(msg) is \(distanceFactor)")
            
            chatImage.frame = CGRect(x: 20 + distanceFactor, y: chatImage.frame.origin.y, width: ((sizeOFStr.width + 107)  > 207 ? (sizeOFStr.width + 107) : 200), height: sizeOFStr.height + 40)
            ////    //print("chatImage.x for \(msg) is \(20 + distanceFactor) and chatimage.wdith is \(chatImage.frame.width)")
            
            
            msgLabel.isHidden=false
            //chatImage.frame = CGRectMake(20 + distanceFactor, chatImage.frame.origin.y, ((sizeOFStr.width + 100)  > 200 ? (sizeOFStr.width + 100) : 200), sizeOFStr.height + 40)
            chatImage.image = UIImage(named: "chat_send")?.stretchableImage(withLeftCapWidth: 40,topCapHeight: 20);
            //*********
            
            msgLabel.frame = CGRect(x: 36 + distanceFactor, y: msgLabel.frame.origin.y, width: msgLabel.frame.size.width, height: sizeOFStr.height)
            
            // //print("date received in chat is \(date2.debugDescription)")
            let formatter = DateFormatter();
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS";
            //formatter.dateFormat = "MM/dd hh:mm a"";
            formatter.timeZone = TimeZone.autoupdatingCurrent
            let defaultTimeZoneStr = formatter.date(from: date2 as! String)
            //print("defaultTimeZoneStr \(defaultTimeZoneStr)")
            timeLabel.frame = CGRect(x: 36 + distanceFactor, y: msgLabel.frame.origin.y+msgLabel.frame.height+10, width: chatImage.frame.size.width-46, height: timeLabel.frame.size.height)
            
            if(defaultTimeZoneStr == nil)
            {
                timeLabel.text=date2! as! String
            }
            else
            {
                let formatter2 = DateFormatter();
                formatter2.timeZone=TimeZone.autoupdatingCurrent
                formatter2.dateFormat = "MM/dd hh:mm a";
                let displaydate=formatter2.string(from: defaultTimeZoneStr!)
                //formatter.dateFormat = "MM/dd hh:mm a"";
                
                
                
               //== uncomment later timeLabel.frame = CGRectMake(36 + distanceFactor, timeLabel.frame.origin.y, timeLabel.frame.size.width, timeLabel.frame.size.height)
                
                timeLabel.text=displaydate

            }
            
            let swipeRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(self.chatSwipped(_:)))
                //Selector("chatSwipped:"))
            //Add the recognizer to your view.
            swipeRecognizer.direction = .left
            chatImage.addGestureRecognizer(swipeRecognizer)
            msgLabel.text=msg as! String
            
          //  textLable.text = msg! as! String
            msgLabel.numberOfLines = 0
            msgLabel.enabledTypes = [.mention, .hashtag, .url]
            // textLable.text = "This is a post with #hashtags and a @userhandle."
            msgLabel.textColor = .black
            msgLabel.handleHashtagTap { hashtag in
                print("Success. You just tapped the \(hashtag) hashtag")
            }
            msgLabel.handleURLTap({ (url) in
                print("Success. You just tapped the \(url) url")
                var stringURL="\(url)"
                if !(stringURL.contains("http")) {
                    stringURL = "http://" + stringURL
                }
                
                var res=UIApplication.shared.openURL(NSURL.init(string: stringURL) as! URL)
                print("open url \(res)")
            })

            
            return cell
        
        }
            
        //if(msgType.isEqual("1"))
        
        else{

            if (msgType?.isEqual(to: "4"))!{
                cell = ///tblForChats.dequeueReusableCellWithIdentifier("ChatReceivedCell")! as UITableViewCell
                    
                    //FileImageReceivedCell
                    tblForGroupChat.dequeueReusableCell(withIdentifier: "FileImageReceivedCell")! as UITableViewCell
                
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
                
                let filename=messageDic["filename"]! as! NSString
                let status=(msg as! String).replacingOccurrences(of: filename as String, with: "", options: NSString.CompareOptions.literal, range: nil)
                
                let dirPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
                let docsDir1 = dirPaths[0]
                let documentDir=docsDir1 as NSString
                
                let imgPath=documentDir.appendingPathComponent(filename as String)
                //  print("uniqueid image is \(uniqueidDictValue) filename is \(filename) imgPath is \(imgPath)")
                
                let imgNSData=FileManager.default.contents(atPath: imgPath)
                
                //====     print("imgNSData is \(imgNSData)")
                
                //var imgNSData=NSFileManager.default.contents(atPath:imgPath.path!)
                //print("hereee imgPath.path! is \(imgPath)")
                
                timeLabel.frame = CGRect(x: chatImage.frame.origin.x, y: chatImage.frame.origin.y+180, width: chatImage.frame.width,  height: timeLabel.frame.height)
                
                
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
                    let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(GroupChatingDetailController.imageTapped(_:)))
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
                    
                    timeLabel.text="\(displaydate) \(status)"
                    // timeLabel.text=date2.debugDescription
                }
                timeLabel.text="\(displaydate) \(status)"
                
                /* var imgNSURL = NSURL(fileURLWithPath: msg as String)
                 var imgNSData=NSFileManager.default.contents(atPath:imgNSURL.path!)
                 if(imgNSData != nil)
                 {
                 chatImage.image = UIImage(contentsOfFile: msg as String)
                 //print("file shownnnnnnnnn")
                 }
                 */
            }

            else{
                if(msgType?.isEqual(to: "3"))!
                
                    {
                        cell = ///tblForChats.dequeueReusableCellWithIdentifier("ChatReceivedCell")! as UITableViewCell
                            
                            //FileImageReceivedCell
                            tblForGroupChat.dequeueReusableCell(withIdentifier: "FileImageSentCell")! as UITableViewCell
                        
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
                        
                        let filename=messageDic["filename"] as NSString!
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
                        
                        if(imgNSData != nil/* && (cell.tag == indexPath.row)*/)
                        {
                            chatImage.isUserInteractionEnabled = true
                            
                            
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
                            let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(GroupChatingDetailController.imageTapped(_:)))
                            //Add the recognizer to your view.
                            chatImage.addGestureRecognizer(tapRecognizer)
                            
                            
                            chatImage.frame = CGRect(x: chatImage.frame.origin.x, y: chatImage.frame.origin.y, width: 200, height: 200)
                            
                            chatImage.image = UIImage(data: imgNSData!)!
                            ///.stretchableImageWithLeftCapWidth(40,topCapHeight: 20);
                            chatImage.contentMode = .scaleAspectFill
                            //===== uncomment later chatImage.setNeedsDisplay()
                            //print("file shownnnnnnnnn")
                            textLable.isHidden=true
                            
                            
                            timeLabel.text="\(displaydate) (\(status))"
                            //timeLabel.text=date2.debugDescription
                        }
                        
                        timeLabel.text="\(displaydate) (\(status))" /* var imgNSURL = NSURL(fileURLWithPath: msg as String)
                         var imgNSData=NSFileManager.default.contents(atPath:imgNSURL.path!)
                         if(imgNSData != nil)
                         {
                         chatImage.image = UIImage(contentsOfFile: msg as String)
                         //print("file shownnnnnnnnn")
                         }
                         */
                    }
                else{
                    
                    
                    if(msgType?.isEqual(to: "11"))!
                    {
                        //audio received
                        print("audio received is \(msg)")
                        cell = tblForGroupChat.dequeueReusableCell(withIdentifier: "AudioReceivedCell")! as UITableViewCell
                        if(cell==nil)
                        {
                            cell = tblForGroupChat.dequeueReusableCell(withIdentifier: "AudioReceivedCell")! as UITableViewCell
                        }
                        let textLable = cell.viewWithTag(12) as! UILabel
                        let chatImage = cell.viewWithTag(1) as! UIImageView
                        let profileImage = cell.viewWithTag(2) as! UIImageView
                        let timeLabel = cell.viewWithTag(11) as! UILabel
                        let buttonSave = cell.viewWithTag(16) as! UIButton
                        
                        audioFilePlayName=msg! as! String
                        /*buttonSave.addTarget(self, action: #selector(ChatDetailViewController.BtnPlayAudioClicked(_:)), for:.touchUpInside)
                         */
                        
                        textLable.text = msg! as! String
                        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(GroupChatingDetailController.BtnPlayAudioClicked(_:)))
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
                    else
                    {if(msgType?.isEqual(to: "12"))!
                    {
                        
                        print("UI chat type is \(msgType!)")
                        cell=tblForGroupChat.dequeueReusableCell(withIdentifier: "AudioSentCell")!
                        if(cell==nil)
                        {
                            cell = tblForGroupChat.dequeueReusableCell(withIdentifier: "AudioSentCell")! as UITableViewCell
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
                        
                        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(GroupChatingDetailController.BtnPlayAudioClicked(_:)))
                        //Add the recognizer to your view.
                        
                        cell.contentView.addGestureRecognizer(tapRecognizer)
                        
                        
                        
                        
                        //local date already shortened then added to dictionary when post button is pressed
                        //timeLabel.text=date2.debugDescription
                    }
                    else{
                        
                        if(msgType?.isEqual(to: "6"))!
                        {
                            //print("type is 6 hereeeeeeeeeeee")
                            cell = ///tblForChats.dequeueReusableCellWithIdentifier("ChatReceivedCell")! as UITableViewCell
                                
                                //FileImageReceivedCell
                                tblForGroupChat.dequeueReusableCell(withIdentifier: "DocReceivedCell")! as UITableViewCell
                            let deliveredLabel = cell.viewWithTag(13) as! UILabel
                            let textLable = cell.viewWithTag(12) as! UILabel
                            let timeLabel = cell.viewWithTag(11) as! UILabel
                            let chatImage = cell.viewWithTag(1) as! UIImageView
                            let profileImage = cell.viewWithTag(2) as! UIImageView
                            let progressView=cell.viewWithTag(14) as! KDCircularProgress
                            
                            
                            
                            // let distanceFactor = (170.0 - sizeOFStr.width) < 100 ? (170.0 - sizeOFStr.width) : 100
                            
                            let distanceFactor = (197.0 - sizeOFStr.width) < 107 ? (197.0 - sizeOFStr.width) : 107
                            
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
                            
                            chatImage.frame = CGRect(x: 20 + distanceFactor, y: chatImage.frame.origin.y, width: ((sizeOFStr.width + 107)  > 207 ? (sizeOFStr.width + 107) : 200), height: correctheight + 30)
                            chatImage.image = UIImage(named: "chat_send")?.stretchableImage(withLeftCapWidth: 40,topCapHeight: 20);
                            //*********
                            
                            //getSizeOfStringHeight(msg).height
                            
                            textLable.frame = CGRect(x: 60 + distanceFactor, y: textLable.frame.origin.y, width: chatImage.frame.width-70, height: correctheight)
                            
                            
                            // newwwwwwwwww textLable.frame = CGRectMake(26 + distanceFactor, textLable.frame.origin.y, chatImage.frame.width-36, getSizeOfStringHeight(msg).height)
                            // print("new height is \(textLable.frame.height) msg is \(msg)")
                            //=====newwwwwww  textLable.frame = CGRectMake(26 + distanceFactor,
                            
                            
                            timeLabel.frame = CGRect(x: 36 + distanceFactor, y: textLable.frame.origin.y+textLable.frame.height, width: chatImage.frame.size.width-46, height: timeLabel.frame.size.height)
                            
                            profileImage.center = CGPoint(x: 45+distanceFactor, y: chatImage.frame.origin.y + (profileImage.frame.size.height)/2+5)
                            
                            
                            
                            
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
                        else{
                            if(msgType?.isEqual(to: "5"))!
                            {
                                //print("type is 5 hereeeeeeeeeeee")
                                cell = ///tblForChats.dequeueReusableCellWithIdentifier("ChatReceivedCell")! as UITableViewCell
                                    
                                    //FileImageReceivedCell
                                    tblForGroupChat.dequeueReusableCell(withIdentifier: "DocSentCell")! as UITableViewCell
                                let deliveredLabel = cell.viewWithTag(13) as! UILabel
                                let textLable = cell.viewWithTag(12) as! UILabel
                                let timeLabel = cell.viewWithTag(11) as! UILabel
                                let chatImage = cell.viewWithTag(1) as! UIImageView
                                let profileImage = cell.viewWithTag(2) as! UIImageView
                                let progressView=cell.viewWithTag(14) as! KDCircularProgress
                                
                                let distanceFactor = (170.0 - sizeOFStr.width) < 100 ? (170.0 - sizeOFStr.width) : 100
                                
                                
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
                                chatImage.image = UIImage(named: "chat_receive")?.stretchableImage(withLeftCapWidth: 40,topCapHeight: 20);
                                
                                chatImage.frame = CGRect(x: chatImage.frame.origin.x, y: chatImage.frame.origin.y, width: ((sizeOFStr.width + 100)  > 200 ? (sizeOFStr.width + 100) : 200), height: correctheight + 50)
                                
                                
                                
                                
                                textLable.frame = CGRect(x: 60, y: textLable.frame.origin.y, width: chatImage.frame.width-70, height: correctheight)
                                
                                
                                // newwwwwwwwww textLable.frame = CGRectMake(26 + distanceFactor, textLable.frame.origin.y, chatImage.frame.width-36, getSizeOfStringHeight(msg).height)
                                //print("new height is \(textLable.frame.height) msg is \(msg)")
                                //=====newwwwwww  textLable.frame = CGRectMake(26 + distanceFactor,
                                
                                
                                timeLabel.frame = CGRect(x: 35, y: textLable.frame.origin.y+textLable.frame.height, width: chatImage.frame.size.width-46, height: timeLabel.frame.size.height)
                                
                                profileImage.center = CGPoint(x: 45, y: chatImage.frame.origin.y + (profileImage.frame.size.height)/2+5)
                                
                                
                                
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
                            else{
                                
                                if(msgType?.isEqual(to: "9"))!
                                {
                                    print("video received is \(msg)")
                                    cell = tableView.dequeueReusableCell(withIdentifier: "VideoReceivedCell")! as UITableViewCell
                                    if(cell==nil)
                                    {
                                        cell = tblForGroupChat.dequeueReusableCell(withIdentifier: "VideoReceivedCell")! as UITableViewCell
                                    }
                                    
                                    let videoView = cell.viewWithTag(0)
                                    let videoLabel = videoView?.viewWithTag(1) as! UILabel
                                    let timeLabel = videoView?.viewWithTag(3) as! UILabel
                                    
                                    videoLabel.text=msg! as! String
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
                                    //var status=messageDic["status"] as! NSString
                                    timeLabel.text=displaydate///////+" (\(status as! String))"
                                    
                                    let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(GroupChatingDetailController.videoTapped(_:)))
                                    //Add the recognizer to your view.
                                    videoView?.addGestureRecognizer(tapRecognizer)
                                    
                                    
                                }
                                else{
                                
                                    
                                    if(msgType?.isEqual(to: "10"))!
                                    {
                                        print("video sent is \(msg)")
                                        cell = tableView.dequeueReusableCell(withIdentifier: "VideoSentCell")! as UITableViewCell
                                        if(cell==nil)
                                        {
                                            cell = tblForGroupChat.dequeueReusableCell(withIdentifier: "VideoSentCell")! as UITableViewCell
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
                                        
                                        var status=messageDic["status"] as! NSString
                                        let formatter = DateFormatter()
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
                                        
                                        
                                        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(GroupChatingDetailController.videoTapped(_:)))
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
                                    
                                    else{
                                        
                                        if (msgType?.isEqual(to: "13"))!{
                                            cell = ///tblForChats.dequeueReusableCellWithIdentifier("ChatReceivedCell")! as UITableViewCell
                                                
                                                //FileImageReceivedCell
                                                tblForGroupChat.dequeueReusableCell(withIdentifier: "LocationReceivedCell")! as UITableViewCell
                                            
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
                                            
                                            var url=URL.init(string: "http://maps.google.com/maps/api/staticmap?center=\(latitude),\(longitude)&zoom=18&size=500x300&sensor=TRUE_OR_FALSE")
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
                                        else{
                                            
                                            if (msgType?.isEqual(to: "14"))!{
                                                cell = ///tblForChats.dequeueReusableCellWithIdentifier("ChatReceivedCell")! as UITableViewCell
                                                    
                                                    //FileImageReceivedCell
                                                    tblForGroupChat.dequeueReusableCell(withIdentifier: "LocationSentCell")! as UITableViewCell
                                                
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
                                                
                                                let contactinfo=msg!.components(separatedBy: ":") ///return array string
                                                var latitude = contactinfo[0]
                                                //var longitude = contactinfo[1]
                                                
                                                //coz message has mag+ \(status)
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
                                                
                                                var status=messageDic["status"] as! NSString
                                                timeLabel.text="\(displaydate) \(status)"
                                                
                                            }
                                            else{
                                            
                                        
                                                if(msgType?.isEqual(to: "7"))!
                                                {
                                                    print("contact received is \(msg)")
                                                    cell = tblForGroupChat.dequeueReusableCell(withIdentifier: "ContactReceivedCell")! as UITableViewCell
                                                    if(cell==nil)
                                                    {
                                                        cell = tblForGroupChat.dequeueReusableCell(withIdentifier: "ContactReceivedCell")! as UITableViewCell
                                                        
                                                    }
                                                    let textLable = cell.viewWithTag(12) as! UILabel
                                                    let chatImage = cell.viewWithTag(1) as! UIImageView
                                                    let profileImage = cell.viewWithTag(22) as! UIImageView
                                                    let timeLabel = cell.viewWithTag(11) as! UILabel
                                                    
                                                                                                       ///let buttonSave = cell.viewWithTag(15) as! UIButton
                                                    
                                                    let buttonsView = cell.viewWithTag(16)! as UIView
                                                    let btnInviteView = buttonsView.viewWithTag(0) as! UIButton
                                                    let btnSaveView = buttonsView.viewWithTag(1) as! UIButton
                                                    let btnMessageView = buttonsView.viewWithTag(2) as! UIButton
                                                    
                                                    //buttonSave.tag=indexPath.row
                                                   // buttonSave.isHidden=true
                                                    var lbl_senderName = cell.viewWithTag(15) as! UILabel

                                                    lbl_senderName.text=fullname as! String?
                                                       lbl_senderName.frame=CGRect(x:chatImage.frame.origin.x+20,y: lbl_senderName.frame.origin.y,width:lbl_senderName.frame.width,height:lbl_senderName.frame.height)
                                                    btnSaveView.addTarget(self, action: #selector(GroupChatingDetailController.BtnSaveContactClicked(_:)), for:.touchUpInside)
                                                    
                                                    
                                                    let contactinfo=msg!.components(separatedBy: ":") ///return array string
                                                    textLable.text = contactinfo[0]
                                                    contactreceivedphone=contactinfo[1]
                                                    
                                                    
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
                                                    
                                                    profileImage.center = CGPoint(x: CGFloat(Float(chatImage.image!.leftCapWidth)+30.0), y: chatImage.frame.height/2 + 10)
                                                    
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
                                                    
                                                   // buttonSave.frame = CGRect(x: chatImage.frame.width-40, y: chatImage.frame.height-25, width: buttonSave.frame.size.width, height: buttonSave.frame.size.height)
                                                    //timeLabel.text=date2.debugDescription
                                                }
                                                else{
                                                
                                                
                                                    if(msgType?.isEqual(to: "8"))!
                                                    {
                                                        
                                                        print("UI chat type is \(msgType!)")
                                                        cell=tableView.dequeueReusableCell(withIdentifier: "ContactSentCell")!
                                                        if(cell==nil)
                                                        {
                                                            cell = tblForGroupChat.dequeueReusableCell(withIdentifier: "ContactSentCell")! as UITableViewCell
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
                                                        
                                                        let contactinfo=msg!.components(separatedBy: ":") ///return array string
                                                        textLable.text = contactinfo[0]
                                                        var number=contactinfo[1]
                                                        let number2=number.components(separatedBy: " ")
                                                        number=number2[0]
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
                                                        
                                                        contactCardSelected=number
                                                        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(GroupChatingDetailController.contactSharedTapped(_:)))
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
                                                    else{
                                                
                                                
                                print("got sender msg \(msg)")
             cell = tblForGroupChat.dequeueReusableCell(withIdentifier: "ChatSentCell")! as UITableViewCell
            
          
            
            let msgLabel = cell.viewWithTag(12) as! ActiveLabel
            
            let chatImage = cell.viewWithTag(1) as! UIImageView
            let nameLabel = cell.viewWithTag(15) as! UILabel
           
            let timeLabel = cell.viewWithTag(11) as! UILabel
            
            chatImage.frame = CGRect(x: chatImage.frame.origin.x, y: chatImage.frame.origin.y, width: ((sizeOFStr.width + 100)  > 200 ? (sizeOFStr.width + 100) : 200), height: sizeOFStr.height + 60)
            chatImage.image = UIImage(named: "chat_receive")?.stretchableImage(withLeftCapWidth: 40,topCapHeight: 20);
            //******
            
            
            msgLabel.frame = CGRect(x: msgLabel.frame.origin.x, y: msgLabel.frame.origin.y, width: msgLabel.frame.size.width, height: sizeOFStr.height)
            
            
            
            let formatter = DateFormatter();
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS";
            //formatter.dateFormat = "MM/dd hh:mm a"";
            formatter.timeZone = TimeZone.autoupdatingCurrent
            let defaultTimeZoneStr = formatter.date(from: date2 as! String)
            //print("defaultTimeZoneStr \(defaultTimeZoneStr)")
            
            let formatter2 = DateFormatter();
            formatter2.timeZone=TimeZone.autoupdatingCurrent
            formatter2.dateFormat = "MM/dd hh:mm a";
            let displaydate=formatter2.string(from: defaultTimeZoneStr!)
            timeLabel.frame = CGRect(x: msgLabel.frame.origin.x, y: msgLabel.frame.origin.y+msgLabel.frame.height+5, width: chatImage.frame.size.width-46, height: timeLabel.frame.size.height)
            
            timeLabel.text = displaydate
            nameLabel.textColor=UIColor.blue
            nameLabel.text=fullname as! String
            msgLabel.text=msg as! String
                                                        msgLabel.numberOfLines = 0
                                                        msgLabel.enabledTypes = [.mention, .hashtag, .url]
                                                        // textLable.text = "This is a post with #hashtags and a @userhandle."
                                                        msgLabel.textColor = .black
                                                        msgLabel.handleHashtagTap { hashtag in
                                                            print("Success. You just tapped the \(hashtag) hashtag")
                                                        }
                                                        msgLabel.handleURLTap({ (url) in
                                                            print("Success. You just tapped the \(url) url")
                                                            var stringURL="\(url)"
                                                            if !(stringURL.contains("http")) {
                                                                stringURL = "http://" + stringURL
                                                            }
                                                            
                                                            var res=UIApplication.shared.openURL(NSURL.init(string: stringURL) as! URL)
                                                            print("open url \(res)")
                                                        })
                                                        
                                                    }
            
                                                }
                                            }
                                        }
                                    }
            }
                            }
                        }        }
                    }
                }
            }
            return cell


        }
  
        
    }
    
    func contactTapped(_ button: UIButton) {
       // print("contact title tapped \(self.selectedContact)")
        //tappedImageView will be the image view that was tapped.
        //dismiss it, animate it off screen, whatever.
        //let tappedImageView = gestureRecognizer.view! as! UIImageView
        //selectedImage=tappedImageView.image
        self.performSegue(withIdentifier: "contactdetailsinfogroupsegue", sender: nil);
        
    }
    
    
    func BtnSaveContactClicked(_ sender:UIButton)
    {
        let contact = CNMutableContact()
        /*var rowselected=sender.tag
         var messageDic = messages.object(at: rowselected) as! [String : String];
         let msg = messageDic["message"] as NSString!
         
         //sender.tag=15
         
         let contactinfo=msg?.components(separatedBy: ":") ///return array string
         //textLable.text = contactinfo[0]
         contactreceivedphone=(contactinfo?[1])!
         */
        
        var phoneIdentifier=sqliteDB.getIdentifierFRomPhone(contactreceivedphone)
        if(phoneIdentifier != nil)
        {
            
        }
        else{
            
        }
        contact.phoneNumbers = [CNLabeledValue(
            label:CNLabelPhoneNumberiPhone,
            value:CNPhoneNumber(stringValue:contactreceivedphone))]
        let contactViewController = CNContactViewController(forNewContact: contact)
        contactViewController.delegate=self
        //var contactDetailShow=CNContactViewControllr.init(contact)
        self.navigationController!.pushViewController(contactViewController,animated: false)
    }

    
    func contactSharedTapped(_ gestureRecognizer: UITapGestureRecognizer) {
        //tappedImageView will be the image view that was tapped.
        //dismiss it, animate it off screen, whatever.
        contactshared=true
        
        self.performSegue(withIdentifier: "contactdetailsinfogroupsegue", sender: nil);
        
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
        
        messages.add(["msg":msgbody+" (pending)", "type":"14", "fromFullName":"","date":date,"uniqueid":uniqueID])
        
        
        
        
        //save chat
        sqliteDB.storeGroupsChat(username!, group_unique_id1: groupid1, type1: "location", msg1: msgbody, from_fullname1: username!, date1: Date(), unique_id1: uniqueID)
        
        
        //get members and store status as pending
        for i in 0 ..< membersList.count
        {
            /*
             let member_phone = Expression<String>("member_phone")
             let isAdmin = Expression<String>("isAdmin")
             let membership_status
             */
            if((membersList[i]["member_phone"] as! String) != username! && (membersList[i]["membership_status"] as! String) != "left")
            {
                print("adding group chat status for \(membersList[i]["member_phone"])")
                sqliteDB.storeGRoupsChatStatus(uniqueID, status1: "pending", memberphone1: membersList[i]["member_phone"]! as! String, delivereddate1: UtilityFunctions.init().minimumDate(), readDate1: UtilityFunctions.init().minimumDate())
            }
        }
        
       // var chatmsg=txtFieldMessage.text!
        //txtFieldMessage.text = "";
       // self.didValueChanged(txtFieldMessage)
        
       /* tblForGroupChat.reloadData()
        if(messages.count>1)
        {
            var indexPath = IndexPath(row:messages.count-1, section: 0)
            tblForGroupChat.scrollToRow(at: indexPath, at: UITableViewScrollPosition.bottom, animated: true)
            
            
            
        }
        */
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        /*sqliteDB.storeGroupsChat(username!, group_unique_id1: self.groupid1, type1: "audio", msg1: self.filename, from_fullname1: username!, date1: Date(), unique_id1: uniqueID)
        
        
        
        //self.addUploadInfo(self.groupid,uniqueid1: uniqueid_chat, rowindex: self.messages.count, uploadProgress: 0.0, isCompleted: false)
        
        
        //get members and store status as pending
        for i in 0 ..< self.membersList.count
        {
            /*
             let member_phone = Expression<String>("member_phone")
             let isAdmin = Expression<String>("isAdmin")
             let membership_status
             */
            if((self.membersList[i]["member_phone"] as! String) != username! && (self.membersList[i]["membership_status"] as! String) != "left")
            {
                print("adding group chat status for \(self.membersList[i]["member_phone"])")
                sqliteDB.storeGRoupsChatStatus(uniqueID, status1: "pending", memberphone1: self.membersList[i]["member_phone"]! as! String, delivereddate1: UtilityFunctions.init().minimumDate(), readDate1: UtilityFunctions.init().minimumDate())
                
                ///////sqliteDB.saveFile(self.membersList[i]["member_phone"]! as! String, from1: username!, owneruser1: username!, file_name1: self.filename, date1: nil, uniqueid1: uniqueID, file_size1: "\(filesize1)", file_type1: ftype, file_path1: filePathImage2, type1: "audio")
                
            }
        }

        
        
        var formatter2 = DateFormatter();
        formatter2.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        formatter2.timeZone = NSTimeZone.local
        var defaultTimeeee = formatter2.string(from:Date())
        
        
        messages.add(["msg":msgbody+" (\(statusNow))", "type":"14", "fromFullName":"","date":date,"uniqueid":uniqueID])
      
        
        
        ////self.addMessage(msgbody+" (\(statusNow))",status:statusNow,ofType: "14",date:defaultTimeeee, uniqueid: uniqueID)
        
        self.tblForGroupChat.reloadData()
        if(self.messages.count>1)
        {
            // let indexPath = NSIndexPath(forRow:self.messages.count-1, inSection: 0)
            let indexPath = IndexPath(row:self.tblForGroupChat.numberOfRows(inSection: 0)-1, section: 0)
            self.tblForGroupChat.scrollToRow(at: indexPath, at: UITableViewScrollPosition.bottom, animated: false)
            
            
            
        }
        */
        
        // }
        // })
        //  }
        
        
        
       // DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.default).async
         //   {
                print("messages count before sending msg is \(self.messages.count)")
                self.sendChatMessage(self.groupid1, from: username!, type: "location", msg: msgbody, fromFullname: username!, uniqueidChat: uniqueID, completion: { (result) in
                    
                    print("chat sent")
                    if(result==true)
                    {
                        for i in 0 ..< self.membersList.count
                        {
                            if((self.membersList[i]["member_phone"] as! String) != username! && (self.membersList[i]["membership_status"] as! String) != "left")
                            {
                                sqliteDB.updateGroupChatStatus(uniqueID, memberphone1: self.membersList[i]["member_phone"]! as! String, status1: "sent", delivereddate1: Date(), readDate1: Date())
                                
                                // === wrong sqliteDB.storeGRoupsChatStatus(uniqueid_chat, status1: "sent", memberphone1: self.membersList[i]["member_phone"]! as! String, delivereddate1: UtilityFunctions.init().minimumDate(), readDate1: UtilityFunctions.init().minimumDate())
                            }
                        }
                        
                        var searchformat=NSPredicate(format: "uniqueid = %@",uniqueID)
                        
                        var resultArray=self.messages.filtered(using: searchformat)
                        var ind=self.messages.index(of: resultArray.first!)
                        //cfpresultArray.first
                        //resultArray.first
                        var aa=self.messages.object(at: ind) as! [String:AnyObject]
                        var actualmsg=aa["msg"] as! String
                        actualmsg=actualmsg.removeCharsFromEnd(10)
                        //var actualmsg=newmsg
                        aa["msg"]="\(actualmsg) (sent)" as AnyObject?
                        self.messages.replaceObject(at: ind, with: aa)
                        //  self.messages.objectAtIndex(ind).message="\(self.messages[ind]["message"]) (sent)"
                        var indexp=IndexPath(row:ind, section:0)
                      //  DispatchQueue.main.async
                        //    {
                       //         self.tblForChats.reloadData()
                       // }

                        
                        //==== sqliteDB.updateGroupChatStatus(uniqueid_chat, memberphone1: username!,status1: "sent", delivereddate1: UtilityFunctions.init().minimumDate(), readDate1: UtilityFunctions.init().minimumDate())
                        
                        UIDelegates.getInstance().UpdateGroupChatDetailsDelegateCall()
                    }
                })
       // }
        
        
        
        //...
        
        //print("messages count before sending msg is \(self.messages.count)")
        print("sending msg \(msgbody)")
             //in chat window
           /* self.sendChatMessage(imParas){ (uniqueid,result) -> () in
                
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
      */
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
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath) {
        if(messages.count > 0 && messages.count > indexPath.row)
        {
            var messageDic = messages.object(at: indexPath.row) as! [String : String];
           // NSLog(messageDic["message"]!, 1)
            let msgType = messageDic["type"] as NSString!
            let msg = messageDic["msg"] as NSString!
            
            if((msgType?.isEqual(to: "5"))!||(msgType?.isEqual(to: "6"))!){
                self.performSegue(withIdentifier: "showFullDocGroupSegue", sender: nil);
            }
            if((msgType?.isEqual(to: "14"))! || (msgType?.isEqual(to: "13"))!){
                self.performSegue(withIdentifier: "MapViewGroupSegue", sender: nil);
            }
        }
    }
    
    
    func textFieldShouldReturn (_ textField: UITextField!) -> Bool{
        textField.resignFirstResponder()
        let duration : TimeInterval = 0
        let keyboardFrame = keyFrame
        
        
        if(cellY>((keyboardFrame?.origin.y)!-20))
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
    
    
    func imageTapped(_ gestureRecognizer: UITapGestureRecognizer) {
        //tappedImageView will be the image view that was tapped.
        //dismiss it, animate it off screen, whatever.
        let tappedImageView = gestureRecognizer.view! as! UIImageView
        selectedImage=tappedImageView.image
        self.performSegue(withIdentifier: "showFullImageGroupSegue", sender: nil);
        
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
        print("videoPath path is \(videoPath)")
        let player = AVPlayer(url: URL.init(fileURLWithPath: videoPath))
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        contactshared=false
        self.present(playerViewController, animated: true) {
            
            //  self.performSegue(withIdentifier: "showFullImageSegue", sender: nil);
            
        }
        
    }
    
    func keyboardWillShow(_ notification: Notification) {
        
        
        //uncomment moved down
        
        /*
            var lastind=NSIndexPath.init(index: self.messages.count)
            let rectOfCellInTableView = tblForGroupChat.rectForRowAtIndexPath(lastind)
            let rectOfCellInSuperview = tblForGroupChat.convertRect(rectOfCellInTableView, toView: nil)
            print("last cell pos y is \(tblForGroupChat.visibleCells.last?.frame.origin.y)")
            
            print("Y of Cell is: \(rectOfCellInSuperview.origin.y%viewForContent.frame.height)")
            print("content offset is \(tblForGroupChat.contentOffset.y)")
            
            cellY=(tblForGroupChat.visibleCells.last?.frame.origin.y)!+(tblForGroupChat.visibleCells.last?.frame.height)!
            print("cellY is \(cellY)")*/
            
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
                let rectOfCellInTableView = tblForGroupChat.rectForRow(at: lastind)
                let rectOfCellInSuperview = tblForGroupChat.convert(rectOfCellInTableView, to: nil)
                print("last cell pos y is \(tblForGroupChat.visibleCells.last?.frame.origin.y)")
                
                print("Y of Cell is: \(rectOfCellInSuperview.origin.y.truncatingRemainder(dividingBy: viewForContent.frame.height))")
                print("content offset is \(tblForGroupChat.contentOffset.y)")
                
                cellY=(tblForGroupChat.visibleCells.last?.frame.origin.y)!+(tblForGroupChat.visibleCells.last?.frame.height)!
                print("cellY is \(cellY)")
            }
                if(cellY>(keyboardFrame.origin.y-20))
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
            
            tblForGroupChat.reloadData()
            if(messages.count>1)
            {
                let indexPath = IndexPath(row:messages.count-1, section: 0)
                tblForGroupChat.scrollToRow(at: indexPath, at: UITableViewScrollPosition.bottom, animated: true)
            }
        
        /*if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            self.viewForTableAndTextfield.frame.origin.y -= keyboardSize.height
            // self.view.frame.origin.y -= keyboardSize.height
        }
        */
    }
    //uncomment
   /* func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            self.viewForContent.frame.origin.y += keyboardSize.height
            //self.view.frame.origin.y += keyboardSize.height
        }
    }*/
    
    func getSizeOfString(_ postTitle: NSString) -> CGSize {
        
        
        // Get the height of the font
        let constraintSize = CGSize(width: 170, height: CGFloat.greatestFiniteMagnitude)
        
        //let constraintSize = CGSizeMake(220, CGFloat.max)
        
        
        
        /*let attributes = [NSFontAttributeName:UIFont.systemFontOfSize(11.0)]
         let labelSize = postTitle.boundingRectWithSize(constraintSize,
         options: NSStringDrawingOptions.UsesLineFragmentOrigin,
         attributes: attributes,
         context: nil)*/
        
        let labelSize = postTitle.boundingRect(with: constraintSize,
                                                       options: NSStringDrawingOptions.usesLineFragmentOrigin,
                                                       attributes:[NSFontAttributeName : UIFont.systemFont(ofSize: 11.0)],
                                                       context: nil)
        ////print("size is width \(labelSize.width) and height is \(labelSize.height)")
        return labelSize.size
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

    
    func sendGroupChatStatus(_ chat_uniqueid:String,status1:String)
    {
    
    var url=Constants.MainUrl+Constants.updateGroupChatStatusAPI
    
    
   //--- dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0))
    //{
        
        let request=Alamofire.request("\(url)", method: .post, parameters: ["chat_unique_id":chat_uniqueid,"status":status1],headers:header).responseJSON { response in
            
        
        //alamofire4
    //let request = Alamofire.request(.POST, "\(url)", parameters: ["chat_unique_id":chat_uniqueid,"status":status1],headers:header).responseJSON { response in
    
    
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
    var resJSON=JSON(response.result.value!)
    print("status seen sent response \(resJSON)")
        //update locally
        //moving it out of function. if seen offline so remove chat bubble unread count
        
        sqliteDB.removeGroupStatusTemp(status1, memberphone1: username!, messageuniqueid1: chat_uniqueid)
        sqliteDB.updateGroupChatStatus(chat_uniqueid, memberphone1: username!, status1: status1, delivereddate1: NSDate() as Date!, readDate1: NSDate() as Date!)
    }
    }
  //===  }
}

    func generateUniqueid()->String
    {
    
        let uid=randomStringWithLength(7)
    
        let date=Date()
        let calendar = Calendar.current
        let year=(calendar as NSCalendar).components(NSCalendar.Unit.year,from: date).year
        let month=(calendar as NSCalendar).components(NSCalendar.Unit.month,from: date).month
        let day=(calendar as NSCalendar).components(.day,from: date).day
        let hr=(calendar as NSCalendar).components(NSCalendar.Unit.hour,from: date).hour
        let min=(calendar as NSCalendar).components(NSCalendar.Unit.minute,from: date).minute
        let sec=(calendar as NSCalendar).components(NSCalendar.Unit.second,from: date).second
        print("\(year) \(month) \(day) \(hr) \(min) \(sec)")
        let uniqueid="\(uid)\(year!)\(month!)\(day!)\(hr!)\(min!)\(sec!)"
        
        return uniqueid
        

    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        print("inside preparesegue")
        //groupMessageInfoSegue
        
        if segue.identifier == "groupMessageInfoSegue" {
              print("inside preparesegue groupMessageInfoSegue")
            if let destinationVC = segue.destination as? GroupMessageStatusViewController{
                print("inside preparesegue destinationVC \(destinationVC.debugDescription)")
                var messageDic = messages.object(at: swipedRow) as! [String : String];
                
                let uniqueid = messageDic["uniqueid"] as NSString!
                
                let msg = messageDic["msg"] as NSString!
                let date2=messageDic["date"] as NSString!
                let fullname=messageDic["fromFullName"] as NSString!
                destinationVC.message_unique_id=uniqueid as! String
                destinationVC.messageString=msg as! String
                destinationVC.datetime=date2 as! String
            }
        }
        
        if segue.identifier == "contactdetailsinfogroupsegue" {
            if let destinationVC = segue.destination as? contactsDetailsTableViewController{
                
                if(contactshared==true)
                {
                    destinationVC.selectedContactphone=self.contactCardSelected
                }
                else{
                    destinationVC.selectedContactphone=groupid1
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
                
                do{
                    
                    
                    for i in 0 ..< membersList.count
                    {
                        /*
                         let member_phone = Expression<String>("member_phone")
                         let isAdmin = Expression<String>("isAdmin")
                         let membership_status
                         */
                        if((membersList[i]["member_phone"] as! String) != username! && (membersList[i]["membership_status"] as! String) != "left")
                        {
                            
                            for resultrows in try sqliteDB.db.prepare((tbl_contactslists?.filter(phone==(membersList[i]["member_phone"] as! String) && blockedByMe==true))!)
                            {
                                print("blocked by me")
                                //blockedcontact=true
                                destinationVC.blockedByMe=true
                                break
                            }
                            
                            print("adding group contat segue for \(membersList[i]["member_phone"])")
                        }}
                    
                    
               
                }
                catch{
                    print("not blocked coz not in contact list")
                }
                
            }
        }
        
        
        if segue.identifier == "MapViewGroupSegue" {
            if let destinationVC = segue.destination as? MapViewController{
                //destinationVC.tabBarController?.selectedIndex=0
                //self.tabBarController?.selectedIndex=0
                let selectedRow = tblForGroupChat.indexPathForSelectedRow!.row
                var messageDic = messages.object(at: selectedRow) as! [String : String];
                let coordinates = messageDic["msg"] as NSString!
                
                let locationinfo=coordinates!.components(separatedBy: ":") ///return array string
                var latitude = locationinfo[0]
                var longitude = locationinfo[1]
                destinationVC.latitude=latitude
                destinationVC.longitude=longitude
                self.dismiss(animated: true, completion: { () -> Void in
                    
                    
                    
                })
            }
        }
        
        if segue.identifier == "showFullImageGroupSegue" {
            if let destinationVC = segue.destination as? ShowImageViewController{
                //destinationVC.tabBarController?.selectedIndex=0
                //self.tabBarController?.selectedIndex=0
                destinationVC.newimage=self.selectedImage
                self.dismiss(animated: true, completion: { () -> Void in
                    
                    
                    
                })
            }
        }
        
        if let destinationVC = segue.destination as? textDocumentViewController{
            let selectedRow = tblForGroupChat.indexPathForSelectedRow!.row
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

    func refreshGroupChatDetailUI(_ message: String, data: AnyObject!) {
        
        self.retrieveChatFromSqlite { (result) in
            
            
            //DispatchQueue.main.async
           // {
            self.tblForGroupChat.reloadData()
            
            if(self.messages.count>1)
            {
                let indexPath = IndexPath(row:self.messages.count-1, section: 0)
                
                self.tblForGroupChat.scrollToRow(at: indexPath, at: UITableViewScrollPosition.bottom, animated: true)
            }
           // }
        }
    }
    
    
    @IBAction func btnFileShare(_ sender: Any) {
        let contactPickerViewController = CNContactPickerViewController()
        contactPickerViewController.delegate=self
        
        
       
        
   /// shareMenu.modalPresentationStyle=UIModalPresentationStyle.overCurrentContext
        
        
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
                    {self.textFieldShouldReturn(self.txtFieldMessage)
                    }
                    self.present(picker, animated: true, completion: nil)
                    
            }
            
            
        })
        let photoAction = UIAlertAction(title: "Share Photo".localized, style: UIAlertActionStyle.default,handler: { (action) -> Void in
            
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
            ////picker.mediaTypes=[kUTTypeMovie as NSString as String,kUTTypeMovie as NSString as String]
            //[self presentViewController:picker animated:YES completion:NULL];
            DispatchQueue.main.async
                { () -> Void in
                    //  picker.addChildViewController(UILabel("hiiiiiiiiiiiii"))
                    if(self.showKeyboard==true)
                    {self.textFieldShouldReturn(self.txtFieldMessage)
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
            
           /* DispatchQueue.main.async { () -> Void in
                if(self.showKeyboard==true)
                {self.textFieldShouldReturn(self.txtFieldMessage)
                }*/
                self.present(importMenu, animated: true, completion: nil)
                
                
           // }
            
            
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
        
        messages.add(["msg":msgbody+" (pending)", "type":"8", "fromFullName":"","date":date,"uniqueid":uniqueID])
        
        
        
        
        //save chat
        sqliteDB.storeGroupsChat(username!, group_unique_id1: groupid1, type1: "contact", msg1: msgbody, from_fullname1: username!, date1: Date(), unique_id1: uniqueID)
        
        
        //get members and store status as pending
        for i in 0 ..< membersList.count
        {
            /*
             let member_phone = Expression<String>("member_phone")
             let isAdmin = Expression<String>("isAdmin")
             let membership_status
             */
            if((membersList[i]["member_phone"] as! String) != username! && (membersList[i]["membership_status"] as! String) != "left")
            {
                print("adding group chat status for \(membersList[i]["member_phone"])")
                sqliteDB.storeGRoupsChatStatus(uniqueID, status1: "pending", memberphone1: membersList[i]["member_phone"]! as! String, delivereddate1: UtilityFunctions.init().minimumDate(), readDate1: UtilityFunctions.init().minimumDate())
            }
        }

        
        
        
        print("messages count before sending msg is \(self.messages.count)")
        self.sendChatMessage(self.groupid1, from: username!, type: "contact", msg: msgbody, fromFullname: username!, uniqueidChat: uniqueID, completion: { (result) in
            
            print("chat sent")
            if(result==true)
            {
                for i in 0 ..< self.membersList.count
                {
                    if((self.membersList[i]["member_phone"] as! String) != username! && (self.membersList[i]["membership_status"] as! String) != "left")
                    {
                        sqliteDB.updateGroupChatStatus(uniqueID, memberphone1: self.membersList[i]["member_phone"]! as! String, status1: "sent", delivereddate1: Date(), readDate1: Date())
                        
                        // === wrong sqliteDB.storeGRoupsChatStatus(uniqueid_chat, status1: "sent", memberphone1: self.membersList[i]["member_phone"]! as! String, delivereddate1: UtilityFunctions.init().minimumDate(), readDate1: UtilityFunctions.init().minimumDate())
                    }
                }
                
                var searchformat=NSPredicate(format: "uniqueid = %@",uniqueID)
                
                var resultArray=self.messages.filtered(using: searchformat)
                var ind=self.messages.index(of: resultArray.first!)
                //cfpresultArray.first
                //resultArray.first
                var aa=self.messages.object(at: ind) as! [String:AnyObject]
                var actualmsg=aa["msg"] as! String
                actualmsg=actualmsg.removeCharsFromEnd(10)
                //var actualmsg=newmsg
                aa["msg"]="\(actualmsg) (sent)" as AnyObject?
                self.messages.replaceObject(at: ind, with: aa)
                //  self.messages.objectAtIndex(ind).message="\(self.messages[ind]["message"]) (sent)"
                var indexp=IndexPath(row:ind, section:0)
                //  DispatchQueue.main.async
                //    {
                //         self.tblForChats.reloadData()
                // }
                
                
                //==== sqliteDB.updateGroupChatStatus(uniqueid_chat, memberphone1: username!,status1: "sent", delivereddate1: UtilityFunctions.init().minimumDate(), readDate1: UtilityFunctions.init().minimumDate())
                
                UIDelegates.getInstance().UpdateGroupChatDetailsDelegateCall()
            }
        })
        
        
        
        
        
        
        
        
        
        
        
    }
    
    
    
    
    func insertChatRowAtLast(_ message: String, uniqueid: String, status: String, filename: String, type: String, date: String,from:String) {
        
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
        messages.add(["message":message,"filename":filename,"type":type,"date":date,"uniqueid":uniqueid, "status":status])
        //tblForChats.beginUpdates()
        
        tblForGroupChat.insertRows(at: [NSIndexPath.init(row: messages.count-1, section: 0) as IndexPath], with: UITableViewRowAnimation.bottom)
        
        // tblForChats.endUpdates()
        self.tblForGroupChat.scrollToRow(at: NSIndexPath.init(row: messages.count-1, section: 0) as IndexPath, at: UITableViewScrollPosition.bottom, animated: false)
        
        if(from != username!)
        {
            //LATER
            
            //sqliteDB.UpdateChatStatus(uniqueid, newstatus: "seen")
           // sqliteDB.saveGroupStatusTemp("seen", sender1: tblUserChats[from], messageuniqueid1: tblUserChats[uniqueid])
            //sqliteDB.saveMessageStatusSeen("seen", sender1: from, uniqueid1: uniqueid)
            //self.sendGroupChatStatus(uniqueid,status: "seen")

            //sendChatStatusUpdateMessage(uniqueid,status: "seen",sender:from)
        }
        
    }
    
    func insertBulkChats(statusArray: [[String : AnyObject]]) {
        
        tblForGroupChat.beginUpdates()
        for chats  in statusArray
        {
            //var messageDic = chats.object(at: indexPath.row) as! [String : String];
            messages.add(["message":chats["message"],"filename":chats["filename"],"type":chats["type"],"date":chats["date"],"uniqueid":chats["uniqueid"],"status":chats["status"]])
            tblForGroupChat.insertRows(at: [NSIndexPath.init(row: messages.count-1, section: 0) as IndexPath], with: UITableViewRowAnimation.bottom)
        }
        tblForGroupChat.endUpdates()
        
    }
    
    func insertBulkChatStatusesSync(statusArray: [[String : AnyObject]]) {
        
        tblForGroupChat.beginUpdates()
        for chats in statusArray
        {
            var predicate=NSPredicate(format: "uniqueid = %@", chats["uniqueid"] as! String)
            var resultArray=self.messages.filtered(using: predicate)
            if(resultArray.count > 0)
            {
                var foundindex=self.messages.index(of: resultArray.first!)
                var newrow:[String:AnyObject]=["message":"\(chats["message"]!) (\(chats["status"])" as AnyObject,"filename":chats["filename"]!,"type":chats["type"]!,"date":chats["date"]!,"uniqueid":chats["uniqueid"]!,"status":chats["status"]!]
                
                //messages.add(["message":chats["message"],"filename":chats["filename"],"type":chats["type"],"date":chats["date"],"uniqueid":chats["uniqueid"]])
                tblForGroupChat.insertRows(at: [NSIndexPath.init(row: resultArray.first as! Int, section: 0) as IndexPath], with: UITableViewRowAnimation.bottom)
            }
        }
        tblForGroupChat.endUpdates()
    }
    
    func updateChatStatusRow(_ message: String, uniqueid: String, status: String, filename: String, type: String, date: String) {
        
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
            actualmsg=actualmsg.removeCharsFromEnd(statusCount)
            
            print("found old message is \(message)")
            
            var newrow:[String:AnyObject]=["message":"\(actualmsg) (\(status))"/*"\(message) \((status))"*/  /*"message":"\(actualmsg) (\(status))"*/ as AnyObject,"filename":filename as AnyObject,"type":aa["type"] as AnyObject,"date":aa["date"] as AnyObject,"uniqueid":aa["uniqueid"] as AnyObject,"status":status as AnyObject]
            
            print("replaced with \(newrow["message"])")
            
            messages.replaceObject(at: foundindex, with: newrow)
            
            tblForGroupChat.beginUpdates()
            
            tblForGroupChat.reloadRows(at: [NSIndexPath.init(row: foundindex, section: 0) as IndexPath], with: UITableViewRowAnimation.bottom)
            
            tblForGroupChat.endUpdates()
            
            
            
            //// self.tblForChats.scrollToRow(at: NSIndexPath.init(row: messages.count-1, section: 0) as IndexPath, at: UITableViewScrollPosition.bottom, animated: false)
            
        }
    }
    
    
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
                }
                else{
                    print("choosen type is not video")
                    if (picker.sourceType == UIImagePickerControllerSourceType.camera) {
                        print ("from camera")
                    }
                    self.imagePickerController(picker, didFinishPickingImage: (info[UIImagePickerControllerOriginalImage] as? UIImage)!, editingInfo: info as [String : AnyObject]?)
                }
                
            }
        }
    }
    
    
    func sendVideo(urlOfVideoGetMetadata:URL,urlOfVideoPath:URL)
    { print("urlOfVideoGetMetadata is \(urlOfVideoGetMetadata) and urlOfVideoPath is \(urlOfVideoPath)")
        
        
        
        var filesize1=0
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
        
        
        let shareMenu = UIAlertController(title: nil, message: "Send \" \(filename) ? ", preferredStyle: .actionSheet)
        shareMenu.modalPresentationStyle=UIModalPresentationStyle.overCurrentContext
        let confirm = UIAlertAction(title: "Yes", style: UIAlertActionStyle.default,handler: { (action) -> Void in
            
            socketObj.socket.emit("logClient","IPHONE-LOG: \(username!) selected video group ")
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
            var uniqueid_chat=UtilityFunctions.init().generateUniqueid()
            var date=self.getDateString(Date())
            var status="pending"
            
            ///messages.add(["msg":txtFieldMessage.text!+" (pending)", "type":"2", "fromFullName":"","date":date,"uniqueid":uniqueid_chat])
            
            
            
            
            //save chat
            sqliteDB.storeGroupsChat(username!, group_unique_id1: self.groupid1, type1: "video", msg1: self.filename, from_fullname1: username!, date1: Date(), unique_id1: uniqueid_chat)
            
            
            
            //self.addUploadInfo(self.groupid,uniqueid1: uniqueid_chat, rowindex: self.messages.count, uploadProgress: 0.0, isCompleted: false)
            
            
            //get members and store status as pending
            for i in 0 ..< self.membersList.count
            {
                /*
                 let member_phone = Expression<String>("member_phone")
                 let isAdmin = Expression<String>("isAdmin")
                 let membership_status
                 */
                if((self.membersList[i]["member_phone"] as! String) != username! && (self.membersList[i]["membership_status"] as! String) != "left")
                {
                    print("adding group chat status for \(self.membersList[i]["member_phone"])")
                    sqliteDB.storeGRoupsChatStatus(uniqueid_chat, status1: "pending", memberphone1: self.membersList[i]["member_phone"]! as! String, delivereddate1: UtilityFunctions.init().minimumDate(), readDate1: UtilityFunctions.init().minimumDate())
                    
                    sqliteDB.saveFile(self.membersList[i]["member_phone"]! as! String, from1: username!, owneruser1: username!, file_name1: self.filename, date1: nil, uniqueid1: uniqueid_chat, file_size1: "\(filesize1)", file_type1: ftype, file_path1: filePathImage2, type1: "video")
                    
                }
            }
            
            
            
            managerFile.uploadFileInGroup(filePathImage2, groupid1:self.groupid1,from1:username!,uniqueid1:uniqueid_chat,file_name1:self.filename,file_size1:"\(filesize1)",file_type1:ftype,type1:"video")
            
            
            //uploadFileInGroup(_ filePath1:String,groupid1:String,from1:String, uniqueid1:String,file_name1:String,file_size1:String,file_type1:String,type1:String){
            
            
            
            //(filePathImage2, to1: self.selectedContact, from1: username!, uniqueid1: uniqueID, file_name1: self.filename, file_size1: "\(self.fileSize1)", file_type1: ftype,type1:"image")
            // })
            
            self.retrieveChatFromSqlite({ (result) in
                
                
                // })
                // (self.selectedContact,completion:{(result)-> () in
                DispatchQueue.main.async
                    {
                        self.tblForGroupChat.reloadData()
                        
                        if(self.messages.count>1)
                        {
                            print("scrollinggg 3360 line")
                            //var indexPath = NSIndexPath(forRow:self.messages.count-1, inSection: 0)
                            let indexPath = IndexPath(row:self.tblForGroupChat.numberOfRows(inSection: 0)-1, section: 0)
                            self.tblForGroupChat.scrollToRow(at: indexPath, at: UITableViewScrollPosition.bottom, animated: false)
                        }
                }
            })
            self.dismiss(animated: true, completion:{ ()-> Void in
                
            })
        })
        let notConfirm = UIAlertAction(title: "No".localized, style: UIAlertActionStyle.cancel, handler: { (action) -> Void in
            
        })
        
        shareMenu.addAction(confirm)
        shareMenu.addAction(notConfirm)
        //shareMenu.addAction(notConfirm)
        self.present(shareMenu, animated: true) {
            
            
        }
        
        
      /*  self.dismiss(animated: true, completion:{ ()-> Void in
            
            if(self.showKeyboard==true)
            {
                self.textFieldShouldReturn(self.txtFieldMessage)
                
            }
            self.tblForGroupChat.reloadData()
            if(self.messages.count>1)
            {
                // var indexPath = NSIndexPath(forRow:self.messages.count-1, inSection: 0)
                print("scrollinggg 3389 line")
                let indexPath = IndexPath(row:self.tblForGroupChat.numberOfRows(inSection: 0)-1, section: 0)
                self.tblForGroupChat.scrollToRow(at: indexPath, at: UITableViewScrollPosition.bottom, animated: false)
                
            }
            
            self.present(shareMenu, animated: true) {
                
                
            }
            
        })*/
    //  }//

        

    }
    
   func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        print("inside imagepicked")
    
            var ftype=""
            var filesize1=0
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
    else{
    
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
                print("filename is \(self.filename)")
                
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
    print("file type is \(ftype)")
    
      /*  let shareMenu = UIAlertController(title: nil, message: " Share file \(filename) ? ", preferredStyle: .actionSheet)
    
        shareMenu.modalPresentationStyle=UIModalPresentationStyle.overCurrentContext
        let confirm = UIAlertAction(title: "Yes", style: UIAlertActionStyle.default,handler: { (action) -> Void in
        */
            socketObj.socket.emit("logClient","IPHONE-LOG: \(username!) selected image ")
            //print("file gotttttt")
            
            // var fname=furl!.deletingLastPathComponent()
    }
    let shareMenu = UIAlertController(title: nil, message: " Send \" \(filename) ? ", preferredStyle: .actionSheet)
    shareMenu.modalPresentationStyle=UIModalPresentationStyle.overCurrentContext
    let confirm = UIAlertAction(title: "Yes", style: UIAlertActionStyle.default,handler: { (action) -> Void in
  
    let dirPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
    let docsDir1 = dirPaths[0]
    var documentDir=docsDir1 as NSString
    var filePathImage2=documentDir.appendingPathComponent(self.filename)
    print("filePathImage2 is \(filePathImage2)")
            var fm=FileManager.default
    
    
    
    
    
    
      var uniqueid_chat=UtilityFunctions.init().generateUniqueid()
    
            var fileAttributes:[String:AnyObject]=["":"" as AnyObject]
    
    do {
                let fileAttributes : NSDictionary? = try FileManager.default.attributesOfItem(atPath: filePathImage2) as NSDictionary?
                if let _attr = fileAttributes {
                    filesize1 = Int(_attr.fileSize());
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
            
    do{try data!.write(to: URL(fileURLWithPath: filePathImage2), options: [.atomic])
    }
    catch{
        print("file not written \(error)")
        return
    }
            // data!.writeToFile(localPath.absoluteString, atomically: true)
            
             //var uniqueID=
            
    

            var date=self.getDateString(Date())
            var status="pending"
           
            ///messages.add(["msg":txtFieldMessage.text!+" (pending)", "type":"2", "fromFullName":"","date":date,"uniqueid":uniqueid_chat])
            
            
            
            
            //save chat
            sqliteDB.storeGroupsChat(username!, group_unique_id1: self.groupid1, type1: "image", msg1: self.filename, from_fullname1: username!, date1: Date(), unique_id1: uniqueid_chat)
            
            
            
            //self.addUploadInfo(self.groupid,uniqueid1: uniqueid_chat, rowindex: self.messages.count, uploadProgress: 0.0, isCompleted: false)
            
            
            //get members and store status as pending
            for i in 0 ..< self.membersList.count
            {
                /*
                 let member_phone = Expression<String>("member_phone")
                 let isAdmin = Expression<String>("isAdmin")
                 let membership_status
                 */
                if((self.membersList[i]["member_phone"] as! String) != username! && (self.membersList[i]["membership_status"] as! String) != "left")
                {
                    print("adding group chat status for \(self.membersList[i]["member_phone"])")
                    sqliteDB.storeGRoupsChatStatus(uniqueid_chat, status1: "pending", memberphone1: self.membersList[i]["member_phone"]! as! String, delivereddate1: UtilityFunctions.init().minimumDate(), readDate1: UtilityFunctions.init().minimumDate())
                    
                    sqliteDB.saveFile(self.membersList[i]["member_phone"]! as! String, from1: username!, owneruser1: username!, file_name1: self.filename, date1: nil, uniqueid1: uniqueid_chat, file_size1: "\(filesize1)", file_type1: ftype, file_path1: filePathImage2, type1: "image")
                    
                }
            }
            
            
            
            
            
            self.tblForGroupChat.reloadData()
            if(self.messages.count>1)
            {
                var indexPath = IndexPath(row:self.messages.count-1, section: 0)
                self.tblForGroupChat.scrollToRow(at: indexPath, at: UITableViewScrollPosition.bottom, animated: true)
                
                
                
            }
            
            /////// dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED,0))
            ////// {
            
           // DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.default).async
                //{
                    /*
                    print("messages count before sending msg is \(self.messages.count)")
                    self.sendChatMessage(self.groupid1, from: username!, type: "image", msg: self.filename, fromFullname: username!, uniqueidChat: uniqueid_chat, completion: { (result) in
                        
                        print("image sent")
                        if(result==true)
                        {
                            for i in 0 ..< self.membersList.count
                            {
                                if((self.membersList[i]["member_phone"] as! String) != username! && (self.membersList[i]["membership_status"] as! String) != "left")
                                {
                                    sqliteDB.updateGroupChatStatus(uniqueid_chat, memberphone1: self.membersList[i]["member_phone"]! as! String, status1: "sent", delivereddate1: Date(), readDate1: Date())
                                    
                                    // === wrong sqliteDB.storeGRoupsChatStatus(uniqueid_chat, status1: "sent", memberphone1: self.membersList[i]["member_phone"]! as! String, delivereddate1: UtilityFunctions.init().minimumDate(), readDate1: UtilityFunctions.init().minimumDate())
                                }
                            }
                            
                            //==== sqliteDB.updateGroupChatStatus(uniqueid_chat, memberphone1: username!,status1: "sent", delivereddate1: UtilityFunctions.init().minimumDate(), readDate1: UtilityFunctions.init().minimumDate())
                            
                            UIDelegates.getInstance().UpdateGroupChatDetailsDelegateCall()
                        }
            */
            
            
            /*
            var imParas=["from":"\(username!)","to":"\(self.selectedContact)","fromFullName":"\(displayname)","msg":self.filename,"uniqueid":uniqueID,"type":"file","file_type":"image"]
            //print("imparas are \(imParas)")
            
            
            var statusNow="pending"
            //------
            sqliteDB.SaveChat(self.selectedContact, from1: username!, owneruser1: username!, fromFullName1: displayname, msg1: self.filename, date1: nil, uniqueid1: uniqueID, status1: statusNow, type1: "file", file_type1: "image", file_path1: filePathImage2)
            
        
            sqliteDB.saveFile(self.selectedContact, from1: username!, owneruser1: username!, file_name1: self.filename, date1: nil, uniqueid1: uniqueID, file_size1: "\(self.fileSize1)", file_type1: ftype, file_path1: filePathImage2, type1: "image")
            
            self.addUploadInfo(self.selectedContact,uniqueid1: uniqueID, rowindex: self.messages.count, uploadProgress: 0.0, isCompleted: false)
            */
                        managerFile.uploadFileInGroup(filePathImage2, groupid1:self.groupid1,from1:username!,uniqueid1:uniqueid_chat,file_name1:self.filename,file_size1:"\(filesize1)",file_type1:ftype,type1:"image")
    
    
                        //uploadFileInGroup(_ filePath1:String,groupid1:String,from1:String, uniqueid1:String,file_name1:String,file_size1:String,file_type1:String,type1:String){
                        

                        
                        //(filePathImage2, to1: self.selectedContact, from1: username!, uniqueid1: uniqueID, file_name1: self.filename, file_size1: "\(self.fileSize1)", file_type1: ftype,type1:"image")
       // })
    
    self.retrieveChatFromSqlite({ (result) in
        
        
   // })
   // (self.selectedContact,completion:{(result)-> () in
        DispatchQueue.main.async
            {
                self.tblForGroupChat.reloadData()
                
                if(self.messages.count>1)
                {
                    print("scrollinggg 5032 line")
                    //var indexPath = NSIndexPath(forRow:self.messages.count-1, inSection: 0)
                    let indexPath = IndexPath(row:self.tblForGroupChat.numberOfRows(inSection: 0)-1, section: 0)
                    self.tblForGroupChat.scrollToRow(at: indexPath, at: UITableViewScrollPosition.bottom, animated: false)
                }
        }
    })
    self.dismiss(animated: true, completion:{ ()-> Void in
        
    })
    })
    let notConfirm = UIAlertAction(title: "No", style: UIAlertActionStyle.cancel, handler: { (action) -> Void in
        
    })
    
    shareMenu.addAction(confirm)
    shareMenu.addAction(notConfirm)
    
    self.dismiss(animated: true, completion:{ ()-> Void in
        
        if(self.showKeyboard==true)
        {
            self.textFieldShouldReturn(self.txtFieldMessage)
            
        }
        self.tblForGroupChat.reloadData()
        if(self.messages.count>1)
        {
            // var indexPath = NSIndexPath(forRow:self.messages.count-1, inSection: 0)
            print("scrollinggg 5306 line")
            let indexPath = IndexPath(row:self.tblForGroupChat.numberOfRows(inSection: 0)-1, section: 0)
            self.tblForGroupChat.scrollToRow(at: indexPath, at: UITableViewScrollPosition.bottom, animated: false)
            
        }
        
        self.present(shareMenu, animated: true) {
            
            
        }
        
    });
    }
      //  }//
   // )
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("picker cancelled")
        DispatchQueue.main.async { () -> Void in
            self.dismiss(animated: true, completion: { ()-> Void in
                
                if(self.showKeyboard==true)
                {
                    print("hidinggg keyboard")
                    self.textFieldShouldReturn(self.txtFieldMessage)
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
    override func viewWillDisappear(_ animated: Bool) {
        
        UIDelegates.getInstance().delegateGroupChatDetails1=nil
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

}
