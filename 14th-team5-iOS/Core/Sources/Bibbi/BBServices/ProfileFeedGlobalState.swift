//
//  ProfileFeedGlobalState.swift
//  Core
//
//  Created by Kim dohyun on 5/16/24.
//

import Foundation

import RxSwift

public enum BibbiFeedType: Int {
    case survival = 0
    case mission = 1
}

public enum ProfileFeedEvent {
    case didTapSegmentedPage(BibbiFeedType)
    case didReceiveMemberId(BibbiFeedType)
}


public protocol ProfileFeedGlobalStateType {
    var event: PublishSubject<ProfileFeedEvent> { get }
    
    @discardableResult
    func didTapSegmentedPageType(type: BibbiFeedType) -> Observable<BibbiFeedType>
    @discardableResult
    func didReceiveMemberId(memberId: BibbiFeedType) -> Observable<BibbiFeedType>
}

public final class ProfileFeedGlobalState: BaseService, ProfileFeedGlobalStateType {
    
    public var event: PublishSubject<ProfileFeedEvent> = PublishSubject()
    
    public func didTapSegmentedPageType(type: BibbiFeedType) -> Observable<BibbiFeedType> {
        event.onNext(.didTapSegmentedPage(type))
        return Observable<BibbiFeedType>.just(type)
    }
    
    public func didReceiveMemberId(memberId: BibbiFeedType) -> Observable<BibbiFeedType> {
        event.onNext(.didReceiveMemberId(memberId))
        return Observable<BibbiFeedType>.just(memberId)
    }
}

