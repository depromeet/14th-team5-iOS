//
//  JoinedFamilyDIContainer.swift
//  App
//
//  Created by geonhui Yu on 2/8/24.
//

import UIKit

import Core
import Data
import Domain

@available(*, deprecated, renamed: "JoinedFamilyViewControllerWrapper")
final class JoinedFamilyDIContainer {
    public func makeViewController() -> FamilyEntranceViewController {
        return FamilyEntranceViewController(reactor: makeReactor())
    }
    
    public func makeReactor() -> FamilyEntranceReactor {
        return FamilyEntranceReactor()
    }
}
