//
//  SplashViewControllerWrapper.swift
//  App
//
//  Created by 김건우 on 6/26/24.
//

import Core
import Foundation

final class SplashViewControllerWrapper: BaseWrapper {
    
    // MARK: - Typealias
    
    typealias R = SplashReactor
    typealias V = SplashViewController
    
    // MARK: - Properties
    
    var reactor: SplashReactor {
        makeReactor()
    }
    
    var viewController: SplashViewController {
        makeViewController()
    }
    
    // MARK: - Make
    
    func makeReactor() -> SplashReactor {
        SplashReactor()
    }
    
    func makeViewController() -> SplashViewController {
        SplashViewController(reactor: makeReactor())
    }
}
