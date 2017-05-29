//
//  StatusVideoViewController.swift
//  kiboApp
//
//  Created by Cloudkibo on 26/05/2017.
//  Copyright © 2017 MyAppTemplates. All rights reserved.
//

/*Copyright (c) 2016, Andrew Walz.
 
 Redistribution and use in source and binary forms, with or without modification,are permitted provided that the following conditions are met:
 
 1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 
 2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the
 documentation and/or other materials provided with the distribution.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
 THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS
 BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE
 GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE. */

import UIKit
import AVFoundation
import AVKit
import SwiftyCam
class StatusVideoViewController: UIViewController {
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    private var videoURL: URL
    var player: AVPlayer?
    var playerController : AVPlayerViewController?
    
    init(videoURL: URL) {
        self.videoURL = videoURL
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.gray
        player = AVPlayer(url: videoURL)
        playerController = AVPlayerViewController()
        
        guard player != nil && playerController != nil else {
            return
        }
        playerController!.showsPlaybackControls = true
        
        playerController!.player = player!
        self.addChildViewController(playerController!)
        self.view.addSubview(playerController!.view)
        playerController!.view.frame = view.frame
        NotificationCenter.default.addObserver(self, selector: #selector(playerItemDidReachEnd), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.player!.currentItem)
        
        let cancelButton = UIButton(frame: CGRect(x: 10.0, y: 10.0, width: 30.0, height: 30.0))
        cancelButton.setImage(#imageLiteral(resourceName: "cancel"), for: UIControlState())
        cancelButton.addTarget(self, action: #selector(cancel), for: .touchUpInside)
        //==--view.addSubview(cancelButton)
        let sendButton = UIButton(frame: CGRect(x: 220, y: 430, width: 30.0, height: 30.0))
        sendButton.setImage(#imageLiteral(resourceName: "send"), for: UIControlState())
        sendButton.addTarget(self, action: #selector(cancel), for: .touchUpInside)
        view.addSubview(sendButton)
        
        
        
        let captionfield=UIButton.init(frame: CGRect(x: 100.0, y: 430, width: 100.0, height: 30.0))
        //==--captionfield.setImage(#imageLiteral(resourceName: "chat_input_background"), for: UIControlState.normal)
        captionfield.titleLabel?.text="Add caption"
        //==--captionfield.backgroundColor = .green
        captionfield.setTitle("Add caption", for: UIControlState.normal)
        captionfield.addTarget(self, action: #selector(addcaptiontapped), for: .touchUpInside)
        
        view.addSubview(captionfield)
    }
    
    func addcaptiontapped()
    {
        let alert = UIAlertController(title: "Add caption".localized, message: "", preferredStyle: .alert)
        
        //2. Add the text field. You can configure it however you need.
        alert.addTextField(configurationHandler: { (textField) -> Void in
           //!! self.imgCaption = ""
            textField.text = ""
        })
        
        
        //3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "Send", style: .default, handler: { (action) -> Void in
            let textField = alert.textFields![0] as UITextField
            //!!self.imgCaption = textField.text!
            // let textField = alert.textFields![0] as UITextField
            
            //!!--self.imagePickerController(picker, didFinishPickingImage: (info[UIImagePickerControllerOriginalImage] as? UIImage)!, editingInfo: info as [String : AnyObject]?)
            
            //!!
            /*if(self.showKeyboard==true)
            {
                self.textFieldShouldReturn(textField)
                
            }*/
            
            
            
            
            
            print("extension is \(self.videoURL.pathExtension)")
            var uniqueid=UtilityFunctions.init().generateUniqueid()
            let dirPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
            let docsDir1 = dirPaths[0]
            var documentDir=docsDir1 as NSString
            var filePathVideo=documentDir.appendingPathComponent(uniqueid+self.videoURL.pathExtension)
            var fm=FileManager.default
            
            var fileAttributes:[String:AnyObject]=["":"" as AnyObject]
            
            //!!var s=fm.createFile(atPath: filePathImage2, contents: nil, attributes: nil)
            
            //  var written=fileData!.writeToFile(filePathImage2, atomically: false)
            
            //filePathImage2
           do{var data=try Data.init(contentsOf: self.videoURL)
                try? data.write(to: URL(fileURLWithPath: filePathVideo), options: [.atomic])
            UtilityFunctions.init().log_papertrail("IPHONE-LOG: \(username!) is uploading video captured, saved file")
                // data!.writeToFile(localPath.absoluteString, atomically: true)
            }
            catch{
                UtilityFunctions.init().log_papertrail("IPHONE-LOG: \(username) cannot write file \(error)")
                
                return
                //==--self.showError("Error".localized, message: "Unable to get video".localized, button1: "Ok".localized)
            }

            
            var uniqueID=UtilityFunctions.init().generateUniqueid()
            print("uniqueid video is \(uniqueID)")
            var statusNow="pending"
            
           // var imParas=["from":"\(username!)","to":"\(self.selectedContact)","fromFullName":"\(displayname)","msg":self.filename,"uniqueid":uniqueID,"type":"file","file_type":"video","status":statusNow]
            //print("imparas are \(imParas)")
            
            
            //------
            
            //SPECIAL
            sqliteDB.saveFile(self.selectedContact, from1: username!, owneruser1: username!, file_name1: self.filename, date1: nil, uniqueid1: uniqueID, file_size1: "\(self.fileSize1)", file_type1: uniqueID, file_path1: filePathVideo, type1: "day_status_chat",caption1:self.imgCaption)
            
            //==--self.addUploadInfo(self.selectedContact,uniqueid1: uniqueID, rowindex: self.messages.count, uploadProgress: 0.0, isCompleted: false)
            
            //if(self.selectedContact != "")
            //{
            
            
            
                
                managerFile.uploadFile(filePathImage2, to1: self.selectedContact, from1: username!, uniqueid1: uniqueID, file_name1: self.filename, file_size1: "\(self.fileSize1)", file_type1: ftype,type1:"video",label1:"")
           // }
            
            
            
            
            
            
            ///
           /* var uniqueID = UtilityFunctions.init().generateUniqueid()
            
            
            let dirPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
            let docsDir1 = dirPaths[0]
            let documentDir=docsDir1 as NSString
            let audioFilename =  documentDir.appendingPathComponent("\(uniqueID).m4a")

            */
            self.dismiss(animated: true, completion: {
                
                
            })
            
            
            
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) -> Void in
            
           
        }))
        self.present(alert, animated: true, completion: {
        })
     

    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //==--player?.play()
    }

    func cancel() {
        dismiss(animated: true, completion: nil)
    }

    @objc fileprivate func playerItemDidReachEnd(_ notification: Notification) {
        /*if self.player != nil {
            self.player!.seek(to: kCMTimeZero)
            self.player!.play()
        }*/
    }
}


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

//}
