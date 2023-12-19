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
    public typealias Repository = CalendarFeedImpl
    public typealias Reactor = CalendarFeedViewReactor
    
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
    
    public func makeRepository() -> CalendarFeedImpl {
        return CalendarFeedViewRepository()
    }
    
    public func makeReactor() -> CalendarFeedViewReactor {
        let intialState = CalendarFeedViewReactor.State(selectedDate)
        return CalendarFeedViewReactor(intialState, provider: globalState)
    }
}
