

**Discussion about iOS background Notifications (APNS)**
----------------------------------------------------

Here is the discussion deck for iOs background notifications:

https://docs.google.com/a/cloudkibo.com/presentation/d/1WRWP_KhPuqdt_Cf9ArMOgHzxNg--mMWJ_jR22X7Q1PE/edit?usp=sharing

Here are some links:

https://developer.apple.com/library/ios/documentation/NetworkingInternet/Conceptual/RemoteNotificationsPG/Chapters/ApplePushService.html

https://developer.apple.com/library/ios/documentation/iPhone/Conceptual/iPhoneOSProgrammingGuide/BackgroundExecution/BackgroundExecution.html

http://pierremarcairoldi.com/ios-8-voip-notifications/


**Is there a comparable service on Android from Google?**
It is called Google Cloud Messaging (GCM). There are many debates in community over use of socket.io vs use of GCM.

GCM is like Apple's push notification is only push technology. It would send messages from server to client. But client won't be able to send messages to server using this technology. Push notifications are uni-directional and sockets are bi-directional.

So, we should not replace socket.io completely with Apple notifications. Else, we would lose the way to send messages from client to server in real-time. Sumaira and I are having some discussion on it.

Android is not being affected by this problem as in android services can run in background. There are few cases when services are closed by OS (i.e. battery is low). Else they are running and our socket.io is running in background on Android.

**How are messages handled when the app is in the background?**

We have a background service which runs and carries the socket.io. When app is in background, this services keeps running.

**Please send me links on how notification is handled on Android.**

There are several ways to handle notifications. Some people use websockets. Some use socket.io. Some of them use GCM. Others use Pushy. There are several push notification services available. We use socket.io instead. I just saw some long debates on which should we use. Socket.io, websockets or GCM. However, GCM, like Apple push notifications, has one demerit. It is unidirectional. Client can't send messages or updates to server in real-time.

Some people also thought to use both GCM and socket.io together. For iOS, this would be ideal option that sumaira uses Apple Push Notifications and socket.io together. APNs will wake the socket.io. These are some initial thoughts. We are discussing more and will come back on this.

------------------------------------------------------------------------
Here are some links:

We would need some nodejs library like this on our server which would connect to GCM, APN or other push notification services:

https://www.npmjs.com/package/xpush

This is Pushy, a push notification service for Android:

https://eladnava.com/pushy-a-new-alternative-to-google-cloud-messaging/

This is other push notification service from AWS:

http://aws.amazon.com/sns/

PubNub is another push notification gateway:

https://www.pubnub.com/docs/android-java/mobile-gateway#_using_pubnub_native_push_notifications

Finally, here is the link for GCM. GCM is free and works for both Android and iOS. The APN by apple might not work for android. All other push notifications services work for both iOS and android:

https://developers.google.com/cloud-messaging/

All of these have one requirement. It is that we would have to connect our server to their server. Just like facebook connect api, we connect to facebook servers for SMS, similarly, here we would connect to these servers.

Here are some other links I found:

http://stackoverflow.com/questions/35637353/push-notifications-or-socket-io-or-both

http://stackoverflow.com/questions/15617615/websockets-versus-gcm-under-android-battery-usage

https://eladnava.com/google-cloud-messaging-extremely-unreliable/

Personally, I would suggest that we should strive to complete v1 by end of June. This would change entire structure of our application. We should be very picky in choosing the service. The APN by apple might be costly and may work only for iOS. The GCM is free and will work for iOS, Android and chrome.
Note, these are initial thoughts. After Iftar time, I would discuss with sumaira.

GCM however is two-way. They are talking about combination with XMPP. Here is the article for how to send message from client to server.

https://developers.google.com/cloud-messaging/upstream#sending_an_ack_message

I will have to read the above article carefully but it shows there is possibility.

We don't use XMPP and use socket.io instead. People are also using socket.io with GCM.

http://stackoverflow.com/questions/27051864/chat-algorithm-with-websockets-and-gcm

https://www.learn2crack.com/2016/05/gcm-push-notification-server-node-js-mongodb.html

--------------------------------------------------------------

Here are the answers:

**1- Is this new notification you can send a message also? So we can attach**
txt or images with it. Correct?*
          No. In iOS 8 and later, the notification payload can be up to  2
kilobytes long. We can send a URL from which the image can be
downloaded within the app.

**2- This notification will work regardless if the phone is in background
mode or in non-background mode**
               Yes

**3- I am assuming notification is only for server to client? How will
messages be sent from client to server?**
              Yes. We need to use some other mechanism for sending messages
to server . e.g. socket . Notification will wake up application and socket
will become active. We can then use socket for sending messages to server.

**4- Is there a difference between notification or sending a message from server to client?**
              The difference is that push notifications will wake up
application from background or suspended mode also.

**5- It appears notifications are sent via Apple Cloud. Is there a size
limit?**
                In iOS 8 and later, the notification payload can be up to  2
kilobytes long. Only one recent notification for a particular app is
stored. If multiple notifications are sent while the device is offline, the
new notification causes the prior notification to be discarded

**6- When the notification is sent, and the client is not available the
notification will be lost. Correct? So it up to the server to resend the
notification. Correct?**
               When device is offline, the notification is stored for a
limited period of time, and delivered to the device when it becomes
available.

------------------------------------