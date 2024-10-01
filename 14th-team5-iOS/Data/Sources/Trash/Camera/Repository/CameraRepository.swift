//
//  CameraRepository.swift
//  Data
//
//  Created by Kim dohyun on 6/7/24.
//

import Foundation

import Core
import Domain
import RxCocoa
import RxSwift


public final class CameraRepository {

    public var disposeBag: DisposeBag = DisposeBag()
    private let cameraAPIWorker: CameraAPIWorker = CameraAPIWorker()
    
    public init() { }
    
        
}

extension CameraRepository: CameraRepositoryProtocol {
    
    
    public func combineWithTextImage(parameters: CameraDisplayPostParameters, query:CameraMissionFeedQuery) -> Single<CameraPostEntity?> {
        return cameraAPIWorker.combineWithTextImageUpload(parameters: parameters, query: query)
            .map { $0?.toDomain() }
            .catchAndReturn(nil)
    }
    
    public func addPresignedeImageURL(parameters: CameraDisplayImageParameters) -> Single<CameraPreSignedEntity?> {
        return cameraAPIWorker.createProfilePresignedURL(parameters: parameters)
            .map { $0?.toDomain() }
    }
    
    
        
    public func uploadImageToS3(to url: String, from imageData: Data) -> Single<Bool> {
        return cameraAPIWorker.uploadImageToPresignedURL(toURL: url, withImageData: imageData)
    }
    
    public func editProfleImageToS3(memberId: String, parameter: ProfileImageEditParameter) -> Single<MembersProfileEntity?> {
        return cameraAPIWorker.editProfileImageToS3(memberId: memberId, parameters: parameter)
            .do {
                guard let userEntity = $0?.toProfileEntity() else { return }
                let familyUserDefaults = FamilyInfoUserDefaults()
                familyUserDefaults.updateFamilyMember(userEntity)
            }
            .map { $0?.toDomain() }
    }
    
    public func fetchRealEmojiImageURL(memberId: String, parameters: CameraRealEmojiParameters) -> Single<CameraRealEmojiPreSignedEntity?> {
        return cameraAPIWorker.createRealEmojiPresignedURL(parameters: parameters)
            .map { $0?.toDomain() }
    }
    
    public func uploadRealEmojiImageToS3(memberId: String, parameters: CameraCreateRealEmojiParameters) -> Single<CameraCreateRealEmojiEntity?> {
        return cameraAPIWorker.uploadRealEmojiImageToS3(parameters: parameters)
            .map { $0?.toDomain() }
    }
    
    public func fetchRealEmojiItems() -> Single<[CameraRealEmojiImageItemEntity?]> {
        return cameraAPIWorker.loadRealEmojiImage()
            .map { $0?.toDomain() ?? [] }
    }
    
    public func updateRealEmojiImage(memberId: String, realEmojiId: String, parameters: CameraUpdateRealEmojiParameters) -> Single<CameraUpdateRealEmojiEntity?> {
        return cameraAPIWorker.updateRealEmojiImage(realEmojiId: realEmojiId, parameters: parameters)
            .map { $0?.toDomain() }
    }
  
  public func fetchTodayMissionItem() -> Single<CameraTodayMssionEntity?> {
      return cameraAPIWorker.fetchMissionItems()
          .map { $0?.toDomain() }
  }
    
}
