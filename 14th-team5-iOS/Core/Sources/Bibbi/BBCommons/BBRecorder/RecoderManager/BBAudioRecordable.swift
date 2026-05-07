//
//  BBAudioRecordable.swift
//  Core
//
//  Created by 김도현 on 4/27/26.
//

import Foundation

public protocol BBAudioRecordable {
    var isRecording: Bool { get }
    func startRecording() throws -> URL
    func stopRecording() throws
    func pauseRecording()
}
