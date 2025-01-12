//
//  ManagementViewController.swift
//  App
//
//  Created by 김건우 on 6/25/24.
//

import Core
import Foundation
import MacrosInterface

@Wrapper<ManagementReactor, ManagementViewController>
final class ManagementViewControllerWrapper {
    
    // MARK: - Make
    
    func makeReactor() -> ManagementReactor {
        ManagementReactor()
    }
    
}
