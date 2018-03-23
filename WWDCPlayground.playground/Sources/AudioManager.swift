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
    
    private override init() {}
    
    var myPlayers = [AVAudioPlayer]()
    
    let guitarSounds = ["guitar_1.wav","guitar_2.wav","guitar_3.wav","guitar_4.wav","guitar_5.wav","guitar_6.wav"]
    let drumSounds = ["drum_1.wav","drum_2.wav","drum_3.wav","drum_4.wav","drum_5.wav","drum_6.wav"]
    let bandSounds = ["guitar_1.wav","drum_2.wav","guitar_3.wav","drum_4.wav","guitar_5.wav","drum_6.wav"]
    
    
    public func prepareAudioPlayers(instrument: Int) {
        switch instrument {
        case InstrumentsEnum.BAND:
            prepareURLS(soundFiles: bandSounds)
            break
            
        case InstrumentsEnum.DRUM:
            prepareURLS(soundFiles: drumSounds)
            break
            
        case InstrumentsEnum.GUITAR:
            prepareURLS(soundFiles: guitarSounds)
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
    
}
