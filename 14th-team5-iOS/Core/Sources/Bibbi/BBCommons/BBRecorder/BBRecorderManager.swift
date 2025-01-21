//
//  BBRecorderManager.swift
//  Core
//
//  Created by 김도현 on 12/23/24.
//

import Foundation

import AVFoundation

public class BBRecorderManager: NSObject {
    private var recorderCore: BBRecorderCore

    public init(
        recorderCore: BBRecorderCore = BBRecorderCore()
    ) {
        self.recorderCore = recorderCore
        super.init()
        start()
    }

    
    @discardableResult
    public func start() -> Self {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playAndRecord, options: .defaultToSpeaker)
            try AVAudioSession.sharedInstance().setActive(true)
            try AVAudioSession.sharedInstance().overrideOutputAudioPort(.speaker)
        } catch {
            print("AVAudio Session Not Settings")
        }
        return self
    }
    
    @objc @discardableResult
    public func startRecoding() -> Self {
        print("start recording")
        recorderCore.audioRecorder.isMeteringEnabled = true
        recorderCore.audioRecorder.record()
        return self
    }
    
    @discardableResult
    public func pauseRecoding() -> Self {
        recorderCore.audioRecorder.pause()
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
    
    @objc
    public func updateDecibels() -> Float {
        recorderCore.audioRecorder.updateMeters()
        let decibels = recorderCore.audioRecorder.averagePower(forChannel: 0)
        return decibels
    }
    
}
