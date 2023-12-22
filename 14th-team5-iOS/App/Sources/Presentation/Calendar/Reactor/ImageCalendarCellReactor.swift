//
//  ImageCalendarCellReactor.swift
//  App
//
//  Created by 김건우 on 12/9/23.
//

import Foundation

import ReactorKit
import RxSwift

final class ImageCalendarCellReactor: Reactor {
    // MARK: - Action
    typealias Action = NoAction
    
    struct State {
        var date: Date
        var representativePostId: String?
        var representativeThumbnailUrl: String?
        var allFamilyMemebersUploaded: Bool = false
        var isSelected: Bool = false
    }
    
    // MARK: - Properties
    var initialState: State
    
    var date: Date
    
    // MARK: - Intializer
    init(_ date: Date, perDayInfo dayInfo: PerDayInfo) {
        self.initialState = State(
            date: dayInfo.date,
            representativePostId: dayInfo.representativePostId,
            representativeThumbnailUrl: dayInfo.representativeThumbnailUrl,
            allFamilyMemebersUploaded: dayInfo.allFamilyMemebersUploaded,
            isSelected: dayInfo.isSelected
        )
        
        self.date = date
    }
}
