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
    
    public func fetchProfileMember(memberId: String) -> Single<MembersProfileResponseDTO?> {
        let spec = MembersAPIs.profileMember(memberId).spec
        let accessToken: String = App.Repository.token.accessToken.value?.accessToken ?? ""
        let headers = BibbiHeader.commonHeaders(accessToken: accessToken)
        return request(spec: spec, headers: headers)
            .subscribe(on: Self.queue)
            .map(MembersProfileResponseDTO.self)
            .catchAndReturn(nil)
            .asSingle()
        
    }
    
    public func createProfileImagePresingedURL(parameters: Encodable) -> Single<CameraDisplayImageResponseDTO?> {
        let spec = MembersAPIs.profileAlbumUploadImageURL.spec
        let accessToken: String = App.Repository.token.accessToken.value?.accessToken ?? ""
        let headers = BibbiHeader.commonHeaders(accessToken: accessToken)
        return request(spec: spec, headers: headers, jsonEncodable: parameters)
            .subscribe(on: Self.queue)
            .map(CameraDisplayImageResponseDTO.self)
            .catchAndReturn(nil)
            .asSingle()
    }
    
    public func uploadToProfilePresingedURL(toURL url: String, with imageData: Data) -> Single<Bool> {
        let spec = MembersAPIs.profileUploadToPreSignedURL(url).spec
        let accessToken: String = App.Repository.token.accessToken.value?.accessToken ?? ""
        let headers = BibbiHeader.commonHeaders(accessToken: accessToken)
        return upload(spec: spec, headers: headers, image: imageData)
            .subscribe(on: Self.queue)
            .catchAndReturn(false)
            .map { _ in true }
    }
    
    public func updateProfileAlbumImageToS3(memberId: String, parameter: Encodable) -> Single<MembersProfileResponseDTO?> {
        let spec = MembersAPIs.profileEditImage(memberId).spec
        let accessToken: String = App.Repository.token.accessToken.value?.accessToken ?? ""
        let headers = BibbiHeader.commonHeaders(accessToken: accessToken)
        return request(spec: spec, headers: headers, jsonEncodable: parameter)
            .subscribe(on: Self.queue)
            .map(MembersProfileResponseDTO.self)
            .catchAndReturn(nil)
            .asSingle()
    }
    
    public func deleteProfileImageToS3(memberId: String) -> Single<MembersProfileResponseDTO?> {
        let spec = MembersAPIs.profileDeleteImage(memberId).spec
        return request(spec: spec)
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
