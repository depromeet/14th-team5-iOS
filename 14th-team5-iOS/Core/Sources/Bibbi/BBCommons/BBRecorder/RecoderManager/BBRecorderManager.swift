//
//  BBRecorderManager.swift
//  Core
//
//  Created by 김도현 on 12/23/24.
//

import Foundation
import AVFoundation
import RxSwift

public class BBRecorderManager: ReactiveCompatible {
    
    public static let shared: BBRecorderManager = BBRecorderManager()
    
    public let audioEngine: AVAudioEngine = AVAudioEngine()
    public let sessionManager: BBAudioSessionManageable
    public let recordingService: BBAudioRecordable
    public let monitoringService: BBAudioMonitorable
    public let playbackService: BBAudioPlayable
    
    public let recorderCore: BBRecorderCore = BBRecorderCore()
    
    public var inputNode: AVAudioInputNode {
        return audioEngine.inputNode
    }
    
    private var currentRecordingURL: URL?
    
    private init(
        sessionManager: BBAudioSessionManageable? = nil,
        recordingService: BBAudioRecordable? = nil,
        monitoringService: BBAudioMonitorable? = nil,
        playbackService: BBAudioPlayable? = nil
    ) {
        self.sessionManager = sessionManager ?? BBAudioSessionManager()
        self.recordingService = recordingService ?? BBRecordingService(audioEngine: audioEngine)
        self.monitoringService = monitoringService ?? BBMonitoringService(audioEngine: audioEngine)
        self.playbackService = playbackService ?? BBPlaybackService()
    }
    
    @objc public func startRecoding() {
        
        do {
            try sessionManager.setupSession()
            try sessionManager.activateSession()
            
            let url = try recordingService.startRecording()
            currentRecordingURL = url
            
            if !recorderCore.isRecording {
                recorderCore.audioRecorder.record()
            }
        } catch {
            print("녹음 시작 실패: \(error)")
        }
    }
    
    @objc public func stopRecoding() {
        do {
            try recordingService.stopRecording()
            try sessionManager.deactivateSession()
            
            currentRecordingURL = nil
            
            if recorderCore.isRecording {
                recorderCore.audioRecorder.stop()
            }
        } catch {
            print("녹음 중지 실패: \(error)")
        }
    }
    
    public func pauseRecording() {
        recordingService.pauseRecording()
    }
    
    public var isRecording: Bool {
        return recordingService.isRecoding
    }
    
    public func play(_ url: URL) throws {
        try sessionManager.setupSession()
        try sessionManager.activateSession()
        try playbackService.play(url)
    }
    
    public func stopPlayback() {
        playbackService.stop()
    }
    
    public func pausePlayback() {
        playbackService.pause()
    }
    
    public var isPlaying: Bool {
        return playbackService.isPlaying
    }
    
    
    public func startMonitoring() -> Observable<CGFloat> {
        return monitoringService.startAudioMonitoring()
    }
    
    public func stopMonitoring() {
        monitoringService.stopAudioMonitoring()
    }
    
    public func cleanup() {
        if isRecording {
            stopRecoding()
        }
        
        if isPlaying {
            stopPlayback()
        }
        
        stopMonitoring()
        
        try? sessionManager.deactivateSession()
    }
}
