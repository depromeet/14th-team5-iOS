//
//  MembersAPIWorker.swift
//  Data
//
//  Created by Kim dohyun on 6/5/24.
//

import Core
import Foundation

import Alamofire
import Domain
import RxSwift


typealias MembersAPIWorker = MembersAPIs.Worker

extension MembersAPIs {
    final class Worker: APIWorker {
        
        static let queue = {
            ConcurrentDispatchQueueScheduler(queue: DispatchQueue(label: "ProfileAPIQueue", qos: .utility))
        }()
        
        override init() {
            super.init()
            self.id = "ProfileAPIWorker"
        }
        
    }
}


extension MembersAPIWorker {
    
    public func fetchProfileMember(accessToken: String, memberId: String) -> Single<MembersProfileResponseDTO?> {
        let spec = MembersAPIs.profileMember(memberId).spec

        return request(spec: spec, headers: [BibbiAPI.Header.xAppVersion, BibbiAPI.Header.xUserPlatform, BibbiAPI.Header.xAppKey, BibbiAPI.Header.acceptJson, BibbiAPI.Header.xAuthToken(accessToken)])
            .subscribe(on: Self.queue)
            .map(MembersProfileResponseDTO.self)
            .catchAndReturn(nil)
            .asSingle()
        
    }
    
    public func createProfileImagePresingedURL(accessToken: String, parameters: Encodable) -> Single<CameraDisplayImageResponseDTO?> {
        let spec = MembersAPIs.profileAlbumUploadImageURL.spec
        
        return request(spec: spec, headers: [BibbiAPI.Header.xAppVersion, BibbiAPI.Header.xUserPlatform, BibbiAPI.Header.xAppKey, BibbiAPI.Header.acceptJson, BibbiAPI.Header.xAuthToken(accessToken)], jsonEncodable: parameters)
            .subscribe(on: Self.queue)
            .map(CameraDisplayImageResponseDTO.self)
            .catchAndReturn(nil)
            .asSingle()
    }
    
    public func uploadToProfilePresingedURL(accessToken: String, toURL url: String, with imageData: Data) -> Single<Bool> {
        let spec = MembersAPIs.profileUploadToPreSignedURL(url).spec
        
        return upload(spec: spec, headers: [BibbiAPI.Header.xAppVersion, BibbiAPI.Header.xUserPlatform, BibbiAPI.Header.xAppKey, BibbiAPI.Header.xAuthToken(accessToken)], image: imageData)
            .subscribe(on: Self.queue)
            .catchAndReturn(false)
            .map { _ in true }
    }
    
    public func updateProfileAlbumImageToS3(accessToken: String, memberId: String, parameter: Encodable) -> Single<MembersProfileResponseDTO?> {
        let spec = MembersAPIs.profileEditImage(memberId).spec
        
        return request(spec: spec, headers: [BibbiAPI.Header.xAppVersion, BibbiAPI.Header.xUserPlatform, BibbiAPI.Header.xAppKey, BibbiAPI.Header.acceptJson, BibbiAPI.Header.xAuthToken(accessToken)], jsonEncodable: parameter)
            .subscribe(on: Self.queue)
            .map(MembersProfileResponseDTO.self)
            .catchAndReturn(nil)
            .asSingle()
    }
    
    public func deleteProfileImageToS3(accessToken: String, memberId: String) -> Single<MembersProfileResponseDTO?> {
        let spec = MembersAPIs.profileDeleteImage(memberId).spec
        
        return request(spec: spec,headers: [BibbiAPI.Header.xAppVersion, BibbiAPI.Header.xUserPlatform, BibbiAPI.Header.xAppKey, BibbiAPI.Header.acceptJson])
            .subscribe(on: Self.queue)
            .map(MembersProfileResponseDTO.self)
            .catchAndReturn(nil)
            .asSingle()
    }
    
    public func deleteAccountUser(memberId: String, body: Encodable) -> Single<AccountResignResponseDTO?> {
        let spec = ResignAPIs.accountResign(memberId).spec
        
        return request(spec: spec, jsonEncodable: body)
            .subscribe(on: Self.queue)
            .map(AccountResignResponseDTO.self)
            .catchAndReturn(nil)
            .asSingle()
    }
    
}
