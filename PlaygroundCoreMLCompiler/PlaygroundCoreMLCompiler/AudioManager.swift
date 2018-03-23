//
//  AudioManager.swift
//
//  Created by Vincenzo Aceto on 23/03/2018.
//  Copyright © 2018 Vincenzo Aceto. All rights reserved.
//

import Foundation
import AVFoundation

public class AudioManager: NSObject, AVAudioPlayerDelegate {
    
    static let sharedInstance = AudioManager()
    
    private override init() {}
    
    var myPlayers = [AVAudioPlayer]()
    
    let guitarSounds = ["guitar_1.wav","guitar_2.wav","guitar_3.wav","guitar_1.wav","guitar_2.wav","guitar_3.wav"]
    let drumSounds = ["guitar_1.wav","guitar_2.wav","guitar_3.wav","guitar_1.wav","guitar_2.wav","guitar_3.wav"]
    let bandSounds = ["guitar_1.wav","guitar_2.wav","guitar_3.wav","guitar_1.wav","guitar_2.wav","guitar_3.wav"]
    
    
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
    
    func playSoundFromArray(gesture: Int) {

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
