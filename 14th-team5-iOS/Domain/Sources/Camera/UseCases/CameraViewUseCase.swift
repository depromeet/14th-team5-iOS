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
    func executeProfileImageURL(parameter: CameraDisplayImageParameters) -> Observable<CameraDisplayImageResponse?>
    func executeUploadToS3(toURL url: String, imageData: Data) -> Observable<Bool>
    func executeEditProfileImage(memberId: String, parameter: ProfileImageEditParameter) -> Observable<MembersProfileResponse?>
    func executeRealEmojiImageURL(memberId: String, parameter: CameraRealEmojiParameters) -> Observable<CameraRealEmojiPreSignedResponse?>
    func executeRealEmojiUploadToS3(memberId: String, parameter: CameraCreateRealEmojiParameters) -> Observable<CameraCreateRealEmojiResponse?>
    func executeRealEmojiItems(memberId: String) -> Observable<[CameraRealEmojiImageItemResponse?]>
    func executeUpdateRealEmojiImage(memberId: String, realEmojiId: String ,parameter: CameraUpdateRealEmojiParameters) -> Observable<CameraUpdateRealEmojiResponse?>
    func executeTodayMission() -> Observable<CameraTodayMissionResponse?>
}



public final class CameraViewUseCase: CameraViewUseCaseProtocol {
    
    private let cameraRepository: CameraRepositoryProtocol
    
    public init(cameraRepository: CameraRepositoryProtocol) {
        self.cameraRepository = cameraRepository
    }
    
    public func executeToggleCameraPosition(_ isState: Bool) -> Observable<Bool> {
        return cameraRepository.toggleCameraPosition(isState)
    }
    
    public func executeToggleCameraFlash(_ isState: Bool) -> Observable<Bool> {
        return cameraRepository.toggleCameraFlash(isState)
    }
    
    public func executeProfileImageURL(parameter: CameraDisplayImageParameters) -> Observable<CameraDisplayImageResponse?> {
        return cameraRepository.fetchPresignedeImageURL(parameters: parameter)
    }

    public func executeUploadToS3(toURL url: String, imageData: Data) -> Observable<Bool> {
        return cameraRepository.uploadImageToS3(toURL: url, imageData: imageData)
    }

    public func executeEditProfileImage(memberId: String, parameter: ProfileImageEditParameter) -> Observable<MembersProfileResponse?> {
        return cameraRepository.editProfleImageToS3(memberId: memberId, parameter: parameter)
    }
    
    public func executeRealEmojiImageURL(memberId: String, parameter: CameraRealEmojiParameters) -> Observable<CameraRealEmojiPreSignedResponse?> {
        return cameraRepository.fetchRealEmojiImageURL(memberId: memberId, parameters: parameter)
    }
    
    public func executeRealEmojiUploadToS3(memberId: String, parameter: CameraCreateRealEmojiParameters) -> Observable<CameraCreateRealEmojiResponse?> {
        return cameraRepository.uploadRealEmojiImageToS3(memberId: memberId, parameters: parameter)
    }

    
    public func executeRealEmojiItems(memberId: String) -> Observable<[CameraRealEmojiImageItemResponse?]> {
        return cameraRepository.fetchRealEmojiItems(memberId: memberId)
    }
    
    public func executeUpdateRealEmojiImage(memberId: String, realEmojiId: String, parameter: CameraUpdateRealEmojiParameters) -> Observable<CameraUpdateRealEmojiResponse?> {
        return cameraRepository.updateRealEmojiImage(memberId: memberId, realEmojiId: realEmojiId, parameters: parameter)
    }
  
    public func executeTodayMission() -> Observable<CameraTodayMissionResponse?> {
      return cameraRepository.fetchTodayMissionItem()
    }
    
}
