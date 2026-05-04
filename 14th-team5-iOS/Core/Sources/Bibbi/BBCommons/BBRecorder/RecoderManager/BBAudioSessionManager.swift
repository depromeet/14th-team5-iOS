//
//  BBAudioSessionManager.swift
//  Core
//
//  Created by 김도현 on 4/27/26.
//


import Foundation
import AVFoundation


public final class BBAudioSessionManager: BBAudioSessionManageable {
    
    //MARK: Property
    private let session: AVAudioSession = AVAudioSession()
    
    //MARK: Helpers
    public func setupSession() throws {
        try session.setCategory(
            .playAndRecord,
            mode: .voiceChat,
            options: [.defaultToSpeaker, .allowBluetooth]
        )
    }
    
    public func activateSession() throws {
        try session.setActive(true)
    }
    
    public func deactivateSession() throws {
        try session.setActive(false, options: .notifyOthersOnDeactivation)
    }
}
