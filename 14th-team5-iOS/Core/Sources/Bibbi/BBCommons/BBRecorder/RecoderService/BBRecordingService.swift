//
//  BBRecordingService.swift
//  Core
//
//  Created by 김도현 on 4/27/26.
//


import Foundation

import AVFoundation


public final class BBRecordingService: BBAudioRecordable {
    public private(set) var audioRecorder: AVAudioRecorder?
    private let audioEngine: AVAudioEngine
    
    
    public init(audioEngine: AVAudioEngine) {
        self.audioEngine = audioEngine
    }
    
    
    public var isRecording: Bool {
        return audioRecorder?.isRecording ?? false
    }
    
    private func makeRecordingFileURL() -> URL {
        let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
        return documents.appendingPathComponent(UUID().uuidString + ".m4a")
    }
    
    public func startRecording() throws -> URL {
        let url = makeRecordingFileURL()
        let settings = BBRecorderOption.default(inputNode: audioEngine.inputNode)
            .asFormat()
        
        audioRecorder = try AVAudioRecorder(url: url, settings: settings)
        audioRecorder?.isMeteringEnabled = true
        
        guard audioRecorder?.prepareToRecord() == true else {
            throw NSError(
                domain: "BBRecordingService",
                code: -1,
                userInfo: [NSLocalizedDescriptionKey: "녹음 준비 실패"]
            )
        }
        
        guard audioRecorder?.record() == true else {
            throw NSError(
                domain: "BBRecordingService",
                code: -2,
                userInfo: [NSLocalizedDescriptionKey: "녹음 시작 실패"]
            )
        }
        
        return url
    }
    
    public func stopRecording() throws {
        audioRecorder?.stop()
        audioRecorder = nil
    }
    
    public func pauseRecording() {
        audioRecorder?.pause()
    }
}
