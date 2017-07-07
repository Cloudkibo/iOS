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
import Compression
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

class NetworkingManager
{
    var delegateProgressUpload:showUploadProgressDelegate!
   
    let imageExtensions=[
        "gif",
        "jpeg",
        "jpg",
        "png",
        "tif",
        "tiff",
        "wbmp",
        "ico",
        "jng",
        "bmp",
        "svg",
        "svgz",
        "webp"
    ]
    
    
    let audioExtensions=[
        "mid",
        "midi","kar","mp3","ogg","m4a",
        "ra"
    ]
    //m4a
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
    internal let DEFAULT_MIME_TYPE = "application/octet-stream"
    
     let mimeTypes = [
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
    
    internal func MimeType(_ ext: String?) -> String {
        if ext != nil && mimeTypes.contains(where: { $0.0 == ext!.lowercased() }) {
            return mimeTypes[ext!.lowercased()]!
        }
        return DEFAULT_MIME_TYPE
    }
    
    
    static let sharedManager = NetworkingManager()

    
    fileprivate lazy var backgroundManager: Alamofire.SessionManager = {
        let bundleIdentifier = "kiboChat"
        return Alamofire.SessionManager(configuration: URLSessionConfiguration.background(withIdentifier: bundleIdentifier + ".background"))
    }()
    
    
    
    
    
    
    
    
    func sendChatMessage(_ chatstanza:[String:String],completion:@escaping (_ result:Bool)->())
    {
        
       // let queue = dispatch_queue_create("com.kibochat.manager-response-queue", DISPATCH_QUEUE_SERIAL)
        
        var url=Constants.MainUrl+Constants.sendChatURL
      /*
        let request = Alamofire.request(.POST, "\(url)", parameters: chatstanza,headers:header)
        request.response(
            queue: queue,
            responseSerializer: Request.JSONResponseSerializer(options: .AllowFragments),
          completionHandler: { response in
 
 */
        
        let request = Alamofire.request("\(url)", method: .post, parameters: chatstanza,headers:header).response { response in
        
        
            //alamofire4
      //  let request = Alamofire.request(.POST, "\(url)", parameters: chatstanza,headers:header).responseJSON { response in
                // You are now running on the concurrent `queue` you created earlier.
               

 print("Parsing JSON on thread: \(Thread.current) is main thread: \(Thread.isMainThread)")
                
                // Validate your JSON response and convert into model objects if necessary
               // print(response.result.value) //status, uniqueid
                
                // To update anything on the main thread, just jump back on like so.
                print("sending pending msg.... \(chatstanza["msg"])")
                if(response.response?.statusCode==200)
                {print("got response pending msg.... \(chatstanza["msg"])")
                    
                    print("chat ack received")
                    var statusNow="sent"
                    ///var chatmsg=JSON(data)
                    /// print(data[0])
                    ///print(chatmsg[0])
                    print("chat sent msg \(chatstanza)")
                    
                    sqliteDB.UpdateChatStatus(chatstanza["uniqueid"]!, newstatus: "sent")
                    
                    
                    completion(true)
                    
                    
                    
                    
                    //happens when synch finishes after server chat is fetched
                   /* DispatchQueue.main.async {
                       // print("Am I back on the main thread: \(NSThread.isMainThread())")
                        
                        
                        //////self.retrieveChatFromSqlite(self.selectedContact)
                        
                        if(delegateRefreshChat != nil)
                        {delegateRefreshChat?.refreshChatsUI("updateUI", data: nil)
                        }
                       
                        
                    }*/
                }
                
                 completion(false)
            }
   
        //)
        
    }
    
    func sendStatusReplyMessage(_ chatstanza:[String:String],completion:@escaping (_ result:Bool)->())
    {
        
        // let queue = dispatch_queue_create("com.kibochat.manager-response-queue", DISPATCH_QUEUE_SERIAL)
        
        var url=Constants.MainUrl+Constants.sendChatURL
        /*
         let request = Alamofire.request(.POST, "\(url)", parameters: chatstanza,headers:header)
         request.response(
         queue: queue,
         responseSerializer: Request.JSONResponseSerializer(options: .AllowFragments),
         completionHandler: { response in
         
         */
        
        let request = Alamofire.request("\(url)", method: .post, parameters: chatstanza,headers:header).response { response in
            
            
            //alamofire4
            //  let request = Alamofire.request(.POST, "\(url)", parameters: chatstanza,headers:header).responseJSON { response in
            // You are now running on the concurrent `queue` you created earlier.
            
            
            print("Parsing JSON on thread: \(Thread.current) is main thread: \(Thread.isMainThread)")
            
            // Validate your JSON response and convert into model objects if necessary
            // print(response.result.value) //status, uniqueid
            
            // To update anything on the main thread, just jump back on like so.
            print("sending pending msg.... \(chatstanza["msg"])")
            if(response.response?.statusCode==200)
            {print("got response pending msg.... \(chatstanza["msg"])")
                
                print("chat ack received")
                var statusNow="sent"
                ///var chatmsg=JSON(data)
                /// print(data[0])
                ///print(chatmsg[0])
                print("chat sent msg \(chatstanza)")
                
                sqliteDB.UpdateChatStatus(chatstanza["uniqueid"]!, newstatus: "sent")
                
                
                completion(true)
                
                
                
                
                //happens when synch finishes after server chat is fetched
                /* DispatchQueue.main.async {
                 // print("Am I back on the main thread: \(NSThread.isMainThread())")
                 
                 
                 //////self.retrieveChatFromSqlite(self.selectedContact)
                 
                 if(delegateRefreshChat != nil)
                 {delegateRefreshChat?.refreshChatsUI("updateUI", data: nil)
                 }
                 
                 
                 }*/
            }
            
            completion(false)
        }
        
        //)
        
    }

    
    
    
    func sendChatStatusUpdateMessage(_ uniqueid:String,status:String,sender:String)
    {
        if(status != "delivered")
        {
        
      //  let queue = dispatch_queue_create("com.kibochat.manager-response-queue", DISPATCH_QUEUE_CONCURRENT)
        
        var url=Constants.MainUrl+Constants.sendChatStatusURL
        
        /*let request = Alamofire.request(.POST, "\(url)", parameters: ["uniqueid":uniqueid,"sender":sender,"status":status],headers:header)
        request.response(
            queue: queue,
            responseSerializer: Request.JSONResponseSerializer(options: .AllowFragments),
            completionHandler: { response in
               
                */
        
        
        let request = Alamofire.request("\(url)", method: .post, parameters: ["uniqueid":uniqueid,"sender":sender,"status":status],headers:header).responseJSON { response in
      
        //alamofire4
        ////let request = Alamofire.request(.POST, "\(url)", parameters: ["uniqueid":uniqueid,"sender":sender,"status":status],headers:header).responseJSON { response in
                // You are now running on the concurrent `queue` you created earlier.
                print("Parsing JSON on thread: \(Thread.current) is main thread: \(Thread.isMainThread)")
                
                // Validate your JSON response and convert into model objects if necessary
               /////// print(response.result.value!) //status, uniqueid
                
                
                // To update anything on the main thread, just jump back on like so.
                
                if(response.response?.statusCode==200)
                {
                    var resJSON=JSON(response.result.value!)
                    print("json is \(resJSON)")
                    
                    
                   ///// DispatchQueue.main.async {
                        print("Am I back on the main thread: \(Thread.isMainThread)")
                        print("uniqueid is \(resJSON["uniqueid"].string!)")
                        sqliteDB.removeMessageStatusSeen(resJSON["uniqueid"].string!)
                    
                        print("chat message status ack received")
                        
                        //print(data[0]["status"]!!.string!+" ... "+data[0]["uniqueid"]!!.string!)
                        print("chat status seen emitted")
                        
                        socketObj.socket.emit("logClient","\(username) chat status emitted")
                        
                        
                        
                        
                        
                    ////////}
                }
            }
       // )
    }
    }

    func uploadFileInGroup(_ filePath1:String,groupid1:String,from1:String, uniqueid1:String,file_name1:String,file_size1:String,file_type1:String,type1:String,label1:String){
        
        var membercount=sqliteDB.getGroupMembersCount(groupid1: groupid1)
        var parameters = [
            "group_unique_id": groupid1,
            "from": from1,
            "total_members":"\(membercount)",
            "uniqueid": uniqueid1,
            "filename": file_name1,
            "filesize": file_size1,
            "filetype": type1,
            "label":label1
           ]
        
        /*group_unique_id : req.body.group_unique_id,
        from : req.body.from,
        total_members: req.body.total_members,
        uniqueid: req.body.uniqueid,
        file_name : req.body.filename,
        file_size : req.body.filesize,
        path : serverPath,*/
        
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
        
        var imageData:Data?
        if(self.imageExtensions.contains(file_type1.lowercased()))
        {
            imageData=UIImageJPEGRepresentation(UIImage(contentsOfFile: filePath1)!,0.9)
            print("new upload image size is \(imageData!.count)")
        }
            
        else{
            
            /*if(self.audioExtensions.contains(file_type1.lowercased()))
             {
             //imageData=UIImageJPEGRepresentation(UIImage(contentsOfFile: filePath1)!,0.9)
             print("audio file is uploading")
             //imageData=try? Data(contentsOf: URL(fileURLWithPath: filePath1))
             }else{*/
            imageData=try? Data(contentsOf: URL(fileURLWithPath: filePath1))
            print("old upload image size is \(imageData!.count)")
            var imageData2=imageData!.compressed(using: Compression.zlib)
            print("imageData2 is \(imageData2)")
            print("old upload image compressed size is \(imageData2!.count)")
            //}
        }
        // var imageData=UIImageJPEGRepresentation(UIImage(contentsOfFile: filePath1)!,0.9)
        
        // print("ols upload image size is \(imageData2!.length)")
        
        print("mimetype is \(MimeType(file_type1))")
        
        var urlupload=Constants.MainUrl+Constants.uploadImageInGroupChatURL
        
        
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                multipartFormData.append(imageData!, withName:  "file", fileName: file_name1, mimeType: self.MimeType(file_type1))                //,fileName: file_name1, mimeType: "image/\(file_type1)")
                for (key, value) in parameters {
                    multipartFormData.append(value.data(using: .utf8)!, withName: key)
                    // multipartFormData.append(data: value.data(using: String.Encoding.utf8)!, withName: key)
                }
                
        },
            to: urlupload,headers: header,
            encodingCompletion: { encodingResult in
                switch encodingResult {
                    
                    /*
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
                     */
                case .success(let upload, _, _):
                    
                    upload.validate()
                    upload.uploadProgress { progress in // main queue by default
                        print("Upload Progress: \(progress.fractionCompleted)")
                    }
                    upload.responseJSON { response in
                        print(response.response?.statusCode)
                        print(response.data!)
                        
                        switch response.result {
                        case .success:
                            
                            var uniqueid_chat=UtilityFunctions.init().generateUniqueid()
                            
                            //var date=self.getDateString(Date())
                            var status="pending"
                            
                            ///messages.add(["msg":txtFieldMessage.text!+" (pending)", "type":"2", "fromFullName":"","date":date,"uniqueid":uniqueid_chat])
                            
                            
                            
                            
                            //save chat
                            //////sqliteDB.storeGroupsChat(username!, group_unique_id1: self.groupid1, type1: "chat", msg1: self.txtFieldMessage.text!, from_fullname1: username!, date1: Date(), unique_id1: uniqueid_chat)
                            
                            
                            
                    
                            
                            
                            DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.default).async
                                {
                                    
                                    var url=Constants.MainUrl+Constants.sendGroupChat
                                    print(url)
                                    print("..")
                                    //filePath1:String,groupid1:String,from1:String, uniqueid1:String,file_name1:String,file_size1:String,file_type1:String,type1:String
                                    
                                    print("send image chat filename \(file_name1)")
                                    let request=Alamofire.request("\(url)", method: .post, parameters: ["group_unique_id":groupid1,"from":from1,"type":type1,"msg":file_name1,"from_fullname":username!,"unique_id":uniqueid1],headers:header).responseJSON { response in
                                        
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
                                            var membersList=sqliteDB.getGroupMembersOfGroup(groupid1)
                                            for i in 0 ..< membersList.count
                                            {
                                                if((membersList[i]["member_phone"] as! String) != username! && (membersList[i]["membership_status"] as! String) != "left")
                                                {
                                                    sqliteDB.updateGroupChatStatus(uniqueid_chat, memberphone1: membersList[i]["member_phone"]! as! String, status1: "sent", delivereddate1: Date(), readDate1: Date())
                                                    
                                                    // === wrong sqliteDB.storeGRoupsChatStatus(uniqueid_chat, status1: "sent", memberphone1: self.membersList[i]["member_phone"]! as! String, delivereddate1: UtilityFunctions.init().minimumDate(), readDate1: UtilityFunctions.init().minimumDate())
                                                }
                                            }
                                           /* if(self.delegateProgressUpload != nil)
                                            {
                                                self.delegateProgressUpload.updateProgressUpload(1.0,uniqueid: uniqueid1)
                                                
                                            }*/
                                            
                                            
                                        }
                                        else{
                                            print("failed to send chat")
                                        }
                                        
                                        //send chat end
                                    }
                            
                            }
                        
                        case .failure: print("case failure upload encoding")
                            
                        }
                    }
                    
                    
                case .failure: print("file uploading encoding failed")
        
    }
        
        })
    }
    
    func uploadFile(_ filePath1:String,to1:String,from1:String, uniqueid1:String,file_name1:String,file_size1:String,file_type1:String,type1:String,label1:String){
        
        var parameters = [
            "to": to1,
            "from": from1,
            "uniqueid": uniqueid1,
            "filename": file_name1,
            "filesize": file_size1,
            "filetype": file_type1,
            "label":label1]
        
        
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
        
        var imageData:Data?
        if(self.imageExtensions.contains(file_type1.lowercased()))
        {
            imageData=UIImageJPEGRepresentation(UIImage(contentsOfFile: filePath1)!,0.9)
            print("new upload image size is \(imageData!.count)")
        }
            
        else{
            
            /*if(self.audioExtensions.contains(file_type1.lowercased()))
             {
             //imageData=UIImageJPEGRepresentation(UIImage(contentsOfFile: filePath1)!,0.9)
             print("audio file is uploading")
             //imageData=try? Data(contentsOf: URL(fileURLWithPath: filePath1))
             }else{*/
            imageData=try? Data(contentsOf: URL(fileURLWithPath: filePath1))
            print("old upload image size is \(imageData!.count)")
            var imageData2=imageData!.compressed(using: Compression.zlib)
            print("imageData2 is \(imageData2)")
            print("old upload image compressed size is \(imageData2!.count)")
            //}
        }
        // var imageData=UIImageJPEGRepresentation(UIImage(contentsOfFile: filePath1)!,0.9)
        
        // print("ols upload image size is \(imageData2!.length)")
        
        print("mimetype is \(MimeType(file_type1))")
        
        var urlupload=Constants.MainUrl+Constants.uploadFile
        
        
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                multipartFormData.append(imageData!, withName:  "file", fileName: file_name1, mimeType: self.MimeType(file_type1))                //,fileName: file_name1, mimeType: "image/\(file_type1)")
                for (key, value) in parameters {
                    multipartFormData.append(value.data(using: .utf8)!, withName: key)
                    // multipartFormData.append(data: value.data(using: String.Encoding.utf8)!, withName: key)
                }
                
        },
            to: urlupload,headers: header,
            encodingCompletion: { encodingResult in
                switch encodingResult {
                    
                    /*
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
                     */
                case .success(let upload, _, _):
                    
                    upload.validate()
                    upload.uploadProgress { progress in // main queue by default
                        print("Upload Progress: \(progress.fractionCompleted)")
                    }
                    upload.responseJSON { response in
                        print(response.response?.statusCode)
                        print(response.data!)
                        
                        switch response.result {
                        case .success:
                            
                            
                            var imParas=["from":from1,"to":to1,"fromFullName":"\(displayname)","msg":file_name1,"uniqueid":uniqueid1,"type":"file","file_type":type1]
                            print("imparas are \(imParas)")
                            
                            
                            var statusNow="pending"
                            
                            
                            
                            //------
                            
                            var url=Constants.MainUrl+Constants.sendChatURL
                            let request = Alamofire.request("\(url)", method: .post, parameters:  imParas,headers:header).responseJSON { response in
                                
                                
                                //alamofire4
                                //// let request = Alamofire.request(.POST, "\(url)", parameters: chatstanza,headers:header).responseJSON { response in
                                
                                
                                // You are now running on the concurrent `queue` you created earlier.
                                //print("Parsing JSON on thread: \(NSThread.currentThread()) is main thread: \(NSThread.isMainThread())")
                                
                                // Validate your JSON response and convert into model objects if necessary
                                //print(response.result.value) //status, uniqueid
                                
                                // To update anything on the main thread, just jump back on like so.
                                print("\(imParas) ..  \(response)")
                                if(response.response?.statusCode==200)
                                {
                                    //  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0))
                                    //{
                                    //print("chat ack received")
                                    // var statusNow="sent"
                                    
                                    
                                    
                                    
                                    //==-----
                                    ////////// var ackFile=socketObj.socket.emitWithAck("im",["room":"globalchatroom","stanza":imParas])
                                    
                                    /////// ackFile.timingOut(after: 150000, callback: { (data) in
                                    
                                    print("chat ack received  \(response.data!)")
                                    statusNow="sent"
                                    var chatmsg=JSON(response.data!)
                                    print("response.data! \(response.data!)")
                                    print("response.result.value \(response.result.value)")
                                    print("JSON chatmsg \(chatmsg)")
                                    print("JSON response.result.value \(JSON(response.result.value!))")
                                    // print(chatmsg[0])
                                    // sqliteDB.UpdateChatStatus(chatmsg[0]["uniqueid"].string!, newstatus: chatmsg[0]["status"].string!)
                                    sqliteDB.UpdateChatStatus(chatmsg["uniqueid"].string!, newstatus: chatmsg["status"].string!)
                                    
                                    DispatchQueue.main.async() {
                                        if(UIDelegates.getInstance().delegateSingleChatDetails1 != nil)
                                        {
                                            UIDelegates.getInstance().UpdateSingleChatDetailDelegateCall()
                                        }
                                        if(delegateRefreshChat != nil)
                                        {print("updating UI now ...")
                                            delegateRefreshChat?.refreshChatsUI(nil, uniqueid:nil, from:nil, date1:nil, type:"status")
                                        }
                                        
                                        if(socketObj.delegateChat != nil)
                                        {
                                            socketObj.delegateChat?.socketReceivedMessageChat("updateUI", data: nil)
                                        }
                                        /* if(self.delegate != nil)
                                         {
                                         self.delegate?.socketReceivedMessage("updateUI", data: nil)
                                         }*/
                                        ///////// }
                                        
                                    }
                                    //^^^self.retrieveChatFromSqlite(self.selectedContact)
                                    //self.tblForChats.reloadData()
                                    ////////   })
                                    
                                    
                                    /*if(self.delegateChat != nil)
                                     {
                                     self.delegateChat?.socketReceivedMessageChat("updateUI", data: nil)
                                     }
                                     if(self.delegate != nil)
                                     {
                                     self.delegate?.socketReceivedMessage("updateUI", data: nil)
                                     }
                                     */
                                    
                                    if(self.delegateProgressUpload != nil)
                                    {
                                        self.delegateProgressUpload.updateProgressUpload(1.0,uniqueid: uniqueid1)
                                        
                                    }
                                    
                                    //debugPrint(response)
                                    print("file upload success")
                                    print(response.result.value)
                                    print(JSON(response.result.value!)) // "status":"success"
                                }
                                    // case .failure(let error):
                                else{
                                    print("file upload failure")
                                }
                                
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
                        case .failure: print("case failure upload encoding")
                            
                        }
                    }
                    
                    
                case .failure: print("case failure in encoding")
                    
                }
        })
    }
    
    
    func uploadBroadcastFile(_ filePath1:String,to1:[String],from1:String, uniqueid1:String,file_name1:String,file_size1:String,file_type1:String,type1:String,totalmembers:String){
        
        var parameters:JSON = [
            "to": to1,
            "from": from1,
            "uniqueid": uniqueid1,
            "total_members":totalmembers,
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
        
        var imageData:Data?
        if(self.imageExtensions.contains(file_type1.lowercased()))
        {
            imageData=UIImageJPEGRepresentation(UIImage(contentsOfFile: filePath1)!,0.9)
            print("new upload image size is \(imageData!.count)")
        }
            
        else{
            
            /*if(self.audioExtensions.contains(file_type1.lowercased()))
            {
                //imageData=UIImageJPEGRepresentation(UIImage(contentsOfFile: filePath1)!,0.9)
                print("audio file is uploading")
                //imageData=try? Data(contentsOf: URL(fileURLWithPath: filePath1))
            }else{*/
            imageData=try? Data(contentsOf: URL(fileURLWithPath: filePath1))
             print("old upload image size is \(imageData!.count)")
            var imageData2=imageData!.compressed(using: Compression.zlib)
            print("imageData2 is \(imageData2)")
            print("old upload image compressed size is \(imageData2!.count)")
            //}
        }
       // var imageData=UIImageJPEGRepresentation(UIImage(contentsOfFile: filePath1)!,0.9)
       
       // print("ols upload image size is \(imageData2!.length)")
        
        print("mimetype is \(MimeType(file_type1))")
        
        var urlupload=Constants.MainUrl+Constants.uploadFileBroadcast
    
        
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                multipartFormData.append(imageData!, withName:  "file", fileName: file_name1, mimeType: self.MimeType(file_type1))                //,fileName: file_name1, mimeType: "image/\(file_type1)")
                for (key, value) in parameters {
                    multipartFormData.append(Data.init((value as AnyObject).description.data(using: String.Encoding.utf8)!), withName: key)
                   // multipartFormData.append(data: value.data(using: String.Encoding.utf8)!, withName: key)
                }

        },
            to: urlupload,headers: header,
            encodingCompletion: { encodingResult in
                switch encodingResult {
                    
           /*
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
                    */
        case .success(let upload, _, _):
          
            upload.validate()
            upload.uploadProgress { progress in // main queue by default
                print("Upload Progress: \(progress.fractionCompleted)")
            }
            upload.responseJSON { response in
                print(response.response?.statusCode)
                print(response.data!)
                
                switch response.result {
                case .success:
                    
                    
                    //var imParas=["from":from1,"to":to1,"fromFullName":"\(displayname)","msg":file_name1,"uniqueid":uniqueid1,"type":"file","file_type":type1] as [String : Any]
                    
                    var imParas:[String:AnyObject]=["from":username! as AnyObject,"to":to1 as AnyObject,"fromFullName":displayname as AnyObject,"msg":file_name1 as AnyObject,"uniqueid":uniqueid1 as AnyObject,"type":"broadcast_file" as AnyObject,"file_type":type1 as AnyObject]
                    
                    print("imparas are \(imParas)")
                    
                    var statusNow="pending"
                 
                    
                    
                    //------
                  
                     var url=Constants.MainUrl+Constants.sendbroadcastmessage
                    let request = Alamofire.request("\(url)", method: .post, parameters: imParas,encoding:JSONEncoding.default,headers:header).response { response in
                        
                        
                        //alamofire4
                        //// let request = Alamofire.request(.POST, "\(url)", parameters: chatstanza,headers:header).responseJSON { response in
                        
                        
                        // You are now running on the concurrent `queue` you created earlier.
                        //print("Parsing JSON on thread: \(NSThread.currentThread()) is main thread: \(NSThread.isMainThread())")
                        
                        // Validate your JSON response and convert into model objects if necessary
                        //print(response.result.value) //status, uniqueid
                        
                        // To update anything on the main thread, just jump back on like so.
                        print("\(imParas) ..  \(response)")
                        if(response.response?.statusCode==200)
                        {
                            //  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0))
                            //{
                            //print("chat ack received")
                           // var statusNow="sent"
                            
                            
                            
                            
                            //==-----
                   ////////// var ackFile=socketObj.socket.emitWithAck("im",["room":"globalchatroom","stanza":imParas])
                    
                   /////// ackFile.timingOut(after: 150000, callback: { (data) in
                        
                        print("chat ack received  \(response.data!)")
                        statusNow="sent"
                        var chatmsg=JSON(response.data!)
                        print("response.data! \(response.data!)")
                            //print("response.result.value \(response. result.value)")
                            print("JSON chatmsg \(chatmsg)")
                            //print("JSON response.result.value \(JSON(response.result.value!))")
                       // print(chatmsg[0])
                       // sqliteDB.UpdateChatStatus(chatmsg[0]["uniqueid"].string!, newstatus: chatmsg[0]["status"].string!)
                            sqliteDB.UpdateChatStatus(chatmsg["uniqueid"].string!, newstatus: chatmsg["status"].string!)
                            
                        DispatchQueue.main.async() {
                            if(UIDelegates.getInstance().delegateSingleChatDetails1 != nil)
                            {
                                UIDelegates.getInstance().UpdateSingleChatDetailDelegateCall()
                            }
                            if(delegateRefreshChat != nil)
                            {print("updating UI now ...")
                                delegateRefreshChat?.refreshChatsUI(nil, uniqueid:nil, from:nil, date1:nil, type:"status")
                            }
                            
                            if(socketObj.delegateChat != nil)
                            {
                                socketObj.delegateChat?.socketReceivedMessageChat("updateUI", data: nil)
                            }
                           /* if(self.delegate != nil)
                            {
                                self.delegate?.socketReceivedMessage("updateUI", data: nil)
                            }*/
                            ///////// }
                            
                        }
                        //^^^self.retrieveChatFromSqlite(self.selectedContact)
                        //self.tblForChats.reloadData()
                 ////////   })
                    
                    
                    /*if(self.delegateChat != nil)
                    {
                        self.delegateChat?.socketReceivedMessageChat("updateUI", data: nil)
                    }
                    if(self.delegate != nil)
                    {
                        self.delegate?.socketReceivedMessage("updateUI", data: nil)
                    }
                    */
                    
                    if(self.delegateProgressUpload != nil)
                    {
                        self.delegateProgressUpload.updateProgressUpload(1.0,uniqueid: uniqueid1)
                        
                    }
                    
                    //debugPrint(response)
                    print("file upload success")
                   // print(response.result.value)
                   // print(JSON(response.result.value!)) // "status":"success"
                        }
               // case .failure(let error):
                        else{
                    print("file upload failure")
                        }
                
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
                case .failure: print("case failure upload encoding")
                
                }
                    }
               
                
                case .failure: print("case failure in encoding")
                    
        }
        })
        }
        
        
    
    func checkPendingFilesInGroup(_ uniqueid1:String)
    {print("inside checkpending")
        var checkPendingFiles=Constants.MainUrl+Constants.checkPendingFileGroupChatURL
        
        
        Alamofire.request("\(checkPendingFiles)", method: .post, parameters: ["uniqueid":uniqueid1],headers:header).validate(statusCode: 200..<300).responseJSON{
            
            response in
            
            
            /*
             Alamofire.request(.POST,"\(checkPendingFiles)",headers:header,parameters: ["uniqueid":uniqueid1]).validate(statusCode: 200..<300).responseJSON{
             
             response in*/
            
            ////// print(response.data!)
            
            switch response.result {
            case .success:
                
                //debugPrint(response)
                print("checking pending files success")
                ///////print(response.result.value)
                if(response.result.value != nil)
                {print(JSON(response.result.value!)) // "status":"success"
                    var jsonResult=JSON(response.result.value!)
                    //print("count jsonresult is \(jsonResult.count)")
                    // print("count jsonresult zeroth is \(jsonResult[0].count)")
                    print("count jsonresult filepending \(jsonResult["filepending"].count)")
                    
                    if(jsonResult["filepending"].count>0)
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
                            
                            
                            ////var filetype=jsonResult["filepending"]["file_type"].string!
                            var filePendingSize="\(jsonResult["filepending"]["file_size"])"
                            var filependingDate=jsonResult["filepending"]["date"].string!
                            //var filePendingTo=jsonResult["filepending"]["to"].string!
                            var filePendingTo=jsonResult["filepending"]["group_unique_id"].string!
                            
                            //  self.downloadFile("\(jsonResult["filepending"]["uniqueid"])")
                            
                            var filetype=jsonResult["filepending"]["file_type"].string!
                            var filecaption=""
                            if(jsonResult["filepending"]["label"] != nil)
                            {
                            filecaption=jsonResult["filepending"]["label"].string!
                            }
                            self.downloadFileInGroup(fileuniqueid,filePendingName: filePendingName,filefrom: filefrom,filetype: filetype,filePendingSize: filePendingSize,filependingDate: filependingDate,filePendingTo: filePendingTo,filecaption: filecaption)
                        }
                        //}
                        
                        //}
                        
                    }
                }
                else{
                    print("no pending files found")
                }
                
            case .failure(let error):
                print("\(error) file check pending failed")
            }
        }
        
    }
    
    
    func checkPendingFilesBroadcasr(_ uniqueid1:String)
    {print("inside checkpending")
        var checkPendingFiles=Constants.MainUrl+Constants.checkPendingFilesBroadcast
        
        
        Alamofire.request("\(checkPendingFiles)", method: .post, parameters: ["uniqueid":uniqueid1],headers:header).validate(statusCode: 200..<300).responseJSON{
            
            response in
            
            
            switch response.result {
            case .success:
                
                //debugPrint(response)
                print("checking pending files success")
                ///////print(response.result.value)
                if(response.result.value != nil)
                {print(JSON(response.result.value!)) // "status":"success"
                    var jsonResult=JSON(response.result.value!)
                    //print("count jsonresult is \(jsonResult.count)")
                    // print("count jsonresult zeroth is \(jsonResult[0].count)")
                    print("count jsonresult filepending \(jsonResult["filepending"].count)")
                    
                    if(jsonResult["filepending"].count>0)
                    {
                        print("downloading file with id \(jsonResult["filepending"]["uniqueid"])")
                        print("downloading file from \(jsonResult["filepending"]["from"])")
                        if(jsonResult["filepending"]["from"] != nil)
                        {
                            print("downloading file with id \(jsonResult["filepending"]["uniqueid"])")
                            
                            /*
                             "filepending" : {
                             "from" : "+923333864540",
                             "uniqueid" : "PhYUgbp2017569504",
                             "_id" : "590d560143bfa19d46a28474",
                             "__v" : 0,
                             "file_type" : "PNG",
                             "members_downloaded" : 0,
                             "file_size" : 0,
                             "file_name" : "IMG_0109.PNG",
                             "date" : "2017-05-06T04:50:09.341Z",
                             "total_members" : 1,
                             "path" : "\/fb442acab6d2017560509.png"
                             }
                             */
                            var fileuniqueid=jsonResult["filepending"]["uniqueid"].string!
                            var filePendingName=jsonResult["filepending"]["file_name"].string!
                            var filefrom=jsonResult["filepending"]["from"].string!
                            var filetype=jsonResult["filepending"]["file_type"].string!
                            var filePendingSize="\(jsonResult["filepending"]["file_size"])"
                            var filependingDate=jsonResult["filepending"]["date"].string!
                            
                            
                            var filecaption=""
                            if(jsonResult["filepending"]["label"] != nil)
                            {
                             filecaption=jsonResult["filepending"]["label"].string!
                            }
                            //var filePendingTo=jsonResult["filepending"]["to"].string!
                            
                            //  self.downloadFile("\(jsonResult["filepending"]["uniqueid"])")
                            self.downloadBroadcastFile(fileuniqueid,filePendingName: filePendingName,filefrom: filefrom,filetype: filetype,filePendingSize: filePendingSize,filependingDate: filependingDate,filePendingTo: username!,filecaption: filecaption)
                        }
                        //}
                        
                        //}
                        
                    }
                }
                else{
                    print("no pending files found")
                }
                
            case .failure(let error):
                print("\(error) file check pending failed")
            }
                   }
    }
    
    
    func checkPendingFiles(_ uniqueid1:String)
    {print("inside checkpending")
        var checkPendingFiles=Constants.MainUrl+Constants.checkPendingFile
        
      
        Alamofire.request("\(checkPendingFiles)", method: .post, parameters: ["uniqueid":uniqueid1],headers:header).validate(statusCode: 200..<300).responseJSON{
            
            response in
            

        /*
        Alamofire.request(.POST,"\(checkPendingFiles)",headers:header,parameters: ["uniqueid":uniqueid1]).validate(statusCode: 200..<300).responseJSON{
            
        response in*/
            
           ////// print(response.data!)
            
            switch response.result {
            case .success:
                
                //debugPrint(response)
                print("checking pending files success")
                ///////print(response.result.value)
                if(response.result.value != nil)
                {print(JSON(response.result.value!)) // "status":"success"
                    var jsonResult=JSON(response.result.value!)
                    //print("count jsonresult is \(jsonResult.count)")
                   // print("count jsonresult zeroth is \(jsonResult[0].count)")
                    print("count jsonresult filepending \(jsonResult["filepending"].count)")

                    if(jsonResult["filepending"].count>0)
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
                            
                            var caption=""
                            if(jsonResult["filepending"]["label"] != nil)
                            {
                             caption=jsonResult["filepending"]["label"].string!
                            }
                              //  self.downloadFile("\(jsonResult["filepending"]["uniqueid"])")
                             self.downloadFile(fileuniqueid,filePendingName: filePendingName,filefrom: filefrom,filetype: filetype,filePendingSize: filePendingSize,filependingDate: filependingDate,filePendingTo: filePendingTo,filecaption: caption)
                        }
                            //}
                            
                        //}
                   
                    }
                }
                else{
                    print("no pending files found")
                }
            
            case .failure(let error):
                print("\(error) file check pending failed")
            }
            //request1, response1, data1, error1 in
            
            //===========INITIALISE SOCKETIOCLIENT=========
            // dispatch_async(dispatch_get_main_queue(), {
            
            //self.dismiss(true, completion: nil);
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
    
    
    func downloadFileInGroup(_ fileuniqueid:String,filePendingName:String,filefrom:String,filetype:String,filePendingSize:String,filependingDate:String,filePendingTo:String,filecaption:String)
    {
        print("inside download file function uniqueid \(fileuniqueid) and filetype is \(filetype) filePendingSize is \(filePendingSize)")
        
        var downloadURL=Constants.MainUrl+Constants.downloadInGroupChatURL
        print("start download")
        print(Date())
        

        
        let path = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0] as URL
        //print("path download is \(path)")
        //////// let newPath = path.URLByAppendingPathComponent(fileName1)
        /////// print("full path download file is \(newPath)")
        //////  let destination = Alamofire.Request.suggestedDownloadDestination(directory: .DocumentDirectory, domain: .UserDomainMask)
        //  print("path download is \(destination.lowercaseString)")
        //  Alamofire.download(.GET, "http://httpbin.org/stream/100", destination: destination)
        // var downloadURL=Constants.MainUrl+Constants.downloadFile
        
        
        
        let destination1: DownloadRequest.DownloadFileDestination = { _, _ in
            var documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            var localImageURL = documentsURL.appendingPathComponent(filePendingName)
            return (localImageURL, [.removePreviousFile])
        }
        
        
        /// let destination = DownloadRequest.suggestedDownloadDestination(for: .documentDirectory, in: .userDomainMask) as? URL
        
        
        let destination: (URL, HTTPURLResponse) -> (URL) = {
            (temporaryURL, response) in
            
            if let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0] as? URL {
                //// var localImageURL = directoryURL.URLByAppendingPathComponent("\(response.suggestedFilename!)")
                //filenamePending
                print("filePendingName is \(filePendingName)")
                var localImageURL = directoryURL.appendingPathComponent(filePendingName)
                print("response.suggestedFilename! is \(response.suggestedFilename!)")
                let checkValidation = FileManager.default
                
                if (checkValidation.fileExists(atPath: "\(localImageURL)"))
                {
                    print("FILE AVAILABLE")
                }
                else
                {
                    print("FILE NOT AVAILABLE")
                }
                
                
                print("localpathhhhhh \(localImageURL.debugDescription)")
                return localImageURL
            }
            print("tempurl is \(temporaryURL.debugDescription)")
            return temporaryURL
        }
        
        
        print("downloading call unique id \(fileuniqueid)")
        
        //uncomment change later
        Alamofire.download("\(downloadURL)", method: .post, parameters: ["uniqueid":fileuniqueid], encoding: JSONEncoding.default, headers: header, to: destination1).response { (response) in
            
            print(response)
            print("1...... \(response.request?.url)")
            //print("2..... \(response.request?. .URL.debugDescription)")
            //print("3.... \(response.response?.URL.debugDescription)")
            
            
            let dirPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
            let docsDir1 = dirPaths[0]
            var documentDir=docsDir1 as NSString
            var filePendingPath=documentDir.appendingPathComponent(filePendingName)
            
           /* if(self.imageExtensions.contains(filetype.lowercased()))
            {
                //filePendingName
                sqliteDB.saveFile(filePendingTo, from1: filefrom, owneruser1: username!, file_name1: filePendingName, date1: nil, uniqueid1: fileuniqueid, file_size1: filePendingSize, file_type1: filetype, file_path1: filePendingPath, type1: "image")
            }
            else
            {
                sqliteDB.saveFile(filePendingTo, from1: filefrom, owneruser1: username!, file_name1: filePendingName, date1: nil, uniqueid1: fileuniqueid, file_size1: filePendingSize, file_type1: filetype, file_path1: filePendingPath, type1: "document")
                
            }*/
            
            sqliteDB.saveFile(filePendingTo, from1: filefrom, owneruser1: username!, file_name1: filePendingName, date1: nil, uniqueid1: fileuniqueid, file_size1: filePendingSize, file_type1: filetype, file_path1: filePendingPath, type1: filetype,caption1:filecaption)
            
           /* if(socketObj.delegateChat != nil)
            {
                socketObj.delegateChat.socketReceivedMessageChat("updateUI", data: nil)
            }
            */
            
            //===
            //refresh UI file download commented==--- uncomment later ====================================----------
            /*
             if(delegateRefreshChat != nil)
             {
             delegateRefreshChat?.refreshChatsUI("",uniqueid:fileuniqueid,from:filefrom,date1:NSDate(), type:"file")
             
             //===uncomment later  delegateRefreshChat?.refreshChatsUI("",uniqueid:fileuniqueid,from:filefrom,date1:NSDate(), type:"chat")
             }*/
            
            
            
            
            
            //filedownloaded’ to with parameters ‘senderoffile’, ‘receiveroffile’
            
            print("download done long")
            print(NSDate())
            self.confirmDownloadInGroup(fileuniqueid)
            print("confirminggggggg")
            
            // print(request?.)
            
        }
        
        //// }
    }
    
    func confirmDownloadInGroup(_ uniqueid1:String)
    {print("confirmDownloadInGroup \(uniqueid1)")
        let confirmURL=Constants.MainUrl+Constants.confirmDownloadInGroupChatURL
        
        let request = Alamofire.request("\(confirmURL)", method: .post, parameters: ["uniqueid":uniqueid1],headers:header).responseJSON { response in
            
            //  Alamofire.request(.POST,"\(confirmURL)",headers:header,parameters:["uniqueid":uniqueid1]).validate(statusCode: 200..<300).responseJSON{response in
            
            
            switch response.result {
            case .success:
                print("download confirm sent \(uniqueid1)")
                
            case .failure(let error):
                print("confirmation download failed")
            }}
    }
    
    
    //downloadBroadcastFile
    func downloadFile(_ fileuniqueid:String,filePendingName:String,filefrom:String,filetype:String,filePendingSize:String,filependingDate:String,filePendingTo:String,filecaption:String)
    {
        print("inside download file function uniqueid \(fileuniqueid) and filetype is \(filetype) filePendingSize is \(filePendingSize)")
        
        var downloadURL=Constants.MainUrl+Constants.downloadFile
        print("start download")
        print(Date())
        
  
        
        let path = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0] as URL

        
        let destination1: DownloadRequest.DownloadFileDestination = { _, _ in
            var documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            var localImageURL = documentsURL.appendingPathComponent(filePendingName)
            return (localImageURL, [.removePreviousFile])
        }
        
        
        /// let destination = DownloadRequest.suggestedDownloadDestination(for: .documentDirectory, in: .userDomainMask) as? URL
        
        
        let destination: (URL, HTTPURLResponse) -> (URL) = {
            (temporaryURL, response) in
            
            if let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0] as? URL {
                //// var localImageURL = directoryURL.URLByAppendingPathComponent("\(response.suggestedFilename!)")
                //filenamePending
                print("filePendingName is \(filePendingName)")
                var localImageURL = directoryURL.appendingPathComponent(filePendingName)
                print("response.suggestedFilename! is \(response.suggestedFilename!)")
                let checkValidation = FileManager.default
                
                if (checkValidation.fileExists(atPath: "\(localImageURL)"))
                {
                    print("FILE AVAILABLE")
                }
                else
                {
                    print("FILE NOT AVAILABLE")
                }
                
                
                print("localpathhhhhh \(localImageURL.debugDescription)")
                return localImageURL
            }
            print("tempurl is \(temporaryURL.debugDescription)")
            return temporaryURL
        }
        
        
        print("downloading call unique id \(fileuniqueid)")
        
        //uncomment change later
        Alamofire.download("\(downloadURL)", method: .post, parameters: ["uniqueid":fileuniqueid], encoding: JSONEncoding.default, headers: header, to: destination1).downloadProgress { progress in
            print("Download Progress: \(progress.fractionCompleted)")
            
            if(self.delegateProgressUpload != nil)
            {self.delegateProgressUpload.updateProgressUpload(Float(progress.fractionCompleted), uniqueid: fileuniqueid)
            }
            }.response { (response) in
            
            print(response)
            print("1...... \(response.request?.url)")
            //print("2..... \(response.request?. .URL.debugDescription)")
            //print("3.... \(response.response?.URL.debugDescription)")
            
            
            let dirPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
            let docsDir1 = dirPaths[0]
            var documentDir=docsDir1 as NSString
            var filePendingPath=documentDir.appendingPathComponent(filePendingName)
            
            if(self.imageExtensions.contains(filetype.lowercased()))
            {
                //filePendingName
                sqliteDB.saveFile(filePendingTo, from1: filefrom, owneruser1: username!, file_name1: filePendingName, date1: nil, uniqueid1: fileuniqueid, file_size1: filePendingSize, file_type1: filetype, file_path1: filePendingPath, type1: "image",caption1: filecaption)
            }
            else
            {
                sqliteDB.saveFile(filePendingTo, from1: filefrom, owneruser1: username!, file_name1: filePendingName, date1: nil, uniqueid1: fileuniqueid, file_size1: filePendingSize, file_type1: filetype, file_path1: filePendingPath, type1: "document",caption1:"")
                
            }
            
                /*if(socketObj.delegateChat != nil)
            {
                socketObj.delegateChat.socketReceivedMessageChat("updateUI", data: nil)
            }
            */
                if(self.delegateProgressUpload != nil)
                    
                {self.delegateProgressUpload.updateProgressUpload(Float(1.0), uniqueid: fileuniqueid)
                }
                
            //===
            //refresh UI file download commented==--- uncomment later ====================================----------
            /*
             if(delegateRefreshChat != nil)
             {
             delegateRefreshChat?.refreshChatsUI("",uniqueid:fileuniqueid,from:filefrom,date1:NSDate(), type:"file")
             
             //===uncomment later  delegateRefreshChat?.refreshChatsUI("",uniqueid:fileuniqueid,from:filefrom,date1:NSDate(), type:"chat")
             }*/
            
            
            
                if(self.delegateProgressUpload != nil)
                    
                {self.delegateProgressUpload.updateProgressUpload(Float(1.0), uniqueid: fileuniqueid)
                }
            
            //filedownloaded’ to with parameters ‘senderoffile’, ‘receiveroffile’
            
            print("download done long")
            print(NSDate())
            self.confirmDownload(fileuniqueid)
            print("confirminggggggg")
            
            // print(request?.)
            
        }
        
        //// }
    }
    
    func confirmDownloadBroadcast(_ uniqueid1:String)
    {
        let confirmURL=Constants.MainUrl+Constants.confirmDownloadBroadcast
        
        let request = Alamofire.request("\(confirmURL)", method: .post, parameters: ["uniqueid":uniqueid1],headers:header).responseJSON { response in
            
            //  Alamofire.request(.POST,"\(confirmURL)",headers:header,parameters:["uniqueid":uniqueid1]).validate(statusCode: 200..<300).responseJSON{response in
            
            
            switch response.result {
            case .success:
                print("download confirm sent \(uniqueid1)")
                
            case .failure(let error):
                print("confirmation download failed")
            }}
    }

    
    
    /////////
    
    func downloadBroadcastFile(_ fileuniqueid:String,filePendingName:String,filefrom:String,filetype:String,filePendingSize:String,filependingDate:String,filePendingTo:String,filecaption:String)
    {
        print("inside download file function uniqueid \(fileuniqueid) and filetype is \(filetype) filePendingSize is \(filePendingSize)")
        
        var downloadURL=Constants.MainUrl+Constants.downloadFileBroadcast
        print("start download")
        print(Date())
        
        
        let path = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0] as URL
        //print("path download is \(path)")
       //////// let newPath = path.URLByAppendingPathComponent(fileName1)
       /////// print("full path download file is \(newPath)")
      //////  let destination = Alamofire.Request.suggestedDownloadDestination(directory: .DocumentDirectory, domain: .UserDomainMask)
              //  print("path download is \(destination.lowercaseString)")
      //  Alamofire.download(.GET, "http://httpbin.org/stream/100", destination: destination)
       // var downloadURL=Constants.MainUrl+Constants.downloadFile
        
            
            
            let destination1: DownloadRequest.DownloadFileDestination = { _, _ in
                var documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                var localImageURL = documentsURL.appendingPathComponent(filePendingName)
                return (localImageURL, [.removePreviousFile])
            }
            
            
           /// let destination = DownloadRequest.suggestedDownloadDestination(for: .documentDirectory, in: .userDomainMask) as? URL
            
       
            let destination: (URL, HTTPURLResponse) -> (URL) = {
            (temporaryURL, response) in
            
            if let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0] as? URL {
               //// var localImageURL = directoryURL.URLByAppendingPathComponent("\(response.suggestedFilename!)")
                //filenamePending
                print("filePendingName is \(filePendingName)")
                var localImageURL = directoryURL.appendingPathComponent(filePendingName)
                print("response.suggestedFilename! is \(response.suggestedFilename!)")
                let checkValidation = FileManager.default
                
                if (checkValidation.fileExists(atPath: "\(localImageURL)"))
                {
                    print("FILE AVAILABLE")
                }
                else
                {
                    print("FILE NOT AVAILABLE")
                }
                
                
                print("localpathhhhhh \(localImageURL.debugDescription)")
                return localImageURL
            }
            print("tempurl is \(temporaryURL.debugDescription)")
            return temporaryURL
        }

        
        print("downloading call unique id \(fileuniqueid)")
       
        //uncomment change later
            Alamofire.download("\(downloadURL)", method: .post, parameters: ["uniqueid":fileuniqueid], encoding: JSONEncoding.default, headers: header, to: destination1).response { (response) in
                
                print(response)
                print("1...... \(response.request?.url)")
                //print("2..... \(response.request?. .URL.debugDescription)")
                //print("3.... \(response.response?.URL.debugDescription)")
                
                
                let dirPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
                let docsDir1 = dirPaths[0]
                var documentDir=docsDir1 as NSString
                var filePendingPath=documentDir.appendingPathComponent(filePendingName)
                
                if(self.imageExtensions.contains(filetype.lowercased()))
                {
                //filePendingName
                    sqliteDB.saveFile(filePendingTo, from1: filefrom, owneruser1: username!, file_name1: filePendingName, date1: nil, uniqueid1: fileuniqueid, file_size1: filePendingSize, file_type1: filetype, file_path1: filePendingPath, type1: "image",caption1:filecaption)
                }
                else
                {
                    sqliteDB.saveFile(filePendingTo, from1: filefrom, owneruser1: username!, file_name1: filePendingName, date1: nil, uniqueid1: fileuniqueid, file_size1: filePendingSize, file_type1: filetype, file_path1: filePendingPath, type1: "document",caption1:"")
                    
                }
                if(socketObj.delegateChat != nil)
                {
                    socketObj.delegateChat.socketReceivedMessageChat("updateUI", data: nil)
                }
                
                
                //===
                //refresh UI file download commented==--- uncomment later ====================================----------
                /*
                if(delegateRefreshChat != nil)
                {
                    delegateRefreshChat?.refreshChatsUI("",uniqueid:fileuniqueid,from:filefrom,date1:NSDate(), type:"file")
                    
                   //===uncomment later  delegateRefreshChat?.refreshChatsUI("",uniqueid:fileuniqueid,from:filefrom,date1:NSDate(), type:"chat")
                }*/
                
                
                
                
                
                //filedownloaded’ to with parameters ‘senderoffile’, ‘receiveroffile’
                
                print("download done long")
                print(NSDate())
                self.confirmDownloadBroadcast(fileuniqueid)
                print("confirminggggggg")
                
               // print(request?.)
                
        }
        
       //// }
    }
    
    func confirmDownload(_ uniqueid1:String)
    {
        let confirmURL=Constants.MainUrl+Constants.confirmDownload
        
         let request = Alamofire.request("\(confirmURL)", method: .post, parameters: ["uniqueid":uniqueid1],headers:header).responseJSON { response in
            
      //  Alamofire.request(.POST,"\(confirmURL)",headers:header,parameters:["uniqueid":uniqueid1]).validate(statusCode: 200..<300).responseJSON{response in
            
            
            switch response.result {
            case .success:
                print("download confirm sent \(uniqueid1)")
                
            case .failure(let error):
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
    
    func uploadProfileImage(_ groupUniqueID:String,filePath1:String,filename:String,fileType:String,completion:(_ result:Bool,_ error:String?)->())
    {
        var url=Constants.MainUrl+Constants.uploadProfileImage
        var parameters:[String:String] = [
            "unique_id": groupUniqueID]
        
        
        //// Alamofire.request(.POST,"\(url)",parameters:["unique_id":uniqueid],headers:header,encoding:.JSON).validate().responseJSON { response in
        
        var imageData=try? Data(contentsOf: URL(fileURLWithPath: filePath1))
        
        // var urlupload=Constants.MainUrl+Constants.uploadFile
        print("uploading file image data is \(imageData)")
        
        
        
        
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                multipartFormData.append(imageData!, withName:  "file", fileName: filename, mimeType: ".\(fileType)")                //,fileName: file_name1, mimeType: "image/\(file_type1)")
                for (key, value) in parameters {
                    multipartFormData.append(value.data(using: .utf8)!, withName: key)
                    // multipartFormData.append(data: value.data(using: String.Encoding.utf8)!, withName: key)
                }
                
        },
            to: url,headers: header,
            encodingCompletion: { encodingResult in
                switch encodingResult {
                    

                    
                case .success(let upload, _, _):
                    
                    upload.validate()
                    upload.uploadProgress { progress in // main queue by default
                        print("Upload Progress: \(progress.fractionCompleted)")
                    }
                    upload.responseJSON { response in
                        print(response.response?.statusCode)
                        print(response.data!)
                        
                        switch response.result {
                        case .success:
                            
                            
                            print("file uploaded successss")
                            var iconExists=sqliteDB.checkIfFileExists(groupUniqueID)
                            if(iconExists==true)
                            {
                                sqliteDB.updateFileInfo(groupUniqueID, from1: "", owneruser1: "", file_name1: filename, date1: nil, uniqueid1: groupUniqueID, file_size1: "1", file_type1: fileType, file_path1: filePath1, type1: "groupIcon", caption1:"")
                            }
                            else{
                                sqliteDB.saveFile(groupUniqueID, from1: "", owneruser1: "", file_name1: filename, date1: nil, uniqueid1: groupUniqueID, file_size1: "1", file_type1: fileType, file_path1: filePath1, type1: "groupIcon",caption1:"")
                            }
                            
                            sqliteDB.storeGroupsChat("Log:", group_unique_id1: groupUniqueID, type1: "log", msg1: "You changed this group's icon", from_fullname1: displayname, date1: Date(), unique_id1: groupUniqueID)
                            
                            
                           //  sqliteDB.saveFile(groupUniqueID, from1: "", owneruser1: "", file_name1: filename, date1: nil, uniqueid1: groupUniqueID, file_size1: "1", file_type1: fileType, file_path1: filePath1, type1: "groupIcon")
                           //update "group_icon" as exists
                            
                        case .failure(let error):
                            print("file upload failure \(error)")
                        }
                        
                        
                        
                        print("Add profile pic called")
                        if(response.result.isSuccess)
                        {
                            print("success uploading image profile")
                        }
                        
                        
                    }
                case .failure(let error):
                    print("file upload failure")
                }})
        
        
    }
    
    func sendDayStatusSeenUpdate(uniqueid:String,time:String,uploadedBy:String)
    {
        var url=Constants.MainUrl+Constants.sendDayStatusUpdate
        let request = Alamofire.request("\(url)", method: .post, parameters: ["uniqueid":uniqueid,"time":time,"uploadedBy":uploadedBy],headers:header).responseJSON { response in
            
            //  Alamofire.request(.POST,"\(confirmURL)",headers:header,parameters:["uniqueid":uniqueid1]).validate(statusCode: 200..<300).responseJSON{response in
            
            
            switch response.result {
            case .success:
                print("daystatus update sent \(uniqueid)")
                
            case .failure(let error):
                print("daystatus update failed")
            }}

        
    }
    
    func checkDayStatusMetaData(uniqueid1:String)
    {
        print("inside checkDayStatusMetaData")
        var checkPendingFiles=Constants.MainUrl+Constants.daystatusGetMetaData
        
        
        Alamofire.request("\(checkPendingFiles)", method: .post, parameters: ["uniqueid":uniqueid1],headers:header).validate(statusCode: 200..<300).responseJSON{
            
            response in
            
            
            /*
             Alamofire.request(.POST,"\(checkPendingFiles)",headers:header,parameters: ["uniqueid":uniqueid1]).validate(statusCode: 200..<300).responseJSON{
             
             response in*/
            
            ////// print(response.data!)
            
            switch response.result {
            case .success:
                
                //debugPrint(response)
                print("checking pending day status success")
                ///////print(response.result.value)
                if(response.result.value != nil)
                {print(JSON(response.result.value!)) // "status":"success"
                    var jsonResult=JSON(response.result.value!)
                    //print("count jsonresult is \(jsonResult.count)")
                    // print("count jsonresult zeroth is \(jsonResult[0].count)")
                    print("count jsonresult day status \(jsonResult["data"].count)")
                    
                    if(jsonResult["data"].count>0)
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
                        print("downloading day status with id \(jsonResult["data"]["uniqueid"])")
                        print("downloading day status from \(jsonResult["data"]["uploadedBy"])")
                        if(jsonResult["data"]["uploadedBy"] != nil)
                        {
                            print("downloading day status with id \(jsonResult["data"]["uniqueid"])")
                            
                            var fileuniqueid=jsonResult["data"]["uniqueid"].string!
                            var filePendingName=jsonResult["data"]["file_name"].string!
                            var filefrom=jsonResult["data"]["uploadedBy"].string!
                            var filetype=jsonResult["data"]["file_type"].string!
                            var filePendingSize="\(jsonResult["data"]["file_size"])"
                            var filependingDate=jsonResult["data"]["date"].string!
                            //var filePendingTo=jsonResult["filepending"]["to"].string!
                            
                            var caption=""
                            if(jsonResult["data"]["label"] != nil)
                            {
                                caption=jsonResult["data"]["label"].string!
                            }
                            //  self.downloadFile("\(jsonResult["filepending"]["uniqueid"])")
                          
                            
                            self.downloadDayStatus(uniqueid: fileuniqueid,filePendingName: filePendingName,senderId: filefrom,filetype: filetype,filePendingSize: filePendingSize,filependingDate: filependingDate,filePendingTo: "-",filecaption: caption)
                        }
                        //}
                        
                        //}
                        
                    }
                }
                else{
                    print("no pending files found")
                }
                
            case .failure(let error):
                print("\(error) file check pending failed")
            }
            //request1, response1, data1, error1 in
            
            //===========INITIALISE SOCKETIOCLIENT=========
            // dispatch_async(dispatch_get_main_queue(), {
            
            //self.dismiss(true, completion: nil);
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

    
    func downloadDayStatus(uniqueid:String,filePendingName: String,senderId: String,filetype: String,filePendingSize: String,filependingDate: String,filePendingTo:String,filecaption: String)
    {
        print("downloadDayStatus")
    
    /// else{
    //uncomment
    
    
    let path = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0] as URL
    
    
    let destination1: DownloadRequest.DownloadFileDestination = { _, _ in
        var documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        var localImageURL = documentsURL.appendingPathComponent(filePendingName)
        return (localImageURL, [.removePreviousFile])
    }
    
    
    /// let destination = DownloadRequest.suggestedDownloadDestination(for: .documentDirectory, in: .userDomainMask) as? URL
    
    
    let destination: (URL, HTTPURLResponse) -> (URL) = {
        (temporaryURL, response) in
        
        if let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0] as? URL {
            //// var localImageURL = directoryURL.URLByAppendingPathComponent("\(response.suggestedFilename!)")
            //filenamePending
            print("fileName is \(response.suggestedFilename!)")
            var localImageURL = directoryURL.appendingPathComponent(response.suggestedFilename!)
            print("response.suggestedFilename! is \(response.suggestedFilename!)")
            let checkValidation = FileManager.default
            
            if (checkValidation.fileExists(atPath: "\(localImageURL)"))
            {
                print("FILE AVAILABLE")
            }
            else
            {
                print("FILE NOT AVAILABLE")
            }
            
            
            print("localpathhhhhh \(localImageURL.debugDescription)")
            return localImageURL
        }
        print("tempurl is \(temporaryURL.debugDescription)")
        return temporaryURL
    }
    
    var downloadURL=Constants.MainUrl+Constants.daystatusDownload
    print("downloading call unique id \(uniqueid)")
    
    //uncomment change later
    Alamofire.download("\(downloadURL)", method: .post, parameters: ["uniqueid":uniqueid], encoding: JSONEncoding.default, headers: header, to: destination1).downloadProgress { progress in
    print("Download Progress: \(progress.fractionCompleted)")
    
   /* if(self.delegateProgressUpload != nil)
    {self.delegateProgressUpload.updateProgressUpload(Float(progress.fractionCompleted), uniqueid: fileuniqueid)
    }*/
    }.response { (response) in
    
    print(response)
    print("1...... \(response.request?.url)")
    //print("2..... \(response.request?. .URL.debugDescription)")
    //print("3.... \(response.response?.URL.debugDescription)")
        print("2.... daystatusdownload body is ")
    print(JSON(response.request?.httpBody))
    
    let dirPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
    let docsDir1 = dirPaths[0]
    var documentDir=docsDir1 as NSString
    var filePendingPath=documentDir.appendingPathComponent(filePendingName)
    
        
        sqliteDB.saveFile(filePendingTo, from1: senderId, owneruser1: username!, file_name1: filePendingName, date1: nil, uniqueid1: uniqueid, file_size1: filePendingSize, file_type1: filetype, file_path1: filePendingPath, type1: "day_status",caption1: filecaption)
        
        
        
       //==-- sqliteDB.saveFile("all", from1: senderId, owneruser1: username!, file_name1: uniqueid+".jpg", date1: nil, uniqueid1: uniqueid, file_size1: "0", file_type1: "jpg", file_path1: filePendingPath, type1: "day_status",caption1:"")
        
    /*if(self.imageExtensions.contains(filetype.lowercased()))
    {
    //filePendingName
    sqliteDB.saveFile(filePendingTo, from1: filefrom, owneruser1: username!, file_name1: filePendingName, date1: nil, uniqueid1: fileuniqueid, file_size1: filePendingSize, file_type1: filetype, file_path1: filePendingPath, type1: "image",caption1: filecaption)
    }
    else
    {
    sqliteDB.saveFile(filePendingTo, from1: filefrom, owneruser1: username!, file_name1: filePendingName, date1: nil, uniqueid1: fileuniqueid, file_size1: filePendingSize, file_type1: filetype, file_path1: filePendingPath, type1: "document",caption1:"")
    
    }*/
    
    /*if(socketObj.delegateChat != nil)
     {
     socketObj.delegateChat.socketReceivedMessageChat("updateUI", data: nil)
     }
     */
    
        //!!!
        /*if(self.delegateProgressUpload != nil)
    
    {self.delegateProgressUpload.updateProgressUpload(Float(1.0), uniqueid: fileuniqueid)
    }*/
    
    //===
    //refresh UI file download commented==--- uncomment later ====================================----------
    /*
     if(delegateRefreshChat != nil)
     {
     delegateRefreshChat?.refreshChatsUI("",uniqueid:fileuniqueid,from:filefrom,date1:NSDate(), type:"file")
     
     //===uncomment later  delegateRefreshChat?.refreshChatsUI("",uniqueid:fileuniqueid,from:filefrom,date1:NSDate(), type:"chat")
     }*/
    
    
    
        /*
    if(self.delegateProgressUpload != nil)
    
    {self.delegateProgressUpload.updateProgressUpload(Float(1.0), uniqueid: fileuniqueid)
    }
    */
    //filedownloaded’ to with parameters ‘senderoffile’, ‘receiveroffile’
    
    print("download done long")
    print(NSDate())
    //self.confirmDownload(fileuniqueid)
   // print("confirminggggggg")
    
    // print(request?.)
    
    }
    
 
    }

    func uploadStatus(date1:Date,uniqueid1:String,file_name1:String,file_size1:String,label1:String,file_type1:String,uploadedBy1:String,file_path1:String)
    {
        /*
         date: { type: Date, default: Date.now },
         uniqueid: String,
         file_name: String,
         file_size: Number,
         path: String,
         label: String,
         file_type: String,
         uploadedBy: String
         */
        print("file type is \(file_type1)")
        var parameters:JSON = [
                "date": "\(date1)",
                "uniqueid": uniqueid1,
                "file_name":file_name1,
                "file_size": file_size1,
                "label": label1,
                "filesize": file_size1,
                "file_type": "."+file_type1,
                "uploadedBy":uploadedBy1
            ]
            
        
            var imageData:Data?
            if(self.imageExtensions.contains(file_type1.lowercased()))
            {
                imageData=UIImageJPEGRepresentation(UIImage(contentsOfFile: file_path1)!,0.9)
                print("new upload image size is \(imageData!.count)")
            }
                
            else{
                
                /*if(self.audioExtensions.contains(file_type1.lowercased()))
                 {
                 //imageData=UIImageJPEGRepresentation(UIImage(contentsOfFile: filePath1)!,0.9)
                 print("audio file is uploading")
                 //imageData=try? Data(contentsOf: URL(fileURLWithPath: filePath1))
                 }else{*/
                imageData=try? Data(contentsOf: URL(fileURLWithPath: file_path1))
                print("old upload image size is \(imageData!.count)")
                var imageData2=imageData!.compressed(using: Compression.zlib)
                print("imageData2 is \(imageData2)")
                print("old upload image compressed size is \(imageData2!.count)")
                //}
            }
        
            print("mimetype is \(MimeType(file_type1))")
            
            var urlupload=Constants.MainUrl+Constants.uploadstatusURL
            
            
            Alamofire.upload(
                multipartFormData: { multipartFormData in
                    multipartFormData.append(imageData!, withName:  "file", fileName: file_name1, mimeType: self.MimeType(file_type1))                //,fileName: file_name1, mimeType: "image/\(file_type1)")
                    for (key, value) in parameters {
                         multipartFormData.append(Data.init((value as AnyObject).description.data(using: String.Encoding.utf8)!), withName: key)
                        //!!multipartFormData.append(value.data(using: .utf8)!, withName: key)
                        // multipartFormData.append(data: value.data(using: String.Encoding.utf8)!, withName: key)
                    }
                    
            },
                to: urlupload,headers: header,
                encodingCompletion: { encodingResult in
                    switch encodingResult {
                        
                    case .success(let upload, _, _):
                        
                        upload.validate()
                        upload.uploadProgress { progress in // main queue by default
                            print("Upload Progress: \(progress.fractionCompleted)")
                        }
                        upload.responseJSON { response in
                            print(response.response?.statusCode)
                            print(response.data!)
                            
                            switch response.result {
                            case .success:
                                 print("status updated success")
                                var uniqueid_chat=UtilityFunctions.init().generateUniqueid()
                                
                                //var date=self.getDateString(Date())
                                var status="pending"
                         
                                
                                
                                DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.default).async
                                    {
                                        print("status updated success")
                                        //UPDATE STATUS SENT
                                        //!!sqliteDB.updateDayStatusReceipt()
                                        
                                        
                                }
                                
                            case .failure: print("case failure upload status encoding")
                                
                            }
                        }
                        
                        
                    case .failure: print("file uploading status encoding failed")
                        
                    }
                    
            })
        
    }


}
protocol showUploadProgressDelegate:class
{
    func updateProgressUpload(_ progress:Float,uniqueid:String);
}

