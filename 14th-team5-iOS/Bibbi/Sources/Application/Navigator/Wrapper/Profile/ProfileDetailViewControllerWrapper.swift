//
//  ProfileDetailViewControllerWrapper.swift
//  App
//
//  Created by Kim dohyun on 6/24/24.
//

import Core
import Foundation
import MacrosInterface

@Wrapper<ProfileDetailViewReactor, ProfileDetailViewController>
final class ProfileDetailViewControllerWrapper {
    
    private let profileURL: URL
    private let userNickname: String
    
    init(profileURL: URL, userNickname: String) {
        self.profileURL = profileURL
        self.userNickname = userNickname
    }
    
    func makeReactor() -> ProfileDetailViewReactor {
        return ProfileDetailViewReactor(profileURL: profileURL, userNickname: userNickname)
    }
    
}
