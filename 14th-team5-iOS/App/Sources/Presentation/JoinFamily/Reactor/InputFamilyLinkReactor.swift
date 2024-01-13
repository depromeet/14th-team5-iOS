//
//  InputFamilyLinkReactor.swift
//  App
//
//  Created by 마경미 on 13.01.24.
//

import Foundation

import Domain

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
        var showToastMessage: String = ""
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
            
            let urlString = currentState.linkString

            guard let firstIndex = urlString.lastIndex(of: "/") else {
                return Observable.just(Mutation.setToastMessage("링크 형식이 맞지 않습니다."))
            }

            let endIndex = urlString.endIndex
            let afterSlashIndex = urlString.index(after: firstIndex)
            let result = urlString[afterSlashIndex..<endIndex]
            // result 가 invite 코드거든?
            let request = JoinFamilyRequest(inviteCode: String(result))
            
            return familyUseCase.execute(body: request)
                .asObservable()
                .flatMap { joinFamilyData in
                    guard let joinFamilyData else {
                        return Observable.just(Mutation.setToastMessage("가족에 입장할 수 없습니다."))
                    }
                    
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
