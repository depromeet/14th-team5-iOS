//
//  JoinedFamilyViewControllerWrapper.swift
//  App
//
//  Created by 김건우 on 6/26/24.
//

import Core
import Foundation
import MacrosInterface

@Wrapper<FamilyEntranceReactor, FamilyEntranceViewController>
final class FamilyEntranceControllerWrapper {
    
    // MARK: - Make
    
    func makeReactor() -> FamilyEntranceReactor {
        FamilyEntranceReactor()
    }
    
}
