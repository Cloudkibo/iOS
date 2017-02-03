//
//  fileTestingDoc.swift
//  Chat
//
//  Created by Cloudkibo on 11/03/2016.
//  Copyright © 2016 MyAppTemplates. All rights reserved.
//

import UIKit
import Foundation

class fileTestingDoc: UIDocument {
    
    var userText: String? = "Some Sample Text"
    
    
    override func contents(forType typeName: String) throws -> Any {
        if let content = userText {
            
            let length =
            content.lengthOfBytes(using: String.Encoding.utf8)
            return Data(bytes: UnsafePointer<UInt8>(content), count: length)
            
        } else {
            return Data()
        }
        
    }
    
    override func load(fromContents contents: Any, ofType typeName: String?) throws {
        if let userContent = contents as? Data {
            userText = NSString(bytes: (contents as AnyObject).bytes,
                length: userContent.count,
                encoding: String.Encoding.utf8.rawValue) as? String
        }
        
        
    }
}
