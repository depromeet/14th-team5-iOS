//
//  StoreDeepLink.swift
//  Bibbi
//
//  Created by 마경미 on 24.02.25.
//

import Foundation
import StoreKit

import Core

// MARK: - Store 딥링크
final class StoreDeepLink: DeepLinkProtocol {
    enum StoreDeepLinkType {
        case openAppStore
    }
    
    var type: StoreDeepLinkType?
    
    init(
        pathComponents: [String]
    ) {
        if pathComponents.count > 1,
           pathComponents[1] == "bibbi" {
            type = .openAppStore
        }
    }
    
    func doDeepLink() throws {
        guard let type else {
            throw DeepLinkError.invalidLink
        }
        switch type {
        case .openAppStore: openAppStore()
        }
    }
}

extension StoreDeepLink {
    private func openAppStore() {
        let appStoreURL = URLTypes.appStore.originURL
        if UIApplication.shared.canOpenURL(appStoreURL) {
            UIApplication.shared.open(
                appStoreURL, options: [:],
                completionHandler: nil
            )
        }
    }
}

