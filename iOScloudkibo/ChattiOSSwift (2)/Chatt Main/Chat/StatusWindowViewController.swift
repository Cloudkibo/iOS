//
//  StatusWindowViewController.swift
//  kiboApp
//
//  Created by Cloudkibo on 26/05/2017.
//  Copyright © 2017 MyAppTemplates. All rights reserved.
//

//import UIKit

//class StatusWindowViewController: UIViewController {
/*Copyright (c) 2016, Andrew Walz.
 
 Redistribution and use in source and binary forms, with or without modification,are permitted provided that the following conditions are met:
 
 1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 
 2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the
 documentation and/or other materials provided with the distribution.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
 THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS
 BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE
 GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE. */


import SwiftyCam
import UIKit
import SwiftyJSON
import SQLite
import Alamofire
import AVFoundation
import MobileCoreServices
import Foundation
import AssetsLibrary
import Photos
import Foundation
import ImagePicker
import Photos
//import PhotoUI

class StatusWindowViewController: SwiftyCamViewController, SwiftyCamViewControllerDelegate,UIImagePickerControllerDelegate,UIPickerViewDelegate{
    
    
    var scrollView: UIScrollView!
    var stackView: UIStackView!
    lazy var assets = [PHAsset]()
    var configuration = Configuration()
    var scrollview=UIScrollView.init()
    let imagePicker=UIImagePickerController.init()
    var flipCameraButton: UIButton!
    var flashButton: UIButton!
    var captureButton: SwiftyRecordButton!
    var galleryButton: UIButton!
    var cancelButton: UIButton!
    
    
    struct GestureConstants {
        static let maximumHeight: CGFloat = 200
        static let minimumHeight: CGFloat = 125
        static let velocity: CGFloat = 100
    }
    
    
    open lazy var galleryView: ImageGalleryView = { [unowned self] in
        let galleryView = ImageGalleryView(configuration: self.configuration)
        //galleryView.delegate = self
        //galleryView.selectedStack = self.stack
        galleryView.collectionView.layer.anchorPoint = CGPoint(x: 0, y: 0)
        //galleryView.imageLimit = self.imageLimit
        
        return galleryView
        }()
    
    
    open lazy var bottomContainer: BottomContainerView = { [unowned self] in
        let view = BottomContainerView(configuration: self.configuration)
        view.backgroundColor = self.configuration.bottomContainerColor
        //!!view.delegate = self
        
        return view
        }()
    
 
    
    lazy var panGestureRecognizer: UIPanGestureRecognizer = { [unowned self] in
        let gesture = UIPanGestureRecognizer()
        gesture.addTarget(self, action: #selector(panGestureRecognizerHandler(_:)))
        
        return gesture
        }()
    
   
    
    var volume = AVAudioSession.sharedInstance().outputVolume
    
    open weak var delegate: ImagePickerDelegate?
    //!!open var stack = ImageStack()
    open var imageLimit = 0
    open var preferredImageSize: CGSize?
    open var startOnFrontCamera = false
    var totalSize: CGSize { return UIScreen.main.bounds.size }
    var initialFrame: CGRect?
    var initialContentOffset: CGPoint?
    var numberOfCells: Int?
    var statusBarHidden = true

    
    func panGestureRecognizerHandler(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        let velocity = gesture.velocity(in: view)
        
        if gesture.location(in: view).y > galleryView.frame.origin.y - 25 {
          //!!  gesture.state == .began ? panGestureDidStart() : panGestureDidChange(translation)
        }
        
        if gesture.state == .ended {
          //!!  panGestureDidEnd(translation, velocity: velocity)
        }
    }

    func panGestureDidStart() {
       //!! guard let collectionSize = galleryView.collectionSize else { return }
        
        initialFrame = galleryView.frame
        initialContentOffset = galleryView.collectionView.contentOffset
        //!!if let contentOffset = initialContentOffset { numberOfCells = Int(contentOffset.x / collectionSize.width) }
    }
    
    func getAssetThumbnail(asset: PHAsset) -> UIImage {
        let manager = PHImageManager.default()
        let option = PHImageRequestOptions()
        var thumbnail = UIImage()
        option.isSynchronous = true
        manager.requestImage(for: asset, targetSize: CGSize(width: 100, height: 100), contentMode: .aspectFit, options: option, resultHandler: {(result, info)->Void in
            thumbnail = result!
        })
        return thumbnail
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cameraDelegate = self
        maximumVideoDuration = 10.0
        shouldUseDeviceOrientation = true
        addButtons()
        self.fetchPhotos()
        
        var img1=UIImage.init(named: "cancel.png")
        var img2=UIImage.init(named: "gallery.png")
      var imgview1=UIImageView.init(image: img1)
        var imgview2=UIImageView.init(image: img2)
        var imgview3=UIImageView.init(image: img1)
        var imgview4=UIImageView.init(image: img2)
        var imgview5=UIImageView.init(image: img1)
        var imgview6=UIImageView.init(image: img2)
        var imgview7=UIImageView.init(image: img1)
        var imgview8=UIImageView.init(image: img2)
        var imgview9=UIImageView.init(image: img1)
        var imgview10=UIImageView.init(image: img2)
        
        scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        var myviewgallery=UIView.init(frame: CGRect(x: 10, y: view.frame.height - 400, width: 575.0, height: 100.0))
        myviewgallery.addSubview(scrollView)
        view.addSubview(myviewgallery)
        
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[scrollView]|", options: .alignAllCenterX, metrics: nil, views: ["scrollView": scrollView]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[scrollView]|", options: .alignAllCenterX, metrics: nil, views: ["scrollView": scrollView]))
        
        
        stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        scrollView.addSubview(stackView)
        
