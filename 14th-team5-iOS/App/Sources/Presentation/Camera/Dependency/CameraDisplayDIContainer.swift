//
//  CameraDisplayDIContainer.swift
//  App
//
//  Created by Kim dohyun on 12/11/23.
//

import Foundation

import Data
import Core


public final class CameraDisplayDIContainer: BaseDIContainer {
    public typealias ViewContrller = CameraDisplayViewController
    public typealias Repository = CameraDisplayImpl
    public typealias Reactor = CameraDisplayViewReactor
    
    
    public func makeViewController() -> ViewContrller {
        return CameraDisplayViewController(reacter: makeReactor())
    }
    
    public func makeRepository() -> Repository {
        return CameraDisplayViewRepository()
    }
    
    public func makeReactor() -> Reactor {
        return CameraDisplayViewReactor(cameraDisplayRepository: makeRepository())
    }
    
}
