//
//  Studio.swift
//  Bibbi
//
//  Created by 마경미 on 25.09.25.
//

import Core
import Foundation
import MacrosInterface

@Wrapper<StudioReactor, StudioViewController>
final class StudioViewControllerWrapper {
    
    init() { }
    
    
    func makeReactor() -> R {
        return StudioReactor()
    }
    
}
