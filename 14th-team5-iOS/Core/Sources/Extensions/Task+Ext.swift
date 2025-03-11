//
//  Task+Ext.swift
//  Core
//
//  Created by 김도현 on 2/18/25.
//

import Foundation


public extension Task where Failure == Error {
    static func synchronous(priority: TaskPriority? = nil, operation: @escaping @Sendable () async throws -> Success) {
        let semaphore = DispatchSemaphore(value: 0)

        Task(priority: priority) {
            defer { semaphore.signal() }
            return try await operation()
        }

        semaphore.wait()
    }
}
