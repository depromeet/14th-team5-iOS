//
//  OnboardingViewControllerWrapper.swift
//  App
//
//  Created by 김건우 on 6/26/24.
//

import Core
import Foundation
import MacrosInterface

@Wrapper<OnBoardingReactor, OnBoardingViewController>
final class OnboardingViewControllerWrapper {
    
    // MARK: - Make
    
    func makeReactor() -> OnBoardingReactor {
        OnBoardingReactor()
    }
    
}
