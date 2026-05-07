//
//  BBMonitoringService.swift
//  Core
//
//  Created by 김도현 on 4/27/26.
//


import Foundation
import AVFoundation

import RxSwift

public final class BBMonitoringService: BBAudioMonitorable {
    private let audioEngine: AVAudioEngine
    private var isMonitoring = false
    
    
    public init(audioEngine: AVAudioEngine) {
        self.audioEngine = audioEngine
    }
    
    public func startAudioMonitoring() -> Observable<CGFloat> {
        return Observable.create { [weak self] observer in
            guard let self = self else { return Disposables.create() }
            
            if self.isMonitoring {
                observer.onError(NSError(
                    domain: "BBMonitoringService",
                    code: -1,
                    userInfo: [NSLocalizedDescriptionKey: "이미 모니터링 중입니다."]
                ))
                return Disposables.create()
            }
            
            self.isMonitoring = true
            let format = self.audioEngine.inputNode.outputFormat(forBus: 0)
            
            self.audioEngine.inputNode.installTap(
                onBus: 0,
                bufferSize: 1024,
                format: format) { buffer, _ in
                    let decibel = buffer.normalizeDecible()
                    observer.onNext(CGFloat(decibel))
            }
            
            self.audioEngine.prepare()
            
            do {
                try self.audioEngine.start()
            } catch {
                self.audioEngine.inputNode.removeTap(onBus: 0)
                self.isMonitoring = false
                observer.onError(error)
                return Disposables.create()
            }
            
            return Disposables.create { [weak self] in
                self?.audioEngine.inputNode.removeTap(onBus: 0)
                self?.audioEngine.stop()
                self?.isMonitoring = false
            }
        }
    }
    
    public func stopAudioMonitoring() {
        guard isMonitoring else { return }
        
        audioEngine.inputNode.removeTap(onBus: 0)
        audioEngine.stop()
        isMonitoring = false
    }
    
}
