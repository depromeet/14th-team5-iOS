//
//  StudioReactor.swift
//  Bibbi
//
//  Created by 마경미 on 22.09.25.
//

import Foundation

import ReactorKit
import Core

final class StudioPageReactor: Reactor {
    @Injected var provider: ServiceProviderProtocol
    
    enum Action {
        case bannerClicked
    }
    
    enum Mutation {
        case setMemoriesCount(Int)
        
    }
    
    struct State {
        var memoriesCount: Int = 0
    }
    
    let initialState: State = State()
    
    @Navigator var navigator: StudioPageNavigatorProtocol
}

extension StudioPageReactor {
    public func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        let studioMudation = provider.studioGlobalState.event
            .flatMap { event -> Observable<Mutation> in
                switch event {
                case let .receiveMemoriesCount(count):
                    return .just(.setMemoriesCount(count))
                }
            }
        return Observable<Mutation>.merge(mutation, studioMudation)
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .bannerClicked:
            navigator.toStudio()
            return Observable.empty()
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case let .setMemoriesCount(count):
            newState.memoriesCount = count
        }
        
        return newState
    }
}
