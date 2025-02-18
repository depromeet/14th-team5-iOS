//
//  AVAudioPCMBuffer+Ext.swift
//  Core
//
//  Created by 김도현 on 2/3/25.
//

import Foundation

import AVFoundation

public extension AVAudioPCMBuffer {
    
    func normalizeDecible() -> Float {
        guard let channelData = self.floatChannelData?.pointee else {
            return 0.0
        }
        let frameLength = self.frameLength
        let rms = sqrt((0..<Int(frameLength)).map { channelData[$0] * channelData[$0] }.reduce(0, +) / Float(frameLength))
        
        let decibel = 20 * log10(rms)
 
        let minDecibel: Float = -60.0
        let maxDecibel: Float = 0.0
        let targetMin: Float = 1.0
        let targetMax: Float = 10.0
        
        let clampedDecibel = max(minDecibel, min(decibel, maxDecibel))
        let linearNormalized = (clampedDecibel - minDecibel) / (maxDecibel - minDecibel)
        let nonlinearNormalized = pow(linearNormalized, 1.0)
        let normalizedValue = targetMin + nonlinearNormalized * (targetMax - targetMin)
        
        return Float(round(normalizedValue * 10000) / 10000)
    }
    
}
