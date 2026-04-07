//
//  FetchStudioThemeUseCase.swift
//  Domain
//
//  Created by 마경미 on 19.02.26.
//

import Foundation

import RxSwift

public protocol FetchStudioThemeListUseCaseProtocol {
    func execute() -> Observable<[StudioThemeEntity]?>
}

public final class FetchStudioThemeListUseCase : FetchStudioThemeListUseCaseProtocol {
    
    private let studioRepository: StudioRepositoryProtocol
    
    public init(
        studioRepository: StudioRepositoryProtocol
    ) {
        self.studioRepository = studioRepository
    }
    
    public func execute() -> Observable<[StudioThemeEntity]?> {
        return studioRepository.fetchStudioThemeList()
    }
}
