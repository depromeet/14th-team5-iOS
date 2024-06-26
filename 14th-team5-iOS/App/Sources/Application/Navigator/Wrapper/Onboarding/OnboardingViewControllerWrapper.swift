//
//  OnboardingViewControllerWrapper.swift
//  App
//
//  Created by 김건우 on 6/26/24.
//

import Core
import Foundation

final class OnboardingViewControllerWrapper: BaseWrapper {
    
    // MARK: - Typealias
    
    typealias R = OnBoardingReactor
    typealias V = OnBoardingViewController
    
    // MARK: - Properties
    
    var reactor: OnBoardingReactor {
        makeReactor()
    }
    
    var viewController: OnBoardingViewController {
        makeViewController()
    }
    
    // MARK: - Make
    
    func makeReactor() -> OnBoardingReactor {
        OnBoardingReactor()
    }
    
    func makeViewController() -> OnBoardingViewController {
        OnBoardingViewController(reactor: makeReactor())
    }
    
}
