//
//  ProfileViewRepository.swift
//  Data
//
//  Created by Kim dohyun on 12/17/23.
//

import Foundation

import RxSwift
import RxCocoa


public struct FeedEntity {
    public var imageURL: String = "https://src.hidoc.co.kr/image/lib/2021/4/28/1619598179113_0.jpg"
    public var descrption: String = "https://src.hidoc.co.kr/image/lib/2021/4/28/1619598179113_0.jpg"
    public var subTitle: String = "2022-12-11"
}


public protocol ProfileViewImpl: AnyObject {
    var disposeBag: DisposeBag { get }
    
    func fetchProfileFeedItems() -> Observable<[FeedEntity]>
}


public final class ProfileViewRepository: ProfileViewImpl {
    
    public var disposeBag: DisposeBag = DisposeBag()
    
    public init() { }
    
    public func fetchProfileFeedItems() -> RxSwift.Observable<[FeedEntity]> {
        let items: [FeedEntity] = [FeedEntity]()
        
        return Observable.create { observer in
            observer.onNext(items)
            return Disposables.create()
        }
    }
    
    
}
