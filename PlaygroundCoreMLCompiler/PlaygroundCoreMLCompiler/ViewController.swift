//
//  ViewController.swift
//  PlaygroundCoreMLCompiler
//
//  Created by Vincenzo Aceto on 20/03/2018.
//  Copyright © 2018 Vincenzo Aceto. All rights reserved.
//

import Foundation
import UIKit
import Vision
import AVFoundation

class ViewController: UIViewController {
    
    //VIDEO
    var handDetectionRequest: VNImageBasedRequest!
    private var requests = [VNRequest]()
    
    private var devicePosition: AVCaptureDevice.Position = .front
    
    private let session = AVCaptureSession()
    private var isSessionRunning = false
    
    private let sessionQueue = DispatchQueue(label: "session queue", attributes: [], target: nil) // Communicate with the session and other session objects on this queue.
    
    private var videoDeviceInput: AVCaptureDeviceInput!
    private var videoDataOutput: AVCaptureVideoDataOutput!
    private var videoDataOutputQueue = DispatchQueue(label: "VideoDataOutputQueue")
    
    public override func loadView() {
        self.view = MainView.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpCoreMLModel()
        setupVision()
        setupSound()
        
        self.configureVideoSession()
        self.session.startRunning()
        
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Only setup observers and start the session running if setup succeeded.
        self.isSessionRunning = self.session.isRunning
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        self.session.stopRunning()
        self.isSessionRunning = self.session.isRunning
        
        super.viewWillDisappear(animated)
    }
    
    private func configureVideoSession() {
        
        session.beginConfiguration()
        session.sessionPreset = .high
        
        // Add video input.
        do {
            var defaultVideoDevice: AVCaptureDevice?
            
            // Choose the front camera
            if let frontCameraDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front){
                defaultVideoDevice = frontCameraDevice
            }
            if defaultVideoDevice != nil {
                let videoDeviceInput = try AVCaptureDeviceInput(device: defaultVideoDevice!)
                
                if session.canAddInput(videoDeviceInput) {
                    session.addInput(videoDeviceInput)
                    self.videoDeviceInput = videoDeviceInput
                    
                }
            } else {
                let alert = UIAlertController(title: "NO CAMERA FOUND", message: "This device can't run the Playground", preferredStyle: .alert)
                self.present(alert, animated: true, completion: nil)
            }
        } catch {
            print("Could not create video device input: \(error)")
            session.commitConfiguration()
            return
        }
        
        // add output
        videoDataOutput = AVCaptureVideoDataOutput()
        videoDataOutput.videoSettings = [(kCVPixelBufferPixelFormatTypeKey as String): Int(kCVPixelFormatType_32BGRA)]
        
        if session.canAddOutput(videoDataOutput) {
            videoDataOutput.alwaysDiscardsLateVideoFrames = true
            videoDataOutput.setSampleBufferDelegate(self, queue: videoDataOutputQueue)
            session.addOutput(videoDataOutput)
        } else {
            print("Could not add metadata output to the session")
            session.commitConfiguration()
            return
        }
        
        session.commitConfiguration()
    }
    
    func classificationCompleteHandler(request: VNRequest, error: Error?) {
        
    }
    
    func setUpCoreMLModel() {
        
        // Choose the model to use with Vision
        guard let selectedModel = try? VNCoreMLModel(for: hand_recognizer_model_3().model) else {
            fatalError("Could not load model.")
        }
        
        // Set up Vision-CoreML Request
        handDetectionRequest = VNCoreMLRequest(model: selectedModel, completionHandler: classificationCompleteHandler)
        
        requests = [handDetectionRequest]
    }
    
    func setupSound() {
        AudioManager.sharedInstance.prepareAudioPlayers(instrument: 0)
    }
    
}

@available(iOS 11.0, *)
extension ViewController {
    func setupVision() {
        self.requests = [handDetectionRequest]
    }
    
}

@available(iOS 11.0, *)
extension ViewController: AVCaptureVideoDataOutputSampleBufferDelegate{
    // MARK: - AVCaptureVideoDataOutputSampleBufferDelegate
    public func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        let exifOrientation = CGImagePropertyOrientation.leftMirrored
        var requestOptions: [VNImageOption : Any] = [:]
        
        if let cameraIntrinsicData = CMGetAttachment(sampleBuffer, kCMSampleBufferAttachmentKey_CameraIntrinsicMatrix, nil) {
            requestOptions = [.cameraIntrinsics : cameraIntrinsicData]
        }
        
        let imageRequestHandler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: exifOrientation, options: requestOptions)
        
        do {
            try imageRequestHandler.perform(requests)
        }
            
        catch {
            print(error)
        }
        
    }
    
}
