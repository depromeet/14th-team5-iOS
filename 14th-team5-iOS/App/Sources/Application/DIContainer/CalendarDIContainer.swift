//
//  CommentDIContainer.swift
//  App
//
//  Created by 김건우 on 6/3/24.
//

import Core
import Data
import Domain


// NOTE: 
// - APIWorker를 나눈대로 DIContainer도 분리합니다.
// - CalendarDIContainer는 유지보수 용이를 위한 컨테어너의 역할만 수행합니다.

final class CalendarDIContainer: DIContainer {
    
    // MARK: - Make UseCase
    
    func makeUseCase() -> CalendarUseCaseProtocol {
        return CalendarUseCase(
            calendarRepository: makeCalendarRepository()
        )
    }
    
    // NOTE: - 추후 UseCase 리팩토링하면 make() 메서드가 더 많아지겠죠?
    
    
    // MARK: - Make Repository
    
    func makeCalendarRepository() -> CalendarRepositoryProtocol {
        return CalendarRepository(
        //  calendarApiWorker: ...
            keychain: Storage.Keychain.token,
            userDefaults: Storage.UserDefaults.member
        )
        
        // NOTE: - 궁극적인 목표는 DIContainer 안에서 APIWorker, Storage 등 모든 의존성을 주입하게 만들어 유지보수를 용이하게 하는 겁니다.
    }
    
    
    // MARK: - Register
    
    override func registerDependencies() {
        super.registerDependencies()
        
        // NOTE: - 등록하면 @Injected로 편하게 의존성을 받아올 수 있습니다.
        // - (MonthlyCalendarViewReactor.swift 참조)
        container.register(
            type: CalendarUseCaseProtocol.self
        ) { [unowned self] _ in
            self.makeUseCase()
        }
    }
    
    
    
}



