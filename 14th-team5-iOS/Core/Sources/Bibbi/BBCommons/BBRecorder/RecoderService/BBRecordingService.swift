//
//  BBRecordingService.swift
//  Core
//
//  Created by 김도현 on 4/27/26.
//


import Foundation

import AVFoundation


public final class BBRecordingService: BBAudioRecordable {
    private var audioRecoder: AVAudioRecorder?
    private let audioEngine: AVAudioEngine
    
    
    public init(audioEngine: AVAudioEngine) {
        self.audioEngine = audioEngine
    }
    
    
    public var isRecoding: Bool {
        return audioRecoder?.isRecording ?? false
    }
    
    private func makeRecodingFileURL() -> URL {
        let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
        return documents.appendingPathComponent(UUID().uuidString + ".m4a")
    }
    
    public func startRecording() throws -> URL {
        let url = makeRecodingFileURL()
        let settings = BBRecorderOption.default(inputNode: audioEngine.inputNode)
            .asFormat()
        
        audioRecoder = try AVAudioRecorder(url: url, settings: settings)
        audioRecoder?.isMeteringEnabled = true
        audioRecoder?.record()
        
        return url
    }
    
    public func stopRecording() throws {
        audioRecoder?.stop()
        audioRecoder = nil
    }
    
    public func pauseRecording() {
        audioRecoder?.pause()
    }
}
