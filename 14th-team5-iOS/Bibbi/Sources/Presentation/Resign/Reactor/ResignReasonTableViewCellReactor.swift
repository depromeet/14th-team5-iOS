//
//  ResignReasonTableViewCellReactor.swift
//  App
//
//  Created by 김도현 on 11/21/24.
//

import Foundation

import ReactorKit

final class ResignReasonTableViewCellReactor: Reactor {
    public typealias Action = NoAction
    var initialState: State
    
    public struct State {
        var reasonType: ReasonType
    }
    
    init(reasonType: ReasonType) {
        self.initialState = State(reasonType: reasonType)
    }
}
