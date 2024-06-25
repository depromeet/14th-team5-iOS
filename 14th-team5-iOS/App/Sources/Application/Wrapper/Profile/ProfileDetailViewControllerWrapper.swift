//
//  ProfileDetailViewControllerWrapper.swift
//  App
//
//  Created by Kim dohyun on 6/24/24.
//

import Core

import Foundation

final class ProfileDetailViewControllerWrapper: BaseWrapper {
    typealias R = ProfileDetailViewReactor
    typealias V = ProfileDetailViewController
    
    var reactor: ProfileDetailViewReactor {
        return makeReactor()
    }
    
    var viewController: ProfileDetailViewController {
        return makeViewController()
    }
    
    private let profileURL: URL
    private let userNickname: String
    
    init(profileURL: URL, userNickname: String) {
        self.profileURL = profileURL
        self.userNickname = userNickname
    }
    
    func makeReactor() -> ProfileDetailViewReactor {
        return ProfileDetailViewReactor(profileURL: profileURL, userNickname: userNickname)
    }
    
    func makeViewController() -> ProfileDetailViewController {
        return ProfileDetailViewController(reactor: reactor)
    }
    
    
}
