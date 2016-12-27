//
//  UtilityFunctions.swift
//  kiboApp
//
//  Created by Cloudkibo on 25/10/2016.
//  Copyright © 2016 MyAppTemplates. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import Contacts
import SQLite
class UtilityFunctions{
    
    init()
    {
        
    }
    internal let mimeTypes = [
        "html": "text/html",
        "htm": "text/html",
        "shtml": "text/html",
        "css": "text/css",
        "xml": "text/xml",
        "gif": "image/gif",
        "jpeg": "image/jpeg",
        "jpg": "image/jpeg",
        "js": "application/javascript",
        "atom": "application/atom+xml",
        "rss": "application/rss+xml",
        "mml": "text/mathml",
        "txt": "text/plain",
        "jad": "text/vnd.sun.j2me.app-descriptor",
        "wml": "text/vnd.wap.wml",
        "htc": "text/x-component",
        "png": "image/png",
        "tif": "image/tiff",
        "tiff": "image/tiff",
        "wbmp": "image/vnd.wap.wbmp",
        "ico": "image/x-icon",
        "jng": "image/x-jng",
        "bmp": "image/x-ms-bmp",
        "svg": "image/svg+xml",
        "svgz": "image/svg+xml",
        "webp": "image/webp",
        "woff": "application/font-woff",
        "jar": "application/java-archive",
        "war": "application/java-archive",
        "ear": "application/java-archive",
        "json": "application/json",
        "hqx": "application/mac-binhex40",
        "doc": "application/msword",
        "pdf": "application/pdf",
        "ps": "application/postscript",
        "eps": "application/postscript",
        "ai": "application/postscript",
        "rtf": "application/rtf",
        "m3u8": "application/vnd.apple.mpegurl",
        "xls": "application/vnd.ms-excel",
        "eot": "application/vnd.ms-fontobject",
        "ppt": "application/vnd.ms-powerpoint",
        "wmlc": "application/vnd.wap.wmlc",
        "kml": "application/vnd.google-earth.kml+xml",
        "kmz": "application/vnd.google-earth.kmz",
        "7z": "application/x-7z-compressed",
        "cco": "application/x-cocoa",
        "jardiff": "application/x-java-archive-diff",
        "jnlp": "application/x-java-jnlp-file",
        "run": "application/x-makeself",
        "pl": "application/x-perl",
        "pm": "application/x-perl",
        "prc": "application/x-pilot",
        "pdb": "application/x-pilot",
        "rar": "application/x-rar-compressed",
        "rpm": "application/x-redhat-package-manager",
        "sea": "application/x-sea",
        "swf": "application/x-shockwave-flash",
        "sit": "application/x-stuffit",
        "tcl": "application/x-tcl",
        "tk": "application/x-tcl",
        "der": "application/x-x509-ca-cert",
        "pem": "application/x-x509-ca-cert",
        "crt": "application/x-x509-ca-cert",
        "xpi": "application/x-xpinstall",
        "xhtml": "application/xhtml+xml",
        "xspf": "application/xspf+xml",
        "zip": "application/zip",
        "bin": "application/octet-stream",
        "exe": "application/octet-stream",
        "dll": "application/octet-stream",
        "deb": "application/octet-stream",
        "dmg": "application/octet-stream",
        "iso": "application/octet-stream",
        "img": "application/octet-stream",
        "msi": "application/octet-stream",
        "msp": "application/octet-stream",
        "msm": "application/octet-stream",
        "docx": "application/vnd.openxmlformats-officedocument.wordprocessingml.document",
        "xlsx": "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
        "pptx": "application/vnd.openxmlformats-officedocument.presentationml.presentation",
        "mid": "audio/midi",
        "midi": "audio/midi",
        "kar": "audio/midi",
        "mp3": "audio/mpeg",
        "ogg": "audio/ogg",
        "m4a": "audio/x-m4a",
        "ra": "audio/x-realaudio",
        "3gpp": "video/3gpp",
        "3gp": "video/3gpp",
        "ts": "video/mp2t",
        "mp4": "video/mp4",
        "mpeg": "video/mpeg",
        "mpg": "video/mpeg",
        "mov": "video/quicktime",
        "webm": "video/webm",
        "flv": "video/x-flv",
        "m4v": "video/x-m4v",
        "mng": "video/x-mng",
        "asx": "video/x-ms-asf",
        "asf": "video/x-ms-asf",
        "wmv": "video/x-ms-wmv",
        "avi": "video/x-msvideo"
    ]
    
