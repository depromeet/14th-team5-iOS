//
//  ToastGlobalState.swift
//  Core
//
//  Created by 김건우 on 1/3/24.
//

import Foundation

import RxSwift

public enum ToastMessageEvent {
    case showAllFamilyUploadedToastView(Bool)
}

public protocol ToastMessageGlobalStateType {
    var lastSelectedDate: Date { get set }
    var event: BehaviorSubject<ToastMessageEvent> { get }
    
    @discardableResult
    func showAllFamilyUploadedToastMessageView(selection date: Date) -> Observable<Bool>
    
    func clearToastMessageEvent()
    func clearLastSelectedDate()
}

final public class ToastMessageGlobalState: BaseService, ToastMessageGlobalStateType {
    public var lastSelectedDate: Date = .distantFuture
    public var event: BehaviorSubject<ToastMessageEvent> = BehaviorSubject<ToastMessageEvent>(value: .showAllFamilyUploadedToastView(false))
    
    public func showAllFamilyUploadedToastMessageView(selection date: Date) -> Observable<Bool> {
        lastSelectedDate = date
        event.onNext(.showAllFamilyUploadedToastView(true))
        return Observable<Bool>.just(true)
    }
    
    public func clearToastMessageEvent() {
        event.onNext(.showAllFamilyUploadedToastView(false))
    }
    
    public func clearLastSelectedDate() {
        lastSelectedDate = .distantFuture
    }
}
