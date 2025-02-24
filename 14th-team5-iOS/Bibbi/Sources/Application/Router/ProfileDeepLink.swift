//
//  ProfileDeepLink.swift
//  Bibbi
//
//  Created by 마경미 on 24.02.25.
//

import Foundation

import Core

// MARK: - Profile 딥링크
final class ProfileDeepLink: DeepLinkProtocol {
    enum ProfileDeepLinkType {
        case openProfile(memberId: String)
    }
    
    let type: ProfileDeepLinkType
    
    init(
        pathComponents: [String]
    ) {
        guard pathComponents.first == "profile",
              let memberId = pathComponents[safe: 1] else {
            BBToast.text("화면을 이동할 수 없어요").show()
            return
        }
        type = .openProfile(memberId: memberId)
    }
    
    func doDeepLink() {
        switch self.type {
        case let .openProfile(memberId):
            openProfile(memberId)
        }
    }
}

extension ProfileDeepLink {
    private func openProfile(_ memberId: String) {
        
    }
}
