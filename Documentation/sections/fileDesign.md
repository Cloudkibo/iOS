## File sharing in Kibo App ##


The diagram below shows design logic for sending and receiving file:
![File Sending Flow](fileSend.png)


**File Management WatsApp Vs Kibo Chat**
Here is a comparison sheet of File Management features provided by Kibo Chat and WatsApp. It covers features for both sending and receiving files:

[File Management Comparison Sheet](https://drive.google.com/drive/u/1/folders/0ByXJY8WVZm-NZ3ZqUlhvT1pPTDg)


**Design Discussion**
Sumaira and I just had a discussion on how should we do the file transfer outside the call. There are two options that we have in.
1) In this, user will select the contact name and send the file to him. The receiver no matter wherever he is on the device will receive notification that user A wants to transfer file to you. User B accepts then file transfer will start in background (shown in notification) afterwards, it will show another notification that file transfer has been completed and stored in Downloads folder. This is what I have been doing on Android before for file transfer outside the call. The only difference is that previously there was no notification and it didn’t happen in background.

2) Sumaira wants to make it like whatsapp where file is shared and shown in the chat itself. In this the user sends the file and file is shown in the chat to receiver. Sometimes, if user is offline the file is stored on whatsapp server and is received when next time user comes online. This one is more like File sharing and not file transferring. This method will also increase the time as it will require a lot of work on the UI of current chat window.


The option that I am suggesting will be file transfer when both are online. It will use datachannel of file transfer. The option 2 is file sharing and will also require to have storage on server. It cannot be webrtc purely as webrtc does file transfer in real time i.e. when both sender and receiver are online and sending the file in real-time.
