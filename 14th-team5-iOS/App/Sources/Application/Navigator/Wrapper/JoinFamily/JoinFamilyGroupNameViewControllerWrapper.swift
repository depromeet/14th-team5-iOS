//
//  JoinFamilyGroupNameViewControllerWrapper.swift
//  App
//
//  Created by Kim dohyun on 7/23/24.
//

import Core
import Foundation


final class JoinFamilyGroupNameViewControllerWrapper: BaseWrapper {
        
    typealias R = JoinFamilyGroupNameViewReactor
    typealias V = JoinFamilyGroupNameViewController
    
    
    func makeReactor() -> JoinFamilyGroupNameViewReactor {
        return JoinFamilyGroupNameViewReactor()
    }
    
    func makeViewController() -> JoinFamilyGroupNameViewController {
        return JoinFamilyGroupNameViewController(reactor: reactor)
    }
    
    var reactor: JoinFamilyGroupNameViewReactor {
        return makeReactor()
    }
    
    var viewController: JoinFamilyGroupNameViewController {
        return makeViewController()
    }
}
