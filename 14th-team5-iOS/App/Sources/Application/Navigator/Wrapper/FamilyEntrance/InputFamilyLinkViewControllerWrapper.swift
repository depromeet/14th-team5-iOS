//
//  InputLinkViewControllerWrapper.swift
//  App
//
//  Created by 김건우 on 6/26/24.
//

import Core
import Foundation
import MacrosInterface

@Wrapper<InputFamilyLinkReactor, InputFamilyLinkViewController>
final class InputFamilyLinkViewControllerWrapper {
    
    // MARK: - Make
    
    func makeReactor() -> InputFamilyLinkReactor {
        InputFamilyLinkReactor()
    }
    
}
