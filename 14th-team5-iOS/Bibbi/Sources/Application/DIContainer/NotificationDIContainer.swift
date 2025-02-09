//
//  NotificationDIContainer.swift
//  Bibbi
//
//  Created by 마경미 on 31.01.25.
//

import Core
import Data
import Domain

final class NotificationDIContainer: BaseContainer {
    private func makeNotificationRepository() -> NotificationRepositoryPorotocol {
        return NotificationRepository()
    }
    
    private func makeFetchNotificationUseCase() -> FetchNotificationUseCaseProtocol {
        FetchNotificationUseCase(notificationRepository: makeNotificationRepository()
        )
    }
    
    func registerDependencies() {
        container.register(type: FetchNotificationUseCaseProtocol.self) { _ in self.makeFetchNotificationUseCase()
        }
    }
}
