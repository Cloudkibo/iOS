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
    
static let hubname="CloudKiboIOSPush" //testing
//=========static let hubname="Cloudkibo" //production
static let connectionstring="Endpoint=sb://cloudkiboiospush.servicebus.windows.net/;SharedAccessKeyName=DefaultListenSharedAccessSignature;SharedAccessKey=2OXyVhx1SX6m34z1RT0pnrpj5MBdv0aAE+7v8W5kkIw="  //testing
    
//========static let connectionstring="Endpoint=sb://cloudkibo.servicebus.windows.net/;SharedAccessKeyName=DefaultListenSharedAccessSignature;SharedAccessKey=fs2RqnCIAJ+W5gc/iC82h5A0a+UuMHKNdQruSRxo/Hk="    //production
    
    static let fetchSingleChat="/api/userchat/getsinglechat" //uniqueid:
    
    static let partialSync="/api/userchat/partialchatsync"
    
   // static let connectionstring="Endpoint=sb://cloudkibo.servicebus.windows.net/;SharedAccessKeyName=DefaultFullSharedAccessSignature;SharedAccessKey=arTrXZQGBUeuLYLcwTTzCVqFDN1P3a6VrxA15yvpnqE="
   
    static let sendChatURL="/api/userchat/save2" //send chat stanza
    static let sendChatStatusURL="/api/userchat/updateStatus" //uniqueid,sender,status
    
    static let urllog="/api/users/log"//papertrail
    static let createGroupUrl="/api/groupmessaging/"
    static let addGroupMembersUrl="/api/groupmessaginguser/"
    static var sendGroupChat="/api/groupchat/"
    static var fetchSingleGroupChat="/api/groupchat/fetchSingleChat"
    
    static var getMyGroups="/api/groupmessaginguser/mygroups"
    
    static var sendChat="/api/groupchat/"
    static var fetchmygroupmembers="/api/groupmessaginguser/mygroupsmembers"
    static var fetchSingleGroup="/api/groupmessaging/specificGroup"
    static var fetchGroupMembersSpecificGroup="/api/groupmessaginguser/myspecificgroupsmembers"
    
    static var leaveGroup="/api/groupmessaginguser/leaveGroup" //group_unique_id
    static var removeMemberFromGroup="/api/groupmessaginguser/removeFromGroup" //group_unique_id , phone
    
    static var  uploadProfileImage="/api/groupmessaging/uploadIcon"
    static var  changeRole="/api/groupmessaginguser/updateRole"
    
    static var checkGroupMsgStatus="/api/groupchatstatus/checkStatus"
    static var  updateGroupChatStatusAPI = "/api/groupchatstatus/updateStatus"
    static var  syncGetPartialGroupChats="/api/groupchatstatus/"
    
    static var downloadGroupIcon="/api/groupmessaging/downloadIcon"
    
    
    
  //  static var fetchSingleGroupChat="/api/groupchat/fetchSingleChat"
    /*
     private static String phoneContactsURL = "https://www.cloudkibo.com/api/users/searchaccountsbyphone/";
     private static String emailContactsURL = "https://www.cloudkibo.com/api/users/searchaccountsbyemail/";
     private static String inviteContactsURL = "https://www.cloudkibo.com/api/users/invitebymultipleemail/";
     */
    
    //https://api.cloudkibo.com/api/users/log

    
    
    
    
    
    
}