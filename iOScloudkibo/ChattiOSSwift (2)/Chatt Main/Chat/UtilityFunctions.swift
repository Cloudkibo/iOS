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
import SwiftyJSON
import Photos
import AssetsLibrary
import AlamofireImage

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
    
    func getFileExtension(_ mime:String)->String
    {
        print("taking out extension")
        
        let ext=mimeTypes.keys[mimeTypes.values.index(of: mime)!]
        print("extension is \(ext)")
        return ext
    }
    
    let DEFAULT_MIME_TYPE = "application/octet-stream"
    

     func MimeType(_ ext: String?) -> String {
        if ext != nil && mimeTypes.contains(where: { $0.0 == ext!.lowercased() }) {
            return mimeTypes[ext!.lowercased()]!
        }
        return DEFAULT_MIME_TYPE
    }
    
    func log_papertrail(_ msg:String)
    {
        
        Alamofire.request("https://api.cloudkibo.com/api/users/log", method: .post, parameters: ["data":msg], encoding: JSONEncoding.default)
            .downloadProgress(queue: DispatchQueue.global(qos: .utility)) { progress in
                print("Progress: \(progress.fractionCompleted)")
            }
            .validate { request, response, data in
                // Custom evaluation closure now includes data (allows you to parse data to dig out error messages if necessary)
                return .success
            }
            .responseJSON { response in
                debugPrint(response)
        }

        /*
        Alamofire.request(.POST,"https://api.cloudkibo.com/api/users/log",headers:header,parameters: ["data":msg]).response{
            request, response_, data, error in
            print(error)
        }*/
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
    
    func minimumDate() -> Date
    {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        let someDateTime = formatter.date(from: "0001/01/01 00:01")
        
        return someDateTime!
        /*let calendar = NSCalendar(calendarIdentifier: NSGregorianCalendar)!
        return calendar.dateWithEra(1, year: 1, month: 1, day: 1, hour: 0, minute: 0, second: 0, nanosecond: 0)!*/
    
}
    
 
    func createGroupAPI(_ groupname:String,members:[String],uniqueid:String)
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
        
        Alamofire.request("\(url)", method: .post, parameters: ["group_name":groupname,"members":members, "unique_id":uniqueid],encoding: JSONEncoding.default,headers:header).responseJSON { response in
          
            //alamofire4
        //Alamofire.request(.POST,"\(url)",parameters:["group_name":groupname,"members":members, "unique_id":uniqueid],headers:header,encoding:.JSON).validate().responseJSON { response in
            
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
                sqliteDB.updateGroupCreationDate(uniqueid, date1: NSDate() as Date)
                //update membership status
                for i in 0 ..< members.count
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
    
    
    
    func downloadProfileImageOnLaunch(_ uniqueid1:String,completion:@escaping (_ result:Bool,_ error:String?)->())
    {
        
        var filetype:String=""
        print("inside download group icon on launch")
        //581b26d7583658844e9003d7
        let path = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0] as URL
        //print("path download is \(path)")
        //////// let newPath = path.URLByAppendingPathComponent(fileName1)
        /////// print("full path download file is \(newPath)")
        //////  let destination = Alamofire.Request.suggestedDownloadDestination(directory: .DocumentDirectory, domain: .UserDomainMask)
        //  print("path download is \(destination.lowercaseString)")
        //  Alamofire.download(.GET, "http://httpbin.org/stream/100", destination: destination)
        
        var downloadURL=Constants.MainUrl+Constants.downloadGroupIcon
        
        
       /* let destination1: DownloadRequest.DownloadFileDestination = { _, response in
            var documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            
            filetype=self.getFileExtension(response.mimeType!)
            //var localImageURL = directoryURL.appendingPathComponent(uniqueid1+"."+filetype)
            let fileURL = documentsURL.appendingPathComponent("\(uniqueid1).\(filetype)")
            
           // var localImageURL = documentsURL.appendingPathComponent(filePendingName)
            return (documentsURL, [.removePreviousFile ,.createIntermediateDirectories])
        }*/
        
        
        let destination: Alamofire.DownloadRequest.DownloadFileDestination = { _, response in
            var documentsURL = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
            
            filetype=self.getFileExtension(response.mimeType!)
            //var localImageURL = directoryURL.appendingPathComponent(uniqueid1+"."+filetype)
            let fileURL = documentsURL.appendingPathComponent("\(uniqueid1).\(filetype)")
            
            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
        }
     

/*
        let destination: (URL, HTTPURLResponse) -> (URL) = {
            (temporaryURL, response) in
            print("response file name is \(response.suggestedFilename!)")
            print("tempURL is \(temporaryURL) and response is \(response.allHeaderFields)")
            if let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0] as? URL {
                //// var localImageURL = directoryURL.URLByAppendingPathComponent("\(response.suggestedFilename!)")
                //filenamePending
                ///===  var localImageURL = directoryURL.URLByAppendingPathComponent(filePendingName)
                
                var filetype=self.getFileExtension(response.mimeType!)
                var localImageURL = directoryURL.appendingPathComponent(uniqueid1+"."+filetype)
                
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
        */
        DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.default).async
        {
        // print("downloading call unique id \(fileuniqueid)")
            
            
            
           /* print("download icon \(uniqueid1) destination \(destination1)")
            
            Alamofire.download("\(downloadURL)", method: .post, parameters: ["unique_id":uniqueid1], encoding: JSONEncoding.default, headers: header, to: destination1).response { (response) in
                
                print(response)
            print("download icon \(uniqueid1) destination \(destination)")
            */
            Alamofire.download("\(downloadURL)", method: .post, parameters: ["unique_id":uniqueid1], encoding: JSONEncoding.default, headers: header, to: destination).response { (response) in
                
                print(response)
                /*
                
            
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
                */
                
                print(response)
                print("1...... \(response.request?.url)")
                print("2..... \(response.request?.url.debugDescription)")
                print("3.... \(response.response?.url.debugDescription)")
            //    print("error: \(error)")
                
                if(response.response?.statusCode==200 || response.response?.statusCode==201)
                {
                let dirPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
                let docsDir1 = dirPaths[0]
                var documentDir=docsDir1 as NSString
                
                
                //var filetype=self.getFileExtension(response.MIMEType!)
                
                var filePendingPath=documentDir.appendingPathComponent(uniqueid1+"."+filetype)
                
                print("filePendingPath is \(filePendingPath)")
                //var filePendingPath=documentDir.appendingPathComponent(uniqueid1)
                
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
                
                DispatchQueue.main.async
                {
                    return completion(true, nil)
                /*UIDelegates.getInstance().UpdateMainPageChatsDelegateCall()
                UIDelegates.getInstance().UpdateGroupChatDetailsDelegateCall()
                UIDelegates.getInstance().UpdateGroupInfoDetailsDelegateCall()
 */
                }
            }
            else{
                DispatchQueue.main.async
                {
                    return completion(false, "Error in downloading profile picture")
                }
            }
                // print(request?.)
                
        }
        }
    }
    
    
    
    func downloadProfileImage(_ uniqueid1:String)
    {
        var filetype=""
        //581b26d7583658844e9003d7
        let path = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0] as URL
        //print("path download is \(path)")
        //////// let newPath = path.URLByAppendingPathComponent(fileName1)
        /////// print("full path download file is \(newPath)")
        //////  let destination = Alamofire.Request.suggestedDownloadDestination(directory: .DocumentDirectory, domain: .UserDomainMask)
        //  print("path download is \(destination.lowercaseString)")
        //  Alamofire.download(.GET, "http://httpbin.org/stream/100", destination: destination)
        var downloadURL=Constants.MainUrl+Constants.downloadGroupIcon
        
        
        
        let destination: Alamofire.DownloadRequest.DownloadFileDestination = { _, response in
            var documentsURL = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
            
            filetype=self.getFileExtension(response.mimeType!)
            //var localImageURL = directoryURL.appendingPathComponent(uniqueid1+"."+filetype)
            let fileURL = documentsURL.appendingPathComponent("\(uniqueid1).\(filetype)")
            
            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
        }
        /*let destination: (URL, HTTPURLResponse) -> (URL) = {
            (temporaryURL, response) in
            print("response file name is \(response.suggestedFilename!)")
print("tempURL is \(temporaryURL) and response is \(response.allHeaderFields)")
            if let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0] as? URL {
                //// var localImageURL = directoryURL.URLByAppendingPathComponent("\(response.suggestedFilename!)")
                //filenamePending
              ///===  var localImageURL = directoryURL.URLByAppendingPathComponent(filePendingName)
                
                var filetype=self.getFileExtension(response.mimeType!)
                var localImageURL = directoryURL.appendingPathComponent(uniqueid1+"."+filetype)
                
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
        */
        
       // print("downloading call unique id \(fileuniqueid)")
        
        Alamofire.download("\(downloadURL)", method: .post, parameters: ["unique_id":uniqueid1], encoding: JSONEncoding.default, headers: header, to: destination).response { (response) in
            
            print(response)
            /*
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
                */
                print(response)
            
                
                
                let dirPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
                let docsDir1 = dirPaths[0]
                var documentDir=docsDir1 as NSString
                
                
                //var filetype=self.getFileExtension(response.MIMEType!)
                
                var filePendingPath=documentDir.appendingPathComponent(uniqueid1+"."+filetype)
                
                print("filePendingPath is \(filePendingPath)")
                //var filePendingPath=documentDir.appendingPathComponent(uniqueid1)
                
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
            UIDelegates.getInstance().UpdateSingleChatDetailDelegateCall()
                UIDelegates.getInstance().UpdateGroupChatDetailsDelegateCall()
                UIDelegates.getInstance().UpdateGroupInfoDetailsDelegateCall()
                
                // print(request?.)
                
        }
    }
    
    func downloadGroupIconsService(_ uniqueidArray:[String],completion:@escaping (_ result:Bool,_ error:String?/*,groupiconinfo:[String:NSData]*/)->())
    {
        
        print("group icons array to be downloaded \(uniqueidArray)")
        var storedError: NSError!
        //var iconinfolist=[String:NSData]()
        var downloadGroup = DispatchGroup()
        
        for address in uniqueidArray
        {
            //let url = NSURL(string: address)
            downloadGroup.enter()
            
            
            /*Alamofire.request(.POST,"\(Constants.MainUrl+Constants.urllog)",headers:header,parameters: ["data":"IPHONE_LOG: \(username!) downloading group icons \(uniqueidArray.description)"]).response{
                request, response_, data, error in
                print(error)
            }*/
            
            self.downloadProfileImageOnLaunch(address, completion: { (result, error) in
                print("done downloading pendingGroupIcons \(address)")
                 downloadGroup.leave()
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
                var imgPath=documentDir.appendingPathComponent(filedata["file_name"] as! String)
                
                var imgNSData=NSFileManager.default.contents(atPath:imgPath)
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
        
        downloadGroup.notify(queue: DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.high)) { // 2
           print("pendingGroupIcons done all downloads")
            /*Alamofire.request(.POST,"\(Constants.MainUrl+Constants.urllog)",headers:header,parameters: ["data":"IPHONE_LOG: pendingGroupIcons done all downloads \(username!)"]).response{
                request, response_, data, error in
                print(error)
            }*/
            
            //if let completion = completion {
                               completion(true, nil/*, groupiconinfo: iconinfolist*/)
           // }
        }
    }
    
    func convertStringToDate(_ dateString:String,dateformat:String)->Date
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateformat
        
        let datens2 = dateFormatter.date(from: dateString)
        return datens2!
        
    }

    func findContactsOnBackgroundThread (_ completion:@escaping (_ contact:[CNContact]?)->())/*->([CNContact]))*/ {
        print("inside findContactsOnBackgroundThread")
        DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async(execute: { () -> Void in
            
            //let keysToFetch = [CNContactFormatter.descriptorForRequiredKeysForStyle(.FullName),CNContactPhoneNumbersKey] //CNContactIdentifierKey
            
             let keysToFetch = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactEmailAddressesKey, CNContactPhoneNumbersKey, CNContactImageDataAvailableKey,CNContactThumbnailImageDataKey, CNContactImageDataKey]
            let fetchRequest = CNContactFetchRequest( keysToFetch: keysToFetch as [CNKeyDescriptor])
            var contacts = [CNContact]()
            CNContact.localizedString(forKey: CNLabelPhoneNumberiPhone)
            
            if #available(iOS 10.0, *) {
                fetchRequest.mutableObjects = false
            } else {
                // Fallback on earlier versions
            }
            if #available(iOS 10.0, *) {
                fetchRequest.mutableObjects = false
            } else {
                // Fallback on earlier versions
            }
            fetchRequest.unifyResults = true
            fetchRequest.sortOrder = .userDefault
            
            let contactStoreID = CNContactStore().defaultContainerIdentifier()
            print("\(contactStoreID)")
            
            
            do {
                
                try CNContactStore().enumerateContacts(with: fetchRequest) { (contact, stop) -> Void in
                    //do something with contact
                    if contact.phoneNumbers.count > 0 {
                        print("inside contactsarray class \(contact.phoneNumbers)")
                        contacts.append(contact)
                    }
                    
                }
            } catch let e as NSError {
                print(e.localizedDescription)
            }
            
            DispatchQueue.main.async(execute: { () -> Void in
                return completion(contacts)
                
            })
        })
    }

    func findContact(_ identifiers:String)->[CNContact]
    {var contacts = [CNContact]()
        let store = CNContactStore()
        do{
            contacts = try store.unifiedContacts(matching: CNContact.predicateForContacts(withIdentifiers: [identifiers]), keysToFetch:[CNContactNamePrefixKey as CNKeyDescriptor,
                CNContactGivenNameKey as CNKeyDescriptor,
                CNContactFamilyNameKey as CNKeyDescriptor,
                CNContactOrganizationNameKey as CNKeyDescriptor,
                CNContactBirthdayKey as CNKeyDescriptor,
                CNContactImageDataKey as CNKeyDescriptor,
                CNContactThumbnailImageDataKey as CNKeyDescriptor,
                CNContactImageDataAvailableKey as CNKeyDescriptor,
                CNContactPhoneNumbersKey as CNKeyDescriptor,
                CNContactEmailAddressesKey as CNKeyDescriptor,
                ])

            return contacts
    }
    
    catch
    {
    return contacts
    }
    }
 
    
    func AddtoAddressBook(_ contact1:CNContact,isKibo:Bool,completion:(_ result:Bool)->())
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
    var image=Data()
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
    let a = phoneNumber.value 
    //////////////emails.append(a.valueForKey("digits") as! String)
    var zeroIndex = -1
    var phoneDigits=a.value(forKey: "digits") as! String
    var actualphonedigits=a.value(forKey: "digits") as! String
 
    for i in 0 ..< phoneDigits.characters.count
    {
    if(phoneDigits.characters.first=="0")
    {
    phoneDigits.remove(at: phoneDigits.startIndex)
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
    do{for account in try sqliteDB.db.prepare(tbl_accounts!) {
    countrycode=account[country_prefix]
    //displayname=account[firstname]
    
    }
    }
    }
    if(countrycode=="1")
    {
        if(phoneDigits.characters.first=="1" && phoneDigits.characters.first != "+")
        {
            
            phoneDigits = "+"+phoneDigits
        }
    }
    else if(phoneDigits.characters.first != "+"){
    phoneDigits = "+"+countrycode+phoneDigits
    print("appended phone is \(phoneDigits)")
    }
    
    //////===========
    // =============emails.append(phoneDigits)
    var emailAddress=""
    
        if let em = try contact1.emailAddresses.first{
            print(em.label)
            print(em.value)
            emailAddress=(em.value) as String
            //print("email adress value iss \(emailAddress)")
            
        }
    
    /*    if((em?.value) != nil && (em?.value) != "")
    {
    print(em?.label)
    print(em?.value)
    emailAddress=(em?.value)! as String
    print("email adress value iss \(emailAddress)")
    /////emails.append(em!.value as! String)
    }*/
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
            
            for j in 0 ..< contactsdata.count
            {
                do{
                    try sqliteDB.db.run((tbl_allcontacts?.insert(name<-contactsdata[j]["name"]!,phone<-contactsdata[j]["phone"]!,actualphone<-contactsdata[j]["actualphone"]!,email<-contactsdata[j]["email"]!,uniqueidentifier<-contactsdata[j]["uniqueidentifier"]!,kiboContact<-isKibo))!)
                    
                    return completion(true)
                }
                catch(let error)
                {
                    print("error in inserting contact : \(error)")
                    ///////socketObj.socket.emit("logClient","IPHONE-LOG: iphoneLog: error is getting name \(error)")
                }
            }
            
        
       
         return completion(false)
    
    }
    
    func requestForAccess(_ completionHandler: @escaping (_ accessGranted: Bool) -> Void) {
         let contactStore = CNContactStore()
        let authorizationStatus = CNContactStore.authorizationStatus(for: CNEntityType.contacts)
        
        switch authorizationStatus {
        case .authorized:
            completionHandler(true)
            
        case .denied, .notDetermined:
            contactStore.requestAccess(for: CNEntityType.contacts, completionHandler: { (access, accessError) -> Void in
                if access {
                    completionHandler(access)
                }
                else {
                    if authorizationStatus == CNAuthorizationStatus.denied {
                        DispatchQueue.main.async(execute: { () -> Void in
                            let message = "\(accessError!.localizedDescription)\n\nPlease allow the app to access your contacts through the Settings."
                            completionHandler(false)
                            //==--self.showMessage(message)
                        })
                    }
                }
            })
            
        default:
            completionHandler(false)
        }
    }
    
    func networkRequestDownloadDataRequest()
    {
        /*Alamofire.request("\(Constants.MainUrl+Constants.urllog)", method: .post, parameters: ["data":"IPHONE_LOG: partial sync chat \(username!)"], encoding: JSONEncoding.default)
            .downloadProgress(queue: DispatchQueue.global(qos: .utility)) { progress in
                print("Progress: \(progress.fractionCompleted)")
            }
            .validate { request, response, data in
                // Custom evaluation closure now includes data (allows you to parse data to dig out error messages if necessary)
                return .success
            }
            .responseJSON { response in
                debugPrint(response)
        }*/
    }
    
    
    class func requestGETURL(_ strURL: String, success:@escaping (JSON) -> Void, failure:@escaping (Error) -> Void) {
        Alamofire.request(strURL).responseJSON { (responseObject) -> Void in
            
            print(responseObject)
            
            if responseObject.result.isSuccess {
                let resJson = JSON(responseObject.result.value!)
                success(resJson)
            }
            if responseObject.result.isFailure {
                let error : Error = responseObject.result.error!
                failure(error)
            }
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
    
    func resizedAvatar(img:UIImage!,size:CGSize, sizeStyle:String)->UIImage?
    {
        switch(sizeStyle)
        {
        case "noRatio":
        // Scale image to size disregarding aspect ratio
        let scaledImage = img.af_imageScaled(to: size)
        return scaledImage
        case "Fit":
        // Scale image to fit within specified size while maintaining aspect ratio
        let aspectScaledToFitImage = img.af_imageAspectScaled(toFit: size)
        return aspectScaledToFitImage
        case "Fill":
        // Scale image to fill specified size while maintaining aspect ratio
        let aspectScaledToFillImage = img.af_imageAspectScaled(toFill: size)
            return aspectScaledToFillImage
        
        default: return nil
        }
        
        //return nil
    }
    
    func compareLongerString(txt1:String,txt2:String)->String
    {
        if(txt1.characters.count<txt2.characters.count)
        {
            return txt2
        }
        else
        {
           return txt1
        }

    }
    
    func backupFiles()
    {
        let dirPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let docsDir1 = dirPaths[0]
        var documentDir=docsDir1 as NSString
        
       var dir=URL.init(string: docsDir1)
       
       
        var keys=NSArray.init(objects: [URLResourceKey.isDirectoryKey, URLResourceKey.isPackageKey, URLResourceKey.localizedNameKey,nil])
        var enumerator=FileManager.default.enumerator(at: dir!, includingPropertiesForKeys: [URLResourceKey.isDirectoryKey, URLResourceKey.isPackageKey, URLResourceKey.localizedNameKey])
        
        for url in enumerator!{
            var urlfile=url as! NSURL
            print("url icloud file backup is \(urlfile)")
            
           // var isPackage = AnyObject()
            var rsrcPackage: AnyObject?
            var rsrcDirectory: AnyObject?
            var rsrc: AnyObject?
            
            var fileeee=url as! URL
            print("fileee \(fileeee)")
            do{
            try urlfile.getResourceValue(&rsrcPackage, forKey: URLResourceKey.isPackageKey)
            print("URLResourceKey.isPackageKey \(rsrcPackage)")
            
           // var isDirectory = AnyObject()
            try urlfile.getResourceValue(&rsrcDirectory , forKey: URLResourceKey.isDirectoryKey)
            print("URLResourceKey.isDirectoryKey \(rsrcDirectory)")
       
            
            //var localName = ""
                
                if(rsrcDirectory! as! Bool == false && rsrcPackage! as! Bool == false)
            
                {try urlfile.getResourceValue(&rsrc , forKey:  URLResourceKey.localizedNameKey)
            print(" URLResourceKey.localizedNameKey \(rsrc!)")
                   
                    saveToiCloud(filename: rsrc! as! String,fileurl: fileeee)
                    
                }
            }
            catch
            {
                print("icloud error files ")
            }
        }
           //var filepath=documentDir.appendingPathComponent(filename)
        //var filesList=FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
       // let filelistdocsDir1 = dirPaths[0]
       /* var filesList=FileManager.default.urls(for: documentDir, in: .userDomainMask)
        
        for file in filesList{
            print("got file to be backed up")
            print(file)
        }*/
        
        /*
         NSURL *directoryURL = <#An NSURL object that contains a reference to a directory#>;
         
         NSArray *keys = [NSArray arrayWithObjects:
         NSURLIsDirectoryKey, NSURLIsPackageKey, NSURLLocalizedNameKey, nil];
         
         NSDirectoryEnumerator *enumerator = [[NSFileManager defaultManager]
         enumeratorAtURL:directoryURL
         includingPropertiesForKeys:keys
         options:(NSDirectoryEnumerationSkipsPackageDescendants |
         NSDirectoryEnumerationSkipsHiddenFiles)
         errorHandler:^(NSURL *url, NSError *error) {
         // Handle the error.
         // Return YES if the enumeration should continue after the error.
         return <#YES or NO#>;
         }];
         
         for (NSURL *url in enumerator) {
         
         // Error checking is omitted for clarity.
         
         NSNumber *isDirectory = nil;
         [url getResourceValue:&isDirectory forKey:NSURLIsDirectoryKey error:NULL];
         
         if ([isDirectory boolValue]) {
         
         NSString *localizedName = nil;
         [url getResourceValue:&localizedName forKey:NSURLLocalizedNameKey error:NULL];
         
         NSNumber *isPackage = nil;
         [url getResourceValue:&isPackage forKey:NSURLIsPackageKey error:NULL];
         
         if ([isPackage boolValue]) {
         NSLog(@"Package at %@", localizedName);
         }
         else {
         NSLog(@"Directory at %@", localizedName);
         }
         }
         }
 */
    }
    
    func saveToiCloud(filename:String,fileurl:URL)
        
    {
        var filemgr=FileManager.init()
        DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.default).async
            {
                () -> Void in
                let rootDirect=filemgr.url(forUbiquityContainerIdentifier: "iCloud.iCloud.MyAppTemplates.cloudkibo")?.appendingPathComponent("Backup")
                if((rootDirect) != nil)
                {
                    if((filemgr.fileExists(atPath: rootDirect!.description, isDirectory: nil)) == false)
                    {
                        print("create directory")
                        
                        
                        //var cloudDirect=rootDirect!.URLByAppendingPathComponent("cloudkibo")
                        ///var cloudDirect=rootDirect!.appendingPathComponent("cloudkibo")
                        
                        let cloudDirect=filemgr.url(forUbiquityContainerIdentifier: "iCloud.iCloud.MyAppTemplates.cloudkibo")!.appendingPathComponent("Backup")
                        do{
                            var directAns = try filemgr.createDirectory(at: cloudDirect, withIntermediateDirectories: true, attributes: nil)
                           
                            print("cloudDirect is \(cloudDirect) and creation was \(directAns)")
                            print("directAns is \(directAns)")
                        }catch{
                            print("error 2 is \(error)")
                        }
                    }
                }
                
        }
        
        //let filemgr = FileManager.init()
       // var ubiquityURL=filemgr.url(forUbiquityContainerIdentifier: Constants.icloudcontainer)
        var ubiquityURL=filemgr.url(forUbiquityContainerIdentifier: "iCloud.iCloud.MyAppTemplates.cloudkibo")
            ///.appendingPathComponent("Documents")
        print("number 1 is \(ubiquityURL)")
        ubiquityURL=ubiquityURL!.appendingPathComponent("Backup", isDirectory: true)
        
        
        
        ubiquityURL=ubiquityURL!.appendingPathComponent("\(filename)")
        print("number 4 is \(ubiquityURL)")
        
        
        //let dirPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
       // let docsDir1 = dirPaths[0]
        //var documentDir=docsDir1 as NSString
        //var filepath=documentDir.appendingPathComponent(filename)
        //var ddd=FileManager.init().urls(for: .documentDirectory, in: .userDomainMask)
       // let docsDir1 = ddd[0]
        /*
        let dirPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let docsDir1 = dirPaths[0]
        var documentDir=docsDir1 as NSString
        var filepath=documentDir.appendingPathComponent(filename)
        
        var dir=URL.init(string: filepath)
        */
        
        /*
        let dirPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let docsDir1 = dirPaths[0]
        var documentDir=docsDir1 as NSString
        var filePathImage2=documentDir.appendingPathComponent(filename)
        var fileurl=URL(fileURLWithPath: filePathImage2)
        //var filePathURL=URL(fileURLWithPath: filepath)
        
        //let documentURL=filePathURL //this is full path
        
        */
        
        let dirPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let docsDir1 = dirPaths[0]
        var documentDir=docsDir1 as NSString
        var filePathImage2=documentDir.appendingPathComponent(filename)
        var filedata=NSData.init(contentsOfFile: filePathImage2)
        var filepath2=URL(fileURLWithPath: filePathImage2)
        let documentURL=filepath2
        
        ///////   if let ubiquityURL = ubiquityURL {
        let error:NSError? = nil
        var isDir:ObjCBool = false
        if (filemgr.fileExists(atPath: ubiquityURL!.path, isDirectory: &isDir)) {
            print("file exists alrady on icloud")
            /*do{try filemgr.removeItemAtURL(ubiquityURL!)}
             catch{
             print("error removing file")
             }*/
           /* DispatchQueue.main.async(execute: {
                let alert = UIAlertController(title: "Error", message: "File with the name \(filejustreceivednameToSave) already exists. Please enter new name of file" , preferredStyle: .alert)
                
                //2. Add the text field. You can configure it however you need.
                alert.addTextField(configurationHandler: { (textField) -> Void in
                    textField.text = ""
                })
                
                
                //3. Grab the value from the text field, and print it when the user clicks OK.
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                    let textField = alert.textFields![0] as UITextField
                    print("Text field: \(textField.text)")
                    var newfilenamegot=textField.text!
                    
                    let indExt=filejustreceivednameToSave.characters.index(of: ".")
                    let filetype=filejustreceivednameToSave.substring(from: indExt!)
                    
                    let indExtNewName=newfilenamegot.characters.index(of: ".")
                    
                    if(newfilenamegot.characters.contains("."))
                    {
                        newfilenamegot=newfilenamegot.substring(to: indExtNewName!)
                    }
                    print("newfilenamegot is \(newfilenamegot)")
                    ////filejustreceivednameToSave=textField.text!+filetype
                    filejustreceivednameToSave=newfilenamegot+filetype
                    print("newwwww file isss \(filejustreceivednameToSave)")
                    self.saveToiCloud()
                }))
                
                // 4. Present the alert.
                self.present(alert, animated: true, completion:
                    {
                        
                        
                }
                )
                
            })
            */
            
        }
        else{
            
            do{if (error == nil) {
                print("copying file to icloud")
                
                if(filemgr.fileExists(atPath: filePathImage2) == true)
                
                {
                    var ans=try filemgr.setUbiquitous(true, itemAt: URL.init(fileURLWithPath: filePathImage2), destinationURL: ubiquityURL!)
                    
               // var ans=try filemgr.createFile(atPath: (ubiquityURL?.absoluteString)!, contents: filedata as Data?, attributes: nil)
                    //.copyItem(at: documentURL, to: ubiquityURL!)
                print("Your file \(filename) has been \(ans) saved to iCloud Drive")
                }
                else{
                    print("cannot find file at path \(documentURL)")
                }
                
                /*let alert = UIAlertController(title: "Success", message: "Your file \(filename) has been successfully saved to iCloud Drive", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: {
                    
                    
                })*/
                
                //print(error?.localizedDescription);
                
                }
            else{
                print("Your file \(filename) has not been saved to iCloud Drive \(error)")
                backupChatsTable()
                }
            }
            catch{
                //print("error anssss is \(ans)")
                print("error icloud is \(error)")
                /*let alert = UIAlertController(title: "Cancel", message: "\(error)", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: {
                    
                    
                })*/
            }
            
        }
        
    }
    
    func backupChatsTable()
    {
        let dirPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let docsDir1 = dirPaths[0]
        var documentDir=docsDir1 as NSString
        var filePathImage2=documentDir.appendingPathComponent("chats.JSON")
        print("dir to save table chat json is \(filePathImage2)")
        var text=JSON.init([["fsdf":"Sdfs"],["Sfsf":"Sdfsd"]])
        print("text to be saved is \(Data.init(base64Encoded: text.string!))")
        var filestattus=FileManager.default.createFile(atPath: filePathImage2, contents: Data.init(base64Encoded: text.string!), attributes: nil)
        print("file saved status is \(filestattus)")
        
    }

}

extension PHAsset {
    
    var originalFilename: String? {
        
        var fname:String?
        
        if #available(iOS 9.0, *) {
            let resources = PHAssetResource.assetResources(for: self)
            if let resource = resources.first {
                fname = resource.originalFilename
            }
        }
        
        if fname == nil {
            // this is an undocumented workaround that works as of iOS 9.1
            fname = self.value(forKey: "filename") as? String
        }
        
        return fname
    }
}
