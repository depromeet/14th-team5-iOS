//
//  CameraDIContainer.swift
//  App
//
//  Created by Kim dohyun on 12/6/23.
//

import Foundation

import Core
import Data
import Domain

public final class CameraDIContainer: BaseDIContainer {
        
    public typealias ViewContrller = CameraViewController
    public typealias Repository = CameraViewInterface
    public typealias Reactor = CameraViewReactor
    public typealias UseCase = CameraViewUseCaseProtocol
    
    private let cameraType: UploadLocation
    private let memberId: String
    
    public init(cameraType: UploadLocation, memberId: String = "") {
        self.cameraType = cameraType
        self.memberId = memberId
    }
    
    public func makeViewController() -> CameraViewController {
        return CameraViewController(reactor: makeReactor())
    }
    
    public func makeUseCase() -> UseCase {
        return CameraViewUseCase(cameraViewRepository: makeRepository())
    }
    
    
    public func makeRepository() -> Repository {
        return CameraViewRepository()
    }
    
    public func makeReactor() -> Reactor {
        return CameraViewReactor(cameraUseCase: makeUseCase(), cameraType: cameraType, memberId: memberId)
    }
    

}
