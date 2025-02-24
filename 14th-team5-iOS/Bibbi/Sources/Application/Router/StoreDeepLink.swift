//
//  StoreDeepLink.swift
//  Bibbi
//
//  Created by 마경미 on 24.02.25.
//

import Foundation

import Core

// MARK: - Store 딥링크
final class StoreDeepLink: DeepLinkProtocol {
    enum StoreDeepLinkType {
        case openAppStore
    }
    
    let type: StoreDeepLinkType
    
    init(
        pathComponents: [String]
    ) {
        if pathComponents.first == "bibbi" {
            type = .openAppStore
        } else {
            BBToast.text("화면을 이동할 수 없어요").show()
            return
        }
    }
    
    func doDeepLink() {
        switch type {
        case .openAppStore: openAppStore()
        }
    }
}

extension StoreDeepLink {
    private func openAppStore() {
        
    }
}
