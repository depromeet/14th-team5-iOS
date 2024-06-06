//
//  CameraViewRepository.swift
//  Data
//
//  Created by Kim dohyun on 12/6/23.
//

import Foundation

import Core
import Domain
import RxCocoa
import RxSwift




public final class CameraViewRepository {

    public var disposeBag: DisposeBag = DisposeBag()
    private let cameraAPIWorker: CameraAPIWorker = CameraAPIWorker()
    
    public init() { }
    
    public var accessToken: String = App.Repository.token.accessToken.value?.accessToken ?? ""
        
}


extension CameraViewRepository: CameraViewInterface {
        
    public func toggleCameraPosition(_ isState: Bool) -> Observable<Bool> {
        return Observable<Bool>
            .create { observer in
                observer.onNext(!isState)
                
                return Disposables.create()
        }
    }
    
    
    public func toggleCameraFlash(_ isState: Bool) -> Observable<Bool> {
        return Observable<Bool>
            .create { observer in
                observer.onNext(!isState)
                return Disposables.create()
            }
    }
    
    
    public func fetchProfileImageURL(parameters: CameraDisplayImageParameters) -> Observable<CameraDisplayImageResponse?> {
        
        return cameraAPIWorker.createProfilePresignedURL(accessToken: accessToken, parameters: parameters)
            .compactMap { $0?.toDomain() }
            .asObservable()
    }
        
    public func uploadImageToS3(toURL url: String, imageData: Data) -> Observable<Bool> {
        return cameraAPIWorker.uploadImageToPresignedURL(accessToken: accessToken, toURL: url, withImageData: imageData)
            .asObservable()
    }
    
    public func editProfleImageToS3(memberId: String, parameter: ProfileImageEditParameter) -> Observable<MembersProfileResponse?> {
        return cameraAPIWorker.editProfileImageToS3(accessToken: accessToken, memberId: memberId, parameters: parameter)
            .do {
                guard let userEntity = $0?.toProfileEntity() else { return }
                FamilyUserDefaults.saveMemberToUserDefaults(familyMember: userEntity)
            }
            .compactMap { $0?.toDomain() }
            .asObservable()
    }
    
    public func fetchRealEmojiImageURL(memberId: String, parameters: CameraRealEmojiParameters) -> Observable<CameraRealEmojiPreSignedResponse?> {
        return cameraAPIWorker.createRealEmojiPresignedURL(accessToken: accessToken, memberId: memberId, parameters: parameters)
            .compactMap { $0?.toDomain() }
            .asObservable()
    }
    
    public func uploadRealEmojiImageToS3(memberId: String, parameters: CameraCreateRealEmojiParameters) -> Observable<CameraCreateRealEmojiResponse?> {
        return cameraAPIWorker.uploadRealEmojiImageToS3(accessToken: accessToken, memberId: memberId, parameters: parameters)
            .compactMap { $0?.toDomain() }
            .asObservable()
    }
    
    public func fetchRealEmojiItems(memberId: String) -> Observable<[CameraRealEmojiImageItemResponse?]> {
        return cameraAPIWorker.loadRealEmojiImage(accessToken: accessToken, memberId: memberId)
            .compactMap { $0?.toDomain() }
            .asObservable()
    }
    
    public func updateRealEmojiImage(memberId: String, realEmojiId: String, parameters: CameraUpdateRealEmojiParameters) -> Observable<CameraUpdateRealEmojiResponse?> {
        return cameraAPIWorker.updateRealEmojiImage(accessToken: accessToken, memberId: memberId, realEmojiId: realEmojiId, parameters: parameters)
            .compactMap { $0?.toDomain() }
            .asObservable()
    }
  
  public func fetchTodayMissionItem() -> Observable<CameraTodayMissionResponse?> {
      return cameraAPIWorker.fetchMissionItems(accessToken: accessToken)
        .compactMap { $0?.toDomain() }
        .asObservable()
  }
}
