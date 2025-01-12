//
//  OnBoardingDIContainer.swift
//  App
//
//  Created by geonhui Yu on 12/25/23.
//

import Foundation

import Core
import Data
import Domain

@available(*, deprecated, renamed: "OnboardingViewControllerWrapper")
public final class OnBoardingDIContainer {
    
    public func makeViewController() -> OnBoardingViewController {
        return OnBoardingViewController(reactor: makeReactor())
    }
    
    public func makeUseCase() -> FamilyUseCaseProtocol {
        return FamilyUseCase(familyRepository: makeRepository())
    }
    
    public func makeRepository() -> FamilyRepositoryProtocol {
        return FamilyRepository()
    }
    
    public func makeReactor() -> OnBoardingReactor {
        return OnBoardingReactor()
    }
}
