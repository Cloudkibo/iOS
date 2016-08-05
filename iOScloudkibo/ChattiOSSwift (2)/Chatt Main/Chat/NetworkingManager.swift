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
    
    func uploadFile(filePath:String)
    {
        var parameterJSON = JSON([
            "id_user": "test"
            ])
        // JSON stringify
        let parameterString = parameterJSON.rawString(NSUTF8StringEncoding, options: NSJSONWritingOptions.PrettyPrinted )
        let jsonParameterData = parameterString!.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
        var imageData=NSData(contentsOfFile: filePath)
        
    Alamofire.upload(
    .POST,
    "http://api.imagga.com/v1/content",
    headers: ["Authorization" : "Basic xxx"],
    multipartFormData: { multipartFormData in
    multipartFormData.appendBodyPart(data: imageData!, name: "imagefile",
    fileName: "image.jpg", mimeType: "image/jpeg")
    multipartFormData.appendBodyPart(data: jsonParameterData!, name: "goesIntoForm")
        
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
            }
        case .Failure(let encodingError):
            print(encodingError)
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

