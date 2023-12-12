//
//  ImageCalendarCellReactor.swift
//  App
//
//  Created by 김건우 on 12/9/23.
//

import Foundation

import ReactorKit
import RxSwift

// NOTE: - 임시 코드
struct CellModel {
    var imageUrl: String?
    var isHidden: Bool
}

final class ImageCalendarCellReactor: Reactor {
    // MARK: - Action
    typealias Action = NoAction
    
    // MARK: - Properties
    var initialState: CellModel
    
    // MARK: - Intializer
    init(_ model: CellModel) {
        self.initialState = model
    }
}