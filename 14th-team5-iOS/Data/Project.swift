//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by Kim dohyun on 2023/11/14.
//

import ProjectDescription
import ProjectDescriptionHelpers



private let targets: [Target] = [
    .makeModular(
        layer: .Data,
        factory: .init(
            products: .library(.static),
            dependencies: ModuleLayer.Data.dependencies
        )
    )
]

private let data = Project.makeFrameWork(name: ModuleLayer.Data.rawValue, target: targets)
