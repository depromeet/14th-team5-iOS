//
//  VoiceRepository.swift
//  Data
//
//  Created by 김도현 on 1/15/25.
//

import Foundation
import Domain

import RxSwift

public final class VoiceRepository {
    
    private let disposeBag: DisposeBag = DisposeBag()
    private let voiceApiWorker: VoiceAPIWorker = VoiceAPIWorker()
    public init() { }
}

extension VoiceRepository: VoiceRepositoryProtocol {
    
    public func createVoiceComment(postId: String, body: CreateVoiceRequest) -> Observable<VoiceCommentEntity> {
        let body = CreateVoiceCommentRequestDTO(fileUrl: body.fileUrl)
        return voiceApiWorker.createVoiceComment(postId: postId, body: body)
            .map { $0.toDomain() }
        
    }
    
    public func createVoicePresignedURL(postId: String, body: CreateVoicePresignedURLRequest) -> Observable<VoicePresignedEntity> {
        let body = CreateVoicePresignedURLRequestDTO(imageName: body.imageName)
        return voiceApiWorker.createVoicePresignedURL(postId: postId, body: body)
            .map { $0.toDomain() }
    }
    
    public func deleteVoiceComment(postId: String, commentId: String) -> Observable<DeleteVoiceCommentEntity> {
        return voiceApiWorker.deleteVoiceComment(postId: postId, commentId: commentId)
            .map { $0.toDomain() }
    }
    
    
}
