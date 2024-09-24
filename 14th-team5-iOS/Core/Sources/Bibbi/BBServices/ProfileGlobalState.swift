//
//  ProfileGlobalState.swift
//  Core
//
//  Created by 김건우 on 2/12/24.
//

import UIKit

import RxSwift

public enum ProfileEvent {
    case refreshFamilyMembers
    case fetchMemberId(String)
}

public protocol ProfileGlobalStateType {
    var event: PublishSubject<ProfileEvent> { get }
    
    @discardableResult
    func refreshFamilyMembers() -> Observable<Void>
    @discardableResult
    func fetchMemberdId(memberId: String) -> Observable<String>
}

final public class ProfileGlobalState: BaseService, ProfileGlobalStateType {
    public var event: PublishSubject<ProfileEvent> = PublishSubject<ProfileEvent>()
    
    public func refreshFamilyMembers() -> Observable<Void> {
        event.onNext(.refreshFamilyMembers)
        return Observable<Void>.just(())
    }
    
    public func fetchMemberdId(memberId: String) -> Observable<String> {
        event.onNext(.fetchMemberId(memberId))
        return Observable<String>.just(memberId)
    }
}

