import Foundation
import AVFoundation
import PhotosUI

protocol CameraManDelegate: class {
  func cameraManNotAvailable(_ cameraMan: CameraMan)
  func cameraManDidStart(_ cameraMan: CameraMan)
  func cameraMan(_ cameraMan: CameraMan, didChangeInput input: AVCaptureDeviceInput)
 func startVideoRecording(videofileoutput1:AVCaptureMovieFileOutput?,outputFilePath1:URL)
}

class CameraMan {
  weak var delegate: CameraManDelegate?

    
    var isVideoRecording=false
  let session = AVCaptureSession()
  let queue = DispatchQueue(label: "no.hyper.ImagePicker.Camera.SessionQueue")

  var backCamera: AVCaptureDeviceInput?
  var frontCamera: AVCaptureDeviceInput?
    //!!IMPORTANT
    var videoFileOutput:AVCaptureMovieFileOutput?
    
 // var videoFileOutput:AVCaptureMovieFileOutput?
  var stillImageOutput: AVCaptureStillImageOutput?
  var startOnFrontCamera: Bool = false

  deinit {
    stop()
  }

  // MARK: - Setup

  func setup(_ startOnFrontCamera: Bool = false) {
    self.startOnFrontCamera = startOnFrontCamera
    checkPermission()
  }

  func setupDevices() {
    // Input
    /*AVCaptureDevice
    .devices()
        
        .flatMap {
      return $0 as? AVCaptureDevice
    }/*.filter {
      return $0.hasMediaType(AVMediaTypeVideo)
    }*/
        //.forEach {
      switch $0.position {
      case .front:
        self.frontCamera = try? AVCaptureDeviceInput(device: $0)
      case .back:
        self.backCamera = try? AVCaptureDeviceInput(device: $0)
      default:
        break
      }
   // }
    */
    if let devices = AVCaptureDevice.devices(withMediaType: AVMediaTypeVideo) as? [AVCaptureDevice] {
        switch devices.first.flatMap({return $0 as? AVCaptureDevice})?.position.rawValue
        {
        case 2?:
            self.frontCamera = try? AVCaptureDeviceInput(device: devices.first)
        case 1?: //1
            self.backCamera = try? AVCaptureDeviceInput(device: devices.first)
        default:
            break
        }
    }
    
    // Output
    stillImageOutput = AVCaptureStillImageOutput()
    stillImageOutput?.outputSettings = [AVVideoCodecKey: AVVideoCodecJPEG]
    videoFileOutput = AVCaptureMovieFileOutput()
   /* if self.session.canAddOutput(videoFileOutput) {
        self.session.addOutput(videoFileOutput)
        if let connection = videoFileOutput?.connection(withMediaType: AVMediaTypeVideo) {
            if connection.isVideoStabilizationSupported {
                connection.preferredVideoStabilizationMode = .auto
            }
        }
        
        
    videoFileOutput = AVCaptureMovieFileOutput()
    }
    self.session.commitConfiguration()
   */
  }
    
    fileprivate func configurePhotoOutput() {
        let photoFileOutput = AVCaptureStillImageOutput()
        
        if self.session.canAddOutput(photoFileOutput) {
            photoFileOutput.outputSettings  = [AVVideoCodecKey: AVVideoCodecJPEG]
            self.session.addOutput(photoFileOutput)
            self.stillImageOutput = photoFileOutput
        }
    }

   /* func addVideoInput() {
        switch currentInput {
        /*case self.frontCamera:
            videoDevice = SwiftyCamViewController.deviceWithMediaType(AVMediaTypeVideo, preferringPosition: .front)
        case self.backCamera:
            videoDevice = SwiftyCamViewController.deviceWithMediaType(AVMediaTypeVideo, preferringPosition: .back)
        }*/
        
        /*if let device = videoDevice {
            do {
                try device.lockForConfiguration()
                if device.isFocusModeSupported(.continuousAutoFocus) {
                    device.focusMode = .continuousAutoFocus
                    if device.isSmoothAutoFocusSupported {
                        device.isSmoothAutoFocusEnabled = true
                    }
                }
                
                if device.isExposureModeSupported(.continuousAutoExposure) {
                    device.exposureMode = .continuousAutoExposure
                }
                
                if device.isWhiteBalanceModeSupported(.continuousAutoWhiteBalance) {
                    device.whiteBalanceMode = .continuousAutoWhiteBalance
                }
                
                if device.isLowLightBoostSupported && lowLightBoost == true {
                    device.automaticallyEnablesLowLightBoostWhenAvailable = true
                }
                
                device.unlockForConfiguration()
            } catch {
                print("[SwiftyCam]: Error locking configuration")
            }
        }
        */
 
