//
//  CameraViewUseCase.swift
//  Domain
//
//  Created by Kim dohyun on 12/26/23.
//

import Foundation

import RxSwift
import RxCocoa


public protocol CameraViewUseCaseProtocol {
    func executeToggleCameraPosition(_ isState: Bool) -> Observable<Bool>
    func executeToggleCameraFlash(_ isState: Bool) -> Observable<Bool>
    func executeProfileImageURL(parameter: CameraDisplayImageParameters, type: UploadLocation) -> Observable<CameraDisplayImageResponse?>
    func executeUploadToS3(toURL url: String, imageData: Data) -> Observable<Bool>
    func executeEditProfileImage(memberId: String, parameter: ProfileImageEditParameter) -> Observable<ProfileMemberResponse?>
    func executeRealEmojiImageURL(memberId: String, parameter: CameraRealEmojiParameters) -> Observable<CameraRealEmojiPreSignedResponse?>
    func executeRealEmojiUploadToS3(memberId: String, parameter: CameraCreateRealEmojiParameters) -> Observable<CameraCreateRealEmojiResponse?>
    func executeRealEmojiItems(memberId: String) -> Observable<CameraRealEmojiImageItemResponse?>
}



public final class CameraViewUseCase: CameraViewUseCaseProtocol {
    
    private let cameraViewRepository: CameraViewInterface
    
    public init(cameraViewRepository: CameraViewInterface) {
        self.cameraViewRepository = cameraViewRepository
    }
    
    public func executeToggleCameraPosition(_ isState: Bool) -> Observable<Bool> {
        return cameraViewRepository.toggleCameraPosition(isState)
    }
    
    public func executeToggleCameraFlash(_ isState: Bool) -> Observable<Bool> {
        return cameraViewRepository.toggleCameraFlash(isState)
    }
    
    public func executeProfileImageURL(parameter: CameraDisplayImageParameters, type: UploadLocation) -> Observable<CameraDisplayImageResponse?> {
        return cameraViewRepository.fetchProfileImageURL(parameters: parameter, type: type)
    }

    public func executeUploadToS3(toURL url: String, imageData: Data) -> Observable<Bool> {
        return cameraViewRepository.uploadImageToS3(toURL: url, imageData: imageData)
    }

    public func executeEditProfileImage(memberId: String, parameter: ProfileImageEditParameter) -> Observable<ProfileMemberResponse?> {
        return cameraViewRepository.editProfleImageToS3(memberId: memberId, parameter: parameter)
    }
    
    public func executeRealEmojiImageURL(memberId: String, parameter: CameraRealEmojiParameters) -> Observable<CameraRealEmojiPreSignedResponse?> {
        return cameraViewRepository.fetchRealEmojiImageURL(memberId: memberId, parameters: parameter)
    }
    
    public func executeRealEmojiUploadToS3(memberId: String, parameter: CameraCreateRealEmojiParameters) -> Observable<CameraCreateRealEmojiResponse?> {
        return cameraViewRepository.uploadRealEmojiImageToS3(memberId: memberId, parameters: parameter)
    }

    
    public func executeRealEmojiItems(memberId: String) -> Observable<CameraRealEmojiImageItemResponse?> {
        return cameraViewRepository.fetchRealEmojiItems(memberId: memberId)
    }
    
}
