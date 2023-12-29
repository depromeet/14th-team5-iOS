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
    func executeProfileMemberItems() -> Observable<ProfileMemberResponse>
    func executeProfilePostItems(query: ProfilePostQuery, parameters: ProfilePostDefaultValue) -> Observable<ProfilePostResponse>
    func executeProfileImageURLCreate(parameter: CameraDisplayImageParameters) -> Observable<CameraDisplayImageResponse?>
    func executeProfileImageToPresingedUpload(to url: String, data: Data) -> Observable<Bool>
    func executeReloadProfileImage(memberId: String, parameter: ProfileImageEditParameter) -> Observable<ProfileMemberResponse?>
    
}


public final class ProfileViewUseCase: ProfileViewUsecaseProtocol {
    private let profileViewRepository: ProfileViewInterface
    
    public init(profileViewRepository: ProfileViewInterface) {
        self.profileViewRepository = profileViewRepository
    }
    
    public func executeProfileMemberItems() -> Observable<ProfileMemberResponse> {
        return profileViewRepository.fetchProfileMemberItems()
    }
    
    public func executeProfilePostItems(query: ProfilePostQuery, parameters: ProfilePostDefaultValue) -> Observable<ProfilePostResponse> {
        print("query : \(query) and paramter: \(parameters)")
        return profileViewRepository.fetchProfilePostItems(query: query, parameter: parameters)
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
    
    
}
