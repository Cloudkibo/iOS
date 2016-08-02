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
    var textView:UITextView!
    var docURL:NSURL!
    override func viewDidLoad() {
        super.viewDidLoad()
       // if let rtf = NSBundle.mainBundle().URLForResource("rtfdoc", withExtension: "rtf", subdirectory: nil, localization: nil) {
            
           // let attributedString = NSAttributedString(fileURL: rtf, options: [NSDocumentTypeDocumentAttribute:NSRTFTextDocumentType], documentAttributes: nil, error: nil)
            
            do{  let attrString =
                try NSMutableAttributedString(URL: NSURL(), options: [NSDocumentTypeDocumentAttribute:NSRTFTextDocumentType], documentAttributes: nil)
   
            
            textView.attributedText = attrString
            textView.editable = false
            }
            catch{
                
            }
      //  }
        
        // Do any additional setup after loading the view.
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
