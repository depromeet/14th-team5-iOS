//
//  YourFamilProfileCellReactor.swift
//  App
//
//  Created by 김건우 on 12/12/23.
//

import Foundation

import Core
import Domain
import ReactorKit
import RxDataSources
import RxSwift

final class FamilyMemberProfileCellReactor: Reactor {
    // MARK: - Action
    typealias Action = NoAction
    
    struct State {
        var memeberId: String
        var name: String
        var imageUrl: String?
    }
    
    var initialState: State
    
    init(_ memberResponse: FamilyMemberProfileResponse) {
        self.initialState = State(
            memeberId: memberResponse.memberId,
            name: memberResponse.name,
            imageUrl: memberResponse.imageUrl
        )
    }
}
