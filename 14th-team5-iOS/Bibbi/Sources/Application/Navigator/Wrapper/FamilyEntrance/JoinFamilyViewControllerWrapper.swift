//
//  JoinFamilyViewControllerWrapper.swift
//  App
//
//  Created by 김건우 on 6/26/24.
//

import Core
import Foundation
import MacrosInterface

@Wrapper<JoinFamilyReactor, JoinFamilyViewController>
final class JoinFamilyViewControllerWrapper {
    
    // MARK: - Make
    
    func makeReactor() -> JoinFamilyReactor {
        JoinFamilyReactor()
    }
    
}
