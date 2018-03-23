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
    
    //AUDIO
    var engine = AVAudioEngine()
    var distortion = AVAudioUnitDistortion()
    var reverb = AVAudioUnitReverb()
    var myTone = MyAVAudioPlayerNode()
    
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
            
            let videoDeviceInput = try AVCaptureDeviceInput(device: defaultVideoDevice!)
            
            if session.canAddInput(videoDeviceInput) {
                session.addInput(videoDeviceInput)
                self.videoDeviceInput = videoDeviceInput
                self.previewView?.videoPreviewLayer.connection!.videoOrientation = .portrait
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

            //Chosing different sound for different classification
            switch classifications.components(separatedBy: "\n")[1] {
            case ModelStatesStringEnum.HAND:
                let freq = PlaygroundManager.shared.currentFrequency * pow(2.0, TonesEnum.NO_HAND)
                
                self.myTone.frequency = freq
                self.myTone.amplitude = PlaygroundManager.shared.currentAmplitude

                if !self.myTone.isPlaying {
                    self.myTone.preparePlaying()
                    self.myTone.play()
                    self.engine.mainMixerNode.volume = 1.0
                }
            case ModelStatesStringEnum.HAND_1:
                let freq = PlaygroundManager.shared.currentFrequency * pow(2.0, TonesEnum.HAND_1)
                self.myTone.frequency = freq
                self.myTone.amplitude = PlaygroundManager.shared.currentAmplitude

                if !self.myTone.isPlaying {
                    self.myTone.preparePlaying()
                    self.myTone.play()
                    self.engine.mainMixerNode.volume = 1.0
                }
            case ModelStatesStringEnum.HAND_2:
                let freq = PlaygroundManager.shared.currentFrequency * pow(2.0, TonesEnum.HAND_2)
                self.myTone.frequency = freq
                self.myTone.amplitude = PlaygroundManager.shared.currentAmplitude

                if !self.myTone.isPlaying {
                    self.myTone.preparePlaying()
                    self.myTone.play()
                    self.engine.mainMixerNode.volume = 1.0
                }
            case ModelStatesStringEnum.HAND_3:
                let freq = PlaygroundManager.shared.currentFrequency * pow(2.0, TonesEnum.HAND_3)
                self.myTone.frequency = freq
                self.myTone.amplitude = PlaygroundManager.shared.currentAmplitude

                if !self.myTone.isPlaying {
                    self.myTone.preparePlaying()
                    self.myTone.play()
                    self.engine.mainMixerNode.volume = 1.0
                }
            case ModelStatesStringEnum.HAND_4:
                let freq = PlaygroundManager.shared.currentFrequency * pow(2.0, TonesEnum.HAND_4)
                self.myTone.frequency = freq
                self.myTone.amplitude = 1

                if !self.myTone.isPlaying {
                    self.myTone.preparePlaying()
                    self.myTone.play()
                    self.engine.mainMixerNode.volume = 1.0
                }
            case ModelStatesStringEnum.HAND_5:
                let freq = PlaygroundManager.shared.currentFrequency * pow(2.0, TonesEnum.HAND_5)
                self.myTone.frequency = freq
                self.myTone.amplitude = PlaygroundManager.shared.currentAmplitude

                if !self.myTone.isPlaying {
                    self.myTone.preparePlaying()
                    self.myTone.play()
                    self.engine.mainMixerNode.volume = 1.0
                }
            case ModelStatesStringEnum.HAND_6:
                let freq = PlaygroundManager.shared.currentFrequency * pow(2.0, TonesEnum.HAND_6)
                self.myTone.frequency = freq
                self.myTone.amplitude = PlaygroundManager.shared.currentAmplitude

                if !self.myTone.isPlaying {
                    self.myTone.preparePlaying()
                    self.myTone.play()
                    self.engine.mainMixerNode.volume = 1.0
                }
            default:
                self.engine.mainMixerNode.volume = 0.0
                self.myTone.stop()
            }
            
        }
        
    }
    
    func setUpCoreMLModel() {
        guard let selectedModel = try? VNCoreMLModel(for: hand_recognizer_model_2().model) else {
            fatalError("Could not load model. Ensure model has been drag and dropped (copied) to XCode Project. Also ensure the model is part of a target (see: https://stackoverflow.com/questions/45884085/model-is-not-part-of-any-target-add-the-model-to-a-target-to-enable-generation ")
        }
        
        // Set up Vision-CoreML Request
        handDetectionRequest = VNCoreMLRequest(model: selectedModel, completionHandler: classificationCompleteHandler)
        
        requests = [handDetectionRequest]
    }
    
    func setUpView() {
        
        self.view = UIView()
        self.view.frame = CGRect(x: 0, y: 0, width: 500, height: 500)
        
        self.view.backgroundColor = .brown
        
        buttonLeft = UIButton.init(frame:CGRect.init(x: 50, y: 130, width: 50, height:50))
        buttonLeft?.backgroundColor = .white
        buttonLeft?.addTarget(self, action: #selector(buttonLeftPressed), for: .touchUpInside)
        
        
        buttonRight = UIButton.init(frame:CGRect.init(x: self.view.frame.width - 50, y: 130, width: 50, height:50))
        buttonRight?.backgroundColor = .white
        buttonRight?.addTarget(self, action: #selector(buttonRightPressed), for: .touchUpInside)
        
        self.view.addSubview(buttonLeft!)
        self.view.addSubview(buttonRight!)
        
        sliderFrequency = UISlider.init(frame: CGRect.init(x: self.view.frame.width/2, y: self.view.frame.height/2, width: 300, height:50))
        
        sliderFrequency?.minimumValue = -5.0
        sliderFrequency?.maximumValue = 5.0
        sliderFrequency?.addTarget(self, action: #selector(sliderValueDidChange(_:)), for: .valueChanged)
        
        self.view.addSubview(sliderFrequency!)
        
        self.labeClassification = UILabel.init(frame: CGRect.init(x: self.view.frame.width/2, y: self.view.frame.height/3, width: 100, height: 50))
        self.labeClassification?.backgroundColor = UIColor.clear
        self.labeClassification?.font = UIFont.systemFont(ofSize: 20)
        self.view.addSubview(self.labeClassification!)
        
        
        
        previewView = PreviewView()
        previewView?.session = session
        
        self.view.addSubview(previewView!)
    }
    
    func setupSound() {
        let format = AVAudioFormat(standardFormatWithSampleRate: myTone.sampleRate, channels: 1)
        
        engine = AVAudioEngine()
        engine.attach(myTone)
        let mixer = engine.mainMixerNode
        engine.connect(myTone, to: mixer, format: format)
        do {
            try engine.start()
        } catch let error as NSError {
            print(error)
        }
        
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
