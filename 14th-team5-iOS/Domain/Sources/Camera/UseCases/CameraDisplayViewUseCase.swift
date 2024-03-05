//
//  CameraDisplayViewUseCase.swift
//  Domain
//
//  Created by Kim dohyun on 12/26/23.
//

import Foundation

import RxSwift
import RxCocoa


public protocol CameraDisplayViewUseCaseProtocol {
    func executeDescrptionItems(with keyword: String) -> Observable<Array<String>>
    func executeDisplayImageURL(parameters: CameraDisplayImageParameters) -> Observable<CameraDisplayImageResponse?>
    func executeUploadToS3(toURL url: String, imageData: Data) -> Observable<Bool>
    func executeCombineWithTextImage(parameters: CameraDisplayPostParameters) -> Observable<CameraDisplayPostResponse?>
    
}


public final class CameraDisplayViewUseCase: CameraDisplayViewUseCaseProtocol {

    private let cameraDisplayViewRepository: CameraDisplayViewInterface
    
    public init(cameraDisplayViewRepository: CameraDisplayViewInterface) {
        self.cameraDisplayViewRepository = cameraDisplayViewRepository
    }
    
    public func executeDescrptionItems(with keyword: String) -> Observable<Array<String>> {
        return cameraDisplayViewRepository.generateDescrption(with: keyword)
    }
    
    public func executeDisplayImageURL(parameters: CameraDisplayImageParameters) -> Observable<CameraDisplayImageResponse?> {
        return cameraDisplayViewRepository.fetchFeedImageURL(parameters: parameters)
    }
    
    public func executeUploadToS3(toURL url: String, imageData: Data) -> Observable<Bool> {
        return cameraDisplayViewRepository.uploadImageToS3(toURL: url, imageData: imageData)
    }
    
    public func executeCombineWithTextImage(parameters: CameraDisplayPostParameters) -> Observable<CameraDisplayPostResponse?> {
        return cameraDisplayViewRepository.combineWithTextImage(parameters: parameters)
    }
    
    
    
    
    
    
}
