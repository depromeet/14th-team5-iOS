//
//  CameraDisplayDIContainer.swift
//  App
//
//  Created by Kim dohyun on 12/11/23.
//

import UIKit

import Core
import Data
import Domain


public final class CameraDisplayDIContainer: BaseDIContainer {
    public typealias ViewContrller = CameraDisplayViewController
    public typealias Repository = CameraRepositoryProtocol
    public typealias Reactor = CameraDisplayViewReactor
    
    fileprivate var displayData: Data
    fileprivate var missionTitle: String
    fileprivate var cameraDisplayType: PostType
    
    private var globalState: GlobalStateProviderProtocol {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return GlobalStateProvider()
        }
        return appDelegate.globalStateProvider
    }
  
    public init(displayData: Data, missionTitle: String = "", cameraDisplayType: PostType = .survival) {
        self.displayData = displayData
        self.missionTitle = missionTitle
        self.cameraDisplayType = cameraDisplayType
    }
    
    public func makeViewController() -> ViewContrller {
        return CameraDisplayViewController(reactor: makeReactor())
    }
    
    public func makeRepository() -> Repository {
        return CameraRepository()
    }
    
    public func makeReactor() -> Reactor {
        return CameraDisplayViewReactor(
            provider: globalState,
            createPresignedCameraUseCase: CreateCameraUseCase(cameraRepository: makeRepository()),
            uploadImageUseCase: FetchCameraUploadImageUseCase(cameraRepository: makeRepository()),
            fetchCameraImageUseCase: CreateCameraImageUseCase(cameraRepository: makeRepository()),
            displayData: displayData,
            missionTitle: missionTitle,
            cameraType: cameraDisplayType
        )
    }
}
