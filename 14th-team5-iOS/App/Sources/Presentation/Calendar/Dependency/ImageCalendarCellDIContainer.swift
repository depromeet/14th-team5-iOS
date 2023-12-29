//
//  ImageCalendarCellDIContainer.swift
//  App
//
//  Created by 김건우 on 12/26/23.
//

import UIKit

import Core
import Data
import Domain

public final class ImageCalendarCellDIContainer {
    public typealias Reactor = ImageCalendarCellReactor
    
    public let type: ImageCalendarCellReactor.CalendarType
    public let dayResponse: CalendarResponse
    public let selection: Bool
    
    private var globalState: GlobalStateProviderProtocol {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return GlobalStateProvider()
        }
        return appDelegate.globalStateProvider
    }
    
    public init(
        _ type: ImageCalendarCellReactor.CalendarType,
        dayResponse: CalendarResponse,
        isSelected selection: Bool
    ) {
        self.type = type
        self.dayResponse = dayResponse
        self.selection = selection
    }
    
    public func makeReactor() -> Reactor {
        return ImageCalendarCellReactor(
            type,
            dayResponse: dayResponse,
            isSelected: selection,
            provider: globalState
        )
    }
}
