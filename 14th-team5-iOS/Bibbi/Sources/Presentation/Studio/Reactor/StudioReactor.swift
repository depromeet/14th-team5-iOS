//
//  StudioReactor.swift
//  Bibbi
//
//  Created by 마경미 on 26.09.25.
//

import Foundation

import ReactorKit

import Core
import Domain

final class StudioReactor: Reactor {
    enum Action {
        case checkTermAgreement
        case fetchStudioCount
        case didTapUpload
    }
    
    enum Mutation {
        case setTermsAgreement(Bool)
        case setStudioCount(StudioCountEntity)
    }
    
    struct State {
        @Pulse var studioCount: StudioCountEntity?
        @Pulse var isEnabledUpload: Bool = true
        
        var isAITermsAgreed: Bool = true
    }
    
    init() {
        action.onNext(.checkTermAgreement)
    }
    
    let initialState: State = State()
    
    @Navigator var navigator: StudioNavigatorProtocol
    @Injected var fetchStudioCountUsecase: FetchStudioCountUseCaseProtocol
    @Injected var fetchIsAITermsAgreedUsecase: FetchIsAITermsAgreedUseCaseProtocol
    @Injected var saveIsAITermsAgreedUsecase: SaveIsAITermsAgreedUseCaseProtocol
}

extension StudioReactor {
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .fetchStudioCount:
            return fetchStudioCountUsecase.execute()
                .flatMap { Observable.just(.setStudioCount($0)) }
        case .didTapUpload:
            if currentState.isEnabledUpload {
                // 카메라 이동
                return .empty()
            } else {
                navigator.showErrorToast(message: "업로드 횟수를 모두 사용했어요")
                return .empty()
            }
        case .checkTermAgreement:
            return fetchIsAITermsAgreedUsecase.execute()
                .flatMap { [weak self] isAgreed -> Observable<Mutation> in
                    if isAgreed {
                        return  .just(.setTermsAgreement(true))
                    } else {
                        self?.navigator.showAITermAlert(saveAction: { [weak self] _ in
                            self?.saveIsAITermsAgreedUsecase.execute(true)
                        })
                        return .empty()
                    }
                }
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case let .setStudioCount(counts):
            newState.studioCount = counts
            newState.isEnabledUpload = counts.availableCount > 0
        case let .setTermsAgreement(isAgreed):
            newState.isAITermsAgreed = isAgreed
        }
        
        return newState
    }
}
