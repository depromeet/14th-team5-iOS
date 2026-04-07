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
        var theme: StudioThemeEntity
    }

    let initialState: State

    init(theme: StudioThemeEntity) {
        self.initialState = State(theme: theme)
        action.onNext(.checkTermAgreement)
    }
    
    @Navigator var navigator: StudioNavigatorProtocol
    @Injected var fetchStudioCountUsecase: FetchStudioCountUseCaseProtocol
    @Injected var fetchIsAITermsAgreedUsecase: FetchIsAITermsAgreedUseCaseProtocol
    @Injected var saveIsAITermsAgreedUsecase: SaveIsAITermsAgreedUseCaseProtocol
    @Injected private var provider: ServiceProviderProtocol
}

extension StudioReactor {
    public func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        let studioMainMutation = provider.aiImageGlobalState.event
            .withUnretained(self)
            .flatMap { owner, event -> Observable<Mutation> in
                switch event {
                case let .imageUploadDidFinish(isSuccess):
                    guard isSuccess else {
                        return .empty()
                    }
                    
                    owner.navigator.showToast()
                    return .empty()
                }
            }
        
        return Observable<Mutation>.merge(mutation, studioMainMutation)
    }
    
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .fetchStudioCount:
            return fetchStudioCountUsecase.execute(aiPostType: currentState.theme.aiPostType)
                .flatMap { [weak self] entity -> Observable<Mutation> in
                    self?.provider.studioGlobalState.updateMemoriesItemCount(entity.postCount)
                    return .just(.setStudioCount(entity))
                }
        case .didTapUpload:
            if currentState.isEnabledUpload {
                navigator.toCamera()
                return .empty()
            } else {
                navigator.showErrorToast(message: "업로드 횟수를 모두 사용했어요")
                return .empty()
            }
        case .checkTermAgreement:
            return fetchIsAITermsAgreedUsecase.execute()
                .flatMap { [weak self] isAgreed -> Observable<Mutation> in
                    if isAgreed {
                        return .just(.setTermsAgreement(true))
                    } else {
                        self?.navigator.showTermsAlert { [weak self] in
                            self?.saveIsAITermsAgreedUsecase.execute(true)
                        }
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
