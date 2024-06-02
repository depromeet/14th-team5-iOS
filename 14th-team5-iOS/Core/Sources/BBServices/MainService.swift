//
//  HomeService.swift
//  Core
//
//  Created by 김건우 on 5/2/24.
//

import Foundation

import RxSwift

public enum MainEvent {
    case presentPickAlert(String, String)
    case showPickButton(Bool, String)
    case refreshMain
}

public protocol MainServiceType {
    var event: PublishSubject<MainEvent> { get }
    
    @discardableResult
    func pickButtonTapped(name: String, memberId id: String) -> Observable<Void>
    @discardableResult
    func showPickButton(_ show: Bool, memberId id: String) -> Observable<Bool>
    @discardableResult
    func refreshMain() -> Observable<Void>
}

final public class MainService: BaseService, MainServiceType {
    public var event = PublishSubject<MainEvent>()
    
    @discardableResult
    public func pickButtonTapped(name: String, memberId id: String) -> Observable<Void> {
        event.onNext(.presentPickAlert(name, id))
        return Observable<Void>.empty()
    }
    
    @discardableResult
    public func showPickButton(_ show: Bool, memberId id: String) -> Observable<Bool> {
        event.onNext(.showPickButton(show, id))
        return Observable<Bool>.just(show)
    }
    
    @discardableResult
    public func refreshMain() -> Observable<Void> {
        event.onNext(.refreshMain)
        return Observable<Void>.just(())
    }
}
