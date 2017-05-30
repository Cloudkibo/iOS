//
//  StatusSlideShowViewController.swift
//  kiboApp
//
//  Created by Cloudkibo on 29/05/2017.
//  Copyright © 2017 MyAppTemplates. All rights reserved.
//

import UIKit
import ImageSlideshow

//import activityIndicator
class StatusSlideShowViewController: UIViewController {

    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }

    var slideshowarray:NSMutableArray!
    var imageslist=[ImageSource]()
     let localSource = [ImageSource(imageString: "status.png")!, ImageSource(imageString: "avatar.png")!, ImageSource(imageString: "cross.png")!, ImageSource(imageString: "gallery.png")!]
    
    
    @IBOutlet weak var slideshowOutlet: ImageSlideshow!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for messageObjects in slideshowarray
        {
            var messageDic = messageObjects as! [String : AnyObject];
            //.object(at: indexPath.row) as! [String : AnyObject];
            
            var messages_from = messageDic["messages_from"] as! String
            var messages_duration = messageDic["messages_duration"] as! String
            var messages_file_type=messageDic["messages_file_type"] as! String
            var messages_uniqueid=messageDic["messages_uniqueid"] as! String
            var messages_file_name=messageDic["messages_file_name"] as! String
            var messages_file_caption=messageDic["messages_file_caption"] as! String
            var messages_file_pic=messageDic["messages_file_pic"] as! Data
            
            if let img=UIImage(data:messages_file_pic)
            {
                imageslist.append(ImageSource.init(image: img))
            }
        }
        
        
                self.slideshowOutlet.setImageInputs(imageslist)
        self.slideshowOutlet.contentScaleMode = .scaleAspectFit
        self.slideshowOutlet.slideshowInterval = 5
        self.slideshowOutlet.zoomEnabled = true
        self.slideshowOutlet.pageControlPosition = .insideScrollView
//self.slideshowOutlet.activityIndicator = DefaultActivityIndicator(style: .whiteLarge, color: .black)
        

        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func didTap() {
        let fullScreenController = slideshowOutlet.presentFullScreenController(from: self)
        // set the activity indicator for full screen controller; skip the line if no activity indicator should be shown
      //  fullScreenController.slideshow.activityIndicator = DefaultActivityIndicator(style: .white, color: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
