//
//  CameraDisplayViewRepository.swift
//  Data
//
//  Created by Kim dohyun on 12/11/23.
//

import Foundation

import Core
import Domain
import RxSwift
import RxCocoa
import ReactorKit



public final class CameraDisplayViewRepository {
    public init() { }
    private let cameraDisplayAPIWorker: CameraAPIWorker = CameraAPIWorker()
    
    public var disposeBag: DisposeBag = DisposeBag()
    public var token: String = "eyJ0eXBlIjoiYWNjZXNzIiwicmVnRGF0ZSI6MTcwNDQ2NjIyMzU3NCwidHlwIjoiSldUIiwiYWxnIjoiSFMyNTYifQ.eyJ1c2VySWQiOiIwMUhKQk5YQVYwVFlRMUtFU1dFUjQ1QTJRUCIsImV4cCI6MTcwNDU1MjYyM30.j9RJtR1bqzabskH8vAqUQLggRzjHyI_paAbh3k06NuU"
    
}


extension CameraDisplayViewRepository: CameraDisplayViewInterface {
    
    public func generateDescrption(with keyword: String) -> Observable<Array<String>> {
        
        let item: Array<String> = Array(keyword).map { String($0) }
        return Observable.create { observer in
            observer.onNext(item)
            
            return Disposables.create()
        }
    }
    
    public func fetchImageURL(parameters: CameraDisplayImageParameters, type: UploadLocation) -> Observable<CameraDisplayImageResponse?>  {
        return cameraDisplayAPIWorker.createPresignedURL(accessToken: token, parameters: parameters, type: type)
            .compactMap { $0?.toDomain() }
            .asObservable()
                
    }
    
    public func uploadImageToS3(toURL url: String, imageData: Data) -> Observable<Bool> {
        return cameraDisplayAPIWorker.uploadImageToPresignedURL(accessToken: token, toURL: url, withImageData: imageData)
            .asObservable()
    }
    
    
    public func combineWithTextImage(parameters: CameraDisplayPostParameters) -> Observable<CameraDisplayPostResponse?> {
        return cameraDisplayAPIWorker.combineWithTextImageUpload(accessToken: token, parameters: parameters)
            .compactMap { $0?.toDomain() }
            .asObservable()
    }
    
}
