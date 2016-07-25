//
//  FileReceivedViewController.swift
//  Chat
//
//  Created by Cloudkibo on 01/03/2016.
//  Copyright © 2016 MyAppTemplates. All rights reserved.
//

import UIKit

class FileReceivedViewController: UIViewController,UIDocumentInteractionControllerDelegate,FileReceivedAlertDelegate {

    
    @IBOutlet weak var btnFilePreview: UIButton!
    var documentInteractionController:UIDocumentInteractionController!
    var delegateFileReceived:FileReceivedAlertDelegate!
    var fileURL:NSURL!
    var videoCont:VideoViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //videoCont=storyboard?.instantiateViewControllerWithIdentifier("MainV2") as! VideoViewController
        //videoCont.delegateFileReceived=self

        
        // Do any additional setup after loading the view.
        
    }

    override func viewWillAppear(animated: Bool) {
        
        //videoCont=storyboard?.instantiateViewControllerWithIdentifier("MainV2") as! VideoViewController
        //videoCont.delegateFileReceived=self
        
    }
    //var documentInteractionController = UIDocumentInteractionController().delegate=self
    
    
    @IBAction func btn_backPressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true) { () -> Void in
            
            
        }
    }
    
    
    func saveToiCloud()
    
    {
        
        
           let filemgr = NSFileManager.init()
        var ubiquityURL=filemgr.URLForUbiquityContainerIdentifier("iCloud.iCloud.MyAppTemplates.cloudkibo")
        
        print("number 1 is \(ubiquityURL)")
        ubiquityURL=ubiquityURL!.URLByAppendingPathComponent("Documents", isDirectory: true)
        ubiquityURL=ubiquityURL!.URLByAppendingPathComponent("\(filejustreceivednameToSave)")
        print("number 4 is \(ubiquityURL)")
        
        var documentURL=filejustreceivedPathURL //this is full path
        
        ///////   if let ubiquityURL = ubiquityURL {
    var error:NSError?
    var isDir:ObjCBool = false
    if (filemgr.fileExistsAtPath(ubiquityURL!.path!, isDirectory: &isDir)) {
    /*do{try filemgr.removeItemAtURL(ubiquityURL!)}
     catch{
     print("error removing file")
     }*/
    dispatch_async(dispatch_get_main_queue(),{
    var alert = UIAlertController(title: "Error", message: "File with the name \(filejustreceivednameToSave) already exists. Please enter new name of file" , preferredStyle: .Alert)
    
    //2. Add the text field. You can configure it however you need.
    alert.addTextFieldWithConfigurationHandler({ (textField) -> Void in
    textField.text = ""
    })
    
    
    //3. Grab the value from the text field, and print it when the user clicks OK.
    alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
    let textField = alert.textFields![0] as UITextField
    print("Text field: \(textField.text)")
    var newfilenamegot=textField.text!
        
    var indExt=filejustreceivednameToSave.characters.indexOf(".")
    var filetype=filejustreceivednameToSave.substringFromIndex(indExt!)
        
        var indExtNewName=newfilenamegot.characters.indexOf(".")
        
        if(newfilenamegot.characters.contains("."))
        {
        newfilenamegot=newfilenamegot.substringToIndex(indExtNewName!)
        }
        print("newfilenamegot is \(newfilenamegot)")
        ////filejustreceivednameToSave=textField.text!+filetype
        filejustreceivednameToSave=newfilenamegot+filetype
       print("newwwww file isss \(filejustreceivednameToSave)")
        self.saveToiCloud()
    }))
    
    // 4. Present the alert.
    self.presentViewController(alert, animated: true, completion:
    {
    
    
    }
    )
    
    })
    
    }
    else{
    
    do{if (error == nil) {
    print("copying file to icloud")
    var ans=try filemgr.copyItemAtURL(documentURL!, toURL: ubiquityURL!)
        
        let alert = UIAlertController(title: "Success", message: "Your file \(filejustreceivednameToSave) has been successfully saved to iCloud Drive", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: {
            
            
        })

    //print(error?.localizedDescription);
    
    }
    }
    catch{
    //print("error anssss is \(ans)")
    print("error is \(error)")
    let alert = UIAlertController(title: "Cancel", message: "\(error)", preferredStyle: UIAlertControllerStyle.Alert)
    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
    self.presentViewController(alert, animated: true, completion: {
    
    
    })
    }
    
    }
    
    }
    
    func didReceiveFileConference()
    {
        //videoCont.btnViewFile.enabled=true
        let alert = UIAlertController(title: "Success", message: "You have received a new file. You can view files by clicking on \"View\" button present on Main conference page.", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    
    
    @IBAction func btnFileOpenPressed(sender: AnyObject) {
        
        
        
        let filemgr = NSFileManager.init()
        //let filemgr = NSFileManager.defaultManager()
        var error: NSError?
        /*
        var document: fileTestingDoc?
        var documentURL: NSURL?
        var ubiquityURL2: NSURL?
        ubiquityURL2 = filemgr.URLForUbiquityContainerIdentifier(nil)!.URLByAppendingPathComponent("Documents")
        ubiquityURL2 = ubiquityURL2!.URLByAppendingPathComponent(filejustreceivedname)
        print("ubiquityURL2 is \(ubiquityURL2)")
        document = fileTestingDoc(fileURL: ubiquityURL2!)
        document?.userText="tesing document sample text"
            ///filemgr.contentsAtPath(filejustreceivedPathURL).
        
        document?.saveToURL(ubiquityURL2!,
            forSaveOperation: .ForCreating,
            completionHandler: {(success: Bool) -> Void in
                if success {
                    print("Save  OK")
                } else {
                    print("Save  failed")
                }
        })
        
        
        */
        
        
        
         dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0))
            {
                () -> Void in
        var rootDirect=filemgr.URLForUbiquityContainerIdentifier(nil)?.URLByAppendingPathComponent("Documents")
        if((rootDirect) != nil)
        {
            if((filemgr.fileExistsAtPath(rootDirect!.description, isDirectory: nil)) == false)
            {
                print("create directory")
                //var cloudDirect=rootDirect!.URLByAppendingPathComponent("cloudkibo")
                
                var cloudDirect=filemgr.URLForUbiquityContainerIdentifier(nil)!.URLByAppendingPathComponent("cloudkibo2")
                do{
                var directAns = try filemgr.createDirectoryAtURL(cloudDirect, withIntermediateDirectories: true, attributes: nil)
                    print("cloudDirect is \(cloudDirect)")
                    print("directAns is \(directAns)")
                }catch{
                    print("error 2 is \(error)")
                }
            }
        }
        
        
        /*
        NSURL *rootDirectory = [[[NSFileManager defaultManager] URLForUbiquityContainerIdentifier:nil]URLByAppendingPathComponent:@"Documents"];
        
        if (rootDirectory) {
        if (![[NSFileManager defaultManager] fileExistsAtPath:rootDirectory.path isDirectory:nil]) {
        NSLog(@"Create directory");
        [[NSFileManager defaultManager] createDirectoryAtURL:rootDirectory withIntermediateDirectories:YES attributes:nil error:nil];
        }
        }

        */
                
        var ubiquityURL=filemgr.URLForUbiquityContainerIdentifier("iCloud.iCloud.MyAppTemplates.cloudkibo")
        
        print("number 1 is \(ubiquityURL)")
        ubiquityURL=ubiquityURL!.URLByAppendingPathComponent("Documents", isDirectory: true)
        //print("number 2 is \(ubiquityURL)")
        ///ubiquityURL=ubiquityURL!.URLByAppendingPathComponent("cloudkibo2", isDirectory: true)
        //print("number 3 is \(ubiquityURL)")
        ubiquityURL=ubiquityURL!.URLByAppendingPathComponent("\(filejustreceivedname)")
        print("number 4 is \(ubiquityURL)")
        
        var documentURL=filejustreceivedPathURL
        
        
       do
        {
            //var newdest=dest!.URLByAppendingPathComponent("Documents", isDirectory: true)
            //print("newdest is \(newdest.debugDescription)")
            //var ans=try fileManager.setUbiquitous(true, itemAtURL: self.fileURL, destinationURL: newdest)
            
            
            self.saveToiCloud()
            
            
            
            
            /*
            
         ///////   if let ubiquityURL = ubiquityURL {
                var error:NSError?
                var isDir:ObjCBool = false
                if (filemgr.fileExistsAtPath(ubiquityURL!.path!, isDirectory: &isDir)) {
                    /*do{try filemgr.removeItemAtURL(ubiquityURL!)}
                    catch{
                        print("error removing file")
                    }*/
                    dispatch_async(dispatch_get_main_queue(),{
                        var alert = UIAlertController(title: "Error", message: "\(error) Please enter new name of file" , preferredStyle: .Alert)
                        
                        //2. Add the text field. You can configure it however you need.
                        alert.addTextFieldWithConfigurationHandler({ (textField) -> Void in
                            textField.text = ""
                        })
                        
                        
                        //3. Grab the value from the text field, and print it when the user clicks OK.
                        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
                            let textField = alert.textFields![0] as UITextField
                            username = textField.text!
                            print("Text field: \(textField.text)")
                            
                            
                            ///username = "iphoneUser"
                            //iamincallWith = "webConference"
                            isInitiator = false
                            isConference = true
                            //  ConferenceRoomName = self.txtForRoomName.text!
                            
                            
                            // let next = self.storyboard!.instantiateViewControllerWithIdentifier("MainV2") as! VideoViewController
                            
                            // self.presentViewController(next, animated: true, completion:nil)
                            
                            
                        }))
                        
                        // 4. Present the alert.
                        self.presentViewController(alert, animated: true, completion:
                            {
                                
                                
                            }
                        )
                        
                    })
                    
            }
                else{
                    
                    do{if (error == nil) {
                        print("copying file to icloud")
                        var ans=try filemgr.copyItemAtURL(documentURL, toURL: ubiquityURL!)
                        //print(error?.localizedDescription);
                        
                        }
                    }
                    catch{
                        //print("error anssss is \(ans)")
                        print("error is \(error)")
                        let alert = UIAlertController(title: "Cancel", message: "\(error)", preferredStyle: UIAlertControllerStyle.Alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                        self.presentViewController(alert, animated: true, completion: {
                            
                            
                        })
                    }
                    
            }
            
            */
                }
                
                
               /* do{if (error == nil) {
                    print("copying file to icloud")
                     var ans=try filemgr.copyItemAtURL(documentURL, toURL: ubiquityURL!)
                    //print(error?.localizedDescription);
                    
                }
                }
                catch{*/
                    
                    /*
                    dispatch_async(dispatch_get_main_queue(),{
                        var alert = UIAlertController(title: "Error", message: "\(error) Please enter new name of file" , preferredStyle: .Alert)
                        
                        //2. Add the text field. You can configure it however you need.
                        alert.addTextFieldWithConfigurationHandler({ (textField) -> Void in
                            textField.text = ""
                        })
                        
                        
                        //3. Grab the value from the text field, and print it when the user clicks OK.
                        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
                            let textField = alert.textFields![0] as UITextField
                            username = textField.text!
                            print("Text field: \(textField.text)")
                            
                            
                            ///username = "iphoneUser"
                            //iamincallWith = "webConference"
                            isInitiator = false
                            isConference = true
                          //  ConferenceRoomName = self.txtForRoomName.text!
                            
                            
                           // let next = self.storyboard!.instantiateViewControllerWithIdentifier("MainV2") as! VideoViewController
                            
                           // self.presentViewController(next, animated: true, completion:nil)
                            
                            
                        }))
                        
                        // 4. Present the alert.
                        self.presentViewController(alert, animated: true, completion:
                            {
                                
                                
                            }
                        )
                        
                    })
*/
                }
       //////     }
            
            
                }
            
            
           /* print("file path in string is \(ubiquityURL!.absoluteString)")
            if(filemgr.fileExistsAtPath((ubiquityURL!.absoluteString)))
            {
                //ubiquityURL=filemgr.URLForUbiquityContainerIdentifier("iCloud.iCloud.MyAppTemplates.cloudkibo")!.URLByAppendingPathComponent("\(filejustreceivedname)").
                print("new path is \(ubiquityURL)")
                
            }else
            {
                
                print("file dest path is \(ubiquityURL) and source path is \(documentURL)")
            var ans = try filemgr.copyItemAtURL(documentURL,toURL: ubiquityURL! )
            
               //var ans = try filemgr.setUbiquitous(true, itemAtURL:documentURL ,
                //destinationURL: ubiquityURL! )
          print("ans is \(ans)")
            let alert = UIAlertController(title: "Success", message: "Your file has been successfully saved to iCloud", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: {
                
                
            })
            }
            //btnFilePreview
        }catch
        {
            //print("error anssss is \(ans)")
            print("error is \(error)")
            let alert = UIAlertController(title: "Cancel", message: "\(error)", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: {
                
                    
            })
        }*/
        
      //  }
        
        
        /*if filemgr.setUbiquitous(true, itemAtURL: documentURL,
            destinationURL: ubiquityURL) {
                print("setUbiquitous OK")
        } else {
            print("setUbiquitous failed: \(error!.localizedDescription)")
        }
        */
        
        /*
        //open
        
        //[self.documentInteractionController presentOpenInMenuFromRect:[button frame] inView:self.view animated:YES];
        let dirPaths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let docsDir1 = dirPaths[0]
        var documentDir=docsDir1 as NSString
        var filePathImage2=documentDir.stringByAppendingPathComponent(filejustreceivedname!)
        print("filepath2 is\(filePathImage2)")
        fileURL=NSURL(fileURLWithPath: filePathImage2)
        var furl2=NSURL(fileURLWithPath: filePathImage2)
        print("local furl2 is\(furl2)")
        
        documentInteractionController = UIDocumentInteractionController(URL: fileURL)
        documentInteractionController.delegate=self
        //documentInteractionController.presentOpenInMenuFromRect(CGRect(x: 20, y: 100, width: 300, height: 200), inView: self.view, animated: true)
        
        
        
        
        var fileManager=NSFileManager.defaultManager()
        var e:NSError!
                    print("saving to iCloud")
            dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0), { () -> Void in
                var dest=fileManager.URLForUbiquityContainerIdentifier("")
                
                do
                {
                    //var newdest=dest!.URLByAppendingPathComponent("Documents", isDirectory: true)
                    //print("newdest is \(newdest.debugDescription)")
                    //var ans=try fileManager.setUbiquitous(true, itemAtURL: self.fileURL, destinationURL: newdest)
                    var ans=try fileManager.setUbiquitous(true, itemAtURL: furl2, destinationURL: dest!)
                    
                    print("ans is \(ans)")

                }catch
                {
                    print("error is \(error)")
                }
                
                
                
            })
            */
        
