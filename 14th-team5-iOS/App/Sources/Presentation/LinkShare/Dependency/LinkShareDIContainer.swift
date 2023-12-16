//
//  LinkShareDIContainer.swift
//  App
//
//  Created by 김건우 on 12/16/23.
//

import UIKit

import Core
import Data

public final class LinkShareDIContainer: BaseDIContainer {
    public typealias ViewController = LinkShareViewController
    public typealias Repository = LinkShareImpl
    public typealias Reactor = LinkShareViewReactor
    
    private var globalState: GlobalStateProviderType {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return GlobalStateProvider()
        }
        return appDelegate.globalStateProvider
    }
    
    public func makeViewController() -> LinkShareViewController {
        return LinkShareViewController(reacter: makeReactor())
    }
    
    public func makeRepository() -> LinkShareImpl {
        return LinkShareViewRepository()
    }
    
    public func makeReactor() -> LinkShareViewReactor {
        return LinkShareViewReactor(provider: globalState)
    }
}
