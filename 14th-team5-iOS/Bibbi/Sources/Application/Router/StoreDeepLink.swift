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
        if pathComponents.first == "bibbi" {
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
        let storeViewController = SKStoreProductViewController()
        let viewController = getNavigationController()
        
        storeViewController.delegate = viewController as? SKStoreProductViewControllerDelegate
        
        let parameters = [
            SKStoreProductParameterITunesItemIdentifier:
                Bundle.main.bundleIdentifier
        ]
        
        storeViewController.loadProduct(
            withParameters: parameters as [String : Any]
        ) { (loaded, error) in
            if loaded {
                viewController?.present(storeViewController, animated: true)
            } else {
                BBToast.text("알 수 없는 오류가 발생했습니다.").show()
            }
        }
    }
}

