//
//  BaseWrapper.swift
//  Core
//
//  Created by 김건우 on 6/14/24.
//

import UIKit

import ReactorKit

public protocol BaseWrapper {
    
    associatedtype R: Reactor
    associatedtype V: ReactorKit.View
    
    func makeReactor() -> R
    func makeViewController() -> V
    
    var reactor: R { get }
    var viewController: V { get }
    
}
