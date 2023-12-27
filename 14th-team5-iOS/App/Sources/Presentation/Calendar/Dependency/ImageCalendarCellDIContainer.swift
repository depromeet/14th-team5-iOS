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
    private var globalState: GlobalStateProviderType {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return GlobalStateProvider()
        }
        return appDelegate.globalStateProvider
    }
    
    public func makeReactor(
        _ type: ImageCalendarCellReactor.CellType,
        isSelected selection: Bool,
        dayResponse: CalendarResponse
    ) -> ImageCalendarCellReactor {
        return ImageCalendarCellReactor(
            type,
            isSelected: selection,
            dayResponse: dayResponse,
            provider: globalState
        )
    }
}
