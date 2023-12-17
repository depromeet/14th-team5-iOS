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
        return CalendarFeedViewReactor(provider: globalState)
    }
}
