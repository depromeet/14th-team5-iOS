//
//  YourFamilProfileCellReactor.swift
//  App
//
//  Created by 김건우 on 12/12/23.
//

import Foundation

import Core
import ReactorKit
import RxSwift

// NOTE: - 임시 코드
struct TempProfileCellModel {
    var imageUrl: String
    var name: String
    var isMe: Bool
}

final class YourFamilProfileCellReactor: Reactor {
    // MARK: - Action
    typealias Action = NoAction
    
    // MARK: - Properties
    let initialState: TempProfileCellModel
    
    // MARK: - Intializer
    init(_ cellModel: TempProfileCellModel) {
        self.initialState = cellModel
    }
}
