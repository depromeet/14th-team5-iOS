//
//  TimerDIContainer.swift
//  App
//
//  Created by 마경미 on 30.01.24.
//

import UIKit

import Core

final class TimerDIContainer {
    private var globalState: GlobalStateProviderProtocol {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return GlobalStateProvider()
        }
        return appDelegate.globalStateProvider
    }
    
    func makeReactor(isSelfUploaded: Bool, isAllUploaded: Bool) -> TimerReactor {
        return TimerReactor(provider: globalState, isSelfUploaded: isSelfUploaded, isAllUploaded: isAllUploaded)
    }
}
