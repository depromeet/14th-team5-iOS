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

public final class CameraDIContainer: BaseDIContainer {
        
    public typealias ViewContrller = CameraViewController
    public typealias Repository = CameraViewInterface
    public typealias Reactor = CameraViewReactor
    public typealias UseCase = CameraViewUseCaseProtocol
    
    
    private let cameraType: UploadLocation
    private let realEmojiType: Emojis
    private let memberId: String
    
    
    private var globalState: GlobalStateProviderProtocol {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return GlobalStateProvider()
        }
        return appDelegate.globalStateProvider
    }
    
    public init(cameraType: UploadLocation, memberId: String = "", realEmojiType: Emojis = Emojis.emoji(forIndex: 1)) {
        self.cameraType = cameraType
        self.realEmojiType = realEmojiType
        self.memberId = App.Repository.member.memberID.value ?? ""
    }
    
    public func makeViewController() -> CameraViewController {
        return CameraViewController(reactor: makeReactor())
    }
    
    public func makeUseCase() -> UseCase {
        return CameraViewUseCase(cameraViewRepository: makeRepository())
    }
    
    
    public func makeRepository() -> Repository {
        return CameraViewRepository()
    }
    
    public func makeReactor() -> Reactor {
        return CameraViewReactor(
            cameraUseCase: makeUseCase(),
            provider: globalState,
            cameraType: cameraType,
            memberId: memberId,
            emojiType: realEmojiType
        )
    }
    

}
