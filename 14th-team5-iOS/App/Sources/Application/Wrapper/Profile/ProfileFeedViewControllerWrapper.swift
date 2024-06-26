//
//  ProfileFeedViewControllerWrapper.swift
//  App
//
//  Created by Kim dohyun on 6/24/24.
//

import Core
import Domain

import Foundation


final class ProfileFeedViewControllerWrapper: BaseWrapper {
    
    typealias R = ProfileFeedViewReactor
    typealias V = ProfileFeedViewController
        
    var reactor: ProfileFeedViewReactor {
        return makeReactor()
    }
    
    var viewController: ProfileFeedViewController {
        return makeViewController()
    }
    
    private let postType: PostType
    private let memberId: String
    
    init(postType: PostType, memberId: String) {
        self.postType = postType
        self.memberId = memberId
    }
    
    
    func makeReactor() -> ProfileFeedViewReactor {
        return ProfileFeedViewReactor(type: postType, memberId: memberId)
    }
    
    func makeViewController() -> ProfileFeedViewController {
        return ProfileFeedViewController(reactor: reactor)
    }
}
