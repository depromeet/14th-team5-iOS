//
//  ProfileFeedPageDIContainer.swift
//  App
//
//  Created by Kim dohyun on 5/16/24.
//

import UIKit

import Core


final class ProfileFeedPageDIContainer {
    typealias ViewController = ProfileFeedPageViewController
    typealias Reactor = ProfileFeedPageViewReactor
    
    private var memberId: String = ""
    
    init(memberId: String) {
        self.memberId = memberId
    }
    
    private var globalState: GlobalStateProviderProtocol {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return GlobalStateProvider()
        }
        return appDelegate.globalStateProvider
    }
    
    func makeViewController() -> ViewController {
        return ProfileFeedPageViewController(reactor: makeReactor(), memberId: memberId)
    }
    
    func makeReactor() -> Reactor {
        return ProfileFeedPageViewReactor(provider: globalState)
    }
    
    
}
