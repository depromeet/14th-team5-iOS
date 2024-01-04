//
//  ToastGlobalState.swift
//  Core
//
//  Created by 김건우 on 1/3/24.
//

import Foundation

import RxSwift

public enum ToastEvent {
    case hiddenAllFamilyUploadedToastView(Bool)
}

public protocol ToastGlobalStateType {
    var event: BehaviorSubject<ToastEvent> { get }
    func hiddenAllFamilyUploadedToastMessageView(_ bool: Bool) -> Observable<Bool>
}

final public class ToastGlobalState: BaseGlobalState, ToastGlobalStateType {
    public var event: BehaviorSubject<ToastEvent> = BehaviorSubject<ToastEvent>(value: .hiddenAllFamilyUploadedToastView(true))
    
    public func hiddenAllFamilyUploadedToastMessageView(_ isUploaded: Bool) -> Observable<Bool> {
        event.onNext(.hiddenAllFamilyUploadedToastView(isUploaded))
        return Observable<Bool>.just(isUploaded)
    }
}
