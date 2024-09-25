//
//  CameraAPIWorker.swift
//  Data
//
//  Created by Kim dohyun on 12/21/23.
//

import Foundation
import Core

import Alamofire
import Domain
import RxSwift


typealias CameraAPIWorker = CameraAPIs.Worker


extension CameraAPIs {
    final class Worker: APIWorker {
        
        static let queue = {
            ConcurrentDispatchQueueScheduler(queue: DispatchQueue(label: "CameraAPIQueue", qos: .utility))
        }()
        
        override init() {
            super.init()
            self.id = "CameraAPIWorker"
        }
    }
}


extension CameraAPIWorker {
    public func createProfilePresignedURL(accessToken: String, parameters: Encodable) -> Single<CameraDisplayImageResponseDTO?> {
        
        let spec = CameraAPIs.uploadProfileImageURL.spec
        
        return request(spec: spec, headers: [BibbiAPI.Header.xAppKey, BibbiAPI.Header.acceptJson, BibbiAPI.Header.xAuthToken(accessToken)], jsonEncodable: parameters)
            .subscribe(on: Self.queue)
            .map(CameraDisplayImageResponseDTO.self)
            .catchAndReturn(nil)
            .asSingle()
    }
    
    
    
    public func createFeedPresignedURL(accessToken: String, parameters: Encodable) -> Single<CameraDisplayImageResponseDTO?> {
        let spec = CameraAPIs.uploadImageURL.spec
        
        
        return request(spec: spec, headers: [BibbiAPI.Header.xAppKey, BibbiAPI.Header.acceptJson, BibbiAPI.Header.xAuthToken(accessToken)], jsonEncodable: parameters)
            .subscribe(on: Self.queue)
            .map(CameraDisplayImageResponseDTO.self)
            .catchAndReturn(nil)
            .asSingle()
    }
    
    public func editProfileImageToS3(accessToken: String, memberId: String, parameters: Encodable) -> Single<MembersProfileResponseDTO?>   {
        let spec = CameraAPIs.editProfileImage(memberId).spec
        return request(spec: spec, headers: [BibbiAPI.Header.xAppKey, BibbiAPI.Header.acceptJson, BibbiAPI.Header.xAuthToken(accessToken)], jsonEncodable: parameters)
            .subscribe(on: Self.queue)
            .map(MembersProfileResponseDTO.self)
            .catchAndReturn(nil)
            .asSingle()
    }
    
    public func uploadImageToPresignedURL(accessToken: String, toURL url: String, withImageData imageData: Data) -> Single<Bool> {
        let spec = CameraAPIs.presignedURL(url).spec
        return upload(spec: spec, headers: [BibbiAPI.Header.xAppKey, BibbiAPI.Header.xAuthToken(accessToken)], image: imageData)
            .subscribe(on: Self.queue)
            .catchAndReturn(false)
            .debug()
            .map { $0 }
    }
    
    public func combineWithTextImageUpload(accessToken: String, parameters: Encodable, query: CameraMissionFeedQuery)  -> Single<CameraDisplayPostResponseDTO?> {
        let spec = CameraAPIs.updateImage(query).spec
        
        return request(spec: spec, headers: [BibbiAPI.Header.xAppKey, BibbiAPI.Header.acceptJson, BibbiAPI.Header.xAuthToken(accessToken)], jsonEncodable: parameters)
            .subscribe(on: Self.queue)
            .map(CameraDisplayPostResponseDTO.self)
            .map { dto in
                guard let dto = dto else { return nil }
                let repository = PostUserDefaultsRepository()
                repository.savePostUploadDate(createdAt: dto.createdAt)
                return dto
            }
            .catchAndReturn(nil)
            .asSingle()
        
    }
    
    public func createRealEmojiPresignedURL(accessToken: String, parameters: Encodable) -> Single<CameraRealEmojiPreSignedResponseDTO?> {
        //TODO: Repository로 코드 원복
        let memberId = App.Repository.member.memberID.value ?? ""
        let spec = CameraAPIs.uploadRealEmojiURL(memberId).spec
        
        return request(spec: spec, headers: [BibbiAPI.Header.xAppKey, BibbiAPI.Header.acceptJson, BibbiAPI.Header.xAuthToken(accessToken)], jsonEncodable: parameters)
            .subscribe(on: Self.queue)
            .map(CameraRealEmojiPreSignedResponseDTO.self)
            .catchAndReturn(nil)
            .asSingle()
        
    }
    
    public func uploadRealEmojiImageToS3(accessToken: String, parameters: Encodable) -> Single<CameraCreateRealEmojiResponseDTO?> {
        //TODO: Repository로 코드 원복
        let memberId = App.Repository.member.memberID.value ?? ""
        let spec = CameraAPIs.updateRealEmojiImage(memberId).spec
        
        return request(spec: spec, headers: [BibbiAPI.Header.xAppKey, BibbiAPI.Header.acceptJson, BibbiAPI.Header.xAuthToken(accessToken)], jsonEncodable: parameters)
            .subscribe(on: Self.queue)
            .map(CameraCreateRealEmojiResponseDTO.self)
            .catchAndReturn(nil)
            .asSingle()
    }
    
    public func loadRealEmojiImage(accessToken: String) -> Single<CameraRealEmojiImageItemResponseDTO?> {
        //TODO: Repository로 코드 원복
        let memberId = App.Repository.member.memberID.value ?? ""
        let spec = CameraAPIs.reloadRealEmoji(memberId).spec
        
        return request(spec: spec, headers: [BibbiAPI.Header.xAppKey, BibbiAPI.Header.acceptJson, BibbiAPI.Header.xAuthToken(accessToken)])
            .subscribe(on: Self.queue)
            .map(CameraRealEmojiImageItemResponseDTO.self)
            .catchAndReturn(nil)
            .asSingle()
    }
    
    public func updateRealEmojiImage(accessToken: String, realEmojiId: String, parameters: Encodable) -> Single<CameraUpdateRealEmojiResponseDTO?> {
        //TODO: Repository로 코드 원복
        let memberId = App.Repository.member.memberID.value ?? ""
        let spec = CameraAPIs.modifyRealEmojiImage(memberId, realEmojiId).spec
        return request(spec: spec, headers: [BibbiAPI.Header.xAppKey, BibbiAPI.Header.acceptJson, BibbiAPI.Header.xAuthToken(accessToken)], jsonEncodable: parameters)
            .subscribe(on: Self.queue)
            .map(CameraUpdateRealEmojiResponseDTO.self)
            .catchAndReturn(nil)
            .asSingle()
    }
  
  public func fetchMissionItems(accessToken: String) -> Single<CameraTodayMissionResponseDTO?> {
    let spec = CameraAPIs.fetchMissionToday.spec
    return request(spec: spec, headers: [BibbiAPI.Header.xAppKey, BibbiAPI.Header.acceptJson, BibbiAPI.Header.xAuthToken(accessToken)])
      .subscribe(on: Self.queue)
      .map(CameraTodayMissionResponseDTO.self)
      .catchAndReturn(nil)
      .asSingle()
  }
}

