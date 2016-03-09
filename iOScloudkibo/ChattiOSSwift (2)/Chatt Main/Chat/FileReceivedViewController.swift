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
            
        
    }
    
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
