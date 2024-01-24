//
//  InputFamilyLinkReactor.swift
//  App
//
//  Created by 마경미 on 13.01.24.
//

import Foundation

import Domain
import Core

import ReactorKit

public final class InputFamilyLinkReactor: Reactor {
    // MARK: - Action
    public enum Action {
        case inputLink(String)
        case tapJoinFamily
        case tapPopButton
    }
    
    // MARK: - Mutate
    public enum Mutation {
        case setLinkString(String)
        case setShowHome(Bool)
        case setToastMessage(String)
        case setPoped(Bool)
    }
    
    // MARK: - State
    public struct State {
        var linkString: String = ""
        var isShowHome: Bool = false
        @Pulse var showToastMessage: String = ""
        var isPoped: Bool = false
    }
    
    // MARK: - Properties
    public let initialState: State
    private let familyUseCase: JoinFamilyUseCaseProtocol
    
    init(initialState: State, familyUseCase: JoinFamilyUseCaseProtocol) {
        self.initialState = initialState
        self.familyUseCase = familyUseCase
    }
}

extension InputFamilyLinkReactor {
    
    // MARK: - Mutate
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .inputLink(link):
            return Observable.just(Mutation.setLinkString(link))
        case .tapJoinFamily:
            
            MPEvent.Account.invitedGroupFinished.track(with: nil)
            
            let code = currentState.linkString
            let request = JoinFamilyRequest(inviteCode: String(code))
            
            return familyUseCase.execute(body: request)
                .asObservable()
                .flatMap { joinFamilyData in
                    guard let joinFamilyData else {
                        return Observable.just(Mutation.setToastMessage("존재하지 않는 초대코드에요."))
                    }
                    App.Repository.member.familyId.accept(joinFamilyData.familyId)
                    return Observable.just(Mutation.setShowHome(true))
                }
        case .tapPopButton:
            return Observable.just(Mutation.setPoped(true))
        }
    }
    
    // MARK: - Reduce
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .setLinkString(link):
            newState.linkString = link
        case let .setShowHome(isShow):
            newState.isShowHome = isShow
        case let .setToastMessage(message):
            newState.showToastMessage = message
        case let .setPoped(isPop):
            newState.isPoped = isPop
        }
        return newState
    }
}
