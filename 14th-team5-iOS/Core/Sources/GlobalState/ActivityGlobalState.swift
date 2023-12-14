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
}

public protocol ActivityGlobalStateType {
    var event: PublishSubject<ActivityEvent> { get }
    func didTapCopyInvitationUrlAction() -> Observable<Void>
}

final public class ActivityGlobalState: BaseGlobalState, ActivityGlobalStateType {
    public var event: PublishSubject<ActivityEvent> = PublishSubject<ActivityEvent>()
    
    public func didTapCopyInvitationUrlAction() -> Observable<Void> {
        event.onNext(.didTapCopyInvitationUrlAction)
        return Observable<Void>.just(())
    }
}

