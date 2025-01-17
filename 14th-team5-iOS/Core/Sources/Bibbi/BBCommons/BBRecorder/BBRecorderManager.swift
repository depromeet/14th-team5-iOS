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
    
    // 시작과 동시에 데시벨을 업데이트 해야함
    // 데시벨은 말을 할때 데시벨이 주기적으로 업데이트가 되기 때문에 데시벨 업데이트 메서드만 추가해서 구독 하면 될 듯
    
}
