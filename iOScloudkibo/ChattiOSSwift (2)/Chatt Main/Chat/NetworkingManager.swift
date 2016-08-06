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
            "file_name": file_name1,
            "file_size": file_size1,
            "file_type": file_type1]
        
        
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
        
        var urlupload=Constants.MainUrl+Constants.uploadFile
    Alamofire.upload(
    .POST,
    urlupload,
    headers: header,
    multipartFormData: { multipartFormData in
    multipartFormData.appendBodyPart(data: imageData!, name: "file",
    fileName: file_name1, mimeType: "image/\(file_type1)")
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
                print(JSON(response.data!))
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
    
    
    var backgroundCompletionHandler: (() -> Void)? {
        get {
            return backgroundManager.backgroundCompletionHandler
        }
        set {
            backgroundManager.backgroundCompletionHandler = newValue
        }
    }
}

