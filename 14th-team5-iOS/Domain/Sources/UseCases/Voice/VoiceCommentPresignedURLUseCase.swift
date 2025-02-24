//
//  VoiceCommentPresignedURLUseCase.swift
//  Domain
//
//  Created by 김도현 on 1/27/25.
//

import Foundation

import Core
import RxSwift



public protocol VoiceCommentPresignedURLUseCaseProtocol {
    func execute(postId: String, _ body: CreateVoicePresignedURLRequest, mp4File: Data) -> Observable<VoicePresignedEntity>
}


public final class VoiceCommentPresignedURLUseCase: VoiceCommentPresignedURLUseCaseProtocol {
        
    private let voiceCommentRepository: VoiceRepositoryProtocol
    
    public init(voiceCommentRepository: VoiceRepositoryProtocol) {
        self.voiceCommentRepository = voiceCommentRepository
    }
    
    public func execute(postId: String, _ body: CreateVoicePresignedURLRequest, mp4File: Data) -> Observable<VoicePresignedEntity> {
        return voiceCommentRepository.createVoicePresignedURL(postId: postId, body: body)
            .flatMap { presignedURL -> Observable<VoicePresignedEntity> in
                if presignedURL.audioURL.isEmpty {
                    return .error(BBUploadError.invalidServerResponse)
                }
                return self.voiceCommentRepository.uploadMediaToS3(presignedURL.audioURL, mp4File: mp4File).flatMap { isSuccess -> Observable<VoicePresignedEntity> in
                    if isSuccess {
                        return .just(presignedURL)
                    }
                    return .error(BBUploadError.uploadFailed)
                }
            }
    }
}
