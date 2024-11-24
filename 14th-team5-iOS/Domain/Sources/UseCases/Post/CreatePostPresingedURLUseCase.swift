//
//  CreatePostPresingedURLUseCase.swift
//  Domain
//
//  Created by 김도현 on 11/22/24.
//

import Foundation

import Core
import RxSwift

public protocol CreatePresignedURLUseCaseProtocol {
    func execute(body: CreatePostPresignedURLRequest, imageData: Data) -> Observable<CreatePostPresignedURLEntity?>
}


public final class CreatePresignedURLUseCase: CreatePresignedURLUseCaseProtocol {
    
    private let postListReposity: PostListRepositoryProtocol
    
    public init(postListReposity: PostListRepositoryProtocol) {
        self.postListReposity = postListReposity
    }
    
    
    public func execute(body: CreatePostPresignedURLRequest, imageData: Data) -> Observable<CreatePostPresignedURLEntity?> {
        return postListReposity.createPostPresignedURLItem(body: body)
            .flatMap { [unowned self] presignedURL -> Observable<CreatePostPresignedURLEntity?> in
                guard let remoteURL = presignedURL?.imageURL else {
                    return .error(BBUploadError.invalidServerResponse)
                }
                return self.postListReposity.uploadPostImageToS3Bucket(remoteURL, image: imageData)
                    .flatMap { isSuccess -> Observable<CreatePostPresignedURLEntity?> in
                        if isSuccess {
                            return .just(presignedURL)
                        } else {
                            return .error(BBUploadError.uploadFailed)
                        }
                    }
            }
    }
}
