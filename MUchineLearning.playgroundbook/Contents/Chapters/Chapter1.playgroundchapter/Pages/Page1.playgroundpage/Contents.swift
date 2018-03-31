
//#-hidden-code

import UIKit
import PlaygroundSupport
import Vision
import AVFoundation

if #available(iOSApplicationExtension 11.0, *) {
    let viewController = MainViewController()
    PlaygroundPage.current.liveView = viewController
    PlaygroundPage.current.needsIndefiniteExecution = true
} else {
    print("Run this Playbook on iPad with iOS 11")
}
//#-end-hidden-code
/*:
 # Let's start
 ### Just tap Run Code and put your hand on the camera

 ---
 
 # MUchineLearning
 ## (_MUsic Machine_ and _Machine Learning_)
 ### let you play music with the gestures of your hand!
 
 Try to discover all the possible combinations of gestures  and instruments you can have fun with!
 
 In order to improve your experience, just remind to:
 
 1. Turn up the volume
 2. Put your iPad on a table or an other horizontal surface
 3. Put your hand on the front camera at 20/30 cm of distance
 4. Enjoy it
 
 */
