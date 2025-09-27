//
//  StudioPageViewControllerWrapper.swift
//  Bibbi
//
//  Created by 마경미 on 26.09.25.
//

import Core
import Domain
import Foundation
import MacrosInterface

@Wrapper<StudioPageReactor, StudioPageViewController>
final class StudioPageViewControllerWrapper {

    init() { }
    
    func makeReactor() -> R {
        return StudioPageReactor()
    }

}

