//
//  ProfileViewUseCase.swift
//  Data
//
//  Created by Kim dohyun on 12/25/23.
//

import Foundation

import RxCocoa
import RxSwift

public protocol ProfileViewUsecaseProtocol {
    func executeProfileMemberItems(memberId: String) -> Observable<ProfileMemberResponse>
    func executeProfileImageURLCreate(parameter: CameraDisplayImageParameters) -> Observable<CameraDisplayImageResponse?>
    func executeProfileImageToPresingedUpload(to url: String, data: Data) -> Observable<Bool>
    func executeReloadProfileImage(memberId: String, parameter: ProfileImageEditParameter) -> Observable<ProfileMemberResponse?>
    func executeDeleteProfileImage(memberId: String) -> Observable<ProfileMemberResponse?>
}


public final class ProfileViewUseCase: ProfileViewUsecaseProtocol {
    private let profileViewRepository: ProfileViewInterface
    
    public init(profileViewRepository: ProfileViewInterface) {
        self.profileViewRepository = profileViewRepository
    }
    
    public func executeProfileMemberItems(memberId: String) -> Observable<ProfileMemberResponse> {
        return profileViewRepository.fetchProfileMemberItems(memberId: memberId)
    }
    
    public func executeProfileImageURLCreate(parameter: CameraDisplayImageParameters) -> Observable<CameraDisplayImageResponse?> {
        return profileViewRepository.fetchProfileAlbumImageURL(parameter: parameter)
    }
    
    
    public func executeProfileImageToPresingedUpload(to url: String, data: Data) -> Observable<Bool> {
        return profileViewRepository.uploadProfileImageToPresingedURL(to: url, imageData: data)
    }
    
    public func executeReloadProfileImage(memberId: String, parameter: ProfileImageEditParameter) -> Observable<ProfileMemberResponse?> {
        return profileViewRepository.updataProfileImageToS3(memberId: memberId, parameter: parameter)
    }
    
    public func executeDeleteProfileImage(memberId: String) -> Observable<ProfileMemberResponse?> {
        return profileViewRepository.deleteProfileImageToS3(memberId: memberId)
    }
    
    
}
