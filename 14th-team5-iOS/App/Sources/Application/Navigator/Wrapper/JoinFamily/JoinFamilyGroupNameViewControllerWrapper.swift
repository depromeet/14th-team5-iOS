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
        return reactor
    }
    
    func makeViewController() -> JoinFamilyGroupNameViewController {
        return viewController
    }
    
    var reactor: JoinFamilyGroupNameViewReactor {
        return JoinFamilyGroupNameViewReactor()
    }
    
    var viewController: JoinFamilyGroupNameViewController {
        return JoinFamilyGroupNameViewController(reactor: reactor)
    }
}
