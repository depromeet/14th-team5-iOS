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
    func executeDisplayImageURL(parameters: CameraDisplayImageParameters) -> Observable<CameraDisplayImageResponse?>
    func executeUploadToS3(toURL url: String, imageData: Data) -> Observable<Bool>
    func executeCombineWithTextImage(parameters: CameraDisplayPostParameters, query: CameraMissionFeedQuery) -> Observable<CameraDisplayPostResponse?>
    
}


public final class CameraDisplayViewUseCase: CameraDisplayViewUseCaseProtocol {

    private let cameraDisplayViewRepository: CameraRepositoryProtocol
    
    public init(cameraDisplayViewRepository: CameraRepositoryProtocol) {
        self.cameraDisplayViewRepository = cameraDisplayViewRepository
    }
    
    public func executeDisplayImageURL(parameters: CameraDisplayImageParameters) -> Observable<CameraDisplayImageResponse?> {
        return cameraDisplayViewRepository.fetchPresignedeImageURL(parameters: parameters)
    }
    
    public func executeUploadToS3(toURL url: String, imageData: Data) -> Observable<Bool> {
        return cameraDisplayViewRepository.uploadImageToS3(toURL: url, imageData: imageData)
    }
    
    public func executeCombineWithTextImage(parameters: CameraDisplayPostParameters, query: CameraMissionFeedQuery) -> Observable<CameraDisplayPostResponse?> {
        return cameraDisplayViewRepository.combineWithTextImage(parameters: parameters, query: query)
    }
    
    
    
    
    
    
}
