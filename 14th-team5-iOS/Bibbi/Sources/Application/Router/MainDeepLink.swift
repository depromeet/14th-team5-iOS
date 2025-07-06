//
//  MainDeepLink.swift
//  Bibbi
//
//  Created by 마경미 on 24.02.25.
//

import Foundation

import Core
import Domain

// MARK: - Main 딥링크
final class MainDeepLink: DeepLinkProtocol {
    enum MainDeepLinkType {
        case openMain
        case openMissionAlert
    }
    
    var type: MainDeepLinkType?
    
    init(
        pathComponents: [String],
        queryParams: [URLQueryItem]?
    ) {
        if let isMission = queryParams?.first(where: {
            $0.name == "openMission"})?.value {
            
            if isMission == "true" {
                type = .openMissionAlert
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
        case .openMissionAlert: openMission()
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
    
    // 홈 화면 로직 수정 필요
    // 홈 화면에서 mission tab으로 넘어간뒤 mission alert 띄워야함.
    // 임시로 홈화면에서 Mission alert 띄우기로 개발되어있음
    private func openMission() {
        popToMain()
        let handler: BBAlertActionHandler = { [weak self] alert in
            self?.toCamera(.mission)
        }
        
        BBAlert.style(
            .mission,
            primaryAction: handler
        ).show()
    }
    
    func toCamera(_ type: UploadLocation) {
        let vc = CameraViewControllerWrapper(cameraType: type).viewController
        getNavigationController()?.pushViewController(vc, animated: true)
    }
}
