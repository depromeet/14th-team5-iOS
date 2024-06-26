//
//  InputLinkViewControllerWrapper.swift
//  App
//
//  Created by 김건우 on 6/26/24.
//

import Core
import Foundation

final class InputFamilyLinkViewControllerWrapper: BaseWrapper {
    
    // MARK: - Typealias
    
    typealias R = InputFamilyLinkReactor
    typealias V = InputFamilyLinkViewController
    
    // MARK: - Properties
    
    var reactor: InputFamilyLinkReactor {
        InputFamilyLinkReactor()
    }
    
    var viewController: InputFamilyLinkViewController {
        InputFamilyLinkViewController(reactor: makeReactor())
    }
    
    // MARK: - Make
    
    func makeReactor() -> InputFamilyLinkReactor {
        InputFamilyLinkReactor()
    }
    
    func makeViewController() -> InputFamilyLinkViewController {
        InputFamilyLinkViewController(reactor: makeReactor())
    }
    
}
