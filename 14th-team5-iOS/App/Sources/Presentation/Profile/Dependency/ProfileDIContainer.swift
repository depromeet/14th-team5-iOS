//
//  ProfileDIContainer.swift
//  App
//
//  Created by Kim dohyun on 12/17/23.
//

import UIKit

import Core
import Data
import Domain


public final class ProfileDIContainer: BaseDIContainer {
    public typealias ViewContrller = ProfileViewController
    public typealias Repository = MembersRepositoryProtocol
    public typealias Reactor = ProfileViewReactor
    
    private var globalState: GlobalStateProviderProtocol {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return GlobalStateProvider()
        }
        return appDelegate.globalStateProvider
    }
    
    private let memberId: String
    private let isUser: Bool
    
    public init(memberId: String = "") {
        self.memberId = memberId
        self.isUser = memberId == App.Repository.member.memberID.value ? true : false
    }
    
    public func makeViewController() -> ProfileViewController {
        return ProfileViewController(reactor: makeReactor())
    }
    
    public func makeRepository() -> Repository {
        return MembersRepository()
    }
    
    private func makeCameraRepository() -> CameraRepository {
        return CameraRepository()
    }
    
    public func makeReactor() -> ProfileViewReactor {
        return ProfileViewReactor(
            fetchMembersProfileUseCase: FetchMembersProfileUseCase(membersRepository: makeRepository()),
            createProfilePresignedUseCase: CreateCameraUseCase(cameraRepository: makeCameraRepository()),
            uploadProfileImageUseCase: FetchCameraUploadImageUseCase(cameraRepository: makeCameraRepository()),
            updateProfileUseCase: UpdateMembersProfileUseCase(membersRepository: makeRepository()),
            provider: globalState,
            memberId: memberId,
            isUser: isUser
        )
    }
}
