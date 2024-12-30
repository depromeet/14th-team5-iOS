//
//  AVAudioRecorderDelegate+Ext.swift
//  Core
//
//  Created by 김도현 on 12/30/24.
//

import Foundation

import RxSwift
import RxCocoa
import AVFoundation

final class AVRecorderDelegateProxy: DelegateProxy<AVAudioRecorder, AVAudioRecorderDelegate>, DelegateProxyType, AVAudioRecorderDelegate {
    static func registerKnownImplementations() {
        self.register {
            AVRecorderDelegateProxy(parentObject: $0, delegateProxy: self)
        }
    }
    
    static func currentDelegate(for object: AVAudioRecorder) -> (any AVAudioRecorderDelegate)? {
        object.delegate
    }
    
    static func setCurrentDelegate(_ delegate: (any AVAudioRecorderDelegate)?, to object: AVAudioRecorder) {
        object.delegate = delegate
    }
    
}

extension Reactive where Base: AVAudioRecorder {
    public var delegate: DelegateProxy<AVAudioRecorder, AVAudioRecorderDelegate> {
        return AVRecorderDelegateProxy.proxy(for: self.base)
    }
    
    public var audioRecorderDidFinishRecording: ControlEvent<URL> {
        let source = delegate.methodInvoked(#selector(AVAudioRecorderDelegate.audioRecorderDidFinishRecording(_:successfully:)))
            .compactMap {
                let recorder = $0[0] as? AVAudioRecorder
                return recorder?.url
            }
        return ControlEvent(events: source)
    }
}
