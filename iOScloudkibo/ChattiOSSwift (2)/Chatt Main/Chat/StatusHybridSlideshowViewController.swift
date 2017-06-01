//
//  StatusHybridSlideshowViewController.swift
//  kiboApp
//
//  Created by Cloudkibo on 31/05/2017.
//  Copyright © 2017 MyAppTemplates. All rights reserved.
//

import UIKit
import MediaPlayer
import AVKit
    
    class StatusHybridSlideshowViewController: UIViewController, UIScrollViewDelegate {
        
        var mytimer: Timer!
        var progressTimer: Timer!
        var timersList=[Timer]()
        var imageslist=[UIView]()
        @IBOutlet weak var stackView: UIStackView!
        var slideshowarray:NSMutableArray!
       // @IBOutlet var scrollView: UIScrollView!
        //@IBOutlet var textView: UITextView!
        @IBOutlet weak var scrollView: UIScrollView!
        //@IBOutlet var pageControl: UIPageControl!
        
        //@IBOutlet var startButton: UIButton!
        
        @IBOutlet weak var pageControl: UIPageControl!
        
        override func viewDidLoad() {
            super.viewDidLoad()
            self.stackView.distribution = .fillEqually
            // Do any additional setup after loading the view, typically from a nib.
            //1
            
            
            self.scrollView.frame = CGRect(x:0, y:0, width:self.view.frame.width, height:self.view.frame.height)
            let scrollViewWidth:CGFloat = self.scrollView.frame.width
            let scrollViewHeight:CGFloat = self.scrollView.frame.height
            //2
            //textView.textAlignment = .center
            //textView.text = "Sweettutos.com is your blog of choice for Mobile tutorials"
            //textView.textColor = .black
            //self.startButton.layer.cornerRadius = 4.0
            //3
            
            /*let imgOne = UIImageView(frame: CGRect(x:0, y:0,width:scrollViewWidth, height:scrollViewHeight))
            imgOne.image = UIImage(named: "Slide 1")
            let imgTwo = UIImageView(frame: CGRect(x:scrollViewWidth, y:0,width:scrollViewWidth, height:scrollViewHeight))
            imgTwo.image = UIImage(named: "Slide 2")
            let imgThree = UIImageView(frame: CGRect(x:scrollViewWidth*2, y:0,width:scrollViewWidth, height:scrollViewHeight))
            imgThree.image = UIImage(named: "Slide 3")
            let imgFour = UIImageView(frame: CGRect(x:scrollViewWidth*3, y:0,width:scrollViewWidth, height:scrollViewHeight))
            imgFour.image = UIImage(named: "Slide 4")
            */
            
            ////self.configurePageControl()
            
            
        //!!    pageControl.addTarget(self, action: #selector(self.changePage(sender:)), for: UIControlEvents.valueChanged)
            
            
            /*
             self.scrollView.contentSize = CGSize(width:self.scrollView.frame.width * CGFloat(imageslist.count), height:self.scrollView.frame.height)
            self.scrollView.delegate = self
            self.pageControl.numberOfPages=imageslist.count
            self.pageControl.currentPage = 0*/
        }
        
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }
       
        
        override func viewWillAppear(_ animated: Bool) {
            
            var count=0
            
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
                
                print("size of image is \(messages_file_pic.count)")
                var util=UtilityFunctions.init()
                print("file type iss \((messages_file_type as String).lowercased()) and filename is \(messages_file_name)")
                if(util.videoExtensions.contains((messages_file_type as String).lowercased()))
                {
                    print("filetype is video")
                    let dirPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
                    let docsDir1 = dirPaths[0]
                    var documentDir=docsDir1 as NSString
                    var videoPath=documentDir.appendingPathComponent(messages_file_name)
                    
                    let player = AVPlayer(url: URL.init(fileURLWithPath: videoPath))
                   // var videolayer=AVPlayerLayer.init(player: player)
                   let playerViewController = AVPlayerViewController.init()
                   // playerViewController.videoBounds = CGRect.equalTo(scrollView.bounds)
                   playerViewController.player = player
                    playerViewController.player?.play()
                  // playerViewController.view.frame=CGRect(dictionaryRepresentation: CGRect(x:scrollView.frame.width * CGFloat(count), y:CGFloat(0),width:scrollView.frame.width, height:scrollView.frame.height) as! CFDictionary)!
                  // playerViewController.view.bounds=CGRect(x:scrollView.frame.width * CGFloat(count), y:0,width:scrollView.frame.width, height:scrollView.frame.height)
                   // playerViewController.showsPlaybackControls=true
                    //!!!playerViewController.view.frame=CGRect(x:scrollView.frame.width * CGFloat(count), y:0,width:scrollView.frame.width, height:scrollView.frame.height)
                   //playerViewController.videoGravity = AVLayerVideoGravityResizeAspectFill;
                    
                   /* var playerLayer = AVPlayerLayer.init(player: player)
                    playerLayer.player?.play()
                   // playerLayer.player = player;
                   ////// playerLayer.frame = CGRect(x:scrollView.frame.width * CGFloat(count), y:0,width:scrollView.frame.width, height:scrollView.frame.height)
                    //playerLayer.backgroundColor = [UIColor blackColor].CGColor;
                    playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
                    var newview=UIView.init()
                    newview.layer.addSublayer(playerLayer)
                    */
                    //scrollView.addChildViewController(playerViewController)
                    
                    
                    
                    
                    playerViewController.view.frame=CGRect(x:self.view.frame.width * CGFloat(count), y:0,width:self.view.frame.width, height:self.view.frame.height)
                   ///!!! playerViewController.view.frame=self.view.frame
                    imageslist.append(playerViewController.view)
                    
                    count += 1
                }
                /*if(notimage)
                {
                                   }*/
                else{
                if let img=UIImage(data:messages_file_pic)
                {
                    if(messages_file_pic.count>0)
                    {
                        let imgTwo = UIImageView(frame: CGRect(x:scrollView.frame.width * CGFloat(count), y:0,width:scrollView.frame.width, height:scrollView.frame.height))
                        
                        imgTwo.image=img
                        imageslist.append(imgTwo)
                        
                        
                        count += 1
                    }
                }
                else{
                    print("empty image")
                }
            }
            }
            for imgss in imageslist{
                var progressView = UIProgressView(progressViewStyle: UIProgressViewStyle.default)
                //progressView?.frame=CGRect(x: 10, y: 10, width: frame.size.width-40, height: 30)
                
                self.stackView.addArrangedSubview(progressView)
                if let imgview1=imgss as? AVPlayerViewController
                {
                    //// imgss.frame=self.view.frame
                    
 //imgss.frame=CGRect(x:scrollView.frame.width * CGFloat(count), y:0,width:scrollView.frame.width, height:scrollView.frame.height)
                }
                else{
                 // imgss.frame=self.view.frame
                }
                self.scrollView.addSubview(imgss)
                
                
            }
            print("imagelist array count is \(imageslist.count)")
            
            pageControl.frame = CGRect(x:0,y:264,width:480,height:36);
            pageControl.numberOfPages=imageslist.count;
            pageControl.autoresizingMask=[]
            
            
            /*
             self.scrollView.addSubview(imgOne)
             self.scrollView.addSubview(imgTwo)
             self.scrollView.addSubview(imgThree)
             self.scrollView.addSubview(imgFour)
             */
            //4
            //self.scrollView.contentSize = CGSize(width:self.scrollView.frame.width * 4, height:self.scrollView.frame.height)
            
            
            self.scrollView.isPagingEnabled = true
            self.scrollView.contentSize = CGSize(width: self.scrollView.frame.size.width * CGFloat(imageslist.count), height: self.scrollView.frame.size.height)
            
            scrollView.contentSize=CGSize(width:scrollView.frame.size.width*CGFloat(imageslist.count), height:scrollView.frame.size.height);
            
            
            var currentProgressBar=stackView.arrangedSubviews[timersList.count] as! UIProgressView
            currentProgressBar.progress=0
            
            progressTimer = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(self.startProgressViewTimer(_:)), userInfo: nil, repeats: true)
            timersList.append(progressTimer)
            
            //.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(self.startProgressViewTimer(_:)), userInfo: nil, repeats: true)
            
            var timerinterval:Double=4.0
           /* if let imgview1=imageslist[0] as? AVPlayerViewController
            {
                if(imgview1.player!.currentItem!.duration.seconds > 20.0)
                {
                    timerinterval=20.0
                }
                else{
                    timerinterval=(imgview1.player?.currentItem?.duration.seconds)!
                }
            }*/
            
            // enable timer after each 2 seconds for scrolling.
            mytimer = Timer.scheduledTimer(timeInterval: timerinterval, target: self, selector: #selector(self.scrollingTimer(_:)), userInfo: nil, repeats: true)
            

        }
  /*
func configurePageControl() {
    // The total number of pages that are available is based on how many available colors we have.
    self.pageControl.numberOfPages = imageslist.count
    self.pageControl.currentPage = 0
    self.pageControl.tintColor = UIColor.red
    self.pageControl.pageIndicatorTintColor = UIColor.black
    self.pageControl.currentPageIndicatorTintColor = UIColor.green
    /////self.view.addSubview(pageControl)
    //==--[NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(scrollingTimer) userInfo:nil repeats:YES];
    
   // var slideshowTimer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(self.scrollingTimer(_:)), userInfo: nil, repeats: false)
    //changePage
    

    
    //timersList[0]
    
    
        var slideshowTimer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(self.scrollingTimer(_:)), userInfo: nil, repeats: true)
    
        }
        */
        var repeatinterval=0.0
        
        
    func startProgressViewTimer(_ timer: Timer)
    {print("repeatinterval is \(repeatinterval)")
        repeatinterval+=0.05
        var currentProgressBar=stackView.arrangedSubviews[timersList.count-1] as! UIProgressView
        
        
        currentProgressBar.progress+=0.0125
       // currentProgressBar.progress+=Float(1.00/Double(currentProgressBar.frame.width/8))/8.0
        print("currentProgressBar \(currentProgressBar.progress)")
            if(repeatinterval>=8)
            {
                ///currentProgressBar.progress=1
                repeatinterval=0.0
                timer.invalidate()
            }
            
        
        }
        
    func scrollingTimer(_ timer: Timer) {
    
        
    // access the scroll view with the tag
    //UIScrollView *scrMain = (UIScrollView*) [self.view viewWithTag:1];
    // same way, access pagecontroll access
   // UIPageControl *pgCtr = (UIPageControl*) [self.view viewWithTag:12];
    // get the current offset ( which page is being displayed )
    var contentOffset = scrollView.contentOffset.x;
    // calculate next page to display
    var nextPage = Int(contentOffset/scrollView.frame.size.width) + 1 ;
    // if page is not 10, display it
    
    print("nextpage is \(nextPage)")
    //UIProgressView
    if( nextPage != imageslist.count )  {
        //progressView?.progress += 0.02
       

        var prexProgressbar=stackView.arrangedSubviews[timersList.count-1] as! UIProgressView
        prexProgressbar.progress=1
         repeatinterval=0.0
        var currentProgressBar=stackView.arrangedSubviews[timersList.count] as! UIProgressView
        currentProgressBar.progress=0
        progressTimer.invalidate()
                progressTimer = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(self.startProgressViewTimer(_:)), userInfo: nil, repeats: true)
        
        //.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(self.startProgressViewTimer(_:)), userInfo: nil, repeats: true)
        
        timersList.append(progressTimer)
        //invalidate progresstimer of previous page
        //var currentprogresstimer=timersList[0] as! Timer
        //currentprogresstimer.invalidate()
        
        
    
        scrollView.scrollRectToVisible(CGRect(x:CGFloat(nextPage)*scrollView.frame.size.width,y:0,width:scrollView.frame.size.width, height:scrollView.frame.size.height), animated: true)
        
       // scrollRectToVisible:CGRectMake(nextPage*scrMain.frame.size.width, 0, scrMain.frame.size.width, scrMain.frame.size.height) animated:YES];
        pageControl.currentPage=nextPage;
       
        
        //mytimer.invalidate()
        
        
        
        // else start sliding form 1 :)
       //!! mytimer = Timer.scheduledTimer(timeInterval: 4, target: self, selector: #selector(self.scrollingTimer(_:)), userInfo: nil, repeats: false)
    } else {
        timer.invalidate()
       ////!!! scrollView.scrollRectToVisible(CGRect(x:0,y:0,width:scrollView.frame.size.width,height:scrollView.frame.size.height), animated: true)
        
       // [scrMain scrollRectToVisible:CGRectMake(0, 0, scrMain.frame.size.width, scrMain.frame.size.height) animated:YES];
        ////!!! pageControl.currentPage=0;
    }
        }

