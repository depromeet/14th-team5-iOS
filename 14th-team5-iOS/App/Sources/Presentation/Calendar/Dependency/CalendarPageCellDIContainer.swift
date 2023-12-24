//
//  CalendarPageCellDIContainer.swift
//  App
//
//  Created by 김건우 on 12/16/23.
//

import UIKit

import Core
import Data

public final class CalendarPageCellDIContainer {
    private var globalState: GlobalStateProviderType {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return GlobalStateProvider()
        }
        return appDelegate.globalStateProvider
    }
    
    public func makeReactor(yearMonth: String) -> CalendarPageCellReactor {
        return CalendarPageCellReactor(yearMonth: yearMonth, provider: globalState)
    }
}
