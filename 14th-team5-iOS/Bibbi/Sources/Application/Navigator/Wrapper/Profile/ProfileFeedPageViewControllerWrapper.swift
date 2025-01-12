//
//  ProfileFeedPageViewControllerWrapper.swift
//  App
//
//  Created by Kim dohyun on 6/21/24.
//

import Core

import Foundation

final class ProfileFeedPageViewControllerWrapper {
    typealias R = ProfileFeedPageViewReactor
    typealias V = ProfileFeedPageViewController

    private let memberId: String
    
    init(memberId: String) {
        self.memberId = memberId
    }
    
    var reactor: ProfileFeedPageViewReactor {
        return makeReactor()
    }
    
    var viewController: ProfileFeedPageViewController {
        return makeViewController()
    }
    
    func makeViewController() -> ProfileFeedPageViewController {
        return ProfileFeedPageViewController(reactor: reactor, memberId: memberId)
    }
    
    func makeReactor() -> ProfileFeedPageViewReactor {
        return ProfileFeedPageViewReactor()
    }
    
}
