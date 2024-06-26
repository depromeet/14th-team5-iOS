//
//  FetchCameraRealEmojiUpdateUseCase.swift
//  Domain
//
//  Created by Kim dohyun on 6/14/24.
//

import Foundation

import RxSwift
import RxCocoa

public protocol FetchCameraRealEmojiUpdateUseCaseProtocol {

    func execute(memberId: String, emojiId: String, parameter: CameraUpdateRealEmojiParameters) -> Single<CameraUpdateRealEmojiEntity?>
}


public final class FetchCameraRealEmojiUpdateUseCase: FetchCameraRealEmojiUpdateUseCaseProtocol {
    private let cameraRepostiroy: any CameraRepositoryProtocol
    
    public init(cameraRepostiroy: any CameraRepositoryProtocol) {
        self.cameraRepostiroy = cameraRepostiroy
    }
    
    public func execute(memberId: String, emojiId: String, parameter: CameraUpdateRealEmojiParameters) -> Single<CameraUpdateRealEmojiEntity?> {
        return cameraRepostiroy.updateRealEmojiImage(memberId: memberId, realEmojiId: emojiId, parameters: parameter)
    }
}
