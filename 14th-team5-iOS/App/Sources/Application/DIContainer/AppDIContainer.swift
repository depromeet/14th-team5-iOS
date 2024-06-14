//
//  DIContainer.swift
//  App
//
//  Created by 김건우 on 6/4/24.
//

import Core
import Data
import Foundation

final class AppDIContainer: BaseContainer {
    
    // MARK: - Register
    func registerDependencies() {
        
        // ServiceProvider 등록
        container.register(type: GlobalStateProviderProtocol.self) { _ in
            return GlobalStateProvider()
        }
        
    }
    
}
