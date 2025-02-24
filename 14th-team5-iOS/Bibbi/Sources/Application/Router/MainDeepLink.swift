//
//  MainDeepLink.swift
//  Bibbi
//
//  Created by 마경미 on 24.02.25.
//

import Foundation

import Core

// MARK: - Main 딥링크
final class MainDeepLink: DeepLinkProtocol {
    enum MainDeepLinkType {
        case openMain
        case openMission
    }
    
    let type: MainDeepLinkType
    
    init(
        pathComponents: [String],
        queryParams: [URLQueryItem]?
    ) {
        guard let isMission = queryParams?.first(where: {
            $0.name == "openMission"})?.value else {
            BBToast.text("화면을 이동할 수 없어요").show()
            return
        }
        
        if isMission == "true" {
            type = .openMission
        } else {
            type = .openMain
        }
    }
    
    func doDeepLink() {
        switch type {
        case .openMission: openMission()
        case .openMain: popToMain()
        }
    }
}

extension MainDeepLink {
    private func popToMain() {
        popToViewController(
            ofType: MainViewController.self,
            animated: true
        )
    }
    
    private func openMission() {
        
    }
}
