//
//  LoginAPI.swift
//  Chat
//
//  Created by Cloudkibo on 13/08/2015.
//  Copyright (c) 2015 MyAppTemplates. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import UIKit
import SQLite
import AVFoundation
import AccountKit

enum ChatAppSocketChannelState:NSInteger{
    
    case kARDWebSocketChannelStateClosed
    // State when connection is established but not ready for use.
    case kARDWebSocketChannelStateOpen
    // State when connection is established and registered.
    case kARDWebSocketChannelStateRegistered
    // State when connection encounters a fatal error.
    case kARDWebSocketChannelStateError
    
}

/*
kARDWebSocketChannelStateClosed,
// State when connection is established but not ready for use.
kARDWebSocketChannelStateOpen,
// State when connection is established and registered.
kARDWebSocketChannelStateRegistered,
// State when connection encounters a fatal error.
kARDWebSocketChannelStateError*/

class LoginAPI{
    
    
    var delegateChat:UpdateChatDelegate!
    var socket:SocketIOClient
    //var areYouFreeForCall:Bool
    var isBusy:Bool
    var delegate:SocketClientDelegate!
    var delegateWebRTC:SocketClientDelegateWebRTC!
    var delegateWebRTCVideo:SocketClientDelegateWebRTCVideo!
    var delegateSocketConnected:SocketConnecting!
    //var areYouFreeForCall:Bool
    
    
    init(url:String){
        socket=SocketIOClient(socketURL: "\(url)"/*, options: [.Log(true)]*/)
        areYouFreeForCall=true
        isBusy=false
        self.socket.on("connect") {data, ack in
            isSocketConnected=true
            NSLog("connected to socket")
            
            //if(globalChatRoomJoined==false)
            //{
                let _id = Expression<String>("_id")
                let phone = Expression<String>("phone")
                let username1 = Expression<String>("username")
                let status = Expression<String>("status")
                let firstname = Expression<String>("firstname")
            //country_prefix
            //national_number
            
                
                let tbl_accounts = sqliteDB.accounts
                do{for account in try sqliteDB.db.prepare(tbl_accounts) {
                    if(socketObj != nil)
{
                    socketObj.socket.emit("logClient","IPHONE-LOG:username:\(account[phone]) _id: \(account[_id]) ,status: \(account[status]),display_name: \(account[firstname])")
                    }
                    print("username:\(account[phone]) _id: \(account[_id]) ,status: \(account[status]),display_name: \(account[firstname])")
                    username=account[phone]
                  //  if(socketObj != nil)
                   // {
                socketObj.socket.emit("join global chatroom", ["room": "globalchatroom", "user":["username":"\(account[phone])","_id":"\(account[_id])","status":"\(account[status])","display_name":"\(account[firstname])","phone":"\(account[phone])"]])
                    //WORKINGGG
                  //  }
                    globalChatRoomJoined=true
                  //  if(socketObj != nil)
                   // {
                    self.socket.emit("logClient","IPHONE-LOG: \(username!) is joining room room:globalchatroom")
                    ////}
                    }
                    }
                catch
                {
                    if(socketObj != nil)
                    {
                    self.socket.emit("logClient","IPHONE-LOG: no value in accounts table")
                    }
                }
                
                //self.socket.emit("join global chatroom",["room": "globalchatroom", "user": json.object])
                
                //print(json["_id"])
                
                
                
                
            //}
            self.delegateSocketConnected?.socketConnected()
            
        }
        //self.socket.reconnects=true
        self.socket.connect()
        print("socketObj value is \(socketObj)")
        //%%%%%%%%% self.socket.reconnects=false
        /*self.socket.connect()
        socketConnected=true
        self.addHandlers()
        self.addWebRTCHandlers()
       
        */
        //self.delegate=SocketClientDelegate()
    }
    /*
    func connect()
    {
        
        self.socket.on("connect") {data, ack in
            NSLog("connected to socket")
            
            
        }
        self.socket.on("disconnect") {data, ack in
            NSLog("disconnected from socket")
            //self.socket.emit("message", ["msg":"hangup"])
            
        }
        //connection.status
        self.socket.on("connection.status") {data, ack in
            NSLog("disconnected from socket")
            print(data?.debugDescription)
           // self.socket.emit("message", ["msg":"hangup"])
            
        }
       /* socket.on("youareonline") {data,ack in
            
            print("you onlineeee \(ack)")
            glocalChatRoomJoined = true
        }*/
        //self.socket.connect()
        //addHandlers()
        
            }
