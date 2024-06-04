//
//  BaseWrapper.swift
//  App
//
//  Created by 김건우 on 6/4/24.
//

import Core
import UIKit

import ReactorKit

// NOTE: - Bibbi-Package에 이미 포함되어 있어 삭제할 코드

protocol BaseWrapper {
    
    associatedtype R: Reactor
    associatedtype V: ReactorKit.View
    
    func makeReactor() -> R
}
