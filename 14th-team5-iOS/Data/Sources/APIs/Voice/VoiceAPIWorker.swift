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
    public func createVoiceComment(postId: String, body: CreateVoiceCommentRequestDTO) -> Observable<PostCommentResponseDTO> {
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
    
    
    /// 음성 댓글 미디어 파일을 S3 Bucket에 업로드 하기 위한 Method 입낟.
    /// HTTP Method : PUT
    /// - Parameters
    ///     - presignedURL : 서버에서 발급 받은 Presigned-URL
    ///     - mp4File : MP4 File Data
    /// - Returns  : 업로드 성공 여부 확인(Bool) Type
    public func uploadMediaFileToS3(_ presignedURL: String, mp4File: Data) -> Observable<Bool> {
        return upload(presignedURL, with: mp4File)
    }
    
    
}
