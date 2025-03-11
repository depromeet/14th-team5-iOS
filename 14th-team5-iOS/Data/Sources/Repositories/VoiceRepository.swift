//
//  VoiceRepository.swift
//  Data
//
//  Created by 김도현 on 1/15/25.
//

import Foundation
import Domain
import Core
import Util

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
            .flatMap { response -> Observable<PostCommentEntity> in
                if response.commentType == "VOICE" {
                    return Observable.create { observer in
                        Task {
                            do {
                                
                                guard let voiceURL = response.voiceURL,
                                      let cacheURL = URL(string: voiceURL),
                                      let bufferData = try? Data(contentsOf: cacheURL) else {
                                    return
                                }
                                try await self.voiceStorage.setObject(bufferData, for: response.commentId)
                                observer.onNext(response.toDomain())
                                observer.onCompleted()
                            } catch {
                                BBLogManager.sendError(error: error)
                                observer.onError(error)
                            }
                        }
                        return Disposables.create()
                    }
                }
                return .just(response.toDomain())
            }
    }

    
    public func createVoicePresignedURL(postId: String, body: CreateVoicePresignedURLRequest) -> Observable<VoicePresignedEntity> {
        let body = CreateVoicePresignedURLRequestDTO(imageName: body.imageName)
        return voiceApiWorker.createVoicePresignedURL(postId: postId, body: body)
            .map { $0.toDomain() }
    }
    
    public func deleteVoiceComment(postId: String, commentId: String) -> Observable<DeleteVoiceCommentEntity> {
        return voiceApiWorker.deleteVoiceComment(postId: postId, commentId: commentId)
            .do(onNext: { response in
                if response.success {
                    do {
                        try self.voiceStorage.removeObject(forKey: commentId)
                    } catch {
                        BBLogManager.sendError(error: error)
                    }
                }
            })
            .map { $0.toDomain() }
    }
    
    public func uploadMediaToS3(_ presignedURL: String, mp4File: Data) -> Observable<Bool> {
        return voiceApiWorker.uploadMediaFileToS3(presignedURL, mp4File: mp4File)
    }
    
    
}
