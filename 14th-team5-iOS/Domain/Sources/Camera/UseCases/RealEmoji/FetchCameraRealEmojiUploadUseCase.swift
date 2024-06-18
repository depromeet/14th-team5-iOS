//
//  FetchCameraRealEmojiUploadUseCase.swift
//  Domain
//
//  Created by Kim dohyun on 6/14/24.
//

import Foundation

import RxSwift
import RxCocoa

public protocol FetchCameraRealEmojiUploadUseCaseProtocol {
    func execute(memberId: String, parameter: CameraCreateRealEmojiParameters) -> Single<CameraCreateRealEmojiEntity?>
}

public final class FetchCameraRealEmojiUploadUseCase: FetchCameraRealEmojiUploadUseCaseProtocol {
    
    private let cameraRepository: any CameraRepositoryProtocol
    
    public init(cameraRepository: any CameraRepositoryProtocol) {
        self.cameraRepository = cameraRepository
    }
    
    public func execute(memberId: String, parameter: CameraCreateRealEmojiParameters) -> Single<CameraCreateRealEmojiEntity?> {
        return cameraRepository.uploadRealEmojiImageToS3(memberId: memberId, parameters: parameter)
    }
}

