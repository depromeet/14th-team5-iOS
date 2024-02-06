//
//  PostGlobalState.swift
//  Core
//
//  Created by 김건우 on 1/22/24.
//

import Foundation

import RxSwift

public enum PostEvent {
    case pushPresentProfileView(String)
}

public protocol PostGlobalStateType {
    var input: BehaviorSubject<(String, String)> { get }
    var event: PublishSubject<PostEvent> { get }
    
    @discardableResult
    func PushProfileView(_ postId: String) -> Observable<String>
    
    @discardableResult
    func storeCommentText(_ postId: String, text: String) -> Observable<(String, String)>
    func clearCommentText()
}

final public class PostGlobalState: BaseGlobalState, PostGlobalStateType {
    public var input: BehaviorSubject<(String, String)> = BehaviorSubject<(String, String)>(value: ("", ""))
    public var event: PublishSubject<PostEvent> = PublishSubject<PostEvent>()
    
    public func PushProfileView(_ postId: String) -> Observable<String> {
        event.onNext(.pushPresentProfileView(postId))
        return Observable<String>.just(postId)
    }
    
    public func storeCommentText(_ postId: String, text: String) -> Observable<(String, String)> {
        input.onNext((postId, text))
        return Observable<(String, String)>.just((postId, text))
    }
    
    public func clearCommentText() {
        input.onNext((.none, .none))
    }
}
