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
    private let membersAPIWorker: MembersAPIWorker = MembersAPIWorker()
    private let accessToken: String = App.Repository.token.accessToken.value?.accessToken ?? ""
    public init() { }
    
}


extension MembersRepository: MembersRepositoryProtocol {
    
    public func fetchProfileMemberItems(memberId: String) -> Observable<MembersProfileResponse?> {
        return membersAPIWorker.fetchProfileMember(accessToken: accessToken, memberId: memberId)
            .map { $0?.toDomain() }
            .catchAndReturn(nil)
            .asObservable()
    }
    
    
    public func fetchProfileAlbumImageURL(parameter: CameraDisplayImageParameters) -> Observable<CameraDisplayImageResponse?> {
        return membersAPIWorker.createProfileImagePresingedURL(accessToken: accessToken, parameters: parameter)
            .compactMap { $0?.toDomain() }
            .asObservable()
    }
    
    
    public func uploadProfileImageToPresingedURL(to url: String, imageData: Data) -> Observable<Bool> {
        return membersAPIWorker.uploadToProfilePresingedURL(accessToken: accessToken, toURL: url, with: imageData)
            .asObservable()
    }
    
    public func updataProfileImageToS3(memberId: String, parameter: ProfileImageEditParameter) -> Observable<MembersProfileResponse?> {
        return membersAPIWorker.updateProfileAlbumImageToS3(accessToken: accessToken, memberId: memberId, parameter: parameter)
            .do {
                guard let userEntity = $0?.toProfileEntity() else { return }
                FamilyUserDefaults.saveMemberToUserDefaults(familyMember: userEntity)
            }
            .map { $0?.toDomain() }
            .catchAndReturn(nil)
            .asObservable()
    }
    
    public func deleteProfileImageToS3(memberId: String) -> Observable<MembersProfileResponse?> {
        return membersAPIWorker.deleteProfileImageToS3(accessToken: accessToken, memberId: memberId)
            .do {
                guard let userEntity = $0?.toProfileEntity() else { return }
                FamilyUserDefaults.saveMemberToUserDefaults(familyMember: userEntity)
            }
            .map { $0?.toDomain() }
            .catchAndReturn(nil)
            .asObservable()
    }
    
}
