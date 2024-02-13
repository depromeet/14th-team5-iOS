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
    public typealias Repository = ProfileViewInterface
    public typealias Reactor = ProfileViewReactor
    public typealias UseCase = ProfileViewUsecaseProtocol
    
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
    
    public func makeUseCase() -> UseCase {
        return ProfileViewUseCase(profileViewRepository: makeRepository())
    }
    
    public func makeRepository() -> Repository {
        return ProfileViewRepository()
    }
    
    public func makeReactor() -> ProfileViewReactor {
        return ProfileViewReactor(profileUseCase: makeUseCase(), provider: globalState, memberId: memberId, isUser: isUser)
    }
    
    
}
