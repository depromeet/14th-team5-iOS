//
//  VoiceRepository.swift
//  Data
//
//  Created by 김도현 on 1/15/25.
//

import Foundation
import Domain
import Core

import RxSwift

public final class VoiceRepository {
    
    private let disposeBag: DisposeBag = DisposeBag()
    private let voiceApiWorker: VoiceAPIWorker = VoiceAPIWorker()
    private let voiceStorage: BBDiskCacheStorage<String, Data> = BBDiskCacheStorage()
    public init() { }
}

extension VoiceRepository: VoiceRepositoryProtocol {
    
    public func createVoiceComment(postId: String, body: CreateVoiceRequest) -> Observable<PostCommentEntity> {
        let body = CreateVoiceCommentRequestDTO(fileUrl: body.fileUrl)
        return voiceApiWorker.createVoiceComment(postId: postId, body: body)
            .do(onNext: { response in
                if response.commentType == "VOICE" {
                    Task {
                        do {
                            guard let voiceURL = URL(string: response.comment),
                                  let bufferData = try? Data(contentsOf: voiceURL) else {
                                return
                            }
                            try await self.voiceStorage.setObject(bufferData, for: response.commentId)
                        } catch {
                            print("😳음성 녹음 URL을 저장하는데 실패 했습니다.")
                            print(error.localizedDescription)
                        }
                    }
                }
            })
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
    
    public func uploadMediaToS3(_ presignedURL: String, mp4File: Data) -> Observable<Bool> {
        return voiceApiWorker.uploadMediaFileToS3(presignedURL, mp4File: mp4File)
    }
    
    
}
