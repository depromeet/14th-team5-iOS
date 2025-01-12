//
//  ProfileFeedViewControllerWrapper.swift
//  App
//
//  Created by Kim dohyun on 6/24/24.
//

import Core
import Domain
import Foundation
import MacrosInterface

@Wrapper<ProfileFeedViewReactor, ProfileFeedViewController>
final class ProfileFeedViewControllerWrapper {
    
    private let postType: PostType
    private let memberId: String
    
    init(postType: PostType, memberId: String) {
        self.postType = postType
        self.memberId = memberId
    }
    
    
    func makeReactor() -> ProfileFeedViewReactor {
        return ProfileFeedViewReactor(type: postType, memberId: memberId)
    }

}
