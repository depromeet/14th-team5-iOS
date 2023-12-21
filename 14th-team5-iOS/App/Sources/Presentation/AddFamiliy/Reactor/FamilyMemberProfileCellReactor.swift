//
//  YourFamilProfileCellReactor.swift
//  App
//
//  Created by 김건우 on 12/12/23.
//

import Foundation

import Core
import ReactorKit
import RxDataSources
import RxSwift

final class FamilyMemberProfileCellReactor: Reactor {
    // MARK: - Action
    typealias Action = NoAction
    
    var initialState: FamilyMemeberProfile
    
    init(_ cellModel: FamilyMemeberProfile) {
        self.initialState = cellModel
    }
}
