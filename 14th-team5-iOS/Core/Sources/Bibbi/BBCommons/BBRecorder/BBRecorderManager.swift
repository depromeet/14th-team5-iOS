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
    
}
