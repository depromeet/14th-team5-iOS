//
//  BBAnalyticsLogType.swift
//  Core
//
//  Created by 김도현 on 12/19/24.
//

import Foundation
import Core

public protocol BBAnalyticsLogType {
    var name: String { get }
    var params: [String: Any] { get }
}

public extension BBAnalyticsLogType {
    var name: String {
        Mirror(reflecting: self)
            .children
            .first?
            .label?
            .toSnakeCase() ?? String(describing: self).toSnakeCase()
    }

    var params: [String: Any] {
        var dict: [String: Any] = [:]

        let enumMirror = Mirror(reflecting: self)

        guard let associated = enumMirror.children.first else { return dict }

        for enumParams in Mirror(reflecting: associated.value).children {
            guard let label = enumParams.label?.toSnakeCase() else { continue }
            dict[label] = enumParams.value
        }

        return dict
    }
}
