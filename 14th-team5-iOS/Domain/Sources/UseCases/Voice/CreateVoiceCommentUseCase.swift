//
//  CreateVoiceCommentUseCase.swift
//  Domain
//
//  Created by 김도현 on 1/24/25.
//

import Foundation

import RxSwift

public protocol CreateVoiceCommentUseCaseProtocol {
    func execute(postId: String, body: CreateVoiceRequest) -> Observable<PostCommentEntity>
}


public final class CreateVoiceCommentUseCase: CreateVoiceCommentUseCaseProtocol {
    
    private let voiceCommentRepository: VoiceRepositoryProtocol
    
    public init(voiceCommentRepository: VoiceRepositoryProtocol) {
        self.voiceCommentRepository = voiceCommentRepository
    }
    
    public func execute(postId: String, body: CreateVoiceRequest) -> Observable<PostCommentEntity> {
        return voiceCommentRepository.createVoiceComment(postId: postId, body: body)
    }
}
