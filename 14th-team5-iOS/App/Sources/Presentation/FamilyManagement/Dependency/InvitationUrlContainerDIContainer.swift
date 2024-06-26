//
//  InvitationUrlContainerDIContainer.swift
//  App
//
//  Created by 김건우 on 1/17/24.
//

import Core
import Foundation
import UIKit

@available(*, deprecated)
public final class InvitationUrlContainerDIContainer {
    // MARK: - Properties
    private var globalState: GlobalStateProviderProtocol {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return GlobalStateProvider()
        }
        return appDelegate.globalStateProvider
    }
    
    // MARK: - Make
    public func makeView() -> InvitationUrlContainerView {
        return InvitationUrlContainerView(reactor: makeReactor())
    }
    
    public func makeReactor() -> InvitationUrlContainerViewReactor {
        return InvitationUrlContainerViewReactor(provider: globalState)
    }
}
