//
//  CreateCameraUseCase.swift
//  Domain
//
//  Created by Kim dohyun on 6/13/24.
//

import Foundation

import RxSwift
import RxCocoa

public protocol CreateCameraUseCaseProtocol {
    func execute(parameter: CameraDisplayImageParameters) -> Single<CameraPreSignedEntity?>
}

public final class CreateCameraUseCase: CreateCameraUseCaseProtocol {
    
    private let cameraRepository: any CameraRepositoryProtocol
    
    public init(cameraRepository: any CameraRepositoryProtocol) {
        self.cameraRepository = cameraRepository
    }
    
    public func execute(parameter: CameraDisplayImageParameters) -> RxSwift.Single<CameraPreSignedEntity?> {
        return cameraRepository.addPresignedeImageURL(parameters: parameter)
    }
}


