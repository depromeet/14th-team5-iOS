//
//  CameraViewRepository.swift
//  Data
//
//  Created by Kim dohyun on 12/6/23.
//

import Foundation

import Core
import Domain
import RxCocoa
import RxSwift




public final class CameraViewRepository {

    public var disposeBag: DisposeBag = DisposeBag()
    private let cameraAPIWorker: CameraAPIWorker = CameraAPIWorker()
    
    public init() { }
    
    public var accessToken: String = "eyJ0eXBlIjoiYWNjZXNzIiwicmVnRGF0ZSI6MTcwNDQ2NjIyMzU3NCwidHlwIjoiSldUIiwiYWxnIjoiSFMyNTYifQ.eyJ1c2VySWQiOiIwMUhKQk5YQVYwVFlRMUtFU1dFUjQ1QTJRUCIsImV4cCI6MTcwNDU1MjYyM30.j9RJtR1bqzabskH8vAqUQLggRzjHyI_paAbh3k06NuU"
        
}


extension CameraViewRepository: CameraViewInterface {
        
    public func toggleCameraPosition(_ isState: Bool) -> Observable<Bool> {
        return Observable<Bool>
            .create { observer in
                observer.onNext(!isState)
                
                return Disposables.create()
        }
    }
    
    
    public func toggleCameraFlash(_ isState: Bool) -> Observable<Bool> {
        return Observable<Bool>
            .create { observer in
                observer.onNext(!isState)
                return Disposables.create()
            }
    }
    
    
    public func fetchProfileImageURL(parameters: CameraDisplayImageParameters, type: UploadLocation) -> Observable<CameraDisplayImageResponse?> {
        return cameraAPIWorker.createPresignedURL(accessToken: accessToken, parameters: parameters, type: type)
            .compactMap { $0?.toDomain() }
            .asObservable()
    }
        
    public func uploadProfileImage(toURL url: String, imageData: Data) -> Observable<Bool> {
        return cameraAPIWorker.uploadImageToPresignedURL(accessToken: accessToken, toURL: url, withImageData: imageData)
            .asObservable()
    }
    
    public func editProfleImageToS3(memberId: String, parameter: ProfileImageEditParameter) -> Observable<ProfileMemberResponse?> {
        return cameraAPIWorker.editProfileImageToS3(accessToken: accessToken, memberId: memberId, parameters: parameter)
            .compactMap { $0?.toDomain() }
            .asObservable()
    }
}
