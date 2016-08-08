//
//  NetworkingManager.swift
//  kiboApp
//
//  Created by Cloudkibo on 05/08/2016.
//  Copyright © 2016 MyAppTemplates. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
class NetworkingManager
{
    
    internal let DEFAULT_MIME_TYPE = "application/octet-stream"
    
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
    
    internal func MimeType(ext: String?) -> String {
        if ext != nil && mimeTypes.contains({ $0.0 == ext!.lowercaseString }) {
            return mimeTypes[ext!.lowercaseString]!
        }
        return DEFAULT_MIME_TYPE
    }
    
    
    static let sharedManager = NetworkingManager()

    
    private lazy var backgroundManager: Alamofire.Manager = {
        let bundleIdentifier = "kiboChat"
        return Alamofire.Manager(configuration: NSURLSessionConfiguration.backgroundSessionConfigurationWithIdentifier(bundleIdentifier + ".background"))
    }()
    
    func uploadFile(filePath1:String,to1:String,from1:String, uniqueid1:String,file_name1:String,file_size1:String,file_type1:String)
    {
        
        var parameters = [
            "to": to1,
            "from": from1,
            "uniqueid": uniqueid1,
            "filename": file_name1,
            "filesize": file_size1,
            "filetype": file_type1]
        
    
        /*var parameterJSON = JSON([
            "to": to1,
            "from": from1,
            "uniqueid": uniqueid1,
            "file_name": file_name1,
            "file_size": file_size1,
            "file_type": file_type1
            /*to
            from
            uniqueid
            file_name
            file_size
            file_type
            */
            ])
 
 */
        // JSON stringify
       // let parameterString = parameterJSON.rawString(NSUTF8StringEncoding, options: NSJSONWritingOptions.PrettyPrinted )
       // let jsonParameterData = parameterString!.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
        var imageData=NSData(contentsOfFile: filePath1)
        print("mimetype is \(MimeType(file_type1))")
        
        var urlupload=Constants.MainUrl+Constants.uploadFile
    Alamofire.upload(
    .POST,
    urlupload,
    headers: header,
    multipartFormData: { multipartFormData in
    multipartFormData.appendBodyPart(data: imageData!, name: "file"
        ,fileName: file_name1, mimeType: self.MimeType(file_type1))
        //,fileName: file_name1, mimeType: "image/\(file_type1)")
        for (key, value) in parameters {
            multipartFormData.appendBodyPart(data: value.dataUsingEncoding(NSUTF8StringEncoding)!, name: key)
        }
    ///multipartFormData.appendBodyPart(data: jsonParameterData!, name: "goesIntoForm")
        
    },
    encodingCompletion: { encodingResult in
        switch encodingResult {
        case .Success(let upload, _, _):
            upload.progress { bytesWritten, totalBytesWritten, totalBytesExpectedToWrite in
                dispatch_async(dispatch_get_main_queue()) {
                    let percent = (Float(totalBytesWritten) / Float(totalBytesExpectedToWrite))
                    /////progress(percent: percent)
                    print("percentage is \(percent)")
                }
            }
            upload.validate()
            upload.responseJSON { response in
                print(response.response?.statusCode)
                print(response.data!)
                
                switch response.result {
                case .Success:
                    
                    //debugPrint(response)
                    print("file upload success")
                    print(response.result.value)
                    print(JSON(response.result.value!)) // "status":"success"
                case .Failure(let error):
                    print("file upload failure")
                }
                //debugPrint(response)
                /*print("response 2 nsdata is \(JSON((response.2?.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength))!)))")
                print("statuscode is \(response.1?.statusCode)")
                print("jsonn response is \(response.1!)")
                print(response.2?.description)
                print(JSON(response.2!))
 */
              //  print("response is \(response.debugDescription)")
               // print("response result value is \(response.result.value)")
            }
        case .Failure(let encodingError):
            print(encodingError)
            print("failureeeeeeee")
        }
        
    }
    )
        
        
    }
    
    func checkPendingFiles(phone1:String)
    {
        var checkPendingFiles=Constants.MainUrl+Constants.checkPendingFile
        
        //Alamofire.request(.POST,"\(removeChatHistoryURL)",headers:header,parameters: ["username":"\(selectedContact)"]).validate(statusCode: 200..<300).response{
        Alamofire.request(.POST,"\(checkPendingFiles)",headers:header,parameters: ["phone":phone1]).validate(statusCode: 200..<300).responseJSON{
            response in
            
           ////// print(response.data!)
            
            switch response.result {
            case .Success:
                
                //debugPrint(response)
                print("checking pending files success")
                ///////print(response.result.value)
                if(response.result.value != nil)
                {print(JSON(response.result.value!)) // "status":"success"
                    var jsonResult=JSON(response.result.value!)
                    //print("count jsonresult is \(jsonResult.count)")
                   // print("count jsonresult zeroth is \(jsonResult[0].count)")
                    print("count jsonresult filepending \(jsonResult["filepending"].count)")

                    if(jsonResult["filepending"]["uniqueid"].isExists())
                    {//print("count filepending is \(jsonResult["filepending"].count)")
                       // for(var i=0;i<jsonResult.count;i++)
                        //{
                          //  if(jsonResult[i]["filepending"]["from"].isExists())
                            //{
                        
                        /*
 
                         "filepending" : {
                         "from" : "+923201211991",
                         "uniqueid" : "ovDA992233720368547758079223372036854775807922337203685477580713289223372036854775807",
                         "_id" : "57a842cfc42c92dc695b162c",
                         "__v" : 0,
                         "file_type" : "JPG",
                         "file_size" : 0,
                         "file_name" : "IMG_0073.JPG",
                         "date" : "2016-08-08T08:29:03.233Z",
                         "path" : "\/f6fdf7ed82d2016884293.jpeg",
                         "to" : "+923333864540"
                         }
 */
                                print("downloading file with id \(jsonResult["filepending"]["uniqueid"])")
                                print("downloading file from \(jsonResult["filepending"]["from"])")
                        if(jsonResult["filepending"]["from"] != nil)
                        {
                            print("downloading file with id \(jsonResult["filepending"]["uniqueid"])")
                            
                            var fileuniqueid=jsonResult["filepending"]["uniqueid"].string!
                            var filePendingName=jsonResult["filepending"]["file_name"].string!
                            var filefrom=jsonResult["filepending"]["from"].string!
                            var filetype=jsonResult["filepending"]["file_type"].string!
                            var filePendingSize="\(jsonResult["filepending"]["file_size"])"
                            var filependingDate=jsonResult["filepending"]["date"].string!
                            var filePendingTo=jsonResult["filepending"]["to"].string!
                            
                              //  self.downloadFile("\(jsonResult["filepending"]["uniqueid"])")
                             self.downloadFile(fileuniqueid,filePendingName: filePendingName,filefrom: filefrom,filetype: filetype,filePendingSize: filePendingSize,filependingDate: filependingDate,filePendingTo: filePendingTo)
                        }
                            //}
                            
                        //}
                   
                    }
                }
                else{
                    print("no pending files found")
                }
            
            case .Failure(let error):
                print("\(error) file check pending failed")
            }
            //request1, response1, data1, error1 in
            
            //===========INITIALISE SOCKETIOCLIENT=========
            // dispatch_async(dispatch_get_main_queue(), {
            
            //self.dismissViewControllerAnimated(true, completion: nil);
            /// self.performSegueWithIdentifier("loginSegue", sender: nil)
            
        /*if response1?.statusCode==200 {
                print("checkPendingFiles success")
                if(data1 != nil)
                {
                print(data1.debugDescription)
                }
                else{
                    print("no pending file")
                }
                //print(JSON(data1!.debugDescription).debugDescription)
            }
            else{
                print("checkpendingfiles failed")
            }*/
        }
    }
    
    func downloadFile(fileuniqueid:String,filePendingName:String,filefrom:String,filetype:String,filePendingSize:String,filependingDate:String,filePendingTo:String)
    {
        let path = NSFileManager.defaultManager().URLsForDirectory(.ApplicationSupportDirectory, inDomains: .UserDomainMask)[0] as NSURL
        //print("path download is \(path)")
       //////// let newPath = path.URLByAppendingPathComponent(fileName1)
       /////// print("full path download file is \(newPath)")
      //////  let destination = Alamofire.Request.suggestedDownloadDestination(directory: .DocumentDirectory, domain: .UserDomainMask)
              //  print("path download is \(destination.lowercaseString)")
      //  Alamofire.download(.GET, "http://httpbin.org/stream/100", destination: destination)
        var downloadURL=Constants.MainUrl+Constants.downloadFile
        
        let destination: (NSURL, NSHTTPURLResponse) -> (NSURL) = {
            (temporaryURL, response) in
            
            if let directoryURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0] as? NSURL {
               //// var localImageURL = directoryURL.URLByAppendingPathComponent("\(response.suggestedFilename!)")
                //filenamePending
                var localImageURL = directoryURL.URLByAppendingPathComponent(filePendingName)
                print("localpathhhhhh \(localImageURL.debugDescription)")
                return localImageURL
            }
            print("tempurl is \(temporaryURL.debugDescription)")
            return temporaryURL
        }

        
        print("downloading call unique id \(fileuniqueid)")
        Alamofire.download(.POST, "\(downloadURL)", headers:header, parameters: ["uniqueid":fileuniqueid], destination: destination)
            .progress { (bytesRead, totalBytesRead, totalBytesExpectedToRead) in
                print("writing bytes \(totalBytesRead)")
            }
            .response { (request, response, _, error) in
                print(response)
                print("1...... \(request?.URLString)")
                print("2..... \(request?.URL.debugDescription)")
                print("3.... \(response?.URL.debugDescription)")
                
                
                let dirPaths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
                let docsDir1 = dirPaths[0]
                var documentDir=docsDir1 as NSString
                var filePendingPath=documentDir.stringByAppendingPathComponent(filePendingName)
                
                
                //filePendingName
                sqliteDB.saveFile(filePendingTo, from1: filefrom, owneruser1: username!, file_name1: filePendingName, date1: nil, uniqueid1: fileuniqueid, file_size1: filePendingSize, file_type1: filetype, file_path1: filePendingPath, type1: "image")
                
                self.confirmDownload(fileuniqueid)
                print("confirminggggggg")
                
               // print(request?.)
                
        }
    }
    
    func confirmDownload(uniqueid1:String)
    {
        let confirmURL=Constants.MainUrl+Constants.confirmDownload
        Alamofire.request(.POST,"\(confirmURL)",headers:header,parameters:["uniqueid":uniqueid1]).validate(statusCode: 200..<300).responseJSON{response in
            
            
            switch response.result {
            case .Success:
                print("download confirm sent \(uniqueid1)")
                
            case .Failure(let error):
                print("confirmation download failed")
            }}
    }
    
    var backgroundCompletionHandler: (() -> Void)? {
        get {
            return backgroundManager.backgroundCompletionHandler
        }
        set {
            backgroundManager.backgroundCompletionHandler = newValue
        }
    }
}

