//
//  BBRecorderOption.swift
//  Core
//
//  Created by 김도현 on 12/23/24.
//

import Foundation

import AVFoundation

public enum BBRecorderOption {
    case formatIDKey(AudioFormatID)
    case sampleRate(Double)
    case channelsKey(Int)
    case qualityKey(AVAudioQuality)
}

public extension BBRecorderOption {
    var key: String {
        switch self {
        /// : 오디오 데이터의 형식을 나타내는 값
        case .formatIDKey: return AVFormatIDKey
        /// 샘플 속도를 헤츠르로 나타내는 부동 소수점 값
        case .sampleRate: return AVSampleRateKey
        /// 채널 수를 나타내는 값
        case .channelsKey: return AVNumberOfChannelsKey
        /// 오디오 품질을 열거형의 정수를 나타내는 상수
        case .qualityKey: return AVEncoderAudioQualityKey
        }
    }
    
    var value: Any {
        switch self {
        case let .formatIDKey(formatIdKey):
            setFormatIdKey(id: formatIdKey)
        case let .sampleRate(hertz):
            setSampleRate(hertz: hertz)
        case let .channelsKey(channel):
            setChannles(channel: channel)
        case let .qualityKey(quality):
            setQualityKey(quality: quality)
        }
    }
}

public extension BBRecorderOption {
    /// 오디오 데이터 형식을 설정하는 메서드
    func setFormatIdKey(id: AudioFormatID) -> Int {
        return Int(id)
    }
    
    /// 오디오 헤르츠 값을 설정하는 메서드
    func setSampleRate(hertz: Double) -> Double {
        return hertz
    }
    
    /// 오디오 채널 수를 설정하는 메서드
    func setChannles(channel: Int) -> Int {
        return channel
    }
    
    /// 오디오 품질을 설정하는 메서드
    func setQualityKey(quality: AVAudioQuality) -> Int {
        return quality.rawValue
    }
    
    /// 기본 옵션 메서드
    static func `default`() -> [BBRecorderOption] {
        return [
            .formatIDKey(kAudioFormatMPEG4AAC),
            .sampleRate(44100),
            .channelsKey(1),
            .qualityKey(.high)
        ]
    }
}


extension Array where Element == BBRecorderOption {
    func asFormat() -> [String: Any] {
        var format: [String: Any] = [:]
        for option in self {
            format[option.key] = option.value
        }
        return format
    }
}
