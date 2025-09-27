//
//  SaveIsAITermsAgreedUseCase.swift
//  Domain
//
//  Created by 마경미 on 27.09.25.
//

import Foundation

import RxSwift

public protocol SaveIsAITermsAgreedUseCaseProtocol {
    func execute(_ isAgreed: Bool)
}

public class SaveIsAITermsAgreedUseCase: SaveIsAITermsAgreedUseCaseProtocol {
    
    private let repository: AppRepositoryProtocol
    
    public init(repository: AppRepositoryProtocol) {
        self.repository = repository
    }
    
    public func execute(_ isAgreed: Bool) {
        repository.saveIsAITermsAgreed(isAgreed: isAgreed)
    }
}