        do {
         //   let videoDeviceInput = try AVCaptureDeviceInput(device: videoDevice)
            
            if session.canAddInput(currentInput) {
                session.addInput(videoDeviceInput)
                self.videoDeviceInput = videoDeviceInput
            } else {
                print("[SwiftyCam]: Could not add video device input to the session")
                print(session.canSetSessionPreset(videoInputPresetFromVideoQuality(quality: videoQuality)))
                setupResult = .configurationFailed
                session.commitConfiguration()
                return
            }
        } catch {
            print("[SwiftyCam]: Could not create video device input: \(error)")
            setupResult = .configurationFailed
            return
        }
    }

    }*/
    
  func addInput(_ input: AVCaptureDeviceInput) {
    configurePreset(input)

    if session.canAddInput(input) {
      session.addInput(input)

      DispatchQueue.main.async {
        self.delegate?.cameraMan(self, didChangeInput: input)
      }
    }
  }

  // MARK: - Permission

  func checkPermission() {
    let status = AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo)

    switch status {
    case .authorized:
      start()
    case .notDetermined:
      requestPermission()
    default:
      delegate?.cameraManNotAvailable(self)
    }
  }

  func requestPermission() {
    AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeVideo) { granted in
      DispatchQueue.main.async {
        if granted {
          self.start()
        } else {
          self.delegate?.cameraManNotAvailable(self)
        }
      }
    }
  }

  // MARK: - Session

  var currentInput: AVCaptureDeviceInput? {
    return session.inputs.first as? AVCaptureDeviceInput
  }

  fileprivate func start() {
    // Devices
    setupDevices()

    //!! guard let input = (self.startOnFrontCamera) ? frontCamera ?? backCamera : backCamera, let output = stillImageOutput else { return }
     let imageinput = (self.startOnFrontCamera) ? frontCamera ?? backCamera : backCamera, output = stillImageOutput
   
    let videoinput = (self.startOnFrontCamera) ? frontCamera ?? backCamera : backCamera, videooutput = videoFileOutput
    
    addInput(imageinput!)
    addInput(videoinput!)

    if session.canAddOutput(output) {
      session.addOutput(output)
    }
    if session.canAddOutput(videooutput) {
        session.addOutput(videooutput)
    }

    queue.async {
      self.session.startRunning()

      DispatchQueue.main.async {
        self.delegate?.cameraManDidStart(self)
      }
    }
  }

  func stop() {
    self.session.stopRunning()
  }

  func switchCamera(_ completion: (() -> Void)? = nil) {
    guard let currentInput = currentInput
      else {
        completion?()
        return
    }

    queue.async {
      guard let input = (currentInput == self.backCamera) ? self.frontCamera : self.backCamera
        else {
          DispatchQueue.main.async {
            completion?()
          }
          return
      }

      self.configure {
        self.session.removeInput(currentInput)
        self.addInput(input)
      }

      DispatchQueue.main.async {
        completion?()
      }
    }
  }

    
    func takeVideo(_ previewLayer: AVCaptureVideoPreviewLayer, location: CLLocation?, completion: (() -> Void)? = nil) {
        //guard let connection = videoFileOutput?.connection(withMediaType: AVMediaTypeVideo) else { return }
        print("inside take video .. 1")
        //connection.videoOrientation = Helper.videoOrientation()
        
       /* queue.async {
            self.videoFileOutput?.captureStillImageAsynchronously(from: connection) {
                buffer, error in
                
                guard let buffer = buffer, error == nil && CMSampleBufferIsValid(buffer),
                    
                    
                    let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(buffer),
                    let image = UIImage(data: imageData)
                    else {
                        DispatchQueue.main.async {
                            completion?()
                        }
                        return
                }
                
                self.savePhoto(image, location: location, completion: completion)
            }
        }*/
        print("self.videoFileOutput?.isRecording is \(self.videoFileOutput?.isRecording)")
        queue.async { [unowned self] in
            if !(self.videoFileOutput?.isRecording)! {
                if UIDevice.current.isMultitaskingSupported {
                    //!!self.backgroundRecordingID = UIApplication.shared.beginBackgroundTask(expirationHandler: nil)
                }
                
                // Update the orientation on the movie file output video connection before starting recording.
                let movieFileOutputConnection = self.videoFileOutput?.connection(withMediaType: AVMediaTypeVideo)
                
                
                //flip video output if front facing camera is selected
                if (self.currentInput?.device.position == .front) {
                    movieFileOutputConnection?.isVideoMirrored = true
                }
                
                movieFileOutputConnection?.videoOrientation = Helper.videoOrientation()
                // Start recording to a temporary file.
                let outputFileName = UUID().uuidString
                let outputFilePath = (NSTemporaryDirectory() as NSString).appendingPathComponent((outputFileName as NSString).appendingPathExtension("mov")!)
                print("outputFilePath is \(outputFilePath)")
                self.delegate?.startVideoRecording(videofileoutput1:self.videoFileOutput,outputFilePath1:URL(fileURLWithPath: outputFilePath))
                
              //!!  self.videoFileOutput?.startRecording(toOutputFileURL: URL(fileURLWithPath: outputFilePath), recordingDelegate: CameraView.init())
                self.isVideoRecording = true
                DispatchQueue.main.async {
                    //self.cameraDelegate?.swiftyCam(self, didBeginRecordingVideo: self.currentCamera)
                }
            }
            else {
                self.videoFileOutput?.stopRecording()
            }
        }
        
        
        
        
    }
    
    public func stopVideoRecording() {
        if self.videoFileOutput?.isRecording == true {
            self.isVideoRecording = false
            videoFileOutput!.stopRecording()
            //self.delegate?.stopVideoRecording()
            //!!disableFlash()
           /*
            if currentInput?.device.position == .front && flashEnabled == true && flashView != nil {
                UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveEaseInOut, animations: {
                    self.flashView?.alpha = 0.0
                }, completion: { (_) in
                    self.flashView?.removeFromSuperview()
                })
            }*/
            DispatchQueue.main.async {
               //!! self.cameraDelegate?.swiftyCam(self, didFinishRecordingVideo: self.currentCamera)
            }
        }
    }
    
    
    
  func takePhoto(_ previewLayer: AVCaptureVideoPreviewLayer, location: CLLocation?, completion: (() -> Void)? = nil) {
    guard let connection = stillImageOutput?.connection(withMediaType: AVMediaTypeVideo) else { return }

    connection.videoOrientation = Helper.videoOrientation()

    queue.async {
      self.stillImageOutput?.captureStillImageAsynchronously(from: connection) {
        buffer, error in

        
        
        guard let buffer = buffer, error == nil && CMSampleBufferIsValid(buffer),
            
          //!!  videoFileOutput?.startRecording(toOutputFileURL: <#T##URL!#>, recordingDelegate: <#T##AVCaptureFileOutputRecordingDelegate!#>)
            
          let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(buffer),
          let image = UIImage(data: imageData)
          else {
            DispatchQueue.main.async {
              completion?()
            }
            return
        }

        self.savePhoto(image, location: location, completion: completion)
      }
    }
  }

  
    
  func savePhoto(_ image: UIImage, location: CLLocation?, completion: (() -> Void)? = nil) {
    PHPhotoLibrary.shared().performChanges({
      let request = PHAssetChangeRequest.creationRequestForAsset(from: image)
      request.creationDate = Date()
      request.location = location
      }, completionHandler: { _ in
        DispatchQueue.main.async {
            
            
          completion?()
        }
    })
  }

  func flash(_ mode: AVCaptureFlashMode) {
    guard let device = currentInput?.device, device.isFlashModeSupported(mode) else { return }

    queue.async {
      self.lock {
        device.flashMode = mode
      }
    }
  }

  func focus(_ point: CGPoint) {
    guard let device = currentInput?.device, device.isFocusModeSupported(AVCaptureFocusMode.locked) else { return }

    queue.async {
      self.lock {
        device.focusPointOfInterest = point
      }
    }
  }

  // MARK: - Lock

  func lock(_ block: () -> Void) {
    if let device = currentInput?.device, (try? device.lockForConfiguration()) != nil {
      block()
      device.unlockForConfiguration()
    }
  }

  // MARK: - Configure
  func configure(_ block: () -> Void) {
    session.beginConfiguration()
    block()
    session.commitConfiguration()
  }

  // MARK: - Preset

  func configurePreset(_ input: AVCaptureDeviceInput) {
    for asset in preferredPresets() {
      if input.device.supportsAVCaptureSessionPreset(asset) && self.session.canSetSessionPreset(asset) {
        self.session.sessionPreset = asset
        return
      }
    }
  }

  func preferredPresets() -> [String] {
    return [
      AVCaptureSessionPresetHigh,
      AVCaptureSessionPresetMedium,
      AVCaptureSessionPresetLow
    ]
  }
}