    func getFileExtension(mime:String)->String
    {
        print("taking out extension")
        
        var ext=mimeTypes.keys[mimeTypes.values.indexOf(mime)!]
        print("extension is \(ext)")
        return ext
    }
    
    let DEFAULT_MIME_TYPE = "application/octet-stream"
    

     func MimeType(ext: String?) -> String {
        if ext != nil && mimeTypes.contains({ $0.0 == ext!.lowercaseString }) {
            return mimeTypes[ext!.lowercaseString]!
        }
        return DEFAULT_MIME_TYPE
    }
    
    func log_papertrail(msg:String)
    {
        Alamofire.request(.POST,"https://api.cloudkibo.com/api/users/log",headers:header,parameters: ["data":msg]).response{
            request, response_, data, error in
            print(error)
        }
    }
    
    func randomStringWithLength (len : Int) -> NSString {
        
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        
        let randomString : NSMutableString = NSMutableString(capacity: len)
        
        for (var i=0; i < len; i++){
            let length = UInt32 (letters.length)
            let rand = arc4random_uniform(length)
            randomString.appendFormat("%C", letters.characterAtIndex(Int(rand)))
        }
        
        return randomString
    }
    func generateUniqueid()->String
    {
        
        var uid=randomStringWithLength(7)
        
        var date=NSDate()
        var calendar = NSCalendar.currentCalendar()
        var year=calendar.components(NSCalendarUnit.Year,fromDate: date).year
        var month=calendar.components(NSCalendarUnit.Month,fromDate: date).month
        var day=calendar.components(.Day,fromDate: date).day
        var hr=calendar.components(NSCalendarUnit.Hour,fromDate: date).hour
        var min=calendar.components(NSCalendarUnit.Minute,fromDate: date).minute
        var sec=calendar.components(NSCalendarUnit.Second,fromDate: date).second
        print("\(year) \(month) \(day) \(hr) \(min) \(sec)")
        var uniqueid="\(uid)\(year)\(month)\(day)\(hr)\(min)\(sec)"
        
        return uniqueid
        
        
    }
    
    func minimumDate() -> NSDate
    {
        
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        let someDateTime = formatter.dateFromString("0001/01/01 00:01")
        
        return someDateTime!
        /*let calendar = NSCalendar(calendarIdentifier: NSGregorianCalendar)!
        return calendar.dateWithEra(1, year: 1, month: 1, day: 1, hour: 0, minute: 0, second: 0, nanosecond: 0)!*/
    
}
    
 
    func createGroupAPI(groupname:String,members:[String],uniqueid:String)
    {
        //show progress wheen somewhere
        
        // var memberphones=[String]()
        /*var membersnames=[String]()
        for(var i=0;i<participants.count;i++)
        {
            //  memberphones.append(participants[i].getPhoneNumber())
            membersnames.append(participants[i].displayName())
        }
        */
        var url=Constants.MainUrl+Constants.createGroupUrl
        Alamofire.request(.POST,"\(url)",parameters:["group_name":groupname,"members":members, "unique_id":uniqueid],headers:header,encoding:.JSON).validate().responseJSON { response in
            
            /*
             
             "__v" = 0;
             "_id" = 57c69e61dfff9e5223a8fcb2;
             activeStatus = Yes;
             companyid = cd89f71715f2014725163952;
             createdby = 554896ca78aed92f4e6db296;
             creationdate = "2016-08-31T09:07:45.236Z";
             groupid = 57c69e61dfff9e5223a8fcb1;
             "msg_channel_description" = "This channel is for general discussions";
             "msg_channel_name" = General;
             
             
             */
            print("Create Group API called")
            if(response.result.isSuccess)
            {
                print("success group created")
                //update group date
                sqliteDB.updateGroupCreationDate(uniqueid, date1: NSDate())
                //update membership status
                for(var i=0;i<members.count;i++)
                {
                     sqliteDB.updateMembershipStatus(uniqueid, memberphone1: members[i] as! String, membership_status1: "joined")
                }
                sqliteDB.updateGroupChatMessage(uniqueid, msg1: "You created this group")
                UIDelegates.getInstance().UpdateMainPageChatsDelegateCall()
            }
            else
            {
                print("failed group creation")
                UIDelegates.getInstance().UpdateMainPageChatsDelegateCall()
            }
        }
    }
    
    
    
