//
//  MembersUseCase.swift
//  Domain
//
//  Created by Kim dohyun on 6/5/24.
//

import Foundation

import RxCocoa
import RxSwift


public protocol MembersUseCaseProtocol {
    func executeProfileMemberItems(memberId: String) -> Observable<MembersProfileResponse?>
    func executeProfileImageURLCreate(parameter: CameraDisplayImageParameters) -> Observable<CameraDisplayImageResponse?>
    func executeProfileImageToPresingedUpload(to url: String, data: Data) -> Observable<Bool>
    func executeReloadProfileImage(memberId: String, parameter: ProfileImageEditParameter) -> Observable<MembersProfileResponse?>
    func executeDeleteProfileImage(memberId: String) -> Observable<MembersProfileResponse?>
}

public final class MembersUseCase: MembersUseCaseProtocol {
    private let membersRepository: MembersRepositoryProtocol
    
    public init(membersRepository: MembersRepositoryProtocol) {
        self.membersRepository = membersRepository
    }
    
    public func executeProfileMemberItems(memberId: String) -> Observable<MembersProfileResponse?> {
        return membersRepository.fetchProfileMemberItems(memberId: memberId)
            .asObservable()
    }
    
    public func executeProfileImageURLCreate(parameter: CameraDisplayImageParameters) -> Observable<CameraDisplayImageResponse?> {
        return membersRepository.fetchProfileAlbumImageURL(parameter: parameter)
    }
    
    
    public func executeProfileImageToPresingedUpload(to url: String, data: Data) -> Observable<Bool> {
        return membersRepository.uploadProfileImageToPresingedURL(to: url, imageData: data)
    }
    
    public func executeReloadProfileImage(memberId: String, parameter: ProfileImageEditParameter) -> Observable<MembersProfileResponse?> {
        return membersRepository.updataProfileImageToS3(memberId: memberId, parameter: parameter)
    }
    
    public func executeDeleteProfileImage(memberId: String) -> Observable<MembersProfileResponse?> {
        return membersRepository.deleteProfileImageToS3(memberId: memberId)
    }
    
}
