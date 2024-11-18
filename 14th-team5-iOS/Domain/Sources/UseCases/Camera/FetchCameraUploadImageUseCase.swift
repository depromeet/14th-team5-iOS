//
//  FetchCameraUploadImageUseCase.swift
//  Domain
//
//  Created by Kim dohyun on 6/15/24.
//

import Foundation

import RxSwift
import RxCocoa


public protocol FetchCameraUploadImageUseCaseProtocol {
    func execute(_ presignedURL: String, image: Data) -> Observable<Bool>
}


public final class FetchCameraUploadImageUseCase: FetchCameraUploadImageUseCaseProtocol {
    
    private let cameraRepository: any CameraRepositoryProtocol
    
    public init(cameraRepository: any CameraRepositoryProtocol) {
        self.cameraRepository = cameraRepository
    }
    
    public func execute(_ presignedURL: String, image: Data) -> Observable<Bool> {
        return cameraRepository.uploadImageToS3Bucket(presignedURL, image: image)
    }
}
