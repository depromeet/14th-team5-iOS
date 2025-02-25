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
    
    var type: MainDeepLinkType?
    
    init(
        pathComponents: [String],
        queryParams: [URLQueryItem]?
    ) {
        if let isMission = queryParams?.first(where: {
            $0.name == "openMission"})?.value {
            
            if isMission == "true" {
                type = .openMission
            } else {
                type = .openMain
            }
        }
    }
    
    func doDeepLink() throws {
        guard let type else {
            throw DeepLinkError.invalidLink
        }
        
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
        popToMain()
    }
}
