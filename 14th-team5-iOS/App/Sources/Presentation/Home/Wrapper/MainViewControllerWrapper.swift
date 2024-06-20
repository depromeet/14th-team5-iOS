//
//  MainViewControllerWrapper.swift
//  App
//
//  Created by 마경미 on 17.06.24.
//

import Foundation

import Core

final class MainViewControllerWrapper: BaseWrapper {
    typealias R = MainViewReactor
    typealias V = MainViewController
    
    func makeViewController() -> V {
        return MainViewController(reactor: makeReactor())
    }
    
    func makeReactor() -> R {
        return MainViewReactor()
    }
    
    var viewController: V {
        makeViewController()
    }
    
    var reactor: R {
        makeReactor()
    }
}
