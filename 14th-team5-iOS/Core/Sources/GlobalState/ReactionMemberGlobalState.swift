//
//  ReactionMemberGlobalState.swift
//  Core
//
//  Created by 마경미 on 07.01.24.
//

import Foundation

import RxSwift

public enum ReactionMemberEvent {
    case showReactionMemberSheet([String])
}

public protocol ReactionMemberGlobalStateType {
    var event: BehaviorSubject<ReactionMemberEvent> { get }
    func showReactionMemberSheet(_ memberIds: [String]) -> Observable<[String]>
}

final public class ReactionMemberGlobalState: BaseGlobalState, ReactionMemberGlobalStateType {
    
    public var event: RxSwift.BehaviorSubject<ReactionMemberEvent> = BehaviorSubject<ReactionMemberEvent>(value: .showReactionMemberSheet([]))
    
    public func showReactionMemberSheet(_ memberIds: [String]) -> RxSwift.Observable<[String]> {
        event.onNext(.showReactionMemberSheet(memberIds))
        return Observable<[String]>.just(memberIds)
    }
}
