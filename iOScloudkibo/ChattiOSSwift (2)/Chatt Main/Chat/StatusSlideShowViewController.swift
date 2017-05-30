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

    
     let localSource = [ImageSource(imageString: "status.png")!, ImageSource(imageString: "avatar.png")!, ImageSource(imageString: "cross.png")!, ImageSource(imageString: "gallery.png")!]
    
    @IBOutlet weak var slideshowOutlet: ImageSlideshow!
    override func viewDidLoad() {
        super.viewDidLoad()
                self.slideshowOutlet.setImageInputs(localSource)
        self.slideshowOutlet.contentScaleMode = .scaleAspectFill
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
