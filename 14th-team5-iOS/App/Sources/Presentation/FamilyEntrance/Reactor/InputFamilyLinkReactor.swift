//
//  InputFamilyLinkReactor.swift
//  App
//
//  Created by 마경미 on 13.01.24.
//

import Foundation

import Domain
import Core
import Util

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
        case setToastMessage(String)
    }
    
    // MARK: - State
    public struct State {
        var linkString: String = ""
        @Pulse var showToastMessage: String = ""
    }
    
    // MARK: - Properties
    public let initialState: State = State()
    @Injected var familyUseCase: FamilyUseCaseProtocol
    @Injected var joinFamilyUseCase: JoinFamilyUseCaseProtocol
    @Navigator var navigator: InputFamilyLinkNavigatorProtocol
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
                // Repository에서 이미 UserDefaults와 App.Repository에 저장하고 있음
                App.Repository.member.familyId.accept(joinFamilyData.familyId)
                App.Repository.member.familyCreatedAt.accept(joinFamilyData.createdAt)
                
                self.navigator.toHome()
                return .empty()
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
                return joinFamilyUseCase.execute(body: body)
                    .asObservable()
                    .flatMap { joinFamilyData in
                        guard let joinFamilyData = joinFamilyData else {
                            return Observable.just(Mutation.setToastMessage("존재하지 않는 초대코드에요."))
                        }
                        return commonLogic(joinFamilyData)
                    }
            }
        case .tapPopButton:
            navigator.pop()
            return .empty()
        }
    }
    
    // MARK: - Reduce
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .setLinkString(link):
            newState.linkString = link
        case let .setToastMessage(message):
            newState.showToastMessage = message
        }
        return newState
    }
}
