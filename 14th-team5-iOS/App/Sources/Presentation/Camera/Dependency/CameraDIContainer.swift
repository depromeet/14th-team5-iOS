//
//  CameraDIContainer.swift
//  App
//
//  Created by Kim dohyun on 12/6/23.
//

import Foundation

import Data
import Core

public final class CameraDIContainer: BaseDIContainer {
        
    public typealias ViewContrller = CameraViewController
    public typealias Repository = CameraViewImpl
    public typealias Reactor = CameraViewReactor
    
    public func makeViewController() -> CameraViewController {
        return CameraViewController(reacter: makeReactor())
    }
    
    public func makeRepository() -> Repository {
        return CameraViewRepository()
    }
    
    public func makeReactor() -> Reactor {
        return CameraViewReactor(cameraRepository: CameraViewRepository())
    }
    

}
