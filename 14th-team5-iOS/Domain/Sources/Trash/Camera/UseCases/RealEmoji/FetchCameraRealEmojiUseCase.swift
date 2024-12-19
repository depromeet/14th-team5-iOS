//
//  FetchCameraRealEmojiUseCase.swift
//  Domain
//
//  Created by Kim dohyun on 6/14/24.
//

import Foundation
import Core

import RxSwift
import RxCocoa


public protocol FetchCameraRealEmojiUseCaseProtocol {
    func execute(memberId: String, body: CreatePresignedURLRequest, imageData: Data) -> Observable<CameraRealEmojiPreSignedEntity>
}

public final class FetchCameraRealEmojiUseCase: FetchCameraRealEmojiUseCaseProtocol {
    
    private let cameraRepository: any CameraRepositoryProtocol
    
    public init(cameraRepository: any CameraRepositoryProtocol) {
        self.cameraRepository = cameraRepository
    }
    
    public func execute(memberId: String, body: CreatePresignedURLRequest, imageData: Data) -> Observable<CameraRealEmojiPreSignedEntity> {
        
        return cameraRepository.createEmojiImagePresignedURL(memberID: memberId, body: body)
            .flatMap { [unowned self] presignedURL -> Observable<CameraRealEmojiPreSignedEntity> in
                
                return self.cameraRepository.uploadEmojiImageToS3Bucket(presignedURL.imageURL, image: imageData)
                    .flatMap { isSuccess -> Observable<CameraRealEmojiPreSignedEntity> in
                        if isSuccess {
                            return .just(presignedURL)
                        }
                        return .error(BBUploadError.uploadFailed)
                    }
        }
    }
}
