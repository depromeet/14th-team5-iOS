//
//  Project.swift
//  Manifests
//
//  Created by 김도현 on 2/23/26.
//

@preconcurrency import ProjectDescription
import ProjectDescriptionHelpers


private let targets: [Target] = [
    .makeModular(
        layer: .ThirdPartyLibs,
        factory: .init(
            products: .library(.static),
            dependencies: ModuleLayer.ThirdPartyLibs.dependencies
        )
    )
]


private let thirdPartyLibs = Project.makeApp(name: ModuleLayer.ThirdPartyLibs.rawValue, target: targets)
