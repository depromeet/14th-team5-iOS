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
    
    var type: ProfileDeepLinkType?
    
    init(
        pathComponents: [String]
    ) {
        if pathComponents.count > 2,
           pathComponents[1] == "profile" {
            type = .openProfile(memberId: pathComponents[2])
        }
    }
    
    func doDeepLink() throws {
        guard let type = type else {
            throw DeepLinkError.invalidLink
        }
        
        switch type {
        case let .openProfile(memberId):
            openProfile(memberId)
        }
    }
}

extension ProfileDeepLink {
    private func openProfile(_ memberId: String) {
        let viewController = ProfileViewControllerWrapper(
            memberId: memberId
        ).viewController
        
        getNavigationController()?.pushViewController(
            viewController,
            animated: true
        )
    }
}
