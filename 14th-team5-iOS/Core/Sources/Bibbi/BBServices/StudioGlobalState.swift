//
//  StudioGlobalState.swift
//  Core
//
//  Created by 김도현 on 9/28/25.
//

import Foundation

import RxSwift


public enum StduioEvent {
    case receiveMemoriesCount(Int)
}


public protocol StudioGlobalStateType {
    var event: PublishSubject<StduioEvent> { get }
    
    @discardableResult
    func updateMemoriesItemCount(_ count: Int) -> Observable<Int>
}


public final class StudioGlobalState: BaseService, StudioGlobalStateType {
    public var event: PublishSubject<StduioEvent> = PublishSubject<StduioEvent>()
    
    
    public func updateMemoriesItemCount(_ count: Int) -> RxSwift.Observable<Int> {
        event.onNext(.receiveMemoriesCount(count))
        
        return Observable<Int>.just(count)
    }
}
