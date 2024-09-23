//
//  SplashViewControllerWrapper.swift
//  App
//
//  Created by 김건우 on 6/26/24.
//

import Core
import Foundation
import MacrosInterface

@Wrapper<SplashReactor, SplashViewController>
final class SplashViewControllerWrapper {
    
    // MARK: - Make
    
    func makeReactor() -> SplashReactor {
        SplashReactor()
    }
  
}
