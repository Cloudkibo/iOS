//
//  ShowImageViewController.swift
//  kiboApp
//
//  Created by Cloudkibo on 02/08/2016.
//  Copyright © 2016 MyAppTemplates. All rights reserved.
//

import UIKit

class ShowImageViewController: UIViewController {

    var newimage:UIImage? = nil
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?)
    {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        print(NSBundle.debugDescription())
        
        // Custom initialization
    }
    
    required init?(coder aDecoder: NSCoder!) {
        super.init(coder: aDecoder)
    }
    
    override func viewWillAppear(animated: Bool) {
        //fillImageView = UIImageView(image: newimage)
        fillImageView?.image=newimage
        fillImageView?.contentMode = .ScaleAspectFit
        //fillImageView?.image
        fillImageView?.setNeedsDisplay()
    }
   /* required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }*/
    
   /* required init?(coder aDecoder: NSCoder) {
         super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
        super.init(coder: aDecoder)
        
    }*/
    override func viewDidLoad() {
        super.viewDidLoad()
       //// fillImageView = UIImageView(image: newimage)
        
       // fillImageView!.frame = CGRectMake(fillImageView!.frame.origin.x, fillImageView!.frame.origin.y, fillImageView!.frame.width , fillImageView!.frame.height)
        
       // fillImageView = UIImageView(image: newimage)
        fillImageView?.image=newimage
        ///.stretchableImageWithLeftCapWidth(40,topCapHeight: 20);
       // fillImageView!.contentMode = .ScaleAspectFill
        //fillImageView!.setNeedsDisplay()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBOutlet weak var fillImageView: UIImageView?
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
