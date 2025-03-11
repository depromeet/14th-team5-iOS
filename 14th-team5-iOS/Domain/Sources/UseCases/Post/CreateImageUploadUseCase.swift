//
//  CreateImageUploadUseCase.swift
//  Domain
//
//  Created by 김도현 on 2/18/25.
//

import Foundation

import RxSwift

public protocol CreateImageUploadUseCaseProtocol {
    
    func execute(_ remoteURL: String, with binaryData: Data) -> Observable<Bool>
}


public final class CreateImageUploadUseCase: CreateImageUploadUseCaseProtocol {
    
    
    private let postListRepository: PostRepositoryProtocol
    
    
    public init(postListRepository: PostRepositoryProtocol) {
        self.postListRepository = postListRepository
    }
    
    
    public func execute(_ remoteURL: String, with binaryData: Data) -> Observable<Bool> {
        return postListRepository.uploadPostImageToS3Bucket(remoteURL, image: binaryData)
    }
}
