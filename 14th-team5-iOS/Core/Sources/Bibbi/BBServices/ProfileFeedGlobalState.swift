//
//  ProfileFeedGlobalState.swift
//  Core
//
//  Created by Kim dohyun on 5/16/24.
//

import Foundation

import RxSwift

// TODO: Domain으로 옮기기
public enum BibbiFeedType: String {
    case survival = "SURVIVAL"
    case mission = "MISSION"
    case studio = "AI_IMAGE"
    
    public init?(index: Int) {
        switch index {
        case 0: self = .survival
        case 1: self = .mission
        case 2: self = .studio
        default: return nil
        }
    }
    
    public var index: Int {
        switch self {
        case .survival:
            return 0
        case .mission:
            return 1
        case .studio:
            return 2
        }
    }
    
    public static func getPostType(index: Int) -> BibbiFeedType {
        switch index {
        case 0:
            return .survival
        case 1:
            return .mission
        case 2:
            return .studio
        default:
            fatalError("index Out of range")
        }
    }
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

