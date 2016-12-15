//
//  UIDelegates.swift
//  kiboApp
//
//  Created by Cloudkibo on 01/11/2016.
//  Copyright © 2016 MyAppTemplates. All rights reserved.
//

import Foundation

class UIDelegates
{
    var delegateGroupChatDetails1:UpdateGroupChatDetailsDelegate!
    var delegateGroupInfoDetails1:UpdateGroupInfoDetailsDelegate!
    var delegateMainPageChats1:UpdateMainPageChatsDelegate!
    var delegateSingleChatDetails1:UpdateSingleChatDetailDelegate!
    
   // var delegateChannelsDetails1:UpdateChannelsDetailsDelegate!
   // var delegateTeamsDetails1:UpdateTeamsDetailsDelegate!
    
    // var delegateTeamsDetails1:UpdateTeamsDetailsDelegate!
    
    static let sharedInstance = UIDelegates()
    
    class func getInstance() -> UIDelegates
    {
        return sharedInstance
        
    }
    
    
    private init() {}
    
    func UpdateGroupChatDetailsDelegateCall()
    {
        if(delegateGroupChatDetails1 != nil)
        {
            delegateGroupChatDetails1?.refreshGroupChatDetailUI("updateUI", data: nil)
        }
    }
    func UpdateGroupInfoDetailsDelegateCall()
    {
        if(delegateGroupInfoDetails1 != nil)
        {
            delegateGroupInfoDetails1?.refreshGroupInfoUI("updateUI", data: nil)
        }
    }
    func UpdateMainPageChatsDelegateCall()
    {
        if(delegateMainPageChats1 != nil)
        {
            delegateMainPageChats1?.refreshMainChatViewUI("updateUI", data: nil)
        }
    }
    func UpdateSingleChatDetailDelegateCall()
    {
        if(delegateSingleChatDetails1 != nil)
        {
            delegateSingleChatDetails1?.refreshSingleChatDetailUI("updateUI", data: nil)
        }
    }
    
    
}
protocol UpdateGroupChatDetailsDelegate:class
{
    func refreshGroupChatDetailUI(message:String,data:AnyObject!);
}
protocol UpdateGroupInfoDetailsDelegate:class
{
    func refreshGroupInfoUI(message:String,data:AnyObject!);
}
protocol UpdateMainPageChatsDelegate:class
{
    func refreshMainChatViewUI(message:String,data:AnyObject!);
}
protocol UpdateSingleChatDetailDelegate:class
{
    func refreshSingleChatDetailUI(message:String,data:AnyObject!);
}
/*
protocol UpdateChannelsDetailsDelegate:class
{
    func refreshChannelsUI(message:String,data:AnyObject!);
}
protocol UpdateTeamsDetailsDelegate:class
{
    func refreshTeamsUI(message:String,data:AnyObject!);
}
*/