    func downloadProfileImageOnLaunch(uniqueid1:String,completion:(result:Bool,error:String!)->())
    {
        print("inside download group icon on launch")
        //581b26d7583658844e9003d7
        let path = NSFileManager.defaultManager().URLsForDirectory(.ApplicationSupportDirectory, inDomains: .UserDomainMask)[0] as NSURL
        //print("path download is \(path)")
        //////// let newPath = path.URLByAppendingPathComponent(fileName1)
        /////// print("full path download file is \(newPath)")
        //////  let destination = Alamofire.Request.suggestedDownloadDestination(directory: .DocumentDirectory, domain: .UserDomainMask)
        //  print("path download is \(destination.lowercaseString)")
        //  Alamofire.download(.GET, "http://httpbin.org/stream/100", destination: destination)
        var downloadURL=Constants.MainUrl+Constants.downloadGroupIcon
        
        let destination: (NSURL, NSHTTPURLResponse) -> (NSURL) = {
            (temporaryURL, response) in
            print("response file name is \(response.suggestedFilename!)")
            print("tempURL is \(temporaryURL) and response is \(response.allHeaderFields)")
            if let directoryURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0] as? NSURL {
                //// var localImageURL = directoryURL.URLByAppendingPathComponent("\(response.suggestedFilename!)")
                //filenamePending
                ///===  var localImageURL = directoryURL.URLByAppendingPathComponent(filePendingName)
                
                var filetype=self.getFileExtension(response.MIMEType!)
                var localImageURL = directoryURL.URLByAppendingPathComponent(uniqueid1+"."+filetype)
                
                /*let checkValidation = NSFileManager.defaultManager()
                 
                 if (checkValidation.fileExistsAtPath("\(localImageURL)"))
                 {
                 print("FILE AVAILABLE")
                 }
                 else
                 {
                 print("FILE NOT AVAILABLE")
                 }*/
                
                
                print("localpathhhhhh \(localImageURL.debugDescription)")
                ///sqliteDB.saveFile(uniqueid1, from1: from1, owneruser1: from1, file_name1: filename1, date1: NSDate().description, uniqueid1: UtilityFunctions.init().generateUniqueid(), file_size1: <#T##String#>, file_type1: <#T##String#>, file_path1: <#T##String#>, type1: "groupIcon")
                return localImageURL
            }
            print("tempurl is \(temporaryURL.debugDescription)")
            return temporaryURL
        }
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0))
        {
        // print("downloading call unique id \(fileuniqueid)")
        Alamofire.download(.POST, "\(downloadURL)", headers:header, parameters: ["unique_id":uniqueid1], destination: destination)
            .progress { (bytesRead, totalBytesRead, totalBytesExpectedToRead) in
                print("writing bytes \(totalBytesRead)")
                print(" bytes1 \(bytesRead)")
                print("totalBytesRead bytes \(totalBytesRead)")
                var progressbytes=(Float(totalBytesRead)/Float(totalBytesExpectedToRead)) as Float
                print("totalBytesExpectedToRead are \(totalBytesExpectedToRead)")
                /* if(self.delegateProgressUpload != nil)
                 {
                 if(progressbytes<1.0)
                 {
                 
                 print("calling delegate progress bar.....")
                 self.delegateProgressUpload.updateProgressUpload(progressbytes,uniqueid: fileuniqueid)
                 }
                 
                 }
                 */
                
                /* if(self.delegateProgressUpload != nil)
                 {print("progress download value is \(progressbytes)")
                 self.delegateProgressUpload.updateProgressUpload(progressbytes,uniqueid: fileuniqueid)
                 
                 }*/
            }
            .response { (request, response, _, error) in
                print(response)
                print("1...... \(request?.URLString)")
                print("2..... \(request?.URL.debugDescription)")
                print("3.... \(response?.URL.debugDescription)")
                print("error: \(error)")
                
                if(response?.statusCode==200 || response?.statusCode==201)
                {
                let dirPaths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
                let docsDir1 = dirPaths[0]
                var documentDir=docsDir1 as NSString
                
                
                var filetype=self.getFileExtension(response!.MIMEType!)
                
                var filePendingPath=documentDir.stringByAppendingPathComponent(uniqueid1+"."+filetype)
                
                print("filePendingPath is \(filePendingPath)")
                //var filePendingPath=documentDir.stringByAppendingPathComponent(uniqueid1)
                
                //  if(self.imageExtensions.contains(filetype.lowercaseString))
                // {
                //filePendingName
                sqliteDB.saveFile(uniqueid1, from1: "", owneruser1: "", file_name1: uniqueid1+"."+filetype, date1: nil, uniqueid1: uniqueid1, file_size1: "1", file_type1: filetype, file_path1: filePendingPath, type1: "groupIcon")
                //}
                /*else
                 {
                 sqliteDB.saveFile(filePendingTo, from1: filefrom, owneruser1: username!, file_name1: filePendingName, date1: nil, uniqueid1: fileuniqueid, file_size1: filePendingSize, file_type1: filetype, file_path1: filePendingPath, type1: "document")
                 
                 }
                 if(socketObj.delegateChat != nil)
                 {
                 socketObj.delegateChat.socketReceivedMessageChat("updateUI", data: nil)
                 }
                 */
                
                //===
                /* if(delegateRefreshChat != nil)
                 {
                 delegateRefreshChat?.refreshChatsUI("",uniqueid:fileuniqueid,from:filefrom,date1:NSDate(), type:"chat")
                 }*/
                //filedownloaded’ to with parameters ‘senderoffile’, ‘receiveroffile’
                
                //self.confirmDownload(fileuniqueid)
                print("confirminggggggg")
                
                dispatch_async(dispatch_get_main_queue())
                {
                    return completion(result: true, error: nil)
                /*UIDelegates.getInstance().UpdateMainPageChatsDelegateCall()
                UIDelegates.getInstance().UpdateGroupChatDetailsDelegateCall()
                UIDelegates.getInstance().UpdateGroupInfoDetailsDelegateCall()
 */
                }
            }
            else{
                dispatch_async(dispatch_get_main_queue())
                {
                    return completion(result: false, error: "Error in downloading profile picture")
                }
            }
                // print(request?.)
                
        }
        }
    }
    
    
    
    func downloadProfileImage(uniqueid1:String)
    {
        //581b26d7583658844e9003d7
        let path = NSFileManager.defaultManager().URLsForDirectory(.ApplicationSupportDirectory, inDomains: .UserDomainMask)[0] as NSURL
        //print("path download is \(path)")
        //////// let newPath = path.URLByAppendingPathComponent(fileName1)
        /////// print("full path download file is \(newPath)")
        //////  let destination = Alamofire.Request.suggestedDownloadDestination(directory: .DocumentDirectory, domain: .UserDomainMask)
        //  print("path download is \(destination.lowercaseString)")
        //  Alamofire.download(.GET, "http://httpbin.org/stream/100", destination: destination)
        var downloadURL=Constants.MainUrl+Constants.downloadGroupIcon
        
        let destination: (NSURL, NSHTTPURLResponse) -> (NSURL) = {
            (temporaryURL, response) in
            print("response file name is \(response.suggestedFilename!)")
print("tempURL is \(temporaryURL) and response is \(response.allHeaderFields)")
            if let directoryURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0] as? NSURL {
                //// var localImageURL = directoryURL.URLByAppendingPathComponent("\(response.suggestedFilename!)")
                //filenamePending
              ///===  var localImageURL = directoryURL.URLByAppendingPathComponent(filePendingName)
                
                var filetype=self.getFileExtension(response.MIMEType!)
                var localImageURL = directoryURL.URLByAppendingPathComponent(uniqueid1+"."+filetype)
                
                /*let checkValidation = NSFileManager.defaultManager()
                 
                 if (checkValidation.fileExistsAtPath("\(localImageURL)"))
                 {
                 print("FILE AVAILABLE")
                 }
                 else
                 {
                 print("FILE NOT AVAILABLE")
                 }*/
                
                
                print("localpathhhhhh \(localImageURL.debugDescription)")
                ///sqliteDB.saveFile(uniqueid1, from1: from1, owneruser1: from1, file_name1: filename1, date1: NSDate().description, uniqueid1: UtilityFunctions.init().generateUniqueid(), file_size1: <#T##String#>, file_type1: <#T##String#>, file_path1: <#T##String#>, type1: "groupIcon")
                return localImageURL
            }
            print("tempurl is \(temporaryURL.debugDescription)")
            return temporaryURL
        }
        
        
       // print("downloading call unique id \(fileuniqueid)")
        Alamofire.download(.POST, "\(downloadURL)", headers:header, parameters: ["unique_id":uniqueid1], destination: destination)
            .progress { (bytesRead, totalBytesRead, totalBytesExpectedToRead) in
                print("writing bytes \(totalBytesRead)")
                print(" bytes1 \(bytesRead)")
                print("totalBytesRead bytes \(totalBytesRead)")
                var progressbytes=(Float(totalBytesRead)/Float(totalBytesExpectedToRead)) as Float
                print("totalBytesExpectedToRead are \(totalBytesExpectedToRead)")
                /* if(self.delegateProgressUpload != nil)
                 {
                 if(progressbytes<1.0)
                 {
                 
                 print("calling delegate progress bar.....")
                 self.delegateProgressUpload.updateProgressUpload(progressbytes,uniqueid: fileuniqueid)
                 }
                 
                 }
                 */
                
                /* if(self.delegateProgressUpload != nil)
                 {print("progress download value is \(progressbytes)")
                 self.delegateProgressUpload.updateProgressUpload(progressbytes,uniqueid: fileuniqueid)
                 
                 }*/
            }
            .response { (request, response, _, error) in
                print(response)
                print("1...... \(request?.URLString)")
                print("2..... \(request?.URL.debugDescription)")
                print("3.... \(response?.URL.debugDescription)")
                print("error: \(error)")
                
                
                
                let dirPaths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
                let docsDir1 = dirPaths[0]
                var documentDir=docsDir1 as NSString
                
                
                var filetype=self.getFileExtension(response!.MIMEType!)
                
                var filePendingPath=documentDir.stringByAppendingPathComponent(uniqueid1+"."+filetype)
                
                print("filePendingPath is \(filePendingPath)")
                //var filePendingPath=documentDir.stringByAppendingPathComponent(uniqueid1)
                
              //  if(self.imageExtensions.contains(filetype.lowercaseString))
               // {
                    //filePendingName
                    sqliteDB.saveFile(uniqueid1, from1: "", owneruser1: "", file_name1: uniqueid1+"."+filetype, date1: nil, uniqueid1: uniqueid1, file_size1: "1", file_type1: filetype, file_path1: filePendingPath, type1: "groupIcon")
                //}
                /*else
                {
                    sqliteDB.saveFile(filePendingTo, from1: filefrom, owneruser1: username!, file_name1: filePendingName, date1: nil, uniqueid1: fileuniqueid, file_size1: filePendingSize, file_type1: filetype, file_path1: filePendingPath, type1: "document")
                    
                }
                if(socketObj.delegateChat != nil)
                {
                    socketObj.delegateChat.socketReceivedMessageChat("updateUI", data: nil)
                }
                */
                
                //===
               /* if(delegateRefreshChat != nil)
                {
                    delegateRefreshChat?.refreshChatsUI("",uniqueid:fileuniqueid,from:filefrom,date1:NSDate(), type:"chat")
                }*/
                //filedownloaded’ to with parameters ‘senderoffile’, ‘receiveroffile’
                
                //self.confirmDownload(fileuniqueid)
                print("confirminggggggg")
                
                UIDelegates.getInstance().UpdateMainPageChatsDelegateCall()
                UIDelegates.getInstance().UpdateGroupChatDetailsDelegateCall()
                UIDelegates.getInstance().UpdateGroupInfoDetailsDelegateCall()
                
                // print(request?.)
                
        }
    }
    
    func downloadGroupIconsService(uniqueidArray:[String],completion:(result:Bool,error:String!/*,groupiconinfo:[String:NSData]*/)->())
    {
        
        print("group icons array to be downloaded \(uniqueidArray)")
        var storedError: NSError!
        //var iconinfolist=[String:NSData]()
        var downloadGroup = dispatch_group_create()
        
        for address in uniqueidArray
        {
            //let url = NSURL(string: address)
            dispatch_group_enter(downloadGroup)
            Alamofire.request(.POST,"\(Constants.MainUrl+Constants.urllog)",headers:header,parameters: ["data":"IPHONE_LOG: \(username!) downloading group icons \(uniqueidArray.description)"]).response{
                request, response_, data, error in
                print(error)
            }
            
            self.downloadProfileImageOnLaunch(address, completion: { (result, error) in
                print("done downloading pendingGroupIcons \(address)")
                 dispatch_group_leave(downloadGroup)
            })
            /*
            let photo = DownloadPhoto(url: url!) {
                image, error in
                if let error = error {
                    storedError = error
                }
                dispatch_group_leave(downloadGroup)
            }*/
            
            //PhotoManager.sharedManager.addPhoto(photo)
            //update cell
            /*var filedata=sqliteDB.getFilesData(address)
            //file exists locally
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
                    if(imgNSData != nil)
                    {
                        //uniqueid is key
                        //e.g. [dsfsadfmsafdasdfasf]=[image]
                iconinfolist[address]=imgNSData
                }
            }
            else{
                iconinfolist[address]=NSData.init()
            }
            */

        }
        
        dispatch_group_notify(downloadGroup, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)) { // 2
           print("pendingGroupIcons done all downloads")
            Alamofire.request(.POST,"\(Constants.MainUrl+Constants.urllog)",headers:header,parameters: ["data":"IPHONE_LOG: pendingGroupIcons done all downloads \(username!)"]).response{
                request, response_, data, error in
                print(error)
            }
            
            //if let completion = completion {
                               completion(result: true, error: nil/*, groupiconinfo: iconinfolist*/)
           // }
        }
    }
    
    func convertStringToDate(dateString:String,dateformat:String)->NSDate
    {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = dateformat
        
        let datens2 = dateFormatter.dateFromString(dateString)
        return datens2!
        
    }

    func findContactsOnBackgroundThread (completion:(contact:[CNContact]?)->())/*->([CNContact]))*/ {
        print("inside findContactsOnBackgroundThread")
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), { () -> Void in
            
            //let keysToFetch = [CNContactFormatter.descriptorForRequiredKeysForStyle(.FullName),CNContactPhoneNumbersKey] //CNContactIdentifierKey
            
             let keysToFetch = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactEmailAddressesKey, CNContactPhoneNumbersKey, CNContactImageDataAvailableKey,CNContactThumbnailImageDataKey, CNContactImageDataKey]
            let fetchRequest = CNContactFetchRequest( keysToFetch: keysToFetch)
            var contacts = [CNContact]()
            CNContact.localizedStringForKey(CNLabelPhoneNumberiPhone)
            
            fetchRequest.mutableObjects = false
            fetchRequest.unifyResults = true
            fetchRequest.sortOrder = .UserDefault
            
            let contactStoreID = CNContactStore().defaultContainerIdentifier()
            print("\(contactStoreID)")
            
            
            do {
                
                try CNContactStore().enumerateContactsWithFetchRequest(fetchRequest) { (contact, stop) -> Void in
                    //do something with contact
                    if contact.phoneNumbers.count > 0 {
                        print("inside contactsarray class \(contact.phoneNumbers)")
                        contacts.append(contact)
                    }
                    
                }
            } catch let e as NSError {
                print(e.localizedDescription)
            }
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                return completion(contact: contacts)
                
            })
        })
    }

    func findContact(identifiers:String)->[CNContact]
    {var contacts = [CNContact]()
        let store = CNContactStore()
        do{
            contacts = try store.unifiedContactsMatchingPredicate(CNContact.predicateForContactsWithIdentifiers([identifiers]), keysToFetch:[CNContactNamePrefixKey,
                CNContactGivenNameKey,
                CNContactFamilyNameKey,
                CNContactOrganizationNameKey,
                CNContactBirthdayKey,
                CNContactImageDataKey,
                CNContactThumbnailImageDataKey,
                CNContactImageDataAvailableKey,
                CNContactPhoneNumbersKey,
                CNContactEmailAddressesKey,
                ])

            return contacts
    }
    
    catch
    {
    return contacts
    }
    }
 
    
    func AddtoAddressBook(contact1:CNContact,isKibo:Bool,completion:(result:Bool)->())
    {
        print("AddtoAddressBook called")
        var kiboContact=Expression<Bool>("kiboContact")

        var name=Expression<String>("name")
        var phone=Expression<String>("phone")
        var actualphone=Expression<String>("actualphone")
        var email=Expression<String>("email")
        //////////////var profileimage=Expression<NSData>("profileimage")
        let uniqueidentifier = Expression<String>("uniqueidentifier")
        
        var fullname=""
  
        let tbl_allcontacts=sqliteDB.allcontacts
        var contactsdata=[[String:String]]()
    do{
    
    var uniqueidentifier1=contact1.identifier
    var image=NSData()
        if(contact1.isKeyAvailable(CNContactGivenNameKey))
        {
    fullname=contact1.givenName
            if(contact1.isKeyAvailable(CNContactFamilyNameKey))
            {
                fullname=fullname+" "+contact1.familyName

            }
        }
    if (contact1.isKeyAvailable(CNContactPhoneNumbersKey)) {
    for phoneNumber:CNLabeledValue in contact1.phoneNumbers {print("phones are there")
    let a = phoneNumber.value as! CNPhoneNumber
    //////////////emails.append(a.valueForKey("digits") as! String)
    var zeroIndex = -1
    var phoneDigits=a.valueForKey("digits") as! String
    var actualphonedigits=a.valueForKey("digits") as! String
 
    for(var i=0;i<phoneDigits.characters.count;i++)
    {
    if(phoneDigits.characters.first=="0")
    {
    phoneDigits.removeAtIndex(phoneDigits.startIndex)
    //phoneDigits.characters.popFirst() as! String
    print(".. droping zero \(phoneDigits)")
    }
    else
    {
    break
    }
    }
    do{
    
    
    //get countrycode from db
    
    let country_prefix = Expression<String>("country_prefix")
    
    
    if(countrycode == nil)
    {
    let tbl_accounts = sqliteDB.accounts
    do{for account in try sqliteDB.db.prepare(tbl_accounts) {
    countrycode=account[country_prefix]
    //displayname=account[firstname]
    
    }
    }
    }
    if(countrycode=="1" && phoneDigits.characters.first=="1" && phoneDigits.characters.first != "+")
    {
    phoneDigits = "+"+phoneDigits
    }
    else if(phoneDigits.characters.first != "+"){
    phoneDigits = "+"+countrycode+phoneDigits
    print("appended phone is \(phoneDigits)")
    }
    
    //////===========
    // =============emails.append(phoneDigits)
    var emailAddress=""
    let em = try contact1.emailAddresses.first
    if(em != nil && em != "")
    {
    print(em?.label)
    print(em?.value)
    emailAddress=(em?.value)! as! String
    print("email adress value iss \(emailAddress)")
    /////emails.append(em!.value as! String)
    }
    if(contact1.imageDataAvailable==true)
    {
    image=contact1.imageData!
    }
    print("trying to save \(fullname) and uniqueidentifier is \(uniqueidentifier1)")
    
    var data=[String:String]()
    data["name"]=fullname
    data["phone"]=phoneDigits
    data["actualphone"]=actualphonedigits
    data["email"]=emailAddress
    data["uniqueidentifier"]=uniqueidentifier1
    
    
    contactsdata.append(data)
    //==== --- new commented moved down try sqliteDB.db.run(tbl_allcontacts.insert(name<-fullname,phone<-phoneDigits,actualphone<-actualphonedigits,email<-emailAddress,uniqueidentifier<-uniqueidentifier1))
    }
    catch(let error)
    {
    print("errorr in reading in name : \(error)")
    
    ///////socketObj.socket.emit("logClient","IPHONE-LOG: iphoneLog: error is getting name \(error)")
    }

    }
        }
        }
    catch{
        
        }
       
           //==-- try sqliteDB.db.run(tbl_allcontacts.delete())
            // print("now count is \(sqliteDB.db.scalar(tbl_allcontacts.count))")
            
            for(var j=0;j<contactsdata.count;j++)
            {
                do{
                    try sqliteDB.db.run(tbl_allcontacts.insert(name<-contactsdata[j]["name"]!,phone<-contactsdata[j]["phone"]!,actualphone<-contactsdata[j]["actualphone"]!,email<-contactsdata[j]["email"]!,uniqueidentifier<-contactsdata[j]["uniqueidentifier"]!,kiboContact<-isKibo))
                    
                    return completion(result: true)
                }
                catch(let error)
                {
                    print("error in inserting contact : \(error)")
                    ///////socketObj.socket.emit("logClient","IPHONE-LOG: iphoneLog: error is getting name \(error)")
                }
            }
            
        
       
         return completion(result: false)
    
    }
    
    func requestForAccess(completionHandler: (accessGranted: Bool) -> Void) {
         let contactStore = CNContactStore()
        let authorizationStatus = CNContactStore.authorizationStatusForEntityType(CNEntityType.Contacts)
        
        switch authorizationStatus {
        case .Authorized:
            completionHandler(accessGranted: true)
            
        case .Denied, .NotDetermined:
            contactStore.requestAccessForEntityType(CNEntityType.Contacts, completionHandler: { (access, accessError) -> Void in
                if access {
                    completionHandler(accessGranted: access)
                }
                else {
                    if authorizationStatus == CNAuthorizationStatus.Denied {
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            let message = "\(accessError!.localizedDescription)\n\nPlease allow the app to access your contacts through the Settings."
                            completionHandler(accessGranted: false)
                            //==--self.showMessage(message)
                        })
                    }
                }
            })
            
        default:
            completionHandler(accessGranted: false)
        }
    }
    
   /* func showError(title:String,message:String,button1:String) {
        
        // create the alert
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        
        // add the actions (buttons)
        alert.addAction(UIAlertAction(title: button1, style: UIAlertActionStyle.Default, handler: nil))
        //alert.addAction(UIAlertAction(title: button2, style: UIAlertActionStyle.Cancel, handler: nil))
        
        // show the alert
        self.presentViewController(alert, animated: true, completion: nil)
    }*/
}