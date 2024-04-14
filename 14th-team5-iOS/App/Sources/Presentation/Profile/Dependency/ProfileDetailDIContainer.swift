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
    private let userNickname: String
    
    init(profileURL: URL, userNickname: String) {
        self.profileURL = profileURL
        self.userNickname = userNickname
    }
    
    
    public func makeReactor() -> Reactor {
        return ProfileDetailViewReactor(profileURL: profileURL, userNickname: userNickname)
    }
    
    public func makeViewController() -> ViewContrller {
        return ProfileDetailViewController(reactor: makeReactor())
    }
    
    
    
}
