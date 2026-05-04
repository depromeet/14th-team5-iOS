//
//  BBAudioMonitorable.swift
//  Core
//
//  Created by 김도현 on 4/27/26.
//


import Foundation

import RxSwift


public protocol BBAudioMonitorable {
    func startAudioMonitoring() -> Observable<CGFloat>
    func stopAudioMonitoring()
}
