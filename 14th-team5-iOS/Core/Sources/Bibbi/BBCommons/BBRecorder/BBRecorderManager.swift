//
//  BBRecorderManager.swift
//  Core
//
//  Created by 김도현 on 12/23/24.
//

import Foundation

import AVFoundation

public class BBRecorderManager: NSObject {
    public var recorderCore: BBRecorderCore
    public var audioEngine: AVAudioEngine
    public var inputNode: AVAudioInputNode

    public init(
        recorderCore: BBRecorderCore = BBRecorderCore()
    ) {
        self.recorderCore = recorderCore
        self.audioEngine = AVAudioEngine()
        self.inputNode = audioEngine.inputNode
        super.init()
        start()
    }

    
    @discardableResult
    public func start() -> Self {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playAndRecord, options: [.defaultToSpeaker, .allowBluetooth])
            try AVAudioSession.sharedInstance().setActive(true)
            try AVAudioSession.sharedInstance().overrideOutputAudioPort(.speaker)
        } catch {
            print("AVAudio Session Not Settings")
        }
        return self
    }
    
    @objc @discardableResult
    public func startRecoding() -> Self {
        recorderCore.audioRecorder.isMeteringEnabled = true
        recorderCore.audioRecorder.record()
        return self
    }
    
    @objc @discardableResult
    public func stopRecoding() -> Self {
        recorderCore.audioRecorder.stop()
        return self
    }
    
    @objc @discardableResult
    public func play() -> Self {
        recorderCore.audioPlayer.volume = 1.0
        recorderCore.audioPlayer.prepareToPlay()
        recorderCore.audioPlayer.play()
        return self
    }
    
    func updateDecibels(buffer: AVAudioPCMBuffer) -> Float {
        guard let channelData = buffer.floatChannelData?.pointee else { return 0.0 }
        let frameLength = buffer.frameLength
        let rms = sqrt((0..<Int(frameLength)).map { channelData[$0] * channelData[$0] }.reduce(0, +) / Float(frameLength))
        let decibel = 20 * log10(rms)
 
        return decibel
    }
    
    func normalizeDecibel(decibel: Float) -> Float {
        let minDecibel: Float = -60.0
        let maxDecibel: Float = 0.0
        let targetMin: Float = 1.0
        let targetMax: Float = 10.0

       
        let clampedDecibel = max(minDecibel, min(decibel, maxDecibel))
        let linearNormalized = (clampedDecibel - minDecibel) / (maxDecibel - minDecibel)
        let nonlinearNormalized = pow(linearNormalized, 1.0)
        let normalizedValue = targetMin + nonlinearNormalized * (targetMax - targetMin)
        
        return Float(round(normalizedValue * 10000) / 10000)
    }
    
}
