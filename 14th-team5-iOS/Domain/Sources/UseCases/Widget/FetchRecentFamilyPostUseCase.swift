//
//  FetchRecentFamilyPostUseCase.swift
//  Domain
//
//  Created by 마경미 on 05.06.24.
//

import Foundation

public protocol FetchRecentFamilyPostUseCaseProtocol {
    func excute(completion: @escaping (Result<WidgetPostEntity, Error>) -> Void)
}

public class FetchRecentFamilyPostUseCase: FetchRecentFamilyPostUseCaseProtocol {
    private let widgetRepository: WidgetRepositoryProtocol
    
    public init(widgetRepository: WidgetRepositoryProtocol) {
        self.widgetRepository = widgetRepository
    }
    
    public func excute(completion: @escaping (Result<WidgetPostEntity, Error>) -> Void) {
        return widgetRepository.fetchRecentFamilyPost(completion: completion)
    }
}
