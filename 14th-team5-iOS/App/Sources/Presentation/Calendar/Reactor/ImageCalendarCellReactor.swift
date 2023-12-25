//
//  ImageCalendarCellReactor.swift
//  App
//
//  Created by 김건우 on 12/9/23.
//

import Foundation

import Domain
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
    }
    
    // MARK: - Properties
    var initialState: State
    
    // MARK: - Intializer
    init(dayResponse: CalendarResponse) {
        self.initialState = State(
            date: dayResponse.date,
            representativePostId: dayResponse.representativePostId,
            representativeThumbnailUrl: dayResponse.representativeThumbnailUrl,
            allFamilyMemebersUploaded: dayResponse.allFamilyMemebersUploaded
        )
    }
}
