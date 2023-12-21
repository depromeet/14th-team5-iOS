//
//  CameraAPIWorker.swift
//  Data
//
//  Created by Kim dohyun on 12/21/23.
//

import Foundation

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
    public func createPresignedURL(accessToken: String, parameters: Encodable) -> Single<CameraDisplayImageResponse?> {
        let spec = CameraAPIs.uploadImageURL.spec
        
        return request(spec: spec, headers: [BibbiAPI.Header.acceptJson, BibbiAPI.Header.xAuthToken(accessToken)], jsonEncodable: parameters)
            .subscribe(on: Self.queue)
            .do {
                if let str = String(data: $0.1, encoding: .utf8) {
                    debugPrint("uploadImage Fetch Reuslt: \(str)")
                }
            }
            .map(CameraDisplayImageDTO.self)
            .catchAndReturn(nil)
            .map { $0?.toDomain() }
            .asSingle()
    }
    
    public func uploadImageToPresignedURL(accessToken: String, toURL url: String, withImageData imageData: Data) -> Single<Bool> {
        let spec = CameraAPIs.presignedURL(url).spec
        return upload(spec: spec, headers: [BibbiAPI.Header.xAuthToken(accessToken)], image: imageData)
            .subscribe(on: Self.queue)
            .catchAndReturn(false)
            .debug()
            .map { _ in true }
    }
    
    public func combineWithTextImageUpload(accessToken: String, parameters: Encodable)  -> Single<CameraDisplayPostResponse?> {
        let spec = CameraAPIs.updateImage.spec
        
        return request(spec: spec, headers: [BibbiAPI.Header.acceptJson, BibbiAPI.Header.xAuthToken(accessToken)], jsonEncodable: parameters)
            .subscribe(on: Self.queue)
            .do {
                if let str = String(data: $0.1, encoding: .utf8) {
                    debugPrint("combine With TextImage Result: \(str)")
                }
            }
            .map(CameraDisplayPostDTO.self)
            .catchAndReturn(nil)
            .map { $0?.toDomain() }
            .asSingle()
        
    }
}
