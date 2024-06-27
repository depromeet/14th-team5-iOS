//
//  ProfileViewControllerWrapper.swift
//  App
//
//  Created by Kim dohyun on 6/21/24.
//

import Core

import Foundation

final class ProfileViewControllerWrapper: BaseWrapper {
    typealias R = ProfileViewReactor
    typealias V = ProfileViewController
    
    private let memberId: String
    private let isUser: Bool
    
    init(
        memberId: String = ""
    ) {
        self.memberId = memberId
        self.isUser = memberId == App.Repository.member.memberID.value ? true : false
    }
    
    var reactor: ProfileViewReactor {
        return makeReactor()
    }
    
    var viewController: ProfileViewController {
        return makeViewController()
    }
    
    
    func makeViewController() -> ProfileViewController {
        return ProfileViewController(reactor: reactor)
    }
    
    func makeReactor() -> ProfileViewReactor {
        ProfileViewReactor(memberId: memberId, isUser: isUser)
    }
}
