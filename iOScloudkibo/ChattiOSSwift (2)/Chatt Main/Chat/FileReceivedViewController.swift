//
//  FileReceivedViewController.swift
//  Chat
//
//  Created by Cloudkibo on 01/03/2016.
//  Copyright © 2016 MyAppTemplates. All rights reserved.
//

import UIKit

class FileReceivedViewController: UIViewController,UIDocumentInteractionControllerDelegate {

    
    var documentInteractionController:UIDocumentInteractionController!
    
    var fileURL:NSURL!
    override func viewDidLoad() {
        super.viewDidLoad()

        
        // Do any additional setup after loading the view.
        
    }

    //var documentInteractionController = UIDocumentInteractionController().delegate=self
    
    
    @IBAction func btnFileOpenPressed(sender: AnyObject) {
        
        
        
        let filemgr = NSFileManager.init()
        var error: NSError?
        
        var document: fileTestingDoc?
        var documentURL: NSURL?
        var ubiquityURL2: NSURL?
        ubiquityURL2 = filemgr.URLForUbiquityContainerIdentifier(nil)!.URLByAppendingPathComponent("Documents")
        ubiquityURL2 = ubiquityURL2!.URLByAppendingPathComponent("savefile.pages")
        
        document = fileTestingDoc(fileURL: ubiquityURL2!)
        
        
        document?.saveToURL(ubiquityURL2!,
            forSaveOperation: .ForOverwriting,
            completionHandler: {(success: Bool) -> Void in
                if success {
                    print("Save overwrite OK")
                } else {
                    print("Save overwrite failed")
                }
        })
        
        
        
        
        
        /*
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
                
                var cloudDirect=filemgr.URLForUbiquityContainerIdentifier(nil)!.URLByAppendingPathComponent("cloudkibo")
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
        ubiquityURL=ubiquityURL!.URLByAppendingPathComponent("cloudkibo", isDirectory: true)
        //print("number 3 is \(ubiquityURL)")
        ubiquityURL=ubiquityURL!.URLByAppendingPathComponent("\(filejustreceivedname)")
        print("number 4 is \(ubiquityURL)")
        
        var documentURL=filejustreceivedPathURL
        
        
       do
        {
            //var newdest=dest!.URLByAppendingPathComponent("Documents", isDirectory: true)
            //print("newdest is \(newdest.debugDescription)")
            //var ans=try fileManager.setUbiquitous(true, itemAtURL: self.fileURL, destinationURL: newdest)
               var ans = try filemgr.setUbiquitous(true, itemAtURL:documentURL ,
                destinationURL: ubiquityURL! )
          print("ans is \(ans)")
            
        }catch
        {
            //print("error anssss is \(ans)")
            print("error is \(error)")
        }
        
        }*/
        
        
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
        
    }
    
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
        var filePathImage2=documentDir.stringByAppendingPathComponent(filejustreceivedname!)
        
        fileURL=NSURL(fileURLWithPath: filePathImage2)
        var documentInteractionController = UIDocumentInteractionController(URL: fileURL)
        documentInteractionController.delegate=self
        documentInteractionController.presentPreviewAnimated(true)

        
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
