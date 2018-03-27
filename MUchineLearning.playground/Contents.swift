//#-hidden-code

import UIKit
import PlaygroundSupport
import Vision
import AVFoundation



public class MainViewController:UIViewController{
    
    //VIEW COMPONENTS
    var buttonLeft: UIButton?
    var buttonRight: UIButton?
    var instrumentImageView: UIImageView?
    
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
            
            
            //Chosing different sound for different classification
            switch classifications.components(separatedBy: "\n")[1] {
            case ModelStatesStringEnum.HAND:
                AudioManager.sharedInstance.playSoundFromArray(gesture: ModelStatesEnum.HAND)
                if let preview = self.view as? MainView {
                    preview.previewImage?.image = UIImage(named:"hand_0")
                }
                break

            case ModelStatesStringEnum.HAND_0:
                AudioManager.sharedInstance.playSoundFromArray(gesture: ModelStatesEnum.HAND_0)
                if let preview = self.view as? MainView {
                    preview.previewImage?.image = UIImage(named:"hand_0")
                }
                break
            case ModelStatesStringEnum.HAND_1:
                AudioManager.sharedInstance.playSoundFromArray(gesture: ModelStatesEnum.HAND_1)
                if let preview = self.view as? MainView {
                    preview.previewImage?.image = UIImage(named:"hand_1")
                }
                break

            case ModelStatesStringEnum.HAND_2:
                AudioManager.sharedInstance.playSoundFromArray(gesture: ModelStatesEnum.HAND_2)
                if let preview = self.view as? MainView {
                    preview.previewImage?.image = UIImage(named:"hand_2")
                }
                break

            case ModelStatesStringEnum.HAND_3:
                AudioManager.sharedInstance.playSoundFromArray(gesture: ModelStatesEnum.HAND_3)
                if let preview = self.view as? MainView {
                    preview.previewImage?.image = UIImage(named:"hand_3")
                }
                break

            case ModelStatesStringEnum.HAND_4:
                AudioManager.sharedInstance.playSoundFromArray(gesture: ModelStatesEnum.HAND_4)
                if let preview = self.view as? MainView {
                    preview.previewImage?.image = UIImage(named:"hand_4")
                }
                break
                

            case ModelStatesStringEnum.HAND_5:
                AudioManager.sharedInstance.playSoundFromArray(gesture: ModelStatesEnum.HAND_5)
                if let preview = self.view as? MainView {
                    preview.previewImage?.image = UIImage(named:"hand_5")
                }
                break

            default:
                AudioManager.sharedInstance.playSoundFromArray(gesture: ModelStatesEnum.CEILING)
                if let preview = self.view as? MainView {
                    preview.previewImage?.image = UIImage(named:"no_hand")
                }
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
    
    func setupSound() {
       AudioManager.sharedInstance.prepareAudioPlayers(instrument: 0)
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
    
    @objc func buttonRecPressed()
    {
        print("buttonRecPressed")
    }
    
    @objc func buttonPlayPressed()
    {
        print("buttonPlayPressed")
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

let viewController = MainViewController()
PlaygroundPage.current.liveView = viewController
PlaygroundPage.current.needsIndefiniteExecution = true
//#-end-hidden-code

/*:
 ## Let's start
 **Put your hand on top of the camera**!
 
  - - -
 */

/*:
 MUchineLearning is a word created by _MUsic Machine_ and _Machine Learning_
 
 This playground uses machine learning to recognise gestures, that you can easily do with your hand, and it reproduces different sounds based on the different gestures . You can choose different music instruments and, in the bottom of the view, you can see what the playground are recognising every moment.
 To realise this magic, i used Vision and CoreML: very powerful tools. I used Vision to get images catches by the front camera of the iPad and I passed this very heavy flow of information to CoreML that has interpreted it and categorised all the results sorted by percentage of probability.
 Another important need to reach the gaol is the neural network to use with CoreML. I created my personal neural network with my Iphone camera, hundreds photos of my hands and a third part free online tool. This neural network has precision about 90% to recognise the right gesture that you are reproducing: obviously it is influenced by light condition and ceiling color but it works enough well.
 To use the neural network in this playground, I created another project in Xcode that I used to compile the neural network model and then I putted it in to the playground.
 
 It was my first time using machine learning and I was being really fascinated about this world.
 
 At least, some steps to improve your *experience*
 
 1. Use this Playground only on iPad
 2. Turn up the volume
 3. Put your iPad on a table or an other horizontal surface
 4. Run Code
 5. Allow camera permission
 6. Put your hand on the front camera at 20/30 cm of distance
 7. Enjoy
 
 
 About me
 
 I’m Vincenzo Aceto. I’m 28 years old and I came from Cosenza (Italy). I’m a student of Apple Developer Academy at Università Federico II. Before this experience I was a mobile developer for an IT Company and I developer many apps for important customers in Android and Xamarin.
 
 To see all the code of this playground, the modelML of my neural network and all the staffs related to this project, follow my GitHub repository at


 */