        scrollView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[stackView]|", options: NSLayoutFormatOptions.alignAllCenterX, metrics: nil, views: ["stackView": stackView]))
        scrollView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[stackView]", options: NSLayoutFormatOptions.alignAllCenterX, metrics: nil, views: ["stackView": stackView]))
        
        for imgs in assets{
            
            var imgview1=UIImageView.init(image:self.getAssetThumbnail(asset: imgs))
            stackView.addArrangedSubview(imgview1)
            
        }
        
        /* stackView.addArrangedSubview(imgview1)
        stackView.addArrangedSubview(imgview2)
        stackView.addArrangedSubview(imgview3)
        stackView.addArrangedSubview(imgview4)
        stackView.addArrangedSubview(imgview5)
        stackView.addArrangedSubview(imgview6)
        stackView.addArrangedSubview(imgview7)
        stackView.addArrangedSubview(imgview8)
        stackView.addArrangedSubview(imgview9)
        stackView.addArrangedSubview(imgview10)
        */
        
        /*for _ in 1 ..< 100 {
            let vw = UIButton(type: UIButtonType.System)
            vw.setTitle("Button", forState: .Normal)
            stackView.addArrangedSubview(vw)
        }*/
        /*
        let myStack = UIStackView(arrangedSubviews: [imgview1,imgview2,imgview3,imgview4,imgview5,imgview6,imgview7,imgview8,imgview9,imgview10,imgview1,imgview2,imgview1,imgview2,imgview1,imgview2,imgview1,imgview2,imgview1,imgview2,imgview1,imgview2,imgview1,imgview2])
        myStack.frame=CGRect(x: view.frame.midX - 37.5, y: view.frame.height - 300, width: 575.0, height: 75.0)
        myStack.axis = .horizontal
        
        scrollview.contentSize = CGSize(width: myStack.frame.width, height: myStack.frame.height)
        scrollview.addSubview(myStack)
        myStack.leadingAnchor.constraint(equalTo: scrollview.leadingAnchor).isActive = true
        myStack.trailingAnchor.constraint(equalTo: scrollview.trailingAnchor).isActive = true
        myStack.bottomAnchor.constraint(equalTo: scrollview.bottomAnchor).isActive = true
        myStack.topAnchor.constraint(equalTo: scrollview.topAnchor).isActive = true
        myStack.widthAnchor.constraint(equalTo: scrollview.widthAnchor).isActive = true

        */
        //!!self.view.addSubview(stackView)
        
        
        /*for subview in [imagePicker.view] {
            view.addSubview(subview!)
            subview?.translatesAutoresizingMaskIntoConstraints = false
        }*/
        /*
        view.addSubview(volumeView)
        view.sendSubview(toBack: volumeView)
        */
        //!!view.backgroundColor = UIColor.white
        //!!view.backgroundColor = configuration.mainColor
        
