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
    
    
    public init(audioEngine: AVAudioEngine) {
        self.audioEngine = audioEngine
    }
    
    public func startAudioMonitoring() -> Observable<CGFloat> {
        return Observable.create { [weak self] observer in
            guard let self = self else { return  Disposables.create() }
            
            let format = self.audioEngine.inputNode.outputFormat(forBus: 0)
            
            self.audioEngine.inputNode.installTap(
                onBus: 0,
                bufferSize: 1024,
                format: format) { buffer, _ in
                    let decibel = buffer.normalizeDecible()
                    observer.onNext(CGFloat(decibel))
            }
            
            self.audioEngine.prepare()
            try? self.audioEngine.start()
            
            return Disposables.create {
                self.audioEngine.inputNode.removeTap(onBus: 0)
                self.audioEngine.stop()
            }
        }
    }
    
    public func stopAudioMonitoring() {
        audioEngine.inputNode.removeTap(onBus: 0)
        audioEngine.stop()
    }
    
}
