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
        
    public func fetchProfileMemberItems(memberId: String) -> Single<MembersProfileEntity?> {
        return membersAPIWorker.fetchProfileMember(memberId: memberId)
            .map { $0?.toDomain() }
            .catchAndReturn(nil)
    }
    
    public func updataProfileImageToS3(memberId: String, parameter: ProfileImageEditParameter) -> Single<MembersProfileEntity?> {
        return membersAPIWorker.updateProfileAlbumImageToS3(memberId: memberId, parameter: parameter)
            .do {
                guard let userEntity = $0?.toProfileEntity() else { return }
                self.familyUserDefaults.updateFamilyMember(userEntity)
            }
            .map { $0?.toDomain() }
            .catchAndReturn(nil)
    }
    
    public func deleteProfileImageToS3(memberId: String) -> Single<MembersProfileEntity?> {
        return membersAPIWorker.deleteProfileImageToS3(memberId: memberId)
            .do {
                guard let userEntity = $0?.toProfileEntity() else { return }
                self.familyUserDefaults.updateFamilyMember(userEntity)
            }
            .map { $0?.toDomain() }
            .catchAndReturn(nil)
    }
}
