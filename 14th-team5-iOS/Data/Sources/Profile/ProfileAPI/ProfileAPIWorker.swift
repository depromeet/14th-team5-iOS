//
//  ProfileAPIWorker.swift
//  Data
//
//  Created by Kim dohyun on 12/25/23.
//

import Core
import Foundation

import Alamofire
import Domain
import RxSwift


typealias ProfileAPIWorker = ProfileAPIs.Worker

extension ProfileAPIs {
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


extension ProfileAPIWorker {
    
    
    public func fetchProfileMember(accessToken: String, memberId: String) -> Single<ProfileMemberDTO?> {
        let spec = ProfileAPIs.profileMember(memberId).spec

        return request(spec: spec, headers: [BibbiAPI.Header.xAppVersion, BibbiAPI.Header.xUserPlatform, BibbiAPI.Header.xAppKey, BibbiAPI.Header.acceptJson, BibbiAPI.Header.xAuthToken(accessToken)])
            .subscribe(on: Self.queue)
            .do {
                if let str = String(data: $0.1, encoding: .utf8) {
                    debugPrint("fetch Profile Member Result: \(str)")
                }
            }
            .map(ProfileMemberDTO.self)
            .catchAndReturn(nil)
            .asSingle()
        
    }
    
    public func createProfileImagePresingedURL(accessToken: String, parameters: Encodable) -> Single<CameraDisplayImageDTO?> {
        let spec = ProfileAPIs.profileAlbumUploadImageURL.spec
        
        return request(spec: spec, headers: [BibbiAPI.Header.xAppVersion, BibbiAPI.Header.xUserPlatform, BibbiAPI.Header.xAppKey, BibbiAPI.Header.acceptJson, BibbiAPI.Header.xAuthToken(accessToken)], jsonEncodable: parameters)
            .subscribe(on: Self.queue)
            .do {
                if let str = String(data: $0.1, encoding: .utf8) {
                    debugPrint("createPresinged URL \(str)")
                }
            }
            .map(CameraDisplayImageDTO.self)
            .catchAndReturn(nil)
            .asSingle()
    }
    
    public func uploadToProfilePresingedURL(accessToken: String, toURL url: String, with imageData: Data) -> Single<Bool> {
        let spec = ProfileAPIs.profileUploadToPreSignedURL(url).spec
        
        return upload(spec: spec, headers: [BibbiAPI.Header.xAppVersion, BibbiAPI.Header.xUserPlatform, BibbiAPI.Header.xAppKey, BibbiAPI.Header.xAuthToken(accessToken)], image: imageData)
            .subscribe(on: Self.queue)
            .catchAndReturn(false)
            .debug("preSingedURL Upload To Profile")
            .map { _ in true }
    }
    
    public func updateProfileAlbumImageToS3(accessToken: String, memberId: String, parameter: Encodable) -> Single<ProfileMemberDTO?> {
        let spec = ProfileAPIs.profileEditImage(memberId).spec
        
        return request(spec: spec, headers: [BibbiAPI.Header.xAppVersion, BibbiAPI.Header.xUserPlatform, BibbiAPI.Header.xAppKey, BibbiAPI.Header.acceptJson, BibbiAPI.Header.xAuthToken(accessToken)], jsonEncodable: parameter)
            .subscribe(on: Self.queue)
            .do {
                if let str = String(data: $0.1, encoding: .utf8) {
                    debugPrint("updateProfile Image Result: \(str)")
                }
            }
            .map(ProfileMemberDTO.self)
            .catchAndReturn(nil)
            .asSingle()
    }
    
    public func deleteProfileImageToS3(accessToken: String, memberId: String) -> Single<ProfileMemberDTO?> {
        let spec = ProfileAPIs.profileDeleteImage(memberId).spec
        
        return request(spec: spec,headers: [BibbiAPI.Header.xAppVersion, BibbiAPI.Header.xUserPlatform, BibbiAPI.Header.xAppKey, BibbiAPI.Header.acceptJson])
            .subscribe(on: Self.queue)
            .do {
                if let str = String(data: $0.1, encoding: .utf8) {
                    debugPrint("delete Profile Image Result: \(str)")
                }
            }
            .map(ProfileMemberDTO.self)
            .catchAndReturn(nil)
            .asSingle()
    }
    
}
