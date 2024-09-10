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
    
    typealias R = ManagementReactor
    typealias V = ManagementViewController
    
    // MARK: - Properties
    
    var reactor: ManagementReactor {
        makeReactor()
    }
    
    var viewController: ManagementViewController {
        makeViewController()
    }
    
    // MARK: - Make
    
    func makeReactor() -> ManagementReactor {
        ManagementReactor()
    }
    
    func makeViewController() -> ManagementViewController {
        ManagementViewController(reactor: makeReactor())
    }
    
}
