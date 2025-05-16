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
        return Observable.create { observer in
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
            
            let engine = AVAudioEngine()
            let inputNode = engine.inputNode
            let inputFormat = inputNode.outputFormat(forBus: 0)
            let format = AVAudioFormat(commonFormat: .pcmFormatFloat32, sampleRate: inputFormat.sampleRate, channels: inputFormat.channelCount, interleaved: true)
            
            base.inputNode.installTap(onBus: 0, bufferSize: 1024, format: format) { buffer, time in
                let normlizedDecibel = buffer.normalizeDecible()
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

public extension ObservableType {
    func willChangedAudioTime(_ transform: @escaping (Element) -> (BBEqualizerState, String)) -> Observable<String> {
        return flatMapLatest { element -> Observable<String> in
            let (equalizerState, audioId) = transform(element)
            
            return Observable.create { observer in
                guard let filePath = BBDiskCacheStorage<String, URL>.read(forkey: audioId) else {
                    return Disposables.create()
                }
                
                let asset = AVURLAsset(url: filePath)
                let duration = CMTimeGetSeconds(asset.duration)
                
                guard equalizerState == .play else {
                    observer.onCompleted()
                    return Disposables.create()
                }
                
                guard duration.isFinite || !duration.isZero  else {
                    observer.onCompleted()
                    return Disposables.create()
                }
                
                let timer = Observable<Int>
                    .interval(.seconds(1), scheduler: RxScheduler.main)
                    .flatMapLatest { times -> Observable<String> in
                        let currentTime = max(0, duration - Double(times))
                        let playerMinutes = Int(currentTime) / 60
                        let playerSeconds = Int(currentTime) % 60
                        let formatTimes = String(format: "%01d:%02d", playerMinutes, playerSeconds)
                        
                        if currentTime.isZero {
                            observer.onNext("0:00")
                            observer.onCompleted()
                        }
                        
                        return .just(formatTimes)
                    }
                    .subscribe(observer)
                    
                return Disposables.create {
                    timer.dispose()
                }
            }
            
        }
    }
    
    func requestAudioElapsedTime(_ transform: @escaping (Element) -> String) -> Observable<TimeInterval> {
        return flatMapLatest { element -> Observable<TimeInterval> in
            let fileIdKey = transform(element)
            guard let filePath = BBDiskCacheStorage<String, URL>.read(forkey: fileIdKey) else {
                return .error(BBDiskCacheStroageError.cannotCreateCacheFile)
            }
            
            let asset = AVURLAsset(url: filePath)
            let elapsedTime: TimeInterval = round(CMTimeGetSeconds(asset.duration))
            
            guard elapsedTime.isFinite || !elapsedTime.isZero else {
                return .error(NSError(domain: "❌잘못된 음성 녹음 파일 입니다.❌", code: -1))
            }
            
            return .just(elapsedTime)
        }
    }
    
    
    func requestAudioCurrentTime(_ transform: @escaping (Element) -> String) -> Observable<String> {
        return flatMap { element -> Observable<String> in
            let fileIdKey = transform(element)
            guard let filePath = BBDiskCacheStorage<String, URL>.read(forkey: fileIdKey) else {
                return .error(BBDiskCacheStroageError.cannotCreateCacheFile)
            }
            
            let asset = AVURLAsset(url: filePath)
            let duration = CMTimeGetSeconds(asset.duration)
            
            guard duration.isFinite || !duration.isZero else {
                return .error(NSError(domain: "❌잘못된 음성 녹음 파일 입니다.❌", code: -1))
            }
            
            let playerMinutes = Int(duration) / 60
            let playerSeconds = Int(duration) % 60
            let formatTimes = String(format: "%01d:%02d", playerMinutes, playerSeconds)
            return .just(formatTimes)
            
        }
    }
    
    func requestAudioFileDecibels(_ transform: @escaping (Element) -> String) -> Observable<[CGFloat]> {
        return flatMapLatest { element -> Observable<[CGFloat]> in
            let fileIDKey = transform(element)
            var decibels: [CGFloat] = []
            guard let filePath = BBDiskCacheStorage<String, URL>.read(forkey: fileIDKey) else {
                return .error(BBDiskCacheStroageError.cannotCreateCacheFile)
            }
            let standardFilePath = filePath.standardizedFileURL
            let asset = AVURLAsset(url: standardFilePath)
            
            guard let assetReader = try? AVAssetReader(asset: asset) else {
                return .error(AVError(.failedToLoadMediaData))
            }
            
            guard let track = asset.tracks(withMediaType: .audio).first else {
                return .error(AVError(.fileFormatNotRecognized))
            }
            
            let outputSettings: [String: Any] = [
                AVFormatIDKey: kAudioFormatLinearPCM,
                AVLinearPCMIsFloatKey: true,
                AVLinearPCMBitDepthKey: 32
            ]
            
            let trackOutput = AVAssetReaderTrackOutput(track: track, outputSettings: outputSettings)
            assetReader.add(trackOutput)
            
            if assetReader.status == .failed {
                return .error(BBUploadError.uploadFailed)
            }
            
            assetReader.startReading()
            while assetReader.status == .reading {
                if let sampleBuffer = trackOutput.copyNextSampleBuffer(),
                   let blockBuffer = CMSampleBufferGetDataBuffer(sampleBuffer) {
                    let length = CMBlockBufferGetDataLength(blockBuffer)
                    var data = [Float](repeating: 0, count: length / MemoryLayout<Float>.size)
                    CMBlockBufferCopyDataBytes(blockBuffer, atOffset: 0, dataLength: length, destination: &data)

                    for sample in data {
                        let decibel = 20 * log10(abs(sample))
                        let minDecibel: Float = -60.0
                        let maxDecibel: Float = 0.0
                        
                        let clampedDecibel = max(minDecibel, min(decibel, maxDecibel))
                    
                        let normalizedValue = 1.0 + (clampedDecibel - minDecibel) / (maxDecibel - minDecibel) * (10.0 - 1.0)
                        
                        if decibels.count >= 30 {
                            break
                        }
                        decibels.append(CGFloat(round(normalizedValue * 10000) / 10000))
                    }
                }
            }
            return .just(decibels)
        }
    }
        
}
