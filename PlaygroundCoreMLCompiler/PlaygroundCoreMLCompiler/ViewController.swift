//
//  ViewController.swift
//  PlaygroundCoreMLCompiler
//
//  Created by Vincenzo Aceto on 20/03/2018.
//  Copyright © 2018 Vincenzo Aceto. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func loadView() {
        self.view = MainView.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width))
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let model = hand_recognizer_model()
        AudioManager.sharedInstance.prepareAudioPlayers(instrument: InstrumentsEnum.BAND)
        AudioManager.sharedInstance.playSoundFromArray(gesture: ModelStatesEnum.HAND_1)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            AudioManager.sharedInstance.playSoundFromArray(gesture: ModelStatesEnum.HAND)
            DispatchQueue.main.asyncAfter(deadline: .now() + 7) {
                AudioManager.sharedInstance.playSoundFromArray(gesture: ModelStatesEnum.HAND_5
                )
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    AudioManager.sharedInstance.prepareRecorder()
                    AudioManager.sharedInstance.startRecording()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        AudioManager.sharedInstance.stopRecording(success: true)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            AudioManager.sharedInstance.playRecorderFile()
                        }
                    }
                }
            }
            
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

