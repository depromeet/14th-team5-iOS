//
//  ProfileViewControllerWrapper.swift
//  App
//
//  Created by Kim dohyun on 6/21/24.
//

import Core
import Foundation
import MacrosInterface

@Wrapper<ProfileViewReactor, ProfileViewController>
final class ProfileViewControllerWrapper {
    
    private let memberId: String
    private let isUser: Bool
    
    init(
        memberId: String = ""
    ) {
        self.memberId = memberId
        self.isUser = memberId == App.Repository.member.memberID.value ? true : false
    }
   
    func makeReactor() -> ProfileViewReactor {
        ProfileViewReactor(memberId: memberId, isUser: isUser)
    }
}
