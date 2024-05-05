//
//  ProfileFeedUseCase.swift
//  Domain
//
//  Created by Kim dohyun on 5/4/24.
//

import Foundation

import RxSwift
import RxCocoa


public protocol ProfileFeedUseCaseProtocol {
    func execute(query: PostListQuery) -> Observable<PostListPage?>
}



public final class ProfileFeedUseCase: ProfileFeedUseCaseProtocol {
    
    private let missionFeedRepository: PostListRepositoryProtocol
    
    public init(missionFeedRepository: PostListRepositoryProtocol) {
        self.missionFeedRepository = missionFeedRepository
    }
    
    public func execute(query: PostListQuery) -> RxSwift.Observable<PostListPage?> {
        return missionFeedRepository.fetchTodayPostList(query: query)
            .asObservable()
    }
    
    
    
}
