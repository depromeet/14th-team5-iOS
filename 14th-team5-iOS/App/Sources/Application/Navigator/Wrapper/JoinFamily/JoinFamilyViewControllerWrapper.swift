//
//  JoinFamilyViewControllerWrapper.swift
//  App
//
//  Created by 김건우 on 6/26/24.
//

import Core
import Foundation

final class JoinFamilyViewControllerWrapper: BaseWrapper {
    
    // MARK: - Typealias
    
    typealias R = JoinFamilyReactor
    typealias V = JoinFamilyViewController
    
    // MARK: - Properties
    
    var reactor: JoinFamilyReactor {
        makeReactor()
    }
    
    var viewController: JoinFamilyViewController {
        makeViewController()
    }
    
    // MARK: - Make
    
    func makeReactor() -> JoinFamilyReactor {
        JoinFamilyReactor()
    }
    
    func makeViewController() -> JoinFamilyViewController {
        JoinFamilyViewController(reactor: makeReactor())
    }
    
}
