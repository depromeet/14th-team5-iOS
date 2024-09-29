//
//  UpdateIsFirstOnboardingUseCase.swift
//  Domain
//
//  Created by Kim dohyun on 9/10/24.
//

import Foundation


public protocol UpdateIsFirstOnboardingUseCaseProtocol {
    func execute(_ isFirstOnboarding: Bool)
}

public final class UpdateIsFirstOnboardingUseCase: UpdateIsFirstOnboardingUseCaseProtocol {
    
    private let myRepository: any MyRepositoryProtocol
    
    public init(myRepository: any MyRepositoryProtocol) {
        self.myRepository = myRepository
    }
    
    public func execute(_ isFirstOnboarding: Bool) {
        myRepository.updateIsFirstOnboarding(isFirstOnboarding)
    }
}
