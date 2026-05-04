//
//  BBPlaybackService.swift
//  Core
//
//  Created by 김도현 on 4/27/26.
//




import Foundation
import AVFoundation


public final class BBPlaybackService: BBAudioPlayable {
    
    // MARK: - Properties
    private var audioPlayer: AVAudioPlayer?
    
    
    public var isPlaying: Bool {
        return audioPlayer?.isPlaying ?? false
    }
    
    public func play(_ url: URL) throws {
        audioPlayer?.stop()
        audioPlayer = nil
        
        audioPlayer = try AVAudioPlayer(contentsOf: url)
        audioPlayer?.prepareToPlay()
        audioPlayer?.play()
    }
    
    public func stop() {
        audioPlayer?.stop()
        audioPlayer?.currentTime = 0
    }
    
    public func pause() {
        audioPlayer?.pause()
    }
}
