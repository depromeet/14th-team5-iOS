//
//  CalendarDIConatainer.swift
//  App
//
//  Created by 김건우 on 12/16/23.
//

import UIKit

import Core
import Data

public final class CalendarDIConatainer: BaseDIContainer {
    public typealias ViewController = CalendarViewController
    public typealias Repository = CalendarImpl
    public typealias Reactor = CalendarViewReactor
    
    private var globalState: GlobalStateProviderType {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return GlobalStateProvider()
        }
        return appDelegate.globalStateProvider
    }
    
    public func makeViewController() -> CalendarViewController {
        return CalendarViewController(reacter: makeReactor())
    }
    
    public func makeRepository() -> CalendarImpl {
        return CalendarViewRepository()
    }
    
    public func makeReactor() -> CalendarViewReactor {
        return CalendarViewReactor(provider: globalState)
    }
}
