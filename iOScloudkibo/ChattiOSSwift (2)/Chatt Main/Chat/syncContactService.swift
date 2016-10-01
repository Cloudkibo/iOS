//
//  syncContactService.swift
//  kiboApp
//
//  Created by Cloudkibo on 29/09/2016.
//  Copyright © 2016 MyAppTemplates. All rights reserved.
//

import Foundation
import SQLite
import Contacts
import AccountKit
import Alamofire
import SwiftyJSON

class syncContactService
{
    var Q0_sendDisplayName=dispatch_queue_create("Q0_sendDisplayName",DISPATCH_QUEUE_SERIAL)
    var Q1_fetchFromDevice=dispatch_queue_create("fetchFromDevice",DISPATCH_QUEUE_SERIAL)
    var Q2_sendPhonesToServer=dispatch_queue_create("sendPhonesToServer",DISPATCH_QUEUE_SERIAL)
    var Q3_getContactsFromServer=dispatch_queue_create("getContactsFromServer",DISPATCH_QUEUE_SERIAL)
    var Q4_getUserData=dispatch_queue_create("getUserData",DISPATCH_QUEUE_SERIAL)
    var Q5_fetchAllChats=dispatch_queue_create("fetchAllChats",DISPATCH_QUEUE_SERIAL)
    
    var accountKit: AKFAccountKit!
   
     init()
    {
        if(accountKit == nil){
            accountKit = AKFAccountKit(responseType: AKFResponseType.AccessToken)
        }
     
        
    }
    
    func startContactsRefresh()
    {
        if (accountKit!.currentAccessToken != nil) {
            
        
        print("sync fetching from devie")
    dispatch_async(self.Q1_fetchFromDevice,
    {
    self.fetchContactsFromDevice({ (result) -> () in
    
    dispatch_async(self.Q2_sendPhonesToServer,
    {
        
        print("sync sending numbers to server")
    self.sendPhoneNumbersToServer({ (result) -> () in
    
    dispatch_async(self.Q3_getContactsFromServer,
    {
        
        print("sync fetching contacts from server")
    self.fetchContactsFromServer({ (result) -> () in
    
    
    var allcontactslist1=sqliteDB.allcontacts
    var alladdressContactsArray:Array<Row>
    
    let phone = Expression<String>("phone")
    let kibocontact = Expression<Bool>("kiboContact")
    let name = Expression<String?>("name")
    
    //alladdressContactsArray = Array(try sqliteDB.db.prepare(allcontactslist1))
    
    do{for ccc in try sqliteDB.db.prepare(allcontactslist1) {
    
    for var i=0;i<availableEmailsList.count;i++
    {print(":::email .......  : \(availableEmailsList[i])")
    if(ccc[phone]==availableEmailsList[i])
    { print(":::::::: \(ccc[phone])  and emaillist : \(availableEmailsList[i])")
    //ccc[kibocontact]
    
    let query = allcontactslist1.select(kibocontact)           // SELECT "email" FROM "users"
    .filter(phone == ccc[phone])     // WHERE "name" IS NOT NULL
    
    try sqliteDB.db.run(query.update(kibocontact <- true))
    // for kk in try sqliteDB.db.prepare(query) {
    //  try sqliteDB.db.run(query.update(kk[kibocontact] <- true))
    //}
    //try sqliteDB.db.run(allcontactslist1.update(query[kibocontact] <- true))
    
    // try sqliteDB.db.run(allcontactslist1.update(ccc[kibocontact] <- true))
    }
    
    }
    
    }
    }
    catch{
    print("error 123")
    }
    
    })})})})})})
        }
        else
        {
            print("error: accountkit not initialised yet in sync contacts")
        }
    }
    
    
    func sendNameToServer(var displayName:String,completion:(result:Bool)->())
    {
        // progressBarDisplayer("Contacting Server", true)
        //let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        
        //dispatch_async(dispatch_get_global_queue(priority, 0)) {
        // do some task start to show progress wheel
        
        var urlToSendDisplayName=Constants.MainUrl+Constants.firstTimeLogin
        var nn="{display_name:displayName}"
        //var getUserDataURL=userDataUrl
        
        Alamofire.request(.POST,"\(urlToSendDisplayName)",headers:header,parameters:["display_name":displayName]).responseJSON{
            response in
            
            
            print(response.data?.debugDescription)
            
            print("display name is \(displayName)")
            /*Alamofire.request(.GET,"\(urlToSendDisplayName)",headers:header,parameters:["display_name":"\(displayName)"]).validate(statusCode: 200..<300).responseJSON{response in
             */
            
            switch response.result {
                
                
                
            case .Success:
                print("display name sent to server")
                firstTimeLogin=false
                if(socketObj != nil)
                {
                    socketObj.socket.emit("logClient", "display name \(displayName) sent to server successfully")
                }
                return completion(result: true)
                //////// %%%%%%%%%%%%%%***************self.performSegueWithIdentifier("fetchContactsSegue", sender: self)
                //self.performSegueWithIdentifier("fetchaddressbooksegue", sender: self)
                //*********************%%%%%%%%%%%%%%%%%%%%%%%%% commented new
                
                //%%%%%%%%%%%%%%%% new logic commented -------------
                /*
                 dispatch_async(dispatch_get_main_queue()) {
                 // update some UI
                 //remove progress wheel
                 print("got server response")
                 self.messageFrame.removeFromSuperview()
                 self.fetchContactsFromDevice(){ (result) -> () in
                 socketObj.socket.emit("logClient","IPHONE-LOG: contacts fetched from device")
                 for cc in contacts{
                 sqliteDB.saveAllContacts(cc, kiboContact1: false)
                 }
                 
                 
                 //move to next screen
                 //self.saveButton.enabled = true
                 }
                 
                 
                 }*/
                //%%%%%%%%%%%%%%%%_----
                
                
                /////%%%%%%% important new commented %%%%%%%%%
                
                /*self.dismissViewControllerAnimated(false, completion: { () -> Void in
                 
                 print("logged in going to contactlist")
                 })*/
                
                
                //self.performSegueWithIdentifier(<#T##identifier: String##String#>, sender: <#T##AnyObject?#>)
                
            case .Failure(let error):
                print(error)
                if(socketObj != nil)
                {
                    socketObj.socket.emit("logClient","IPHONE-LOG: \(error)")
                }
                
                
                
                
                //when server sends response:
                
            }
            
            
            
        }
        // }
    }
    
