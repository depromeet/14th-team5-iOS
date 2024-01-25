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
    //TODO: 나중에 Prameters memberId 추가하고 type에 따라 realEmoji, feed, profile, PresignedURL 호출 API 분기 작성하면 하나로 통합 할 수 있을듯
    public func createPresignedURL(accessToken: String, parameters: Encodable, type: UploadLocation) -> Single<CameraDisplayImageDTO?> {
        let spec = type == .feed ? CameraAPIs.uploadImageURL.spec : CameraAPIs.uploadProfileImageURL.spec
        
        
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
    
    public func editProfileImageToS3(accessToken: String, memberId: String, parameters: Encodable) -> Single<ProfileMemberDTO?>   {
        let spec = CameraAPIs.editProfileImage(memberId).spec
        return request(spec: spec, headers: [BibbiAPI.Header.xAppKey, BibbiAPI.Header.acceptJson, BibbiAPI.Header.xAuthToken(accessToken)], jsonEncodable: parameters)
            .subscribe(on: Self.queue)
            .do {
                if let str = String(data: $0.1, encoding: .utf8) {
                    debugPrint("editProfile Image Upload Result: \(str)")
                }
            }
            .map(ProfileMemberDTO.self)
            .catchAndReturn(nil)
            .asSingle()
    }
    
    public func uploadImageToPresignedURL(accessToken: String, toURL url: String, withImageData imageData: Data) -> Single<Bool> {
        let spec = CameraAPIs.presignedURL(url).spec
        return upload(spec: spec, headers: [BibbiAPI.Header.xAppKey, BibbiAPI.Header.xAuthToken(accessToken)], image: imageData)
            .subscribe(on: Self.queue)
            .catchAndReturn(false)
            .debug()
            .map { _ in true }
    }
    
    public func combineWithTextImageUpload(accessToken: String, parameters: Encodable)  -> Single<CameraDisplayPostDTO?> {
        let spec = CameraAPIs.updateImage.spec
        
        return request(spec: spec, headers: [BibbiAPI.Header.xAppKey, BibbiAPI.Header.acceptJson, BibbiAPI.Header.xAuthToken(accessToken)], jsonEncodable: parameters)
            .subscribe(on: Self.queue)
            .do {
                if let str = String(data: $0.1, encoding: .utf8) {
                    debugPrint("editProfile Image Upload Result: \(str)")
                }
            }
            .map(CameraDisplayPostDTO.self)
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
}

