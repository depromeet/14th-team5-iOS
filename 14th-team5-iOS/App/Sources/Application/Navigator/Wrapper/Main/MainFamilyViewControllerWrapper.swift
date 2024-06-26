//
//  MainFamilyViewControllerWrapper.swift
//  App
//
//  Created by 마경미 on 17.06.24.
//

import Foundation

import Core

final class MainFamilyViewControllerWrapper: BaseWrapper {
    typealias R = MainFamilyViewReactor
    typealias V = MainFamilyViewController
    
    func makeViewController() -> V {
        return MainFamilyViewController(reactor: makeReactor())
    }
    
    func makeReactor() -> R {
        return MainFamilyViewReactor()
    }
    
    var viewController: V {
        makeViewController()
    }
    
    var reactor: R {
        makeReactor()
    }
}
