import Foundation
import AVFoundation

public class MyAVAudioPlayerNode: AVAudioPlayerNode {
    
    let bufferCapacity: AVAudioFrameCount = UInt32(AudioEnum.BUFFER_CAPACITY)
    public let sampleRate: Double = AudioEnum.SAMPLE_RATE
    
    public var frequency: Double = AudioEnum.FREQUENCY
    public var amplitude: Double = AudioEnum.AMPLITUDE
    
    private var theta: Double = AudioEnum.THETA
    private var audioFormat: AVAudioFormat!
    
    public override init() {
        super.init()
        audioFormat = AVAudioFormat(standardFormatWithSampleRate: sampleRate, channels: 1)
    }
    
    public func prepareBuffer() -> AVAudioPCMBuffer {
        let buffer = AVAudioPCMBuffer(pcmFormat: audioFormat, frameCapacity: bufferCapacity)
        fillBuffer(buffer!)
        return buffer!
    }
    
    public func fillBuffer(_ buffer: AVAudioPCMBuffer) {
        let data = buffer.floatChannelData?[0]
        let numberFrames = buffer.frameCapacity
        var theta = self.theta
        let theta_increment = 2.0 * .pi * self.frequency / self.sampleRate
        
        for frame in 0..<Int(numberFrames) {
            data?[frame] = Float32(sin(theta) * amplitude)
            
            theta += theta_increment
            if theta > 2.0 * .pi {
                theta -= 2.0 * .pi
            }
        }
        buffer.frameLength = numberFrames
        self.theta = theta
    }
    
    public func scheduleBuffer() {
        let buffer = prepareBuffer()
        self.scheduleBuffer(buffer) {
            if self.isPlaying {
                self.scheduleBuffer()
            }
        }
    }
    
    public func preparePlaying() {
        scheduleBuffer()
        scheduleBuffer()
        scheduleBuffer()
        scheduleBuffer()
    }
}