        //!!imagePicker.view.addGestureRecognizer(panGestureRecognizer)
     }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    
    func fetch(withConfiguration configuration: Configuration, _ completion: @escaping (_ assets: [PHAsset]) -> Void) {
        guard PHPhotoLibrary.authorizationStatus() == .authorized else { return }
        
        DispatchQueue.global(qos: .background).async {
            let fetchResult = configuration.allowVideoSelection
                ? PHAsset.fetchAssets(with: PHFetchOptions())
                : PHAsset.fetchAssets(with: .image, options: PHFetchOptions())
            
            if fetchResult.count > 0 {
                var assets = [PHAsset]()
                fetchResult.enumerateObjects({ object, index, stop in
                    assets.insert(object, at: 0)
                })
                
                DispatchQueue.main.async {
                    completion(assets)
                }
            }
        }
    }
    
    
    func fetchPhotos(_ completion: (() -> Void)? = nil) {
        self.fetch(withConfiguration: configuration) { assets in
            self.assets.removeAll()
            self.assets.append(contentsOf: assets)
            //!! self.collectionView.reloadData()
            
            completion?()
        }
    }
    
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didTake photo: UIImage) {
        let newVC = StatusPhotoViewController(image: photo)
        self.present(newVC, animated: true){
            //self.dismiss(animated: true){
                
           // }
        }
        //self.present(newVC, animated: true, completion: nil)
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didBeginRecordingVideo camera: SwiftyCamViewController.CameraSelection) {
        print("Did Begin Recording")
        captureButton.growButton()
        UIView.animate(withDuration: 0.25, animations: {
           //!! self.flashButton.alpha = 0.0
           //!! self.flipCameraButton.alpha = 0.0
        })
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didFinishRecordingVideo camera: SwiftyCamViewController.CameraSelection) {
        print("Did finish Recording")
        captureButton.shrinkButton()
        UIView.animate(withDuration: 0.25, animations: {
            //!!self.flashButton.alpha = 1.0
            //!!self.flipCameraButton.alpha = 1.0
        })
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didFinishProcessVideoAt url: URL) {
        let newVC = StatusVideoViewController(videoURL: url)
        self.present(newVC, animated: true, completion: nil)
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didFocusAtPoint point: CGPoint) {
        let focusView = UIImageView(image: #imageLiteral(resourceName: "focus"))
        focusView.center = point
        focusView.alpha = 0.0
        view.addSubview(focusView)
        
        UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseInOut, animations: {
            focusView.alpha = 1.0
            focusView.transform = CGAffineTransform(scaleX: 1.25, y: 1.25)
        }, completion: { (success) in
            UIView.animate(withDuration: 0.15, delay: 0.5, options: .curveEaseInOut, animations: {
                focusView.alpha = 0.0
                focusView.transform = CGAffineTransform(translationX: 0.6, y: 0.6)
            }, completion: { (success) in
                focusView.removeFromSuperview()
            })
        })
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didChangeZoomLevel zoom: CGFloat) {
        print(zoom)
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didSwitchCameras camera: SwiftyCamViewController.CameraSelection) {
        print(camera)
    }
    
    @objc private func cameraSwitchAction(_ sender: Any) {
        switchCamera()
    }
    func GalleryShowAction(_ sender: Any) {
        
        /// imagePicker =  UIImagePickerController()
        //imagePicker.delegate=self
        imagePicker.sourceType = .photoLibrary
        
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    @objc private func toggleFlashAction(_ sender: Any) {
        flashEnabled = !flashEnabled
        
        if flashEnabled == true {
            flashButton.setImage(#imageLiteral(resourceName: "flash"), for: UIControlState())
        } else {
            flashButton.setImage(#imageLiteral(resourceName: "flashOutline"), for: UIControlState())
        }
    }
    @objc private func goBack(_ sender: Any) {
        self.dismiss(animated: true) { 
            
            
        }
    }
    private func addButtons() {
        captureButton = SwiftyRecordButton(frame: CGRect(x: view.frame.midX - 37.5, y: view.frame.height - 100.0-50, width: 75.0, height: 75.0))
        self.view.addSubview(captureButton)
        captureButton.delegate = self
        
       /* cancelButton = UIButton(frame: CGRect(x: (((view.frame.width / 2 - 37.5) / 2) - 15.0), y: 30.0, width: 20.0, height: 20.0))
        cancelButton.setImage(#imageLiteral(resourceName: "cross"), for: UIControlState())
        cancelButton.addTarget(self, action: #selector(goBack(_:)), for: .touchUpInside)
        self.view.addSubview(cancelButton)
        */

        
        /*flipCameraButton = UIButton(frame: CGRect(x: (((view.frame.width / 2 - 37.5) / 2) - 15.0), y: view.frame.height - 74.0, width: 30.0, height: 23.0))
        flipCameraButton.setImage(#imageLiteral(resourceName: "flipCamera"), for: UIControlState())
        flipCameraButton.addTarget(self, action: #selector(cameraSwitchAction(_:)), for: .touchUpInside)
        self.view.addSubview(flipCameraButton)
        */
        galleryButton = UIButton(frame: CGRect(x: (((view.frame.width / 2 - 37.5) / 2) - 15.0), y: view.frame.height - 74.0-50, width: 40.0, height: 30.0))
        galleryButton.setImage(#imageLiteral(resourceName: "gallery"), for: UIControlState())
        galleryButton.addTarget(self, action: #selector(GalleryShowAction(_:)), for: .touchUpInside)
        self.view.addSubview(galleryButton)
        
        
        let test = CGFloat((view.frame.width - (view.frame.width / 2 + 37.5)) + ((view.frame.width / 2) - 37.5) - 9.0)
        
        flipCameraButton = UIButton(frame: CGRect(x: test, y: view.frame.height - 76-50, width: 35.0, height: 42.0))
        flipCameraButton.setImage(#imageLiteral(resourceName: "flipCamera"), for: UIControlState())
        flipCameraButton.addTarget(self, action: #selector(cameraSwitchAction(_:)), for: .touchUpInside)
        self.view.addSubview(flipCameraButton)
        /*
        let test = CGFloat((view.frame.width - (view.frame.width / 2 + 37.5)) + ((view.frame.width / 2) - 37.5) - 9.0)
        
        flashButton = UIButton(frame: CGRect(x: test, y: view.frame.height - 77.5, width: 18.0, height: 30.0))
        flashButton.setImage(#imageLiteral(resourceName: "flashOutline"), for: UIControlState())
        flashButton.addTarget(self, action: #selector(toggleFlashAction(_:)), for: .touchUpInside)
        self.view.addSubview(flashButton)*/
    }
}

