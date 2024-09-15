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
}

public protocol ManagementServiceType {
    var event: PublishSubject<ManagementEvent> { get }
    
    @discardableResult
    func didTapCopUrlAction() -> Observable<Void>
}

final public class ManagementService: BaseService, ManagementServiceType {
    
    public var event: PublishSubject<ManagementEvent> = PublishSubject<ManagementEvent>()
    
    public func didTapCopUrlAction() -> Observable<Void> {
        event.onNext(.didTapCopyUrlAction)
        return Observable<Void>.just(())
    }
    
}

