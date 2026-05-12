//
//  BBAudioRecordable.swift
//  Core
//
//  Created by 김도현 on 4/27/26.
//

import Foundation
import AVFoundation

public protocol BBAudioRecordable {
    var isRecording: Bool { get }
    var audioRecorder: AVAudioRecorder? { get }
    func startRecording() throws -> URL
    func stopRecording() throws
    func pauseRecording()
}