*/
    
    func addHandlers(){
        print("adding socket handlerssss", terminator: "")
        
        /*self.socket.on("connect") {data, ack in
            isSocketConnected=true
            NSLog("connected to socket")
            self.delegateSocketConnected?.socketConnected()
            
        }*/
        
        self.socket.on("disconnect") {data, ack in
            //NSLog("disconnected from socket")
            print("disconnected from socket")
            /////socketObj.socket.emit("logClient","IPHONE-LOG: kibo disconnected from socket. conneted again")
            meetingStarted=false
            isSocketConnected=false
            globalChatRoomJoined=false
            //self.socket.reconnects=true
           // self.socket.connect()
            //self.socket.emit("message", ["msg":"hangup"])
            
        }
        //connection.status
        self.socket.on("connection.status") {data, ack in
            NSLog(" socket status \(data.debugDescription)")
            print(data.debugDescription)
            // self.socket.emit("message", ["msg":"hangup"])
            
        }
        
        socketObj.socket.on("theseareonline"){data,ack in
            print("theseareonline ........")
            print(":::::::::::::::::::::::::::::::::::")
            var msg=JSON(data)
            print(msg.debugDescription)
            self.delegate?.socketReceivedMessage("theseareonline",data: data)
        }
        socketObj.socket.on("yesiamfreeforcall"){data,ack in
            print("yesiamfreeforcall .......")
            print(":::::::::::::::::::::::::::::::::::")
            var msg=JSON(data)
            print(msg.debugDescription)
            self.delegate?.socketReceivedMessage("yesiamfreeforcall",data: data)
        }
        
        socketObj.socket.on("online"){data,ack in
            print("online .......")
            print(":::::::::::::::::::::::::::::::::::")
            var msg=JSON(data)
            print(msg.debugDescription)
            self.delegate?.socketReceivedMessage("online",data: data)
        }
    
        socketObj.socket.on("offline"){data,ack in
            print("offline .......")
            print(":::::::::::::::::::::::::::::::::::")
            var msg=JSON(data)
            print(msg.debugDescription)
            self.delegate?.socketReceivedMessage("offline",data: data)
        }
        
        
        socketObj.socket.on("areyoufreeforcall"){data,ack in
            socketObj.socket.emit("logClient","\(username) received message areyoufreeforcall")
            print("areyoufreeforcall ........")
            print(":::::::::::::::::::::::::::::::::::")
            
            var jdata=JSON(data)
            socketObj.socket.emit("logClient","IPHONE-LOG: checking if \(username!) is free for call")
            print("areyoufreeforcall ......", terminator: "")
            print(jdata.debugDescription)
            
            if(areYouFreeForCall==true)
            {   iOSstartedCall=false
                //print(jdata[0]["caller"].string!)
                //print(self.currrentUsernameRetrieved, terminator: "")
                iamincallWith=jdata[0]["callerphone"].string!
                isInitiator=false
                //callerID=jdata[0]["sendersocket"].string!
                //transition
                
                //let secondViewController:CallRingingViewController = CallRingingViewController()
                var aa=JSON(["to":jdata[0]["callerphone"].string!,"msg":["callerphone":jdata[0]["callerphone"].string!,"calleephone":jdata[0]["calleephone"].string!,"status":"calleeisavailable","type":"call"]])
                
                //print(aa.description)
                socketObj.socket.emit("logClient","IPHONE-LOG: \(aa.object)")
                socketObj.socket.emit("message",aa.object)
               
                let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)

                var next = storyboard.instantiateViewControllerWithIdentifier("Main") as! CallRingingViewController
                
                let navigationController = UIApplication.sharedApplication().windows[0].rootViewController as! UITabBarController
                
                let activeViewCont = navigationController.selectedViewController
                var nameOfCaller=""
                var allcontacts=sqliteDB.allcontacts
                //var contactsKibo=sqliteDB.contactslists
                
                
                let phone = Expression<String>("phone")
                let usernameFromDb = Expression<String?>("username")
                let name = Expression<String?>("name")
                
                nameOfCaller=jdata[0]["callerphone"].string!
                //do
                //{allkiboContactsArray = Array(try sqliteDB.db.prepare(contactsKibo))
                do{
                    for all in try sqliteDB.db.prepare(allcontacts) {
                        if(all[phone]==iamincallWith) //if we found contact in our AddressBook
                            
                        {
                            //Matched phone number. Got contact
                            if(all[name] != "" || all[name] != nil)
                            {
                                nameOfCaller=all[name]!
                                //cell.contactName?.text=all[name]
                            }}}}
                catch
                {
                    print("error here 111")
                }
            
                
                activeViewCont!.presentViewController(next, animated: true, completion: {next.txtCallerName.text=jdata[0]["callerphone"].string!; next.currentusernameretrieved=username!; next.callerName=jdata[0]["callerphone"].string!
                    isInitiator=false
                    sqliteDB.saveCallHist(nameOfCaller, dateTime1: NSDate().debugDescription, type1: "Incoming")
                    
                    
                })

                

                
                
                /*self.presentViewController(next, animated: false, completion: {next.txtCallerName.text=jdata[0]["callerphone"].string!; next.currentusernameretrieved=self.currrentUsernameRetrieved; next.callerName=jdata[0]["callerphone"].string!
                    isInitiator=false
                })*/
                
            }
            else{
                print("callee is busyy.....")
                iOSstartedCall=false
                //print(jdata[0]["caller"].string!)
                //print(self.currrentUsernameRetrieved, terminator: "")
                //iamincallWith=jdata[0]["callerphone"].string!
                isInitiator=false
                //callerID=jdata[0]["sendersocket"].string!
                //transition
                
                //let secondViewController:CallRingingViewController = CallRingingViewController()
                var aa=JSON(["to":jdata[0]["callerphone"].string!,"msg":["callerphone":jdata[0]["callerphone"].string!,"calleephone":jdata[0]["calleephone"].string!,"status":"calleeisbusy","type":"call"]])
                
                //print(aa.description)
                socketObj.socket.emit("logClient","IPHONE-LOG: \(aa.object)")
                socketObj.socket.emit("message",aa.object)
            }
            //OLD LOGIC only works on chatview as catched there only
            /*var msg=JSON(data)
            print(msg.debugDescription)
            
            
            var jdata=JSON(data)
            print("areyoufreeforcall ......", terminator: "")
            print(jdata.debugDescription)
            
            
            
            
            
            var state=UIApplication.sharedApplication().applicationState
            
            if (state == UIApplicationState.Background || state == UIApplicationState.Inactive)
                
                
            {
                var localNotification = UILocalNotification()
                
                
                localNotification.fireDate = NSDate(timeIntervalSinceNow: 1)
                
                
                localNotification.alertBody = "You have a new call"
                
                
                localNotification.timeZone = NSTimeZone.defaultTimeZone()
                
                
                localNotification.applicationIconBadgeNumber = UIApplication.sharedApplication().applicationIconBadgeNumber + 1
                
                UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
                
                //UIApplication.sharedApplication().presentLocalNotificationNow(localNotification)
             
                
            }
            /*if(areYouFreeForCall==true)
            {   iOSstartedCall=false
                print(jdata[0]["caller"].string!)
                //print(self.currrentUsernameRetrieved, terminator: "")
                iamincallWith=jdata[0]["caller"].string!
                isInitiator=false
                //callerID=jdata[0]["sendersocket"].string!
                //transition
                
                //let secondViewController:CallRingingViewController = CallRingingViewController()
                
                socketObj.socket.emit("yesiamfreeforcall",["mycaller" : jdata[0]["caller"].string!, "me":username!])
                
                
            }*/
            self.delegate?.socketReceivedMessage("areyoufreeforcall",data: data)
            
            */
        }
        
        socketObj.socket.on("noiambusy"){data,ack in
            print("i am busyy ......")
            print(":::::::::::::::::::::::::::::::::::")
            var msg=JSON(data)
            print(msg.debugDescription)
            self.delegate?.socketReceivedMessage("noiambusy",data: data)
        }
        //calleeisbusy
        socketObj.socket.on("calleeisbusy"){data,ack in
            print("calleeisbusy ......")
            print(":::::::::::::::::::::::::::::::::::")
            var msg=JSON(data)
            print(msg.debugDescription)
            self.delegate?.socketReceivedMessage("calleeisbusy",data: data)
        }
        
        
        
        socketObj.socket.on("offline"){data,ack in
            print("offline ......")
            print(":::::::::::::::::::::::::::::::::::")
            var msg=JSON(data)
            print(msg.debugDescription)
            self.delegate?.socketReceivedMessage("offline",data: data)
        }
        
        socketObj.socket.on("messageStatusUpdate"){data,ack in
            print("messageStatusUpdate ......")
            print(":::::::::::::::::::::::::::::::::::")
            var chatmsg=JSON(data)
            print(data[0])
            print(chatmsg[0])
            sqliteDB.UpdateChatStatus(chatmsg[0]["uniqueid"].string!, newstatus: chatmsg[0]["status"].string!)
            

            //get status and unique id from server delivered or seen
            
            
            self.delegate?.socketReceivedMessage("messageStatusUpdate",data: data)
            if(self.delegateChat != nil)
            {
            self.delegateChat?.socketReceivedMessageChat("updateUI", data: nil)
            }
        }
        
        //messageStatusUpdate
        
        socketObj.socket.on("im") {data,ack in
            print("im is reeived from server........................")
            var msg=JSON(data)
            
           
            //=========================================
            //Sound will be received in payload through push notifications
            //=========================================
            
            /* let systemSoundID: SystemSoundID = 1016
            
            // to play sound
            AudioServicesPlaySystemSound (systemSoundID)
           
            */
            
            //AudioServicesCre
            // to play sound
            //AudioServicesPlaySystemSound (systemSoundID)
            
            var chatJson=JSON(data)
            print("chat received \(chatJson.debugDescription)")
            print(chatJson[0]["msg"])
            var receivedMsg=chatJson[0]["msg"]
            var uniqueid=chatJson[0]["uniqueid"]
            //var dateString=chatJson[0]["date"]
            
            self.fetchSingleChatMessage(chatJson[0]["uniqueid"].string!)
            
            //self.addMessage(receivedMsg.description, ofType: "1",date: NSDate().debugDescription)
          
            
            
            
            //======================
            // Use Push Notification to receive Chat message. Logic moved to App Delegte ReceivedNotification
            //========================
            
            var status="delivered"
            
             /*if(!chatJson[0]["type"].isExists())
            {//old chat message
                 sqliteDB.SaveChat(chatJson[0]["to"].string!, from1: chatJson[0]["from"].string!,owneruser1:chatJson[0]["to"].string!, fromFullName1: chatJson[0]["fromFullName"].string!, msg1: chatJson[0]["msg"].string!,date1:nil,uniqueid1:chatJson[0]["uniqueid"].string!,status1: status,type1: "", file_type1: "chat",file_path1: "")
                
                
            }
            else
            {
                
                if(chatJson[0]["type"].string! == "file")
                {
                    managerFile.checkPendingFiles(username!)
                }
                
                sqliteDB.SaveChat(chatJson[0]["to"].string!, from1: chatJson[0]["from"].string!,owneruser1:chatJson[0]["to"].string!, fromFullName1: chatJson[0]["fromFullName"].string!, msg1: chatJson[0]["msg"].string!,date1:nil,uniqueid1:chatJson[0]["uniqueid"].string!,status1: status,type1: chatJson[0]["type"].string!, file_type1: chatJson[0]["file_type"].string!,file_path1: "")
                

            }*/
            
            
            //{status : '<delivered or seen>', uniqueid : '<unique id of message>', sender : '<cell number of sender>'}
            
            socketObj.socket.emitWithAck("messageStatusUpdate", ["status":status,"uniqueid":chatJson[0]["uniqueid"].string!,"sender": chatJson[0]["from"].string!])(timeoutAfter: 0){data in
                var chatmsg=JSON(data)
                print(data[0])
                print(chatmsg[0])
                print("chat status emitted")
                if(socketObj != nil)
                {
                socketObj.socket.emit("logClient","\(username) chat status emitted")
                }
                }
            
            
            
            print(msg.debugDescription)
            self.delegate?.socketReceivedMessage("im",data: data)
            if(self.delegateChat != nil)
            { if(socketObj != nil)
            {
                socketObj.socket.emit("logClient","chat delegate not nil")
                }
            self.delegateChat?.socketReceivedMessageChat("im",data: data)
            }
            else
            {
                //show local notification in top bar
             /*   let notification = UILocalNotification()
                notification.alertBody = chatJson[0]["msg"].string! // text that will be displayed in the notification
                ///notification.alertAction = "open" // text that is displayed after "slide to..." on the lock screen - defaults to "slide to view"
                notification.fireDate = NSDate() // todo item due date (when notification will be fired)
                notification.soundName = UILocalNotificationDefaultSoundName // play default sound
                notification.userInfo = ["title": chatJson[0]["from"].string!, "UUID": chatJson[0]["uniqueid"].string!] // assign a unique identifier to the notification so that we can retrieve it later
                
              //  UIApplication.sharedApplication().scheduleLocalNotification(notification)
                UIApplication.sharedApplication().presentLocalNotificationNow(notification)
                */
                
            }
            
            
            //print("chat received \(chatJson.debugDescription)")
            //print(chatJson[0]["msg"])
            //receivedMsg=chatJson[0]["msg"]
            
            //print("chat sent to server.ack received")
            // declared system sound here
            //let systemSoundID: SystemSoundID = 1104
            // create a sound ID, in this case its the tweet sound.
            var state=UIApplication.sharedApplication().applicationState
            
            //UIApplicationState state = [[UIApplication sharedApplication] applicationState];
            
            /*if (state == UIApplicationState.Background || state == UIApplicationState.Inactive)
            {
                //Do checking here.
            
            let systemSoundID: SystemSoundID = 1016
            
            // to play sound
            AudioServicesPlaySystemSound (systemSoundID)
            let todoItem = NotificationItem(otherUserName: msg[0]["fromFullName"].string!, message:msg[0]["msg"].string! , type: "New Message", UUID: "111", deadline: NSDate(timeIntervalSinceNow: 0))
            notificationsMainClass.sharedInstance.addItem(todoItem) // schedule a local notification to persist this item
            }*/
        }
        
        ///////////////
        
        /*socketObj.socket.on("othersideringing"){data,ack in
            
            
            //UIApplicationState state = [[UIApplication sharedApplication] applicationState];
           
            print("otherside ringing")
            print(":::::::::::::::::::::::::::::::::::")
            let msg=JSON(data)
            print(msg.debugDescription)
            self.delegate?.socketReceivedMessage("othersideringing",data: data)
            
        }*/
        
        socket.on("youareonline") {data,ack in
            //var contactsOnlineList=JSON(data)
            //print(contactsOnlineList.debugDescription)
            //print("you onlineeee \(ack)")
            print("you onlineeee \(ack)")
            globalChatRoomJoined = true
            self.delegate?.socketReceivedMessage("youareonline",data: data)
        }
        /*
        socketObj.socket.on("message"){data,ack in
            print("received messageee")
            var msg=JSON(data)
            print(msg.debugDescription)
            if(msg[0]["type"] == "call")
            {
            if(msg[0]["status"] == "calleeisavailable")
            {
                print("otherside ringing")
                print("--------")
                let msg=JSON(data)
                print(msg.debugDescription)
                /////////self.delegate?.socketReceivedMessage("othersideringing",data: data)

            }
                
           // }
                
                /*
            var missedMsg=""
            var nameOfCaller=""
            print(msg.debugDescription)
            let mmm=msg[0].debugDescription
            let start = mmm.startIndex
            let char:Character=":"
            let end=mmm.characters.indexOf(char)
            ////////^^^^^^newww let end = find(mmm, ":")
            print("missed here in login API")
            if (end != nil) {
                missedMsg = mmm[start...end!]
                print(missedMsg)
                var startNameChar=end
                var lastChar=missedMsg.characters.indices.last
                nameOfCaller=mmm[startNameChar!...lastChar!]
                print(nameOfCaller)
            }
            if(missedMsg == "Missed Incoming Call: ")
            {print("inside missed notification")
                
                var allcontacts=sqliteDB.allcontacts
                //var contactsKibo=sqliteDB.contactslists
                
                
                let phone = Expression<String>("phone")
                let usernameFromDb = Expression<String?>("username")
                let name = Expression<String?>("name")
                
                //do
                //{allkiboContactsArray = Array(try sqliteDB.db.prepare(contactsKibo))
                    do{
                        for all in try sqliteDB.db.prepare(allcontacts) {
                        if(all[phone]==nameOfCaller) //if we found contact in our AddressBook
                            
                        {
                            //Matched phone number. Got contact
                            if(all[name] != "" || all[name] != nil)
                            {
                                nameOfCaller=all[name]!
                                //cell.contactName?.text=all[name]
                                print("name is \(all[name])")

                            }
                            }
                        }
                    }
                catch
                {
                    print("error in fetching all contacts from addressbook")
                }
            }
                
                sqliteDB.saveCallHist(nameOfCaller, dateTime1: NSDate().debugDescription, type1: "Missed")
                */
                
                /*let todoItem = NotificationItem(otherUserName: nameOfCaller, message: "you received a mised call", type: "missed call", UUID: "111", deadline: NSDate())
                notificationsMainClass.sharedInstance.addItem(todoItem) // schedule a local notification to persist this item
                */
            }
        
           /* if (end != nil) {
                missedMsg = mmm[start...end!]
                print(missedMsg)
            }
            if(missedMsg == "Missed Call:")
            {print("inside missed notification")
                
                sqliteDB.saveCallHist(iamincallWith, dateTime1: NSDate().debugDescription, type1: "Missed")
                
                let todoItem = NotificationItem(otherUserName: "\(iamincallWith!)", message: "you received a mised call", type: "missed call", UUID: "111", deadline: NSDate())
                notificationsMainClass.sharedInstance.addItem(todoItem) // schedule a local notification to persist this item
                
            }*/
            if(msg[0].description=="Accept Call")
            {
                print("loginAPI Accept Call delegate sentt")
                self.delegate?.socketReceivedMessage("Accept Call",data: data)
            }

            print("handlers added")
        }
        */
    
    }
    
        
        func addWebRTCHandlers()
        {
            print("adding webrtc handlers")
            //-----------------------
            //-----old conference handlers
            //-----------------------
            socketObj.socket.on("msg"){data,ack in
                
                self.delegateWebRTC.socketReceivedMSGWebRTC("msg", data: data)
                
                print("msg reeived.. check if offer answer or ice")
                
                /*
                
                var msg=JSON(data)
                print(msg[0].description)
                
                if(msg[0]["type"].string! == "offer")
                {
                
                
                /*
                //^^^^^^^^^^^^^^^^newwwww if(joinedRoomInCall == "" && isInitiator.description == "false")
                if(joinedRoomInCall == "")
                {
                print("room joined is null")
                }
                
                print("offer received")
                //var sdpNew=msg[0]["sdp"].object
                if(self.pc == nil) //^^^^^^^^^^^^^^^^^^newwwww tryyy
                {
                self.createPeerConnectionObject()
                }
                //^^^^^^^^^^^^^^^^^^ check this for second call already have localstream
                
                self.addLocalMediaStreamToPeerConnection()
                
                
                //^^^^^^^^^^^^^^^^^^^^^^^newwwwww self.pc.addStream(self.getLocalMediaStream())
                otherID=msg[0]["by"].int!
                currentID=msg[0]["to"].int!
                
                if(msg[0]["username"].description != username! && self.pc.remoteDescription == nil){
                var sessionDescription=RTCSessionDescription(type: msg[0]["type"].description, sdp: msg[0]["sdp"]["sdp"].description)
                self.pc.setRemoteDescriptionWithDelegate(self, sessionDescription: sessionDescription)
                }
                */
                }
                
                if(msg[0]["type"].string! == "answer" && msg[0]["by"].int != currentID)
                {
                /*
                if(isInitiator.description == "true" && self.pc.remoteDescription == nil)
                {print("answer received")
                var sessionDescription=RTCSessionDescription(type: msg[0]["type"].description, sdp: msg[0]["sdp"]["sdp"].description)
                self.pc.setRemoteDescriptionWithDelegate(self, sessionDescription: sessionDescription)
                }
                */
                
                }
                if(msg[0]["type"].string! == "ice")
                {print("ice received of other peer")
                /* if(msg[0]["ice"].description=="null")
                {print("last ice as null so ignore")}
                else{
                if(msg[0]["by"].intValue != currentID)
                {var iceCandidate=RTCICECandidate(mid: msg[0]["ice"]["sdpMid"].description, index: msg[0]["ice"]["sdpMLineIndex"].int!, sdp: msg[0]["ice"]["candidate"].description)
                print(iceCandidate.description)
                
                if(self.pc.localDescription != nil && self.pc.remoteDescription != nil)
                
                {var addedcandidate=self.pc.addICECandidate(iceCandidate)
                print("ice candidate added \(addedcandidate)")
                }
                
                }
                }*/
                
                }
                
                */
                
                
            }
            
            
            
            
            ///////////////////////
            /////////////////////////////////////
            socketObj.socket.on("peer.connected"){data,ack in
                print("received peer.connected obj from server")
                self.delegateWebRTC.socketReceivedOtherWebRTC("peer.connected", data: data)
                
                //Both joined same room
                /*
                var datajson=JSON(data!)
                print(datajson.debugDescription)
                
                if(datajson[0]["username"].description != username!){
                otherID=datajson[0]["id"].int
                iamincallWith=datajson[0]["username"].description
                isInitiator=true
                iamincallWith = datajson[0]["username"].description
                
                
                //////optional
                if(self.pc == nil) //^^^^^^^^^^^^^^^^^^newwww tryyy
                {                         self.createPeerConnectionObject()
                }
                
                self.addLocalMediaStreamToPeerConnection()
                //^^^^^^^^^^^^^^^^^^newwwww self.pc.addStream(self.rtcLocalMediaStream)
                print("peer attached stream")
                
                
                self.pc.createOfferWithDelegate(self, constraints: self.rtcMediaConst!)
                }
                
                */
            }
            
            socketObj.socket.on("conference.stream"){data,ack in
                
                print("received conference.stream obj from server")
                self.delegateWebRTC.socketReceivedOtherWebRTC("conference.stream", data: data)
                var datajson=JSON(data)
                print(datajson.debugDescription)
                /*if(datajson[0]["username"].debugDescription != username! && datajson[0]["type"].debugDescription == "video" && self.rtcVideoTrackReceived != nil)
                {
                print("toggle remote video stream")
                ////////////self.rtcVideoTrackReceived.setEnabled((datajson[0]["action"].bool!))
                if(datajson[0]["action"].bool! == false)
                {
                self.localView.hidden=true
                self.remoteView.hidden=true
                }
                if(datajson[0]["action"].bool! == true)
                {
                self.localView.hidden=true
                self.remoteView.hidden=false
                }
                }
                
                */
                
            }
            
            socketObj.socket.on("peer.stream"){data,ack in
                print("received peer.stream obj from server")
                var datajson=JSON(data)
                print(datajson.debugDescription)
                
            }
            socketObj.socket.on("peer.disconnected"){data,ack in
                print("received peer.disconnected obj from server")
                var datajson=JSON(data)
                print(datajson.debugDescription)
                
                self.delegateWebRTC.socketReceivedOtherWebRTC("peer.disconnected", data: data)
                
            }
            
            
            
            
            socketObj.socket.on("message"){data,ack in
                print("received messageee101")
                
                
                
                if(self.delegateWebRTC != nil){
                    print("insidee hereeee")
                    self.delegateWebRTC.socketReceivedMessageWebRTC("message",data: data)
                    var msg=JSON(data)
                    print(msg.debugDescription)

                //socketReceivedMessage
                if(msg[0]["type"]=="room_name")
                {
                    /*
                    ////////////////////////////////////////////////////////////////
                    //////////////^^^^^^^^^^^^^^^^^^^^^^newww isInitiator=false
                    //What to do if already in a room??
                    
                    if(joinedRoomInCall=="")
                    {
                    var CurrentRoomName=msg[0]["room"].string!
                    print("got room name as \(joinedRoomInCall)")
                    print("trying to join room")
                    
                    socketObj.socket.emitWithAck("init", ["room":CurrentRoomName,"username":username!])(timeout: 1500000000) {data in
                    print("room joined got ack")
                    var a=JSON(data!)
                    print(a.debugDescription)
                    currentID=a[1].int!
                    joinedRoomInCall=msg[0]["room"].string!
                    print("current id is \(currentID)")
                    //}
                    }}
                    ////////////////////////newwwwwww
                    else
                    {
                    isInitiator = false
                    }
                    */
                }
                if(msg[0]=="Accept Call")
                {/*
                    if(joinedRoomInCall == "")
                    {
                    print("inside accept call")
                    var roomname=self.randomStringWithLength(9)
                    //iamincallWith=username!
                    self.areYouFreeForCall=false
                    joinedRoomInCall=roomname as String
                    socketObj.socket.emitWithAck("init", ["room":joinedRoomInCall,"username":username!])(timeout: 150000000) {data in
                    print("room joined by got ack")
                    var a=JSON(data!)
                    print(a.debugDescription)
                    currentID=a[1].int!
                    print("current id is \(currentID)")
                    var aa=JSON(["msg":["type":"room_name","room":roomname as String],"room":globalroom,"to":iamincallWith!,"username":username!])
                    print(aa.description)
                    socketObj.socket.emit("message",aa.object)
                    
                    }//end data
                    }*/
                    
                    
                }
                if(msg[0]=="Reject Call")
                {
                    /*
                    print("inside reject call")
                    var roomname=""
                    iamincallWith=""
                    self.areYouFreeForCall=true
                    callerName=""
                    joinedRoomInCall=""
                    if(self.pc != nil)
                    {self.pc.close()}
                    self.dismissViewControllerAnimated(true, completion: nil)
                    */
                    
                }
                
                
                if(msg[0]=="hangup")
                {
                    /*if(self.pc != nil)
                    {
                    print("hangupppppp received \(msg[0])")
                    
                    print("hangupppppp received \(msg.debugDescription)")
                    self.remoteDisconnected()
                    
                    
                    socketObj.socket.emit("leave",["room":joinedRoomInCall])
                    self.disconnect()
                    }*/
                    
                }
                
                /*if(msg[0]["type"]=="Missed")
                {
                let todoItem = NotificationItem(otherUserName: "\(iamincallWith!)", message: "You have received a missed call", type: "missed call", UUID: "111", deadline: NSDate())
                notificationsMainClass.sharedInstance.addItem(todoItem) // schedule a local notification to persist this item
                
                }
                */
                
                
                
                
            }//end if Accept call
            }//end if "messages"
            
            
            
            //----------------
            //-Webmeeting handlers start here
            //-----------------
            socketObj.socket.on("msgAudio"){data,ack in
                
                self.delegateWebRTC.socketReceivedMSGWebRTC("msgAudio", data: data)
                
                print("msgAudio reeived.. check if offer answer or ice")
 
                
                
            }
            
           /* socketObj.socket.on("msgVideo"){data,ack in
            
                self.delegateWebRTC.socketReceivedMSGWebRTC("msgVideo", data: data)
                
                print("msgVideo reeived.. check if offer answer or ice")
                
                
                
            }*/
            
            
            socketObj.socket.on("peer.connected.new"){data,ack in
                print("received peer.connected.new obj from server")
                self.delegateWebRTC.socketReceivedOtherWebRTC("peer.connected.new", data: data)
                
                //Both joined same room
            }
            
            socketObj.socket.on("conference.stream"){data,ack in
                
                print("received conference.stream obj from server")
                self.delegateWebRTC.socketReceivedOtherWebRTC("conference.stream", data: data)
                
            }
            /*socketObj.socket.on("conference.streamVideo"){data,ack in
                
                print("received conference.streamVideo obj from server")
                self.delegateWebRTC.socketReceivedOtherWebRTC("conference.streamVideo", data: data)
                
            }*/
            
            /*socketObj.socket.on("peer.stream"){data,ack in
                print("received peer.stream obj from server")
                var datajson=JSON(data)
                print(datajson.debugDescription)
                
            }
*/
            socketObj.socket.on("peer.disconnected.new"){data,ack in
                print("received peer.disconnected obj from server")
                var datajson=JSON(data)
                print(datajson.debugDescription)
                
                self.delegateWebRTC.socketReceivedOtherWebRTC("peer.disconnected.new", data: data)
                
            }
            
            /* ////////////////
            socketObj.socket.on("message"){data,ack in
                print("received messageee22")
                var msg=JSON(data)
                if(msg[0].description != "Accept Call")
                {
                    if(self.delegateWebRTC != nil)
{
                self.delegateWebRTC.socketReceivedMessageWebRTC("message",data: data)
                }
}
                else
                {
                    /////// *** may 2016 neww self.delegate?.socketReceivedMessage("Accept Call",data: data)

}
                
                
            }
            
            */
            
            socketObj.socket.on("conference.chat"){data,ack in
                print("chat received")
                print("\(data)")
                var chat=JSON(data)
                print(JSON(data))
                ///self.delegateChat=WebmeetingChatViewController
                print(chat[0]["message"].description)
                print(chat[0]["phone"].description)
                print(chat[0]["message"].string)
                print(chat[0]["phone"].string)
                //self.receivedChatMessage(chat[0]["message"].description,username: "\(chat[0]["username"].description)")
                
                webMeetingModel.addChatMsg(chat[0]["message"].description, usr: chat[0]["phone"].description)
                //webMeetingModel.delegateWebmeetingChat.receivedChatMessageUpdateUI(chat[0]["message"].description, username: chat[0]["username"].description)
                //self.delegateWebRTC.socketReceivedOtherWebRTC("conference.chat",data: data)
                
                
                
            }

            //conference.streamVideo
        }
    
    
    
    func addWebRTCHandlersVideo()
    {
        
        socketObj.socket.on("msgVideo"){data,ack in
            
           // self.delegateWebRTCVideo.socketReceivedMSGWebRTCVideo("msgVideo", data: data)
            
            print("msgVideo reeived.. check if offer answer or ice")
            
            
            
        }
        
        
        socketObj.socket.on("peer.connected.new"){data,ack in
            print("received peer.connected.new obj from server")
            //self.delegateWebRTCVideo.socketReceivedOtherWebRTCVideo("peer.connected.new", data: data)
            
            //Both joined same room
        }
        
       
        socketObj.socket.on("conference.streamVideo"){data,ack in
            
            print("received conference.streamVideo obj from server")
            //self.delegateWebRTCVideo.socketReceivedOtherWebRTCVideo("conference.streamVideo", data: data)
            
        }
        
        /*socketObj.socket.on("peer.stream"){data,ack in
        print("received peer.stream obj from server")
        var datajson=JSON(data)
        print(datajson.debugDescription)
        
        }
        */
        socketObj.socket.on("peer.disconnected.new"){data,ack in
            print("received peer.disconnected obj from server")
            var datajson=JSON(data)
            print(datajson.debugDescription)
            
           // self.delegateWebRTCVideo.socketReceivedOtherWebRTCVideo("peer.disconnected.new", data: data)
            
        }
      
        //conference.streamVideo
    }


    func getSocket()->SocketIOClient {
        return self.socket
    }
    
    func registerWithRoomId(roomId:NSString,clientId:NSString)
    {
        
    }
    func sendMessage(msg:String,para:[AnyObject]!)
    {
        socket.emit(msg, para)
        print("Socket emitted \(msg) \(para.debugDescription)", terminator: "")
        //ChatAppSocketDelegate.channel(socket,didReceiveMessage:msg)
}
    
    
    func sendMessagesOfMessageType(msg:String)
    {
        print("inside sendMessagesOfMessageType func \(msg)", terminator: "")
        //var str=msg
        //str = msg.stringByReplacingOccurrencesOfString("\\", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
        print(msg, terminator: "")
        //var message:JSON=["msg":msg,"room":globalroom,"to":iamincallWith!,"username":username!]
        
        socket.emit("message",["msg":msg,"room":globalroom,"to":iamincallWith!,"phone":username!])
        
        //////////socket.emit("message",["msgAudio":msg,"room":globalroom,"to":iamincallWith!,"username":username!])
        
    }
    
    func fetchChatsFromServer()
    {
        
        
        let uniqueid = Expression<String>("uniqueid")
        let file_name = Expression<String>("file_name")
         let type = Expression<String>("type")
        let from = Expression<String>("from")
                 let phone = Expression<String>("phone")
        
        let contactPhone = Expression<String>("contactPhone")
         let date = Expression<NSDate>("date")
        //contactPhone
        
        //%%%%%% fetch chat
        
        //dispatch_async(dispatch_get_global_queue(priority, 0)) {
        //self.progressBarDisplayer("Setting Conversations", true)
        print("\(username) is Fetching chat")
        socketObj.socket.emit("logClient","\(username) is Fetching chat")
        var fetchChatURL=Constants.MainUrl+Constants.fetchMyAllchats
        //var getUserDataURL=userDataUrl
        
        //  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND,0))
        //    {
        
        //QOS_CLASS_USER_INTERACTIVE
        let queue2 = dispatch_queue_create("com.cnoon.manager-response-queue", DISPATCH_QUEUE_CONCURRENT)
        let qqq=dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0)
        let request = Alamofire.request(.POST, "\(fetchChatURL)", parameters: ["user1":username!], headers:header)
        request.response(
        queue: queue2,
        responseSerializer: Request.JSONResponseSerializer(),
        completionHandler: { response in
        // You are now running on the concurrent `queue` you created earlier.
        print("Parsing JSON on thread: \(NSThread.currentThread()) is main thread: \(NSThread.isMainThread())")
        
        // Validate your JSON response and convert into model objects if necessary
        //print(response)
        //print(response.result.value)
        
        
        switch response.result {
        case .Success:
        
        print("All chat fetched success")
        socketObj.socket.emit("logClient", "All chat fetched success")
        if let data1 = response.result.value {
        let UserchatJson = JSON(data1)
        // print("chat fetched JSON: \(json)")
        
        var tableUserChatSQLite=sqliteDB.userschats
        
        do{
        try sqliteDB.db.run(tableUserChatSQLite.delete())
        }catch{
        socketObj.socket.emit("logClient","sqlite chat table refreshed")
        print("chat table not deleted")
        }
        
        //Overwrite sqlite db
        //sqliteDB.deleteChat(self.selectedContact)
        
        socketObj.socket.emit("logClient","IPHONE-LOG: all chat messages count is \(UserchatJson["msg"].count)")
        for var i=0;i<UserchatJson["msg"].count
        ;i++
        {
            
           // var isFile=false
            var chattype="chat"
            var file_type=""
            //UserchatJson["msg"][i]["date"].string!
            
            
            
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            let datens2 = dateFormatter.dateFromString(UserchatJson["msg"][i]["date"].string!)
            
            
            
            let formatter = NSDateFormatter()
            formatter.dateFormat = "MM/dd, HH:mm";
           // formatter.dateStyle = NSDateFormatterStyle.ShortStyle
            //formatter.timeStyle = .ShortStyle
            
            let dateString = formatter.stringFromDate(datens2!)
            
            if(UserchatJson["msg"][i]["type"].isExists())
            {
                chattype=UserchatJson["msg"][i]["type"].string!
            }
            
            if(UserchatJson["msg"][i]["file_type"].isExists())
            {
                file_type=UserchatJson["msg"][i]["file_type"].string!
            }
        
        if(UserchatJson["msg"][i]["uniqueid"].isExists())
        {
            
           /* let tbl_files=sqliteDB.files;
            do{
                
                
                for tblFiles in try sqliteDB.db.prepare(tbl_files.filter(uniqueid==UserchatJson["msg"][i]["uniqueid"].string!/*,from==username!*/)){
                    isFile=true
                    chattype=tblFiles[type]
                    
                    print("File exists in file table \(file_name)")
                 /////   socketObj.socket.emit("logClient","IPHONE LOG: \(username!) File exists in file table \(tblFiles[file_name])")


                    /*print(tblContacts[to])
                     print(tblContacts[from])
                     print(tblContacts[msg])
                     print(tblContacts[date])
                     print(tblContacts[status])
                     print("--------")
                     */
                    /*if(tblContacts[from]==selecteduser
                     
                     ){}*/
                }
            }
            catch
            {
                print("error in checking files table")
            }
            */
            
        if(UserchatJson["msg"][i]["to"].string! == username! && UserchatJson["msg"][i]["status"].string!=="sent")
        {
        var updatedStatus="delivered"
            
           
        sqliteDB.SaveChat(UserchatJson["msg"][i]["to"].string!, from1: UserchatJson["msg"][i]["from"].string!,owneruser1:UserchatJson["msg"][i]["owneruser"].string! , fromFullName1: UserchatJson["msg"][i]["fromFullName"].string!, msg1: UserchatJson["msg"][i]["msg"].string!,date1:dateString,uniqueid1:UserchatJson["msg"][i]["uniqueid"].string!,status1: updatedStatus, type1: chattype, file_type1: file_type,file_path1: "" )
        
        //socketObj.socket.emit("messageStatusUpdate",["status":"","iniqueid":"","sender":""])
        socketObj.socket.emitWithAck("messageStatusUpdate", ["status":updatedStatus,"uniqueid":UserchatJson["msg"][i]["uniqueid"].string!,"sender": UserchatJson["msg"][i]["from"].string!])(timeoutAfter: 0){data in
        var chatmsg=JSON(data)
        print(data[0])
        print(chatmsg[0])
        print("chat status emitted")
        socketObj.socket.emit("logClient","\(username) chat status emitted")
            
        }
        
        
        
        }
        else
        {
        
            sqliteDB.SaveChat(UserchatJson["msg"][i]["to"].string!, from1: UserchatJson["msg"][i]["from"].string!,owneruser1:UserchatJson["msg"][i]["owneruser"].string! , fromFullName1: UserchatJson["msg"][i]["fromFullName"].string!, msg1: UserchatJson["msg"][i]["msg"].string!,date1:dateString,uniqueid1:UserchatJson["msg"][i]["uniqueid"].string!,status1: UserchatJson["msg"][i]["status"].string!, type1: chattype, file_type1: file_type,file_path1: "" )

        }
        }
        else
        {
            sqliteDB.SaveChat(UserchatJson["msg"][i]["to"].string!, from1: UserchatJson["msg"][i]["from"].string!,owneruser1:UserchatJson["msg"][i]["owneruser"].string! , fromFullName1: UserchatJson["msg"][i]["fromFullName"].string!, msg1: UserchatJson["msg"][i]["msg"].string!,date1:dateString,uniqueid1:"",status1: "",type1: chattype, file_type1: file_type,file_path1: "" )

        }
        
                }
            
            
            
          /*  let tbl_userchats=sqliteDB.userschats
            let tbl_contactslists=sqliteDB.contactslists
            let tbl_allcontacts=sqliteDB.allcontacts
            
            let myquery=tbl_contactslists.join(tbl_userchats, on: tbl_contactslists[phone] == tbl_userchats[contactPhone]).group(tbl_userchats[contactPhone]).order(date.desc)
            
            var queryruncount=0
            do{for ccc in try sqliteDB.db.prepare(myquery) {
                
                print("checking pending files from \(ccc[contactPhone])")
                managerFile.checkPendingFiles(ccc[contactPhone])
                
                
                }
            }
            catch{
                print("error 1232")
            }*/
           /////// managerFile.checkPendingFiles(username!)

           //////// dispatch_async(dispatch_get_main_queue()) {
            
            
            
            
            //------CHECK IF ANY PENDING FILES--------
            
            
            if(self.delegateChat != nil)
            {
            self.delegateChat?.socketReceivedMessageChat("updateUI", data: nil)
            }
                if(self.delegate != nil)
{
                self.delegate?.socketReceivedMessage("updateUI", data: nil)
}
           ///////// }
            print("all fetched chats saved in sqlite success")
   
        
        
        }
        
        
        /////return completion(result: true)
        case .Failure:
        socketObj.socket.emit("logClient", "All chat fetched failed")
        print("all chat fetched failed")
        }
        // }
        
        
        // To update anything on the main thread, just jump back on like so.
        ///  dispatch_async(dispatch_get_main_queue()) {
        ///      print("Am I back on the main thread: \(NSThread.isMainThread())")
        /// }
        }
        )


    }
    
    
    
    
    
    func sendPendingChatMessages(completion:(result:Bool)->())
    {
        print("checkin here inside pending chat messages.....")
        var userchats=sqliteDB.userschats
        var userchatsArray:Array<Row>
        
        
        
        let to = Expression<String>("to")
        let from = Expression<String>("from")
        let owneruser = Expression<String>("owneruser")
        let fromFullName = Expression<String>("fromFullName")
        let msg = Expression<String>("msg")
        let date = Expression<String>("date")
        let status = Expression<String>("status")
        let uniqueid = Expression<String>("uniqueid")
        let type = Expression<String>("type")
        let file_type = Expression<String>("file_type")
        

        
        
        var tbl_userchats=sqliteDB.userschats
        //var res=tbl_userchats.filter(to==selecteduser || from==selecteduser)
        //to==selecteduser || from==selecteduser
        //print("chat from sqlite is")
        //print(res)
        do
        {
            var count=0
            for pendingchats in try sqliteDB.db.prepare(tbl_userchats.filter(status=="pending"))
            {
                print("pending chats count is \(count)")
                count++
                var imParas=["from":pendingchats[from],"to":pendingchats[to],"fromFullName":pendingchats[fromFullName],"msg":pendingchats[msg],"uniqueid":pendingchats[uniqueid],"type":pendingchats[type],"file_type":pendingchats[file_type]]
                
                print("imparas are \(imParas)")
                print(imParas, terminator: "")
                print("", terminator: "")
                ///=== code for sending chat here
                ///=================
                
                //socketObj.socket.emit("logClient","IPHONE-LOG: \(username!) is sending chat message")
                //////socketObj.socket.emit("im",["room":"globalchatroom","stanza":imParas])
                // var statusNow=""
                /* if(isSocketConnected==true)
                {
                statusNow="sent"
                
                }
                else
                {
                statusNow="pending"
                }
                */
                // statusNow="pending"
                
                //sqliteDB.SaveChat(pendingchats[to], from1:pendingchats[from],owneruser1: pendingchats[from], fromFullName1: pendingchats[fromFullName], msg1:pendingchats[msg],date1: nil,uniqueid1: pendingchats[uniqueid], status1: statusNow)
                
                
                socketObj.socket.emitWithAck("im",["room":"globalchatroom","stanza":imParas])(timeoutAfter: 1500000)
                    {data in
                        print("chat ack received \(data)")
                        // statusNow="sent"
                        var chatmsg=JSON(data)
                        print(data[0])
                        print(chatmsg[0])
                        sqliteDB.UpdateChatStatus(chatmsg[0]["uniqueid"].string!, newstatus: chatmsg[0]["status"].string!)
                        
                }
                
                
                
                
                
            }
            socketObj.socket.emit("logClient","IPHONE-LOG: \(username!) done sending pending chat messages")
            return completion(result: true)
            //// return completion(result: true)
        }
        catch
        {
            print("error in pending chat fetching")
            socketObj.socket.emit("logClient","IPHONE-LOG: \(username!) error in sending pending chat messages")
            return completion(result: false)
        }
        
        
    }
    
    
    
    
    func fetchSingleChatMessage(uniqueid:String)
    {
        print("uniqueid of single chat is \(uniqueid)")
        
        //======GETTING REST API TO GET CURRENT USER=======================
        
        print("inside fetch single chat")
        if(accountKit == nil){
            accountKit = AKFAccountKit(responseType: AKFResponseType.AccessToken)
        }
        
        if (accountKit!.currentAccessToken == nil) {
            
            print("inside etch single 1462")
            //specify AKFResponseType.AccessToken
            accountKit = AKFAccountKit(responseType: AKFResponseType.AccessToken)
            accountKit.requestAccount{
                (account, error) -> Void in
                
                
                
                
                //**********
                
                if(account != nil){
                    var url=Constants.MainUrl+Constants.getContactsList
                    
                    let header:[String:String]=["kibo-token":(accountKit!.currentAccessToken!.tokenString)]
                    
                    
                }
                
                }
            }
        var fetchSingleMsgURL=Constants.MainUrl+Constants.fetchSingleChat
        
        
        //var getUserDataURL=userDataUrl
        
        Alamofire.request(.POST,"\(fetchSingleMsgURL)",parameters: ["uniqueid":uniqueid],headers:header).validate(statusCode: 200..<300).responseJSON{response in
            
            
            switch response.result {
            case .Success:
                if let data1 = response.result.value {
                    let json = JSON(data1)
                    print("JSON single chat: \(json)")
                    print(";;;;")
                    print("JSON single chat: \(json["msg"])")
                    print("''''''")
                    print("JSON single chat to is: \(json["msg"][0]["to"])")
                    //print(response.description)
                   // print(JSON(response.data!).description)
                    
                }
            case .Failure:
                print("failed to get seingle chat message")
            }
        }

        }
    
    
    }//Unique Chat data sent to client

