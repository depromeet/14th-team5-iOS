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

final public class FamilyMemberCellReactor: Reactor {
    
    // MARK: - Action
    
    public typealias Action = NoAction
    
    
    // MARK: - State
    
    public struct State {
        var member: FamilyMemberProfileEntity
        let isMe: Bool
        let kind: FamilyMemberCellKind
    }
    
    
    // MARK: - Properties
    
    public var initialState: State
    
    
    // MARK: - Intializer
    
    public init(
        of kind: FamilyMemberCellKind,
        member: FamilyMemberProfileEntity,
        isMe: Bool
    ) {
        self.initialState = State(
            member: member,
            isMe: isMe,
            kind: kind
        )
    }
}
