//
//  FamilyNameSettingViewControllerWrapper.swift
//  App
//
//  Created by Kim dohyun on 7/23/24.
//

import Core
import Foundation


final class FamilyNameSettingViewControllerWrapper: BaseWrapper {
        
    typealias R = FamilyNameSettingViewReactor
    typealias V = FamilyNameSettingViewController
    
    
    func makeReactor() -> FamilyNameSettingViewReactor {
        return FamilyNameSettingViewReactor()
    }
    
    func makeViewController() -> FamilyNameSettingViewController {
        return FamilyNameSettingViewController(reactor: reactor)
    }
    
    var reactor: FamilyNameSettingViewReactor {
        return makeReactor()
    }
    
    var viewController: FamilyNameSettingViewController {
        return makeViewController()
    }
}
