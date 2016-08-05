//
//  NetworkingManager.swift
//  kiboApp
//
//  Created by Cloudkibo on 05/08/2016.
//  Copyright © 2016 MyAppTemplates. All rights reserved.
//

import Foundation
import Alamofire

class NetworkingManager
{
    static let sharedManager = NetworkingManager()

    
    private lazy var backgroundManager: Alamofire.Manager = {
        let bundleIdentifier = "kiboChat"
        return Alamofire.Manager(configuration: NSURLSessionConfiguration.backgroundSessionConfigurationWithIdentifier(bundleIdentifier + ".background"))
    }()
    
    func uploadFile()
    {
    Alamofire.upload(
    .POST,
    "http://api.imagga.com/v1/content",
    headers: ["Authorization" : "Basic xxx"],
    multipartFormData: { multipartFormData in
    multipartFormData.appendBodyPart(data: imageData, name: "imagefile",
    fileName: "image.jpg", mimeType: "image/jpeg")
    },
    encodingCompletion: { encodingResult in
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

