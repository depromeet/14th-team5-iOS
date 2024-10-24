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
    case renewalCommentCount(Int)
    case receiveMissionContent(String)
}

public protocol PostGlobalStateType {

    var event: PublishSubject<PostEvent> { get }
    
    @discardableResult
    func pushProfileViewController(_ memberId: String) -> Observable<String>
    
    @discardableResult
    func renewalPostCommentCount(_ count: Int) -> Observable<Int>
    
    @discardableResult
    func missionContentText(_ content: String) -> Observable<String>
}

final public class PostGlobalState: BaseService, PostGlobalStateType {

    public var event: PublishSubject<PostEvent> = PublishSubject<PostEvent>()
    
    @available(*, deprecated, message: "Navigator를 사용하세요.")
    public func pushProfileViewController(_ memberId: String) -> Observable<String> {
        event.onNext(.pushProfileViewController(memberId))
        return Observable<String>.just(memberId)
    }
    
    public func renewalPostCommentCount(_ count: Int) -> Observable<Int> {
        event.onNext(.renewalCommentCount(count))
        return Observable<Int>.just(count)
    }
    
    public func missionContentText(_ content: String) -> Observable<String> {
        event.onNext(.receiveMissionContent(content))
        return Observable<String>.just(content)
    }
}
