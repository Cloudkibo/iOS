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
    
    let videoExtensions=[
        "3gpp",
        "3gp",
        "ts",
        "mp4",
        "mpeg",
        "mpg",
        "mov",
        "webm",
        "flv",
        "mng",
        "asx",
        "asf",
        "wmv",
        "avi"]
    
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
                sqliteDB.updateGroupsCreateNewStatus(uniqueid1: uniqueid, status1: "new")
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
        
        let destination1: Alamofire.DownloadRequest.DownloadFileDestination = { _, response in
            filetype=self.getFileExtension(response.mimeType!)
            var documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            var localImageURL = documentsURL.appendingPathComponent("\(uniqueid1).\(filetype)")
            return (localImageURL, [.removePreviousFile])
        }
        
        
        /*let destination: Alamofire.DownloadRequest.DownloadFileDestination = { _, response in
            var documentsURL = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
            
            filetype=self.getFileExtension(response.mimeType!)
            //var localImageURL = directoryURL.appendingPathComponent(uniqueid1+"."+filetype)
            let fileURL = documentsURL.appendingPathComponent("\(uniqueid1).\(filetype)")
            
            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
        }*/
     

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
            Alamofire.download("\(downloadURL)", method: .post, parameters: ["unique_id":uniqueid1], encoding: JSONEncoding.default, headers: header, to: destination1).response { (response) in
                
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
                print("2..... \(response.response?.allHeaderFields)")
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
                    
                    var iconExists=sqliteDB.checkIfFileExists(uniqueid1)
                    if(iconExists==true)
                    {
                        sqliteDB.updateFileInfo(uniqueid1, from1: "", owneruser1: "", file_name1: uniqueid1+"."+filetype, date1: nil, uniqueid1: uniqueid1, file_size1: "1", file_type1: filetype, file_path1: filePendingPath, type1: "groupIcon", caption1:"")
                    }
                    else{
                        sqliteDB.saveFile(uniqueid1, from1: "", owneruser1: "", file_name1: uniqueid1+"."+filetype, date1: nil, uniqueid1: uniqueid1, file_size1: "1", file_type1: filetype, file_path1: filePendingPath, type1: "groupIcon",caption1:"")
                    }
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
        
        
        let destination1: Alamofire.DownloadRequest.DownloadFileDestination = { _, response in
            var serverfilename=response.suggestedFilename
            filetype=self.getFileExtension(response.mimeType!)
            var documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            var localImageURL = documentsURL.appendingPathComponent("\(uniqueid1).\(filetype)")
            return (localImageURL, [.removePreviousFile])
        }
        
        
        /*let destination: Alamofire.DownloadRequest.DownloadFileDestination = { _, response in
            var documentsURL = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
            
            filetype=self.getFileExtension(response.mimeType!)
            //var localImageURL = directoryURL.appendingPathComponent(uniqueid1+"."+filetype)
            let fileURL = documentsURL.appendingPathComponent("\(uniqueid1).\(filetype)")
            
            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
        }*/
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
        
        Alamofire.download("\(downloadURL)", method: .post, parameters: ["unique_id":uniqueid1], encoding: JSONEncoding.default, headers: header, to: destination1).response { (response) in
            
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
            
            var iconExists=sqliteDB.checkIfFileExists(uniqueid1)
            if(iconExists==true)
            {
                sqliteDB.updateFileInfo(uniqueid1, from1: "", owneruser1: "", file_name1: uniqueid1+"."+filetype, date1: nil, uniqueid1: uniqueid1, file_size1: "1", file_type1: filetype, file_path1: filePendingPath, type1: "groupIcon",caption1:"")
            }
            else{
                sqliteDB.saveFile(uniqueid1, from1: "", owneruser1: "", file_name1: uniqueid1+"."+filetype, date1: nil, uniqueid1: uniqueid1, file_size1: "1", file_type1: filetype, file_path1: filePendingPath, type1: "groupIcon",caption1:"")
            }
            
            
                    /////!!sqliteDB.saveFile(uniqueid1, from1: "", owneruser1: "", file_name1: uniqueid1+"."+filetype, date1: nil, uniqueid1: uniqueid1, file_size1: "1", file_type1: filetype, file_path1: filePendingPath, type1: "groupIcon")
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
 
    func isKiboContact(phone1:String)->Bool
    {
        var allcontactslist1=sqliteDB.allcontacts
        var alladdressContactsArray:Array<Row>
        
        let phone = Expression<String>("phone")
        let kibocontact = Expression<Bool>("kiboContact")
        let name =
            Expression<String?>("name")
        // if(self.getPhoneNumber() != nil)
        //{
        do{for found in try sqliteDB.db.prepare((allcontactslist1?.filter(phone==phone1 && kibocontact==true))!)
        {
           // print("found contact \(self.getPhoneNumber())")
            return true
            }
        }catch{}
        // }
        return false
        
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
        // Scale image to fill specified size while maintaining 
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
       
        /*if (UserDefaults.standard.value(forKey: Constants.defaultsBackupDateTimeKey) == nil)
        {
          UserDefaults.standard.set(Date(), forKey: Constants.defaultsBackupDateTimeKey)
        }*/
       
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
                   
                    copyToICloud(filename: rsrc! as! String,fileurl: fileeee)
                    
                }
            }
            catch
            {
                print("icloud error files ")
            }
        }
        
        backupChatsTable()
        backupFilesTable()
        backupStatusUpdateTable()
        BackupGroupsTable()
        BackupGroupsChatTable()
        BackupGroupMembersTable()
        BackupBroadcastListTable()
        BackupGroupChatsStatusTable()
        BackupBroadcastListMembersTable()
        
   
    }
    
    func copyToICloud(filename:String,fileurl:URL)
        
    {
        var ubiquityURL=getBackupDirectoryICloud()
        
        if(ubiquityURL != nil)
        {
        ubiquityURL=ubiquityURL!.appendingPathComponent("\(filename)")
        print("ubiquityURL is \(ubiquityURL)")
        
        var filemgr=FileManager.init()
        
              let dirPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let docsDir1 = dirPaths[0]
        var documentDir=docsDir1 as NSString
        var filePathImage2=documentDir.appendingPathComponent(filename)
        var filedata=NSData.init(contentsOfFile: filePathImage2)
        var filepath2=URL(fileURLWithPath: filePathImage2)
        let documentURL=filepath2
        
        ///////   if let ubiquityURL = ubiquityURL {
        var error:NSError? = nil
        var isDir:ObjCBool = false
        
        let coordinator = NSFileCoordinator()
        //var error:NSError? = nil
        coordinator.coordinate(readingItemAt: ubiquityURL!, options: [], error: &error) { (url) -> Void in
          
        }
        if (filemgr.fileExists(atPath: ubiquityURL!.path, isDirectory: &isDir)) {
            print("file exists alrady on icloud")
             //IF JSON SO REPLACE
            
            
        }
        else{
            
            do{if (error == nil) {
                print("copying file to icloud")
                
                if(filemgr.fileExists(atPath: filePathImage2) == true)
                
                {
                    
                    do{ var ans=try filemgr.copyItem(at: URL.init(fileURLWithPath: filePathImage2), to: ubiquityURL!)
                    ///var ans=try filemgr.setUbiquitous(true, itemAt: URL.init(fileURLWithPath: filePathImage2), destinationURL: ubiquityURL!)
                    
               // var ans=try filemgr.createFile(atPath: (ubiquityURL?.absoluteString)!, contents: filedata as Data?, attributes: nil)
                    //.copyItem(at: documentURL, to: ubiquityURL!)
                print("Your file \(filename) has been \(ans) saved to iCloud Drive")
                   ///--- backupChatsTable()
                    }
                    catch{
                        print("savedddddd to icloud")
                    }
                }
                else{
                    print("cannot find file at path \(documentURL)")
                }
                }
            else{
                print("Your file \(filename) has not been saved to iCloud Drive \(error)")
                //-----backupChatsTable()
                }
            }
            catch{
                //print("error anssss is \(ans)")
                print("error icloud is \(error)")
                          }
            
        }
    }
    
    }
    
    func getBackupDirectoryICloud()->URL?
    {
        
        var cloudDirect:URL?=nil
        var filemgr=FileManager.init()
      //  DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.default).async
        //    {
          //      () -> Void in
                cloudDirect=filemgr.url(forUbiquityContainerIdentifier: Constants.icloudcontainer)?.appendingPathComponent("Backup")
                if((cloudDirect) != nil)
                {
                    if((filemgr.fileExists(atPath: cloudDirect!.description, isDirectory: nil)) == false)
                    {
                        print("create directory")
                        
                        
                        //var cloudDirect=rootDirect!.URLByAppendingPathComponent("cloudkibo")
                        ///var cloudDirect=rootDirect!.appendingPathComponent("cloudkibo")
                        
                         cloudDirect=filemgr.url(forUbiquityContainerIdentifier: Constants.icloudcontainer)!.appendingPathComponent("Backup")
                        do{
                            var directAns = try filemgr.createDirectory(at: cloudDirect!, withIntermediateDirectories: true, attributes: nil)
                            
                            print("cloudDirect is \(cloudDirect) and creation was \(directAns)")
                            //print("directAns is \(directAns)")
                        }catch{
                            print("error creating backup directory is \(error)")
                        }
                    }
                }
                
      //  }
        
        return cloudDirect
    }
    
    func backupChatsTableDraft()
    {
        let dirPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let docsDir1 = dirPaths[0]
        var documentDir=docsDir1 as NSString
        var filePathImage2=documentDir.appendingPathComponent("chats1.JSON")
        print("dir to save table chat json is \(filePathImage2)")
        
        
        var text=JSON.init([["fsdf":"Sdfs"],["Sfsf":"Sdfsd"]])
        print("text to be saved is \(text)")
        
        do{
            var filestattus=try FileManager.default.createFile(atPath: filePathImage2, contents: text.rawData(), attributes: nil)
        print("file saved status is \(filestattus)")
        }
        catch{
            print("unable to dave chat json file")
        }
        
    }
    
    func saveTableToICloud(filename:String,tableData:Data)->Bool
    {
        var fileMgr=FileManager.init()
        var ubiquityURL=getBackupDirectoryICloud()
        if(ubiquityURL != nil)
        {
            var fileLocation=ubiquityURL?.appendingPathComponent(filename)
            do{var isCreated=try fileMgr.createFile(atPath: (fileLocation?.path)!, contents: tableData, attributes: nil)
           
            if(isCreated==true)
            {
                print("file created on icloud \(filename)")
                return true
            }
            else{
                print("error: file is NOT created on icloud \(filename)")
                return false
            }
            }
            catch{
                print("error saving file \(filename) to icloud")
                return false
            }
            /* if (filemgr.fileExists(atPath: fileLocation!.path, isDirectory: &isDir)) {
                print("file exists alrady on icloud")
                //IF JSON SO REPLACE
                
                
            }
            else{
                
            }*/

        }
        else{
            print("error: iCloud not accessible")
            return false
        }
    }
    func backupChatsTable()
    {
        
        let dirPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let docsDir1 = dirPaths[0]
        var documentDir=docsDir1 as NSString
        var filePathImage2=documentDir.appendingPathComponent("userschats.json")
        print("dir to save table chat json is \(filePathImage2)")
      
        
        var chatsList=[[String:Any]]()
        
        let to = Expression<String>("to")
        let from = Expression<String>("from")
        let fromFullName = Expression<String>("fromFullName")
        let msg = Expression<String>("msg")
        let owneruser = Expression<String>("owneruser")
        let date = Expression<Date>("date")
        let uniqueid = Expression<String>("uniqueid")
        let status = Expression<String>("status")
        let contactPhone = Expression<String>("contactPhone")
        let type = Expression<String>("type")
        let file_type = Expression<String>("file_type")
        let file_path = Expression<String>("file_path")
        let broadcastlistID = Expression<String>("broadcastlistID")
        let isBroadcastMessage = Expression<Bool>("isBroadcastMessage")
        var chats=sqliteDB.userschats
        
        do
        {for chats in try sqliteDB.db.prepare(chats!){
            // print("channel name for deptid \(deptid) is \(channelNames.get(msg_channel_name))")
            var newEntry: [String: Any] = [:]
            
            newEntry["to"]=chats.get(to) as String
            newEntry["from"]=chats.get(from) as String
            newEntry["fromFullName"]=chats.get(fromFullName) as String
            newEntry["msg"]=chats.get(msg) as String
            newEntry["owneruser"]=chats.get(owneruser) as String
            
            var formatterDateSendtoDateType = DateFormatter();
            formatterDateSendtoDateType.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ";
            formatterDateSendtoDateType.timeZone = TimeZone.autoupdatingCurrent
            var datestring=formatterDateSendtoDateType.string(from: chats.get(date))
            
            
            newEntry["date"]=datestring
            newEntry["uniqueid"]=chats.get(uniqueid) as String
            newEntry["status"]=chats.get(status) as String
            newEntry["contactPhone"]=chats.get(contactPhone) as String
            newEntry["type"]=chats.get(type) as String
            newEntry["file_type"]=chats.get(file_type) as String
            newEntry["file_path"]=chats.get(file_path) as String
            newEntry["broadcastlistID"]=chats.get(broadcastlistID) as String
            newEntry["isBroadcastMessage"]=chats.get(isBroadcastMessage) as Bool
            
             chatsList.append(newEntry)
            }
            var text=JSON.init(chatsList)
            //print("text to be saved is \(text.r)")
            
/*            do{
                var filestattus=try FileManager.default.createFile(atPath: filePathImage2, contents: chatsList.toJSON(), attributes: nil)
                print("file saved status is \(filestattus)")
                */
                do{
                    
                var isSaved=saveTableToICloud(filename: "userchats.json", tableData: try chatsList.toJSON())
                    
                    
                    
                }
                
                catch{
                   
                    print("unable to convert to json")
                }
                
               // saveToiCloud(filename: "userschats.json", fileurl: URL.init(fileURLWithPath: filePathImage2))
          /*  }
            catch{
                print("unable to save userchats json file")
            }*/
            
        }
        catch{
            print("error reading from table userchats")
        }
       ///==--- RestoreService.init().RestoreChatsTable(filename: "userchats.json")
        /////---readChatsFile(filename: "userchats.json")
    }
    
    func backupFilesTable()
    {
     
        var filename="files.json"
        var List=[[String:Any]]()
        print("table name is \(filename.removeCharsFromEnd(5))")
        let to = Expression<String>("to") //user phone or group id
        let from = Expression<String>("from")
        let date = Expression<Date>("date")
        let uniqueid = Expression<String>("uniqueid") //chat uniqueid OR group image id
        let contactPhone = Expression<String>("contactPhone")
        let type = Expression<String>("type")  //image or document
        let file_name = Expression<String>("file_name")
        let file_size = Expression<String>("file_size")
        let file_type = Expression<String>("file_type")
        let file_path = Expression<String>("file_path")
        
        var files=sqliteDB.files
        
        do
        {for files in try sqliteDB.db.prepare(files!){
            // print("channel name for deptid \(deptid) is \(channelNames.get(msg_channel_name))")
            
            if (UserDefaults.standard.value(forKey: Constants.defaultsBackupIncludeVideosKey) == nil)
            {
                UserDefaults.standard.set("Off", forKey: Constants.defaultsBackupIncludeVideosKey)
                
            }
            if(UserDefaults.standard.value(forKey: Constants.defaultsBackupIncludeVideosKey) as! String == "Off")
            
            {
                //exclude videos
                if(!videoExtensions.contains((files.get(file_type) as String).lowercased()))
                {
                    print("filetype is not video it is \(files.get(file_type) as String) and settings includevideos is set as \(UserDefaults.standard.value(forKey: Constants.defaultsBackupIncludeVideosKey) as! String)")
            var newEntry: [String: Any] = [:]
            
            newEntry["to"]=files.get(to) as String
            newEntry["from"]=files.get(from) as String
    
                    
                    var formatterDateSendtoDateType = DateFormatter();
                    formatterDateSendtoDateType.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ";
                    formatterDateSendtoDateType.timeZone = TimeZone.autoupdatingCurrent
                    var datestring=formatterDateSendtoDateType.string(from: files.get(date))
            
                    
            newEntry["date"]=datestring
            newEntry["uniqueid"]=files.get(uniqueid) as String
            newEntry["contactPhone"]=files.get(contactPhone) as String
            newEntry["type"]=files.get(type) as String
            newEntry["file_name"]=files.get(file_name) as String
            newEntry["file_size"]=files.get(file_size) as String

            newEntry["file_type"]=files.get(file_type) as String
            newEntry["file_path"]=files.get(file_path) as String
            
            List.append(newEntry)
                }
            }
            else
            {
                print("filetype is not video it is \(files.get(file_type) as String) and settings includevideos is set as \(UserDefaults.standard.value(forKey: Constants.defaultsBackupIncludeVideosKey) as! String)")
                var newEntry: [String: Any] = [:]
                
                newEntry["to"]=files.get(to) as String
                newEntry["from"]=files.get(from) as String
                
                newEntry["date"]=files.get(date).debugDescription as String
                newEntry["uniqueid"]=files.get(uniqueid) as String
                newEntry["contactPhone"]=files.get(contactPhone) as String
                newEntry["type"]=files.get(type) as String
                newEntry["file_name"]=files.get(file_name) as String
                newEntry["file_size"]=files.get(file_size) as String
                
                newEntry["file_type"]=files.get(file_type) as String
                newEntry["file_path"]=files.get(file_path) as String
                
                List.append(newEntry)
 
            }
            }
            var text=JSON.init(List)
            //print("text to be saved is \(text.r)")
            
            /*            do{
             var filestattus=try FileManager.default.createFile(atPath: filePathImage2, contents: chatsList.toJSON(), attributes: nil)
             print("file saved status is \(filestattus)")
             */
            do{
                
                var isSaved=saveTableToICloud(filename: filename, tableData: try List.toJSON())
                print("files table isSaved \(isSaved)")
                
                
            }
                
            catch{
                
                print("unable to convert to json")
            }
            
            // saveToiCloud(filename: "userschats.json", fileurl: URL.init(fileURLWithPath: filePathImage2))
            /*  }
             catch{
             print("unable to save userchats json file")
             }*/
            
        }
        catch{
            print("error reading from table \(filename.removeCharsFromEnd(5))")
        }
        
        ///////RestoreService.init().RestoreFilesTable(filename: filename)
        //copyToAppContainer
        //readChatsFile(filename: filename)
    }
    
    
    

    
    func BackupBroadcastListMembersTable()
    {
        ///
        var filename="broadcastlistmembers.json"
        var List=[[String:Any]]()
        print("table name is \(filename.removeCharsFromEnd(5))")
        
        let uniqueid = Expression<String>("uniqueid")
        let memberphone = Expression<String>("memberphone")
        var files=sqliteDB.broadcastlistmembers
        
        do
        {for files in try sqliteDB.db.prepare(files!){
            // print("channel name for deptid \(deptid) is \(channelNames.get(msg_channel_name))")
            
           var newEntry: [String: Any] = [:]
                    
                    newEntry["uniqueid"]=files.get(uniqueid) as String
                    newEntry["memberphone"]=files.get(memberphone) as String
                    
                  
                    List.append(newEntry)
            
                      }
            var text=JSON.init(List)
        }
        catch
        {
            print("error reading broadcast list members table")
        }
        
        do{
                
                var isSaved=saveTableToICloud(filename: filename, tableData: try List.toJSON())
                print("BackupBroadcastListMembersTable table isSaved \(isSaved)")
                
                
            }
                
            catch{
                
                print("unable to convert to json")
            }
            
            // saveToiCloud(filename: "userschats.json", fileurl: URL.init(fileURLWithPath: filePathImage2))
            /*  }
             catch{
             print("unable to save userchats json file")
             }*/
      
       // RestoreService.init().RestoreFilesTable(filename: filename)
        //copyToAppContainer
        //readChatsFile(filename: filename)
    }
    
    
    
    func BackupGroupChatsStatusTable()
    {
        
        var filename="groupchatstatus.json"
        var List=[[String:Any]]()
        print("table name is \(filename.removeCharsFromEnd(5))")
        
        
        let msg_unique_id = Expression<String>("msg_unique_id")
        let Status = Expression<String>("Status")
        let user_phone = Expression<String>("user_phone")
        
        let read_date = Expression<Date>("read_date")
        let delivered_date = Expression<Date>("delivered_date")
        
        var files=sqliteDB.group_chat_status
      
        
        
        do
        {for files in try sqliteDB.db.prepare(files!){
            // print("channel name for deptid \(deptid) is \(channelNames.get(msg_channel_name))")
            
            var newEntry: [String: Any] = [:]
            
            newEntry["msg_unique_id"]=files.get(msg_unique_id) as String
            newEntry["Status"]=files.get(Status) as String
            newEntry["user_phone"]=files.get(user_phone) as String
            
            var formatterDateSendtoDateType = DateFormatter();
            formatterDateSendtoDateType.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ";
            formatterDateSendtoDateType.timeZone = TimeZone.autoupdatingCurrent
            var datestringread=formatterDateSendtoDateType.string(from: files.get(read_date) as Date)
            
            var datestringdelivered=formatterDateSendtoDateType.string(from: files.get(delivered_date) as Date)
            
            newEntry["read_date"]=datestringread
            newEntry["delivered_date"]=datestringdelivered
           
            
            List.append(newEntry)
            
            }
            var text=JSON.init(List)
        }
        catch
        {
            print("error reading BackupGroupChatsStatusTable table")
        }
        
        do{
            
            var isSaved=saveTableToICloud(filename: filename, tableData: try List.toJSON())
            print("BackupGroupChatsStatusTable table isSaved \(isSaved)")
            
            
        }
            
        catch{
            
            print("unable to convert to json")
        }
        
        // saveToiCloud(filename: "userschats.json", fileurl: URL.init(fileURLWithPath: filePathImage2))
        /*  }
         catch{
         print("unable to save userchats json file")
         }*/
        
        // RestoreService.init().RestoreFilesTable(filename: filename)
        //copyToAppContainer
        //readChatsFile(filename: filename)
    }
    
    
  
    
    
    func BackupBroadcastListTable()
    {
        
        var filename="broadcastlists.json"
        var List=[[String:Any]]()
        print("table name is \(filename.removeCharsFromEnd(5))")
        
        
        let uniqueid = Expression<String>("uniqueid")
        let listname = Expression<String>("listname")
        
        var files=sqliteDB.broadcastlisttable
        
        do
        {for files in try sqliteDB.db.prepare(files!){
            // print("channel name for deptid \(deptid) is \(channelNames.get(msg_channel_name))")
            
            var newEntry: [String: Any] = [:]
            
            newEntry["uniqueid"]=files.get(uniqueid) as String
            newEntry["listname"]=files.get(listname) as String
            
            
            List.append(newEntry)
            
            }
            var text=JSON.init(List)
        }
        catch
        {
            print("error reading broadcastlist table")
        }
        
        do{
            
            var isSaved=saveTableToICloud(filename: filename, tableData: try List.toJSON())
            print("broadcastlist table isSaved \(isSaved)")
            
            
        }
            
        catch{
            
            print("unable to convert to json")
        }
        
        // saveToiCloud(filename: "userschats.json", fileurl: URL.init(fileURLWithPath: filePathImage2))
        /*  }
         catch{
         print("unable to save userchats json file")
         }*/
        
        // RestoreService.init().RestoreFilesTable(filename: filename)
        //copyToAppContainer
        //readChatsFile(filename: filename)
    }
    
    
    
    func BackupGroupsChatTable()
    {
        
        var filename="groupchats.json"
        var List=[[String:Any]]()
        print("table name is \(filename.removeCharsFromEnd(5))")
       
        let from = Expression<String>("from")
        let group_unique_id = Expression<String>("group_unique_id")
        let type = Expression<String>("type")
        let msg = Expression<String>("msg")
        let from_fullname = Expression<String>("from_fullname")
        let date = Expression<Date>("date")
        let unique_id = Expression<String>("unique_id")
        
        
        
        var files=sqliteDB.group_chat
        
        do
        {for files in try sqliteDB.db.prepare(files!){
            // print("channel name for deptid \(deptid) is \(channelNames.get(msg_channel_name))")
            
            var newEntry: [String: Any] = [:]
            
            newEntry["from"]=files.get(from) as String
            newEntry["group_unique_id"]=files.get(group_unique_id) as String
             newEntry["type"]=files.get(type) as String
             newEntry["msg"]=files.get(msg) as String
             newEntry["from_fullname"]=files.get(from_fullname) as String
            
            var formatterDateSendtoDateType = DateFormatter();
            formatterDateSendtoDateType.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ";
            formatterDateSendtoDateType.timeZone = TimeZone.autoupdatingCurrent
            var datestring=formatterDateSendtoDateType.string(from: files.get(date) as Date)
            
            
             newEntry["date"]=datestring
             newEntry["unique_id"]=files.get(unique_id) as String
            
            
            List.append(newEntry)
            
            }
            var text=JSON.init(List)
        }
        catch
        {
            print("error reading broadcast list  table")
        }
        
        do{
            
            var isSaved=saveTableToICloud(filename: filename, tableData: try List.toJSON())
            print("BackupBroadcastListTable table isSaved \(isSaved)")
            
            
        }
            
        catch{
            
            print("unable to convert to json")
        }
        
        // saveToiCloud(filename: "userschats.json", fileurl: URL.init(fileURLWithPath: filePathImage2))
        /*  }
         catch{
         print("unable to save userchats json file")
         }*/
        
        // RestoreService.init().RestoreFilesTable(filename: filename)
        //copyToAppContainer
        //readChatsFile(filename: filename)
    }
    
    
    
    func BackupGroupMembersTable()
    {
        
        var filename="groupmembers.json"
        var List=[[String:Any]]()
        print("table name is \(filename.removeCharsFromEnd(5))")
        
        let group_unique_id = Expression<String>("group_unique_id")
        let member_phone = Expression<String>("member_phone")
        let isAdmin = Expression<String>("isAdmin")
        let membership_status = Expression<String>("membership_status")
        let date_joined = Expression<Date>("date_joined")
        let date_left = Expression<Date>("date_left")
        let group_member_displayname = Expression<String>("group_member_displayname")
        
        var files=sqliteDB.group_member
        
        do
        {for files in try sqliteDB.db.prepare(files!){
            // print("channel name for deptid \(deptid) is \(channelNames.get(msg_channel_name))")
            
            var newEntry: [String: Any] = [:]
            
            newEntry["group_unique_id"]=files.get(group_unique_id) as String
            newEntry["member_phone"]=files.get(member_phone) as String
            newEntry["isAdmin"]=files.get(isAdmin) as String
            newEntry["membership_status"]=files.get(membership_status) as String
            
            var formatterDateSendtoDateType = DateFormatter();
            formatterDateSendtoDateType.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ";
            formatterDateSendtoDateType.timeZone = TimeZone.autoupdatingCurrent
            var datestringjoined=formatterDateSendtoDateType.string(from: files.get(date_joined) as Date)
            
             var datestringleft=formatterDateSendtoDateType.string(from: files.get(date_left) as Date)
            newEntry["date_joined"]=datestringjoined
            newEntry["date_left"]=datestringleft
            newEntry["group_member_displayname"]=files.get(group_member_displayname) as String

            
            
            List.append(newEntry)
            
            }
            var text=JSON.init(List)
        }
        catch
        {
            print("error reading groupmembers table")
        }
        
        do{
            
            var isSaved=saveTableToICloud(filename: filename, tableData: try List.toJSON())
            print("BackupGroupMembers table isSaved \(isSaved)")
            
            
        }
            
        catch{
            
            print("unable to convert to json")
        }
        
        // saveToiCloud(filename: "userschats.json", fileurl: URL.init(fileURLWithPath: filePathImage2))
        /*  }
         catch{
         print("unable to save userchats json file")
         }*/
        
        // RestoreService.init().RestoreFilesTable(filename: filename)
        //copyToAppContainer
        //readChatsFile(filename: filename)
    }
    
    
    
    func BackupGroupsTable()
    {
        
        var filename="groups.json"
        var List=[[String:Any]]()
        print("table name is \(filename.removeCharsFromEnd(5))")
        
        let group_name = Expression<String>("group_name")
        let group_icon = Expression<Data>("group_icon")
        let date_creation = Expression<Date>("date_creation")
        let unique_id = Expression<String>("unique_id")
        let isMute = Expression<Bool>("isMute")
        let status = Expression<String>("status")
  
        var files=sqliteDB.groups
        
        do
        {for files in try sqliteDB.db.prepare(files!){
            // print("channel name for deptid \(deptid) is \(channelNames.get(msg_channel_name))")
            
            var newEntry: [String: Any] = [:]
            
            
            var formatterDateSendtoDateType = DateFormatter();
            formatterDateSendtoDateType.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ";
            formatterDateSendtoDateType.timeZone = TimeZone.current
            var datestring=formatterDateSendtoDateType.string(from: files.get(date_creation))
            
            newEntry["group_name"]=files.get(group_name) as String
            newEntry["group_icon"]=files.get(group_icon).base64EncodedString() ///////----
            newEntry["date_creation"]=datestring
            newEntry["unique_id"]=files.get(unique_id) as String
            newEntry["isMute"]=files.get(isMute)
            newEntry["status"]=files.get(status)
            
            
            List.append(newEntry)
            
            }
            var text=JSON.init(List)
        }
        catch
        {
            print("error reading groups table")
        }
        
        do{
            
            var isSaved=saveTableToICloud(filename: filename, tableData: try List.toJSON())
            print("BackupGroups table isSaved \(isSaved)")
            
            
        }
            
        catch{
            
            print("unable to convert to json")
        }
        
        // saveToiCloud(filename: "userschats.json", fileurl: URL.init(fileURLWithPath: filePathImage2))
        /*  }
         catch{
         print("unable to save userchats json file")
         }*/
        
        // RestoreService.init().RestoreFilesTable(filename: filename)
        //copyToAppContainer
        //readChatsFile(filename: filename)
    }
    
    
  

    
    
    //////
    func backupStatusUpdateTable()
    {
        
        var filename="statusUpdate.json"
        var List=[[String:Any]]()
        print("table name is \(filename.removeCharsFromEnd(5))")
        
        
        let status = Expression<String>("status")
        let sender = Expression<String>("sender")
        let uniqueid = Expression<String>("uniqueid")
        
        var files=sqliteDB.statusUpdate
        
        do
        {for statusUpdate in try sqliteDB.db.prepare(files!){
            // print("channel name for deptid \(deptid) is \(channelNames.get(msg_channel_name))")
            var newEntry: [String: Any] = [:]
            
            newEntry["status"]=statusUpdate.get(status) as String
            newEntry["sender"]=statusUpdate.get(sender) as String
            
            newEntry["uniqueid"]=statusUpdate.get(uniqueid).debugDescription as String
            
            List.append(newEntry)
            }
            var text=JSON.init(List)
            //print("text to be saved is \(text.r)")
            
            /*            do{
             var filestattus=try FileManager.default.createFile(atPath: filePathImage2, contents: chatsList.toJSON(), attributes: nil)
             print("file saved status is \(filestattus)")
             */
            do{
                
                var isSaved=saveTableToICloud(filename: filename, tableData: try List.toJSON())
                
                
                
            }
                
            catch{
                
                print("unable to convert to json")
            }
            
            // saveToiCloud(filename: "userschats.json", fileurl: URL.init(fileURLWithPath: filePathImage2))
            /*  }
             catch{
             print("unable to save userchats json file")
             }*/
            
        }
        catch{
            print("error reading from table \(filename.removeCharsFromEnd(5))")
        }
        
        readChatsFile(filename: filename)
    }


    
    func readChatsFile(filename:String)
    {
        var ubiquityURL=FileManager.init().url(forUbiquityContainerIdentifier: "iCloud.iCloud.MyAppTemplates.cloudkibo")
        if(ubiquityURL != nil)
        {
        ubiquityURL=ubiquityURL!.appendingPathComponent("Backup", isDirectory: true)
        ubiquityURL=ubiquityURL!.appendingPathComponent("\(filename)")
        
        do{ var filedata=try Data.init(contentsOf: ubiquityURL!)
        print("reading \(filename.removeCharsFromEnd(5)) table from icloud")
        print(JSON.init(data: filedata))
        }
        catch{
            print("error reading \(filename.removeCharsFromEnd(5)) table from icloud")
        }
        }
        else{
        //sign in icloud
        }
    }
    
    func blockContact(phone1:String)
    {
        var blockContactURL=Constants.MainUrl+Constants.blockContactURL
        
        //Alamofire.request(.POST,"\(removeChatHistoryURL)",headers:header,parameters: ["username":"\(selectedContact)"]).validate(statusCode: 200..<300).response{
        
        
        Alamofire.request("\(blockContactURL)", method: .post, parameters:  ["phone":phone1],headers:header).response{
            response in
            
            print(response)
            if(response.response?.statusCode==200 || response.response?.statusCode==201)
            {
                //block
                print("contact blocked")
                sqliteDB.BlockContactUpdateStatus(phone1: phone1,status1: true)
            }
            else{
                print("unable to block")
            }
            
        }
    }
    
    func unblockContact(phone1:String)
    {
        var blockContactURL=Constants.MainUrl+Constants.unblockContactURL
        
        //Alamofire.request(.POST,"\(removeChatHistoryURL)",headers:header,parameters: ["username":"\(selectedContact)"]).validate(statusCode: 200..<300).response{
        
        
        Alamofire.request("\(blockContactURL)", method: .post, parameters:  ["phone":phone1],headers:header).response{
            response in
            
            print(response)
            if(response.response?.statusCode==200 || response.response?.statusCode==201)
            {
                //block
                print("contact unblocked")
                sqliteDB.BlockContactUpdateStatus(phone1: phone1,status1: false)
            }
            else{
                print("unable to unblock")
            }
            
        }
    }
    
    func checkIfKiboContactOnServer(phone:String)->Bool
    {
        let searchContactsByPhones=Constants.MainUrl+Constants.searchContactsByPhone
      var result=false
        
        let request = Alamofire.request("\(searchContactsByPhones)", method: .post, parameters: ["phonenumbers":[phone]],encoding: JSONEncoding.init(), headers:header).responseJSON{ response in
            
            
            //alamofire4
            // Alamofire.request(.POST,searchContactsByPhones,headers:header,parameters:["phonenumbers":phones],encoding: .JSON).responseJSON { response in
            
            if(response.response?.statusCode==200)
            {socketObj.socket.emit("logClient","IPHONE-LOG: success in getting available and not available contacts")
                
               // DispatchQueue.global().sync
                    //global(DispatchQueue.GlobalQueuePriority.default,0).sync()
                 //   {
                        debugPrint("response.data \(response.data)")
                        //print(response.request)
                        //print(response.response)
                        //print(response.data)
                        //print(response.e
                        
                        //************* error here...........................
                        //print("response.result.value! \(response.result.value!)")
                        //  print(")response.result.value! \(response.result.value!)")
                        /////////var res=JSON(response.data!)
                        var res=JSON(response.result.value)
                        print("res \(res)")
                        ////////////////var availableContactsEmails=res["available"].object
                        var availableContactsPhones=res["available"]
                        print("available contacts are \(availableContactsPhones.debugDescription)")
                        
                        var notAvailablePhonesArrayReturned=res["notAvailable"]
                        if(availableContactsPhones.count>0)
                        {
                            result=true
                        }
                        else{
                            result=false
                        }
                        
               // }
            }
          
        }
        
        return result
    }
    
    
    func getURLs(text:String)->[NSURL]
    {
        //let text = "http://www.google.com .I am Kirit Modi, Competed Bachelor degree (Information technology). My blog url is http://iosdevcenters.blogspot.in, Check It"
        let types: NSTextCheckingResult.CheckingType = .link
        var URLStrings = [NSURL]()
        let detector = try? NSDataDetector(types: types.rawValue)
        let matches = detector!.matches(in: text, options: .reportCompletion, range: NSMakeRange(0, text.characters.count))
        
        for match in matches {
            print(match.url!)
            URLStrings.append(match.url! as NSURL)
        }
        print("URL URL URL")
        print(URLStrings)
        
        return URLStrings
    }
    
    func getAppState(currentState:UIApplicationState.RawValue)->String
    {
        print("app state application is \(currentState)")
        
        switch(currentState)
        {
        case UIApplicationState.inactive.rawValue:
            print("inactive")
            self.log_papertrail("IPHONE-Log: \(username!) inactive")
            return "inactive"
            
        case UIApplicationState.background.rawValue:
            print("background")
            self.log_papertrail("IPHONE-Log: \(username!) background")
            return "background"
            
        case UIApplicationState.active.rawValue:
            print("active")
            self.log_papertrail("IPHONE-Log: \(username!) active")
            return "active"
            
            
        default: self.log_papertrail(currentState.description)
            return ""
        // print("app state value background is \(UIApplicationState.background.rawValue)")
       // print("app state value inactive is \(UIApplicationState.inactive.rawValue)")
       // print("app state value active is \(UIApplicationState.active.rawValue)")
        }
        
    }
    
    func writeLocaliseFile()
    {  let fileName = "StoryBoardTranslated"
        let DocumentDirURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        
        let fileURL = DocumentDirURL.appendingPathComponent(fileName).appendingPathExtension("txt")
        print("FilePath: \(fileURL.path)")
        
        if let pathTrans = Bundle.main.path(forResource: "storyboardDefault", ofType: "txt") {
            do {
                var storyboardDefault = try String(contentsOfFile: pathTrans, encoding: .utf8) //full string
                //let storyboardDefaultStrings = storyboardDefault.components(separatedBy: .newlines)
                
        if let pathTrans = Bundle.main.path(forResource: "TestStory", ofType: "txt") {
            do {
                let testStory = try String(contentsOfFile: pathTrans, encoding: .utf8) //full string
                let testStoryStrings = testStory.components(separatedBy: .newlines)
                //var newDict=""
                
                if let pathTrans = Bundle.main.path(forResource: "storyTrans", ofType: "txt") {
                    do {
                        let storyTrans = try String(contentsOfFile: pathTrans, encoding: .utf8) //full string
                        let storyTransStrings = storyTrans.components(separatedBy: .newlines)
                        var newDict=""
                        
                for i in 0 ..< testStoryStrings.count
                {
                    
                    storyboardDefault = storyboardDefault.replacingOccurrences(of: testStoryStrings[i], with:storyTransStrings[i], options: NSString.CompareOptions.literal, range: nil)

                    
                    
                 //   newDict=newDict+"\n"+"\""+transStrings[i]+"\""
                    /// newDict=newDict+"\n"+"\""+myStrings[i]+"\"=\""+transStrings[i]+"\";"
                   // print(newDict)
                    
                    
                }
                        print(storyboardDefault)
                let writeString = storyboardDefault
                
                
                ////
              
                
                ////
                do {
                    // Write to the file
                    try writeString.write(to: fileURL, atomically: true, encoding: String.Encoding.utf8)
                    print("writinggg")
                } catch let error as NSError {
                    print("Failed writing to URL: \(fileURL), Error: " + error.localizedDescription)
                }
                

            }
            catch{
                 print(error)
            }
                }
            }
                catch{
                    print("error reading storytrans")
                }
            }
           
                }
            catch{
                print(error)
            }
            

        
       /* if let path = Bundle.main.path(forResource: "keyFile", ofType: "txt") {
            do {
                let data = try String(contentsOfFile: path, encoding: .utf8)
                let myStrings = data.components(separatedBy: .newlines)
                
                if let pathTrans = Bundle.main.path(forResource: "valueFile", ofType: "txt") {
                    do {
                        let trans = try String(contentsOfFile: pathTrans, encoding: .utf8) //full string
                        let transStrings = trans.components(separatedBy: .newlines)
                        var newDict=""
                        for i in 0 ..< myStrings.count
                        {
                            newDict=newDict+"\n"+"\""+myStrings[i]+"\""
                           /// newDict=newDict+"\n"+"\""+myStrings[i]+"\"=\""+transStrings[i]+"\";"
                            print(newDict)
                           

                        }
                        let writeString = newDict
                        do {
                            // Write to the file
                            try writeString.write(to: fileURL, atomically: true, encoding: String.Encoding.utf8)
                            print("writinggg")
                        } catch let error as NSError {
                            print("Failed writing to URL: \(fileURL), Error: " + error.localizedDescription)
                        }
                        
                        
                        //TextView.text = myStrings.joined(separator: ", ")
                    } catch {
                        print(error)
                    }
                }
                
                
                //TextView.text = myStrings.joined(separator: ", ")
            } catch {
                print(error)
            }
        }*/
    }
    }
    
    func replaceStoryboardStrings()
    {
        
        let fileName = "Test"
        let DocumentDirURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        
        let fileURL = DocumentDirURL.appendingPathComponent(fileName).appendingPathExtension("txt")
        print("FilePath: \(fileURL.path)")
        
        
        if let path = Bundle.main.path(forResource: "story", ofType: "txt") {
            do {
                let data = try String(contentsOfFile: path, encoding: .utf8)
                let myStrings = data.components(separatedBy: .newlines)
                
                if let pathTrans = Bundle.main.path(forResource: "valueFile", ofType: "txt") {
                    do {
                        let trans = try String(contentsOfFile: pathTrans, encoding: .utf8) //full string
                        let transStrings = trans.components(separatedBy: .newlines)
                        var newDict=""
                        for i in 0 ..< myStrings.count
                        {
                            newDict=newDict+"\n"+"\""+myStrings[i]+"\"=\""+transStrings[i]+"\";"
                            print(newDict)
                            
                            
                        }
                        let writeString = newDict
                        do {
                            // Write to the file
                            try writeString.write(to: fileURL, atomically: true, encoding: String.Encoding.utf8)
                            print("writinggg")
                        } catch let error as NSError {
                            print("Failed writing to URL: \(fileURL), Error: " + error.localizedDescription)
                        }
                        
                        
                        //TextView.text = myStrings.joined(separator: ", ")
                    } catch {
                        print(error)
                    }
                }
                
                
                //TextView.text = myStrings.joined(separator: ", ")
            } catch {
                print(error)
            }
        }

        
        
        
        
        // Save data to file
        
       /* for (originalWord, newWord) in myDictionary {
            myString = myString.stringByReplacingOccurrencesOfString(originalWord, withString:newWord, options: NSStringCompareOptions.LiteralSearch, range: nil)
        }*/
        }
    
    func getDateShortened(date2:String)->String
    {
        var displaydate=""
        let formatter = DateFormatter();
        //formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS";
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        //formatter.dateFormat = "MM/dd hh:mm a";
        formatter.timeZone = TimeZone.autoupdatingCurrent
        let defaultTimeZoneStr = formatter.date(from: date2)
        //print("defaultTimeZoneStr \(defaultTimeZoneStr)")
        
       /* if(defaultTimeZoneStr == nil)
        {
            timeLabel.text=date2 as! String
            
        }
        else
        {*/
            let formatter2 = DateFormatter();
            formatter2.timeZone=TimeZone.autoupdatingCurrent
            formatter2.dateFormat = "MM/dd hh:mm a";
             displaydate=formatter2.string(from: defaultTimeZoneStr!)
        
        return displaydate
   // }
    }
    
    func sendDataToDesktopApp(data1:AnyObject,type1:String)
    {
        print("inside sending data to desktop")
        if(desktopAppRoomJoined==true)
        {
        var serviceSendInitialData=ConnectToDesktop.init()
        UtilityFunctions.init().log_papertrail("IPHONE-DESKTOP-LOG : desktopID \(desktopRoomID) .. mobileID \(mobileSocketID)")
        serviceSendInitialData.startInitialDataLoad(phone: username!, to_connection_id: desktopRoomID, from_connection_id:mobileSocketID, data: data1, type: type1)
        }
        else{
            UtilityFunctions.init().log_papertrail("IPHONE-LOG-DESK: room not joined")
        }
        
    }
    
    func sendAttachment(_ screenshot: UIImage!,unique_id1:String) {
        var chunkLength=16000
        var imageData:Data = UIImageJPEGRepresentation(screenshot, 1.0)!
        var numchunks=0
        var len=imageData.count
        print("length is\(len)")
        numchunks=len/chunkLength
        print("numchunks are \(numchunks)")
        
        var test="\(imageData.count)"
        
        //to send total file size commented
        //self.sendDataBuffer(test, isb: false)
        
        for j in 0 ..< numchunks
        {
            var start=j*chunkLength
            var end=(j+1)*chunkLength
            var newrange=start..<end
            
            let range:Range<Data.Index> = start..<end
            var data=["unique_id":unique_id1,"chunk":imageData.subdata(in: range),"chunk_id":j+1,"total_chunks":numchunks+1] as [String : Any]
            print(data)
            UtilityFunctions.init().log_papertrail("IPHONE-Desk \(username!) image START \(start) END \(end-1)")
            self.sendDataToDesktopApp(data1: data as AnyObject, type1: "mobile_sending_chunk")
            //self.sendImageUsingSocket(imageData.subdata(in: range))
            
        }
        if((len%chunkLength) > 0)
        {
            print("len%chunkLength \(len%chunkLength)")
            
            //imageData.getBytes(&imageData, length: numchunks*chunkLength)
            var data=["unique_id":unique_id1,"chunk":imageData.subdata(in: numchunks*chunkLength..<len
                /*%chunkLength*/),"chunk_id":numchunks+1,"total_chunks":numchunks+1] as [String : Any]
             UtilityFunctions.init().log_papertrail("IPHONE-Desk \(username!) image last chunk START \(numchunks*chunkLength) END \(len-1)")
            self.sendDataToDesktopApp(data1: data as AnyObject, type1: "mobile_sending_chunk")
           
            
           // self.sendImageUsingSocket(imageData.subdata(in: numchunks*chunkLength..<len%chunkLength))
            
        }
        
    }
   
    /*func sendImageUsingSocket(_ imageData:Data)
    {
        // let imageSent=self.rtcDataChannel.sendData(RTCDataBuffer(data: imageData, isBinary: true))
        
        //(parameters in data field: unique_id, chunk, chunk_id, total_chunks)
        var dataInput=["phone":username!,
                       "to_connection_id" : desktopRoomID,
                       "from_connection_id" : mobileSocketID,
                       "data":imageData,
                       "type": "mobile_sending_chunk"] as [String : Any]
        socketObj.socket.emit("platform_room_message", dataInput)
        
    }*/
    
    
    
    func hexStringToUIColor (_ hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: (NSCharacterSet.whitespacesAndNewlines as NSCharacterSet) as CharacterSet).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString = cString.substring(from: cString.characters.index(cString.startIndex, offsetBy: 1))
        }
        
        if ((cString.characters.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    func getLastSeen(phone1:String)->String
    {
        var lastseen=""
        //  let slp = SwiftLinkPreview()
        Alamofire.request(Constants.MainUrl+Constants.getLastSeen, method: .post, parameters: ["phone":phone1], encoding: JSONEncoding.default, headers: header).responseJSON { (response) in
            
            if(response.response?.statusCode==200)
            {
                var dataGot=JSON(response.data)
                print(dataGot)
                //lastseen=dataGot.description
                lastseen=dataGot["last_seen"].string!
            }
        }
        return lastseen
    }
    
    func leftJoinContactsTables(_ phone1:String)->Array<Row>
    {
        
        var resultrow=Array<Row>()
        let name = Expression<String>("name")
        let phone = Expression<String>("phone")
        let actualphone = Expression<String>("actualphone")
        let email = Expression<String>("email")
        let kiboContact = Expression<Bool>("kiboContact")
        /////////////////////let profileimage = Expression<NSData>("profileimage")
        let uniqueidentifier = Expression<String>("uniqueidentifier")
        //
        var allcontacts = sqliteDB.allcontacts
        //========================================================
        let contactid = Expression<String>("contactid")
        let detailsshared = Expression<String>("detailsshared")
        let unreadMessage = Expression<Bool>("unreadMessage")
        
        let userid = Expression<String>("userid")
        let firstname = Expression<String>("firstname")
        let lastname = Expression<String>("lastname")
        //---let email = Expression<String>("email")
        //--- let phone = Expression<String>("phone")
        let username = Expression<String>("username")
        let status = Expression<String>("status")
        
        var contactslists = sqliteDB.contactslists
        //=================================================
        var joinquery=allcontacts?.join(.leftOuter, contactslists!, on: (contactslists?[phone])! == (allcontacts?[phone])!).filter((allcontacts?[phone])!==phone1)
        
        do{for joinresult in try sqliteDB.db.prepare(joinquery!) {
            
            resultrow.append(joinresult)
            }
        }
        catch{
            print("error in join query \(error)")
        }
        return resultrow
        
    }
    
    /*func sendLogMessageToAllMembers(logMsgType:String,groupid:String,action_by:String)
    {
     var groupmembers=sqliteDB.getGroupMembersOfGroup(groupid)
        for var i in 0..<groupmembers.count
        {
            /*newEntry["group_unique_id"]
            newEntry["member_phone"]
            newEntry["isAdmin"]
            newEntry["membership_status"]
            newEntry["date_joined"]
            newEntry["date_left"]
            newEntry["group_member_displayname"]
            */
            switch(logMsgType)
            {
            case "removed-you": print("left group")
            case "removed-member-info": print("left group")
                
            case "group-added": print("left group")
            default:print("-")
            }
        }
    }*/
    
    

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
