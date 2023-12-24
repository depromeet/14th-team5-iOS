//
//  CalendarFeedDIContainer.swift
//  App
//
//  Created by 김건우 on 12/16/23.
//

import UIKit

import Core
import Data

public final class CalendarFeedDIConatainer: BaseDIContainer {
    public typealias ViewController = CalendarFeedViewController
    public typealias Repository = CalendarImpl
    public typealias Reactor = CalendarPostViewReactor
    
    let selectedDate: Date
    
    init(selectedDate date: Date) {
        self.selectedDate = date
    }
    
    private var globalState: GlobalStateProviderType {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return GlobalStateProvider()
        }
        return appDelegate.globalStateProvider
    }
    
    public func makeViewController() -> CalendarFeedViewController {
        return CalendarFeedViewController(reacter: makeReactor())
    }
    
    public func makeRepository() -> CalendarImpl {
        return CalendarRepository()
    }
    
    public func makeReactor() -> CalendarPostViewReactor {
        let intialState = CalendarPostViewReactor.State(selectedDate)
        return CalendarPostViewReactor(intialState, provider: globalState)
    }
}
