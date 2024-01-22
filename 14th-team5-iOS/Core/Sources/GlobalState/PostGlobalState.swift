//
//  PostGlobalState.swift
//  Core
//
//  Created by 김건우 on 1/22/24.
//

import Foundation

import RxSwift

public enum PostEvent {
    case presentPostCommentSheet(Int)
}

public protocol PostGlobalStateType {
    var event: PublishSubject<PostEvent> { get }
    
    @discardableResult
    func presentPostCommentSheet(_ commentCount: Int) -> Observable<Int>
}

final public class PostGlobalState: BaseGlobalState, PostGlobalStateType {
    public var event: PublishSubject<PostEvent> = PublishSubject<PostEvent>()
    
    public func presentPostCommentSheet(_ commentCount: Int) -> Observable<Int> {
        event.onNext(.presentPostCommentSheet(commentCount))
        return Observable<Int>.just(commentCount)
    }
}
