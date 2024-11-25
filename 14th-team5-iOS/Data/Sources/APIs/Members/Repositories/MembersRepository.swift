//
//  MembersRepository.swift
//  Data
//
//  Created by Kim dohyun on 6/5/24.
//

import Foundation

import Core
import Domain
import RxSwift
import RxCocoa


public final class MembersRepository {
        
    public var disposeBag: DisposeBag = DisposeBag()
    
    private let familyUserDefaults: FamilyInfoUserDefaults = FamilyInfoUserDefaults()
    private let membersAPIWorker: MembersAPIWorker = MembersAPIWorker()
    public init() { }
    
}


extension MembersRepository: MembersRepositoryProtocol {
        
    public func fetchProfileMemberItem(memberId: String) -> Observable<MembersProfileEntity?> {
        return membersAPIWorker.fetchMember(memberId: memberId)
            .map { $0?.toDomain() }
    }
    
    public func updateMemberNameItem(memberId: String, body: UpdateMemberNameRequest) -> Observable<UpdateMemberNameEntity?> {
        let body = UpdateMemberNameRequestDTO(name: body.name)
        
        return membersAPIWorker.updateMemberName(memberId: memberId, body: body)
            .map { $0?.toDomain() }
    }
    
    public func updateMemberProfileImageItem(memberId: String, body: UpdateMemberImageRequest) -> Observable<MembersProfileEntity?> {
        let body = UpdateMemberImageRequestDTO(profileImageUrl: body.profileImageUrl)
        
        return membersAPIWorker.updateMemberProfileImage(memberId: memberId, body: body)
            .do {
                guard let userEntity = $0?.toProfileEntity() else { return }
                self.familyUserDefaults.updateFamilyMember(userEntity)
            }
            .map { $0?.toDomain() }
    }
    
    public func createMemberPickItem(memberId: String) -> Observable<CreateMemberPickEntity?> {
        return membersAPIWorker.createMemberPick(memberId: memberId)
            .map { $0?.toDomain() }
    }
    
    public func creteMemberImagePresignedURL(body: CreateMemberPresignedReqeust) -> Observable<CreateMemberPresignedEntity?> {
        let body = CreateMemberPresignedURLRequestDTO(imageName: body.imageName)
        
        return membersAPIWorker.createMemberPresignedURL(body: body)
            .map { $0?.toDomain() }
    }
    
    public func deleteMemberProfileImageItem(memberId: String) -> Observable<MembersProfileEntity?> {
        return membersAPIWorker.deleteMemberProfileImage(memberId: memberId)
            .do {
                guard let userEntity = $0?.toProfileEntity() else { return }
                self.familyUserDefaults.updateFamilyMember(userEntity)
            }
            .map { $0?.toDomain() }
    }
    
    public func deleteMemberItem(memberId: String) -> Observable<DeleteMemberEntity?> {
        
        return membersAPIWorker.deleteMember(memberId: memberId)
            .map { $0?.toDomain() }
    }
    
    public func uploadMemberImageToS3Bucket(_ presignedURL: String, image: Data) -> Observable<Bool> {
        return membersAPIWorker.updateS3MemberImageUpload(presignedURL, image: image)
    }
}
