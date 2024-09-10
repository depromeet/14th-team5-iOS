//
//  ManagementViewController.swift
//  App
//
//  Created by 김건우 on 6/25/24.
//

import Core
import Foundation

final class ManagementViewControllerWrapper: BaseWrapper {
    
    // MARK: - Typealias
    
    typealias R = ManagementViewReactor
    typealias V = ManagementViewController
    
    // MARK: - Properties
    
    var reactor: ManagementViewReactor {
        makeReactor()
    }
    
    var viewController: ManagementViewController {
        makeViewController()
    }
    
    // MARK: - Make
    
    func makeReactor() -> ManagementViewReactor {
        ManagementViewReactor()
    }
    
    func makeViewController() -> ManagementViewController {
        ManagementViewController(reactor: makeReactor())
    }
    
}
