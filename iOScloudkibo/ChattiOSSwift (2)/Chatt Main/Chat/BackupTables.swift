//
//  BackupTables.swift
//  kiboApp
//
//  Created by Cloudkibo on 06/03/2017.
//  Copyright © 2017 MyAppTemplates. All rights reserved.
//

import UIKit
import SwiftyJSON
import SQLite
import Alamofire
import AVFoundation
import MobileCoreServices
import Foundation
import AssetsLibrary
import Photos
import Contacts
import Compression
import ContactsUI
import MediaPlayer
import AVKit
import Kingfisher

class BackupTables{
    
    init()
    {
        
        
    }
    
    func backupChatsTable()
    {
        let dirPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let docsDir1 = dirPaths[0]
        var documentDir=docsDir1 as NSString
        var filePathImage2=documentDir.appendingPathComponent("chats.JSON")
        
        var text=JSON.init([["fsdf":"Sdfs"],["Sfsf":"Sdfsd"]])
        FileManager.default.createFile(atPath: filePathImage2, contents: Data.init(base64Encoded: text.string!), attributes: nil)
    
    }
}
