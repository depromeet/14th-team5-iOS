//
//  FetchCameraRealEmojiListUseCase.swift
//  Domain
//
//  Created by Kim dohyun on 6/14/24.
//

import Foundation

import RxSwift
import RxCocoa


public protocol FetchCameraRealEmojiListUseCaseProtocol {
    func execute() -> Single<[CameraRealEmojiImageItemEntity?]>
}


public final class FetchCameraRealEmojiListUseCase: FetchCameraRealEmojiListUseCaseProtocol {
    
    private let cameraRepository: any CameraRepositoryProtocol
    
    public init(cameraRepository: any CameraRepositoryProtocol) {
        self.cameraRepository = cameraRepository
    }
    
    public func execute() -> Single<[CameraRealEmojiImageItemEntity?]> {
        return cameraRepository.fetchRealEmojiItems()
    }
    
}
