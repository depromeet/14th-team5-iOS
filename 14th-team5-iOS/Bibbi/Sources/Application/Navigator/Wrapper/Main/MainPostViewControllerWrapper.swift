//
//  MainPostViewController.swift
//  App
//
//  Created by 마경미 on 17.06.24.
//

import Core
import Domain
import Foundation
import MacrosInterface

@Wrapper<MainPostViewReactor, MainPostViewController>
final class MainPostViewControllerWrapper {
   
    private let type: PostType
    
    init(type: PostType) {
        self.type = type
    }
    
    func makeReactor() -> R {
        return MainPostViewReactor(initialState: .init(type: type))
    }

}
