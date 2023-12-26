//
//  CalendarFeedDIContainer.swift
//  App
//
//  Created by 김건우 on 12/16/23.
//

import UIKit

import Core
import Data

public final class CalendarPostDIConatainer: BaseDIContainer {
    public typealias ViewController = CalendarPostViewController
    public typealias Repository = CalendarImpl
    public typealias Reactor = CalendarPostViewReactor
    
    let availableYearMonths: [String]
    let selectedCalendarCell: Date
    
    init(_ yearMonths: [String], selectedCalendarCell: Date) {
        self.availableYearMonths = yearMonths
        self.selectedCalendarCell = selectedCalendarCell
    }
    
    private var globalState: GlobalStateProviderType {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return GlobalStateProvider()
        }
        return appDelegate.globalStateProvider
    }
    
    public func makeViewController() -> CalendarPostViewController {
        return CalendarPostViewController(reacter: makeReactor())
    }
    
    public func makeRepository() -> CalendarImpl {
        return CalendarRepository()
    }
    
    public func makeReactor() -> CalendarPostViewReactor {
        return CalendarPostViewReactor(
            availableYearMonths,
            selectedCalendarCell: selectedCalendarCell,
            provider: globalState
        )
    }
}
