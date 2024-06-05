//
//  DIContainer.swift
//  App
//
//  Created by 김건우 on 6/4/24.
//

import Core
import Data
import Foundation

class DIContainer {
    
    // MARK: - Properties
    var container: Container = {
        Container.standard
    }()
    
    // MARK: - API Workers
    enum API {
        static let calendar = CalendarAPIWorker()
    }
    
    // MARK: - Persistent Storage
    enum Storage {
        enum Keychain {
            static let token = TokenKeychain()
        }
        
        enum UserDefaults {
            static let member = MemberUserDefaults()
        }
        
        enum InMemory {
            // NOTE: - 사실 CleanArchitecture 잘 준수만 하면 인-메모리 DB는 사용할 일이 딱히 없어 보여요.
            // 곧바로 Repository에서 Keychain이나 UserDefaults에 접근하면 되니까요.
        }
    }
    
    // MARK: - Register
    func registerDependencies() {
        
        // ServiceProvider 등록
        container.register(type: GlobalStateProviderProtocol.self) { _ in
            return GlobalStateProvider()
        }
        
        // NOTE: - 앞으로 @Injected var provider: ServiceProviderProtocol처럼 작성해야 합니다.
        // 직접 Service를 주입하면 항목(Item) 전달이 제대로 되지 않아요.
        
    }
    
}
