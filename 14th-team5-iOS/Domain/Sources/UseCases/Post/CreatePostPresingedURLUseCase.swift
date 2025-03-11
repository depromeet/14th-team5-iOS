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
    func execute(body: CreatePostPresignedURLRequest) -> Observable<CreatePostPresignedURLEntity?>
}


public final class CreatePresignedURLUseCase: CreatePresignedURLUseCaseProtocol {
    
    private let postListReposity: PostRepositoryProtocol
    
    public init(postListReposity: PostRepositoryProtocol) {
        self.postListReposity = postListReposity
    }
    
    
    public func execute(body: CreatePostPresignedURLRequest) -> Observable<CreatePostPresignedURLEntity?> {
        return postListReposity.createPostPresignedURLItem(body: body)
    }
}
