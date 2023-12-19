//
//  ProfileDIContainer.swift
//  App
//
//  Created by Kim dohyun on 12/17/23.
//

import Foundation

import Core
import Data


public final class ProfileDIContainer: BaseDIContainer {
    public typealias ViewContrller = ProfileViewController
    public typealias Repository = ProfileViewImpl
    public typealias Reactor = ProfileViewReactor
    
    
    public func makeViewController() -> ProfileViewController {
        return ProfileViewController(reacter: makeReactor())
    }
    
    public func makeRepository() -> Repository {
        return ProfileViewRepository()
    }
    
    public func makeReactor() -> ProfileViewReactor {
        return ProfileViewReactor(profileRepository: makeRepository())
    }
    
    
}
