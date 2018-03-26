//
//  AudioManager.swift
//
//  Created by Vincenzo Aceto on 23/03/2018.
//  Copyright © 2018 Vincenzo Aceto. All rights reserved.
//

import Foundation
import AVFoundation

public class AudioManager: NSObject, AVAudioPlayerDelegate , AVAudioRecorderDelegate {
    
    static let sharedInstance = AudioManager()
    
    private override init() {}
    
    var myPlayers = [AVAudioPlayer]()
    var myRecordAudioPlayer = AVAudioPlayer()
    
    let guitarSounds = ["guitar_1.wav","guitar_2.wav","guitar_3.wav","guitar_1.wav","guitar_2.wav","guitar_3.wav"]
    let drumSounds = ["guitar_1.wav","guitar_2.wav","guitar_3.wav","guitar_1.wav","guitar_2.wav","guitar_3.wav"]
    let bandSounds = ["guitar_1.wav","guitar_2.wav","guitar_3.wav","guitar_1.wav","guitar_2.wav","guitar_3.wav"]
    
    var recordingSession : AVAudioSession!
    var audioRecorder    :AVAudioRecorder!
    var settings         = [String : Int]()
    
    public func prepareAudioPlayers(instrument: Int) {
        switch instrument {
        case InstrumentsEnum.BAND:
            prepareURLS(soundFiles: guitarSounds)
            break

        case InstrumentsEnum.DRUM:
            prepareURLS(soundFiles: drumSounds)
            break

        default:
            prepareURLS(soundFiles: bandSounds)
            break
        }
    }
    
    public func prepareURLS (soundFiles: [String]) {
        for sound in soundFiles {
            let soundFileNameURL = Bundle.main.path(forResource: sound, ofType: nil)!
            let url = URL(fileURLWithPath: soundFileNameURL)
            
                do{
                    let player = try AVAudioPlayer(contentsOf: url)
                    player.prepareToPlay()
                    player.numberOfLoops = -1
                    myPlayers.append(player)
                    
                } catch {
                    print("Could not play sound file!")
                }
        }

    }
    
    public func playSoundFromGesture(gesture: Int) {
        switch gesture {
        case ModelStatesEnum.CEILING:
            playSoundFromArray(gesture: ModelStatesEnum.CEILING)
            break
        case ModelStatesEnum.HAND:
            playSoundFromArray(gesture: ModelStatesEnum.HAND)
            break
        case ModelStatesEnum.CEILING:
            playSoundFromArray(gesture: ModelStatesEnum.CEILING)
            break
        default:
            playSoundFromArray(gesture: ModelStatesEnum.CEILING)
            break
        }
    }
    
    public func playSoundFromArray(gesture: Int) {

        for i in 0 ... myPlayers.count - 1 {
            if gesture >= 0 {
                if i == gesture {
                    if myPlayers[i].isPlaying {
                        return
                    }
                    myPlayers[i].play()
                } else {
                    myPlayers[i].stop()
                }
            } else {
                myPlayers[i].stop()
            }
        }
    }
    
    public func prepareRecorder() {
        recordingSession = AVAudioSession.sharedInstance()
        do {
            try recordingSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try recordingSession.setActive(true)
            recordingSession.requestRecordPermission() { [unowned self] allowed in
                DispatchQueue.main.async {
                    if allowed {
                        print("Allow rec")
                    } else {
                        print("Dont Allow rec")
                    }
                }
            }
        } catch {
            print("failed to rec!")
        }
        
        // Audio Settings
        
        settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
    }
    
    public func directoryURL() -> NSURL? {
        let fileManager = FileManager.default
        let urls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = urls[0] as NSURL
        let soundURL = documentDirectory.appendingPathComponent("myrec.m4a")
        print(soundURL ?? "no file to save")
        return soundURL as NSURL?
    }
    
    public func startRecording() {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            audioRecorder = try AVAudioRecorder(url: self.directoryURL()! as URL,
                                                settings: settings)
            audioRecorder.delegate = self
            audioRecorder.prepareToRecord()
        } catch {
            stopRecording(success: false)
        }
        do {
            try audioSession.setActive(true)
            audioRecorder.record()
        } catch {
        }
    }
    
    public func stopRecording(success: Bool) {
        audioRecorder.stop()
        if success {
            print(success)
        } else {
            audioRecorder = nil
            print("Somthing Wrong.")
        }
    }
    
    
    public func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            stopRecording(success: false)
        }
    }
    
    public func playRecorderFile() {
        if !audioRecorder.isRecording {
            self.myRecordAudioPlayer = try! AVAudioPlayer(contentsOf: audioRecorder.url)
            self.myRecordAudioPlayer.prepareToPlay()
            self.myRecordAudioPlayer.delegate = self
            self.myRecordAudioPlayer.play()
        }
    }
    
}
