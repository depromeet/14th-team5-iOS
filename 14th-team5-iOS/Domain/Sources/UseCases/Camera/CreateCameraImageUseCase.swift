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
    func execute(query: CreateFeedQuery, body: CreateFeedRequest) -> Observable<CameraPostEntity?>
}

public final class CreateCameraImageUseCase: CreateCameraImageUseCaseProtocol {
        
    private let cameraRepository: any CameraRepositoryProtocol
    
    public init(cameraRepository: any CameraRepositoryProtocol) {
        self.cameraRepository = cameraRepository
    }
    
    public func execute(query: CreateFeedQuery, body: CreateFeedRequest) -> Observable<CameraPostEntity?> {
        return cameraRepository.createFeedImage(query: query, body: body)
    }
}
