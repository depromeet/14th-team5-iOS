//
//  ProfileDIContainer.swift
//  App
//
//  Created by Kim dohyun on 12/17/23.
//

import Foundation

import Core
import Data
import Domain


public final class ProfileDIContainer: BaseDIContainer {
    public typealias ViewContrller = ProfileViewController
    public typealias Repository = ProfileViewInterface
    public typealias Reactor = ProfileViewReactor
    public typealias UseCase = ProfileViewUsecaseProtocol
    
    private let memberId: String
    private let isUser: Bool
    
    public init(memberId: String = "") {
        self.memberId = memberId
        print("my memberID: \(memberId) or \(FamilyUserDefaults.checkIsMyMemberId(memberId: memberId)) \(UserDefaults.standard.memberId)")
        self.isUser = FamilyUserDefaults.checkIsMyMemberId(memberId: memberId)
    }
    
    public func makeViewController() -> ProfileViewController {
        return ProfileViewController(reactor: makeReactor())
    }
    
    public func makeUseCase() -> UseCase {
        return ProfileViewUseCase(profileViewRepository: makeRepository())
    }
    
    public func makeRepository() -> Repository {
        return ProfileViewRepository()
    }
    
    public func makeReactor() -> ProfileViewReactor {
        return ProfileViewReactor(profileUseCase: makeUseCase(), memberId: memberId, isUser: isUser)
    }
    
    
}