// MARK : TO CHANGE WHILE CLICKING ON PAGE CONTROL
        
        func changePage(_ timer: Timer) -> () {
//func changePage(sender: AnyObject) -> () {
            var contentOffset = scrollView.contentOffset.x;
            var nextPage = Int(contentOffset/scrollView.frame.size.width) + 1 ;
    if( nextPage != imageslist.count )  {
    let x = CGFloat(pageControl.currentPage) * scrollView.frame.size.width
    scrollView.setContentOffset(CGPoint(x: x,y :0), animated: true)
        pageControl.currentPage=nextPage;
    }
}

        override func viewDidLayoutSubviews() {
            
            
        }
        
        override func viewWillDisappear(_ animated: Bool) {
    
            progressTimer.invalidate()
            mytimer.invalidate()
            
        }
/*func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    
    let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
    pageControl.currentPage = Int(pageNumber)
}*/
        /*
        //MARK: UIScrollView Delegate
        func scrollViewDidEndDecelerating(_ scrollView: UIScrollView){
            print("here in scrollViewDidEndDecelerating")
            // Test the offset and calculate the current page after scrolling ends
            let pageWidth:CGFloat = scrollView.frame.width
            let currentPage:CGFloat = floor((scrollView.contentOffset.x-pageWidth/2)/pageWidth)+1
            // Change the indicator
            self.pageControl.currentPage = Int(currentPage);
            // Change the text accordingly
            if Int(currentPage) == 0{
                //textView.text = "Sweettutos.com is your blog of choice for Mobile tutorials"
            }else if Int(currentPage) == 1{
               // textView.text = "I write mobile tutorials mainly targeting iOS"
            }else if Int(currentPage) == 2{
               // textView.text = "And sometimes I write games tutorials about Unity"
            }else{
               // textView.text = "Keep visiting sweettutos.com for new coming tutorials, and don't forget to subscribe to be notified by email :)"
                // Show the "Let's Start" button in the last slide (with a fade in animation)
                UIView.animate(withDuration: 1.0, animations: { () -> Void in
                    //self.startButton.alpha = 1.0
                })
            }
        }*/
}
