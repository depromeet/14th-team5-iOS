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
    
    public var accessToken: String = App.Repository.token.accessToken.value?.accessToken ?? ""
        
}

extension CameraRepository: CameraRepositoryProtocol {
    
    
    public func combineWithTextImage(parameters: CameraDisplayPostParameters, query:CameraMissionFeedQuery) -> Single<CameraPostEntity?> {
        return cameraAPIWorker.combineWithTextImageUpload(accessToken: accessToken, parameters: parameters, query: query)
            .map { $0?.toDomain() }
            .catchAndReturn(nil)
    }
    
    public func addPresignedeImageURL(parameters: CameraDisplayImageParameters) -> Single<CameraPreSignedEntity?> {
        return cameraAPIWorker.createProfilePresignedURL(accessToken: accessToken, parameters: parameters)
            .map { $0?.toDomain() }
    }
    
    
        
    public func uploadImageToS3(to url: String, from imageData: Data) -> Single<Bool> {
        return cameraAPIWorker.uploadImageToPresignedURL(accessToken: accessToken, toURL: url, withImageData: imageData)
    }
    
    public func editProfleImageToS3(memberId: String, parameter: ProfileImageEditParameter) -> Single<MembersProfileEntity?> {
        return cameraAPIWorker.editProfileImageToS3(accessToken: accessToken, memberId: memberId, parameters: parameter)
            .do {
                guard let userEntity = $0?.toProfileEntity() else { return }
                FamilyUserDefaults.saveMemberToUserDefaults(familyMember: userEntity)
            }
            .map { $0?.toDomain() }
    }
    
    public func fetchRealEmojiImageURL(memberId: String, parameters: CameraRealEmojiParameters) -> Single<CameraRealEmojiPreSignedEntity?> {
        return cameraAPIWorker.createRealEmojiPresignedURL(accessToken: accessToken, memberId: memberId, parameters: parameters)
            .map { $0?.toDomain() }
    }
    
    public func uploadRealEmojiImageToS3(memberId: String, parameters: CameraCreateRealEmojiParameters) -> Single<CameraCreateRealEmojiEntity?> {
        return cameraAPIWorker.uploadRealEmojiImageToS3(accessToken: accessToken, memberId: memberId, parameters: parameters)
            .map { $0?.toDomain() }
    }
    
    public func fetchRealEmojiItems(memberId: String) -> Single<[CameraRealEmojiImageItemEntity?]> {
        return cameraAPIWorker.loadRealEmojiImage(accessToken: accessToken, memberId: memberId)
            .map { $0?.toDomain() ?? [] }
    }
    
    public func updateRealEmojiImage(memberId: String, realEmojiId: String, parameters: CameraUpdateRealEmojiParameters) -> Single<CameraUpdateRealEmojiEntity?> {
        return cameraAPIWorker.updateRealEmojiImage(accessToken: accessToken, memberId: memberId, realEmojiId: realEmojiId, parameters: parameters)
            .map { $0?.toDomain() }
    }
  
  public func fetchTodayMissionItem() -> Single<CameraTodayMssionEntity?> {
      return cameraAPIWorker.fetchMissionItems(accessToken: accessToken)
          .map { $0?.toDomain() }
  }
    
}
