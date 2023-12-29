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
    func executeProfileUploadToS3(toURL url: String, imageData: Data) -> Observable<Bool>
    func executeEditProfileImage(memberId: String, parameter: ProfileImageEditParameter) -> Observable<ProfileMemberResponse?>
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

    public func executeProfileUploadToS3(toURL url: String, imageData: Data) -> Observable<Bool> {
        return cameraViewRepository.uploadProfileImage(toURL: url, imageData: imageData)
    }

    public func executeEditProfileImage(memberId: String, parameter: ProfileImageEditParameter) -> Observable<ProfileMemberResponse?> {
        return cameraViewRepository.editProfleImageToS3(memberId: memberId, parameter: parameter)
    }
    

    
}
