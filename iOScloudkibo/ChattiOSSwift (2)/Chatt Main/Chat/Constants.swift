//
//  Constants.swift
//  Chat
//
//  Created by Cloudkibo on 14/08/2015.
//  Copyright (c) 2015 MyAppTemplates. All rights reserved.
//

import Foundation
class Constants{
    
    //static let MainUrl="https://www.cloudkibo.com"
    static let MainUrl="https://api.cloudkibo.com"

    static let firstTimeLogin="/api/users/newuser"
    static let authentictionUrl="/auth/local/"
    static let bringUserChat="/api/userchat/"
    static let getCurrentUser="/api/users/me"
    static let getContactsList="/api/contactslist/"
    static let room="globalchatroom"
    
    static let addContactByUsername="/api/contactslist/addbyusername"
    static let addContactByEmail="/api/contactslist/addbyemail"
    static let markAsRead="/api/userchat/markasread"
    static let getSingleUserByID="/api/users/" //send if along
    static let removeChatHistory="/api/userchat/removechathistory"
    static let removeFriend="/api/contactslist/removefriend"
    static let getPendingFriendRequestsContacts="/api/contactslist/pendingcontacts"
    static let rejectPendingFriendRequest="/api/contactslist/rejectfriendrequest"
    static let approvePendingFriendRequest="/api/contactslist/approvefriendrequest"
    static let createNewUser="/api/users/"
    static let searchContactsByEmail="/api/users/searchaccountsbyemail"
    static let invitebymultipleemail="/api/users/invitebymultipleemail"
    static let invitebyemail="/api/users/invitebyemail"
    static let searchContactsByPhone="/api/users/searchaccountsbyphone/"
    static let fetchMyAllchats="/api/userchat/alluserchat"
    
    static let uploadFile="/api/filetransfers/upload"
    static let downloadFile="/api/filetransfers/download"
    static let checkPendingFile="/api/filetransfers/checkpendingfile"
    
    static let confirmDownload="/api/filetransfers/confirmdownload"
    /*
    private static String phoneContactsURL = "https://www.cloudkibo.com/api/users/searchaccountsbyphone/";
    private static String emailContactsURL = "https://www.cloudkibo.com/api/users/searchaccountsbyemail/";
    private static String inviteContactsURL = "https://www.cloudkibo.com/api/users/invitebymultipleemail/";
    */
}