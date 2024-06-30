//
//  TimerGlobalState.swift
//  Core
//
//  Created by 마경미 on 30.01.24.
//

import Foundation

import RxSwift

public enum TimerEvent {
    case notTime
    case inTime
}

public protocol TimerGlobalStateType {
    var event: BehaviorSubject<TimerEvent> { get }
    
    @discardableResult
    func setNotTime() -> Observable<Void>
    @discardableResult
    func setInTime() -> Observable<Void>
}

final public class TimerGlobalState: BaseService, TimerGlobalStateType {
    public var event: BehaviorSubject<TimerEvent> = BehaviorSubject(value: .inTime)
    
    public func setNotTime() -> RxSwift.Observable<Void> {
        event.onNext(.notTime)
        return Observable<Void>.just(())
    }
    
    public func setInTime() -> RxSwift.Observable<Void> {
        event.onNext(.inTime)
        return Observable<Void>.just(())
    }
}
