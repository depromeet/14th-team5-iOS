//
//  FetchCameraRealEmojiUseCase.swift
//  Domain
//
//  Created by Kim dohyun on 6/14/24.
//

import Foundation

import RxSwift
import RxCocoa


public protocol FetchCameraRealEmojiUseCaseProtocol {
    func execute(memberId: String, body: CreatePresignedURLRequest) -> Observable<CameraRealEmojiPreSignedEntity?>
}

public final class FetchCameraRealEmojiUseCase: FetchCameraRealEmojiUseCaseProtocol {
    
    private let cameraRepository: any CameraRepositoryProtocol
    
    public init(cameraRepository: any CameraRepositoryProtocol) {
        self.cameraRepository = cameraRepository
    }
    
    public func execute(memberId: String, body: CreatePresignedURLRequest) -> Observable<CameraRealEmojiPreSignedEntity?> {
        return cameraRepository.createEmojiImagePresignedURL(memberID: memberId, body: body)
    }
}
