//
//  CameraDisplayViewControllerWrapper.swift
//  App
//
//  Created by Kim dohyun on 6/21/24.
//

import Core
import Domain
import Foundation
import MacrosInterface

@Wrapper<CameraDisplayViewReactor, CameraDisplayViewController>
final class CameraDisplayViewControllerWrapper {
    
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
    
    func makeReactor() -> CameraDisplayViewReactor {
        return CameraDisplayViewReactor(
            displayData: displayData,
            missionTitle: missionTitle,
            cameraType: cameraDisplayType
        )
    }
}
