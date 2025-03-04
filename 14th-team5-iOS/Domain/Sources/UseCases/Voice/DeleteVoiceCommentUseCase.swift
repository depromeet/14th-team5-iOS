//
//  DeleteVoiceCommentUseCase.swift
//  Domain
//
//  Created by 김도현 on 2/9/25.
//

import Foundation

import RxSwift

public protocol DeleteVoiceCommentUseCaseProtocol {
    func execute(postId: String, commentId: String) -> Observable<DeleteVoiceCommentEntity>
}

public final class DeleteVoiceCommentUseCase: DeleteVoiceCommentUseCaseProtocol {
    private let voiceCommentRepository: VoiceRepositoryProtocol
    
    
    public init(voiceCommentRepository: VoiceRepositoryProtocol) {
        self.voiceCommentRepository = voiceCommentRepository
    }
    
    public func execute(postId: String, commentId: String) -> Observable<DeleteVoiceCommentEntity> {
        return voiceCommentRepository.deleteVoiceComment(postId: postId, commentId: commentId)
    }
}
