//
//  CommentService.swift
//  Core
//
//  Created by 김건우 on 9/12/24.
//

import UIKit

import RxSwift

public enum CommentEvent {
    case hiddenTableProgressHud(hidden: Bool)
    case hiddenCommentFetchFailureView(hidden: Bool)
    case hiddenNoneCommentView(hidden: Bool)
//    case endTableRefreshing
    
    case clearCommentTextField
    case enableCommentTextField(enable: Bool)
    case enableConfirmButton(enable: Bool)
    
    case scrollCommentTableToLast(index: IndexPath)
    
    case becomeFirstResponder
}

public protocol CommentServiceType {
    var event: PublishSubject<CommentEvent> { get }
    
    @discardableResult
    func hiddenTableProgressHud(hidden: Bool) -> Observable<Bool>
    @discardableResult
    func hiddenCommentFetchFailureView(hidden: Bool) -> Observable<Bool>
    @discardableResult
    func hiddenNoneCommentView(hidden: Bool) -> Observable<Bool>
//    @discardableResult
//    func endTableRefreshing() -> Observable<Void>
    
    @discardableResult
    func clearCommentTextField() -> Observable<Void>
    @discardableResult
    func enableCommentTextField(enable: Bool) -> Observable<Bool>
    @discardableResult
    func enableConfirmButton(enable: Bool) -> Observable<Bool>
    
    @discardableResult
    func scrollCommentTableToLast(index: IndexPath) -> Observable<IndexPath>
    
    @discardableResult
    func becomeFirstResponder() -> Observable<Void>
}

final public class CommentService: BaseService, CommentServiceType {
    
    public var event: PublishSubject<CommentEvent> = PublishSubject<CommentEvent>()
    
    public func hiddenTableProgressHud(hidden: Bool) -> Observable<Bool> {
        print(#function)
        event.onNext(.hiddenTableProgressHud(hidden: hidden))
        return Observable<Bool>.just(hidden)
    }
    
    public func hiddenCommentFetchFailureView(hidden: Bool) -> Observable<Bool> {
        print(#function)
        event.onNext(.hiddenCommentFetchFailureView(hidden: hidden))
        return Observable<Bool>.just(hidden)
    }
    
    public func hiddenNoneCommentView(hidden: Bool) -> Observable<Bool> {
        print(#function)
        event.onNext(.hiddenNoneCommentView(hidden: hidden))
        return Observable<Bool>.just(hidden)
    }
    
//    public func endTableRefreshing() -> Observable<Void> {
//        event.onNext(.endTableRefreshing)
//        return Observable<Void>.just(())
//    }
    
    public func clearCommentTextField() -> Observable<Void> {
        event.onNext(.clearCommentTextField)
        return Observable<Void>.just(())
    }
    
    public func enableCommentTextField(enable: Bool) -> Observable<Bool> {
        event.onNext(.enableCommentTextField(enable: enable))
        return Observable<Bool>.just(enable)
    }
    
    public func enableConfirmButton(enable: Bool) -> Observable<Bool> {
        event.onNext(.enableConfirmButton(enable: enable))
        return Observable<Bool>.just(enable)
    }
    
    public func scrollCommentTableToLast(index: IndexPath) -> Observable<IndexPath> {
        event.onNext(.scrollCommentTableToLast(index: index))
        return Observable<IndexPath>.just(index)
    }
    
    public func becomeFirstResponder() -> Observable<Void> {
        event.onNext(.becomeFirstResponder)
        return Observable<Void>.just(())
    }
    
}


