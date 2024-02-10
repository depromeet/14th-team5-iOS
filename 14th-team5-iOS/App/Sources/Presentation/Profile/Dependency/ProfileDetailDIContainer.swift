//
//  ProfileDetailDIContainer.swift
//  App
//
//  Created by Kim dohyun on 2/10/24.
//

import Foundation

import Core


final class ProfileDetailDIContainer {
    public typealias ViewContrller = ProfileDetailViewController
    public typealias Reactor = ProfileDetailViewReactor
    
    private let profileURL: URL
    
    init(profileURL: URL) {
        self.profileURL = profileURL
    }
    
    
    public func makeReactor() -> Reactor {
        return ProfileDetailViewReactor(profileURL: profileURL)
    }
    
    public func makeViewController() -> ViewContrller {
        return ProfileDetailViewController(reactor: makeReactor())
    }
    
    
    
}