//}

    /*
    
    
    document!.userText = textView.text
    
    document?.saveToURL(ubiquityURL!,
    forSaveOperation: .ForOverwriting,
    completionHandler: {(success: Bool) -> Void in
    if success {
    println("Save overwrite OK")
    } else {
    println("Save overwrite failed")
    }
    })
    }
    
    
document = MyDocument(fileURL: ubiquityURL!)

document?.saveToURL(ubiquityURL!,
forSaveOperation: .ForCreating,
completionHandler: {(success: Bool) -> Void in
if success {
println("iCloud create OK")
} else {
println("iCloud create failed")
}
})
}
*/

    @IBAction func btnFilePreviewPressed(sender: AnyObject) {
        //preview
        let dirPaths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let docsDir1 = dirPaths[0]
        var documentDir=docsDir1 as NSString
        print("\(username!) received file \(filejustreceivedname). trying to preview")
        var filePathImage2=documentDir.stringByAppendingPathComponent(filejustreceivedname!)
        
        fileURL=NSURL(fileURLWithPath: filePathImage2)
        var documentInteractionController = UIDocumentInteractionController(URL: fileURL)
        documentInteractionController.delegate=self
        documentInteractionController.presentPreviewAnimated(true)
        
        
    }
    
    @IBAction func btnSaveToOtherLocPressed(sender: AnyObject) {
        
        var documentURL=filejustreceivedPathURL
        documentInteractionController = UIDocumentInteractionController(URL: documentURL)
        documentInteractionController.delegate=self
        documentInteractionController.presentOpenInMenuFromRect(CGRect(x: 20, y: 100, width: 300, height: 200), inView: self.view, animated: true)
    }
 
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func documentInteractionControllerViewControllerForPreview(controller: UIDocumentInteractionController) -> UIViewController {
        
        return self
    }

    func documentInteractionControllerDidEndPreview(controller: UIDocumentInteractionController) {
        
        documentInteractionController=nil
    }
    
    
    
    func moveToiCloud(filetosave:NSURL)
    {
        var sourceURL:NSURL=filetosave
        //NSString destFileName
    }
    
    
    /*
    (void)moveFileToiCloud:(FileRepresentation *)fileToMove {
    NSURL *sourceURL = fileToMove.url;
    NSString *destinationFileName = fileToMove.fileName;
    NSURL *destinationURL = [self.documentsDir URLByAppendingPathComponent:destinationFileName];
    
    dispatch_queue_t q_default;
    q_default = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(q_default, ^(void) {
    NSFileManager *fileManager = [[[NSFileManager alloc] init] autorelease];
    NSError *error = nil;
    BOOL success = [fileManager setUbiquitous:YES itemAtURL:sourceURL
    destinationURL:destinationURL error:&error];
    dispatch_queue_t q_main = dispatch_get_main_queue();
    dispatch_async(q_main, ^(void) {
    if (success) {
    FileRepresentation *fileRepresentation = [[FileRepresentation alloc]
    initWithFileName:fileToMove.fileName url:destinationURL];
    [_fileList removeObject:fileToMove];
    [_fileList addObject:fileRepresentation];
    NSLog(@"moved file to cloud: %@", fileRepresentation);
    }
    if (!success) {
    NSLog(@"Couldn't move file to iCloud: %@", fileToMove);
    }
    });
    });
    }
    
    */

    
    
    
    
    
    
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
