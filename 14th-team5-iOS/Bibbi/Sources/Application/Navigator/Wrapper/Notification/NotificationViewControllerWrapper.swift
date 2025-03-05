//
//  NotificationViewControllerWrapper.swift
//  Bibbi
//
//  Created by 마경미 on 30.01.25.
//

import Core
import Foundation
import MacrosInterface

@Wrapper<NotificationReactor, NotificationViewController>
final class NotificationViewControllerWrapper {
    
    // MARK: - Make
    
    func makeReactor() -> NotificationReactor {
        NotificationReactor()
    }
    
}
