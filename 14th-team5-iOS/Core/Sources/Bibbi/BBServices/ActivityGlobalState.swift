//
//  ActivityGlobalState.swift
//  Core
//
//  Created by 김건우 on 12/13/23.
//

import UIKit

import RxSwift

public enum ActivityEvent {
    case didTapCopyInvitationUrlAction
    case hiddenInvitationUrlIndicatorView(Bool)
}

public protocol ActivityGlobalStateType {
    var event: PublishSubject<ActivityEvent> { get }
    func didTapCopyInvitationUrlAction() -> Observable<Void>
    func hiddenInvitationUrlIndicatorView(_ hidden: Bool) -> Observable<Bool>
}

final public class ActivityGlobalState: BaseService, ActivityGlobalStateType {
    public var event: PublishSubject<ActivityEvent> = PublishSubject<ActivityEvent>()
    
    public func didTapCopyInvitationUrlAction() -> Observable<Void> {
        event.onNext(.didTapCopyInvitationUrlAction)
        return Observable<Void>.just(())
    }
    
    public func hiddenInvitationUrlIndicatorView(_ hidden: Bool) -> Observable<Bool> {
        event.onNext(.hiddenInvitationUrlIndicatorView(hidden))
        return Observable<Bool>.just(hidden)
    }
}

