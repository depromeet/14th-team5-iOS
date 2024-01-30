//
//  PostGlobalState.swift
//  Core
//
//  Created by 김건우 on 1/22/24.
//

import Foundation

import RxSwift

public enum PostEvent {
    case presentPostCommentSheet(String, Int)
}

public protocol PostGlobalStateType {
    var input: BehaviorSubject<(String, String)> { get }
    var event: PublishSubject<PostEvent> { get }
    
    @discardableResult
    func presentPostCommentSheet(_ postId: String, commentCount: Int) -> Observable<Int>
    @discardableResult
    func storeCommentText(_ postId: String, text: String) -> Observable<(String, String)>
    func clearCommentText()
}

final public class PostGlobalState: BaseGlobalState, PostGlobalStateType {
    public var input: BehaviorSubject<(String, String)> = BehaviorSubject<(String, String)>(value: ("", ""))
    public var event: PublishSubject<PostEvent> = PublishSubject<PostEvent>()
    
    public func presentPostCommentSheet(_ postId: String, commentCount: Int) -> Observable<Int> {
        event.onNext(.presentPostCommentSheet(postId, commentCount))
        return Observable<Int>.just(commentCount)
    }
    
    public func storeCommentText(_ postId: String, text: String) -> Observable<(String, String)> {
        debugPrint("텍스트 저장됨 \(postId), \(text)")
        input.onNext((postId, text))
        return Observable<(String, String)>.just((postId, text))
    }
    
    public func clearCommentText() {
        input.onNext((.none, .none))
    }
}
