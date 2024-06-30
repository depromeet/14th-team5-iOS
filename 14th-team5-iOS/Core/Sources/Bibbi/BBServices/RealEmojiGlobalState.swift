//
//  RealEmojiGlobalState.swift
//  Core
//
//  Created by Kim dohyun on 1/24/24.
//

import Foundation

import RxSwift


public enum RealEmojiEvent {
    case didTapRealEmojiPad(Int)
    case updateRealEmojiImage(Int, URL)
    case createRealEmojiImage(Int, URL, String)
}

public protocol RealEmojiGlobalStateType {
    var event: PublishSubject<RealEmojiEvent> { get }
    @discardableResult
    func updateRealEmojiImage(indexPath row: Int, image: URL) -> Observable<(Int, URL)>
    @discardableResult
    func createRealEmojiImage(indexPath row: Int, image: URL, emojiType: String) -> Observable<(Int, URL, String)>
    @discardableResult
    func didTapRealEmojiEvent(indexPath row: Int) -> Observable<Int>
}


public final class RealEmojiGlobalState: BaseService, RealEmojiGlobalStateType {
    public var event: PublishSubject<RealEmojiEvent> = PublishSubject<RealEmojiEvent>()
    
    public func didTapRealEmojiEvent(indexPath row: Int) -> RxSwift.Observable<Int> {
        event.onNext(.didTapRealEmojiPad(row))
        return Observable<Int>.just(row)
    }
    
    public func updateRealEmojiImage(indexPath row: Int, image: URL) -> RxSwift.Observable<(Int, URL)> {
        event.onNext(.updateRealEmojiImage(row, image))
        return Observable<(Int, URL)>.just((row, image))
    }
    
    public func createRealEmojiImage(indexPath row: Int, image: URL, emojiType: String) -> Observable<(Int, URL, String)> {
        event.onNext(.createRealEmojiImage(row, image, emojiType))
        return Observable<(Int, URL, String)>.just((row, image, emojiType))
    }
    
}
