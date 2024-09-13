//
//  ActivityGlobalState.swift
//  Core
//
//  Created by 김건우 on 12/13/23.
//

import UIKit

import RxSwift

public enum ManagementEvent {
    case didTapCopyUrlAction
    case hiddenSharingProgressHud(hidden: Bool)
    case hiddenTableProgressHud(hidden: Bool)
    case hiddenMemberFetchFailureView(hidden: Bool)
    case setTableHeaderInfo(familyName: String, memberCount: Int)
    case endTableRefreshing
}

public protocol ManagementServiceType {
    var event: PublishSubject<ManagementEvent> { get }
    
    @discardableResult
    func didTapCopUrlAction() -> Observable<Void>
    @discardableResult
    func hiddenSharingProgressHud(hidden: Bool) -> Observable<Bool>
    @discardableResult
    func hiddenTableProgressHud(hidden: Bool) -> Observable<Bool>
    @discardableResult
    func hiddenMemberFetchFailureView(hidden: Bool) -> Observable<Bool>
    @discardableResult
    func setTableHeaderInfo(familyName: String, memberCount: Int) -> Observable<(String, Int)>
    @discardableResult
    func endTableRefreshing() -> Observable<Void>
}

final public class ManagementService: BaseService, ManagementServiceType {
    
    public var event: PublishSubject<ManagementEvent> = PublishSubject<ManagementEvent>()
    
    public func didTapCopUrlAction() -> Observable<Void> {
        event.onNext(.didTapCopyUrlAction)
        return Observable<Void>.just(())
    }
    
    public func hiddenSharingProgressHud(hidden: Bool) -> Observable<Bool> {
        event.onNext(.hiddenSharingProgressHud(hidden: hidden))
        return Observable<Bool>.just(hidden)
    }
    
    public func hiddenTableProgressHud(hidden: Bool) -> Observable<Bool> {
        event.onNext(.hiddenTableProgressHud(hidden: hidden))
        return Observable<Bool>.just(hidden)
    }
    
    public func hiddenMemberFetchFailureView(hidden: Bool) -> Observable<Bool> {
        event.onNext(.hiddenMemberFetchFailureView(hidden: hidden))
        return Observable<Bool>.just(hidden)
    }
    
    public func setTableHeaderInfo(familyName: String, memberCount: Int) -> Observable<(String, Int)> {
        event.onNext(.setTableHeaderInfo(familyName: familyName, memberCount: memberCount))
        return Observable<(String, Int)>.just((familyName, memberCount))
    }
    
    public func endTableRefreshing() -> Observable<Void> {
        event.onNext(.endTableRefreshing)
        return Observable<Void>.just(())
    }
    
}

