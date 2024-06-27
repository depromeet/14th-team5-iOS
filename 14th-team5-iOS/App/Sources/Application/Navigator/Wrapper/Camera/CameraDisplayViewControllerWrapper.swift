//
//  CameraDisplayViewControllerWrapper.swift
//  App
//
//  Created by Kim dohyun on 6/21/24.
//

import Core
import Domain

import Foundation


final class CameraDisplayViewControllerWrapper: BaseWrapper {
    
    typealias R = CameraDisplayViewReactor
    typealias V = CameraDisplayViewController
    
    private let displayData: Data
    private let missionTitle: String
    private let cameraDisplayType: PostType
    
    public init(
        displayData: Data,
        missionTitle: String = "",
        cameraDisplayType: PostType = .survival
    ) {
        self.displayData = displayData
        self.missionTitle = missionTitle
        self.cameraDisplayType = cameraDisplayType
    }
    
    var reactor: CameraDisplayViewReactor {
        return makeReactor()
    }
    
    var viewController: CameraDisplayViewController {
        return makeViewController()
    }
    
    
    func makeViewController() -> CameraDisplayViewController {
        return CameraDisplayViewController(reactor: reactor)
    }
    
    func makeReactor() -> CameraDisplayViewReactor {
        return CameraDisplayViewReactor(
            displayData: displayData,
            missionTitle: missionTitle,
            cameraType: cameraDisplayType
        )
    }
}