protocol UpdateChatDelegate:class
{
     func socketReceivedMessageChat(message:String,data:AnyObject!);
}

protocol ChatAppSocketDelegate
{
    func channel(channel:SocketIOClient ,didChangeState state:ChatAppSocketChannelState);
     func channel(channel:SocketIOClient,didReceiveMessage message:String);
    //socket.on(message
   
}
protocol SocketClientDelegate:class
{
    func socketReceivedMessage(message:String,data:AnyObject!);
    func socketReceivedSpecialMessage(message:String,params:JSON!)
    
    /*
    
    func appClient(client:ChatAppClient,didChangeState state:ChatAppClientState);
    func appClient(client:ChatAppClient,didReceiveLocalVideoTrack localVideoTrack:RTCVideoTrack);
    func appClient(client:ChatAppClient,didReceiveRemoteVideoTrack remoteVideoTrack:RTCVideoTrack);
    func appClient(client:ChatAppClient,didError error:NSError);
    
    //func game(game: DiceGame, didStartNewTurnWithDiceRoll diceRoll: Int)
    */
}
protocol SocketClientDelegateWebRTC:class
{
    func socketReceivedMSGWebRTC(message:String,data:AnyObject!);
    func socketReceivedOtherWebRTC(message:String,data:AnyObject!);
    func socketReceivedMessageWebRTC(message:String,data:AnyObject!);
    
    
}

protocol SocketClientDelegateWebRTCVideo:class
{
    func socketReceivedMSGWebRTCVideo(message:String,data:AnyObject!);
    func socketReceivedOtherWebRTCVideo(message:String,data:AnyObject!);
    func socketReceivedMessageWebRTCVideo(message:String,data:AnyObject!);
    
    
}
protocol SocketConnecting:class
{
    func socketConnected();
}
