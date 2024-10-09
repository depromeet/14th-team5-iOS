//
//  FetchIsFirstOnboardingUseCase.swift
//  Domain
//
//  Created by Kim dohyun on 9/9/24.
//

import Foundation


public protocol FetchIsFirstOnboardingUseCaseProtocol {
    func execute() -> Bool
}


public final class FetchIsFirstOnboardingUseCase: FetchIsFirstOnboardingUseCaseProtocol {
    
    private let myRepository: any MyRepositoryProtocol
    
    public init(myRepository: any MyRepositoryProtocol) {
        self.myRepository = myRepository
    }
    
    public func execute() -> Bool {
        guard let isFirstOnboarding = myRepository.fetchIsFirstOnboarding() else {
            return false
        }
        return isFirstOnboarding
    }
}
