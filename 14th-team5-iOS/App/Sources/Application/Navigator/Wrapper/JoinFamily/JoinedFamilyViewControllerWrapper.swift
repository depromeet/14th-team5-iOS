//
//  JoinedFamilyViewControllerWrapper.swift
//  App
//
//  Created by 김건우 on 6/26/24.
//

import Core
import Foundation

final class JoinedFamilyViewControllerWrapper: BaseWrapper {
    
    // MARK: - Typealias
    
    typealias R = JoinedFamilyReactor
    typealias V = JoinedFamilyViewController
    
    // MARK: - Properties
    
    var reactor: JoinedFamilyReactor {
        makeReactor()
    }
    
    var viewController: JoinedFamilyViewController {
        makeViewController()
    }
    
    // MARK: - Make
    
    func makeReactor() -> JoinedFamilyReactor {
        JoinedFamilyReactor()
    }
    
    func makeViewController() -> JoinedFamilyViewController {
        JoinedFamilyViewController(reactor: makeReactor())
    }
    
}
