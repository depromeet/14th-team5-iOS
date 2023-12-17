//
//  PrivacyDIContainer.swift
//  App
//
//  Created by Kim dohyun on 12/16/23.
//

import Foundation

import Data
import Core


public final class PrivacyDIContainer: BaseDIContainer {
    public typealias ViewContrller = PrivacyViewController
    public typealias Repository = PrivacyViewImpl
    public typealias Reactor = PrivacyViewReactor
    
    
    public func makeViewController() -> PrivacyViewController {
        return PrivacyViewController(reacter: makeReactor())
    }
    
    public func makeRepository() -> Repository {
        return PrivacyViewRepository()
    }
    
    public func makeReactor() -> PrivacyViewReactor {
        return PrivacyViewReactor(privacyRepository: makeRepository())
    }
    
}
