//
//  TempCellReactor.swift
//  App
//
//  Created by 마경미 on 28.01.24.
//

import Foundation

import Core
import Domain

import ReactorKit

final class TempCellReactor: Reactor {
    enum Action {
        case toggleSelect
        case setCell
    }
    
    enum Mutation {
        case toggleSelected
        case setCellData
    }
    
    struct State {
        var cellData: EmojiEntity?
    }
    
    let initialState: State = State()
    let items: EmojiEntity
    
    init(items: EmojiEntity) {
        self.items = items
    }
}

extension TempCellReactor {
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .setCell:
            Observable.just(Mutation.setCellData)
        case .toggleSelect:
            Observable.just(Mutation.toggleSelected)
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setCellData:
            newState.cellData = items
        case .toggleSelected:
            guard var cellData = state.cellData else { return newState }

            let isAdd: Bool = !cellData.isSelfSelected

            guard let myId = App.Repository.member.memberID.value else {
                return newState
            }

            if isAdd {
                cellData.count += 1
                cellData.memberIds.append(myId)
            } else {
                cellData.count -= 1
                cellData.memberIds.removeAll { $0 == myId }
            }
            cellData.isSelfSelected = isAdd
            newState.cellData = cellData
        }
        
        return newState
    }
}
