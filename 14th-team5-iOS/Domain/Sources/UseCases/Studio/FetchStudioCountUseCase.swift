//
//  Studio.swift
//  Domain
//
//  Created by 마경미 on 27.09.25.
//

import Foundation

import RxSwift

public protocol FetchStudioCountUseCaseProtocol {
    func execute(aiPostType: String) -> Observable<StudioCountEntity>
}

enum StudioError: Error {
    case failedToFetch
}

public final class FetchStudioCountUseCase : FetchStudioCountUseCaseProtocol {
    
    private let studioRepository: StudioRepositoryProtocol
    
    public init(
        studioRepository: StudioRepositoryProtocol
    ) {
        self.studioRepository = studioRepository
    }
    
    public func execute(aiPostType: String) -> Observable<StudioCountEntity> {
        return studioRepository.fetchStudioCount(aiPostType: aiPostType)
            .flatMap { counts -> Observable<StudioCountEntity> in
                guard let counts else {
                    return .just(.init(postCount: 0, availableCount: 0))
                }
                return .just(counts)
            }
    }
}
