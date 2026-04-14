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
    // 00:00 ~ 09:59 → 자정 구간 (메인 앱과 동일 기준)
    func isMidNight() -> Bool {
        let hour = Calendar.current.component(.hour, from: Date())
        return hour < 10
    }

    // "yyyy-MM-dd" 형식의 startDate~endDate 기간 내에 오늘이 포함되는지 확인
    static func isInThemePeriod(theme: StudioThemeEntity) -> Bool {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        guard let start = formatter.date(from: theme.startDate),
              let end = formatter.date(from: theme.endDate) else { return false }
        let today = Calendar.current.startOfDay(for: Date())
        return today >= Calendar.current.startOfDay(for: start)
            && today <= Calendar.current.startOfDay(for: end)
    }
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
            if isMidNight() {
                navigator.showErrorToast(message: "자정이 지나 업로드할 수 없어요")
                return .empty()
            }
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
