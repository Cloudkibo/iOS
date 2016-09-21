//
//  notificationsMainClass.swift
//  Chat
//
//  Created by Cloudkibo on 30/12/2015.
//  Copyright (c) 2015 MyAppTemplates. All rights reserved.
//

/*import Foundation

class notificationsMainClass {
    class var sharedInstance : notificationsMainClass {
        struct Static {
            static let instance : notificationsMainClass = notificationsMainClass()
        }
        return Static.instance
    }
    
    private let ITEMS_KEY = "todoItems"
    
    func addItem(item: NotificationItem) { // persist a representation of this todo item in NSUserDefaults
        var todoDictionary = NSUserDefaults.standardUserDefaults().dictionaryForKey(ITEMS_KEY) ?? Dictionary() // if todoItems hasn't been set in user defaults, initialize todoDictionary to an empty dictionary using nil-coalescing operator (??)
        
        todoDictionary[item.UUID] = ["type": item.type , "UUID": item.UUID, "message": item.message, "otherUserName": item.otherUserName] // store NSData representation of todo item in dictionary with UUID as key
        NSUserDefaults.standardUserDefaults().setObject(todoDictionary, forKey: ITEMS_KEY) // save/overwrite todo item list
        
        // create a corresponding local notification
        let notification = UILocalNotification()
        ////%%%%notification.alertBody = "You received a \"\(item.type)\" from \(item.otherUserName)" // text that will be displayed in the notification
        notification.alertBody = "\(item.otherUserName) says: \(item.message)" // text that will be displayed in the notification
        
        notification.alertAction = "open" // text that is displayed after "slide to..." on the lock screen - defaults to "slide to view"
        notification.fireDate = item.deadline // todo item due date (when notification will be fired)
        notification.soundName = UILocalNotificationDefaultSoundName // play default sound
        notification.userInfo = ["UUID": item.UUID, ] // assign a unique identifier to the notification so that we can retrieve it later
        notification.category = "Cloudkibo_Category"
        //UIApplication.sharedApplication().scheduleLocalNotification(notification)
    }
}
*/