//
//  textDocumentViewController.swift
//  kiboApp
//
//  Created by Cloudkibo on 02/08/2016.
//  Copyright © 2016 MyAppTemplates. All rights reserved.
//

import UIKit
import Foundation

class textDocumentViewController: UIViewController {
    @IBOutlet weak var textViewDoc: UITextView!
    var newtext:String!
    var fileextension=""
    //var textView:UITextView!
   // var docURL:NSURL=NSURL(fileURLWithPath: "/private/var/mobile/Containers/Data/Application/8B265342-96B0-45B0-B603-D314F860B1EB/tmp/iCloud.MyAppTemplates.cloudkibo-Inbox/cartext.rtf")
    override func viewDidLoad() {
        super.viewDidLoad()
       // if let rtf = NSBundle.mainBundle().URLForResource("rtfdoc", withExtension: "rtf", subdirectory: nil, localization: nil) {
            
           // let attributedString = NSAttributedString(fileURL: rtf, options: [NSDocumentTypeDocumentAttribute:NSRTFTextDocumentType], documentAttributes: nil, error: nil)
 
      //  }
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        
        do{  let attrString =
            
           
            try NSMutableAttributedString(URL: NSURL(fileURLWithPath: newtext), options: [NSDocumentTypeDocumentAttribute:NSRTFTextDocumentType], documentAttributes: nil)
            print("url text is \(newtext)")
            // textViewDoc.text = try NSString(contentsOfURL: NSURL(string: newtext)!, encoding: NSUTF8StringEncoding) as! String
            //var urlContents = NSString(contentsOfURL: docURL, encoding: NSUTF8StringEncoding, error: nil)
            var txtNSString = try NSString(contentsOfFile: newtext, encoding: NSUTF8StringEncoding)
            /////textViewDoc.text = txtNSString as String
            
            //NSUTF8StringEncoding
            textViewDoc.attributedText = attrString
            
            textViewDoc.editable = false
        }
        catch{
            print("error in textdoc")
            do{  let attrString =
                
                
                try NSMutableAttributedString(URL: NSURL(fileURLWithPath: newtext), options: [NSDocumentTypeDocumentAttribute:NSPlainTextDocumentType], documentAttributes: nil)
                print("url text is \(newtext)")
                // textViewDoc.text = try NSString(contentsOfURL: NSURL(string: newtext)!, encoding: NSUTF8StringEncoding) as! String
                //var urlContents = NSString(contentsOfURL: docURL, encoding: NSUTF8StringEncoding, error: nil)
                var txtNSString = try NSString(contentsOfFile: newtext, encoding: NSUTF8StringEncoding)
                /////textViewDoc.text = txtNSString as String
                
                //NSUTF8StringEncoding
                textViewDoc.attributedText = attrString
                
                textViewDoc.editable = false
            }
            catch{
                print("error in textdoc")
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
