//
//  LinkShareDIContainer.swift
//  App
//
//  Created by 김건우 on 12/16/23.
//

import UIKit

import Core
import Data

public final class AddFamilyDIContainer: BaseDIContainer {
    public typealias ViewController = AddFamilyViewController
    public typealias Repository = AddFamilyImpl
    public typealias Reactor = AddFamilyViewReactor
    
    private var globalState: GlobalStateProviderType {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return GlobalStateProvider()
        }
        return appDelegate.globalStateProvider
    }
    
    public func makeViewController() -> AddFamilyViewController {
        return AddFamilyViewController(reacter: makeReactor())
    }
    
    public func makeRepository() -> AddFamilyImpl {
        return AddFamilyRepository()
    }
    
    public func makeReactor() -> AddFamilyViewReactor {
        return AddFamilyViewReactor(provider: globalState)
    }
}
