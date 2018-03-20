import UIKit
import PlaygroundSupport
import Vision
import AVFoundation


class ViewController:UIViewController{
    
    var handDetectionRequest: VNImageBasedRequest!
    private var requests = [VNRequest]()
    
    var previewView: PreviewView?
    
    var buttonLeft: UIButton?
    var buttonRight: UIButton?
    var labeClassification: UILabel?
    
    private var devicePosition: AVCaptureDevice.Position = .front
    
    private let session = AVCaptureSession()
    private var isSessionRunning = false
    
    private let sessionQueue = DispatchQueue(label: "session queue", attributes: [], target: nil) // Communicate with the session and other session objects on this queue.
    
    private var videoDeviceInput: AVCaptureDeviceInput!
    
    private var videoDataOutput: AVCaptureVideoDataOutput!
    private var videoDataOutputQueue = DispatchQueue(label: "VideoDataOutputQueue")

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .brown
        
        buttonLeft = UIButton.init(frame:CGRect.init(x: 50, y: 107, width: 50, height:50))
        buttonLeft?.backgroundColor = .white
        buttonRight = UIButton.init(frame:CGRect.init(x: self.view.frame.width - 50, y: 130, width: 50, height:50))
        buttonRight?.backgroundColor = .white

        
        self.view.addSubview(buttonLeft!)
        self.view.addSubview(buttonRight!)
        
        self.labeClassification = UILabel.init(frame: CGRect.init(x: 50, y: 200, width: UIScreen.main.bounds.width-20, height: 15))
        self.labeClassification?.backgroundColor = UIColor.clear
        self.labeClassification?.font = UIFont.systemFont(ofSize: 12)
        self.view.addSubview(self.labeClassification!)

        
        
        previewView = PreviewView()
        previewView?.session = session

        self.view.addSubview(previewView!)
        
        guard let selectedModel = try? VNCoreMLModel(for: hand_recognizer_model().model) else {
            fatalError("Could not load model. Ensure model has been drag and dropped (copied) to XCode Project. Also ensure the model is part of a target (see: https://stackoverflow.com/questions/45884085/model-is-not-part-of-any-target-add-the-model-to-a-target-to-enable-generation ")
        }
        
        // Set up Vision-CoreML Request
        handDetectionRequest = VNCoreMLRequest(model: selectedModel, completionHandler: classificationCompleteHandler)
        //handDetectionRequest.imageCropAndScaleOption = VNImageCropAndScaleOption.centerCrop // Crop from centre of images and scale to appropriate size.
        requests = [handDetectionRequest]

        setupVision()
        
        self.configureSession()
        self.session.startRunning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Only setup observers and start the session running if setup succeeded.
        self.isSessionRunning = self.session.isRunning
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.session.stopRunning()
        self.isSessionRunning = self.session.isRunning
        
        super.viewWillDisappear(animated)
    }
    
    private func configureSession() {
        
        session.beginConfiguration()
        session.sessionPreset = .high
        
        // Add video input.
        do {
            var defaultVideoDevice: AVCaptureDevice?
            
            // Choose the front camera
            if let frontCameraDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: AVMediaType.video, position: .front) {
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
            .map({ "\($0.identifier) \(String(format:" : %.2f", $0.confidence))" })
            .joined(separator: "\n")
        
        // Render Classifications
        DispatchQueue.main.async {
            // Print Classifications
             print(classifications)
            // print("-------------")
            
            // Display Debug Text on screen
            
            
            self.labeClassification?.text = classifications.components(separatedBy: "\n")[0]

        }
    }
    
}

extension ViewController {
    func setupVision() {
        self.requests = [handDetectionRequest]
    }
    
}

extension ViewController: AVCaptureVideoDataOutputSampleBufferDelegate{
    // MARK: - AVCaptureVideoDataOutputSampleBufferDelegate
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
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



let viewController = ViewController()
PlaygroundPage.current.liveView = viewController
PlaygroundPage.current.needsIndefiniteExecution = true
/*:
 ## Let's start
 Test text
 **Next Chapter**!
 */


