//
//  LinkShareDIContainer.swift
//  App
//
//  Created by 김건우 on 12/16/23.
//

import UIKit

import Core
import Data

public final class AddFamiliyDIContainer: BaseDIContainer {
    public typealias ViewController = AddFamiliyViewController
    public typealias Repository = AddFamiliyImpl
    public typealias Reactor = AddFamiliyViewReactor
    
    private var globalState: GlobalStateProviderType {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return GlobalStateProvider()
        }
        return appDelegate.globalStateProvider
    }
    
    public func makeViewController() -> AddFamiliyViewController {
        return AddFamiliyViewController(reacter: makeReactor())
    }
    
    public func makeRepository() -> AddFamiliyImpl {
        return AddFamiliyViewRepository()
    }
    
    public func makeReactor() -> AddFamiliyViewReactor {
        return AddFamiliyViewReactor(provider: globalState)
    }
}
