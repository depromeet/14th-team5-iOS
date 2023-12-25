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


public protocol CameraDisplayImpl: AnyObject {
    var disposeBag: DisposeBag { get }
    func generateDescrption(with keyword: String) -> Observable<Array<String>>
    func fetchImageURL(parameters: CameraDisplayImageParameters) -> Observable<CameraDisplayImageResponse?>
    func uploadImageToS3(toURL url: String, imageData: Data) -> Observable<Bool>
    func executeCombineWithTextImage(parameters: CameraDisplayPostParameters) -> Observable<CameraDisplayPostResponse?>
}

public final class CameraDisplayViewRepository: CameraDisplayImpl {
    public init() { } 
    private let cameraAPIWorker: CameraAPIWorker = CameraAPIWorker()
    
    public var disposeBag: DisposeBag = DisposeBag()
    public var token: String = "eyJyZWdEYXRlIjoxNzAzNDkzOTQwNTE1LCJ0eXBlIjoiYWNjZXNzIiwiYWxnIjoiSFMyNTYiLCJ0eXAiOiJKV1QifQ.eyJ1c2VySWQiOiI4IiwiZXhwIjoxNzAzNTgwMzQwfQ.2AxJTnE2rhdl17Ml62wPLFCSosd_aLaXNRPHXluk2iA"
    
    public func generateDescrption(with keyword: String) -> RxSwift.Observable<Array<String>> {
        
        let item: Array<String> = Array(keyword).map { String($0) }
        return Observable.create { observer in
            observer.onNext(item)
            
            return Disposables.create()
        }
    }
    
    public func fetchImageURL(parameters: CameraDisplayImageParameters) -> Observable<CameraDisplayImageResponse?>  {
        return cameraAPIWorker.createPresignedURL(accessToken: token, parameters: parameters)
            .asObservable()
                
    }
    
    public func uploadImageToS3(toURL url: String, imageData: Data) -> Observable<Bool> {
        return cameraAPIWorker.uploadImageToPresignedURL(accessToken: token, toURL: url, withImageData: imageData)
            .asObservable()
    }
    
    
    public func executeCombineWithTextImage(parameters: CameraDisplayPostParameters) -> Observable<CameraDisplayPostResponse?> {
        return cameraAPIWorker.combineWithTextImageUpload(accessToken: token, parameters: parameters)
            .asObservable()
    }
    
    
}
