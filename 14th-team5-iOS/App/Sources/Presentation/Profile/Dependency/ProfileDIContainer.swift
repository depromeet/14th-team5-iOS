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
    public typealias UseCase = MembersUseCaseProtocol
    
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
        return MembersUseCase(membersRepository: makeRepository())
    }
    
    public func makeRepository() -> Repository {
        return MembersRepository()
    }
    
    public func makeReactor() -> ProfileViewReactor {
        return ProfileViewReactor(membersUseCase: makeUseCase(), provider: globalState, memberId: memberId, isUser: isUser)
    }
    
    
}
