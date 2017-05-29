//
//  StatusPhotoViewController.swift
//  kiboApp
//
//  Created by Cloudkibo on 26/05/2017.
//  Copyright © 2017 MyAppTemplates. All rights reserved.
//

import UIKit

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

class StatusPhotoViewController: UIViewController,UIImagePickerControllerDelegate {
    
    var image:UIImage!
    var imgcaption=""
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    private var backgroundImage: UIImage
    
    init(image: UIImage) {
        self.image=image
        self.backgroundImage = image
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.gray
        let backgroundImageView = UIImageView(frame: view.frame)
        backgroundImageView.contentMode = UIViewContentMode.scaleAspectFit
        backgroundImageView.image = backgroundImage
        view.addSubview(backgroundImageView)
        let cancelButton = UIButton(frame: CGRect(x: 10.0, y: 10.0, width: 30.0, height: 30.0))
        cancelButton.setImage(#imageLiteral(resourceName: "cancel"), for: UIControlState())
        cancelButton.addTarget(self, action: #selector(cancel), for: .touchUpInside)
        view.addSubview(cancelButton)
        //==--let cancelButton = UIButton(frame: CGRect(x: 10.0, y: 10.0, width: 30.0, height: 30.0))
       /*let captionfield=UITextView.init(frame: CGRect(x: 50.0, y: view.frame.height - 50.0, width: 200.0, height: 30.0))
        //==--view.addSubview(captionfield)
        
        //==--let sendButton = UIButton(frame: CGRect(x: captionfield.frame.origin.x+300+20, y: captionfield.frame.origin.y, width: 30.0, height: 30.0))
         let sendButton = UIButton(frame: CGRect(x: 150, y: captionfield.frame.origin.y, width: 30.0, height: 30.0))
        sendButton.setImage(#imageLiteral(resourceName: "send"), for: UIControlState())
        sendButton.addTarget(self, action: #selector(cancel), for: .touchUpInside)
        view.addSubview(sendButton)
        */
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
            
            self.imgcaption=textField.text!
            var uniqueid=UtilityFunctions.init().generateUniqueid()
            let dirPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
            let docsDir1 = dirPaths[0]
            var documentDir=docsDir1 as NSString
            var filename=uniqueid+"."+"png"
            var filePathVideo=documentDir.appendingPathComponent(uniqueid+"."+"png")
            var fm=FileManager.default
            var fileExtension="."+"png"
            var fileAttributes:[String:AnyObject]=["":"" as AnyObject]
            
            //!!var s=fm.createFile(atPath: filePathImage2, contents: nil, attributes: nil)
            
            //  var written=fileData!.writeToFile(filePathImage2, atomically: false)
            
            //filePathImage2
            do{var data=try UIImagePNGRepresentation(self.image)
                
                var filesize=data?.count
                
                try? data?.write(to: URL(fileURLWithPath: filePathVideo), options: [.atomic])
                
                UtilityFunctions.init().log_papertrail("IPHONE-LOG: \(username!) is uploading video captured, saved file")
                // data!.writeToFile(localPath.absoluteString, atomically: true)
                var uniqueID=UtilityFunctions.init().generateUniqueid()
                print("uniqueid video is \(uniqueID)")
                var statusNow="pending"
                
                // var imParas=["from":"\(username!)","to":"\(self.selectedContact)","fromFullName":"\(displayname)","msg":self.filename,"uniqueid":uniqueID,"type":"file","file_type":"video","status":statusNow]
                //print("imparas are \(imParas)")
                
                
                //------
                
                //SPECIAL
                sqliteDB.saveFile("all", from1: username!, owneruser1: username!, file_name1:filename, date1: nil, uniqueid1: uniqueID, file_size1: "\(filesize)", file_type1: uniqueID, file_path1: filePathVideo, type1: "day_status",caption1:self.imgcaption)
                
                //==--self.addUploadInfo(self.selectedContact,uniqueid1: uniqueID, rowindex: self.messages.count, uploadProgress: 0.0, isCompleted: false)
                
                //if(self.selectedContact != "")
                //{
                
                
                
                
                managerFile.uploadStatus(date1: Date.init(), uniqueid1: uniqueID, file_name1: filename, file_size1: filesize!.description, label1: self.imgcaption, file_type1: "png", uploadedBy1: username!, file_path1: filePathVideo)
                
                
            }
            catch{
                UtilityFunctions.init().log_papertrail("IPHONE-LOG: \(username) cannot write file \(error)")
                
                return
                //==--self.showError("Error".localized, message: "Unable to get video".localized, button1: "Ok".localized)
            }

            //!!self.imgCaption = textField.text!
            // let textField = alert.textFields![0] as UITextField
            
            //!!--self.imagePickerController(picker, didFinishPickingImage: (info[UIImagePickerControllerOriginalImage] as? UIImage)!, editingInfo: info as [String : AnyObject]?)
            
            //!!
            /*if(self.showKeyboard==true)
             {
             self.textFieldShouldReturn(textField)
             
             }*/
            self.dismiss(animated: true, completion: {
                
                
            })
            
            
            
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) -> Void in
            
         
        }))
        self.present(alert, animated: true, completion: {
        })
        
        
    }
    
    func cancel() {
        dismiss(animated: true, completion: nil)
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