    func fetchContactsFromDevice(completion: (result:Bool)->())
    {
        contactsList.fetch(){ (result) -> () in
            print("got contacts from device")
            if(socketObj != nil)
            {
                socketObj.socket.emit("logClient", "done fetched contacts from iphone")
            }
            for r in result
            {
                //get phones and append phones in list
                emailList.append(r)
            }
            completion(result: true)
        }
    }
    
    
    
    func sendPhoneNumbersToServer(completion: (result:Bool)->())
    {
        contactsList.searchContactsByPhone(emailList)
        { (result2) -> () in
            if(socketObj != nil)
            {
                socketObj.socket.emit("logClient", "received contacts from cloudkibo server")
            }
            for r2 in result2
            {
                notAvailableEmails.append(r2)
                
            }
            
            completion(result: true)
        }
        
    }
    
    
    
    func fetchContactsFromServer(completion:(result:Bool)->()){
        print("Server fetchingg contactss", terminator: "")
        if(socketObj != nil)
        {
            socketObj.socket.emit("logClient","IPHONE-LOG: fetch contacts from server")
        }
        if(loggedUserObj == JSON("[]"))
        {
        }
        
        //%%%%% new phone model
        //var fetchChatURL=Constants.MainUrl+Constants.getContactsList+"?access_token="+AuthToken!
        
        var fetchChatURL=Constants.MainUrl+Constants.getContactsList
        
        print(fetchChatURL, terminator: "")
        
        //%%%%% new phone model
        //Alamofire.request(.GET,"\(fetchChatURL)").validate(statusCode: 200..<300)
        header=["kibo-token":self.accountKit!.currentAccessToken!.tokenString]
        print("header iss \(header)")
        Alamofire.request(.GET,"\(fetchChatURL)",headers:header).validate(statusCode: 200..<300)
            .response { (request1, response1, data1, error1) in
                
                
                
                
                if response1?.statusCode==200 {
                    //============GOT Contacts SECCESS=================
                    
                    
                    print("success successfully received friends list from server")
                    if(socketObj != nil)
                    {socketObj.socket.emit("logClient","IPHONE-LOG:  successfully received friends list from server")
                    }
                    if(globalChatRoomJoined == false)
                    {
                        //socketObj.addHandlers()
                        print("joiningggggg")
                        
                        
                    }
                    //print("Contacts fetched success")
                    let contactsJsonObj = JSON(data: data1!)
                    print(contactsJsonObj)
                    //print(contactsJsonObj["userid"])
                    //let contact=JSON(contactsJsonObj["contactid"])
                    //   print(contact["firstname"])
                    print("Contactsss fetcheddddddd")
                    //var userr=contactsJsonObj["userid"]
                    // print(self.contactsJsonObj.count)
                    let contactid = Expression<String>("contactid")
                    let detailsshared = Expression<String>("detailsshared")
                    
                    let unreadMessage = Expression<Bool>("unreadMessage")
                    
                    let userid = Expression<String>("userid")
                    let firstname = Expression<String>("firstname")
                    let lastname = Expression<String>("lastname")
                    let email = Expression<String>("email")
                    let phone = Expression<String>("phone")
                    let username = Expression<String>("username")
                    let status = Expression<String>("status")
                    
                    
                    let tbl_contactslists=sqliteDB.contactslists
                    /////////newwwwwwwww///////
                    do{try sqliteDB.db.run(tbl_contactslists.delete())}catch{
                        print("contactslist table not deleted")
                    }
                    ////////////////
                    ///tbl_contactslists.delete() //complete refresh
                    ////////////////////////////////////////COUNTTTTTTT
                    print(sqliteDB.contactslists.count)
                    
                    
                    
                    //////
                    for var i=0;i<contactsJsonObj.count;i++
                    {
                        print("inside for loop")
                        do {
                            if(contactsJsonObj[i]["contactid"]["username"].string != nil)
                            {
                                print("inside username hereeeeeee")
                                let rowid = try sqliteDB.db.run(tbl_contactslists.insert(contactid<-contactsJsonObj[i]["contactid"]["_id"].string!,
                                    detailsshared<-contactsJsonObj[i]["detailsshared"].string!,
                                    
                                    unreadMessage<-contactsJsonObj[i]["unreadMessage"].boolValue,
                                    
                                    userid<-contactsJsonObj[i]["userid"].string!,
                                    firstname<-contactsJsonObj[i]["contactid"]["firstname"].string!,
                                    lastname<-contactsJsonObj[i]["contactid"]["lastname"].string!,
                                    email<-contactsJsonObj[i]["contactid"]["email"].string!,
                                    phone<-contactsJsonObj[i]["contactid"]["phone"].string!,
                                    username<-contactsJsonObj[i]["contactid"]["username"].string!,
                                    status<-contactsJsonObj[i]["contactid"]["status"].string!)
                                )
                                print("data inserttt")
                                
                                //=========this is done in fetching from sqlite not here====
                                
                                
                                // %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%new commented june
                                
                                
                                print("inserted id: \(rowid)")
                            }
                            else
                            {
                                print("inside displayname hereeeeeee")
                                
                                
                                let rowid = try sqliteDB.db.run(tbl_contactslists.insert(contactid<-contactsJsonObj[i]["contactid"]["_id"].string!,
                                    detailsshared<-contactsJsonObj[i]["detailsshared"].string!,
                                    
                                    unreadMessage<-contactsJsonObj[i]["unreadMessage"].boolValue,
                                    
                                    userid<-contactsJsonObj[i]["userid"].string!,
                                    firstname<-contactsJsonObj[i]["contactid"]["display_name"].string!,
                                    lastname<-"",
                                    
                                    //lastname<-contactsJsonObj[i]["contactid"]["lastname"].string!,
                                    email<-"@",
                                    phone<-contactsJsonObj[i]["contactid"]["phone"].string!,
                                    username<-contactsJsonObj[i]["contactid"]["phone"].string!,
                                    status<-contactsJsonObj[i]["contactid"]["status"].string!)
                                )
                                
                                print("inserted id: \(rowid)")
                                
                            }
                            
                        } catch {
                            print("insertion failed: \(error)")
                        }
                        
                    }
                    
                    print("contacts fetchedddddddddddddd sucecess")
                    
                    
                    completion(result:true)
                    
                }else{
                    
                    completion(result:false)
                    
                    print("error: \(error1!.localizedDescription)")
                    if(socketObj != nil)
                    {
                        socketObj.socket.emit("logClient", "error: \(error1!.localizedDescription)")
                    }
                    print(error1)
                    print(response1?.statusCode)
                    print("FETCH CONTACTS FAILED")
                    print("eeeeeeeeeeeeeeeeeeeeee")
                    
                }
                if(response1?.statusCode==401)
                {
                    if(socketObj != nil)
                    {
                        socketObj.socket.emit("logClient", "error: \(error1!.localizedDescription)")
                    }
                    print("Refreshinggggggggggggggggggg token expired")
                    if(username==nil || password==nil)
                    {print("line # 1074")
                      //  self.performSegueWithIdentifier("loginSegue", sender: nil)
                    }
                    
                    /*else{
                     self.rt.refrToken()
                     }*/
                    
                }
                
        }
        
        
        
    }
}