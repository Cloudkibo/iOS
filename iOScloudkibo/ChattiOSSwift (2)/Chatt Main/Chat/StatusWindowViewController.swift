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
    
    var recognizer=UITapGestureRecognizer.init()
    var myviewgallery=UIView.init()
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
    
    var images=[UIImageView]()
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
        //!!self.fetchPhotosFromGallery()
        self.recognizer.delegate = self
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
         myviewgallery=UIView.init(frame: CGRect(x: 10, y: view.frame.height - 250, width: 575.0, height: 100.0))
        myviewgallery.addSubview(scrollView)
        view.addSubview(myviewgallery)
        
        //!!view.addSubview(scrollView)
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[scrollView]|", options: .alignAllCenterX, metrics: nil, views: ["scrollView": scrollView]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[scrollView]|", options: .alignAllCenterX, metrics: nil, views: ["scrollView": scrollView]))
        
        
        stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        scrollView.addSubview(stackView)
        
        scrollView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[stackView]|", options: NSLayoutFormatOptions.alignAllCenterX, metrics: nil, views: ["stackView": stackView]))
        scrollView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[stackView]", options: NSLayoutFormatOptions.alignAllCenterX, metrics: nil, views: ["stackView": stackView]))
        var imgview=UIImageView.init()
        
        DispatchQueue.global(qos: .background).async {
        //==--self.myfetch()
        }
       
        /*for imgs in images{
         
             //imgview=UIImageView.init(image:self.getAssetThumbnail(asset: imgs))
            imgview=UIImageView.init(image:imgs)
            stackView.addArrangedSubview(imgview1)
            
        }*/
       /* let imgManager = PHImageManager.default()
        
        // Note that if the request is not set to synchronous
        // the requestImageForAsset will return both the image
        // and thumbnail; by setting synchronous to true it
        // will return just the thumbnail
        var requestOptions = PHImageRequestOptions()
        requestOptions.isSynchronous = false
        
        // Sort the images by creation date
        var fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key:"creationDate", ascending: true)]
        
        if let fetchResult: PHFetchResult = PHAsset.fetchAssets(with: PHAssetMediaType.image, options: fetchOptions) {
            
            // If the fetch result isn't empty,
            // proceed with the image request
            for i in 0..<fetchResult.count-1{
                // Perform the image request
                imgManager.requestImage(for: fetchResult.object(at: i) as PHAsset, targetSize: view.frame.size, contentMode: PHImageContentMode.aspectFill, options: requestOptions, resultHandler: { (image, _) in
                    
                    // Add the returned image to your array
                    if(image != nil)
                    {
                        self.images.append((image)!)
                        self.stackView.addArrangedSubview(UIImageView.init(image: image))
                    }
                    // If you haven't already reached the first
                    // index of the fetch result and if you haven't
                    // already stored all of the images you need,
                    // perform the fetch request again with an
                    // incremented index
                    /* if index + 1 < fetchResult.count && self.images.count < self.totalImageCountNeeded {
                     self.fetchPhotoAtIndexFromEnd(index + 1)
                     } else {
                     // Else you have completed creating your array
                     println("Completed array: \(self.images)")
                     }*/
                    //})
                    // }
                })
            }
        }*/
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
        //!!self.view.addSubview(scrollView)
        
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
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func myfetch()
    {
        //var phassetcollection1=PHAssetCollection.init()
        
     //   fetchOptions.predicate = NSPredicate(format: "title = %@", self.albumName)?
        let collection:PHFetchResult = PHAssetCollection.fetchAssetCollections(with: .moment, subtype: .any, options: nil)
        if let first_Obj:AnyObject = collection.firstObject{
            //found the album
          // phassetcollection1 = collection.firstObject! as PHAssetCollection
           //!! self.albumFound = true
        }
        else {
            //!!albumFound = false
        }
        //var i = collection.count
        var photoAssets=PHAsset.fetchAssets(with: .image, options: nil)
        //!!!var photoAssets = PHAsset.fetchAssets(in: phassetcollection1, options: nil)
        let imageManager = PHCachingImageManager()
        
        photoAssets.enumerateObjects({(object: AnyObject!,
            count: Int,
            stop: UnsafeMutablePointer<ObjCBool>) in
            
            if object is PHAsset{
                let asset = object as! PHAsset
                print("Inside  If object is PHAsset, This is number 1")
                
                //!!let imageSize = CGSize(width: asset.pixelWidth,
                                      // height: asset.pixelHeight)
                let imageSize = CGSize(width: 100,
                                       height: 100)
                
                /* For faster performance, and maybe degraded image */
                let options = PHImageRequestOptions()
                options.deliveryMode = .fastFormat
                options.isSynchronous = false
                imageManager.requestImage(for: asset,
                                                  targetSize: imageSize,
                                                  contentMode: .aspectFit,
                                                  options: options,
                                                  resultHandler: {
                                                    image, info in
                                                    
                                                    self.images.append(UIImageView.init(image: image!))
                                                    
                                                    self.stackView.addArrangedSubview(UIImageView.init(image: image!))
                                                    print("adding tap gesture")
                                                    let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.stackImageTapped(_:)))
                                                    
                                                    tapRecognizer.delegate=self
                                                    /// img.addTarget(self, action: #selector(self.selectImageView(_:)), for:.touchUpInside)
                                                    
                                                    self.stackView.arrangedSubviews.last?.addGestureRecognizer(tapRecognizer)

                                                   // var gest = UITapGestureRecognizer(
                                                    
                                                        var img=self.stackView.subviews.last as! UIImageView
                                                    
                                               
                                                    //!!!!self.photo = image!
                                                    /* The image is now available to us */
                                                    //!!!!self.sendPhotos(self.photo)
                                                    print("enum for image, This is number 2")
                                                    
                                                    
                })
            }
        })
       /* for ind in 0..<stackView.arrangedSubviews.count{
            print("adding tap gesture \(ind)")
            let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.stackImageTapped(_:)))
            
            /// img.addTarget(self, action: #selector(self.selectImageView(_:)), for:.touchUpInside)
            
            self.stackView.arrangedSubviews[ind].addGestureRecognizer(tapRecognizer)
        }*/
    }

    //stackImageTapped
    func stackImageTapped(_ recognizer: UITapGestureRecognizer) {
        print("stackImageTapped")
        if let selectedImageView = recognizer.view as? UIImageView {
            selectImageView(imgView: selectedImageView)
        }
    }
    
  /*  func selectImageView(_ sender:AnyObject!)
    { print("stackImageTapped1")
        var photoview=sender as! UIImageView
        var photo=photoview.image
        let newVC = StatusPhotoViewController(image: photo!)
        self.present(newVC, animated: true){
            //self.dismiss(animated: true){
            
            // }
        }
    }
    */
    func selectImageView(imgView:UIImageView)
    {
        var photo=imgView.image
    let newVC = StatusPhotoViewController(image: photo!)
    self.present(newVC, animated: true){
    //self.dismiss(animated: true){
    
    // }
    }
    }
    
   /* func fetchPhotosFromGallery() {
        
        let imgManager = PHImageManager.default()
        
        // Note that if the request is not set to synchronous
        // the requestImageForAsset will return both the image
        // and thumbnail; by setting synchronous to true it
        // will return just the thumbnail
        var requestOptions = PHImageRequestOptions()
        requestOptions.isSynchronous = false
        
        // Sort the images by creation date
        var fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key:"creationDate", ascending: true)]
        
        if let fetchResult: PHFetchResult = PHAsset.fetchAssets(with: PHAssetMediaType.image, options: fetchOptions) {
            
            // If the fetch result isn't empty,
            // proceed with the image request
            for i in 0..<fetchResult.count-1{
                // Perform the image request
                imgManager.requestImage(for: fetchResult.object(at: i) as PHAsset, targetSize: view.frame.size, contentMode: PHImageContentMode.aspectFill, options: requestOptions, resultHandler: { (image, _) in
                    
                    // Add the returned image to your array
                    if(image != nil)
                    {
                    self.images.append((image)!)
                    }
                    // If you haven't already reached the first
                    // index of the fetch result and if you haven't
                    // already stored all of the images you need,
                    // perform the fetch request again with an
                    // incremented index
                   /* if index + 1 < fetchResult.count && self.images.count < self.totalImageCountNeeded {
                        self.fetchPhotoAtIndexFromEnd(index + 1)
                    } else {
                        // Else you have completed creating your array
                        println("Completed array: \(self.images)")
                    }*/
                //})
           // }
        })
    }
        }
    }
    */
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
        print("video url \(url)")
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
        
        var lbl=UILabel.init(frame:CGRect(x: view.frame.midX - 100, y: view.frame.height - 100, width: 250.0, height: 75.0))
        lbl.text="Hold for video, tap for photo"
        lbl.textColor = .white
        lbl.shadowColor = .black
        self.view.addSubview(lbl)
        
        /*
        let test = CGFloat((view.frame.width - (view.frame.width / 2 + 37.5)) + ((view.frame.width / 2) - 37.5) - 9.0)
        
        flashButton = UIButton(frame: CGRect(x: test, y: view.frame.height - 77.5, width: 18.0, height: 30.0))
        flashButton.setImage(#imageLiteral(resourceName: "flashOutline"), for: UIControlState())
        flashButton.addTarget(self, action: #selector(toggleFlashAction(_:)), for: .touchUpInside)
        self.view.addSubview(flashButton)*/
    }
}

