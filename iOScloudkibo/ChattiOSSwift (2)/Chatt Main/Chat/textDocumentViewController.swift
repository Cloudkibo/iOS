//
//  textDocumentViewController.swift
//  kiboApp
//
//  Created by Cloudkibo on 02/08/2016.
//  Copyright © 2016 MyAppTemplates. All rights reserved.
//

import UIKit
import Foundation
import QuickLook


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
    
    override func viewWillAppear(_ animated: Bool) {
        var attrString:NSMutableAttributedString!=nil
        
        
        do{
            print("newtext is \(newtext)")
            let dirPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
            let docsDir1 = dirPaths[0]
            let documentDir=docsDir1 as NSString
            let filePathImage2=documentDir.appendingPathComponent(newtext)
            newtext=documentDir.appendingPathComponent(newtext)
            //fname!+"."+ftype
            
            
            let furl=URL(fileURLWithPath: filePathImage2)
            let ftype=furl.pathExtension
            
           /* var furl=NSURL(fileURLWithPath: newtext)
            var ftype=furl.pathExtension!
            print("file type found is \(ftype)")
 
 */
            switch(ftype.lowercased())
            {case "rtf":
            
            
                 attrString = try NSMutableAttributedString(url: URL(fileURLWithPath: newtext), options: [NSDocumentTypeDocumentAttribute:NSRTFTextDocumentType], documentAttributes: nil)
                
           
                case "txt":
                   
                        attrString =
                            
                            
                            try NSMutableAttributedString(url: URL(fileURLWithPath: newtext), options: [NSDocumentTypeDocumentAttribute:NSPlainTextDocumentType], documentAttributes: nil)
                        
                
                case "html":
                    
                        attrString =
                            
                            
                            try NSMutableAttributedString(url: URL(fileURLWithPath: newtext), options: [NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType], documentAttributes: nil)
                
                case "rtfd":
                    
                        attrString =
                            
                            
                            try NSMutableAttributedString(url: URL(fileURLWithPath: newtext), options: [NSDocumentTypeDocumentAttribute:NSRTFDTextDocumentType], documentAttributes: nil)
                        
                
                case "pdf":
                    let webView = UIWebView(frame: CGRect(x: 0,y: 0,width: self.view.frame.size.width,height: self.view.frame.size.height))
                    let pdffile=try? Data(contentsOf: URL(fileURLWithPath: newtext))
                    if(pdffile != nil)
                    {
                        //error handling. file found
                    webView.load(pdffile!, mimeType: "application/pdf", textEncodingName:"", baseURL: NSURL(fileURLWithPath: newtext).deletingLastPathComponent!)
                    webView.contentMode = UIViewContentMode.scaleAspectFit
                    webView.scalesPageToFit = true
                    webView.contentMode = UIViewContentMode.scaleAspectFit
                    }
                    textViewDoc.addSubview(webView)
                
            case "docx":
                let webView = UIWebView(frame: CGRect(x: 0,y: 0,width: self.textViewDoc.frame.size.width,height: self.textViewDoc.frame.size.height-40))
                let docxfile=try? Data(contentsOf: URL(fileURLWithPath: newtext))
                webView.load(docxfile!, mimeType: "application/vnd.openxmlformats-officedocument.wordprocessingml.document", textEncodingName:"", baseURL: NSURL(fileURLWithPath: newtext).deletingLastPathComponent!)
                webView.scalesPageToFit = true
                webView.contentMode = UIViewContentMode.scaleAspectFit
                textViewDoc.addSubview(webView)
                
            case "doc":
                 let webView = UIWebView(frame: CGRect(x: 0,y: 0,width: self.view.frame.size.width,height: self.view.frame.size.height))
                let docxfile=try? Data(contentsOf: URL(fileURLWithPath: newtext))
                webView.load(docxfile!, mimeType: "application/msword", textEncodingName:"", baseURL: NSURL(fileURLWithPath: newtext).deletingLastPathComponent!)
                 webView.scalesPageToFit = true
                 webView.contentMode = UIViewContentMode.scaleAspectFit
                 textViewDoc.addSubview(webView)


                
                //application/msword
            default:  attrString =
                
                
                try NSMutableAttributedString(url: URL(fileURLWithPath: newtext), options: [NSDocumentTypeDocumentAttribute:NSDocumentTypeDocumentAttribute], documentAttributes: nil)
            }
            
          
           
            print("url text is \(newtext)")
            // textViewDoc.text = try NSString(contentsOfURL: NSURL(string: newtext)!, encoding: NSUTF8StringEncoding) as! String
            //var urlContents = NSString(contentsOfURL: docURL, encoding: NSUTF8StringEncoding, error: nil)
            var txtNSString = try NSString(contentsOfFile: newtext, encoding: String.Encoding.utf8.rawValue)
            /////textViewDoc.text = txtNSString as String
            
            //NSUTF8StringEncoding
            textViewDoc.attributedText = attrString
            
            textViewDoc.isEditable = false
        }
        catch{
            print("error in textdoc")
           
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
