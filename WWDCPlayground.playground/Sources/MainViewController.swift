import Foundation
import UIKit
import Vision
import AVFoundation


public class MainViewController:UIViewController{
    
    //VIEW COMPONENTS
    var previewView: PreviewView?
    
    var buttonLeft: UIButton?
    var buttonRight: UIButton?
    var labeClassification: UILabel?
    var sliderFrequency: UISlider?
    
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
    
    
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpView()
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
                    self.previewView?.videoPreviewLayer.connection!.videoOrientation = .portrait
                }
            } else {
                let alert = UIAlertController(title: "NO CAMERA FOUND", message: "This device can't run the Playground", preferredStyle: .alert)
                //alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
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
        
        // Catch Errors
        if error != nil {
            print("Error: " + (error?.localizedDescription)!)
            return
        }
        guard let observations = request.results else {
            print("No results")
            return
        }
        
        // Get Classifications
        let classifications = observations[0...2] // top 3 results
            .flatMap({ $0 as? VNClassificationObservation })
            .map({ "\($0.identifier)" })
            .joined(separator: "\n")
        
        // Render Classifications
        DispatchQueue.main.async {
            
            self.labeClassification?.text = classifications.components(separatedBy: "\n")[1]
            
            //            switch classifications.components(separatedBy: "\n")[1] {
            //            case ModelStatesStringEnum.HAND:
            //                AudioManager.sharedInstance.playSoundFromGesture(gesture: ModelStatesEnum.HAND_1)
            //            default:
            //                AudioManager.sharedInstance.playSoundFromGesture(gesture: ModelStatesEnum.HAND)
            //
            //            }
            
            //Chosing different sound for different classification
            switch classifications.components(separatedBy: "\n")[1] {
            case ModelStatesStringEnum.HAND:
                AudioManager.sharedInstance.playSoundFromArray(gesture: ModelStatesEnum.HAND)
                break
                
            case ModelStatesStringEnum.HAND_1:
                AudioManager.sharedInstance.playSoundFromArray(gesture: ModelStatesEnum.HAND_1)
                break
                
            case ModelStatesStringEnum.HAND_2:
                AudioManager.sharedInstance.playSoundFromArray(gesture: ModelStatesEnum.HAND_2)
                break
                
            case ModelStatesStringEnum.HAND_3:
                AudioManager.sharedInstance.playSoundFromArray(gesture: ModelStatesEnum.HAND_3)
                break
                
            case ModelStatesStringEnum.HAND_4:
                AudioManager.sharedInstance.playSoundFromArray(gesture: ModelStatesEnum.HAND_4)
                break
                
                
            case ModelStatesStringEnum.HAND_5:
                AudioManager.sharedInstance.playSoundFromArray(gesture: ModelStatesEnum.HAND_5)
                break
                
            case ModelStatesStringEnum.HAND_6:
                AudioManager.sharedInstance.playSoundFromArray(gesture: ModelStatesEnum.HAND_6)
                break
            default:
                AudioManager.sharedInstance.playSoundFromArray(gesture: ModelStatesEnum.CEILING)
                break
            }
            
        }
        
    }
    
    func setUpCoreMLModel() {
        guard let selectedModel = try? VNCoreMLModel(for: hand_recognizer_model_2().model) else {
            fatalError("Could not load model.")
        }
        
        // Set up Vision-CoreML Request
        handDetectionRequest = VNCoreMLRequest(model: selectedModel, completionHandler: classificationCompleteHandler)
        
        requests = [handDetectionRequest]
    }
    
    func setUpView() {
        
        self.view = UIView()
        
        let internalView = UIView()
        internalView.frame = CGRect(x: 0, y: 0, width: 500, height: 500)
        internalView.bounds = CGRect(x: 0, y: 0, width: 500, height: 500)
        internalView.backgroundColor = .brown
        
        self.view.addSubview(internalView)
        
        buttonLeft = UIButton.init(frame:CGRect.init(x: 50, y: 130, width: 50, height:50))
        buttonLeft?.backgroundColor = .white
        buttonLeft?.addTarget(self, action: #selector(buttonLeftPressed), for: .touchUpInside)
        
        
        buttonRight = UIButton.init(frame:CGRect.init(x: self.view.frame.width - 50, y: 130, width: 50, height:50))
        buttonRight?.backgroundColor = .white
        buttonRight?.addTarget(self, action: #selector(buttonRightPressed), for: .touchUpInside)
        
        internalView.addSubview(buttonLeft!)
        internalView.addSubview(buttonRight!)
        
        sliderFrequency = UISlider.init(frame: CGRect.init(x: self.view.frame.width/2, y: self.view.frame.height/2, width: 300, height:50))
        
        sliderFrequency?.minimumValue = -5.0
        sliderFrequency?.maximumValue = 5.0
        sliderFrequency?.addTarget(self, action: #selector(sliderValueDidChange(_:)), for: .valueChanged)
        
        internalView.addSubview(sliderFrequency!)
        
        self.labeClassification = UILabel.init(frame: CGRect.init(x: self.view.frame.width/2, y: self.view.frame.height/3, width: 100, height: 50))
        self.labeClassification?.backgroundColor = UIColor.clear
        self.labeClassification?.font = UIFont.systemFont(ofSize: 20)
        internalView.addSubview(self.labeClassification!)
        
        
        
        previewView = PreviewView()
        previewView?.session = session
        
        internalView.addSubview(previewView!)
    }
    
    func setupSound() {
        AudioManager.sharedInstance.prepareAudioPlayers(instrument: InstrumentsEnum.BAND)
    }
    
    @objc func buttonLeftPressed()
    {
        print("buttonLeftPressed")
        PlaygroundManager.shared.currentFrequency -= 10
    }
    
    @objc func buttonRightPressed()
    {
        print("buttonRightPressed")
        PlaygroundManager.shared.currentFrequency += 10
    }
    
    @objc func sliderValueDidChange(_ sender:UISlider!)
    {
        print("FrequencySlider value: \(sender.value)")
        PlaygroundManager.shared.currentFrequency = Double(sender.value)
    }
    
}

extension MainViewController {
    func setupVision() {
        self.requests = [handDetectionRequest]
    }
    
}

extension MainViewController: AVCaptureVideoDataOutputSampleBufferDelegate{
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