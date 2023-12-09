//
//  MainViewReactor.swift
//  App
//
//  Created by 마경미 on 05.12.23.
//

import Foundation
import ReactorKit
import RxDataSources

final class MainViewReactor: Reactor {
    enum Action {
        case cellSelected(IndexPath)
    }
    
    enum Mutation {
        case setSelectedIndexPath(IndexPath?)
    }
    
    struct State {
        var selectedIndexPath: IndexPath? = nil
        var familySections: [SectionModel<String, ProfileData>] = SectionOfFamily.sections
        var feedSections: [SectionModel<String, FeedData>] = SectionOfFeed.sections
    }
    
    let initialState: State = State()
}

extension MainViewReactor {
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .cellSelected(indexPath):
            return Observable.concat([
                Observable.just(Mutation.setSelectedIndexPath(indexPath)),
                Observable.just(Mutation.setSelectedIndexPath(nil))
            ])
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case let .setSelectedIndexPath(indexPath):
            newState.selectedIndexPath = indexPath
        }
        
        return newState
    }
}
