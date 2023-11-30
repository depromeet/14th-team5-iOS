//
//  Path+Templates.swift
//  ProjectDescriptionHelpers
//
//  Created by Kim dohyun on 11/30/23.
//

import ProjectDescription

extension Path {
    public static func relativeToXCConfig(type: BuildTarget) -> Self {
        return .relativeToRoot("./14th-team5-iOS/XCConfig/\(type.rawValue.lowercased()).xcconfig")
    }
}
