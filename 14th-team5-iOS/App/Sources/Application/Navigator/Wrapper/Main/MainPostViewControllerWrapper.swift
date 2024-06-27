//
//  MainPostViewController.swift
//  App
//
//  Created by 마경미 on 17.06.24.
//

import Foundation

import Core
import Domain

final class MainPostViewControllerWrapper: BaseWrapper {
    typealias R = MainPostViewReactor
    typealias V = MainPostViewController
    
    private let type: PostType
    
    init(type: PostType) {
        self.type = type
    }
    
    func makeViewController() -> V {
        return MainPostViewController(reactor: makeReactor())
    }
    
    func makeReactor() -> R {
        return MainPostViewReactor(initialState: .init(type: type))
    }
    
    var viewController: V {
        makeViewController()
    }
    
    var reactor: R {
        makeReactor()
    }
}
