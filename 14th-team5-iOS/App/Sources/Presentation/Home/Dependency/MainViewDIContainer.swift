//
//  HomeDIContainer.swift
//  App
//
//  Created by 마경미 on 24.12.23.
//

import UIKit

import Data
import Domain
import Core


final class MainViewDIContainer {
    private var globalState: GlobalStateProviderProtocol {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return GlobalStateProvider()
        }
        return appDelegate.globalStateProvider
    }
    
    
    func makeViewController() -> MainViewController {
        return MainViewController(reactor: makeReactor())
    }
    
    private func makeReactor() -> MainViewReactor {
        return MainViewReactor(provider: globalState)
    }
}
