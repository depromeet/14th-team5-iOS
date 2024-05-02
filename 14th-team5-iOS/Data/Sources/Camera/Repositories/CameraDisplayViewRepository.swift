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
    public var accessToken: String = App.Repository.token.accessToken.value?.accessToken ?? ""
    
}


extension CameraDisplayViewRepository: CameraDisplayViewInterface {
    
    public func generateDescrption(with keyword: String) -> Observable<Array<String>> {
        
        let item: Array<String> = Array(keyword).map { String($0) }
        return Observable.create { observer in
            observer.onNext(item)
            
            return Disposables.create()
        }
    }
    
    public func fetchFeedImageURL(parameters: CameraDisplayImageParameters) -> Observable<CameraDisplayImageResponse?>  {
        return cameraDisplayAPIWorker.createFeedPresignedURL(accessToken: accessToken, parameters: parameters)
            .catchAndReturn(nil)
            .map { $0?.toDomain() ?? nil }
            .asObservable()
                
    }
    
    public func uploadImageToS3(toURL url: String, imageData: Data) -> Observable<Bool> {
        return cameraDisplayAPIWorker.uploadImageToPresignedURL(accessToken: accessToken, toURL: url, withImageData: imageData)
            .asObservable()
    }
    
    
    public func combineWithTextImage(parameters: CameraDisplayPostParameters, query:CameraMissionFeedQuery) -> Observable<CameraDisplayPostResponse?> {
        return cameraDisplayAPIWorker.combineWithTextImageUpload(accessToken: accessToken, parameters: parameters, query: query)
            .map { $0?.toDomain() }
            .catchAndReturn(nil)
            .asObservable()
    }
    
}
