//
//  ProfileViewRepository.swift
//  Data
//
//  Created by Kim dohyun on 12/25/23.
//

import Foundation

import Core
import Domain
import RxSwift
import RxCocoa





public final class ProfileViewRepository {
        
    public var disposeBag: DisposeBag = DisposeBag()
    private let profileAPIWorker: ProfileAPIWorker = ProfileAPIWorker()
    private let accessToken: String = App.Repository.token.accessToken.value?.accessToken ?? ""
    public init() { }
    
}


extension ProfileViewRepository: ProfileViewInterface {
    
    public func fetchProfileMemberItems(memberId: String) -> Observable<ProfileMemberResponse> {
        return profileAPIWorker.fetchProfileMember(accessToken: accessToken, memberId: memberId)
            .compactMap { $0?.toDomain() }
            .asObservable()
    }
    
    public func fetchProfilePostItems(query: ProfilePostQuery, parameter: ProfilePostDefaultValue) -> Observable<ProfilePostResponse> {
        
        
        let parameters: ProfilePostParameter = ProfilePostParameter(
            page: query.page,
            size: query.size,
            date: parameter.date,
            type: parameter.type,
            memberId: parameter.memberId,
            sort: parameter.sort
        )
        
        
        return profileAPIWorker.fetchProfilePost(accessToken: accessToken, parameter: parameters)
            .compactMap { $0?.toDomain() }
            .asObservable()
    }
    
    
    public func fetchProfileAlbumImageURL(parameter: CameraDisplayImageParameters) -> Observable<CameraDisplayImageResponse?> {
        return profileAPIWorker.createProfileImagePresingedURL(accessToken: accessToken, parameters: parameter)
            .compactMap { $0?.toDomain() }
            .asObservable()
    }
    
    
    public func uploadProfileImageToPresingedURL(to url: String, imageData: Data) -> Observable<Bool> {
        return profileAPIWorker.uploadToProfilePresingedURL(accessToken: accessToken, toURL: url, with: imageData)
            .asObservable()
    }
    
    public func updataProfileImageToS3(memberId: String, parameter: ProfileImageEditParameter) -> Observable<ProfileMemberResponse?> {
        return profileAPIWorker.updateProfileAlbumImageToS3(accessToken: accessToken, memberId: memberId, parameter: parameter)
            .do {
                guard let userEntity = $0?.toProfileDomain() else { return }
                FamilyUserDefaults.saveMemberToUserDefaults(familyMember: userEntity)
            }
            .compactMap { $0?.toDomain() }
            .asObservable()
    }
    
    public func deleteProfileImageToS3(memberId: String) -> Observable<ProfileMemberResponse?> {
        return profileAPIWorker.deleteProfileImageToS3(accessToken: accessToken, memberId: memberId)
            .do {
                guard let userEntity = $0?.toProfileDomain() else { return }
                FamilyUserDefaults.saveMemberToUserDefaults(familyMember: userEntity)
            }
            .compactMap { $0?.toDomain() }
            .asObservable()
    }
    
}
