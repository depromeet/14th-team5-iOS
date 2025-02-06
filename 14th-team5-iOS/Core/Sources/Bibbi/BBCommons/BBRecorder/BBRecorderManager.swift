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
    public var audioPlayer: AVAudioPlayer?
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
    
    public func pauseAudioPlayback() {
        guard let audioPlayer = audioPlayer else { return }
        if audioPlayer.isPlaying {
            audioPlayer.pause()
        }
    }
    
    public func playAudio(from audioId: String) -> Void {
        guard let audioURL = BBDiskCacheStorage<String, URL>.read(forkey: audioId) else { return }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: audioURL)
            audioPlayer?.volume = 1.0
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
        } catch {
            print(error.localizedDescription)
        }
    }
}
