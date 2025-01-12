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
    private var globalState: ServiceProviderProtocol {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return ServiceProvider()
        }
        return appDelegate.globalStateProvider
    }
    
    // MARK: - Make
    public func makeView() -> SharingContainerView {
        return SharingContainerView(reactor: makeReactor())
    }
    
    public func makeReactor() -> SharingContainerReactor {
        return SharingContainerReactor()
    }
}
