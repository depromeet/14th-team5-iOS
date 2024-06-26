//
//  CameraDIContainer.swift
//  App
//
//  Created by Kim dohyun on 12/6/23.
//

import Foundation

import Core
import Data
import Domain
import UIKit

final class CameraDIContainer: BaseContainer {
    
    public func makeRepository() -> CameraRepositoryProtocol {
        return CameraRepository()
    }
    
    
    private func makeCreateProfileImageUseCase() -> CreateCameraImageUseCaseProtocol {
        return CreateCameraImageUseCase(cameraRepository: makeRepository())
    }
    
    private func makeCreateCameraUseCase() -> CreateCameraUseCaseProtocol {
        return CreateCameraUseCase(cameraRepository: makeRepository())
    }
    
    private func makeEditCameraProfileImageUseCase() -> EditCameraProfileImageUseCaseProtocol {
        return EditCameraProfileImageUseCase(cameraRepository: makeRepository())
    }
    
    private func makeFetchCameraUploadImageUseCase() -> FetchCameraUploadImageUseCaseProtocol {
        return FetchCameraUploadImageUseCase(cameraRepository: makeRepository())
    }
    
    private func makeFetchCameraTodayMissionUseCase() -> FetchCameraTodayMissionUseCaseProtocol {
        return FetchCameraTodayMissionUseCase(cameraRepository: makeRepository())
    }
    
    private func makeFetchCameraRealEmojiUpdateUseCase() -> FetchCameraRealEmojiUpdateUseCaseProtocol {
        return FetchCameraRealEmojiUpdateUseCase(cameraRepostiroy: makeRepository())
    }
    
    private func makeFetchCameraRealEmojiUploadUseCase() -> FetchCameraRealEmojiUploadUseCaseProtocol {
        return FetchCameraRealEmojiUploadUseCase(cameraRepository: makeRepository())
    }
    
    private func makeFetchCameraRealEmojiListUseCase() -> FetchCameraRealEmojiListUseCaseProtocol {
        return FetchCameraRealEmojiListUseCase(cameraRepository: makeRepository())
    }
    
    private func makeFetchCameraRealEmojiUseCase() ->  FetchCameraRealEmojiUseCaseProtocol {
        return FetchCameraRealEmojiUseCase(cameraRepository: makeRepository())
    }
        
    func registerDependencies() {
        container.register(type: CreateCameraImageUseCaseProtocol.self) { _ in
            self.makeCreateProfileImageUseCase()
        }
        
        container.register(type: CreateCameraUseCaseProtocol.self) { _ in
            self.makeCreateCameraUseCase()
        }
        
        container.register(type: EditCameraProfileImageUseCaseProtocol.self) { _ in
            self.makeEditCameraProfileImageUseCase()
        }
        
        container.register(type: FetchCameraUploadImageUseCaseProtocol.self) { _ in
            self.makeFetchCameraUploadImageUseCase()
        }
        
        container.register(type: FetchCameraTodayMissionUseCaseProtocol.self) { _ in
            self.makeFetchCameraTodayMissionUseCase()
        }
        
        container.register(type: FetchCameraRealEmojiUpdateUseCaseProtocol.self) { _ in
            self.makeFetchCameraRealEmojiUpdateUseCase()
        }
        
        container.register(type: FetchCameraRealEmojiUploadUseCaseProtocol.self) { _ in
            self.makeFetchCameraRealEmojiUploadUseCase()
        }
        
        container.register(type: FetchCameraRealEmojiListUseCaseProtocol.self) { _ in
            self.makeFetchCameraRealEmojiListUseCase()
        }
        
        container.register(type: FetchCameraRealEmojiUseCaseProtocol.self) { _ in
            self.makeFetchCameraRealEmojiUseCase()
        }
    }
    

}
