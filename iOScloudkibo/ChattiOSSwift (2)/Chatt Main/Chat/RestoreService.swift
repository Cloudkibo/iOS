//
//  RestoreService.swift
//  kiboApp
//
//  Created by Cloudkibo on 10/03/2017.
//  Copyright © 2017 MyAppTemplates. All rights reserved.
//

import Foundation
import SQLite
import UIKit
import SwiftyJSON

class RestoreService{
    
    
    init()
    {
        
    }
    
    func RestoreChatsTable(filename:String)
    {
      //  var ubiquityURL=FileManager.init().url(forUbiquityContainerIdentifier: "iCloud.iCloud.MyAppTemplates.cloudkibo")
        
        var ubiquityURL = UtilityFunctions.init().getBackupDirectoryICloud()
        
        if(ubiquityURL != nil)
        {
        ///////ubiquityURL=ubiquityURL!.appendingPathComponent("Backup", isDirectory: true)
        ubiquityURL=ubiquityURL!.appendingPathComponent("\(filename)")
        
        do{ var chatsData=try Data.init(contentsOf: ubiquityURL!)
            print("reading \(filename.removeCharsFromEnd(5)) table from icloud")
            print(JSON.init(data: chatsData))
            var ChatsDataJSONobject=JSON.init(data: chatsData)
            
            for chatsRows in ChatsDataJSONobject
            {
                var chats=chatsRows.1 //as! [String : Any]
                //chats.
                
                var iterator=chats.makeIterator()
                
                
            sqliteDB.SaveChat(iterator.next() as! String, from1: iterator.next() as! String, owneruser1: iterator.next() as! String, fromFullName1: iterator.next() as! String, msg1: iterator.next() as! String, date1: iterator.next() as! Date?, uniqueid1: iterator.next() as! String, status1: iterator.next() as! String, type1: iterator.next() as! String, file_type1: iterator.next() as! String, file_path1: iterator.next() as! String)
            }
        }
        catch{
            print("error reading \(filename.removeCharsFromEnd(5)) table from icloud")
        }
        }
    }
    
    
    func RestoreChatsStatusTable()
    {
        
    }
    
    func RestoreFilesTable()
    {
        
    }
    
    
}
