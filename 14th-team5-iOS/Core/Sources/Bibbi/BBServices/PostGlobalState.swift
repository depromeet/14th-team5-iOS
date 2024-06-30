//
//  PostGlobalState.swift
//  Core
//
//  Created by 김건우 on 1/22/24.
//

import Foundation

import RxSwift

public enum PostEvent {
    case pushProfileViewController(String)
    case renewalPostCommentCount(Int)
    case receiveMissionContent(String)
}

public protocol PostGlobalStateType {
    var input: BehaviorSubject<(String, String)> { get }
    var event: PublishSubject<PostEvent> { get }
    
    @discardableResult
    func pushProfileViewController(_ memberId: String) -> Observable<String>
    
    @discardableResult
    func storeCommentText(_ postId: String, text: String) -> Observable<(String, String)>
    func clearCommentText()
    
    @discardableResult
    func renewalPostCommentCount(_ count: Int) -> Observable<Int>
    
    @discardableResult
    func missionContentText(_ content: String) -> Observable<String>
}

final public class PostGlobalState: BaseService, PostGlobalStateType {
    public var input: BehaviorSubject<(String, String)> = BehaviorSubject<(String, String)>(value: ("", ""))
    public var event: PublishSubject<PostEvent> = PublishSubject<PostEvent>()
    
    public func pushProfileViewController(_ memberId: String) -> Observable<String> {
        event.onNext(.pushProfileViewController(memberId))
        return Observable<String>.just(memberId)
    }
    
    public func renewalPostCommentCount(_ count: Int) -> Observable<Int> {
        event.onNext(.renewalPostCommentCount(count))
        return Observable<Int>.just(count)
    }
    
    public func storeCommentText(_ postId: String, text: String) -> Observable<(String, String)> {
        input.onNext((postId, text))
        return Observable<(String, String)>.just((postId, text))
    }
    
    public func clearCommentText() {
        input.onNext((.none, .none))
    }
    
    public func missionContentText(_ content: String) -> Observable<String> {
        event.onNext(.receiveMissionContent(content))
        return Observable<String>.just(content)
    }
}
