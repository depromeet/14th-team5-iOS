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
}

public protocol CommentServiceType {
    var event: PublishSubject<CommentEvent> { get }
    
    @discardableResult
    func didReceiveVoiceCommentFile(_ file: Data) -> Observable<Data>
}

public final class CommentService: BaseService, CommentServiceType {
    
    public var event = PublishSubject<CommentEvent>()
    
    public func didReceiveVoiceCommentFile(_ file: Data) -> RxSwift.Observable<Data> {
        event.onNext(.didReceiveVoiceCommentFile(file))
        return Observable<Data>.just(file)
    }
    
    
    
    
}
