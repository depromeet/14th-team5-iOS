//
//  BBRecorderManager+Ext.swift
//  Core
//
//  Created by 김도현 on 12/30/24.
//

import Foundation

import RxSwift
import RxCocoa


extension Reactive where Base: BBRecorderManager {
    public var startRecording: ControlEvent<Void> {
        let event = self.methodInvoked(#selector(Base.startRecoding)).map { _ in }
        return ControlEvent(events: event)
    }
    
    public var stopRecoding: ControlEvent<Void> {
        let event = self.methodInvoked(#selector(Base.stopRecoding)).map { _ in }
        return ControlEvent(events: event)
    }
    
    public var play: ControlEvent<Void> {
        let event = self.methodInvoked(#selector(Base.play)).map { _ in }
        return ControlEvent(events: event)
    }
}
