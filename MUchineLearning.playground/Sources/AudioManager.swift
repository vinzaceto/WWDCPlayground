//
//  AudioManager.swift
//
//  Created by Vincenzo Aceto on 23/03/2018.
//  Copyright © 2018 Vincenzo Aceto. All rights reserved.
//

import Foundation
import AVFoundation

public class AudioManager: NSObject, AVAudioPlayerDelegate {
    
    public static let sharedInstance = AudioManager()
    
    public var instrumentCount: Int = 100
    
    private override init() {}
    
    var myPlayers = [AVAudioPlayer]()
    
    let guitarSounds = ["guitar_1.wav","guitar_2.wav","guitar_3.wav","guitar_4.wav","guitar_5.wav","guitar_6.wav"]
    let drumSounds = ["drum_1.wav","drum_2.wav","drum_3.wav","drum_4.wav","drum_5.wav","drum_6.wav"]
    let bandSounds = ["guitar_1.wav","drum_2.wav","piano_3.wav","synth_4.wav","guitar_5.wav","drum_6.wav"]
    
    let pianoSounds = ["piano_1.wav","piano_2.wav","piano_3.wav","piano_4.wav","piano_5.wav","piano_6.wav"]
    
    let synthSounds = ["synth_1.wav","synth_2.wav","synth_3.wav","synth_4.wav","synth_5.wav","synth_6.wav"]
    public func prepareAudioPlayers(instrument: Int) {
        
        
        instrumentCount += instrument
        if instrumentCount < 0 {
            instrumentCount *= -1
        }
        
        print("preparingAudioPlayers instrumentCounter: \(instrumentCount)")

        
        switch instrumentCount % 5 {
        case InstrumentsEnum.BAND:
            print("preparingAudioPlayers band")
            prepareURLS(soundFiles: bandSounds)
            break
            
        case InstrumentsEnum.DRUM:
            print("preparingAudioPlayers drum")
            prepareURLS(soundFiles: drumSounds)
            break
            
        case InstrumentsEnum.GUITAR:
            print("preparingAudioPlayers guitar")
            prepareURLS(soundFiles: guitarSounds)
            break
            
        case InstrumentsEnum.PIANO:
            print("preparingAudioPlayers piano")
            prepareURLS(soundFiles: pianoSounds)
            break
            
        default:
            print("preparingAudioPlayers synth")
            prepareURLS(soundFiles: synthSounds)
            break
        }
    }
    
    public func prepareURLS (soundFiles: [String]) {
        myPlayers = [AVAudioPlayer]()
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
    
}

