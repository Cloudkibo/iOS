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
        
        fileURL=NSURL(fileURLWithPath: filePathImage2)
        var fileManager=NSFileManager.defaultManager()
        var e:NSError!
        do
        {
            print("saving to iCloud")
            var dest=fileManager.URLForUbiquityContainerIdentifier(nil)
            dest!.URLByAppendingPathComponent("cloudkiboDirectory")
            var ans=try fileManager.setUbiquitous(true, itemAtURL: fileURL, destinationURL: dest!)
            print("\(ans)")
        }catch
        {
            print(error)
        }
        
        
        documentInteractionController = UIDocumentInteractionController(URL: fileURL)
        documentInteractionController.delegate=self
        documentInteractionController.presentOpenInMenuFromRect(CGRect(x: 20, y: 100, width: 300, height: 200), inView: self.view, animated: true)
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
