//
//  CreateMembersPresignedURLUseCase.swift
//  Domain
//
//  Created by 김도현 on 11/24/24.
//

import Foundation

import Core
import RxSwift


public protocol CreateMembersPresignedURLUseCaseProtocol {
    func execute(body: CreateMemberPresignedReqeust, imageData: Data) -> Observable<CreateMemberPresignedEntity?>
}


public final class CreateMembersPresignedURLUseCase: CreateMembersPresignedURLUseCaseProtocol {
    
    private let membersRepository: any MembersRepositoryProtocol
    
    public init(membersRepository: any MembersRepositoryProtocol) {
        self.membersRepository = membersRepository
    }

    public func execute(body: CreateMemberPresignedReqeust, imageData: Data) -> Observable<CreateMemberPresignedEntity?> {
        return membersRepository.creteMemberImagePresignedURL(body: body)
            .flatMap { [unowned self] presignedURL -> Observable<CreateMemberPresignedEntity?> in
                guard let remoteURL = presignedURL?.imageURL else {
                    return .error(BBUploadError.invalidServerResponse)
                }
                
                return self.membersRepository.uploadMemberImageToS3Bucket(remoteURL, image: imageData)
                    .flatMap { isSucess -> Observable<CreateMemberPresignedEntity?> in
                        if isSucess {
                            return .just(presignedURL)
                        } else {
                            return .error(BBUploadError.uploadFailed)
                        }
                    }
            }
    }
    
    
    
    
}
