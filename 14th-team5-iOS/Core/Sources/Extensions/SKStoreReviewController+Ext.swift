//
//  SKStoreReviewController+Ext.swift
//  Core
//
//  Created by 김도현 on 2/20/25.
//

import Foundation

import StoreKit


public extension SKStoreReviewController {
    static func requestReviewInCurrentScene() {
        if let scene = UIApplication.shared.connectedScenes.first(where: {
            $0.activationState == .foregroundActive
        }) as? UIWindowScene {
            self.requestReview(in: scene)
        }
    }
}
