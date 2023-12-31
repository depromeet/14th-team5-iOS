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

final public class FamilyMemberProfileCellReactor: Reactor {
    // MARK: - Action
    public typealias Action = NoAction
    
    public struct State {
        var memeberId: String
        var name: String
        var imageUrl: String?
    }
    
    public var initialState: State
    
    public init(_ memberResponse: FamilyMemberProfileResponse) {
        self.initialState = State(
            memeberId: memberResponse.memberId,
            name: memberResponse.name,
            imageUrl: memberResponse.imageUrl
        )
    }
}
