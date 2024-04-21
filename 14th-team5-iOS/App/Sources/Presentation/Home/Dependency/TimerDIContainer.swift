//
//  TimerDIContainer.swift
//  App
//
//  Created by 마경미 on 30.01.24.
//

import UIKit

import Core

final class TimerDIContainer {
    func makeView() -> TimerView {
        return TimerView(reactor: makeReactor())
    }
    
    func makeReactor() -> TimerReactor {
        return TimerReactor()
    }
}
