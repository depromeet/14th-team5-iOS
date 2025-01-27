//
//  Reactive+Ext.swift
//  App
//
//  Created by Kim dohyun on 12/15/23.
//

import UIKit
import WebKit

import Kingfisher
import RxCocoa
import RxSwift
import AVFoundation

extension Reactive where Base: UIViewController {
    public var viewDidLoad: ControlEvent<Bool> {
        let event = self.methodInvoked(#selector(Base.viewDidLoad)).map { $0.first as? Bool ?? false }
        return ControlEvent(events: event)
    }
    
    public var viewWillAppear: ControlEvent<Bool> {
        let event = self.methodInvoked(#selector(Base.viewWillAppear)).map { $0.first as? Bool ?? false }
        return ControlEvent(events: event)
    }
    
    public var viewDidDisappear: ControlEvent<Bool> {
        let source = self.methodInvoked(#selector(Base.viewDidDisappear)).map { $0.first as? Bool ?? false }
        return ControlEvent(events: source)
      }
}

extension Reactive where Base: UIView {
    public var tapGesture: UITapGestureRecognizer {
        return UITapGestureRecognizer()
    }
    
    public var tap: ControlEvent<Void> {
        let tapGestureRecognizer = tapGesture
        base.addGestureRecognizer(tapGestureRecognizer)
        
        return tapGestureRecognizer.rx.tapGesture
    }
    
    public var pinchGesture: ControlEvent<UIPinchGestureRecognizer> {
        let pinchGestureRecognizer = UIPinchGestureRecognizer()
        base.addGestureRecognizer(pinchGestureRecognizer)
        
        return ControlEvent(events: pinchGestureRecognizer.rx.event)
    }
    
    public var longPress: ControlEvent<UILongPressGestureRecognizer> {
        let gestureRecognizer = UILongPressGestureRecognizer()
        self.base.addGestureRecognizer(gestureRecognizer)
        
        return ControlEvent(events: gestureRecognizer.rx.event)
    }
}

extension Reactive where Base: UITapGestureRecognizer {
    public var tapGesture: ControlEvent<Void> {
        let tapEvent = self.methodInvoked(#selector(Base.touchesBegan(_:with:))).map { _ in }
        return ControlEvent(events: tapEvent)
    }
}

extension Reactive where Base: UILabel {
    
    public var firstLetterText: Binder<String> {
        Binder(self.base) { label, text in
            if let firstLetter = text.first {
                label.text = String(firstLetter)
            }
        }
    }
    
}

extension Reactive where Base: WKWebView {
    public var loadURL: Binder<URL> {
        return Binder(self.base) { webView, url in
            let request = URLRequest(url: url)
            webView.load(request)
        }
        
    }
}

extension Reactive where Base: UIImageView {
    
    @available(*, deprecated, renamed: "kfImage")
    public var kingfisherImage: Binder<String> {
        Binder(self.base) { imageView, urlString in
            imageView.kf.setImage(
                with: URL(string: urlString),
                options: [
                    .transition(.fade(0.15))
                ]
            )
        }
    }
    
    public var kfImage: Binder<URL> {
        // TODO: - 이미지 캐시, 트랜지션 효과 추가 구현하기
        Binder(self.base) { imageView, url in
            imageView.kf.setImage(with: url)
        }
    }
    
}


public extension Reactive where Base: BBRecorderManager {
    var requestCurrentTime: Observable<String> {
        return Observable<String>.create { observer in
            let timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak base] _ in
                guard let currentTime = base?.recorderCore.audioRecorder.currentTime else {
                    return
                }
                
                let recordMinutes = Int(currentTime) / 60
                let recordSeconds = Int(currentTime) % 60
                let formatTimes = String(format: "%01d:%02d", recordMinutes, recordSeconds)
                
                observer.onNext(formatTimes)
                if currentTime >= 30.0 {
                    observer.onCompleted()
                }
            }
            RunLoop.main.add(timer, forMode: .common)
            return Disposables.create {
                timer.invalidate()
            }
        }
    }
    
    var requestDecibels: Observable<[CGFloat]> {
        return Observable.create { [weak base] observer in
            guard let base = base else { return Disposables.create() }
            var decibles: [CGFloat] = []
            
            base.inputNode.installTap(onBus: 0, bufferSize: 1024, format: base.inputNode.inputFormat(forBus: 0)) { buffer, time in
                let realTimeDecibel = base.updateDecibels(buffer: buffer)
                let normlizedDecibel = base.normalizeDecibel(decibel: realTimeDecibel)
                decibles.append(CGFloat(normlizedDecibel))
    
                observer.onNext(decibles)
            }
            
            base.audioEngine.prepare()
            try? base.audioEngine.start()
            
            return Disposables.create {
                base.inputNode.removeTap(onBus: 0)
                base.audioEngine.stop()
            }
        }
    }
        
    var requestMicrophonePermission: Observable<Bool> {
        return Observable.create { observer in
            AVAudioSession.sharedInstance().requestRecordPermission { accept in
                if accept {
                    do {
                        try AVAudioSession.sharedInstance().setCategory(.playAndRecord, options: .defaultToSpeaker)
                        try AVAudioSession.sharedInstance().setActive(true)
                        try AVAudioSession.sharedInstance().overrideOutputAudioPort(.speaker)
                        observer.onNext(true)
                        observer.onCompleted()
                    } catch {
                        observer.onError(error)
                    }
                } else {
                    observer.onNext(false)
                    observer.onCompleted()
                }
            }
            return Disposables.create()
        }
    }
}
