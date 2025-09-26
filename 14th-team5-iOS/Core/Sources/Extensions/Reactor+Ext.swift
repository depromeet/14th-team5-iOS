//
//  Reactor+Ext.swift
//  Core
//
//  Created by 김도현 on 9/26/25.
//

import Foundation

import ReactorKit

public extension Reactor {
    func run(
        priority: TaskPriority? = nil,
        scheduler: ImmediateSchedulerType = MainScheduler.instance,
        operation: @escaping @MainActor @Sendable (_ send: Send<Mutation>) async -> Void
    ) -> Observable<Mutation> {
        return .create { observer in
            let task = Task(priority: priority) {
                let send = Send<Mutation> { mutation in
                    observer.onNext(mutation)
                }
                await operation(send)
                observer.onCompleted()
            }
            return Disposables.create {
                task.cancel()
            }
        }
        .observe(on: scheduler)
    }
}
