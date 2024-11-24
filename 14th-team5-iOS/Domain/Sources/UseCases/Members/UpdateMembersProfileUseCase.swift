//
//  UpdateMembersProfileUseCase.swift
//  Domain
//
//  Created by Kim dohyun on 6/15/24.
//

import Foundation

import Core
import RxSwift

public protocol UpdateMembersProfileUseCaseProtocol {
    func execute(memberId: String, body: CreateMemberPresignedReqeust, imageData: Data) -> Observable<MembersProfileEntity?>
}


public final class UpdateMembersProfileUseCase: UpdateMembersProfileUseCaseProtocol {
    
    private let membersRepository: any MembersRepositoryProtocol
    
    
    public init(membersRepository: any MembersRepositoryProtocol) {
        self.membersRepository = membersRepository
    }
    
    public func execute(memberId: String, body: CreateMemberPresignedReqeust, imageData: Data) -> Observable<MembersProfileEntity?> {
        return membersRepository.creteMemberImagePresignedURL(memberId: memberId, body: body)
            .flatMap { [unowned self] presignedURL -> Observable<MembersProfileEntity?> in
                guard let presignedURL = presignedURL?.imageURL else {
                    return .error(BBUploadError.invalidServerResponse)
                }
                
                let body = UpdateMemberImageRequest(profileImageUrl: presignedURL)
                return self.membersRepository.uploadMemberImageToS3Bucket(presignedURL, image: imageData)
                    .flatMap { [unowned self] isSucess -> Observable<MembersProfileEntity?> in
                        if isSucess {
                            return self.membersRepository.updateMemberProfileImageItem(memberId: memberId, body: body)
                                .flatMap { entity -> Observable<MembersProfileEntity?> in
                                    return .just(entity)
                                }
                        } else {
                            return .error(BBUploadError.uploadFailed)
                        }
                    }
            }
    }
}
