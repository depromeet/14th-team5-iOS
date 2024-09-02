//
//  JoinedFamilyViewControllerWrapper.swift
//  App
//
//  Created by 김건우 on 6/26/24.
//

import Core
import Foundation

final class FamilyEntranceControllerWrapper: BaseWrapper {
    
    // MARK: - Typealias
    
    typealias R = FamilyEntranceReactor
    typealias V = FamilyEntranceViewController
    
    // MARK: - Properties
    
    var reactor: FamilyEntranceReactor {
        makeReactor()
    }
    
    var viewController: FamilyEntranceViewController {
        makeViewController()
    }
    
    // MARK: - Make
    
    func makeReactor() -> FamilyEntranceReactor {
        FamilyEntranceReactor()
    }
    
    func makeViewController() -> FamilyEntranceViewController {
        FamilyEntranceViewController(reactor: makeReactor())
    }
    
}
