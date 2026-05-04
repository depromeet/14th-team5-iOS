//
//  BBAudioPlayable.swift
//  Core
//
//  Created by 김도현 on 4/27/26.
//


import Foundation

public protocol BBAudioPlayable {
    var isPlaying: Bool { get }
    func play(_ url: URL) throws
    func stop()
    func pause()
}
