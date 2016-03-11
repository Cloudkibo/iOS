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
    
    
    override func contentsForType(typeName: String) throws -> AnyObject {
        if let content = userText {
            
            var length =
            content.lengthOfBytesUsingEncoding(NSUTF8StringEncoding)
            return NSData(bytes:content, length: length)
            
        } else {
            return NSData()
        }
        
    }
    
    override func loadFromContents(contents: AnyObject, ofType typeName: String?) throws {
        if let userContent = contents as? NSData {
            userText = NSString(bytes: contents.bytes,
                length: userContent.length,
                encoding: NSUTF8StringEncoding) as? String
        }
        
        
    }
}
