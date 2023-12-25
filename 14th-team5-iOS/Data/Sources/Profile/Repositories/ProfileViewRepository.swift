//
//  ProfileViewRepository.swift
//  Data
//
//  Created by Kim dohyun on 12/25/23.
//

import Foundation

import Domain
import RxSwift
import RxCocoa





public final class ProfileViewRepository {
        
    public var disposeBag: DisposeBag = DisposeBag()
    private let profileAPIWorker: ProfileAPIWorker = ProfileAPIWorker()
    private let accessToken: String = "eyJyZWdEYXRlIjoxNzAzNTIwODMzMjkwLCJ0eXBlIjoiYWNjZXNzIiwiYWxnIjoiSFMyNTYiLCJ0eXAiOiJKV1QifQ.eyJ1c2VySWQiOiIwMUhKQk5YQVYwVFlRMUtFU1dFUjQ1QTJRUCIsImV4cCI6MTcwMzYwNzIzM30.3sXvWVhPzb_CHXDrscsZCznIXt_sMaORb55n54JojCY"
    
    public init() { }
    
}


extension ProfileViewRepository: ProfileViewInterface {
    
    
    public func fetchProfileMemberItems() -> Observable<ProfileMemberResponse> {
        return profileAPIWorker.fetchProfileMember(accessToken: accessToken, "01HJBNXAV0TYQ1KESWER45A2QP")
            .compactMap { $0?.toDomain() }
            .asObservable()
    }
    
    
    public func fetchProfileFeedItems() -> RxSwift.Observable<[Domain.FeedEntity]> {
        let items: [FeedEntity] = [
            FeedEntity(
                imageURL: "https://src.hidoc.co.kr/image/lib/2021/4/28/1619598179113_0.jpg",
                descrption: "테스트 입니다!!!",
                subTitle: "2022-12-11"
            ),
            FeedEntity(
                imageURL: "https://src.hidoc.co.kr/image/lib/2021/4/28/1619598179113_0.jpg",
                descrption: "테스트 입니다!!!",
                subTitle: "2022-12-11"
            ),
            FeedEntity(
                imageURL: "https://src.hidoc.co.kr/image/lib/2021/4/28/1619598179113_0.jpg",
                descrption: "테스트 입니다!!!",
                subTitle: "2022-12-11"
            ),
            FeedEntity(
                imageURL: "https://src.hidoc.co.kr/image/lib/2021/4/28/1619598179113_0.jpg",
                descrption: "테스트 입니다!!!",
                subTitle: "2022-12-11"
            ),
            FeedEntity(
                imageURL: "https://src.hidoc.co.kr/image/lib/2021/4/28/1619598179113_0.jpg",
                descrption: "테스트 입니다!!!",
                subTitle: "2022-12-11"
            ),
            FeedEntity(
                imageURL: "https://src.hidoc.co.kr/image/lib/2021/4/28/1619598179113_0.jpg",
                descrption: "테스트 입니다!!!",
                subTitle: "2022-12-11"
            ),
            FeedEntity(
                imageURL: "https://src.hidoc.co.kr/image/lib/2021/4/28/1619598179113_0.jpg",
                descrption: "테스트 입니다!!!",
                subTitle: "2022-12-11"
            )
        ]
        
        return Observable.create { observer in
            observer.onNext(items)
            return Disposables.create()
        }
    }
    
    
}
