//
//  StudioReactor.swift
//  Bibbi
//
//  Created by 마경미 on 22.09.25.
//

import Foundation

import ReactorKit
import Core
import Domain

final class StudioPageReactor: Reactor {
    
    enum Action {
        case fetchThemeList
        case didSelectTheme(StudioThemeEntity)
    }

    enum Mutation {
        case updateStudioThemeDataSource([StudioThemeEntity])
    }
    
    struct State {
        @Pulse var studioSection: StudioSection = StudioSection(items: [])
        var isError: Bool = false
    }
    
    let initialState: State = State()
    
    @Injected var provider: ServiceProviderProtocol
    @Injected var studioPostUseCase: FetchStudioThemeListUseCaseProtocol
    @Navigator var navigator: StudioPageNavigatorProtocol
}

extension StudioPageReactor {
//    public func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
//        let studioMudation = provider.studioGlobalState.event
//            .flatMap { event -> Observable<Mutation> in
//                switch event {
//                case let .receiveMemoriesCount(count):
//                    return .just(.setMemoriesCount(count))
//                }
//            }
//        return Observable<Mutation>.merge(mutation, studioMudation)
//    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .fetchThemeList:
            return studioPostUseCase.execute()
                .flatMap { list -> Observable<Mutation> in
                    guard let list else {
                        return Observable.from([])
                    }
                    return Observable.from([
                        .updateStudioThemeDataSource(list)
                    ])
                }
                .catch { _ in .empty() }
        case let .didSelectTheme(theme):
            navigator.toStudio(theme: theme)
            return .empty()
        }

    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case let .updateStudioThemeDataSource(list):
            newState.studioSection = StudioSection(items: list)
        }
        
        return newState
    }
}
