//
//  HomeService.swift
//  Core
//
//  Created by 김건우 on 5/2/24.
//

import Foundation

import RxSwift

public enum HomeEvent {
    case presentPickAlert(String, String)
    case showPickButton(Bool, String)
}

public protocol HomeServiceType {
    var event: PublishSubject<HomeEvent> { get }
    
    @discardableResult
    func pickButtonTapped(name: String, memberId id: String) -> Observable<Void>
    @discardableResult
    func showPickButton(_ show: Bool, memberId id: String) -> Observable<Bool>
}

final public class HomeService: BaseGlobalState, HomeServiceType {
    public var event = PublishSubject<HomeEvent>()
    
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
    
}
