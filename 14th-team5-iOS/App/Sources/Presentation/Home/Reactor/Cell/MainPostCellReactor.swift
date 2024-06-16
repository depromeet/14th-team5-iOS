//
//  SurvivalCellReactor.swift
//  App
//
//  Created by 마경미 on 21.04.24.
//

import Foundation

import Core
import Domain

import ReactorKit
import RxDataSources

final class MainPostCellReactor: Reactor {
    enum Action {
        case setCell
    }
    
    enum Mutation {
        case injectDisplayContent([DisplayEditItemModel])
    }
    
    struct State {
        let postListData: PostEntity
        var fetchedDisplayContent: [DisplayEditSectionModel] = [.displayKeyword([])]
    }
    
    let initialState: State
    
    init(initialState: State) {
        self.initialState = initialState
    }
}

extension MainPostCellReactor {
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .setCell:
            guard let content = currentState.postListData.content else {
                return .empty()
            }
            var sectionItem: [DisplayEditItemModel] = []
            content.forEach {
                sectionItem.append(
                    .fetchDisplayItem(DisplayEditCellReactor(title: String($0), radius: 6, font: .caption))
                )
            }
            
            return Observable<Mutation>.just(.injectDisplayContent(sectionItem))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
            case let .injectDisplayContent(section):
                newState.fetchedDisplayContent = [.displayKeyword(section)]
        }
        
        return newState
    }
}
