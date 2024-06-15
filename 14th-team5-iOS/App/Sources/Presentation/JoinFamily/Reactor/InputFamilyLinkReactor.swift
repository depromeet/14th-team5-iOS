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
    private let familyUseCase: FamilyUseCaseProtocol
    
    init(initialState: State, familyUseCase: FamilyUseCaseProtocol) {
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
            let body = JoinFamilyRequest(inviteCode: String(code))
            
            let commonLogic: (JoinFamilyEntity) -> Observable<InputFamilyLinkReactor.Mutation> = { joinFamilyData in
//                App.Repository.member.familyId.accept(joinFamilyData.familyId)
//                App.Repository.member.familyCreatedAt.accept(joinFamilyData.createdAt)
                return Observable.just(Mutation.setShowHome(true))
            }

            if App.Repository.member.familyId.value != nil {
                return familyUseCase.executeResignFamily()
                    .asObservable()
                    .withUnretained(self)
                    .flatMap { owner, useCase -> Observable<InputFamilyLinkReactor.Mutation> in
                        return owner.familyUseCase.executeJoinFamily(body: body)
                            .asObservable()
                            .flatMap { joinFamilyData in
                                guard let joinFamilyData = joinFamilyData else {
                                    return Observable.just(Mutation.setToastMessage("존재하지 않는 초대코드에요."))
                                }
                                return commonLogic(joinFamilyData)
                            }
                    }
            } else {
                return familyUseCase.executeJoinFamily(body: body)
                    .asObservable()
                    .flatMap { joinFamilyData in
                        guard let joinFamilyData = joinFamilyData else {
                            return Observable.just(Mutation.setToastMessage("존재하지 않는 초대코드에요."))
                        }
                        return commonLogic(joinFamilyData)
                    }
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
