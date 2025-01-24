//
//  VoiceAPIWorker.swift
//  Data
//
//  Created by 김도현 on 1/6/25.
//

import Foundation
import Core

import Alamofire
import RxSwift
import Domain



typealias VoiceAPIWorker = VoiceAPIs.Worker

extension VoiceAPIWorker {
    
    /// 음성 댓글을 추가하기 위한 API 요청 Method 입니다.
    /// HTTP Methd : POST
    /// - Parameters :
    ///     - PostId (게시물 ID)
    ///     - body :** CreateVoiceCommentRequestDTO**
    /// - Returns : CreateVoiceCommentRequestDTO
    public func createVoiceComment(postId: String, body: CreateVoiceCommentRequestDTO) -> Observable<VoiceCommentResponseDTO> {
        let spec = VoiceAPIs.createVoiceComment(postId: postId, body: body).spec
        
        return request(spec)
    }
    
    /// 음성 댓글을 삭제하기 위한 API 요청 Method 입니다.
    /// HTTP Method : Delete
    /// - Parameters :
    ///     - PostId : (게시물 ID)
    ///     - commentId: (음성 댓글 ID)
    /// - Returns : **DeleteVoiceCommentResponseDTO**
    public func deleteVoiceComment(postId: String, commentId: String) -> Observable<DeleteVoiceCommentResponseDTO> {
        let spec = VoiceAPIs.deleteVoiceComment(postId: postId, commentId: commentId).spec
        
        return request(spec)
    }
    
    /// 음성 댓글을 업로드 하기 위한 Presigned-URL API 요청 Method 입니다.
    /// HTTP Method : POST
    /// - Parameters :
    ///     - postId : (게시물 ID)
    ///     - body : **CreateVoicePresignedURLRequestDTO**
    /// - Returns :**VoicePresignedResponseDTO**
    public func createVoicePresignedURL(postId: String, body: CreateVoicePresignedURLRequestDTO) -> Observable<VoicePresignedResponseDTO> {
        let spec = VoiceAPIs.createVoiceCommentPresignedURL(postId: postId, body: body).spec
        
        return request(spec)
    }
    
    
}
