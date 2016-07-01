Is there a comparable service on Android from Google?
It is called Google Cloud Messaging (GCM). There are many debates in community over use of socket.io vs use of GCM.

GCM is like Apple's push notification is only push technology. It would send messages from server to client. But client won't be able to send messages to server using this technology. Push notifications are uni-directional and sockets are bi-directional.

So, we should not replace socket.io completely with Apple notifications. Else, we would lose the way to send messages from client to server in real-time. Sumaira and I are having some discussion on it.

Android is not being affected by this problem as in android services can run in background. There are few cases when services are closed by OS (i.e. battery is low). Else they are running and our socket.io is running in background on Android.

How are messages handled when the app is in the background?

We have a background service which runs and carries the socket.io. When app is in background, this services keeps running.

Please send me links on how notification is handled on Android.

There are several ways to handle notifications. Some people use websockets. Some use socket.io. Some of them use GCM. Others use Pushy. There are several push notification services available. We use socket.io instead. I just saw some long debates on which should we use. Socket.io, websockets or GCM. However, GCM, like Apple push notifications, has one demerit. It is unidirectional. Client can't send messages or updates to server in real-time.

Some people also thought to use both GCM and socket.io together. For iOS, this would be ideal option that sumaira uses Apple Push Notifications and socket.io together. APNs will wake the socket.io. These are some initial thoughts. We are discussing more and will come back on this.