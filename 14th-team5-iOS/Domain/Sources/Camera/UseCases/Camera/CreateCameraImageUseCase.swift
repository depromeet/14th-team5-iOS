//
//  CreateCameraImageUseCase.swift
//  Domain
//
//  Created by Kim dohyun on 6/14/24.
//

import Foundation

import RxSwift
import RxCocoa


public protocol CreateCameraImageUseCaseProtocol {
    func execute(parameter: CameraDisplayPostParameters, query: CameraMissionFeedQuery) -> Single<CameraPostEntity?>
}

public final class CreateCameraImageUseCase: CreateCameraImageUseCaseProtocol {
    
    private let cameraRepository: any CameraRepositoryProtocol
    
    public init(cameraRepository: any CameraRepositoryProtocol) {
        self.cameraRepository = cameraRepository
    }
    
    public func execute(parameter: CameraDisplayPostParameters, query: CameraMissionFeedQuery) -> Single<CameraPostEntity?> {
        return cameraRepository.combineWithTextImage(parameters: parameter, query: query)
    }
}
