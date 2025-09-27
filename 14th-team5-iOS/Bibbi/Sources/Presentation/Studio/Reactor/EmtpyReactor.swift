////
////  EmtpyReactor.swift
////  Bibbi
////
////  Created by 마경미 on 27.09.25.
////
//
//import Foundation
//
//import ReactorKit
//
//import Core
//import Domain
//
//final class StudioTermReactor: Reactor {
//    enum Action {
//    }
//    
//    enum Mutation {
//    }
//    
//    struct State {
//    }
//    
//    init() {
//        action.onNext(.checkTermAgreement)
//    }
//    
//    let initialState: State = State()
//    
//    @Navigator var navigator: StudioNavigatorProtocol
//    @Injected var fetchStudioCountUsecase: FetchStudioCountUseCaseProtocol
//    @Injected var fetchIsAITermsAgreedUsecase: FetchIsAITermsAgreedUseCaseProtocol
//    @Injected var saveIsAITermsAgreedUsecase: SaveIsAITermsAgreedUseCaseProtocol
//}
//
//extension StudioReactor {
//    func mutate(action: Action) -> Observable<Mutation> {
//        switch action {
//        case .fetchStudioCount:
//            return fetchStudioCountUsecase.execute()
//                .flatMap { Observable.just(.setStudioCount($0)) }
//        case .didTapUpload:
//            if currentState.isEnabledUpload {
//                // 카메라 이동
//                return .empty()
//            } else {
//                navigator.showErrorToast(message: "업로드 횟수를 모두 사용했어요")
//                return .empty()
//            }
//        case .checkTermAgreement:
//            return fetchIsAITermsAgreedUsecase.execute()
//                .flatMap {
//                    if $0 {
//                        return Observable.just(.setTermsAgreement($0))
//                    } else {
//                        return navigator.
//                    }
//                }
//        }
//    }
//
//    func reduce(state: State, mutation: Mutation) -> State {
//        var newState = state
//        
//        switch mutation {
//        case let .setStudioCount(counts):
//            newState.studioCount = counts
//            newState.isEnabledUpload = counts.availableCount > 0
//        case let .setTermsAgreement(isAgreed):
//            newState.isAITermsAgreed = isAgreed
//        }
//        
//        return newState
//    }
//}
