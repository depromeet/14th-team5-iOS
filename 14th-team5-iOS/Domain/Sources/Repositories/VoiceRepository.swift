//
//  VoiceRepository.swift
//  Domain
//
//  Created by 김도현 on 1/15/25.
//

import Foundation

import RxSwift

public protocol VoiceRepositoryProtocol {
    /// CREATE
    func createVoiceComment(postId: String, body: CreateVoiceRequest) -> Observable<VoiceCommentEntity>
    func createVoicePresignedURL(postId: String, body: CreateVoicePresignedURLRequest) -> Observable<VoicePresignedEntity>
    /// DELETE
    func deleteVoiceComment(postId: String, commentId: String) -> Observable<DeleteVoiceCommentEntity>
}
