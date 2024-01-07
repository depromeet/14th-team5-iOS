//
//  ReactionMemberGlobalState.swift
//  Core
//
//  Created by 마경미 on 07.01.24.
//

import Foundation

import RxSwift

public enum ReactionMemberEvent {
    case showReactionMemberSheet(Bool)
}

public protocol ReactionMemberGlobalStateType {
    var event: BehaviorSubject<ReactionMemberEvent> { get }
    func showReactionMemberSheet(_ isShow: Bool) -> Observable<Bool>
}

final public class ReactionMemberGlobalState: BaseGlobalState, ReactionMemberGlobalStateType {
    
    public var event: RxSwift.BehaviorSubject<ReactionMemberEvent> = BehaviorSubject<ReactionMemberEvent>(value: .showReactionMemberSheet(false))
    
    public func showReactionMemberSheet(_ isShow: Bool) -> RxSwift.Observable<Bool> {
        event.onNext(.showReactionMemberSheet(isShow))
        return Observable<Bool>.just(isShow)
    }
}
