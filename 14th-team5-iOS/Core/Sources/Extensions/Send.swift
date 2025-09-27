//
//  Send.swift
//  Core
//
//  Created by 김도현 on 9/26/25.
//

import Foundation


public struct Send<Mutation>: Sendable {

    let send: @Sendable (Mutation) -> Void

    public init(_ send: @escaping @Sendable (Mutation) -> Void) {
        self.send = send
    }

    public func callAsFunction(_ mutation: Mutation) {
        guard !Task.isCancelled else { return }
        self.send(mutation)
    }
}
