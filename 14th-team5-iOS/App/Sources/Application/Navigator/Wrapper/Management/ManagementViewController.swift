//
//  ManagementViewController.swift
//  App
//
//  Created by 김건우 on 6/25/24.
//

import Core
import Foundation

final class ManagementViewController: BaseWrapper {
    
    // MARK: - Typealias
    
    typealias R = FamilyManagementViewReactor
    typealias V = FamilyManagementViewController
    
    // MARK: - Properties
    
    var reactor: FamilyManagementViewReactor {
        makeReactor()
    }
    
    var viewController: FamilyManagementViewController {
        makeViewController()
    }
    
    // MARK: - Make
    
    func makeReactor() -> FamilyManagementViewReactor {
        FamilyManagementViewReactor()
    }
    
    func makeViewController() -> FamilyManagementViewController {
        FamilyManagementViewController(reactor: makeReactor())
    }
    
}
