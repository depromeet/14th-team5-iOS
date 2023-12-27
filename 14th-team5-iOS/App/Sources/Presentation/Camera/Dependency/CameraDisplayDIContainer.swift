//
//  CameraDisplayDIContainer.swift
//  App
//
//  Created by Kim dohyun on 12/11/23.
//

import Foundation

import Core
import Data
import Domain


public final class CameraDisplayDIContainer: BaseDIContainer {
    public typealias ViewContrller = CameraDisplayViewController
    public typealias Repository = CameraDisplayViewInterface
    public typealias Reactor = CameraDisplayViewReactor
    public typealias UseCase = CameraDisplayViewUseCaseProtocol
    
    fileprivate var displayData: Data
    
    public init(displayData: Data) {
        self.displayData = displayData
    }
    
    public func makeViewController() -> ViewContrller {
        return CameraDisplayViewController(reacter: makeReactor())
    }
    
    public func makeRepository() -> Repository {
        return CameraDisplayViewRepository()
    }
    
    public func makeUseCase() -> UseCase {
        return CameraDisplayViewUseCase(cameraDisplayViewRepository: makeRepository())
    }
    
    public func makeReactor() -> Reactor {
        return CameraDisplayViewReactor(cameraDisplayUseCase: makeUseCase(), displayData: displayData)
    }
    
}
