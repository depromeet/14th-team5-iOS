//
//  ToastGlobalState.swift
//  Core
//
//  Created by 김건우 on 1/3/24.
//

import Foundation

import RxSwift

public enum ToastEvent {
    case showAllFamilyUploadedToastView(Bool)
}

public protocol ToastGlobalStateType {
    var lastSelectedDate: Date { get set }
    var event: BehaviorSubject<ToastEvent> { get }
    func showAllFamilyUploadedToastMessageView(_ bool: Bool, selection date: Date) -> Observable<Bool>
    func resetLastSelectedDate()
}

final public class ToastGlobalState: BaseGlobalState, ToastGlobalStateType {
    public var lastSelectedDate: Date = .distantFuture
    public var event: BehaviorSubject<ToastEvent> = BehaviorSubject<ToastEvent>(value: .showAllFamilyUploadedToastView(false))
    
    public func showAllFamilyUploadedToastMessageView(_ isUploaded: Bool, selection date: Date) -> Observable<Bool> {
        lastSelectedDate = date
        event.onNext(.showAllFamilyUploadedToastView(isUploaded))
        return Observable<Bool>.just(isUploaded)
    }
    
    public func resetLastSelectedDate() {
        lastSelectedDate = .distantFuture
    }
}
