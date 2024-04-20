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
    public enum CellType {
        case family
        case emoji
    }
    
    // MARK: - Action
    public typealias Action = NoAction
    
    // MARK: - State
    public struct State {
        let cellType: CellType
        var memberId: String
        var name: String
        var imageUrl: String?
        var dayOfBirth: Date
        var isMe: Bool
    }
    
    // MARK: - Properties
    public var initialState: State
    
    // MARK: - Intializer
    public init(_ memberResponse: ProfileData, isMe: Bool, cellType: CellType) {
        self.initialState = State(
            cellType: cellType,
            memberId: memberResponse.memberId,
            name: memberResponse.name,
            imageUrl: memberResponse.profileImageURL,
            dayOfBirth: memberResponse.dayOfBirth ?? Date(),
            isMe: isMe
        )
    }
}
