//
//  CommentService.swift
//  Core
//
//  Created by 김도현 on 1/27/25.
//

import UIKit

import RxSwift


public enum CommentEvent {
    case didReceiveVoiceCommentFile(_ file: Data)
    case didTappedPlaybutton(_ commentId: String)
}

public protocol CommentServiceType {
    var event: PublishSubject<CommentEvent> { get }
    
    @discardableResult
    func didReceiveVoiceCommentFile(_ file: Data) -> Observable<Data>
    @discardableResult
    func didTappedPlayButton(with commentId: String) -> Observable<String>
}

public final class CommentService: BaseService, CommentServiceType {
    
    public var event = PublishSubject<CommentEvent>()
    
    public func didReceiveVoiceCommentFile(_ file: Data) -> RxSwift.Observable<Data> {
        event.onNext(.didReceiveVoiceCommentFile(file))
        return Observable<Data>.just(file)
    }
    
    public func didTappedPlayButton(with commentId: String) -> Observable<String> {
        event.onNext(.didTappedPlaybutton(commentId))
        return Observable<String>.just(commentId)
    }
    
    
    
    
}
