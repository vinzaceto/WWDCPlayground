

import Foundation

public class PlaygroundManager {
    
    public static let shared = PlaygroundManager()
    
    public var currentFrequency: Double = AudioEnum.FREQUENCY
    public var currentAmplitude: Double = AudioEnum.AMPLITUDE
    public var currentTheta: Double = AudioEnum.THETA
}
