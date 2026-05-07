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
    
    public var inputNode: AVAudioInputNode {
        return audioEngine.inputNode
    }
    
    private var currentRecordingURL: URL?
    private var interruptionObserver: NSObjectProtocol?
    
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
        
        setupInterruptionHandling()
    }
    
    deinit {
        cleanup()
    }
        
    private func setupInterruptionHandling() {
        interruptionObserver = NotificationCenter.default.addObserver(
            forName: AVAudioSession.interruptionNotification,
            object: nil,
            queue: .main
        ) { [weak self] notification in
            self?.handleInterruption(notification)
        }
    }
    
    private func handleInterruption(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let typeValue = userInfo[AVAudioSessionInterruptionTypeKey] as? UInt,
              let type = AVAudioSession.InterruptionType(rawValue: typeValue) else {
            return
        }
        
        switch type {
        case .began:
            handleInterruptionBegan()
            
        case .ended:
            handleInterruptionEnded(userInfo: userInfo)
            
        @unknown default:
            break
        }
    }
    
    private func handleInterruptionBegan() {
        if isRecording {
            pauseRecording()
        }
        if isPlaying {
            pausePlayback()
        }
    }
    
    private func handleInterruptionEnded(userInfo: [AnyHashable: Any]) {
        guard let optionsValue = userInfo[AVAudioSessionInterruptionOptionKey] as? UInt else {
            return
        }
        let options = AVAudioSession.InterruptionOptions(rawValue: optionsValue)
        
        if options.contains(.shouldResume) {
            do {
                try sessionManager.activateSession()
            } catch {
                print("인터럽션 후 세션 재활성화 실패: \(error)")
            }
        }
    }
    
    @objc public func startRecording() {
        do {
            try sessionManager.setupSession()
            try sessionManager.activateSession()
            
            let url = try recordingService.startRecording()
            currentRecordingURL = url
            
        } catch {
            print("녹음 시작 실패: \(error)")
            try? sessionManager.deactivateSession()
        }
    }
    
    @objc public func stopRecording() {
        do {
            try recordingService.stopRecording()
            currentRecordingURL = nil
            
            try sessionManager.deactivateSession()
        } catch {
            print("녹음 중지 실패: \(error)")
        }
    }
    
    public func pauseRecording() {
        recordingService.pauseRecording()
    }
    
    public var isRecording: Bool {
        return recordingService.isRecording
    }
    
    public func play(_ url: URL) throws {
        try sessionManager.setupSession()
        try sessionManager.activateSession()
        try playbackService.play(url)
    }
    
    public func stopPlayback() {
        playbackService.stop()
        try? sessionManager.deactivateSession()
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
            stopRecording()
        }
        
        if isPlaying {
            stopPlayback()
        }
        
        stopMonitoring()
        
        if let observer = interruptionObserver {
            NotificationCenter.default.removeObserver(observer)
            interruptionObserver = nil
        }
        
        try? sessionManager.deactivateSession()
    }
}
