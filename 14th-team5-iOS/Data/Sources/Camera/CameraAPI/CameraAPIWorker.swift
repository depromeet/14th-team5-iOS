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
    public func createProfilePresignedURL(accessToken: String, parameters: Encodable) -> Single<CameraDisplayImageDTO?> {
        
        let spec = CameraAPIs.uploadProfileImageURL.spec
        
        return request(spec: spec, headers: [BibbiAPI.Header.xAppKey, BibbiAPI.Header.acceptJson, BibbiAPI.Header.xAuthToken(accessToken)], jsonEncodable: parameters)
            .subscribe(on: Self.queue)
            .do {
                if let str = String(data: $0.1, encoding: .utf8) {
                    debugPrint("upload Profile Image URL Fetch Reuslt: \(str)")
                }
            }
            .map(CameraDisplayImageDTO.self)
            .catchAndReturn(nil)
            .asSingle()
    }
    
    
    
    public func createFeedPresignedURL(accessToken: String, parameters: Encodable) -> Single<CameraDisplayImageDTO?> {
        let spec = CameraAPIs.uploadImageURL.spec
        
        
        return request(spec: spec, headers: [BibbiAPI.Header.xAppKey, BibbiAPI.Header.acceptJson, BibbiAPI.Header.xAuthToken(accessToken)], jsonEncodable: parameters)
            .subscribe(on: Self.queue)
            .do {
                if let str = String(data: $0.1, encoding: .utf8) {
                    debugPrint("uploadImage Fetch Reuslt: \(str)")
                }
            }
            .map(CameraDisplayImageDTO.self)
            .catchAndReturn(nil)
            .asSingle()
    }
    
    public func editProfileImageToS3(accessToken: String, memberId: String, parameters: Encodable) -> Single<MembersProfileResponseDTO?>   {
        let spec = CameraAPIs.editProfileImage(memberId).spec
        return request(spec: spec, headers: [BibbiAPI.Header.xAppKey, BibbiAPI.Header.acceptJson, BibbiAPI.Header.xAuthToken(accessToken)], jsonEncodable: parameters)
            .subscribe(on: Self.queue)
            .do {
                if let str = String(data: $0.1, encoding: .utf8) {
                    debugPrint("editProfile Image Upload Result: \(str)")
                }
            }
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
    
    public func combineWithTextImageUpload(accessToken: String, parameters: Encodable, query: CameraMissionFeedQuery)  -> Single<CameraDisplayPostDTO?> {
        let spec = CameraAPIs.updateImage(query).spec
        
        return request(spec: spec, headers: [BibbiAPI.Header.xAppKey, BibbiAPI.Header.acceptJson, BibbiAPI.Header.xAuthToken(accessToken)], jsonEncodable: parameters)
            .subscribe(on: Self.queue)
            .do {
                if let str = String(data: $0.1, encoding: .utf8) {
                    debugPrint("editProfile Image Upload Result: \(str)")
                }
            }
            .map(CameraDisplayPostDTO.self)
            .map { dto in
                guard let dto = dto else { return nil }
                let repository = PostUserDefaultsRepository()
                repository.savePostUploadDate(createdAt: dto.createdAt)
                return dto
            }
            .catchAndReturn(nil)
            .asSingle()
        
    }
    
    
    // TODO: Real Emoji API 추가
    public func createRealEmojiPresignedURL(accessToken: String, memberId: String, parameters: Encodable) -> Single<CameraRealEmojiPreSignedDTO?> {
        let spec = CameraAPIs.uploadRealEmojiURL(memberId).spec
        
        return request(spec: spec, headers: [BibbiAPI.Header.xAppKey, BibbiAPI.Header.acceptJson, BibbiAPI.Header.xAuthToken(accessToken)], jsonEncodable: parameters)
            .subscribe(on: Self.queue)
            .do {
                if let str = String(data: $0.1, encoding: .utf8) {
                    debugPrint("RealEmoji Image Presigned URL Reuslt: \(str)")
                }
            }
            .map(CameraRealEmojiPreSignedDTO.self)
            .catchAndReturn(nil)
            .asSingle()
        
    }
    
    public func uploadRealEmojiImageToS3(accessToken: String, memberId: String, parameters: Encodable) -> Single<CameraCreateRealEmojiDTO?> {
        let spec = CameraAPIs.updateRealEmojiImage(memberId).spec
        
        return request(spec: spec, headers: [BibbiAPI.Header.xAppKey, BibbiAPI.Header.acceptJson, BibbiAPI.Header.xAuthToken(accessToken)], jsonEncodable: parameters)
            .subscribe(on: Self.queue)
            .do {
                if let str = String(data: $0.1, encoding: .utf8) {
                    debugPrint("Real Image upload to S3 Result: \(str)")
                }
            }
            .map(CameraCreateRealEmojiDTO.self)
            .catchAndReturn(nil)
            .asSingle()
    }
    
    public func loadRealEmojiImage(accessToken: String, memberId: String) -> Single<CameraRealEmojiImageItemDTO?> {
        let spec = CameraAPIs.reloadRealEmoji(memberId).spec
        
        return request(spec: spec, headers: [BibbiAPI.Header.xAppKey, BibbiAPI.Header.acceptJson, BibbiAPI.Header.xAuthToken(accessToken)])
            .subscribe(on: Self.queue)
            .do {
                if let str = String(data: $0.1, encoding: .utf8) {
                    debugPrint("Real Emoji Items Result: \(str)")
                }
            }
            .map(CameraRealEmojiImageItemDTO.self)
            .catchAndReturn(nil)
            .asSingle()
    }
    
    public func updateRealEmojiImage(accessToken: String, memberId: String, realEmojiId: String, parameters: Encodable) -> Single<CameraUpdateRealEmojiDTO?> {
        let spec = CameraAPIs.modifyRealEmojiImage(memberId, realEmojiId).spec
        return request(spec: spec, headers: [BibbiAPI.Header.xAppKey, BibbiAPI.Header.acceptJson, BibbiAPI.Header.xAuthToken(accessToken)], jsonEncodable: parameters)
            .subscribe(on: Self.queue)
            .do {
                if let str = String(data: $0.1, encoding: .utf8) {
                    debugPrint("Real Emoji Modify Result: \(str)")
                }
            }
            .map(CameraUpdateRealEmojiDTO.self)
            .catchAndReturn(nil)
            .asSingle()
    }
  
  public func fetchMissionItems(accessToken: String) -> Single<CameraTodayMissionDTO?> {
    let spec = CameraAPIs.fetchMissionToday.spec
    return request(spec: spec, headers: [BibbiAPI.Header.xAppKey, BibbiAPI.Header.acceptJson, BibbiAPI.Header.xAuthToken(accessToken)])
      .subscribe(on: Self.queue)
      .do {
        if let str = String(data: $0.1, encoding: .utf8) {
          debugPrint("Fetch Today Mission Items : \(str)")
        }
      }
      .map(CameraTodayMissionDTO.self)
      .catchAndReturn(nil)
      .asSingle()
  }
}

