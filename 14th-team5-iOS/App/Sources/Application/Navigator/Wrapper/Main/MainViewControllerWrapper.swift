//
//  MainViewControllerWrapper.swift
//  App
//
//  Created by 마경미 on 17.06.24.
//

import Core
import Foundation
import MacrosInterface

@Wrapper<MainViewReactor, MainViewController>
final class MainViewControllerWrapper {
   
    func makeReactor() -> R {
        return MainViewReactor()
    }
    
}
