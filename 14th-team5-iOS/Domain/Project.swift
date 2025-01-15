//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by Kim dohyun on 2023/11/14.
//

@preconcurrency import ProjectDescription
import ProjectDescriptionHelpers


private let targets: [Target] = [
    .makeModular(
        layer: .Domain,
        factory: .init(
            products: .library(.static),
            dependencies: ModuleLayer.Domain.dependencies
        )
    )
]

private let domain = Project.makeApp(name: ModuleLayer.Domain.rawValue, target: targets)
