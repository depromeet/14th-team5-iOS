//
//  BaseWrapperView.swift
//  Core
//
//  Created by 김건우 on 6/20/24.
//

import UIKit

import ReactorKit

public protocol BaseWrapperView {
    
    associatedtype R: Reactor
    associatedtype V: ReactorKit.View
    
    func makeReactor() -> R
    func makeView() -> V
    
    var reactor: R { get }
    var view: V { get }
    
}
